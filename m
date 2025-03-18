Return-Path: <kvm+bounces-41397-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 74F10A678F8
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 17:19:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4461C7A85E6
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 16:17:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20B0820FA9D;
	Tue, 18 Mar 2025 16:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BJB2eNp7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98F4320E032
	for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 16:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742314710; cv=none; b=johFOuZw0N8T+hOxsyKha7P1IlK01MRh9LTBSdRgJe9xi4iW0opQrz4/ToA1A34cUImJjrJyxrt80la+lgd548/HgzJ11UkDhQqJFMczrfa9vCLIRcaUT0OwbL8V4Mgiyw2xJmu1ucA2DwcxiSg22/A+VBiOqV1N5bOJMp0HKV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742314710; c=relaxed/simple;
	bh=sjo7jmQc7al/yL/P26xDJfaRUQWhfD/K1qNaiuw/aqk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Rlgdqw7vn4aE/uBjB5Hc315shHLW4peL1Wd0oawD5JKWjEWSe/OCyPKLEdhFeDg3VcVFNNuw9kWJP43aKIuW+E8hwSk/ofP50Ap9y8+SLcFhuRBA5VHuXFHKfqRjJ83naJCfdewV8VxzaXg+rGwhwTiuC89yx+6ATJRGIE2XvRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BJB2eNp7; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-43d0830c3f7so30339385e9.2
        for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 09:18:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1742314707; x=1742919507; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RUG6NztbLFLzDS9xNltsNQX8q/i/r4KDCgmt5mBPitc=;
        b=BJB2eNp7gdwjJUx3LhWqGIVsY5PL+0bFWkt6HoqcR/8qy9yRe3JOMbqRS073CRtJur
         0k4ZhE6NR9xvD1O5VNI7eKHzwL5qV3Y5TcM+dy1MyiT/Xgt4wkBh2ltpFH4ofILiw92q
         QbpjEqFmpw/stawHDOyac+pL/7rgD+oWbOgswBiDFzz7HOnlPxao+sdVZfeXhqh/TbwS
         8q9dbLfpD4J3i8aMgN8gEsU2a7HwmQ1E4egGrq1oGH/XSuFEaXopNBFYeh9AuAHVTBWl
         NTumth5bsSOwhEO/TVnK+jAW6oy+IUjQYAMoJ5KsAuHt7cVh8laHnMmFUgCy626MA8+U
         SBcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742314707; x=1742919507;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RUG6NztbLFLzDS9xNltsNQX8q/i/r4KDCgmt5mBPitc=;
        b=qi822F5FR9RMxnDUrfhpYrTHNqmfqKhBNStr8326/DmJNMXwYVX8augY48qpU6Cud9
         yjFMgufvR8ANSci/IJXKIldZgES45TZ7mAcaZ/hvMtf8W21eKahxIwreJVkAISsTcGwq
         rMtzJyTlcA4w45P+m4E/X4LMnaPzscmMZ2L6Nh3ioR/EK6aXE9ZU2Y4Fu7ja9HQUFGrg
         PKAbOs1kt7MvksDYWVi5OAtrWV0/ZeAmlpH9yWvkRkXuItdCpSqxxJJaW+ec9a0jmd2i
         HkIBo3eF7mSeuNXyo+jWvJkXrClv70+YScgRlNmyGx8cRwW/6XW1CzRtZTN8C5KsgHYy
         a1wA==
X-Gm-Message-State: AOJu0YwtpV2niExAvRDWB9TsVPoS2UgrPm4rPKw0Caw5Aj3fbPtTpaX7
	o73tbXbyAiq2WP5G/VQosbUN28v91bof1zkZ6fbECu7IeoLOjD6tFu2LaC1Re05TmAdknbI6KS+
	sih4itHM1foa6AZNOawBIhoyOjQsC3EoQh5UbLVV14MyzN15GSfCwguby1GTcllma/CoL75Wb8k
	eMaGkQrQIjYoqcX65IROgju3I=
X-Google-Smtp-Source: AGHT+IGA4buFW8D/i7of1JJ/CaW7suQpBbUbSZuYhIOMvxS1NT2RYw+WVnJcFCNBlIIk3X2ZUVPHPmOwRw==
X-Received: from wmgg28.prod.google.com ([2002:a05:600d:1c:b0:43c:fcbd:f2eb])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:468e:b0:43c:f81d:f
 with SMTP id 5b1f17b1804b1-43d3b986350mr25234125e9.8.1742314706944; Tue, 18
 Mar 2025 09:18:26 -0700 (PDT)
Date: Tue, 18 Mar 2025 16:18:15 +0000
In-Reply-To: <20250318161823.4005529-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250318161823.4005529-1-tabba@google.com>
X-Mailer: git-send-email 2.49.0.rc1.451.g8f38331e32-goog
Message-ID: <20250318161823.4005529-2-tabba@google.com>
Subject: [PATCH v7 1/9] mm: Consolidate freeing of typed folios on final folio_put()
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Some folio types, such as hugetlb, handle freeing their own
folios. Moreover, guest_memfd will require being notified once a
folio's reference count reaches 0 to facilitate shared to private
folio conversion, without the folio actually being freed at that
point.

As a first step towards that, this patch consolidates freeing
folios that have a type. The first user is hugetlb folios. Later
in this patch series, guest_memfd will become the second user of
this.

Suggested-by: David Hildenbrand <david@redhat.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 include/linux/page-flags.h | 15 +++++++++++++++
 mm/swap.c                  | 23 ++++++++++++++++++-----
 2 files changed, 33 insertions(+), 5 deletions(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 36d283552f80..6dc2494bd002 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -953,6 +953,21 @@ static inline bool page_has_type(const struct page *page)
 	return page_mapcount_is_type(data_race(page->page_type));
 }
 
+static inline int page_get_type(const struct page *page)
+{
+	return page->page_type >> 24;
+}
+
+static inline bool folio_has_type(const struct folio *folio)
+{
+	return page_has_type(&folio->page);
+}
+
+static inline int folio_get_type(const struct folio *folio)
+{
+	return page_get_type(&folio->page);
+}
+
 #define FOLIO_TYPE_OPS(lname, fname)					\
 static __always_inline bool folio_test_##fname(const struct folio *folio) \
 {									\
diff --git a/mm/swap.c b/mm/swap.c
index fc8281ef4241..47bc1bb919cc 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -94,6 +94,19 @@ static void page_cache_release(struct folio *folio)
 		unlock_page_lruvec_irqrestore(lruvec, flags);
 }
 
+static void free_typed_folio(struct folio *folio)
+{
+	switch (folio_get_type(folio)) {
+#ifdef CONFIG_HUGETLBFS
+	case PGTY_hugetlb:
+		free_huge_folio(folio);
+		return;
+#endif
+	default:
+		WARN_ON_ONCE(1);
+	}
+}
+
 void __folio_put(struct folio *folio)
 {
 	if (unlikely(folio_is_zone_device(folio))) {
@@ -101,8 +114,8 @@ void __folio_put(struct folio *folio)
 		return;
 	}
 
-	if (folio_test_hugetlb(folio)) {
-		free_huge_folio(folio);
+	if (unlikely(folio_has_type(folio))) {
+		free_typed_folio(folio);
 		return;
 	}
 
@@ -966,13 +979,13 @@ void folios_put_refs(struct folio_batch *folios, unsigned int *refs)
 		if (!folio_ref_sub_and_test(folio, nr_refs))
 			continue;
 
-		/* hugetlb has its own memcg */
-		if (folio_test_hugetlb(folio)) {
+		if (unlikely(folio_has_type(folio))) {
+			/* typed folios have their own memcg, if any */
 			if (lruvec) {
 				unlock_page_lruvec_irqrestore(lruvec, flags);
 				lruvec = NULL;
 			}
-			free_huge_folio(folio);
+			free_typed_folio(folio);
 			continue;
 		}
 		folio_unqueue_deferred_split(folio);
-- 
2.49.0.rc1.451.g8f38331e32-goog


