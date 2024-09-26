Return-Path: <kvm+bounces-27524-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A292D986A87
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2024 03:37:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C5D431C225C0
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2024 01:37:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6FA4192B69;
	Thu, 26 Sep 2024 01:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MlGjxCjp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8D4418BB84
	for <kvm@vger.kernel.org>; Thu, 26 Sep 2024 01:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727314527; cv=none; b=IkcJ3vjnxXezkr2lcgJrD0zRv71+XOooumf5+vmnb9ztZuWoEIMec4LLdzD8jiD4Iy+SnSxW4acGH+AzcXvdYzIWo0zVBd+78uumwp32a9QBtJUQta7NGnmVpDoJIJEayiLe/e/t9CXgF77daLIaMOXADk6+V907TobNcQtuyCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727314527; c=relaxed/simple;
	bh=i7ngJ/q5kYIHv8bPc7pXv+SigYhoKYSU3nQq3Jajqd0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=iB0CAPBPfAb6LKYHLCPBcKBvWtBxtOqwzja6CneikZM3juETtyfwt8gxbwd39aQDGld8/IHYYWpB5gBrF0TqjxCdNiV7O6/6tP6Epk2zpg9iTWAnNoR3wb04nd8UQ8xlj5fxxd0mPzJtHvpF2YpZmjDPL37EvSkHOir7EQfpiQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MlGjxCjp; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e02a4de4f4eso972754276.1
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2024 18:35:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1727314524; x=1727919324; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=MAX0OZs2fthT88FLek8b9DqcvP6EmNxdVeFSdhP6yzs=;
        b=MlGjxCjpMWcL04NToxLQANTbtyPP/2IaWbryTpoTSqvdMTDNpLq23u9qmd3cj/55HM
         xidhNhzxb9HwSOdOCkiPbHBpbv+T0Ax0s+awYfnt4brcZ4olgm70YwhpHDtC9D5GDjQt
         88UjhmatowSNEuq9LN1I5NLo1kpERexAc4dBIQ/DB3m3jE2bN61E7aRADdsPlhJnYEVM
         u3ThGTkz0sm7PA7UyoGTzuV5vsE8QOrP2J246ZcG06s8Z875DZD8oV3SfK2KW0lPMjJn
         ijOeuUGDv0+xbQ7o6RSAE9X2Mlt8gxhZEHGIhHDLYacpuJA9iT0iXjMhTBq4h3KSauBg
         QUBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727314524; x=1727919324;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MAX0OZs2fthT88FLek8b9DqcvP6EmNxdVeFSdhP6yzs=;
        b=u6aBSbCEkLxnZvOpp3ipS6xNsFcv2hihgxVyf9Fs8Aq2jodOqUG4R6mfkwPOeeAYJf
         a1jzRMPrkEuZizX88+/IVZfgKWxeeQGginVzB1dxxSXtRTYF19Z9w4Hjatk9LRqA3kBo
         Xcjssu4xzdbOTRpDL9ef00qY+7pyV8i3mqRgCZJCkwBAcQhctlZrT2eXBclh41kawAST
         XHLnPDgneT29LPJM6XNT764mOt2hb1YVx/SuC1xH1oMxqFB2psyOBg6nCK3eLYNY0pXa
         jRYyxjhJvo/bZvmUxBEfL9Taqv3o5OAQ196ay+1Q5MZ6fg4Cm3fv5G4cVtGac8Eeam9N
         INAw==
X-Forwarded-Encrypted: i=1; AJvYcCVzWdSloyOEaxYsYMeA8xynDfKwnktZZhlJF9e7O+JwGUXLCLxLkc00ntOJqxadN+qfXIg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxGo5xa2CS5iQ0DXz3gF4G6iXHVpD50Lou0EsBL3AgfW/M75CAA
	CGtNg20FUMo5m7jW6cPCWwSv3PiOR8zl0QO+fUvOb0JV0RUi1pd+IPP6c/yX0aBetDET8PpXi1G
	3wMR8tt44SpVSZoyhIQ==
X-Google-Smtp-Source: AGHT+IGaRNcJ0pUCHmWao5UQiFUuGRcX2zXYa1voIITtc2canA4FkWeSC7N08ZTT/PlEa6ZAuN210z4HqmS+Jzo6
X-Received: from jthoughton.c.googlers.com ([fda3:e722:ac3:cc00:13d:fb22:ac12:a84b])
 (user=jthoughton job=sendgmr) by 2002:a25:d608:0:b0:e11:6a73:b0d with SMTP id
 3f1490d57ef6-e24d9dc640bmr3172276.6.1727314523065; Wed, 25 Sep 2024 18:35:23
 -0700 (PDT)
Date: Thu, 26 Sep 2024 01:34:55 +0000
In-Reply-To: <20240926013506.860253-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240926013506.860253-1-jthoughton@google.com>
X-Mailer: git-send-email 2.46.0.792.g87dc391469-goog
Message-ID: <20240926013506.860253-8-jthoughton@google.com>
Subject: [PATCH v7 07/18] KVM: x86/mmu: Refactor low level rmap helpers to
 prep for walking w/o mmu_lock
From: James Houghton <jthoughton@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Matlack <dmatlack@google.com>, 
	David Rientjes <rientjes@google.com>, James Houghton <jthoughton@google.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Wei Xu <weixugc@google.com>, Yu Zhao <yuzhao@google.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"

From: Sean Christopherson <seanjc@google.com>

Refactor the pte_list and rmap code to always read and write rmap_head->val
exactly once, e.g. by collecting changes in a local variable and then
propagating those changes back to rmap_head->val as appropriate.  This will
allow implementing a per-rmap rwlock (of sorts) by adding a LOCKED bit into
the rmap value alongside the MANY bit.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 83 +++++++++++++++++++++++++-----------------
 1 file changed, 50 insertions(+), 33 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index b4e543bdf3f0..17de470f542c 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -920,21 +920,24 @@ static struct kvm_memory_slot *gfn_to_memslot_dirty_bitmap(struct kvm_vcpu *vcpu
 static int pte_list_add(struct kvm_mmu_memory_cache *cache, u64 *spte,
 			struct kvm_rmap_head *rmap_head)
 {
+	unsigned long old_val, new_val;
 	struct pte_list_desc *desc;
 	int count = 0;
 
-	if (!rmap_head->val) {
-		rmap_head->val = (unsigned long)spte;
-	} else if (!(rmap_head->val & KVM_RMAP_MANY)) {
+	old_val = rmap_head->val;
+
+	if (!old_val) {
+		new_val = (unsigned long)spte;
+	} else if (!(old_val & KVM_RMAP_MANY)) {
 		desc = kvm_mmu_memory_cache_alloc(cache);
-		desc->sptes[0] = (u64 *)rmap_head->val;
+		desc->sptes[0] = (u64 *)old_val;
 		desc->sptes[1] = spte;
 		desc->spte_count = 2;
 		desc->tail_count = 0;
-		rmap_head->val = (unsigned long)desc | KVM_RMAP_MANY;
+		new_val = (unsigned long)desc | KVM_RMAP_MANY;
 		++count;
 	} else {
-		desc = (struct pte_list_desc *)(rmap_head->val & ~KVM_RMAP_MANY);
+		desc = (struct pte_list_desc *)(old_val & ~KVM_RMAP_MANY);
 		count = desc->tail_count + desc->spte_count;
 
 		/*
@@ -943,21 +946,25 @@ static int pte_list_add(struct kvm_mmu_memory_cache *cache, u64 *spte,
 		 */
 		if (desc->spte_count == PTE_LIST_EXT) {
 			desc = kvm_mmu_memory_cache_alloc(cache);
-			desc->more = (struct pte_list_desc *)(rmap_head->val & ~KVM_RMAP_MANY);
+			desc->more = (struct pte_list_desc *)(old_val & ~KVM_RMAP_MANY);
 			desc->spte_count = 0;
 			desc->tail_count = count;
-			rmap_head->val = (unsigned long)desc | KVM_RMAP_MANY;
+			new_val = (unsigned long)desc | KVM_RMAP_MANY;
+		} else {
+			new_val = old_val;
 		}
 		desc->sptes[desc->spte_count++] = spte;
 	}
+
+	rmap_head->val = new_val;
+
 	return count;
 }
 
-static void pte_list_desc_remove_entry(struct kvm *kvm,
-				       struct kvm_rmap_head *rmap_head,
+static void pte_list_desc_remove_entry(struct kvm *kvm, unsigned long *rmap_val,
 				       struct pte_list_desc *desc, int i)
 {
-	struct pte_list_desc *head_desc = (struct pte_list_desc *)(rmap_head->val & ~KVM_RMAP_MANY);
+	struct pte_list_desc *head_desc = (struct pte_list_desc *)(*rmap_val & ~KVM_RMAP_MANY);
 	int j = head_desc->spte_count - 1;
 
 	/*
@@ -984,9 +991,9 @@ static void pte_list_desc_remove_entry(struct kvm *kvm,
 	 * head at the next descriptor, i.e. the new head.
 	 */
 	if (!head_desc->more)
-		rmap_head->val = 0;
+		*rmap_val = 0;
 	else
-		rmap_head->val = (unsigned long)head_desc->more | KVM_RMAP_MANY;
+		*rmap_val = (unsigned long)head_desc->more | KVM_RMAP_MANY;
 	mmu_free_pte_list_desc(head_desc);
 }
 
@@ -994,24 +1001,26 @@ static void pte_list_remove(struct kvm *kvm, u64 *spte,
 			    struct kvm_rmap_head *rmap_head)
 {
 	struct pte_list_desc *desc;
+	unsigned long rmap_val;
 	int i;
 
-	if (KVM_BUG_ON_DATA_CORRUPTION(!rmap_head->val, kvm))
-		return;
+	rmap_val = rmap_head->val;
+	if (KVM_BUG_ON_DATA_CORRUPTION(!rmap_val, kvm))
+		goto out;
 
-	if (!(rmap_head->val & KVM_RMAP_MANY)) {
-		if (KVM_BUG_ON_DATA_CORRUPTION((u64 *)rmap_head->val != spte, kvm))
-			return;
+	if (!(rmap_val & KVM_RMAP_MANY)) {
+		if (KVM_BUG_ON_DATA_CORRUPTION((u64 *)rmap_val != spte, kvm))
+			goto out;
 
-		rmap_head->val = 0;
+		rmap_val = 0;
 	} else {
-		desc = (struct pte_list_desc *)(rmap_head->val & ~KVM_RMAP_MANY);
+		desc = (struct pte_list_desc *)(rmap_val & ~KVM_RMAP_MANY);
 		while (desc) {
 			for (i = 0; i < desc->spte_count; ++i) {
 				if (desc->sptes[i] == spte) {
-					pte_list_desc_remove_entry(kvm, rmap_head,
+					pte_list_desc_remove_entry(kvm, &rmap_val,
 								   desc, i);
-					return;
+					goto out;
 				}
 			}
 			desc = desc->more;
@@ -1019,6 +1028,9 @@ static void pte_list_remove(struct kvm *kvm, u64 *spte,
 
 		KVM_BUG_ON_DATA_CORRUPTION(true, kvm);
 	}
+
+out:
+	rmap_head->val = rmap_val;
 }
 
 static void kvm_zap_one_rmap_spte(struct kvm *kvm,
@@ -1033,17 +1045,19 @@ static bool kvm_zap_all_rmap_sptes(struct kvm *kvm,
 				   struct kvm_rmap_head *rmap_head)
 {
 	struct pte_list_desc *desc, *next;
+	unsigned long rmap_val;
 	int i;
 
-	if (!rmap_head->val)
+	rmap_val = rmap_head->val;
+	if (!rmap_val)
 		return false;
 
-	if (!(rmap_head->val & KVM_RMAP_MANY)) {
-		mmu_spte_clear_track_bits(kvm, (u64 *)rmap_head->val);
+	if (!(rmap_val & KVM_RMAP_MANY)) {
+		mmu_spte_clear_track_bits(kvm, (u64 *)rmap_val);
 		goto out;
 	}
 
-	desc = (struct pte_list_desc *)(rmap_head->val & ~KVM_RMAP_MANY);
+	desc = (struct pte_list_desc *)(rmap_val & ~KVM_RMAP_MANY);
 
 	for (; desc; desc = next) {
 		for (i = 0; i < desc->spte_count; i++)
@@ -1059,14 +1073,15 @@ static bool kvm_zap_all_rmap_sptes(struct kvm *kvm,
 
 unsigned int pte_list_count(struct kvm_rmap_head *rmap_head)
 {
+	unsigned long rmap_val = rmap_head->val;
 	struct pte_list_desc *desc;
 
-	if (!rmap_head->val)
+	if (!rmap_val)
 		return 0;
-	else if (!(rmap_head->val & KVM_RMAP_MANY))
+	else if (!(rmap_val & KVM_RMAP_MANY))
 		return 1;
 
-	desc = (struct pte_list_desc *)(rmap_head->val & ~KVM_RMAP_MANY);
+	desc = (struct pte_list_desc *)(rmap_val & ~KVM_RMAP_MANY);
 	return desc->tail_count + desc->spte_count;
 }
 
@@ -1109,6 +1124,7 @@ static void rmap_remove(struct kvm *kvm, u64 *spte)
  */
 struct rmap_iterator {
 	/* private fields */
+	struct rmap_head *head;
 	struct pte_list_desc *desc;	/* holds the sptep if not NULL */
 	int pos;			/* index of the sptep */
 };
@@ -1123,18 +1139,19 @@ struct rmap_iterator {
 static u64 *rmap_get_first(struct kvm_rmap_head *rmap_head,
 			   struct rmap_iterator *iter)
 {
+	unsigned long rmap_val = rmap_head->val;
 	u64 *sptep;
 
-	if (!rmap_head->val)
+	if (!rmap_val)
 		return NULL;
 
-	if (!(rmap_head->val & KVM_RMAP_MANY)) {
+	if (!(rmap_val & KVM_RMAP_MANY)) {
 		iter->desc = NULL;
-		sptep = (u64 *)rmap_head->val;
+		sptep = (u64 *)rmap_val;
 		goto out;
 	}
 
-	iter->desc = (struct pte_list_desc *)(rmap_head->val & ~KVM_RMAP_MANY);
+	iter->desc = (struct pte_list_desc *)(rmap_val & ~KVM_RMAP_MANY);
 	iter->pos = 0;
 	sptep = iter->desc->sptes[iter->pos];
 out:
-- 
2.46.0.792.g87dc391469-goog


