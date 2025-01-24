Return-Path: <kvm+bounces-36552-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E7EDA1BAAA
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 17:38:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6E7AB16DE4D
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 16:38:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F8A81990C8;
	Fri, 24 Jan 2025 16:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fV8tUTlr"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2E1915A84E
	for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 16:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737736718; cv=none; b=WpawbMppAdlgRxdCtJyQqbeKh2NivwpbWCapebHVBdzzPJrfRB4rz13Vjgg013Evd8wcAPuMYesl/7zNN/SJIaAnIohsSupCS72PuE4IMkw6+IqurFWnfkFYg514LUH2fhIBV+1pVoKKAbxPYYsmtFvPCBWcMrnoCcGROj/r5/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737736718; c=relaxed/simple;
	bh=Z4SsLTqJ+8vK34LGyOAPCoa+Drac0XGtk91LmMo0jys=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uUea+MijtpqdQf1AW1znEdMbzytnvPRIoh1nIkkwitWZWu0nj8Zko8RGr48hMrC1D1IB024n6+Cg5rwwiedpvG7or/oyzUjFDxdoIA83wIoblaLls5OJD2KzZYjPTQEHcUIGERVQrg+blg61sN3pOTerKZAAnGbWjAB5SxycLxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fV8tUTlr; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737736714;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=DHJrlJwHvpO/uOe7u2J07ot3w7HAQkAox5jZRt8r3cw=;
	b=fV8tUTlr60xPCUr9pBROHKMrV9dT+yz8b2jdU6sovS8AWN1MOJkPeSCd3oVe79Mxh2Ns3x
	5+c5a3R4NHpuyhLAJ6gdIGh8fRXEV/YREjj2f31pPguX3ByDkUZUPUkh6Li5xHqb03yhG5
	rS7inb2kGc/mNPxJzzBJw2Gh5hNDwUg=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-330-NY6qiUVbPSmSn0bnvDGcyg-1; Fri,
 24 Jan 2025 11:38:32 -0500
X-MC-Unique: NY6qiUVbPSmSn0bnvDGcyg-1
X-Mimecast-MFC-AGG-ID: NY6qiUVbPSmSn0bnvDGcyg
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 59105197702F;
	Fri, 24 Jan 2025 16:37:43 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7817630001BE;
	Fri, 24 Jan 2025 16:37:42 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [GIT PULL] KVM changes for Linux 6.14
Date: Fri, 24 Jan 2025 11:37:41 -0500
Message-ID: <20250124163741.101568-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Linus,

The following changes since commit 5bc55a333a2f7316b58edc7573e8e893f7acb532:

  Linux 6.13-rc7 (2025-01-12 14:37:56 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 931656b9e2ff7029aee0b36e17780621948a6ac1:

  kvm: defer huge page recovery vhost task to later (2025-01-24 10:53:56 -0500)

There is a conflict in arch/x86/kvm/cpuid.c that is nasty to describe
because the affected area has been completely rewritten, but is really a
one liner.  The change to be reproduced is commit 716f86b523d8 ("KVM:
x86: Advertise SRSO_USER_KERNEL_NO to userspace"):

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index ae0b438a2c99..f7e222953cab 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -821,7 +821,7 @@ void kvm_set_cpu_caps(void)
 	kvm_cpu_cap_mask(CPUID_8000_0021_EAX,
 		F(NO_NESTED_DATA_BP) | F(LFENCE_RDTSC) | 0 /* SmmPgCfgLock */ |
 		F(NULL_SEL_CLR_BASE) | F(AUTOIBRS) | 0 /* PrefetchCtlMsr */ |
-		F(WRMSR_XX_BASE_NS)
+		F(WRMSR_XX_BASE_NS) | F(SRSO_USER_KERNEL_NO)
 	);
 
 	kvm_cpu_cap_check_and_set(X86_FEATURE_SBPB);

but you can throw away the <<<< ... ==== part completely, and apply the
same change on top of the new implementation:

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index edef30359c19..9f9a29be3beb 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1177,6 +1177,7 @@ void kvm_set_cpu_caps(void)
 		EMULATED_F(NO_SMM_CTL_MSR),
 		/* PrefetchCtlMsr */
 		F(WRMSR_XX_BASE_NS),
+		F(SRSO_USER_KERNEL_NO),
 		SYNTHESIZED_F(SBPB),
 		SYNTHESIZED_F(IBPB_BRTYPE),
 		SYNTHESIZED_F(SRSO_NO),

I cannot blame Boris at all for including the change to cpuid.c, since
this file has never been much of a source of conflicts (and is not
expected to become one in the future).

Thanks,

Paolo

----------------------------------------------------------------
Loongarch:

* Clear LLBCTL if secondary mmu mapping changes.

* Add hypercall service support for usermode VMM.

x86:

* Add a comment to kvm_mmu_do_page_fault() to explain why KVM performs a
  direct call to kvm_tdp_page_fault() when RETPOLINE is enabled.

* Ensure that all SEV code is compiled out when disabled in Kconfig, even
  if building with less brilliant compilers.

* Remove a redundant TLB flush on AMD processors when guest CR4.PGE changes.

* Use str_enabled_disabled() to replace open coded strings.

* Drop kvm_x86_ops.hwapic_irr_update() as KVM updates hardware's APICv cache
  prior to every VM-Enter.

* Overhaul KVM's CPUID feature infrastructure to track all vCPU capabilities
  instead of just those where KVM needs to manage state and/or explicitly
  enable the feature in hardware.  Along the way, refactor the code to make
  it easier to add features, and to make it more self-documenting how KVM
  is handling each feature.

* Rework KVM's handling of VM-Exits during event vectoring; this plugs holes
  where KVM unintentionally puts the vCPU into infinite loops in some scenarios
  (e.g. if emulation is triggered by the exit), and brings parity between VMX
  and SVM.

* Add pending request and interrupt injection information to the kvm_exit and
  kvm_entry tracepoints respectively.

* Fix a relatively benign flaw where KVM would end up redoing RDPKRU when
  loading guest/host PKRU, due to a refactoring of the kernel helpers that
  didn't account for KVM's pre-checking of the need to do WRPKRU.

* Make the completion of hypercalls go through the complete_hypercall
  function pointer argument, no matter if the hypercall exits to
  userspace or not.  Previously, the code assumed that KVM_HC_MAP_GPA_RANGE
  specifically went to userspace, and all the others did not; the new code
  need not special case KVM_HC_MAP_GPA_RANGE and in fact does not care at
  all whether there was an exit to userspace or not.

* As part of enabling TDX virtual machines, support support separation of
  private/shared EPT into separate roots.  When TDX will be enabled, operations
  on private pages will need to go through the privileged TDX Module via SEAMCALLs;
  as a result, they are limited and relatively slow compared to reading a PTE.
  The patches included in 6.14 allow KVM to keep a mirror of the private EPT in
  host memory, and define entries in kvm_x86_ops to operate on external page
  tables such as the TDX private EPT.

* The recently introduced conversion of the NX-page reclamation kthread to
  vhost_task moved the task under the main process.  The task is created as
  soon as KVM_CREATE_VM was invoked and this, of course, broke userspace that
  didn't expect to see any child task of the VM process until it started
  creating its own userspace threads.  In particular crosvm refuses to fork()
  if procfs shows any child task, so unbreak it by creating the task lazily.
  This is arguably a userspace bug, as there can be other kinds of legitimate
  worker tasks and they wouldn't impede fork(); but it's not like userspace
  has a way to distinguish kernel worker tasks right now.  Should they show
  as "Kthread: 1" in proc/.../status?

x86 - Intel:

* Fix a bug where KVM updates hardware's APICv cache of the highest ISR bit
  while L2 is active, while ultimately results in a hardware-accelerated L1
  EOI effectively being lost.

* Honor event priority when emulating Posted Interrupt delivery during nested
  VM-Enter by queueing KVM_REQ_EVENT instead of immediately handling the
  interrupt.

* Rework KVM's processing of the Page-Modification Logging buffer to reap
  entries in the same order they were created, i.e. to mark gfns dirty in the
  same order that hardware marked the page/PTE dirty.

* Misc cleanups.

Generic:

* Cleanup and harden kvm_set_memory_region(); add proper lockdep assertions when
  setting memory regions and add a dedicated API for setting KVM-internal
  memory regions.  The API can then explicitly disallow all flags for
  KVM-internal memory regions.

* Explicitly verify the target vCPU is online in kvm_get_vcpu() to fix a bug
  where KVM would return a pointer to a vCPU prior to it being fully online,
  and give kvm_for_each_vcpu() similar treatment to fix a similar flaw.

* Wait for a vCPU to come online prior to executing a vCPU ioctl, to fix a
  bug where userspace could coerce KVM into handling the ioctl on a vCPU that
  isn't yet onlined.

* Gracefully handle xarray insertion failures; even though such failures are
  impossible in practice after xa_reserve(), reserving an entry is always followed
  by xa_store() which does not know (or differentiate) whether there was an
  xa_reserve() before or not.

RISC-V:

* Zabha, Svvptc, and Ziccrse extension support for guests.  None of them
  require anything in KVM except for detecting them and marking them
  as supported; Zabha adds byte and halfword atomic operations, while the
  others are markers for specific operation of the TLB and of LL/SC
  instructions respectively.

* Virtualize SBI system suspend extension for Guest/VM

* Support firmware counters which can be used by the guests to collect
  statistics about traps that occur in the host.

Selftests:

* Rework vcpu_get_reg() to return a value instead of using an out-param, and
  update all affected arch code accordingly.

* Convert the max_guest_memory_test into a more generic mmu_stress_test.
  The basic gist of the "conversion" is to have the test do mprotect() on
  guest memory while vCPUs are accessing said memory, e.g. to verify KVM
  and mmu_notifiers are working as intended.

* Play nice with treewrite builds of unsupported architectures, e.g. arm
  (32-bit), as KVM selftests' Makefile doesn't do anything to ensure the
  target architecture is actually one KVM selftests supports.

* Use the kernel's $(ARCH) definition instead of the target triple for arch
  specific directories, e.g. arm64 instead of aarch64, mainly so as not to
  be different from the rest of the kernel.

* Ensure that format strings for logging statements are checked by the
  compiler even when the logging statement itself is disabled.

* Attempt to whack the last LLC references/misses mole in the Intel PMU
  counters test by adding a data load and doing CLFLUSH{OPT} on the data
  instead of the code being executed.  It seems that modern Intel CPUs
  have learned new code prefetching tricks that bypass the PMU counters.

* Fix a flaw in the Intel PMU counters test where it asserts that events
  are counting correctly without actually knowing what the events count
  given the underlying hardware; this can happen if Intel reuses a
  formerly microarchitecture-specific event encoding as an architectural
  event, as was the case for Top-Down Slots.

----------------------------------------------------------------
Adrian Hunter (1):
      KVM: VMX: Allow toggling bits in MSR_IA32_RTIT_CTL when enable bit is cleared

Andrew Jones (2):
      RISC-V: KVM: Add SBI system suspend support
      KVM: riscv: selftests: Add SBI SUSP to get-reg-list test

Atish Patra (2):
      RISC-V: KVM: Update firmware counters for various events
      RISC-V: KVM: Add new exit statstics for redirected traps

Bibo Mao (2):
      LoongArch: KVM: Clear LLBCTL if secondary mmu mapping is changed
      LoongArch: KVM: Add hypercall service support for usermode VMM

Binbin Wu (1):
      KVM: x86: Add a helper to check for user interception of KVM hypercalls

Chao Gao (2):
      KVM: nVMX: Defer SVI update to vmcs01 on EOI when L2 is active w/o VID
      KVM: x86: Remove hwapic_irr_update() from kvm_x86_ops

Costas Argyris (1):
      KVM: VMX: Reinstate __exit attribute for vmx_exit()

Gao Shiyuan (1):
      KVM: VMX: Fix comment of handle_vmx_instruction()

Isaku Yamahata (12):
      KVM: Add member to struct kvm_gfn_range to indicate private/shared
      KVM: x86/mmu: Add an external pointer to struct kvm_mmu_page
      KVM: x86/mmu: Add an is_mirror member for union kvm_mmu_page_role
      KVM: x86/tdp_mmu: Take struct kvm in iter loops
      KVM: x86/mmu: Support GFN direct bits
      KVM: x86/tdp_mmu: Extract root invalid check from tdx_mmu_next_root()
      KVM: x86/tdp_mmu: Introduce KVM MMU root types to specify page table type
      KVM: x86/tdp_mmu: Take root in tdp_mmu_for_each_pte()
      KVM: x86/tdp_mmu: Support mirror root for TDP MMU
      KVM: x86/tdp_mmu: Propagate building mirror page tables
      KVM: x86/tdp_mmu: Propagate tearing down mirror page tables
      KVM: x86/tdp_mmu: Take root types for kvm_tdp_mmu_invalidate_all_roots()

Ivan Orlov (7):
      KVM: x86: Add function for vectoring error generation
      KVM: x86: Add emulation status for unhandleable exception vectoring
      KVM: x86: Try to unprotect and retry on unhandleable emulation failure
      KVM: VMX: Handle event vectoring error in check_emulate_instruction()
      KVM: SVM: Handle event vectoring error in check_emulate_instruction()
      KVM: selftests: Add and use a helper function for x86's LIDT
      KVM: selftests: Add test case for MMIO during vectoring on x86

Juergen Gross (1):
      KVM/x86: add comment to kvm_mmu_do_page_fault()

Keith Busch (1):
      kvm: defer huge page recovery vhost task to later

Liam Ni (1):
      KVM: x86: Use LVT_TIMER instead of an open coded literal

Maxim Levitsky (4):
      KVM: x86: Add interrupt injection information to the kvm_entry tracepoint
      KVM: x86: Add information about pending requests to kvm_exit tracepoint
      KVM: VMX: refactor PML terminology
      KVM: VMX: read the PML log in the same order as it was written

Paolo Bonzini (15):
      Merge tag 'kvm-selftests-treewide-6.14' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-fixes-6.13-rcN' of https://github.com/kvm-x86/linux into HEAD
      KVM: x86: clear vcpu->run->hypercall.ret before exiting for KVM_EXIT_HYPERCALL
      KVM: x86: Refactor __kvm_emulate_hypercall() into a macro
      KVM: x86/tdp_mmu: Propagate attr_filter to MMU notifier callbacks
      Merge tag 'loongarch-kvm-6.14' of git://git.kernel.org/pub/scm/linux/kernel/git/chenhuacai/linux-loongson into HEAD
      Merge tag 'kvm-memslots-6.14' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-vcpu_array-6.14' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-mmu-6.14' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-svm-6.14' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-vmx-6.14' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-misc-6.14' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-riscv-6.14-1' of https://github.com/kvm-riscv/linux into HEAD
      Merge branch 'kvm-userspace-hypercall' into HEAD
      Merge branch 'kvm-mirror-page-tables' into HEAD

Quan Zhou (5):
      RISC-V: KVM: Allow Svvptc extension for Guest/VM
      RISC-V: KVM: Allow Zabha extension for Guest/VM
      RISC-V: KVM: Allow Ziccrse extension for Guest/VM
      KVM: riscv: selftests: Add Svvptc/Zabha/Ziccrse exts to get-reg-list test
      RISC-V: KVM: Redirect instruction access fault trap to guest

Rick Edgecombe (5):
      KVM: x86/mmu: Zap invalid roots with mmu_lock holding for write at uninit
      KVM: x86: Add a VM type define for TDX
      KVM: x86/mmu: Make kvm_tdp_mmu_alloc_root() return void
      KVM: x86/tdp_mmu: Don't zap valid mirror roots in kvm_tdp_mmu_zap_all()
      KVM: x86/mmu: Prevent aliased memslot GFNs

Sean Christopherson (96):
      KVM: Explicitly verify target vCPU is online in kvm_get_vcpu()
      KVM: Verify there's at least one online vCPU when iterating over all vCPUs
      KVM: Grab vcpu->mutex across installing the vCPU's fd and bumping online_vcpus
      Revert "KVM: Fix vcpu_array[0] races"
      KVM: Don't BUG() the kernel if xa_insert() fails with -EBUSY
      KVM: Drop hack that "manually" informs lockdep of kvm->lock vs. vcpu->mutex
      KVM: x86: Plumb in the vCPU to kvm_x86_ops.hwapic_isr_update()
      KVM: SVM: Macrofy SEV=n versions of sev_xxx_guest()
      KVM: SVM: Remove redundant TLB flush on guest CR4.PGE change
      KVM: Move KVM_REG_SIZE() definition to common uAPI header
      KVM: selftests: Return a value from vcpu_get_reg() instead of using an out-param
      KVM: selftests: Assert that vcpu_{g,s}et_reg() won't truncate
      KVM: selftests: Check for a potential unhandled exception iff KVM_RUN succeeded
      KVM: selftests: Rename max_guest_memory_test to mmu_stress_test
      KVM: selftests: Only muck with SREGS on x86 in mmu_stress_test
      KVM: selftests: Compute number of extra pages needed in mmu_stress_test
      KVM: sefltests: Explicitly include ucall_common.h in mmu_stress_test.c
      KVM: selftests: Enable mmu_stress_test on arm64
      KVM: selftests: Use vcpu_arch_put_guest() in mmu_stress_test
      KVM: selftests: Precisely limit the number of guest loops in mmu_stress_test
      KVM: selftests: Add a read-only mprotect() phase to mmu_stress_test
      KVM: selftests: Verify KVM correctly handles mprotect(PROT_READ)
      KVM: selftests: Provide empty 'all' and 'clean' targets for unsupported ARCHs
      KVM: selftests: Use canonical $(ARCH) paths for KVM selftests directories
      KVM: selftests: Override ARCH for x86_64 instead of using ARCH_DIR
      KVM: x86: Use feature_bit() to clear CONSTANT_TSC when emulating CPUID
      KVM: x86: Limit use of F() and SF() to kvm_cpu_cap_{mask,init_kvm_defined}()
      KVM: x86: Do all post-set CPUID processing during vCPU creation
      KVM: x86: Explicitly do runtime CPUID updates "after" initial setup
      KVM: x86: Account for KVM-reserved CR4 bits when passing through CR4 on VMX
      KVM: selftests: Update x86's set_sregs_test to match KVM's CPUID enforcement
      KVM: selftests: Assert that vcpu->cpuid is non-NULL when getting CPUID entries
      KVM: selftests: Refresh vCPU CPUID cache in __vcpu_get_cpuid_entry()
      KVM: selftests: Verify KVM stuffs runtime CPUID OS bits on CR4 writes
      KVM: x86: Move __kvm_is_valid_cr4() definition to x86.h
      KVM: x86/pmu: Drop now-redundant refresh() during init()
      KVM: x86: Drop now-redundant MAXPHYADDR and GPA rsvd bits from vCPU creation
      KVM: x86: Disallow KVM_CAP_X86_DISABLE_EXITS after vCPU creation
      KVM: x86: Reject disabling of MWAIT/HLT interception when not allowed
      KVM: x86: Drop the now unused KVM_X86_DISABLE_VALID_EXITS
      KVM: selftests: Fix a bad TEST_REQUIRE() in x86's KVM PV test
      KVM: selftests: Update x86's KVM PV test to match KVM's disabling exits behavior
      KVM: x86: Zero out PV features cache when the CPUID leaf is not present
      KVM: x86: Don't update PV features caches when enabling enforcement capability
      KVM: x86: Do reverse CPUID sanity checks in __feature_leaf()
      KVM: x86: Account for max supported CPUID leaf when getting raw host CPUID
      KVM: x86: Unpack F() CPUID feature flag macros to one flag per line of code
      KVM: x86: Rename kvm_cpu_cap_mask() to kvm_cpu_cap_init()
      KVM: x86: Add a macro to init CPUID features that are 64-bit only
      KVM: x86: Add a macro to precisely handle aliased 0x1.EDX CPUID features
      KVM: x86: Handle kernel- and KVM-defined CPUID words in a single helper
      KVM: x86: #undef SPEC_CTRL_SSBD in cpuid.c to avoid macro collisions
      KVM: x86: Harden CPU capabilities processing against out-of-scope features
      KVM: x86: Add a macro to init CPUID features that ignore host kernel support
      KVM: x86: Add a macro to init CPUID features that KVM emulates in software
      KVM: x86: Swap incoming guest CPUID into vCPU before massaging in KVM_SET_CPUID2
      KVM: x86: Clear PV_UNHALT for !HLT-exiting only when userspace sets CPUID
      KVM: x86: Remove unnecessary caching of KVM's PV CPUID base
      KVM: x86: Always operate on kvm_vcpu data in cpuid_entry2_find()
      KVM: x86: Move kvm_find_cpuid_entry{,_index}() up near cpuid_entry2_find()
      KVM: x86: Remove all direct usage of cpuid_entry2_find()
      KVM: x86: Advertise TSC_DEADLINE_TIMER in KVM_GET_SUPPORTED_CPUID
      KVM: x86: Advertise HYPERVISOR in KVM_GET_SUPPORTED_CPUID
      KVM: x86: Rename "governed features" helpers to use "guest_cpu_cap"
      KVM: x86: Replace guts of "governed" features with comprehensive cpu_caps
      KVM: x86: Initialize guest cpu_caps based on guest CPUID
      KVM: x86: Extract code for generating per-entry emulated CPUID information
      KVM: x86: Treat MONTIOR/MWAIT as a "partially emulated" feature
      KVM: x86: Initialize guest cpu_caps based on KVM support
      KVM: x86: Avoid double CPUID lookup when updating MWAIT at runtime
      KVM: x86: Drop unnecessary check that cpuid_entry2_find() returns right leaf
      KVM: x86: Update OS{XSAVE,PKE} bits in guest CPUID irrespective of host support
      KVM: x86: Update guest cpu_caps at runtime for dynamic CPUID-based features
      KVM: x86: Shuffle code to prepare for dropping guest_cpuid_has()
      KVM: x86: Replace (almost) all guest CPUID feature queries with cpu_caps
      KVM: x86: Drop superfluous host XSAVE check when adjusting guest XSAVES caps
      KVM: x86: Add a macro for features that are synthesized into boot_cpu_data
      KVM: x86: Pull CPUID capabilities from boot_cpu_data only as needed
      KVM: x86: Rename "SF" macro to "SCATTERED_F"
      KVM: x86: Explicitly track feature flags that require vendor enabling
      KVM: x86: Explicitly track feature flags that are enabled at runtime
      KVM: x86: Use only local variables (no bitmask) to init kvm_cpu_caps
      KVM: nVMX: Explicitly update vPPR on successful nested VM-Enter
      KVM: nVMX: Check for pending INIT/SIPI after entering non-root mode
      KVM: nVMX: Drop manual vmcs01.GUEST_INTERRUPT_STATUS.RVI check at VM-Enter
      KVM: nVMX: Use vmcs01's controls shadow to check for IRQ/NMI windows at VM-Enter
      KVM: nVMX: Honor event priority when emulating PI delivery during VM-Enter
      KVM: x86: Move "emulate hypercall" function declarations to x86.h
      KVM: x86: Bump hypercall stat prior to fully completing hypercall
      KVM: x86: Always complete hypercall via function callback
      KVM: x86: Avoid double RDPKRU when loading host/guest PKRU
      KVM: Open code kvm_set_memory_region() into its sole caller (ioctl() API)
      KVM: Assert slots_lock is held when setting memory regions
      KVM: Add a dedicated API for setting KVM-internal memslots
      KVM: x86: Drop double-underscores from __kvm_set_memory_region()
      KVM: Disallow all flags for KVM-internal memslots

Thorsten Blum (2):
      KVM: SVM: Use str_enabled_disabled() helper in sev_hardware_setup()
      KVM: SVM: Use str_enabled_disabled() helper in svm_hardware_setup()

Yan Zhao (2):
      KVM: guest_memfd: Remove RCU-protected attribute from slot->gmem.file
      KVM: x86/mmu: Return RET_PF* instead of 1 in kvm_mmu_page_fault()

 Documentation/virt/kvm/api.rst                     |  10 +-
 MAINTAINERS                                        |  12 +-
 arch/arm64/include/uapi/asm/kvm.h                  |   3 -
 arch/loongarch/include/asm/kvm_host.h              |   1 +
 arch/loongarch/include/asm/kvm_para.h              |   3 +
 arch/loongarch/include/asm/kvm_vcpu.h              |   1 +
 arch/loongarch/include/uapi/asm/kvm_para.h         |   1 +
 arch/loongarch/kvm/exit.c                          |  30 +
 arch/loongarch/kvm/main.c                          |  18 +
 arch/loongarch/kvm/vcpu.c                          |   7 +-
 arch/riscv/include/asm/kvm_host.h                  |   5 +
 arch/riscv/include/asm/kvm_vcpu_sbi.h              |   1 +
 arch/riscv/include/uapi/asm/kvm.h                  |   7 +-
 arch/riscv/kvm/Makefile                            |   1 +
 arch/riscv/kvm/vcpu.c                              |   7 +-
 arch/riscv/kvm/vcpu_exit.c                         |  37 +-
 arch/riscv/kvm/vcpu_onereg.c                       |   6 +
 arch/riscv/kvm/vcpu_sbi.c                          |   4 +
 arch/riscv/kvm/vcpu_sbi_system.c                   |  73 ++
 arch/x86/include/asm/kvm-x86-ops.h                 |   6 +-
 arch/x86/include/asm/kvm_host.h                    | 107 ++-
 arch/x86/include/uapi/asm/kvm.h                    |   1 +
 arch/x86/kvm/cpuid.c                               | 997 ++++++++++++++-------
 arch/x86/kvm/cpuid.h                               | 132 ++-
 arch/x86/kvm/governed_features.h                   |  22 -
 arch/x86/kvm/hyperv.c                              |   2 +-
 arch/x86/kvm/kvm_emulate.h                         |   2 +
 arch/x86/kvm/lapic.c                               |  31 +-
 arch/x86/kvm/lapic.h                               |   1 +
 arch/x86/kvm/mmu.h                                 |  33 +-
 arch/x86/kvm/mmu/mmu.c                             |  82 +-
 arch/x86/kvm/mmu/mmu_internal.h                    |  80 +-
 arch/x86/kvm/mmu/spte.h                            |   5 +
 arch/x86/kvm/mmu/tdp_iter.c                        |  10 +-
 arch/x86/kvm/mmu/tdp_iter.h                        |  21 +-
 arch/x86/kvm/mmu/tdp_mmu.c                         | 325 +++++--
 arch/x86/kvm/mmu/tdp_mmu.h                         |  51 +-
 arch/x86/kvm/pmu.c                                 |   1 -
 arch/x86/kvm/reverse_cpuid.h                       |  23 +-
 arch/x86/kvm/smm.c                                 |  10 +-
 arch/x86/kvm/svm/nested.c                          |  22 +-
 arch/x86/kvm/svm/pmu.c                             |   8 +-
 arch/x86/kvm/svm/sev.c                             |  43 +-
 arch/x86/kvm/svm/svm.c                             |  78 +-
 arch/x86/kvm/svm/svm.h                             |  23 +-
 arch/x86/kvm/trace.h                               |  17 +-
 arch/x86/kvm/vmx/hyperv.h                          |   2 +-
 arch/x86/kvm/vmx/main.c                            |   4 +-
 arch/x86/kvm/vmx/nested.c                          | 102 ++-
 arch/x86/kvm/vmx/pmu_intel.c                       |   4 +-
 arch/x86/kvm/vmx/sgx.c                             |  14 +-
 arch/x86/kvm/vmx/vmx.c                             | 176 ++--
 arch/x86/kvm/vmx/vmx.h                             |   6 +-
 arch/x86/kvm/vmx/x86_ops.h                         |   6 +-
 arch/x86/kvm/x86.c                                 | 261 +++---
 arch/x86/kvm/x86.h                                 |  34 +-
 include/linux/call_once.h                          |  45 +
 include/linux/kvm_host.h                           |  37 +-
 include/uapi/linux/kvm.h                           |   8 +-
 tools/testing/selftests/kvm/.gitignore             |   1 +
 tools/testing/selftests/kvm/Makefile               | 347 +------
 tools/testing/selftests/kvm/Makefile.kvm           | 330 +++++++
 .../kvm/{aarch64 => arm64}/aarch32_id_regs.c       |  10 +-
 .../selftests/kvm/{aarch64 => arm64}/arch_timer.c  |   0
 .../kvm/{aarch64 => arm64}/arch_timer_edge_cases.c |   0
 .../kvm/{aarch64 => arm64}/debug-exceptions.c      |   4 +-
 .../kvm/{aarch64 => arm64}/get-reg-list.c          |   0
 .../selftests/kvm/{aarch64 => arm64}/hypercalls.c  |   6 +-
 .../selftests/kvm/{aarch64 => arm64}/mmio_abort.c  |   0
 .../selftests/kvm/{aarch64 => arm64}/no-vgic-v3.c  |   2 +-
 .../kvm/{aarch64 => arm64}/page_fault_test.c       |   0
 .../selftests/kvm/{aarch64 => arm64}/psci_test.c   |   8 +-
 .../selftests/kvm/{aarch64 => arm64}/set_id_regs.c |  22 +-
 .../kvm/{aarch64 => arm64}/smccc_filter.c          |   0
 .../kvm/{aarch64 => arm64}/vcpu_width_config.c     |   0
 .../selftests/kvm/{aarch64 => arm64}/vgic_init.c   |   0
 .../selftests/kvm/{aarch64 => arm64}/vgic_irq.c    |   0
 .../kvm/{aarch64 => arm64}/vgic_lpi_stress.c       |   0
 .../kvm/{aarch64 => arm64}/vpmu_counter_access.c   |  19 +-
 tools/testing/selftests/kvm/dirty_log_perf_test.c  |   2 +-
 .../kvm/include/{aarch64 => arm64}/arch_timer.h    |   0
 .../kvm/include/{aarch64 => arm64}/delay.h         |   0
 .../selftests/kvm/include/{aarch64 => arm64}/gic.h |   0
 .../kvm/include/{aarch64 => arm64}/gic_v3.h        |   0
 .../kvm/include/{aarch64 => arm64}/gic_v3_its.h    |   0
 .../kvm/include/{aarch64 => arm64}/kvm_util_arch.h |   0
 .../kvm/include/{aarch64 => arm64}/processor.h     |   0
 .../kvm/include/{aarch64 => arm64}/spinlock.h      |   0
 .../kvm/include/{aarch64 => arm64}/ucall.h         |   0
 .../kvm/include/{aarch64 => arm64}/vgic.h          |   0
 tools/testing/selftests/kvm/include/kvm_util.h     |  10 +-
 .../kvm/include/{s390x => s390}/debug_print.h      |   0
 .../include/{s390x => s390}/diag318_test_handler.h |   0
 .../kvm/include/{s390x => s390}/facility.h         |   0
 .../kvm/include/{s390x => s390}/kvm_util_arch.h    |   0
 .../kvm/include/{s390x => s390}/processor.h        |   0
 .../selftests/kvm/include/{s390x => s390}/sie.h    |   0
 .../selftests/kvm/include/{s390x => s390}/ucall.h  |   0
 .../selftests/kvm/include/{x86_64 => x86}/apic.h   |   2 -
 .../selftests/kvm/include/{x86_64 => x86}/evmcs.h  |   3 -
 .../selftests/kvm/include/{x86_64 => x86}/hyperv.h |   3 -
 .../kvm/include/{x86_64 => x86}/kvm_util_arch.h    |   0
 .../selftests/kvm/include/{x86_64 => x86}/mce.h    |   2 -
 .../selftests/kvm/include/{x86_64 => x86}/pmu.h    |   0
 .../kvm/include/{x86_64 => x86}/processor.h        |  27 +-
 .../selftests/kvm/include/{x86_64 => x86}/sev.h    |   0
 .../selftests/kvm/include/{x86_64 => x86}/svm.h    |   6 -
 .../kvm/include/{x86_64 => x86}/svm_util.h         |   3 -
 .../selftests/kvm/include/{x86_64 => x86}/ucall.h  |   0
 .../selftests/kvm/include/{x86_64 => x86}/vmx.h    |   2 -
 .../selftests/kvm/lib/{aarch64 => arm64}/gic.c     |   0
 .../kvm/lib/{aarch64 => arm64}/gic_private.h       |   0
 .../selftests/kvm/lib/{aarch64 => arm64}/gic_v3.c  |   0
 .../kvm/lib/{aarch64 => arm64}/gic_v3_its.c        |   0
 .../kvm/lib/{aarch64 => arm64}/handlers.S          |   0
 .../kvm/lib/{aarch64 => arm64}/processor.c         |   8 +-
 .../kvm/lib/{aarch64 => arm64}/spinlock.c          |   0
 .../selftests/kvm/lib/{aarch64 => arm64}/ucall.c   |   0
 .../selftests/kvm/lib/{aarch64 => arm64}/vgic.c    |   0
 tools/testing/selftests/kvm/lib/kvm_util.c         |   3 +-
 tools/testing/selftests/kvm/lib/riscv/processor.c  |  66 +-
 .../kvm/lib/{s390x => s390}/diag318_test_handler.c |   0
 .../selftests/kvm/lib/{s390x => s390}/facility.c   |   0
 .../selftests/kvm/lib/{s390x => s390}/processor.c  |   0
 .../selftests/kvm/lib/{s390x => s390}/ucall.c      |   0
 .../selftests/kvm/lib/{x86_64 => x86}/apic.c       |   0
 .../selftests/kvm/lib/{x86_64 => x86}/handlers.S   |   0
 .../selftests/kvm/lib/{x86_64 => x86}/hyperv.c     |   0
 .../selftests/kvm/lib/{x86_64 => x86}/memstress.c  |   2 +-
 .../selftests/kvm/lib/{x86_64 => x86}/pmu.c        |   0
 .../selftests/kvm/lib/{x86_64 => x86}/processor.c  |   2 -
 .../selftests/kvm/lib/{x86_64 => x86}/sev.c        |   0
 .../selftests/kvm/lib/{x86_64 => x86}/svm.c        |   1 -
 .../selftests/kvm/lib/{x86_64 => x86}/ucall.c      |   0
 .../selftests/kvm/lib/{x86_64 => x86}/vmx.c        |   2 -
 .../{max_guest_memory_test.c => mmu_stress_test.c} | 162 +++-
 tools/testing/selftests/kvm/riscv/arch_timer.c     |   2 +-
 tools/testing/selftests/kvm/riscv/ebreak_test.c    |   2 +-
 tools/testing/selftests/kvm/riscv/get-reg-list.c   |  18 +-
 tools/testing/selftests/kvm/riscv/sbi_pmu_test.c   |   2 +-
 .../selftests/kvm/{s390x => s390}/cmma_test.c      |   0
 tools/testing/selftests/kvm/{s390x => s390}/config |   0
 .../kvm/{s390x => s390}/cpumodel_subfuncs_test.c   |   0
 .../selftests/kvm/{s390x => s390}/debug_test.c     |   0
 .../testing/selftests/kvm/{s390x => s390}/memop.c  |   0
 .../testing/selftests/kvm/{s390x => s390}/resets.c |   2 +-
 .../kvm/{s390x => s390}/shared_zeropage_test.c     |   0
 .../selftests/kvm/{s390x => s390}/sync_regs_test.c |   0
 .../testing/selftests/kvm/{s390x => s390}/tprot.c  |   0
 .../selftests/kvm/{s390x => s390}/ucontrol_test.c  |   0
 .../testing/selftests/kvm/set_memory_region_test.c |  59 +-
 tools/testing/selftests/kvm/steal_time.c           |   3 +-
 .../selftests/kvm/{x86_64 => x86}/amx_test.c       |   0
 .../kvm/{x86_64 => x86}/apic_bus_clock_test.c      |   0
 .../selftests/kvm/{x86_64 => x86}/cpuid_test.c     |   0
 .../kvm/{x86_64 => x86}/cr4_cpuid_sync_test.c      |   0
 .../selftests/kvm/{x86_64 => x86}/debug_regs.c     |   0
 .../dirty_log_page_splitting_test.c                |   0
 .../exit_on_emulation_failure_test.c               |   0
 .../kvm/{x86_64 => x86}/feature_msrs_test.c        |   0
 .../kvm/{x86_64 => x86}/fix_hypercall_test.c       |   0
 .../selftests/kvm/{x86_64 => x86}/flds_emulation.h |   0
 .../selftests/kvm/{x86_64 => x86}/hwcr_msr_test.c  |   0
 .../selftests/kvm/{x86_64 => x86}/hyperv_clock.c   |   0
 .../selftests/kvm/{x86_64 => x86}/hyperv_cpuid.c   |   0
 .../selftests/kvm/{x86_64 => x86}/hyperv_evmcs.c   |   0
 .../{x86_64 => x86}/hyperv_extended_hypercalls.c   |   0
 .../kvm/{x86_64 => x86}/hyperv_features.c          |   0
 .../selftests/kvm/{x86_64 => x86}/hyperv_ipi.c     |   0
 .../kvm/{x86_64 => x86}/hyperv_svm_test.c          |   0
 .../kvm/{x86_64 => x86}/hyperv_tlb_flush.c         |   0
 .../selftests/kvm/{x86_64 => x86}/kvm_clock_test.c |   0
 .../selftests/kvm/{x86_64 => x86}/kvm_pv_test.c    |  38 +-
 .../kvm/{x86_64 => x86}/max_vcpuid_cap_test.c      |   0
 .../kvm/{x86_64 => x86}/monitor_mwait_test.c       |   0
 .../kvm/{x86_64 => x86}/nested_exceptions_test.c   |   0
 .../kvm/{x86_64 => x86}/nx_huge_pages_test.c       |   0
 .../kvm/{x86_64 => x86}/nx_huge_pages_test.sh      |   0
 .../kvm/{x86_64 => x86}/platform_info_test.c       |   0
 .../kvm/{x86_64 => x86}/pmu_counters_test.c        |   0
 .../kvm/{x86_64 => x86}/pmu_event_filter_test.c    |   0
 .../{x86_64 => x86}/private_mem_conversions_test.c |   0
 .../{x86_64 => x86}/private_mem_kvm_exits_test.c   |   0
 .../kvm/{x86_64 => x86}/recalc_apic_map_test.c     |   0
 .../kvm/{x86_64 => x86}/set_boot_cpu_id.c          |   0
 .../selftests/kvm/{x86_64 => x86}/set_sregs_test.c |  63 +-
 .../kvm/{x86_64 => x86}/sev_init2_tests.c          |   0
 .../kvm/{x86_64 => x86}/sev_migrate_tests.c        |   0
 .../selftests/kvm/{x86_64 => x86}/sev_smoke_test.c |   2 +-
 .../smaller_maxphyaddr_emulation_test.c            |   0
 .../selftests/kvm/{x86_64 => x86}/smm_test.c       |   0
 .../selftests/kvm/{x86_64 => x86}/state_test.c     |   0
 .../kvm/{x86_64 => x86}/svm_int_ctl_test.c         |   0
 .../kvm/{x86_64 => x86}/svm_nested_shutdown_test.c |   0
 .../{x86_64 => x86}/svm_nested_soft_inject_test.c  |   0
 .../kvm/{x86_64 => x86}/svm_vmcall_test.c          |   0
 .../selftests/kvm/{x86_64 => x86}/sync_regs_test.c |   0
 .../kvm/{x86_64 => x86}/triple_fault_event_test.c  |   0
 .../selftests/kvm/{x86_64 => x86}/tsc_msrs_test.c  |   0
 .../kvm/{x86_64 => x86}/tsc_scaling_sync.c         |   0
 .../kvm/{x86_64 => x86}/ucna_injection_test.c      |   0
 .../kvm/{x86_64 => x86}/userspace_io_test.c        |   0
 .../kvm/{x86_64 => x86}/userspace_msr_exit_test.c  |   0
 .../kvm/{x86_64 => x86}/vmx_apic_access_test.c     |   0
 .../{x86_64 => x86}/vmx_close_while_nested_test.c  |   0
 .../kvm/{x86_64 => x86}/vmx_dirty_log_test.c       |   0
 .../vmx_exception_with_invalid_guest_state.c       |   0
 .../vmx_invalid_nested_guest_state.c               |   0
 .../selftests/kvm/{x86_64 => x86}/vmx_msrs_test.c  |   0
 .../{x86_64 => x86}/vmx_nested_tsc_scaling_test.c  |   0
 .../kvm/{x86_64 => x86}/vmx_pmu_caps_test.c        |   0
 .../{x86_64 => x86}/vmx_preemption_timer_test.c    |   0
 .../{x86_64 => x86}/vmx_set_nested_state_test.c    |   0
 .../kvm/{x86_64 => x86}/vmx_tsc_adjust_test.c      |   0
 .../selftests/kvm/{x86_64 => x86}/xapic_ipi_test.c |   0
 .../kvm/{x86_64 => x86}/xapic_state_test.c         |   0
 .../kvm/{x86_64 => x86}/xcr0_cpuid_test.c          |   0
 .../kvm/{x86_64 => x86}/xen_shinfo_test.c          |   0
 .../kvm/{x86_64 => x86}/xen_vmcall_test.c          |   0
 .../selftests/kvm/{x86_64 => x86}/xss_msr_test.c   |   0
 virt/kvm/guest_memfd.c                             |  36 +-
 virt/kvm/kvm_main.c                                | 115 ++-
 222 files changed, 2909 insertions(+), 1547 deletions(-)
 create mode 100644 arch/riscv/kvm/vcpu_sbi_system.c
 delete mode 100644 arch/x86/kvm/governed_features.h
 create mode 100644 include/linux/call_once.h
 create mode 100644 tools/testing/selftests/kvm/Makefile.kvm
 rename tools/testing/selftests/kvm/{aarch64 => arm64}/aarch32_id_regs.c (95%)
 rename tools/testing/selftests/kvm/{aarch64 => arm64}/arch_timer.c (100%)
 rename tools/testing/selftests/kvm/{aarch64 => arm64}/arch_timer_edge_cases.c (100%)
 rename tools/testing/selftests/kvm/{aarch64 => arm64}/debug-exceptions.c (99%)
 rename tools/testing/selftests/kvm/{aarch64 => arm64}/get-reg-list.c (100%)
 rename tools/testing/selftests/kvm/{aarch64 => arm64}/hypercalls.c (98%)
 rename tools/testing/selftests/kvm/{aarch64 => arm64}/mmio_abort.c (100%)
 rename tools/testing/selftests/kvm/{aarch64 => arm64}/no-vgic-v3.c (98%)
 rename tools/testing/selftests/kvm/{aarch64 => arm64}/page_fault_test.c (100%)
 rename tools/testing/selftests/kvm/{aarch64 => arm64}/psci_test.c (96%)
 rename tools/testing/selftests/kvm/{aarch64 => arm64}/set_id_regs.c (97%)
 rename tools/testing/selftests/kvm/{aarch64 => arm64}/smccc_filter.c (100%)
 rename tools/testing/selftests/kvm/{aarch64 => arm64}/vcpu_width_config.c (100%)
 rename tools/testing/selftests/kvm/{aarch64 => arm64}/vgic_init.c (100%)
 rename tools/testing/selftests/kvm/{aarch64 => arm64}/vgic_irq.c (100%)
 rename tools/testing/selftests/kvm/{aarch64 => arm64}/vgic_lpi_stress.c (100%)
 rename tools/testing/selftests/kvm/{aarch64 => arm64}/vpmu_counter_access.c (97%)
 rename tools/testing/selftests/kvm/include/{aarch64 => arm64}/arch_timer.h (100%)
 rename tools/testing/selftests/kvm/include/{aarch64 => arm64}/delay.h (100%)
 rename tools/testing/selftests/kvm/include/{aarch64 => arm64}/gic.h (100%)
 rename tools/testing/selftests/kvm/include/{aarch64 => arm64}/gic_v3.h (100%)
 rename tools/testing/selftests/kvm/include/{aarch64 => arm64}/gic_v3_its.h (100%)
 rename tools/testing/selftests/kvm/include/{aarch64 => arm64}/kvm_util_arch.h (100%)
 rename tools/testing/selftests/kvm/include/{aarch64 => arm64}/processor.h (100%)
 rename tools/testing/selftests/kvm/include/{aarch64 => arm64}/spinlock.h (100%)
 rename tools/testing/selftests/kvm/include/{aarch64 => arm64}/ucall.h (100%)
 rename tools/testing/selftests/kvm/include/{aarch64 => arm64}/vgic.h (100%)
 rename tools/testing/selftests/kvm/include/{s390x => s390}/debug_print.h (100%)
 rename tools/testing/selftests/kvm/include/{s390x => s390}/diag318_test_handler.h (100%)
 rename tools/testing/selftests/kvm/include/{s390x => s390}/facility.h (100%)
 rename tools/testing/selftests/kvm/include/{s390x => s390}/kvm_util_arch.h (100%)
 rename tools/testing/selftests/kvm/include/{s390x => s390}/processor.h (100%)
 rename tools/testing/selftests/kvm/include/{s390x => s390}/sie.h (100%)
 rename tools/testing/selftests/kvm/include/{s390x => s390}/ucall.h (100%)
 rename tools/testing/selftests/kvm/include/{x86_64 => x86}/apic.h (98%)
 rename tools/testing/selftests/kvm/include/{x86_64 => x86}/evmcs.h (99%)
 rename tools/testing/selftests/kvm/include/{x86_64 => x86}/hyperv.h (99%)
 rename tools/testing/selftests/kvm/include/{x86_64 => x86}/kvm_util_arch.h (100%)
 rename tools/testing/selftests/kvm/include/{x86_64 => x86}/mce.h (94%)
 rename tools/testing/selftests/kvm/include/{x86_64 => x86}/pmu.h (100%)
 rename tools/testing/selftests/kvm/include/{x86_64 => x86}/processor.h (99%)
 rename tools/testing/selftests/kvm/include/{x86_64 => x86}/sev.h (100%)
 rename tools/testing/selftests/kvm/include/{x86_64 => x86}/svm.h (98%)
 rename tools/testing/selftests/kvm/include/{x86_64 => x86}/svm_util.h (94%)
 rename tools/testing/selftests/kvm/include/{x86_64 => x86}/ucall.h (100%)
 rename tools/testing/selftests/kvm/include/{x86_64 => x86}/vmx.h (99%)
 rename tools/testing/selftests/kvm/lib/{aarch64 => arm64}/gic.c (100%)
 rename tools/testing/selftests/kvm/lib/{aarch64 => arm64}/gic_private.h (100%)
 rename tools/testing/selftests/kvm/lib/{aarch64 => arm64}/gic_v3.c (100%)
 rename tools/testing/selftests/kvm/lib/{aarch64 => arm64}/gic_v3_its.c (100%)
 rename tools/testing/selftests/kvm/lib/{aarch64 => arm64}/handlers.S (100%)
 rename tools/testing/selftests/kvm/lib/{aarch64 => arm64}/processor.c (98%)
 rename tools/testing/selftests/kvm/lib/{aarch64 => arm64}/spinlock.c (100%)
 rename tools/testing/selftests/kvm/lib/{aarch64 => arm64}/ucall.c (100%)
 rename tools/testing/selftests/kvm/lib/{aarch64 => arm64}/vgic.c (100%)
 rename tools/testing/selftests/kvm/lib/{s390x => s390}/diag318_test_handler.c (100%)
 rename tools/testing/selftests/kvm/lib/{s390x => s390}/facility.c (100%)
 rename tools/testing/selftests/kvm/lib/{s390x => s390}/processor.c (100%)
 rename tools/testing/selftests/kvm/lib/{s390x => s390}/ucall.c (100%)
 rename tools/testing/selftests/kvm/lib/{x86_64 => x86}/apic.c (100%)
 rename tools/testing/selftests/kvm/lib/{x86_64 => x86}/handlers.S (100%)
 rename tools/testing/selftests/kvm/lib/{x86_64 => x86}/hyperv.c (100%)
 rename tools/testing/selftests/kvm/lib/{x86_64 => x86}/memstress.c (98%)
 rename tools/testing/selftests/kvm/lib/{x86_64 => x86}/pmu.c (100%)
 rename tools/testing/selftests/kvm/lib/{x86_64 => x86}/processor.c (99%)
 rename tools/testing/selftests/kvm/lib/{x86_64 => x86}/sev.c (100%)
 rename tools/testing/selftests/kvm/lib/{x86_64 => x86}/svm.c (99%)
 rename tools/testing/selftests/kvm/lib/{x86_64 => x86}/ucall.c (100%)
 rename tools/testing/selftests/kvm/lib/{x86_64 => x86}/vmx.c (99%)
 rename tools/testing/selftests/kvm/{max_guest_memory_test.c => mmu_stress_test.c} (60%)
 rename tools/testing/selftests/kvm/{s390x => s390}/cmma_test.c (100%)
 rename tools/testing/selftests/kvm/{s390x => s390}/config (100%)
 rename tools/testing/selftests/kvm/{s390x => s390}/cpumodel_subfuncs_test.c (100%)
 rename tools/testing/selftests/kvm/{s390x => s390}/debug_test.c (100%)
 rename tools/testing/selftests/kvm/{s390x => s390}/memop.c (100%)
 rename tools/testing/selftests/kvm/{s390x => s390}/resets.c (99%)
 rename tools/testing/selftests/kvm/{s390x => s390}/shared_zeropage_test.c (100%)
 rename tools/testing/selftests/kvm/{s390x => s390}/sync_regs_test.c (100%)
 rename tools/testing/selftests/kvm/{s390x => s390}/tprot.c (100%)
 rename tools/testing/selftests/kvm/{s390x => s390}/ucontrol_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/amx_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/apic_bus_clock_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/cpuid_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/cr4_cpuid_sync_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/debug_regs.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/dirty_log_page_splitting_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/exit_on_emulation_failure_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/feature_msrs_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/fix_hypercall_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/flds_emulation.h (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/hwcr_msr_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/hyperv_clock.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/hyperv_cpuid.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/hyperv_evmcs.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/hyperv_extended_hypercalls.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/hyperv_features.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/hyperv_ipi.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/hyperv_svm_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/hyperv_tlb_flush.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/kvm_clock_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/kvm_pv_test.c (76%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/max_vcpuid_cap_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/monitor_mwait_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/nested_exceptions_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/nx_huge_pages_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/nx_huge_pages_test.sh (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/platform_info_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/pmu_counters_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/pmu_event_filter_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/private_mem_conversions_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/private_mem_kvm_exits_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/recalc_apic_map_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/set_boot_cpu_id.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/set_sregs_test.c (75%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/sev_init2_tests.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/sev_migrate_tests.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/sev_smoke_test.c (99%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/smaller_maxphyaddr_emulation_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/smm_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/state_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/svm_int_ctl_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/svm_nested_shutdown_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/svm_nested_soft_inject_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/svm_vmcall_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/sync_regs_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/triple_fault_event_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/tsc_msrs_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/tsc_scaling_sync.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/ucna_injection_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/userspace_io_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/userspace_msr_exit_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/vmx_apic_access_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/vmx_close_while_nested_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/vmx_dirty_log_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/vmx_exception_with_invalid_guest_state.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/vmx_invalid_nested_guest_state.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/vmx_msrs_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/vmx_nested_tsc_scaling_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/vmx_pmu_caps_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/vmx_preemption_timer_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/vmx_set_nested_state_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/vmx_tsc_adjust_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/xapic_ipi_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/xapic_state_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/xcr0_cpuid_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/xen_shinfo_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/xen_vmcall_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/xss_msr_test.c (100%)


