Return-Path: <kvm+bounces-37199-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 419E2A268C0
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 01:43:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D56FC1886558
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 00:43:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F165F13A265;
	Tue,  4 Feb 2025 00:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BZa0f4/b"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vs1-f73.google.com (mail-vs1-f73.google.com [209.85.217.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9688142659
	for <kvm@vger.kernel.org>; Tue,  4 Feb 2025 00:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738629664; cv=none; b=RSIp9FiIgEoxICYJ1+B2le36AkW2R9/puaYntf5F6M0lnxwDEwW3DDg1dUcEGOLEIIhwT5sOG2zl2RmfEkmNhp/njUYlH3AwCpHKBUHfvrctHXcQ9NC1Zr2Kw1Z78Vc+kOS+tEHrApB+lPJHo9iz9k3NpZLah3/0er6wveeTp6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738629664; c=relaxed/simple;
	bh=NQkRdnDJ8oV4CwyBueAB1Gp67A6naYtqcTLSaIZ4KK0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ACWbX1JoviaGmc7dqBiTs9MdAMPnlJplVJAXY1isUvTX/nupprlrh7QuXoUoZoAeaETg8QxkyawimPr7aOC0mgTx2igUzAPfgdURvjMR6LDOiijBe6WAcbzOk/Th4hZk1De/sLyabl1oeBHU4R+VUhRXCLw5RzLqJU/feTrsoGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BZa0f4/b; arc=none smtp.client-ip=209.85.217.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-vs1-f73.google.com with SMTP id ada2fe7eead31-4b68cedd094so545882137.1
        for <kvm@vger.kernel.org>; Mon, 03 Feb 2025 16:41:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738629662; x=1739234462; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8RxCUl1rGMBFv/rhBwFBhZEDraoafq6dJ5Zr6afNrok=;
        b=BZa0f4/bhrWVGpv+YEUObPz7sJvXj9npm3BC7KUsWiKt14n/FMg+RQmHYK3ow1BcOB
         Y0MwaU4ymlFYQrnnjEsavPWCVmexxO0q7rncpa1kbf/rqu77mYAh4VLit4/LlzQ/VA1P
         FeH/1NleT1LVuvVUl4uKO0oMWmSyBGvpheiAo5l+/sMlg5ob75Ww2zhEbHVlmD6Ht9N2
         3hI3AHM2WSqaxctabcERXNHd1oWLfaRejnongDA6eyOL9tk+nm+itcmeBt01B1qDEFlq
         aLYW7MI2eN1uF96IOwbVpHgxY3wXczPcpVCtMtTRrPMEJKaubxDVtTOkT+1aRQP9B/yA
         h7ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738629662; x=1739234462;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8RxCUl1rGMBFv/rhBwFBhZEDraoafq6dJ5Zr6afNrok=;
        b=nqZ0N64mn0T2dShu19XHxuZieqLE9Csn3/rOBQjA/WHL5PC+CUG6ovvl6tbE7MnrdN
         cWXgbnj1qkH0VM+tuSic0M/I7zyAEkNZvQVAf1CD5cAs2VzySW2+xCDOBYFnzu/lkdmh
         T0Nryte0nMrSebGaYnosQohgIPR110zgO9FQZFFe5GgB8YA/hTCuFHxIi5fEWOscj31c
         1FHxcBBW3i05A99g1CQsNtmgmDeH0dX6V9yQVa9lhvX/vx09CiP/cOsrGdtJJ+28q8U5
         a6kEtrQ//Eb5k4mfpeBj1yjWGBPvuznNSbWwcgYeksl+PaC/emt6RqRSiDafN93/PIo3
         9D+w==
X-Forwarded-Encrypted: i=1; AJvYcCVIpk5YDki5ZUWigfpVJhHKZ9506OSQNxikGE7yJSI3dcbYLefUKYghjmyjZFyqvJegmV8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwkQUYyJpTQOyrGTIj1o+WhuhaCmrWZt7KuGH6JTx2GHcOfwrbl
	Art+cE9V3YN0pQziStA2ObbGuB9l44c/OO5PeupgPStObHjhOW0bD3vG/F6nkRJuI78W0e4Grot
	BUZXZ7DqU+TVVY1Df5A==
X-Google-Smtp-Source: AGHT+IGaTi9ZNq9xOes9fU6YyaVEV8EpFgnNHamMKa9cr3UKjn+KasYzgH/SPpIJ+0LGZyE7LGqO1tR+XsBjYhsh
X-Received: from vsvg20.prod.google.com ([2002:a05:6102:1594:b0:4af:b35d:162c])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6102:5e8b:b0:4af:e5fd:77fc with SMTP id ada2fe7eead31-4b9a4ebe487mr20551082137.3.1738629661703;
 Mon, 03 Feb 2025 16:41:01 -0800 (PST)
Date: Tue,  4 Feb 2025 00:40:35 +0000
In-Reply-To: <20250204004038.1680123-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250204004038.1680123-1-jthoughton@google.com>
X-Mailer: git-send-email 2.48.1.362.g079036d154-goog
Message-ID: <20250204004038.1680123-9-jthoughton@google.com>
Subject: [PATCH v9 08/11] KVM: x86/mmu: Refactor low level rmap helpers to
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
index f75779d8d6fd..a24cf8ddca7f 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -864,21 +864,24 @@ static struct kvm_memory_slot *gfn_to_memslot_dirty_bitmap(struct kvm_vcpu *vcpu
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
@@ -887,21 +890,25 @@ static int pte_list_add(struct kvm_mmu_memory_cache *cache, u64 *spte,
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
@@ -928,9 +935,9 @@ static void pte_list_desc_remove_entry(struct kvm *kvm,
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
 
@@ -938,24 +945,26 @@ static void pte_list_remove(struct kvm *kvm, u64 *spte,
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
@@ -963,6 +972,9 @@ static void pte_list_remove(struct kvm *kvm, u64 *spte,
 
 		KVM_BUG_ON_DATA_CORRUPTION(true, kvm);
 	}
+
+out:
+	rmap_head->val = rmap_val;
 }
 
 static void kvm_zap_one_rmap_spte(struct kvm *kvm,
@@ -977,17 +989,19 @@ static bool kvm_zap_all_rmap_sptes(struct kvm *kvm,
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
@@ -1003,14 +1017,15 @@ static bool kvm_zap_all_rmap_sptes(struct kvm *kvm,
 
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
 
@@ -1053,6 +1068,7 @@ static void rmap_remove(struct kvm *kvm, u64 *spte)
  */
 struct rmap_iterator {
 	/* private fields */
+	struct rmap_head *head;
 	struct pte_list_desc *desc;	/* holds the sptep if not NULL */
 	int pos;			/* index of the sptep */
 };
@@ -1067,18 +1083,19 @@ struct rmap_iterator {
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
2.48.1.362.g079036d154-goog


