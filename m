Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2989223CF07
	for <lists+kvm@lfdr.de>; Wed,  5 Aug 2020 21:12:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729024AbgHETMT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Aug 2020 15:12:19 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:31772 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729241AbgHES1X (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 Aug 2020 14:27:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596651982;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=NY6yDRCEkpDg5LXNyaSXdjYfolIgk3OXFlkk/eTLcfo=;
        b=f3ouCTk08IwmV2TOjtMlzOCsHmgkojNijPv3k4PQVN50fCt0B0GCxCwSE0pde1yfw/PAe4
        QifpmLo1kQP8tRPUR26QLYtjqX9dANE36djG/PlIH/087YuEuRYToR6v35OBLq647T0Bpn
        novRGLzgvZ6fWGVQYCj6QXQjgaAzJ3Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-39-NIBy4lHNMPuW20DwNN_t3g-1; Wed, 05 Aug 2020 14:26:09 -0400
X-MC-Unique: NIBy4lHNMPuW20DwNN_t3g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EA9A210059A7;
        Wed,  5 Aug 2020 18:26:07 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 794135F202;
        Wed,  5 Aug 2020 18:26:07 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] First batch of KVM changes for Linux 5.9
Date:   Wed,  5 Aug 2020 14:26:06 -0400
Message-Id: <20200805182606.12621-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit 8038a922cf9af5266eaff29ce996a0d1b788fc0d:

  Merge tag 'kvmarm-fixes-5.8-3' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into kvm-master (2020-07-06 13:05:38 -0400)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to f3633c2683545213de4a00a9b0c3fba741321fb2:

  Merge tag 'kvm-s390-next-5.9-1' of git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux into kvm-next-5.6 (2020-08-03 14:19:13 -0400)

----------------------------------------------------------------
s390: implement diag318

x86:
* Report last CPU for debugging
* Emulate smaller MAXPHYADDR in the guest than in the host
* .noinstr and tracing fixes from Thomas
* nested SVM page table switching optimization and fixes

Generic:
* Unify shadow MMU cache data structures across architectures

----------------------------------------------------------------

There is a conflict in arch/x86/kernel/kvm.c that git will only
partially report.  idtentry_enter_cond_rcu and idtentry_exit_cond_rcu
have been renamed to idtentry_enter and idtentry_exit and their return
type went from bool to idtentry_state_t.  There are two occurrences
but git will only notice the first one (and only partly so, it misses
the function calls altogether).

The resolution is simple, but I've included it at the end of this message
anyway.

Thanks,

Paolo

Colin Ian King (1):
      KVM: MIPS: fix spelling mistake "Exteneded" -> "Extended"

Collin Walling (2):
      s390/setup: diag 318: refactor struct
      s390/kvm: diagnose 0x318 sync and reset

Dan Carpenter (1):
      KVM: SVM: Fix sev_pin_memory() error handling

Haiwei Li (1):
      KVM: Using macros instead of magic values

Huacai Chen (1):
      MIPS: KVM: Fix build error caused by 'kvm_run' cleanup

Jiaxun Yang (2):
      MIPS: KVM: Limit Trap-and-Emulate to MIPS32R2 only
      MIPS: KVM: Remove outdated README

Jim Mattson (7):
      kvm: svm: Prefer vcpu->cpu to raw_smp_processor_id()
      kvm: svm: Always set svm->last_cpu on VMRUN
      kvm: vmx: Add last_cpu to struct vcpu_vmx
      kvm: x86: Add "last CPU" to some KVM_EXIT information
      kvm: x86: Move last_cpu into kvm_vcpu_arch as last_vmentry_cpu
      kvm: x86: Set last_vmentry_cpu in vcpu_enter_guest
      kvm: x86: Read PDPTEs on CR0.CD and CR0.NW changes

Joerg Roedel (4):
      KVM: SVM: Rename struct nested_state to svm_nested_state
      KVM: SVM: Add vmcb_ prefix to mark_*() functions
      KVM: SVM: Add svm_ prefix to set/clr/is_intercept()
      KVM: SVM: Rename svm_nested_virtualize_tpr() to nested_svm_virtualize_tpr()

John Hubbard (2):
      KVM: SVM: fix svn_pin_memory()'s use of get_user_pages_fast()
      KVM: SVM: convert get_user_pages() --> pin_user_pages()

Krish Sadhukhan (4):
      KVM: x86: Move the check for upper 32 reserved bits of DR6 to separate function
      KVM: nSVM: Check that DR6[63:32] and DR7[64:32] are not set on vmrun of nested guests
      KVM: x86: Create mask for guest CR4 reserved bits in kvm_update_cpuid()
      KVM: nSVM: Check that MBZ bits in CR3 and CR4 are not set on vmrun of nested guests

Like Xu (2):
      kvm: x86: limit the maximum number of vPMU fixed counters to 3
      KVM/x86: pmu: Fix #GP condition check for RDPMC emulation

Maxim Levitsky (1):
      kvm: x86: replace kvm_spec_ctrl_test_value with runtime test on the host

Mohammed Gamal (5):
      KVM: x86: Add helper functions for illegal GPA checking and page fault injection
      KVM: x86: mmu: Move translate_gpa() to mmu.c
      KVM: x86: mmu: Add guest physical address check in translate_gpa()
      KVM: VMX: Add guest physical address check in EPT violation and misconfig
      KVM: x86: Add a capability for GUEST_MAXPHYADDR < HOST_MAXPHYADDR support

Paolo Bonzini (11):
      Merge branch 'kvm-async-pf-int' into HEAD
      Merge branch 'kvm-master' into HEAD
      KVM: x86: report sev_pin_memory errors with PTR_ERR
      KVM: x86: Make CR4.VMXE reserved for the guest
      KVM: MMU: stop dereferencing vcpu->arch.mmu to get the context for MMU init
      KVM: x86: rename update_bp_intercept to update_exception_bitmap
      KVM: x86: update exception bitmap on CPUID changes
      KVM: VMX: introduce vmx_need_pf_intercept
      KVM: VMX: optimize #PF injection when MAXPHYADDR does not match
      KVM: nSVM: remove nonsensical EXITINFO1 adjustment on nested NPF
      Merge tag 'kvm-s390-next-5.9-1' of git://git.kernel.org/.../kvms390/linux into kvm-next-5.6

Peter Xu (2):
      KVM: X86: Move ignore_msrs handling upper the stack
      KVM: X86: Do the same ignore_msrs check for feature msrs

Sean Christopherson (46):
      KVM: x86/mmu: Drop kvm_arch_write_log_dirty() wrapper
      KVM: nVMX: WARN if PML emulation helper is invoked outside of nested guest
      KVM: x86/mmu: Make .write_log_dirty a nested operation
      KVM: nVMX: Wrap VM-Fail valid path in generic VM-Fail helper
      KVM: x86/mmu: Avoid multiple hash lookups in kvm_get_mmu_page()
      KVM: x86/mmu: Optimize MMU page cache lookup for fully direct MMUs
      KVM: x86/mmu: Don't put invalid SPs back on the list of active pages
      KVM: x86/mmu: Batch zap MMU pages when recycling oldest pages
      KVM: x86/mmu: Batch zap MMU pages when shrinking the slab
      KVM: x86/mmu: Exit to userspace on make_mmu_pages_available() error
      KVM: x86/mmu: Move mmu_audit.c and mmutrace.h into the mmu/ sub-directory
      KVM: x86/mmu: Move kvm_mmu_available_pages() into mmu.c
      KVM: x86/mmu: Add MMU-internal header
      KVM: x86/mmu: Make kvm_mmu_page definition and accessor internal-only
      KVM: x86/mmu: Add sptep_to_sp() helper to wrap shadow page lookup
      KVM: x86/mmu: Rename page_header() to to_shadow_page()
      KVM: x86/mmu: Track the associated kmem_cache in the MMU caches
      KVM: x86/mmu: Consolidate "page" variant of memory cache helpers
      KVM: x86/mmu: Use consistent "mc" name for kvm_mmu_memory_cache locals
      KVM: x86/mmu: Remove superfluous gotos from mmu_topup_memory_caches()
      KVM: x86/mmu: Try to avoid crashing KVM if a MMU memory cache is empty
      KVM: x86/mmu: Move fast_page_fault() call above mmu_topup_memory_caches()
      KVM: x86/mmu: Topup memory caches after walking GVA->GPA
      KVM: x86/mmu: Clean up the gorilla math in mmu_topup_memory_caches()
      KVM: x86/mmu: Separate the memory caches for shadow pages and gfn arrays
      KVM: x86/mmu: Make __GFP_ZERO a property of the memory cache
      KVM: x86/mmu: Zero allocate shadow pages (outside of mmu_lock)
      KVM: x86/mmu: Skip filling the gfn cache for guaranteed direct MMU topups
      KVM: x86/mmu: Prepend "kvm_" to memory cache helpers that will be global
      KVM: Move x86's version of struct kvm_mmu_memory_cache to common code
      KVM: Move x86's MMU memory cache helpers to common KVM code
      KVM: arm64: Drop @max param from mmu_topup_memory_cache()
      KVM: arm64: Use common code's approach for __GFP_ZERO with memory caches
      KVM: arm64: Use common KVM implementation of MMU memory caches
      KVM: MIPS: Drop @max param from mmu_topup_memory_cache()
      KVM: MIPS: Account pages used for GPA page tables
      KVM: MIPS: Use common KVM implementation of MMU memory caches
      KVM: nSVM: Correctly set the shadow NPT root level in its MMU role
      KVM: VMX: Drop a duplicate declaration of construct_eptp()
      KVM: x86/mmu: Add separate helper for shadow NPT root page role calc
      KVM: VMX: Make vmx_load_mmu_pgd() static
      KVM: x86: Pull the PGD's level from the MMU instead of recalculating it
      KVM: VXM: Remove temporary WARN on expected vs. actual EPTP level mismatch
      KVM: x86: Dynamically calculate TDP level from max level and MAXPHYADDR
      KVM: x86/mmu: Rename max_page_level to max_huge_page_level
      KVM: x86: Specify max TDP level via kvm_configure_mmu()

Thomas Gleixner (7):
      x86/kvm: Move context tracking where it belongs
      x86/kvm/vmx: Add hardirq tracing to guest enter/exit
      x86/kvm/svm: Add hardirq tracing on guest enter/exit
      x86/kvm/vmx: Move guest enter/exit into .noinstr.text
      x86/kvm/svm: Move guest enter/exit into .noinstr.text
      x86/kvm/svm: Use uninstrumented wrmsrl() to restore GS
      x86/kvm/vmx: Use native read/write_cr2()

Tianjia Zhang (3):
      KVM: s390: clean up redundant 'kvm_run' parameters
      KVM: arm64: clean up redundant 'kvm_run' parameters
      KVM: MIPS: clean up redundant 'kvm_run' parameters

Uros Bizjak (1):
      KVM: x86: Use VMCALL and VMMCALL mnemonics in kvm_para.h

Vitaly Kuznetsov (13):
      KVM: x86: Switch KVM guest to using interrupts for page ready APF delivery
      KVM: x86: drop KVM_PV_REASON_PAGE_READY case from kvm_handle_page_fault()
      KVM: async_pf: change kvm_setup_async_pf()/kvm_arch_setup_async_pf() return type to bool
      KVM: x86: take as_id into account when checking PGD
      KVM: x86: move MSR_IA32_PERF_CAPABILITIES emulation to common x86 code
      KVM: nSVM: split kvm_init_shadow_npt_mmu() from kvm_init_shadow_mmu()
      KVM: nSVM: reset nested_run_pending upon nested_svm_vmrun_msrpm() failure
      KVM: nSVM: prepare to handle errors from enter_svm_guest_mode()
      KVM: nSVM: introduce nested_svm_load_cr3()/nested_npt_enabled()
      KVM: nSVM: move kvm_set_cr3() after nested_svm_uninit_mmu_context()
      KVM: nSVM: implement nested_svm_load_cr3() and use it for host->guest switch
      KVM: nSVM: use nested_svm_load_cr3() on guest->host switch
      KVM: x86: drop superfluous mmu_check_root() from fast_pgd_switch()

Wanpeng Li (1):
      KVM: LAPIC: Set the TDCR settable bits

Xiaoyao Li (9):
      KVM: X86: Reset vcpu->arch.cpuid_nent to 0 if SET_CPUID* fails
      KVM: X86: Go on updating other CPUID leaves when leaf 1 is absent
      KVM: lapic: Use guest_cpuid_has() in kvm_apic_set_version()
      KVM: X86: Move kvm_apic_set_version() to kvm_update_cpuid()
      KVM: x86: Introduce kvm_check_cpuid()
      KVM: x86: Extract kvm_update_cpuid_runtime() from kvm_update_cpuid()
      KVM: x86: Rename kvm_update_cpuid() to kvm_vcpu_after_set_cpuid()
      KVM: x86: Rename cpuid_update() callback to vcpu_after_set_cpuid()
      KVM: x86: Move kvm_x86_ops.vcpu_after_set_cpuid() into kvm_vcpu_after_set_cpuid()

Zhenzhong Duan (4):
      Revert "KVM: X86: Fix setup the virt_spin_lock_key before static key get initialized"
      x86/kvm: Change print code to use pr_*() format
      x86/kvm: Add "nopvspin" parameter to disable PV spinlocks
      xen: Mark "xen_nopvspin" parameter obsolete

 Documentation/admin-guide/kernel-parameters.txt |  10 +-
 Documentation/virt/kvm/api.rst                  |   5 +
 arch/arm64/include/asm/kvm_coproc.h             |  12 +-
 arch/arm64/include/asm/kvm_host.h               |  22 +-
 arch/arm64/include/asm/kvm_mmu.h                |   2 +-
 arch/arm64/include/asm/kvm_types.h              |   8 +
 arch/arm64/kvm/arm.c                            |   8 +-
 arch/arm64/kvm/handle_exit.c                    |  36 +-
 arch/arm64/kvm/mmio.c                           |  11 +-
 arch/arm64/kvm/mmu.c                            |  61 +---
 arch/arm64/kvm/sys_regs.c                       |  13 +-
 arch/mips/Kconfig                               |   1 +
 arch/mips/include/asm/kvm_host.h                |  39 +-
 arch/mips/include/asm/kvm_types.h               |   7 +
 arch/mips/kvm/00README.txt                      |  31 --
 arch/mips/kvm/Kconfig                           |   3 +-
 arch/mips/kvm/emulate.c                         |  65 ++--
 arch/mips/kvm/mips.c                            |  11 +-
 arch/mips/kvm/mmu.c                             |  44 +--
 arch/mips/kvm/trap_emul.c                       | 114 +++---
 arch/mips/kvm/vz.c                              |  26 +-
 arch/powerpc/include/asm/Kbuild                 |   1 +
 arch/s390/include/asm/Kbuild                    |   1 +
 arch/s390/include/asm/diag.h                    |   6 +-
 arch/s390/include/asm/kvm_host.h                |   4 +-
 arch/s390/include/uapi/asm/kvm.h                |   7 +-
 arch/s390/kernel/setup.c                        |   3 +-
 arch/s390/kvm/kvm-s390.c                        |  54 ++-
 arch/s390/kvm/vsie.c                            |   1 +
 arch/x86/Kconfig                                |   1 +
 arch/x86/include/asm/hardirq.h                  |   4 +-
 arch/x86/include/asm/idtentry.h                 |   4 +
 arch/x86/include/asm/kvm_host.h                 |  95 ++---
 arch/x86/include/asm/kvm_para.h                 |   3 +-
 arch/x86/include/asm/kvm_types.h                |   7 +
 arch/x86/include/asm/qspinlock.h                |   1 +
 arch/x86/kernel/kvm.c                           | 118 ++++--
 arch/x86/kvm/cpuid.c                            | 115 +++---
 arch/x86/kvm/cpuid.h                            |   2 +-
 arch/x86/kvm/lapic.c                            |  11 +-
 arch/x86/kvm/mmu.h                              |  34 +-
 arch/x86/kvm/mmu/mmu.c                          | 461 +++++++++++++-----------
 arch/x86/kvm/{ => mmu}/mmu_audit.c              |  12 +-
 arch/x86/kvm/mmu/mmu_internal.h                 |  63 ++++
 arch/x86/kvm/{ => mmu}/mmutrace.h               |   2 +-
 arch/x86/kvm/mmu/page_track.c                   |   2 +-
 arch/x86/kvm/mmu/paging_tmpl.h                  |  19 +-
 arch/x86/kvm/pmu.c                              |   5 +
 arch/x86/kvm/pmu.h                              |   2 +
 arch/x86/kvm/svm/avic.c                         |   2 +-
 arch/x86/kvm/svm/nested.c                       | 142 ++++++--
 arch/x86/kvm/svm/sev.c                          |  47 +--
 arch/x86/kvm/svm/svm.c                          | 262 +++++++++-----
 arch/x86/kvm/svm/svm.h                          |  32 +-
 arch/x86/kvm/svm/vmenter.S                      |   2 +-
 arch/x86/kvm/vmx/nested.c                       | 149 +++++---
 arch/x86/kvm/vmx/ops.h                          |   4 +
 arch/x86/kvm/vmx/pmu_intel.c                    |  17 -
 arch/x86/kvm/vmx/vmenter.S                      |   5 +-
 arch/x86/kvm/vmx/vmx.c                          | 209 ++++++-----
 arch/x86/kvm/vmx/vmx.h                          |  12 +-
 arch/x86/kvm/x86.c                              | 231 +++++++-----
 arch/x86/kvm/x86.h                              |  34 +-
 arch/x86/xen/spinlock.c                         |   4 +-
 include/asm-generic/kvm_types.h                 |   5 +
 include/linux/kvm_host.h                        |  12 +-
 include/linux/kvm_types.h                       |  19 +
 include/uapi/linux/kvm.h                        |   4 +
 kernel/locking/qspinlock.c                      |   7 +
 virt/kvm/async_pf.c                             |  16 +-
 virt/kvm/kvm_main.c                             |  63 ++++
 71 files changed, 1633 insertions(+), 1212 deletions(-)
 create mode 100644 arch/arm64/include/asm/kvm_types.h
 create mode 100644 arch/mips/include/asm/kvm_types.h
 delete mode 100644 arch/mips/kvm/00README.txt
 create mode 100644 arch/x86/include/asm/kvm_types.h
 rename arch/x86/kvm/{ => mmu}/mmu_audit.c (96%)
 create mode 100644 arch/x86/kvm/mmu/mmu_internal.h
 rename arch/x86/kvm/{ => mmu}/mmutrace.h (99%)
 create mode 100644 include/asm-generic/kvm_types.h

diff --cc arch/x86/kernel/kvm.c
index d9995931ea18,3f78482d9496..000000000000
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@@ -34,6 -31,6 +34,7 @@@
  #include <asm/apic.h>
  #include <asm/apicdef.h>
  #include <asm/hypervisor.h>
++#include <asm/idtentry.h>
  #include <asm/tlb.h>
  #include <asm/cpuidle_haltpoll.h>
  
@@@ -235,13 -232,18 +236,13 @@@ EXPORT_SYMBOL_GPL(kvm_read_and_reset_ap
  
  noinstr bool __kvm_handle_async_pf(struct pt_regs *regs, u32 token)
  {
 -	u32 reason = kvm_read_and_reset_apf_flags();
 +	u32 flags = kvm_read_and_reset_apf_flags();
- 	bool rcu_exit;
+ 	idtentry_state_t state;
  
 -	switch (reason) {
 -	case KVM_PV_REASON_PAGE_NOT_PRESENT:
 -	case KVM_PV_REASON_PAGE_READY:
 -		break;
 -	default:
 +	if (!flags)
  		return false;
 -	}
  
- 	rcu_exit = idtentry_enter_cond_rcu(regs);
+ 	state = idtentry_enter(regs);
  	instrumentation_begin();
  
  	/*
@@@ -266,27 -268,6 +267,27 @@@
  	return true;
  }
  
 +DEFINE_IDTENTRY_SYSVEC(sysvec_kvm_asyncpf_interrupt)
 +{
 +	struct pt_regs *old_regs = set_irq_regs(regs);
 +	u32 token;
- 	bool rcu_exit;
++	idtentry_state_t rcu_exit;
 +
- 	rcu_exit = idtentry_enter_cond_rcu(regs);
++	rcu_exit = idtentry_enter(regs);
 +
 +	inc_irq_stat(irq_hv_callback_count);
 +
 +	if (__this_cpu_read(apf_reason.enabled)) {
 +		token = __this_cpu_read(apf_reason.token);
 +		kvm_async_pf_task_wake(token);
 +		__this_cpu_write(apf_reason.token, 0);
 +		wrmsrl(MSR_KVM_ASYNC_PF_ACK, 1);
 +	}
 +
- 	idtentry_exit_cond_rcu(regs, rcu_exit);
++	idtentry_exit(regs, rcu_exit);
 +	set_irq_regs(old_regs);
 +}
 +
  static void __init paravirt_ops_setup(void)
  {
  	pv_info.name = "KVM";

