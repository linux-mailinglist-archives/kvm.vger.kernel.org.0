Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ECE770720D
	for <lists+kvm@lfdr.de>; Wed, 17 May 2023 21:26:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbjEQT0R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 May 2023 15:26:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229799AbjEQT0J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 May 2023 15:26:09 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FD13A5D7;
        Wed, 17 May 2023 12:25:43 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id ffacd0b85a97d-30636edb493so296619f8f.1;
        Wed, 17 May 2023 12:25:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684351539; x=1686943539;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S3weABmS34nZVMLJo+XTzwZMXin1WTjGdDKVc/7JR4E=;
        b=jGTRNaT/LTEfefiq7iqw5TaJTPZA9TvIW3MjtLorKW+Kvhvp856nVPG5cbioprbYxW
         /1gJIPovKpgZj//NU8LN58hvGAl9o0TeOmswwjgR3g+OAR/02RTQtyaXz2b/YGkqVosZ
         6hsrlRZVEvvFxPLck4msRzdPTPsf3m2WXx7T13x0VCG4M0mW/wr55sxmbQSTnd7YYheo
         vQujQxPFUYm7HVF1F1sW21FscyTgGBy6UrtT6V5kydLfRh12iqndOBJOMXpYaHJWHt4Q
         AZvImUUAbB5UT1lEZFAFTBzcRayTpDXVrTX416cenJYX7bP0DZ8GK1O/VM1RVqG+2Bug
         lavQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684351539; x=1686943539;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S3weABmS34nZVMLJo+XTzwZMXin1WTjGdDKVc/7JR4E=;
        b=MnOuq+TFGSiNu0iCYxnA6TprVzs0KvmdrFWnDCwLYshyXZ7feF/8Qq+scvTTYN6QDo
         BCP77GHs9u1cIugWKyeTxbxBafQw13ohUcbSNwnEgnuKu1CcixNcuOO70R+YbIkqcJZn
         Qd6ukVv7hNQDxB9L1bs3DR7rHj6SsOAWNDlp4+fIlr5EGmMHjoyrDWCDp/q2VhRRiGWf
         uzCK1WxXTSEnt0iI4RqYhWZF4aj2teFIiUXK50Oo8FoID40R6/dHjax+UhGUq7WqW8cA
         DwUTtnpzbs5KmgrmIuJGlh9PJmIl1eWtg1YSB3eyOQQnSi2+KZoKZZzouJ+BT636LHAE
         bleQ==
X-Gm-Message-State: AC+VfDyipHD97r2CrIwLubxZW7J7ooNZz76hfrkPhBIixiF29B91ttKW
        RkyxMga/H81eJstlJ3yRWMA=
X-Google-Smtp-Source: ACHHUZ41Ld9JgKrYrlAx6gZJdD/qq/cESCQqKPp4/u9Jh+7PIgc4GjZmT9TPDR7j6Hx7/rIs3UxZoQ==
X-Received: by 2002:a5d:528a:0:b0:2fd:c315:bb2c with SMTP id c10-20020a5d528a000000b002fdc315bb2cmr1331031wrv.22.1684351539048;
        Wed, 17 May 2023 12:25:39 -0700 (PDT)
Received: from lucifer.home (host86-156-84-164.range86-156.btcentralplus.com. [86.156.84.164])
        by smtp.googlemail.com with ESMTPSA id t2-20020a5d5342000000b00307972e46fasm3588386wrv.107.2023.05.17.12.25.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 12:25:38 -0700 (PDT)
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
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Lorenzo Stoakes <lstoakes@gmail.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH v6 2/6] mm/gup: remove unused vmas parameter from pin_user_pages_remote()
Date:   Wed, 17 May 2023 20:25:36 +0100
Message-Id: <28f000beb81e45bf538a2aaa77c90f5482b67a32.1684350871.git.lstoakes@gmail.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1684350871.git.lstoakes@gmail.com>
References: <cover.1684350871.git.lstoakes@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

No invocation of pin_user_pages_remote() uses the vmas parameter, so remove
it. This forms part of a larger patch set eliminating the use of the vmas
parameters altogether.

Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
---
 drivers/iommu/iommufd/pages.c    | 4 ++--
 drivers/vfio/vfio_iommu_type1.c  | 2 +-
 include/linux/mm.h               | 2 +-
 kernel/trace/trace_events_user.c | 2 +-
 mm/gup.c                         | 8 +++-----
 mm/process_vm_access.c           | 2 +-
 6 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/iommu/iommufd/pages.c b/drivers/iommu/iommufd/pages.c
index 3c47846cc5ef..412ca96be128 100644
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
@@ -1799,7 +1799,7 @@ static int iopt_pages_rw_page(struct iopt_pages *pages, unsigned long index,
 	rc = pin_user_pages_remote(
 		pages->source_mm, (uintptr_t)(pages->uptr + index * PAGE_SIZE),
 		1, (flags & IOMMUFD_ACCESS_RW_WRITE) ? FOLL_WRITE : 0, &page,
-		NULL, NULL);
+		NULL);
 	mmap_read_unlock(pages->source_mm);
 	if (rc != 1) {
 		if (WARN_ON(rc >= 0))
diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 3d4dd9420c30..3d2d9a944906 100644
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
index 2c1a92bf5626..8ea82e9e7719 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2380,7 +2380,7 @@ long get_user_pages_remote(struct mm_struct *mm,
 long pin_user_pages_remote(struct mm_struct *mm,
 			   unsigned long start, unsigned long nr_pages,
 			   unsigned int gup_flags, struct page **pages,
-			   struct vm_area_struct **vmas, int *locked);
+			   int *locked);
 long get_user_pages(unsigned long start, unsigned long nr_pages,
 		    unsigned int gup_flags, struct page **pages);
 long pin_user_pages(unsigned long start, unsigned long nr_pages,
diff --git a/kernel/trace/trace_events_user.c b/kernel/trace/trace_events_user.c
index b1ecd7677642..bdc2666e8d39 100644
--- a/kernel/trace/trace_events_user.c
+++ b/kernel/trace/trace_events_user.c
@@ -406,7 +406,7 @@ static int user_event_enabler_write(struct user_event_mm *mm,
 		return -EBUSY;
 
 	ret = pin_user_pages_remote(mm->mm, uaddr, 1, FOLL_WRITE | FOLL_NOFAULT,
-				    &page, NULL, NULL);
+				    &page, NULL);
 
 	if (unlikely(ret <= 0)) {
 		if (!fixup_fault)
diff --git a/mm/gup.c b/mm/gup.c
index b8189396f435..ce78a5186dbb 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -3243,8 +3243,6 @@ EXPORT_SYMBOL_GPL(pin_user_pages_fast);
  * @gup_flags:	flags modifying lookup behaviour
  * @pages:	array that receives pointers to the pages pinned.
  *		Should be at least nr_pages long.
- * @vmas:	array of pointers to vmas corresponding to each page.
- *		Or NULL if the caller does not require them.
  * @locked:	pointer to lock flag indicating whether lock is held and
  *		subsequently whether VM_FAULT_RETRY functionality can be
  *		utilised. Lock must initially be held.
@@ -3259,14 +3257,14 @@ EXPORT_SYMBOL_GPL(pin_user_pages_fast);
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
2.40.1

