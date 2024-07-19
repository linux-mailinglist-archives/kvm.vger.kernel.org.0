Return-Path: <kvm+bounces-21932-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7869893795D
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 16:53:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 11E4D282F3B
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 14:53:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E782D13E3F6;
	Fri, 19 Jul 2024 14:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DfXrnz8N"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7559713A87A
	for <kvm@vger.kernel.org>; Fri, 19 Jul 2024 14:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721400830; cv=none; b=G/MAOQ/gpVP9/DwXK1JtBQ5LNSW9HQgIwqZ/HrYlGVFGMf5fONmvKFi/3h8L8+yeKD+b6ePxY0KwHv0s3XfNnvU8YFtfGxSElgTCgO7vwhqP3C30+k7pwPqgBu7aWB8pdKQkNbvyhKBLHQla38J2JtG7d8HEwzYIO4KE/abzzxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721400830; c=relaxed/simple;
	bh=Lqm8sWwjeoATbRTg40vMMSKEFVXCMeI7QnaE/qhqRW4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=MU3S+l5CBsj+vNAOgMSh7boGu2kDBh0hpnSioRkr5GCzyHnRKS015HzjVzteGf09RDHA1RMOQgFTjCkyAx5MbilIb9lVvoeO/hcKxZsfbHVKpaibU2Q18A26Fg6R6bjzMWD8nDLzAykmI0dTdrnIUg1hNWhsN5ifjOAZ8XNdCDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DfXrnz8N; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721400826;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=HXSVrx5j9Iz0iqVTmvtAqAxN+XqdY4Q2iHVeJ7jHC7k=;
	b=DfXrnz8NE0zs4592S0qZirxCStA5a+TiLR1+7dAiFJnQYLFvaTvLIlqdIG1vcnObDpti22
	CaeJxG+MlK9OdUb9lGaoNiyS6WludvnDkBrBo0lOpgJfBhS7CJr+N1Apakj4lui6gZTsvd
	8H+4OHQZEvY9oVwwiTWltoteP7WJk3I=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-423-KQKa_wfnMju1Srqj7xfmqg-1; Fri,
 19 Jul 2024 10:53:42 -0400
X-MC-Unique: KQKa_wfnMju1Srqj7xfmqg-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2EA161955D4B;
	Fri, 19 Jul 2024 14:53:41 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1159A1955F6B;
	Fri, 19 Jul 2024 14:53:39 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [GIT PULL] KVM changes for 6.11 merge window
Date: Fri, 19 Jul 2024 10:53:38 -0400
Message-ID: <20240719145339.55027-1-pbonzini@redhat.com>
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

The following changes since commit 256abd8e550ce977b728be79a74e1729438b4948:

  Linux 6.10-rc7 (2024-07-07 14:23:46 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 332d2c1d713e232e163386c35a3ba0c1b90df83f:

  crypto: ccp: Add the SNP_VLEK_LOAD command (2024-07-17 12:46:26 -0400)


Conflicts (fortunately trivial):

- the one in arch/x86/include/asm/sev-common.h is just two branches adding
  macros in the same place

- the slightly more annoying one is in tools/perf/arch/loongarch/util/Build
  and tools/perf/arch/riscv/util/Build, where perf-y has been renamed
  to perf-util-y by commit e467705a9fb3 ("perf util: Make util its own
  library").  The relevant commits in this pull request are

  492ac37fa38f perf kvm: Add kvm-stat for loongarch64
  da7b1b525e97 perf kvm/riscv: Port perf kvm stat to RISC-V


Non-KVM changes:

- a new ioctl for the AMD secure processor driver, which is in charge of
  /dev/sev (sev = secure encrypted virtualization); patch reviewed by
  the maintainer, Tom Lendacky.

- renaming the AS_UNMOVABLE flag, which was added for KVM's guest_memfd,
  to AS_INACCESSIBLE now that it can also be used for hardware-protected
  memory and it protects truncation in addition to page migration.  Acked
  by David Hildenbrand and Vlastimil Babka.

Thanks,

Paolo

----------------------------------------------------------------
ARM:

* Initial infrastructure for shadow stage-2 MMUs, as part of nested
  virtualization enablement

* Support for userspace changes to the guest CTR_EL0 value, enabling
  (in part) migration of VMs between heterogenous hardware

* Fixes + improvements to pKVM's FF-A proxy, adding support for v1.1 of
  the protocol

* FPSIMD/SVE support for nested, including merged trap configuration
  and exception routing

* New command-line parameter to control the WFx trap behavior under KVM

* Introduce kCFI hardening in the EL2 hypervisor

* Fixes + cleanups for handling presence/absence of FEAT_TCRX

* Miscellaneous fixes + documentation updates

LoongArch:

* Add paravirt steal time support.

* Add support for KVM_DIRTY_LOG_INITIALLY_SET.

* Add perf kvm-stat support for loongarch.

RISC-V:

* Redirect AMO load/store access fault traps to guest

* perf kvm stat support

* Use guest files for IMSIC virtualization, when available

ONE_REG support for the Zimop, Zcmop, Zca, Zcf, Zcd, Zcb and Zawrs ISA
extensions is coming through the RISC-V tree.

s390:

* Assortment of tiny fixes which are not time critical

x86:

* Fixes for Xen emulation.

* Add a global struct to consolidate tracking of host values, e.g. EFER

* Add KVM_CAP_X86_APIC_BUS_CYCLES_NS to allow configuring the effective APIC
  bus frequency, because TDX.

* Print the name of the APICv/AVIC inhibits in the relevant tracepoint.

* Clean up KVM's handling of vendor specific emulation to consistently act on
  "compatible with Intel/AMD", versus checking for a specific vendor.

* Drop MTRR virtualization, and instead always honor guest PAT on CPUs
  that support self-snoop.

* Update to the newfangled Intel CPU FMS infrastructure.

* Don't advertise IA32_PERF_GLOBAL_OVF_CTRL as an MSR-to-be-saved, as it reads
  '0' and writes from userspace are ignored.

* Misc cleanups

x86 - MMU:

* Small cleanups, renames and refactoring extracted from the upcoming
  Intel TDX support.

* Don't allocate kvm_mmu_page.shadowed_translation for shadow pages that can't
  hold leafs SPTEs.

* Unconditionally drop mmu_lock when allocating TDP MMU page tables for eager
  page splitting, to avoid stalling vCPUs when splitting huge pages.

* Bug the VM instead of simply warning if KVM tries to split a SPTE that is
  non-present or not-huge.  KVM is guaranteed to end up in a broken state
  because the callers fully expect a valid SPTE, it's all but dangerous
  to let more MMU changes happen afterwards.

x86 - AMD:

* Make per-CPU save_area allocations NUMA-aware.

* Force sev_es_host_save_area() to be inlined to avoid calling into an
  instrumentable function from noinstr code.

* Base support for running SEV-SNP guests.  API-wise, this includes
  a new KVM_X86_SNP_VM type, encrypting/measure the initial image into
  guest memory, and finalizing it before launching it.  Internally,
  there are some gmem/mmu hooks needed to prepare gmem-allocated pages
  before mapping them into guest private memory ranges.

  This includes basic support for attestation guest requests, enough to
  say that KVM supports the GHCB 2.0 specification.

  There is no support yet for loading into the firmware those signing
  keys to be used for attestation requests, and therefore no need yet
  for the host to provide certificate data for those keys.  To support
  fetching certificate data from userspace, a new KVM exit type will be
  needed to handle fetching the certificate from userspace. An attempt to
  define a new KVM_EXIT_COCO/KVM_EXIT_COCO_REQ_CERTS exit type to handle
  this was introduced in v1 of this patchset, but is still being discussed
  by community, so for now this patchset only implements a stub version
  of SNP Extended Guest Requests that does not provide certificate data.

x86 - Intel:

* Remove an unnecessary EPT TLB flush when enabling hardware.

* Fix a series of bugs that cause KVM to fail to detect nested pending posted
  interrupts as valid wake eents for a vCPU executing HLT in L2 (with
  HLT-exiting disable by L1).

* KVM: x86: Suppress MMIO that is triggered during task switch emulation

  Explicitly suppress userspace emulated MMIO exits that are triggered when
  emulating a task switch as KVM doesn't support userspace MMIO during
  complex (multi-step) emulation.  Silently ignoring the exit request can
  result in the WARN_ON_ONCE(vcpu->mmio_needed) firing if KVM exits to
  userspace for some other reason prior to purging mmio_needed.

  See commit 0dc902267cb3 ("KVM: x86: Suppress pending MMIO write exits if
  emulator detects exception") for more details on KVM's limitations with
  respect to emulated MMIO during complex emulator flows.

Generic:

* Rename the AS_UNMOVABLE flag that was introduced for KVM to AS_INACCESSIBLE,
  because the special casing needed by these pages is not due to just
  unmovability (and in fact they are only unmovable because the CPU cannot
  access them).

* New ioctl to populate the KVM page tables in advance, which is useful to
  mitigate KVM page faults during guest boot or after live migration.
  The code will also be used by TDX, but (probably) not through the ioctl.

* Enable halt poll shrinking by default, as Intel found it to be a clear win.

* Setup empty IRQ routing when creating a VM to avoid having to synchronize
  SRCU when creating a split IRQCHIP on x86.

* Rework the sched_in/out() paths to replace kvm_arch_sched_in() with a flag
  that arch code can use for hooking both sched_in() and sched_out().

* Take the vCPU @id as an "unsigned long" instead of "u32" to avoid
  truncating a bogus value from userspace, e.g. to help userspace detect bugs.

* Mark a vCPU as preempted if and only if it's scheduled out while in the
  KVM_RUN loop, e.g. to avoid marking it preempted and thus writing guest
  memory when retrieving guest state during live migration blackout.

Selftests:

* Remove dead code in the memslot modification stress test.

* Treat "branch instructions retired" as supported on all AMD Family 17h+ CPUs.

* Print the guest pseudo-RNG seed only when it changes, to avoid spamming the
  log for tests that create lots of VMs.

* Make the PMU counters test less flaky when counting LLC cache misses by
  doing CLFLUSH{OPT} in every loop iteration.

----------------------------------------------------------------
Alejandro Jimenez (2):
      KVM: x86: Print names of apicv inhibit reasons in traces
      KVM: x86: Keep consistent naming for APICv/AVIC inhibit reasons

Anup Patel (2):
      RISC-V: KVM: Share APLIC and IMSIC defines with irqchip drivers
      RISC-V: KVM: Use IMSIC guest files when available

Ashish Kalra (1):
      KVM: SEV: Avoid WBINVD for HVA-based MMU notifications for SNP

Bibo Mao (10):
      LoongArch: KVM: Sync pending interrupt when getting ESTAT from user mode
      LoongArch: KVM: Delay secondary mmu tlb flush until guest entry
      LoongArch: KVM: Select huge page only if secondary mmu supports it
      LoongArch: KVM: Discard dirty page tracking on readonly memslot
      LoongArch: KVM: Add memory barrier before update pmd entry
      LoongArch: KVM: Add dirty bitmap initially all set support
      LoongArch: KVM: Mark page accessed and dirty with page ref added
      LoongArch: KVM: Add PV steal time support in host side
      LoongArch: KVM: Add PV steal time support in guest side
      perf kvm: Add kvm-stat for loongarch64

Binbin Wu (1):
      KVM: VMX: Remove unused declaration of vmx_request_immediate_exit()

Borislav Petkov (1):
      KVM: Unexport kvm_debugfs_dir

Brijesh Singh (8):
      KVM: SEV: Add initial SEV-SNP support
      KVM: SEV: Add KVM_SEV_SNP_LAUNCH_START command
      KVM: SEV: Add KVM_SEV_SNP_LAUNCH_UPDATE command
      KVM: SEV: Add KVM_SEV_SNP_LAUNCH_FINISH command
      KVM: SEV: Add support to handle GHCB GPA register VMGEXIT
      KVM: SEV: Add support to handle RMP nested page faults
      KVM: SVM: Add module parameter to enable SEV-SNP
      KVM: SEV: Provide support for SNP_GUEST_REQUEST NAE event

Carlos López (1):
      KVM: x86: Improve documentation for KVM_CAP_X86_BUS_LOCK_EXIT

Changyuan Lyu (3):
      KVM: Documentation: Fix typo `BFD`
      KVM: Documentation: Enumerate allowed value macros of `irq_type`
      KVM: Documentation: Correct the VGIC V2 CPU interface addr space size

Christoffer Dall (2):
      KVM: arm64: nv: Implement nested Stage-2 page table walk logic
      KVM: arm64: nv: Unmap/flush shadow stage 2 page tables

Christoph Schlameuss (1):
      kvm: s390: Reject memory region operations for ucontrol VMs

Claudio Imbrenda (1):
      KVM: s390: remove useless include

Colton Lewis (1):
      KVM: arm64: Add early_param to control WFx trapping

Dan Carpenter (1):
      KVM: Fix a goof where kvm_create_vm() returns 0 instead of -ENOMEM

Dapeng Mi (3):
      KVM: x86/pmu: Change ambiguous _mask suffix to _rsvd in kvm_pmu
      KVM: x86/pmu: Manipulate FIXED_CTR_CTRL MSR with macros
      KVM: x86/pmu: Introduce distinct macros for GP/fixed counter max number

David Matlack (7):
      KVM: x86/mmu: Always drop mmu_lock to allocate TDP MMU SPs for eager splitting
      KVM: x86/mmu: Hard code GFP flags for TDP MMU eager split allocations
      KVM: x86/mmu: Unnest TDP MMU helpers that allocate SPs for eager splitting
      KVM: x86/mmu: Avoid reacquiring RCU if TDP MMU fails to allocate an SP
      KVM: Introduce vcpu->wants_to_run
      KVM: Ensure new code that references immediate_exit gets extra scrutiny
      KVM: Mark a vCPU as preempted/ready iff it's scheduled out while running

Dr. David Alan Gilbert (1):
      KVM: selftests: remove unused struct 'memslot_antagonist_args'

Eric Farman (1):
      KVM: s390: vsie: retry SIE instruction on host intercepts

Hou Wenlong (2):
      KVM: x86/mmu: Only allocate shadowed translation cache for sp->role.level <= KVM_MAX_HUGEPAGE_LEVEL
      KVM: x86: Drop unused check_apicv_inhibit_reasons() callback definition

Isaku Yamahata (8):
      KVM: x86: hyper-v: Calculate APIC bus frequency for Hyper-V
      KVM: x86: Make nanoseconds per APIC bus cycle a VM variable
      KVM: x86: Add a capability to configure bus frequency for APIC timer
      KVM: x86/tdp_mmu: Sprinkle __must_check
      KVM: selftests: Add test for configure of x86 APIC bus frequency
      KVM: Document KVM_PRE_FAULT_MEMORY ioctl
      KVM: Add KVM_PRE_FAULT_MEMORY vcpu ioctl to pre-populate guest memory
      KVM: selftests: x86: Add test for KVM_PRE_FAULT_MEMORY

Jeff Johnson (2):
      KVM: x86: Add missing MODULE_DESCRIPTION() macros
      KVM: Add missing MODULE_DESCRIPTION()

Jia Qingtong (1):
      LoongArch: KVM: always make pte young in page map's fast path

Jim Mattson (1):
      KVM: x86: Remove IA32_PERF_GLOBAL_OVF_CTRL from KVM_GET_MSR_INDEX_LIST

Jintack Lim (1):
      KVM: arm64: nv: Forward FP/ASIMD traps to guest hypervisor

Julian Stecklina (1):
      KVM: fix documentation rendering for KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM

Kai Huang (1):
      KVM: VMX: Switch __vmx_exit() and kvm_x86_vendor_exit() in vmx_exit()

Li RongQing (3):
      KVM: SVM: remove useless input parameter in snp_safe_alloc_page
      KVM: SVM: not account memory allocation for per-CPU svm_data
      KVM: SVM: Consider NUMA affinity when allocating per-CPU save_area

Liang Chen (1):
      KVM: x86: invalid_list not used anymore in mmu_shrink_scan

Manali Shukla (1):
      KVM: selftests: Treat AMD Family 17h+ as supporting branch insns retired

Marc Zyngier (25):
      KVM: arm64: nv: Fix RESx behaviour of disabled FGTs with negative polarity
      KVM: arm64: nv: Support multiple nested Stage-2 mmu structures
      KVM: arm64: nv: Handle shadow stage 2 page faults
      KVM: arm64: nv: Add Stage-1 EL2 invalidation primitives
      KVM: arm64: nv: Handle EL2 Stage-1 TLB invalidation
      KVM: arm64: nv: Handle TLB invalidation targeting L2 stage-1
      KVM: arm64: nv: Handle TLBI VMALLS12E1{,IS} operations
      KVM: arm64: nv: Handle TLBI ALLE1{,IS} operations
      KVM: arm64: nv: Handle TLBI IPAS2E1{,IS} operations
      KVM: arm64: nv: Handle FEAT_TTL hinted TLB operations
      KVM: arm64: nv: Tag shadow S2 entries with guest's leaf S2 level
      KVM: arm64: nv: Invalidate TLBs based on shadow S2 TTL-like information
      KVM: arm64: nv: Add handling of outer-shareable TLBI operations
      KVM: arm64: nv: Add handling of range-based TLBI operations
      KVM: arm64: nv: Add handling of NXS-flavoured TLBI operations
      KVM: arm64: nv: Handle CPACR_EL1 traps
      KVM: arm64: nv: Add TCPAC/TTA to CPTR->CPACR conversion helper
      KVM: arm64: nv: Add trap description for CPTR_EL2
      KVM: arm64: nv: Add additional trap setup for CPTR_EL2
      KVM: arm64: Correctly honor the presence of FEAT_TCRX
      KVM: arm64: Get rid of HCRX_GUEST_FLAGS
      KVM: arm64: Make TCR2_EL1 save/restore dependent on the VM features
      KVM: arm64: Make PIR{,E0}_EL1 save/restore conditional on FEAT_TCRX
      KVM: arm64: Honor trap routing for TCR2_EL1
      KVM: arm64: nv: Truely enable nXS TLBI operations

Mathias Krause (4):
      KVM: Reject overly excessive IDs in KVM_CREATE_VCPU
      KVM: x86: Limit check IDs for KVM_SET_BOOT_CPU_ID
      KVM: selftests: Test max vCPU IDs corner cases
      KVM: selftests: Test vCPU boot IDs above 2^32 and MAX_VCPU_ID

Maxim Levitsky (1):
      KVM: selftests: Increase robustness of LLC cache misses in PMU counters test

Michael Roth (15):
      mm: Introduce AS_INACCESSIBLE for encrypted/confidential memory
      KVM: guest_memfd: Use AS_INACCESSIBLE when creating guest_memfd inode
      KVM: guest_memfd: Add hook for invalidating memory
      KVM: x86: Add hook for determining max NPT mapping level
      KVM: MMU: Disable fast path if KVM_EXIT_MEMORY_FAULT is needed
      KVM: SEV: Select KVM_GENERIC_PRIVATE_MEM when CONFIG_KVM_AMD_SEV=y
      KVM: SEV: Add support to handle MSR based Page State Change VMGEXIT
      KVM: SEV: Add support to handle Page State Change VMGEXIT
      KVM: SEV: Implement gmem hook for initializing private pages
      KVM: SEV: Implement gmem hook for invalidating private pages
      KVM: x86: Implement hook for determining max NPT mapping level
      KVM: SEV: Automatically switch reclaimed pages to shared
      x86/sev: Move sev_guest.h into common SEV header
      KVM: SEV: Provide support for SNP_EXTENDED_GUEST_REQUEST NAE event
      crypto: ccp: Add the SNP_VLEK_LOAD command

Oliver Upton (28):
      KVM: arm64: nv: Use GFP_KERNEL_ACCOUNT for sysreg_masks allocation
      KVM: arm64: Get sys_reg encoding from descriptor in idregs_debug_show()
      KVM: arm64: Make idregs debugfs iterator search sysreg table directly
      KVM: arm64: Use read-only helper for reading VM ID registers
      KVM: arm64: Add helper for writing ID regs
      KVM: arm64: nv: Use accessors for modifying ID registers
      KVM: arm64: nv: Forward SVE traps to guest hypervisor
      KVM: arm64: nv: Handle ZCR_EL2 traps
      KVM: arm64: nv: Load guest hyp's ZCR into EL1 state
      KVM: arm64: nv: Save guest's ZCR_EL2 when in hyp context
      KVM: arm64: nv: Use guest hypervisor's max VL when running nested guest
      KVM: arm64: nv: Ensure correct VL is loaded before saving SVE state
      KVM: arm64: Spin off helper for programming CPTR traps
      KVM: arm64: nv: Load guest FP state for ZCR_EL2 trap
      KVM: arm64: nv: Honor guest hypervisor's FP/SVE traps in CPTR_EL2
      KVM: arm64: Allow the use of SVE+NV
      KVM: arm64: nv: Unfudge ID_AA64PFR0_EL1 masking
      KVM: selftests: Assert that MPIDR_EL1 is unchanged across vCPU reset
      MAINTAINERS: Include documentation in KVM/arm64 entry
      Revert "KVM: arm64: nv: Fix RESx behaviour of disabled FGTs with negative polarity"
      Merge branch kvm-arm64/misc into kvmarm/next
      Merge branch kvm-arm64/ffa-1p1 into kvmarm/next
      Merge branch kvm-arm64/shadow-mmu into kvmarm/next
      Merge branch kvm-arm64/ctr-el0 into kvmarm/next
      Merge branch kvm-arm64/el2-kcfi into kvmarm/next
      Merge branch kvm-arm64/nv-sve into kvmarm/next
      Merge branch kvm-arm64/nv-tcr2 into kvmarm/next
      Merge branch kvm-arm64/docs into kvmarm/next

Paolo Bonzini (30):
      KVM: guest_memfd: pass error up from filemap_grab_folio
      KVM: guest_memfd: limit overzealous WARN
      KVM: guest_memfd: Add hook for initializing memory
      KVM: guest_memfd: extract __kvm_gmem_get_pfn()
      KVM: guest_memfd: Add interface for populating gmem pages with user data
      Merge branch 'kvm-coco-hooks' into HEAD
      KVM: SEV: Don't WARN() if RMP lookup fails when invalidating gmem pages
      Merge branch 'kvm-fixes-6.10-1' into HEAD
      Merge branch 'kvm-6.11-sev-snp' into HEAD
      KVM: interrupt kvm_gmem_populate() on signals
      Merge branch 'kvm-6.10-fixes' into HEAD
      mm, virt: merge AS_UNMOVABLE and AS_INACCESSIBLE
      Merge branch 'kvm-tdx-prep-1-truncated' into HEAD
      KVM: x86/mmu: Make kvm_mmu_do_page_fault() return mapped level
      KVM: x86: Implement kvm_arch_vcpu_pre_fault_memory()
      Merge branch 'kvm-prefault' into HEAD
      Merge tag 'kvm-riscv-6.11-1' of https://github.com/kvm-riscv/linux into HEAD
      Merge tag 'kvm-s390-next-6.11-1' of https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux into HEAD
      Merge tag 'loongarch-kvm-6.11' of git://git.kernel.org/pub/scm/linux/kernel/git/chenhuacai/linux-loongson into HEAD
      Merge tag 'kvmarm-6.11' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD
      Merge tag 'kvm-x86-fixes-6.10-11' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-generic-6.11' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-misc-6.11' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-mmu-6.11' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-mtrrs-6.11' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-pmu-6.11' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-selftests-6.11' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-svm-6.11' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-vmx-6.11' of https://github.com/kvm-x86/linux into HEAD
      Merge branch 'kvm-6.11-sev-attestation' into HEAD

Parshuram Sangle (2):
      KVM: Enable halt polling shrink parameter by default
      KVM: Update halt polling documentation to note that KVM has 4 module params

Pei Li (1):
      KVM: Validate hva in kvm_gpc_activate_hva() to fix __kvm_gpc_refresh() WARN

Peng Hao (1):
      KVM: X86: Remove unnecessary GFP_KERNEL_ACCOUNT for temporary variables

Pierre-Clément Tosi (8):
      KVM: arm64: Fix clobbered ELR in sync abort/SError
      KVM: arm64: Fix __pkvm_init_switch_pgd call ABI
      KVM: arm64: nVHE: Simplify invalid_host_el2_vect
      KVM: arm64: nVHE: gen-hyprel: Skip R_AARCH64_ABS32
      KVM: arm64: VHE: Mark __hyp_call_panic __noreturn
      arm64: Introduce esr_brk_comment, esr_is_cfi_brk
      KVM: arm64: Introduce print_nvhe_hyp_panic helper
      KVM: arm64: nVHE: Support CONFIG_CFI_CLANG at EL2

Ravi Bangoria (1):
      KVM: SNP: Fix LBR Virtualization for SNP guest

Reinette Chatre (1):
      KVM: selftests: Add guest udelay() utility for x86

Rick Edgecombe (2):
      KVM: x86/tdp_mmu: Rename REMOVED_SPTE to FROZEN_SPTE
      KVM: x86/tdp_mmu: Take a GFN in kvm_tdp_mmu_fast_pf_get_last_sptep()

Sean Christopherson (42):
      Revert "KVM: async_pf: avoid recursive flushing of work items"
      KVM: x86: Add a struct to consolidate host values, e.g. EFER, XCR0, etc...
      KVM: SVM: Use KVM's snapshot of the host's XCR0 for SEV-ES host state
      KVM: x86/mmu: Snapshot shadow_phys_bits when kvm.ko is loaded
      KVM: x86: Move shadow_phys_bits into "kvm_host", as "maxphyaddr"
      KVM: x86: Remove VMX support for virtualizing guest MTRR memtypes
      KVM: VMX: Drop support for forcing UC memory when guest CR0.CD=1
      KVM: VMX: Always honor guest PAT on CPUs that support self-snoop
      KVM: x86/pmu: Squash period for checkpointed events based on host HLE/RTM
      KVM: x86: Apply Intel's TSC_AUX reserved-bit behavior to Intel compat vCPUs
      KVM: x86: Inhibit code #DBs in MOV-SS shadow for all Intel compat vCPUs
      KVM: x86: Use "is Intel compatible" helper to emulate SYSCALL in !64-bit
      KVM: SVM: Emulate SYSENTER RIP/RSP behavior for all Intel compat vCPUs
      KVM: x86: Allow SYSENTER in Compatibility Mode for all Intel compat vCPUs
      KVM: x86: Open code vendor_intel() in string_registers_quirk()
      KVM: x86: Bury guest_cpuid_is_amd_or_hygon() in cpuid.c
      KVM: x86/pmu: Add a helper to enable bits in FIXED_CTR_CTRL
      KVM: Add a flag to track if a loaded vCPU is scheduled out
      KVM: VMX: Move PLE grow/shrink helpers above vmx_vcpu_load()
      KVM: x86: Fold kvm_arch_sched_in() into kvm_arch_vcpu_load()
      KVM: Delete the now unused kvm_arch_sched_in()
      KVM: x86: Unconditionally set l1tf_flush_l1d during vCPU load
      KVM: x86: Drop now-superflous setting of l1tf_flush_l1d in vcpu_run()
      KVM: x86/mmu: Rephrase comment about synthetic PFERR flags in #PF handler
      KVM: x86: Prevent excluding the BSP on setting max_vcpu_ids
      KVM: selftests: Print the seed for the guest pRNG iff it has changed
      KVM: selftests: Rework macros in PMU counters test to prep for multi-insn loop
      KVM: SVM: Force sev_es_host_save_area() to be inlined (for noinstr usage)
      KVM: SVM: Use sev_es_host_save_area() helper when initializing tsc_aux
      KVM: nVMX: Update VMCS12_REVISION comment to state it should never change
      KVM: VMX: Remove unnecessary INVEPT[GLOBAL] from hardware enable path
      KVM: nVMX: Add a helper to get highest pending from Posted Interrupt vector
      KVM: nVMX: Request immediate exit iff pending nested event needs injection
      KVM: VMX: Split out the non-virtualization part of vmx_interrupt_blocked()
      KVM: nVMX: Check for pending posted interrupts when looking for nested events
      KVM: nVMX: Fold requested virtual interrupt check into has_nested_events()
      KVM: x86: WARN if a vCPU gets a valid wakeup that KVM can't yet inject
      KVM: x86/mmu: Bump pf_taken stat only in the "real" page fault handler
      KVM: x86/mmu: Account pf_{fixed,emulate,spurious} in callers of "do page fault"
      KVM: x86/mmu: Bug the VM if KVM tries to split a !hugepage SPTE
      KVM: x86/mmu: Clean up make_huge_page_split_spte() definition and intro
      KVM: x86: Suppress MMIO that is triggered during task switch emulation

Sebastian Ene (4):
      KVM: arm64: Trap FFA_VERSION host call in pKVM
      KVM: arm64: Add support for FFA_PARTITION_INFO_GET
      KVM: arm64: Update the identification range for the FF-A smcs
      KVM: arm64: Use FF-A 1.1 with pKVM

Sebastian Ott (5):
      KVM: arm64: unify code to prepare traps
      KVM: arm64: Treat CTR_EL0 as a VM feature ID register
      KVM: arm64: show writable masks for feature registers
      KVM: arm64: rename functions for invariant sys regs
      KVM: selftests: arm64: Test writes to CTR_EL0

Shenlin Liang (2):
      RISCV: KVM: add tracepoints for entry and exit events
      perf kvm/riscv: Port perf kvm stat to RISC-V

Thomas Prescher (1):
      KVM: x86: Add KVM_RUN_X86_GUEST_MODE kvm_run flag

Tom Lendacky (2):
      KVM: SEV: Support SEV-SNP AP Creation NAE event
      KVM: SVM: Remove the need to trigger an UNBLOCK event on AP creation

Tony Luck (2):
      KVM: x86/pmu: Switch to new Intel CPU model defines
      KVM: VMX: Switch to new Intel CPU model infrastructure

Wei Wang (3):
      KVM: x86: Replace static_call_cond() with static_call()
      KVM: x86: Introduce kvm_x86_call() to simplify static calls of kvm_x86_ops
      KVM: x86/pmu: Add kvm_pmu_call() to simplify static calls of kvm_pmu_ops

Yan Zhao (2):
      srcu: Add an API for a memory barrier after SRCU read lock
      KVM: x86: Ensure a full memory barrier is emitted in the VM-Exit path

Yi Wang (3):
      KVM: Setup empty IRQ routing when creating a VM
      KVM: x86: Don't re-setup empty IRQ routing when KVM_CAP_SPLIT_IRQCHIP
      KVM: s390: Don't re-setup dummy routing when KVM_CREATE_IRQCHIP

Yu-Wei Hsu (1):
      RISC-V: KVM: Redirect AMO load/store access fault traps to guest

 Documentation/admin-guide/kernel-parameters.txt    |   24 +-
 Documentation/virt/coco/sev-guest.rst              |   19 +
 Documentation/virt/kvm/api.rst                     |  169 ++-
 Documentation/virt/kvm/devices/arm-vgic.rst        |    2 +-
 Documentation/virt/kvm/halt-polling.rst            |   12 +-
 .../virt/kvm/x86/amd-memory-encryption.rst         |  110 +-
 Documentation/virt/kvm/x86/errata.rst              |   18 +
 MAINTAINERS                                        |    2 +
 arch/arm64/include/asm/esr.h                       |   12 +
 arch/arm64/include/asm/kvm_arm.h                   |    1 -
 arch/arm64/include/asm/kvm_asm.h                   |    2 +
 arch/arm64/include/asm/kvm_emulate.h               |   95 +-
 arch/arm64/include/asm/kvm_host.h                  |   69 +-
 arch/arm64/include/asm/kvm_hyp.h                   |    4 +-
 arch/arm64/include/asm/kvm_mmu.h                   |   26 +
 arch/arm64/include/asm/kvm_nested.h                |  131 +-
 arch/arm64/include/asm/sysreg.h                    |   17 +
 arch/arm64/kernel/asm-offsets.c                    |    1 +
 arch/arm64/kernel/debug-monitors.c                 |    4 +-
 arch/arm64/kernel/traps.c                          |    8 +-
 arch/arm64/kvm/arm.c                               |   88 +-
 arch/arm64/kvm/emulate-nested.c                    |  104 ++
 arch/arm64/kvm/fpsimd.c                            |   19 +-
 arch/arm64/kvm/handle_exit.c                       |   43 +-
 arch/arm64/kvm/hyp/entry.S                         |    8 +
 arch/arm64/kvm/hyp/include/hyp/switch.h            |   29 +-
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h         |   35 +-
 arch/arm64/kvm/hyp/include/nvhe/ffa.h              |    2 +-
 arch/arm64/kvm/hyp/nvhe/Makefile                   |    6 +-
 arch/arm64/kvm/hyp/nvhe/ffa.c                      |  286 ++--
 arch/arm64/kvm/hyp/nvhe/gen-hyprel.c               |    6 +
 arch/arm64/kvm/hyp/nvhe/host.S                     |    6 -
 arch/arm64/kvm/hyp/nvhe/hyp-init.S                 |   30 +-
 arch/arm64/kvm/hyp/nvhe/setup.c                    |    4 +-
 arch/arm64/kvm/hyp/vhe/switch.c                    |  202 ++-
 arch/arm64/kvm/hyp/vhe/tlb.c                       |  147 ++
 arch/arm64/kvm/mmu.c                               |  213 ++-
 arch/arm64/kvm/nested.c                            | 1024 +++++++++++--
 arch/arm64/kvm/pmu-emul.c                          |    2 +-
 arch/arm64/kvm/reset.c                             |    6 +
 arch/arm64/kvm/sys_regs.c                          |  593 +++++++-
 arch/loongarch/Kconfig                             |   11 +
 arch/loongarch/include/asm/kvm_host.h              |   14 +-
 arch/loongarch/include/asm/kvm_para.h              |   11 +
 arch/loongarch/include/asm/kvm_vcpu.h              |    5 +
 arch/loongarch/include/asm/loongarch.h             |    1 +
 arch/loongarch/include/asm/paravirt.h              |    5 +
 arch/loongarch/include/uapi/asm/kvm.h              |    4 +
 arch/loongarch/kernel/paravirt.c                   |  145 ++
 arch/loongarch/kernel/time.c                       |    2 +
 arch/loongarch/kvm/Kconfig                         |    1 +
 arch/loongarch/kvm/exit.c                          |   38 +-
 arch/loongarch/kvm/main.c                          |    1 +
 arch/loongarch/kvm/mmu.c                           |   72 +-
 arch/loongarch/kvm/tlb.c                           |    5 +-
 arch/loongarch/kvm/vcpu.c                          |  156 +-
 arch/mips/include/asm/kvm_host.h                   |    1 -
 arch/mips/kvm/mips.c                               |    2 +-
 arch/powerpc/include/asm/kvm_host.h                |    1 -
 arch/powerpc/kvm/powerpc.c                         |    2 +-
 arch/riscv/include/asm/kvm_aia_aplic.h             |   58 -
 arch/riscv/include/asm/kvm_aia_imsic.h             |   38 -
 arch/riscv/include/asm/kvm_host.h                  |    1 -
 arch/riscv/kvm/aia.c                               |   35 +-
 arch/riscv/kvm/aia_aplic.c                         |    2 +-
 arch/riscv/kvm/aia_device.c                        |    2 +-
 arch/riscv/kvm/aia_imsic.c                         |    2 +-
 arch/riscv/kvm/trace.h                             |   67 +
 arch/riscv/kvm/vcpu.c                              |    9 +-
 arch/riscv/kvm/vcpu_exit.c                         |    2 +
 arch/s390/include/asm/kvm_host.h                   |    2 -
 arch/s390/kvm/kvm-s390.c                           |   14 +-
 arch/s390/kvm/vsie.c                               |   24 +-
 arch/x86/include/asm/kvm-x86-ops.h                 |    8 +-
 arch/x86/include/asm/kvm-x86-pmu-ops.h             |    3 +-
 arch/x86/include/asm/kvm_host.h                    |   90 +-
 arch/x86/include/asm/sev-common.h                  |   25 +
 arch/x86/include/asm/sev.h                         |   51 +
 arch/x86/include/asm/svm.h                         |    9 +-
 arch/x86/include/uapi/asm/kvm.h                    |   49 +
 arch/x86/kvm/Kconfig                               |    4 +
 arch/x86/kvm/cpuid.c                               |   14 +-
 arch/x86/kvm/cpuid.h                               |   18 -
 arch/x86/kvm/emulate.c                             |   71 +-
 arch/x86/kvm/hyperv.c                              |    9 +-
 arch/x86/kvm/irq.c                                 |    2 +-
 arch/x86/kvm/irq.h                                 |    1 -
 arch/x86/kvm/irq_comm.c                            |    7 -
 arch/x86/kvm/kvm_cache_regs.h                      |   10 +-
 arch/x86/kvm/kvm_emulate.h                         |    1 +
 arch/x86/kvm/lapic.c                               |   48 +-
 arch/x86/kvm/lapic.h                               |    5 +-
 arch/x86/kvm/mmu.h                                 |   42 +-
 arch/x86/kvm/mmu/mmu.c                             |  206 ++-
 arch/x86/kvm/mmu/mmu_internal.h                    |   26 +-
 arch/x86/kvm/mmu/paging_tmpl.h                     |    3 +-
 arch/x86/kvm/mmu/spte.c                            |   46 +-
 arch/x86/kvm/mmu/spte.h                            |   10 +-
 arch/x86/kvm/mmu/tdp_mmu.c                         |  136 +-
 arch/x86/kvm/mmu/tdp_mmu.h                         |    2 +-
 arch/x86/kvm/mtrr.c                                |  644 +-------
 arch/x86/kvm/pmu.c                                 |   73 +-
 arch/x86/kvm/pmu.h                                 |   10 +-
 arch/x86/kvm/smm.c                                 |   44 +-
 arch/x86/kvm/svm/nested.c                          |    2 +-
 arch/x86/kvm/svm/pmu.c                             |   11 +-
 arch/x86/kvm/svm/sev.c                             | 1564 +++++++++++++++++++-
 arch/x86/kvm/svm/svm.c                             |   78 +-
 arch/x86/kvm/svm/svm.h                             |   70 +-
 arch/x86/kvm/trace.h                               |   55 +-
 arch/x86/kvm/vmx/main.c                            |    5 +-
 arch/x86/kvm/vmx/nested.c                          |   55 +-
 arch/x86/kvm/vmx/pmu_intel.c                       |   52 +-
 arch/x86/kvm/vmx/posted_intr.h                     |   10 +
 arch/x86/kvm/vmx/vmcs12.h                          |   14 +-
 arch/x86/kvm/vmx/vmx.c                             |  205 ++-
 arch/x86/kvm/vmx/vmx.h                             |    3 +-
 arch/x86/kvm/vmx/x86_ops.h                         |    4 -
 arch/x86/kvm/x86.c                                 |  567 +++----
 arch/x86/kvm/x86.h                                 |   25 +-
 arch/x86/kvm/xen.c                                 |    6 +-
 drivers/crypto/ccp/sev-dev.c                       |   36 +
 drivers/virt/coco/sev-guest/sev-guest.c            |    2 -
 drivers/virt/coco/sev-guest/sev-guest.h            |   63 -
 include/linux/arm_ffa.h                            |    3 +
 include/linux/kvm_host.h                           |   53 +-
 include/linux/pagemap.h                            |   13 +-
 include/linux/psp-sev.h                            |    4 +-
 include/linux/srcu.h                               |   14 +
 include/uapi/linux/kvm.h                           |   27 +-
 include/uapi/linux/psp-sev.h                       |   27 +
 include/uapi/linux/sev-guest.h                     |    3 +
 mm/compaction.c                                    |   12 +-
 mm/migrate.c                                       |    2 +-
 mm/truncate.c                                      |    3 +-
 tools/include/uapi/linux/kvm.h                     |   10 +
 tools/perf/arch/loongarch/Makefile                 |    1 +
 tools/perf/arch/loongarch/util/Build               |    2 +
 tools/perf/arch/loongarch/util/header.c            |   96 ++
 tools/perf/arch/loongarch/util/kvm-stat.c          |  139 ++
 tools/perf/arch/riscv/Makefile                     |    1 +
 tools/perf/arch/riscv/util/Build                   |    1 +
 tools/perf/arch/riscv/util/kvm-stat.c              |   78 +
 tools/perf/arch/riscv/util/riscv_exception_types.h |   35 +
 tools/testing/selftests/kvm/Makefile               |    2 +
 tools/testing/selftests/kvm/aarch64/set_id_regs.c  |   17 +
 tools/testing/selftests/kvm/include/x86_64/apic.h  |    8 +
 .../selftests/kvm/include/x86_64/processor.h       |   18 +
 tools/testing/selftests/kvm/lib/kvm_util.c         |    9 +-
 tools/testing/selftests/kvm/lib/x86_64/processor.c |   11 +
 .../kvm/memslot_modification_stress_test.c         |    6 -
 .../testing/selftests/kvm/pre_fault_memory_test.c  |  146 ++
 .../selftests/kvm/x86_64/apic_bus_clock_test.c     |  194 +++
 .../selftests/kvm/x86_64/max_vcpuid_cap_test.c     |   22 +-
 .../selftests/kvm/x86_64/pmu_counters_test.c       |   44 +-
 .../selftests/kvm/x86_64/pmu_event_filter_test.c   |   35 +-
 .../testing/selftests/kvm/x86_64/set_boot_cpu_id.c |   16 +
 virt/kvm/Kconfig                                   |   11 +
 virt/kvm/async_pf.c                                |   13 +-
 virt/kvm/guest_memfd.c                             |  176 ++-
 virt/kvm/irqchip.c                                 |   24 +
 virt/kvm/kvm_main.c                                |  106 +-
 virt/kvm/pfncache.c                                |    3 +
 163 files changed, 7813 insertions(+), 2378 deletions(-)
 delete mode 100644 arch/riscv/include/asm/kvm_aia_aplic.h
 delete mode 100644 arch/riscv/include/asm/kvm_aia_imsic.h
 create mode 100644 arch/riscv/kvm/trace.h
 delete mode 100644 drivers/virt/coco/sev-guest/sev-guest.h
 create mode 100644 tools/perf/arch/loongarch/util/header.c
 create mode 100644 tools/perf/arch/loongarch/util/kvm-stat.c
 create mode 100644 tools/perf/arch/riscv/util/kvm-stat.c
 create mode 100644 tools/perf/arch/riscv/util/riscv_exception_types.h
 create mode 100644 tools/testing/selftests/kvm/pre_fault_memory_test.c
 create mode 100644 tools/testing/selftests/kvm/x86_64/apic_bus_clock_test.c


