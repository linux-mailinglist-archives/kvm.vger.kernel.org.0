Return-Path: <kvm+bounces-27643-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E8ED989017
	for <lists+kvm@lfdr.de>; Sat, 28 Sep 2024 17:33:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 102D72825A3
	for <lists+kvm@lfdr.de>; Sat, 28 Sep 2024 15:33:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 186161F5E6;
	Sat, 28 Sep 2024 15:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KAzcI0ir"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0CDF1B299
	for <kvm@vger.kernel.org>; Sat, 28 Sep 2024 15:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727537591; cv=none; b=iuzCG6ORovYbyG9Bl8AQOOxm2F9hlD1N63vA1XTYSzrMfTLLcj/wJXrzzdpsxzd7hpCzeiPmUAtOeXRb+kt15NrVOVqW1nV1hCa4IBA1oI+CbuLvS0XvgP0jqJrFQdUSVJaK/gn3eUR0cbIrrmbiuwiWXYUVaR2F0eQH3/qz0NI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727537591; c=relaxed/simple;
	bh=kHO0U8GEn4i5/vco/E4qYjcEd9mmP8lnRQLGAPZez6s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HodaoRGiFE/d1NUl3k5Pc6n9T4Zmd5T8Sj2kqX8+tkwae9FYgVzraOiHZuH5l/2JEwDb4FWp1k494JuZqNH/z5qTh7VIfVjR8iBIrTF17C5kGX4nlwsrWwV+Ejl5XAY1q9272cSXpq8qdl+uc85vxq4d1V3B1bZR5J2iIrMNHZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KAzcI0ir; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1727537587;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=V8AslBscwXwooPSNFsIbB0LA55XWIqF8Xm2fNtIFaUk=;
	b=KAzcI0ir2ulX66870BZIeCxhhBtgr9nmd17F4sPlXefKepfr0C7vZlmNnNnpVSvMnVTnk8
	zfSNGZD1XPqkasLmjPLtLAIXUgNrdGieB1bZbw689/h3lgxcgbcFycxAJtoA87E/KR/91P
	ppu3HgoAocfdIlMfLulCEwyOzJYwefU=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-339-XyIkngvNNDu0V7XZPaof0Q-1; Sat,
 28 Sep 2024 11:33:04 -0400
X-MC-Unique: XyIkngvNNDu0V7XZPaof0Q-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (unknown [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 827F71955D4C;
	Sat, 28 Sep 2024 15:33:03 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (unknown [10.8.1.187])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C49051955DCB;
	Sat, 28 Sep 2024 15:33:02 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [GIT PULL] KVM/x86 changes for Linux 6.12
Date: Sat, 28 Sep 2024 11:33:02 -0400
Message-ID: <20240928153302.92406-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Linus,

The following changes since commit da3ea35007d0af457a0afc87e84fddaebc4e0b63:

  Linux 6.11-rc7 (2024-09-08 14:50:28 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to efbc6bd090f48ccf64f7a8dd5daea775821d57ec:

  Documentation: KVM: fix warning in "make htmldocs" (2024-09-27 11:45:50 -0400)

Apologize for the late pull request; all the traveling made things a
bit messy.  Also, we have a known regression here on ancient processors
and will fix it next week.

Paolo
----------------------------------------------------------------
x86:

* KVM currently invalidates the entirety of the page tables, not just
  those for the memslot being touched, when a memslot is moved or deleted.
  The former does not have particularly noticeable overhead, but Intel's
  TDX will require the guest to re-accept private pages if they are
  dropped from the secure EPT, which is a non starter.  Actually,
  the only reason why this is not already being done is a bug which
  was never fully investigated and caused VM instability with assigned
  GeForce GPUs, so allow userspace to opt into the new behavior.

* Advertise AVX10.1 to userspace (effectively prep work for the "real" AVX10
  functionality that is on the horizon).

* Rework common MSR handling code to suppress errors on userspace accesses to
  unsupported-but-advertised MSRs.  This will allow removing (almost?) all of
  KVM's exemptions for userspace access to MSRs that shouldn't exist based on
  the vCPU model (the actual cleanup is non-trivial future work).

* Rework KVM's handling of x2APIC ICR, again, because AMD (x2AVIC) splits the
  64-bit value into the legacy ICR and ICR2 storage, whereas Intel (APICv)
  stores the entire 64-bit value at the ICR offset.

* Fix a bug where KVM would fail to exit to userspace if one was triggered by
  a fastpath exit handler.

* Add fastpath handling of HLT VM-Exit to expedite re-entering the guest when
  there's already a pending wake event at the time of the exit.

* Fix a WARN caused by RSM entering a nested guest from SMM with invalid guest
  state, by forcing the vCPU out of guest mode prior to signalling SHUTDOWN
  (the SHUTDOWN hits the VM altogether, not the nested guest)

* Overhaul the "unprotect and retry" logic to more precisely identify cases
  where retrying is actually helpful, and to harden all retry paths against
  putting the guest into an infinite retry loop.

* Add support for yielding, e.g. to honor NEED_RESCHED, when zapping rmaps in
  the shadow MMU.

* Refactor pieces of the shadow MMU related to aging SPTEs in prepartion for
  adding multi generation LRU support in KVM.

* Don't stuff the RSB after VM-Exit when RETPOLINE=y and AutoIBRS is enabled,
  i.e. when the CPU has already flushed the RSB.

* Trace the per-CPU host save area as a VMCB pointer to improve readability
  and cleanup the retrieval of the SEV-ES host save area.

* Remove unnecessary accounting of temporary nested VMCB related allocations.

* Set FINAL/PAGE in the page fault error code for EPT violations if and only
  if the GVA is valid.  If the GVA is NOT valid, there is no guest-side page
  table walk and so stuffing paging related metadata is nonsensical.

* Fix a bug where KVM would incorrectly synthesize a nested VM-Exit instead of
  emulating posted interrupt delivery to L2.

* Add a lockdep assertion to detect unsafe accesses of vmcs12 structures.

* Harden eVMCS loading against an impossible NULL pointer deref (really truly
  should be impossible).

* Minor SGX fix and a cleanup.

* Misc cleanups

Generic:

* Register KVM's cpuhp and syscore callbacks when enabling virtualization in
  hardware, as the sole purpose of said callbacks is to disable and re-enable
  virtualization as needed.

* Enable virtualization when KVM is loaded, not right before the first VM
  is created.  Together with the previous change, this simplifies a
  lot the logic of the callbacks, because their very existence implies
  virtualization is enabled.

* Fix a bug that results in KVM prematurely exiting to userspace for coalesced
  MMIO/PIO in many cases, clean up the related code, and add a testcase.

* Fix a bug in kvm_clear_guest() where it would trigger a buffer overflow _if_
  the gpa+len crosses a page boundary, which thankfully is guaranteed to not
  happen in the current code base.  Add WARNs in more helpers that read/write
  guest memory to detect similar bugs.

Selftests:

* Fix a goof that caused some Hyper-V tests to be skipped when run on bare
  metal, i.e. NOT in a VM.

* Add a regression test for KVM's handling of SHUTDOWN for an SEV-ES guest.

* Explicitly include one-off assets in .gitignore.  Past Sean was completely
  wrong about not being able to detect missing .gitignore entries.

* Verify userspace single-stepping works when KVM happens to handle a VM-Exit
  in its fastpath.

* Misc cleanups

----------------------------------------------------------------
Amit Shah (1):
      KVM: SVM: let alternatives handle the cases when RSB filling is required

Christoph Schlameuss (7):
      selftests: kvm: s390: Define page sizes in shared header
      selftests: kvm: s390: Add kvm_s390_sie_block definition for userspace tests
      selftests: kvm: s390: Add s390x ucontrol test suite with hpage test
      selftests: kvm: s390: Add test fixture and simple VM setup tests
      selftests: kvm: s390: Add debug print functions
      selftests: kvm: s390: Add VM run test case
      s390: Enable KVM_S390_UCONTROL config in debug_defconfig

Hariharan Mari (1):
      KVM: s390: Fix SORTL and DFLTCC instruction format error in __insn32_query

Ilias Stamatis (1):
      KVM: Fix coalesced_mmio_has_room() to avoid premature userspace exit

Kai Huang (2):
      KVM: VMX: Do not account for temporary memory allocation in ECREATE emulation
      KVM: VMX: Also clear SGX EDECCSSA in KVM CPU caps when SGX is disabled

Li Chen (1):
      KVM: x86: Use this_cpu_ptr() in kvm_user_return_msr_cpu_online

Maxim Levitsky (1):
      KVM: nVMX: Use vmx_segment_cache_clear() instead of open coded equivalent

Paolo Bonzini (12):
      Merge tag 'kvm-s390-next-6.12-1' of https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux into HEAD
      Merge branch 'kvm-memslot-zap-quirk' into HEAD
      Merge branch 'kvm-redo-enable-virt' into HEAD
      Merge tag 'kvm-x86-generic-6.12' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-misc-6.12' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-selftests-6.12' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-mmu-6.12' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-pat_vmx_msrs-6.12' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-svm-6.12' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-vmx-6.12' of https://github.com/kvm-x86/linux into HEAD
      Documentation: KVM: fix warning in "make htmldocs"
      Merge remote-tracking branch 'origin/master' into HEAD

Peter Gonda (1):
      KVM: selftests: Add SEV-ES shutdown test

Qiang Liu (1):
      KVM: VMX: Modify the BUILD_BUG_ON_MSG of the 32-bit field in the vmcs_check16 function

Sean Christopherson (94):
      x86/cpu: KVM: Add common defines for architectural memory types (PAT, MTRRs, etc.)
      x86/cpu: KVM: Move macro to encode PAT value to common header
      KVM: x86: Stuff vCPU's PAT with default value at RESET, not creation
      KVM: nVMX: Add a helper to encode VMCS info in MSR_IA32_VMX_BASIC
      KVM VMX: Move MSR_IA32_VMX_MISC bit defines to asm/vmx.h
      KVM: nVMX: Honor userspace MSR filter lists for nested VM-Enter/VM-Exit
      KVM: x86/mmu: Clean up function comments for dirty logging APIs
      KVM: SVM: Disallow guest from changing userspace's MSR_AMD64_DE_CFG value
      KVM: x86: Move MSR_TYPE_{R,W,RW} values from VMX to x86, as enums
      KVM: x86: Rename KVM_MSR_RET_INVALID to KVM_MSR_RET_UNSUPPORTED
      KVM: x86: Refactor kvm_x86_ops.get_msr_feature() to avoid kvm_msr_entry
      KVM: x86: Rename get_msr_feature() APIs to get_feature_msr()
      KVM: x86: Refactor kvm_get_feature_msr() to avoid struct kvm_msr_entry
      KVM: x86: Funnel all fancy MSR return value handling into a common helper
      KVM: x86: Hoist x86.c's global msr_* variables up above kvm_do_msr_access()
      KVM: x86: Suppress failures on userspace access to advertised, unsupported MSRs
      KVM: x86: Suppress userspace access failures on unsupported, "emulated" MSRs
      KVM: x86: Enforce x2APIC's must-be-zero reserved ICR bits
      KVM: x86: Move x2APIC ICR helper above kvm_apic_write_nodecode()
      KVM: x86: Re-split x2APIC ICR into ICR+ICR2 for AMD (x2AVIC)
      KVM: selftests: Open code vcpu_run() equivalent in guest_printf test
      KVM: selftests: Report unhandled exceptions on x86 as regular guest asserts
      KVM: selftests: Add x86 helpers to play nice with x2APIC MSR #GPs
      KVM: selftests: Skip ICR.BUSY test in xapic_state_test if x2APIC is enabled
      KVM: selftests: Test x2APIC ICR reserved bits
      KVM: selftests: Verify the guest can read back the x2APIC ICR it wrote
      KVM: selftests: Play nice with AMD's AVIC errata
      KVM: selftests: Remove unused kvm_memcmp_hva_gva()
      KVM: selftests: Always unlink memory regions when deleting (VM free)
      KVM: x86/mmu: Decrease indentation in logic to sync new indirect shadow page
      KVM: x86/mmu: Drop pointless "return" wrapper label in FNAME(fetch)
      KVM: x86/mmu: Reword a misleading comment about checking gpte_changed()
      KVM: SVM: Add a helper to convert a SME-aware PA back to a struct page
      KVM: SVM: Add host SEV-ES save area structure into VMCB via a union
      KVM: SVM: Track the per-CPU host save area as a VMCB pointer
      KVM: selftests: Add a test for coalesced MMIO (and PIO on x86)
      KVM: Clean up coalesced MMIO ring full check
      KVM: selftests: Explicitly include committed one-off assets in .gitignore
      KVM: x86: Re-enter guest if WRMSR(X2APIC_ICR) fastpath is successful
      KVM: x86: Dedup fastpath MSR post-handling logic
      KVM: x86: Exit to userspace if fastpath triggers one on instruction skip
      KVM: x86: Reorganize code in x86.c to co-locate vCPU blocking/running helpers
      KVM: x86: Add fastpath handling of HLT VM-Exits
      KVM: Use dedicated mutex to protect kvm_usage_count to avoid deadlock
      KVM: Register cpuhp and syscore callbacks when enabling hardware
      KVM: Rename symbols related to enabling virtualization hardware
      KVM: Rename arch hooks related to per-CPU virtualization enabling
      KVM: MIPS: Rename virtualization {en,dis}abling APIs to match common KVM
      KVM: x86: Rename virtualization {en,dis}abling APIs to match common KVM
      KVM: Add a module param to allow enabling virtualization when KVM is loaded
      KVM: Add arch hooks for enabling/disabling virtualization
      x86/reboot: Unconditionally define cpu_emergency_virt_cb typedef
      KVM: x86: Register "emergency disable" callbacks when virt is enabled
      KVM: x86: Forcibly leave nested if RSM to L2 hits shutdown
      KVM: selftests: Verify single-stepping a fastpath VM-Exit exits to userspace
      KVM: x86: Move "ack" phase of local APIC IRQ delivery to separate API
      KVM: nVMX: Get to-be-acknowledge IRQ for nested VM-Exit at injection site
      KVM: nVMX: Suppress external interrupt VM-Exit injection if there's no IRQ
      KVM: nVMX: Detect nested posted interrupt NV at nested VM-Exit injection
      KVM: x86: Fold kvm_get_apic_interrupt() into kvm_cpu_get_interrupt()
      KVM: nVMX: Explicitly invalidate posted_intr_nv if PI is disabled at VM-Enter
      KVM: nVMX: Assert that vcpu->mutex is held when accessing secondary VMCSes
      KVM: Write the per-page "segment" when clearing (part of) a guest page
      KVM: Harden guest memory APIs against out-of-bounds accesses
      KVM: x86/mmu: Replace PFERR_NESTED_GUEST_PAGE with a more descriptive helper
      KVM: x86/mmu: Trigger unprotect logic only on write-protection page faults
      KVM: x86/mmu: Skip emulation on page fault iff 1+ SPs were unprotected
      KVM: x86: Retry to-be-emulated insn in "slow" unprotect path iff sp is zapped
      KVM: x86: Get RIP from vCPU state when storing it to last_retry_eip
      KVM: x86: Store gpa as gpa_t, not unsigned long, when unprotecting for retry
      KVM: x86/mmu: Apply retry protection to "fast nTDP unprotect" path
      KVM: x86/mmu: Try "unprotect for retry" iff there are indirect SPs
      KVM: x86: Move EMULTYPE_ALLOW_RETRY_PF to x86_emulate_instruction()
      KVM: x86: Fold retry_instruction() into x86_emulate_instruction()
      KVM: x86/mmu: Don't try to unprotect an INVALID_GPA
      KVM: x86/mmu: Always walk guest PTEs with WRITE access when unprotecting
      KVM: x86/mmu: Move event re-injection unprotect+retry into common path
      KVM: x86: Remove manual pfn lookup when retrying #PF after failed emulation
      KVM: x86: Check EMULTYPE_WRITE_PF_TO_SP before unprotecting gfn
      KVM: x86: Apply retry protection to "unprotect on failure" path
      KVM: x86: Update retry protection fields when forcing retry on emulation failure
      KVM: x86: Rename reexecute_instruction()=>kvm_unprotect_and_retry_on_failure()
      KVM: x86/mmu: Subsume kvm_mmu_unprotect_page() into the and_retry() version
      KVM: x86/mmu: Detect if unprotect will do anything based on invalid_list
      KVM: x86/mmu: WARN on MMIO cache hit when emulating write-protected gfn
      KVM: x86/mmu: Move walk_slot_rmaps() up near for_each_slot_rmap_range()
      KVM: x86/mmu: Plumb a @can_yield parameter into __walk_slot_rmaps()
      KVM: x86/mmu: Add a helper to walk and zap rmaps for a memslot
      KVM: x86/mmu: Honor NEED_RESCHED when zapping rmaps and blocking is allowed
      KVM: x86/mmu: Morph kvm_handle_gfn_range() into an aging specific helper
      KVM: x86/mmu: Fold mmu_spte_age() into kvm_rmap_age_gfn_range()
      KVM: x86/mmu: Add KVM_RMAP_MANY to replace open coded '1' and '1ul' literals
      KVM: x86/mmu: Use KVM_PAGES_PER_HPAGE() instead of an open coded equivalent
      KVM: VMX: Set PFERR_GUEST_{FINAL,PAGE}_MASK if and only if the GVA is valid

Tao Su (1):
      KVM: x86: Advertise AVX10.1 CPUID to userspace

Thorsten Blum (1):
      KVM: x86: Optimize local variable in start_sw_tscdeadline()

Vitaly Kuznetsov (3):
      KVM: VMX: hyper-v: Prevent impossible NULL pointer dereference in evmcs_load()
      KVM: selftests: Move Hyper-V specific functions out of processor.c
      KVM: selftests: Re-enable hyperv_evmcs/hyperv_svm_test on bare metal

Xin Li (5):
      KVM: VMX: Move MSR_IA32_VMX_BASIC bit defines to asm/vmx.h
      KVM: VMX: Track CPU's MSR_IA32_VMX_BASIC as a single 64-bit value
      KVM: nVMX: Use macros and #defines in vmx_restore_vmx_basic()
      KVM: VMX: Open code VMX preemption timer rate mask in its accessor
      KVM: nVMX: Use macros and #defines in vmx_restore_vmx_misc()

Yan Zhao (4):
      KVM: x86/mmu: Introduce a quirk to control memslot zap behavior
      KVM: selftests: Test slot move/delete with slot zap quirk enabled/disabled
      KVM: selftests: Allow slot modification stress test with quirk disabled
      KVM: selftests: Test memslot move in memslot_perf_test with quirk disabled

Yongqiang Liu (1):
      KVM: SVM: Remove unnecessary GFP_KERNEL_ACCOUNT in svm_set_nested_state()

Yue Haibing (1):
      KVM: x86: Remove some unused declarations

 Documentation/admin-guide/kernel-parameters.txt    |   17 +
 Documentation/virt/kvm/api.rst                     |   31 +-
 Documentation/virt/kvm/locking.rst                 |   32 +-
 arch/arm64/kvm/arm.c                               |    6 +-
 arch/loongarch/kvm/main.c                          |    4 +-
 arch/mips/include/asm/kvm_host.h                   |    4 +-
 arch/mips/kvm/mips.c                               |    8 +-
 arch/mips/kvm/vz.c                                 |    8 +-
 arch/riscv/kvm/main.c                              |    4 +-
 arch/s390/configs/debug_defconfig                  |    1 +
 arch/s390/kvm/kvm-s390.c                           |   27 +-
 arch/x86/include/asm/cpuid.h                       |    1 +
 arch/x86/include/asm/kvm-x86-ops.h                 |    6 +-
 arch/x86/include/asm/kvm_host.h                    |   32 +-
 arch/x86/include/asm/msr-index.h                   |   34 +-
 arch/x86/include/asm/reboot.h                      |    2 +-
 arch/x86/include/asm/svm.h                         |   20 +-
 arch/x86/include/asm/vmx.h                         |   40 +-
 arch/x86/include/uapi/asm/kvm.h                    |    1 +
 arch/x86/kernel/cpu/mtrr/mtrr.c                    |    6 +
 arch/x86/kvm/cpuid.c                               |   30 +-
 arch/x86/kvm/irq.c                                 |   10 +-
 arch/x86/kvm/lapic.c                               |   84 +-
 arch/x86/kvm/lapic.h                               |    3 +-
 arch/x86/kvm/mmu.h                                 |    2 -
 arch/x86/kvm/mmu/mmu.c                             |  558 ++++++-----
 arch/x86/kvm/mmu/mmu_internal.h                    |    5 +-
 arch/x86/kvm/mmu/mmutrace.h                        |    1 +
 arch/x86/kvm/mmu/paging_tmpl.h                     |   63 +-
 arch/x86/kvm/mmu/tdp_mmu.c                         |    6 +-
 arch/x86/kvm/reverse_cpuid.h                       |    8 +
 arch/x86/kvm/smm.c                                 |   24 +-
 arch/x86/kvm/svm/nested.c                          |    4 +-
 arch/x86/kvm/svm/svm.c                             |   87 +-
 arch/x86/kvm/svm/svm.h                             |   18 +-
 arch/x86/kvm/svm/vmenter.S                         |    8 +-
 arch/x86/kvm/vmx/capabilities.h                    |   10 +-
 arch/x86/kvm/vmx/main.c                            |   10 +-
 arch/x86/kvm/vmx/nested.c                          |  134 ++-
 arch/x86/kvm/vmx/nested.h                          |    8 +-
 arch/x86/kvm/vmx/sgx.c                             |    2 +-
 arch/x86/kvm/vmx/vmx.c                             |   67 +-
 arch/x86/kvm/vmx/vmx.h                             |    9 +-
 arch/x86/kvm/vmx/vmx_onhyperv.h                    |    8 +
 arch/x86/kvm/vmx/vmx_ops.h                         |    2 +-
 arch/x86/kvm/vmx/x86_ops.h                         |    7 +-
 arch/x86/kvm/x86.c                                 | 1006 ++++++++++----------
 arch/x86/kvm/x86.h                                 |   31 +-
 arch/x86/mm/pat/memtype.c                          |   36 +-
 include/linux/kvm_host.h                           |   18 +-
 tools/testing/selftests/kvm/.gitignore             |    4 +
 tools/testing/selftests/kvm/Makefile               |    4 +
 tools/testing/selftests/kvm/coalesced_io_test.c    |  236 +++++
 tools/testing/selftests/kvm/guest_print_test.c     |   19 +-
 tools/testing/selftests/kvm/include/kvm_util.h     |   28 +-
 .../selftests/kvm/include/s390x/debug_print.h      |   69 ++
 .../selftests/kvm/include/s390x/processor.h        |    5 +
 tools/testing/selftests/kvm/include/s390x/sie.h    |  240 +++++
 tools/testing/selftests/kvm/include/x86_64/apic.h  |   23 +-
 .../testing/selftests/kvm/include/x86_64/hyperv.h  |   18 +
 .../selftests/kvm/include/x86_64/processor.h       |    7 +-
 tools/testing/selftests/kvm/lib/kvm_util.c         |   85 +-
 tools/testing/selftests/kvm/lib/s390x/processor.c  |   10 +-
 tools/testing/selftests/kvm/lib/x86_64/hyperv.c    |   67 ++
 tools/testing/selftests/kvm/lib/x86_64/processor.c |   69 +-
 .../kvm/memslot_modification_stress_test.c         |   19 +-
 tools/testing/selftests/kvm/memslot_perf_test.c    |   12 +-
 tools/testing/selftests/kvm/s390x/cmma_test.c      |    7 +-
 tools/testing/selftests/kvm/s390x/config           |    2 +
 tools/testing/selftests/kvm/s390x/debug_test.c     |    4 +-
 tools/testing/selftests/kvm/s390x/memop.c          |    4 +-
 tools/testing/selftests/kvm/s390x/tprot.c          |    5 +-
 tools/testing/selftests/kvm/s390x/ucontrol_test.c  |  332 +++++++
 .../testing/selftests/kvm/set_memory_region_test.c |   29 +-
 tools/testing/selftests/kvm/x86_64/debug_regs.c    |   11 +-
 tools/testing/selftests/kvm/x86_64/hyperv_evmcs.c  |    2 +-
 .../testing/selftests/kvm/x86_64/hyperv_svm_test.c |    2 +-
 .../testing/selftests/kvm/x86_64/sev_smoke_test.c  |   32 +
 .../selftests/kvm/x86_64/xapic_state_test.c        |   54 +-
 .../testing/selftests/kvm/x86_64/xen_vmcall_test.c |    1 +
 virt/kvm/coalesced_mmio.c                          |   31 +-
 virt/kvm/kvm_main.c                                |  281 +++---
 82 files changed, 2803 insertions(+), 1452 deletions(-)


