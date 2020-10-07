Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E9222864D0
	for <lists+kvm@lfdr.de>; Wed,  7 Oct 2020 18:44:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728046AbgJGQol (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Oct 2020 12:44:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728022AbgJGQoj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Oct 2020 12:44:39 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EDCEC0613E1
        for <kvm@vger.kernel.org>; Wed,  7 Oct 2020 09:44:38 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id p15so3041724wmi.4
        for <kvm@vger.kernel.org>; Wed, 07 Oct 2020 09:44:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fbQ4UHoMI3gmmgUudGaz4yL7TM4S3Iddi1GT7Ee/+0U=;
        b=GwLaASBB1efTh6MPYPZRJ8sRahCLRvTt+3ohcP4zw6YZTX22OiwAXRVD6PAfYgfgqP
         MCyytYGELOTCoMpkehTDRE8nAbzQtjgDaBnw+1Ojb8/wCoU+VYASX13tI1VU/7VWuEaC
         0AeT2tPwf+0OAmbFt5CWbHSjCY7HVIdMBTY9A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fbQ4UHoMI3gmmgUudGaz4yL7TM4S3Iddi1GT7Ee/+0U=;
        b=rZ/8fS1j9NFucZNiQAveDZPcCqZEwozpZjWlftKMW1Q0YHjz87/gDV1MwkI6IXPGes
         WoEaiN1Kbj2PcJ2UhU8xgUyebMvLhbNIx1zmVHAUGPYxgf8jx6inOqeDw5ecdYlRt704
         f1T2z3w99pofbBmNE+PMo7GCgQBdptdNeF1PZudqO8H46PZYFQfwE0nyQlw+sT6689cB
         3Lk4oN6k+c3qV3AkSx1eEK9+fGHC1HZg8DyMQJS7f6WEvBnyZkxvMSHnQtsK52whQB7N
         RUUc1DD6IlVZEHf2uPHSHgPY8y0q2YIWXblNxPXztSg0J4iBMoVTU7aDJdqrY6eaNlWn
         Go7A==
X-Gm-Message-State: AOAM530NAOOPnKMl0idaRknYiZNpWKwqN93kneiZGiwdaKEZSIIUakGB
        i6GxtYDVHOBlDEbc5ZkCHPj1oA==
X-Google-Smtp-Source: ABdhPJwEu4LC2Cz1K2rgxVwQrYuYinT+uwWru1r5SWZOb1CzlJ/0rEY8IUuIAasACAWLOr06TRZTNA==
X-Received: by 2002:a1c:1983:: with SMTP id 125mr4134376wmz.29.1602089077113;
        Wed, 07 Oct 2020 09:44:37 -0700 (PDT)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id z191sm3332280wme.40.2020.10.07.09.44.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2020 09:44:36 -0700 (PDT)
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
Subject: [PATCH 03/13] misc/habana: Stop using frame_vector helpers
Date:   Wed,  7 Oct 2020 18:44:16 +0200
Message-Id: <20201007164426.1812530-4-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201007164426.1812530-1-daniel.vetter@ffwll.ch>
References: <20201007164426.1812530-1-daniel.vetter@ffwll.ch>
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
---
 drivers/misc/habanalabs/Kconfig             |  1 -
 drivers/misc/habanalabs/common/habanalabs.h |  3 +-
 drivers/misc/habanalabs/common/memory.c     | 51 +++++++++------------
 3 files changed, 23 insertions(+), 32 deletions(-)

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
index 5ff4688683fd..ef89cfa2f95a 100644
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
 
@@ -1405,7 +1401,7 @@ int hl_pin_host_memory(struct hl_device *hdev, u64 addr, u64 size,
  */
 void hl_unpin_host_memory(struct hl_device *hdev, struct hl_userptr *userptr)
 {
-	struct page **pages;
+	int i;
 
 	hl_debugfs_remove_userptr(hdev, userptr);
 
@@ -1414,15 +1410,10 @@ void hl_unpin_host_memory(struct hl_device *hdev, struct hl_userptr *userptr)
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
+	for (i = 0; i < userptr->npages; i++)
+		set_page_dirty_lock(userptr->pages[i]);
+	unpin_user_pages(userptr->pages, userptr->npages);
+	kvfree(userptr->pages);
 
 	list_del(&userptr->job_node);
 
-- 
2.28.0

