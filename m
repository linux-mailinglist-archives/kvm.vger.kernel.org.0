Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4A4D45F5B6
	for <lists+kvm@lfdr.de>; Fri, 26 Nov 2021 21:17:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240506AbhKZUUh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Nov 2021 15:20:37 -0500
Received: from mga11.intel.com ([192.55.52.93]:59589 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233186AbhKZUSd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Nov 2021 15:18:33 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10180"; a="233207745"
X-IronPort-AV: E=Sophos;i="5.87,266,1631602800"; 
   d="scan'208";a="233207745"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2021 12:15:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,266,1631602800"; 
   d="scan'208";a="607979028"
Received: from lkp-server02.sh.intel.com (HELO 9e1e9f9b3bcb) ([10.239.97.151])
  by orsmga004.jf.intel.com with ESMTP; 26 Nov 2021 12:15:15 -0800
Received: from kbuild by 9e1e9f9b3bcb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1mqhco-0008YA-L7; Fri, 26 Nov 2021 20:15:14 +0000
Date:   Sat, 27 Nov 2021 04:14:33 +0800
From:   kernel test robot <lkp@intel.com>
To:     David Woodhouse <dwmw2@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm <kvm@vger.kernel.org>
Cc:     kbuild-all@lists.01.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        "jmattson @ google . com" <jmattson@google.com>,
        "wanpengli @ tencent . com" <wanpengli@tencent.com>,
        "seanjc @ google . com" <seanjc@google.com>,
        "vkuznets @ redhat . com" <vkuznets@redhat.com>,
        "mtosatti @ redhat . com" <mtosatti@redhat.com>,
        "joro @ 8bytes . org" <joro@8bytes.org>
Subject: Re: [PATCH v5 12/12] KVM: x86: First attempt at converting nested
 virtual APIC page to gpc
Message-ID: <202111270405.fmQ2HTy9-lkp@intel.com>
References: <20211121125451.9489-13-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211121125451.9489-13-dwmw2@infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi David,

I love your patch! Perhaps something to improve:

[auto build test WARNING on linus/master]
[also build test WARNING on v5.16-rc2]
[cannot apply to kvm/queue kvms390/next powerpc/topic/ppc-kvm kvmarm/next mst-vhost/linux-next next-20211126]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/David-Woodhouse/KVM-x86-xen-Add-in-kernel-Xen-event-channel-delivery/20211121-205657
base:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git 923dcc5eb0c111eccd51cc7ce1658537e3c38b25
config: x86_64-randconfig-r024-20211126 (https://download.01.org/0day-ci/archive/20211127/202111270405.fmQ2HTy9-lkp@intel.com/config)
compiler: gcc-9 (Debian 9.3.0-22) 9.3.0
reproduce (this is a W=1 build):
        # https://github.com/0day-ci/linux/commit/21f06a7b7c4145cff195635eee12d43625610fb4
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review David-Woodhouse/KVM-x86-xen-Add-in-kernel-Xen-event-channel-delivery/20211121-205657
        git checkout 21f06a7b7c4145cff195635eee12d43625610fb4
        # save the config file to linux build tree
        mkdir build_dir
        make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash arch/x86/kvm/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   arch/x86/kvm/x86.c: In function 'vcpu_enter_guest':
>> arch/x86/kvm/x86.c:9743:4: warning: suggest braces around empty body in an 'if' statement [-Wempty-body]
    9743 |    ; /* Nothing to do. It just wanted to wake us */
         |    ^


vim +/if +9743 arch/x86/kvm/x86.c

  9593	
  9594	/*
  9595	 * Returns 1 to let vcpu_run() continue the guest execution loop without
  9596	 * exiting to the userspace.  Otherwise, the value will be returned to the
  9597	 * userspace.
  9598	 */
  9599	static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
  9600	{
  9601		int r;
  9602		bool req_int_win =
  9603			dm_request_for_irq_injection(vcpu) &&
  9604			kvm_cpu_accept_dm_intr(vcpu);
  9605		fastpath_t exit_fastpath;
  9606	
  9607		bool req_immediate_exit = false;
  9608	
  9609		/* Forbid vmenter if vcpu dirty ring is soft-full */
  9610		if (unlikely(vcpu->kvm->dirty_ring_size &&
  9611			     kvm_dirty_ring_soft_full(&vcpu->dirty_ring))) {
  9612			vcpu->run->exit_reason = KVM_EXIT_DIRTY_RING_FULL;
  9613			trace_kvm_dirty_ring_exit(vcpu);
  9614			r = 0;
  9615			goto out;
  9616		}
  9617	
  9618		if (kvm_request_pending(vcpu)) {
  9619			if (kvm_check_request(KVM_REQ_VM_DEAD, vcpu)) {
  9620				r = -EIO;
  9621				goto out;
  9622			}
  9623			if (kvm_check_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu)) {
  9624				if (unlikely(!kvm_x86_ops.nested_ops->get_nested_state_pages(vcpu))) {
  9625					r = 0;
  9626					goto out;
  9627				}
  9628			}
  9629			if (kvm_check_request(KVM_REQ_MMU_RELOAD, vcpu))
  9630				kvm_mmu_unload(vcpu);
  9631			if (kvm_check_request(KVM_REQ_MIGRATE_TIMER, vcpu))
  9632				__kvm_migrate_timers(vcpu);
  9633			if (kvm_check_request(KVM_REQ_MASTERCLOCK_UPDATE, vcpu))
  9634				kvm_update_masterclock(vcpu->kvm);
  9635			if (kvm_check_request(KVM_REQ_GLOBAL_CLOCK_UPDATE, vcpu))
  9636				kvm_gen_kvmclock_update(vcpu);
  9637			if (kvm_check_request(KVM_REQ_CLOCK_UPDATE, vcpu)) {
  9638				r = kvm_guest_time_update(vcpu);
  9639				if (unlikely(r))
  9640					goto out;
  9641			}
  9642			if (kvm_check_request(KVM_REQ_MMU_SYNC, vcpu))
  9643				kvm_mmu_sync_roots(vcpu);
  9644			if (kvm_check_request(KVM_REQ_LOAD_MMU_PGD, vcpu))
  9645				kvm_mmu_load_pgd(vcpu);
  9646			if (kvm_check_request(KVM_REQ_TLB_FLUSH, vcpu)) {
  9647				kvm_vcpu_flush_tlb_all(vcpu);
  9648	
  9649				/* Flushing all ASIDs flushes the current ASID... */
  9650				kvm_clear_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
  9651			}
  9652			if (kvm_check_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu))
  9653				kvm_vcpu_flush_tlb_current(vcpu);
  9654			if (kvm_check_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu))
  9655				kvm_vcpu_flush_tlb_guest(vcpu);
  9656	
  9657			if (kvm_check_request(KVM_REQ_REPORT_TPR_ACCESS, vcpu)) {
  9658				vcpu->run->exit_reason = KVM_EXIT_TPR_ACCESS;
  9659				r = 0;
  9660				goto out;
  9661			}
  9662			if (kvm_check_request(KVM_REQ_TRIPLE_FAULT, vcpu)) {
  9663				if (is_guest_mode(vcpu)) {
  9664					kvm_x86_ops.nested_ops->triple_fault(vcpu);
  9665				} else {
  9666					vcpu->run->exit_reason = KVM_EXIT_SHUTDOWN;
  9667					vcpu->mmio_needed = 0;
  9668					r = 0;
  9669					goto out;
  9670				}
  9671			}
  9672			if (kvm_check_request(KVM_REQ_APF_HALT, vcpu)) {
  9673				/* Page is swapped out. Do synthetic halt */
  9674				vcpu->arch.apf.halted = true;
  9675				r = 1;
  9676				goto out;
  9677			}
  9678			if (kvm_check_request(KVM_REQ_STEAL_UPDATE, vcpu))
  9679				record_steal_time(vcpu);
  9680			if (kvm_check_request(KVM_REQ_SMI, vcpu))
  9681				process_smi(vcpu);
  9682			if (kvm_check_request(KVM_REQ_NMI, vcpu))
  9683				process_nmi(vcpu);
  9684			if (kvm_check_request(KVM_REQ_PMU, vcpu))
  9685				kvm_pmu_handle_event(vcpu);
  9686			if (kvm_check_request(KVM_REQ_PMI, vcpu))
  9687				kvm_pmu_deliver_pmi(vcpu);
  9688			if (kvm_check_request(KVM_REQ_IOAPIC_EOI_EXIT, vcpu)) {
  9689				BUG_ON(vcpu->arch.pending_ioapic_eoi > 255);
  9690				if (test_bit(vcpu->arch.pending_ioapic_eoi,
  9691					     vcpu->arch.ioapic_handled_vectors)) {
  9692					vcpu->run->exit_reason = KVM_EXIT_IOAPIC_EOI;
  9693					vcpu->run->eoi.vector =
  9694							vcpu->arch.pending_ioapic_eoi;
  9695					r = 0;
  9696					goto out;
  9697				}
  9698			}
  9699			if (kvm_check_request(KVM_REQ_SCAN_IOAPIC, vcpu))
  9700				vcpu_scan_ioapic(vcpu);
  9701			if (kvm_check_request(KVM_REQ_LOAD_EOI_EXITMAP, vcpu))
  9702				vcpu_load_eoi_exitmap(vcpu);
  9703			if (kvm_check_request(KVM_REQ_APIC_PAGE_RELOAD, vcpu))
  9704				kvm_vcpu_reload_apic_access_page(vcpu);
  9705			if (kvm_check_request(KVM_REQ_HV_CRASH, vcpu)) {
  9706				vcpu->run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
  9707				vcpu->run->system_event.type = KVM_SYSTEM_EVENT_CRASH;
  9708				r = 0;
  9709				goto out;
  9710			}
  9711			if (kvm_check_request(KVM_REQ_HV_RESET, vcpu)) {
  9712				vcpu->run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
  9713				vcpu->run->system_event.type = KVM_SYSTEM_EVENT_RESET;
  9714				r = 0;
  9715				goto out;
  9716			}
  9717			if (kvm_check_request(KVM_REQ_HV_EXIT, vcpu)) {
  9718				struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
  9719	
  9720				vcpu->run->exit_reason = KVM_EXIT_HYPERV;
  9721				vcpu->run->hyperv = hv_vcpu->exit;
  9722				r = 0;
  9723				goto out;
  9724			}
  9725	
  9726			/*
  9727			 * KVM_REQ_HV_STIMER has to be processed after
  9728			 * KVM_REQ_CLOCK_UPDATE, because Hyper-V SynIC timers
  9729			 * depend on the guest clock being up-to-date
  9730			 */
  9731			if (kvm_check_request(KVM_REQ_HV_STIMER, vcpu))
  9732				kvm_hv_process_stimers(vcpu);
  9733			if (kvm_check_request(KVM_REQ_APICV_UPDATE, vcpu))
  9734				kvm_vcpu_update_apicv(vcpu);
  9735			if (kvm_check_request(KVM_REQ_APF_READY, vcpu))
  9736				kvm_check_async_pf_completion(vcpu);
  9737			if (kvm_check_request(KVM_REQ_MSR_FILTER_CHANGED, vcpu))
  9738				static_call(kvm_x86_msr_filter_changed)(vcpu);
  9739	
  9740			if (kvm_check_request(KVM_REQ_UPDATE_CPU_DIRTY_LOGGING, vcpu))
  9741				static_call(kvm_x86_update_cpu_dirty_logging)(vcpu);
  9742			if (kvm_check_request(KVM_REQ_GPC_INVALIDATE, vcpu))
> 9743				; /* Nothing to do. It just wanted to wake us */
  9744		}
  9745	
  9746		if (kvm_check_request(KVM_REQ_EVENT, vcpu) || req_int_win ||
  9747		    kvm_xen_has_interrupt(vcpu)) {
  9748			++vcpu->stat.req_event;
  9749			r = kvm_apic_accept_events(vcpu);
  9750			if (r < 0) {
  9751				r = 0;
  9752				goto out;
  9753			}
  9754			if (vcpu->arch.mp_state == KVM_MP_STATE_INIT_RECEIVED) {
  9755				r = 1;
  9756				goto out;
  9757			}
  9758	
  9759			r = inject_pending_event(vcpu, &req_immediate_exit);
  9760			if (r < 0) {
  9761				r = 0;
  9762				goto out;
  9763			}
  9764			if (req_int_win)
  9765				static_call(kvm_x86_enable_irq_window)(vcpu);
  9766	
  9767			if (kvm_lapic_enabled(vcpu)) {
  9768				update_cr8_intercept(vcpu);
  9769				kvm_lapic_sync_to_vapic(vcpu);
  9770			}
  9771		}
  9772	
  9773		r = kvm_mmu_reload(vcpu);
  9774		if (unlikely(r)) {
  9775			goto cancel_injection;
  9776		}
  9777	
  9778		preempt_disable();
  9779	
  9780		static_call(kvm_x86_prepare_guest_switch)(vcpu);
  9781	
  9782		/*
  9783		 * Disable IRQs before setting IN_GUEST_MODE.  Posted interrupt
  9784		 * IPI are then delayed after guest entry, which ensures that they
  9785		 * result in virtual interrupt delivery.
  9786		 */
  9787		local_irq_disable();
  9788		vcpu->mode = IN_GUEST_MODE;
  9789	
  9790		/*
  9791		 * If the guest requires direct access to mapped L1 pages, check
  9792		 * the caches are valid. Will raise KVM_REQ_GET_NESTED_STATE_PAGES
  9793		 * to go and revalidate them, if necessary.
  9794		 */
  9795		if (is_guest_mode(vcpu) && kvm_x86_ops.nested_ops->check_guest_maps)
  9796			kvm_x86_ops.nested_ops->check_guest_maps(vcpu);
  9797	
  9798		srcu_read_unlock(&vcpu->kvm->srcu, vcpu->srcu_idx);
  9799	
  9800		/*
  9801		 * 1) We should set ->mode before checking ->requests.  Please see
  9802		 * the comment in kvm_vcpu_exiting_guest_mode().
  9803		 *
  9804		 * 2) For APICv, we should set ->mode before checking PID.ON. This
  9805		 * pairs with the memory barrier implicit in pi_test_and_set_on
  9806		 * (see vmx_deliver_posted_interrupt).
  9807		 *
  9808		 * 3) This also orders the write to mode from any reads to the page
  9809		 * tables done while the VCPU is running.  Please see the comment
  9810		 * in kvm_flush_remote_tlbs.
  9811		 */
  9812		smp_mb__after_srcu_read_unlock();
  9813	
  9814		/*
  9815		 * This handles the case where a posted interrupt was
  9816		 * notified with kvm_vcpu_kick.
  9817		 */
  9818		if (kvm_lapic_enabled(vcpu) && vcpu->arch.apicv_active)
  9819			static_call(kvm_x86_sync_pir_to_irr)(vcpu);
  9820	
  9821		if (kvm_vcpu_exit_request(vcpu)) {
  9822			vcpu->mode = OUTSIDE_GUEST_MODE;
  9823			smp_wmb();
  9824			local_irq_enable();
  9825			preempt_enable();
  9826			vcpu->srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
  9827			r = 1;
  9828			goto cancel_injection;
  9829		}
  9830	
  9831		if (req_immediate_exit) {
  9832			kvm_make_request(KVM_REQ_EVENT, vcpu);
  9833			static_call(kvm_x86_request_immediate_exit)(vcpu);
  9834		}
  9835	
  9836		fpregs_assert_state_consistent();
  9837		if (test_thread_flag(TIF_NEED_FPU_LOAD))
  9838			switch_fpu_return();
  9839	
  9840		if (unlikely(vcpu->arch.switch_db_regs)) {
  9841			set_debugreg(0, 7);
  9842			set_debugreg(vcpu->arch.eff_db[0], 0);
  9843			set_debugreg(vcpu->arch.eff_db[1], 1);
  9844			set_debugreg(vcpu->arch.eff_db[2], 2);
  9845			set_debugreg(vcpu->arch.eff_db[3], 3);
  9846		} else if (unlikely(hw_breakpoint_active())) {
  9847			set_debugreg(0, 7);
  9848		}
  9849	
  9850		for (;;) {
  9851			/*
  9852			 * Assert that vCPU vs. VM APICv state is consistent.  An APICv
  9853			 * update must kick and wait for all vCPUs before toggling the
  9854			 * per-VM state, and responsing vCPUs must wait for the update
  9855			 * to complete before servicing KVM_REQ_APICV_UPDATE.
  9856			 */
  9857			WARN_ON_ONCE(kvm_apicv_activated(vcpu->kvm) != kvm_vcpu_apicv_active(vcpu));
  9858	
  9859			exit_fastpath = static_call(kvm_x86_run)(vcpu);
  9860			if (likely(exit_fastpath != EXIT_FASTPATH_REENTER_GUEST))
  9861				break;
  9862	
  9863			if (vcpu->arch.apicv_active)
  9864				static_call(kvm_x86_sync_pir_to_irr)(vcpu);
  9865	
  9866			if (unlikely(kvm_vcpu_exit_request(vcpu))) {
  9867				exit_fastpath = EXIT_FASTPATH_EXIT_HANDLED;
  9868				break;
  9869			}
  9870		}
  9871	
  9872		/*
  9873		 * Do this here before restoring debug registers on the host.  And
  9874		 * since we do this before handling the vmexit, a DR access vmexit
  9875		 * can (a) read the correct value of the debug registers, (b) set
  9876		 * KVM_DEBUGREG_WONT_EXIT again.
  9877		 */
  9878		if (unlikely(vcpu->arch.switch_db_regs & KVM_DEBUGREG_WONT_EXIT)) {
  9879			WARN_ON(vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP);
  9880			static_call(kvm_x86_sync_dirty_debug_regs)(vcpu);
  9881			kvm_update_dr0123(vcpu);
  9882			kvm_update_dr7(vcpu);
  9883		}
  9884	
  9885		/*
  9886		 * If the guest has used debug registers, at least dr7
  9887		 * will be disabled while returning to the host.
  9888		 * If we don't have active breakpoints in the host, we don't
  9889		 * care about the messed up debug address registers. But if
  9890		 * we have some of them active, restore the old state.
  9891		 */
  9892		if (hw_breakpoint_active())
  9893			hw_breakpoint_restore();
  9894	
  9895		vcpu->arch.last_vmentry_cpu = vcpu->cpu;
  9896		vcpu->arch.last_guest_tsc = kvm_read_l1_tsc(vcpu, rdtsc());
  9897	
  9898		vcpu->mode = OUTSIDE_GUEST_MODE;
  9899		smp_wmb();
  9900	
  9901		static_call(kvm_x86_handle_exit_irqoff)(vcpu);
  9902	
  9903		/*
  9904		 * Consume any pending interrupts, including the possible source of
  9905		 * VM-Exit on SVM and any ticks that occur between VM-Exit and now.
  9906		 * An instruction is required after local_irq_enable() to fully unblock
  9907		 * interrupts on processors that implement an interrupt shadow, the
  9908		 * stat.exits increment will do nicely.
  9909		 */
  9910		kvm_before_interrupt(vcpu);
  9911		local_irq_enable();
  9912		++vcpu->stat.exits;
  9913		local_irq_disable();
  9914		kvm_after_interrupt(vcpu);
  9915	
  9916		/*
  9917		 * Wait until after servicing IRQs to account guest time so that any
  9918		 * ticks that occurred while running the guest are properly accounted
  9919		 * to the guest.  Waiting until IRQs are enabled degrades the accuracy
  9920		 * of accounting via context tracking, but the loss of accuracy is
  9921		 * acceptable for all known use cases.
  9922		 */
  9923		vtime_account_guest_exit();
  9924	
  9925		if (lapic_in_kernel(vcpu)) {
  9926			s64 delta = vcpu->arch.apic->lapic_timer.advance_expire_delta;
  9927			if (delta != S64_MIN) {
  9928				trace_kvm_wait_lapic_expire(vcpu->vcpu_id, delta);
  9929				vcpu->arch.apic->lapic_timer.advance_expire_delta = S64_MIN;
  9930			}
  9931		}
  9932	
  9933		local_irq_enable();
  9934		preempt_enable();
  9935	
  9936		vcpu->srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
  9937	
  9938		/*
  9939		 * Profile KVM exit RIPs:
  9940		 */
  9941		if (unlikely(prof_on == KVM_PROFILING)) {
  9942			unsigned long rip = kvm_rip_read(vcpu);
  9943			profile_hit(KVM_PROFILING, (void *)rip);
  9944		}
  9945	
  9946		if (unlikely(vcpu->arch.tsc_always_catchup))
  9947			kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
  9948	
  9949		if (vcpu->arch.apic_attention)
  9950			kvm_lapic_sync_from_vapic(vcpu);
  9951	
  9952		r = static_call(kvm_x86_handle_exit)(vcpu, exit_fastpath);
  9953		return r;
  9954	
  9955	cancel_injection:
  9956		if (req_immediate_exit)
  9957			kvm_make_request(KVM_REQ_EVENT, vcpu);
  9958		static_call(kvm_x86_cancel_injection)(vcpu);
  9959		if (unlikely(vcpu->arch.apic_attention))
  9960			kvm_lapic_sync_from_vapic(vcpu);
  9961	out:
  9962		return r;
  9963	}
  9964	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
