Return-Path: <kvm+bounces-41713-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 46C96A6C251
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 19:25:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6E7C3188E43C
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 18:25:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D911722F16F;
	Fri, 21 Mar 2025 18:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bWA4ZHX6"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9AA01E5B83
	for <kvm@vger.kernel.org>; Fri, 21 Mar 2025 18:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742581494; cv=none; b=mldKtb7QzkFUbbEX+TqWPtc4M6dfmq2YKLhFtaClNl3nkD6gdOroeHfZg6jaST5Oyrwq8y6m19rXu2sdR+ibSGNvtwMuRzY28OWtDuI8QScq+6pavqoUPZ90kT+VsVeAcOMuXas9voRNQorq/zL7UXwFKA4q2HFMBGWQZuD2Wpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742581494; c=relaxed/simple;
	bh=VI15j4TuWu17BeYXrlCNP2NWb9Rqc3doOpgyCu300Os=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=V4furM/IRRG09mp6s/ZRZHOzrwKME2Q6BsoUxkPTD17i5NugfsNNdDljfAxKA9y5yk9ydFE35INKsxBXpjS6Md0+2PoO0QOjS0juC2TaEwX7FmeN0X06jor3Zejq40m1x9rzUXRapri06GcUQBqWyUzny5tqUwKkya+yE/iXAa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bWA4ZHX6; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742581489;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=TiOCGvoiXYa0+9GVmJUw8XdswC+bwUaexvhIuXi4QSM=;
	b=bWA4ZHX6OIPM4ZBfE3XOzBQVIDnAqSNkaWSHnI/LhxrbDJub2OD8+9N9AkBDf7WNnwSWRT
	SSknIQKGpsK8yIF7fi44KEfTgKIim+CbJRo+maU0IuGBXci5LotYtKzWOLsBf0Gg+u7Nxc
	LCVvHAmKQgkfTniJdLAXvov/HapR3wg=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-648-1lS3CyyMOE-hh-_6HzBxbg-1; Fri,
 21 Mar 2025 14:24:47 -0400
X-MC-Unique: 1lS3CyyMOE-hh-_6HzBxbg-1
X-Mimecast-MFC-AGG-ID: 1lS3CyyMOE-hh-_6HzBxbg_1742581486
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 666F1196D2D8;
	Fri, 21 Mar 2025 18:24:46 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C28BA1800944;
	Fri, 21 Mar 2025 18:24:45 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [GIT PULL] First batch of KVM changes for Linux 6.15
Date: Fri, 21 Mar 2025 14:24:43 -0400
Message-ID: <20250321182445.162466-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Linus,

The following changes since commit 4701f33a10702d5fc577c32434eb62adde0a1ae1:

  Linux 6.14-rc7 (2025-03-16 12:55:17 -1000)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 782f9feaa9517caf33186dcdd6b50a8f770ed29b:

  Merge branch 'kvm-pre-tdx' into HEAD (2025-03-20 13:13:13 -0400)

Since I am travelling next week I'm sending what I already have.
s390 is missing and will come during the second week of the merge
window.

There is a conflict with the Arm tree in arch/arm64/kernel/proton-pack.c.
The fix is to remove the first argument to is_midr_in_range_list(), as
seen in commit e3121298c7fc from this merge ("arm64: Modify _midr_range()
functions to read MIDR/REVIDR internally").

Paolo

----------------------------------------------------------------
ARM:

* Nested virtualization support for VGICv3, giving the nested
hypervisor control of the VGIC hardware when running an L2 VM

* Removal of 'late' nested virtualization feature register masking,
  making the supported feature set directly visible to userspace

* Support for emulating FEAT_PMUv3 on Apple silicon, taking advantage
  of an IMPLEMENTATION DEFINED trap that covers all PMUv3 registers

* Paravirtual interface for discovering the set of CPU implementations
  where a VM may run, addressing a longstanding issue of guest CPU
  errata awareness in big-little systems and cross-implementation VM
  migration

* Userspace control of the registers responsible for identifying a
  particular CPU implementation (MIDR_EL1, REVIDR_EL1, AIDR_EL1),
  allowing VMs to be migrated cross-implementation

* pKVM updates, including support for tracking stage-2 page table
  allocations in the protected hypervisor in the 'SecPageTable' stat

* Fixes to vPMU, ensuring that userspace updates to the vPMU after
  KVM_RUN are reflected into the backing perf events

LoongArch:

* Remove unnecessary header include path

* Assume constant PGD during VM context switch

* Add perf events support for guest VM

RISC-V:

* Disable the kernel perf counter during configure

* KVM selftests improvements for PMU

* Fix warning at the time of KVM module removal

x86:

* Add support for aging of SPTEs without holding mmu_lock.  Not taking mmu_lock
  allows multiple aging actions to run in parallel, and more importantly avoids
  stalling vCPUs.  This includes an implementation of per-rmap-entry locking;
  aging the gfn is done with only a per-rmap single-bin spinlock taken, whereas
  locking an rmap for write requires taking both the per-rmap spinlock and
  the mmu_lock.

  Note that this decreases slightly the accuracy of accessed-page information,
  because changes to the SPTE outside aging might not use atomic operations
  even if they could race against a clear of the Accessed bit.  This is
  deliberate because KVM and mm/ tolerate false positives/negatives for
  accessed information, and testing has shown that reducing the latency of
  aging is far more beneficial to overall system performance than providing
  "perfect" young/old information.

* Defer runtime CPUID updates until KVM emulates a CPUID instruction, to
  coalesce updates when multiple pieces of vCPU state are changing, e.g. as
  part of a nested transition.

* Fix a variety of nested emulation bugs, and add VMX support for synthesizing
  nested VM-Exit on interception (instead of injecting #UD into L2).

* Drop "support" for async page faults for protected guests that do not set
  SEND_ALWAYS (i.e. that only want async page faults at CPL3)

* Bring a bit of sanity to x86's VM teardown code, which has accumulated
  a lot of cruft over the years.  Particularly, destroy vCPUs before
  the MMU, despite the latter being a VM-wide operation.

* Add common secure TSC infrastructure for use within SNP and in the
  future TDX

* Block KVM_CAP_SYNC_REGS if guest state is protected.  It does not make
  sense to use the capability if the relevant registers are not
  available for reading or writing.

* Don't take kvm->lock when iterating over vCPUs in the suspend notifier to
  fix a largely theoretical deadlock.

* Use the vCPU's actual Xen PV clock information when starting the Xen timer,
  as the cached state in arch.hv_clock can be stale/bogus.

* Fix a bug where KVM could bleed PVCLOCK_GUEST_STOPPED across different
  PV clocks; restrict PVCLOCK_GUEST_STOPPED to kvmclock, as KVM's suspend
  notifier only accounts for kvmclock, and there's no evidence that the
  flag is actually supported by Xen guests.

* Clean up the per-vCPU "cache" of its reference pvclock, and instead only
  track the vCPU's TSC scaling (multipler+shift) metadata (which is moderately
  expensive to compute, and rarely changes for modern setups).

* Don't write to the Xen hypercall page on MSR writes that are initiated by
  the host (userspace or KVM) to fix a class of bugs where KVM can write to
  guest memory at unexpected times, e.g. during vCPU creation if userspace has
  set the Xen hypercall MSR index to collide with an MSR that KVM emulates.

* Restrict the Xen hypercall MSR index to the unofficial synthetic range to
  reduce the set of possible collisions with MSRs that are emulated by KVM
  (collisions can still happen as KVM emulates Hyper-V MSRs, which also reside
  in the synthetic range).

* Clean up and optimize KVM's handling of Xen MSR writes and xen_hvm_config.

* Update Xen TSC leaves during CPUID emulation instead of modifying the CPUID
  entries when updating PV clocks; there is no guarantee PV clocks will be
  updated between TSC frequency changes and CPUID emulation, and guest reads
  of the TSC leaves should be rare, i.e. are not a hot path.

x86 (Intel):

* Fix a bug where KVM unnecessarily reads XFD_ERR from hardware and thus
  modifies the vCPU's XFD_ERR on a #NM due to CR0.TS=1.

* Pass XFD_ERR as the payload when injecting #NM, as a preparatory step
  for upcoming FRED virtualization support.

* Decouple the EPT entry RWX protection bit macros from the EPT Violation
  bits, both as a general cleanup and in anticipation of adding support for
  emulating Mode-Based Execution Control (MBEC).

* Reject KVM_RUN if userspace manages to gain control and stuff invalid guest
  state while KVM is in the middle of emulating nested VM-Enter.

* Add a macro to handle KVM's sanity checks on entry/exit VMCS control pairs
  in anticipation of adding sanity checks for secondary exit controls (the
  primary field is out of bits).

x86 (AMD):

* Ensure the PSP driver is initialized when both the PSP and KVM modules are
  built-in (the initcall framework doesn't handle dependencies).

* Use long-term pins when registering encrypted memory regions, so that the
  pages are migrated out of MIGRATE_CMA/ZONE_MOVABLE and don't lead to
  excessive fragmentation.

* Add macros and helpers for setting GHCB return/error codes.

* Add support for Idle HLT interception, which elides interception if the vCPU
  has a pending, unmasked virtual IRQ when HLT is executed.

* Fix a bug in INVPCID emulation where KVM fails to check for a non-canonical
  address.

* Don't attempt VMRUN for SEV-ES+ guests if the vCPU's VMSA is invalid, e.g.
  because the vCPU was "destroyed" via SNP's AP Creation hypercall.

* Reject SNP AP Creation if the requested SEV features for the vCPU don't
  match the VM's configured set of features.

Selftests:

* Fix again the Intel PMU counters test; add a data load and do CLFLUSH{OPT} on the data
  instead of executing code.  The theory is that modern Intel CPUs have
  learned new code prefetching tricks that bypass the PMU counters.

* Fix a flaw in the Intel PMU counters test where it asserts that an event is
  counting correctly without actually knowing what the event counts on the
  underlying hardware.

* Fix a variety of flaws, bugs, and false failures/passes dirty_log_test, and
  improve its coverage by collecting all dirty entries on each iteration.

* Fix a few minor bugs related to handling of stats FDs.

* Add infrastructure to make vCPU and VM stats FDs available to tests by
  default (open the FDs during VM/vCPU creation).

* Relax an assertion on the number of HLT exits in the xAPIC IPI test when
  running on a CPU that supports AMD's Idle HLT (which elides interception of
  HLT if a virtual IRQ is pending and unmasked).

----------------------------------------------------------------
Akihiko Odaki (5):
      KVM: arm64: PMU: Set raw values from user to PM{C,I}NTEN{SET,CLR}, PMOVS{SET,CLR}
      KVM: arm64: PMU: Assume PMU presence in pmu-emul.c
      KVM: arm64: PMU: Fix SET_ONE_REG for vPMC regs
      KVM: arm64: PMU: Reload when user modifies registers
      KVM: arm64: PMU: Reload when resetting

Andre Przywara (1):
      KVM: arm64: nv: Allow userland to set VGIC maintenance IRQ

Atish Patra (5):
      RISC-V: KVM: Disable the kernel perf counter during configure
      KVM: riscv: selftests: Do not start the counter in the overflow handler
      KVM: riscv: selftests: Change command line option
      KVM: riscv: selftests: Allow number of interrupts to be configurable
      RISC-V: KVM: Teardown riscv specific bits after kvm_exit

Bibo Mao (4):
      LoongArch: KVM: Remove PGD saving during VM context switch
      LoongArch: KVM: Add stub for kvm_arch_vcpu_preempted_in_kernel()
      LoongArch: KVM: Implement arch-specific functions for guest perf
      LoongArch: KVM: Register perf callbacks for guest

Chao Du (1):
      RISC-V: KVM: Optimize comments in kvm_riscv_vcpu_isa_disable_allowed

Chen Ni (1):
      KVM: selftests: Remove unneeded semicolon

Claudio Imbrenda (1):
      KVM: s390: pv: fix race when making a page secure

Colin Ian King (1):
      KVM: selftests: Fix spelling mistake "UFFDIO_CONINUE" -> "UFFDIO_CONTINUE"

Colton Lewis (2):
      KVM: selftests: Fix typos in x86's PMU counter test's macro variable use
      KVM: selftests: Add defines for AMD PMU CPUID features and properties

David Woodhouse (1):
      KVM: x86/xen: Only write Xen hypercall page for guest writes to MSR

Ethan Zhao (1):
      KVM: x86/cpuid: add type suffix to decimal const 48 fix building warning

Fred Griffoul (1):
      KVM: x86: Update Xen TSC leaves during CPUID emulation

Fuad Tabba (4):
      KVM: arm64: Factor out setting HCRX_EL2 traps into separate function
      KVM: arm64: Initialize HCRX_EL2 traps in pKVM
      KVM: arm64: Factor out pKVM hyp vcpu creation to separate function
      KVM: arm64: Create each pKVM hyp vcpu after its corresponding host vcpu

Ge Yang (1):
      KVM: SEV: Use long-term pin when registering encrypted memory regions

Isaku Yamahata (3):
      KVM: selftests: Add printf attribute to _no_printf()
      KVM: x86: Push down setting vcpu.arch.user_set_tsc
      KVM: x86: Add infrastructure for secure TSC

James Houghton (6):
      KVM: Rename kvm_handle_hva_range()
      KVM: Allow lockless walk of SPTEs when handing aging mmu_notifier event
      KVM: x86/mmu: Factor out spte atomic bit clearing routine
      KVM: x86/mmu: Don't force atomic update if only the Accessed bit is volatile
      KVM: x86/mmu: Skip shadow MMU test_young if TDP MMU reports page as young
      KVM: x86/mmu: Only check gfn age in shadow MMU if indirect_shadow_pages > 0

Jim Mattson (2):
      KVM: x86: Introduce kvm_set_mp_state()
      KVM: x86: Clear pv_unhalted on all transitions to KVM_MP_STATE_RUNNABLE

Jintack Lim (1):
      KVM: arm64: nv: Respect virtual HCR_EL2.TWx setting

Li RongQing (1):
      KVM: x86: Use kvfree_rcu() to free old optimized APIC map

Liam Ni (1):
      KVM: x86: Wake vCPU for PIC interrupt injection iff a valid IRQ was found

Manali Shukla (2):
      x86/cpufeatures: Add CPUID feature bit for Idle HLT intercept
      KVM: SVM: Add Idle HLT intercept support

Marc Zyngier (25):
      arm64: cpufeature: Handle NV_frac as a synonym of NV2
      KVM: arm64: Hide ID_AA64MMFR2_EL1.NV from guest and userspace
      KVM: arm64: Mark HCR.EL2.E2H RES0 when ID_AA64MMFR1_EL1.VH is zero
      KVM: arm64: Mark HCR.EL2.{NV*,AT} RES0 when ID_AA64MMFR4_EL1.NV_frac is 0
      KVM: arm64: Advertise NV2 in the boot messages
      KVM: arm64: Consolidate idreg callbacks
      KVM: arm64: Make ID_REG_LIMIT_FIELD_ENUM() more widely available
      KVM: arm64: Enforce NV limits on a per-idregs basis
      KVM: arm64: Move NV-specific capping to idreg sanitisation
      KVM: arm64: Allow userspace to limit NV support to nVHE
      KVM: arm64: Make ID_AA64MMFR4_EL1.NV_frac writable
      KVM: arm64: Advertise FEAT_ECV when possible
      arm64: sysreg: Add layout for ICH_HCR_EL2
      arm64: sysreg: Add layout for ICH_VTR_EL2
      arm64: sysreg: Add layout for ICH_MISR_EL2
      KVM: arm64: nv: Load timer before the GIC
      KVM: arm64: nv: Add ICH_*_EL2 registers to vpcu_sysreg
      KVM: arm64: nv: Plumb handling of GICv3 EL2 accesses
      KVM: arm64: nv: Sanitise ICH_HCR_EL2 accesses
      KVM: arm64: nv: Nested GICv3 emulation
      KVM: arm64: nv: Handle L2->L1 transition on interrupt injection
      KVM: arm64: nv: Add Maintenance Interrupt emulation
      KVM: arm64: nv: Propagate used_lrs between L1 and L0 contexts
      KVM: arm64: nv: Fold GICv3 host trapping requirements into guest setup
      KVM: arm64: nv: Fail KVM init if asking for NV without GICv3

Masahiro Yamada (1):
      LoongArch: KVM: Remove unnecessary header include path

Maxim Levitsky (2):
      KVM: selftests: Support multiple write retires in dirty_log_test
      KVM: selftests: Limit dirty_log_test's s390x workaround to s390x

Melody Wang (2):
      KVM: SVM: Convert plain error code numbers to defines
      KVM: SVM: Provide helpers to set the error code

Nikolay Borisov (2):
      KVM: VMX: Remove EPT_VIOLATIONS_ACC_*_BIT defines
      KVM: x86/tdp_mmu: Remove tdp_mmu_for_each_pte()

Nikunj A Dadhania (1):
      KVM: SEV: Use to_kvm_sev_info() for fetching kvm_sev_info struct

Oliver Upton (32):
      KVM: arm64: Set HCR_EL2.TID1 unconditionally
      KVM: arm64: Load VPIDR_EL2 with the VM's MIDR_EL1 value
      KVM: arm64: vgic-v4: Only attempt vLPI mapping for actual MSIs
      KVM: arm64: vgic-v4: Only WARN for HW IRQ mismatch when unmapping vLPI
      KVM: arm64: vgic-v4: Fall back to software irqbypass if LPI not found
      KVM: arm64: Document ordering requirements for irqbypass
      KVM: arm64: nv: Request vPE doorbell upon nested ERET to L2
      KVM: arm64: Copy guest CTR_EL0 into hyp VM
      KVM: arm64: Copy MIDR_EL1 into hyp VM when it is writable
      KVM: arm64: Fix documentation for KVM_CAP_ARM_WRITABLE_IMP_ID_REGS
      drivers/perf: apple_m1: Refactor event select/filter configuration
      drivers/perf: apple_m1: Support host/guest event filtering
      KVM: arm64: Compute PMCEID from arm_pmu's event bitmaps
      KVM: arm64: Always support SW_INCR PMU event
      KVM: arm64: Use a cpucap to determine if system supports FEAT_PMUv3
      KVM: arm64: Drop kvm_arm_pmu_available static key
      KVM: arm64: Use guard() to cleanup usage of arm_pmus_lock
      KVM: arm64: Move PMUVer filtering into KVM code
      KVM: arm64: Compute synthetic sysreg ESR for Apple PMUv3 traps
      KVM: arm64: Advertise PMUv3 if IMPDEF traps are present
      KVM: arm64: Remap PMUv3 events onto hardware
      drivers/perf: apple_m1: Provide helper for mapping PMUv3 events
      KVM: arm64: Provide 1 event counter on IMPDEF hardware
      arm64: Enable IMP DEF PMUv3 traps on Apple M*
      Merge branch 'kvm-arm64/misc' into kvmarm/next
      Merge branch 'kvm-arm64/nv-vgic' into kvmarm/next
      Merge branch 'kvm-arm64/nv-idregs' into kvmarm/next
      Merge branch 'kvm-arm64/pv-cpuid' into kvmarm/next
      Merge branch 'kvm-arm64/pmuv3-asahi' into kvmarm/next
      Merge branch 'kvm-arm64/writable-midr' into kvmarm/next
      Merge branch 'kvm-arm64/pkvm-6.15' into kvmarm/next
      Merge branch 'kvm-arm64/pmu-fixes' into kvmarm/next

Paolo Bonzini (16):
      KVM: x86: move vm_destroy callback at end of kvm_arch_destroy_vm
      KVM: x86: block KVM_CAP_SYNC_REGS if guest state is protected
      Merge tag 'kvm-s390-master-6.14-1' of https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux into HEAD
      Merge tag 'loongarch-kvm-6.15' of git://git.kernel.org/pub/scm/linux/kernel/git/chenhuacai/linux-loongson into HEAD
      Merge tag 'kvm-x86-mmu-6.15' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-misc-6.15' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-selftests_6.15-1' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-selftests-6.15' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-vmx-6.15' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-svm-6.15' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-pvclock-6.15' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-xen-6.15' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-riscv-6.15-1' of https://github.com/kvm-riscv/linux into HEAD
      Merge tag 'kvmarm-6.15' of https://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD
      Merge branch 'kvm-nvmx-and-vm-teardown' into HEAD
      Merge branch 'kvm-pre-tdx' into HEAD

Sean Christopherson (97):
      KVM: selftests: Use data load to trigger LLC references/misses in Intel PMU
      KVM: selftests: Add helpers for locally (un)blocking IRQs on x86
      crypto: ccp: Add external API interface for PSP module initialization
      KVM: SVM: Ensure PSP module is initialized if KVM module is built-in
      KVM: selftests: Make Intel arch events globally available in PMU counters test
      KVM: selftests: Only validate counts for hardware-supported arch events
      KVM: selftests: Remove dead code in Intel PMU counters test
      KVM: selftests: Drop the "feature event" param from guest test helpers
      KVM: selftests: Print out the actual Top-Down Slots count on failure
      KVM: selftests: Actually emit forced emulation prefix for kvm_asm_safe_fep()
      KVM: selftests: Sync dirty_log_test iteration to guest *before* resuming
      KVM: selftests: Drop signal/kick from dirty ring testcase
      KVM: selftests: Drop stale srandom() initialization from dirty_log_test
      KVM: selftests: Precisely track number of dirty/clear pages for each iteration
      KVM: selftests: Read per-page value into local var when verifying dirty_log_test
      KVM: selftests: Continuously reap dirty ring while vCPU is running
      KVM: selftests: Honor "stop" request in dirty ring test
      KVM: selftests: Keep dirty_log_test vCPU in guest until it needs to stop
      KVM: selftests: Post to sem_vcpu_stop if and only if vcpu_stop is true
      KVM: selftests: Use continue to handle all "pass" scenarios in dirty_log_test
      KVM: selftests: Print (previous) last_page on dirty page value mismatch
      KVM: selftests: Collect *all* dirty entries in each dirty_log_test iteration
      KVM: sefltests: Verify value of dirty_log_test last page isn't bogus
      KVM: selftests: Ensure guest writes min number of pages in dirty_log_test
      KVM: selftests: Tighten checks around prev iter's last dirty page in ring
      KVM: selftests: Set per-iteration variables at the start of each iteration
      KVM: selftests: Fix an off-by-one in the number of dirty_log_test iterations
      KVM: selftests: Allow running a single iteration of dirty_log_test
      KVM: selftests: Fix mostly theoretical leak of VM's binary stats FD
      KVM: selftests: Close VM's binary stats FD when releasing VM
      KVM: x86: Use for-loop to iterate over XSTATE size entries
      KVM: x86: Apply TSX_CTRL_CPUID_CLEAR if and only if the vCPU has RTM or HLE
      KVM: x86: Query X86_FEATURE_MWAIT iff userspace owns the CPUID feature bit
      KVM: x86: Defer runtime updates of dynamic CPUID bits until CPUID emulation
      KVM: x86: Don't take kvm->lock when iterating over vCPUs in suspend notifier
      KVM: x86: Eliminate "handling" of impossible errors during SUSPEND
      KVM: x86: Drop local pvclock_flags variable in kvm_guest_time_update()
      KVM: x86: Process "guest stopped request" once per guest time update
      KVM: x86/xen: Use guest's copy of pvclock when starting timer
      KVM: x86: Don't bleed PVCLOCK_GUEST_STOPPED across PV clocks
      KVM: x86: Set PVCLOCK_GUEST_STOPPED only for kvmclock, not for Xen PV clock
      KVM: x86: Pass reference pvclock as a param to kvm_setup_guest_pvclock()
      KVM: x86: Remove per-vCPU "cache" of its reference pvclock
      KVM: x86: Setup Hyper-V TSC page before Xen PV clocks (during clock update)
      KVM: x86: Override TSC_STABLE flag for Xen PV clocks in kvm_guest_time_update()
      KVM: selftests: Assert that __vm_get_stat() actually finds a stat
      KVM: selftests: Macrofy vm_get_stat() to auto-generate stat name string
      KVM: selftests: Add struct and helpers to wrap binary stats cache
      KVM: selftests: Get VM's binary stats FD when opening VM
      KVM: selftests: Adjust number of files rlimit for all "standard" VMs
      KVM: selftests: Add infrastructure for getting vCPU binary stats
      KVM: x86/mmu: Always update A/D-disabled SPTEs atomically
      KVM: x86/mmu: Age TDP MMU SPTEs without holding mmu_lock
      KVM: x86/mmu: Refactor low level rmap helpers to prep for walking w/o mmu_lock
      KVM: x86/mmu: Add infrastructure to allow walking rmaps outside of mmu_lock
      KVM: x86/mmu: Add support for lockless walks of rmap SPTEs
      KVM: x86/mmu: Walk rmaps (shadow MMU) without holding mmu_lock when aging gfns
      KVM: x86/xen: Restrict hypercall MSR to unofficial synthetic range
      KVM: x86/xen: Add an #ifdef'd helper to detect writes to Xen MSR
      KVM: x86/xen: Consult kvm_xen_enabled when checking for Xen MSR writes
      KVM: x86/xen: Bury xen_hvm_config behind CONFIG_KVM_XEN=y
      KVM: x86/xen: Move kvm_xen_hvm_config field into kvm_xen
      KVM: nVMX: Check PAUSE_EXITING, not BUS_LOCK_DETECTION, on PAUSE emulation
      KVM: nSVM: Pass next RIP, not current RIP, for nested VM-Exit on emulation
      KVM: nVMX: Allow emulating RDPID on behalf of L2
      KVM: nVMX: Emulate HLT in L2 if it's not intercepted
      KVM: nVMX: Consolidate missing X86EMUL_INTERCEPTED logic in L2 emulation
      KVM: x86: Plumb the src/dst operand types through to .check_intercept()
      KVM: x86: Plumb the emulator's starting RIP into nested intercept checks
      KVM: x86: Add a #define for the architectural max instruction length
      KVM: nVMX: Allow the caller to provide instruction length on nested VM-Exit
      KVM: nVMX: Synthesize nested VM-Exit for supported emulation intercepts
      KVM: selftests: Add a nested (forced) emulation intercept test for x86
      KVM: x86: Don't inject PV async #PF if SEND_ALWAYS=0 and guest state is protected
      KVM: x86: Rename and invert async #PF's send_user_only flag to send_always
      KVM: x86: Use a dedicated flow for queueing re-injected exceptions
      KVM: VMX: Don't modify guest XFD_ERR if CR0.TS=1
      KVM: VMX: Pass XFD_ERR as pseudo-payload when injecting #NM
      KVM: x86: Don't load/put vCPU when unloading its MMU during teardown
      KVM: Assert that a destroyed/freed vCPU is no longer visible
      KVM: x86: Unload MMUs during vCPU destruction, not before
      KVM: x86: Fold guts of kvm_arch_sync_events() into kvm_arch_pre_destroy_vm()
      KVM: Drop kvm_arch_sync_events() now that all implementations are nops
      KVM: nVMX: Decouple EPT RWX bits from EPT Violation protection bits
      KVM: VMX: Reject KVM_RUN if userspace forces emulation during nested VM-Enter
      KVM: SVM: Inject #GP if memory operand for INVPCID is non-canonical
      KVM: selftests: Relax assertion on HLT exits if CPU supports Idle HLT
      KVM: x86: Always set mp_state to RUNNABLE on wakeup from HLT
      KVM: SVM: Refuse to attempt VRMUN if an SEV-ES+ guest has an invalid VMSA
      KVM: SVM: Don't change target vCPU state on AP Creation VMGEXIT error
      KVM: SVM: Require AP's "requested" SEV_FEATURES to match KVM's view
      KVM: SVM: Simplify request+kick logic in SNP AP Creation handling
      KVM: SVM: Use guard(mutex) to simplify SNP AP Creation error handling
      KVM: SVM: Mark VMCB dirty before processing incoming snp_vmsa_gpa
      KVM: SVM: Use guard(mutex) to simplify SNP vCPU state updates
      KVM: SVM: Invalidate "next" SNP VMSA GPA even on failure
      KVM: VMX: Extract checks on entry/exit control pairs to a helper macro

Sebastian Ott (5):
      KVM: arm64: Maintain per-VM copy of implementation ID regs
      KVM: arm64: Allow userspace to change the implementation ID registers
      KVM: selftests: arm64: Test writes to MIDR,REVIDR,AIDR
      KVM: arm64: Allow userspace to write ID_AA64MMFR0_EL1.TGRAN*_2
      KVM: arm64: selftests: Test that TGRAN*_2 fields are writable

Shameer Kolothum (7):
      arm64: Modify _midr_range() functions to read MIDR/REVIDR internally
      KVM: arm64: Specify hypercall ABI for retrieving target implementations
      KVM: arm64: Introduce KVM_REG_ARM_VENDOR_HYP_BMAP_2
      arm64: Make  _midr_in_range_list() an exported function
      smccc/kvm_guest: Enable errata based on implementation CPUs
      KVM: selftests: Add test for KVM_REG_ARM_VENDOR_HYP_BMAP_2
      smccc: kvm_guest: Fix kernel builds for 32 bit arm

Ted Chen (1):
      KVM: x86: Remove unused iommu_domain and iommu_noncoherent from kvm_arch

Vincent Donnefort (3):
      KVM: arm64: Add flags to kvm_hyp_memcache
      KVM: arm64: Distinct pKVM teardown memcache for stage-2
      KVM: arm64: Count pKVM stage-2 usage in secondary pagetable stats

Will Deacon (1):
      KVM: arm64: Tear down vGIC on failed vCPU creation

Xiaoyao Li (1):
      KVM: x86: Remove the unreachable case for 0x80000022 leaf in __do_cpuid_func()

 Documentation/virt/kvm/api.rst                     |  22 +
 Documentation/virt/kvm/arm/fw-pseudo-registers.rst |  15 +-
 Documentation/virt/kvm/arm/hypercalls.rst          |  59 +++
 Documentation/virt/kvm/devices/arm-vgic-its.rst    |   5 +-
 Documentation/virt/kvm/devices/arm-vgic-v3.rst     |  12 +-
 Documentation/virt/kvm/locking.rst                 |   4 +-
 arch/arm64/include/asm/apple_m1_pmu.h              |   1 +
 arch/arm64/include/asm/cpucaps.h                   |   2 +
 arch/arm64/include/asm/cpufeature.h                |  28 +-
 arch/arm64/include/asm/cputype.h                   |  40 +-
 arch/arm64/include/asm/hypervisor.h                |   1 +
 arch/arm64/include/asm/kvm_arm.h                   |   4 +-
 arch/arm64/include/asm/kvm_emulate.h               |  37 ++
 arch/arm64/include/asm/kvm_host.h                  |  67 ++-
 arch/arm64/include/asm/kvm_hyp.h                   |   2 +
 arch/arm64/include/asm/kvm_nested.h                |   1 +
 arch/arm64/include/asm/kvm_pkvm.h                  |   1 +
 arch/arm64/include/asm/mmu.h                       |   3 +-
 arch/arm64/include/asm/sysreg.h                    |  30 --
 arch/arm64/include/uapi/asm/kvm.h                  |  14 +
 arch/arm64/kernel/cpu_errata.c                     | 117 ++++-
 arch/arm64/kernel/cpufeature.c                     |  53 ++-
 arch/arm64/kernel/image-vars.h                     |   6 +-
 arch/arm64/kernel/proton-pack.c                    |  17 +-
 arch/arm64/kvm/Makefile                            |   2 +-
 arch/arm64/kvm/arm.c                               |  76 ++-
 arch/arm64/kvm/emulate-nested.c                    |  24 +-
 arch/arm64/kvm/handle_exit.c                       |   6 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h            |   4 +-
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h         |  14 +-
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h      |   2 +-
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h             |   6 -
 arch/arm64/kvm/hyp/nvhe/mem_protect.c              |   2 +-
 arch/arm64/kvm/hyp/nvhe/pkvm.c                     |  79 ++--
 arch/arm64/kvm/hyp/nvhe/sysreg-sr.c                |   4 +-
 arch/arm64/kvm/hyp/vgic-v3-sr.c                    |  16 +-
 arch/arm64/kvm/hyp/vhe/switch.c                    |  22 +
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c                 |  28 +-
 arch/arm64/kvm/hypercalls.c                        |  13 +
 arch/arm64/kvm/mmu.c                               |  22 +-
 arch/arm64/kvm/nested.c                            | 286 ++++++-----
 arch/arm64/kvm/pkvm.c                              |  75 +--
 arch/arm64/kvm/pmu-emul.c                          | 194 ++++----
 arch/arm64/kvm/pmu.c                               |  10 +-
 arch/arm64/kvm/reset.c                             |   3 -
 arch/arm64/kvm/sys_regs.c                          | 478 ++++++++++++-------
 arch/arm64/kvm/sys_regs.h                          |  10 +
 arch/arm64/kvm/vgic-sys-reg-v3.c                   |   8 +-
 arch/arm64/kvm/vgic/vgic-init.c                    |  29 ++
 arch/arm64/kvm/vgic/vgic-kvm-device.c              |  29 +-
 arch/arm64/kvm/vgic/vgic-v3-nested.c               | 409 ++++++++++++++++
 arch/arm64/kvm/vgic/vgic-v3.c                      |  46 +-
 arch/arm64/kvm/vgic/vgic-v4.c                      |  35 +-
 arch/arm64/kvm/vgic/vgic.c                         |  38 ++
 arch/arm64/kvm/vgic/vgic.h                         |   6 +
 arch/arm64/tools/cpucaps                           |   2 +
 arch/arm64/tools/sysreg                            |  48 ++
 arch/loongarch/include/asm/kvm_host.h              |   7 +-
 arch/loongarch/kernel/asm-offsets.c                |   1 +
 arch/loongarch/kvm/Kconfig                         |   1 +
 arch/loongarch/kvm/Makefile                        |   2 -
 arch/loongarch/kvm/main.c                          |   3 +
 arch/loongarch/kvm/switch.S                        |  12 +-
 arch/loongarch/kvm/vcpu.c                          |  37 ++
 arch/mips/include/asm/kvm_host.h                   |   1 -
 arch/powerpc/include/asm/kvm_host.h                |   1 -
 arch/riscv/include/asm/kvm_host.h                  |   2 -
 arch/riscv/kvm/main.c                              |   4 +-
 arch/riscv/kvm/vcpu_onereg.c                       |   2 +-
 arch/riscv/kvm/vcpu_pmu.c                          |   1 +
 arch/s390/include/asm/gmap.h                       |   1 -
 arch/s390/include/asm/kvm_host.h                   |   1 -
 arch/s390/include/asm/uv.h                         |   2 +-
 arch/s390/kernel/uv.c                              | 136 +++++-
 arch/s390/kvm/gmap.c                               | 103 +---
 arch/s390/kvm/kvm-s390.c                           |  25 +-
 arch/s390/mm/gmap.c                                |  28 --
 arch/x86/include/asm/cpufeatures.h                 |   1 +
 arch/x86/include/asm/kvm_host.h                    |  21 +-
 arch/x86/include/asm/sev-common.h                  |  12 +-
 arch/x86/include/asm/svm.h                         |   5 +-
 arch/x86/include/asm/vmx.h                         |  28 +-
 arch/x86/include/uapi/asm/kvm.h                    |   3 +
 arch/x86/include/uapi/asm/svm.h                    |   2 +
 arch/x86/kvm/Kconfig                               |   1 +
 arch/x86/kvm/cpuid.c                               |  68 ++-
 arch/x86/kvm/cpuid.h                               |   9 +-
 arch/x86/kvm/emulate.c                             |   5 +-
 arch/x86/kvm/i8259.c                               |   2 +-
 arch/x86/kvm/kvm_emulate.h                         |   7 +-
 arch/x86/kvm/lapic.c                               |  17 +-
 arch/x86/kvm/mmu/mmu.c                             | 363 ++++++++++----
 arch/x86/kvm/mmu/paging_tmpl.h                     |   3 +-
 arch/x86/kvm/mmu/spte.c                            |  31 +-
 arch/x86/kvm/mmu/spte.h                            |   2 +-
 arch/x86/kvm/mmu/tdp_iter.h                        |  34 +-
 arch/x86/kvm/mmu/tdp_mmu.c                         |  45 +-
 arch/x86/kvm/smm.c                                 |   2 +-
 arch/x86/kvm/svm/nested.c                          |   2 +-
 arch/x86/kvm/svm/sev.c                             | 377 +++++++--------
 arch/x86/kvm/svm/svm.c                             |  56 ++-
 arch/x86/kvm/svm/svm.h                             |  39 +-
 arch/x86/kvm/trace.h                               |  14 +-
 arch/x86/kvm/vmx/nested.c                          |  18 +-
 arch/x86/kvm/vmx/nested.h                          |  22 +-
 arch/x86/kvm/vmx/vmx.c                             | 226 ++++++---
 arch/x86/kvm/x86.c                                 | 342 +++++++-------
 arch/x86/kvm/x86.h                                 |   8 +
 arch/x86/kvm/xen.c                                 | 121 +++--
 arch/x86/kvm/xen.h                                 |  30 +-
 drivers/clocksource/arm_arch_timer.c               |   2 +-
 drivers/firmware/smccc/kvm_guest.c                 |  66 +++
 drivers/hwtracing/coresight/coresight-etm4x-core.c |   2 +-
 drivers/irqchip/irq-apple-aic.c                    |   8 +-
 drivers/perf/apple_m1_cpu_pmu.c                    | 101 +++-
 include/kvm/arm_pmu.h                              |  17 +-
 include/kvm/arm_vgic.h                             |  10 +
 include/linux/arm-smccc.h                          |  15 +
 include/linux/kvm_host.h                           |   2 +-
 include/linux/perf/arm_pmu.h                       |   4 +
 include/uapi/linux/kvm.h                           |   1 +
 tools/arch/arm/include/uapi/asm/kvm.h              |   1 +
 tools/arch/arm64/include/asm/sysreg.h              |  30 --
 tools/arch/arm64/include/uapi/asm/kvm.h            |  12 +
 tools/testing/selftests/kvm/Makefile.kvm           |   1 +
 .../selftests/kvm/access_tracking_perf_test.c      |   2 +-
 tools/testing/selftests/kvm/arm64/get-reg-list.c   |   1 +
 tools/testing/selftests/kvm/arm64/hypercalls.c     |  46 +-
 tools/testing/selftests/kvm/arm64/set_id_regs.c    |  40 +-
 tools/testing/selftests/kvm/dirty_log_test.c       | 521 ++++++++++-----------
 tools/testing/selftests/kvm/include/kvm_util.h     |  33 +-
 tools/testing/selftests/kvm/include/test_util.h    |   2 +-
 .../testing/selftests/kvm/include/x86/processor.h  |  50 +-
 tools/testing/selftests/kvm/kvm_create_max_vcpus.c |  28 +-
 tools/testing/selftests/kvm/lib/kvm_util.c         | 114 +++--
 tools/testing/selftests/kvm/lib/userfaultfd_util.c |   2 +-
 tools/testing/selftests/kvm/riscv/sbi_pmu_test.c   |  81 +++-
 .../kvm/x86/dirty_log_page_splitting_test.c        |   6 +-
 tools/testing/selftests/kvm/x86/hyperv_ipi.c       |   6 +-
 .../selftests/kvm/x86/nested_emulation_test.c      | 146 ++++++
 .../testing/selftests/kvm/x86/nx_huge_pages_test.c |   4 +-
 .../testing/selftests/kvm/x86/pmu_counters_test.c  | 158 ++++---
 tools/testing/selftests/kvm/x86/svm_int_ctl_test.c |   5 +-
 .../selftests/kvm/x86/ucna_injection_test.c        |   2 +-
 tools/testing/selftests/kvm/x86/xapic_ipi_test.c   |  16 +-
 tools/testing/selftests/kvm/x86/xapic_state_test.c |   4 +-
 tools/testing/selftests/kvm/x86/xen_shinfo_test.c  |   5 +-
 virt/kvm/Kconfig                                   |   4 +
 virt/kvm/kvm_main.c                                |  62 ++-
 149 files changed, 4313 insertions(+), 2150 deletions(-)
 create mode 100644 arch/arm64/kvm/vgic/vgic-v3-nested.c
 create mode 100644 tools/testing/selftests/kvm/x86/nested_emulation_test.c


