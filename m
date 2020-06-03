Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A76FF1ED51B
	for <lists+kvm@lfdr.de>; Wed,  3 Jun 2020 19:39:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726213AbgFCRjK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Jun 2020 13:39:10 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:45850 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726148AbgFCRjK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Jun 2020 13:39:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591205945;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=/vEBO1IrJGzl6O7vI7ZYQg1K/9Egm537VwPehzExGCc=;
        b=Qqk/+QMIdl93ZpI2rd/Kr+NqWIXbJjZ9fUoXpToXt1xNDGqqKExYB0phSeuAdKwCIkJUac
        p9oLshabeZwMxJMApTZvnYpEDCeIVvKQAjNlmIECirgW7uNEsiTixnFQVVV/tObJU04F+V
        a0gyXL7ZJIq391nzK1+ND26jPn72dzw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-41-rHcWdWWcN76iHawECVBvPw-1; Wed, 03 Jun 2020 13:38:59 -0400
X-MC-Unique: rHcWdWWcN76iHawECVBvPw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CF8B5EC1A1;
        Wed,  3 Jun 2020 17:38:58 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5B65A5D9DA;
        Wed,  3 Jun 2020 17:38:58 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] First batch of KVM changes for Linux 5.8
Date:   Wed,  3 Jun 2020 13:38:57 -0400
Message-Id: <20200603173857.1345-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit 6553896666433e7efec589838b400a2a652b3ffa:

  vmlinux.lds.h: Create section for protection against instrumentation (2020-05-19 15:47:20 +0200)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 13ffbd8db1dd43d63d086517872a4e702a6bf309:

  KVM: selftests: fix rdtsc() for vmx_tsc_adjust_test (2020-06-01 11:58:23 -0400)

----------------------------------------------------------------
ARM:
- Move the arch-specific code into arch/arm64/kvm
- Start the post-32bit cleanup
- Cherry-pick a few non-invasive pre-NV patches

x86:
- Rework of TLB flushing
- Rework of event injection, especially with respect to nested virtualization
- Nested AMD event injection facelift, building on the rework of generic code
and fixing a lot of corner cases
- Nested AMD live migration support
- Optimization for TSC deadline MSR writes and IPIs
- Various cleanups
- Asynchronous page fault cleanups (from tglx, common topic branch with tip tree)
- Interrupt-based delivery of asynchronous "page ready" events (host side)
- Hyper-V MSRs and hypercalls for guest debugging
- VMX preemption timer fixes

s390:
- Cleanups

Generic:
- switch vCPU thread wakeup from swait to rcuwait

The other architectures, and the guest side of the asynchronous page fault
work, will come next week.

----------------------------------------------------------------

There could be minor conflicts depending on the order you're processing 5.8
pull requests.

Andrew Scull (1):
      KVM: arm64: Remove obsolete kvm_virt_to_phys abstraction

Andy Lutomirski (1):
      x86/kvm: Handle async page faults directly through do_page_fault()

Cathy Avery (1):
      KVM: SVM: Implement check_nested_events for NMI

Christoffer Dall (1):
      KVM: arm64: vgic-v3: Take cpu_if pointer directly instead of vcpu

Colin Ian King (1):
      KVM: remove redundant assignment to variable r

David Brazdil (2):
      KVM: arm64: Clean up cpu_init_hyp_mode()
      KVM: arm64: Fix incorrect comment on kvm_get_hyp_vector()

David Hildenbrand (2):
      KVM: s390: vsie: Move conditional reschedule
      KVM: s390: vsie: gmap_table_walk() simplifications

David Matlack (2):
      kvm: add capability for halt polling
      kvm: add halt-polling cpu usage stats

Davidlohr Bueso (5):
      rcuwait: Fix stale wake call name in comment
      rcuwait: Let rcuwait_wake_up() return whether or not a task was awoken
      rcuwait: Introduce prepare_to and finish_rcuwait
      rcuwait: Introduce rcuwait_active()
      kvm: Replace vcpu->swait with rcuwait

Emanuele Giuseppe Esposito (1):
      kvm_host: unify VM_STAT and VCPU_STAT definitions in a single place

Eric Northup (1):
      KVM: pass through CPUID(0x80000006)

Fuad Tabba (2):
      KVM: arm64: Clean up kvm makefiles
      KVM: Fix spelling in code comments

Gustavo A. R. Silva (1):
      KVM: VMX: Replace zero-length array with flexible-array

Haiwei Li (1):
      KVM: Fix the indentation to match coding style

Jason Yan (2):
      KVM: s390: remove unneeded semicolon in gisa_vcpu_kicker()
      kvm/eventfd: remove unneeded conversion to bool

Jiang Yi (1):
      KVM: arm/arm64: Release kvm->mmu_lock in loop to prevent starvation

Jim Mattson (3):
      KVM: nVMX: Really make emulated nested preemption timer pinned
      KVM: nVMX: Change emulated VMX-preemption timer hrtimer to absolute
      KVM: nVMX: Migrate the VMX-preemption timer

Jon Doron (5):
      x86/kvm/hyper-v: Explicitly align hcall param for kvm_hyperv_exit
      x86/hyper-v: Add synthetic debugger definitions
      x86/kvm/hyper-v: Add support for synthetic debugger interface
      x86/kvm/hyper-v: enable hypercalls regardless of hypercall page
      x86/kvm/hyper-v: Add support for synthetic debugger via hypercalls

Junaid Shahid (2):
      KVM: nVMX: Invalidate all roots when emulating INVVPID without EPT
      KVM: x86: Sync SPTEs when injecting page/EPT fault into L1

Keqian Zhu (1):
      KVM: arm64: Support enabling dirty log gradually in small chunks

Krish Sadhukhan (1):
      KVM: nSVM: Check for CR0.CD and CR0.NW on VMRUN of nested guests

Like Xu (1):
      KVM: x86/pmu: Support full width counting

Makarand Sonare (1):
      KVM: selftests: VMX preemption timer migration test

Marc Zyngier (10):
      KVM: arm64: Move virt/kvm/arm to arch/arm64
      KVM: arm64: Simplify __kvm_timer_set_cntvoff implementation
      KVM: arm64: Use cpus_have_final_cap for has_vhe()
      KVM: arm64: Make KVM_CAP_MAX_VCPUS compatible with the selected GIC version
      KVM: arm64: Refactor vcpu_{read,write}_sys_reg
      KVM: arm64: Add missing reset handlers for PMU emulation
      KVM: arm64: Move sysreg reset check to boot time
      KVM: arm64: Don't use empty structures as CPU reset state
      KVM: arm64: Parametrize exception entry with a target EL
      KVM: arm64: Drop obsolete comment about sys_reg ordering

Maxim Levitsky (2):
      KVM: VMX: enable X86_FEATURE_WAITPKG in KVM capabilities
      KVM: x86: don't expose MSR_IA32_UMWAIT_CONTROL unconditionally

Miaohe Lin (1):
      KVM: VMX: replace "fall through" with "return" to indicate different case

Paolo Bonzini (65):
      KVM: x86: introduce kvm_mmu_invalidate_gva
      KVM: x86: cleanup kvm_inject_emulated_page_fault
      KVM: x86: move kvm_create_vcpu_debugfs after last failure point
      KVM: x86/mmu: Avoid an extra memslot lookup in try_async_pf() for L2
      KVM: SVM: avoid infinite loop on NPF from bad address
      selftests: kvm/set_memory_region_test: do not check RIP if the guest shuts down
      KVM: x86: check_nested_events is never NULL
      KVM: eVMCS: check if nesting is enabled
      KVM: x86: move nested-related kvm_x86_ops to a separate struct
      KVM: SVM: do not allow VMRUN inside SMM
      Merge branch 'kvm-amd-fixes' into HEAD
      KVM: SVM: introduce nested_run_pending
      KVM: SVM: leave halted state on vmexit
      KVM: SVM: immediately inject INTR vmexit
      KVM: x86: replace is_smm checks with kvm_x86_ops.smi_allowed
      KVM: nSVM: Report NMIs as allowed when in L2 and Exit-on-NMI is set
      KVM: nSVM: Move SMI vmexit handling to svm_check_nested_events()
      KVM: SVM: Split out architectural interrupt/NMI/SMI blocking checks
      KVM: nSVM: Report interrupts as allowed when in L2 and exit-on-interrupt is set
      KVM: nSVM: Preserve IRQ/NMI/SMI priority irrespective of exiting behavior
      KVM: x86: Replace late check_nested_events() hack with more precise fix
      KVM: x86: handle wrap around 32-bit address space
      KVM: x86: introduce kvm_can_use_hv_timer
      KVM: x86: only do L1TF workaround on affected processors
      rcuwait: avoid lockdep splats from rcuwait_active()
      Merge tag 'noinstr-x86-kvm-2020-05-16' of git://git.kernel.org/.../tip/tip into HEAD
      KVM: x86: simplify is_mmio_spte
      Merge tag 'kvm-s390-next-5.8-1' of git://git.kernel.org/.../kvms390/linux into HEAD
      Merge branch 'kvm-master' into HEAD
      KVM: x86: allow KVM_STATE_NESTED_MTF_PENDING in kvm_state flags
      KVM: nSVM: fix condition for filtering async PF
      KVM: nSVM: leave ASID aside in copy_vmcb_control_area
      KVM: x86: track manually whether an event has been injected
      KVM: x86: enable event window in inject_pending_event
      KVM: nSVM: inject exceptions via svm_check_nested_events
      KVM: nSVM: remove exit_required
      KVM: nSVM: correctly inject INIT vmexits
      KVM: SVM: always update CR3 in VMCB
      KVM: nVMX: always update CR3 in VMCS
      KVM: check userspace_addr for all memslots
      KVM: nSVM: move map argument out of enter_svm_guest_mode
      KVM: nSVM: extract load_nested_vmcb_control
      KVM: nSVM: extract preparation of VMCB for nested run
      KVM: nSVM: move MMU setup to nested_prepare_vmcb_control
      KVM: nSVM: clean up tsc_offset update
      KVM: nSVM: pass vmcb_control_area to copy_vmcb_control_area
      KVM: nSVM: remove trailing padding for struct vmcb_control_area
      KVM: nSVM: save all control fields in svm->nested
      KVM: nSVM: restore clobbered INT_CTL fields after clearing VINTR
      KVM: nSVM: synchronize VMCB controls updated by the processor on every vmexit
      KVM: nSVM: remove unnecessary if
      KVM: nSVM: extract svm_set_gif
      KVM: SVM: preserve VGIF across VMCB switch
      KVM: nSVM: synthesize correct EXITINTINFO on vmexit
      KVM: nSVM: remove HF_VINTR_MASK
      KVM: nSVM: remove HF_HIF_MASK
      KVM: nSVM: split nested_vmcb_check_controls
      KVM: nSVM: leave guest mode when clearing EFER.SVME
      KVM: MMU: pass arbitrary CR0/CR4/EFER to kvm_init_shadow_mmu
      selftests: kvm: add a SVM version of state-test
      KVM: nSVM: implement KVM_GET_NESTED_STATE and KVM_SET_NESTED_STATE
      Revert "KVM: No need to retry for hva_to_pfn_remapped()"
      KVM: check userspace_addr for all memslots
      Merge tag 'kvmarm-5.8' of git://git.kernel.org/.../kvmarm/kvmarm into HEAD
      Merge branch 'kvm-master' into HEAD

Peter Shier (2):
      KVM: x86: Return updated timer current count register from KVM_GET_LAPIC
      KVM: nVMX: Fix VMX preemption timer migration

Peter Xu (4):
      KVM: X86: Force ASYNC_PF_PER_VCPU to be power of two
      KVM: No need to retry for hva_to_pfn_remapped()
      KVM: X86: Sanity check on gfn before removal
      KVM: Documentation: Fix up cpuid page

Peter Zijlstra (1):
      lockdep: Prepare for noinstr sections

Sean Christopherson (94):
      KVM: selftests: Take vcpu pointer instead of id in vm_vcpu_rm()
      KVM: selftests: Use kernel's list instead of homebrewed replacement
      KVM: selftests: Add util to delete memory region
      KVM: selftests: Add GUEST_ASSERT variants to pass values to host
      KVM: sefltests: Add explicit synchronization to move mem region test
      KVM: selftests: Add "delete" testcase to set_memory_region_test
      KVM: selftests: Add "zero" testcase to set_memory_region_test
      KVM: selftests: Make set_memory_region_test common to all architectures
      KVM: VMX: Flush all EPTP/VPID contexts on remote TLB flush
      KVM: nVMX: Validate the EPTP when emulating INVEPT(EXTENT_CONTEXT)
      KVM: nVMX: Invalidate all EPTP contexts when emulating INVEPT for L1
      KVM: x86: Export kvm_propagate_fault() (as kvm_inject_emulated_page_fault)
      KVM: VMX: Skip global INVVPID fallback if vpid==0 in vpid_sync_context()
      KVM: VMX: Use vpid_sync_context() directly when possible
      KVM: VMX: Move vpid_sync_vcpu_addr() down a few lines
      KVM: VMX: Handle INVVPID fallback logic in vpid_sync_vcpu_addr()
      KVM: VMX: Drop redundant capability checks in low level INVVPID helpers
      KVM: nVMX: Use vpid_sync_vcpu_addr() to emulate INVVPID with address
      KVM: x86: Move "flush guest's TLB" logic to separate kvm_x86_ops hook
      KVM: VMX: Clean up vmx_flush_tlb_gva()
      KVM: x86: Drop @invalidate_gpa param from kvm_x86_ops' tlb_flush()
      KVM: SVM: Wire up ->tlb_flush_guest() directly to svm_flush_tlb()
      KVM: VMX: Move vmx_flush_tlb() to vmx.c
      KVM: nVMX: Move nested_get_vpid02() to vmx/nested.h
      KVM: VMX: Introduce vmx_flush_tlb_current()
      KVM: SVM: Document the ASID logic in svm_flush_tlb()
      KVM: x86: Rename ->tlb_flush() to ->tlb_flush_all()
      KVM: nVMX: Add helper to handle TLB flushes on nested VM-Enter/VM-Exit
      KVM: x86: Introduce KVM_REQ_TLB_FLUSH_CURRENT to flush current ASID
      KVM: x86/mmu: Use KVM_REQ_TLB_FLUSH_CURRENT for MMU specific flushes
      KVM: nVMX: Selectively use TLB_FLUSH_CURRENT for nested VM-Enter/VM-Exit
      KVM: nVMX: Reload APIC access page on nested VM-Exit only if necessary
      KVM: VMX: Retrieve APIC access page HPA only when necessary
      KVM: VMX: Don't reload APIC access page if its control is disabled
      KVM: x86/mmu: Move fast_cr3_switch() side effects to __kvm_mmu_new_cr3()
      KVM: x86/mmu: Add separate override for MMU sync during fast CR3 switch
      KVM: x86/mmu: Add module param to force TLB flush on root reuse
      KVM: nVMX: Skip MMU sync on nested VMX transition when possible
      KVM: nVMX: Don't flush TLB on nested VMX transition
      KVM: nVMX: Free only the affected contexts when emulating INVEPT
      KVM: x86: Replace "cr3" with "pgd" in "new cr3/pgd" related code
      KVM: VMX: Clean cr3/pgd handling in vmx_load_mmu_pgd()
      KVM: nVMX: Move reflection check into nested_vmx_reflect_vmexit()
      KVM: nVMX: Uninline nested_vmx_reflect_vmexit(), i.e. move it to nested.c
      KVM: nVMX: Move VM-Fail check out of nested_vmx_exit_reflected()
      KVM: nVMX: Move nested VM-Exit tracepoint into nested_vmx_reflect_vmexit()
      KVM: nVMX: Split VM-Exit reflection logic into L0 vs. L1 wants
      KVM: nVMX: Drop a superfluous WARN on reflecting EXTERNAL_INTERRUPT
      KVM: nVMX: Pull exit_reason from vcpu_vmx in nested_vmx_reflect_vmexit()
      KVM: nVMX: Cast exit_reason to u16 to check for nested EXTERNAL_INTERRUPT
      KVM: nVMX: Rename exit_reason to vm_exit_reason for nested VM-Exit
      KVM: nVMX: Invoke ept_save_pdptrs() if and only if PAE paging is enabled
      KVM: nVMX: Reset register cache (available and dirty masks) on VMCS switch
      KVM: nVMX: Drop manual clearing of segment cache on nested VMCS switch
      KVM: VMX: Cache vmcs.EXIT_QUALIFICATION using arch avail_reg flags
      KVM: VMX: Cache vmcs.EXIT_INTR_INFO using arch avail_reg flags
      KVM: x86/mmu: Set @writable to false for non-visible accesses by L2
      KVM: nVMX: Remove non-functional "support" for CR3 target values
      KVM: VMX: Optimize handling of VM-Entry failures in vmx_vcpu_run()
      KVM: nVMX: Drop a redundant call to vmx_get_intr_info()
      KVM: nVMX: Store vmcs.EXIT_QUALIFICATION as an unsigned long, not u32
      KVM: nVMX: Preserve exception priority irrespective of exiting behavior
      KVM: nVMX: Open a window for pending nested VMX preemption timer
      KVM: x86: Set KVM_REQ_EVENT if run is canceled with req_immediate_exit set
      KVM: x86: Make return for {interrupt_nmi,smi}_allowed() a bool instead of int
      KVM: nVMX: Report NMIs as allowed when in L2 and Exit-on-NMI is set
      KVM: VMX: Split out architectural interrupt/NMI blocking checks
      KVM: nVMX: Preserve IRQ/NMI priority irrespective of exiting behavior
      KVM: nVMX: Prioritize SMI over nested IRQ/NMI
      KVM: x86: WARN on injected+pending exception even in nested case
      KVM: VMX: Use vmx_interrupt_blocked() directly from vmx_handle_exit()
      KVM: VMX: Use vmx_get_rflags() to query RFLAGS in vmx_interrupt_blocked()
      KVM: VMX: Use accessor to read vmcs.INTR_INFO when handling exception
      KVM: nVMX: Skip IBPB when switching between vmcs01 and vmcs02
      KVM: nVMX: Skip IBPB when temporarily switching between vmcs01 and vmcs02
      KVM: x86: Save L1 TSC offset in 'struct kvm_vcpu_arch'
      KVM: nVMX: Unconditionally validate CR3 during nested transitions
      KVM: VMX: Add proper cache tracking for CR4
      KVM: VMX: Add proper cache tracking for CR0
      KVM: VMX: Move nested EPT out of kvm_x86_ops.get_tdp_level() hook
      KVM: x86/mmu: Capture TDP level when updating CPUID
      KVM: nVMX: Tweak handling of failure code for nested VM-Enter failure
      KVM: x86/mmu: Tweak PSE hugepage handling to avoid 2M vs 4M conundrum
      KVM: x86/mmu: Move max hugepage level to a separate #define
      KVM: x86/mmu: Drop KVM's hugepage enums in favor of the kernel's enums
      KVM: x86/mmu: Add a helper to consolidate root sp allocation
      KVM: nVMX: Truncate writes to vmcs.SYSENTER_EIP/ESP for 32-bit vCPU
      KVM: nVMX: Drop superfluous VMREAD of vmcs02.GUEST_SYSENTER_*
      KVM: x86: Print symbolic names of VMX VM-Exit flags in traces
      KVM: nVMX: Remove unused 'ops' param from nested_vmx_hardware_setup()
      KVM: x86/mmu: Set mmio_value to '0' if reserved #PF can't be generated
      KVM: x86: Remove superfluous brackets from case statement
      KVM: x86: Take an unsigned 32-bit int for has_emulated_msr()'s index
      KVM: x86: Initialize tdp_level during vCPU creation

Stefan Raspl (3):
      tools/kvm_stat: add command line switch '-z' to skip zero records
      tools/kvm_stat: Add command line switch '-L' to log to file
      tools/kvm_stat: add sample systemd unit file

Suravee Suthikulpanit (2):
      KVM: SVM: Merge svm_enable_vintr into svm_set_vintr
      KVM: SVM: Remove unnecessary V_IRQ unsetting

Suzuki K Poulose (2):
      KVM: arm64: Clean up the checking for huge mapping
      KVM: arm64: Unify handling THP backed host memory

Thomas Gleixner (4):
      tracing: Provide lockdep less trace_hardirqs_on/off() variants
      context_tracking: Make guest_enter/exit() .noinstr ready
      x86/kvm: Sanitize kvm_async_pf_task_wait()
      x86/kvm: Restrict ASYNC_PF to user space

Tianjia Zhang (1):
      KVM: Remove redundant argument to kvm_arch_vcpu_ioctl_run

Uros Bizjak (3):
      KVM: SVM: Use do_machine_check to pass MCE to the host
      KVM: VMX: Remove unneeded __ASM_SIZE usage with POP instruction
      KVM: VMX: Improve handle_external_interrupt_irqoff inline assembly

Vitaly Kuznetsov (13):
      KVM: x86: make Hyper-V PV TLB flush use tlb_flush_guest()
      KVM: nSVM: Preserve registers modifications done before nested_svm_vmexit()
      selftests: kvm: introduce cpu_has_svm() check
      selftests: kvm: fix smm test on SVM
      Revert "KVM: async_pf: Fix #DF due to inject "Page not Present" and "Page Ready" exceptions simultaneously"
      KVM: x86: extend struct kvm_vcpu_pv_apf_data with token info
      KVM: rename kvm_arch_can_inject_async_page_present() to kvm_arch_can_dequeue_async_page_present()
      KVM: introduce kvm_read_guest_offset_cached()
      KVM: x86: interrupt based APF 'page ready' event delivery
      KVM: x86: acknowledgment mechanism for async pf page ready notifications
      KVM: x86: announce KVM_FEATURE_ASYNC_PF_INT
      KVM: selftests: update hyperv_cpuid with SynDBG tests
      KVM: selftests: fix rdtsc() for vmx_tsc_adjust_test

Wainer dos Santos Moschetta (2):
      selftests: kvm: Add vm_get_fd() in kvm_util
      selftests: kvm: Add testcase for creating max number of memslots

Wanpeng Li (7):
      KVM: X86: Improve latency for single target IPI fastpath
      KVM: VMX: Introduce generic fastpath handler
      KVM: X86: Introduce kvm_vcpu_exit_request() helper
      KVM: X86: Introduce more exit_fastpath_completion enum values
      KVM: VMX: Optimize posted-interrupt delivery for timer fastpath
      KVM: X86: TSCDEADLINE MSR emulation fastpath
      KVM: VMX: Handle preemption timer fastpath

Wei Wang (1):
      KVM: x86/pmu: Tweak kvm_pmu_get_msr to pass 'struct msr_data' in

Will Deacon (3):
      KVM: arm64: Kill off CONFIG_KVM_ARM_HOST
      KVM: arm64: Update help text
      KVM: arm64: Change CONFIG_KVM to a menuconfig entry

Xiaoyao Li (1):
      kvm: x86: Cleanup vcpu->arch.guest_xstate_size

Zenghui Yu (1):
      KVM: arm64: Sidestep stage2_unmap_vm() on vcpu reset when S2FWB is supported

彭浩(Richard) (1):
      kvm/x86: Remove redundant function implementations

 Documentation/virt/kvm/api.rst                     |  41 +-
 Documentation/virt/kvm/cpuid.rst                   |   8 +-
 Documentation/virt/kvm/msr.rst                     | 119 +++-
 Documentation/virt/kvm/nested-vmx.rst              |   5 +-
 MAINTAINERS                                        |   1 -
 arch/arm64/include/asm/kvm_asm.h                   |   4 +-
 arch/arm64/include/asm/kvm_host.h                  |  46 +-
 arch/arm64/include/asm/kvm_hyp.h                   |  12 +-
 arch/arm64/include/asm/kvm_mmu.h                   |   4 +-
 arch/arm64/include/asm/ptrace.h                    |   1 +
 arch/arm64/include/asm/virt.h                      |   2 +-
 arch/arm64/kernel/asm-offsets.c                    |   2 +-
 arch/arm64/kernel/cpu_errata.c                     |   2 +-
 arch/arm64/kernel/smp.c                            |   2 +-
 arch/arm64/kvm/Kconfig                             |  22 +-
 arch/arm64/kvm/Makefile                            |  46 +-
 {virt/kvm/arm => arch/arm64/kvm}/aarch32.c         |   0
 {virt/kvm/arm => arch/arm64/kvm}/arch_timer.c      |  15 +-
 {virt/kvm/arm => arch/arm64/kvm}/arm.c             |  75 ++-
 arch/arm64/kvm/guest.c                             |  29 +-
 arch/arm64/kvm/handle_exit.c                       |   2 +-
 arch/arm64/kvm/hyp/Makefile                        |  16 +-
 {virt/kvm/arm => arch/arm64/kvm}/hyp/aarch32.c     |   0
 arch/arm64/kvm/hyp/switch.c                        |   8 +-
 {virt/kvm/arm => arch/arm64/kvm}/hyp/timer-sr.c    |   3 +-
 {virt/kvm/arm => arch/arm64/kvm}/hyp/vgic-v3-sr.c  |  39 +-
 {virt/kvm/arm => arch/arm64/kvm}/hypercalls.c      |   0
 arch/arm64/kvm/inject_fault.c                      |  75 +--
 {virt/kvm/arm => arch/arm64/kvm}/mmio.c            |   2 +-
 {virt/kvm/arm => arch/arm64/kvm}/mmu.c             | 148 +++--
 {virt/kvm/arm => arch/arm64/kvm}/perf.c            |   0
 virt/kvm/arm/pmu.c => arch/arm64/kvm/pmu-emul.c    |   0
 {virt/kvm/arm => arch/arm64/kvm}/psci.c            |   6 +-
 {virt/kvm/arm => arch/arm64/kvm}/pvtime.c          |   0
 arch/arm64/kvm/reset.c                             |  27 +-
 arch/arm64/kvm/sys_regs.c                          | 212 ++++---
 arch/arm64/kvm/trace.h                             | 216 +------
 virt/kvm/arm/trace.h => arch/arm64/kvm/trace_arm.h |  11 +-
 arch/arm64/kvm/trace_handle_exit.h                 | 215 +++++++
 arch/arm64/kvm/vgic-sys-reg-v3.c                   |   2 +-
 {virt/kvm/arm => arch/arm64/kvm}/vgic/trace.h      |   2 +-
 {virt/kvm/arm => arch/arm64/kvm}/vgic/vgic-debug.c |   0
 {virt/kvm/arm => arch/arm64/kvm}/vgic/vgic-init.c  |   0
 {virt/kvm/arm => arch/arm64/kvm}/vgic/vgic-irqfd.c |   0
 {virt/kvm/arm => arch/arm64/kvm}/vgic/vgic-its.c   |   0
 .../arm => arch/arm64/kvm}/vgic/vgic-kvm-device.c  |   0
 .../kvm/arm => arch/arm64/kvm}/vgic/vgic-mmio-v2.c |   0
 .../kvm/arm => arch/arm64/kvm}/vgic/vgic-mmio-v3.c |   0
 {virt/kvm/arm => arch/arm64/kvm}/vgic/vgic-mmio.c  |   0
 {virt/kvm/arm => arch/arm64/kvm}/vgic/vgic-mmio.h  |   0
 {virt/kvm/arm => arch/arm64/kvm}/vgic/vgic-v2.c    |  10 +-
 {virt/kvm/arm => arch/arm64/kvm}/vgic/vgic-v3.c    |  18 +-
 {virt/kvm/arm => arch/arm64/kvm}/vgic/vgic-v4.c    |   0
 {virt/kvm/arm => arch/arm64/kvm}/vgic/vgic.c       |  25 +-
 {virt/kvm/arm => arch/arm64/kvm}/vgic/vgic.h       |   0
 arch/mips/include/asm/kvm_host.h                   |   2 +
 arch/mips/kvm/mips.c                               |  72 +--
 arch/powerpc/include/asm/kvm_book3s.h              |   2 +-
 arch/powerpc/include/asm/kvm_host.h                |   2 +-
 arch/powerpc/kvm/book3s.c                          |  61 +-
 arch/powerpc/kvm/book3s_hv.c                       |  23 +-
 arch/powerpc/kvm/booke.c                           |  43 +-
 arch/powerpc/kvm/powerpc.c                         |   5 +-
 arch/s390/include/asm/kvm_host.h                   |   6 +-
 arch/s390/kvm/interrupt.c                          |   2 +-
 arch/s390/kvm/kvm-s390.c                           | 210 +++----
 arch/s390/kvm/vsie.c                               |   3 +-
 arch/s390/mm/gmap.c                                |  10 +-
 arch/x86/entry/entry_32.S                          |   8 -
 arch/x86/entry/entry_64.S                          |   4 -
 arch/x86/include/asm/hyperv-tlfs.h                 |   6 +
 arch/x86/include/asm/kvm_host.h                    | 138 ++--
 arch/x86/include/asm/kvm_para.h                    |  27 +-
 arch/x86/include/asm/svm.h                         |   9 +-
 arch/x86/include/asm/vmx.h                         |  10 +-
 arch/x86/include/asm/x86_init.h                    |   2 -
 arch/x86/include/uapi/asm/kvm.h                    |  20 +-
 arch/x86/include/uapi/asm/kvm_para.h               |  17 +-
 arch/x86/include/uapi/asm/vmx.h                    |   3 +
 arch/x86/kernel/kvm.c                              | 172 +++--
 arch/x86/kernel/traps.c                            |   2 -
 arch/x86/kernel/x86_init.c                         |   1 -
 arch/x86/kvm/cpuid.c                               |  15 +-
 arch/x86/kvm/cpuid.h                               |   5 +
 arch/x86/kvm/emulate.c                             |   2 +
 arch/x86/kvm/hyperv.c                              | 197 +++++-
 arch/x86/kvm/hyperv.h                              |  32 +
 arch/x86/kvm/ioapic.h                              |   8 +-
 arch/x86/kvm/irq.c                                 |   3 +
 arch/x86/kvm/irq.h                                 |  15 +-
 arch/x86/kvm/kvm_cache_regs.h                      |  10 +-
 arch/x86/kvm/lapic.c                               |  95 ++-
 arch/x86/kvm/lapic.h                               |   9 +-
 arch/x86/kvm/mmu.h                                 |   4 +-
 arch/x86/kvm/mmu/mmu.c                             | 517 ++++++++-------
 arch/x86/kvm/mmu/page_track.c                      |   4 +-
 arch/x86/kvm/mmu/paging_tmpl.h                     |  20 +-
 arch/x86/kvm/mmu_audit.c                           |   6 +-
 arch/x86/kvm/pmu.c                                 |   4 +-
 arch/x86/kvm/pmu.h                                 |   4 +-
 arch/x86/kvm/svm/nested.c                          | 681 +++++++++++++-------
 arch/x86/kvm/svm/pmu.c                             |   7 +-
 arch/x86/kvm/svm/svm.c                             | 404 +++++++-----
 arch/x86/kvm/svm/svm.h                             |  57 +-
 arch/x86/kvm/trace.h                               |  83 ++-
 arch/x86/kvm/vmx/capabilities.h                    |  11 +
 arch/x86/kvm/vmx/evmcs.c                           |  32 +-
 arch/x86/kvm/vmx/nested.c                          | 693 +++++++++++++--------
 arch/x86/kvm/vmx/nested.h                          |  49 +-
 arch/x86/kvm/vmx/ops.h                             |  32 +-
 arch/x86/kvm/vmx/pmu_intel.c                       |  71 ++-
 arch/x86/kvm/vmx/vmcs.h                            |   2 +-
 arch/x86/kvm/vmx/vmcs12.c                          |   4 -
 arch/x86/kvm/vmx/vmcs12.h                          |  10 +-
 arch/x86/kvm/vmx/vmenter.S                         |  14 +-
 arch/x86/kvm/vmx/vmx.c                             | 579 ++++++++++-------
 arch/x86/kvm/vmx/vmx.h                             |  64 +-
 arch/x86/kvm/x86.c                                 | 661 ++++++++++++--------
 arch/x86/kvm/x86.h                                 |   9 +-
 arch/x86/mm/fault.c                                |  19 +
 include/kvm/arm_vgic.h                             |   5 +-
 include/linux/context_tracking.h                   |  21 +-
 include/linux/irqflags.h                           |   6 +
 include/linux/kvm_host.h                           |  30 +-
 include/linux/rcuwait.h                            |  32 +-
 include/linux/sched.h                              |   1 +
 include/uapi/linux/kvm.h                           |  14 +
 kernel/exit.c                                      |   9 +-
 kernel/locking/lockdep.c                           |  86 ++-
 kernel/trace/trace_preemptirq.c                    |  39 ++
 lib/debug_locks.c                                  |   2 +-
 tools/arch/x86/include/uapi/asm/kvm.h              |   1 +
 tools/kvm/kvm_stat/kvm_stat                        |  84 ++-
 tools/kvm/kvm_stat/kvm_stat.service                |  16 +
 tools/kvm/kvm_stat/kvm_stat.txt                    |  15 +-
 tools/testing/selftests/kvm/.gitignore             |   3 +-
 tools/testing/selftests/kvm/Makefile               |   6 +-
 tools/testing/selftests/kvm/include/kvm_util.h     |  32 +-
 .../selftests/kvm/include/x86_64/processor.h       |  11 +-
 .../selftests/kvm/include/x86_64/svm_util.h        |  10 +
 tools/testing/selftests/kvm/include/x86_64/vmx.h   |  27 +
 tools/testing/selftests/kvm/lib/kvm_util.c         | 163 ++---
 .../testing/selftests/kvm/lib/kvm_util_internal.h  |   8 +-
 tools/testing/selftests/kvm/lib/s390x/processor.c  |   5 +-
 .../testing/selftests/kvm/set_memory_region_test.c | 408 ++++++++++++
 tools/testing/selftests/kvm/x86_64/debug_regs.c    | 202 ++++++
 tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c  | 103 +--
 .../selftests/kvm/x86_64/set_memory_region_test.c  | 141 -----
 tools/testing/selftests/kvm/x86_64/smm_test.c      |  19 +-
 tools/testing/selftests/kvm/x86_64/state_test.c    |  62 +-
 .../kvm/x86_64/vmx_preemption_timer_test.c         | 255 ++++++++
 virt/kvm/async_pf.c                                |  15 +-
 virt/kvm/coalesced_mmio.c                          |   2 +-
 virt/kvm/eventfd.c                                 |   4 +-
 virt/kvm/kvm_main.c                                | 111 ++--
 155 files changed, 5606 insertions(+), 3107 deletions(-)
 rename {virt/kvm/arm => arch/arm64/kvm}/aarch32.c (100%)
 rename {virt/kvm/arm => arch/arm64/kvm}/arch_timer.c (98%)
 rename {virt/kvm/arm => arch/arm64/kvm}/arm.c (94%)
 rename {virt/kvm/arm => arch/arm64/kvm}/hyp/aarch32.c (100%)
 rename {virt/kvm/arm => arch/arm64/kvm}/hyp/timer-sr.c (89%)
 rename {virt/kvm/arm => arch/arm64/kvm}/hyp/vgic-v3-sr.c (95%)
 rename {virt/kvm/arm => arch/arm64/kvm}/hypercalls.c (100%)
 rename {virt/kvm/arm => arch/arm64/kvm}/mmio.c (98%)
 rename {virt/kvm/arm => arch/arm64/kvm}/mmu.c (96%)
 rename {virt/kvm/arm => arch/arm64/kvm}/perf.c (100%)
 rename virt/kvm/arm/pmu.c => arch/arm64/kvm/pmu-emul.c (100%)
 rename {virt/kvm/arm => arch/arm64/kvm}/psci.c (98%)
 rename {virt/kvm/arm => arch/arm64/kvm}/pvtime.c (100%)
 rename virt/kvm/arm/trace.h => arch/arm64/kvm/trace_arm.h (97%)
 create mode 100644 arch/arm64/kvm/trace_handle_exit.h
 rename {virt/kvm/arm => arch/arm64/kvm}/vgic/trace.h (93%)
 rename {virt/kvm/arm => arch/arm64/kvm}/vgic/vgic-debug.c (100%)
 rename {virt/kvm/arm => arch/arm64/kvm}/vgic/vgic-init.c (100%)
 rename {virt/kvm/arm => arch/arm64/kvm}/vgic/vgic-irqfd.c (100%)
 rename {virt/kvm/arm => arch/arm64/kvm}/vgic/vgic-its.c (100%)
 rename {virt/kvm/arm => arch/arm64/kvm}/vgic/vgic-kvm-device.c (100%)
 rename {virt/kvm/arm => arch/arm64/kvm}/vgic/vgic-mmio-v2.c (100%)
 rename {virt/kvm/arm => arch/arm64/kvm}/vgic/vgic-mmio-v3.c (100%)
 rename {virt/kvm/arm => arch/arm64/kvm}/vgic/vgic-mmio.c (100%)
 rename {virt/kvm/arm => arch/arm64/kvm}/vgic/vgic-mmio.h (100%)
 rename {virt/kvm/arm => arch/arm64/kvm}/vgic/vgic-v2.c (98%)
 rename {virt/kvm/arm => arch/arm64/kvm}/vgic/vgic-v3.c (97%)
 rename {virt/kvm/arm => arch/arm64/kvm}/vgic/vgic-v4.c (100%)
 rename {virt/kvm/arm => arch/arm64/kvm}/vgic/vgic.c (97%)
 rename {virt/kvm/arm => arch/arm64/kvm}/vgic/vgic.h (100%)
 create mode 100644 tools/kvm/kvm_stat/kvm_stat.service
 create mode 100644 tools/testing/selftests/kvm/set_memory_region_test.c
 create mode 100644 tools/testing/selftests/kvm/x86_64/debug_regs.c
 delete mode 100644 tools/testing/selftests/kvm/x86_64/set_memory_region_test.c
 create mode 100644 tools/testing/selftests/kvm/x86_64/vmx_preemption_timer_test.c

