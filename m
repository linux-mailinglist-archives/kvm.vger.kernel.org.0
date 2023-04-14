Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B999F6E2CD2
	for <lists+kvm@lfdr.de>; Sat, 15 Apr 2023 01:27:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbjDNX1g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Apr 2023 19:27:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229840AbjDNX1f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Apr 2023 19:27:35 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A0A51BC2;
        Fri, 14 Apr 2023 16:27:33 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id ffacd0b85a97d-2efbab47633so65553f8f.2;
        Fri, 14 Apr 2023 16:27:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681514852; x=1684106852;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1VJscWXDoV805lUglV9Lx4G4y0RL2KQ+qVhOtcQn4So=;
        b=TQhDiOv0KwrX1cl+HMRY/m9AlRUvTYmjRVKkUqK7mY3kxSUGxZiTt8OYrLUmUeyCKW
         oAUQJOGgCStHEvZfAYU02YzPBy26VHk1lJviLsUEA6XAPswuM4D05Dp+mfBQIJ+XfaX7
         1QujcskdwR8bLgjh1lu+JhFW63rvse6gXWwLjCkbo7iYN74NDaNkhM7Lie2u9dYw/jOj
         lG4gRmfBXpDCu/JYCZVyYhoUuPl+LjI+gbL/TJWPjqP7lOVKGKftL3cndCs5fGFAXuyW
         WjyPGFoN1jOK6Qkr4qiCPERBiYVC40Ip8Nxzn7FSB+NU4/YlO4xATw65tFgRiSl2He4f
         PI5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681514852; x=1684106852;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1VJscWXDoV805lUglV9Lx4G4y0RL2KQ+qVhOtcQn4So=;
        b=ZCykG09M0LrvYGXhlS0z4jCSepMRce2qiToTBNDA/wpJV5gPnRvbnT/nBW1e+XuCP2
         XmiPDoPRe2QmUURwCD9up9BVhsdeCBA0+VJuNsCrfUI5tE5ATU7n7Me/QaiTHpvDQkx5
         da5nMcb0rdsd4fph9IRk359LZmsChLrimYVIihe3AKMK34r+FUnitWoSvcDOzoPa264d
         a0muI/QL07qM26u0y3iLypcexRzZvdn0ybqpXuoOUZFgN9J7iE0qEBXsoIFIRvfK2jl0
         1HuMUtdhOBdCzQDvTqDxn2TS6P50aVnveHNsxy5a5CFLbKGSn/SgushKokso6uy+7p0m
         r03A==
X-Gm-Message-State: AAQBX9dC0TGYdsc2A7/pOAsWbwKke6OyzhkmMSEbF3BWCoh9ohkvFzxL
        tgYFweDgv9o9BfHd3/cL2TpPBS2MECY=
X-Google-Smtp-Source: AKy350btVgvfuTZx4LLwP2D/aSmexxkQWIDKHhEHiIOChilrQmlVnxBaZQKRLjJJ40FW9Avxwpik5Q==
X-Received: by 2002:adf:e506:0:b0:2ef:9837:6b2b with SMTP id j6-20020adfe506000000b002ef98376b2bmr255643wrm.21.1681514851612;
        Fri, 14 Apr 2023 16:27:31 -0700 (PDT)
Received: from lucifer.home (host86-156-84-164.range86-156.btcentralplus.com. [86.156.84.164])
        by smtp.googlemail.com with ESMTPSA id s9-20020a5d6a89000000b002cf1c435afcsm4550694wru.11.2023.04.14.16.27.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Apr 2023 16:27:30 -0700 (PDT)
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
Subject: [PATCH 2/7] mm/gup: remove unused vmas parameter from pin_user_pages_remote()
Date:   Sat, 15 Apr 2023 00:27:23 +0100
Message-Id: <c75291e4afe968824b89831cbd341f8b54ce28a4.1681508038.git.lstoakes@gmail.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <cover.1681508038.git.lstoakes@gmail.com>
References: <cover.1681508038.git.lstoakes@gmail.com>
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
index faeed36c2d04..513d5fab02f1 100644
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

