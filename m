Return-Path: <kvm+bounces-10169-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B53386A38C
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 00:25:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7B7301C2495D
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 23:25:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D87A5D73C;
	Tue, 27 Feb 2024 23:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VnSj9axn"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B0235730C
	for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 23:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709076074; cv=none; b=L63U3UnAHZzls/XIv+2iW8gSykhDnkxu7OeRRckaEF1SX5CQB9qrpbsyxQBoLg6Q8DVUbOqT56jdIxIkJk4hyF5aCOJIwSLQN7qF68xqaF3Rx7hYngwYdrUEbql3ivC3fBhPv6l+Glm5iYnrEl3ApCUYqkxwVUc12w4jr+OqeoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709076074; c=relaxed/simple;
	bh=TTy3JmqXesssW2PhZAosjOWCyuDukKNcv04NZiXZfxE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=N6KLGp9UP4j+wWEDtGceqmRJwq/DuFrxQgwePzsyn7pRI1ibY2bCiRHLnYK1IOyrWeW6Ict6wrpzXnReyDtcTyk5jUml1wav6fZAuZs5g5V33NL3Zg1j5/XP5XAVbvC9Z7+M6VSxLsqXO7ltwI9rBjgSOZzGekX0QBdUFdBAJ8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VnSj9axn; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709076067;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gZCnuiOOjhwJlttY0FhctLg6J4phcptVrWdx4vnyW/Q=;
	b=VnSj9axnoeb8NrvVCme/mrpzhvDaJEre9bS1lm8qAHa7g2ssp4fkzb9sfq7XtqoSDwEXra
	j6eKyFi7i+QTV6ihnNe/9zSr/nlTqvs65z18hBrYMFABAnqjq1bFfsoMy7sHHbanNZyy9R
	FVzlRgJH0JoRkGmL6kr/wotR1n+W86o=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-689-dIbl5VkcMDugYiScuBLpTw-1; Tue, 27 Feb 2024 18:21:04 -0500
X-MC-Unique: dIbl5VkcMDugYiScuBLpTw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 84BD3108BCA0;
	Tue, 27 Feb 2024 23:21:03 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 58859C040F7;
	Tue, 27 Feb 2024 23:21:03 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	michael.roth@amd.com,
	isaku.yamahata@intel.com,
	thomas.lendacky@amd.com
Subject: [PATCH 11/21] KVM: x86/tdp_mmu: Init role member of struct kvm_mmu_page at allocation
Date: Tue, 27 Feb 2024 18:20:50 -0500
Message-Id: <20240227232100.478238-12-pbonzini@redhat.com>
In-Reply-To: <20240227232100.478238-1-pbonzini@redhat.com>
References: <20240227232100.478238-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8

From: Isaku Yamahata <isaku.yamahata@intel.com>

Refactor tdp_mmu_alloc_sp() and tdp_mmu_init_sp and eliminate
tdp_mmu_init_child_sp().  Currently tdp_mmu_init_sp() (or
tdp_mmu_init_child_sp()) sets kvm_mmu_page.role after tdp_mmu_alloc_sp()
allocating struct kvm_mmu_page and its page table page.  This patch makes
tdp_mmu_alloc_sp() initialize kvm_mmu_page.role instead of
tdp_mmu_init_sp().

To handle private page tables, argument of is_private needs to be passed
down.  Given that already page level is passed down, it would be cumbersome
to add one more parameter about sp. Instead replace the level argument with
union kvm_mmu_page_role.  Thus the number of argument won't be increased
and more info about sp can be passed down.

For private sp, secure page table will be also allocated in addition to
struct kvm_mmu_page and page table (spt member).  The allocation functions
(tdp_mmu_alloc_sp() and __tdp_mmu_alloc_sp_for_split()) need to know if the
allocation is for the conventional page table or private page table.  Pass
union kvm_mmu_role to those functions and initialize role member of struct
kvm_mmu_page.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Message-Id: <d69acdd7f0b0b104f330a6d42ac28f9a9b1b5850.1705965635.git.isaku.yamahata@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/tdp_iter.h | 12 ++++++++++
 arch/x86/kvm/mmu/tdp_mmu.c  | 44 ++++++++++++++++---------------------
 2 files changed, 31 insertions(+), 25 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_iter.h b/arch/x86/kvm/mmu/tdp_iter.h
index fae559559a80..e1e40e3f5eb7 100644
--- a/arch/x86/kvm/mmu/tdp_iter.h
+++ b/arch/x86/kvm/mmu/tdp_iter.h
@@ -135,4 +135,16 @@ void tdp_iter_start(struct tdp_iter *iter, struct kvm_mmu_page *root,
 void tdp_iter_next(struct tdp_iter *iter);
 void tdp_iter_restart(struct tdp_iter *iter);
 
+static inline union kvm_mmu_page_role tdp_iter_child_role(struct tdp_iter *iter)
+{
+	union kvm_mmu_page_role child_role;
+	struct kvm_mmu_page *parent_sp;
+
+	parent_sp = sptep_to_sp(rcu_dereference(iter->sptep));
+
+	child_role = parent_sp->role;
+	child_role.level--;
+	return child_role;
+}
+
 #endif /* __KVM_X86_MMU_TDP_ITER_H */
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index d15c44a8e123..55b5e3857e98 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -184,24 +184,30 @@ static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
 #define for_each_valid_tdp_mmu_root(_kvm, _root, _as_id)		\
 	__for_each_tdp_mmu_root(_kvm, _root, _as_id, true)
 
-static struct kvm_mmu_page *tdp_mmu_alloc_sp(struct kvm_vcpu *vcpu)
+static struct kvm_mmu_page *tdp_mmu_alloc_sp(struct kvm_vcpu *vcpu,
+					     union kvm_mmu_page_role role)
 {
 	struct kvm_mmu_page *sp;
 
 	sp = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_page_header_cache);
 	sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
+	sp->role = role;
 
 	return sp;
 }
 
 static void tdp_mmu_init_sp(struct kvm_mmu_page *sp, tdp_ptep_t sptep,
-			    gfn_t gfn, union kvm_mmu_page_role role)
+			    gfn_t gfn)
 {
 	INIT_LIST_HEAD(&sp->possible_nx_huge_page_link);
 
 	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
 
-	sp->role = role;
+	/*
+	 * role must be set before calling this function.  At least role.level
+	 * is not 0 (PG_LEVEL_NONE).
+	 */
+	WARN_ON_ONCE(!sp->role.word);
 	sp->gfn = gfn;
 	sp->ptep = sptep;
 	sp->tdp_mmu_page = true;
@@ -209,20 +215,6 @@ static void tdp_mmu_init_sp(struct kvm_mmu_page *sp, tdp_ptep_t sptep,
 	trace_kvm_mmu_get_page(sp, true);
 }
 
-static void tdp_mmu_init_child_sp(struct kvm_mmu_page *child_sp,
-				  struct tdp_iter *iter)
-{
-	struct kvm_mmu_page *parent_sp;
-	union kvm_mmu_page_role role;
-
-	parent_sp = sptep_to_sp(rcu_dereference(iter->sptep));
-
-	role = parent_sp->role;
-	role.level--;
-
-	tdp_mmu_init_sp(child_sp, iter->sptep, iter->gfn, role);
-}
-
 int kvm_tdp_mmu_alloc_root(struct kvm_vcpu *vcpu)
 {
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
@@ -260,8 +252,8 @@ int kvm_tdp_mmu_alloc_root(struct kvm_vcpu *vcpu)
 			goto out_spin_unlock;
 	}
 
-	root = tdp_mmu_alloc_sp(vcpu);
-	tdp_mmu_init_sp(root, NULL, 0, role);
+	root = tdp_mmu_alloc_sp(vcpu, role);
+	tdp_mmu_init_sp(root, NULL, 0);
 
 	/*
 	 * TDP MMU roots are kept until they are explicitly invalidated, either
@@ -1118,8 +1110,8 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 		 * The SPTE is either non-present or points to a huge page that
 		 * needs to be split.
 		 */
-		sp = tdp_mmu_alloc_sp(vcpu);
-		tdp_mmu_init_child_sp(sp, &iter);
+		sp = tdp_mmu_alloc_sp(vcpu, tdp_iter_child_role(&iter));
+		tdp_mmu_init_sp(sp, iter.sptep, iter.gfn);
 
 		sp->nx_huge_page_disallowed = fault->huge_page_disallowed;
 
@@ -1362,7 +1354,7 @@ bool kvm_tdp_mmu_wrprot_slot(struct kvm *kvm,
 	return spte_set;
 }
 
-static struct kvm_mmu_page *__tdp_mmu_alloc_sp_for_split(gfp_t gfp)
+static struct kvm_mmu_page *__tdp_mmu_alloc_sp_for_split(gfp_t gfp, union kvm_mmu_page_role role)
 {
 	struct kvm_mmu_page *sp;
 
@@ -1372,6 +1364,7 @@ static struct kvm_mmu_page *__tdp_mmu_alloc_sp_for_split(gfp_t gfp)
 	if (!sp)
 		return NULL;
 
+	sp->role = role;
 	sp->spt = (void *)__get_free_page(gfp);
 	if (!sp->spt) {
 		kmem_cache_free(mmu_page_header_cache, sp);
@@ -1385,6 +1378,7 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(struct kvm *kvm,
 						       struct tdp_iter *iter,
 						       bool shared)
 {
+	union kvm_mmu_page_role role = tdp_iter_child_role(iter);
 	struct kvm_mmu_page *sp;
 
 	kvm_lockdep_assert_mmu_lock_held(kvm, shared);
@@ -1398,7 +1392,7 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(struct kvm *kvm,
 	 * If this allocation fails we drop the lock and retry with reclaim
 	 * allowed.
 	 */
-	sp = __tdp_mmu_alloc_sp_for_split(GFP_NOWAIT | __GFP_ACCOUNT);
+	sp = __tdp_mmu_alloc_sp_for_split(GFP_NOWAIT | __GFP_ACCOUNT, role);
 	if (sp)
 		return sp;
 
@@ -1410,7 +1404,7 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(struct kvm *kvm,
 		write_unlock(&kvm->mmu_lock);
 
 	iter->yielded = true;
-	sp = __tdp_mmu_alloc_sp_for_split(GFP_KERNEL_ACCOUNT);
+	sp = __tdp_mmu_alloc_sp_for_split(GFP_KERNEL_ACCOUNT, role);
 
 	if (shared)
 		read_lock(&kvm->mmu_lock);
@@ -1505,7 +1499,7 @@ static int tdp_mmu_split_huge_pages_root(struct kvm *kvm,
 				continue;
 		}
 
-		tdp_mmu_init_child_sp(sp, &iter);
+		tdp_mmu_init_sp(sp, iter.sptep, iter.gfn);
 
 		if (tdp_mmu_split_huge_page(kvm, &iter, sp, shared))
 			goto retry;
-- 
2.39.0



