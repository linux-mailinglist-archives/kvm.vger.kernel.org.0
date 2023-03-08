Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E71886B0D48
	for <lists+kvm@lfdr.de>; Wed,  8 Mar 2023 16:48:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231460AbjCHPs3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Mar 2023 10:48:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbjCHPs2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Mar 2023 10:48:28 -0500
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EA6EF3D900;
        Wed,  8 Mar 2023 07:48:26 -0800 (PST)
Received: from [192.168.2.24] (77-166-152-30.fixed.kpn.net [77.166.152.30])
        by linux.microsoft.com (Postfix) with ESMTPSA id 4026220C14D7;
        Wed,  8 Mar 2023 07:48:25 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 4026220C14D7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1678290506;
        bh=ARQrceL3+wT2jD97un/kmuZ56IAlnxpVrHWJjIbRFfk=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=Ik3GgKWT6qNSz4gwPQqkSw3k0Xk0BtaXQiVXe1vUfn7VYh0rH7vyNHKNWbyPtUImp
         bSySGUn3tdcXiDqiESLZyO0TQFLR+st7InQglysc5LWEkdg4euSc/gqhUalZp0FdJA
         hAfnZ4wW1egFg4Sm+4djLrMaxWauCZ6jZjX8AFBw=
Message-ID: <80ccfedc-c6fb-8038-4e3e-24e1d806a021@linux.microsoft.com>
Date:   Wed, 8 Mar 2023 16:48:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH] KVM: SVM: Disable TDP MMU when running on Hyper-V
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Tianyu Lan <ltykernel@gmail.com>,
        Michael Kelley <mikelley@microsoft.com>
References: <20230227171751.1211786-1-jpiotrowski@linux.microsoft.com>
 <ZAd2MRNLw1JAXmOf@google.com>
 <CABgObfa1578yKuw3sqnCeLXpyyKmMPgNaftP9HCdgHNM9Tztjw@mail.gmail.com>
From:   Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
In-Reply-To: <CABgObfa1578yKuw3sqnCeLXpyyKmMPgNaftP9HCdgHNM9Tztjw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/03/2023 01:00, Paolo Bonzini wrote:
> On Tue, Mar 7, 2023 at 6:36 PM Sean Christopherson <seanjc@google.com> wrote:
>> Thinking about this more, I would rather revert commit 1e0c7d40758b ("KVM: SVM:
>> hyper-v: Remote TLB flush for SVM") or fix the thing properly straitaway.  KVM
>> doesn't magically handle the flushes correctly for the shadow/legacy MMU, KVM just
>> happens to get lucky and not run afoul of the underlying bugs.
> 
> I don't think it's about luck---the legacy MMU's zapping/invalidation
> seems to invoke the flush hypercall correctly:
> 
> Jeremi, did you ever track the call stack where
> hyperv_nested_flush_guest_mapping is triggered?
> 
> Paolo
> 

Yes, here's all the stacktraces I get for hyperv_nested_flush_guest_mapping with legacy MMU:

1
 entry_SYSCALL_64_after_hwframe
  do_syscall_64
   __x64_sys_ioctl
    kvm_vcpu_ioctl
     kvm_arch_vcpu_ioctl_run
      svm_handle_exit
       svm_invoke_exit_handler
        npf_interception
         kvm_mmu_page_fault
          kvm_mmu_do_page_fault
           kvm_tdp_page_fault
            direct_page_fault
             kvm_faultin_pfn
              __gfn_to_pfn_memslot
               hva_to_pfn
                get_user_pages_unlocked
                 __gup_longterm_locked
                  __get_user_pages
                   handle_mm_fault
                    __handle_mm_fault
                     do_huge_pmd_wp_page
                      __split_huge_pmd
                       __mmu_notifier_invalidate_range_start
                        kvm_mmu_notifier_invalidate_range_start
                         kvm_flush_remote_tlbs
                          hv_remote_flush_tlb
                           hv_remote_flush_tlb_with_range
                            hyperv_flush_guest_mapping
1
 entry_SYSCALL_64_after_hwframe
  do_syscall_64
   syscall_exit_to_user_mode
    exit_to_user_mode_prepare
     arch_do_signal_or_restart
      get_signal
       do_group_exit
        do_exit
         mmput
          __mmput
           exit_mmap
            __mmu_notifier_release
             kvm_mmu_notifier_release
              kvm_arch_flush_shadow_all
               kvm_mmu_zap_all
                kvm_mmu_commit_zap_page.part.0
                 kvm_flush_remote_tlbs
                  hv_remote_flush_tlb
                   hv_remote_flush_tlb_with_range
                    hyperv_flush_guest_mapping
1
 entry_SYSCALL_64_after_hwframe
  do_syscall_64
   syscall_exit_to_user_mode
    exit_to_user_mode_prepare
     arch_do_signal_or_restart
      get_signal
       do_group_exit
        do_exit
         task_work_run
          ____fput
           __fput
            kvm_vm_release
             kvm_put_kvm
              kvm_destroy_vm
               kvm_arch_destroy_vm
                kvm_mmu_unload
                 kvm_mmu_free_roots
                  kvm_mmu_commit_zap_page.part.0
                   kvm_flush_remote_tlbs
                    hv_remote_flush_tlb
                     hv_remote_flush_tlb_with_range
                      hyperv_flush_guest_mapping
6
 entry_SYSCALL_64_after_hwframe
  do_syscall_64
   __x64_sys_ioctl
    kvm_vcpu_ioctl
     kvm_arch_vcpu_ioctl_run
      svm_handle_exit
       svm_invoke_exit_handler
        npf_interception
         kvm_mmu_page_fault
          kvm_mmu_do_page_fault
           kvm_tdp_page_fault
            direct_page_fault
             kvm_faultin_pfn
              __gfn_to_pfn_memslot
               hva_to_pfn
                get_user_pages_unlocked
                 __gup_longterm_locked
                  __get_user_pages
                   handle_mm_fault
                    __handle_mm_fault
                     do_wp_page
                      __mmu_notifier_invalidate_range_start
                       kvm_mmu_notifier_invalidate_range_start
                        kvm_flush_remote_tlbs
                         hv_remote_flush_tlb
                          hv_remote_flush_tlb_with_range
                           hyperv_flush_guest_mapping
8
 entry_SYSCALL_64_after_hwframe
  do_syscall_64
   __x64_sys_ioctl
    kvm_vcpu_ioctl
     kvm_arch_vcpu_ioctl_run
      kvm_apic_accept_events
       kvm_vcpu_reset
        kvm_mmu_reset_context
         kvm_mmu_free_roots
          kvm_mmu_commit_zap_page.part.0
           kvm_flush_remote_tlbs
            hv_remote_flush_tlb
             hv_remote_flush_tlb_with_range
              hyperv_flush_guest_mapping
20
 entry_SYSCALL_64_after_hwframe
  do_syscall_64
   __x64_sys_ioctl
    kvm_vcpu_ioctl
     kvm_arch_vcpu_ioctl_run
      svm_handle_exit
       svm_invoke_exit_handler
        npf_interception
         kvm_mmu_page_fault
          kvm_mmu_do_page_fault
           kvm_tdp_page_fault
            direct_page_fault
             mmu_set_spte
              hv_remote_flush_tlb_with_range
               hyperv_flush_guest_mapping_range
406
 entry_SYSCALL_64_after_hwframe
  do_syscall_64
   __x64_sys_ioctl
    kvm_vm_ioctl
     __kvm_set_memory_region
      kvm_set_memslot
       kvm_arch_flush_shadow_memslot
        kvm_page_track_flush_slot
         kvm_mmu_invalidate_zap_pages_in_memslot
          kvm_mmu_zap_all_fast
           kvm_mmu_commit_zap_page.part.0
            kvm_flush_remote_tlbs
             hv_remote_flush_tlb
              hv_remote_flush_tlb_with_range
               hyperv_flush_guest_mapping
406
 entry_SYSCALL_64_after_hwframe
  do_syscall_64
   __x64_sys_ioctl
    kvm_vcpu_ioctl
     kvm_arch_vcpu_ioctl_run
      kvm_mmu_free_obsolete_roots
       __kvm_mmu_free_obsolete_roots
        kvm_mmu_free_roots
         kvm_mmu_commit_zap_page.part.0
          kvm_flush_remote_tlbs
           hv_remote_flush_tlb
            hv_remote_flush_tlb_with_range
             hyperv_flush_guest_mapping


and here's the stacks for TDP MMU:

1
 entry_SYSCALL_64_after_hwframe
  do_syscall_64
   __x64_sys_ioctl
    kvm_vcpu_ioctl
     kvm_arch_vcpu_ioctl_run
      svm_handle_exit
       svm_invoke_exit_handler
        npf_interception
         kvm_mmu_page_fault
          kvm_mmu_do_page_fault
           kvm_tdp_page_fault
            kvm_faultin_pfn
             __gfn_to_pfn_memslot
              hva_to_pfn
               get_user_pages_unlocked
                __gup_longterm_locked
                 __get_user_pages
                  handle_mm_fault
                   __handle_mm_fault
                    do_huge_pmd_wp_page
                     __split_huge_pmd
                      __mmu_notifier_invalidate_range_start
                       kvm_mmu_notifier_invalidate_range_start
                        kvm_flush_remote_tlbs
                         hv_remote_flush_tlb
                          hv_remote_flush_tlb_with_range
                           hyperv_flush_guest_mapping
6
 entry_SYSCALL_64_after_hwframe
  do_syscall_64
   __x64_sys_ioctl
    kvm_vcpu_ioctl
     kvm_arch_vcpu_ioctl_run
      svm_handle_exit
       svm_invoke_exit_handler
        npf_interception
         kvm_mmu_page_fault
          kvm_mmu_do_page_fault
           kvm_tdp_page_fault
            kvm_faultin_pfn
             __gfn_to_pfn_memslot
              hva_to_pfn
               get_user_pages_unlocked
                __gup_longterm_locked
                 __get_user_pages
                  handle_mm_fault
                   __handle_mm_fault
                    do_wp_page
                     __mmu_notifier_invalidate_range_start
                      kvm_mmu_notifier_invalidate_range_start
                       kvm_flush_remote_tlbs
                        hv_remote_flush_tlb
                         hv_remote_flush_tlb_with_range
                          hyperv_flush_guest_mapping

>> The revert appears
>> to be reasonably straightforward (see bottom).
>>
>> And _if_ we want to hack-a-fix it, then I would strongly prefer a very isolated,
>> obviously hacky fix, e.g.
>>
>> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
>> index 36e4561554ca..a9ba4ae14fda 100644
>> --- a/arch/x86/kvm/mmu/mmu.c
>> +++ b/arch/x86/kvm/mmu/mmu.c
>> @@ -5779,8 +5779,13 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
>>         tdp_root_level = tdp_forced_root_level;
>>         max_tdp_level = tdp_max_root_level;
>>
>> +       /*
>> +        * FIXME: Remove the enlightened TLB restriction when KVM properly
>> +        * handles TLB flushes for said enlightenment.
>> +        */.
>>  #ifdef CONFIG_X86_64
>> -       tdp_mmu_enabled = tdp_mmu_allowed && tdp_enabled;
>> +       tdp_mmu_enabled = tdp_mmu_allowed && tdp_enabled &&
>> +                         !(ms_hyperv.nested_features & HV_X64_NESTED_ENLIGHTENED_TLB);
>>  #endif
>>         /*
>>          * max_huge_page_level reflects KVM's MMU capabilities irrespective
>>
>>
>>
>>
>> The revert...
>>
>> ---
>>  arch/x86/kvm/svm/svm.c          |  3 ---
>>  arch/x86/kvm/svm/svm_onhyperv.h | 27 ---------------------------
>>  2 files changed, 30 deletions(-)
>>
>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>> index 11068e8eb969..292650dc85a0 100644
>> --- a/arch/x86/kvm/svm/svm.c
>> +++ b/arch/x86/kvm/svm/svm.c
>> @@ -1320,7 +1320,6 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
>>         if (sev_guest(vcpu->kvm))
>>                 sev_init_vmcb(svm);
>>
>> -       svm_hv_init_vmcb(vmcb);
>>         init_vmcb_after_set_cpuid(vcpu);
>>
>>         vmcb_mark_all_dirty(vmcb);
>> @@ -4075,8 +4074,6 @@ static void svm_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa,
>>                 svm->vmcb->control.nested_cr3 = __sme_set(root_hpa);
>>                 vmcb_mark_dirty(svm->vmcb, VMCB_NPT);
>>
>> -               hv_track_root_tdp(vcpu, root_hpa);
>> -
>>                 cr3 = vcpu->arch.cr3;
>>         } else if (root_level >= PT64_ROOT_4LEVEL) {
>>                 cr3 = __sme_set(root_hpa) | kvm_get_active_pcid(vcpu);
>> diff --git a/arch/x86/kvm/svm/svm_onhyperv.h b/arch/x86/kvm/svm/svm_onhyperv.h
>> index 6981c1e9a809..5118fd273e73 100644
>> --- a/arch/x86/kvm/svm/svm_onhyperv.h
>> +++ b/arch/x86/kvm/svm/svm_onhyperv.h
>> @@ -15,31 +15,8 @@ static struct kvm_x86_ops svm_x86_ops;
>>
>>  int svm_hv_enable_l2_tlb_flush(struct kvm_vcpu *vcpu);
>>
>> -static inline void svm_hv_init_vmcb(struct vmcb *vmcb)
>> -{
>> -       struct hv_vmcb_enlightenments *hve = &vmcb->control.hv_enlightenments;
>> -
>> -       BUILD_BUG_ON(sizeof(vmcb->control.hv_enlightenments) !=
>> -                    sizeof(vmcb->control.reserved_sw));
>> -
>> -       if (npt_enabled &&
>> -           ms_hyperv.nested_features & HV_X64_NESTED_ENLIGHTENED_TLB)
>> -               hve->hv_enlightenments_control.enlightened_npt_tlb = 1;
>> -
>> -       if (ms_hyperv.nested_features & HV_X64_NESTED_MSR_BITMAP)
>> -               hve->hv_enlightenments_control.msr_bitmap = 1;
>> -}
>> -
>>  static inline void svm_hv_hardware_setup(void)
>>  {
>> -       if (npt_enabled &&
>> -           ms_hyperv.nested_features & HV_X64_NESTED_ENLIGHTENED_TLB) {
>> -               pr_info(KBUILD_MODNAME ": Hyper-V enlightened NPT TLB flush enabled\n");
>> -               svm_x86_ops.tlb_remote_flush = hv_remote_flush_tlb;
>> -               svm_x86_ops.tlb_remote_flush_with_range =
>> -                               hv_remote_flush_tlb_with_range;
>> -       }
>> -
>>         if (ms_hyperv.nested_features & HV_X64_NESTED_DIRECT_FLUSH) {
>>                 int cpu;
>>
>> @@ -80,10 +57,6 @@ static inline void svm_hv_update_vp_id(struct vmcb *vmcb, struct kvm_vcpu *vcpu)
>>  }
>>  #else
>>
>> -static inline void svm_hv_init_vmcb(struct vmcb *vmcb)
>> -{
>> -}
>> -
>>  static inline void svm_hv_hardware_setup(void)
>>  {
>>  }
>>
>> base-commit: cb8748a781fe983e451f616ce4861a1c49ce79dd
>> --
>>
