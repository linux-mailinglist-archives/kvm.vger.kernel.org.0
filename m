Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E735989F56
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2019 15:14:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728927AbfHLNNT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Aug 2019 09:13:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39050 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728864AbfHLNNR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Aug 2019 09:13:17 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 64F01309C387;
        Mon, 12 Aug 2019 13:13:16 +0000 (UTC)
Received: from virtlab605.virt.lab.eng.bos.redhat.com (virtlab605.virt.lab.eng.bos.redhat.com [10.19.152.201])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6F84B5D6A0;
        Mon, 12 Aug 2019 13:13:14 +0000 (UTC)
From:   Nitesh Narayan Lal <nitesh@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, virtio-dev@lists.oasis-open.org,
        pbonzini@redhat.com, lcapitulino@redhat.com, pagupta@redhat.com,
        wei.w.wang@intel.com, yang.zhang.wz@gmail.com, riel@surriel.com,
        david@redhat.com, mst@redhat.com, dodgen@google.com,
        konrad.wilk@oracle.com, dhildenb@redhat.com, aarcange@redhat.com,
        alexander.duyck@gmail.com, john.starks@microsoft.com,
        dave.hansen@intel.com, mhocko@suse.com, cohuck@redhat.com
Subject: [RFC][Patch v12 2/2] virtio-balloon: interface to support free page reporting
Date:   Mon, 12 Aug 2019 09:12:35 -0400
Message-Id: <20190812131235.27244-3-nitesh@redhat.com>
In-Reply-To: <20190812131235.27244-1-nitesh@redhat.com>
References: <20190812131235.27244-1-nitesh@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Mon, 12 Aug 2019 13:13:16 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Enables the kernel to negotiate VIRTIO_BALLOON_F_REPORTING feature with
the host. If it is available and page_reporting_flag is set to true,
page_reporting is enabled and its callback is configured along with
the max_pages count which indicates the maximum number of pages that
can be isolated and reported at a time. Currently, only free pages of
order >= (MAX_ORDER - 2) are reported. To prevent any false OOM
max_pages count is set to 16.

By default page_reporting feature is enabled and gets loaded as soon
as the virtio-balloon driver is loaded. However, it could be disabled
by writing the page_reporting_flag which is a virtio-balloon parameter.

Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
---
 drivers/virtio/Kconfig              |  1 +
 drivers/virtio/virtio_balloon.c     | 64 ++++++++++++++++++++++++++++-
 include/uapi/linux/virtio_balloon.h |  1 +
 3 files changed, 65 insertions(+), 1 deletion(-)

diff --git a/drivers/virtio/Kconfig b/drivers/virtio/Kconfig
index 078615cf2afc..4b2dd8259ff5 100644
--- a/drivers/virtio/Kconfig
+++ b/drivers/virtio/Kconfig
@@ -58,6 +58,7 @@ config VIRTIO_BALLOON
 	tristate "Virtio balloon driver"
 	depends on VIRTIO
 	select MEMORY_BALLOON
+	select PAGE_REPORTING
 	---help---
 	 This driver supports increasing and decreasing the amount
 	 of memory within a KVM guest.
diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index 226fbb995fb0..defec00d4ee2 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -19,6 +19,7 @@
 #include <linux/mount.h>
 #include <linux/magic.h>
 #include <linux/pseudo_fs.h>
+#include <linux/page_reporting.h>
 
 /*
  * Balloon device works in 4K page units.  So each page is pointed to by
@@ -46,6 +47,7 @@ enum virtio_balloon_vq {
 	VIRTIO_BALLOON_VQ_DEFLATE,
 	VIRTIO_BALLOON_VQ_STATS,
 	VIRTIO_BALLOON_VQ_FREE_PAGE,
+	VIRTIO_BALLOON_VQ_REPORTING,
 	VIRTIO_BALLOON_VQ_MAX
 };
 
@@ -55,7 +57,8 @@ enum virtio_balloon_config_read {
 
 struct virtio_balloon {
 	struct virtio_device *vdev;
-	struct virtqueue *inflate_vq, *deflate_vq, *stats_vq, *free_page_vq;
+	struct virtqueue *inflate_vq, *deflate_vq, *stats_vq, *free_page_vq,
+			 *reporting_vq;
 
 	/* Balloon's own wq for cpu-intensive work items */
 	struct workqueue_struct *balloon_wq;
@@ -113,6 +116,9 @@ struct virtio_balloon {
 
 	/* To register a shrinker to shrink memory upon memory pressure */
 	struct shrinker shrinker;
+
+	/* To configure page reporting to report isolated pages */
+	struct page_reporting_config page_reporting_conf;
 };
 
 static struct virtio_device_id id_table[] = {
@@ -120,6 +126,10 @@ static struct virtio_device_id id_table[] = {
 	{ 0 },
 };
 
+bool page_reporting_flag = true;
+module_param(page_reporting_flag, bool, 0644);
+MODULE_PARM_DESC(page_reporting_flag, "Enable page reporting");
+
 static u32 page_to_balloon_pfn(struct page *page)
 {
 	unsigned long pfn = page_to_pfn(page);
@@ -152,6 +162,44 @@ static void tell_host(struct virtio_balloon *vb, struct virtqueue *vq)
 
 }
 
+void virtballoon_report_pages(struct page_reporting_config *page_reporting_conf,
+			      unsigned int num_pages)
+{
+	struct virtio_balloon *vb = container_of(page_reporting_conf,
+						 struct virtio_balloon,
+						 page_reporting_conf);
+	struct virtqueue *vq = vb->reporting_vq;
+	int err, unused;
+
+	/* We should always be able to add these buffers to an empty queue. */
+	err = virtqueue_add_inbuf(vq, page_reporting_conf->sg, num_pages, vb,
+				  GFP_NOWAIT);
+	/* We should not report if the guest is low on memory */
+	if (unlikely(err))
+		return;
+	virtqueue_kick(vq);
+
+	/* When host has read buffer, this completes via balloon_ack */
+	wait_event(vb->acked, virtqueue_get_buf(vq, &unused));
+}
+
+static void virtballoon_page_reporting_setup(struct virtio_balloon *vb)
+{
+	struct device *dev = &vb->vdev->dev;
+	int err;
+
+	vb->page_reporting_conf.report = virtballoon_report_pages;
+	vb->page_reporting_conf.max_pages = PAGE_REPORTING_MAX_PAGES;
+	err = page_reporting_enable(&vb->page_reporting_conf);
+	if (err < 0) {
+		dev_err(dev, "Failed to enable reporting, err = %d\n", err);
+		page_reporting_flag = false;
+		vb->page_reporting_conf.report = NULL;
+		vb->page_reporting_conf.max_pages = 0;
+		return;
+	}
+}
+
 static void set_page_pfns(struct virtio_balloon *vb,
 			  __virtio32 pfns[], struct page *page)
 {
@@ -476,6 +524,7 @@ static int init_vqs(struct virtio_balloon *vb)
 	names[VIRTIO_BALLOON_VQ_DEFLATE] = "deflate";
 	names[VIRTIO_BALLOON_VQ_STATS] = NULL;
 	names[VIRTIO_BALLOON_VQ_FREE_PAGE] = NULL;
+	names[VIRTIO_BALLOON_VQ_REPORTING] = NULL;
 
 	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_STATS_VQ)) {
 		names[VIRTIO_BALLOON_VQ_STATS] = "stats";
@@ -487,11 +536,18 @@ static int init_vqs(struct virtio_balloon *vb)
 		callbacks[VIRTIO_BALLOON_VQ_FREE_PAGE] = NULL;
 	}
 
+	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_REPORTING)) {
+		names[VIRTIO_BALLOON_VQ_REPORTING] = "reporting_vq";
+		callbacks[VIRTIO_BALLOON_VQ_REPORTING] = balloon_ack;
+	}
 	err = vb->vdev->config->find_vqs(vb->vdev, VIRTIO_BALLOON_VQ_MAX,
 					 vqs, callbacks, names, NULL, NULL);
 	if (err)
 		return err;
 
+	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_REPORTING))
+		vb->reporting_vq = vqs[VIRTIO_BALLOON_VQ_REPORTING];
+
 	vb->inflate_vq = vqs[VIRTIO_BALLOON_VQ_INFLATE];
 	vb->deflate_vq = vqs[VIRTIO_BALLOON_VQ_DEFLATE];
 	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_STATS_VQ)) {
@@ -924,6 +980,9 @@ static int virtballoon_probe(struct virtio_device *vdev)
 		if (err)
 			goto out_del_balloon_wq;
 	}
+	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_REPORTING) &&
+	    page_reporting_flag)
+		virtballoon_page_reporting_setup(vb);
 	virtio_device_ready(vdev);
 
 	if (towards_target(vb))
@@ -971,6 +1030,8 @@ static void virtballoon_remove(struct virtio_device *vdev)
 		destroy_workqueue(vb->balloon_wq);
 	}
 
+	if (page_reporting_flag)
+		page_reporting_disable(&vb->page_reporting_conf);
 	remove_common(vb);
 #ifdef CONFIG_BALLOON_COMPACTION
 	if (vb->vb_dev_info.inode)
@@ -1027,6 +1088,7 @@ static unsigned int features[] = {
 	VIRTIO_BALLOON_F_DEFLATE_ON_OOM,
 	VIRTIO_BALLOON_F_FREE_PAGE_HINT,
 	VIRTIO_BALLOON_F_PAGE_POISON,
+	VIRTIO_BALLOON_F_REPORTING,
 };
 
 static struct virtio_driver virtio_balloon_driver = {
diff --git a/include/uapi/linux/virtio_balloon.h b/include/uapi/linux/virtio_balloon.h
index a1966cd7b677..19974392d324 100644
--- a/include/uapi/linux/virtio_balloon.h
+++ b/include/uapi/linux/virtio_balloon.h
@@ -36,6 +36,7 @@
 #define VIRTIO_BALLOON_F_DEFLATE_ON_OOM	2 /* Deflate balloon on OOM */
 #define VIRTIO_BALLOON_F_FREE_PAGE_HINT	3 /* VQ to report free pages */
 #define VIRTIO_BALLOON_F_PAGE_POISON	4 /* Guest is using page poisoning */
+#define VIRTIO_BALLOON_F_REPORTING	5 /* Page reporting virtqueue */
 
 /* Size of a PFN in the balloon interface. */
 #define VIRTIO_BALLOON_PFN_SHIFT 12
-- 
2.21.0

