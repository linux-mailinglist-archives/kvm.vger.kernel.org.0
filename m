Return-Path: <kvm+bounces-33775-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 264229F1701
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 21:03:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 32D56160846
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 20:03:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8087C1F6661;
	Fri, 13 Dec 2024 19:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BN/KKuJJ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C1F91F5400
	for <kvm@vger.kernel.org>; Fri, 13 Dec 2024 19:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734119858; cv=none; b=pdGwARRTyv+8Iwejyzd0GXADipjxd/tHpTVSlyfdHGVIskbew41ALnKV23HQsOyq37NmHDoNfKK1uCEt4MxaTrghQ+EKrbm2pGm4y4zKd+k2wLvzJhtEsnWXvfxdGGsroQNqA/PTBe7NiJf/lDTrJU+yV+lefI/10iav/6T1wJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734119858; c=relaxed/simple;
	bh=mjfxOEXfCpvxzXZwsm7LtxbdD7uPWESX2balfnJL7sE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FP5k9Jntt4W3YPTHl53XtAcITTQBkUqjiD/oeNgovnwoq5IfzyJR+8dWkO/skPg1kXumt48wBuHovHLDLJvW3gY+tqyfdfZGCH13DXQAVEYShhNLKer+yPVYQkozB2yKLnJpGuMAODNcQ/YSdfSiqvNitQNX+AxIEszfd6ZgLUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BN/KKuJJ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734119855;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mxUcb7oEqtXsCOXTqrmeA8imQXmp/55AQphr/HRenrY=;
	b=BN/KKuJJNQpmsCAIovgWSh1qEmt6ageJT3aTGw91O/H0zYdPX4eUIRbT0iCFJRJNCI4oRl
	zKmkvoOEyOY2xVZUKT4MUlPOgIwFxhr3Inc7/hDEUvIP+orcFxbecvUaIHOUUH/rrOR+cS
	7LAIH8feaIans9f5/ayiOZh1f26ljhc=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-473-5ywnCW4KPUii0_LFUQeiLA-1; Fri,
 13 Dec 2024 14:57:32 -0500
X-MC-Unique: 5ywnCW4KPUii0_LFUQeiLA-1
X-Mimecast-MFC-AGG-ID: 5ywnCW4KPUii0_LFUQeiLA
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5FCB71956089;
	Fri, 13 Dec 2024 19:57:31 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3D5FA1956089;
	Fri, 13 Dec 2024 19:57:30 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: yan.y.zhao@intel.com,
	isaku.yamahata@intel.com,
	binbin.wu@linux.intel.com,
	rick.p.edgecombe@intel.com,
	Kai Huang <kai.huang@intel.com>
Subject: [PATCH 14/18] KVM: x86/tdp_mmu: Propagate building mirror page tables
Date: Fri, 13 Dec 2024 14:57:07 -0500
Message-ID: <20241213195711.316050-15-pbonzini@redhat.com>
In-Reply-To: <20241213195711.316050-1-pbonzini@redhat.com>
References: <20241213195711.316050-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

From: Isaku Yamahata <isaku.yamahata@intel.com>

Integrate hooks for mirroring page table operations for cases where TDX
will set PTEs or link page tables.

Like other Coco technologies, TDX has the concept of private and shared
memory. For TDX the private and shared mappings are managed on separate
EPT roots. The private half is managed indirectly through calls into a
protected runtime environment called the TDX module, where the shared half
is managed within KVM in normal page tables.

Since calls into the TDX module are relatively slow, walking private page
tables by making calls into the TDX module would not be efficient. Because
of this, previous changes have taught the TDP MMU to keep a mirror root,
which is separate, unmapped TDP root that private operations can be
directed to. Currently this root is disconnected from any actual guest
mapping. Now add plumbing to propagate changes to the "external" page
tables being mirrored. Just create the x86_ops for now, leave plumbing the
operations into the TDX module for future patches.

Add two operations for setting up external page tables, one for linking
new page tables and one for setting leaf PTEs. Don't add any op for
configuring the root PFN, as TDX handles this itself. Don't provide a
way to set permissions on the PTEs also, as TDX doesn't support it.

This results in MMU "mirroring" support that is very targeted towards TDX.
Since it is likely there will be no other user, the main benefit of making
the support generic is to keep TDX specific *looking* code outside of the
MMU. As a generic feature it will make enough sense from TDX's
perspective. For developers unfamiliar with TDX arch it can express the
general concepts such that they can continue to work in the code.

TDX MMU support will exclude certain MMU operations, so only plug in the
mirroring x86 ops where they will be needed. For setting/linking, only
hook tdp_mmu_set_spte_atomic() which is used for mapping and linking
PTs. Don't bother hooking tdp_mmu_iter_set_spte() as it is only used for
setting PTEs in operations unsupported by TDX: splitting huge pages and
write protecting. Sprinkle KVM_BUG_ON()s to document as code that these
paths are not supported for mirrored page tables. For zapping operations,
leave those for near future changes.

Many operations in the TDP MMU depend on atomicity of the PTE update.
While the mirror PTE on KVM's side can be updated atomically, the update
that happens inside the external operations (S-EPT updates via TDX module
call) can't happen atomically with the mirror update. The following race
could result during two vCPU's populating private memory:

* vcpu 1: atomically update 2M level mirror EPT entry to be present
* vcpu 2: read 2M level EPT entry that is present
* vcpu 2: walk down into 4K level EPT
* vcpu 2: atomically update 4K level mirror EPT entry to be present
* vcpu 2: set_exterma;_spte() to update 4K secure EPT entry => error
          because 2M secure EPT entry is not populated yet
* vcpu 1: link_external_spt() to update 2M secure EPT entry

Prevent this by setting the mirror PTE to FROZEN_SPTE while the reflect
operations are performed. Only write the actual mirror PTE value once the
reflect operations have completed. When trying to set a PTE to present and
encountering a frozen SPTE, retry the fault.

By doing this the race is prevented as follows:
* vcpu 1: atomically update 2M level EPT entry to be FROZEN_SPTE
* vcpu 2: read 2M level EPT entry that is FROZEN_SPTE
* vcpu 2: find that the EPT entry is frozen
          abandon page table walk to resume guest execution
* vcpu 1: link_external_spt() to update 2M secure EPT entry
* vcpu 1: atomically update 2M level EPT entry to be present (unfreeze)
* vcpu 2: resume guest execution
          Depending on vcpu 1 state, vcpu 2 may result in EPT violation
          again or make progress on guest execution

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Co-developed-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
Co-developed-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
Co-developed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Message-ID: <20240718211230.1492011-15-rick.p.edgecombe@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  2 +
 arch/x86/include/asm/kvm_host.h    |  7 +++
 arch/x86/kvm/mmu/tdp_mmu.c         | 94 ++++++++++++++++++++++++++----
 3 files changed, 92 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 5aff7222e40f..dbbdaa8586ab 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -94,6 +94,8 @@ KVM_X86_OP_OPTIONAL_RET0(set_tss_addr)
 KVM_X86_OP_OPTIONAL_RET0(set_identity_map_addr)
 KVM_X86_OP_OPTIONAL_RET0(get_mt_mask)
 KVM_X86_OP(load_mmu_pgd)
+KVM_X86_OP_OPTIONAL(link_external_spt)
+KVM_X86_OP_OPTIONAL(set_external_spte)
 KVM_X86_OP(has_wbinvd_exit)
 KVM_X86_OP(get_l2_tsc_offset)
 KVM_X86_OP(get_l2_tsc_multiplier)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index dc8e4460a4bc..b973fda8528a 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1758,6 +1758,13 @@ struct kvm_x86_ops {
 	void (*load_mmu_pgd)(struct kvm_vcpu *vcpu, hpa_t root_hpa,
 			     int root_level);
 
+	/* Update external mapping with page table link. */
+	int (*link_external_spt)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
+				void *external_spt);
+	/* Update the external page table from spte getting set. */
+	int (*set_external_spte)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
+				 kvm_pfn_t pfn_for_gfn);
+
 	bool (*has_wbinvd_exit)(void);
 
 	u64 (*get_l2_tsc_offset)(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 9a004c999a28..7ba1f0ce99c8 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -440,6 +440,59 @@ static void handle_removed_pt(struct kvm *kvm, tdp_ptep_t pt, bool shared)
 	call_rcu(&sp->rcu_head, tdp_mmu_free_sp_rcu_callback);
 }
 
+static void *get_external_spt(gfn_t gfn, u64 new_spte, int level)
+{
+	if (is_shadow_present_pte(new_spte) && !is_last_spte(new_spte, level)) {
+		struct kvm_mmu_page *sp = spte_to_child_sp(new_spte);
+
+		WARN_ON_ONCE(sp->role.level + 1 != level);
+		WARN_ON_ONCE(sp->gfn != gfn);
+		return sp->external_spt;
+	}
+
+	return NULL;
+}
+
+static int __must_check set_external_spte_present(struct kvm *kvm, tdp_ptep_t sptep,
+						 gfn_t gfn, u64 old_spte,
+						 u64 new_spte, int level)
+{
+	bool was_present = is_shadow_present_pte(old_spte);
+	bool is_present = is_shadow_present_pte(new_spte);
+	bool is_leaf = is_present && is_last_spte(new_spte, level);
+	kvm_pfn_t new_pfn = spte_to_pfn(new_spte);
+	int ret = 0;
+
+	KVM_BUG_ON(was_present, kvm);
+
+	lockdep_assert_held(&kvm->mmu_lock);
+	/*
+	 * We need to lock out other updates to the SPTE until the external
+	 * page table has been modified. Use FROZEN_SPTE similar to
+	 * the zapping case.
+	 */
+	if (!try_cmpxchg64(sptep, &old_spte, FROZEN_SPTE))
+		return -EBUSY;
+
+	/*
+	 * Use different call to either set up middle level
+	 * external page table, or leaf.
+	 */
+	if (is_leaf) {
+		ret = static_call(kvm_x86_set_external_spte)(kvm, gfn, level, new_pfn);
+	} else {
+		void *external_spt = get_external_spt(gfn, new_spte, level);
+
+		KVM_BUG_ON(!external_spt, kvm);
+		ret = static_call(kvm_x86_link_external_spt)(kvm, gfn, level, external_spt);
+	}
+	if (ret)
+		__kvm_tdp_mmu_write_spte(sptep, old_spte);
+	else
+		__kvm_tdp_mmu_write_spte(sptep, new_spte);
+	return ret;
+}
+
 /**
  * handle_changed_spte - handle bookkeeping associated with an SPTE change
  * @kvm: kvm instance
@@ -540,7 +593,8 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 		handle_removed_pt(kvm, spte_to_child_pt(old_spte, level), shared);
 }
 
-static inline int __must_check __tdp_mmu_set_spte_atomic(struct tdp_iter *iter,
+static inline int __must_check __tdp_mmu_set_spte_atomic(struct kvm *kvm,
+							 struct tdp_iter *iter,
 							 u64 new_spte)
 {
 	u64 *sptep = rcu_dereference(iter->sptep);
@@ -553,15 +607,25 @@ static inline int __must_check __tdp_mmu_set_spte_atomic(struct tdp_iter *iter,
 	 */
 	WARN_ON_ONCE(iter->yielded || is_frozen_spte(iter->old_spte));
 
-	/*
-	 * Note, fast_pf_fix_direct_spte() can also modify TDP MMU SPTEs and
-	 * does not hold the mmu_lock.  On failure, i.e. if a different logical
-	 * CPU modified the SPTE, try_cmpxchg64() updates iter->old_spte with
-	 * the current value, so the caller operates on fresh data, e.g. if it
-	 * retries tdp_mmu_set_spte_atomic()
-	 */
-	if (!try_cmpxchg64(sptep, &iter->old_spte, new_spte))
-		return -EBUSY;
+	if (is_mirror_sptep(iter->sptep) && !is_frozen_spte(new_spte)) {
+		int ret;
+
+		ret = set_external_spte_present(kvm, iter->sptep, iter->gfn,
+						iter->old_spte, new_spte, iter->level);
+		if (ret)
+			return ret;
+	} else {
+		/*
+		 * Note, fast_pf_fix_direct_spte() can also modify TDP MMU SPTEs
+		 * and does not hold the mmu_lock.  On failure, i.e. if a
+		 * different logical CPU modified the SPTE, try_cmpxchg64()
+		 * updates iter->old_spte with the current value, so the caller
+		 * operates on fresh data, e.g. if it retries
+		 * tdp_mmu_set_spte_atomic()
+		 */
+		if (!try_cmpxchg64(sptep, &iter->old_spte, new_spte))
+			return -EBUSY;
+	}
 
 	return 0;
 }
@@ -591,7 +655,7 @@ static inline int __must_check tdp_mmu_set_spte_atomic(struct kvm *kvm,
 
 	lockdep_assert_held_read(&kvm->mmu_lock);
 
-	ret = __tdp_mmu_set_spte_atomic(iter, new_spte);
+	ret = __tdp_mmu_set_spte_atomic(kvm, iter, new_spte);
 	if (ret)
 		return ret;
 
@@ -631,6 +695,14 @@ static u64 tdp_mmu_set_spte(struct kvm *kvm, int as_id, tdp_ptep_t sptep,
 	old_spte = kvm_tdp_mmu_write_spte(sptep, old_spte, new_spte, level);
 
 	handle_changed_spte(kvm, as_id, gfn, old_spte, new_spte, level, false);
+
+	/*
+	 * Users that do non-atomic setting of PTEs don't operate on mirror
+	 * roots, so don't handle it and bug the VM if it's seen.
+	 */
+	if (is_mirror_sptep(sptep))
+		KVM_BUG_ON(is_shadow_present_pte(new_spte), kvm);
+
 	return old_spte;
 }
 
-- 
2.43.5



