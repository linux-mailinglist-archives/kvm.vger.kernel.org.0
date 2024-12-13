Return-Path: <kvm+bounces-33773-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 72B119F16FA
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 21:02:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0E1D2188C613
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 20:02:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB3011F470F;
	Fri, 13 Dec 2024 19:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gwHXNs/6"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5F621F1936
	for <kvm@vger.kernel.org>; Fri, 13 Dec 2024 19:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734119853; cv=none; b=Vj8gtS2a4vcl/yMwyU67V6YyZFJjTTT3e1FS/holIzaUDLC1133B6yp2Y43ooopmSKzKyXvOdO9H+eCtPcAeC8xPVdJEkPfOFNTEMUykRJ78NGh/M4HnQz3H5gP59Prp/UexrcThiICNiAdGNQqSirEPs8sSUGqnzdFR0Tg2qyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734119853; c=relaxed/simple;
	bh=O5sV77XM4BKOiOwy9WCUnQPWMbwYNKTvZhkRj16DYwM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rxPmuZ0mt5Bd/m5ix6B21F5NIlqBOjA8UVL3xvmY8GIExAX4eQSQqewsCdHqevkloJs5MtyB/0CwpzlnirHt7v4rshJt39fKzket9nL79e9lGUmQmU6xCp/AkD1OSTAGPrky5PN/hbRfAoSjwE/UBrFgM1BDU/aI2TWkSaeOr+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gwHXNs/6; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734119848;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Qkxb/FiLfFGyv+nlN6+ZSj7urbZqydcQqys4jU1LBww=;
	b=gwHXNs/6jWTk6N0uVR+gs5djJFc2hjKzGW9gksEe6tIGkC2x3mvZOwmxhEMHB4AIGbIpaD
	M+dvcJkYFN+JaOUbjzL0YIk6CwUo/D2r+vc/2vlF0yqkW8lQQS/YsM8I4kPZvHKgKIMRDL
	6c6nzRaOkD7x07I/3oYcE4rSSpGEbmM=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-230-u_X9WMlgMbiwYj75QDEHyQ-1; Fri,
 13 Dec 2024 14:57:24 -0500
X-MC-Unique: u_X9WMlgMbiwYj75QDEHyQ-1
X-Mimecast-MFC-AGG-ID: u_X9WMlgMbiwYj75QDEHyQ
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2EB6D195608B;
	Fri, 13 Dec 2024 19:57:22 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3BBEF195605A;
	Fri, 13 Dec 2024 19:57:21 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: yan.y.zhao@intel.com,
	isaku.yamahata@intel.com,
	binbin.wu@linux.intel.com,
	rick.p.edgecombe@intel.com
Subject: [PATCH 07/18] KVM: x86/tdp_mmu: Take struct kvm in iter loops
Date: Fri, 13 Dec 2024 14:57:00 -0500
Message-ID: <20241213195711.316050-8-pbonzini@redhat.com>
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

Add a struct kvm argument to the TDP MMU iterators.

Future changes will want to change how the iterator behaves based on a
member of struct kvm. Change the signature and callers of the iterator
loop helpers in a separate patch to make the future one easier to review.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Message-ID: <20240718211230.1492011-8-rick.p.edgecombe@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/tdp_iter.h |  6 +++---
 arch/x86/kvm/mmu/tdp_mmu.c  | 38 ++++++++++++++++++-------------------
 2 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_iter.h b/arch/x86/kvm/mmu/tdp_iter.h
index 2880fd392e0c..d8f2884e3c66 100644
--- a/arch/x86/kvm/mmu/tdp_iter.h
+++ b/arch/x86/kvm/mmu/tdp_iter.h
@@ -122,13 +122,13 @@ struct tdp_iter {
  * Iterates over every SPTE mapping the GFN range [start, end) in a
  * preorder traversal.
  */
-#define for_each_tdp_pte_min_level(iter, root, min_level, start, end) \
+#define for_each_tdp_pte_min_level(iter, kvm, root, min_level, start, end)		  \
 	for (tdp_iter_start(&iter, root, min_level, start); \
 	     iter.valid && iter.gfn < end;		     \
 	     tdp_iter_next(&iter))
 
-#define for_each_tdp_pte(iter, root, start, end) \
-	for_each_tdp_pte_min_level(iter, root, PG_LEVEL_4K, start, end)
+#define for_each_tdp_pte(iter, kvm, root, start, end)				\
+	for_each_tdp_pte_min_level(iter, kvm, root, PG_LEVEL_4K, start, end)
 
 tdp_ptep_t spte_to_child_pt(u64 pte, int level);
 
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 0d179653f959..6fb49f595d68 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -625,18 +625,18 @@ static inline void tdp_mmu_iter_set_spte(struct kvm *kvm, struct tdp_iter *iter,
 					  iter->gfn, iter->level);
 }
 
-#define tdp_root_for_each_pte(_iter, _root, _start, _end) \
-	for_each_tdp_pte(_iter, _root, _start, _end)
+#define tdp_root_for_each_pte(_iter, _kvm, _root, _start, _end)	\
+	for_each_tdp_pte(_iter, _kvm, _root, _start, _end)
 
-#define tdp_root_for_each_leaf_pte(_iter, _root, _start, _end)	\
-	tdp_root_for_each_pte(_iter, _root, _start, _end)		\
+#define tdp_root_for_each_leaf_pte(_iter, _kvm, _root, _start, _end)	\
+	tdp_root_for_each_pte(_iter, _kvm, _root, _start, _end)		\
 		if (!is_shadow_present_pte(_iter.old_spte) ||		\
 		    !is_last_spte(_iter.old_spte, _iter.level))		\
 			continue;					\
 		else
 
-#define tdp_mmu_for_each_pte(_iter, _mmu, _start, _end)		\
-	for_each_tdp_pte(_iter, root_to_sp(_mmu->root.hpa), _start, _end)
+#define tdp_mmu_for_each_pte(_iter, _kvm, _mmu, _start, _end)		\
+	for_each_tdp_pte(_iter, _kvm, root_to_sp(_mmu->root.hpa), _start, _end)
 
 static inline bool __must_check tdp_mmu_iter_need_resched(struct kvm *kvm,
 							  struct tdp_iter *iter)
@@ -708,7 +708,7 @@ static void __tdp_mmu_zap_root(struct kvm *kvm, struct kvm_mmu_page *root,
 	gfn_t end = tdp_mmu_max_gfn_exclusive();
 	gfn_t start = 0;
 
-	for_each_tdp_pte_min_level(iter, root, zap_level, start, end) {
+	for_each_tdp_pte_min_level(iter, kvm, root, zap_level, start, end) {
 retry:
 		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, shared))
 			continue;
@@ -812,7 +812,7 @@ static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
 
 	rcu_read_lock();
 
-	for_each_tdp_pte_min_level(iter, root, PG_LEVEL_4K, start, end) {
+	for_each_tdp_pte_min_level(iter, kvm, root, PG_LEVEL_4K, start, end) {
 		if (can_yield &&
 		    tdp_mmu_iter_cond_resched(kvm, &iter, flush, false)) {
 			flush = false;
@@ -1081,7 +1081,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 
 	rcu_read_lock();
 
-	tdp_mmu_for_each_pte(iter, mmu, fault->gfn, fault->gfn + 1) {
+	tdp_mmu_for_each_pte(iter, kvm, mmu, fault->gfn, fault->gfn + 1) {
 		int r;
 
 		if (fault->nx_huge_page_workaround_enabled)
@@ -1207,7 +1207,7 @@ static bool __kvm_tdp_mmu_age_gfn_range(struct kvm *kvm,
 	for_each_valid_tdp_mmu_root(kvm, root, range->slot->as_id) {
 		guard(rcu)();
 
-		tdp_root_for_each_leaf_pte(iter, root, range->start, range->end) {
+		tdp_root_for_each_leaf_pte(iter, kvm, root, range->start, range->end) {
 			if (!is_accessed_spte(iter.old_spte))
 				continue;
 
@@ -1248,7 +1248,7 @@ static bool wrprot_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 
 	BUG_ON(min_level > KVM_MAX_HUGEPAGE_LEVEL);
 
-	for_each_tdp_pte_min_level(iter, root, min_level, start, end) {
+	for_each_tdp_pte_min_level(iter, kvm, root, min_level, start, end) {
 retry:
 		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, true))
 			continue;
@@ -1367,7 +1367,7 @@ static int tdp_mmu_split_huge_pages_root(struct kvm *kvm,
 	 * level above the target level (e.g. splitting a 1GB to 512 2MB pages,
 	 * and then splitting each of those to 512 4KB pages).
 	 */
-	for_each_tdp_pte_min_level(iter, root, target_level + 1, start, end) {
+	for_each_tdp_pte_min_level(iter, kvm, root, target_level + 1, start, end) {
 retry:
 		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, shared))
 			continue;
@@ -1465,7 +1465,7 @@ static void clear_dirty_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 
 	rcu_read_lock();
 
-	tdp_root_for_each_pte(iter, root, start, end) {
+	tdp_root_for_each_pte(iter, kvm, root, start, end) {
 retry:
 		if (!is_shadow_present_pte(iter.old_spte) ||
 		    !is_last_spte(iter.old_spte, iter.level))
@@ -1513,7 +1513,7 @@ static void clear_dirty_pt_masked(struct kvm *kvm, struct kvm_mmu_page *root,
 
 	rcu_read_lock();
 
-	tdp_root_for_each_leaf_pte(iter, root, gfn + __ffs(mask),
+	tdp_root_for_each_leaf_pte(iter, kvm, root, gfn + __ffs(mask),
 				    gfn + BITS_PER_LONG) {
 		if (!mask)
 			break;
@@ -1567,7 +1567,7 @@ static int tdp_mmu_make_huge_spte(struct kvm *kvm,
 	gfn_t end = start + KVM_PAGES_PER_HPAGE(parent->level);
 	struct tdp_iter iter;
 
-	tdp_root_for_each_leaf_pte(iter, root, start, end) {
+	tdp_root_for_each_leaf_pte(iter, kvm, root, start, end) {
 		/*
 		 * Use the parent iterator when checking for forward progress so
 		 * that KVM doesn't get stuck continuously trying to yield (i.e.
@@ -1601,7 +1601,7 @@ static void recover_huge_pages_range(struct kvm *kvm,
 
 	rcu_read_lock();
 
-	for_each_tdp_pte_min_level(iter, root, PG_LEVEL_2M, start, end) {
+	for_each_tdp_pte_min_level(iter, kvm, root, PG_LEVEL_2M, start, end) {
 retry:
 		if (tdp_mmu_iter_cond_resched(kvm, &iter, flush, true)) {
 			flush = false;
@@ -1682,7 +1682,7 @@ static bool write_protect_gfn(struct kvm *kvm, struct kvm_mmu_page *root,
 
 	rcu_read_lock();
 
-	for_each_tdp_pte_min_level(iter, root, min_level, gfn, gfn + 1) {
+	for_each_tdp_pte_min_level(iter, kvm, root, min_level, gfn, gfn + 1) {
 		if (!is_shadow_present_pte(iter.old_spte) ||
 		    !is_last_spte(iter.old_spte, iter.level))
 			continue;
@@ -1737,7 +1737,7 @@ int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
 
 	*root_level = vcpu->arch.mmu->root_role.level;
 
-	tdp_mmu_for_each_pte(iter, mmu, gfn, gfn + 1) {
+	tdp_mmu_for_each_pte(iter, vcpu->kvm, mmu, gfn, gfn + 1) {
 		leaf = iter.level;
 		sptes[leaf] = iter.old_spte;
 	}
@@ -1763,7 +1763,7 @@ u64 *kvm_tdp_mmu_fast_pf_get_last_sptep(struct kvm_vcpu *vcpu, gfn_t gfn,
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
 	tdp_ptep_t sptep = NULL;
 
-	tdp_mmu_for_each_pte(iter, mmu, gfn, gfn + 1) {
+	tdp_mmu_for_each_pte(iter, vcpu->kvm, mmu, gfn, gfn + 1) {
 		*spte = iter.old_spte;
 		sptep = iter.sptep;
 	}
-- 
2.43.5



