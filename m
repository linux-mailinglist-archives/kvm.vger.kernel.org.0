Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 294682884B7
	for <lists+kvm@lfdr.de>; Fri,  9 Oct 2020 10:02:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732686AbgJIIB7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Oct 2020 04:01:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732683AbgJIIAM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Oct 2020 04:00:12 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83D5EC0613E1
        for <kvm@vger.kernel.org>; Fri,  9 Oct 2020 00:59:57 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id d81so8864194wmc.1
        for <kvm@vger.kernel.org>; Fri, 09 Oct 2020 00:59:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=L2oZv7vxEZZWtTO3C1Lp0XtxkN66QV3fUnWxu78Rh38=;
        b=bKzq2hZGOXu0fkRVuHIJG2XdpMLBMLxx8G3yFQUHXKyWtYO+OHOAhvEMdWtfddJPky
         lUh2trsfuVCq/RGQTrV1pHhiifcSTHeUjmS3vMPfONOs+Ca+ALkk3BA4oWopUBar7jBe
         WASwfm88dJqsT9h2tML16LqS2STnW0TBm//DA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=L2oZv7vxEZZWtTO3C1Lp0XtxkN66QV3fUnWxu78Rh38=;
        b=PL86+L65A4Ob4r5hUb3vIBN0iDKsUody8AmVjMPPX0G1KOjEDf5G2zoJf57/UExPzR
         ENiayS5mdzuww9K7VuJSs91oJRnxXjjnvDR2WjgJx77ndhOKwhPHtiz+dXwXDzr8mnJG
         3Zno0TK/YyzscSf/JEXbo5wWBY29WiMRphQKPzapj+4/Sk0II+7IBPo+Yju+hBWcSwqu
         TCU/Jp20azZm/gwJA0lKBsI9YnD+R6sXcRDSz3Tjlk6As1/HqoA+jEy1cISLo2W5PWq+
         sRlwhzm03hRZbryBwpjweb91A0otIzbl1At5NNPEs17RdJrcrqyblanWGqXbS1S7iUk8
         luQQ==
X-Gm-Message-State: AOAM531V1ibVqWTLM7lWv0tQ8y9uxrzvMvQ+9z37qCBwAq/2g0AMmgfD
        hnW1TpXPxvP9mcBmSc2NKGiaRg==
X-Google-Smtp-Source: ABdhPJzG3BYXEMIUcMAsDOoP86h0w2yTKkQt8nM1pRPVArdkv8JKqITJk6zo5uSkNezo/eZMOHu0cw==
X-Received: by 2002:a1c:8057:: with SMTP id b84mr12530132wmd.116.1602230396240;
        Fri, 09 Oct 2020 00:59:56 -0700 (PDT)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id u17sm11634118wri.45.2020.10.09.00.59.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2020 00:59:55 -0700 (PDT)
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
To:     DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-s390@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Hubbard <jhubbard@nvidia.com>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
        Jan Kara <jack@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Oded Gabbay <oded.gabbay@gmail.com>,
        Omer Shpigelman <oshpigelman@habana.ai>,
        Ofir Bitton <obitton@habana.ai>,
        Tomer Tayar <ttayar@habana.ai>,
        Moti Haimovski <mhaimovski@habana.ai>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pawel Piskorski <ppiskorski@habana.ai>
Subject: [PATCH v2 03/17] misc/habana: Stop using frame_vector helpers
Date:   Fri,  9 Oct 2020 09:59:20 +0200
Message-Id: <20201009075934.3509076-4-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201009075934.3509076-1-daniel.vetter@ffwll.ch>
References: <20201009075934.3509076-1-daniel.vetter@ffwll.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

All we need are a pages array, pin_user_pages_fast can give us that
directly. Plus this avoids the entire raw pfn side of get_vaddr_frames.

Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Jérôme Glisse <jglisse@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: linux-mm@kvack.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-samsung-soc@vger.kernel.org
Cc: linux-media@vger.kernel.org
Cc: Oded Gabbay <oded.gabbay@gmail.com>
Cc: Omer Shpigelman <oshpigelman@habana.ai>
Cc: Ofir Bitton <obitton@habana.ai>
Cc: Tomer Tayar <ttayar@habana.ai>
Cc: Moti Haimovski <mhaimovski@habana.ai>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Pawel Piskorski <ppiskorski@habana.ai>
--
v2: Use unpin_user_pages_dirty_lock (John)
---
 drivers/misc/habanalabs/Kconfig             |  1 -
 drivers/misc/habanalabs/common/habanalabs.h |  3 +-
 drivers/misc/habanalabs/common/memory.c     | 49 ++++++++-------------
 3 files changed, 20 insertions(+), 33 deletions(-)

diff --git a/drivers/misc/habanalabs/Kconfig b/drivers/misc/habanalabs/Kconfig
index 8eb5d38c618e..2f04187f7167 100644
--- a/drivers/misc/habanalabs/Kconfig
+++ b/drivers/misc/habanalabs/Kconfig
@@ -6,7 +6,6 @@
 config HABANA_AI
 	tristate "HabanaAI accelerators (habanalabs)"
 	depends on PCI && HAS_IOMEM
-	select FRAME_VECTOR
 	select DMA_SHARED_BUFFER
 	select GENERIC_ALLOCATOR
 	select HWMON
diff --git a/drivers/misc/habanalabs/common/habanalabs.h b/drivers/misc/habanalabs/common/habanalabs.h
index edbd627b29d2..c1b3ad613b15 100644
--- a/drivers/misc/habanalabs/common/habanalabs.h
+++ b/drivers/misc/habanalabs/common/habanalabs.h
@@ -881,7 +881,8 @@ struct hl_ctx_mgr {
 struct hl_userptr {
 	enum vm_type_t		vm_type; /* must be first */
 	struct list_head	job_node;
-	struct frame_vector	*vec;
+	struct page		**pages;
+	unsigned int		npages;
 	struct sg_table		*sgt;
 	enum dma_data_direction dir;
 	struct list_head	debugfs_list;
diff --git a/drivers/misc/habanalabs/common/memory.c b/drivers/misc/habanalabs/common/memory.c
index 5ff4688683fd..327b64479f97 100644
--- a/drivers/misc/habanalabs/common/memory.c
+++ b/drivers/misc/habanalabs/common/memory.c
@@ -1281,45 +1281,41 @@ static int get_user_memory(struct hl_device *hdev, u64 addr, u64 size,
 		return -EFAULT;
 	}
 
-	userptr->vec = frame_vector_create(npages);
-	if (!userptr->vec) {
+	userptr->pages = kvmalloc_array(npages, sizeof(*userptr->pages),
+					GFP_KERNEL);
+	if (!userptr->pages) {
 		dev_err(hdev->dev, "Failed to create frame vector\n");
 		return -ENOMEM;
 	}
 
-	rc = get_vaddr_frames(start, npages, FOLL_FORCE | FOLL_WRITE,
-				userptr->vec);
+	rc = pin_user_pages_fast(start, npages, FOLL_FORCE | FOLL_WRITE,
+				 userptr->pages);
 
 	if (rc != npages) {
 		dev_err(hdev->dev,
 			"Failed to map host memory, user ptr probably wrong\n");
 		if (rc < 0)
-			goto destroy_framevec;
+			goto destroy_pages;
+		npages = rc;
 		rc = -EFAULT;
-		goto put_framevec;
-	}
-
-	if (frame_vector_to_pages(userptr->vec) < 0) {
-		dev_err(hdev->dev,
-			"Failed to translate frame vector to pages\n");
-		rc = -EFAULT;
-		goto put_framevec;
+		goto put_pages;
 	}
+	userptr->npages = npages;
 
 	rc = sg_alloc_table_from_pages(userptr->sgt,
-					frame_vector_pages(userptr->vec),
-					npages, offset, size, GFP_ATOMIC);
+				       userptr->pages,
+				       npages, offset, size, GFP_ATOMIC);
 	if (rc < 0) {
 		dev_err(hdev->dev, "failed to create SG table from pages\n");
-		goto put_framevec;
+		goto put_pages;
 	}
 
 	return 0;
 
-put_framevec:
-	put_vaddr_frames(userptr->vec);
-destroy_framevec:
-	frame_vector_destroy(userptr->vec);
+put_pages:
+	unpin_user_pages(userptr->pages, npages);
+destroy_pages:
+	kvfree(userptr->pages);
 	return rc;
 }
 
@@ -1405,8 +1401,6 @@ int hl_pin_host_memory(struct hl_device *hdev, u64 addr, u64 size,
  */
 void hl_unpin_host_memory(struct hl_device *hdev, struct hl_userptr *userptr)
 {
-	struct page **pages;
-
 	hl_debugfs_remove_userptr(hdev, userptr);
 
 	if (userptr->dma_mapped)
@@ -1414,15 +1408,8 @@ void hl_unpin_host_memory(struct hl_device *hdev, struct hl_userptr *userptr)
 							userptr->sgt->nents,
 							userptr->dir);
 
-	pages = frame_vector_pages(userptr->vec);
-	if (!IS_ERR(pages)) {
-		int i;
-
-		for (i = 0; i < frame_vector_count(userptr->vec); i++)
-			set_page_dirty_lock(pages[i]);
-	}
-	put_vaddr_frames(userptr->vec);
-	frame_vector_destroy(userptr->vec);
+	unpin_user_pages_dirty_lock(userptr->pages, userptr->npages, true);
+	kvfree(userptr->pages);
 
 	list_del(&userptr->job_node);
 
-- 
2.28.0

