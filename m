Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91DB92864ED
	for <lists+kvm@lfdr.de>; Wed,  7 Oct 2020 18:46:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728658AbgJGQpE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Oct 2020 12:45:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728222AbgJGQon (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Oct 2020 12:44:43 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33C93C0613D3
        for <kvm@vger.kernel.org>; Wed,  7 Oct 2020 09:44:43 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id j136so3139172wmj.2
        for <kvm@vger.kernel.org>; Wed, 07 Oct 2020 09:44:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ijyQHvjtAZuVgL9EA0yhX2lOO0Plieezx6jpuHoNbWM=;
        b=LwVSypRUHyZ0T87PhhZ+4ADU5nIhUvXazxLJTlWaavCk3/BH7CCIyWxKz8EdLbYRFB
         RxOJt4YGDrY5Z18DWWeYewrbgmnTQhbvcg7G1wzOSmJSW22Rnu7elA3IHcpsmrAC5fm4
         607Hl7Db7B4Nz9Bbo3tUQsyeynMvBXjImw/ME=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ijyQHvjtAZuVgL9EA0yhX2lOO0Plieezx6jpuHoNbWM=;
        b=C2cJETU1BBVK9KDxqUKyhiAO4ZbSGrM456S5jdXHLFcA6GFn61+vGIVWddFDgSOVvN
         aTCmvPCjD3qwOHd8c1LBlnEVAx9vJPF0U0+vclm87SVP+278tcLUtMdomurq3NsPKJzW
         v54Mu6XaoZVgz4pKu9PBLDNNQG3yDhvn58Jy+ozQxmeZCu+TxMKvZP4G8/6Lo7OVBDl6
         lRfQ42YaXNF9HIbUdT/PHAxWSoHLYqMnuDN7M1WNnz1mYyrICkkbZNeNOQKGSrlJfASJ
         11WVhtg45QWkQvydDm2Kf3cvlWnkhX3Qn2kJOL9UxV6WYJwHXImXJxj8MLAauvGXM3kk
         bUvg==
X-Gm-Message-State: AOAM533OXJcvJuPwzZZYEEMw9hBmcSnwF5YNNNxQxptTuSFKhK3i8U1x
        0UBpMobihQLyiN127hCRuBU3eg==
X-Google-Smtp-Source: ABdhPJyUC9AoVMqunH06ot8WNvMdaDUQIFaIEaHUrOCUzlvQcH2+ffkYARv3NTyh7jH2Zwg9GWymBA==
X-Received: by 2002:a1c:cc1a:: with SMTP id h26mr4130331wmb.131.1602089081802;
        Wed, 07 Oct 2020 09:44:41 -0700 (PDT)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id z191sm3332280wme.40.2020.10.07.09.44.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2020 09:44:41 -0700 (PDT)
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
Subject: [PATCH 06/13] media: videobuf2: Move frame_vector into media subsystem
Date:   Wed,  7 Oct 2020 18:44:19 +0200
Message-Id: <20201007164426.1812530-7-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201007164426.1812530-1-daniel.vetter@ffwll.ch>
References: <20201007164426.1812530-1-daniel.vetter@ffwll.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It's the only user. This also garbage collects the CONFIG_FRAME_VECTOR
symbol from all over the tree (well just one place, somehow omap media
driver still had this in its Kconfig, despite not using it).

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
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
---
 drivers/media/common/videobuf2/Kconfig        |  1 -
 drivers/media/common/videobuf2/Makefile       |  1 +
 .../media/common/videobuf2}/frame_vector.c    |  2 +
 drivers/media/platform/omap/Kconfig           |  1 -
 include/linux/mm.h                            | 42 -------------------
 include/media/videobuf2-core.h                | 42 +++++++++++++++++++
 mm/Kconfig                                    |  3 --
 mm/Makefile                                   |  1 -
 8 files changed, 45 insertions(+), 48 deletions(-)
 rename {mm => drivers/media/common/videobuf2}/frame_vector.c (99%)

diff --git a/drivers/media/common/videobuf2/Kconfig b/drivers/media/common/videobuf2/Kconfig
index edbc99ebba87..d2223a12c95f 100644
--- a/drivers/media/common/videobuf2/Kconfig
+++ b/drivers/media/common/videobuf2/Kconfig
@@ -9,7 +9,6 @@ config VIDEOBUF2_V4L2
 
 config VIDEOBUF2_MEMOPS
 	tristate
-	select FRAME_VECTOR
 
 config VIDEOBUF2_DMA_CONTIG
 	tristate
diff --git a/drivers/media/common/videobuf2/Makefile b/drivers/media/common/videobuf2/Makefile
index 77bebe8b202f..54306f8d096c 100644
--- a/drivers/media/common/videobuf2/Makefile
+++ b/drivers/media/common/videobuf2/Makefile
@@ -1,5 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 videobuf2-common-objs := videobuf2-core.o
+videobuf2-common-objs += frame_vector.o
 
 ifeq ($(CONFIG_TRACEPOINTS),y)
   videobuf2-common-objs += vb2-trace.o
diff --git a/mm/frame_vector.c b/drivers/media/common/videobuf2/frame_vector.c
similarity index 99%
rename from mm/frame_vector.c
rename to drivers/media/common/videobuf2/frame_vector.c
index 39db520a51dc..b95f4f371681 100644
--- a/mm/frame_vector.c
+++ b/drivers/media/common/videobuf2/frame_vector.c
@@ -8,6 +8,8 @@
 #include <linux/pagemap.h>
 #include <linux/sched.h>
 
+#include <media/videobuf2-core.h>
+
 /**
  * get_vaddr_frames() - map virtual addresses to pfns
  * @start:	starting user address
diff --git a/drivers/media/platform/omap/Kconfig b/drivers/media/platform/omap/Kconfig
index f73b5893220d..de16de46c0f4 100644
--- a/drivers/media/platform/omap/Kconfig
+++ b/drivers/media/platform/omap/Kconfig
@@ -12,6 +12,5 @@ config VIDEO_OMAP2_VOUT
 	depends on VIDEO_V4L2
 	select VIDEOBUF2_DMA_CONTIG
 	select OMAP2_VRFB if ARCH_OMAP2 || ARCH_OMAP3
-	select FRAME_VECTOR
 	help
 	  V4L2 Display driver support for OMAP2/3 based boards.
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 16b799a0522c..acd60fbf1a5a 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1743,48 +1743,6 @@ int account_locked_vm(struct mm_struct *mm, unsigned long pages, bool inc);
 int __account_locked_vm(struct mm_struct *mm, unsigned long pages, bool inc,
 			struct task_struct *task, bool bypass_rlim);
 
-/* Container for pinned pfns / pages */
-struct frame_vector {
-	unsigned int nr_allocated;	/* Number of frames we have space for */
-	unsigned int nr_frames;	/* Number of frames stored in ptrs array */
-	bool got_ref;		/* Did we pin pages by getting page ref? */
-	bool is_pfns;		/* Does array contain pages or pfns? */
-	void *ptrs[];		/* Array of pinned pfns / pages. Use
-				 * pfns_vector_pages() or pfns_vector_pfns()
-				 * for access */
-};
-
-struct frame_vector *frame_vector_create(unsigned int nr_frames);
-void frame_vector_destroy(struct frame_vector *vec);
-int get_vaddr_frames(unsigned long start, unsigned int nr_pfns,
-		     unsigned int gup_flags, struct frame_vector *vec);
-void put_vaddr_frames(struct frame_vector *vec);
-int frame_vector_to_pages(struct frame_vector *vec);
-void frame_vector_to_pfns(struct frame_vector *vec);
-
-static inline unsigned int frame_vector_count(struct frame_vector *vec)
-{
-	return vec->nr_frames;
-}
-
-static inline struct page **frame_vector_pages(struct frame_vector *vec)
-{
-	if (vec->is_pfns) {
-		int err = frame_vector_to_pages(vec);
-
-		if (err)
-			return ERR_PTR(err);
-	}
-	return (struct page **)(vec->ptrs);
-}
-
-static inline unsigned long *frame_vector_pfns(struct frame_vector *vec)
-{
-	if (!vec->is_pfns)
-		frame_vector_to_pfns(vec);
-	return (unsigned long *)(vec->ptrs);
-}
-
 struct kvec;
 int get_kernel_pages(const struct kvec *iov, int nr_pages, int write,
 			struct page **pages);
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index bbb3f26fbde9..a2e75ca0334f 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -1254,4 +1254,46 @@ bool vb2_request_object_is_buffer(struct media_request_object *obj);
  */
 unsigned int vb2_request_buffer_cnt(struct media_request *req);
 
+/* Container for pinned pfns / pages in frame_vector.c */
+struct frame_vector {
+	unsigned int nr_allocated;	/* Number of frames we have space for */
+	unsigned int nr_frames;	/* Number of frames stored in ptrs array */
+	bool got_ref;		/* Did we pin pages by getting page ref? */
+	bool is_pfns;		/* Does array contain pages or pfns? */
+	void *ptrs[];		/* Array of pinned pfns / pages. Use
+				 * pfns_vector_pages() or pfns_vector_pfns()
+				 * for access */
+};
+
+struct frame_vector *frame_vector_create(unsigned int nr_frames);
+void frame_vector_destroy(struct frame_vector *vec);
+int get_vaddr_frames(unsigned long start, unsigned int nr_pfns,
+		     unsigned int gup_flags, struct frame_vector *vec);
+void put_vaddr_frames(struct frame_vector *vec);
+int frame_vector_to_pages(struct frame_vector *vec);
+void frame_vector_to_pfns(struct frame_vector *vec);
+
+static inline unsigned int frame_vector_count(struct frame_vector *vec)
+{
+	return vec->nr_frames;
+}
+
+static inline struct page **frame_vector_pages(struct frame_vector *vec)
+{
+	if (vec->is_pfns) {
+		int err = frame_vector_to_pages(vec);
+
+		if (err)
+			return ERR_PTR(err);
+	}
+	return (struct page **)(vec->ptrs);
+}
+
+static inline unsigned long *frame_vector_pfns(struct frame_vector *vec)
+{
+	if (!vec->is_pfns)
+		frame_vector_to_pfns(vec);
+	return (unsigned long *)(vec->ptrs);
+}
+
 #endif /* _MEDIA_VIDEOBUF2_CORE_H */
diff --git a/mm/Kconfig b/mm/Kconfig
index 6c974888f86f..da6c943fe9f1 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -815,9 +815,6 @@ config DEVICE_PRIVATE
 	  memory; i.e., memory that is only accessible from the device (or
 	  group of devices). You likely also want to select HMM_MIRROR.
 
-config FRAME_VECTOR
-	bool
-
 config ARCH_USES_HIGH_VMA_FLAGS
 	bool
 config ARCH_HAS_PKEYS
diff --git a/mm/Makefile b/mm/Makefile
index d5649f1c12c0..a025fd6c6afd 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -111,7 +111,6 @@ obj-$(CONFIG_PAGE_EXTENSION) += page_ext.o
 obj-$(CONFIG_CMA_DEBUGFS) += cma_debug.o
 obj-$(CONFIG_USERFAULTFD) += userfaultfd.o
 obj-$(CONFIG_IDLE_PAGE_TRACKING) += page_idle.o
-obj-$(CONFIG_FRAME_VECTOR) += frame_vector.o
 obj-$(CONFIG_DEBUG_PAGE_REF) += debug_page_ref.o
 obj-$(CONFIG_HARDENED_USERCOPY) += usercopy.o
 obj-$(CONFIG_PERCPU_STATS) += percpu-stats.o
-- 
2.28.0

