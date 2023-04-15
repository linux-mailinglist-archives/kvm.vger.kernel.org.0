Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A8C06E2FE0
	for <lists+kvm@lfdr.de>; Sat, 15 Apr 2023 11:08:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbjDOJIi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 15 Apr 2023 05:08:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbjDOJIh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 15 Apr 2023 05:08:37 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DB9B49D7;
        Sat, 15 Apr 2023 02:08:36 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id n42-20020a05600c3baa00b003f0b12814aaso2171612wms.0;
        Sat, 15 Apr 2023 02:08:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681549714; x=1684141714;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J+LSahXs7vXHVGQn1uT2igLaiQzqbh9LfXfVKe7mEnQ=;
        b=aaBU96KigAuWjJFM596TLA0njsd4CcaEKGbQ3wHULm3FUlHtgzTCyGDhowFPT++iSW
         MSDxV70HUFBewCPLHdXGdlAdNSFZ2QHM4BuZOWLhabEOa8OpeehQN57s3BUDDoK9spkH
         t/mC67DAUUPnUuCCmjpDHqOJqjNQHzchn32p+RLHbm5+G7bJCo/+D0U1ld+EKsUxpDJa
         o7ONzkpaOxHVYQ3KPloV+uHoEgKwIYqbmEdFiaDoeHgpPNWMEIHsijRd5LrD6JizDysX
         5fIbBUnSZCIIAaDbh76y0cBT0g5/VD/RlillTzQSP9llXM+nuh/teQkLE5uP1eqzvY9B
         FB2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681549714; x=1684141714;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J+LSahXs7vXHVGQn1uT2igLaiQzqbh9LfXfVKe7mEnQ=;
        b=KFj8z1WLm1vpbm1nGlWa+jQDwtZInIITaztWnKOsf+FEVyWyEQ6nBrPybNzxgGE3Gm
         ZY1bNVesi9UrHfiq2HF7DAU4Vht4HpDmmkgHxe0tx12IJTdSt0/z8VnBeNgJyzT4uFUa
         r0ae/4nJlWAMhtnZs1rNljN+C8vLvznIgZHt9C/8SHiM6i4a9o2ci9BK2SphqFIu8uvy
         Z33GtnFWxa4j+uFKyXjFmZl4TPSzZ4tddNEYFm4ljoHRInX78/S3u9eb1l8srIxOd2uJ
         Qi1pM5TGD3kpRAnhXOelQt34casvJdZKAJug+MR1vSzo2m8NGcqqzN5JOrYvE05/VZak
         uQLA==
X-Gm-Message-State: AAQBX9e3jQuho9/gKbwTByjfZ0eBE9X6kAQI8rbW8Ryfp40fbcqfmapa
        Viwwl5MXX0lFtxh0irjt+0Y+wxgBlDGQwQ==
X-Google-Smtp-Source: AKy350Z6MMpxVfEBhLeercWBNyCumV7NKYzKXFdNExcPGCyibd1J697CX7f/NrQ0Ho74DWqlh8A3kg==
X-Received: by 2002:a7b:ce8c:0:b0:3f0:b194:4912 with SMTP id q12-20020a7bce8c000000b003f0b1944912mr3243201wmj.19.1681549714401;
        Sat, 15 Apr 2023 02:08:34 -0700 (PDT)
Received: from lucifer.home ([2a00:23c5:dc8c:8701:1663:9a35:5a7b:1d76])
        by smtp.googlemail.com with ESMTPSA id g8-20020a05600c310800b003eddc6aa5fasm9876591wmo.39.2023.04.15.02.08.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Apr 2023 02:08:33 -0700 (PDT)
From:   Lorenzo Stoakes <lstoakes@gmail.com>
To:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        iommu@lists.linux.dev
Cc:     Matthew Wilcox <willy@infradead.org>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Kevin Tian <kevin.tian@intel.com>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Lorenzo Stoakes <lstoakes@gmail.com>
Subject: [PATCH v2 2/7] mm/gup: remove unused vmas parameter from pin_user_pages_remote()
Date:   Sat, 15 Apr 2023 10:08:30 +0100
Message-Id: <cd18cc4e30c9ac67aa0ea83ca9449ddee54a86df.1681547405.git.lstoakes@gmail.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <cover.1681547405.git.lstoakes@gmail.com>
References: <cover.1681547405.git.lstoakes@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

No invocation of pin_user_pages_remote() uses the vmas parameter, so remove
it. This forms part of a larger patch set eliminating the use of the vmas
parameters altogether.

Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
---
 drivers/iommu/iommufd/pages.c   | 4 ++--
 drivers/vfio/vfio_iommu_type1.c | 2 +-
 include/linux/mm.h              | 2 +-
 mm/gup.c                        | 8 +++-----
 mm/process_vm_access.c          | 2 +-
 5 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/iommu/iommufd/pages.c b/drivers/iommu/iommufd/pages.c
index f8d92c9bb65b..9d55a2188a64 100644
--- a/drivers/iommu/iommufd/pages.c
+++ b/drivers/iommu/iommufd/pages.c
@@ -786,7 +786,7 @@ static int pfn_reader_user_pin(struct pfn_reader_user *user,
 			user->locked = 1;
 		}
 		rc = pin_user_pages_remote(pages->source_mm, uptr, npages,
-					   user->gup_flags, user->upages, NULL,
+					   user->gup_flags, user->upages,
 					   &user->locked);
 	}
 	if (rc <= 0) {
@@ -1787,7 +1787,7 @@ static int iopt_pages_rw_page(struct iopt_pages *pages, unsigned long index,
 	rc = pin_user_pages_remote(
 		pages->source_mm, (uintptr_t)(pages->uptr + index * PAGE_SIZE),
 		1, (flags & IOMMUFD_ACCESS_RW_WRITE) ? FOLL_WRITE : 0, &page,
-		NULL, NULL);
+		NULL);
 	mmap_read_unlock(pages->source_mm);
 	if (rc != 1) {
 		if (WARN_ON(rc >= 0))
diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 493c31de0edb..e6dc8fec3ed5 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -562,7 +562,7 @@ static int vaddr_get_pfns(struct mm_struct *mm, unsigned long vaddr,
 
 	mmap_read_lock(mm);
 	ret = pin_user_pages_remote(mm, vaddr, npages, flags | FOLL_LONGTERM,
-				    pages, NULL, NULL);
+				    pages, NULL);
 	if (ret > 0) {
 		int i;
 
diff --git a/include/linux/mm.h b/include/linux/mm.h
index b14cc4972d0b..ec9875c59f6d 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2378,7 +2378,7 @@ long get_user_pages_remote(struct mm_struct *mm,
 long pin_user_pages_remote(struct mm_struct *mm,
 			   unsigned long start, unsigned long nr_pages,
 			   unsigned int gup_flags, struct page **pages,
-			   struct vm_area_struct **vmas, int *locked);
+			   int *locked);
 long get_user_pages(unsigned long start, unsigned long nr_pages,
 		    unsigned int gup_flags, struct page **pages);
 long pin_user_pages(unsigned long start, unsigned long nr_pages,
diff --git a/mm/gup.c b/mm/gup.c
index 7e454d6b157e..931c805bc32b 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -3093,8 +3093,6 @@ EXPORT_SYMBOL_GPL(pin_user_pages_fast);
  * @gup_flags:	flags modifying lookup behaviour
  * @pages:	array that receives pointers to the pages pinned.
  *		Should be at least nr_pages long.
- * @vmas:	array of pointers to vmas corresponding to each page.
- *		Or NULL if the caller does not require them.
  * @locked:	pointer to lock flag indicating whether lock is held and
  *		subsequently whether VM_FAULT_RETRY functionality can be
  *		utilised. Lock must initially be held.
@@ -3109,14 +3107,14 @@ EXPORT_SYMBOL_GPL(pin_user_pages_fast);
 long pin_user_pages_remote(struct mm_struct *mm,
 			   unsigned long start, unsigned long nr_pages,
 			   unsigned int gup_flags, struct page **pages,
-			   struct vm_area_struct **vmas, int *locked)
+			   int *locked)
 {
 	int local_locked = 1;
 
-	if (!is_valid_gup_args(pages, vmas, locked, &gup_flags,
+	if (!is_valid_gup_args(pages, NULL, locked, &gup_flags,
 			       FOLL_PIN | FOLL_TOUCH | FOLL_REMOTE))
 		return 0;
-	return __gup_longterm_locked(mm, start, nr_pages, pages, vmas,
+	return __gup_longterm_locked(mm, start, nr_pages, pages, NULL,
 				     locked ? locked : &local_locked,
 				     gup_flags);
 }
diff --git a/mm/process_vm_access.c b/mm/process_vm_access.c
index 78dfaf9e8990..0523edab03a6 100644
--- a/mm/process_vm_access.c
+++ b/mm/process_vm_access.c
@@ -104,7 +104,7 @@ static int process_vm_rw_single_vec(unsigned long addr,
 		mmap_read_lock(mm);
 		pinned_pages = pin_user_pages_remote(mm, pa, pinned_pages,
 						     flags, process_pages,
-						     NULL, &locked);
+						     &locked);
 		if (locked)
 			mmap_read_unlock(mm);
 		if (pinned_pages <= 0)
-- 
2.40.0

