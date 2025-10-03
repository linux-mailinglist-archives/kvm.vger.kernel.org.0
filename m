Return-Path: <kvm+bounces-59456-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 69F9ABB6F3C
	for <lists+kvm@lfdr.de>; Fri, 03 Oct 2025 15:17:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C19211AE1BCE
	for <lists+kvm@lfdr.de>; Fri,  3 Oct 2025 13:15:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1B7A2F1FCD;
	Fri,  3 Oct 2025 13:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZU9P36OJ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 699752F0C4F
	for <kvm@vger.kernel.org>; Fri,  3 Oct 2025 13:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759497040; cv=none; b=oePXnbbmO3R58Z4F3Jro2OUhEE7pIRL5YKUT3iZiN2sCuX3vVz53nN9SgcQXOFQbaszRzjYOxhEFti5ZvLGsSF+YDuR7/WQE4ZwU4u3Rs4+1wIW/A/hzWlm9zl7QeoX2CI2hU5duipIYQOHGXcsAUyM+qjSBCUhSQVzj+wYqAP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759497040; c=relaxed/simple;
	bh=8nje9IN0q2Mj6u/+1Zt+bEWW88bEiSR2XNS2ZUthHDc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=gEJoN32li2nWw3NaTzu2kg9b+KDae8Yz+a+NdeSYlPxly2R3DS4rEc4G+WNI+ltghkDZSgTLpGCpLaMhV9B8234agKykLJh9QeCivjY7k8djealz3jpj0+ZsJD4rXmkO382dD3c++MdPwg5rOwzcyBZUv3QZyTyBbDhQE47T/N4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZU9P36OJ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759497037;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=wpL3D+GqZGkZW+w6bfR9oWlwiLdvXi0mZSpxnWxrGN4=;
	b=ZU9P36OJaMj7y9hKadaLqc809pG6+5scCna4mkOXreZOnX/heUGmHQN20Nrq8kpyEqn8Tg
	rleV2AYeetYK+sr81gmRX8eXzq2bw6yNrdKrR+RUf2pfCrT9cKv6kzaYvx3c1XasamEewQ
	PG3g0sxUK26ykRHlVNGg8ceYSHPj8QU=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-192-vMTDTOa-OAuo6MDUi_itqQ-1; Fri,
 03 Oct 2025 09:10:31 -0400
X-MC-Unique: vMTDTOa-OAuo6MDUi_itqQ-1
X-Mimecast-MFC-AGG-ID: vMTDTOa-OAuo6MDUi_itqQ_1759497030
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1A1911956089;
	Fri,  3 Oct 2025 13:10:30 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 5DD76180035E;
	Fri,  3 Oct 2025 13:10:29 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [GIT PULL] First batch of KVM changes for Linux 6.18
Date: Fri,  3 Oct 2025 09:10:27 -0400
Message-ID: <20251003131028.67395-1-pbonzini@redhat.com>
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

The following changes since commit 07e27ad16399afcd693be20211b0dfae63e0615f:

  Linux 6.17-rc7 (2025-09-21 15:08:52 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 99cab80208809cb918d6e579e6165279096f058a:

  Merge tag 'kvm-x86-generic-6.18' of https://github.com/kvm-x86/linux into HEAD (2025-09-30 13:27:59 -0400)

This excludes the bulk of the x86 changes, which I will send separately.
They have two not complex but relatively unusual conflicts so I will wait
for other dust to settle.

Paolo

----------------------------------------------------------------
guest_memfd:

* Add support for host userspace mapping of guest_memfd-backed memory for VM
  types that do NOT use support KVM_MEMORY_ATTRIBUTE_PRIVATE (which isn't
  precisely the same thing as CoCo VMs, since x86's SEV-MEM and SEV-ES have
  no way to detect private vs. shared).

  This lays the groundwork for removal of guest memory from the kernel direct
  map, as well as for limited mmap() for guest_memfd-backed memory.

  For more information see:
  * a6ad54137af9 ("Merge branch 'guest-memfd-mmap' into HEAD", 2025-08-27)
  * https://github.com/firecracker-microvm/firecracker/tree/feature/secret-hiding
    (guest_memfd in Firecracker)
  * https://lore.kernel.org/all/20250221160728.1584559-1-roypat@amazon.co.uk/
    (direct map removal)
  * https://lore.kernel.org/all/20250328153133.3504118-1-tabba@google.com/
    (mmap support)

ARM:

* Add support for FF-A 1.2 as the secure memory conduit for pKVM,
  allowing more registers to be used as part of the message payload.

* Change the way pKVM allocates its VM handles, making sure that the
  privileged hypervisor is never tricked into using uninitialised
  data.

* Speed up MMIO range registration by avoiding unnecessary RCU
  synchronisation, which results in VMs starting much quicker.

* Add the dump of the instruction stream when panic-ing in the EL2
  payload, just like the rest of the kernel has always done. This will
  hopefully help debugging non-VHE setups.

* Add 52bit PA support to the stage-1 page-table walker, and make use
  of it to populate the fault level reported to the guest on failing
  to translate a stage-1 walk.

* Add NV support to the GICv3-on-GICv5 emulation code, ensuring
  feature parity for guests, irrespective of the host platform.

* Fix some really ugly architecture problems when dealing with debug
  in a nested VM. This has some bad performance impacts, but is at
  least correct.

* Add enough infrastructure to be able to disable EL2 features and
  give effective values to the EL2 control registers. This then allows
  a bunch of features to be turned off, which helps cross-host
  migration.

* Large rework of the selftest infrastructure to allow most tests to
  transparently run at EL2. This is the first step towards enabling
  NV testing.

* Various fixes and improvements all over the map, including one BE
  fix, just in time for the removal of the feature.

LoongArch:

* Detect page table walk feature on new hardware

* Add sign extension with kernel MMIO/IOCSR emulation

* Improve in-kernel IPI emulation

* Improve in-kernel PCH-PIC emulation

* Move kvm_iocsr tracepoint out of generic code

RISC-V:

* Added SBI FWFT extension for Guest/VM with misaligned delegation and
  pointer masking PMLEN features

* Added ONE_REG interface for SBI FWFT extension

* Added Zicbop and bfloat16 extensions for Guest/VM

* Enabled more common KVM selftests for RISC-V

* Added SBI v3.0 PMU enhancements in KVM and perf driver

s390:

* Improve interrupt cpu for wakeup, in particular the heuristic to decide
  which vCPU to deliver a floating interrupt to.

* Clear the PTE when discarding a swapped page because of CMMA; this
  bug was introduced in 6.16 when refactoring gmap code.

x86 selftests:

* Add #DE coverage in the fastops test (the only exception that's guest-
  triggerable in fastop-emulated instructions).

* Fix PMU selftests errors encountered on Granite Rapids (GNR), Sierra
  Forest (SRF) and Clearwater Forest (CWF).

* Minor cleanups and improvements

x86 (guest side):

* For the legacy PCI hole (memory between TOLUD and 4GiB) to UC when
  overriding guest MTRR for TDX/SNP to fix an issue where ACPI auto-mapping
  could map devices as WB and prevent the device drivers from mapping their
  devices with UC/UC-.

* Make kvm_async_pf_task_wake() a local static helper and remove its
  export.

* Use native qspinlocks when running in a VM with dedicated vCPU=>pCPU
  bindings even when PV_UNHALT is unsupported.

Generic:

* Remove a redundant __GFP_NOWARN from kvm_setup_async_pf() as __GFP_NOWARN is
  now included in GFP_NOWAIT.

----------------------------------------------------------------
Ackerley Tng (2):
      KVM: x86/mmu: Rename .private_max_mapping_level() to .gmem_max_mapping_level()
      KVM: x86/mmu: Handle guest page faults for guest_memfd with shared memory

Alexandru Elisei (1):
      KVM: arm64: Update stale comment for sanitise_mte_tags()

Alok Tiwari (1):
      KVM: selftests: Fix typo in hyperv cpuid test message

Anup Patel (6):
      RISC-V: KVM: Set initial value of hedeleg in kvm_arch_vcpu_create()
      RISC-V: KVM: Introduce feature specific reset for SBI FWFT
      RISC-V: KVM: Introduce optional ONE_REG callbacks for SBI extensions
      RISC-V: KVM: Move copy_sbi_ext_reg_indices() to SBI implementation
      RISC-V: KVM: Implement ONE_REG interface for SBI FWFT state
      KVM: riscv: selftests: Add SBI FWFT to get-reg-list test

Atish Patra (8):
      drivers/perf: riscv: Add SBI v3.0 flag
      drivers/perf: riscv: Add raw event v2 support
      RISC-V: KVM: Add support for Raw event v2
      drivers/perf: riscv: Implement PMU event info function
      drivers/perf: riscv: Export PMU event info function
      RISC-V: KVM: No need of explicit writable slot check
      RISC-V: KVM: Implement get event info function
      RISC-V: KVM: Upgrade the supported SBI version to 3.0

Ben Horgan (1):
      KVM: arm64: Fix debug checking for np-guests using huge mappings

Bibo Mao (9):
      LoongArch: KVM: Add PTW feature detection on new hardware
      LoongArch: KVM: Add sign extension with kernel MMIO read emulation
      LoongArch: KVM: Add sign extension with kernel IOCSR read emulation
      LoongArch: KVM: Add implementation with IOCSR_IPI_SET
      LoongArch: KVM: Access mailbox directly in mail_send()
      LoongArch: KVM: Set version information at initial stage
      LoongArch: KVM: Add IRR and ISR register read emulation
      LoongArch: KVM: Add different length support in loongarch_pch_pic_read()
      LoongArch: KVM: Add different length support in loongarch_pch_pic_write()

Christian Borntraeger (1):
      KVM: s390: improve interrupt cpu for wakeup

Clément Léger (2):
      RISC-V: KVM: add support for FWFT SBI extension
      RISC-V: KVM: add support for SBI_FWFT_MISALIGNED_DELEG

Dapeng Mi (2):
      KVM: selftests: Add timing_info bit support in vmx_pmu_caps_test
      KVM: selftests: Validate more arch-events in pmu_counters_test

Dong Yang (1):
      KVM: riscv: selftests: Add missing headers for new testcases

Fangyu Yu (1):
      RISC-V: KVM: Write hgatp register with valid mode bits

Fuad Tabba (25):
      KVM: Rename CONFIG_KVM_PRIVATE_MEM to CONFIG_KVM_GUEST_MEMFD
      KVM: Rename CONFIG_KVM_GENERIC_PRIVATE_MEM to CONFIG_HAVE_KVM_ARCH_GMEM_POPULATE
      KVM: Rename kvm_slot_can_be_private() to kvm_slot_has_gmem()
      KVM: Fix comments that refer to slots_lock
      KVM: Fix comment that refers to kvm uapi header path
      KVM: x86: Enable KVM_GUEST_MEMFD for all 64-bit builds
      KVM: guest_memfd: Add plumbing to host to map guest_memfd pages
      KVM: guest_memfd: Track guest_memfd mmap support in memslot
      KVM: arm64: Refactor user_mem_abort()
      KVM: arm64: Handle guest_memfd-backed guest page faults
      KVM: arm64: nv: Handle VNCR_EL2-triggered faults backed by guest_memfd
      KVM: arm64: Enable support for guest_memfd backed memory
      KVM: Allow and advertise support for host mmap() on guest_memfd files
      KVM: selftests: Do not use hardcoded page sizes in guest_memfd test
      KVM: selftests: guest_memfd mmap() test when mmap is supported
      KVM: arm64: Add build-time check for duplicate DECLARE_REG use
      KVM: arm64: Rename pkvm.enabled to pkvm.is_protected
      KVM: arm64: Rename 'host_kvm' to 'kvm' in pKVM host code
      KVM: arm64: Clarify comments to distinguish pKVM mode from protected VMs
      KVM: arm64: Decouple hyp VM creation state from its handle
      KVM: arm64: Separate allocation and insertion of pKVM VM table entries
      KVM: arm64: Consolidate pKVM hypervisor VM initialization logic
      KVM: arm64: Introduce separate hypercalls for pKVM VM reservation and initialization
      KVM: arm64: Reserve pKVM handle during pkvm_init_host_vm()
      KVM: arm64: Fix page leak in user_mem_abort()

Gautam Gala (1):
      KVM: s390: Fix to clear PTE when discarding a swapped page

Gopi Krishna Menon (1):
      KVM: selftests: fix minor typo in cpumodel_subfuncs

Guo Ren (Alibaba DAMO Academy) (2):
      RISC-V: KVM: Remove unnecessary HGATP csr_read
      RISC-V: KVM: Prevent HGATP_MODE_BARE passed

James Clark (1):
      KVM: arm64: Add trap configs for PMSDSFR_EL1

James Houghton (1):
      KVM: selftests: Fix signedness issue with vCPU mmap size check

Jinqian Yang (2):
      KVM: arm64: Make ID_AA64MMFR1_EL1.{HCX, TWED} writable from userspace
      KVM: arm64: selftests: Test writes to ID_AA64MMFR1_EL1.{HCX, TWED}

Keir Fraser (4):
      KVM: arm64: vgic-init: Remove vgic_ready() macro
      KVM: arm64: vgic: Explicitly implement vgic_dist::ready ordering
      KVM: Implement barriers before accessing kvm->buses[] on SRCU read paths
      KVM: Avoid synchronize_srcu() in kvm_io_bus_register_dev()

Li RongQing (1):
      x86/kvm: Prefer native qspinlock for dedicated vCPUs irrespective of PV_UNHALT

Marc Zyngier (39):
      Merge branch kvm-arm64/ffa-1.2 into kvmarm-master/next
      Merge branch kvm-arm64/pkvm_vm_handle into kvmarm-master/next
      KVM: arm64: Fix kvm_vcpu_{set,is}_be() to deal with EL2 state
      Merge branch kvm-arm64/mmio-rcu into kvmarm-master/next
      Merge branch kvm-arm64/dump-instr into kvmarm-master/next
      KVM: arm64: Don't access ICC_SRE_EL2 if GICv3 doesn't support v2 compatibility
      KVM: arm64: Remove duplicate FEAT_{SYSREG128,MTE2} descriptions
      KVM: arm64: Add reg_feat_map_desc to describe full register dependency
      KVM: arm64: Enforce absence of FEAT_FGT on FGT registers
      KVM: arm64: Enforce absence of FEAT_FGT2 on FGT2 registers
      KVM: arm64: Enforce absence of FEAT_HCX on HCRX_EL2
      KVM: arm64: Convert HCR_EL2 RES0 handling to compute_reg_res0_bits()
      KVM: arm64: Enforce absence of FEAT_SCTLR2 on SCTLR2_EL{1,2}
      KVM: arm64: Enforce absence of FEAT_TCR2 on TCR2_EL2
      KVM: arm64: Convert SCTLR_EL1 RES0 handling to compute_reg_res0_bits()
      KVM: arm64: Convert MDCR_EL2 RES0 handling to compute_reg_res0_bits()
      KVM: arm64: Add helper computing the state of 52bit PA support
      KVM: arm64: Account for 52bit when computing maximum OA
      KVM: arm64: Compute 52bit TTBR address and alignment
      KVM: arm64: Decouple output address from the PT descriptor
      KVM: arm64: Pass the walk_info structure to compute_par_s1()
      KVM: arm64: Compute shareability for LPA2
      KVM: arm64: Populate PAR_EL1 with 52bit addresses
      KVM: arm64: Expand valid block mappings to FEAT_LPA/LPA2 support
      KVM: arm64: Report faults from S1 walk setup at the expected start level
      KVM: arm64: Allow use of S1 PTW for non-NV vcpus
      KVM: arm64: Allow EL1 control registers to be accessed from the CPU state
      KVM: arm64: Don't switch MMU on translation from non-NV context
      KVM: arm64: Add filtering hook to S1 page table walk
      KVM: arm64: Add S1 IPA to page table level walker
      KVM: arm64: Populate level on S1PTW SEA injection
      KVM: arm64: selftest: Expand external_aborts test to look for TTW levels
      Merge branch kvm-arm64/52bit-at into kvmarm-master/next
      Merge branch kvm-arm64/gic-v5-nv into kvmarm-master/next
      Merge branch kvm-arm64/nv-debug into kvmarm-master/next
      Merge branch kvm-arm64/el2-feature-control into kvmarm-master/next
      Merge branch kvm-arm64/nv-misc-6.18 into kvmarm-master/next
      Merge branch kvm-arm64/misc-6.18 into kvmarm-master/next
      Merge branch kvm-arm64/selftests-6.18 into kvmarm-master/next

Mark Brown (3):
      KVM: arm64: Expose FEAT_LSFE to guests
      KVM: arm64: selftests: Remove a duplicate register listing in set_id_regs
      KVM: arm64: selftests: Cover ID_AA64ISAR3_EL1 in set_id_regs

Mostafa Saleh (2):
      KVM: arm64: Dump instruction on hyp panic
      KVM: arm64: Map hyp text as RO and dump instr on panic

Oliver Upton (29):
      KVM: arm64: nv: Trap debug registers when in hyp context
      KVM: arm64: nv: Apply guest's MDCR traps in nested context
      KVM: arm64: nv: Treat AMO as 1 when at EL2 and {E2H,TGE} = {1, 0}
      KVM: arm64: nv: Allow userspace to de-feature stage-2 TGRANs
      KVM: arm64: nv: Convert masks to denylists in limit_nv_id_reg()
      KVM: arm64: nv: Don't erroneously claim FEAT_DoubleLock for NV VMs
      KVM: arm64: nv: Expose FEAT_DF2 to NV-enabled VMs
      KVM: arm64: nv: Expose FEAT_RASv1p1 via RAS_frac
      KVM: arm64: nv: Expose FEAT_ECBHB to NV-enabled VMs
      KVM: arm64: nv: Expose FEAT_AFP to NV-enabled VMs
      KVM: arm64: nv: Exclude guest's TWED configuration when TWE isn't set
      KVM: arm64: nv: Expose FEAT_TWED to NV-enabled VMs
      KVM: arm64: nv: Advertise FEAT_SpecSEI to NV-enabled VMs
      KVM: arm64: nv: Advertise FEAT_TIDCP1 to NV-enabled VMs
      KVM: arm64: nv: Expose up to FEAT_Debugv8p8 to NV-enabled VMs
      KVM: arm64: selftests: Provide kvm_arch_vm_post_create() in library code
      KVM: arm64: selftests: Initialize VGICv3 only once
      KVM: arm64: selftests: Add helper to check for VGICv3 support
      KVM: arm64: selftests: Add unsanitised helpers for VGICv3 creation
      KVM: arm64: selftests: Create a VGICv3 for 'default' VMs
      KVM: arm64: selftests: Alias EL1 registers to EL2 counterparts
      KVM: arm64: selftests: Provide helper for getting default vCPU target
      KVM: arm64: selftests: Select SMCCC conduit based on current EL
      KVM: arm64: selftests: Use hyp timer IRQs when test runs at EL2
      KVM: arm64: selftests: Use the vCPU attr for setting nr of PMU counters
      KVM: arm64: selftests: Initialize HCR_EL2
      KVM: arm64: selftests: Enable EL2 by default
      KVM: arm64: selftests: Add basic test for running in VHE EL2
      KVM: arm64: selftests: Cope with arch silliness in EL2 selftest

Paolo Bonzini (10):
      Merge tag 'kvm-x86-fixes-6.17-rc7' of https://github.com/kvm-x86/linux into HEAD
      Merge branch 'guest-memfd-mmap' into HEAD
      Merge tag 'kvm-s390-next-6.18-1' of https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux into HEAD
      Merge tag 'kvmarm-fixes-6.17-2' of https://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD
      Merge tag 'kvmarm-6.18' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD
      Merge tag 'kvm-riscv-6.18-1' of https://github.com/kvm-riscv/linux into HEAD
      Merge tag 'loongarch-kvm-6.18' of git://git.kernel.org/pub/scm/linux/kernel/git/chenhuacai/linux-loongson into HEAD
      Merge tag 'kvm-x86-selftests-6.18' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-guest-6.18' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-generic-6.18' of https://github.com/kvm-x86/linux into HEAD

Per Larsen (6):
      KVM: arm64: Correct return value on host version downgrade attempt
      KVM: arm64: Use SMCCC 1.2 for FF-A initialization and in host handler
      KVM: arm64: Mark FFA_NOTIFICATION_* calls as unsupported
      KVM: arm64: Mark optional FF-A 1.2 interfaces as unsupported
      KVM: arm64: Mask response to FFA_FEATURE call
      KVM: arm64: Bump the supported version of FF-A to 1.2

Qianfeng Rong (1):
      KVM: remove redundant __GFP_NOWARN

Quan Zhou (8):
      RISC-V: KVM: Change zicbom/zicboz block size to depend on the host isa
      RISC-V: KVM: Provide UAPI for Zicbop block size
      RISC-V: KVM: Allow Zicbop extension for Guest/VM
      RISC-V: KVM: Allow bfloat16 extension for Guest/VM
      KVM: riscv: selftests: Add Zicbop extension to get-reg-list test
      KVM: riscv: selftests: Add bfloat16 extension to get-reg-list test
      KVM: riscv: selftests: Use the existing RISCV_FENCE macro in `rseq-riscv.h`
      KVM: riscv: selftests: Add common supported test cases

Samuel Holland (1):
      RISC-V: KVM: Add support for SBI_FWFT_POINTER_MASKING_PMLEN

Sascha Bischoff (4):
      KVM: arm64: Enable nested for GICv5 host with FEAT_GCIE_LEGACY
      arm64: cpucaps: Add GICv5 Legacy vCPU interface (GCIE_LEGACY) capability
      KVM: arm64: Use ARM64_HAS_GICV5_LEGACY for GICv5 probing
      irqchip/gic-v5: Drop has_gcie_v3_compat from gic_kvm_info

Sean Christopherson (17):
      KVM: selftests: Move Intel and AMD module param helpers to x86/processor.h
      KVM: x86: Have all vendor neutral sub-configs depend on KVM_X86, not just KVM
      KVM: x86: Select KVM_GENERIC_PRIVATE_MEM directly from KVM_SW_PROTECTED_VM
      KVM: x86: Select TDX's KVM_GENERIC_xxx dependencies iff CONFIG_KVM_INTEL_TDX=y
      KVM: x86/mmu: Hoist guest_memfd max level/order helpers "up" in mmu.c
      KVM: x86/mmu: Enforce guest_memfd's max order when recovering hugepages
      KVM: x86/mmu: Extend guest_memfd's max mapping level to shared mappings
      KVM: selftests: Add guest_memfd testcase to fault-in on !mmap()'d memory
      KVM: selftests: Add support for #DE exception fixup
      KVM: selftests: Add coverage for 'b' (byte) sized fastops emulation
      KVM: selftests: Dedup the gnarly constraints of the fastops tests (more macros!)
      KVM: selftests: Add support for DIV and IDIV in the fastops test
      x86/kvm: Force legacy PCI hole to UC when overriding MTRRs for TDX/SNP
      x86/kvm: Make kvm_async_pf_task_wake() a local static helper
      KVM: selftests: Track unavailable_mask for PMU events as 32-bit value
      KVM: selftests: Reduce number of "unavailable PMU events" combos tested
      KVM: selftests: Add ex_str() to print human friendly name of exception vectors

Steven Rostedt (1):
      LoongArch: KVM: Move kvm_iocsr tracepoint out of generic code

Sukrut Heroorkar (1):
      selftests/kvm: remove stale TODO in xapic_state_test

Wei-Lin Chang (1):
      KVM: arm64: ptdump: Don't test PTE_VALID alongside other attributes

Yingchao Deng (1):
      KVM: arm64: Return early from trace helpers when KVM isn't available

Yury Norov (NVIDIA) (1):
      LoongArch: KVM: Rework pch_pic_update_batch_irqs()

dongsheng (1):
      KVM: selftests: Handle Intel Atom errata that leads to PMU event overcount

 Documentation/virt/kvm/api.rst                     |   9 +
 arch/arm64/include/asm/kvm_asm.h                   |   2 +
 arch/arm64/include/asm/kvm_emulate.h               |  34 +-
 arch/arm64/include/asm/kvm_host.h                  |   5 +-
 arch/arm64/include/asm/kvm_nested.h                |  27 +-
 arch/arm64/include/asm/kvm_pkvm.h                  |   1 +
 arch/arm64/include/asm/traps.h                     |   1 +
 arch/arm64/include/asm/vncr_mapping.h              |   2 +
 arch/arm64/kernel/cpufeature.c                     |  15 +
 arch/arm64/kernel/image-vars.h                     |   3 +
 arch/arm64/kernel/traps.c                          |  15 +-
 arch/arm64/kvm/Kconfig                             |   1 +
 arch/arm64/kvm/arm.c                               |  19 +-
 arch/arm64/kvm/at.c                                | 376 ++++++++++----
 arch/arm64/kvm/config.c                            | 358 +++++++++-----
 arch/arm64/kvm/debug.c                             |  25 +-
 arch/arm64/kvm/emulate-nested.c                    |   1 +
 arch/arm64/kvm/handle_exit.c                       |   3 +
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h             |   4 +-
 arch/arm64/kvm/hyp/include/nvhe/trap_handler.h     |   3 +-
 arch/arm64/kvm/hyp/nvhe/Makefile                   |   1 +
 arch/arm64/kvm/hyp/nvhe/ffa.c                      | 217 +++++---
 arch/arm64/kvm/hyp/nvhe/hyp-main.c                 |  14 +
 arch/arm64/kvm/hyp/nvhe/mem_protect.c              |   9 +-
 arch/arm64/kvm/hyp/nvhe/pkvm.c                     | 177 +++++--
 arch/arm64/kvm/hyp/nvhe/setup.c                    |  12 +-
 arch/arm64/kvm/hyp/vgic-v3-sr.c                    |  25 +-
 arch/arm64/kvm/hyp/vhe/switch.c                    |   7 +
 arch/arm64/kvm/inject_fault.c                      |  27 +-
 arch/arm64/kvm/mmu.c                               | 212 +++++---
 arch/arm64/kvm/nested.c                            | 119 ++++-
 arch/arm64/kvm/pkvm.c                              |  76 ++-
 arch/arm64/kvm/ptdump.c                            |  20 +-
 arch/arm64/kvm/sys_regs.c                          |  55 ++-
 arch/arm64/kvm/vgic/vgic-init.c                    |  14 +-
 arch/arm64/kvm/vgic/vgic-v3.c                      |   8 +
 arch/arm64/kvm/vgic/vgic-v5.c                      |   2 +-
 arch/arm64/tools/cpucaps                           |   1 +
 arch/loongarch/include/asm/kvm_pch_pic.h           |  15 +-
 arch/loongarch/include/uapi/asm/kvm.h              |   1 +
 arch/loongarch/kvm/exit.c                          |  19 +-
 arch/loongarch/kvm/intc/ipi.c                      |  80 +--
 arch/loongarch/kvm/intc/pch_pic.c                  | 239 ++++-----
 arch/loongarch/kvm/trace.h                         |  35 ++
 arch/loongarch/kvm/vcpu.c                          |   2 +
 arch/loongarch/kvm/vm.c                            |   4 +
 arch/riscv/include/asm/kvm_host.h                  |   4 +
 arch/riscv/include/asm/kvm_vcpu_pmu.h              |   3 +
 arch/riscv/include/asm/kvm_vcpu_sbi.h              |  25 +-
 arch/riscv/include/asm/kvm_vcpu_sbi_fwft.h         |  34 ++
 arch/riscv/include/asm/sbi.h                       |  13 +
 arch/riscv/include/uapi/asm/kvm.h                  |  21 +
 arch/riscv/kvm/Makefile                            |   1 +
 arch/riscv/kvm/gstage.c                            |  27 +-
 arch/riscv/kvm/main.c                              |  33 +-
 arch/riscv/kvm/vcpu.c                              |   3 +-
 arch/riscv/kvm/vcpu_onereg.c                       |  95 ++--
 arch/riscv/kvm/vcpu_pmu.c                          |  74 ++-
 arch/riscv/kvm/vcpu_sbi.c                          | 198 ++++++--
 arch/riscv/kvm/vcpu_sbi_fwft.c                     | 544 +++++++++++++++++++++
 arch/riscv/kvm/vcpu_sbi_pmu.c                      |   3 +
 arch/riscv/kvm/vcpu_sbi_sta.c                      |  74 +--
 arch/riscv/kvm/vmid.c                              |   8 +-
 arch/s390/include/asm/kvm_host.h                   |   2 +-
 arch/s390/include/asm/pgtable.h                    |  22 +
 arch/s390/kvm/interrupt.c                          |  20 +-
 arch/s390/mm/gmap_helpers.c                        |  12 +-
 arch/s390/mm/pgtable.c                             |  23 +-
 arch/x86/include/asm/kvm-x86-ops.h                 |   2 +-
 arch/x86/include/asm/kvm_host.h                    |   6 +-
 arch/x86/include/asm/kvm_para.h                    |   2 -
 arch/x86/kernel/kvm.c                              |  44 +-
 arch/x86/kvm/Kconfig                               |  26 +-
 arch/x86/kvm/mmu/mmu.c                             | 142 +++---
 arch/x86/kvm/mmu/mmu_internal.h                    |   2 +-
 arch/x86/kvm/mmu/tdp_mmu.c                         |   2 +-
 arch/x86/kvm/svm/sev.c                             |   6 +-
 arch/x86/kvm/svm/svm.c                             |   2 +-
 arch/x86/kvm/svm/svm.h                             |   4 +-
 arch/x86/kvm/vmx/main.c                            |   7 +-
 arch/x86/kvm/vmx/tdx.c                             |   5 +-
 arch/x86/kvm/vmx/vmx.c                             |   7 +
 arch/x86/kvm/vmx/x86_ops.h                         |   2 +-
 arch/x86/kvm/x86.c                                 |  11 +
 drivers/irqchip/irq-gic-v5.c                       |   7 -
 drivers/perf/riscv_pmu_sbi.c                       | 191 ++++++--
 include/kvm/arm_vgic.h                             |   2 +-
 include/linux/arm_ffa.h                            |   1 +
 include/linux/irqchip/arm-vgic-info.h              |   2 -
 include/linux/kvm_host.h                           |  49 +-
 include/linux/perf/riscv_pmu.h                     |   1 +
 include/trace/events/kvm.h                         |  35 --
 include/uapi/linux/kvm.h                           |   2 +
 tools/testing/selftests/kvm/Makefile.kvm           |   8 +
 .../selftests/kvm/access_tracking_perf_test.c      |   1 +
 tools/testing/selftests/kvm/arm64/arch_timer.c     |  13 +-
 .../selftests/kvm/arm64/arch_timer_edge_cases.c    |  13 +-
 .../testing/selftests/kvm/arm64/external_aborts.c  |  42 ++
 tools/testing/selftests/kvm/arm64/hello_el2.c      |  71 +++
 tools/testing/selftests/kvm/arm64/hypercalls.c     |   2 +-
 tools/testing/selftests/kvm/arm64/kvm-uuid.c       |   2 +-
 tools/testing/selftests/kvm/arm64/no-vgic-v3.c     |   2 +
 tools/testing/selftests/kvm/arm64/psci_test.c      |  13 +-
 tools/testing/selftests/kvm/arm64/set_id_regs.c    |  44 +-
 tools/testing/selftests/kvm/arm64/smccc_filter.c   |  17 +-
 tools/testing/selftests/kvm/arm64/vgic_init.c      |   2 +
 tools/testing/selftests/kvm/arm64/vgic_irq.c       |   4 +-
 .../testing/selftests/kvm/arm64/vgic_lpi_stress.c  |   8 +-
 .../selftests/kvm/arm64/vpmu_counter_access.c      |  75 ++-
 tools/testing/selftests/kvm/dirty_log_perf_test.c  |  35 --
 tools/testing/selftests/kvm/dirty_log_test.c       |   1 +
 tools/testing/selftests/kvm/get-reg-list.c         |   9 +-
 tools/testing/selftests/kvm/guest_memfd_test.c     | 236 ++++++++-
 .../selftests/kvm/include/arm64/arch_timer.h       |  24 +
 .../selftests/kvm/include/arm64/kvm_util_arch.h    |   5 +-
 .../selftests/kvm/include/arm64/processor.h        |  74 +++
 tools/testing/selftests/kvm/include/arm64/vgic.h   |   3 +
 tools/testing/selftests/kvm/include/kvm_util.h     |  24 +-
 .../selftests/kvm/include/riscv/processor.h        |   1 +
 tools/testing/selftests/kvm/include/x86/pmu.h      |  26 +
 .../testing/selftests/kvm/include/x86/processor.h  |  35 +-
 tools/testing/selftests/kvm/lib/arm64/processor.c  | 104 +++-
 tools/testing/selftests/kvm/lib/arm64/vgic.c       |  66 ++-
 tools/testing/selftests/kvm/lib/kvm_util.c         |  57 +--
 tools/testing/selftests/kvm/lib/x86/pmu.c          |  49 ++
 tools/testing/selftests/kvm/lib/x86/processor.c    |  41 +-
 .../kvm/memslot_modification_stress_test.c         |   1 +
 tools/testing/selftests/kvm/memslot_perf_test.c    |   1 +
 tools/testing/selftests/kvm/riscv/get-reg-list.c   |  60 +++
 tools/testing/selftests/kvm/s390/cmma_test.c       |   2 +-
 .../selftests/kvm/s390/cpumodel_subfuncs_test.c    |   2 +-
 tools/testing/selftests/kvm/steal_time.c           |   2 +-
 tools/testing/selftests/kvm/x86/fastops_test.c     |  82 +++-
 tools/testing/selftests/kvm/x86/hyperv_cpuid.c     |   2 +-
 tools/testing/selftests/kvm/x86/hyperv_features.c  |  16 +-
 .../testing/selftests/kvm/x86/monitor_mwait_test.c |   8 +-
 .../testing/selftests/kvm/x86/pmu_counters_test.c  |  67 ++-
 .../selftests/kvm/x86/pmu_event_filter_test.c      |   4 +-
 .../testing/selftests/kvm/x86/vmx_pmu_caps_test.c  |   7 +-
 tools/testing/selftests/kvm/x86/xapic_state_test.c |   4 +-
 tools/testing/selftests/kvm/x86/xcr0_cpuid_test.c  |  12 +-
 tools/testing/selftests/rseq/rseq-riscv.h          |   3 +-
 virt/kvm/Kconfig                                   |  15 +-
 virt/kvm/Makefile.kvm                              |   2 +-
 virt/kvm/async_pf.c                                |   2 +-
 virt/kvm/guest_memfd.c                             |  81 ++-
 virt/kvm/kvm_main.c                                |  55 ++-
 virt/kvm/kvm_mm.h                                  |   4 +-
 148 files changed, 4132 insertions(+), 1501 deletions(-)
 create mode 100644 arch/riscv/include/asm/kvm_vcpu_sbi_fwft.h
 create mode 100644 arch/riscv/kvm/vcpu_sbi_fwft.c
 create mode 100644 tools/testing/selftests/kvm/arm64/hello_el2.c


