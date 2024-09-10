Return-Path: <kvm+bounces-26399-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3431397469C
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 01:47:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 583E71C212F1
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 23:47:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BCC71BA287;
	Tue, 10 Sep 2024 23:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YMpFDJHc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 805A71B6520
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 23:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726011887; cv=none; b=U9OQcZuhVBEthSolM1Qfj832JeVDaR+wmNUBsXIF+/thJ4aq4jAKv3ZOwedDo4PIXWurIBbGPZDQRxbINthhtMM098X5xadVkEFV9dTlsIKAc06N64scIL4zg1s7redvL4of8R7Sbim2Zf5mtRseNIePNO3fQK/Gzt33LOdJr+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726011887; c=relaxed/simple;
	bh=K2LzTAiIRtOE5clnGSJ+0g05nFLVoKPOdw852v0pmCA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hnabooVCsQEOZUnnnoDBjQ8vbDJ3uaimgQgmxNVpgcgHpm6nllykh1eZ5YouHSFLwHyKQ3dhyiTGieYy4aartyR77RX9YFG8k4Pn5np9iLO+2bC2WJy+SAUz5btoM1VFHfJrLM4EMmfg7zyNI+fis2AY/qm0E0jsPcVvsXk3T4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YMpFDJHc; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-205529c3402so80424705ad.0
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 16:44:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726011885; x=1726616685; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5f8yQFUffYPzUq824ZihetLpeNkj57gNWJVxt7QoH4Y=;
        b=YMpFDJHcEYokKYHR+LZ3dXpbKws8RDrgYPeZNBFjUwRqpCDbXDaANTSv0upDLn8jkG
         Ig11OBcRMsHhzECs6KqeqOtXN44sY49PxN5NUJQx/0OxvrVcRh37hWqUo0bcmA02yaix
         25IxB1Tqwra+3B2lx1pAo0f2mLx+Gc/fMWMdrrrq2SHoFj1Mq+8l6nzLQFmMxUcBuEYU
         x5TlcwYpBJ5xpgP2ggD/R947WCEl4GIrp6sVQQ0+YaBPi5eI+75RTYNmQI1r2FET2Dzk
         F+6tFcjfeQfUNFddXvFWxiB2JV5J3TLfR0iWP3mHw/XJCVN9NWBFc4tzjHIORhd6Rdw3
         VW1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726011885; x=1726616685;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5f8yQFUffYPzUq824ZihetLpeNkj57gNWJVxt7QoH4Y=;
        b=KYi6RM/97nflVScq317CdHlMoDNwXHWn/WLgo9g4dB/9xeN410SfsVTVDDWeXTIsAL
         6j4iXebhHSfu/hZcaJTCrjIfBqfJQVXmDigqm/Qhvq5StLKuE4rw3Ckrc3/xMFbN3f5d
         +1y45ki5PX4SRjpeqowvasb1oRZjFFBkgvJJ94mkh26/wYvQC+w1K7ot3KPkNqE8hL/c
         t2mRja8yUiMVd7W2DJYdvydIuBLI7qZ+ac0xFs0VH90+yuIHoqIeBwwNpnUoPUFSf+W/
         0xb3HtebH53KGoBuEutV9RxZl/cpYZJCTbcFC4/we1cop3ZCPvPeXNv9zYWgOSGAJbs8
         ECtQ==
X-Forwarded-Encrypted: i=1; AJvYcCUa90ncFlwmzYvml/L/Iy/kJLgBzg9eXrZZXjC0XDZrIO8V6l+fqqS4C6sIHJco6m0vC0A=@vger.kernel.org
X-Gm-Message-State: AOJu0YyDJbyM8dvHFKmUlxVSRVZ//OOZ0QdqVR5yfhHuFy8CcHeNa8I2
	YbDJrAD29rI9cOmWnAcqbTPkrLwm7FNfqx1zfNNpA37xhQ5nE7hhjQUDS/NQizdKvIGbawLymXg
	+8wPAk9myMEigtIYjWrZl8Q==
X-Google-Smtp-Source: AGHT+IEMrn0OqAypgUQC+spX1CPlDQJLfBB8w26Ns2KNptOMPv9ijUEGA9m5hBvK895d2wE0z6f+lmJkIjqr2SJ6OA==
X-Received: from ackerleytng-ctop.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:13f8])
 (user=ackerleytng job=sendgmr) by 2002:a17:903:1ca:b0:206:aa07:b62 with SMTP
 id d9443c01a7336-2074c5f2a6emr2330595ad.5.1726011884521; Tue, 10 Sep 2024
 16:44:44 -0700 (PDT)
Date: Tue, 10 Sep 2024 23:43:38 +0000
In-Reply-To: <cover.1726009989.git.ackerleytng@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1726009989.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.46.0.598.g6f2099f65c-goog
Message-ID: <7348091f4c539ed207d9bb0f3744d0f0efb7f2b3.1726009989.git.ackerleytng@google.com>
Subject: [RFC PATCH 07/39] mm: hugetlb: Refactor out hugetlb_alloc_folio
From: Ackerley Tng <ackerleytng@google.com>
To: tabba@google.com, quic_eberman@quicinc.com, roypat@amazon.co.uk, 
	jgg@nvidia.com, peterx@redhat.com, david@redhat.com, rientjes@google.com, 
	fvdl@google.com, jthoughton@google.com, seanjc@google.com, 
	pbonzini@redhat.com, zhiquan1.li@intel.com, fan.du@intel.com, 
	jun.miao@intel.com, isaku.yamahata@intel.com, muchun.song@linux.dev, 
	mike.kravetz@oracle.com
Cc: erdemaktas@google.com, vannapurve@google.com, ackerleytng@google.com, 
	qperret@google.com, jhubbard@nvidia.com, willy@infradead.org, 
	shuah@kernel.org, brauner@kernel.org, bfoster@redhat.com, 
	kent.overstreet@linux.dev, pvorel@suse.cz, rppt@kernel.org, 
	richard.weiyang@gmail.com, anup@brainfault.org, haibo1.xu@intel.com, 
	ajones@ventanamicro.com, vkuznets@redhat.com, maciej.wieczor-retman@intel.com, 
	pgonda@google.com, oliver.upton@linux.dev, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-fsdevel@kvack.org
Content-Type: text/plain; charset="UTF-8"

hugetlb_alloc_folio() allocates a hugetlb folio without handling
reservations in the vma and subpool, since some of that reservation
concepts are hugetlbfs specific.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 include/linux/hugetlb.h |  12 ++++
 mm/hugetlb.c            | 144 ++++++++++++++++++++++++----------------
 2 files changed, 98 insertions(+), 58 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index c9bf68c239a0..e4a05a421623 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -690,6 +690,10 @@ struct huge_bootmem_page {
 };
 
 int isolate_or_dissolve_huge_page(struct page *page, struct list_head *list);
+struct folio *hugetlb_alloc_folio(struct hstate *h, struct mempolicy *mpol,
+				  int nid, nodemask_t *nodemask,
+				  bool charge_cgroup_reservation,
+				  bool use_hstate_resv);
 struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 				unsigned long addr, int avoid_reserve);
 struct folio *alloc_hugetlb_folio_nodemask(struct hstate *h, int preferred_nid,
@@ -1027,6 +1031,14 @@ static inline int isolate_or_dissolve_huge_page(struct page *page,
 	return -ENOMEM;
 }
 
+static inline struct folio *
+hugetlb_alloc_folio(struct hstate *h, struct mempolicy *mpol, int nid,
+		    nodemask_t *nodemask, bool charge_cgroup_reservation,
+		    bool use_hstate_resv)
+{
+	return NULL;
+}
+
 static inline struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 					   unsigned long addr,
 					   int avoid_reserve)
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index e341bc0eb49a..7e73ebcc0f26 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3106,6 +3106,75 @@ int isolate_or_dissolve_huge_page(struct page *page, struct list_head *list)
 	return ret;
 }
 
+/**
+ * Allocates a hugetlb folio either by dequeueing or from buddy allocator.
+ */
+struct folio *hugetlb_alloc_folio(struct hstate *h, struct mempolicy *mpol,
+				  int nid, nodemask_t *nodemask,
+				  bool charge_cgroup_reservation,
+				  bool use_hstate_resv)
+{
+	struct hugetlb_cgroup *h_cg = NULL;
+	struct folio *folio;
+	int ret;
+	int idx;
+
+	idx = hstate_index(h);
+
+	if (charge_cgroup_reservation) {
+		ret = hugetlb_cgroup_charge_cgroup_rsvd(
+			idx, pages_per_huge_page(h), &h_cg);
+		if (ret)
+			return NULL;
+	}
+
+	ret = hugetlb_cgroup_charge_cgroup(idx, pages_per_huge_page(h), &h_cg);
+	if (ret)
+		goto err_uncharge_cgroup_reservation;
+
+	spin_lock_irq(&hugetlb_lock);
+
+	folio = dequeue_hugetlb_folio(h, mpol, nid, nodemask, use_hstate_resv);
+	if (!folio) {
+		spin_unlock_irq(&hugetlb_lock);
+
+		folio = alloc_buddy_hugetlb_folio_from_node(h, mpol, nid, nodemask);
+		if (!folio)
+			goto err_uncharge_cgroup;
+
+		spin_lock_irq(&hugetlb_lock);
+		if (use_hstate_resv) {
+			folio_set_hugetlb_restore_reserve(folio);
+			h->resv_huge_pages--;
+		}
+		list_add(&folio->lru, &h->hugepage_activelist);
+		folio_ref_unfreeze(folio, 1);
+		/* Fall through */
+	}
+
+	hugetlb_cgroup_commit_charge(idx, pages_per_huge_page(h), h_cg, folio);
+
+	if (charge_cgroup_reservation) {
+		hugetlb_cgroup_commit_charge_rsvd(idx, pages_per_huge_page(h),
+						  h_cg, folio);
+	}
+
+	spin_unlock_irq(&hugetlb_lock);
+
+	return folio;
+
+err_uncharge_cgroup:
+	hugetlb_cgroup_uncharge_cgroup(idx, pages_per_huge_page(h), h_cg);
+
+err_uncharge_cgroup_reservation:
+	if (charge_cgroup_reservation) {
+		hugetlb_cgroup_uncharge_cgroup_rsvd(idx, pages_per_huge_page(h),
+						    h_cg);
+	}
+
+	return NULL;
+}
+
 struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 				    unsigned long addr, int avoid_reserve)
 {
@@ -3114,11 +3183,10 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 	struct folio *folio;
 	long map_chg, map_commit, nr_pages = pages_per_huge_page(h);
 	long gbl_chg;
-	int memcg_charge_ret, ret, idx;
-	struct hugetlb_cgroup *h_cg = NULL;
+	int memcg_charge_ret;
 	struct mem_cgroup *memcg;
-	bool deferred_reserve;
-	gfp_t gfp = htlb_alloc_mask(h) | __GFP_RETRY_MAYFAIL;
+	bool charge_cgroup_reservation;
+	gfp_t gfp = htlb_alloc_mask(h);
 	bool use_hstate_resv;
 	struct mempolicy *mpol;
 	nodemask_t *nodemask;
@@ -3126,13 +3194,14 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 	int nid;
 
 	memcg = get_mem_cgroup_from_current();
-	memcg_charge_ret = mem_cgroup_hugetlb_try_charge(memcg, gfp, nr_pages);
+	memcg_charge_ret =
+		mem_cgroup_hugetlb_try_charge(memcg, gfp | __GFP_RETRY_MAYFAIL,
+					      nr_pages);
 	if (memcg_charge_ret == -ENOMEM) {
 		mem_cgroup_put(memcg);
 		return ERR_PTR(-ENOMEM);
 	}
 
-	idx = hstate_index(h);
 	/*
 	 * Examine the region/reserve map to determine if the process
 	 * has a reservation for the page to be allocated.  A return
@@ -3160,57 +3229,22 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 
 	}
 
-	/* If this allocation is not consuming a reservation, charge it now.
-	 */
-	deferred_reserve = map_chg || avoid_reserve;
-	if (deferred_reserve) {
-		ret = hugetlb_cgroup_charge_cgroup_rsvd(
-			idx, pages_per_huge_page(h), &h_cg);
-		if (ret)
-			goto out_subpool_put;
-	}
-
-	ret = hugetlb_cgroup_charge_cgroup(idx, pages_per_huge_page(h), &h_cg);
-	if (ret)
-		goto out_uncharge_cgroup_reservation;
-
 	use_hstate_resv = should_use_hstate_resv(vma, gbl_chg, avoid_reserve);
 
-	spin_lock_irq(&hugetlb_lock);
+	/*
+	 * charge_cgroup_reservation if this allocation is not consuming a
+	 * reservation
+	 */
+	charge_cgroup_reservation = map_chg || avoid_reserve;
 
 	mpol = get_vma_policy(vma, addr, hstate_vma(vma)->order, &ilx);
-	nid = policy_node_nodemask(mpol, htlb_alloc_mask(h), ilx, &nodemask);
-	folio = dequeue_hugetlb_folio(h, mpol, nid, nodemask, use_hstate_resv);
-	if (!folio) {
-		spin_unlock_irq(&hugetlb_lock);
-
-		folio = alloc_buddy_hugetlb_folio_from_node(h, mpol, nid, nodemask);
-		if (!folio) {
-			mpol_cond_put(mpol);
-			goto out_uncharge_cgroup;
-		}
-
-		spin_lock_irq(&hugetlb_lock);
-		if (use_hstate_resv) {
-			folio_set_hugetlb_restore_reserve(folio);
-			h->resv_huge_pages--;
-		}
-		list_add(&folio->lru, &h->hugepage_activelist);
-		folio_ref_unfreeze(folio, 1);
-		/* Fall through */
-	}
+	nid = policy_node_nodemask(mpol, gfp, ilx, &nodemask);
+	folio = hugetlb_alloc_folio(h, mpol, nid, nodemask,
+				    charge_cgroup_reservation, use_hstate_resv);
 	mpol_cond_put(mpol);
 
-	hugetlb_cgroup_commit_charge(idx, pages_per_huge_page(h), h_cg, folio);
-	/* If allocation is not consuming a reservation, also store the
-	 * hugetlb_cgroup pointer on the page.
-	 */
-	if (deferred_reserve) {
-		hugetlb_cgroup_commit_charge_rsvd(idx, pages_per_huge_page(h),
-						  h_cg, folio);
-	}
-
-	spin_unlock_irq(&hugetlb_lock);
+	if (!folio)
+		goto out_subpool_put;
 
 	hugetlb_set_folio_subpool(folio, spool);
 
@@ -3229,7 +3263,7 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 
 		rsv_adjust = hugepage_subpool_put_pages(spool, 1);
 		hugetlb_acct_memory(h, -rsv_adjust);
-		if (deferred_reserve) {
+		if (charge_cgroup_reservation) {
 			spin_lock_irq(&hugetlb_lock);
 			hugetlb_cgroup_uncharge_folio_rsvd(hstate_index(h),
 					pages_per_huge_page(h), folio);
@@ -3243,12 +3277,6 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 
 	return folio;
 
-out_uncharge_cgroup:
-	hugetlb_cgroup_uncharge_cgroup(idx, pages_per_huge_page(h), h_cg);
-out_uncharge_cgroup_reservation:
-	if (deferred_reserve)
-		hugetlb_cgroup_uncharge_cgroup_rsvd(idx, pages_per_huge_page(h),
-						    h_cg);
 out_subpool_put:
 	if (map_chg || avoid_reserve)
 		hugepage_subpool_put_pages(spool, 1);
-- 
2.46.0.598.g6f2099f65c-goog


