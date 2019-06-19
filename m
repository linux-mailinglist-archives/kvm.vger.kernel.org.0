Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 424784C3B8
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2019 00:33:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730983AbfFSWdm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jun 2019 18:33:42 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:34402 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726251AbfFSWdl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jun 2019 18:33:41 -0400
Received: by mail-io1-f68.google.com with SMTP id k8so187919iot.1;
        Wed, 19 Jun 2019 15:33:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=yajzYDUqG1ebFIffOMsyiuD/cX8ysLbDnEYZsXDC2Oc=;
        b=CkHOyBLfjkZscXBBRUrAj76gIABVTxN4enuI5JTaj3hHhk5IZG5cBtPg0NGdVPEhqt
         9tEJS19ud/merARypx+IJ6GDIL8wlHrLjuHk0bBh5tS7uMslRu6/DjeidMoN6SIS4qvT
         8vOe4IuKzS+F12UkSA+mZrgjMm+iBT0Mc1nM7N6grbBfKJ2EVStny52UrT4zQ3wltImt
         JBs5VO5VcFb9fFWkYP5Gymo/ups1lS+DxpjP6vS2aqE8i4tU4xOUBx4OTC9mD1THSTLK
         jTvRN03YylrVBI9Zya6V5VAcTsJ1N0FQ0Okzi6W0PUhEp3qZd8tJqDpksIRbvkzail2n
         1xtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=yajzYDUqG1ebFIffOMsyiuD/cX8ysLbDnEYZsXDC2Oc=;
        b=RdrsDcoY6I9ZqibkDJVbVAL4CnwRjzA4Z6V14teqVRt8fiwvEW1K/CyaBX/1C6aofa
         5Sba49nHIMABiPmLLpyFly7RWFP/LtR31IvwjQ2AMLaURltou8CO0j6mRW8qOBlhx+fO
         027m/wFoHweUZY7AYkrcEs2Wdc7ZatttBLu7MSM1VsEEOXzc865FikevZRoNgOhFo/lL
         QVCqAlRR+LnAmZjA+zPu7+h8QpzVioAUMEFhcxLrAabG5BTz+wGZvyY10wiGbchPAeo8
         cHIyCyLHU5c7rWwe82V/Itu4xYf+9m/G4E+hrPvaD9lkcDIfXnqBWxOiR7I1YObKv2Ew
         DtEQ==
X-Gm-Message-State: APjAAAXlDctL5gVXaenzd3VvXD8ih8srDxZVu6fD4Df9sxZ/7Lw3rr4X
        hAqVfpuneNkRaI/Nq1EgqRw=
X-Google-Smtp-Source: APXvYqxE9Ekot4Aq4UKpkJxZ/HLof0EmpylZv/EIMvZvgdgOA4zaMDe7/teWqAvV9VkFix7eWOC8SA==
X-Received: by 2002:a6b:b985:: with SMTP id j127mr7261112iof.186.1560983620443;
        Wed, 19 Jun 2019 15:33:40 -0700 (PDT)
Received: from localhost.localdomain (50-126-100-225.drr01.csby.or.frontiernet.net. [50.126.100.225])
        by smtp.gmail.com with ESMTPSA id t133sm37266495iof.21.2019.06.19.15.33.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 19 Jun 2019 15:33:39 -0700 (PDT)
Subject: [PATCH v1 6/6] virtio-balloon: Add support for aerating memory via
 hinting
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     nitesh@redhat.com, kvm@vger.kernel.org, david@redhat.com,
        mst@redhat.com, dave.hansen@intel.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org
Cc:     yang.zhang.wz@gmail.com, pagupta@redhat.com, riel@surriel.com,
        konrad.wilk@oracle.com, lcapitulino@redhat.com,
        wei.w.wang@intel.com, aarcange@redhat.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, alexander.h.duyck@linux.intel.com
Date:   Wed, 19 Jun 2019 15:33:38 -0700
Message-ID: <20190619223338.1231.52537.stgit@localhost.localdomain>
In-Reply-To: <20190619222922.1231.27432.stgit@localhost.localdomain>
References: <20190619222922.1231.27432.stgit@localhost.localdomain>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Alexander Duyck <alexander.h.duyck@linux.intel.com>

Add support for aerating memory using the hinting feature provided by
virtio-balloon. Hinting differs from the regular balloon functionality in
that is is much less durable than a standard memory balloon. Instead of
creating a list of pages that cannot be accessed the pages are only
inaccessible while they are being indicated to the virtio interface. Once
the interface has acknowledged them they are placed back into their
respective free lists and are once again accessible by the guest system.

Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
---
 drivers/virtio/Kconfig              |    1 
 drivers/virtio/virtio_balloon.c     |  110 ++++++++++++++++++++++++++++++++++-
 include/uapi/linux/virtio_balloon.h |    1 
 3 files changed, 108 insertions(+), 4 deletions(-)

diff --git a/drivers/virtio/Kconfig b/drivers/virtio/Kconfig
index 023fc3bc01c6..9cdaccf92c3a 100644
--- a/drivers/virtio/Kconfig
+++ b/drivers/virtio/Kconfig
@@ -47,6 +47,7 @@ config VIRTIO_BALLOON
 	tristate "Virtio balloon driver"
 	depends on VIRTIO
 	select MEMORY_BALLOON
+	select AERATION
 	---help---
 	 This driver supports increasing and decreasing the amount
 	 of memory within a KVM guest.
diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index 44339fc87cc7..91f1e8c9017d 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -18,6 +18,7 @@
 #include <linux/mm.h>
 #include <linux/mount.h>
 #include <linux/magic.h>
+#include <linux/memory_aeration.h>
 
 /*
  * Balloon device works in 4K page units.  So each page is pointed to by
@@ -26,6 +27,7 @@
  */
 #define VIRTIO_BALLOON_PAGES_PER_PAGE (unsigned)(PAGE_SIZE >> VIRTIO_BALLOON_PFN_SHIFT)
 #define VIRTIO_BALLOON_ARRAY_PFNS_MAX 256
+#define VIRTIO_BALLOON_ARRAY_HINTS_MAX	32
 #define VIRTBALLOON_OOM_NOTIFY_PRIORITY 80
 
 #define VIRTIO_BALLOON_FREE_PAGE_ALLOC_FLAG (__GFP_NORETRY | __GFP_NOWARN | \
@@ -45,6 +47,7 @@ enum virtio_balloon_vq {
 	VIRTIO_BALLOON_VQ_DEFLATE,
 	VIRTIO_BALLOON_VQ_STATS,
 	VIRTIO_BALLOON_VQ_FREE_PAGE,
+	VIRTIO_BALLOON_VQ_HINTING,
 	VIRTIO_BALLOON_VQ_MAX
 };
 
@@ -54,7 +57,8 @@ enum virtio_balloon_config_read {
 
 struct virtio_balloon {
 	struct virtio_device *vdev;
-	struct virtqueue *inflate_vq, *deflate_vq, *stats_vq, *free_page_vq;
+	struct virtqueue *inflate_vq, *deflate_vq, *stats_vq, *free_page_vq,
+								*hinting_vq;
 
 	/* Balloon's own wq for cpu-intensive work items */
 	struct workqueue_struct *balloon_wq;
@@ -103,9 +107,21 @@ struct virtio_balloon {
 	/* Synchronize access/update to this struct virtio_balloon elements */
 	struct mutex balloon_lock;
 
-	/* The array of pfns we tell the Host about. */
-	unsigned int num_pfns;
-	__virtio32 pfns[VIRTIO_BALLOON_ARRAY_PFNS_MAX];
+
+	union {
+		/* The array of pfns we tell the Host about. */
+		struct {
+			unsigned int num_pfns;
+			__virtio32 pfns[VIRTIO_BALLOON_ARRAY_PFNS_MAX];
+		};
+		/* The array of physical addresses we are hinting on */
+		struct {
+			unsigned int num_hints;
+			__virtio64 hints[VIRTIO_BALLOON_ARRAY_HINTS_MAX];
+		};
+	};
+
+	struct aerator_dev_info a_dev_info;
 
 	/* Memory statistics */
 	struct virtio_balloon_stat stats[VIRTIO_BALLOON_S_NR];
@@ -151,6 +167,68 @@ static void tell_host(struct virtio_balloon *vb, struct virtqueue *vq)
 
 }
 
+static u64 page_to_hints_pa_order(struct page *page)
+{
+	unsigned char order;
+	dma_addr_t pa;
+
+	BUILD_BUG_ON((64 - VIRTIO_BALLOON_PFN_SHIFT) >=
+		     (1 << VIRTIO_BALLOON_PFN_SHIFT));
+
+	/*
+	 * Record physical page address combined with page order.
+	 * Order will never exceed 64 - VIRTIO_BALLON_PFN_SHIFT
+	 * since the size has to fit into a 64b value. So as long
+	 * as VIRTIO_BALLOON_SHIFT is greater than this combining
+	 * the two values should be safe.
+	 */
+	pa = page_to_phys(page);
+	order = page_private(page) +
+		PAGE_SHIFT - VIRTIO_BALLOON_PFN_SHIFT;
+
+	return (u64)(pa | order);
+}
+
+void virtballoon_aerator_react(struct aerator_dev_info *a_dev_info)
+{
+	struct virtio_balloon *vb = container_of(a_dev_info,
+						struct virtio_balloon,
+						a_dev_info);
+	struct virtqueue *vq = vb->hinting_vq;
+	struct scatterlist sg;
+	unsigned int unused;
+	struct page *page;
+
+	mutex_lock(&vb->balloon_lock);
+
+	vb->num_hints = 0;
+
+	list_for_each_entry(page, &a_dev_info->batch, lru) {
+		vb->hints[vb->num_hints++] =
+				cpu_to_virtio64(vb->vdev,
+						page_to_hints_pa_order(page));
+	}
+
+	/* We shouldn't have been called if there is nothing to process */
+	if (WARN_ON(vb->num_hints == 0))
+		goto out;
+
+	sg_init_one(&sg, vb->hints,
+		    sizeof(vb->hints[0]) * vb->num_hints);
+
+	/*
+	 * We should always be able to add one buffer to an
+	 * empty queue.
+	 */
+	virtqueue_add_outbuf(vq, &sg, 1, vb, GFP_KERNEL);
+	virtqueue_kick(vq);
+
+	/* When host has read buffer, this completes via balloon_ack */
+	wait_event(vb->acked, virtqueue_get_buf(vq, &unused));
+out:
+	mutex_unlock(&vb->balloon_lock);
+}
+
 static void set_page_pfns(struct virtio_balloon *vb,
 			  __virtio32 pfns[], struct page *page)
 {
@@ -475,6 +553,7 @@ static int init_vqs(struct virtio_balloon *vb)
 	names[VIRTIO_BALLOON_VQ_DEFLATE] = "deflate";
 	names[VIRTIO_BALLOON_VQ_STATS] = NULL;
 	names[VIRTIO_BALLOON_VQ_FREE_PAGE] = NULL;
+	names[VIRTIO_BALLOON_VQ_HINTING] = NULL;
 
 	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_STATS_VQ)) {
 		names[VIRTIO_BALLOON_VQ_STATS] = "stats";
@@ -486,11 +565,19 @@ static int init_vqs(struct virtio_balloon *vb)
 		callbacks[VIRTIO_BALLOON_VQ_FREE_PAGE] = NULL;
 	}
 
+	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_HINTING)) {
+		names[VIRTIO_BALLOON_VQ_HINTING] = "hinting_vq";
+		callbacks[VIRTIO_BALLOON_VQ_HINTING] = balloon_ack;
+	}
+
 	err = vb->vdev->config->find_vqs(vb->vdev, VIRTIO_BALLOON_VQ_MAX,
 					 vqs, callbacks, names, NULL, NULL);
 	if (err)
 		return err;
 
+	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_HINTING))
+		vb->hinting_vq = vqs[VIRTIO_BALLOON_VQ_HINTING];
+
 	vb->inflate_vq = vqs[VIRTIO_BALLOON_VQ_INFLATE];
 	vb->deflate_vq = vqs[VIRTIO_BALLOON_VQ_DEFLATE];
 	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_STATS_VQ)) {
@@ -929,12 +1016,24 @@ static int virtballoon_probe(struct virtio_device *vdev)
 		if (err)
 			goto out_del_balloon_wq;
 	}
+
+	vb->a_dev_info.react = virtballoon_aerator_react;
+	vb->a_dev_info.capacity = VIRTIO_BALLOON_ARRAY_HINTS_MAX;
+	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_HINTING)) {
+		err = aerator_startup(&vb->a_dev_info);
+		if (err)
+			goto out_unregister_shrinker;
+	}
+
 	virtio_device_ready(vdev);
 
 	if (towards_target(vb))
 		virtballoon_changed(vdev);
 	return 0;
 
+out_unregister_shrinker:
+	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_DEFLATE_ON_OOM))
+		virtio_balloon_unregister_shrinker(vb);
 out_del_balloon_wq:
 	if (virtio_has_feature(vdev, VIRTIO_BALLOON_F_FREE_PAGE_HINT))
 		destroy_workqueue(vb->balloon_wq);
@@ -963,6 +1062,8 @@ static void virtballoon_remove(struct virtio_device *vdev)
 {
 	struct virtio_balloon *vb = vdev->priv;
 
+	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_HINTING))
+		aerator_shutdown();
 	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_DEFLATE_ON_OOM))
 		virtio_balloon_unregister_shrinker(vb);
 	spin_lock_irq(&vb->stop_update_lock);
@@ -1032,6 +1133,7 @@ static int virtballoon_validate(struct virtio_device *vdev)
 	VIRTIO_BALLOON_F_DEFLATE_ON_OOM,
 	VIRTIO_BALLOON_F_FREE_PAGE_HINT,
 	VIRTIO_BALLOON_F_PAGE_POISON,
+	VIRTIO_BALLOON_F_HINTING,
 };
 
 static struct virtio_driver virtio_balloon_driver = {
diff --git a/include/uapi/linux/virtio_balloon.h b/include/uapi/linux/virtio_balloon.h
index a1966cd7b677..2b0f62814e22 100644
--- a/include/uapi/linux/virtio_balloon.h
+++ b/include/uapi/linux/virtio_balloon.h
@@ -36,6 +36,7 @@
 #define VIRTIO_BALLOON_F_DEFLATE_ON_OOM	2 /* Deflate balloon on OOM */
 #define VIRTIO_BALLOON_F_FREE_PAGE_HINT	3 /* VQ to report free pages */
 #define VIRTIO_BALLOON_F_PAGE_POISON	4 /* Guest is using page poisoning */
+#define VIRTIO_BALLOON_F_HINTING	5 /* Page hinting virtqueue */
 
 /* Size of a PFN in the balloon interface. */
 #define VIRTIO_BALLOON_PFN_SHIFT 12

