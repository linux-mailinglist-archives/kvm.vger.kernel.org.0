Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5413D63A09A
	for <lists+kvm@lfdr.de>; Mon, 28 Nov 2022 05:31:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbiK1EbZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 27 Nov 2022 23:31:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbiK1EbX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 27 Nov 2022 23:31:23 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91687BF64
        for <kvm@vger.kernel.org>; Sun, 27 Nov 2022 20:31:21 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id bs21so14871039wrb.4
        for <kvm@vger.kernel.org>; Sun, 27 Nov 2022 20:31:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Zfu9VL6STiFhoLvxgSlnwvsVyd+Tae2yVWWw42cwCPE=;
        b=N0da9uydu0Lqb9T+Gl+yddMt2roBb1qdz/+Q3sMyQxzFNdqKWtjEq9TpKtczEnYHKm
         ifVk1oh9L8Vc7OBdJWgCJj2A3llLAFtLAj4rJHNxz3SE1092AIXX5DDqqnQbTmhPnkm7
         25VTxVsgjysV7wWSnUccyzVNbTEafCihLAhuDlSAP/UoUIpnSuAw0NSIASRCVQm2zfx0
         Szvo1DykoYWKmSrA2fOZK/kpb+eqx+xEI/FnH51pnPsBXx+sWYgQmdPfH+DT/aV+5e0e
         emuenAs+07CcdeT5VWtSah5VbTzsjRh9QriJH6OC69ikubIoZnFMWWRhRmdvwxqmU9P0
         SOPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Zfu9VL6STiFhoLvxgSlnwvsVyd+Tae2yVWWw42cwCPE=;
        b=7zAgfAPjcHjG8EI5vl5cVvfK5bw8h96fMdbYgRJhLvfhwElysu+tyFVAM8uU/Upchd
         VugioRG7yZx5tiU/wxqOtDNERsWZdcXATfzTvJPW2SOelHllXCPq8fsKGhj9lzWKmDmo
         H2EkG5CM6gkPQzIT1BeUcdSNXltrIgx41wU/rXXGNF5NBOkif3T4xo7LJ3mvGvQbEAKQ
         8Bm5JmllyrknrxXz/Xrmlx9zYX75dXCzccUT2v+c3AR4QBs1dMtPR0r6RVjl9tdR+K2v
         ZYvLD49Upgtv4CnqFWN6e0Tk9n4Bz1ZHuZHipHiHwaYRCK7v/3k3MhPobJCUA9IuqsTc
         34Yw==
X-Gm-Message-State: ANoB5pnPzxIKd7YA8/u5319okWmyCD9Zzkk1YlL7LNbN+B+UZH5MohCK
        hNsLhwHnws3E7hvH2QQq9E2gxJmuv1Mvlw==
X-Google-Smtp-Source: AA0mqf7ZuWZTD+l39wclwvaZD6yAh0rgKqoz3bWmemsR4QasPQi/2GlNU7oOs4AAIsrUNc7O8y7TUQ==
X-Received: by 2002:adf:f50a:0:b0:241:f819:2aad with SMTP id q10-20020adff50a000000b00241f8192aadmr12830094wro.361.1669609880023;
        Sun, 27 Nov 2022 20:31:20 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id m7-20020a05600c4f4700b003cf37c5ddc0sm14433085wmq.22.2022.11.27.20.31.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Nov 2022 20:31:19 -0800 (PST)
Date:   Mon, 28 Nov 2022 07:31:15 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     mlevitsk@redhat.com
Cc:     kvm@vger.kernel.org
Subject: [bug report] KVM: x86: allow L1 to not intercept triple fault
Message-ID: <Y4Q5k9Xd5KgBCKit@kili>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Maxim Levitsky,

The patch 92e7d5c83aff: "KVM: x86: allow L1 to not intercept triple
fault" from Nov 3, 2022, leads to the following Smatch static checker
warning:

	arch/x86/kvm/x86.c:10873 vcpu_enter_guest()
	error: uninitialized symbol 'r'.

arch/x86/kvm/x86.c
    10509 static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
    10510 {
    10511         int r;
    10512         bool req_int_win =
    10513                 dm_request_for_irq_injection(vcpu) &&
    10514                 kvm_cpu_accept_dm_intr(vcpu);
    10515         fastpath_t exit_fastpath;
    10516 
    10517         bool req_immediate_exit = false;
    10518 
    10519         if (kvm_request_pending(vcpu)) {
    10520                 if (kvm_check_request(KVM_REQ_VM_DEAD, vcpu)) {
    10521                         r = -EIO;
    10522                         goto out;
    10523                 }
    10524 
    10525                 if (kvm_dirty_ring_check_request(vcpu)) {
    10526                         r = 0;
    10527                         goto out;
    10528                 }
    10529 
    10530                 if (kvm_check_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu)) {
    10531                         if (unlikely(!kvm_x86_ops.nested_ops->get_nested_state_pages(vcpu))) {
    10532                                 r = 0;
    10533                                 goto out;
    10534                         }
    10535                 }
    10536                 if (kvm_check_request(KVM_REQ_MMU_FREE_OBSOLETE_ROOTS, vcpu))
    10537                         kvm_mmu_free_obsolete_roots(vcpu);
    10538                 if (kvm_check_request(KVM_REQ_MIGRATE_TIMER, vcpu))
    10539                         __kvm_migrate_timers(vcpu);
    10540                 if (kvm_check_request(KVM_REQ_MASTERCLOCK_UPDATE, vcpu))
    10541                         kvm_update_masterclock(vcpu->kvm);
    10542                 if (kvm_check_request(KVM_REQ_GLOBAL_CLOCK_UPDATE, vcpu))
    10543                         kvm_gen_kvmclock_update(vcpu);
    10544                 if (kvm_check_request(KVM_REQ_CLOCK_UPDATE, vcpu)) {
    10545                         r = kvm_guest_time_update(vcpu);
    10546                         if (unlikely(r))
    10547                                 goto out;
    10548                 }
    10549                 if (kvm_check_request(KVM_REQ_MMU_SYNC, vcpu))
    10550                         kvm_mmu_sync_roots(vcpu);
    10551                 if (kvm_check_request(KVM_REQ_LOAD_MMU_PGD, vcpu))
    10552                         kvm_mmu_load_pgd(vcpu);
    10553                 if (kvm_check_request(KVM_REQ_TLB_FLUSH, vcpu)) {
    10554                         kvm_vcpu_flush_tlb_all(vcpu);
    10555 
    10556                         /* Flushing all ASIDs flushes the current ASID... */
    10557                         kvm_clear_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
    10558                 }
    10559                 kvm_service_local_tlb_flush_requests(vcpu);
    10560 
    10561                 if (kvm_check_request(KVM_REQ_REPORT_TPR_ACCESS, vcpu)) {
    10562                         vcpu->run->exit_reason = KVM_EXIT_TPR_ACCESS;
    10563                         r = 0;
    10564                         goto out;
    10565                 }
    10566                 if (kvm_test_request(KVM_REQ_TRIPLE_FAULT, vcpu)) {
    10567                         if (is_guest_mode(vcpu))
    10568                                 kvm_x86_ops.nested_ops->triple_fault(vcpu);
    10569 
    10570                         if (kvm_check_request(KVM_REQ_TRIPLE_FAULT, vcpu)) {
    10571                                 vcpu->run->exit_reason = KVM_EXIT_SHUTDOWN;
    10572                                 vcpu->mmio_needed = 0;
    10573                                 r = 0;
    10574                         }

"r" not initialized on else path.  Forgetting to set the error code is
the canonical bug for do-nothing gotos.

    10575                         goto out;
    10576                 }
    10577                 if (kvm_check_request(KVM_REQ_APF_HALT, vcpu)) {
    10578                         /* Page is swapped out. Do synthetic halt */
    10579                         vcpu->arch.apf.halted = true;
    10580                         r = 1;
    10581                         goto out;
    10582                 }
    10583                 if (kvm_check_request(KVM_REQ_STEAL_UPDATE, vcpu))
    10584                         record_steal_time(vcpu);
    10585                 if (kvm_check_request(KVM_REQ_SMI, vcpu))
    10586                         process_smi(vcpu);
    10587                 if (kvm_check_request(KVM_REQ_NMI, vcpu))
    10588                         process_nmi(vcpu);
    10589                 if (kvm_check_request(KVM_REQ_PMU, vcpu))
    10590                         kvm_pmu_handle_event(vcpu);
    10591                 if (kvm_check_request(KVM_REQ_PMI, vcpu))
    10592                         kvm_pmu_deliver_pmi(vcpu);
    10593                 if (kvm_check_request(KVM_REQ_IOAPIC_EOI_EXIT, vcpu)) {
    10594                         BUG_ON(vcpu->arch.pending_ioapic_eoi > 255);
    10595                         if (test_bit(vcpu->arch.pending_ioapic_eoi,
    10596                                      vcpu->arch.ioapic_handled_vectors)) {
    10597                                 vcpu->run->exit_reason = KVM_EXIT_IOAPIC_EOI;
    10598                                 vcpu->run->eoi.vector =
    10599                                                 vcpu->arch.pending_ioapic_eoi;
    10600                                 r = 0;
    10601                                 goto out;
    10602                         }
    10603                 }
    10604                 if (kvm_check_request(KVM_REQ_SCAN_IOAPIC, vcpu))
    10605                         vcpu_scan_ioapic(vcpu);
    10606                 if (kvm_check_request(KVM_REQ_LOAD_EOI_EXITMAP, vcpu))
    10607                         vcpu_load_eoi_exitmap(vcpu);
    10608                 if (kvm_check_request(KVM_REQ_APIC_PAGE_RELOAD, vcpu))
    10609                         kvm_vcpu_reload_apic_access_page(vcpu);
    10610                 if (kvm_check_request(KVM_REQ_HV_CRASH, vcpu)) {
    10611                         vcpu->run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
    10612                         vcpu->run->system_event.type = KVM_SYSTEM_EVENT_CRASH;
    10613                         vcpu->run->system_event.ndata = 0;
    10614                         r = 0;
    10615                         goto out;
    10616                 }
    10617                 if (kvm_check_request(KVM_REQ_HV_RESET, vcpu)) {
    10618                         vcpu->run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
    10619                         vcpu->run->system_event.type = KVM_SYSTEM_EVENT_RESET;
    10620                         vcpu->run->system_event.ndata = 0;
    10621                         r = 0;
    10622                         goto out;
    10623                 }
    10624                 if (kvm_check_request(KVM_REQ_HV_EXIT, vcpu)) {
    10625                         struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
    10626 
    10627                         vcpu->run->exit_reason = KVM_EXIT_HYPERV;
    10628                         vcpu->run->hyperv = hv_vcpu->exit;
    10629                         r = 0;
    10630                         goto out;
    10631                 }
    10632 
    10633                 /*
    10634                  * KVM_REQ_HV_STIMER has to be processed after
    10635                  * KVM_REQ_CLOCK_UPDATE, because Hyper-V SynIC timers
    10636                  * depend on the guest clock being up-to-date
    10637                  */
    10638                 if (kvm_check_request(KVM_REQ_HV_STIMER, vcpu))
    10639                         kvm_hv_process_stimers(vcpu);
    10640                 if (kvm_check_request(KVM_REQ_APICV_UPDATE, vcpu))
    10641                         kvm_vcpu_update_apicv(vcpu);
    10642                 if (kvm_check_request(KVM_REQ_APF_READY, vcpu))
    10643                         kvm_check_async_pf_completion(vcpu);
    10644                 if (kvm_check_request(KVM_REQ_MSR_FILTER_CHANGED, vcpu))
    10645                         static_call(kvm_x86_msr_filter_changed)(vcpu);
    10646 
    10647                 if (kvm_check_request(KVM_REQ_UPDATE_CPU_DIRTY_LOGGING, vcpu))
    10648                         static_call(kvm_x86_update_cpu_dirty_logging)(vcpu);
    10649         }
    10650 
    10651         if (kvm_check_request(KVM_REQ_EVENT, vcpu) || req_int_win ||
    10652             kvm_xen_has_interrupt(vcpu)) {
    10653                 ++vcpu->stat.req_event;
    10654                 r = kvm_apic_accept_events(vcpu);
    10655                 if (r < 0) {
    10656                         r = 0;
    10657                         goto out;
    10658                 }
    10659                 if (vcpu->arch.mp_state == KVM_MP_STATE_INIT_RECEIVED) {
    10660                         r = 1;
    10661                         goto out;
    10662                 }
    10663 
    10664                 r = kvm_check_and_inject_events(vcpu, &req_immediate_exit);
    10665                 if (r < 0) {
    10666                         r = 0;
    10667                         goto out;
    10668                 }
    10669                 if (req_int_win)
    10670                         static_call(kvm_x86_enable_irq_window)(vcpu);
    10671 
    10672                 if (kvm_lapic_enabled(vcpu)) {
    10673                         update_cr8_intercept(vcpu);
    10674                         kvm_lapic_sync_to_vapic(vcpu);
    10675                 }
    10676         }
    10677 
    10678         r = kvm_mmu_reload(vcpu);
    10679         if (unlikely(r)) {
    10680                 goto cancel_injection;
    10681         }
    10682 
    10683         preempt_disable();
    10684 
    10685         static_call(kvm_x86_prepare_switch_to_guest)(vcpu);
    10686 
    10687         /*
    10688          * Disable IRQs before setting IN_GUEST_MODE.  Posted interrupt
    10689          * IPI are then delayed after guest entry, which ensures that they
    10690          * result in virtual interrupt delivery.
    10691          */
    10692         local_irq_disable();
    10693 
    10694         /* Store vcpu->apicv_active before vcpu->mode.  */
    10695         smp_store_release(&vcpu->mode, IN_GUEST_MODE);
    10696 
    10697         kvm_vcpu_srcu_read_unlock(vcpu);
    10698 
    10699         /*
    10700          * 1) We should set ->mode before checking ->requests.  Please see
    10701          * the comment in kvm_vcpu_exiting_guest_mode().
    10702          *
    10703          * 2) For APICv, we should set ->mode before checking PID.ON. This
    10704          * pairs with the memory barrier implicit in pi_test_and_set_on
    10705          * (see vmx_deliver_posted_interrupt).
    10706          *
    10707          * 3) This also orders the write to mode from any reads to the page
    10708          * tables done while the VCPU is running.  Please see the comment
    10709          * in kvm_flush_remote_tlbs.
    10710          */
    10711         smp_mb__after_srcu_read_unlock();
    10712 
    10713         /*
    10714          * Process pending posted interrupts to handle the case where the
    10715          * notification IRQ arrived in the host, or was never sent (because the
    10716          * target vCPU wasn't running).  Do this regardless of the vCPU's APICv
    10717          * status, KVM doesn't update assigned devices when APICv is inhibited,
    10718          * i.e. they can post interrupts even if APICv is temporarily disabled.
    10719          */
    10720         if (kvm_lapic_enabled(vcpu))
    10721                 static_call_cond(kvm_x86_sync_pir_to_irr)(vcpu);
    10722 
    10723         if (kvm_vcpu_exit_request(vcpu)) {
    10724                 vcpu->mode = OUTSIDE_GUEST_MODE;
    10725                 smp_wmb();
    10726                 local_irq_enable();
    10727                 preempt_enable();
    10728                 kvm_vcpu_srcu_read_lock(vcpu);
    10729                 r = 1;
    10730                 goto cancel_injection;
    10731         }
    10732 
    10733         if (req_immediate_exit) {
    10734                 kvm_make_request(KVM_REQ_EVENT, vcpu);
    10735                 static_call(kvm_x86_request_immediate_exit)(vcpu);
    10736         }
    10737 
    10738         fpregs_assert_state_consistent();
    10739         if (test_thread_flag(TIF_NEED_FPU_LOAD))
    10740                 switch_fpu_return();
    10741 
    10742         if (vcpu->arch.guest_fpu.xfd_err)
    10743                 wrmsrl(MSR_IA32_XFD_ERR, vcpu->arch.guest_fpu.xfd_err);
    10744 
    10745         if (unlikely(vcpu->arch.switch_db_regs)) {
    10746                 set_debugreg(0, 7);
    10747                 set_debugreg(vcpu->arch.eff_db[0], 0);
    10748                 set_debugreg(vcpu->arch.eff_db[1], 1);
    10749                 set_debugreg(vcpu->arch.eff_db[2], 2);
    10750                 set_debugreg(vcpu->arch.eff_db[3], 3);
    10751         } else if (unlikely(hw_breakpoint_active())) {
    10752                 set_debugreg(0, 7);
    10753         }
    10754 
    10755         guest_timing_enter_irqoff();
    10756 
    10757         for (;;) {
    10758                 /*
    10759                  * Assert that vCPU vs. VM APICv state is consistent.  An APICv
    10760                  * update must kick and wait for all vCPUs before toggling the
    10761                  * per-VM state, and responsing vCPUs must wait for the update
    10762                  * to complete before servicing KVM_REQ_APICV_UPDATE.
    10763                  */
    10764                 WARN_ON_ONCE((kvm_vcpu_apicv_activated(vcpu) != kvm_vcpu_apicv_active(vcpu)) &&
    10765                              (kvm_get_apic_mode(vcpu) != LAPIC_MODE_DISABLED));
    10766 
    10767                 exit_fastpath = static_call(kvm_x86_vcpu_run)(vcpu);
    10768                 if (likely(exit_fastpath != EXIT_FASTPATH_REENTER_GUEST))
    10769                         break;
    10770 
    10771                 if (kvm_lapic_enabled(vcpu))
    10772                         static_call_cond(kvm_x86_sync_pir_to_irr)(vcpu);
    10773 
    10774                 if (unlikely(kvm_vcpu_exit_request(vcpu))) {
    10775                         exit_fastpath = EXIT_FASTPATH_EXIT_HANDLED;
    10776                         break;
    10777                 }
    10778         }
    10779 
    10780         /*
    10781          * Do this here before restoring debug registers on the host.  And
    10782          * since we do this before handling the vmexit, a DR access vmexit
    10783          * can (a) read the correct value of the debug registers, (b) set
    10784          * KVM_DEBUGREG_WONT_EXIT again.
    10785          */
    10786         if (unlikely(vcpu->arch.switch_db_regs & KVM_DEBUGREG_WONT_EXIT)) {
    10787                 WARN_ON(vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP);
    10788                 static_call(kvm_x86_sync_dirty_debug_regs)(vcpu);
    10789                 kvm_update_dr0123(vcpu);
    10790                 kvm_update_dr7(vcpu);
    10791         }
    10792 
    10793         /*
    10794          * If the guest has used debug registers, at least dr7
    10795          * will be disabled while returning to the host.
    10796          * If we don't have active breakpoints in the host, we don't
    10797          * care about the messed up debug address registers. But if
    10798          * we have some of them active, restore the old state.
    10799          */
    10800         if (hw_breakpoint_active())
    10801                 hw_breakpoint_restore();
    10802 
    10803         vcpu->arch.last_vmentry_cpu = vcpu->cpu;
    10804         vcpu->arch.last_guest_tsc = kvm_read_l1_tsc(vcpu, rdtsc());
    10805 
    10806         vcpu->mode = OUTSIDE_GUEST_MODE;
    10807         smp_wmb();
    10808 
    10809         /*
    10810          * Sync xfd before calling handle_exit_irqoff() which may
    10811          * rely on the fact that guest_fpu::xfd is up-to-date (e.g.
    10812          * in #NM irqoff handler).
    10813          */
    10814         if (vcpu->arch.xfd_no_write_intercept)
    10815                 fpu_sync_guest_vmexit_xfd_state();
    10816 
    10817         static_call(kvm_x86_handle_exit_irqoff)(vcpu);
    10818 
    10819         if (vcpu->arch.guest_fpu.xfd_err)
    10820                 wrmsrl(MSR_IA32_XFD_ERR, 0);
    10821 
    10822         /*
    10823          * Consume any pending interrupts, including the possible source of
    10824          * VM-Exit on SVM and any ticks that occur between VM-Exit and now.
    10825          * An instruction is required after local_irq_enable() to fully unblock
    10826          * interrupts on processors that implement an interrupt shadow, the
    10827          * stat.exits increment will do nicely.
    10828          */
    10829         kvm_before_interrupt(vcpu, KVM_HANDLING_IRQ);
    10830         local_irq_enable();
    10831         ++vcpu->stat.exits;
    10832         local_irq_disable();
    10833         kvm_after_interrupt(vcpu);
    10834 
    10835         /*
    10836          * Wait until after servicing IRQs to account guest time so that any
    10837          * ticks that occurred while running the guest are properly accounted
    10838          * to the guest.  Waiting until IRQs are enabled degrades the accuracy
    10839          * of accounting via context tracking, but the loss of accuracy is
    10840          * acceptable for all known use cases.
    10841          */
    10842         guest_timing_exit_irqoff();
    10843 
    10844         local_irq_enable();
    10845         preempt_enable();
    10846 
    10847         kvm_vcpu_srcu_read_lock(vcpu);
    10848 
    10849         /*
    10850          * Profile KVM exit RIPs:
    10851          */
    10852         if (unlikely(prof_on == KVM_PROFILING)) {
    10853                 unsigned long rip = kvm_rip_read(vcpu);
    10854                 profile_hit(KVM_PROFILING, (void *)rip);
    10855         }
    10856 
    10857         if (unlikely(vcpu->arch.tsc_always_catchup))
    10858                 kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
    10859 
    10860         if (vcpu->arch.apic_attention)
    10861                 kvm_lapic_sync_from_vapic(vcpu);
    10862 
    10863         r = static_call(kvm_x86_handle_exit)(vcpu, exit_fastpath);
    10864         return r;
    10865 
    10866 cancel_injection:
    10867         if (req_immediate_exit)
    10868                 kvm_make_request(KVM_REQ_EVENT, vcpu);
    10869         static_call(kvm_x86_cancel_injection)(vcpu);
    10870         if (unlikely(vcpu->arch.apic_attention))
    10871                 kvm_lapic_sync_from_vapic(vcpu);
    10872 out:
--> 10873         return r;
    10874 }

regards,
dan carpenter
