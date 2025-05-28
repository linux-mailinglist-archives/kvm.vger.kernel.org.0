Return-Path: <kvm+bounces-47903-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B743AC6F3B
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 19:26:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 29553189C048
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 17:25:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F57D28E562;
	Wed, 28 May 2025 17:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ddkDK2ek"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1C65288C19
	for <kvm@vger.kernel.org>; Wed, 28 May 2025 17:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748453084; cv=none; b=H67PtqNPOraVDq1DJncLNXn0T1YYZGCx9HJAgd1ricYDO7JGUmBVu49G1kxrRDJECRVBCtQSb6BgHq6r3P4D3iEcWBrR7Adc8kQB9l756YzRALlGXa4f0VLwMJgGfFbSYelnVymDAbLy0cqjYDqcmo5TvlA1yfZSoXfeGdB58XA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748453084; c=relaxed/simple;
	bh=NPqHxRv5sCclcZnY4YQwfwiSifdJTM+m76LyYyuNVwM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=E4YAb4GRUZ20QUnutRz0jpTmG4nLzHpGZRrYeqobgJRnz2y280KkfccymREeTyK104PLjl3QCs9tzzd1N7FDyX3Owogu3kTao/O3WZi8QjOXITOOwlPpIjJq1sDQB905NCwPSkKLje3HimsxVcD1KFRiTVtAQ6EE6CpvfikyO6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ddkDK2ek; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748453080;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=6K0SImNSnMbT4NMXaJ8u4klPMFPkFvl0Elczblh1PaU=;
	b=ddkDK2ekPfp6mjnUWvoGjTMkxsJnbeJ+lD32R+oNUJmmblBO1iY7xlMGd6WYsksIOhIFk1
	QB7cblwrG9wG5rPyPJHK9i5klTCkUWmp+0tV5oDbVzRBhAf4RjCyeGvJ1AaDG1jaNOmBWe
	VQqOjCeAytChdPVnTgbX7xkEBBqT5hY=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-454-f6dGrwitNCi3_DSVK2u6dw-1; Wed,
 28 May 2025 13:24:34 -0400
X-MC-Unique: f6dGrwitNCi3_DSVK2u6dw-1
X-Mimecast-MFC-AGG-ID: f6dGrwitNCi3_DSVK2u6dw_1748453074
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C454D1800258;
	Wed, 28 May 2025 17:24:33 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0CC1719560AA;
	Wed, 28 May 2025 17:24:32 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [GIT PULL] First batch of KVM changes for Linux 6.16 merge window
Date: Wed, 28 May 2025 13:24:30 -0400
Message-ID: <20250528172432.8396-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Linus,

The following changes since commit a5806cd506af5a7c19bcd596e4708b5c464bfd21:

  Linux 6.15-rc7 (2025-05-18 13:57:29 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to e9f17038d814c0185e017a3fa62305a12d52f45c:

  x86/tdx: mark tdh_vp_enter() as __flatten (2025-05-26 16:45:07 -0400)

As far as x86 goes this pull request "only" includes TDX host support.
Quotes are appropriate because (at 6k lines and 100+ commits) it is
much bigger than the rest, which will come later this week and consists
mostly of bugfixes and selftests.  s390 changes will also come in the
second batch.

All the changes in arch/x86/virt/ have Dave Hansen's ACK.

----------------------------------------------------------------
ARM:

* Add large stage-2 mapping (THP) support for non-protected guests when
  pKVM is enabled, clawing back some performance.

* Enable nested virtualisation support on systems that support it,
  though it is disabled by default.

* Add UBSAN support to the standalone EL2 object used in nVHE/hVHE and
  protected modes.

* Large rework of the way KVM tracks architecture features and links
  them with the effects of control bits. While this has no functional
  impact, it ensures correctness of emulation (the data is automatically
  extracted from the published JSON files), and helps dealing with the
  evolution of the architecture.

* Significant changes to the way pKVM tracks ownership of pages,
  avoiding page table walks by storing the state in the hypervisor's
  vmemmap. This in turn enables the THP support described above.

* New selftest checking the pKVM ownership transition rules

* Fixes for FEAT_MTE_ASYNC being accidentally advertised to guests
  even if the host didn't have it.

* Fixes for the address translation emulation, which happened to be
  rather buggy in some specific contexts.

* Fixes for the PMU emulation in NV contexts, decoupling PMCR_EL0.N
  from the number of counters exposed to a guest and addressing a
  number of issues in the process.

* Add a new selftest for the SVE host state being corrupted by a
  guest.

* Keep HCR_EL2.xMO set at all times for systems running with the
  kernel at EL2, ensuring that the window for interrupts is slightly
  bigger, and avoiding a pretty bad erratum on the AmpereOne HW.

* Add workaround for AmpereOne's erratum AC04_CPU_23, which suffers
  from a pretty bad case of TLB corruption unless accesses to HCR_EL2
  are heavily synchronised.

* Add a per-VM, per-ITS debugfs entry to dump the state of the ITS
  tables in a human-friendly fashion.

* and the usual random cleanups.

LoongArch:

* Don't flush tlb if the host supports hardware page table walks.

* Add KVM selftests support.

RISC-V:

* Add vector registers to get-reg-list selftest

* VCPU reset related improvements

* Remove scounteren initialization from VCPU reset

* Support VCPU reset from userspace using set_mpstate() ioctl

x86:

* Initial support for TDX in KVM.  This finally makes it possible to use the
  TDX module to run confidential guests on Intel processors.  This is quite a
  large series, including support for private page tables (managed by the
  TDX module and mirrored in KVM for efficiency), forwarding some TDVMCALLs
  to userspace, and handling several special VM exits from the TDX module.

  This has been in the works for literally years and it's not really possible
  to describe everything here, so I'll defer to the various merge commits
  up to and including commit 7bcf7246c42a ("Merge branch 'kvm-tdx-finish-initial'
  into HEAD").

----------------------------------------------------------------
Adrian Hunter (2):
      KVM: TDX: Disable support for TSX and WAITPKG
      KVM: TDX: Save and restore IA32_DEBUGCTL

Atish Patra (5):
      KVM: riscv: selftests: Align the trap information wiht pt_regs
      KVM: riscv: selftests: Decode stval to identify exact exception type
      KVM: riscv: selftests: Add vector extension tests
      RISC-V: KVM: Remove experimental tag for RISC-V
      RISC-V: KVM: Remove scounteren initialization

Ben Horgan (3):
      arm64/sysreg: Expose MTE_frac so that it is visible to KVM
      KVM: arm64: Make MTE_frac masking conditional on MTE capability
      KVM: selftests: Confirm exposing MTE_frac does not break migration

Bibo Mao (7):
      LoongArch: KVM: Add ecode parameter for exception handlers
      LoongArch: KVM: Do not flush tlb if HW PTW supported
      KVM: selftests: Add VM_MODE_P47V47_16K VM mode
      KVM: selftests: Add KVM selftests header files for LoongArch
      KVM: selftests: Add core KVM selftests support for LoongArch
      KVM: selftests: Add ucall test support for LoongArch
      KVM: selftests: Add supported test cases for LoongArch

Binbin Wu (8):
      KVM: VMX: Move common fields of struct vcpu_{vmx,tdx} to a struct
      KVM: x86: Have ____kvm_emulate_hypercall() read the GPRs
      KVM: x86: Move pv_unhalted check out of kvm_vcpu_has_events()
      KVM: TDX: Handle TDG.VP.VMCALL<MapGPA>
      KVM: TDX: Handle TDG.VP.VMCALL<ReportFatalError>
      KVM: TDX: Enforce KVM_IRQCHIP_SPLIT for TDX guests
      KVM: VMX: Move emulation_required to struct vcpu_vt
      KVM: TDX: Enable guest access to MTRR MSRs

Chao Gao (1):
      KVM: x86: Allow to update cached values in kvm_user_return_msrs w/o wrmsr

D Scott Phillips (1):
      arm64: errata: Work around AmpereOne's erratum AC04_CPU_23

David Brazdil (1):
      KVM: arm64: Add .hyp.data section

Fuad Tabba (1):
      KVM: arm64: Track SVE state in the hypervisor vcpu structure

Gavin Shan (1):
      KVM: arm64: Drop sort_memblock_regions()

Isaku Yamahata (66):
      x86/virt/tdx: Add tdx_guest_keyid_alloc/free() to alloc and free TDX guest KeyID
      KVM: TDX: Add placeholders for TDX VM/vCPU structures
      KVM: TDX: Define TDX architectural definitions
      KVM: TDX: Add helper functions to print TDX SEAMCALL error
      KVM: TDX: Add place holder for TDX VM specific mem_enc_op ioctl
      KVM: TDX: Get system-wide info about TDX module on initialization
      KVM: TDX: create/destroy VM structure
      KVM: TDX: Support per-VM KVM_CAP_MAX_VCPUS extension check
      KVM: TDX: add ioctl to initialize VM with TDX specific parameters
      KVM: TDX: Make pmu_intel.c ignore guest TD case
      KVM: TDX: Don't offline the last cpu of one package when there's TDX guest
      KVM: TDX: create/free TDX vcpu structure
      x86/virt/tdx: Add SEAMCALL wrapper tdh_mem_sept_add() to add SEPT pages
      KVM: TDX: Do TDX specific vcpu initialization
      x86/virt/tdx: Add SEAMCALL wrappers to add TD private pages
      x86/virt/tdx: Add SEAMCALL wrappers to manage TDX TLB tracking
      x86/virt/tdx: Add SEAMCALL wrappers to remove a TD private page
      x86/virt/tdx: Add SEAMCALL wrappers for TD measurement of initial contents
      KVM: x86/tdp_mmu: Add a helper function to walk down the TDP MMU
      KVM: TDX: Add accessors VMX VMCS helpers
      KVM: TDX: Set gfn_direct_bits to shared bit
      KVM: TDX: Require TDP MMU, mmio caching and EPT A/D bits for TDX
      KVM: x86/mmu: Add setter for shadow_mmio_value
      KVM: TDX: Set per-VM shadow_mmio_value to 0
      KVM: TDX: Handle TLB tracking for TDX
      KVM: TDX: Implement hooks to propagate changes of TDP MMU mirror page table
      KVM: TDX: Implement hook to get max mapping level of private pages
      KVM: TDX: Add an ioctl to create initial guest memory
      KVM: TDX: Finalize VM initialization
      KVM: TDX: Handle vCPU dissociation
      KVM: TDX: Implement TDX vcpu enter/exit path
      KVM: TDX: vcpu_run: save/restore host state(host kernel gs)
      KVM: TDX: restore host xsave state when exit from the guest TD
      KVM: TDX: restore user ret MSRs
      KVM: TDX: Add a place holder to handle TDX VM exit
      KVM: x86: Add a switch_db_regs flag to handle TDX's auto-switched behavior
      KVM: TDX: Add a place holder for handler of TDX hypercalls (TDG.VP.VMCALL)
      KVM: TDX: Disable PI wakeup for IPIv
      KVM: TDX: Handle KVM hypercall with TDG.VP.VMCALL
      KVM: VMX: Move posted interrupt delivery code to common header
      KVM: TDX: Implement non-NMI interrupt injection
      KVM: TDX: Handle TDX PV port I/O hypercall
      KVM: TDX: Wait lapic expire when timer IRQ was injected
      KVM: TDX: Implement methods to inject NMI
      KVM: TDX: Handle SMI request as !CONFIG_KVM_SMM
      KVM: TDX: Always block INIT/SIPI
      KVM: TDX: Force APICv active for TDX guest
      KVM: TDX: Add methods to ignore virtual apic related operation
      KVM: TDX: Handle EPT violation/misconfig exit
      KVM: TDX: Handle EXCEPTION_NMI and EXTERNAL_INTERRUPT
      KVM: TDX: Handle EXIT_REASON_OTHER_SMI
      KVM: TDX: Handle TDX PV CPUID hypercall
      KVM: TDX: Handle TDX PV HLT hypercall
      KVM: x86: Move KVM_MAX_MCE_BANKS to header file
      KVM: TDX: Implement callbacks for MSR operations
      KVM: TDX: Handle TDX PV rdmsr/wrmsr hypercall
      KVM: TDX: Enable guest access to LMCE related MSRs
      KVM: TDX: Handle TDG.VP.VMCALL<GetTdVmCallInfo> hypercall
      KVM: TDX: Add methods to ignore accesses to CPU state
      KVM: TDX: Add method to ignore guest instruction emulation
      KVM: TDX: Add methods to ignore VMX preemption timer
      KVM: TDX: Add methods to ignore accesses to TSC
      KVM: TDX: Ignore setting up mce
      KVM: TDX: Add a method to ignore hypercall patching
      KVM: TDX: Make TDX VM type supported
      Documentation/virt/kvm: Document on Trust Domain Extensions (TDX)

Jing Zhang (1):
      KVM: arm64: vgic-its: Add debugfs interface to expose ITS tables

Kai Huang (6):
      x86/virt/tdx: Read essential global metadata for KVM
      KVM: Export hardware virtualization enabling/disabling functions
      KVM: VMX: Refactor VMX module init/exit functions
      KVM: VMX: Initialize TDX during KVM module load
      KVM: TDX: Get TDX global information
      x86/virt/tdx: Add SEAMCALL wrapper to enter/exit TDX guest

Marc Zyngier (84):
      KVM: arm64: Repaint pmcr_n into nr_pmu_counters
      KVM: arm64: Fix MDCR_EL2.HPMN reset value
      KVM: arm64: Contextualise the handling of PMCR_EL0.P writes
      KVM: arm64: Allow userspace to limit the number of PMU counters for EL2 VMs
      KVM: arm64: Don't let userspace write to PMCR_EL0.N when the vcpu has EL2
      KVM: arm64: Handle out-of-bound write to MDCR_EL2.HPMN
      KVM: arm64: Let kvm_vcpu_read_pmcr() return an EL-dependent value for PMCR_EL0.N
      Merge branch kvm-arm64/nv-pmu-fixes into kvmarm-master/next
      KVM: arm64: Force HCR_EL2.xMO to 1 at all times in VHE mode
      arm64: sysreg: Add ID_AA64ISAR1_EL1.LS64 encoding for FEAT_LS64WB
      arm64: sysreg: Update ID_AA64MMFR4_EL1 description
      arm64: sysreg: Add layout for HCR_EL2
      arm64: sysreg: Replace HFGxTR_EL2 with HFG{R,W}TR_EL2
      arm64: sysreg: Update ID_AA64PFR0_EL1 description
      arm64: sysreg: Update PMSIDR_EL1 description
      arm64: sysreg: Update TRBIDR_EL1 description
      arm64: sysreg: Update CPACR_EL1 description
      arm64: sysreg: Add registers trapped by HFG{R,W}TR2_EL2
      arm64: sysreg: Add registers trapped by HDFG{R,W}TR2_EL2
      arm64: sysreg: Add system instructions trapped by HFGIRT2_EL2
      arm64: Remove duplicated sysreg encodings
      arm64: tools: Resync sysreg.h
      arm64: Add syndrome information for trapped LD64B/ST64B{,V,V0}
      arm64: Add FEAT_FGT2 capability
      KVM: arm64: Tighten handling of unknown FGT groups
      KVM: arm64: Simplify handling of negative FGT bits
      KVM: arm64: Handle trapping of FEAT_LS64* instructions
      KVM: arm64: Restrict ACCDATA_EL1 undef to FEAT_LS64_ACCDATA being disabled
      KVM: arm64: Don't treat HCRX_EL2 as a FGT register
      KVM: arm64: Plug FEAT_GCS handling
      KVM: arm64: Compute FGT masks from KVM's own FGT tables
      KVM: arm64: Add description of FGT bits leading to EC!=0x18
      KVM: arm64: Use computed masks as sanitisers for FGT registers
      KVM: arm64: Propagate FGT masks to the nVHE hypervisor
      KVM: arm64: Use computed FGT masks to setup FGT registers
      KVM: arm64: Remove hand-crafted masks for FGT registers
      KVM: arm64: Use KVM-specific HCRX_EL2 RES0 mask
      KVM: arm64: Handle PSB CSYNC traps
      KVM: arm64: Switch to table-driven FGU configuration
      KVM: arm64: Validate FGT register descriptions against RES0 masks
      KVM: arm64: Fix PAR_EL1.{PTW,S} reporting on AT S1E*
      KVM: arm64: Teach address translation about access faults
      KVM: arm64: Don't feed uninitialised data to HCR_EL2
      arm64: sysreg: Add layout for VNCR_EL2
      KVM: arm64: nv: Allocate VNCR page when required
      KVM: arm64: nv: Extract translation helper from the AT code
      KVM: arm64: nv: Snapshot S1 ASID tagging information during walk
      KVM: arm64: nv: Move TLBI range decoding to a helper
      KVM: arm64: nv: Don't adjust PSTATE.M when L2 is nesting
      KVM: arm64: nv: Add pseudo-TLB backing VNCR_EL2
      KVM: arm64: nv: Add userspace and guest handling of VNCR_EL2
      KVM: arm64: nv: Handle VNCR_EL2-triggered faults
      KVM: arm64: nv: Handle mapping of VNCR_EL2 at EL2
      KVM: arm64: nv: Handle VNCR_EL2 invalidation from MMU notifiers
      KVM: arm64: nv: Program host's VNCR_EL2 to the fixmap address
      KVM: arm64: nv: Add S1 TLB invalidation primitive for VNCR_EL2
      KVM: arm64: nv: Plumb TLBI S1E2 into system instruction dispatch
      KVM: arm64: nv: Remove dead code from ERET handling
      KVM: arm64: Allow userspace to request KVM_ARM_VCPU_EL2*
      KVM: arm64: Document NV caps and vcpu flags
      KVM: arm64: Use FGT feature maps to drive RES0 bits
      KVM: arm64: Allow kvm_has_feat() to take variable arguments
      KVM: arm64: Use HCRX_EL2 feature map to drive fixed-value bits
      KVM: arm64: Use HCR_EL2 feature map to drive fixed-value bits
      KVM: arm64: Add FEAT_FGT2 registers to the VNCR page
      KVM: arm64: Add sanitisation for FEAT_FGT2 registers
      KVM: arm64: Add trap routing for FEAT_FGT2 registers
      KVM: arm64: Add context-switch for FEAT_FGT2 registers
      KVM: arm64: Allow sysreg ranges for FGT descriptors
      KVM: arm64: Add FGT descriptors for FEAT_FGT2
      KVM: arm64: Handle TSB CSYNC traps
      KVM: arm64: nv: Hold mmu_lock when invalidating VNCR SW-TLB before translating
      KVM: arm64: nv: Handle TLBI S1E2 for VNCR invalidation with mmu_lock held
      KVM: arm64: nv: Release faulted-in VNCR page from mmu_lock critical section
      Merge branch kvm-arm64/pkvm-6.16 into kvm-arm64/pkvm-np-thp-6.16
      Merge branch kvm-arm64/pkvm-selftest-6.16 into kvm-arm64/pkvm-np-thp-6.16
      KVM: arm64: Fix documentation for vgic_its_iter_next()
      Merge branch kvm-arm64/pkvm-np-thp-6.16 into kvmarm-master/next
      Merge branch kvm-arm64/ubsan-el2 into kvmarm-master/next
      Merge branch kvm-arm64/mte-frac into kvmarm-master/next
      Merge branch kvm-arm64/fgt-masks into kvmarm-master/next
      Merge branch kvm-arm64/at-fixes-6.16 into kvmarm-master/next
      Merge branch kvm-arm64/nv-nv into kvmarm-master/next
      Merge branch kvm-arm64/misc-6.16 into kvmarm-master/next

Mark Brown (1):
      KVM: arm64: selftests: Add test for SVE host corruption

Mark Rutland (1):
      KVM: arm64: Unconditionally configure fine-grain traps

Mostafa Saleh (4):
      arm64: Introduce esr_is_ubsan_brk()
      ubsan: Remove regs from report_ubsan_failure()
      KVM: arm64: Introduce CONFIG_UBSAN_KVM_EL2
      KVM: arm64: Handle UBSAN faults

Paolo Bonzini (23):
      x86/virt/tdx: allocate tdx_sys_info in static memory
      KVM: x86: expose cpuid_entry2_find for TDX
      KVM: TDX: Skip updating CPU dirty logging request for TDs
      KVM: x86: do not allow re-enabling quirks
      KVM: x86: Allow vendor code to disable quirks
      KVM: x86: remove shadow_memtype_mask
      Merge branch 'kvm-tdx-initialization' into HEAD
      Merge branch 'kvm-tdx-mmu' into HEAD
      Merge branch 'kvm-tdx-enter-exit' into HEAD
      Merge branch 'kvm-tdx-userspace-exit' into HEAD
      Merge branch 'kvm-tdx-interrupts' into HEAD
      Merge branch 'kvm-tdx-finish-initial' into HEAD
      Merge tag 'kvm-s390-next-6.15-1' of https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux into HEAD
      Merge branch 'kvm-6.15-rc2-cleanups' into HEAD
      Merge branch 'kvm-6.15-rc2-fixes' into HEAD
      Merge branch 'kvm-pi-fix-lockdep' into HEAD
      Merge branch 'kvm-tdx-initial' into HEAD
      Merge branch 'kvm-fixes-6.15-rc4' into HEAD
      Documentation: virt/kvm: remove unreferenced footnote
      Merge tag 'loongarch-kvm-6.16' of git://git.kernel.org/pub/scm/linux/kernel/git/chenhuacai/linux-loongson into HEAD
      Merge tag 'kvmarm-6.16' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD
      Merge tag 'kvm-riscv-6.16-1' of https://github.com/kvm-riscv/linux into HEAD
      x86/tdx: mark tdh_vp_enter() as __flatten

Quentin Perret (11):
      KVM: arm64: Fix pKVM page-tracking comments
      KVM: arm64: Use 0b11 for encoding PKVM_NOPAGE
      KVM: arm64: Introduce {get,set}_host_state() helpers
      KVM: arm64: Move hyp state to hyp_vmemmap
      KVM: arm64: Defer EL2 stage-1 mapping on share
      KVM: arm64: Unconditionally cross check hyp state
      KVM: arm64: Don't WARN from __pkvm_host_share_guest()
      KVM: arm64: Selftest for pKVM transitions
      KVM: arm64: Extend pKVM selftest for np-guests
      KVM: arm64: Convert pkvm_mappings to interval tree
      KVM: arm64: Add a range to pkvm_mappings

Radim Krčmář (5):
      KVM: RISC-V: refactor vector state reset
      KVM: RISC-V: refactor sbi reset request
      KVM: RISC-V: remove unnecessary SBI reset state
      RISC-V: KVM: add KVM_CAP_RISCV_MP_STATE_RESET
      RISC-V: KVM: lock the correct mp_state during reset

Rick Edgecombe (9):
      x86/virt/tdx: Add SEAMCALL wrappers for TDX KeyID management
      x86/virt/tdx: Add SEAMCALL wrappers for TDX TD creation
      x86/virt/tdx: Add SEAMCALL wrappers for TDX vCPU creation
      x86/virt/tdx: Add SEAMCALL wrappers for TDX page cache management
      x86/virt/tdx: Add SEAMCALL wrappers for TDX VM/vCPU field access
      x86/virt/tdx: Add SEAMCALL wrappers for TDX flush operations
      KVM: x86/mmu: Implement memslot deletion for TDX
      KVM: VMX: Teach EPT violation helper about private mem
      KVM: x86/mmu: Export kvm_tdp_map_page()

Sean Christopherson (7):
      KVM: TDX: Add TDX "architectural" error codes
      KVM: VMX: Split out guts of EPT violation to common/exposed function
      KVM: TDX: Add load_mmu_pgd method for TDX
      KVM: TDX: Add support for find pending IRQ in a protected local APIC
      KVM: x86: Assume timer IRQ was injected if APIC state is protected
      KVM: TDX: Handle TDX PV MMIO hypercall
      KVM: VMX: Add a helper for NMI handling

Seongsu Park (1):
      KVM: arm64: Replace ternary flags with str_on_off() helper

Vincent Donnefort (8):
      KVM: arm64: Handle huge mappings for np-guest CMOs
      KVM: arm64: Introduce for_each_hyp_page
      KVM: arm64: Add a range to __pkvm_host_share_guest()
      KVM: arm64: Add a range to __pkvm_host_unshare_guest()
      KVM: arm64: Add a range to __pkvm_host_wrprotect_guest()
      KVM: arm64: Add a range to __pkvm_host_test_clear_young_guest()
      KVM: arm64: Stage-2 huge mappings for np-guests
      KVM: arm64: np-guest CMOs with PMD_SIZE fixmap

Wei-Lin Chang (1):
      KVM: arm64: nv: Remove clearing of ICH_LR<n>.EOI if ICH_LR<n>.HW == 1

Xiaoyao Li (2):
      KVM: x86: Introduce KVM_TDX_GET_CPUID
      KVM: x86/mmu: Taking guest pa into consideration when calculate tdp level

Yan Zhao (12):
      KVM: x86/mmu: Do not enable page track for TD guest
      KVM: x86/mmu: Bail out kvm_tdp_map_page() when VM dead
      KVM: Add parameter "kvm" to kvm_cpu_dirty_log_size() and its callers
      KVM: x86/mmu: Add parameter "kvm" to kvm_mmu_page_ad_need_write_protect()
      KVM: x86: Make cpu_dirty_log_size a per-VM value
      KVM: TDX: Handle SEPT zap error due to page add error in premap
      KVM: TDX: Detect unexpected SEPT violations due to pending SPTEs
      KVM: TDX: Retry locally in TDX EPT violation handler on RET_PF_RETRY
      KVM: TDX: Kick off vCPUs when SEAMCALL is busy during TD page removal
      KVM: x86: Introduce supported_quirks to block disabling quirks
      KVM: x86: Introduce Intel specific quirk KVM_X86_QUIRK_IGNORE_GUEST_PAT
      KVM: TDX: KVM: TDX: Always honor guest PAT on TDX enabled guests

Zhiming Hu (1):
      KVM: TDX: Register TDX host key IDs to cgroup misc controller

 Documentation/arch/arm64/silicon-errata.rst        |    2 +
 Documentation/virt/kvm/api.rst                     |   66 +-
 Documentation/virt/kvm/devices/vcpu.rst            |   24 +
 Documentation/virt/kvm/x86/index.rst               |    1 +
 Documentation/virt/kvm/x86/intel-tdx.rst           |  255 ++
 MAINTAINERS                                        |    2 +
 arch/arm64/Kconfig                                 |   17 +
 arch/arm64/include/asm/el2_setup.h                 |   16 +-
 arch/arm64/include/asm/esr.h                       |   17 +-
 arch/arm64/include/asm/fixmap.h                    |    6 +
 arch/arm64/include/asm/hardirq.h                   |    4 +-
 arch/arm64/include/asm/kvm_arm.h                   |  184 +-
 arch/arm64/include/asm/kvm_host.h                  |   88 +-
 arch/arm64/include/asm/kvm_nested.h                |  100 +
 arch/arm64/include/asm/kvm_pgtable.h               |    7 +-
 arch/arm64/include/asm/kvm_pkvm.h                  |    8 +
 arch/arm64/include/asm/sections.h                  |    1 +
 arch/arm64/include/asm/sysreg.h                    |   53 +-
 arch/arm64/include/asm/vncr_mapping.h              |    5 +
 arch/arm64/include/uapi/asm/kvm.h                  |    9 +-
 arch/arm64/kernel/cpu_errata.c                     |   14 +
 arch/arm64/kernel/cpufeature.c                     |    8 +
 arch/arm64/kernel/hyp-stub.S                       |    2 +-
 arch/arm64/kernel/image-vars.h                     |    2 +
 arch/arm64/kernel/traps.c                          |    4 +-
 arch/arm64/kernel/vmlinux.lds.S                    |   18 +-
 arch/arm64/kvm/Makefile                            |    2 +-
 arch/arm64/kvm/arm.c                               |   30 +
 arch/arm64/kvm/at.c                                |  186 +-
 arch/arm64/kvm/config.c                            | 1085 ++++++
 arch/arm64/kvm/emulate-nested.c                    |  590 ++--
 arch/arm64/kvm/handle_exit.c                       |   84 +
 arch/arm64/kvm/hyp/include/hyp/switch.h            |  160 +-
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h      |   14 +-
 arch/arm64/kvm/hyp/include/nvhe/memory.h           |   58 +-
 arch/arm64/kvm/hyp/include/nvhe/mm.h               |    4 +-
 arch/arm64/kvm/hyp/nvhe/Makefile                   |    6 +
 arch/arm64/kvm/hyp/nvhe/host.S                     |    2 +-
 arch/arm64/kvm/hyp/nvhe/hyp-init.S                 |    4 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c                 |   20 +-
 arch/arm64/kvm/hyp/nvhe/hyp.lds.S                  |    2 +
 arch/arm64/kvm/hyp/nvhe/mem_protect.c              |  510 ++-
 arch/arm64/kvm/hyp/nvhe/mm.c                       |   97 +-
 arch/arm64/kvm/hyp/nvhe/pkvm.c                     |   47 +-
 arch/arm64/kvm/hyp/nvhe/setup.c                    |   27 +-
 arch/arm64/kvm/hyp/nvhe/switch.c                   |   14 +-
 arch/arm64/kvm/hyp/pgtable.c                       |    6 -
 arch/arm64/kvm/hyp/vgic-v3-sr.c                    |   12 +-
 arch/arm64/kvm/hyp/vhe/switch.c                    |   48 +-
 arch/arm64/kvm/hyp/vhe/tlb.c                       |    4 +-
 arch/arm64/kvm/mmu.c                               |    6 +-
 arch/arm64/kvm/nested.c                            |  846 +++--
 arch/arm64/kvm/pkvm.c                              |  164 +-
 arch/arm64/kvm/pmu-emul.c                          |   60 +-
 arch/arm64/kvm/reset.c                             |    2 +
 arch/arm64/kvm/sys_regs.c                          |  273 +-
 arch/arm64/kvm/trace_arm.h                         |    6 +-
 arch/arm64/kvm/vgic/vgic-debug.c                   |  224 ++
 arch/arm64/kvm/vgic/vgic-its.c                     |   39 +-
 arch/arm64/kvm/vgic/vgic-v3-nested.c               |    3 -
 arch/arm64/kvm/vgic/vgic.h                         |   33 +
 arch/arm64/tools/cpucaps                           |    2 +
 arch/arm64/tools/sysreg                            | 1012 +++++-
 arch/loongarch/include/asm/kvm_host.h              |    2 +-
 arch/loongarch/include/asm/kvm_vcpu.h              |    2 +-
 arch/loongarch/kvm/exit.c                          |   37 +-
 arch/loongarch/kvm/mmu.c                           |   15 +-
 arch/riscv/include/asm/kvm_aia.h                   |    3 -
 arch/riscv/include/asm/kvm_host.h                  |   17 +-
 arch/riscv/include/asm/kvm_vcpu_sbi.h              |    3 +
 arch/riscv/include/asm/kvm_vcpu_vector.h           |    6 +-
 arch/riscv/kernel/head.S                           |   10 +
 arch/riscv/kvm/Kconfig                             |    2 +-
 arch/riscv/kvm/aia_device.c                        |    4 +-
 arch/riscv/kvm/vcpu.c                              |   64 +-
 arch/riscv/kvm/vcpu_sbi.c                          |   32 +-
 arch/riscv/kvm/vcpu_sbi_hsm.c                      |   13 +-
 arch/riscv/kvm/vcpu_sbi_system.c                   |   10 +-
 arch/riscv/kvm/vcpu_vector.c                       |   13 +-
 arch/riscv/kvm/vm.c                                |   13 +
 arch/x86/include/asm/kvm-x86-ops.h                 |    5 +-
 arch/x86/include/asm/kvm_host.h                    |   34 +-
 arch/x86/include/asm/posted_intr.h                 |    5 +
 arch/x86/include/asm/shared/tdx.h                  |    9 +-
 arch/x86/include/asm/tdx.h                         |   75 +
 .../vmx/tdx => include/asm}/tdx_global_metadata.h  |   19 +
 arch/x86/include/asm/vmx.h                         |    2 +
 arch/x86/include/uapi/asm/kvm.h                    |   71 +
 arch/x86/include/uapi/asm/vmx.h                    |    5 +-
 arch/x86/kernel/traps.c                            |    2 +-
 arch/x86/kvm/Kconfig                               |   12 +
 arch/x86/kvm/Makefile                              |    1 +
 arch/x86/kvm/cpuid.c                               |   52 +-
 arch/x86/kvm/cpuid.h                               |   33 +-
 arch/x86/kvm/irq.c                                 |    3 +
 arch/x86/kvm/lapic.c                               |   15 +-
 arch/x86/kvm/lapic.h                               |    2 +
 arch/x86/kvm/mmu.h                                 |    6 +-
 arch/x86/kvm/mmu/mmu.c                             |   39 +-
 arch/x86/kvm/mmu/mmu_internal.h                    |    5 +-
 arch/x86/kvm/mmu/page_track.c                      |    3 +
 arch/x86/kvm/mmu/spte.c                            |   29 +-
 arch/x86/kvm/mmu/spte.h                            |    1 -
 arch/x86/kvm/mmu/tdp_mmu.c                         |   49 +-
 arch/x86/kvm/smm.h                                 |    3 +
 arch/x86/kvm/svm/svm.c                             |    1 +
 arch/x86/kvm/vmx/common.h                          |  182 +
 arch/x86/kvm/vmx/main.c                            | 1121 ++++++-
 arch/x86/kvm/vmx/nested.c                          |   12 +-
 arch/x86/kvm/vmx/pmu_intel.c                       |   52 +-
 arch/x86/kvm/vmx/pmu_intel.h                       |   28 +
 arch/x86/kvm/vmx/posted_intr.c                     |   28 +-
 arch/x86/kvm/vmx/posted_intr.h                     |    2 +
 arch/x86/kvm/vmx/tdx.c                             | 3526 ++++++++++++++++++++
 arch/x86/kvm/vmx/tdx.h                             |  204 ++
 arch/x86/kvm/vmx/tdx_arch.h                        |  167 +
 arch/x86/kvm/vmx/tdx_errno.h                       |   40 +
 arch/x86/kvm/vmx/vmx.c                             |  291 +-
 arch/x86/kvm/vmx/vmx.h                             |  140 +-
 arch/x86/kvm/vmx/x86_ops.h                         |  111 +-
 arch/x86/kvm/x86.c                                 |   99 +-
 arch/x86/kvm/x86.h                                 |   31 +-
 arch/x86/virt/vmx/tdx/seamcall.S                   |    3 +
 arch/x86/virt/vmx/tdx/tdx.c                        |  423 ++-
 arch/x86/virt/vmx/tdx/tdx.h                        |   48 +-
 arch/x86/virt/vmx/tdx/tdx_global_metadata.c        |   50 +
 include/linux/kvm_dirty_ring.h                     |   11 +-
 include/linux/kvm_host.h                           |   10 +
 include/linux/misc_cgroup.h                        |    4 +
 include/linux/ubsan.h                              |    6 +-
 include/uapi/linux/kvm.h                           |    4 +
 kernel/cgroup/misc.c                               |    4 +
 lib/Kconfig.ubsan                                  |    9 +
 lib/ubsan.c                                        |    8 +-
 scripts/Makefile.ubsan                             |    5 +-
 tools/arch/arm64/include/asm/sysreg.h              |   65 +-
 tools/testing/selftests/kvm/Makefile               |    2 +-
 tools/testing/selftests/kvm/Makefile.kvm           |   18 +
 tools/testing/selftests/kvm/arm64/host_sve.c       |  127 +
 tools/testing/selftests/kvm/arm64/set_id_regs.c    |   77 +-
 tools/testing/selftests/kvm/include/kvm_util.h     |    6 +
 .../kvm/include/loongarch/kvm_util_arch.h          |    7 +
 .../selftests/kvm/include/loongarch/processor.h    |  141 +
 .../selftests/kvm/include/loongarch/ucall.h        |   20 +
 .../selftests/kvm/include/riscv/processor.h        |   23 +-
 tools/testing/selftests/kvm/lib/kvm_util.c         |    3 +
 .../selftests/kvm/lib/loongarch/exception.S        |   59 +
 .../selftests/kvm/lib/loongarch/processor.c        |  346 ++
 tools/testing/selftests/kvm/lib/loongarch/ucall.c  |   38 +
 tools/testing/selftests/kvm/lib/riscv/handlers.S   |  139 +-
 tools/testing/selftests/kvm/lib/riscv/processor.c  |    2 +-
 tools/testing/selftests/kvm/riscv/arch_timer.c     |    2 +-
 tools/testing/selftests/kvm/riscv/ebreak_test.c    |    2 +-
 tools/testing/selftests/kvm/riscv/get-reg-list.c   |  132 +
 tools/testing/selftests/kvm/riscv/sbi_pmu_test.c   |   24 +-
 .../testing/selftests/kvm/set_memory_region_test.c |    2 +-
 virt/kvm/dirty_ring.c                              |   11 +-
 virt/kvm/kvm_main.c                                |   26 +-
 158 files changed, 13224 insertions(+), 1989 deletions(-)
 create mode 100644 Documentation/virt/kvm/x86/intel-tdx.rst
 create mode 100644 arch/arm64/kvm/config.c
 rename arch/x86/{virt/vmx/tdx => include/asm}/tdx_global_metadata.h (58%)
 create mode 100644 arch/x86/kvm/vmx/common.h
 create mode 100644 arch/x86/kvm/vmx/pmu_intel.h
 create mode 100644 arch/x86/kvm/vmx/tdx.c
 create mode 100644 arch/x86/kvm/vmx/tdx.h
 create mode 100644 arch/x86/kvm/vmx/tdx_arch.h
 create mode 100644 arch/x86/kvm/vmx/tdx_errno.h
 create mode 100644 tools/testing/selftests/kvm/arm64/host_sve.c
 create mode 100644 tools/testing/selftests/kvm/include/loongarch/kvm_util_arch.h
 create mode 100644 tools/testing/selftests/kvm/include/loongarch/processor.h
 create mode 100644 tools/testing/selftests/kvm/include/loongarch/ucall.h
 create mode 100644 tools/testing/selftests/kvm/lib/loongarch/exception.S
 create mode 100644 tools/testing/selftests/kvm/lib/loongarch/processor.c
 create mode 100644 tools/testing/selftests/kvm/lib/loongarch/ucall.c


