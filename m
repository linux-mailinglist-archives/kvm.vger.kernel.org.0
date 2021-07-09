Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E1C53C1DBA
	for <lists+kvm@lfdr.de>; Fri,  9 Jul 2021 05:09:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230463AbhGIDMY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jul 2021 23:12:24 -0400
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:41169 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230347AbhGIDMX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 8 Jul 2021 23:12:23 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=laijs@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0UfAZH.L_1625800178;
Received: from C02XQCBJJG5H.local(mailfrom:laijs@linux.alibaba.com fp:SMTPD_---0UfAZH.L_1625800178)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 09 Jul 2021 11:09:38 +0800
Subject: Re: [PATCH] KVM: X86: Also reload the debug registers before
 kvm_x86->run() when the host is using them
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org
References: <20210628172632.81029-1-jiangshanlai@gmail.com>
 <46e0aaf1-b7cd-288f-e4be-ac59aa04908f@redhat.com>
From:   Lai Jiangshan <laijs@linux.alibaba.com>
Message-ID: <c79d0167-7034-ebe2-97b7-58354d81323d@linux.alibaba.com>
Date:   Fri, 9 Jul 2021 11:09:38 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <46e0aaf1-b7cd-288f-e4be-ac59aa04908f@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2021/7/9 00:48, Paolo Bonzini wrote:
> On 28/06/21 19:26, Lai Jiangshan wrote:
>> From: Lai Jiangshan <laijs@linux.alibaba.com>
>>
>> When the host is using debug registers but the guest is not using them
>> nor is the guest in guest-debug state, the kvm code does not reset
>> the host debug registers before kvm_x86->run().  Rather, it relies on
>> the hardware vmentry instruction to automatically reset the dr7 registers
>> which ensures that the host breakpoints do not affect the guest.
>>
>> But there are still problems:
>>     o The addresses of the host breakpoints can leak into the guest
>>       and the guest may use these information to attack the host.
> 
> I don't think this is true, because DRn reads would exit (if they don't, switch_db_regs would be nonzero).  But 
> otherwise it makes sense to do at least the DR7 write, and we might as well do all of them.

Ahh.... you are right.

> 
>>     o It violates the non-instrumentable nature around VM entry and
>>       exit.  For example, when a host breakpoint is set on
>>       vcpu->arch.cr2, #DB will hit aftr kvm_guest_enter_irqoff().
>>
>> Beside the problems, the logic is not consistent either. When the guest
>> debug registers are active, the host breakpoints are reset before
>> kvm_x86->run(). But when the guest debug registers are inactive, the
>> host breakpoints are delayed to be disabled.  The host tracing tools may
>> see different results depending on there is any guest running or not.
> 
> More precisely, the host tracing tools may see different results depending on what the guest is doing.
> 
> Queued (with fixed commit message), thanks!
> 
> Paolo

I just noticed that emulation.c fails to emulate with DBn.
Is there any problem around it?

For code breakpoint, if the instruction didn't cause vm-exit,
(for example, the 2nd instruction when kvm emulates instructions
back to back) emulation.c fails to emulate with DBn.

For code breakpoint, if the instruction just caused vm-exit.
It is difficult to analyze this case due to the complex priorities
between vectored events and fault-like vm-exit.
Anyway, if it is an instruction that vm-exit has priority over #DB,
emulation.c fails to emulate with DBn.

For data breakpoint, a #DB must be delivered to guest or to VMM (when
guest-debug) after the instruction. But emulation.c doesn't do so.

And the existence of both of effective DBn (guest debug) and guest DBn
complicates the problem when we try to emulate them.

Thanks.
Lai.


