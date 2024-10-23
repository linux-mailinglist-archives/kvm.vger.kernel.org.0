Return-Path: <kvm+bounces-29582-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 90D159AD86A
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 01:28:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0C82F1F21862
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 23:28:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B89B21FF7B1;
	Wed, 23 Oct 2024 23:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aNYpTN4a"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43EF01E4A4
	for <kvm@vger.kernel.org>; Wed, 23 Oct 2024 23:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729726075; cv=none; b=UG2Wh1gRCEcoHhJ21mt1Y0dapmSGfz39ivd3WCWL+XLo68k68WUjqD9cAO3HuA5q+y0e1AzWCoj49xt2p5iSCWI+VAMuVxdZrnMqh0Rtn/OC/ENt2Zyo9hnLN0GsrtBHzsuHVVbBilYPN9a9RisZkigk9kYhN7SLeUVt9IlPNGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729726075; c=relaxed/simple;
	bh=EG0ONMmq4RVFhRO10BpZvh/oHirmRtJ2HeXZN0x9Qdk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kOIHdu0jBJet8nd8dmthqmG6xVW8XoqBgNB/jyk8wg8X0/o+S6GUAi04m0uwm6lXqDoAq6Rr71j6huGafG/Pf2/3PLUSuvXTldfhSSSjeg9FnNx06HdecU3fhGEAsZjvS5EbsNWWTlIzKb1AA9roy6D8zsCuE12UX7/XKw/mylI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aNYpTN4a; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2e2a9577037so359325a91.1
        for <kvm@vger.kernel.org>; Wed, 23 Oct 2024 16:27:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1729726072; x=1730330872; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=pak5RcdWZ0viVp+nAws2VedxAmJZM+00JUHRChlUMWk=;
        b=aNYpTN4ansliEX7ZdYim0ukORvdS4EAZLeVxICKJPE7R4U+f9otKdmBiEMdrkFip2R
         xukgZYXJ2LLjD7i7Yq1wt9CrBeeVqArJEu52fij1lWOV20UDHxJP2J0MOSj9p+kYhA6m
         Rr0+qA+thyRkuVmSugxyCNwo4m8Epr58wGIyKnoAVa8EFAAMeq2njQvOeu4HSZqpz6zZ
         U535NEYHuARWKCD+x+jYBLrZsdqvEfddLdMJc1JFiZVXD8EEwJB0MKd1NTOa9sBN3gY0
         rIpkv5x5/wGlttKXRs6Zizf9JzwEuXm8/pAP4ZbsDVeZB9Pux+qFwKtzYw62uIA/y4E4
         GK2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729726072; x=1730330872;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pak5RcdWZ0viVp+nAws2VedxAmJZM+00JUHRChlUMWk=;
        b=DtRDXrcxgOTFIQB6jpKQ5qmVe061I77dOzV2npPPmv4takCWkDoT1QrJeTiwsAb71N
         1xmbM2BA9vhhTjt821ksDPIcyLZ6+lGitPjixs0CQRP+soroXN/fbaEFZ3d9TodOUjWv
         AUsB4x0VXgGPDrd84wC+LIZ5JGD3cNZ4yAQenNwhX1GBcUjS1ALep8Ikb9S+9wls1k1U
         wEmsbHtswJt7CyuPyPUkFa63BTeov+hemVVqbmMkjgVVorz5XK1CzfA87sXugqGErWnX
         tU+Hz1kVKwfPDqZU7gxPXMZcBPts6SOCcNljV7fkO8L5KcaCU1KF546xaVl/mT50cITP
         hQmg==
X-Gm-Message-State: AOJu0YxJx9s/eXtbj3Oz68tieAmxb0DMetM3AUi2hfuEAonuDEtrTzDW
	T+KjjXUdGOv/4z/n7qEDOtKDA6OyVj3TYmbcIElfREwxdCN8VOTzDzqyP4awZxgYGViyZF2uJ3y
	CHg==
X-Google-Smtp-Source: AGHT+IENhEQ51gU24q+D/f8e8zXmVUVvDzHs+KLAWVmSaatkQ+M8OIvwipnznMZeCLARioALmq9zKEQ4wA8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a17:90b:e11:b0:2e2:cf55:5124 with SMTP id
 98e67ed59e1d1-2e77ecb2a13mr112a91.0.1729726072261; Wed, 23 Oct 2024 16:27:52
 -0700 (PDT)
Date: Wed, 23 Oct 2024 16:27:50 -0700
In-Reply-To: <20241023091902.2289764-1-bk@alpico.io>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241023091902.2289764-1-bk@alpico.io>
Message-ID: <ZxmGdhwr9BlhUQ_Y@google.com>
Subject: Re: [PATCH] KVM: x86: Fast forward the iterator when zapping the TDP MMU
From: Sean Christopherson <seanjc@google.com>
To: Bernhard Kauer <bk@alpico.io>
Cc: kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Oct 23, 2024, Bernhard Kauer wrote:
> Zapping a root means scanning for present entries in a page-table
> hierarchy. This process is relatively slow since it needs to be
> preemtible as millions of entries might be processed.
> 
> Furthermore the root-page is traversed multiple times as zapping
> is done with increasing page-sizes.
> 
> Optimizing for the not-present case speeds up the hello microbenchmark
> by 115 microseconds.

What is the "hello" microbenchmark?  Do we actually care if it's faster?

Are you able to determine exactly what makes iteration slow?  Partly because I'm
curious, partly because it would be helpful to be able to avoid problematic
patterns in the future, and partly because maybe there's a more elegant solution.

Regardless of why iteration is slow, I would much prefer to solve this for all
users of the iterator.  E.g. very lightly tested, and not 100% optimized (though
should be on par with the below).

---
 arch/x86/kvm/mmu/tdp_iter.c | 33 ++++++++++++++++-----------------
 arch/x86/kvm/mmu/tdp_iter.h | 19 +++++++++++++------
 arch/x86/kvm/mmu/tdp_mmu.c  | 26 ++++++++++----------------
 3 files changed, 39 insertions(+), 39 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_iter.c b/arch/x86/kvm/mmu/tdp_iter.c
index 04c247bfe318..53aebc044ca6 100644
--- a/arch/x86/kvm/mmu/tdp_iter.c
+++ b/arch/x86/kvm/mmu/tdp_iter.c
@@ -37,7 +37,7 @@ void tdp_iter_restart(struct tdp_iter *iter)
  * rooted at root_pt, starting with the walk to translate next_last_level_gfn.
  */
 void tdp_iter_start(struct tdp_iter *iter, struct kvm_mmu_page *root,
-		    int min_level, gfn_t next_last_level_gfn)
+		    int min_level, bool only_present, gfn_t next_last_level_gfn)
 {
 	if (WARN_ON_ONCE(!root || (root->role.level < 1) ||
 			 (root->role.level > PT64_ROOT_MAX_LEVEL))) {
@@ -45,6 +45,7 @@ void tdp_iter_start(struct tdp_iter *iter, struct kvm_mmu_page *root,
 		return;
 	}
 
+	iter->only_shadow_present = only_present;
 	iter->next_last_level_gfn = next_last_level_gfn;
 	iter->root_level = root->role.level;
 	iter->min_level = min_level;
@@ -103,26 +104,24 @@ static bool try_step_down(struct tdp_iter *iter)
 /*
  * Steps to the next entry in the current page table, at the current page table
  * level. The next entry could point to a page backing guest memory or another
- * page table, or it could be non-present. Returns true if the iterator was
- * able to step to the next entry in the page table, false if the iterator was
- * already at the end of the current page table.
+ * page table, or it could be non-present. Skips non-present entries if the
+ * iterator is configured to process only shadow-present entries. Returns true
+ * if the iterator was able to step to the next entry in the page table, false
+ * if the iterator was already at the end of the current page table.
  */
 static bool try_step_side(struct tdp_iter *iter)
 {
-	/*
-	 * Check if the iterator is already at the end of the current page
-	 * table.
-	 */
-	if (SPTE_INDEX(iter->gfn << PAGE_SHIFT, iter->level) ==
-	    (SPTE_ENT_PER_PAGE - 1))
-		return false;
+	while (SPTE_INDEX(iter->gfn << PAGE_SHIFT, iter->level) < (SPTE_ENT_PER_PAGE - 1)) {
+		iter->gfn += KVM_PAGES_PER_HPAGE(iter->level);
+		iter->next_last_level_gfn = iter->gfn;
+		iter->sptep++;
+		iter->old_spte = kvm_tdp_mmu_read_spte(iter->sptep);
 
-	iter->gfn += KVM_PAGES_PER_HPAGE(iter->level);
-	iter->next_last_level_gfn = iter->gfn;
-	iter->sptep++;
-	iter->old_spte = kvm_tdp_mmu_read_spte(iter->sptep);
-
-	return true;
+		if (!iter->only_shadow_present ||
+		    is_shadow_present_pte(iter->old_spte))
+			return true;
+	}
+	return false;
 }
 
 /*
diff --git a/arch/x86/kvm/mmu/tdp_iter.h b/arch/x86/kvm/mmu/tdp_iter.h
index 2880fd392e0c..11945ff42f50 100644
--- a/arch/x86/kvm/mmu/tdp_iter.h
+++ b/arch/x86/kvm/mmu/tdp_iter.h
@@ -105,6 +105,8 @@ struct tdp_iter {
 	int as_id;
 	/* A snapshot of the value at sptep */
 	u64 old_spte;
+	/* True if the walk should only visit shadow-present PTEs. */
+	bool only_shadow_present;
 	/*
 	 * Whether the iterator has a valid state. This will be false if the
 	 * iterator walks off the end of the paging structure.
@@ -122,18 +124,23 @@ struct tdp_iter {
  * Iterates over every SPTE mapping the GFN range [start, end) in a
  * preorder traversal.
  */
-#define for_each_tdp_pte_min_level(iter, root, min_level, start, end) \
-	for (tdp_iter_start(&iter, root, min_level, start); \
-	     iter.valid && iter.gfn < end;		     \
-	     tdp_iter_next(&iter))
+#define for_each_tdp_pte_min_level(iter, root, min_level, only_present, start, end)	\
+	for (tdp_iter_start(&iter, root, min_level, only_present, start);		\
+	     iter.valid && iter.gfn < end;						\
+	     tdp_iter_next(&iter))							\
+		if ((only_present) && !is_shadow_present_pte(iter.old_spte)) {		\
+		} else
+
+#define for_each_shadow_present_tdp_pte(iter, root, min_level, start, end)		\
+	for_each_tdp_pte_min_level(iter, root, min_level, true, start, end)
 
 #define for_each_tdp_pte(iter, root, start, end) \
-	for_each_tdp_pte_min_level(iter, root, PG_LEVEL_4K, start, end)
+	for_each_tdp_pte_min_level(iter, root, PG_LEVEL_4K, false, start, end)
 
 tdp_ptep_t spte_to_child_pt(u64 pte, int level);
 
 void tdp_iter_start(struct tdp_iter *iter, struct kvm_mmu_page *root,
-		    int min_level, gfn_t next_last_level_gfn);
+		    int min_level, bool only_present, gfn_t next_last_level_gfn);
 void tdp_iter_next(struct tdp_iter *iter);
 void tdp_iter_restart(struct tdp_iter *iter);
 
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 3b996c1fdaab..25a75db83ca3 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -752,14 +752,11 @@ static void __tdp_mmu_zap_root(struct kvm *kvm, struct kvm_mmu_page *root,
 	gfn_t end = tdp_mmu_max_gfn_exclusive();
 	gfn_t start = 0;
 
-	for_each_tdp_pte_min_level(iter, root, zap_level, start, end) {
+	for_each_shadow_present_tdp_pte(iter, root, zap_level, start, end) {
 retry:
 		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, shared))
 			continue;
 
-		if (!is_shadow_present_pte(iter.old_spte))
-			continue;
-
 		if (iter.level > zap_level)
 			continue;
 
@@ -856,15 +853,14 @@ static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
 
 	rcu_read_lock();
 
-	for_each_tdp_pte_min_level(iter, root, PG_LEVEL_4K, start, end) {
+	for_each_shadow_present_tdp_pte(iter, root, PG_LEVEL_4K, start, end) {
 		if (can_yield &&
 		    tdp_mmu_iter_cond_resched(kvm, &iter, flush, false)) {
 			flush = false;
 			continue;
 		}
 
-		if (!is_shadow_present_pte(iter.old_spte) ||
-		    !is_last_spte(iter.old_spte, iter.level))
+		if (!is_last_spte(iter.old_spte, iter.level))
 			continue;
 
 		tdp_mmu_iter_set_spte(kvm, &iter, SHADOW_NONPRESENT_VALUE);
@@ -1296,7 +1292,7 @@ static bool wrprot_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 
 	BUG_ON(min_level > KVM_MAX_HUGEPAGE_LEVEL);
 
-	for_each_tdp_pte_min_level(iter, root, min_level, start, end) {
+	for_each_shadow_present_tdp_pte(iter, root, min_level, start, end) {
 retry:
 		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, true))
 			continue;
@@ -1415,12 +1411,12 @@ static int tdp_mmu_split_huge_pages_root(struct kvm *kvm,
 	 * level above the target level (e.g. splitting a 1GB to 512 2MB pages,
 	 * and then splitting each of those to 512 4KB pages).
 	 */
-	for_each_tdp_pte_min_level(iter, root, target_level + 1, start, end) {
+	for_each_shadow_present_tdp_pte(iter, root, target_level + 1, start, end) {
 retry:
 		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, shared))
 			continue;
 
-		if (!is_shadow_present_pte(iter.old_spte) || !is_large_pte(iter.old_spte))
+		if (!is_large_pte(iter.old_spte))
 			continue;
 
 		if (!sp) {
@@ -1626,13 +1622,12 @@ static void zap_collapsible_spte_range(struct kvm *kvm,
 
 	rcu_read_lock();
 
-	for_each_tdp_pte_min_level(iter, root, PG_LEVEL_2M, start, end) {
+	for_each_shadow_present_tdp_pte(iter, root, PG_LEVEL_2M, start, end) {
 retry:
 		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, true))
 			continue;
 
-		if (iter.level > KVM_MAX_HUGEPAGE_LEVEL ||
-		    !is_shadow_present_pte(iter.old_spte))
+		if (iter.level > KVM_MAX_HUGEPAGE_LEVEL)
 			continue;
 
 		/*
@@ -1696,9 +1691,8 @@ static bool write_protect_gfn(struct kvm *kvm, struct kvm_mmu_page *root,
 
 	rcu_read_lock();
 
-	for_each_tdp_pte_min_level(iter, root, min_level, gfn, gfn + 1) {
-		if (!is_shadow_present_pte(iter.old_spte) ||
-		    !is_last_spte(iter.old_spte, iter.level))
+	for_each_shadow_present_tdp_pte(iter, root, min_level, gfn, gfn + 1) {
+		if (!is_last_spte(iter.old_spte, iter.level))
 			continue;
 
 		new_spte = iter.old_spte &

base-commit: 8cf0b93919e13d1e8d4466eb4080a4c4d9d66d7b
-- 


> Signed-off-by: Bernhard Kauer <bk@alpico.io>
> ---
>  arch/x86/kvm/mmu/tdp_iter.h | 21 +++++++++++++++++++++
>  arch/x86/kvm/mmu/tdp_mmu.c  |  2 +-
>  2 files changed, 22 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_iter.h b/arch/x86/kvm/mmu/tdp_iter.h
> index 2880fd392e0c..7ad28ac2c6b8 100644
> --- a/arch/x86/kvm/mmu/tdp_iter.h
> +++ b/arch/x86/kvm/mmu/tdp_iter.h
> @@ -130,6 +130,27 @@ struct tdp_iter {
>  #define for_each_tdp_pte(iter, root, start, end) \
>  	for_each_tdp_pte_min_level(iter, root, PG_LEVEL_4K, start, end)
>  
> +
> +/*
> + * Skip up to count not present entries of the iterator. Returns true
> + * if the final entry is not present.
> + */
> +static inline bool tdp_iter_skip_not_present(struct tdp_iter *iter, int count)
> +{
> +	int i;
> +	int pos;
> +
> +	pos = SPTE_INDEX(iter->gfn << PAGE_SHIFT, iter->level);
> +	count = min(count, SPTE_ENT_PER_PAGE - 1 - pos);
> +	for (i = 0; i < count && !is_shadow_present_pte(iter->old_spte); i++)
> +		iter->old_spte = kvm_tdp_mmu_read_spte(iter->sptep + i + 1);
> +
> +	iter->gfn += i * KVM_PAGES_PER_HPAGE(iter->level);
> +	iter->next_last_level_gfn = iter->gfn;
> +	iter->sptep += i;
> +	return !is_shadow_present_pte(iter->old_spte);
> +}
> +
>  tdp_ptep_t spte_to_child_pt(u64 pte, int level);
>  
>  void tdp_iter_start(struct tdp_iter *iter, struct kvm_mmu_page *root,
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 1951f76db657..404726511f95 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -750,7 +750,7 @@ static void __tdp_mmu_zap_root(struct kvm *kvm, struct kvm_mmu_page *root,
>  		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, shared))
>  			continue;
>  
> -		if (!is_shadow_present_pte(iter.old_spte))
> +		if (tdp_iter_skip_not_present(&iter, 32))
>  			continue;
>  
>  		if (iter.level > zap_level)
> -- 
> 2.45.2
> 

