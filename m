Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72433298B35
	for <lists+kvm@lfdr.de>; Mon, 26 Oct 2020 12:01:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1772971AbgJZLAW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Oct 2020 07:00:22 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:35021 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1772412AbgJZK6f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Oct 2020 06:58:35 -0400
Received: by mail-wm1-f67.google.com with SMTP id h22so879063wmb.0
        for <kvm@vger.kernel.org>; Mon, 26 Oct 2020 03:58:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cXs1UvblKDwz1YQCIe37x2wwQ5T1EiKP8bli0y6YQUo=;
        b=E/O7+voKlzMLNr1tMV7GRLom+PNYHCgDQ3OQYV/aWqFBixt9URXmul00B6LbSiurKm
         FWBH3nEs3LtTvDZrOsKqWR6sU78g5LH1U1/DYzkNraEMVQf7DvkjdRanjf1DSeK2bJTj
         IABPWNTOBt65UzvJe20ya2kIjM8TNoEQ70DME=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cXs1UvblKDwz1YQCIe37x2wwQ5T1EiKP8bli0y6YQUo=;
        b=iZbVuMV8LWyTAv7PNBqltsQ/zn3mW9gtf0wviSiUyF1ZuXoRNiwFZWR7/n22sm04wc
         piHgIApDW5yUoWHCnTj/CSXYTShdoct6j9NkqU7oXBHuKMUIBZ5lAoG7q/ie/77umzTE
         ZMkyuAYxJ34PLQ/LD+7JFXsxMMcXX0KaoduOaMSL98hqLBi42TJg4yJt7BtbuoVfELAx
         9LmUvsMEEQWLaFHrgAGtmgr1mOeCjAhqBhIOlyFa/sj3sopOXwgeG42xOmA7J8Le5ESI
         VKEbdVDgLVVGUmj9okN81IZxqffpDdOlLUuFuNlfd2ZvjNwbdJ/Ux35U7OxHadrRdpXI
         fJ2w==
X-Gm-Message-State: AOAM533fc4a5kiCLsX+Mc7zivyW8EyWFoht0S16C9woswnTeZoPJqwWu
        ufZmKETd9cwVR9N7Dd+nnrhwew==
X-Google-Smtp-Source: ABdhPJxmBoKR8n4PO1pSYo1/0YhdisFijwUoQU4+g9izXaJK8ALrEJgk5lU4qb520qBwIoYy7NeuKA==
X-Received: by 2002:a1c:2cc2:: with SMTP id s185mr15884686wms.77.1603709912789;
        Mon, 26 Oct 2020 03:58:32 -0700 (PDT)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id w83sm21165156wmg.48.2020.10.26.03.58.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2020 03:58:32 -0700 (PDT)
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
To:     DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-s390@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
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
Subject: [PATCH v4 05/15] mm/frame-vector: Use FOLL_LONGTERM
Date:   Mon, 26 Oct 2020 11:58:08 +0100
Message-Id: <20201026105818.2585306-6-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201026105818.2585306-1-daniel.vetter@ffwll.ch>
References: <20201026105818.2585306-1-daniel.vetter@ffwll.ch>
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
---
 mm/frame_vector.c | 50 ++++++++++++++---------------------------------
 1 file changed, 15 insertions(+), 35 deletions(-)

diff --git a/mm/frame_vector.c b/mm/frame_vector.c
index 10f82d5643b6..d44779e56313 100644
--- a/mm/frame_vector.c
+++ b/mm/frame_vector.c
@@ -38,7 +38,6 @@ int get_vaddr_frames(unsigned long start, unsigned int nr_frames,
 	struct vm_area_struct *vma;
 	int ret = 0;
 	int err;
-	int locked;
 
 	if (nr_frames == 0)
 		return 0;
@@ -48,40 +47,25 @@ int get_vaddr_frames(unsigned long start, unsigned int nr_frames,
 
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
 	do {
 		unsigned long *nums = frame_vector_pfns(vec);
 
+		vma = find_vma_intersection(mm, start, start + 1);
+		if (!vma)
+			break;
+
 		while (ret < nr_frames && start + PAGE_SIZE <= vma->vm_end) {
 			err = follow_pfn(vma, start, &nums[ret]);
 			if (err) {
@@ -92,17 +76,13 @@ int get_vaddr_frames(unsigned long start, unsigned int nr_frames,
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

