Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CE453C220E
	for <lists+kvm@lfdr.de>; Fri,  9 Jul 2021 12:05:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232036AbhGIKIW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Jul 2021 06:08:22 -0400
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:24795 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231958AbhGIKIV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 9 Jul 2021 06:08:21 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=laijs@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0UfChuN8_1625825125;
Received: from C02XQCBJJG5H.local(mailfrom:laijs@linux.alibaba.com fp:SMTPD_---0UfChuN8_1625825125)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 09 Jul 2021 18:05:26 +0800
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
 <c79d0167-7034-ebe2-97b7-58354d81323d@linux.alibaba.com>
 <397a448e-ffa7-3bea-af86-e92fbb273a07@redhat.com>
From:   Lai Jiangshan <laijs@linux.alibaba.com>
Message-ID: <a4e07fb1-1f36-1078-0695-ff4b72016d48@linux.alibaba.com>
Date:   Fri, 9 Jul 2021 18:05:25 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <397a448e-ffa7-3bea-af86-e92fbb273a07@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2021/7/9 17:49, Paolo Bonzini wrote:
> On 09/07/21 05:09, Lai Jiangshan wrote:
>> I just noticed that emulation.c fails to emulate with DBn.
>> Is there any problem around it?
> 
> Just what you said, it's not easy and the needs are limited.  I implemented kvm_vcpu_check_breakpoint because I was 
> interested in using hardware breakpoints from gdb, even with unrestricted_guest=0 and invalid guest state, but that's it.
> 

Hello Paolo

I just remembered I once came across the patch, but I forgot it when
I wrote the mail.

It seems kvm_vcpu_check_breakpoint() handles only for code breakpoint
and doesn't handle for data breakpoints.

And no code handles DR7_GD bit when the emulation is not resulted from
vm-exit. (for example, the non-first instruction when kvm emulates
instructions back to back and the instruction accesses to DBn).

Thanks
Lai


> Paolo
> 
>> For code breakpoint, if the instruction didn't cause vm-exit,
>> (for example, the 2nd instruction when kvm emulates instructions
>> back to back) emulation.c fails to emulate with DBn.
>>
>> For code breakpoint, if the instruction just caused vm-exit.
>> It is difficult to analyze this case due to the complex priorities
>> between vectored events and fault-like vm-exit.
>> Anyway, if it is an instruction that vm-exit has priority over #DB,
>> emulation.c fails to emulate with DBn.
>>
>> For data breakpoint, a #DB must be delivered to guest or to VMM (when
>> guest-debug) after the instruction. But emulation.c doesn't do so.
>>
>> And the existence of both of effective DBn (guest debug) and guest DBn
>> complicates the problem when we try to emulate them.
