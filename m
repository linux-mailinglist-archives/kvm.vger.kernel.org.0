Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 568ED335F7
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2019 19:05:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726410AbfFCRER (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jun 2019 13:04:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53910 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726527AbfFCREP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Jun 2019 13:04:15 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E3EA481E0C;
        Mon,  3 Jun 2019 17:04:14 +0000 (UTC)
Received: from virtlab512.virt.lab.eng.bos.redhat.com (virtlab512.virt.lab.eng.bos.redhat.com [10.19.152.206])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4410761983;
        Mon,  3 Jun 2019 17:04:07 +0000 (UTC)
From:   Nitesh Narayan Lal <nitesh@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, pbonzini@redhat.com, lcapitulino@redhat.com,
        pagupta@redhat.com, wei.w.wang@intel.com, yang.zhang.wz@gmail.com,
        riel@surriel.com, david@redhat.com, mst@redhat.com,
        dodgen@google.com, konrad.wilk@oracle.com, dhildenb@redhat.com,
        aarcange@redhat.com, alexander.duyck@gmail.com
Subject: [RFC][Patch v10 2/2] virtio-balloon: page_hinting: reporting to the host
Date:   Mon,  3 Jun 2019 13:03:06 -0400
Message-Id: <20190603170306.49099-3-nitesh@redhat.com>
In-Reply-To: <20190603170306.49099-1-nitesh@redhat.com>
References: <20190603170306.49099-1-nitesh@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Mon, 03 Jun 2019 17:04:15 +0000 (UTC)
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
 drivers/virtio/virtio_balloon.c     | 112 +++++++++++++++++++++++++++-
 include/uapi/linux/virtio_balloon.h |  14 ++++
 2 files changed, 125 insertions(+), 1 deletion(-)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index f19061b585a4..40f09ea31643 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -31,6 +31,7 @@
 #include <linux/mm.h>
 #include <linux/mount.h>
 #include <linux/magic.h>
+#include <linux/page_hinting.h>
 
 /*
  * Balloon device works in 4K page units.  So each page is pointed to by
@@ -48,6 +49,7 @@
 /* The size of a free page block in bytes */
 #define VIRTIO_BALLOON_FREE_PAGE_SIZE \
 	(1 << (VIRTIO_BALLOON_FREE_PAGE_ORDER + PAGE_SHIFT))
+#define VIRTIO_BALLOON_PAGE_HINTING_MAX_PAGES	16
 
 #ifdef CONFIG_BALLOON_COMPACTION
 static struct vfsmount *balloon_mnt;
@@ -58,6 +60,7 @@ enum virtio_balloon_vq {
 	VIRTIO_BALLOON_VQ_DEFLATE,
 	VIRTIO_BALLOON_VQ_STATS,
 	VIRTIO_BALLOON_VQ_FREE_PAGE,
+	VIRTIO_BALLOON_VQ_HINTING,
 	VIRTIO_BALLOON_VQ_MAX
 };
 
@@ -67,7 +70,8 @@ enum virtio_balloon_config_read {
 
 struct virtio_balloon {
 	struct virtio_device *vdev;
-	struct virtqueue *inflate_vq, *deflate_vq, *stats_vq, *free_page_vq;
+	struct virtqueue *inflate_vq, *deflate_vq, *stats_vq, *free_page_vq,
+			 *hinting_vq;
 
 	/* Balloon's own wq for cpu-intensive work items */
 	struct workqueue_struct *balloon_wq;
@@ -125,6 +129,9 @@ struct virtio_balloon {
 
 	/* To register a shrinker to shrink memory upon memory pressure */
 	struct shrinker shrinker;
+
+	/* object pointing at the array of isolated pages ready for hinting */
+	struct hinting_data *hinting_arr;
 };
 
 static struct virtio_device_id id_table[] = {
@@ -132,6 +139,85 @@ static struct virtio_device_id id_table[] = {
 	{ 0 },
 };
 
+#ifdef CONFIG_PAGE_HINTING
+struct virtio_balloon *hvb;
+bool page_hinting_flag = true;
+module_param(page_hinting_flag, bool, 0444);
+MODULE_PARM_DESC(page_hinting_flag, "Enable page hinting");
+
+static bool virtqueue_kick_sync(struct virtqueue *vq)
+{
+	u32 len;
+
+	if (likely(virtqueue_kick(vq))) {
+		while (!virtqueue_get_buf(vq, &len) &&
+		       !virtqueue_is_broken(vq))
+			cpu_relax();
+		return true;
+	}
+	return false;
+}
+
+static void page_hinting_report(int entries)
+{
+	struct scatterlist sg;
+	struct virtqueue *vq = hvb->hinting_vq;
+	int err = 0;
+	struct hinting_data *hint_req;
+	u64 gpaddr;
+
+	hint_req = kmalloc(sizeof(*hint_req), GFP_KERNEL);
+	if (!hint_req)
+		return;
+	gpaddr = virt_to_phys(hvb->hinting_arr);
+	hint_req->phys_addr = cpu_to_virtio64(hvb->vdev, gpaddr);
+	hint_req->size = cpu_to_virtio32(hvb->vdev, entries);
+	sg_init_one(&sg, hint_req, sizeof(*hint_req));
+	err = virtqueue_add_outbuf(vq, &sg, 1, hint_req, GFP_KERNEL);
+	if (!err)
+		virtqueue_kick_sync(hvb->hinting_vq);
+
+	kfree(hint_req);
+}
+
+int page_hinting_prepare(void)
+{
+	hvb->hinting_arr = kmalloc_array(VIRTIO_BALLOON_PAGE_HINTING_MAX_PAGES,
+					 sizeof(*hvb->hinting_arr), GFP_KERNEL);
+	if (!hvb->hinting_arr)
+		return -ENOMEM;
+	return 0;
+}
+
+void hint_pages(struct list_head *pages)
+{
+	struct page *page, *next;
+	unsigned long pfn;
+	int idx = 0, order;
+
+	list_for_each_entry_safe(page, next, pages, lru) {
+		pfn = page_to_pfn(page);
+		order = page_private(page);
+		hvb->hinting_arr[idx].phys_addr = pfn << PAGE_SHIFT;
+		hvb->hinting_arr[idx].size = (1 << order) * PAGE_SIZE;
+		idx++;
+	}
+	page_hinting_report(idx);
+}
+
+void page_hinting_cleanup(void)
+{
+	kfree(hvb->hinting_arr);
+}
+
+static const struct page_hinting_cb hcb = {
+	.prepare = page_hinting_prepare,
+	.hint_pages = hint_pages,
+	.cleanup = page_hinting_cleanup,
+	.max_pages = VIRTIO_BALLOON_PAGE_HINTING_MAX_PAGES,
+};
+#endif
+
 static u32 page_to_balloon_pfn(struct page *page)
 {
 	unsigned long pfn = page_to_pfn(page);
@@ -488,6 +574,7 @@ static int init_vqs(struct virtio_balloon *vb)
 	names[VIRTIO_BALLOON_VQ_DEFLATE] = "deflate";
 	names[VIRTIO_BALLOON_VQ_STATS] = NULL;
 	names[VIRTIO_BALLOON_VQ_FREE_PAGE] = NULL;
+	names[VIRTIO_BALLOON_VQ_HINTING] = NULL;
 
 	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_STATS_VQ)) {
 		names[VIRTIO_BALLOON_VQ_STATS] = "stats";
@@ -499,11 +586,18 @@ static int init_vqs(struct virtio_balloon *vb)
 		callbacks[VIRTIO_BALLOON_VQ_FREE_PAGE] = NULL;
 	}
 
+	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_HINTING)) {
+		names[VIRTIO_BALLOON_VQ_HINTING] = "hinting_vq";
+		callbacks[VIRTIO_BALLOON_VQ_HINTING] = NULL;
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
@@ -942,6 +1036,14 @@ static int virtballoon_probe(struct virtio_device *vdev)
 		if (err)
 			goto out_del_balloon_wq;
 	}
+
+#ifdef CONFIG_PAGE_HINTING
+	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_HINTING) &&
+	    page_hinting_flag) {
+		hvb = vb;
+		page_hinting_enable(&hcb);
+	}
+#endif
 	virtio_device_ready(vdev);
 
 	if (towards_target(vb))
@@ -989,6 +1091,12 @@ static void virtballoon_remove(struct virtio_device *vdev)
 		destroy_workqueue(vb->balloon_wq);
 	}
 
+#ifdef CONFIG_PAGE_HINTING
+	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_HINTING)) {
+		hvb = NULL;
+		page_hinting_disable();
+	}
+#endif
 	remove_common(vb);
 #ifdef CONFIG_BALLOON_COMPACTION
 	if (vb->vb_dev_info.inode)
@@ -1043,8 +1151,10 @@ static unsigned int features[] = {
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
index a1966cd7b677..25e4f817c660 100644
--- a/include/uapi/linux/virtio_balloon.h
+++ b/include/uapi/linux/virtio_balloon.h
@@ -29,6 +29,7 @@
 #include <linux/virtio_types.h>
 #include <linux/virtio_ids.h>
 #include <linux/virtio_config.h>
+#include <linux/page_hinting.h>
 
 /* The feature bitmap for virtio balloon */
 #define VIRTIO_BALLOON_F_MUST_TELL_HOST	0 /* Tell before reclaiming pages */
@@ -36,6 +37,7 @@
 #define VIRTIO_BALLOON_F_DEFLATE_ON_OOM	2 /* Deflate balloon on OOM */
 #define VIRTIO_BALLOON_F_FREE_PAGE_HINT	3 /* VQ to report free pages */
 #define VIRTIO_BALLOON_F_PAGE_POISON	4 /* Guest is using page poisoning */
+#define VIRTIO_BALLOON_F_HINTING	5 /* Page hinting virtqueue */
 
 /* Size of a PFN in the balloon interface. */
 #define VIRTIO_BALLOON_PFN_SHIFT 12
@@ -108,4 +110,16 @@ struct virtio_balloon_stat {
 	__virtio64 val;
 } __attribute__((packed));
 
+#ifdef CONFIG_PAGE_HINTING
+/*
+ * struct hinting_data- holds the information associated with hinting.
+ * @phys_add:	physical address associated with a page or the array holding
+ *		the array of isolated pages.
+ * @size:	total size associated with the phys_addr.
+ */
+struct hinting_data {
+	__virtio64 phys_addr;
+	__virtio32 size;
+};
+#endif
 #endif /* _LINUX_VIRTIO_BALLOON_H */
-- 
2.21.0

