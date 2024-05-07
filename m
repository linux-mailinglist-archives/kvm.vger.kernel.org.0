Return-Path: <kvm+bounces-16858-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B089A8BE807
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 17:59:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3C16D284664
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 15:59:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F2C416C684;
	Tue,  7 May 2024 15:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fCzl4NPD"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20D27165FD4
	for <kvm@vger.kernel.org>; Tue,  7 May 2024 15:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715097503; cv=none; b=MovoK1PNfRjStHbf3Fqrb+OyQRaQ+4KZx3Q+qv9dGMSxsjOjzgHUN9iuB3mjfn87DN9ZiBXmHibTHng5JhfWD5xN+b4s0f/UAdpkZb5QpibKHfatYNqyvniSlpiYZZbLOd+5ua6w19xbnNXo9ETt+5L07cnYWV6lCk7Q0cnl4oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715097503; c=relaxed/simple;
	bh=4RohMnPCJFnKpKqUnP8yO28gs460BLP/sGG3w/07gi0=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=e2o87aKeVPOTiDxzS4RA7DB6BF0+335vkQOrngPDbwnVYlucsOABMukkEB7qS0EKpeslYO6h6dc+2wNC6cCz6PFvxeMuJNDQYLMZkH7AfqaUTO2ch+BhpXrnQhoPbQdrYK93Sp1G1juAjhGBXKb5uH8z5SPuxJLU++ugy7GYiEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fCzl4NPD; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715097499;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=iN5+TAR35lqisRhmEUIVe+XBdqZArxYl3xk4LC3xq68=;
	b=fCzl4NPDTcQMkhE3o9oGZpHJxjYXsB7dXocCC/t/HJ9QYmJMjqEKSsUKncT6DyMqNHL3l4
	sJtSuGQ6UTZjpfFOttFXKM7Vd6CnGvM/OWDkZjnX0hHtLGdjn3AHMp6ThE7h07aSt9zVhk
	dz2pJcdfuuxOJMEUduAREumH/Wm6tQo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-135-DYBDo6HCM9GHDhLJzKkOow-1; Tue, 07 May 2024 11:58:18 -0400
X-MC-Unique: DYBDo6HCM9GHDhLJzKkOow-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 05E801816EC5;
	Tue,  7 May 2024 15:58:18 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DD19E2141800;
	Tue,  7 May 2024 15:58:17 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [PATCH v2 00/17] KVM: x86/mmu: Page fault and MMIO cleanups
Date: Tue,  7 May 2024 11:58:00 -0400
Message-ID: <20240507155817.3951344-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6

This is an updated version of the series at
https://patchew.org/linux/20240228024147.41573-1-seanjc@google.com/
which has been used for SEV-SNP development, taking into account
all review comments.  Patch 8 is the only completely new patch
(and even then it had been posted together with the various
TDX/SNP prep series).

Here is an annotated git range-diff:

==============================================================================
KVM: x86/mmu: Exit to userspace with -EFAULT if private fault hits emulation
- tweak commit message, add comment

    @@ Commit message
         Exit to userspace with -EFAULT / KVM_EXIT_MEMORY_FAULT if a private fault
         triggers emulation of any kind, as KVM doesn't currently support emulating
         access to guest private memory.  Practically speaking, private faults and
    -    emulation are already mutually exclusive, but there are edge cases upon
    -    edge cases where KVM can return RET_PF_EMULATE, and adding one last check
    -    to harden against weird, unexpected combinations is inexpensive.
    +    emulation are already mutually exclusive, but there are many flow that
    +    can result in KVM returning RET_PF_EMULATE, and adding one last check
    +    to harden against weird, unexpected combinations and/or KVM bugs is
    +    inexpensive.
     
         Suggested-by: Yan Zhao <yan.y.zhao@intel.com>
         Signed-off-by: Sean Christopherson <seanjc@google.com>
    @@ arch/x86/kvm/mmu/mmu_internal.h: static inline int kvm_mmu_do_page_fault(struct
      	else
      		r = vcpu->arch.mmu->page_fault(vcpu, &fault);
      
    ++	/*
    ++	 * Not sure what's happening, but punt to userspace and hope that
    ++	 * they can fix it by changing memory to shared, or they can
    ++	 * provide a better error.
    ++	 */
     +	if (r == RET_PF_EMULATE && fault.is_private) {
    ++		pr_warn_ratelimited("kvm: unexpected emulation request on private memory\n");
     +		kvm_mmu_prepare_memory_fault_exit(vcpu, &fault);
     +		return -EFAULT;
     +	}


==============================================================================
KVM: x86: Remove separate "bit" defines for page fault error code masks
- do not use ilog2

    @@ Commit message
         just to see which flag corresponds to which bit is quite annoying, as is
         having to define two macros just to add recognition of a new flag.
     
    -    Use ilog2() to derive the bit in permission_fault(), the one function that
    -    actually needs the bit number (it does clever shifting to manipulate flags
    -    in order to avoid conditional branches).
    +    Use ternary operator to derive the bit in permission_fault(), the one
    +    function that actually needs the bit number as part of clever shifting
    +    to avoid conditional branches.  Generally the compiler is able to turn
    +    it into a conditional move, and if not it's not really a big deal.
     
         No functional change intended.
     
    @@ arch/x86/kvm/mmu.h: static inline u8 permission_fault(struct kvm_vcpu *vcpu, str
      	u64 implicit_access = access & PFERR_IMPLICIT_ACCESS;
      	bool not_smap = ((rflags & X86_EFLAGS_AC) | implicit_access) == X86_EFLAGS_AC;
     -	int index = (pfec + (not_smap << PFERR_RSVD_BIT)) >> 1;
    -+	int index = (pfec + (not_smap << ilog2(PFERR_RSVD_MASK))) >> 1;
    ++	int index = (pfec | (not_smap ? PFERR_RSVD_MASK : 0)) >> 1;
      	u32 errcode = PFERR_PRESENT_MASK;
      	bool fault;
      
     @@ arch/x86/kvm/mmu.h: static inline u8 permission_fault(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
    + 		pkru_bits = (vcpu->arch.pkru >> (pte_pkey * 2)) & 3;
      
      		/* clear present bit, replace PFEC.RSVD with ACC_USER_MASK. */
    - 		offset = (pfec & ~1) +
    +-		offset = (pfec & ~1) +
     -			((pte_access & PT_USER_MASK) << (PFERR_RSVD_BIT - PT_USER_SHIFT));
    -+			((pte_access & PT_USER_MASK) << (ilog2(PFERR_RSVD_MASK) - PT_USER_SHIFT));
    ++		offset = (pfec & ~1) | ((pte_access & PT_USER_MASK) ? PFERR_RSVD_MASK : 0);
      
      		pkru_bits &= mmu->pkru_mask >> offset;
      		errcode |= -pkru_bits & PFERR_PK_MASK;

==============================================================================
KVM: x86: Define more SEV+ page fault error bits/flags for #NPF
- match commit message to bits defined in header file

    @@ Commit message
         Define more #NPF error code flags that are relevant to SEV+ (mostly SNP)
         guests, as specified by the APM:
     
    +     * Bit 31 (RMP):   Set to 1 if the fault was caused due to an RMP check or a
    +                       VMPL check failure, 0 otherwise.
          * Bit 34 (ENC):   Set to 1 if the guest’s effective C-bit was 1, 0 otherwise.
          * Bit 35 (SIZEM): Set to 1 if the fault was caused by a size mismatch between
                            PVALIDATE or RMPADJUST and the RMP, 0 otherwise.
          * Bit 36 (VMPL):  Set to 1 if the fault was caused by a VMPL permission
                            check failure, 0 otherwise.
    -     * Bit 37 (SSS):   Set to VMPL permission mask SSS (bit 4) value if VmplSSS is
    -                       enabled.
     
         Note, the APM is *extremely* misleading, and strongly implies that the
         above flags can _only_ be set for #NPF exits from SNP guests.  That is a


==============================================================================
KVM: x86: Move synthetic PFERR_* sanity checks to SVM's #NPF handler
- add a description of PFERR_IMPLICIT_ACCESS

    @@ Commit message
         Add a compile-time assert in the legacy #PF handler to make sure that KVM-
         define flags are covered by its existing sanity check on the upper bits.
     
    +    Opportunistically add a description of PFERR_IMPLICIT_ACCESS, since we
    +    are removing the comment that defined it.
    +
         Signed-off-by: Sean Christopherson <seanjc@google.com>
    +    Reviewed-by: Kai Huang <kai.huang@intel.com>
    +    Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
         Message-ID: <20240228024147.41573-8-seanjc@google.com>
    +    Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
    +
    + ## arch/x86/include/asm/kvm_host.h ##
    +@@ arch/x86/include/asm/kvm_host.h: enum x86_intercept_stage;
    + #define PFERR_GUEST_ENC_MASK	BIT_ULL(34)
    + #define PFERR_GUEST_SIZEM_MASK	BIT_ULL(35)
    + #define PFERR_GUEST_VMPL_MASK	BIT_ULL(36)
    ++
    ++/*
    ++ * IMPLICIT_ACCESS is a KVM-defined flag used to correctly perform SMAP checks
    ++ * when emulating instructions that triggers implicit access.
    ++ */
    + #define PFERR_IMPLICIT_ACCESS	BIT_ULL(48)
    ++#define PFERR_SYNTHETIC_MASK	(PFERR_IMPLICIT_ACCESS)
    + 
    + #define PFERR_NESTED_GUEST_PAGE (PFERR_GUEST_PAGE_MASK |	\
    + 				 PFERR_WRITE_MASK |		\
     
      ## arch/x86/kvm/mmu/mmu.c ##
     @@ arch/x86/kvm/mmu/mmu.c: int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u64 error_code,
    - 	if (WARN_ON_ONCE(error_code >> 32))
    - 		error_code = lower_32_bits(error_code);
    + 		return -EFAULT;
    + #endif
      
     +	/* Ensure the above sanity check also covers KVM-defined flags. */
     +	BUILD_BUG_ON(lower_32_bits(PFERR_SYNTHETIC_MASK));

- move in front of the other synthetic page fault error code patches

==============================================================================
KVM: x86/mmu: WARN if upper 32 bits of legacy #PF error code are non-zero
  commit message copy editing

    @@ Commit message
         and even more explicitly in the SDM as VMCS.VM_EXIT_INTR_ERROR_CODE is a
         32-bit field.
     
    -    Simply drop the upper bits of hardware provides garbage, as spurious
    +    Simply drop the upper bits if hardware provides garbage, as spurious
         information should do no harm (though in all likelihood hardware is buggy
         and the kernel is doomed).
     
    @@ Commit message
         which in turn will allow deriving PFERR_PRIVATE_ACCESS from AMD's
         PFERR_GUEST_ENC_MASK without running afoul of the sanity check.
     
    -    Note, this also why Intel uses bit 15 for SGX (highest bit on Intel CPUs)
    +    Note, this is also why Intel uses bit 15 for SGX (highest bit on Intel CPUs)
         and AMD uses bit 31 for RMP (highest bit on AMD CPUs); using the highest
         bit minimizes the probability of a collision with the "other" vendor,
         without needing to plumb more bits through microcode.


==============================================================================
KVM: x86/mmu: Use synthetic page fault error code to indicate private faults
- patch reordering, no other changes

==============================================================================
KVM: x86/mmu: check for invalid async page faults involving private memory
- new patch coming from TDX/SNP prep series; test PFERR_PRIVATE_ACCESS, set arch.error_code

    @@ arch/x86/kvm/mmu/mmu.c: static u32 alloc_apf_token(struct kvm_vcpu *vcpu)
      	arch.token = alloc_apf_token(vcpu);
     -	arch.gfn = gfn;
     +	arch.gfn = fault->gfn;
    ++	arch.error_code = fault->error_code;
      	arch.direct_map = vcpu->arch.mmu->root_role.direct;
      	arch.cr3 = kvm_mmu_get_guest_pgd(vcpu, vcpu->arch.mmu);
      
    @@ arch/x86/kvm/mmu/mmu.c: static u32 alloc_apf_token(struct kvm_vcpu *vcpu)
      {
      	int r;
      
    -+	if (WARN_ON_ONCE(work->arch.error_code & PFERR_GUEST_ENC_MASK))
    ++	if (WARN_ON_ONCE(work->arch.error_code & PFERR_PRIVATE_ACCESS))
     +		return;
     +
      	if ((vcpu->arch.mmu->root_role.direct != work->arch.direct_map) ||


==============================================================================
KVM: x86/mmu: WARN and skip MMIO cache on private, reserved page faults
- exit to userspace if the wrong case happens, test PFERR_PRIVATE_ACCESS

    @@ Commit message
     
      ## arch/x86/kvm/mmu/mmu.c ##
     @@ arch/x86/kvm/mmu/mmu.c: int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 err
    - 		error_code |= PFERR_PRIVATE_ACCESS;
      
      	r = RET_PF_INVALID;
    --	if (unlikely(error_code & PFERR_RSVD_MASK)) {
    -+	if (unlikely((error_code & PFERR_RSVD_MASK) &&
    -+		     !WARN_ON_ONCE(error_code & PFERR_GUEST_ENC_MASK))) {
    + 	if (unlikely(error_code & PFERR_RSVD_MASK)) {
    ++		if (WARN_ON_ONCE(error_code & PFERR_PRIVATE_ACCESS))
    ++			return -EFAULT;
    ++
      		r = handle_mmio_page_fault(vcpu, cr2_or_gpa, direct);
      		if (r == RET_PF_EMULATE)
      			goto emulate;

==============================================================================
KVM: x86/mmu: Move private vs. shared check above slot validity checks
- add comment about use of mmu_invalidate_seq

    @@ arch/x86/kvm/mmu/mmu.c: static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, stru
      		return kvm_faultin_pfn_private(vcpu, fault);
      
     @@ arch/x86/kvm/mmu/mmu.c: static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
    + {
    + 	int ret;
    + 
    ++	/*
    ++	 * Note that the mmu_invalidate_seq also serves to detect a concurrent
    ++	 * change in attributes.  is_page_fault_stale() will detect an
    ++	 * invalidation relate to fault->fn and resume the guest without
    ++	 * installing a mapping in the page tables.
    ++	 */
      	fault->mmu_seq = vcpu->kvm->mmu_invalidate_seq;
      	smp_rmb();
      
     +	/*
    -+	 * Check for a private vs. shared mismatch *after* taking a snapshot of
    -+	 * mmu_invalidate_seq, as changes to gfn attributes are guarded by the
    -+	 * invalidation notifier.
    ++	 * Now that we have a snapshot of mmu_invalidate_seq we can check for a
    ++	 * private vs. shared mismatch.
     +	 */
     +	if (fault->is_private != kvm_mem_is_private(vcpu->kvm, fault->gfn)) {
     +		kvm_mmu_prepare_memory_fault_exit(vcpu, fault);



==============================================================================
KVM: x86/mmu: Move slot checks from __kvm_faultin_pfn() to kvm_faultin_pfn()
- differences in moved code, range-diff is unreadable


==============================================================================
KVM: x86/mmu: Handle no-slot faults at the beginning of kvm_faultin_pfn()
- remove unnecessary change

    @@ arch/x86/kvm/mmu/mmu.c: static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct
      		return kvm_handle_noslot_fault(vcpu, fault, access);
      
      	/*
    -
    - ## arch/x86/kvm/mmu/mmu_internal.h ##
    -@@ arch/x86/kvm/mmu/mmu_internal.h: struct kvm_page_fault {
    - 	/* The memslot containing gfn. May be NULL. */
    - 	struct kvm_memory_slot *slot;
    - 
    --	/* Outputs of kvm_faultin_pfn.  */
    -+	/* Outputs of kvm_faultin_pfn. */
    - 	unsigned long mmu_seq;
    - 	kvm_pfn_t pfn;
    - 	hva_t hva;


Isaku Yamahata (1):
  KVM: x86/mmu: Pass full 64-bit error code when handling page faults

Paolo Bonzini (1):
  KVM: x86/mmu: check for invalid async page faults involving private
    memory

Sean Christopherson (15):
  KVM: x86/mmu: Exit to userspace with -EFAULT if private fault hits
    emulation
  KVM: x86: Remove separate "bit" defines for page fault error code
    masks
  KVM: x86: Define more SEV+ page fault error bits/flags for #NPF
  KVM: x86: Move synthetic PFERR_* sanity checks to SVM's #NPF handler
  KVM: x86/mmu: WARN if upper 32 bits of legacy #PF error code are
    non-zero
  KVM: x86/mmu: Use synthetic page fault error code to indicate private
    faults
  KVM: x86/mmu: WARN and skip MMIO cache on private, reserved page
    faults
  KVM: x86/mmu: Move private vs. shared check above slot validity checks
  KVM: x86/mmu: Don't force emulation of L2 accesses to non-APIC
    internal slots
  KVM: x86/mmu: Explicitly disallow private accesses to emulated MMIO
  KVM: x86/mmu: Move slot checks from __kvm_faultin_pfn() to
    kvm_faultin_pfn()
  KVM: x86/mmu: Handle no-slot faults at the beginning of
    kvm_faultin_pfn()
  KVM: x86/mmu: Set kvm_page_fault.hva to KVM_HVA_ERR_BAD for "no slot"
    faults
  KVM: x86/mmu: Initialize kvm_page_fault's pfn and hva to error values
  KVM: x86/mmu: Sanity check that __kvm_faultin_pfn() doesn't create
    noslot pfns

 arch/x86/include/asm/kvm_host.h |  46 ++++----
 arch/x86/kvm/mmu.h              |   5 +-
 arch/x86/kvm/mmu/mmu.c          | 182 ++++++++++++++++++++------------
 arch/x86/kvm/mmu/mmu_internal.h |  28 ++++-
 arch/x86/kvm/mmu/mmutrace.h     |   2 +-
 arch/x86/kvm/svm/svm.c          |   9 ++
 6 files changed, 174 insertions(+), 98 deletions(-)

-- 
2.43.0


