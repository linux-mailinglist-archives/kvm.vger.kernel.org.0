Return-Path: <kvm+bounces-49696-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FCBFADCBC2
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 14:42:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5588D174977
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 12:42:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BD872DF3D8;
	Tue, 17 Jun 2025 12:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="eZ5Cunnu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1BA32C08C7
	for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 12:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750164148; cv=none; b=RW/U85o9pwPxbzKqe9SHf15HO0ydc4CykjEKD32z3aZSBASW/gweJtpcZG720JhEwIJYgEE561mVF/4QTOvglRJo3NrI3P+xcUS9U0zdjZA+Duz2UTyw/qm8O4zTIi6utJELVz61nr5QNt8vHQ7YgWIF7i/RlZHpprpZNBWhupw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750164148; c=relaxed/simple;
	bh=YnlMW/OQD8jOXpFvErN0yfsvPxpU/dbDLl8ZtnIoM8w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fMjX88drVSWA7z49fltpEeradEANn0epJ7TS7KebjMmU6UfqdDJ0TZ6hsdShnwzcgJMWCpMH6lx24OvnKE9xunWE/X1QZKlPDLSBEbWIQLlmvDVhfrhZ9WzNVwHfEZ0am4cakd2x2jHGpridEEZEJ9EYbn7ciOZ4ET0VLD6VDxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=eZ5Cunnu; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-23508d30142so65043555ad.0
        for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 05:42:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1750164146; x=1750768946; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xhCeJRKJX5gly7PeRbiNYGYM1xfBGGYyk6W70uoBE2Y=;
        b=eZ5CunnuLLx6rmyo799/SVcUwM1uUjNtBjzancEdBdbLoUn0U5lUzmvloNl1JiBOLq
         4h8mrP1/2UwnvANTwyTzOLVBGUv06vsvNla1iu3OUKMFJJTa1GK0v0BdrVpw6EZGAKkV
         Lom4Xkvg5dqJUVCBvEGngIrCMr9pIx98r3XtgnNSyD7i4va/QK/0Ag12RjrR3Vl4lIYW
         DIx2K0aqUHsLtNCcUgPPbTwuEpn/c8GXwzIal9Jl47V9xVlrxxcULs9mX+gbpOuejVTq
         TgJfh5BVLpCq79na5UB8fgVoKOEH4SZMb11dygXjw0BVvIglgopP2hcsgci9kRivk09a
         LUPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750164146; x=1750768946;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xhCeJRKJX5gly7PeRbiNYGYM1xfBGGYyk6W70uoBE2Y=;
        b=uovlinPO1UsGJgvSWmZ4tgBiPUFVChMaEDsdu7Iuft/c6smqHC21q+GeHodBy9LJgF
         B3r9y1mPGiLoe1rZZhVmQhD4cVnrWXd2AAV3LT3gMgz1HlEHWoc2+tAbCvr+igRskY3W
         nFOHV9DJpDX+WsfUQI/xIznG++ys5mbmMsMnfYB+bzmytV41I8Aqo2M5b1L/C8jYgGOn
         kjEGYPAvSo+jI5Le7Vl58F/yorFoyBNwQN8nQU/+DgUoU3ga/3lxhtpdD+tnz+4gOmND
         R33O4prYOh2QNZhCwOJqj0AD06OEBC4/tkEIYonO/wda25aQd184BDGCJOZ6F5WcL0tn
         8NpQ==
X-Forwarded-Encrypted: i=1; AJvYcCWsz04/xEnaUmh59j04kC8YJ/hXtUtAs9pa3L2CeYHBhwZSvLEW166QW/se9TuiVejaYxQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwfoIao7smc6cLYqrpvEe/cdM66Xzlwebp3pI8zF3XKjc79sOXV
	nxunB+vLg/3do/os/OiKWuT+40NT9j+z/LLJIly0EhWcyKLiP5Q9WDwgSkQCd8q2Fnk=
X-Gm-Gg: ASbGnctIe2Dg52FCEDMmGAqhAN80TBkcqP++TlMWLT2wmHp7SUdPB8qdId71c4kmlo4
	prx4PB2KL31rPQ1qyD2UZmPvnIze5lYhvV7SKyE5tP2f1dlBo6gEiGI+JVoNqFucJkntUu4ILDG
	zGEZJ1f2qTFpYRhRk7DnzVK9TSuMO050mAIr2tXG+/NrwuRMIW+/zJgj1fHYnntK+YeD6q9ZsKV
	G84yO5cdK/FUnD0Ksm+hvGmK9Mo3PvVZZRBWPE/+tA1mTjNnSmqCuhFu+OXyeHZiJVTVysixU9Q
	Jk0Fe/VrnLqOf7BvF1u2AlAVY+F1nk3flCE1wprKWCym7t1Qhn3/JHSG5NUYoE+sL1L7/X1CbgW
	BomgpchVLYMjeKpU2mujucwdq
X-Google-Smtp-Source: AGHT+IEGXsCzeZJho++nxi7+sS5jom3cV2sBi3BqOhTWGBd9h13d/VIShrhQIh5avHoPxHMumouGRg==
X-Received: by 2002:a17:903:1ac4:b0:234:9fea:ec5f with SMTP id d9443c01a7336-2366afd3a91mr205459905ad.1.1750164145833;
        Tue, 17 Jun 2025 05:42:25 -0700 (PDT)
Received: from localhost.localdomain ([203.208.189.11])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-313fcae18e1sm1818708a91.0.2025.06.17.05.42.22
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 17 Jun 2025 05:42:25 -0700 (PDT)
From: lizhe.67@bytedance.com
To: david@redhat.com
Cc: akpm@linux-foundation.org,
	alex.williamson@redhat.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lizhe.67@bytedance.com,
	peterx@redhat.com
Subject: Re: [PATCH v4 3/3] vfio/type1: optimize vfio_unpin_pages_remote() for large folio
Date: Tue, 17 Jun 2025 20:42:18 +0800
Message-ID: <20250617124218.25727-1-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <b88d58d2-59f8-4007-a6c5-d32ba4972bea@redhat.com>
References: <b88d58d2-59f8-4007-a6c5-d32ba4972bea@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 17 Jun 2025 11:49:43 +0200, david@redhat.com wrote:
 
> On 17.06.25 11:47, lizhe.67@bytedance.com wrote:
> > On Tue, 17 Jun 2025 09:43:56 +0200, david@redhat.com wrote:
> >   
> >>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> >>> index e952bf8bdfab..d7653f4c10d5 100644
> >>> --- a/drivers/vfio/vfio_iommu_type1.c
> >>> +++ b/drivers/vfio/vfio_iommu_type1.c
> >>> @@ -801,16 +801,43 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
> >>>           return pinned;
> >>>    }
> >>>    
> >>> +/* Returned number includes the provided current page. */
> >>> +static inline unsigned long folio_remaining_pages(struct folio *folio,
> >>> +               struct page *page, unsigned long max_pages)
> >>> +{
> >>> +       if (!folio_test_large(folio))
> >>> +               return 1;
> >>> +       return min_t(unsigned long, max_pages,
> >>> +                    folio_nr_pages(folio) - folio_page_idx(folio, page));
> >>> +}
> >>
> >> Note that I think that should go somewhere into mm.h, and also get used
> >> by GUP. So factoring it out from GUP and then using it here.
> > 
> > I think I need to separate this out into a distinct patch within the
> > patchset. Is that correct?
> 
> Yes, that's what I would do.

How do you think of this implementation?

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 242b05671502..eb91f99ea973 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2165,6 +2165,23 @@ static inline long folio_nr_pages(const struct folio *folio)
        return folio_large_nr_pages(folio);
 }
 
+/*
+ * folio_remaining_pages - Counts the number of pages from a given
+ * start page to the end of the folio.
+ *
+ * @folio: Pointer to folio
+ * @start_page: The starting page from which to begin counting.
+ *
+ * Returned number includes the provided start page.
+ *
+ * The caller must ensure that @start_page belongs to @folio.
+ */
+static inline unsigned long folio_remaining_pages(struct folio *folio,
+               struct page *start_page)
+{
+       return folio_nr_pages(folio) - folio_page_idx(folio, start_page);
+}
+
 /* Only hugetlbfs can allocate folios larger than MAX_ORDER */
 #ifdef CONFIG_ARCH_HAS_GIGANTIC_PAGE
 #define MAX_FOLIO_NR_PAGES     (1UL << PUD_ORDER)
diff --git a/mm/gup.c b/mm/gup.c
index 15debead5f5b..14ae2e3088b4 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -242,7 +242,7 @@ static inline struct folio *gup_folio_range_next(struct page *start,
 
        if (folio_test_large(folio))
                nr = min_t(unsigned int, npages - i,
-                          folio_nr_pages(folio) - folio_page_idx(folio, next));
+                          folio_remaining_pages(folio, next));
 
        *ntails = nr;
        return folio;
diff --git a/mm/page_isolation.c b/mm/page_isolation.c
index b2fc5266e3d2..34e85258060c 100644
--- a/mm/page_isolation.c
+++ b/mm/page_isolation.c
@@ -96,7 +96,7 @@ static struct page *has_unmovable_pages(unsigned long start_pfn, unsigned long e
                                return page;
                        }
 
-                       skip_pages = folio_nr_pages(folio) - folio_page_idx(folio, page);
+                       skip_pages = folio_remaining_pages(folio, page);
                        pfn += skip_pages - 1;
                        continue;
                }
---

Thanks,
Zhe

