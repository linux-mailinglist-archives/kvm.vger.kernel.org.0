Return-Path: <kvm+bounces-37847-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 87395A30B64
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 13:14:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 27CE7162140
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 12:13:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84FD422068A;
	Tue, 11 Feb 2025 12:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bYNY547d"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D832121CFE6
	for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 12:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739275895; cv=none; b=h1autAYN3zKVa3Q1BJOpYdZrd1yGq+H7aBaEl9Nj1snCa2dKHwJ9nBHecNqeswoA7cS8S0jMe/SxHpdHjpPB1WTpnybMWTbpNb2bf3f/31gL1DJb6PG/8wJqG8rHUdPMVuvL3Lr+AwFpTWbMdxGbRHM4gR7ecWSOBGfUUR8MuxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739275895; c=relaxed/simple;
	bh=bdQ2+JsekwSNsQJcwdpbPIshgmTpGmjqg9MUbSATwio=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OUhgN0Gh23HF49c7Fbbaj3sAhSkk9t+8lVtug3aeq0bdarIDJ/FNV5/BtgvDPx6pnwzxv97eYL0VPST4b4xGcdexuOgNiVWFYgTklkvs3n+L1t2YRaRTPpr8nr4LlbkaWJSpsSOfcVcm0Bdb4mTsI2Og4iDFqUrLTfVj+eRIkSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bYNY547d; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4393b6763a3so13730685e9.2
        for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 04:11:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739275892; x=1739880692; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jVWwkw4l/C0CQ72V45uYNbZ5qQP6QRpYAD9vOGg0YN8=;
        b=bYNY547dtEqXHHKR+V+G9HnAGZmtwc+UZTMUmmt2TzVK4KliLQhl9g7HQYZb3yQTfi
         fNm4ASFxur1lwuoNuQvt4y2Brmjsn1LoD4tgxB0jt3MdaJAZu3ImYiftngOpqSWMtXIJ
         JtTCfZDdNCBl8IIcxFOC+a+kKYfXrL8OGjtI+GLaUIn1SaX7BNBThGSHa3RH0CtByV+L
         emmADGDhx8vtjIjm/erdkC2Nn5/hBbWoCeQ5mdsanA9szEMciSHK414FlMlISDCb3Qdy
         Dy1AqDMUuAAQfyFgen93dGYG8hcuI3+z2usWjvC0SHslYL4d90Cx4+KtnvX5cC3VXyw6
         q9Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739275892; x=1739880692;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jVWwkw4l/C0CQ72V45uYNbZ5qQP6QRpYAD9vOGg0YN8=;
        b=cR0pLrR9XViSCBHSUx3m6Fx2Ph9cUQC1nE1fOAxbf4lU2u2mXvM3EK3O1AJ9WN7MqT
         F4Sjn0l8XBOsLcQmMX+LEhmwPYujrpWg4r4NaU9e3g4QTsbjB2KDsclQOVHZhQC9/yLo
         HnqnOZWwbEQVeTLfrG9FZt4OF3Z7xUglJQgF12b1PS9FqLycrYoHCw+Wfgk4rJHI8zy5
         NbGrmr4rPphERmhxqNQsRy3eYs78CpF1BDFGbniA4ztqfh800AfY0IVoI44TUUEnxKWi
         G/99ccJevCCCGtT10fvdc7UE1k97IquYNobHWvsoiXvH44mUCgOKI7ytCMoHm9TcL7oW
         6jVA==
X-Gm-Message-State: AOJu0YxGyyuXFVNeE7Xr9NguF7jKyX7H3/87ePItQskfMXDo2/ppLYRY
	nhbiv54l9f2xBCUgMU98ZeilvF8p55mIQJGXFEbUPfYSKVchcjGoJ/4LdU0YZbbiyC5w2VfHRi9
	S9dbnsnpUmEVhKDujSJdpTkVrbTDQVrMoRNI8l4SP0Ky48bzCqywdFNKEUMwfeLsdOuHYGZmWCR
	FsKwMzdgQHHHs/6Q21Oo50mIQ=
X-Google-Smtp-Source: AGHT+IG10/vN0gzRGJ08Wn/qWLjVjCNkXjXTKTCGAHZrBJMQnayK6w5tSeoK7viwOkkpLU5EQQeSBy5Iyw==
X-Received: from wmbhc10.prod.google.com ([2002:a05:600c:870a:b0:439:4cf6:9186])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4589:b0:434:f609:1af7
 with SMTP id 5b1f17b1804b1-4394c808849mr36671125e9.4.1739275892079; Tue, 11
 Feb 2025 04:11:32 -0800 (PST)
Date: Tue, 11 Feb 2025 12:11:17 +0000
In-Reply-To: <20250211121128.703390-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250211121128.703390-1-tabba@google.com>
X-Mailer: git-send-email 2.48.1.502.g6dc24dfdaf-goog
Message-ID: <20250211121128.703390-2-tabba@google.com>
Subject: [PATCH v3 01/11] mm: Consolidate freeing of typed folios on final folio_put()
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
2.48.1.502.g6dc24dfdaf-goog


