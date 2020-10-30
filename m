Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 010072A027C
	for <lists+kvm@lfdr.de>; Fri, 30 Oct 2020 11:10:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726340AbgJ3KKm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Oct 2020 06:10:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726344AbgJ3KIq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Oct 2020 06:08:46 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAD2AC0613D2
        for <kvm@vger.kernel.org>; Fri, 30 Oct 2020 03:08:45 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id w14so5781768wrs.9
        for <kvm@vger.kernel.org>; Fri, 30 Oct 2020 03:08:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5VbYPjpc0ChYwbbTgMYmHroaW5HF4a/lmU2ezjjPyKs=;
        b=OE7ODljfg5zYJBQtW0QuYxlR4KXtE85Ja01uQ2DMdxx2GpBsjSlcNmfMNQbCG+kNjo
         LixqeX7mvOxZXGfqzuOMiSC7tcEPjUCegSJW1mWPqssoq64+iOZ+LKEAOZGdVSY0Wa4R
         64xAv6B0jpJaiz7VUMHSuryliKlo0Qfmwj12U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5VbYPjpc0ChYwbbTgMYmHroaW5HF4a/lmU2ezjjPyKs=;
        b=MKLAnDrt89ITCISrq268UNMrIqEgUuDAYlKdaYhjepqQ2txpd/8gnil/JmRN4EKNNL
         1zekXFoFBJ+Wlw7FOrgYpdHnkEb2xmJeoAHvH+/I1VH99JbET41HnUfqN0c3Ms9nxZtQ
         Wt79rU3gA1jif+1N80UMYuxhMrBM4DbYwkfuiinw7iWP8mw+AcWytxhK14wa4ePBO0JZ
         eJXviEHxOfWzHazkiA5qrNQelMUKS6TJfFkojWDW4hPsDS8m3J74FU2u+qA831Q9Mb7t
         LgI/G5kh1S0IfjgwVIaE6Qljxy5i5lkhh122kys/Xw5qYvWbZdfYPRDMlnI0cxMiNgUs
         GpcQ==
X-Gm-Message-State: AOAM533E6rTuReamiYP5sh+95Cc+tQX/V5JWmqO4IKGbjMGnSPF7CFXl
        VPW6/xdXs0/RdbnNKobJu54yVQ==
X-Google-Smtp-Source: ABdhPJyETsw+rdDmSmdKEqL1hei+cZMLQfTxnbjyqr7JYJt2TnKRMYu3u2d5KOQv2rtW2RW3CkNB1A==
X-Received: by 2002:adf:aad0:: with SMTP id i16mr2025058wrc.270.1604052524472;
        Fri, 30 Oct 2020 03:08:44 -0700 (PDT)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id v189sm4430947wmg.14.2020.10.30.03.08.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2020 03:08:43 -0700 (PDT)
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
To:     DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Hubbard <jhubbard@nvidia.com>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
        Jan Kara <jack@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v5 05/15] mm/frame-vector: Use FOLL_LONGTERM
Date:   Fri, 30 Oct 2020 11:08:05 +0100
Message-Id: <20201030100815.2269-6-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201030100815.2269-1-daniel.vetter@ffwll.ch>
References: <20201030100815.2269-1-daniel.vetter@ffwll.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is used by media/videbuf2 for persistent dma mappings, not just
for a single dma operation and then freed again, so needs
FOLL_LONGTERM.

Unfortunately current pup_locked doesn't support FOLL_LONGTERM due to
locking issues. Rework the code to pull the pup path out from the
mmap_sem critical section as suggested by Jason.

By relying entirely on the vma checks in pin_user_pages and follow_pfn
(for vm_flags and vma_is_fsdax) we can also streamline the code a lot.

Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Pawel Osciak <pawel@osciak.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Tomasz Figa <tfiga@chromium.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Jérôme Glisse <jglisse@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: linux-mm@kvack.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-samsung-soc@vger.kernel.org
Cc: linux-media@vger.kernel.org
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
--
v2: Streamline the code and further simplify the loop checks (Jason)

v5: Review from Tomasz:
- fix page counting for the follow_pfn case by resetting ret
- drop gup_flags paramater, now unused
---
 .../media/common/videobuf2/videobuf2-memops.c |  3 +-
 include/linux/mm.h                            |  2 +-
 mm/frame_vector.c                             | 53 ++++++-------------
 3 files changed, 19 insertions(+), 39 deletions(-)

diff --git a/drivers/media/common/videobuf2/videobuf2-memops.c b/drivers/media/common/videobuf2/videobuf2-memops.c
index 6e9e05153f4e..9dd6c27162f4 100644
--- a/drivers/media/common/videobuf2/videobuf2-memops.c
+++ b/drivers/media/common/videobuf2/videobuf2-memops.c
@@ -40,7 +40,6 @@ struct frame_vector *vb2_create_framevec(unsigned long start,
 	unsigned long first, last;
 	unsigned long nr;
 	struct frame_vector *vec;
-	unsigned int flags = FOLL_FORCE | FOLL_WRITE;
 
 	first = start >> PAGE_SHIFT;
 	last = (start + length - 1) >> PAGE_SHIFT;
@@ -48,7 +47,7 @@ struct frame_vector *vb2_create_framevec(unsigned long start,
 	vec = frame_vector_create(nr);
 	if (!vec)
 		return ERR_PTR(-ENOMEM);
-	ret = get_vaddr_frames(start & PAGE_MASK, nr, flags, vec);
+	ret = get_vaddr_frames(start & PAGE_MASK, nr, vec);
 	if (ret < 0)
 		goto out_destroy;
 	/* We accept only complete set of PFNs */
diff --git a/include/linux/mm.h b/include/linux/mm.h
index ef360fe70aaf..d6b8e30dce2e 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1765,7 +1765,7 @@ struct frame_vector {
 struct frame_vector *frame_vector_create(unsigned int nr_frames);
 void frame_vector_destroy(struct frame_vector *vec);
 int get_vaddr_frames(unsigned long start, unsigned int nr_pfns,
-		     unsigned int gup_flags, struct frame_vector *vec);
+		     struct frame_vector *vec);
 void put_vaddr_frames(struct frame_vector *vec);
 int frame_vector_to_pages(struct frame_vector *vec);
 void frame_vector_to_pfns(struct frame_vector *vec);
diff --git a/mm/frame_vector.c b/mm/frame_vector.c
index 10f82d5643b6..f8c34b895c76 100644
--- a/mm/frame_vector.c
+++ b/mm/frame_vector.c
@@ -32,13 +32,12 @@
  * This function takes care of grabbing mmap_lock as necessary.
  */
 int get_vaddr_frames(unsigned long start, unsigned int nr_frames,
-		     unsigned int gup_flags, struct frame_vector *vec)
+		     struct frame_vector *vec)
 {
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma;
 	int ret = 0;
 	int err;
-	int locked;
 
 	if (nr_frames == 0)
 		return 0;
@@ -48,40 +47,26 @@ int get_vaddr_frames(unsigned long start, unsigned int nr_frames,
 
 	start = untagged_addr(start);
 
-	mmap_read_lock(mm);
-	locked = 1;
-	vma = find_vma_intersection(mm, start, start + 1);
-	if (!vma) {
-		ret = -EFAULT;
-		goto out;
-	}
-
-	/*
-	 * While get_vaddr_frames() could be used for transient (kernel
-	 * controlled lifetime) pinning of memory pages all current
-	 * users establish long term (userspace controlled lifetime)
-	 * page pinning. Treat get_vaddr_frames() like
-	 * get_user_pages_longterm() and disallow it for filesystem-dax
-	 * mappings.
-	 */
-	if (vma_is_fsdax(vma)) {
-		ret = -EOPNOTSUPP;
-		goto out;
-	}
-
-	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP))) {
+	ret = pin_user_pages_fast(start, nr_frames,
+				  FOLL_FORCE | FOLL_WRITE | FOLL_LONGTERM,
+				  (struct page **)(vec->ptrs));
+	if (ret > 0) {
 		vec->got_ref = true;
 		vec->is_pfns = false;
-		ret = pin_user_pages_locked(start, nr_frames,
-			gup_flags, (struct page **)(vec->ptrs), &locked);
-		goto out;
+		goto out_unlocked;
 	}
 
+	mmap_read_lock(mm);
 	vec->got_ref = false;
 	vec->is_pfns = true;
+	ret = 0;
 	do {
 		unsigned long *nums = frame_vector_pfns(vec);
 
+		vma = find_vma_intersection(mm, start, start + 1);
+		if (!vma)
+			break;
+
 		while (ret < nr_frames && start + PAGE_SIZE <= vma->vm_end) {
 			err = follow_pfn(vma, start, &nums[ret]);
 			if (err) {
@@ -92,17 +77,13 @@ int get_vaddr_frames(unsigned long start, unsigned int nr_frames,
 			start += PAGE_SIZE;
 			ret++;
 		}
-		/*
-		 * We stop if we have enough pages or if VMA doesn't completely
-		 * cover the tail page.
-		 */
-		if (ret >= nr_frames || start < vma->vm_end)
+		/* Bail out if VMA doesn't completely cover the tail page. */
+		if (start < vma->vm_end)
 			break;
-		vma = find_vma_intersection(mm, start, start + 1);
-	} while (vma && vma->vm_flags & (VM_IO | VM_PFNMAP));
+	} while (ret < nr_frames);
 out:
-	if (locked)
-		mmap_read_unlock(mm);
+	mmap_read_unlock(mm);
+out_unlocked:
 	if (!ret)
 		ret = -EFAULT;
 	if (ret > 0)
-- 
2.28.0

