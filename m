Return-Path: <kvm+bounces-5987-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 833FE82971E
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 11:17:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 67D291C221E8
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 10:17:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15D4F3FB1C;
	Wed, 10 Jan 2024 10:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="F6b5pCZP"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1AF03FB01
	for <kvm@vger.kernel.org>; Wed, 10 Jan 2024 10:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1704881817;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=XLj+QtDOcWUUjg5Kd4VDQJ6amQyqlHFAK7WIzv6lclA=;
	b=F6b5pCZPW+VWTlX8JMY/kFpVThTXLYMWg4DASbg7RWGvFcnPYPHSU6gYkOo0/xVr3fN3vc
	9vSwKbxcmfoQiFeSpaoVWwgAM5D6cVB9KeET38XaDtWMBoh21S2niCLF37aPZBl7005YHH
	Lf+LhhiD7iFpdx2hevDN7nVDRdvtCQg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-633-R15a_I0uO4ifbJellTndGw-1; Wed, 10 Jan 2024 05:16:54 -0500
X-MC-Unique: R15a_I0uO4ifbJellTndGw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1A06580CB60;
	Wed, 10 Jan 2024 10:16:54 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E5C121121306;
	Wed, 10 Jan 2024 10:16:53 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [GIT PULL] KVM changes for Linux 6.8-rc1
Date: Wed, 10 Jan 2024 05:16:53 -0500
Message-Id: <20240110101653.830047-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3

Linus,

The following changes since commit 861deac3b092f37b2c5e6871732f3e11486f7082:

  Linux 6.7-rc7 (2023-12-23 16:25:56 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 1c6d984f523f67ecfad1083bb04c55d91977bb15:

  x86/kvm: Do not try to disable kvmclock if it was not enabled (2024-01-08 12:14:41 -0500)

There are a couple small conflicts, but also two semantic conflicts
in the new file virt/kvm/guest_memfd.c.  These are a bit more tricky
because they won't be detected by a default-ish config ("default-ish"
because defconfig does not build KVM at all).  In order to build-test
the result, you'll need CONFIG_EXPERT=y and CONFIG_KVM_SW_PROTECTED_VM=y
(found under "Virtualization").

The conflicts are:

- a context clash in Documentation/admin-guide/kernel-parameters.txt,
  with the RCU tree

- a function rename clash with the block tree because my pull request
  renames anon_inode_getfile_secure to anon_inode_create_getfile (see
  my commit 4f0b9194bc11, "fs: Rename anon_inode_getfile_secure() and
  anon_inode_getfd_secure()", suggested by Christian Brauner).

and have not been pulled as of this morning.  On the other hand both
of the semantic conflicts are already there, which makes this a good
time to send out the KVM pull request:

- one is with the mm tree due to concurrent conversion of
  error_remove_page to error_remove_folio

- the other is with the vfs tree, due to concurrent rename of
  private_list to i_private_list

I have placed the fixup after the diffstat; it's checked against
a merge with git commit ab27740f7665.  I have also pushed the
resolution to a kvm-6.8-conflict-resolution branch at
https://git.kernel.org/pub/scm/virt/kvm/kvm.git.

Finally, some topic branches were shared with the ARM64 tree. You
have already pulled those so nothing to worry about there.

Thanks,

Paolo

----------------------------------------------------------------
Generic:

- Use memdup_array_user() to harden against overflow.

- Unconditionally advertise KVM_CAP_DEVICE_CTRL for all architectures.

- Clean up Kconfigs that all KVM architectures were selecting

- New functionality around "guest_memfd", a new userspace API that
  creates an anonymous file and returns a file descriptor that refers
  to it.  guest_memfd files are bound to their owning virtual machine,
  cannot be mapped, read, or written by userspace, and cannot be resized.
  guest_memfd files do however support PUNCH_HOLE, which can be used to
  switch a memory area between guest_memfd and regular anonymous memory.

- New ioctl KVM_SET_MEMORY_ATTRIBUTES allowing userspace to specify
  per-page attributes for a given page of guest memory; right now the
  only attribute is whether the guest expects to access memory via
  guest_memfd or not, which in Confidential SVMs backed by SEV-SNP,
  TDX or ARM64 pKVM is checked by firmware or hypervisor that guarantees
  confidentiality (AMD PSP, Intel TDX module, or EL2 in the case of pKVM).

x86:

- Support for "software-protected VMs" that can use the new guest_memfd
  and page attributes infrastructure.  This is mostly useful for testing,
  since there is no pKVM-like infrastructure to provide a meaningfully
  reduced TCB.

- Fix a relatively benign off-by-one error when splitting huge pages during
  CLEAR_DIRTY_LOG.

- Fix a bug where KVM could incorrectly test-and-clear dirty bits in non-leaf
  TDP MMU SPTEs if a racing thread replaces a huge SPTE with a non-huge SPTE.

- Use more generic lockdep assertions in paths that don't actually care
  about whether the caller is a reader or a writer.

- let Xen guests opt out of having PV clock reported as "based on a stable TSC",
  because some of them don't expect the "TSC stable" bit (added to the pvclock
  ABI by KVM, but never set by Xen) to be set.

- Revert a bogus, made-up nested SVM consistency check for TLB_CONTROL.

- Advertise flush-by-ASID support for nSVM unconditionally, as KVM always
  flushes on nested transitions, i.e. always satisfies flush requests.  This
  allows running bleeding edge versions of VMware Workstation on top of KVM.

- Sanity check that the CPU supports flush-by-ASID when enabling SEV support.

- On AMD machines with vNMI, always rely on hardware instead of intercepting
  IRET in some cases to detect unmasking of NMIs

- Support for virtualizing Linear Address Masking (LAM)

- Fix a variety of vPMU bugs where KVM fail to stop/reset counters and other state
  prior to refreshing the vPMU model.

- Fix a double-overflow PMU bug by tracking emulated counter events using a
  dedicated field instead of snapshotting the "previous" counter.  If the
  hardware PMC count triggers overflow that is recognized in the same VM-Exit
  that KVM manually bumps an event count, KVM would pend PMIs for both the
  hardware-triggered overflow and for KVM-triggered overflow.

- Turn off KVM_WERROR by default for all configs so that it's not
  inadvertantly enabled by non-KVM developers, which can be problematic for
  subsystems that require no regressions for W=1 builds.

- Advertise all of the host-supported CPUID bits that enumerate IA32_SPEC_CTRL
  "features".

- Don't force a masterclock update when a vCPU synchronizes to the current TSC
  generation, as updating the masterclock can cause kvmclock's time to "jump"
  unexpectedly, e.g. when userspace hotplugs a pre-created vCPU.

- Use RIP-relative address to read kvm_rebooting in the VM-Enter fault paths,
  partly as a super minor optimization, but mostly to make KVM play nice with
  position independent executable builds.

- Guard KVM-on-HyperV's range-based TLB flush hooks with an #ifdef on
  CONFIG_HYPERV as a minor optimization, and to self-document the code.

- Add CONFIG_KVM_HYPERV to allow disabling KVM support for HyperV "emulation"
  at build time.

ARM64:

- LPA2 support, adding 52bit IPA/PA capability for 4kB and 16kB
  base granule sizes. Branch shared with the arm64 tree.

- Large Fine-Grained Trap rework, bringing some sanity to the
  feature, although there is more to come. This comes with
  a prefix branch shared with the arm64 tree.

- Some additional Nested Virtualization groundwork, mostly
  introducing the NV2 VNCR support and retargetting the NV
  support to that version of the architecture.

- A small set of vgic fixes and associated cleanups.

Loongarch:

- Optimization for memslot hugepage checking

- Cleanup and fix some HW/SW timer issues

- Add LSX/LASX (128bit/256bit SIMD) support

RISC-V:

- KVM_GET_REG_LIST improvement for vector registers

- Generate ISA extension reg_list using macros in get-reg-list selftest

- Support for reporting steal time along with selftest

s390:

- Bugfixes

Selftests:

- Fix an annoying goof where the NX hugepage test prints out garbage
  instead of the magic token needed to run the test.

- Fix build errors when a header is delete/moved due to a missing flag
  in the Makefile.

- Detect if KVM bugged/killed a selftest's VM and print out a helpful
  message instead of complaining that a random ioctl() failed.

- Annotate the guest printf/assert helpers with __printf(), and fix the
  various bugs that were lurking due to lack of said annotation.

There are two non-KVM patches buried in the middle of guest_memfd support:

  fs: Rename anon_inode_getfile_secure() and anon_inode_getfd_secure()
  mm: Add AS_UNMOVABLE to mark mapping as completely unmovable

The first is small and mostly suggested-by Christian Brauner; the second
a bit less so but it was written by an mm person (Vlastimil Babka).

----------------------------------------------------------------
Ackerley Tng (1):
      KVM: selftests: Test KVM exit behavior for private memory/access

Andrew Jones (19):
      RISC-V: KVM: Don't add SBI multi regs in get-reg-list
      KVM: riscv: selftests: Drop SBI multi registers
      RISC-V: KVM: Make SBI uapi consistent with ISA uapi
      KVM: riscv: selftests: Add RISCV_SBI_EXT_REG
      KVM: riscv: selftests: Use register subtypes
      RISC-V: KVM: selftests: Treat SBI ext regs like ISA ext regs
      RISC-V: paravirt: Add skeleton for pv-time support
      RISC-V: Add SBI STA extension definitions
      RISC-V: paravirt: Implement steal-time support
      RISC-V: KVM: Add SBI STA extension skeleton
      RISC-V: KVM: Add steal-update vcpu request
      RISC-V: KVM: Add SBI STA info to vcpu_arch
      RISC-V: KVM: Add support for SBI extension registers
      RISC-V: KVM: Add support for SBI STA registers
      RISC-V: KVM: Implement SBI STA extension
      RISC-V: KVM: selftests: Move sbi_ecall to processor.c
      RISC-V: KVM: selftests: Add guest_sbi_probe_extension
      RISC-V: KVM: selftests: Add steal_time test support
      RISC-V: KVM: selftests: Add get-reg-list test for STA registers

Anup Patel (2):
      KVM: riscv: selftests: Generate ISA extension reg_list using macros
      RISC-V: KVM: Fix indentation in kvm_riscv_vcpu_set_reg_csr()

Ard Biesheuvel (1):
      KVM: arm64: Use helpers to classify exception types reported via ESR

Bibo Mao (5):
      LoongArch: KVM: Optimization for memslot hugepage checking
      LoongArch: KVM: Remove SW timer switch when vcpu is halt polling
      LoongArch: KVM: Allow to access HW timer CSR registers always
      LoongArch: KVM: Remove kvm_acquire_timer() before entering guest
      LoongArch: KVM: Fix timer emulation with oneshot mode

Binbin Wu (9):
      KVM: x86: Consolidate flags for __linearize()
      KVM: x86: Add an emulation flag for implicit system access
      KVM: x86: Add X86EMUL_F_INVLPG and pass it in em_invlpg()
      KVM: x86/mmu: Drop non-PA bits when getting GFN for guest's PGD
      KVM: x86: Add & use kvm_vcpu_is_legal_cr3() to check CR3's legality
      KVM: x86: Remove kvm_vcpu_is_illegal_gpa()
      KVM: x86: Introduce get_untagged_addr() in kvm_x86_ops and call it in emulator
      KVM: x86: Untag addresses for LAM emulation where applicable
      KVM: x86: Use KVM-governed feature framework to track "LAM enabled"

Chao Du (1):
      RISC-V: KVM: remove a redundant condition in kvm_arch_vcpu_ioctl_run()

Chao Peng (8):
      KVM: Use gfn instead of hva for mmu_notifier_retry
      KVM: Add KVM_EXIT_MEMORY_FAULT exit to report faults to userspace
      KVM: Introduce per-page memory attributes
      KVM: x86: Disallow hugepages when memory attributes are mixed
      KVM: x86/mmu: Handle page fault for private memory
      KVM: selftests: Add KVM_SET_USER_MEMORY_REGION2 helper
      KVM: selftests: Expand set_memory_region_test to validate guest_memfd()
      KVM: selftests: Add basic selftest for guest_memfd()

Clément Léger (2):
      riscv: kvm: Use SYM_*() assembly macros instead of deprecated ones
      riscv: kvm: use ".L" local labels in assembly when applicable

Daniel Henrique Barboza (3):
      RISC-V: KVM: set 'vlenb' in kvm_riscv_vcpu_alloc_vector_context()
      RISC-V: KVM: add 'vlenb' Vector CSR
      RISC-V: KVM: add vector registers and CSRs in KVM_GET_REG_LIST

David Matlack (2):
      KVM: x86/mmu: Fix off-by-1 when splitting huge pages during CLEAR
      KVM: x86/mmu: Check for leaf SPTE when clearing dirty bit in the TDP MMU

David Woodhouse (1):
      KVM: selftests: add -MP to CFLAGS

Fuad Tabba (13):
      KVM: arm64: Explicitly trap unsupported HFGxTR_EL2 features
      KVM: arm64: Add missing HFGxTR_EL2 FGT entries to nested virt
      KVM: arm64: Add missing HFGITR_EL2 FGT entries to nested virt
      KVM: arm64: Add bit masks for HAFGRTR_EL2
      KVM: arm64: Handle HAFGRTR_EL2 trapping in nested virt
      KVM: arm64: Update and fix FGT register masks
      KVM: arm64: Add build validation for FGT trap mask values
      KVM: arm64: Use generated FGT RES0 bits instead of specifying them
      KVM: arm64: Define FGT nMASK bits relative to other fields
      KVM: arm64: Macros for setting/clearing FGT bits
      KVM: arm64: Fix which features are marked as allowed for protected VMs
      KVM: arm64: Mark PAuth as a restricted feature for protected VMs
      KVM: arm64: Trap external trace for protected VMs

Jim Mattson (2):
      KVM: x86: Advertise CPUID.(EAX=7,ECX=2):EDX[5:0] to userspace
      KVM: x86: Use a switch statement and macros in __feature_translate()

Kirill A. Shutemov (1):
      x86/kvm: Do not try to disable kvmclock if it was not enabled

Marc Zyngier (16):
      Merge remote-tracking branch 'arm64/for-next/sysregs' into kvm-arm64/fgt-rework
      Merge branch kvm-arm64/lpa2 into kvmarm-master/next
      Merge branch kvm-arm64/fgt-rework into kvmarm-master/next
      arm64: cpufeatures: Restrict NV support to FEAT_NV2
      KVM: arm64: nv: Hoist vcpu_has_nv() into is_hyp_ctxt()
      KVM: arm64: nv: Compute NV view of idregs as a one-off
      KVM: arm64: nv: Drop EL12 register traps that are redirected to VNCR
      KVM: arm64: nv: Add non-VHE-EL2->EL1 translation helpers
      KVM: arm64: nv: Add include containing the VNCR_EL2 offsets
      KVM: arm64: Introduce a bad_trap() primitive for unexpected trap handling
      KVM: arm64: nv: Add EL2_REG_VNCR()/EL2_REG_REDIR() sysreg helpers
      KVM: arm64: nv: Map VNCR-capable registers to a separate page
      KVM: arm64: nv: Handle virtual EL2 registers in vcpu_read/write_sys_reg()
      Merge branch kvm-arm64/nv-6.8-prefix into kvmarm-master/next
      KVM: arm64: vgic-v4: Restore pending state on host userspace write
      Merge branch kvm-arm64/vgic-6.8 into kvmarm-master/next

Nina Schoetterl-Glausch (3):
      KVM: s390: vsie: Fix STFLE interpretive execution identification
      KVM: s390: vsie: Fix length of facility list shadowed
      KVM: s390: cpu model: Use proper define for facility mask size

Oliver Upton (4):
      KVM: arm64: vgic: Use common accessor for writes to ISPENDR
      KVM: arm64: vgic: Use common accessor for writes to ICPENDR
      KVM: arm64: vgic-v3: Reinterpret user ISPENDR writes as I{C,S}PENDR
      KVM: arm64: vgic-its: Avoid potential UAF in LPI translation cache

Paolo Bonzini (30):
      selftests: kvm/s390x: use vm_create_barebones()
      fs: Rename anon_inode_getfile_secure() and anon_inode_getfd_secure()
      Merge branch 'kvm-guestmemfd' into HEAD
      selftests/kvm: fix compilation on non-x86_64 platforms
      KVM: x86/mmu: remove unnecessary "bool shared" argument from functions
      KVM: x86/mmu: remove unnecessary "bool shared" argument from iterators
      KVM: x86/mmu: always take tdp_mmu_pages_lock
      KVM: x86/mmu: fix comment about mmu_unsync_pages_lock
      KVM: selftests: fix supported_flags for aarch64
      KVM: guest-memfd: fix unused-function warning
      Merge tag 'kvm-x86-selftests-6.7-rcN' of https://github.com/kvm-x86/linux into HEAD
      KVM: remove CONFIG_HAVE_KVM_EVENTFD
      KVM: remove CONFIG_HAVE_KVM_IRQFD
      KVM: remove deprecated UAPIs
      KVM: clean up directives to compile out irqfds
      Merge tag 'loongarch-kvm-6.8' of git://git.kernel.org/pub/scm/linux/kernel/git/chenhuacai/linux-loongson into HEAD
      Merge tag 'kvm-s390-next-6.8-1' of https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux into HEAD
      Merge tag 'kvm-riscv-6.8-1' of https://github.com/kvm-riscv/linux into HEAD
      KVM: introduce CONFIG_KVM_COMMON
      KVM: fix direction of dependency on MMU notifiers
      KVM: x86: add missing "depends on KVM"
      Merge tag 'kvmarm-6.8' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD
      Merge tag 'kvm-x86-generic-6.8' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-hyperv-6.8' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-misc-6.8' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-pmu-6.8' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-lam-6.8' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-svm-6.8' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-xen-6.8' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-mmu-6.8' of https://github.com/kvm-x86/linux into HEAD

Paul Durrant (1):
      KVM x86/xen: add an override for PVCLOCK_TSC_STABLE_BIT

Philipp Stanner (3):
      KVM: x86: Harden copying of userspace-array against overflow
      KVM: s390: Harden copying of userspace-array against overflow
      KVM: Harden copying of userspace-array against overflow

Robert Hoo (3):
      KVM: x86: Virtualize LAM for supervisor pointer
      KVM: x86: Virtualize LAM for user pointer
      KVM: x86: Advertise and enable LAM (user and supervisor)

Ryan Roberts (7):
      KVM: arm64: Add new (V)TCR_EL2 field definitions for FEAT_LPA2
      KVM: arm64: Use LPA2 page-tables for stage2 and hyp stage1
      KVM: arm64: Convert translation level parameter to s8
      KVM: arm64: Support up to 5 levels of translation in kvm_pgtable
      KVM: arm64: Allow guests with >48-bit IPA size on FEAT_LPA2 systems
      KVM: selftests: arm64: Determine max ipa size per-page size
      KVM: selftests: arm64: Support P52V48 4K and 16K guest_modes

Sean Christopherson (41):
      KVM: Tweak kvm_hva_range and hva_handler_t to allow reusing for gfn ranges
      KVM: Assert that mmu_invalidate_in_progress *never* goes negative
      KVM: WARN if there are dangling MMU invalidations at VM destruction
      KVM: PPC: Drop dead code related to KVM_ARCH_WANT_MMU_NOTIFIER
      KVM: PPC: Return '1' unconditionally for KVM_CAP_SYNC_MMU
      KVM: Convert KVM_ARCH_WANT_MMU_NOTIFIER to CONFIG_KVM_GENERIC_MMU_NOTIFIER
      KVM: Introduce KVM_SET_USER_MEMORY_REGION2
      KVM: Add a dedicated mmu_notifier flag for reclaiming freed memory
      KVM: Drop .on_unlock() mmu_notifier hook
      mm: Add AS_UNMOVABLE to mark mapping as completely unmovable
      KVM: Add KVM_CREATE_GUEST_MEMFD ioctl() for guest-specific backing memory
      KVM: x86: "Reset" vcpu->run->exit_reason early in KVM_RUN
      KVM: Drop superfluous __KVM_VCPU_MULTIPLE_ADDRESS_SPACE macro
      KVM: Allow arch code to track number of memslot address spaces per VM
      KVM: x86: Add support for "protected VMs" that can utilize private memory
      KVM: selftests: Drop unused kvm_userspace_memory_region_find() helper
      KVM: selftests: Convert lib's mem regions to KVM_SET_USER_MEMORY_REGION2
      KVM: selftests: Add support for creating private memslots
      KVM: selftests: Introduce VM "shape" to allow tests to specify the VM type
      KVM: selftests: Add GUEST_SYNC[1-6] macros for synchronizing more data
      KVM: selftests: Add a memory region subtest to validate invalid flags
      KVM: x86/mmu: Declare flush_remote_tlbs{_range}() hooks iff HYPERV!=n
      KVM: selftests: Drop the single-underscore ioctl() helpers
      KVM: selftests: Add logic to detect if ioctl() failed because VM was killed
      KVM: selftests: Remove x86's so called "MMIO warning" test
      KVM: x86: Turn off KVM_WERROR by default for all configs
      KVM: x86: Don't unnecessarily force masterclock update on vCPU hotplug
      Revert "nSVM: Check for reserved encodings of TLB_CONTROL in nested VMCB"
      KVM: nSVM: Advertise support for flush-by-ASID
      KVM: SVM: Explicitly require FLUSHBYASID to enable SEV support
      KVM: SVM: Don't intercept IRET when injecting NMI and vNMI is enabled
      KVM: x86/pmu: Move PMU reset logic to common x86 code
      KVM: x86/pmu: Reset the PMU, i.e. stop counters, before refreshing
      KVM: x86/pmu: Stop calling kvm_pmu_reset() at RESET (it's redundant)
      KVM: x86/pmu: Remove manual clearing of fields in kvm_pmu_init()
      KVM: x86/pmu: Update sample period in pmc_write_counter()
      KVM: x86/pmu: Track emulated counter events instead of previous counter
      KVM: selftests: Fix MWAIT error message when guest assertion fails
      KVM: selftests: Fix benign %llx vs. %lx issues in guest asserts
      KVM: selftests: Fix broken assert messages in Hyper-V features test
      KVM: selftests: Annotate guest ucall, printf, and assert helpers with __printf()

Steffen Eiden (1):
      s390/uvdevice: Report additional-data length for attestation

Tianrui Zhao (2):
      LoongArch: KVM: Add LSX (128bit SIMD) support
      LoongArch: KVM: Add LASX (256bit SIMD) support

Uros Bizjak (1):
      KVM: SVM,VMX: Use %rip-relative addressing to access kvm_rebooting

Vishal Annapurve (3):
      KVM: selftests: Add helpers to convert guest memory b/w private and shared
      KVM: selftests: Add helpers to do KVM_HC_MAP_GPA_RANGE hypercalls (x86)
      KVM: selftests: Add x86-only selftest for private memory conversions

Vitaly Kuznetsov (16):
      KVM: x86/xen: Remove unneeded xen context from kvm_arch when !CONFIG_KVM_XEN
      KVM: x86: Move Hyper-V partition assist page out of Hyper-V emulation context
      KVM: VMX: Split off vmx_onhyperv.{ch} from hyperv.{ch}
      KVM: x86: Introduce helper to check if auto-EOI is set in Hyper-V SynIC
      KVM: x86: Introduce helper to check if vector is set in Hyper-V SynIC
      KVM: VMX: Split off hyperv_evmcs.{ch}
      KVM: x86: Introduce helper to handle Hyper-V paravirt TLB flush requests
      KVM: nVMX: Split off helper for emulating VMCLEAR on Hyper-V eVMCS
      KVM: selftests: Make Hyper-V tests explicitly require KVM Hyper-V support
      KVM: selftests: Fix vmxon_pa == vmcs12_pa == -1ull nVMX testcase for !eVMCS
      KVM: nVMX: Move guest_cpuid_has_evmcs() to hyperv.h
      KVM: x86: Make Hyper-V emulation optional
      KVM: nVMX: Introduce helpers to check if Hyper-V evmptr12 is valid/set
      KVM: nVMX: Introduce accessor to get Hyper-V eVMCS pointer
      KVM: nVMX: Hide more stuff under CONFIG_KVM_HYPERV
      KVM: nSVM: Hide more stuff under CONFIG_KVM_HYPERV/CONFIG_HYPERV

Wei Wang (1):
      KVM: move KVM_CAP_DEVICE_CTRL to the generic check

Will Deacon (1):
      KVM: arm64: Add missing memory barriers when switching to pKVM's hyp pgd

angquan yu (1):
      KVM: selftests: Actually print out magic token in NX hugepages skip message

 Documentation/admin-guide/kernel-parameters.txt    |   6 +-
 Documentation/virt/kvm/api.rst                     | 219 +++++++-
 Documentation/virt/kvm/locking.rst                 |   7 +-
 arch/arm64/include/asm/esr.h                       |  15 +
 arch/arm64/include/asm/kvm_arm.h                   |  57 +-
 arch/arm64/include/asm/kvm_emulate.h               |  34 +-
 arch/arm64/include/asm/kvm_host.h                  | 140 +++--
 arch/arm64/include/asm/kvm_nested.h                |  56 +-
 arch/arm64/include/asm/kvm_pgtable.h               |  76 ++-
 arch/arm64/include/asm/kvm_pkvm.h                  |   5 +-
 arch/arm64/include/asm/vncr_mapping.h              | 103 ++++
 arch/arm64/kernel/cpufeature.c                     |   2 +-
 arch/arm64/kvm/Kconfig                             |   7 +-
 arch/arm64/kvm/arch_timer.c                        |   3 +-
 arch/arm64/kvm/arm.c                               |  12 +-
 arch/arm64/kvm/emulate-nested.c                    |  63 +++
 arch/arm64/kvm/hyp/include/hyp/fault.h             |   2 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h            |  93 ++--
 arch/arm64/kvm/hyp/include/nvhe/fixed_config.h     |  22 +-
 arch/arm64/kvm/hyp/nvhe/hyp-init.S                 |   6 +-
 arch/arm64/kvm/hyp/nvhe/mem_protect.c              |   6 +-
 arch/arm64/kvm/hyp/nvhe/mm.c                       |   4 +-
 arch/arm64/kvm/hyp/nvhe/pkvm.c                     |   4 +
 arch/arm64/kvm/hyp/nvhe/setup.c                    |   2 +-
 arch/arm64/kvm/hyp/pgtable.c                       |  90 ++--
 arch/arm64/kvm/mmu.c                               |  49 +-
 arch/arm64/kvm/nested.c                            |  22 +-
 arch/arm64/kvm/reset.c                             |   9 +-
 arch/arm64/kvm/sys_regs.c                          | 235 +++++++--
 arch/arm64/kvm/vgic/vgic-its.c                     |   5 +
 arch/arm64/kvm/vgic/vgic-mmio-v3.c                 |  28 +-
 arch/arm64/kvm/vgic/vgic-mmio.c                    | 101 ++--
 arch/loongarch/include/asm/kvm_host.h              |  25 +-
 arch/loongarch/include/asm/kvm_vcpu.h              |  21 +-
 arch/loongarch/include/uapi/asm/kvm.h              |   1 +
 arch/loongarch/kernel/fpu.S                        |   2 +
 arch/loongarch/kvm/Kconfig                         |   5 +-
 arch/loongarch/kvm/exit.c                          |  50 +-
 arch/loongarch/kvm/main.c                          |   1 -
 arch/loongarch/kvm/mmu.c                           | 124 +++--
 arch/loongarch/kvm/switch.S                        |  31 ++
 arch/loongarch/kvm/timer.c                         | 127 +++--
 arch/loongarch/kvm/trace.h                         |   6 +-
 arch/loongarch/kvm/vcpu.c                          | 307 +++++++++--
 arch/mips/include/asm/kvm_host.h                   |   2 -
 arch/mips/kvm/Kconfig                              |   6 +-
 arch/powerpc/include/asm/kvm_host.h                |   2 -
 arch/powerpc/kvm/Kconfig                           |  14 +-
 arch/powerpc/kvm/book3s_hv.c                       |   2 +-
 arch/powerpc/kvm/powerpc.c                         |  10 +-
 arch/riscv/Kconfig                                 |  19 +
 arch/riscv/include/asm/kvm_host.h                  |  12 +-
 arch/riscv/include/asm/kvm_vcpu_sbi.h              |  20 +-
 arch/riscv/include/asm/paravirt.h                  |  28 +
 arch/riscv/include/asm/paravirt_api_clock.h        |   1 +
 arch/riscv/include/asm/sbi.h                       |  17 +
 arch/riscv/include/uapi/asm/kvm.h                  |  13 +
 arch/riscv/kernel/Makefile                         |   1 +
 arch/riscv/kernel/paravirt.c                       | 135 +++++
 arch/riscv/kernel/time.c                           |   3 +
 arch/riscv/kvm/Kconfig                             |   7 +-
 arch/riscv/kvm/Makefile                            |   1 +
 arch/riscv/kvm/vcpu.c                              |  10 +-
 arch/riscv/kvm/vcpu_onereg.c                       | 143 +++--
 arch/riscv/kvm/vcpu_sbi.c                          | 142 +++--
 arch/riscv/kvm/vcpu_sbi_replace.c                  |   2 +-
 arch/riscv/kvm/vcpu_sbi_sta.c                      | 208 ++++++++
 arch/riscv/kvm/vcpu_switch.S                       |  32 +-
 arch/riscv/kvm/vcpu_vector.c                       |  16 +
 arch/riscv/kvm/vm.c                                |   1 -
 arch/s390/include/asm/facility.h                   |   6 +
 arch/s390/include/asm/kvm_host.h                   |   2 +-
 arch/s390/kernel/Makefile                          |   2 +-
 arch/s390/kernel/facility.c                        |  21 +
 arch/s390/kvm/Kconfig                              |   5 +-
 arch/s390/kvm/guestdbg.c                           |   4 +-
 arch/s390/kvm/kvm-s390.c                           |   1 -
 arch/s390/kvm/vsie.c                               |  19 +-
 arch/x86/include/asm/kvm-x86-ops.h                 |   3 +
 arch/x86/include/asm/kvm-x86-pmu-ops.h             |   2 +-
 arch/x86/include/asm/kvm_host.h                    |  75 ++-
 arch/x86/include/uapi/asm/kvm.h                    |   3 +
 arch/x86/kernel/kvmclock.c                         |  12 +-
 arch/x86/kvm/Kconfig                               |  47 +-
 arch/x86/kvm/Makefile                              |  16 +-
 arch/x86/kvm/cpuid.c                               |  33 +-
 arch/x86/kvm/cpuid.h                               |  13 +-
 arch/x86/kvm/debugfs.c                             |   2 +-
 arch/x86/kvm/emulate.c                             |  27 +-
 arch/x86/kvm/governed_features.h                   |   1 +
 arch/x86/kvm/hyperv.h                              |  87 +++-
 arch/x86/kvm/irq.c                                 |   2 +
 arch/x86/kvm/irq_comm.c                            |   9 +-
 arch/x86/kvm/kvm_emulate.h                         |   9 +
 arch/x86/kvm/kvm_onhyperv.h                        |  20 +
 arch/x86/kvm/lapic.c                               |   5 +-
 arch/x86/kvm/mmu.h                                 |   8 +
 arch/x86/kvm/mmu/mmu.c                             | 293 ++++++++++-
 arch/x86/kvm/mmu/mmu_internal.h                    |   3 +
 arch/x86/kvm/mmu/paging_tmpl.h                     |   2 +-
 arch/x86/kvm/mmu/tdp_mmu.c                         |  95 ++--
 arch/x86/kvm/mmu/tdp_mmu.h                         |   3 +-
 arch/x86/kvm/pmu.c                                 | 140 ++++-
 arch/x86/kvm/pmu.h                                 |  47 +-
 arch/x86/kvm/reverse_cpuid.h                       |  33 +-
 arch/x86/kvm/svm/hyperv.h                          |   9 +
 arch/x86/kvm/svm/nested.c                          |  49 +-
 arch/x86/kvm/svm/pmu.c                             |  17 -
 arch/x86/kvm/svm/sev.c                             |   7 +-
 arch/x86/kvm/svm/svm.c                             |  18 +-
 arch/x86/kvm/svm/svm.h                             |   2 +
 arch/x86/kvm/svm/svm_onhyperv.c                    |  10 +-
 arch/x86/kvm/svm/vmenter.S                         |  10 +-
 arch/x86/kvm/vmx/hyperv.c                          | 447 ----------------
 arch/x86/kvm/vmx/hyperv.h                          | 238 +++------
 arch/x86/kvm/vmx/hyperv_evmcs.c                    | 315 +++++++++++
 arch/x86/kvm/vmx/hyperv_evmcs.h                    | 166 ++++++
 arch/x86/kvm/vmx/nested.c                          | 160 +++---
 arch/x86/kvm/vmx/nested.h                          |   3 +-
 arch/x86/kvm/vmx/pmu_intel.c                       |  22 -
 arch/x86/kvm/vmx/sgx.c                             |   1 +
 arch/x86/kvm/vmx/vmenter.S                         |   2 +-
 arch/x86/kvm/vmx/vmx.c                             |  86 ++-
 arch/x86/kvm/vmx/vmx.h                             |  14 +-
 arch/x86/kvm/vmx/vmx_onhyperv.c                    |  36 ++
 arch/x86/kvm/vmx/vmx_onhyperv.h                    | 125 +++++
 arch/x86/kvm/vmx/vmx_ops.h                         |   2 +-
 arch/x86/kvm/x86.c                                 | 168 ++++--
 arch/x86/kvm/x86.h                                 |   2 +
 arch/x86/kvm/xen.c                                 |   9 +-
 drivers/s390/char/uvdevice.c                       |   3 +
 fs/anon_inodes.c                                   |  51 +-
 fs/userfaultfd.c                                   |   5 +-
 include/linux/anon_inodes.h                        |   4 +-
 include/linux/kvm_host.h                           | 181 +++++--
 include/linux/kvm_types.h                          |   1 +
 include/linux/pagemap.h                            |  17 +
 include/trace/events/kvm.h                         |   8 +-
 include/uapi/linux/kvm.h                           | 140 ++---
 io_uring/io_uring.c                                |   3 +-
 mm/compaction.c                                    |  43 +-
 mm/migrate.c                                       |   2 +
 tools/testing/selftests/kvm/Makefile               |   9 +-
 .../selftests/kvm/aarch64/page_fault_test.c        |   2 +-
 tools/testing/selftests/kvm/dirty_log_test.c       |   2 +-
 tools/testing/selftests/kvm/guest_memfd_test.c     | 198 +++++++
 .../selftests/kvm/include/aarch64/processor.h      |   4 +-
 tools/testing/selftests/kvm/include/guest_modes.h  |   4 +-
 .../testing/selftests/kvm/include/kvm_util_base.h  | 217 ++++++--
 .../selftests/kvm/include/riscv/processor.h        |  62 ++-
 tools/testing/selftests/kvm/include/test_util.h    |   7 +-
 tools/testing/selftests/kvm/include/ucall_common.h |  18 +-
 .../selftests/kvm/include/x86_64/processor.h       |  15 +
 tools/testing/selftests/kvm/kvm_page_table_test.c  |   2 +-
 .../testing/selftests/kvm/lib/aarch64/processor.c  |  69 ++-
 tools/testing/selftests/kvm/lib/guest_modes.c      |  50 +-
 tools/testing/selftests/kvm/lib/kvm_util.c         | 229 ++++----
 tools/testing/selftests/kvm/lib/memstress.c        |   3 +-
 tools/testing/selftests/kvm/lib/riscv/processor.c  |  49 +-
 tools/testing/selftests/kvm/lib/riscv/ucall.c      |  26 -
 tools/testing/selftests/kvm/riscv/get-reg-list.c   | 576 ++++++++++-----------
 tools/testing/selftests/kvm/s390x/cmma_test.c      |  11 +-
 .../testing/selftests/kvm/set_memory_region_test.c | 161 +++++-
 tools/testing/selftests/kvm/steal_time.c           |  99 ++++
 tools/testing/selftests/kvm/x86_64/hyperv_clock.c  |   2 +
 tools/testing/selftests/kvm/x86_64/hyperv_evmcs.c  |   5 +-
 .../kvm/x86_64/hyperv_extended_hypercalls.c        |   2 +
 .../testing/selftests/kvm/x86_64/hyperv_features.c |  12 +-
 tools/testing/selftests/kvm/x86_64/hyperv_ipi.c    |   2 +
 .../testing/selftests/kvm/x86_64/hyperv_svm_test.c |   1 +
 .../selftests/kvm/x86_64/hyperv_tlb_flush.c        |   2 +
 .../selftests/kvm/x86_64/mmio_warning_test.c       | 121 -----
 .../selftests/kvm/x86_64/monitor_mwait_test.c      |   6 +-
 .../kvm/x86_64/private_mem_conversions_test.c      | 482 +++++++++++++++++
 .../kvm/x86_64/private_mem_kvm_exits_test.c        | 120 +++++
 .../kvm/x86_64/svm_nested_soft_inject_test.c       |   4 +-
 .../selftests/kvm/x86_64/ucna_injection_test.c     |   2 +-
 .../selftests/kvm/x86_64/vmx_pmu_caps_test.c       |   2 +-
 .../kvm/x86_64/vmx_set_nested_state_test.c         |  16 +-
 .../testing/selftests/kvm/x86_64/xcr0_cpuid_test.c |   8 +-
 virt/kvm/Kconfig                                   |  30 +-
 virt/kvm/Makefile.kvm                              |   1 +
 virt/kvm/dirty_ring.c                              |   2 +-
 virt/kvm/eventfd.c                                 |  28 +-
 virt/kvm/guest_memfd.c                             | 532 +++++++++++++++++++
 virt/kvm/kvm_main.c                                | 522 ++++++++++++++++---
 virt/kvm/kvm_mm.h                                  |  26 +
 187 files changed, 7478 insertions(+), 2719 deletions(-)
 create mode 100644 arch/arm64/include/asm/vncr_mapping.h
 create mode 100644 arch/riscv/include/asm/paravirt.h
 create mode 100644 arch/riscv/include/asm/paravirt_api_clock.h
 create mode 100644 arch/riscv/kernel/paravirt.c
 create mode 100644 arch/riscv/kvm/vcpu_sbi_sta.c
 create mode 100644 arch/s390/kernel/facility.c
 create mode 100644 arch/x86/kvm/vmx/hyperv_evmcs.c
 create mode 100644 arch/x86/kvm/vmx/hyperv_evmcs.h
 create mode 100644 arch/x86/kvm/vmx/vmx_onhyperv.c
 create mode 100644 arch/x86/kvm/vmx/vmx_onhyperv.h
 create mode 100644 tools/testing/selftests/kvm/guest_memfd_test.c
 delete mode 100644 tools/testing/selftests/kvm/x86_64/mmio_warning_test.c
 create mode 100644 tools/testing/selftests/kvm/x86_64/private_mem_conversions_test.c
 create mode 100644 tools/testing/selftests/kvm/x86_64/private_mem_kvm_exits_test.c
 create mode 100644 virt/kvm/guest_memfd.c


diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index c2e2371720a9..c23ce219e21c 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -97,7 +97,7 @@ static void kvm_gmem_invalidate_end(struct kvm_gmem *gmem, pgoff_t start,
 
 static long kvm_gmem_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 {
-	struct list_head *gmem_list = &inode->i_mapping->private_list;
+	struct list_head *gmem_list = &inode->i_mapping->i_private_list;
 	pgoff_t start = offset >> PAGE_SHIFT;
 	pgoff_t end = (offset + len) >> PAGE_SHIFT;
 	struct kvm_gmem *gmem;
@@ -267,16 +267,17 @@ static int kvm_gmem_migrate_folio(struct address_space *mapping,
 	return -EINVAL;
 }
 
-static int kvm_gmem_error_page(struct address_space *mapping, struct page *page)
+static int kvm_gmem_error_folio(struct address_space *mapping,
+				struct folio *folio)
 {
-	struct list_head *gmem_list = &mapping->private_list;
+	struct list_head *gmem_list = &mapping->i_private_list;
 	struct kvm_gmem *gmem;
 	pgoff_t start, end;
 
 	filemap_invalidate_lock_shared(mapping);
 
-	start = page->index;
-	end = start + thp_nr_pages(page);
+	start = folio->index;
+	end = start + folio_nr_pages(folio);
 
 	list_for_each_entry(gmem, gmem_list, entry)
 		kvm_gmem_invalidate_begin(gmem, start, end);
@@ -301,7 +302,7 @@ static int kvm_gmem_error_page(struct address_space *mapping, struct page *page)
 static const struct address_space_operations kvm_gmem_aops = {
 	.dirty_folio = noop_dirty_folio,
 	.migrate_folio	= kvm_gmem_migrate_folio,
-	.error_remove_page = kvm_gmem_error_page,
+	.error_remove_folio = kvm_gmem_error_folio,
 };
 
 static int kvm_gmem_getattr(struct mnt_idmap *idmap, const struct path *path,
@@ -367,7 +368,7 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
 	kvm_get_kvm(kvm);
 	gmem->kvm = kvm;
 	xa_init(&gmem->bindings);
-	list_add(&gmem->entry, &inode->i_mapping->private_list);
+	list_add(&gmem->entry, &inode->i_mapping->i_private_list);
 
 	fd_install(fd, file);
 	return fd;


