Return-Path: <kvm+bounces-23792-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E22B94D7A7
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 21:48:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5302D1C22935
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 19:48:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5069119AA75;
	Fri,  9 Aug 2024 19:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JeOmsrn8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C57019A280
	for <kvm@vger.kernel.org>; Fri,  9 Aug 2024 19:44:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723232654; cv=none; b=KkKxLsYgoi3GYlZAZBY8WcXn1ScMoW5Im/BObqXtH7li/xDASLB5zjfR+vmT2BnoBX/UlRi4VFUEg+Md9hHCD/2K2WKoz6XwmB4o97QW+YPmrmjrHNYEHVzS4liRxsDhgp7UiuQ+BLLkDKG/4rkBJ664YZjJu5UEhUqT4McudqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723232654; c=relaxed/simple;
	bh=KiAcec9zQkYgeR0W9i8MR49CVqVo71Q4X9zgQyrpB/0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tpnNzIyqzZzRg/vH20mJSz6t6DsyvFzGkukufVZ3sHMtkIROg4aJ1XMjv5FLABOcE68vaZwgLJFbK2fsUad+0VrYxjD4zYZNpLAL3Vqg+0ixlZ4NhQMFzbttCT/rfqJ6W7CUDEI1JfOBd7won2f3JDV+PZRE71jewG4hzmG2cMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JeOmsrn8; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-7a242496897so2350059a12.2
        for <kvm@vger.kernel.org>; Fri, 09 Aug 2024 12:44:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723232652; x=1723837452; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=LJq/GJ0moPmdVQ8FJN/LFNxKQSz1PiS8pWAScNqsM+k=;
        b=JeOmsrn85iNSMEOfGAbluITjOVjH7/ODm5wI5Xc5P6E/CDN5hcORuyFfFbjPhBAsne
         3TASZGUndyPHczwmB/cfFV79gMgrpXLzwD5iXaOQrNIGXLQgboG+yVaI5a72DDjEpaXR
         rwMnwc0EYi612YYOmEc9OlpTKeOlyNuU/W7EaJCCSK7WFp6juLnrYwnuEMdANW36t34m
         4+W8AC21Tg1UhUHUWxz/Ts8vCSIpJRrszFmJed8+LPAOIquxyGXMIg2w0sXVoHovIcYO
         wEePlIftCbuFQ9xewWaiKu+KmZR9MHT+wJH8A6XLUCRQRKn3jn26PQeOQHnl+Tq5zrAH
         JGKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723232652; x=1723837452;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LJq/GJ0moPmdVQ8FJN/LFNxKQSz1PiS8pWAScNqsM+k=;
        b=m27UTK1olgsfLXaG7lWBe6z1/4Hfyj/ZO/3MwEhyN9cS6eSFF//0dU+ihw/kEJ8tQX
         Ge89xoMhjiJhDXJWFJuXY+Bz/PfFljkFWyEOgerujsHgKynpjXPRcU7plF/rMCCxT1Fw
         upFtFktrA8hjg5ND7qjyKVWa6LqhzvCe626eNtRqFl+va39lZqrncGe/ZKNfj7N7Sp5W
         +o6u3KjedPUnWjUoBD0jV3b9GVzSAP2k1i3nmwYqivoqBSMBa+KAqQx0bSEFhyzcf3yp
         lQ6lMp+ZJRiQnVk3Hh2EBdqZZgdqdXiaNRko6JZ9+7t00i1Z/eNC4VCCQsOxNSH4J9Oc
         Gy2Q==
X-Gm-Message-State: AOJu0YxWywn5OaB7VoqKSOZPc2Bni2dMuSFckfCiQq3d3ql36GTZYIm1
	YsDOC7asf6GIsS82EUo4V9MjZUExsIj0VDKTaYCkjxGIrkpWTa4xZJZ+8qt7t4jSF2k+Ab2vE7u
	5Qg==
X-Google-Smtp-Source: AGHT+IG9iS1KQa10Rf8CvbcbSW/02Vokoqft8BTRa6S8EoVMPZ81K0TgdGJVD2ND164posnnJw8HgWteDns=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:3714:0:b0:717:a912:c302 with SMTP id
 41be03b00d2f7-7c3d2b78b02mr5155a12.1.1723232652349; Fri, 09 Aug 2024 12:44:12
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  9 Aug 2024 12:43:29 -0700
In-Reply-To: <20240809194335.1726916-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240809194335.1726916-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.76.ge559c4bf1a-goog
Message-ID: <20240809194335.1726916-18-seanjc@google.com>
Subject: [PATCH 17/22] KVM: x86/mmu: Refactor low level rmap helpers to prep
 for walking w/o mmu_lock
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, Peter Xu <peterx@redhat.com>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

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
index 73569979130d..49c1f6cc1526 100644
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
2.46.0.76.ge559c4bf1a-goog


