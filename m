Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92D5A64D01
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2019 21:52:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728217AbfGJTwd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jul 2019 15:52:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45260 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728138AbfGJTw3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Jul 2019 15:52:29 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1FA2C307D850;
        Wed, 10 Jul 2019 19:52:29 +0000 (UTC)
Received: from virtlab512.virt.lab.eng.bos.redhat.com (virtlab512.virt.lab.eng.bos.redhat.com [10.19.152.206])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 54F7119C69;
        Wed, 10 Jul 2019 19:52:27 +0000 (UTC)
From:   Nitesh Narayan Lal <nitesh@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, pbonzini@redhat.com, lcapitulino@redhat.com,
        pagupta@redhat.com, wei.w.wang@intel.com, yang.zhang.wz@gmail.com,
        riel@surriel.com, david@redhat.com, mst@redhat.com,
        dodgen@google.com, konrad.wilk@oracle.com, dhildenb@redhat.com,
        aarcange@redhat.com, alexander.duyck@gmail.com,
        john.starks@microsoft.com, dave.hansen@intel.com, mhocko@suse.com
Subject: [RFC][Patch v11 2/2] virtio-balloon: page_hinting: reporting to the host
Date:   Wed, 10 Jul 2019 15:51:58 -0400
Message-Id: <20190710195158.19640-3-nitesh@redhat.com>
In-Reply-To: <20190710195158.19640-1-nitesh@redhat.com>
References: <20190710195158.19640-1-nitesh@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Wed, 10 Jul 2019 19:52:29 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Enables the kernel to negotiate VIRTIO_BALLOON_F_HINTING feature with the
host. If it is available and page_hinting_flag is set to true, page_hinting
is enabled and its callbacks are configured along with the max_pages count
which indicates the maximum number of pages that can be isolated and hinted
at a time. Currently, only free pages of order >= (MAX_ORDER - 2) are
reported. To prevent any false OOM max_pages count is set to 16.

By default page_hinting feature is enabled and gets loaded as soon
as the virtio-balloon driver is loaded. However, it could be disabled
by writing the page_hinting_flag which is a virtio-balloon parameter.

Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
---
 drivers/virtio/Kconfig              |  1 +
 drivers/virtio/virtio_balloon.c     | 91 ++++++++++++++++++++++++++++-
 include/uapi/linux/virtio_balloon.h | 11 ++++
 3 files changed, 102 insertions(+), 1 deletion(-)

diff --git a/drivers/virtio/Kconfig b/drivers/virtio/Kconfig
index 023fc3bc01c6..dcc0cb4269a5 100644
--- a/drivers/virtio/Kconfig
+++ b/drivers/virtio/Kconfig
@@ -47,6 +47,7 @@ config VIRTIO_BALLOON
 	tristate "Virtio balloon driver"
 	depends on VIRTIO
 	select MEMORY_BALLOON
+	select PAGE_HINTING
 	---help---
 	 This driver supports increasing and decreasing the amount
 	 of memory within a KVM guest.
diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index 44339fc87cc7..1fb0eb0b2c20 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -18,6 +18,7 @@
 #include <linux/mm.h>
 #include <linux/mount.h>
 #include <linux/magic.h>
+#include <linux/page_hinting.h>
 
 /*
  * Balloon device works in 4K page units.  So each page is pointed to by
@@ -35,6 +36,12 @@
 /* The size of a free page block in bytes */
 #define VIRTIO_BALLOON_FREE_PAGE_SIZE \
 	(1 << (VIRTIO_BALLOON_FREE_PAGE_ORDER + PAGE_SHIFT))
+/* Number of isolated pages to be reported to the host at a time.
+ * TODO:
+ * 1. Set it via host.
+ * 2. Find an optimal value for this.
+ */
+#define PAGE_HINTING_MAX_PAGES	16
 
 #ifdef CONFIG_BALLOON_COMPACTION
 static struct vfsmount *balloon_mnt;
@@ -45,6 +52,7 @@ enum virtio_balloon_vq {
 	VIRTIO_BALLOON_VQ_DEFLATE,
 	VIRTIO_BALLOON_VQ_STATS,
 	VIRTIO_BALLOON_VQ_FREE_PAGE,
+	VIRTIO_BALLOON_VQ_HINTING,
 	VIRTIO_BALLOON_VQ_MAX
 };
 
@@ -54,7 +62,8 @@ enum virtio_balloon_config_read {
 
 struct virtio_balloon {
 	struct virtio_device *vdev;
-	struct virtqueue *inflate_vq, *deflate_vq, *stats_vq, *free_page_vq;
+	struct virtqueue *inflate_vq, *deflate_vq, *stats_vq, *free_page_vq,
+			 *hinting_vq;
 
 	/* Balloon's own wq for cpu-intensive work items */
 	struct workqueue_struct *balloon_wq;
@@ -112,6 +121,9 @@ struct virtio_balloon {
 
 	/* To register a shrinker to shrink memory upon memory pressure */
 	struct shrinker shrinker;
+
+	/* Array object pointing at the isolated pages ready for hinting */
+	struct isolated_memory isolated_pages[PAGE_HINTING_MAX_PAGES];
 };
 
 static struct virtio_device_id id_table[] = {
@@ -119,6 +131,66 @@ static struct virtio_device_id id_table[] = {
 	{ 0 },
 };
 
+static struct page_hinting_config page_hinting_conf;
+bool page_hinting_flag = true;
+struct virtio_balloon *hvb;
+module_param(page_hinting_flag, bool, 0444);
+MODULE_PARM_DESC(page_hinting_flag, "Enable page hinting");
+
+static int page_hinting_report(void)
+{
+	struct virtqueue *vq = hvb->hinting_vq;
+	struct scatterlist sg;
+	int err = 0, unused;
+
+	mutex_lock(&hvb->balloon_lock);
+	sg_init_one(&sg, hvb->isolated_pages, sizeof(hvb->isolated_pages[0]) *
+		    PAGE_HINTING_MAX_PAGES);
+	err = virtqueue_add_outbuf(vq, &sg, 1, hvb, GFP_KERNEL);
+	if (!err)
+		virtqueue_kick(hvb->hinting_vq);
+	wait_event(hvb->acked, virtqueue_get_buf(vq, &unused));
+	mutex_unlock(&hvb->balloon_lock);
+	return err;
+}
+
+void hint_pages(struct list_head *pages)
+{
+	struct device *dev = &hvb->vdev->dev;
+	struct page *page, *next;
+	int idx = 0, order, err;
+	unsigned long pfn;
+
+	list_for_each_entry_safe(page, next, pages, lru) {
+		pfn = page_to_pfn(page);
+		order = page_private(page);
+		hvb->isolated_pages[idx].phys_addr = pfn << PAGE_SHIFT;
+		hvb->isolated_pages[idx].size = (1 << order) * PAGE_SIZE;
+		idx++;
+	}
+	err = page_hinting_report();
+	if (err < 0)
+		dev_err(dev, "Failed to hint pages, err = %d\n", err);
+}
+
+static void page_hinting_init(struct virtio_balloon *vb)
+{
+	struct device *dev = &vb->vdev->dev;
+	int err;
+
+	page_hinting_conf.hint_pages = hint_pages;
+	page_hinting_conf.max_pages = PAGE_HINTING_MAX_PAGES;
+	err = page_hinting_enable(&page_hinting_conf);
+	if (err < 0) {
+		dev_err(dev, "Failed to enable page-hinting, err = %d\n", err);
+		page_hinting_flag = false;
+		page_hinting_conf.hint_pages = NULL;
+		page_hinting_conf.max_pages = 0;
+		return;
+	}
+	hvb = vb;
+}
+
 static u32 page_to_balloon_pfn(struct page *page)
 {
 	unsigned long pfn = page_to_pfn(page);
@@ -475,6 +547,7 @@ static int init_vqs(struct virtio_balloon *vb)
 	names[VIRTIO_BALLOON_VQ_DEFLATE] = "deflate";
 	names[VIRTIO_BALLOON_VQ_STATS] = NULL;
 	names[VIRTIO_BALLOON_VQ_FREE_PAGE] = NULL;
+	names[VIRTIO_BALLOON_VQ_HINTING] = NULL;
 
 	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_STATS_VQ)) {
 		names[VIRTIO_BALLOON_VQ_STATS] = "stats";
@@ -486,11 +559,18 @@ static int init_vqs(struct virtio_balloon *vb)
 		callbacks[VIRTIO_BALLOON_VQ_FREE_PAGE] = NULL;
 	}
 
+	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_HINTING)) {
+		names[VIRTIO_BALLOON_VQ_HINTING] = "hinting_vq";
+		callbacks[VIRTIO_BALLOON_VQ_HINTING] = balloon_ack;
+	}
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
@@ -929,6 +1009,9 @@ static int virtballoon_probe(struct virtio_device *vdev)
 		if (err)
 			goto out_del_balloon_wq;
 	}
+	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_HINTING) &&
+	    page_hinting_flag)
+		page_hinting_init(vb);
 	virtio_device_ready(vdev);
 
 	if (towards_target(vb))
@@ -976,6 +1059,10 @@ static void virtballoon_remove(struct virtio_device *vdev)
 		destroy_workqueue(vb->balloon_wq);
 	}
 
+	if (!page_hinting_flag) {
+		hvb = NULL;
+		page_hinting_disable();
+	}
 	remove_common(vb);
 #ifdef CONFIG_BALLOON_COMPACTION
 	if (vb->vb_dev_info.inode)
@@ -1030,8 +1117,10 @@ static unsigned int features[] = {
 	VIRTIO_BALLOON_F_MUST_TELL_HOST,
 	VIRTIO_BALLOON_F_STATS_VQ,
 	VIRTIO_BALLOON_F_DEFLATE_ON_OOM,
+	VIRTIO_BALLOON_F_HINTING,
 	VIRTIO_BALLOON_F_FREE_PAGE_HINT,
 	VIRTIO_BALLOON_F_PAGE_POISON,
+	VIRTIO_BALLOON_F_HINTING,
 };
 
 static struct virtio_driver virtio_balloon_driver = {
diff --git a/include/uapi/linux/virtio_balloon.h b/include/uapi/linux/virtio_balloon.h
index a1966cd7b677..29eed0ec83d3 100644
--- a/include/uapi/linux/virtio_balloon.h
+++ b/include/uapi/linux/virtio_balloon.h
@@ -36,6 +36,8 @@
 #define VIRTIO_BALLOON_F_DEFLATE_ON_OOM	2 /* Deflate balloon on OOM */
 #define VIRTIO_BALLOON_F_FREE_PAGE_HINT	3 /* VQ to report free pages */
 #define VIRTIO_BALLOON_F_PAGE_POISON	4 /* Guest is using page poisoning */
+/* TODO: Find a better name to avoid any confusion with FREE_PAGE_HINT */
+#define VIRTIO_BALLOON_F_HINTING	5 /* Page hinting virtqueue */
 
 /* Size of a PFN in the balloon interface. */
 #define VIRTIO_BALLOON_PFN_SHIFT 12
@@ -108,4 +110,13 @@ struct virtio_balloon_stat {
 	__virtio64 val;
 } __attribute__((packed));
 
+/*
+ * struct isolated_memory- holds the pages which will be reported to the host.
+ * @phys_add:	physical address associated with a page.
+ * @size:	total size of memory to be reported.
+ */
+struct isolated_memory {
+	__virtio64 phys_addr;
+	__virtio64 size;
+};
 #endif /* _LINUX_VIRTIO_BALLOON_H */
-- 
2.21.0

