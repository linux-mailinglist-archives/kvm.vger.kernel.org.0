Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFBFA294A02
	for <lists+kvm@lfdr.de>; Wed, 21 Oct 2020 10:59:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502116AbgJUI5G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Oct 2020 04:57:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2441048AbgJUI5F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Oct 2020 04:57:05 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 920A6C0613D6
        for <kvm@vger.kernel.org>; Wed, 21 Oct 2020 01:57:04 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id n6so2010091wrm.13
        for <kvm@vger.kernel.org>; Wed, 21 Oct 2020 01:57:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=K95D/JeFvwIRswqJ5AyZx2c3o+Go5rbi2d1Aft3apVY=;
        b=Hd5qr7pZZO1AF760IHt5p0pXKDL2hqdJ3sUJVr7XIGUMaqaAvNysYEec4f09iASZfR
         NNiTDBnpFl36ANaTjQP9R6ClT5cy809US9aIQXED4/OldrY173V7OBDkje/vz4pn3KvB
         rgWsXHgy+UPbTuurH+E1eCmRcP1XEOsN6bb/U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=K95D/JeFvwIRswqJ5AyZx2c3o+Go5rbi2d1Aft3apVY=;
        b=AG6LLJGkjmJ8c+nMmsKPvriQ7pF8hCa0OW5voT9UQG0fjiM6S9EgEbt/jgMPIlTmkn
         eWy37FVd0fsFmcwZVX+QOOrpJwwWItCgBviqefxJUnQqrCb1DjWb+QjV2h+WKyx6e8t5
         1oxp0fH/OO3pwvkfNxn+19mp6dSJT3lVjm9v6YqX097wwkNSXA07yGPcXGFWcQhvWiiO
         IeV6Rp6pCDw5L+R7BO4+Tv1hnuHtAe8Qp5CqsgtniscJFe4CZfw9BsW97lR7SO3SgNq/
         9ESJ0TEbDsP/mpIwaxgAgBdEqPAHUI4r1neZuWrn+3OvifPyBuul4CGs1jMQIWOCf/7G
         URyA==
X-Gm-Message-State: AOAM530ezZkkbgIr4tO6Qab8p2K/p3NmLz9WuGJfUX4oDBXWNZB8J905
        K5yOca/f2Ftg2BnyjNlWFOumLg==
X-Google-Smtp-Source: ABdhPJw2XMtVnZfoQx45xaQNDg3qnrf6WmNn/N8qNOBOueDi4hxOOcHlcdccOX48m/SzW3eHWMyAJw==
X-Received: by 2002:a5d:4dc1:: with SMTP id f1mr3452736wru.42.1603270623303;
        Wed, 21 Oct 2020 01:57:03 -0700 (PDT)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id q8sm2675939wro.32.2020.10.21.01.57.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2020 01:57:02 -0700 (PDT)
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
To:     DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-s390@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        John Hubbard <jhubbard@nvidia.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Inki Dae <inki.dae@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
        Jan Kara <jack@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.com>
Subject: [PATCH v3 01/16] drm/exynos: Stop using frame_vector helpers
Date:   Wed, 21 Oct 2020 10:56:40 +0200
Message-Id: <20201021085655.1192025-2-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201021085655.1192025-1-daniel.vetter@ffwll.ch>
References: <20201021085655.1192025-1-daniel.vetter@ffwll.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

All we need are a pages array, pin_user_pages_fast can give us that
directly. Plus this avoids the entire raw pfn side of get_vaddr_frames.

Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Inki Dae <inki.dae@samsung.com>
Cc: Joonyoung Shim <jy0922.shim@samsung.com>
Cc: Seung-Woo Kim <sw0312.kim@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Kukjin Kim <kgene@kernel.org>
Cc: Krzysztof Kozlowski <krzk@kernel.org>
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
v2: Use unpin_user_pages_dirty_lock (John)
---
 drivers/gpu/drm/exynos/Kconfig          |  1 -
 drivers/gpu/drm/exynos/exynos_drm_g2d.c | 47 +++++++++++--------------
 2 files changed, 20 insertions(+), 28 deletions(-)

diff --git a/drivers/gpu/drm/exynos/Kconfig b/drivers/gpu/drm/exynos/Kconfig
index 6417f374b923..43257ef3c09d 100644
--- a/drivers/gpu/drm/exynos/Kconfig
+++ b/drivers/gpu/drm/exynos/Kconfig
@@ -88,7 +88,6 @@ comment "Sub-drivers"
 config DRM_EXYNOS_G2D
 	bool "G2D"
 	depends on VIDEO_SAMSUNG_S5P_G2D=n || COMPILE_TEST
-	select FRAME_VECTOR
 	help
 	  Choose this option if you want to use Exynos G2D for DRM.
 
diff --git a/drivers/gpu/drm/exynos/exynos_drm_g2d.c b/drivers/gpu/drm/exynos/exynos_drm_g2d.c
index 967a5cdc120e..ecede41af9b9 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_g2d.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_g2d.c
@@ -205,7 +205,8 @@ struct g2d_cmdlist_userptr {
 	dma_addr_t		dma_addr;
 	unsigned long		userptr;
 	unsigned long		size;
-	struct frame_vector	*vec;
+	struct page		**pages;
+	unsigned int		npages;
 	struct sg_table		*sgt;
 	atomic_t		refcount;
 	bool			in_pool;
@@ -378,7 +379,6 @@ static void g2d_userptr_put_dma_addr(struct g2d_data *g2d,
 					bool force)
 {
 	struct g2d_cmdlist_userptr *g2d_userptr = obj;
-	struct page **pages;
 
 	if (!obj)
 		return;
@@ -398,15 +398,9 @@ static void g2d_userptr_put_dma_addr(struct g2d_data *g2d,
 	dma_unmap_sgtable(to_dma_dev(g2d->drm_dev), g2d_userptr->sgt,
 			  DMA_BIDIRECTIONAL, 0);
 
-	pages = frame_vector_pages(g2d_userptr->vec);
-	if (!IS_ERR(pages)) {
-		int i;
-
-		for (i = 0; i < frame_vector_count(g2d_userptr->vec); i++)
-			set_page_dirty_lock(pages[i]);
-	}
-	put_vaddr_frames(g2d_userptr->vec);
-	frame_vector_destroy(g2d_userptr->vec);
+	unpin_user_pages_dirty_lock(g2d_userptr->pages, g2d_userptr->npages,
+				    true);
+	kvfree(g2d_userptr->pages);
 
 	if (!g2d_userptr->out_of_list)
 		list_del_init(&g2d_userptr->list);
@@ -474,35 +468,34 @@ static dma_addr_t *g2d_userptr_get_dma_addr(struct g2d_data *g2d,
 	offset = userptr & ~PAGE_MASK;
 	end = PAGE_ALIGN(userptr + size);
 	npages = (end - start) >> PAGE_SHIFT;
-	g2d_userptr->vec = frame_vector_create(npages);
-	if (!g2d_userptr->vec) {
+	g2d_userptr->pages = kvmalloc_array(npages, sizeof(*g2d_userptr->pages),
+					    GFP_KERNEL);
+	if (!g2d_userptr->pages) {
 		ret = -ENOMEM;
 		goto err_free;
 	}
 
-	ret = get_vaddr_frames(start, npages, FOLL_FORCE | FOLL_WRITE,
-		g2d_userptr->vec);
+	ret = pin_user_pages_fast(start, npages, FOLL_FORCE | FOLL_WRITE,
+				  g2d_userptr->pages);
 	if (ret != npages) {
 		DRM_DEV_ERROR(g2d->dev,
 			      "failed to get user pages from userptr.\n");
 		if (ret < 0)
-			goto err_destroy_framevec;
-		ret = -EFAULT;
-		goto err_put_framevec;
-	}
-	if (frame_vector_to_pages(g2d_userptr->vec) < 0) {
+			goto err_destroy_pages;
+		npages = ret;
 		ret = -EFAULT;
-		goto err_put_framevec;
+		goto err_unpin_pages;
 	}
+	g2d_userptr->npages = npages;
 
 	sgt = kzalloc(sizeof(*sgt), GFP_KERNEL);
 	if (!sgt) {
 		ret = -ENOMEM;
-		goto err_put_framevec;
+		goto err_unpin_pages;
 	}
 
 	ret = sg_alloc_table_from_pages(sgt,
-					frame_vector_pages(g2d_userptr->vec),
+					g2d_userptr->pages,
 					npages, offset, size, GFP_KERNEL);
 	if (ret < 0) {
 		DRM_DEV_ERROR(g2d->dev, "failed to get sgt from pages.\n");
@@ -538,11 +531,11 @@ static dma_addr_t *g2d_userptr_get_dma_addr(struct g2d_data *g2d,
 err_free_sgt:
 	kfree(sgt);
 
-err_put_framevec:
-	put_vaddr_frames(g2d_userptr->vec);
+err_unpin_pages:
+	unpin_user_pages(g2d_userptr->pages, npages);
 
-err_destroy_framevec:
-	frame_vector_destroy(g2d_userptr->vec);
+err_destroy_pages:
+	kvfree(g2d_userptr->pages);
 
 err_free:
 	kfree(g2d_userptr);
-- 
2.28.0

