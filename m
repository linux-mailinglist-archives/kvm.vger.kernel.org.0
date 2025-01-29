Return-Path: <kvm+bounces-36870-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 214B9A222C1
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2025 18:23:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 247503A5248
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2025 17:23:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECA601E0DCB;
	Wed, 29 Jan 2025 17:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tL6S0aEI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E0271DFD99
	for <kvm@vger.kernel.org>; Wed, 29 Jan 2025 17:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738171408; cv=none; b=ZFWROsh+PKp6nIfq0pEebCOcjyB3qXSDdQkhIV1EDUmlrsFudbpUsvDW5tgSIXcUCLbHIyGV65Ti0cFcgPXgYNMopVxWFHBa/1IOZM9H2lWReh23xnEYDklpe+uOSfuvtfFcmTRY57l76beNVsuKi5AhFisVwwjGWun0I8PQ5r4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738171408; c=relaxed/simple;
	bh=7AlMcFMWzcY1KBVpuAkyCgonVme5/aciBVZa8uL35zs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GWqlCtN7iznqLadApdjK4Q0pTsFF2yLwaUwSBu6mSi0v6Be7ggouDfX51Rwa6WoccExNOJXmIzFPswe+5WK9uEpxgCZc05gQxNOLtwhybBd6ox18W4GqEQNkCkzo+UW6UHJFdrI6su6o4pEUNCrcd64tCaz3PNCs6w+VONYgT4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tL6S0aEI; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4359eb032c9so50902955e9.2
        for <kvm@vger.kernel.org>; Wed, 29 Jan 2025 09:23:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738171404; x=1738776204; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=iDaVGDLi8mgRhdRmBEo1g3AHoA0NuWvKpi8mcLq23xA=;
        b=tL6S0aEIOa2TEspeIfvXTr7zmNxNvew4FArh/DZqgxQ8WUalZU+TtiCmpVMYNN7riM
         /mPUoIhlE2SosBgm2iBy8HRXYJv3RXVAiUbRvODhbFtMrot3fRU2N80E+iO4jHxLIKH/
         s+pxCZbUtfq74HoPjFm0tdph/krU1SOhLtrcxxKvewu9UWI9FFGjTZtC8EhcMZlwv4v8
         K2HRpbdgV/vseJV3SPWecHiI85nQ6/FidlJyBvo9fvZ/SaaV7UkIfS5aDim1Fvs5Ui8Z
         St0yTvxuC0rgoQuYm9GDCeGQxdKtAvTB3+C5jq9VC6vb8toFraR765EIRyoXWVskvheJ
         2Zzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738171404; x=1738776204;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iDaVGDLi8mgRhdRmBEo1g3AHoA0NuWvKpi8mcLq23xA=;
        b=Lw0m4kIbgtugHYQLtxrxgigqV8RTPjzSy69ED20fG8WYqHdnEFAwEOaf/hrrlr+kfE
         q++kPDZdZieXG3CHjAOj49DnX4NSwLsgAVO/kyyQJE+skbbM9BwvVLISyySYKsOjcKUv
         MbcA54XoxCr27gM0ucZY+sP2apTEh7Y3/HWGEqjUlyOZ4IEh+9IxjyXQLkLPMGkHLomm
         T9fw6aRL8ksEb7komq2THNyCtg3T7rB42PiSvz4XUOgoFii9IxMwxlWGPMuk1mtyrB0j
         fwFQ2uNB0bE0gB6KUujLJQ/LwVcjKW2AJdj0H6iZgzDGhtTgWclQozQ4zuKPc6bGJBJ4
         TeKw==
X-Gm-Message-State: AOJu0Yz7ZMLcoHfo1DPxNRPArjrTsplNKR4DLFzzDUEhJ1FsLVuAt2Mg
	JB0v1ljz22hiyfkZ0HqkSRYgwmaJl8zSmnbUllaGXdDZ5owcUyNt1pBKDo6uJo8qKhRDkeLiPsK
	IgnN3adPQWWIchXlq0zoC2VKw54/2R3Mdoh9nxK2eVh0SH4aDlAEZP5Di1VnCx5EG+YHKYja1OO
	yeryXcWsWLOEVhURXwz3gs02s=
X-Google-Smtp-Source: AGHT+IG7AAxXO9uUL/TV8lWRjQ0ckYe36dATBMk94k2BjGqrWcfbwhKyc4W7DSJHTwQDQb5yqHpv0ii9Sw==
X-Received: from wmbbh25.prod.google.com ([2002:a05:600c:3d19:b0:434:f173:a51])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:1d26:b0:42c:b9c8:2bb0
 with SMTP id 5b1f17b1804b1-438dc3aa595mr34124635e9.4.1738171404499; Wed, 29
 Jan 2025 09:23:24 -0800 (PST)
Date: Wed, 29 Jan 2025 17:23:10 +0000
In-Reply-To: <20250129172320.950523-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250129172320.950523-1-tabba@google.com>
X-Mailer: git-send-email 2.48.1.262.g85cc9f2d1e-goog
Message-ID: <20250129172320.950523-2-tabba@google.com>
Subject: [RFC PATCH v2 01/11] mm: Consolidate freeing of typed folios on final folio_put()
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com, 
	mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, tabba@google.com
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
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 include/linux/page-flags.h | 15 +++++++++++++++
 mm/swap.c                  | 22 +++++++++++++++++-----
 2 files changed, 32 insertions(+), 5 deletions(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 691506bdf2c5..6615f2f59144 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -962,6 +962,21 @@ static inline bool page_has_type(const struct page *page)
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
index 10decd9dffa1..8a66cd9cb9da 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -94,6 +94,18 @@ static void page_cache_release(struct folio *folio)
 		unlock_page_lruvec_irqrestore(lruvec, flags);
 }
 
+static void free_typed_folio(struct folio *folio)
+{
+	switch (folio_get_type(folio)) {
+	case PGTY_hugetlb:
+		if (IS_ENABLED(CONFIG_HUGETLBFS))
+			free_huge_folio(folio);
+		return;
+	default:
+		WARN_ON_ONCE(1);
+	}
+}
+
 void __folio_put(struct folio *folio)
 {
 	if (unlikely(folio_is_zone_device(folio))) {
@@ -101,8 +113,8 @@ void __folio_put(struct folio *folio)
 		return;
 	}
 
-	if (folio_test_hugetlb(folio)) {
-		free_huge_folio(folio);
+	if (unlikely(folio_has_type(folio))) {
+		free_typed_folio(folio);
 		return;
 	}
 
@@ -934,13 +946,13 @@ void folios_put_refs(struct folio_batch *folios, unsigned int *refs)
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
2.48.1.262.g85cc9f2d1e-goog


