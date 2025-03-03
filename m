Return-Path: <kvm+bounces-39902-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EEB26A4C936
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 18:22:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D8E087A2AAF
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 17:21:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE57521505F;
	Mon,  3 Mar 2025 17:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wBdp8pcT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A23B1531C8
	for <kvm@vger.kernel.org>; Mon,  3 Mar 2025 17:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741021821; cv=none; b=MSKHsF7jq9rumQVqOgQrbu7yw0ImIrgTeEG27CJu4j/xMZaaoTu9hu5R2ROgCha01TpjLoNaUmnr14RoI3K7KU9UCNxQYpr7JKo+Vwtbd/if59xtwaLgMLlafx3qpwmdw+tclhxRwt01kX42bWjCg+xB4Ynp4HjUWy1c4v3vPO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741021821; c=relaxed/simple;
	bh=OGMLw7hSKMeyt/pbr/nhF59bzM4sycNSU55EOTupIo0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Pnfv5IOWSCj+C8xBVJxM0rlaTAs30WwbHFw4O0Cn0un9TZsLp7dk1JWT20ULD0EC+9Irxhuc2OaV/k2cDEOYH/ZosOOJ7vQXJyVoTumwlFMdmvuJs15v36PAGKx0rH+ndo87grTIutcsj6lOHa+nbmtRWzj80NaHMyvKAjWFqtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wBdp8pcT; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-390f7db84faso1812119f8f.2
        for <kvm@vger.kernel.org>; Mon, 03 Mar 2025 09:10:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741021818; x=1741626618; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=w5p1u51hDu4RIdVFXU2+a7I5FQFTXTH5HXvwkoJ+/VY=;
        b=wBdp8pcTQsbkSw0R3yXqTYPyUneuv4MOUCAMjIwb8WhKnKWNjpqDO8beaZ5dNokBrg
         7nJ2f+oTpzR+d5SfyS5CuMfuUY7HTfU0/SAyRnfIEANpimjJ6Jdna+z2uOu1Aq7XhLR9
         rvWFTdwfA4Rre/AxIKJRoIs2LW+xfYMLtZwIyerR9qK4C+QYHqS+9hBmJmhCPUPmpYEj
         uzWcc5TgK8Ds4um8RhPEuszJt4XDVbS0gva5/+vS6gwZuLrVqu0DPErx29us1O2TI9rP
         bD9BvaO9LHCJgdUfilsBZ3URRpf+aEmKZADnSsJ00EiRK/sNLIZqpenY+8RN0I1ktrqT
         5B1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741021818; x=1741626618;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=w5p1u51hDu4RIdVFXU2+a7I5FQFTXTH5HXvwkoJ+/VY=;
        b=QnjNzC/fUJXAgZxl43kYot7jexRxuVX95NlsOcQPo3rHowKDBPkVqNJ4VOc8jq+eGy
         u9fl9j8ryRkt1xrsKN/7lRIdGnRUmyxxvWryhqpMfNtuMaIHow3btRQbrs0kWrtSreom
         tFA9d/PaPO7FxO/sOeLpQ11DasT65ugKOSd1rCw0uT4s6/Fv1tlvcqGBKfTT/k4YbUYr
         W1enjHsZXwjOFrXHBl7DxIhXzrsQZssZFvAeGep8wh7y0Lgg4OB6DYy8w1roqqXXfb4J
         Z2QtYb0DNLU3XNUyWgSe+peY/MWdJQisqB8mBp7TKHPIoaWT9GZe6Siws7hPXNyZVLCv
         wvAw==
X-Gm-Message-State: AOJu0YxQunmMGz+X3GzCjhK4159DowZnrTTGUP6P5uR3Xh/icmYnUSXJ
	2hdGDb4EhZ7KuKKTgoF6517lEtZnLJ4jbzajjHFXSuvDgbkdCoqRDPvvvhopkMRcRGFWSWrMH0J
	Zmjk+LMYVlKAxz/qBg8W/XU+KUlk/hRkAzkpgLWaXftS3KhtnT7v18gT+izrxvHHBCbqBh3qq/q
	YTkdPwiW7EzILbJoAtGGWZAu4=
X-Google-Smtp-Source: AGHT+IHrIQRTSbIxQusEzSVfIPDJzKXN0UjZRRQHhWJRv/ncbjwRbNznaVOzH4GMAzYPY56lQvuMR1QBGw==
X-Received: from wre13.prod.google.com ([2002:a05:6000:4b0d:b0:390:e0e3:e8cd])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:186d:b0:391:13ef:1b35
 with SMTP id ffacd0b85a97d-39113ef1da9mr1259620f8f.29.1741021817721; Mon, 03
 Mar 2025 09:10:17 -0800 (PST)
Date: Mon,  3 Mar 2025 17:10:05 +0000
In-Reply-To: <20250303171013.3548775-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250303171013.3548775-1-tabba@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250303171013.3548775-2-tabba@google.com>
Subject: [PATCH v5 1/9] mm: Consolidate freeing of typed folios on final folio_put()
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
2.48.1.711.g2feabab25a-goog


