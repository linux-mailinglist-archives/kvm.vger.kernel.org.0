Return-Path: <kvm+bounces-69454-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OJGAAV61emma9QEAu9opvQ
	(envelope-from <kvm+bounces-69454-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 02:18:22 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 55F8EAA984
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 02:18:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3850B3076EEB
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 01:15:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51A8C33123A;
	Thu, 29 Jan 2026 01:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MLX3OaMZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87F9D32AAA4
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 01:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769649340; cv=none; b=r98bJ3B2up9qMnFFxeC0X16kkDiVMNBte26P1CAsrbcgK41wpjUBciVBRSdC3vZIgbnuTUMmhQ7p6hyfMg9g0yyQNbVy7M0DY/qCNINsutc4AxpcLuynA0K1MLTvJoM5PQOOsGIv71swQGBv5RjMKEGrLIhnEXH7ilGZlVyoUKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769649340; c=relaxed/simple;
	bh=P8qsQaiuZL+h7L+tAAdynSCmTDEjnF5aicywFGbF+f4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DyaieWMBG7lLW2x49s3dGtO0gga1fuYBaD5QSC5P1+ETtQz8AP5u0fq2SrvKDyQPgii12pmoGrQqFQR3vxO8d3AtJvzcjQDfld1acLyVX2+fVfG/A+aovcuIqnjzfLfLr3BXwBttomV5p7pMt2rbzv3KKr+fK0DmHBa36rRfsq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MLX3OaMZ; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c551e6fe4b4so228839a12.3
        for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 17:15:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769649337; x=1770254137; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=pQCejTr0vCZl81GKWwdB4BKHKeMCfpmuFrgxzwPsDWQ=;
        b=MLX3OaMZsd1x+Dr8bv/oDSDCV9VQsrnpASyMyf9vmk8FVw+CL/KZcNo0d01wm/tOdm
         O+6rJermk6khzhsHnh9J5LPIYv1ryVBT0kgKMDW1vxR0YMJ1VKLGHK6ouIbm5gucHSEr
         bcETH6xOJVlet2o8eE56euryRwTlbpMdckpvxJC7rSIhTUXd9wa1FQKdfNkLYSn5s1Ln
         JB5WkN1d3Renh6yPKqj3ztXrGkglWtT0pQU/J/e6xAdwCBB7ovJlVZ2nwPAI6+45YulV
         JjteZmR/eTLOvu5d+fO42MMtqsyA6CnTvN9rX4Gx5aEBIqH3PYBZDiPxdKOQkXTDis7P
         WDhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769649337; x=1770254137;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pQCejTr0vCZl81GKWwdB4BKHKeMCfpmuFrgxzwPsDWQ=;
        b=FqeTs1k2f8+C3+47sLSk4jqpVqOPL+DVyOHdPhrOP+d966oiKxET1jTdpxHC4X9DLW
         /J/v6tCOMgBx04bfbdP6Y2R+rw76RlilxOvEL+qTdUWBntuWaJEn/lu4INYNrdw6brTx
         9AhoqkV9Z1IkoDk+DaIFWYUSwaLgJvE7pMgxbRFpqyPFeMEhWS+JOjfedhP0VbIF7hqU
         xw9UQq8xC1Ek3DcrpIWLKz5qZlk/99aASwkbBtVfMkw21D8ZhhjYbbXzOA/MY5DW1loK
         XOXRtw0Cb1nf4zimjzDKAnQ6JjUYvfjm0yqzrErq249PRJR5ys+eqIrPXMNdUhmdmEU2
         uVIA==
X-Forwarded-Encrypted: i=1; AJvYcCWmSIAogM2tm0//UAYa146lsOJm3XMLNrnZhOzEIzMOtpLCaOJSXhCQJXW4w3GfG/BFPpM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzwKsgJtSm4NSo/2jB7pEmd7dgtKamrJ3slBEUxT8gSIwY3TdBw
	4lRVExVlxdxOpYLxr3dIT87cvKzx56AUst/eCYpjRydeIt/ZI62NAUyYPdA4NUZR2eZiOygSqEs
	Yp+1OaA==
X-Received: from pgg11.prod.google.com ([2002:a05:6a02:4d8b:b0:c65:b239:37ed])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:a106:b0:35d:d477:a7f3
 with SMTP id adf61e73a8af0-38ec62ddca8mr6620267637.20.1769649336815; Wed, 28
 Jan 2026 17:15:36 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 28 Jan 2026 17:14:37 -0800
In-Reply-To: <20260129011517.3545883-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260129011517.3545883-1-seanjc@google.com>
X-Mailer: git-send-email 2.53.0.rc1.217.geba53bf80e-goog
Message-ID: <20260129011517.3545883-6-seanjc@google.com>
Subject: [RFC PATCH v5 05/45] KVM: TDX: Drop kvm_x86_ops.link_external_spt(),
 use .set_external_spte() for all
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Kiryl Shutsemau <kas@kernel.org>, Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev, 
	kvm@vger.kernel.org, Kai Huang <kai.huang@intel.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	Vishal Annapurve <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Sagi Shahar <sagis@google.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69454-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[20];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	HAS_REPLYTO(0.00)[seanjc@google.com];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: 55F8EAA984
X-Rspamd-Action: no action

Drop the dedicated .link_external_spt() for linking non-leaf S-EPT pages,
and instead funnel everything through .set_external_spte().  Using separate
hooks doesn't help prevent TDP MMU details from bleeding into TDX, and vice
versa; to the contrary, dedicated callbacks will result in _more_ pollution
when hugepage support is added, e.g. will require the TDP MMU to know
details about the splitting rules for TDX that aren't all that relevant to
the TDP MMU.

Ideally, KVM would provide a single pair of hooks to set S-EPT entries,
one hook for setting SPTEs under write-lock and another for settings SPTEs
under read-lock (e.g. to ensure the entire operation is "atomic", to allow
for failure, etc.).  Sadly, TDX's requirement that all child S-EPT entries
are removed before the parent makes that impractical: the TDP MMU
deliberately prunes non-leaf SPTEs and _then_ processes its children, thus
making it quite important for the TDP MMU to differentiate between zapping
leaf and non-leaf S-EPT entries.

However, that's the _only_ case that's truly special, and even that case
could be shoehorned into a single hook; it's just wouldn't be a net
positive.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  1 -
 arch/x86/include/asm/kvm_host.h    |  3 --
 arch/x86/kvm/mmu/tdp_mmu.c         | 37 +++---------------
 arch/x86/kvm/vmx/tdx.c             | 61 ++++++++++++++++++++----------
 4 files changed, 48 insertions(+), 54 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index c18a033bee7e..57eb1f4832ae 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -94,7 +94,6 @@ KVM_X86_OP_OPTIONAL_RET0(set_tss_addr)
 KVM_X86_OP_OPTIONAL_RET0(set_identity_map_addr)
 KVM_X86_OP_OPTIONAL_RET0(get_mt_mask)
 KVM_X86_OP(load_mmu_pgd)
-KVM_X86_OP_OPTIONAL_RET0(link_external_spt)
 KVM_X86_OP_OPTIONAL_RET0(set_external_spte)
 KVM_X86_OP_OPTIONAL_RET0(free_external_spt)
 KVM_X86_OP_OPTIONAL(remove_external_spte)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index e441f270f354..d12ca0f8a348 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1853,9 +1853,6 @@ struct kvm_x86_ops {
 	void (*load_mmu_pgd)(struct kvm_vcpu *vcpu, hpa_t root_hpa,
 			     int root_level);
 
-	/* Update external mapping with page table link. */
-	int (*link_external_spt)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
-				void *external_spt);
 	/* Update the external page table from spte getting set. */
 	int (*set_external_spte)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
 				 u64 mirror_spte);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 0feda295859a..56ad056e6042 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -495,31 +495,17 @@ static void handle_removed_pt(struct kvm *kvm, tdp_ptep_t pt, bool shared)
 	call_rcu(&sp->rcu_head, tdp_mmu_free_sp_rcu_callback);
 }
 
-static void *get_external_spt(gfn_t gfn, u64 new_spte, int level)
-{
-	if (is_shadow_present_pte(new_spte) && !is_last_spte(new_spte, level)) {
-		struct kvm_mmu_page *sp = spte_to_child_sp(new_spte);
-
-		WARN_ON_ONCE(sp->role.level + 1 != level);
-		WARN_ON_ONCE(sp->gfn != gfn);
-		return sp->external_spt;
-	}
-
-	return NULL;
-}
-
 static int __must_check set_external_spte_present(struct kvm *kvm, tdp_ptep_t sptep,
 						 gfn_t gfn, u64 *old_spte,
 						 u64 new_spte, int level)
 {
-	bool was_present = is_shadow_present_pte(*old_spte);
-	bool is_present = is_shadow_present_pte(new_spte);
-	bool is_leaf = is_present && is_last_spte(new_spte, level);
-	int ret = 0;
-
-	KVM_BUG_ON(was_present, kvm);
+	int ret;
 
 	lockdep_assert_held(&kvm->mmu_lock);
+
+	if (KVM_BUG_ON(is_shadow_present_pte(*old_spte), kvm))
+		return -EIO;
+
 	/*
 	 * We need to lock out other updates to the SPTE until the external
 	 * page table has been modified. Use FROZEN_SPTE similar to
@@ -528,18 +514,7 @@ static int __must_check set_external_spte_present(struct kvm *kvm, tdp_ptep_t sp
 	if (!try_cmpxchg64(rcu_dereference(sptep), old_spte, FROZEN_SPTE))
 		return -EBUSY;
 
-	/*
-	 * Use different call to either set up middle level
-	 * external page table, or leaf.
-	 */
-	if (is_leaf) {
-		ret = kvm_x86_call(set_external_spte)(kvm, gfn, level, new_spte);
-	} else {
-		void *external_spt = get_external_spt(gfn, new_spte, level);
-
-		KVM_BUG_ON(!external_spt, kvm);
-		ret = kvm_x86_call(link_external_spt)(kvm, gfn, level, external_spt);
-	}
+	ret = kvm_x86_call(set_external_spte)(kvm, gfn, level, new_spte);
 	if (ret)
 		__kvm_tdp_mmu_write_spte(sptep, *old_spte);
 	else
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 5688c77616e3..30494f9ceb31 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1664,18 +1664,58 @@ static int tdx_mem_page_aug(struct kvm *kvm, gfn_t gfn,
 	return 0;
 }
 
+static struct page *tdx_spte_to_external_spt(struct kvm *kvm, gfn_t gfn,
+					     u64 new_spte, enum pg_level level)
+{
+	struct kvm_mmu_page *sp = spte_to_child_sp(new_spte);
+
+	if (KVM_BUG_ON(!sp->external_spt, kvm) ||
+	    KVM_BUG_ON(sp->role.level + 1 != level, kvm) ||
+	    KVM_BUG_ON(sp->gfn != gfn, kvm))
+		return NULL;
+
+	return virt_to_page(sp->external_spt);
+}
+
+static int tdx_sept_link_private_spt(struct kvm *kvm, gfn_t gfn,
+				     enum pg_level level, u64 mirror_spte)
+{
+	gpa_t gpa = gfn_to_gpa(gfn);
+	u64 err, entry, level_state;
+	struct page *external_spt;
+
+	external_spt = tdx_spte_to_external_spt(kvm, gfn, mirror_spte, level);
+	if (!external_spt)
+		return -EIO;
+
+	err = tdh_mem_sept_add(&to_kvm_tdx(kvm)->td, gpa, level, external_spt,
+			       &entry, &level_state);
+	if (unlikely(tdx_operand_busy(err)))
+		return -EBUSY;
+
+	if (TDX_BUG_ON_2(err, TDH_MEM_SEPT_ADD, entry, level_state, kvm))
+		return -EIO;
+
+	return 0;
+}
+
 static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 				     enum pg_level level, u64 mirror_spte)
 {
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
 	kvm_pfn_t pfn = spte_to_pfn(mirror_spte);
 
+	if (KVM_BUG_ON(!is_shadow_present_pte(mirror_spte), kvm))
+		return -EIO;
+
+	if (!is_last_spte(mirror_spte, level))
+		return tdx_sept_link_private_spt(kvm, gfn, level, mirror_spte);
+
 	/* TODO: handle large pages. */
 	if (KVM_BUG_ON(level != PG_LEVEL_4K, kvm))
 		return -EIO;
 
-	WARN_ON_ONCE(!is_shadow_present_pte(mirror_spte) ||
-		     (mirror_spte & VMX_EPT_RWX_MASK) != VMX_EPT_RWX_MASK);
+	WARN_ON_ONCE((mirror_spte & VMX_EPT_RWX_MASK) != VMX_EPT_RWX_MASK);
 
 	/*
 	 * Ensure pre_fault_allowed is read by kvm_arch_vcpu_pre_fault_memory()
@@ -1695,23 +1735,7 @@ static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 	return tdx_mem_page_aug(kvm, gfn, level, pfn);
 }
 
-static int tdx_sept_link_private_spt(struct kvm *kvm, gfn_t gfn,
-				     enum pg_level level, void *private_spt)
-{
-	gpa_t gpa = gfn_to_gpa(gfn);
-	struct page *page = virt_to_page(private_spt);
-	u64 err, entry, level_state;
 
-	err = tdh_mem_sept_add(&to_kvm_tdx(kvm)->td, gpa, level, page, &entry,
-			       &level_state);
-	if (unlikely(tdx_operand_busy(err)))
-		return -EBUSY;
-
-	if (TDX_BUG_ON_2(err, TDH_MEM_SEPT_ADD, entry, level_state, kvm))
-		return -EIO;
-
-	return 0;
-}
 
 /*
  * Ensure shared and private EPTs to be flushed on all vCPUs.
@@ -3592,7 +3616,6 @@ void __init tdx_hardware_setup(void)
 	 */
 	vt_x86_ops.vm_size = max_t(unsigned int, vt_x86_ops.vm_size, sizeof(struct kvm_tdx));
 
-	vt_x86_ops.link_external_spt = tdx_sept_link_private_spt;
 	vt_x86_ops.set_external_spte = tdx_sept_set_private_spte;
 	vt_x86_ops.free_external_spt = tdx_sept_free_private_spt;
 	vt_x86_ops.remove_external_spte = tdx_sept_remove_private_spte;
-- 
2.53.0.rc1.217.geba53bf80e-goog


