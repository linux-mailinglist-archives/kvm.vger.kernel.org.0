Return-Path: <kvm+bounces-33772-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 94ECD9F16F9
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 21:02:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0AE14188B9D4
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 20:02:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AE5E1F4298;
	Fri, 13 Dec 2024 19:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XZXJd2sJ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C150A1F2370
	for <kvm@vger.kernel.org>; Fri, 13 Dec 2024 19:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734119852; cv=none; b=pcHX0nuggvU4oik3h+gCA+rRlqKAzI+gMjjGJdqFv5Es8coegN/oy5VXsrrGMFZCHPqb+2YcK0x7IaDZJuVoiQ8Ned+ZdESCDqgUfuC57RZh03rNTvWmlnFyuyifUkqhdGGvEVt3X1MfjbnHoG8hnsTplq+ygn62mAtDr+Szj8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734119852; c=relaxed/simple;
	bh=vAUcmKNcMVxXTHUkW1gMNUk8rG84FpGFe1wdmVUcNN8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EiJWAZojC/v1LiUapZ3AFi2evrgjVxt7JBRpasRA13wcI/sNSXOc9JbDWT9Jv55xdAjDWHaxogkcYwokvJPLJw8B/cyK+voWEpUS4hOckpukOL2FlTQRGFn4sbjrr5MSuf4NsHu4C0G+61Dayy4lXQEOYRxvKuXt1ygfg57TDig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XZXJd2sJ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734119849;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=McLfKd2G16DQEpxIENacyuf/HIrQ/d0mTTAM0Ao+SQw=;
	b=XZXJd2sJSObTAa2uMaBwczwiseM8FXaqolU7M7lZmKIb9fAeIUl8lOOUr0FCjp1mMMZl5p
	NeO+iHN8xg9cu2jiWJSDiCWiqyUiVSc7IBIDwCfarOXYEGdXzeiohp2z6ePBLf6mAXM1n6
	+UpXmz9zfwkEWQ4F4Dn2GAdi6GE1/Mg=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-3-TMIR3mPnOjGZ58L3o9SCSg-1; Fri,
 13 Dec 2024 14:57:24 -0500
X-MC-Unique: TMIR3mPnOjGZ58L3o9SCSg-1
X-Mimecast-MFC-AGG-ID: TMIR3mPnOjGZ58L3o9SCSg
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 541531956086;
	Fri, 13 Dec 2024 19:57:23 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 60EF5195605A;
	Fri, 13 Dec 2024 19:57:22 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: yan.y.zhao@intel.com,
	isaku.yamahata@intel.com,
	binbin.wu@linux.intel.com,
	rick.p.edgecombe@intel.com
Subject: [PATCH 08/18] KVM: x86/mmu: Support GFN direct bits
Date: Fri, 13 Dec 2024 14:57:01 -0500
Message-ID: <20241213195711.316050-9-pbonzini@redhat.com>
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
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

From: Isaku Yamahata <isaku.yamahata@intel.com>

Teach the MMU to map guest GFNs at a massaged position on the TDP, to aid
in implementing TDX shared memory.

Like other Coco technologies, TDX has the concept of private and shared
memory. For TDX the private and shared mappings are managed on separate
EPT roots. The private half is managed indirectly through calls into a
protected runtime environment called the TDX module, where the shared half
is managed within KVM in normal page tables.

For TDX, the shared half will be mapped in the higher alias, with a "shared
bit" set in the GPA. However, KVM will still manage it with the same
memslots as the private half. This means memslot looks ups and zapping
operations will be provided with a GFN without the shared bit set.

So KVM will either need to apply or strip the shared bit before mapping or
zapping the shared EPT. Having GFNs sometimes have the shared bit and
sometimes not would make the code confusing.

So instead arrange the code such that GFNs never have shared bit set.
Create a concept of "direct bits", that is stripped from the fault
address when setting fault->gfn, and applied within the TDP MMU iterator.
Calling code will behave as if it is operating on the PTE mapping the GFN
(without shared bits) but within the iterator, the actual mappings will be
shifted using bits specific for the root. SPs will have the GFN set
without the shared bit. In the end the TDP MMU will behave like it is
mapping things at the GFN without the shared bit but with a strange page
table format where everything is offset by the shared bit.

Since TDX only needs to shift the mapping like this for the shared bit,
which is mapped as the normal TDP root, add a "gfn_direct_bits" field to
the kvm_arch structure for each VM with a default value of 0. It will
have the bit set at the position of the GPA shared bit in GFN through TD
specific initialization code. Keep TDX specific concepts out of the MMU
code by not naming it "shared".

Ranged TLB flushes (i.e. flush_remote_tlbs_range()) target specific GFN
ranges. In convention established above, these would need to target the
shifted GFN range. It won't matter functionally, since the actual
implementation will always result in a full flush for the only planned
user (TDX). For correctness reasons, future changes can provide a TDX
x86_ops.flush_remote_tlbs_range implementation to return -EOPNOTSUPP and
force the full flush for TDs.

This leaves one problem. Some operations use a concept of max GFN (i.e.
kvm_mmu_max_gfn()), to iterate over the whole TDP range. When applying the
direct mask to the start of the range, the iterator would end up skipping
iterating over the range not covered by the direct mask bit. For safety,
make sure the __tdp_mmu_zap_root() operation iterates over the full GFN
range supported by the underlying TDP format. Add a new iterator helper,
for_each_tdp_pte_min_level_all(), that iterates the entire TDP GFN range,
regardless of root.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Co-developed-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
Co-developed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Message-ID: <20240718211230.1492011-9-rick.p.edgecombe@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/mmu.h              |  5 +++++
 arch/x86/kvm/mmu/mmu_internal.h | 28 ++++++++++++++++++++++++++--
 arch/x86/kvm/mmu/tdp_iter.c     | 10 ++++++----
 arch/x86/kvm/mmu/tdp_iter.h     | 15 +++++++++++----
 arch/x86/kvm/mmu/tdp_mmu.c      |  5 +----
 6 files changed, 51 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index cae88f023caf..95f2b0890a58 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1542,6 +1542,8 @@ struct kvm_arch {
 	 */
 #define SPLIT_DESC_CACHE_MIN_NR_OBJECTS (SPTE_ENT_PER_PAGE + 1)
 	struct kvm_mmu_memory_cache split_desc_cache;
+
+	gfn_t gfn_direct_bits;
 };
 
 struct kvm_vm_stat {
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 538eb3156f09..091002975374 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -292,4 +292,9 @@ static inline bool kvm_has_mirrored_tdp(const struct kvm *kvm)
 {
 	return kvm->arch.vm_type == KVM_X86_TDX_VM;
 }
+
+static inline gfn_t kvm_gfn_direct_bits(const struct kvm *kvm)
+{
+	return kvm->arch.gfn_direct_bits;
+}
 #endif
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index ff00341f26a2..957636660149 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -6,6 +6,8 @@
 #include <linux/kvm_host.h>
 #include <asm/kvm_host.h>
 
+#include "mmu.h"
+
 #ifdef CONFIG_KVM_PROVE_MMU
 #define KVM_MMU_WARN_ON(x) WARN_ON_ONCE(x)
 #else
@@ -173,6 +175,18 @@ static inline void kvm_mmu_alloc_external_spt(struct kvm_vcpu *vcpu, struct kvm_
 	sp->external_spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_external_spt_cache);
 }
 
+static inline gfn_t kvm_gfn_root_bits(const struct kvm *kvm, const struct kvm_mmu_page *root)
+{
+	/*
+	 * Since mirror SPs are used only for TDX, which maps private memory
+	 * at its "natural" GFN, no mask needs to be applied to them - and, dually,
+	 * we expect that the bits is only used for the shared PT.
+	 */
+	if (is_mirror_sp(root))
+		return 0;
+	return kvm_gfn_direct_bits(kvm);
+}
+
 static inline bool kvm_mmu_page_ad_need_write_protect(struct kvm_mmu_page *sp)
 {
 	/*
@@ -257,7 +271,12 @@ struct kvm_page_fault {
 	 */
 	u8 goal_level;
 
-	/* Shifted addr, or result of guest page table walk if addr is a gva.  */
+	/*
+	 * Shifted addr, or result of guest page table walk if addr is a gva. In
+	 * the case of VM where memslot's can be mapped at multiple GPA aliases
+	 * (i.e. TDX), the gfn field does not contain the bit that selects between
+	 * the aliases (i.e. the shared bit for TDX).
+	 */
 	gfn_t gfn;
 
 	/* The memslot containing gfn. May be NULL. */
@@ -345,7 +364,12 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	int r;
 
 	if (vcpu->arch.mmu->root_role.direct) {
-		fault.gfn = fault.addr >> PAGE_SHIFT;
+		/*
+		 * Things like memslots don't understand the concept of a shared
+		 * bit. Strip it so that the GFN can be used like normal, and the
+		 * fault.addr can be used when the shared bit is needed.
+		 */
+		fault.gfn = gpa_to_gfn(fault.addr) & ~kvm_gfn_direct_bits(vcpu->kvm);
 		fault.slot = kvm_vcpu_gfn_to_memslot(vcpu, fault.gfn);
 	}
 
diff --git a/arch/x86/kvm/mmu/tdp_iter.c b/arch/x86/kvm/mmu/tdp_iter.c
index 04c247bfe318..9e17bfa80901 100644
--- a/arch/x86/kvm/mmu/tdp_iter.c
+++ b/arch/x86/kvm/mmu/tdp_iter.c
@@ -12,7 +12,7 @@
 static void tdp_iter_refresh_sptep(struct tdp_iter *iter)
 {
 	iter->sptep = iter->pt_path[iter->level - 1] +
-		SPTE_INDEX(iter->gfn << PAGE_SHIFT, iter->level);
+		SPTE_INDEX((iter->gfn | iter->gfn_bits) << PAGE_SHIFT, iter->level);
 	iter->old_spte = kvm_tdp_mmu_read_spte(iter->sptep);
 }
 
@@ -37,15 +37,17 @@ void tdp_iter_restart(struct tdp_iter *iter)
  * rooted at root_pt, starting with the walk to translate next_last_level_gfn.
  */
 void tdp_iter_start(struct tdp_iter *iter, struct kvm_mmu_page *root,
-		    int min_level, gfn_t next_last_level_gfn)
+		    int min_level, gfn_t next_last_level_gfn, gfn_t gfn_bits)
 {
 	if (WARN_ON_ONCE(!root || (root->role.level < 1) ||
-			 (root->role.level > PT64_ROOT_MAX_LEVEL))) {
+			 (root->role.level > PT64_ROOT_MAX_LEVEL) ||
+			 (gfn_bits && next_last_level_gfn >= gfn_bits))) {
 		iter->valid = false;
 		return;
 	}
 
 	iter->next_last_level_gfn = next_last_level_gfn;
+	iter->gfn_bits = gfn_bits;
 	iter->root_level = root->role.level;
 	iter->min_level = min_level;
 	iter->pt_path[iter->root_level - 1] = (tdp_ptep_t)root->spt;
@@ -113,7 +115,7 @@ static bool try_step_side(struct tdp_iter *iter)
 	 * Check if the iterator is already at the end of the current page
 	 * table.
 	 */
-	if (SPTE_INDEX(iter->gfn << PAGE_SHIFT, iter->level) ==
+	if (SPTE_INDEX((iter->gfn | iter->gfn_bits) << PAGE_SHIFT, iter->level) ==
 	    (SPTE_ENT_PER_PAGE - 1))
 		return false;
 
diff --git a/arch/x86/kvm/mmu/tdp_iter.h b/arch/x86/kvm/mmu/tdp_iter.h
index d8f2884e3c66..047b78333653 100644
--- a/arch/x86/kvm/mmu/tdp_iter.h
+++ b/arch/x86/kvm/mmu/tdp_iter.h
@@ -93,8 +93,10 @@ struct tdp_iter {
 	tdp_ptep_t pt_path[PT64_ROOT_MAX_LEVEL];
 	/* A pointer to the current SPTE */
 	tdp_ptep_t sptep;
-	/* The lowest GFN mapped by the current SPTE */
+	/* The lowest GFN (mask bits excluded) mapped by the current SPTE */
 	gfn_t gfn;
+	/* Mask applied to convert the GFN to the mapping GPA */
+	gfn_t gfn_bits;
 	/* The level of the root page given to the iterator */
 	int root_level;
 	/* The lowest level the iterator should traverse to */
@@ -123,17 +125,22 @@ struct tdp_iter {
  * preorder traversal.
  */
 #define for_each_tdp_pte_min_level(iter, kvm, root, min_level, start, end)		  \
-	for (tdp_iter_start(&iter, root, min_level, start); \
-	     iter.valid && iter.gfn < end;		     \
+	for (tdp_iter_start(&iter, root, min_level, start, kvm_gfn_root_bits(kvm, root)); \
+	     iter.valid && iter.gfn < end;						  \
 	     tdp_iter_next(&iter))
 
+#define for_each_tdp_pte_min_level_all(iter, root, min_level)		\
+	for (tdp_iter_start(&iter, root, min_level, 0, 0);		\
+		iter.valid && iter.gfn < tdp_mmu_max_gfn_exclusive();	\
+		tdp_iter_next(&iter))
+
 #define for_each_tdp_pte(iter, kvm, root, start, end)				\
 	for_each_tdp_pte_min_level(iter, kvm, root, PG_LEVEL_4K, start, end)
 
 tdp_ptep_t spte_to_child_pt(u64 pte, int level);
 
 void tdp_iter_start(struct tdp_iter *iter, struct kvm_mmu_page *root,
-		    int min_level, gfn_t next_last_level_gfn);
+		    int min_level, gfn_t next_last_level_gfn, gfn_t gfn_bits);
 void tdp_iter_next(struct tdp_iter *iter);
 void tdp_iter_restart(struct tdp_iter *iter);
 
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 6fb49f595d68..c77cbf2577c3 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -705,10 +705,7 @@ static void __tdp_mmu_zap_root(struct kvm *kvm, struct kvm_mmu_page *root,
 {
 	struct tdp_iter iter;
 
-	gfn_t end = tdp_mmu_max_gfn_exclusive();
-	gfn_t start = 0;
-
-	for_each_tdp_pte_min_level(iter, kvm, root, zap_level, start, end) {
+	for_each_tdp_pte_min_level_all(iter, root, zap_level) {
 retry:
 		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, shared))
 			continue;
-- 
2.43.5



