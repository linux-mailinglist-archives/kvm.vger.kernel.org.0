Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B637C11E124
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2019 10:47:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbfLMJrj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Dec 2019 04:47:39 -0500
Received: from inca-roads.misterjones.org ([213.251.177.50]:45984 "EHLO
        inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725799AbfLMJrj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 13 Dec 2019 04:47:39 -0500
Received: from www-data by cheepnis.misterjones.org with local (Exim 4.80)
        (envelope-from <maz@kernel.org>)
        id 1ifhXs-0002Pq-GE; Fri, 13 Dec 2019 10:47:36 +0100
To:     Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH 3/3] kvm/arm: Standardize kvm exit reason field
X-PHP-Originating-Script: 0:main.inc
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Fri, 13 Dec 2019 09:47:36 +0000
From:   Marc Zyngier <maz@kernel.org>
Cc:     <kvm@vger.kernel.org>, <pbonzini@redhat.com>, <rkrcmar@redhat.com>,
        <paulus@ozlabs.org>, <jhogan@kernel.org>, <drjones@redhat.com>,
        <vkuznets@redhat.com>
In-Reply-To: <f101e4a6-bebf-d30f-3dfe-99ded0644836@redhat.com>
References: <20191212024512.39930-4-gshan@redhat.com>
 <2e960d77afc7ac75f1be73a56a9aca66@www.loen.fr>
 <f101e4a6-bebf-d30f-3dfe-99ded0644836@redhat.com>
Message-ID: <30c0da369a898143246106205cb3af59@www.loen.fr>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/0.7.2
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Rcpt-To: gshan@redhat.com, kvm@vger.kernel.org, pbonzini@redhat.com, rkrcmar@redhat.com, paulus@ozlabs.org, jhogan@kernel.org, drjones@redhat.com, vkuznets@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Gavin,

On 2019-12-13 00:50, Gavin Shan wrote:
> On 12/12/19 8:23 PM, Marc Zyngier wrote:
>> On 2019-12-12 02:45, Gavin Shan wrote:
>>> This standardizes kvm exit reason field name by replacing "esr_ec"
>>> with "exit_reason".
>>>
>>> Signed-off-by: Gavin Shan <gshan@redhat.com>
>>> ---
>>>  virt/kvm/arm/trace.h | 14 ++++++++------
>>>  1 file changed, 8 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/virt/kvm/arm/trace.h b/virt/kvm/arm/trace.h
>>> index 204d210d01c2..0ac774fd324d 100644
>>> --- a/virt/kvm/arm/trace.h
>>> +++ b/virt/kvm/arm/trace.h
>>> @@ -27,25 +27,27 @@ TRACE_EVENT(kvm_entry,
>>>  );
>>>
>>>  TRACE_EVENT(kvm_exit,
>>> -    TP_PROTO(int ret, unsigned int esr_ec, unsigned long vcpu_pc),
>>> -    TP_ARGS(ret, esr_ec, vcpu_pc),
>>> +    TP_PROTO(int ret, unsigned int exit_reason, unsigned long 
>>> vcpu_pc),
>>> +    TP_ARGS(ret, exit_reason, vcpu_pc),
>>>
>>>      TP_STRUCT__entry(
>>>          __field(    int,        ret        )
>>> -        __field(    unsigned int,    esr_ec        )
>>> +        __field(    unsigned int,    exit_reason    )
>> I don't think the two are the same thing. The exit reason should be
>> exactly that: why has the guest exited (exception, host interrupt, 
>> trap).
>> What we're reporting here is the exception class, which doesn't 
>> apply to
>> interrupts, for example (hence the 0 down below, which we treat as a
>> catch-all).
>>
>
> Marc, thanks a lot for your reply. Yeah, the combination (ret and 
> esr_ec) is
> complete to indicate the exit reasons if I'm understanding correctly.
>
> The exit reasons seen by kvm_stat is exactly the ESR_EL1[EC]. It's 
> declared
> by marcro AARCH64_EXIT_REASONS in tools/kvm/kvm_stat/kvm_stat. So
> it's precise
> and complete from perspective of kvm_stat.
>
> For the patch itself, it standardizes the filter name by renaming 
> "esr_ec"
> to "exit_reason", no functional changes introduced and I think it 
> would be
> fine.

It may not be a functional change, but it is a semantic change. To me,
'exit_reason' means something, and esr_ec something entirely different.

But the real blocker is below.

>>>          __field(    unsigned long,    vcpu_pc        )
>>>      ),
>>>
>>>      TP_fast_assign(
>>>          __entry->ret            = ARM_EXCEPTION_CODE(ret);
>>> -        __entry->esr_ec = ARM_EXCEPTION_IS_TRAP(ret) ? esr_ec : 0;
>>> +        __entry->exit_reason =
>>> +            ARM_EXCEPTION_IS_TRAP(ret) ? exit_reason: 0;
>>>          __entry->vcpu_pc        = vcpu_pc;
>>>      ),
>>>
>>>      TP_printk("%s: HSR_EC: 0x%04x (%s), PC: 0x%08lx",
>>>            __print_symbolic(__entry->ret, kvm_arm_exception_type),
>>> -          __entry->esr_ec,
>>> -          __print_symbolic(__entry->esr_ec, 
>>> kvm_arm_exception_class),
>>> +          __entry->exit_reason,
>>> +          __print_symbolic(__entry->exit_reason,
>>> +                   kvm_arm_exception_class),
>>>            __entry->vcpu_pc)
>>>  );
>> The last thing is whether such a change is an ABI change or not. 
>> I've been very
>> reluctant to change any of this for that reason.
>>
>
> Yeah, I think it is ABI change unfortunately, but I'm not sure how
> many applications are using this filter.

Nobody can tell. The problem is that someone will write a script that
parses this trace point based on an older kernel release (such as
what the distros are shipping today), and two years from now will
shout at you (and me) for having broken their toy.

> However, the fixed filter name ("exit_reason") is beneficial in long 
> run.
> The application needn't distinguish architects to provide different
> tracepoint filters at least.

Well, you certainly need to understand the actual semantic behind the
fields if you want to draw any meaningful conclusion. Otherwise, all
you need is to measure the frequency of such event.

         M.
-- 
Jazz is not dead. It just smells funny...
