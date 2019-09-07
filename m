Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BD51AC81F
	for <lists+kvm@lfdr.de>; Sat,  7 Sep 2019 19:26:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405027AbfIGR0P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 7 Sep 2019 13:26:15 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:46227 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404941AbfIGR0P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 7 Sep 2019 13:26:15 -0400
Received: by mail-oi1-f193.google.com with SMTP id x7so7539617oie.13;
        Sat, 07 Sep 2019 10:26:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=Ec9PKUPnEp2nxFPq8uzj4M569SmUi9G5uEm08+INU8Q=;
        b=FSPmq1O2csaCkFvAJS1xMTNPNzh3ZUdhXDpdYjZZRUfIlUsPeFxmRvlv9A0FMcYbDZ
         s5rHMFU8VUWCy7rWi4cU4n8732sz4192LbjR1Sni4BibjZLDdJpqNqLa7HXgDVt1Wgce
         q4fnwCcSmvZ9SpybvCzKZKyCo6YFSTh5vySaKTOPeHBUYjn2ZIa8woFvfvfSyJRE/UDK
         /2XD9AaU0V7DTUqfJx1QpAKPTdlsGSugEXSe6h3j5aMZ5KeejwWb8tNbcrLA8rB7b+EY
         3ZFkkKYAsBpwVNVPmzTuemNm13nlAeM8QDkAuIrcLu35caMMSeUH1kHoQoVWexmiM6+Z
         FdRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=Ec9PKUPnEp2nxFPq8uzj4M569SmUi9G5uEm08+INU8Q=;
        b=iynVMXovtYG4CumizjLv4WHZvaJozx9wySr2IqMQAis1ZDrxTxKnBCpc6dVtnMWkZE
         7NFhxjbyJ2+gTcfmd9NZdTrdwvrwtMRMNqLRo0WAp5pMBLXgGBHaG++fOqeQzb5/wa1P
         OOQViT8bmUxwgXm8+5q5wQkvFvfb9DMosgAYhRMXFIU5abEEzZg0ztVt9VLWkA2MgDyT
         8RNxAq8y/WbWO4w+sAD3nkIgDhDvI5sa6uyxT05wz3RsEC+58Hz47JR6k1e7tPSgQFM9
         CfQjKsc9rTljQwtRPrOVOCRnvEDDj5gTCFukv2vpU+GHYHGlezcw3xeBzHwDEvHTQojx
         rJvw==
X-Gm-Message-State: APjAAAXqLisO0/5yyxHE8e4wCwO43cqYzmiF77+FK76182VlrTtisGL5
        HDAIDjD8/sOQaZSfYbLJySM=
X-Google-Smtp-Source: APXvYqwtUUfJvT9okkW3XqeOpMY142Y6ahDMpKz0f8GnPzU5ZPpJbRHr5lSEZrIJnrpsN+gxgVN7HQ==
X-Received: by 2002:aca:48b:: with SMTP id 133mr11754933oie.30.1567877173706;
        Sat, 07 Sep 2019 10:26:13 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id 81sm3738825oth.53.2019.09.07.10.26.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 07 Sep 2019 10:26:13 -0700 (PDT)
Subject: [PATCH v9 8/8] virtio-balloon: Add support for providing unused
 page reports to host
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     virtio-dev@lists.oasis-open.org, kvm@vger.kernel.org,
        mst@redhat.com, catalin.marinas@arm.com, david@redhat.com,
        dave.hansen@intel.com, linux-kernel@vger.kernel.org,
        willy@infradead.org, mhocko@kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, will@kernel.org,
        linux-arm-kernel@lists.infradead.org, osalvador@suse.de
Cc:     yang.zhang.wz@gmail.com, pagupta@redhat.com,
        konrad.wilk@oracle.com, nitesh@redhat.com, riel@surriel.com,
        lcapitulino@redhat.com, wei.w.wang@intel.com, aarcange@redhat.com,
        ying.huang@intel.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, fengguang.wu@intel.com,
        alexander.h.duyck@linux.intel.com, kirill.shutemov@linux.intel.com
Date:   Sat, 07 Sep 2019 10:26:10 -0700
Message-ID: <20190907172610.10910.21461.stgit@localhost.localdomain>
In-Reply-To: <20190907172225.10910.34302.stgit@localhost.localdomain>
References: <20190907172225.10910.34302.stgit@localhost.localdomain>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Alexander Duyck <alexander.h.duyck@linux.intel.com>

Add support for the page reporting feature provided by virtio-balloon.
Reporting differs from the regular balloon functionality in that is is
much less durable than a standard memory balloon. Instead of creating a
list of pages that cannot be accessed the pages are only inaccessible
while they are being indicated to the virtio interface. Once the
interface has acknowledged them they are placed back into their respective
free lists and are once again accessible by the guest system.

Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
---
 drivers/virtio/Kconfig              |    1 +
 drivers/virtio/virtio_balloon.c     |   65 +++++++++++++++++++++++++++++++++++
 include/uapi/linux/virtio_balloon.h |    1 +
 3 files changed, 67 insertions(+)

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
index d2547df7de93..62bdb0afd022 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -19,6 +19,7 @@
 #include <linux/mount.h>
 #include <linux/magic.h>
 #include <linux/pseudo_fs.h>
+#include <linux/page_reporting.h>
 
 /*
  * Balloon device works in 4K page units.  So each page is pointed to by
@@ -37,6 +38,9 @@
 #define VIRTIO_BALLOON_FREE_PAGE_SIZE \
 	(1 << (VIRTIO_BALLOON_FREE_PAGE_ORDER + PAGE_SHIFT))
 
+/*  limit on the number of pages that can be on the reporting vq */
+#define VIRTIO_BALLOON_VRING_HINTS_MAX	16
+
 #ifdef CONFIG_BALLOON_COMPACTION
 static struct vfsmount *balloon_mnt;
 #endif
@@ -46,6 +50,7 @@ enum virtio_balloon_vq {
 	VIRTIO_BALLOON_VQ_DEFLATE,
 	VIRTIO_BALLOON_VQ_STATS,
 	VIRTIO_BALLOON_VQ_FREE_PAGE,
+	VIRTIO_BALLOON_VQ_REPORTING,
 	VIRTIO_BALLOON_VQ_MAX
 };
 
@@ -113,6 +118,10 @@ struct virtio_balloon {
 
 	/* To register a shrinker to shrink memory upon memory pressure */
 	struct shrinker shrinker;
+
+	/* Unused page reporting device */
+	struct virtqueue *reporting_vq;
+	struct page_reporting_dev_info ph_dev_info;
 };
 
 static struct virtio_device_id id_table[] = {
@@ -152,6 +161,32 @@ static void tell_host(struct virtio_balloon *vb, struct virtqueue *vq)
 
 }
 
+void virtballoon_unused_page_report(struct page_reporting_dev_info *ph_dev_info,
+				    unsigned int nents)
+{
+	struct virtio_balloon *vb =
+		container_of(ph_dev_info, struct virtio_balloon, ph_dev_info);
+	struct virtqueue *vq = vb->reporting_vq;
+	unsigned int unused, err;
+
+	/* We should always be able to add these buffers to an empty queue. */
+	err = virtqueue_add_inbuf(vq, ph_dev_info->sg, nents, vb,
+				  GFP_NOWAIT | __GFP_NOWARN);
+
+	/*
+	 * In the extremely unlikely case that something has changed and we
+	 * are able to trigger an error we will simply display a warning
+	 * and exit without actually processing the pages.
+	 */
+	if (WARN_ON(err))
+		return;
+
+	virtqueue_kick(vq);
+
+	/* When host has read buffer, this completes via balloon_ack */
+	wait_event(vb->acked, virtqueue_get_buf(vq, &unused));
+}
+
 static void set_page_pfns(struct virtio_balloon *vb,
 			  __virtio32 pfns[], struct page *page)
 {
@@ -476,6 +511,7 @@ static int init_vqs(struct virtio_balloon *vb)
 	names[VIRTIO_BALLOON_VQ_DEFLATE] = "deflate";
 	names[VIRTIO_BALLOON_VQ_STATS] = NULL;
 	names[VIRTIO_BALLOON_VQ_FREE_PAGE] = NULL;
+	names[VIRTIO_BALLOON_VQ_REPORTING] = NULL;
 
 	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_STATS_VQ)) {
 		names[VIRTIO_BALLOON_VQ_STATS] = "stats";
@@ -487,11 +523,19 @@ static int init_vqs(struct virtio_balloon *vb)
 		callbacks[VIRTIO_BALLOON_VQ_FREE_PAGE] = NULL;
 	}
 
+	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_REPORTING)) {
+		names[VIRTIO_BALLOON_VQ_REPORTING] = "reporting_vq";
+		callbacks[VIRTIO_BALLOON_VQ_REPORTING] = balloon_ack;
+	}
+
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
@@ -930,12 +974,30 @@ static int virtballoon_probe(struct virtio_device *vdev)
 		if (err)
 			goto out_del_balloon_wq;
 	}
+
+	vb->ph_dev_info.report = virtballoon_unused_page_report;
+	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_REPORTING)) {
+		unsigned int capacity;
+
+		capacity = min_t(unsigned int,
+				 virtqueue_get_vring_size(vb->reporting_vq),
+				 VIRTIO_BALLOON_VRING_HINTS_MAX);
+		vb->ph_dev_info.capacity = capacity;
+
+		err = page_reporting_startup(&vb->ph_dev_info);
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
@@ -964,6 +1026,8 @@ static void virtballoon_remove(struct virtio_device *vdev)
 {
 	struct virtio_balloon *vb = vdev->priv;
 
+	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_REPORTING))
+		page_reporting_shutdown(&vb->ph_dev_info);
 	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_DEFLATE_ON_OOM))
 		virtio_balloon_unregister_shrinker(vb);
 	spin_lock_irq(&vb->stop_update_lock);
@@ -1035,6 +1099,7 @@ static int virtballoon_validate(struct virtio_device *vdev)
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

