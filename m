Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D4C0458856
	for <lists+kvm@lfdr.de>; Mon, 22 Nov 2021 04:27:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232276AbhKVDa0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 21 Nov 2021 22:30:26 -0500
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:35099 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229775AbhKVDaZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 21 Nov 2021 22:30:25 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=laijs@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0UxaZBi6_1637551635;
Received: from 30.22.113.131(mailfrom:laijs@linux.alibaba.com fp:SMTPD_---0UxaZBi6_1637551635)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 22 Nov 2021 11:27:16 +0800
Message-ID: <1c851214-2873-69c0-0ba6-d82374c26722@linux.alibaba.com>
Date:   Mon, 22 Nov 2021 11:27:15 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.1
Subject: Re: [PATCH 01/15] KVM: VMX: Use x86 core API to access to fs_base and
 inactive gs_base
Content-Language: en-US
To:     Thomas Gleixner <tglx@linutronix.de>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>
References: <20211118110814.2568-1-jiangshanlai@gmail.com>
 <20211118110814.2568-2-jiangshanlai@gmail.com> <87k0h1leqj.ffs@tglx>
From:   Lai Jiangshan <laijs@linux.alibaba.com>
In-Reply-To: <87k0h1leqj.ffs@tglx>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2021/11/21 23:17, Thomas Gleixner wrote:
> Lai,
> 
> On Thu, Nov 18 2021 at 19:08, Lai Jiangshan wrote:
>> From: Lai Jiangshan <laijs@linux.alibaba.com>
>>
>> And they use FSGSBASE instructions when enabled.
> 
> That's really not a proper explanation for adding yet more exports.
> 

Hello

---
When a vCPU thread is rescheduled, 1 rdmsr and 2 wrmsr are called for
MSR_KERNEL_GS_BASE.

In scheduler, the core kernel uses x86_gsbase_[read|write]_cpu_inactive()
to accelerate the access to inactive GSBASE, but when the scheduler calls
in the preemption notifier in kvm, {rd|wr}msr(MSR_KERNEL_GS_BASE) is used.

To make the way of how kvm access to inactive GSBASE consistent with the
scheduler, kvm is changed to use x86 core API to access to fs_base and
inactive gs_base.  And they use FSGSBASE instructions when enabled.

It would add 2 more exports, but it doesn't export any extra software nor
hardware resources since the resources can be access via {rd|wr}msr.
---

Not so persuasive.  If it needs to be accelerated in the preemption notifier,
there are some other more aggressive ways.

Thanks
Lai
