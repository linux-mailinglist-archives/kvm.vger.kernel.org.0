Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0458C2D0FA6
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 12:44:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727279AbgLGLoC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 06:44:02 -0500
Received: from mx2.suse.de ([195.135.220.15]:54896 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726758AbgLGLoB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Dec 2020 06:44:01 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 1FC24AD3A;
        Mon,  7 Dec 2020 11:43:19 +0000 (UTC)
Subject: Re: [RFC PATCH 18/19] target/mips: Restrict some TCG specific
 CPUClass handlers
From:   Claudio Fontana <cfontana@suse.de>
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>
Cc:     qemu-devel@nongnu.org, Aurelien Jarno <aurelien@aurel32.net>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Paul Burton <paulburton@kernel.org>, kvm@vger.kernel.org,
        Huacai Chen <chenhuacai@kernel.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20201206233949.3783184-1-f4bug@amsat.org>
 <20201206233949.3783184-19-f4bug@amsat.org>
 <88161f99-aae5-3b80-e8c6-a57d122a28c4@suse.de>
 <61618998-f854-a7df-301f-f860d9725f1d@suse.de>
 <3956df0d-a42e-f3af-d5e1-cf396ddcb795@suse.de>
Message-ID: <5d11701b-31f8-cfcd-30f9-3eba62c3bab7@suse.de>
Date:   Mon, 7 Dec 2020 12:43:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <3956df0d-a42e-f3af-d5e1-cf396ddcb795@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I am adding to my cleanup series the following, so this is done for all targets:


Author: Claudio Fontana <cfontana@suse.de>
Date:   Mon Dec 7 11:02:34 2020 +0100

    cpu: move do_unaligned_access to tcg_ops
    
    make it consistently SOFTMMU-only.
    
    Signed-off-by: Claudio Fontana <cfontana@suse.de>

commit 1ee8254b568a47453ab481aa206fb9fecc7c16f7
Author: Claudio Fontana <cfontana@suse.de>
Date:   Mon Dec 7 10:29:22 2020 +0100

    cpu: move cc->transaction_failed to tcg_ops
    
    Signed-off-by: Claudio Fontana <cfontana@suse.de>

commit 1a03124581841b5c473f879f5fd396dccde48667
Author: Claudio Fontana <cfontana@suse.de>
Date:   Mon Dec 7 10:02:07 2020 +0100

    cpu: move cc->do_interrupt to tcg_ops
    
    Signed-off-by: Claudio Fontana <cfontana@suse.de>

commit 6a35e8f4ee68923006bba404f1f2471038b1039c
Author: Claudio Fontana <cfontana@suse.de>
Date:   Mon Dec 7 09:31:14 2020 +0100

    target/arm: do not use cc->do_interrupt for KVM directly
    
    cc->do_interrupt is a TCG callback used in accel/tcg only,
    call instead directly the arm_cpu_do_interrupt for the
    injection of exeptions from KVM, so that
    
    do_interrupt can be exported to TCG-only operations in
    the CPUClass.
    
    Signed-off-by: Claudio Fontana <cfontana@suse.de>


On 12/7/20 10:07 AM, Claudio Fontana wrote:
> On 12/7/20 9:53 AM, Claudio Fontana wrote:
>> On 12/7/20 8:59 AM, Claudio Fontana wrote:
>>> On 12/7/20 12:39 AM, Philippe Mathieu-Daudé wrote:
>>>> Restrict the following CPUClass handlers to TCG:
>>>> - do_interrupt
>>>
>>> In this patch it seems do_interrupt is changed to be CONFIG_USER_ONLY, it is not restricted to TCG.
>>
>> Of course it _is_ as only TCG can do -user- , but would it be better to wrap everything around CONFIG_TCG for what is tcg-only, and then add a subsection in there for CONFIG_USER_ONLY?
> 
> 
> Need coffee, sorry. I think you can see the issue there, sorry for the confusion.
> 
> Thanks,
> 
> Claudio
> 
> 
>>
>>> Was this desired, should be commented as such?
>>>
>>> Also, should the whole function then be #ifdefed out in helpers.c?
>>> I guess I am vouching for moving the ifndef CONFIG_USER_ONLY one line up in helpers.c.
>>>
>>> But you wanted this CONFIG_TCG-only?
>>>
>>>
>>>> - do_transaction_failed
>>>> - do_unaligned_access
>>>>
>>>> Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
>>>> ---
>>>> Cc: Claudio Fontana <cfontana@suse.de>
>>>>
>>>>  target/mips/cpu.c | 8 +++++---
>>>>  1 file changed, 5 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/target/mips/cpu.c b/target/mips/cpu.c
>>>> index 8a4486e3ea1..03bd35b7903 100644
>>>> --- a/target/mips/cpu.c
>>>> +++ b/target/mips/cpu.c
>>>> @@ -483,7 +483,6 @@ static void mips_cpu_class_init(ObjectClass *c, void *data)
>>>>  
>>>>      cc->class_by_name = mips_cpu_class_by_name;
>>>>      cc->has_work = mips_cpu_has_work;
>>>> -    cc->do_interrupt = mips_cpu_do_interrupt;
>>>>      cc->cpu_exec_interrupt = mips_cpu_exec_interrupt;
>>>>      cc->dump_state = mips_cpu_dump_state;
>>>>      cc->set_pc = mips_cpu_set_pc;
>>>> @@ -491,8 +490,7 @@ static void mips_cpu_class_init(ObjectClass *c, void *data)
>>>>      cc->gdb_read_register = mips_cpu_gdb_read_register;
>>>>      cc->gdb_write_register = mips_cpu_gdb_write_register;
>>>>  #ifndef CONFIG_USER_ONLY
>>>> -    cc->do_transaction_failed = mips_cpu_do_transaction_failed;
>>>> -    cc->do_unaligned_access = mips_cpu_do_unaligned_access;
>>>> +    cc->do_interrupt = mips_cpu_do_interrupt;
>>>>      cc->get_phys_page_debug = mips_cpu_get_phys_page_debug;
>>>>      cc->vmsd = &vmstate_mips_cpu;
>>>>  #endif
>>>> @@ -500,6 +498,10 @@ static void mips_cpu_class_init(ObjectClass *c, void *data)
>>>>  #ifdef CONFIG_TCG
>>>>      cc->tcg_initialize = mips_tcg_init;
>>>>      cc->tlb_fill = mips_cpu_tlb_fill;
>>>> +#if !defined(CONFIG_USER_ONLY)
>>>> +    cc->do_unaligned_access = mips_cpu_do_unaligned_access;
>>>> +    cc->do_transaction_failed = mips_cpu_do_transaction_failed;
>>>> +#endif /* CONFIG_TCG && !CONFIG_USER_ONLY */
>>>>  #endif
>>>>  
>>>>      cc->gdb_num_core_regs = 73;
>>>>
>>>
>>
> 

