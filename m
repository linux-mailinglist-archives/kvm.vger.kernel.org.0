Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 116F13F946D
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 08:41:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244247AbhH0GdO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Aug 2021 02:33:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbhH0GdO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Aug 2021 02:33:14 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB3B7C061757;
        Thu, 26 Aug 2021 23:32:25 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id u11-20020a17090adb4b00b00181668a56d6so4120427pjx.5;
        Thu, 26 Aug 2021 23:32:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+MbKGaZqb1nOlQOBA1siiT5EUcvqHWSajiiHHKKfKbM=;
        b=UCuSZ0Q9wIR4xSNpyjAgRxY1Nw7/pMXtxDabEn39wJcQpCEf+TnzpWlztpx4nWypLi
         D6rRvjM5Lxnz/9tyZpbsmaX2oHh+LLRsEINwyv3XGoZvksbSPB/8esRKZeytH3ax9bkb
         X+1wNKLiTNQD3ADjW3jZhdSBB4MYvAXIeWrgrz7UrkLkH/HFfzVtf53L7BxrZW5bQoSO
         wfeFnbfW1UIDUODmQFIw86wdUYuskPcaDiHLMkaieuwG27suu2BuWQZh+ZIGrtymAywj
         n7ZS74YCOw9cmKT2DeyGugQrWCmDyLEmgLiIs5SPvdWPsmGLASwSSGi+6MVVscr4Ur3e
         xQnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=+MbKGaZqb1nOlQOBA1siiT5EUcvqHWSajiiHHKKfKbM=;
        b=OdEKMRF3fKJEZRcf02+WKpNmF2pz7XAJBCj4ERCm5dDtOEj7r9tFReuubosFJcXnp0
         kLVYDAgD7rTK3HAqLoP1sNZrVNd31QabrgyBFzWRJSv+4qEPsXVwtfmaaZLTexmgwnmA
         Gb+7oJQLqdmEArvVGEhDZ5LasQCaA0J5Tc/VNN9pi15RioDzQ9d98vc7nHhJABFQVDDc
         w60D2PiNGzo281+o5/3/j7qYpTAEESBlg40tdzA9589ODNqM4D0/bTUAfT/IUWa6zht1
         EHIy2FTc9vUmsM4wlhXtGuyiXlwD+EUretIOsdu/l2mDYMO/B8jvPnv1pDOUgusihAHw
         0Oyg==
X-Gm-Message-State: AOAM532NAOpWROpV+WcXCxzE0/jM3ZyRcqrTmFdclQLgqLJEJmOjpT74
        gFhIAeNEvJvT0GN3RZU7mUA=
X-Google-Smtp-Source: ABdhPJzBd0RL1wY8mA4iTvQlCUrZMja16ozwHu+LXgwex8LJgpDuF+4RrNii8YA8VwAqTX/IbcWEVw==
X-Received: by 2002:a17:90a:4a0c:: with SMTP id e12mr8948175pjh.218.1630045945369;
        Thu, 26 Aug 2021 23:32:25 -0700 (PDT)
Received: from Likes-MacBook-Pro.local ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id x129sm5028060pfx.198.2021.08.26.23.31.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Aug 2021 23:32:24 -0700 (PDT)
Subject: Re: [PATCH V10 01/18] perf/core: Use static_call to optimize
 perf_guest_info_callbacks
To:     Sean Christopherson <seanjc@google.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>
Cc:     peterz@infradead.org, pbonzini@redhat.com, bp@alien8.de,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, kan.liang@linux.intel.com, ak@linux.intel.com,
        wei.w.wang@intel.com, eranian@google.com, liuxiangdong5@huawei.com,
        linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        boris.ostrvsky@oracle.com, Like Xu <like.xu@linux.intel.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Guo Ren <guoren@kernel.org>, Nick Hu <nickhu@andestech.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-csky@vger.kernel.org, linux-riscv@lists.infradead.org,
        xen-devel@lists.xenproject.org
References: <20210806133802.3528-1-lingshan.zhu@intel.com>
 <20210806133802.3528-2-lingshan.zhu@intel.com> <YSfykbECnC6J02Yk@google.com>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
Message-ID: <2f3d9676-3f49-3963-20d5-7aaf81ce996e@gmail.com>
Date:   Fri, 27 Aug 2021 14:31:43 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <YSfykbECnC6J02Yk@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/8/2021 3:59 am, Sean Christopherson wrote:
> TL;DR: Please don't merge this patch, it's broken and is also built on a shoddy
>         foundation that I would like to fix.

Obviously, this patch is not closely related to the guest PEBS feature enabling,
and we can certainly put this issue in another discussion thread [1].

[1] https://lore.kernel.org/kvm/20210827005718.585190-1-seanjc@google.com/

> 
> On Fri, Aug 06, 2021, Zhu Lingshan wrote:
>> diff --git a/kernel/events/core.c b/kernel/events/core.c
>> index 464917096e73..e466fc8176e1 100644
>> --- a/kernel/events/core.c
>> +++ b/kernel/events/core.c
>> @@ -6489,9 +6489,18 @@ static void perf_pending_event(struct irq_work *entry)
>>    */
>>   struct perf_guest_info_callbacks *perf_guest_cbs;
>>   
>> +/* explicitly use __weak to fix duplicate symbol error */
>> +void __weak arch_perf_update_guest_cbs(void)
>> +{
>> +}
>> +
>>   int perf_register_guest_info_callbacks(struct perf_guest_info_callbacks *cbs)
>>   {
>> +	if (WARN_ON_ONCE(perf_guest_cbs))
>> +		return -EBUSY;
>> +
>>   	perf_guest_cbs = cbs;
>> +	arch_perf_update_guest_cbs();
> 
> This is horribly broken, it fails to cleanup the static calls when KVM unregisters
> the callbacks, which happens when the vendor module, e.g. kvm_intel, is unloaded.
> The explosion doesn't happen until 'kvm' is unloaded because the functions are
> implemented in 'kvm', i.e. the use-after-free is deferred a bit.
> 
>    BUG: unable to handle page fault for address: ffffffffa011bb90
>    #PF: supervisor instruction fetch in kernel mode
>    #PF: error_code(0x0010) - not-present page
>    PGD 6211067 P4D 6211067 PUD 6212063 PMD 102b99067 PTE 0
>    Oops: 0010 [#1] PREEMPT SMP
>    CPU: 0 PID: 1047 Comm: rmmod Not tainted 5.14.0-rc2+ #460
>    Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
>    RIP: 0010:0xffffffffa011bb90
>    Code: Unable to access opcode bytes at RIP 0xffffffffa011bb66.
>    Call Trace:
>     <NMI>
>     ? perf_misc_flags+0xe/0x50
>     ? perf_prepare_sample+0x53/0x6b0
>     ? perf_event_output_forward+0x67/0x160
>     ? kvm_clock_read+0x14/0x30
>     ? kvm_sched_clock_read+0x5/0x10
>     ? sched_clock_cpu+0xd/0xd0
>     ? __perf_event_overflow+0x52/0xf0
>     ? handle_pmi_common+0x1f2/0x2d0
>     ? __flush_tlb_all+0x30/0x30
>     ? intel_pmu_handle_irq+0xcf/0x410
>     ? nmi_handle+0x5/0x260
>     ? perf_event_nmi_handler+0x28/0x50
>     ? nmi_handle+0xc7/0x260
>     ? lock_release+0x2b0/0x2b0
>     ? default_do_nmi+0x6b/0x170
>     ? exc_nmi+0x103/0x130
>     ? end_repeat_nmi+0x16/0x1f
>     ? lock_release+0x2b0/0x2b0
>     ? lock_release+0x2b0/0x2b0
>     ? lock_release+0x2b0/0x2b0
>     </NMI>
>    Modules linked in: irqbypass [last unloaded: kvm]
> 
> Even more fun, the existing perf_guest_cbs framework is also broken, though it's
> much harder to get it to fail, and probably impossible to get it to fail without
> some help.  The issue is that perf_guest_cbs is global, which means that it can
> be nullified by KVM (during module unload) while the callbacks are being accessed
> by a PMI handler on a different CPU.
> 
> The bug has escaped notice because all dererfences of perf_guest_cbs follow the
> same "perf_guest_cbs && perf_guest_cbs->is_in_guest()" pattern, and AFAICT the
> compiler never reload perf_guest_cbs in this sequence.  The compiler does reload
> perf_guest_cbs for any future dereferences, but the ->is_in_guest() guard all but
> guarantees the PMI handler will win the race, e.g. to nullify perf_guest_cbs,
> KVM has to completely exit the guest and teardown down all VMs before it can be
> unloaded.
> 
> But with a help, e.g. RAED_ONCE(perf_guest_cbs), unloading kvm_intel can trigger
> a NULL pointer derference, e.g. this tweak
> 
> diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
> index 1eb45139fcc6..202e5ad97f82 100644
> --- a/arch/x86/events/core.c
> +++ b/arch/x86/events/core.c
> @@ -2954,7 +2954,7 @@ unsigned long perf_misc_flags(struct pt_regs *regs)
>   {
>          int misc = 0;
> 
> -       if (perf_guest_cbs && perf_guest_cbs->is_in_guest()) {
> +       if (READ_ONCE(perf_guest_cbs) && READ_ONCE(perf_guest_cbs)->is_in_guest()) {
>                  if (perf_guest_cbs->is_user_mode())
>                          misc |= PERF_RECORD_MISC_GUEST_USER;
>                  else
> 
> 
> while spamming module load/unload leads to:
> 
>    BUG: kernel NULL pointer dereference, address: 0000000000000000
>    #PF: supervisor read access in kernel mode
>    #PF: error_code(0x0000) - not-present page
>    PGD 0 P4D 0
>    Oops: 0000 [#1] PREEMPT SMP
>    CPU: 6 PID: 1825 Comm: stress Not tainted 5.14.0-rc2+ #459
>    Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
>    RIP: 0010:perf_misc_flags+0x1c/0x70
>    Call Trace:
>     perf_prepare_sample+0x53/0x6b0
>     perf_event_output_forward+0x67/0x160
>     __perf_event_overflow+0x52/0xf0
>     handle_pmi_common+0x207/0x300
>     intel_pmu_handle_irq+0xcf/0x410
>     perf_event_nmi_handler+0x28/0x50
>     nmi_handle+0xc7/0x260
>     default_do_nmi+0x6b/0x170
>     exc_nmi+0x103/0x130
>     asm_exc_nmi+0x76/0xbf
> 
> 
> The good news is that I have a series that should fix both the existing NULL pointer
> bug and mostly obviate the need for static calls.  The bad news is that my approach,
> making perf_guest_cbs per-CPU, likely complicates turning these into static calls,
> though I'm guessing it's still a solvable problem.
> 
> Tangentially related, IMO we should make architectures opt-in to getting
> perf_guest_cbs and nuke all of the code in the below files.  Except for arm,
> which recently lost KVM support, it's all a bunch of useless copy-paste code that
> serves no purpose and just complicates cleanups like this.
> 
>>   arch/arm/kernel/perf_callchain.c   | 16 +++++++-----
>>   arch/csky/kernel/perf_callchain.c  |  4 +--
>>   arch/nds32/kernel/perf_event_cpu.c | 16 +++++++-----
>>   arch/riscv/kernel/perf_callchain.c |  4 +--
