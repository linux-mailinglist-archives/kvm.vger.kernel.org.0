Return-Path: <kvm+bounces-25587-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 95D64966D3C
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2024 02:16:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4E086284D8E
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2024 00:16:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA2BD17999;
	Sat, 31 Aug 2024 00:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FotemT0a"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 460BBFC0C
	for <kvm@vger.kernel.org>; Sat, 31 Aug 2024 00:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725063348; cv=none; b=jIIiD1+cILtFz/JuNzxgk34vIQFfxBmVSsqtkEkMW8J/2EMheYKdeoLVWlRlQ5X7yZU188C7b63Jk9bZlC8FM+FOVhuFtcbtBHYISToiNMSVWcLpeolgTIHfbYJygipRdW2uNIRluC5Cw+dvZ1RSIWRU1gjOwgOYxBBi0D+W3Wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725063348; c=relaxed/simple;
	bh=0S1/EC5bIW7JtKKmJwoso0teGFo94sSYh6FcpWHE3qM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fb/CBVPCpQ1QkQdlB5rJlb1WZ2/ITq2ITYgBPcBDMxVyI5NtLqJuJ2gtqj3JVKJURvAb+3LLyr8s4ltLzrtqxoXZG54rUxmxYRL1PaxDxjwkEn2ngBxKDFDHRyxePpWjpR3J+/YYsCwFI2HnOXfUv0HPbIJZucN4RLvQQUyuLPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FotemT0a; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1ff24acb60dso23025085ad.0
        for <kvm@vger.kernel.org>; Fri, 30 Aug 2024 17:15:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725063347; x=1725668147; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=XxaFoHu5A4IbMNy5peQQugHxw56QXCkNO6VTfRtkiXo=;
        b=FotemT0aYrkpUXJK3O2KZVdcObrvQw+Bo1XoSIkxcl9m4ZxgL2WOJeMFodlDRQ1hHs
         EUjtcfL2XEApQq5gEk9iY+gx5vdae2koFcfDzBtuHlBbz0PE7GdJSMeJB0nPzO56ZDRI
         k7GD3xBJlG6bkIlU1m/PgVDcZs5Jvz/3Ly/6qJYZhxAvHYh+6aLUeqVds63fHpMhERA3
         ceG21gxPhoFq/8lJOq7LxUWDOr69aFa7As1q0ou3ClYQcIdqDVIcviRT5Ss2Lx7JT7Om
         XQniYdthN2DFUseIEqJFHu7UKJgOYaxuH02LsXe9XBYG+7LtuJSmH67H8a8fbRM8Rp0n
         cyEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725063347; x=1725668147;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XxaFoHu5A4IbMNy5peQQugHxw56QXCkNO6VTfRtkiXo=;
        b=StqqFhIrWsFNGzT7K8hnwJ5IPB/e961qoFpKBXUekZRDBFSdIi3e6H6BiN1jqbdBi+
         22/QqmVg+DD5C8bPl7wcQX3T8TFB+9HJ1m5Tjl8K1oi/jgyns8XmGX9qG6PdyydjddgD
         BlUEO3WsU2vMwo2qBzFwpSeCjANUqnBvSlhki3OS/iyFzNwJAkogJpFc9ba6wGVOHIUr
         GPEQN51MJsvQRNBCsB4ujT3i/IhHshlmanQon0dGd+Pa+t2Jtg0+asLYKp7nwOr9aGa1
         ymDFSHqluHHyVwuQ40B10bYFfgqiQ4GgpOT3aAC2FiII9zWiyta/SMXzkyvTDjiJiF/X
         9QFA==
X-Gm-Message-State: AOJu0YxiyOXTittsJEON6lw03wdrcZNddvS3slei2ax6WOq2HyP/q9Ie
	uGKFxmV28d5Iodfqlod2xFueRC0Mx/jRlKlYZ2H5XlYYcfiCcv3k2KjVXcxQU5m0iFGmskpMLsU
	auA==
X-Google-Smtp-Source: AGHT+IGKNozOb7ZK1aStUW9JhhyXqjyJ0ZBSiMSMAq640/pmOcPj4mJYAE5X8noIc6nc/DNjGrR2ZttuBmw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:11c3:b0:1fa:1a78:b5bc with SMTP id
 d9443c01a7336-20527228c4emr2748435ad.0.1725063346583; Fri, 30 Aug 2024
 17:15:46 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 30 Aug 2024 17:15:18 -0700
In-Reply-To: <20240831001538.336683-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240831001538.336683-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.469.g59c65b2a67-goog
Message-ID: <20240831001538.336683-4-seanjc@google.com>
Subject: [PATCH v2 03/22] KVM: x86/mmu: Trigger unprotect logic only on
 write-protection page faults
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yuan Yao <yuan.yao@intel.com>, Yuan Yao <yuan.yao@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

Trigger KVM's various "unprotect gfn" paths if and only if the page fault
was a write to a write-protected gfn.  To do so, add a new page fault
return code, RET_PF_WRITE_PROTECTED, to explicitly and precisely track
such page faults.

If a page fault requires emulation for any MMIO (or any reason besides
write-protection), trying to unprotect the gfn is pointless and risks
putting the vCPU into an infinite loop.  E.g. KVM will put the vCPU into
an infinite loop if the vCPU manages to trigger MMIO on a page table walk.

Fixes: 147277540bbc ("kvm: svm: Add support for additional SVM NPF error codes")
Reviewed-by: Yuan Yao <yuan.yao@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c          | 75 +++++++++++++++++++--------------
 arch/x86/kvm/mmu/mmu_internal.h |  3 ++
 arch/x86/kvm/mmu/mmutrace.h     |  1 +
 arch/x86/kvm/mmu/paging_tmpl.h  |  2 +-
 arch/x86/kvm/mmu/tdp_mmu.c      |  6 +--
 5 files changed, 50 insertions(+), 37 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 4ca01256143e..57692d873f76 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2896,10 +2896,8 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
 		trace_kvm_mmu_set_spte(level, gfn, sptep);
 	}
 
-	if (wrprot) {
-		if (write_fault)
-			ret = RET_PF_EMULATE;
-	}
+	if (wrprot && write_fault)
+		ret = RET_PF_WRITE_PROTECTED;
 
 	if (flush)
 		kvm_flush_remote_tlbs_gfn(vcpu->kvm, gfn, level);
@@ -4531,7 +4529,7 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 		return RET_PF_RETRY;
 
 	if (page_fault_handle_page_track(vcpu, fault))
-		return RET_PF_EMULATE;
+		return RET_PF_WRITE_PROTECTED;
 
 	r = fast_page_fault(vcpu, fault);
 	if (r != RET_PF_INVALID)
@@ -4624,7 +4622,7 @@ static int kvm_tdp_mmu_page_fault(struct kvm_vcpu *vcpu,
 	int r;
 
 	if (page_fault_handle_page_track(vcpu, fault))
-		return RET_PF_EMULATE;
+		return RET_PF_WRITE_PROTECTED;
 
 	r = fast_page_fault(vcpu, fault);
 	if (r != RET_PF_INVALID)
@@ -4703,6 +4701,7 @@ static int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code,
 	switch (r) {
 	case RET_PF_FIXED:
 	case RET_PF_SPURIOUS:
+	case RET_PF_WRITE_PROTECTED:
 		return 0;
 
 	case RET_PF_EMULATE:
@@ -5954,6 +5953,40 @@ static bool is_write_to_guest_page_table(u64 error_code)
 	return (error_code & mask) == mask;
 }
 
+static int kvm_mmu_write_protect_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
+				       u64 error_code, int *emulation_type)
+{
+	bool direct = vcpu->arch.mmu->root_role.direct;
+
+	/*
+	 * Before emulating the instruction, check if the error code
+	 * was due to a RO violation while translating the guest page.
+	 * This can occur when using nested virtualization with nested
+	 * paging in both guests. If true, we simply unprotect the page
+	 * and resume the guest.
+	 */
+	if (direct && is_write_to_guest_page_table(error_code)) {
+		kvm_mmu_unprotect_page(vcpu->kvm, gpa_to_gfn(cr2_or_gpa));
+		return RET_PF_RETRY;
+	}
+
+	/*
+	 * The gfn is write-protected, but if emulation fails we can still
+	 * optimistically try to just unprotect the page and let the processor
+	 * re-execute the instruction that caused the page fault.  Do not allow
+	 * retrying MMIO emulation, as it's not only pointless but could also
+	 * cause us to enter an infinite loop because the processor will keep
+	 * faulting on the non-existent MMIO address.  Retrying an instruction
+	 * from a nested guest is also pointless and dangerous as we are only
+	 * explicitly shadowing L1's page tables, i.e. unprotecting something
+	 * for L1 isn't going to magically fix whatever issue cause L2 to fail.
+	 */
+	if (!mmio_info_in_cache(vcpu, cr2_or_gpa, direct) && !is_guest_mode(vcpu))
+		*emulation_type |= EMULTYPE_ALLOW_RETRY_PF;
+
+	return RET_PF_EMULATE;
+}
+
 int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 error_code,
 		       void *insn, int insn_len)
 {
@@ -5999,6 +6032,10 @@ int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 err
 	if (r < 0)
 		return r;
 
+	if (r == RET_PF_WRITE_PROTECTED)
+		r = kvm_mmu_write_protect_fault(vcpu, cr2_or_gpa, error_code,
+						&emulation_type);
+
 	if (r == RET_PF_FIXED)
 		vcpu->stat.pf_fixed++;
 	else if (r == RET_PF_EMULATE)
@@ -6009,32 +6046,6 @@ int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 err
 	if (r != RET_PF_EMULATE)
 		return 1;
 
-	/*
-	 * Before emulating the instruction, check if the error code
-	 * was due to a RO violation while translating the guest page.
-	 * This can occur when using nested virtualization with nested
-	 * paging in both guests. If true, we simply unprotect the page
-	 * and resume the guest.
-	 */
-	if (vcpu->arch.mmu->root_role.direct &&
-	    is_write_to_guest_page_table(error_code)) {
-		kvm_mmu_unprotect_page(vcpu->kvm, gpa_to_gfn(cr2_or_gpa));
-		return 1;
-	}
-
-	/*
-	 * vcpu->arch.mmu.page_fault returned RET_PF_EMULATE, but we can still
-	 * optimistically try to just unprotect the page and let the processor
-	 * re-execute the instruction that caused the page fault.  Do not allow
-	 * retrying MMIO emulation, as it's not only pointless but could also
-	 * cause us to enter an infinite loop because the processor will keep
-	 * faulting on the non-existent MMIO address.  Retrying an instruction
-	 * from a nested guest is also pointless and dangerous as we are only
-	 * explicitly shadowing L1's page tables, i.e. unprotecting something
-	 * for L1 isn't going to magically fix whatever issue cause L2 to fail.
-	 */
-	if (!mmio_info_in_cache(vcpu, cr2_or_gpa, direct) && !is_guest_mode(vcpu))
-		emulation_type |= EMULTYPE_ALLOW_RETRY_PF;
 emulate:
 	return x86_emulate_instruction(vcpu, cr2_or_gpa, emulation_type, insn,
 				       insn_len);
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 1721d97743e9..50d2624111f8 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -258,6 +258,8 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
  * RET_PF_CONTINUE: So far, so good, keep handling the page fault.
  * RET_PF_RETRY: let CPU fault again on the address.
  * RET_PF_EMULATE: mmio page fault, emulate the instruction directly.
+ * RET_PF_WRITE_PROTECTED: the gfn is write-protected, either unprotected the
+ *                         gfn and retry, or emulate the instruction directly.
  * RET_PF_INVALID: the spte is invalid, let the real page fault path update it.
  * RET_PF_FIXED: The faulting entry has been fixed.
  * RET_PF_SPURIOUS: The faulting entry was already fixed, e.g. by another vCPU.
@@ -274,6 +276,7 @@ enum {
 	RET_PF_CONTINUE = 0,
 	RET_PF_RETRY,
 	RET_PF_EMULATE,
+	RET_PF_WRITE_PROTECTED,
 	RET_PF_INVALID,
 	RET_PF_FIXED,
 	RET_PF_SPURIOUS,
diff --git a/arch/x86/kvm/mmu/mmutrace.h b/arch/x86/kvm/mmu/mmutrace.h
index 195d98bc8de8..f35a830ce469 100644
--- a/arch/x86/kvm/mmu/mmutrace.h
+++ b/arch/x86/kvm/mmu/mmutrace.h
@@ -57,6 +57,7 @@
 TRACE_DEFINE_ENUM(RET_PF_CONTINUE);
 TRACE_DEFINE_ENUM(RET_PF_RETRY);
 TRACE_DEFINE_ENUM(RET_PF_EMULATE);
+TRACE_DEFINE_ENUM(RET_PF_WRITE_PROTECTED);
 TRACE_DEFINE_ENUM(RET_PF_INVALID);
 TRACE_DEFINE_ENUM(RET_PF_FIXED);
 TRACE_DEFINE_ENUM(RET_PF_SPURIOUS);
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 69941cebb3a8..a722a3c96af9 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -805,7 +805,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 
 	if (page_fault_handle_page_track(vcpu, fault)) {
 		shadow_page_table_clear_flood(vcpu, fault->addr);
-		return RET_PF_EMULATE;
+		return RET_PF_WRITE_PROTECTED;
 	}
 
 	r = mmu_topup_memory_caches(vcpu, true);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 3c55955bcaf8..3b996c1fdaab 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1046,10 +1046,8 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
 	 * protected, emulation is needed. If the emulation was skipped,
 	 * the vCPU would have the same fault again.
 	 */
-	if (wrprot) {
-		if (fault->write)
-			ret = RET_PF_EMULATE;
-	}
+	if (wrprot && fault->write)
+		ret = RET_PF_WRITE_PROTECTED;
 
 	/* If a MMIO SPTE is installed, the MMIO will need to be emulated. */
 	if (unlikely(is_mmio_spte(vcpu->kvm, new_spte))) {
-- 
2.46.0.469.g59c65b2a67-goog


