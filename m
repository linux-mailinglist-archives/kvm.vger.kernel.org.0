Return-Path: <kvm+bounces-30779-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DCEEB9BD53D
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 19:48:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6EB151F26777
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 18:48:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C75111F7097;
	Tue,  5 Nov 2024 18:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kvpTMSQ8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 236391F5853
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 18:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730832232; cv=none; b=TY44G1qtKIoYoPQVpBnDHDVCW0Z+tmFB2PLItmsiiDK/0yTvseI98KjU1E9r4Ig4bidSqCjK9SugOl6NE8wxtcAxQd0eIraxc2nUA2G51dPDsUiIKxbN2ML5unEW9/Qpvo1pFPoFgQnTyGyQ1Y0xEY8nbRjdeI7y0MwJWvOEKAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730832232; c=relaxed/simple;
	bh=/9mxq13o/uI7Wr1lsTwiFyHNtgH8HeYaRMTy0Q8kkE8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HEpRINOGZxPaGOrl52kN1sbrMdiJWQt1KVKBe0RL7EndUJphXQmBnJOR4A7U5I9/mRDA81XP52FNQyveX0GMoAH6QM0+aG3Mf6F9Qr6OjfNO3Z2IICLwfIu4y61noN2zkDohPvFWNzNw5wStG6Qjv7nHEPiSwaSrr531HAQhs1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kvpTMSQ8; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e28fc60660dso8535780276.0
        for <kvm@vger.kernel.org>; Tue, 05 Nov 2024 10:43:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730832230; x=1731437030; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wIDLC6t/sMMMxR2BsSETZhKknrKZVVywOqJrGrnhMso=;
        b=kvpTMSQ8J2x4KojnB46JtWhIWcdwOHN9TMSkndWsL+/kl5oXygcNOvZwCl9I++3RTs
         urXgAR0D38VqhGXhp2WnkiANacQfd8HWN7tMSeROaAUHOgQQ2YdD1b0N9kb17A1rpOEJ
         lySB8sXX+nHp07I7wtUDbY4dUYN8PHBFtbd5OMUTRfvITWXh1489tVCgdAIlOeR+B84p
         GNEiZYL5Xnl2v/HG7fpXqQeNMY6J0kzHq1FhYTkYgtVzsejrZW9npZfSQMsKiPLcuHdp
         xEKoUiX1SUqEbCTdny4kbFhgUnimO7SLaadC638Tntp+HeGkV+7bgLscXDT7rPqHR/24
         SQwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730832230; x=1731437030;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wIDLC6t/sMMMxR2BsSETZhKknrKZVVywOqJrGrnhMso=;
        b=eXMw+18R1Xhsgu8NW0RyB4VH2XPsGfu/MvkCgHF4+Ei9+u7qJZsFxCEFyCPt8repBn
         KF3yBb0PDom7tpWRNtRbFCvp2Reh3khw0ohEV9rY0els93TtbW/QwnZJ4woO5sLwuciY
         p8FoRIKjLS3i0F5Mckkt7DR+gpH6gdch7mgquD9iMnXEifOjVhrfUdRHbMNn1hcSQG2j
         QzD228/o5jgv7iLsCUOuPHU6aGABdYYWX7nVuKCLm8Zr5Gt3yKzDWGUXaO7bW8kCsXfE
         H2DZBXImO40XhFldkFj9QrJBBkkl+Cij4uaQ2s1UO8F5BQBGkieuXC4pTR7hmpJcValq
         WL8g==
X-Forwarded-Encrypted: i=1; AJvYcCU/aiK8teFP6V+O6oMCGv2fhcN4XACMm7uzCN2GhM9roUXa/b7hmMnoGYs81PTTuLH/miA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzrDbfTEjVTVzGzXNR9nnPttjtFB4CM8vVrTNvYfGihWOM3excv
	Sc2E5bdNMIvA+N5JJLl5ViYHXHs2yI1q7bmAcjd/nYn35/Ny/vStBnGAxn75C4sEU0G6eqkU2+4
	LWHX0S+3SSla/B00xdg==
X-Google-Smtp-Source: AGHT+IHnX5S3d+fPX7LL8o5N7U0OFXGCdCj7VT0GdmujEtmN9uhXC8UXR6GXgHOI3eq/3/wi+mADnEOa9Ep1inMP
X-Received: from jthoughton.c.googlers.com ([fda3:e722:ac3:cc00:13d:fb22:ac12:a84b])
 (user=jthoughton job=sendgmr) by 2002:a25:a207:0:b0:e25:6701:410b with SMTP
 id 3f1490d57ef6-e3087b792abmr83276276.5.1730832230072; Tue, 05 Nov 2024
 10:43:50 -0800 (PST)
Date: Tue,  5 Nov 2024 18:43:29 +0000
In-Reply-To: <20241105184333.2305744-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241105184333.2305744-1-jthoughton@google.com>
X-Mailer: git-send-email 2.47.0.199.ga7371fff76-goog
Message-ID: <20241105184333.2305744-8-jthoughton@google.com>
Subject: [PATCH v8 07/11] KVM: x86/mmu: Refactor low level rmap helpers to
 prep for walking w/o mmu_lock
From: James Houghton <jthoughton@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	James Houghton <jthoughton@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Wei Xu <weixugc@google.com>, Yu Zhao <yuzhao@google.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

From: Sean Christopherson <seanjc@google.com>

Refactor the pte_list and rmap code to always read and write rmap_head->val
exactly once, e.g. by collecting changes in a local variable and then
propagating those changes back to rmap_head->val as appropriate.  This will
allow implementing a per-rmap rwlock (of sorts) by adding a LOCKED bit into
the rmap value alongside the MANY bit.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: James Houghton <jthoughton@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 83 +++++++++++++++++++++++++-----------------
 1 file changed, 50 insertions(+), 33 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 125d4c3ccceb..145ea180963e 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -858,21 +858,24 @@ static struct kvm_memory_slot *gfn_to_memslot_dirty_bitmap(struct kvm_vcpu *vcpu
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
@@ -881,21 +884,25 @@ static int pte_list_add(struct kvm_mmu_memory_cache *cache, u64 *spte,
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
@@ -922,9 +929,9 @@ static void pte_list_desc_remove_entry(struct kvm *kvm,
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
 
@@ -932,24 +939,26 @@ static void pte_list_remove(struct kvm *kvm, u64 *spte,
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
@@ -957,6 +966,9 @@ static void pte_list_remove(struct kvm *kvm, u64 *spte,
 
 		KVM_BUG_ON_DATA_CORRUPTION(true, kvm);
 	}
+
+out:
+	rmap_head->val = rmap_val;
 }
 
 static void kvm_zap_one_rmap_spte(struct kvm *kvm,
@@ -971,17 +983,19 @@ static bool kvm_zap_all_rmap_sptes(struct kvm *kvm,
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
@@ -997,14 +1011,15 @@ static bool kvm_zap_all_rmap_sptes(struct kvm *kvm,
 
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
 
@@ -1047,6 +1062,7 @@ static void rmap_remove(struct kvm *kvm, u64 *spte)
  */
 struct rmap_iterator {
 	/* private fields */
+	struct rmap_head *head;
 	struct pte_list_desc *desc;	/* holds the sptep if not NULL */
 	int pos;			/* index of the sptep */
 };
@@ -1061,18 +1077,19 @@ struct rmap_iterator {
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
2.47.0.199.ga7371fff76-goog


