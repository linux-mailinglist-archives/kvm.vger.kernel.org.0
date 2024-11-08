Return-Path: <kvm+bounces-31297-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 332599C21EF
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 17:21:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EA0F9282900
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 16:21:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B42F199239;
	Fri,  8 Nov 2024 16:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LKbt33FQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C080C1922EE
	for <kvm@vger.kernel.org>; Fri,  8 Nov 2024 16:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731082854; cv=none; b=Qztds5y8Z7hOWocNpGCyXWWDVRm9kYe6dInE0O69tnh4Uopydp9Ln0x+AmMFW69B2WaT+QODYhQ4W1zW1fj5/y6xGO3Ux2Ajxekd78b497rdsxQceP9tuRlUtDeZQWbxpi8j6+0RwNam9oBYIHOTUoxDvf/zkl7HqtaEGoIbyrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731082854; c=relaxed/simple;
	bh=5JwsK3wSjv1NaYBbv9G/u6ImEqnjv/zsjlQjC4xc6fU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=N3GmY+RGT7JsU0Hf6wLgHNyfJsg/QZef875rPdQQW783RbUjT5S/TzmWlqH4mdj7aZ0ubiIk4WElmNthyowsLWvaJEiuCnFtLOLuxUF2+TJTBVLxSS+RUlZd/4btdFCHkLq+s2K9BsuR7f84cm7eZ8CifFl5kFwetJo+zYB+xGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LKbt33FQ; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6eae6aba6d4so8324257b3.3
        for <kvm@vger.kernel.org>; Fri, 08 Nov 2024 08:20:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1731082851; x=1731687651; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xoczasfH3EjGVlSybMjc91OekbCn/q1l859VFPlt17E=;
        b=LKbt33FQNEw2pCEiBJDa775kjEbdjaIvyErQuZ5cM6p5MIVGqE7guFXxNNuhrJvJl6
         vj42xLqUH3L/++D76OusPZ5pSQUvCQUG5MpsKU40BYrVX1SCqkb8CMq6WN7Pl5Pw5PTN
         +WfDZxmPDELd3yua6cNGMyY0dbM5J6gc+YWv3JOH4YLvMjjrkPAKpewIVzhVbN0lvTLD
         w85qlN8Zzf45lqXQEH8+iLzBrf9da0WtRqAabFZJP2tXZF6cT/wmZ+LHD27SJH75pBLP
         yS9ebVZed31tilvg/zgBA+j6Uguw7maio7zNtfMfpgzskzwc36dj4XeRRMav7DwB2QGu
         eYFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731082851; x=1731687651;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xoczasfH3EjGVlSybMjc91OekbCn/q1l859VFPlt17E=;
        b=WARNY7TVT2re9XupEv6pGfBfS9TQfrfb+tyJgmlebOt+RfWgP5eyb9VfFrO9A+5qGH
         w2lkey+Xl8AhI1r7qjgkEgATRvtA42w9fYnVCeRELmLyjarQvzx1lxpKXWlgCRQZTT5Y
         ytK6ICfbK9WqPUrhDiBECZnIq2aMiyk49NCkz/N+0VYtlM2/c2GEFzT1mv/Pk4JCsI2h
         M1O4u3nqllYINfdMbWbzAeCWxn7K7s+f53uWrZkAjrBSqYKBKwn7gBFkg5Uywxgf/Vrf
         il+Ep4nHqP1rqqOtYL/YQotQghE8Hk/ebXoveHmVQJlSfBm8otaoPeZlQhnTNMgDI7TF
         2qsw==
X-Gm-Message-State: AOJu0YxdC7hao2J3NGoGff6NjzRlBT5iIgNeDGusONH5FfH3qo6eIuwd
	WYX9iaTuRzJ3kTdWzRGlkNEC4F74kQeNVMqrOsHrfSdzYUJF5Vn5NnkDevOpuq58LrgoL1xgBw=
	=
X-Google-Smtp-Source: AGHT+IGi0dElEr9qu8fzvtM9cId0LpD1vPVzTDBDvUodGuNk9OVUxqdu5KHHQFxgVeqHmDaBFP7u+PMuDw==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:690c:4b13:b0:6ea:decd:84e with SMTP id
 00721157ae682-6eadecd0dd3mr590627b3.5.1731082851750; Fri, 08 Nov 2024
 08:20:51 -0800 (PST)
Date: Fri,  8 Nov 2024 16:20:34 +0000
In-Reply-To: <20241108162040.159038-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241108162040.159038-1-tabba@google.com>
X-Mailer: git-send-email 2.47.0.277.g8800431eea-goog
Message-ID: <20241108162040.159038-5-tabba@google.com>
Subject: [RFC PATCH v1 04/10] mm/hugetlb-cgroup: convert hugetlb_cgroup_css_offline()
 to work on folios
From: Fuad Tabba <tabba@google.com>
To: linux-mm@kvack.org
Cc: kvm@vger.kernel.org, nouveau@lists.freedesktop.org, 
	dri-devel@lists.freedesktop.org, david@redhat.com, rppt@kernel.org, 
	jglisse@redhat.com, akpm@linux-foundation.org, muchun.song@linux.dev, 
	simona@ffwll.ch, airlied@gmail.com, pbonzini@redhat.com, seanjc@google.com, 
	willy@infradead.org, jgg@nvidia.com, jhubbard@nvidia.com, 
	ackerleytng@google.com, vannapurve@google.com, mail@maciej.szmigiero.name, 
	kirill.shutemov@linux.intel.com, quic_eberman@quicinc.com, maz@kernel.org, 
	will@kernel.org, qperret@google.com, keirf@google.com, roypat@amazon.co.uk, 
	tabba@google.com
Content-Type: text/plain; charset="UTF-8"

From: David Hildenbrand <david@redhat.com>

Let's convert hugetlb_cgroup_css_offline() and
hugetlb_cgroup_move_parent() to work on folios. hugepage_activelist
contains folios, not pages.

While at it, rename page_hcg simply to hcg, removing most of the "page"
terminology.

Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 mm/hugetlb_cgroup.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/mm/hugetlb_cgroup.c b/mm/hugetlb_cgroup.c
index d8d0e665caed..1bdeaf25f640 100644
--- a/mm/hugetlb_cgroup.c
+++ b/mm/hugetlb_cgroup.c
@@ -195,24 +195,23 @@ static void hugetlb_cgroup_css_free(struct cgroup_subsys_state *css)
  * cannot fail.
  */
 static void hugetlb_cgroup_move_parent(int idx, struct hugetlb_cgroup *h_cg,
-				       struct page *page)
+				       struct folio *folio)
 {
 	unsigned int nr_pages;
 	struct page_counter *counter;
-	struct hugetlb_cgroup *page_hcg;
+	struct hugetlb_cgroup *hcg;
 	struct hugetlb_cgroup *parent = parent_hugetlb_cgroup(h_cg);
-	struct folio *folio = page_folio(page);
 
-	page_hcg = hugetlb_cgroup_from_folio(folio);
+	hcg = hugetlb_cgroup_from_folio(folio);
 	/*
 	 * We can have pages in active list without any cgroup
 	 * ie, hugepage with less than 3 pages. We can safely
 	 * ignore those pages.
 	 */
-	if (!page_hcg || page_hcg != h_cg)
+	if (!hcg || hcg != h_cg)
 		goto out;
 
-	nr_pages = compound_nr(page);
+	nr_pages = folio_nr_pages(folio);
 	if (!parent) {
 		parent = root_h_cgroup;
 		/* root has no limit */
@@ -235,13 +234,13 @@ static void hugetlb_cgroup_css_offline(struct cgroup_subsys_state *css)
 {
 	struct hugetlb_cgroup *h_cg = hugetlb_cgroup_from_css(css);
 	struct hstate *h;
-	struct page *page;
+	struct folio *folio;
 
 	do {
 		for_each_hstate(h) {
 			spin_lock_irq(&hugetlb_lock);
-			list_for_each_entry(page, &h->hugepage_activelist, lru)
-				hugetlb_cgroup_move_parent(hstate_index(h), h_cg, page);
+			list_for_each_entry(folio, &h->hugepage_activelist, lru)
+				hugetlb_cgroup_move_parent(hstate_index(h), h_cg, folio);
 
 			spin_unlock_irq(&hugetlb_lock);
 		}
-- 
2.47.0.277.g8800431eea-goog


