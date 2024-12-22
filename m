Return-Path: <kvm+bounces-34310-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 282979FA7C2
	for <lists+kvm@lfdr.de>; Sun, 22 Dec 2024 20:38:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8C8B216155E
	for <lists+kvm@lfdr.de>; Sun, 22 Dec 2024 19:38:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 735C01B3956;
	Sun, 22 Dec 2024 19:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YQe8KeBq"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D24C11B2182
	for <kvm@vger.kernel.org>; Sun, 22 Dec 2024 19:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734896109; cv=none; b=hpE0z2sTBgSxIIzx65Rx7MxknBhXW5GyfWJ3FW/f1Rl09mkXN6iuAT1IW27ZrGGmZhpwrlLKWLiUQ6Pcs3YqP3jjo7QQSBMlZaTbeFBUKsOJ1qKeq+xlvXbXU7E8vnZ0IITJD2hVQ1MKa+4+1/c14G3suy5RjVkC6LoRjYSdFQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734896109; c=relaxed/simple;
	bh=w5DY8do/rTrD17LimKqaSkeBK/lBXKGJYzgSZo1kVzs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TBJcL0Cv3fWIXkQmTKv4h8vpoeZf78t1U0YXA5ZctaYnRqYjAH9kDBOBJsc7yj+U/ZzgD/o+AYXnsh8JdZLPkyU68nU7/RGDWuQWifT4L2DyklmzcIkb9ibxjtjH1tQirRjG5YFtw92aAiHOho75xslXINPncsmf42ryVAru5RI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YQe8KeBq; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734896106;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NxvVx3Sb6cUqjAvHx8FYM5dQ+oQBds2fGAFfaADs2O8=;
	b=YQe8KeBq3rhHUugAWyx0P8pQP755J3VRuEi/dXzR88j2yrEkTsN+rSYqkOSaiGulKtoSO3
	m/a/1yDxYBEI369SCvyVNvhtF9L20aIZJFVw/GWN5ocfe/OWlIqRzNCAqfKtIDqhDoxYdc
	opL8kTjANCtXrh7fcZUl5CX8BQQM8Ig=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-166-VNcibKUtN_G5H-6L0oPvVg-1; Sun,
 22 Dec 2024 14:35:02 -0500
X-MC-Unique: VNcibKUtN_G5H-6L0oPvVg-1
X-Mimecast-MFC-AGG-ID: VNcibKUtN_G5H-6L0oPvVg
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D64DC1956088;
	Sun, 22 Dec 2024 19:35:00 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id BF49319560AA;
	Sun, 22 Dec 2024 19:34:59 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: yan.y.zhao@intel.com,
	isaku.yamahata@intel.com,
	binbin.wu@linux.intel.com,
	rick.p.edgecombe@intel.com,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH v6 10/18] KVM: x86/tdp_mmu: Introduce KVM MMU root types to specify page table type
Date: Sun, 22 Dec 2024 14:34:37 -0500
Message-ID: <20241222193445.349800-11-pbonzini@redhat.com>
In-Reply-To: <20241222193445.349800-1-pbonzini@redhat.com>
References: <20241222193445.349800-1-pbonzini@redhat.com>
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

Define an enum kvm_tdp_mmu_root_types to specify the KVM MMU root type [1]
so that the iterator on the root page table can consistently filter the
root page table type instead of only_valid.

TDX KVM will operate on KVM page tables with specified types.  Shared page
table, private page table, or both.  Introduce an enum instead of bool
only_valid so that we can easily enhance page table types applicable to
shared, private, or both in addition to valid or not.  Replace
only_valid=false with KVM_ANY_ROOTS and only_valid=true with
KVM_ANY_VALID_ROOTS.  Use KVM_ANY_ROOTS and KVM_ANY_VALID_ROOTS to wrap
KVM_VALID_ROOTS to avoid further code churn when direct vs mirror root
concepts are introduced in future patches.

Link: https://lore.kernel.org/kvm/ZivazWQw1oCU8VBC@google.com/ [1]
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Message-ID: <20240718211230.1492011-11-rick.p.edgecombe@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 42 +++++++++++++++++++++-----------------
 arch/x86/kvm/mmu/tdp_mmu.h |  7 +++++++
 2 files changed, 30 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index e0ccfdd4200b..9fbf4770ba3e 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -92,9 +92,13 @@ void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root)
 	call_rcu(&root->rcu_head, tdp_mmu_free_sp_rcu_callback);
 }
 
-static bool tdp_mmu_root_match(struct kvm_mmu_page *root, bool only_valid)
+static bool tdp_mmu_root_match(struct kvm_mmu_page *root,
+			       enum kvm_tdp_mmu_root_types types)
 {
-	if (only_valid && root->role.invalid)
+	if (WARN_ON_ONCE(!(types & KVM_VALID_ROOTS)))
+		return false;
+
+	if (root->role.invalid && !(types & KVM_INVALID_ROOTS))
 		return false;
 
 	return true;
@@ -102,17 +106,17 @@ static bool tdp_mmu_root_match(struct kvm_mmu_page *root, bool only_valid)
 
 /*
  * Returns the next root after @prev_root (or the first root if @prev_root is
- * NULL).  A reference to the returned root is acquired, and the reference to
- * @prev_root is released (the caller obviously must hold a reference to
- * @prev_root if it's non-NULL).
+ * NULL) that matches with @types.  A reference to the returned root is
+ * acquired, and the reference to @prev_root is released (the caller obviously
+ * must hold a reference to @prev_root if it's non-NULL).
  *
- * If @only_valid is true, invalid roots are skipped.
+ * Roots that doesn't match with @types are skipped.
  *
  * Returns NULL if the end of tdp_mmu_roots was reached.
  */
 static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
 					      struct kvm_mmu_page *prev_root,
-					      bool only_valid)
+					      enum kvm_tdp_mmu_root_types types)
 {
 	struct kvm_mmu_page *next_root;
 
@@ -133,7 +137,7 @@ static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
 						   typeof(*next_root), link);
 
 	while (next_root) {
-		if (tdp_mmu_root_match(next_root, only_valid) &&
+		if (tdp_mmu_root_match(next_root, types) &&
 		    kvm_tdp_mmu_get_root(next_root))
 			break;
 
@@ -158,20 +162,20 @@ static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
  * If shared is set, this function is operating under the MMU lock in read
  * mode.
  */
-#define __for_each_tdp_mmu_root_yield_safe(_kvm, _root, _as_id, _only_valid)	\
-	for (_root = tdp_mmu_next_root(_kvm, NULL, _only_valid);		\
+#define __for_each_tdp_mmu_root_yield_safe(_kvm, _root, _as_id, _types)	\
+	for (_root = tdp_mmu_next_root(_kvm, NULL, _types);		\
 	     ({ lockdep_assert_held(&(_kvm)->mmu_lock); }), _root;		\
-	     _root = tdp_mmu_next_root(_kvm, _root, _only_valid))		\
+	     _root = tdp_mmu_next_root(_kvm, _root, _types))		\
 		if (_as_id >= 0 && kvm_mmu_page_as_id(_root) != _as_id) {	\
 		} else
 
 #define for_each_valid_tdp_mmu_root_yield_safe(_kvm, _root, _as_id)	\
-	__for_each_tdp_mmu_root_yield_safe(_kvm, _root, _as_id, true)
+	__for_each_tdp_mmu_root_yield_safe(_kvm, _root, _as_id, KVM_VALID_ROOTS)
 
 #define for_each_tdp_mmu_root_yield_safe(_kvm, _root)			\
-	for (_root = tdp_mmu_next_root(_kvm, NULL, false);		\
+	for (_root = tdp_mmu_next_root(_kvm, NULL, KVM_ALL_ROOTS);		\
 	     ({ lockdep_assert_held(&(_kvm)->mmu_lock); }), _root;	\
-	     _root = tdp_mmu_next_root(_kvm, _root, false))
+	     _root = tdp_mmu_next_root(_kvm, _root, KVM_ALL_ROOTS))
 
 /*
  * Iterate over all TDP MMU roots.  Requires that mmu_lock be held for write,
@@ -180,18 +184,18 @@ static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
  * Holding mmu_lock for write obviates the need for RCU protection as the list
  * is guaranteed to be stable.
  */
-#define __for_each_tdp_mmu_root(_kvm, _root, _as_id, _only_valid)		\
+#define __for_each_tdp_mmu_root(_kvm, _root, _as_id, _types)			\
 	list_for_each_entry(_root, &_kvm->arch.tdp_mmu_roots, link)		\
 		if (kvm_lockdep_assert_mmu_lock_held(_kvm, false) &&		\
 		    ((_as_id >= 0 && kvm_mmu_page_as_id(_root) != _as_id) ||	\
-		     !tdp_mmu_root_match((_root), (_only_valid)))) {		\
+		     !tdp_mmu_root_match((_root), (_types)))) {			\
 		} else
 
 #define for_each_tdp_mmu_root(_kvm, _root, _as_id)			\
-	__for_each_tdp_mmu_root(_kvm, _root, _as_id, false)
+	__for_each_tdp_mmu_root(_kvm, _root, _as_id, KVM_ALL_ROOTS)
 
 #define for_each_valid_tdp_mmu_root(_kvm, _root, _as_id)		\
-	__for_each_tdp_mmu_root(_kvm, _root, _as_id, true)
+	__for_each_tdp_mmu_root(_kvm, _root, _as_id, KVM_VALID_ROOTS)
 
 static struct kvm_mmu_page *tdp_mmu_alloc_sp(struct kvm_vcpu *vcpu)
 {
@@ -1164,7 +1168,7 @@ bool kvm_tdp_mmu_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range,
 {
 	struct kvm_mmu_page *root;
 
-	__for_each_tdp_mmu_root_yield_safe(kvm, root, range->slot->as_id, false)
+	__for_each_tdp_mmu_root_yield_safe(kvm, root, range->slot->as_id, KVM_ALL_ROOTS)
 		flush = tdp_mmu_zap_leafs(kvm, root, range->start, range->end,
 					  range->may_block, flush);
 
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 51884fc6a512..a2028d036c0c 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -19,6 +19,13 @@ __must_check static inline bool kvm_tdp_mmu_get_root(struct kvm_mmu_page *root)
 
 void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root);
 
+enum kvm_tdp_mmu_root_types {
+	KVM_INVALID_ROOTS = BIT(0),
+
+	KVM_VALID_ROOTS = BIT(1),
+	KVM_ALL_ROOTS = KVM_VALID_ROOTS | KVM_INVALID_ROOTS,
+};
+
 bool kvm_tdp_mmu_zap_leafs(struct kvm *kvm, gfn_t start, gfn_t end, bool flush);
 bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp);
 void kvm_tdp_mmu_zap_all(struct kvm *kvm);
-- 
2.43.5



