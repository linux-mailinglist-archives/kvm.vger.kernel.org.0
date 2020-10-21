Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 433102949E9
	for <lists+kvm@lfdr.de>; Wed, 21 Oct 2020 10:58:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502326AbgJUI5Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Oct 2020 04:57:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502320AbgJUI5M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Oct 2020 04:57:12 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2310C0613CF
        for <kvm@vger.kernel.org>; Wed, 21 Oct 2020 01:57:10 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id n6so2010546wrm.13
        for <kvm@vger.kernel.org>; Wed, 21 Oct 2020 01:57:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OPi94I7u5TlT9ZMkfo3wd9G1XVf17ZOM76y2ie/UBYo=;
        b=LHFf1nOpd9Yl+wPGLpl23bEIb0QE+8Hot8HPPyfFC6dPlkHm+Dy5yniNcp8HX0A/zw
         lIEYHsUhRbf34d1PqRehF0XEoT/gzswXJzS/vHVbL/EyCnNOruKM6IjOpvFvTkma3oc3
         x6t5IzbtOyzSuC7eyTfotP+gLU4tsrzFecuWM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OPi94I7u5TlT9ZMkfo3wd9G1XVf17ZOM76y2ie/UBYo=;
        b=bcIRbNhjrDu2CPcT4hq3iCURY16GMFQTcMJZHPmyaOl4OVCawLzEzaVz3Hss3GqpwS
         FB/0GqPzQOlk7O/uYpBUBlJ3o3ycccXiivHCrRwTS5UsHjhZ7l+9DcidMW3cwydv6PRk
         SeP9B81JXuZsIz2xLf/DO+uptK+qwcWKkaA+Hp8Ec9reYns/x2DIQSyN1pwB/CNmkgVr
         hK6Prp5T5fCoL9uyTKcb2hAVG7g61scfSJmBa9q5oVJtKoxdHyqeIU/VA4uadlmRalGq
         0N7/i8IEy/BQKzBH6FrZP+FtZyF8h8tAn1W0Qp8V3Bhs1TeYCGRZkjDu7K7Q+pBn28jG
         8ZLA==
X-Gm-Message-State: AOAM5327Uuyf8uI4auB1LSMd0r+6OZc5y36afuUQF5IVEc+QkgKMszhg
        R/EXajulx9wQ5aW0hf7E8shLTg==
X-Google-Smtp-Source: ABdhPJw9zQlQYxuU/CNLju53SaBbNIHKJyF+jiQvqzMWRBPWLPGowYaSPULBChwBYVyW5+HEPgaJwA==
X-Received: by 2002:adf:cd87:: with SMTP id q7mr3373418wrj.169.1603270629486;
        Wed, 21 Oct 2020 01:57:09 -0700 (PDT)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id q8sm2675939wro.32.2020.10.21.01.57.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2020 01:57:08 -0700 (PDT)
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
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.com>
Subject: [PATCH v3 05/16] mm/frame-vector: Use FOLL_LONGTERM
Date:   Wed, 21 Oct 2020 10:56:44 +0200
Message-Id: <20201021085655.1192025-6-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201021085655.1192025-1-daniel.vetter@ffwll.ch>
References: <20201021085655.1192025-1-daniel.vetter@ffwll.ch>
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
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.com>
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

