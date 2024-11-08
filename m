Return-Path: <kvm+bounces-31296-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DE2A09C21EE
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 17:21:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9BFC02822E7
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 16:21:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B87A198E79;
	Fri,  8 Nov 2024 16:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gyCwXjNZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D880A1990CD
	for <kvm@vger.kernel.org>; Fri,  8 Nov 2024 16:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731082852; cv=none; b=g1izDefZM97tuNLMbu5vLLYrMMipLLj9DppDI93/VUUatvH4bdjqE0a7JYEi2qz9GfVh1zgXBz00vXTBbl9/WHzrxrybXPA4mNYrD/96GsENRsouMlPxBmGMmlUo2LNl2B0iPaUhrg/3E6HJukTND9YPnKBzhBWdlPFp77fRG7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731082852; c=relaxed/simple;
	bh=vBVS9ScDauNLkO23I83Td0F6eVzgmOOsg2e68XJc528=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pDjv/wla47rzaMn0YY3Nc9Qbs1XDAtjVNiRV14pc11vv4R5JfU9BGjBEIu4F2X6HVyYslDi9rJzXGKNqnwr/lZK7fyvwpU3Ki2lby8lMpiQGD+my7a+fJcZWssbYUdhAUwG4hQDkn1WkZB4/P67hcmajPqw+Yu5XbyGnHm6wD3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gyCwXjNZ; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-43154a0886bso15964065e9.0
        for <kvm@vger.kernel.org>; Fri, 08 Nov 2024 08:20:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1731082849; x=1731687649; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=c97rKSzu5OtSEQDwZyqgn1x58KOnaAilRAoGtwwyknw=;
        b=gyCwXjNZmVS6Sx74Cpg01KGSEgJHGjv8s31j89MEAEaJZz4hlTCdeNvABRxhtPssgR
         ZjDSVTgPGRNMLU75Phby7M+RYJ79Bq0VUKNc0X++7IXCbXI4Icl/FTTdz5aOIV2uB6w+
         Hc1bN/bKlFiUSm4sRiXr15w2fhm0H570LIKTiia1QAT87YX3zzuuRbcWJTds3t34xLvU
         yDWaPcI+C9NuOAHA0mbqPggSCG5hQXSmh+Ckf+KMbNEtg3H3G9HDnXJtkCua3PRigtcn
         762yuofHg+s9GT9RZb4ucxcGVhuMD4tXs1EmKWGul7b+A6HbnOSmxAR871AXiEk5dwCW
         djHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731082849; x=1731687649;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=c97rKSzu5OtSEQDwZyqgn1x58KOnaAilRAoGtwwyknw=;
        b=gHQw/V6HEsd3U1R236bVQbAqB4HtC4zyg/iHLjhlXlgPWPYPIVRa9LrRe9qVesz2pk
         /Bm2vJxVaZQ37pblwerIiWEMVYe2zpeUKbGmsneU+LrMKrauvxgPivevZrBpNfTbcYLY
         4NTlsIuIlaK0jfEwydTYyFSg0sS4rbNvvP02l+p8UHIVEtSRcUIqbypl3xggiJpelBmt
         fUM+UU7qS+Y3hbOGV4GbIVbjJujZf5+Th4TImGcFp5CkFYkQn1QtSnU25rgYpfsqnHL0
         ip4Qg6QNNPaDSLnyDhPtp2mO7mzCAuUseXwVBqGOQ75XIvZ+TRv76T58q0gs+wlEwsWW
         DLzw==
X-Gm-Message-State: AOJu0YzMh6GCAnMSajDLlUEKZKAIXQ+PSPQ9ruTTBw+ykbUEMntat/u9
	9ffl87iyyFSSKEHgUA2o0VcerI+flVJLYFGT9lALvZSC4w9/ZljiBBND+I21a2D19+JXRgXrGQ=
	=
X-Google-Smtp-Source: AGHT+IELhlKA+w5GoDYCQVGGU0Q69yO5Jt+Zri88wGQ6Nd2QAGecV+Ce7InAsjA0a+zrL4cO721qJjhh5w==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a5d:4f84:0:b0:381:d049:c688 with SMTP id
 ffacd0b85a97d-381f1884303mr2415f8f.9.1731082849389; Fri, 08 Nov 2024 08:20:49
 -0800 (PST)
Date: Fri,  8 Nov 2024 16:20:33 +0000
In-Reply-To: <20241108162040.159038-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241108162040.159038-1-tabba@google.com>
X-Mailer: git-send-email 2.47.0.277.g8800431eea-goog
Message-ID: <20241108162040.159038-4-tabba@google.com>
Subject: [RFC PATCH v1 03/10] mm/hugetlb: rename "folio_putback_active_hugetlb()"
 to "folio_putback_hugetlb()"
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

Now that folio_putback_hugetlb() is only called on folios that were
previously isolated through folio_isolate_hugetlb(), let's rename it to
match folio_putback_lru().

Add some kernel doc to clarify how this function is supposed to be used.

Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 include/linux/hugetlb.h |  4 ++--
 mm/hugetlb.c            | 15 +++++++++++++--
 mm/migrate.c            |  6 +++---
 3 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index b0cf8dbfeb6a..e846d7dac77c 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -157,7 +157,7 @@ bool folio_isolate_hugetlb(struct folio *folio, struct list_head *list);
 int get_hwpoison_hugetlb_folio(struct folio *folio, bool *hugetlb, bool unpoison);
 int get_huge_page_for_hwpoison(unsigned long pfn, int flags,
 				bool *migratable_cleared);
-void folio_putback_active_hugetlb(struct folio *folio);
+void folio_putback_hugetlb(struct folio *folio);
 void move_hugetlb_state(struct folio *old_folio, struct folio *new_folio, int reason);
 void hugetlb_fix_reserve_counts(struct inode *inode);
 extern struct mutex *hugetlb_fault_mutex_table;
@@ -430,7 +430,7 @@ static inline int get_huge_page_for_hwpoison(unsigned long pfn, int flags,
 	return 0;
 }
 
-static inline void folio_putback_active_hugetlb(struct folio *folio)
+static inline void folio_putback_hugetlb(struct folio *folio)
 {
 }
 
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index da3fe1840ab8..d58bd815fdf2 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -7409,7 +7409,7 @@ __weak unsigned long hugetlb_mask_last_page(struct hstate *h)
  * it is already isolated/non-migratable.
  *
  * On success, an additional folio reference is taken that must be dropped
- * using folio_putback_active_hugetlb() to undo the isolation.
+ * using folio_putback_hugetlb() to undo the isolation.
  *
  * Return: True if isolation worked, otherwise False.
  */
@@ -7461,7 +7461,18 @@ int get_huge_page_for_hwpoison(unsigned long pfn, int flags,
 	return ret;
 }
 
-void folio_putback_active_hugetlb(struct folio *folio)
+/**
+ * folio_putback_hugetlb: unisolate a hugetlb folio
+ * @folio: the isolated hugetlb folio
+ *
+ * Putback/un-isolate the hugetlb folio that was previous isolated using
+ * folio_isolate_hugetlb(): marking it non-isolated/migratable and putting it
+ * back onto the active list.
+ *
+ * Will drop the additional folio reference obtained through
+ * folio_isolate_hugetlb().
+ */
+void folio_putback_hugetlb(struct folio *folio)
 {
 	spin_lock_irq(&hugetlb_lock);
 	folio_set_hugetlb_migratable(folio);
diff --git a/mm/migrate.c b/mm/migrate.c
index b129dc41c140..89292d131148 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -145,7 +145,7 @@ void putback_movable_pages(struct list_head *l)
 
 	list_for_each_entry_safe(folio, folio2, l, lru) {
 		if (unlikely(folio_test_hugetlb(folio))) {
-			folio_putback_active_hugetlb(folio);
+			folio_putback_hugetlb(folio);
 			continue;
 		}
 		list_del(&folio->lru);
@@ -1459,7 +1459,7 @@ static int unmap_and_move_huge_page(new_folio_t get_new_folio,
 
 	if (folio_ref_count(src) == 1) {
 		/* page was freed from under us. So we are done. */
-		folio_putback_active_hugetlb(src);
+		folio_putback_hugetlb(src);
 		return MIGRATEPAGE_SUCCESS;
 	}
 
@@ -1542,7 +1542,7 @@ static int unmap_and_move_huge_page(new_folio_t get_new_folio,
 	folio_unlock(src);
 out:
 	if (rc == MIGRATEPAGE_SUCCESS)
-		folio_putback_active_hugetlb(src);
+		folio_putback_hugetlb(src);
 	else if (rc != -EAGAIN)
 		list_move_tail(&src->lru, ret);
 
-- 
2.47.0.277.g8800431eea-goog


