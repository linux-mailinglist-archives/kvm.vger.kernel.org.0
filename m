Return-Path: <kvm+bounces-33741-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D41989F12D9
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 17:51:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 20440188E7BD
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 16:50:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA9AE1EF09E;
	Fri, 13 Dec 2024 16:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pwaodsk6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 256321EF092
	for <kvm@vger.kernel.org>; Fri, 13 Dec 2024 16:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734108498; cv=none; b=tF3RZnbEhhdNP8vg4H2xwyxuXwPxW+qquaReOHkAkQMDUSsba8Ow8RjEwErV6NPx5peWEhGLoLzKV8u+QuSdUBWpwi9wGDgxk+kAYPdhvVRta96dWAGdPVh4qyYKd7wcTynVuEWhb8vkDGKvoUmgI8FLM4fvJwHC/n+LvBUCgtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734108498; c=relaxed/simple;
	bh=vt1tv3thcSuusIu94qlbNdtWSULIMt9Iwb3oz+YsFfY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Hk/0TZk+UdWwPK2g/eFJTIGr8VHRGTgEo4MCAtfKHdQ7LM5YJYoz7FGJXnkCoS1gOW2iv2n4f4/R7v8TQh3qDro903avg6AjkY8/WyKLAnM2bL3/AH35indP6dnHC5hYk4St1Blabc+jZ3KPEAYdN9zRDR3xBkGODEL06s3zH4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pwaodsk6; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-43624b081f3so17361475e9.1
        for <kvm@vger.kernel.org>; Fri, 13 Dec 2024 08:48:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734108495; x=1734713295; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zAuvJ3/1BpungxKC2V7q88+gZ9+3WIZOJ/4nQKuXfFs=;
        b=pwaodsk67bNZI+cim6lSRCHLusgSaSq+fd2lSDlVxe4yFyvkx64MaEXLCfuAslQSUp
         axCrFHmfv4y/tyg7mlSIKooItR/M6yiMIcHzGsFjKboNlWXx0aC9c+paA+eHsYJgylw4
         /FMG0fumOjPatdhDZKAvtpQhisREwB9rSrxqMwzWvPajONjGpsiiN+O9Dl2jcQfcok5T
         yRpesab7rRoY9gq326tvyPPuYva7wnmqp2wexlVWPgkPrPUSiEyIGkKyy3uhkIZG9i5i
         Bwo3EtD4QoWTOufAG/JfpQULey+Ns+oEy3sXEYPqbvDGy4b3x0YBNd/UlsTX368/NQx2
         nCKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734108495; x=1734713295;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zAuvJ3/1BpungxKC2V7q88+gZ9+3WIZOJ/4nQKuXfFs=;
        b=f5K/pPhA63fE73sk/3wWrRyLHXQs/zj1nCzJpcL53DfruCrTVUgQ+wP/L5RDiUepMQ
         1djqRibpK/wuP7d3X++NVOnx11jrvMJcyZux32rZNiQxjsIa34bMo8++QvqCD/CoSe4M
         5nQUbOJZ8j2D2eBFlj26K0AFFaNX3ikH9ur6fUxzJ9sMThekfljfOzaZcEbT/G3sf+7Y
         pgniMNKue/3Lvo41Pic6SvHAB5w/TEnNfKJEIHDNiDTE7lUFEwEXIPl7y6nn4ihUSNqq
         wPYkY/QGjuzG+gFXTRDSuhGRUOAm49W/BY71ASKVc0QUcvrOkm1WU5LodLOD1rDsp202
         sEXA==
X-Gm-Message-State: AOJu0YxYk5M0yy4IgnJ0bPq0r9U/JYDt9dMPoeZlG9dm6DQh3KT9xll9
	Bgg8d9GkYQl1xJ9CCYc3RBj0TNIX7B7mK/8Gmse9HWOrGeBsnPePFXQU+roO/vwSiIFzthdRhOo
	XgYrjYNtNE5f8SRa6WSUs129EYSqvwakqh0AVD7qguddiKkXbeAZA96f9gYMYD5HLdVnu5Knp+X
	QBupGhBCPhu3KGw/pT9Y8W7ug=
X-Google-Smtp-Source: AGHT+IHs8ZHuR71xrnh0Wig8GOEjO8jW22DFD8cUeagZ+0AiDaeSDaoT2cCNj9eWJgQpPRurrM0qMZgcmQ==
X-Received: from wmbd13.prod.google.com ([2002:a05:600c:58cd:b0:434:9dec:7cc5])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:348f:b0:434:a802:43d
 with SMTP id 5b1f17b1804b1-4362aa9f682mr28943725e9.27.1734108495459; Fri, 13
 Dec 2024 08:48:15 -0800 (PST)
Date: Fri, 13 Dec 2024 16:47:57 +0000
In-Reply-To: <20241213164811.2006197-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241213164811.2006197-1-tabba@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241213164811.2006197-2-tabba@google.com>
Subject: [RFC PATCH v4 01/14] mm: Consolidate freeing of typed folios on final folio_put()
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
 mm/swap.c                  | 24 +++++++++++++++++++-----
 2 files changed, 34 insertions(+), 5 deletions(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index cf46ac720802..aca57802d7c7 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -970,6 +970,21 @@ static inline bool page_has_type(const struct page *page)
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
index 10decd9dffa1..6f01b56bce13 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -94,6 +94,20 @@ static void page_cache_release(struct folio *folio)
 		unlock_page_lruvec_irqrestore(lruvec, flags);
 }
 
+static void free_typed_folio(struct folio *folio)
+{
+	switch (folio_get_type(folio)) {
+	case PGTY_hugetlb:
+		free_huge_folio(folio);
+		return;
+	case PGTY_offline:
+		/* Nothing to do, it's offline. */
+		return;
+	default:
+		WARN_ON_ONCE(1);
+	}
+}
+
 void __folio_put(struct folio *folio)
 {
 	if (unlikely(folio_is_zone_device(folio))) {
@@ -101,8 +115,8 @@ void __folio_put(struct folio *folio)
 		return;
 	}
 
-	if (folio_test_hugetlb(folio)) {
-		free_huge_folio(folio);
+	if (unlikely(folio_has_type(folio))) {
+		free_typed_folio(folio);
 		return;
 	}
 
@@ -934,13 +948,13 @@ void folios_put_refs(struct folio_batch *folios, unsigned int *refs)
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
2.47.1.613.gc27f4b7a9f-goog


