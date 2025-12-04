Return-Path: <kvm+bounces-65302-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 6AC87CA4D96
	for <lists+kvm@lfdr.de>; Thu, 04 Dec 2025 19:07:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7091A307928B
	for <lists+kvm@lfdr.de>; Thu,  4 Dec 2025 18:06:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B90C62F6197;
	Thu,  4 Dec 2025 18:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="M1hl9agd";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="j+BEb3Wz"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55FDF36C5A4
	for <kvm@vger.kernel.org>; Thu,  4 Dec 2025 18:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764871591; cv=none; b=lYgHZUTZ9aYIqdZbbHa5nBef9UzWlb9c2tjZbOJIRc9y2vfGkX9Fc+WlM0yLf9ZC7zKvXiEHI8lr5Idis4AhyF7rAc4E2DMfHX8lY28ytmhQMgDgGLlPSSHAHGmmuMreTHy+X9+SczqHVjhp85VNW23QlJ26HiMXNK35jRa+Mgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764871591; c=relaxed/simple;
	bh=LZTIS9chL9e1Us5qCsIZUZhd/EzN6Shm9Ug64pLCI8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ko090swNXq9DBoSW9q4o7hbfYN68ud5b0tD3d5XXzjVuPsVRhFvXF9MSTljYyYyhCMihDPbDiYLSBhIBezhsXLNxpj3AEFNjuYPl+Ekp90efIGk+oBqgo5xs6r2uSg0A7IQzqzYbO+dgB8ommfLU9K3KiU1/hsvmZG7rwnbUY3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=M1hl9agd; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=j+BEb3Wz; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764871587;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=/HKpiccGmyMSbTM/XhYlpR2a6ZO9k4pnFeMiSh+mMvE=;
	b=M1hl9agd8cwlqhSY8Y5CykRyER7xxMH7dKXwEkzRE97LEDfjOEjhcIAwPFwJnfxk8cucCt
	9xMkCHlSXKDJFqvJ0fzj8JWLWSTePUKR++b723/++Fq+/QYwlUUo41TG49pUwTNIipNAaU
	yV6X03u1Ih/krmrTecL3HGWDlApO2Tg=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-197-r-il2hrQMZOiG8ZajAdduA-1; Thu, 04 Dec 2025 13:06:23 -0500
X-MC-Unique: r-il2hrQMZOiG8ZajAdduA-1
X-Mimecast-MFC-AGG-ID: r-il2hrQMZOiG8ZajAdduA_1764871583
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-42b30184be7so641081f8f.2
        for <kvm@vger.kernel.org>; Thu, 04 Dec 2025 10:06:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764871582; x=1765476382; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/HKpiccGmyMSbTM/XhYlpR2a6ZO9k4pnFeMiSh+mMvE=;
        b=j+BEb3Wzle1StDbSpVe1QKQnpps83qqPK89tNHPCH/ND0IoqFvzVDw+M66PiwXS17J
         2aqZnrpBMN36/1OtMykcBEk0fqXQ4cl68gPLEIgqCrVZbZfNLI2zUgpeJ/gpPIUIjpal
         AjEDhuns2RbgOAJ3jneDTAdiL5H3fJn0UDZ3WJtrsCubB28OO3m3Q69PM/8wdTltgznf
         H5YnM5tmXytAs8wQ9I8aUPaCkIXuI14hWd+yXQ9eQ4td1Qv3PctSeOgb4fyXrfAKIudo
         gGGz3gl5sKHORE83TPew+KjTF1AEmBrH90hAylgXrxjArEl576ApKJME1T3J1th4/PBU
         FBfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764871582; x=1765476382;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/HKpiccGmyMSbTM/XhYlpR2a6ZO9k4pnFeMiSh+mMvE=;
        b=Qm1WSNtzuRZja+IpABIeP5cWPJxrTCD3mIOfyIN03ceBd6htLxamxOIwR+dclqrGNa
         8kPdfL3fyjdW8kBYU/BDE/DFEvFUXnbL7W96jpjBXXvaTRvczj41NYkV/J8Agk93DNxH
         2+TOCX94MT/Ed3DRhyUXmLr53WbrwJoeSs1k94E97CHfLUiKAuFL1scirFSOo141BgGy
         zJdxLH26z15slxP2jKBz2Mn5Sx06XtcutD7gnrCo6XejGgYNLmSBmPAOrkd4JvDqfNea
         z9XbjV0SCzaLaNHg5h06XmYU23riXoQQf8JdIl7GAX09+YTYGxomWy5FpVJjXpT1tyQi
         h6SQ==
X-Forwarded-Encrypted: i=1; AJvYcCUtRmzhGDgLa8ld8OS8ZVGX8zrk5cbQi5IGDu8lEU5BUi9KhYQKfwtKprMWrQ/9rmlzz2U=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxch9jwP83x1BJQCtdVxA5o8O5x3tw9Wn2PldekaMeJ+6phv2Gf
	ZowIa8r3EaM588unLVxvnz+zsZ9BfjtB2o91pCE/clduQsnjzAElXfITqylfeWJ+UlIeZR5nk/z
	xhu0NHCREwUPd0WeaKxHHyrAOcZsKnhgPvZPCRLT3v6ve57Yl+5vaeQ==
X-Gm-Gg: ASbGncubNeeDVT1PQ7vvWvc96tpgzH8HP4RaQjVYDh7JWeoOP/de9+tNrR8lpaDD0lf
	MVp2fK3Fwvnq2iVk7tVfY+nV5RSFEQE2FLhlFOQxTruUHpwt5uXCATn3LzsM++9X2NSri9UsUW6
	yEID6AgD0fO9k8r+/rB6nnX4uYxr/IsnfCQuJEcGN2BVngD11g+axpbpi7u0EiosLxz8oFfJRY+
	EXoVyRcPDzMHt2PqsqL2Y4QZCiSViaN6tqcrwpVwtwDfGBPiZ9DOB3P9ArQA9xQXJN5Ddo42D4Z
	tu2FP6De5g4opRg0twthOGechnJBkzwy9n06ONwutz5D0Vi/hPOMxgb33GG7OYbfKpRCZ8uMWe4
	lFwJHPWLHUp8iCBuRcmPwXkm5vpSfltk+ARu6yFEtlvZR5x7sJST1oPFprHw5C1RSdbbyFlONxB
	SiGrNUsdXwECQ=
X-Received: by 2002:a05:6000:2c0c:b0:429:c774:dbfc with SMTP id ffacd0b85a97d-42f73173f15mr7372505f8f.12.1764871581352;
        Thu, 04 Dec 2025 10:06:21 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG6STSq+EKQ5npb0V55VLkZzHVdlGJYKCtNsYxlUdYbL2dX67533iKsEEWNzAdYt9r9F70Tkw==
X-Received: by 2002:a05:6000:2c0c:b0:429:c774:dbfc with SMTP id ffacd0b85a97d-42f73173f15mr7372428f8f.12.1764871580183;
        Thu, 04 Dec 2025 10:06:20 -0800 (PST)
Received: from [192.168.1.84] ([93.56.161.42])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42f7d353f80sm4457176f8f.41.2025.12.04.10.06.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 10:06:19 -0800 (PST)
From: Paolo Bonzini <pbonzini@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [GIT PULL] KVM changes for Linux 6.19-rc1
Date: Thu,  4 Dec 2025 19:06:19 +0100
Message-ID: <20251204180619.33800-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Linus,

The following changes since commit ac3fd01e4c1efce8f2c054cdeb2ddd2fc0fb150d:

  Linux 6.18-rc7 (2025-11-23 14:53:16 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to e0c26d47def7382d7dbd9cad58bc653aed75737a:

  Merge tag 'kvm-s390-next-6.19-1' of https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux into HEAD (2025-12-02 18:58:47 +0100)

A fairly small release, with several nice cleanups and bugfixes; the main
major feature is NUMA support in guest_memfd.

There's only a minor conflict with the tip tree, due to different features
being added to the Linux-defined words of arch/x86/include/asm/cpufeatures.h.

Thanks,

Paolo
----------------------------------------------------------------
ARM:

- Support for userspace handling of synchronous external aborts (SEAs),
  allowing the VMM to potentially handle the abort in a non-fatal
  manner.

- Large rework of the VGIC's list register handling with the goal of
  supporting more active/pending IRQs than available list registers in
  hardware. In addition, the VGIC now supports EOImode==1 style
  deactivations for IRQs which may occur on a separate vCPU than the
  one that acked the IRQ.

- Support for FEAT_XNX (user / privileged execute permissions) and
  FEAT_HAF (hardware update to the Access Flag) in the software page
  table walkers and shadow MMU.

- Allow page table destruction to reschedule, fixing long need_resched
  latencies observed when destroying a large VM.

- Minor fixes to KVM and selftests

Loongarch:

- Get VM PMU capability from HW GCFG register.

- Add AVEC basic support.

- Use 64-bit register definition for EIOINTC.

- Add KVM timer test cases for tools/selftests.

RISC/V:

- SBI message passing (MPXY) support for KVM guest

- Give a new, more specific error subcode for the case when in-kernel
  AIA virtualization fails to allocate IMSIC VS-file

- Support KVM_DIRTY_LOG_INITIALLY_SET, enabling dirty log gradually
  in small chunks

- Fix guest page fault within HLV* instructions

- Flush VS-stage TLB after VCPU migration for Andes cores

s390:

- Always allocate ESCA (Extended System Control Area), instead of
  starting with the basic SCA and converting to ESCA with the
  addition of the 65th vCPU.  The price is increased number of
  exits (and worse performance) on z10 and earlier processor;
  ESCA was introduced by z114/z196 in 2010.

- VIRT_XFER_TO_GUEST_WORK support

- Operation exception forwarding support

- Cleanups

x86:

- Skip the costly "zap all SPTEs" on an MMIO generation wrap if MMIO SPTE
  caching is disabled, as there can't be any relevant SPTEs to zap.

- Relocate a misplaced export.

- Fix an async #PF bug where KVM would clear the completion queue when the
  guest transitioned in and out of paging mode, e.g. when handling an SMI and
  then returning to paged mode via RSM.

- Leave KVM's user-return notifier registered even when disabling
  virtualization, as long as kvm.ko is loaded.  On reboot/shutdown, keeping
  the notifier registered is ok; the kernel does not use the MSRs and the
  callback will run cleanly and restore host MSRs if the CPU manages to
  return to userspace before the system goes down.

- Use the checked version of {get,put}_user().

- Fix a long-lurking bug where KVM's lack of catch-up logic for periodic APIC
  timers can result in a hard lockup in the host.

- Revert the periodic kvmclock sync logic now that KVM doesn't use a
  clocksource that's subject to NTP corrections.

- Clean up KVM's handling of MMIO Stale Data and L1TF, and bury the latter
  behind CONFIG_CPU_MITIGATIONS.

- Context switch XCR0, XSS, and PKRU outside of the entry/exit fast path;
  the only reason they were handled in the fast path was to paper of a bug
  in the core #MC code, and that has long since been fixed.

- Add emulator support for AVX MOV instructions, to play nice with emulated
  devices whose guest drivers like to access PCI BARs with large multi-byte
  instructions.

x86 (AMD):

- Fix a few missing "VMCB dirty" bugs.

- Fix the worst of KVM's lack of EFER.LMSLE emulation.

- Add AVIC support for addressing 4k vCPUs in x2AVIC mode.

- Fix incorrect handling of selective CR0 writes when checking intercepts
  during emulation of L2 instructions.

- Fix a currently-benign bug where KVM would clobber SPEC_CTRL[63:32] on
  VMRUN and #VMEXIT.

- Fix a bug where KVM corrupt the guest code stream when re-injecting a soft
  interrupt if the guest patched the underlying code after the VM-Exit, e.g.
  when Linux patches code with a temporary INT3.

- Add KVM_X86_SNP_POLICY_BITS to advertise supported SNP policy bits to
  userspace, and extend KVM "support" to all policy bits that don't require
  any actual support from KVM.

x86 (Intel):

- Use the root role from kvm_mmu_page to construct EPTPs instead of the
  current vCPU state, partly as worthwhile cleanup, but mostly to pave the
  way for tracking per-root TLB flushes, and elide EPT flushes on pCPU
  migration if the root is clean from a previous flush.

- Add a few missing nested consistency checks.

- Rip out support for doing "early" consistency checks via hardware as the
  functionality hasn't been used in years and is no longer useful in general;
  replace it with an off-by-default module param to WARN if hardware fails
  a check that KVM does not perform.

- Fix a currently-benign bug where KVM would drop the guest's SPEC_CTRL[63:32]
  on VM-Enter.

- Misc cleanups.

- Overhaul the TDX code to address systemic races where KVM (acting on behalf
  of userspace) could inadvertantly trigger lock contention in the TDX-Module;
  KVM was either working around these in weird, ugly ways, or was simply
  oblivious to them (though even Yan's devilish selftests could only break
  individual VMs, not the host kernel)

- Fix a bug where KVM could corrupt a vCPU's cpu_list when freeing a TDX vCPU,
  if creating said vCPU failed partway through.

- Fix a few sparse warnings (bad annotation, 0 != NULL).

- Use struct_size() to simplify copying TDX capabilities to userspace.

- Fix a bug where TDX would effectively corrupt user-return MSR values if the
  TDX Module rejects VP.ENTER and thus doesn't clobber host MSRs as expected.

Selftests:

- Fix a math goof in mmu_stress_test when running on a single-CPU system/VM.

- Forcefully override ARCH from x86_64 to x86 to play nice with specifying
  ARCH=x86_64 on the command line.

- Extend a bunch of nested VMX to validate nested SVM as well.

- Add support for LA57 in the core VM_MODE_xxx macro, and add a test to
  verify KVM can save/restore nested VMX state when L1 is using 5-level
  paging, but L2 is not.

- Clean up the guest paging code in anticipation of sharing the core logic for
  nested EPT and nested NPT.

guest_memfd:

- Add NUMA mempolicy support for guest_memfd, and clean up a variety of
  rough edges in guest_memfd along the way.

- Define a CLASS to automatically handle get+put when grabbing a guest_memfd
  from a memslot to make it harder to leak references.

- Enhance KVM selftests to make it easer to develop and debug selftests like
  those added for guest_memfd NUMA support, e.g. where test and/or KVM bugs
  often result in hard-to-debug SIGBUS errors.

- Misc cleanups.

Generic:

- Use the recently-added WQ_PERCPU when creating the per-CPU workqueue for
  irqfd cleanup.

- Fix a goof in the dirty ring documentation.

- Fix choice of target for directed yield across different calls to
  kvm_vcpu_on_spin(); the function was always starting from the first
  vCPU instead of continuing the round-robin search.

----------------------------------------------------------------
Ackerley Tng (1):
      KVM: guest_memfd: Use guest mem inodes instead of anonymous inodes

Alexandru Elisei (3):
      KVM: arm64: Document KVM_PGTABLE_PROT_{UX,PX}
      KVM: arm64: at: Use correct HA bit in TCR_EL2 when regime is EL2
      KVM: arm64: at: Update AF on software walk only if VM has FEAT_HAFDBS

Andrew Donnellan (2):
      KVM: s390: Add signal_exits counter
      KVM: s390: Use generic VIRT_XFER_TO_GUEST_WORK functions

Anup Patel (4):
      RISC-V: KVM: Convert kvm_riscv_vcpu_sbi_forward() into extension handler
      RISC-V: KVM: Add separate source for forwarded SBI extensions
      RISC-V: KVM: Add SBI MPXY extension support for Guest
      KVM: riscv: selftests: Add SBI MPXY extension to get-reg-list

Bibo Mao (8):
      LoongArch: KVM: Get VM PMU capability from HW GCFG register
      LoongArch: KVM: Use 64-bit register definition for EIOINTC
      KVM: LoongArch: selftests: Add system registers save/restore on exception
      KVM: LoongArch: selftests: Add basic interfaces
      KVM: LoongArch: selftests: Add exception handler register interface
      KVM: LoongArch: selftests: Add timer interrupt test case
      KVM: LoongArch: selftests: Add SW emulated timer test case
      KVM: LoongArch: selftests: Add time counter test case

BillXiang (1):
      RISC-V: KVM: Introduce KVM_EXIT_FAIL_ENTRY_NO_VSFILE

Binbin Wu (1):
      KVM: x86: Add a helper to dedup loading guest/host XCR0 and XSS

Brendan Jackman (2):
      KVM: selftests: Don't fall over in mmu_stress_test when only one CPU is present
      KVM: x86: Unify L1TF flushing under per-CPU variable

Chang S. Bae (1):
      KVM: x86: Refactor REX prefix handling in instruction emulation

Chao Gao (1):
      KVM: x86: Allocate/free user_return_msrs at kvm.ko (un)loading time

Christoph Schlameuss (2):
      KVM: s390: Use ESCA instead of BSCA at VM init
      KVM: S390: Remove sca_lock

Colin Ian King (1):
      KVM: arm64: Fix spelling mistake "Unexpeced" -> "Unexpected"

Dave Hansen (2):
      KVM: TDX: Remove __user annotation from kernel pointer
      KVM: TDX: Fix sparse warnings from using 0 for NULL

Dmytro Maluka (2):
      KVM: x86/mmu: Skip MMIO SPTE invalidation if enable_mmio_caching=0
      KVM: VMX: Remove stale vmx_set_dr6() declaration

Dong Yang (1):
      KVM: riscv: Support enabling dirty log gradually in small chunks

Eric Farman (1):
      KVM: s390: vsie: Check alignment of BSCA header

Fangyu Yu (1):
      RISC-V: KVM: Fix guest page fault within HLV* instructions

Heiko Carstens (1):
      KVM: s390: Enable and disable interrupts in entry code

Hou Wenlong (1):
      KVM: x86: Don't disable IRQs when unregistering user-return notifier

Hui Min Mina Chou (1):
      RISC-V: KVM: Flush VS-stage TLB after VCPU migration for Andes cores

Janosch Frank (2):
      Documentation: kvm: Fix ordering
      KVM: s390: Add capability that forwards operation exceptions

Jiaqi Yan (3):
      KVM: arm64: VM exit to userspace to handle SEA
      KVM: selftests: Test for KVM_EXIT_ARM_SEA
      Documentation: kvm: new UAPI for handling SEA

Jim Mattson (8):
      KVM: SVM: Mark VMCB_PERM_MAP as dirty on nested VMRUN
      KVM: SVM: Mark VMCB_NPT as dirty on nested VMRUN
      KVM: x86: Advertise EferLmsleUnsupported to userspace
      KVM: SVM: Disallow EFER.LMSLE when not supported by hardware
      KVM: selftests: Use a loop to create guest page tables
      KVM: selftests: Use a loop to walk guest page tables
      KVM: selftests: Change VM_MODE_PXXV48_4K to VM_MODE_PXXVYY_4K
      KVM: selftests: Add a VMX test for LA57 nested state

Josephine Pfeiffer (1):
      KVM: s390: Replace sprintf with snprintf for buffer safety

Kai Huang (1):
      KVM: x86/mmu: Move the misplaced export of kvm_zap_gfn_range()

Lei Chen (3):
      Revert "x86: kvm: introduce periodic global clock updates"
      Revert "x86: kvm: rate-limit global clock updates"
      KVM: x86: remove comment about ntp correction sync for

Leonardo Bras (1):
      KVM: Fix VM exit code for full dirty ring in API documentation

Marc Zyngier (51):
      irqchip/gic: Add missing GICH_HCR control bits
      irqchip/gic: Expose CPU interface VA to KVM
      irqchip/apple-aic: Spit out ICH_MISR_EL2 value on spurious vGIC MI
      KVM: arm64: Turn vgic-v3 errata traps into a patched-in constant
      KVM: arm64: vgic-v3: Fix GICv3 trapping in protected mode
      KVM: arm64: GICv3: Detect and work around the lack of ICV_DIR_EL1 trapping
      KVM: arm64: Repack struct vgic_irq fields
      KVM: arm64: Add tracking of vgic_irq being present in a LR
      KVM: arm64: Add LR overflow handling documentation
      KVM: arm64: GICv3: Drop LPI active state when folding LRs
      KVM: arm64: GICv3: Preserve EOIcount on exit
      KVM: arm64: GICv3: Decouple ICH_HCR_EL2 programming from LRs
      KVM: arm64: GICv3: Extract LR folding primitive
      KVM: arm64: GICv3: Extract LR computing primitive
      KVM: arm64: GICv2: Preserve EOIcount on exit
      KVM: arm64: GICv2: Decouple GICH_HCR programming from LRs being loaded
      KVM: arm64: GICv2: Extract LR folding primitive
      KVM: arm64: GICv2: Extract LR computing primitive
      KVM: arm64: Compute vgic state irrespective of the number of interrupts
      KVM: arm64: Eagerly save VMCR on exit
      KVM: arm64: Revamp vgic maintenance interrupt configuration
      KVM: arm64: Turn kvm_vgic_vcpu_enable() into kvm_vgic_vcpu_reset()
      KVM: arm64: Make vgic_target_oracle() globally available
      KVM: arm64: Invert ap_list sorting to push active interrupts out
      KVM: arm64: Move undeliverable interrupts to the end of ap_list
      KVM: arm64: Use MI to detect groups being enabled/disabled
      KVM: arm64: GICv3: Handle LR overflow when EOImode==0
      KVM: arm64: GICv3: Handle deactivation via ICV_DIR_EL1 traps
      KVM: arm64: GICv3: Add GICv2 SGI handling to deactivation primitive
      KVM: arm64: GICv3: Set ICH_HCR_EL2.TDIR when interrupts overflow LR capacity
      KVM: arm64: GICv3: Add SPI tracking to handle asymmetric deactivation
      KVM: arm64: GICv3: Handle in-LR deactivation when possible
      KVM: arm64: GICv3: Avoid broadcast kick on CPUs lacking TDIR
      KVM: arm64: GICv3: nv: Resync LRs/VMCR/HCR early for better MI emulation
      KVM: arm64: GICv3: nv: Plug L1 LR sync into deactivation primitive
      KVM: arm64: GICv3: Force exit to sync ICH_HCR_EL2.En
      KVM: arm64: GICv2: Handle LR overflow when EOImode==0
      KVM: arm64: GICv2: Handle deactivation via GICV_DIR traps
      KVM: arm64: GICv2: Always trap GICV_DIR register
      KVM: arm64: selftests: gic_v3: Add irq group setting helper
      KVM: arm64: selftests: gic_v3: Disable Group-0 interrupts by default
      KVM: arm64: selftests: vgic_irq: Fix GUEST_ASSERT_IAR_EMPTY() helper
      KVM: arm64: selftests: vgic_irq: Change configuration before enabling interrupt
      KVM: arm64: selftests: vgic_irq: Exclude timer-controlled interrupts
      KVM: arm64: selftests: vgic_irq: Remove LR-bound limitation
      KVM: arm64: selftests: vgic_irq: Perform EOImode==1 deactivation in ack order
      KVM: arm64: selftests: vgic_irq: Add asymmetric SPI deaectivation test
      KVM: arm64: selftests: vgic_irq: Add Group-0 enable test
      KVM: arm64: selftests: vgic_irq: Add timer deactivation test
      KVM: arm64: Convert ICH_HCR_EL2_TDIR cap to EARLY_LOCAL_CPU_FEATURE
      KVM: arm64: Add endian casting to kvm_swap_s[12]_desc()

Marco Crivellari (1):
      KVM: Explicitly allocate/setup irqfd cleanup as per-CPU workqueue

Matthew Wilcox (2):
      mm/filemap: Add NUMA mempolicy support to filemap_alloc_folio()
      mm/filemap: Extend __filemap_get_folio() to support NUMA memory policies

Maxim Levitsky (2):
      KVM: x86: Fix a semi theoretical bug in kvm_arch_async_page_present_queued()
      KVM: x86: Don't clear async #PF queue when CR0.PG is disabled (e.g. on #SMI)

Maximilian Dittgen (2):
      KVM: selftests: Assert GICR_TYPER.Processor_Number matches selftest CPU number
      KVM: selftests: SYNC after guest ITS setup in vgic_lpi_stress

Nathan Chancellor (1):
      KVM: arm64: Add break to default case in kvm_pgtable_stage2_pte_prot()

Naveen N Rao (7):
      KVM: SVM: Limit AVIC physical max index based on configured max_vcpu_ids
      KVM: SVM: Add a helper to look up the max physical ID for AVIC
      KVM: SVM: Replace hard-coded value 0x1FF with the corresponding macro
      KVM: SVM: Expand AVIC_PHYSICAL_MAX_INDEX_MASK to be a 12-bit field
      KVM: SVM: Move AVIC Physical ID table allocation to vcpu_precreate()
      x86/cpufeatures: Add X86_FEATURE_X2AVIC_EXT
      KVM: SVM: Add AVIC support for 4k vCPUs in x2AVIC mode

Oliver Upton (23):
      KVM: arm64: Drop useless __GFP_HIGHMEM from kvm struct allocation
      KVM: arm64: Use kvzalloc() for kvm struct allocation
      KVM: arm64: Only drop references on empty tables in stage2_free_walker
      arm64: Detect FEAT_XNX
      KVM: arm64: Add support for FEAT_XNX stage-2 permissions
      KVM: arm64: nv: Forward FEAT_XNX permissions to the shadow stage-2
      KVM: arm64: Teach ptdump about FEAT_XNX permissions
      KVM: arm64: nv: Advertise support for FEAT_XNX
      KVM: arm64: Call helper for reading descriptors directly
      KVM: arm64: nv: Stop passing vCPU through void ptr in S2 PTW
      KVM: arm64: Handle endianness in read helper for emulated PTW
      KVM: arm64: nv: Use pgtable definitions in stage-2 walk
      KVM: arm64: Add helper for swapping guest descriptor
      KVM: arm64: Propagate PTW errors up to AT emulation
      KVM: arm64: Implement HW access flag management in stage-1 SW PTW
      KVM: arm64: nv: Implement HW access flag management in stage-2 SW PTW
      KVM: arm64: nv: Expose hardware access flag management to NV guests
      KVM: arm64: selftests: Add test for AT emulation
      KVM: arm64: Fix compilation when CONFIG_ARM64_USE_LSE_ATOMICS=n
      Merge branch 'kvm-arm64/misc' into kvmarm/next
      Merge branch 'kvm-arm64/sea-user' into kvmarm/next
      Merge branch 'kvm-arm64/vgic-lr-overflow' into kvmarm/next
      Merge branch 'kvm-arm64/nv-xnx-haf' into kvmarm/next

Omar Sandoval (1):
      KVM: SVM: Don't skip unrelated instruction if INT3/INTO is replaced

Paolo Bonzini (21):
      KVM: x86: Add support for emulating MOVNTDQA
      KVM: x86: Move Src2Shift up one bit (use bits 36:32 for Src2 in the emulator)
      KVM: x86: Improve formatting of the emulator's flags table
      KVM: x86: Move op_prefix to struct x86_emulate_ctxt (from x86_decode_insn())
      KVM: x86: Share emulator's common register decoding code
      KVM: x86: Add x86_emulate_ops.get_xcr() callback
      KVM: x86: Add AVX support to the emulator's register fetch and writeback
      KVM: x86: Add emulator support for decoding VEX prefixes
      KVM: x86: Enable support for emulating AVX MOV instructions
      Merge tag 'kvm-x86-generic-6.19' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-gmem-6.19' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-misc-6.19' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-selftests-6.19' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-mmu-6.19' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-tdx-6.19' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-vmx-6.19' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-svm-6.19' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'loongarch-kvm-6.19' of git://git.kernel.org/pub/scm/linux/kernel/git/chenhuacai/linux-loongson into HEAD
      Merge tag 'kvm-riscv-6.19-1' of https://github.com/kvm-riscv/linux into HEAD
      Merge tag 'kvmarm-6.19' of https://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD
      Merge tag 'kvm-s390-next-6.19-1' of https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux into HEAD

Pawan Gupta (1):
      x86/bugs: Use VM_CLEAR_CPU_BUFFERS in VMX as well

Pedro Demarchi Gomes (1):
      KVM: guest_memfd: use folio_nr_pages() instead of shift operation

Raghavendra Rao Ananta (2):
      KVM: arm64: Split kvm_pgtable_stage2_destroy()
      KVM: arm64: Reschedule as needed when destroying the stage-2 page-tables

Rick Edgecombe (1):
      KVM: TDX: Take MMU lock around tdh_vp_init()

Sean Christopherson (67):
      KVM: VMX: Hoist construct_eptp() "up" in vmx.c
      KVM: nVMX: Hardcode dummy EPTP used for early nested consistency checks
      KVM: x86/mmu: Move "dummy root" helpers to spte.h
      KVM: VMX: Use kvm_mmu_page role to construct EPTP, not current vCPU state
      KVM: nVMX: Add consistency check for TPR_THRESHOLD[31:4]!=0 without VID
      KVM: nVMX: Add consistency check for TSC_MULTIPLIER=0
      KVM: nVMX: Stuff vmcs02.TSC_MULTIPLIER early on for nested early checks
      KVM: nVMX: Remove support for "early" consistency checks via hardware
      KVM: nVMX: Add an off-by-default module param to WARN on missed consistency checks
      KVM: guest_memfd: Drop a superfluous local var in kvm_gmem_fault_user_mapping()
      KVM: guest_memfd: Rename "struct kvm_gmem" to "struct gmem_file"
      KVM: guest_memfd: Add macro to iterate over gmem_files for a mapping/inode
      KVM: selftests: Define wrappers for common syscalls to assert success
      KVM: selftests: Report stacktraces SIGBUS, SIGSEGV, SIGILL, and SIGFPE by default
      KVM: selftests: Add additional equivalents to libnuma APIs in KVM's numaif.h
      KVM: selftests: Use proper uAPI headers to pick up mempolicy.h definitions
      KVM: guest_memfd: Add gmem_inode.flags field instead of using i_private
      KVM: guest_memfd: Define a CLASS to get+put guest_memfd file from a memslot
      KVM: selftests: Forcefully override ARCH from x86_64 to x86
      KVM: selftests: Use "gpa" and "gva" for local variable names in pre-fault test
      KVM: selftests: Rename "guest_paddr" variables to "gpa"
      KVM: x86: Add a helper to dedup reporting of unhandled VM-Exits
      KVM: Make support for kvm_arch_vcpu_async_ioctl() mandatory
      KVM: Rename kvm_arch_vcpu_async_ioctl() to kvm_arch_vcpu_unlocked_ioctl()
      KVM: TDX: Drop PROVE_MMU=y sanity check on to-be-populated mappings
      KVM: x86/mmu: Add dedicated API to map guest_memfd pfn into TDP MMU
      KVM: x86/mmu: WARN if KVM attempts to map into an invalid TDP MMU root
      Revert "KVM: x86/tdp_mmu: Add a helper function to walk down the TDP MMU"
      KVM: x86/mmu: Rename kvm_tdp_map_page() to kvm_tdp_page_prefault()
      KVM: TDX: Return -EIO, not -EINVAL, on a KVM_BUG_ON() condition
      KVM: TDX: Fold tdx_sept_drop_private_spte() into tdx_sept_remove_private_spte()
      KVM: x86/mmu: Drop the return code from kvm_x86_ops.remove_external_spte()
      KVM: TDX: WARN if mirror SPTE doesn't have full RWX when creating S-EPT mapping
      KVM: TDX: Avoid a double-KVM_BUG_ON() in tdx_sept_zap_private_spte()
      KVM: TDX: Use atomic64_dec_return() instead of a poor equivalent
      KVM: TDX: Fold tdx_mem_page_record_premap_cnt() into its sole caller
      KVM: TDX: ADD pages to the TD image while populating mirror EPT entries
      KVM: TDX: Fold tdx_sept_zap_private_spte() into tdx_sept_remove_private_spte()
      KVM: TDX: Combine KVM_BUG_ON + pr_tdx_error() into TDX_BUG_ON()
      KVM: TDX: Derive error argument names from the local variable names
      KVM: TDX: Assert that mmu_lock is held for write when removing S-EPT entries
      KVM: TDX: Add macro to retry SEAMCALLs when forcing vCPUs out of guest
      KVM: TDX: Add tdx_get_cmd() helper to get and validate sub-ioctl command
      KVM: TDX: Convert INIT_MEM_REGION and INIT_VCPU to "unlocked" vCPU ioctl
      KVM: TDX: Use guard() to acquire kvm->lock in tdx_vm_ioctl()
      KVM: TDX: Don't copy "cmd" back to userspace for KVM_TDX_CAPABILITIES
      KVM: TDX: Guard VM state transitions with "all" the locks
      KVM: TDX: Bug the VM if extending the initial measurement fails
      KVM: TDX: Explicitly set user-return MSRs that *may* be clobbered by the TDX-Module
      KVM: x86: WARN if user-return MSR notifier is registered on exit
      KVM: x86: Leave user-return notifier registered on reboot/shutdown
      KVM: VMX: Make loaded_vmcs_clear() static in vmx.c
      KVM: TDX: Use struct_size to simplify tdx_get_capabilities()
      KVM: x86: Use "checked" versions of get_user() and put_user()
      KVM: x86: WARN if hrtimer callback for periodic APIC timer fires with period=0
      KVM: x86: Grab lapic_timer in a local variable to cleanup periodic code
      KVM: VMX: Use on-stack copy of @flags in __vmx_vcpu_run()
      x86/bugs: Decouple ALTERNATIVE usage from VERW macro definition
      x86/bugs: Use an x86 feature to track the MMIO Stale Data mitigation
      KVM: VMX: Handle MMIO Stale Data in VM-Enter assembly via ALTERNATIVES_2
      x86/bugs: KVM: Move VM_CLEAR_CPU_BUFFERS into SVM as SVM_CLEAR_CPU_BUFFERS
      KVM: VMX: Bundle all L1 data cache flush mitigation code together
      KVM: VMX: Disable L1TF L1 data cache flush if CONFIG_CPU_MITIGATIONS=n
      KVM: SVM: Handle #MCs in guest outside of fastpath
      KVM: VMX: Handle #MCs on VM-Enter/TD-Enter outside of the fastpath
      KVM: x86: Load guest/host XCR0 and XSS outside of the fastpath run loop
      KVM: x86: Load guest/host PKRU outside of the fastpath run loop

Shivank Garg (7):
      mm/mempolicy: Export memory policy symbols
      KVM: guest_memfd: move kvm_gmem_get_index() and use in kvm_gmem_prepare_folio()
      KVM: guest_memfd: remove redundant gmem variable initialization
      KVM: guest_memfd: Add slab-allocated inode cache
      KVM: guest_memfd: Enforce NUMA mempolicy using shared policy
      KVM: selftests: Add helpers to probe for NUMA support, and multi-node systems
      KVM: selftests: Add guest_memfd tests for mmap and NUMA policy support

Song Gao (1):
      LoongArch: KVM: Add AVEC basic support

Thorsten Blum (3):
      KVM: TDX: Replace kmalloc + copy_from_user with memdup_user in tdx_td_init()
      KVM: s390: Remove unused return variable in kvm_arch_vcpu_ioctl_set_fpu
      KVM: TDX: Check size of user's kvm_tdx_capabilities array before allocating

Tom Lendacky (4):
      KVM: SEV: Consolidate the SEV policy bits in a single header file
      crypto: ccp - Add an API to return the supported SEV-SNP policy bits
      KVM: SEV: Publish supported SEV-SNP policy bits
      KVM: SEV: Add known supported SEV-SNP policy bits

Uros Bizjak (2):
      KVM: VMX: Ensure guest's SPEC_CTRL[63:32] is loaded on VM-Enter
      KVM: SVM: Ensure SPEC_CTRL[63:32] is context switched between guest and host

Wanpeng Li (1):
      KVM: Fix last_boosted_vcpu index assignment bug

Xin Li (1):
      KVM: nVMX: Use vcpu instead of vmx->vcpu when vcpu is available

Yan Zhao (2):
      KVM: TDX: Drop superfluous page pinning in S-EPT management
      KVM: TDX: Fix list_add corruption during vcpu_load()

Yosry Ahmed (13):
      KVM: nSVM: Remove redundant cases in nested_svm_intercept()
      KVM: nSVM: Propagate SVM_EXIT_CR0_SEL_WRITE correctly for LMSW emulation
      KVM: nSVM: Avoid incorrect injection of SVM_EXIT_CR0_SEL_WRITE
      KVM: x86: Document a virtualization gap for GIF on AMD CPUs
      KVM: selftests: Extend vmx_close_while_nested_test to cover SVM
      KVM: selftests: Extend vmx_nested_tsc_scaling_test to cover SVM
      KVM: selftests: Move nested invalid CR3 check to its own test
      KVM: selftests: Extend nested_invalid_cr3_test to cover SVM
      KVM: selftests: Extend vmx_tsc_adjust_test to cover SVM
      KVM: selftests: Stop hardcoding PAGE_SIZE in x86 selftests
      KVM: selftests: Remove the unused argument to prepare_eptp()
      KVM: selftests: Stop using __virt_pg_map() directly in tests
      KVM: selftests: Make sure vm->vpages_mapped is always up-to-date

Yue Haibing (1):
      KVM: x86: Remove unused declaration kvm_mmu_may_ignore_guest_pat()

fuqiang wang (2):
      KVM: x86: Explicitly set new periodic hrtimer expiration in apic_timer_fn()
      KVM: x86: Fix VM hard lockup after prolonged inactivity with periodic HV timer

 Documentation/virt/kvm/api.rst                     |  70 +-
 Documentation/virt/kvm/x86/errata.rst              |   9 +-
 arch/arm64/include/asm/kvm_arm.h                   |   1 +
 arch/arm64/include/asm/kvm_asm.h                   |   8 +-
 arch/arm64/include/asm/kvm_host.h                  |   3 +
 arch/arm64/include/asm/kvm_hyp.h                   |   3 +-
 arch/arm64/include/asm/kvm_nested.h                |  40 +-
 arch/arm64/include/asm/kvm_pgtable.h               |  49 +-
 arch/arm64/include/asm/kvm_pkvm.h                  |   4 +-
 arch/arm64/include/asm/virt.h                      |   7 +-
 arch/arm64/kernel/cpufeature.c                     |  59 ++
 arch/arm64/kernel/hyp-stub.S                       |   5 +
 arch/arm64/kernel/image-vars.h                     |   1 +
 arch/arm64/kvm/arm.c                               |  20 +-
 arch/arm64/kvm/at.c                                | 196 ++++-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c                 |   7 +-
 arch/arm64/kvm/hyp/nvhe/pkvm.c                     |   3 +
 arch/arm64/kvm/hyp/nvhe/sys_regs.c                 |   5 +
 arch/arm64/kvm/hyp/pgtable.c                       | 128 +++-
 arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c           |   4 +
 arch/arm64/kvm/hyp/vgic-v3-sr.c                    |  96 ++-
 arch/arm64/kvm/mmu.c                               | 132 +++-
 arch/arm64/kvm/nested.c                            | 123 +++-
 arch/arm64/kvm/pkvm.c                              |  11 +-
 arch/arm64/kvm/ptdump.c                            |  35 +-
 arch/arm64/kvm/sys_regs.c                          |  28 +-
 arch/arm64/kvm/vgic/vgic-init.c                    |   9 +-
 arch/arm64/kvm/vgic/vgic-mmio-v2.c                 |  24 +
 arch/arm64/kvm/vgic/vgic-mmio.h                    |   1 +
 arch/arm64/kvm/vgic/vgic-v2.c                      | 295 ++++++--
 arch/arm64/kvm/vgic/vgic-v3-nested.c               | 106 +--
 arch/arm64/kvm/vgic/vgic-v3.c                      | 430 ++++++++---
 arch/arm64/kvm/vgic/vgic-v4.c                      |   5 +-
 arch/arm64/kvm/vgic/vgic.c                         | 304 +++++---
 arch/arm64/kvm/vgic/vgic.h                         |  43 +-
 arch/arm64/tools/cpucaps                           |   2 +
 arch/loongarch/include/asm/kvm_eiointc.h           |  55 +-
 arch/loongarch/include/asm/kvm_host.h              |   8 +
 arch/loongarch/include/asm/kvm_vcpu.h              |   1 +
 arch/loongarch/include/asm/loongarch.h             |   2 +
 arch/loongarch/include/uapi/asm/kvm.h              |   1 +
 arch/loongarch/kvm/Kconfig                         |   1 -
 arch/loongarch/kvm/intc/eiointc.c                  |  80 +-
 arch/loongarch/kvm/interrupt.c                     |  15 +-
 arch/loongarch/kvm/vcpu.c                          |  23 +-
 arch/loongarch/kvm/vm.c                            |  44 +-
 arch/mips/kvm/Kconfig                              |   1 -
 arch/mips/kvm/mips.c                               |   4 +-
 arch/powerpc/kvm/Kconfig                           |   1 -
 arch/powerpc/kvm/powerpc.c                         |   4 +-
 arch/riscv/include/asm/kvm_host.h                  |   6 +
 arch/riscv/include/asm/kvm_tlb.h                   |   1 +
 arch/riscv/include/asm/kvm_vcpu_sbi.h              |   5 +-
 arch/riscv/include/asm/kvm_vmid.h                  |   1 -
 arch/riscv/include/uapi/asm/kvm.h                  |   3 +
 arch/riscv/kvm/Kconfig                             |   1 -
 arch/riscv/kvm/Makefile                            |   1 +
 arch/riscv/kvm/aia_imsic.c                         |   2 +-
 arch/riscv/kvm/main.c                              |  14 +
 arch/riscv/kvm/mmu.c                               |   5 +-
 arch/riscv/kvm/tlb.c                               |  30 +
 arch/riscv/kvm/vcpu.c                              |   6 +-
 arch/riscv/kvm/vcpu_insn.c                         |  22 +
 arch/riscv/kvm/vcpu_sbi.c                          |  10 +-
 arch/riscv/kvm/vcpu_sbi_base.c                     |  28 +-
 arch/riscv/kvm/vcpu_sbi_forward.c                  |  34 +
 arch/riscv/kvm/vcpu_sbi_replace.c                  |  32 -
 arch/riscv/kvm/vcpu_sbi_system.c                   |   4 +-
 arch/riscv/kvm/vcpu_sbi_v01.c                      |   3 +-
 arch/riscv/kvm/vmid.c                              |  23 -
 arch/s390/include/asm/kvm_host.h                   |   8 +-
 arch/s390/include/asm/stacktrace.h                 |   1 +
 arch/s390/kernel/asm-offsets.c                     |   1 +
 arch/s390/kernel/entry.S                           |   2 +
 arch/s390/kvm/Kconfig                              |   2 +-
 arch/s390/kvm/gaccess.c                            |  27 +-
 arch/s390/kvm/intercept.c                          |   3 +
 arch/s390/kvm/interrupt.c                          |  80 +-
 arch/s390/kvm/kvm-s390.c                           | 233 ++----
 arch/s390/kvm/kvm-s390.h                           |   9 +-
 arch/s390/kvm/vsie.c                               |  20 +-
 arch/x86/include/asm/cpufeatures.h                 |   7 +
 arch/x86/include/asm/hardirq.h                     |   4 +-
 arch/x86/include/asm/kvm-x86-ops.h                 |   1 +
 arch/x86/include/asm/kvm_host.h                    |  23 +-
 arch/x86/include/asm/nospec-branch.h               |  30 +-
 arch/x86/include/asm/svm.h                         |   5 +-
 arch/x86/include/uapi/asm/kvm.h                    |   1 +
 arch/x86/kernel/cpu/bugs.c                         |  22 +-
 arch/x86/kernel/cpu/scattered.c                    |   1 +
 arch/x86/kvm/cpuid.c                               |   1 +
 arch/x86/kvm/emulate.c                             | 319 +++++---
 arch/x86/kvm/fpu.h                                 |  66 ++
 arch/x86/kvm/hyperv.c                              |   2 +-
 arch/x86/kvm/kvm_emulate.h                         |  20 +-
 arch/x86/kvm/lapic.c                               |  44 +-
 arch/x86/kvm/mmu.h                                 |   5 +-
 arch/x86/kvm/mmu/mmu.c                             |  94 ++-
 arch/x86/kvm/mmu/mmu_internal.h                    |  10 -
 arch/x86/kvm/mmu/paging_tmpl.h                     |   2 +-
 arch/x86/kvm/mmu/spte.c                            |   2 +-
 arch/x86/kvm/mmu/spte.h                            |  10 +
 arch/x86/kvm/mmu/tdp_mmu.c                         |  50 +-
 arch/x86/kvm/svm/avic.c                            |  86 ++-
 arch/x86/kvm/svm/nested.c                          |  12 +-
 arch/x86/kvm/svm/sev.c                             |  45 +-
 arch/x86/kvm/svm/svm.c                             | 113 +--
 arch/x86/kvm/svm/svm.h                             |   4 +-
 arch/x86/kvm/svm/vmenter.S                         |  53 +-
 arch/x86/kvm/vmx/main.c                            |   9 +
 arch/x86/kvm/vmx/nested.c                          | 173 ++---
 arch/x86/kvm/vmx/run_flags.h                       |  10 +-
 arch/x86/kvm/vmx/tdx.c                             | 801 ++++++++++-----------
 arch/x86/kvm/vmx/tdx.h                             |   9 +-
 arch/x86/kvm/vmx/vmenter.S                         |  49 +-
 arch/x86/kvm/vmx/vmx.c                             | 323 +++++----
 arch/x86/kvm/vmx/vmx.h                             |   2 -
 arch/x86/kvm/vmx/x86_ops.h                         |   2 +-
 arch/x86/kvm/x86.c                                 | 285 ++++----
 arch/x86/kvm/x86.h                                 |  16 +-
 drivers/crypto/ccp/sev-dev.c                       |  37 +
 drivers/irqchip/irq-apple-aic.c                    |   7 +-
 drivers/irqchip/irq-gic.c                          |   3 +
 fs/btrfs/compression.c                             |   4 +-
 fs/btrfs/verity.c                                  |   2 +-
 fs/erofs/zdata.c                                   |   2 +-
 fs/f2fs/compress.c                                 |   2 +-
 include/kvm/arm_vgic.h                             |  29 +-
 include/linux/irqchip/arm-gic.h                    |   6 +
 include/linux/irqchip/arm-vgic-info.h              |   2 +
 include/linux/kvm_host.h                           |  14 +-
 include/linux/pagemap.h                            |  18 +-
 include/linux/psp-sev.h                            |  37 +
 include/uapi/linux/kvm.h                           |  11 +
 include/uapi/linux/magic.h                         |   1 +
 mm/filemap.c                                       |  23 +-
 mm/mempolicy.c                                     |   6 +
 mm/readahead.c                                     |   2 +-
 tools/arch/arm64/include/asm/esr.h                 |   2 +
 tools/testing/selftests/kvm/Makefile               |   2 +-
 tools/testing/selftests/kvm/Makefile.kvm           |  12 +-
 tools/testing/selftests/kvm/arm64/at.c             | 166 +++++
 tools/testing/selftests/kvm/arm64/sea_to_user.c    | 331 +++++++++
 tools/testing/selftests/kvm/arm64/vgic_irq.c       | 287 +++++++-
 .../testing/selftests/kvm/arm64/vgic_lpi_stress.c  |   4 +
 tools/testing/selftests/kvm/guest_memfd_test.c     |  98 +++
 tools/testing/selftests/kvm/include/arm64/gic.h    |   1 +
 .../selftests/kvm/include/arm64/gic_v3_its.h       |   1 +
 tools/testing/selftests/kvm/include/kvm_syscalls.h |  81 +++
 tools/testing/selftests/kvm/include/kvm_util.h     |  45 +-
 .../selftests/kvm/include/loongarch/arch_timer.h   |  85 +++
 .../selftests/kvm/include/loongarch/processor.h    |  81 ++-
 tools/testing/selftests/kvm/include/numaif.h       | 110 +--
 .../testing/selftests/kvm/include/x86/processor.h  |   2 +-
 tools/testing/selftests/kvm/include/x86/vmx.h      |   3 +-
 .../testing/selftests/kvm/kvm_binary_stats_test.c  |   4 +-
 tools/testing/selftests/kvm/lib/arm64/gic.c        |   6 +
 .../testing/selftests/kvm/lib/arm64/gic_private.h  |   1 +
 tools/testing/selftests/kvm/lib/arm64/gic_v3.c     |  22 +
 tools/testing/selftests/kvm/lib/arm64/gic_v3_its.c |  10 +
 tools/testing/selftests/kvm/lib/arm64/processor.c  |   2 +-
 tools/testing/selftests/kvm/lib/kvm_util.c         | 145 ++--
 .../selftests/kvm/lib/loongarch/exception.S        |   6 +
 .../selftests/kvm/lib/loongarch/processor.c        |  47 +-
 tools/testing/selftests/kvm/lib/x86/memstress.c    |   2 +-
 tools/testing/selftests/kvm/lib/x86/processor.c    |  80 +-
 tools/testing/selftests/kvm/lib/x86/vmx.c          |   9 +-
 tools/testing/selftests/kvm/loongarch/arch_timer.c | 200 +++++
 tools/testing/selftests/kvm/mmu_stress_test.c      |  10 +-
 .../testing/selftests/kvm/pre_fault_memory_test.c  |  32 +-
 tools/testing/selftests/kvm/riscv/get-reg-list.c   |   4 +
 tools/testing/selftests/kvm/s390/user_operexec.c   | 140 ++++
 tools/testing/selftests/kvm/x86/hyperv_features.c  |   2 +-
 tools/testing/selftests/kvm/x86/hyperv_ipi.c       |  18 +-
 tools/testing/selftests/kvm/x86/hyperv_tlb_flush.c |   2 +-
 ...while_nested_test.c => nested_close_kvm_test.c} |  42 +-
 .../selftests/kvm/x86/nested_invalid_cr3_test.c    | 116 +++
 ..._tsc_adjust_test.c => nested_tsc_adjust_test.c} |  73 +-
 ...sc_scaling_test.c => nested_tsc_scaling_test.c} |  48 +-
 .../kvm/x86/private_mem_conversions_test.c         |   9 +-
 tools/testing/selftests/kvm/x86/sev_smoke_test.c   |   2 +-
 tools/testing/selftests/kvm/x86/state_test.c       |   2 +-
 .../testing/selftests/kvm/x86/userspace_io_test.c  |   2 +-
 .../testing/selftests/kvm/x86/vmx_dirty_log_test.c |  12 +-
 .../selftests/kvm/x86/vmx_nested_la57_state_test.c | 132 ++++
 tools/testing/selftests/kvm/x86/xapic_ipi_test.c   |   5 +-
 virt/kvm/Kconfig                                   |   3 -
 virt/kvm/eventfd.c                                 |   2 +-
 virt/kvm/guest_memfd.c                             | 373 +++++++---
 virt/kvm/kvm_main.c                                |  15 +-
 virt/kvm/kvm_mm.h                                  |   9 +-
 191 files changed, 6303 insertions(+), 2635 deletions(-)
 create mode 100644 arch/riscv/kvm/vcpu_sbi_forward.c
 create mode 100644 tools/testing/selftests/kvm/arm64/at.c
 create mode 100644 tools/testing/selftests/kvm/arm64/sea_to_user.c
 create mode 100644 tools/testing/selftests/kvm/include/kvm_syscalls.h
 create mode 100644 tools/testing/selftests/kvm/include/loongarch/arch_timer.h
 create mode 100644 tools/testing/selftests/kvm/loongarch/arch_timer.c
 create mode 100644 tools/testing/selftests/kvm/s390/user_operexec.c
 rename tools/testing/selftests/kvm/x86/{vmx_close_while_nested_test.c => nested_close_kvm_test.c} (64%)
 create mode 100644 tools/testing/selftests/kvm/x86/nested_invalid_cr3_test.c
 rename tools/testing/selftests/kvm/x86/{vmx_tsc_adjust_test.c => nested_tsc_adjust_test.c} (61%)
 rename tools/testing/selftests/kvm/x86/{vmx_nested_tsc_scaling_test.c => nested_tsc_scaling_test.c} (83%)
 create mode 100644 tools/testing/selftests/kvm/x86/vmx_nested_la57_state_test.c


