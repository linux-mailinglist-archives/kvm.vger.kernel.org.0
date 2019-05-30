Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E41FB30444
	for <lists+kvm@lfdr.de>; Thu, 30 May 2019 23:54:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727054AbfE3Vyx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 May 2019 17:54:53 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:40222 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727055AbfE3Vyv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 May 2019 17:54:51 -0400
Received: by mail-ot1-f66.google.com with SMTP id u11so7165870otq.7;
        Thu, 30 May 2019 14:54:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=/mUEYZKWYYcL2BHkb0DxPuaatZyzvoF9cSukuFqsj94=;
        b=cbR7FE1zdTHh1NeELi13nyRj1xb4yqLhmeuGlEbyivkZsLIB39JafRdCTyWZW4ufux
         df2TuWOVTJwY0SaSOo7mkmtztkSdvUnXcqR/MeoOGe42k0iFfT4bBFCPz0bxyURY7TUZ
         bhRHulEaACfjcyPUPtgEkThh7MyjbEWB2YIPTIEBYQmeZqG53q+hLORM9WmGLoudMFdL
         om1G4JzlXwN33wwnyKo34fnqr5EGubW3LDFIsN26NjyHtyi8wXc2VgvmiU+I8gU1ck9p
         3SqhZ6xJNojk92m6bkbBN9LZm78eARhs3gL4w27+beyXfel6y7AYi/KV+k8A1EsqYxBS
         LlFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=/mUEYZKWYYcL2BHkb0DxPuaatZyzvoF9cSukuFqsj94=;
        b=f2ir20CIeNWzzJ+KN2kx4iTBu971KO5gJ9GLYqYI3jdxBg7EYYUIlL0m4uS+b+xEgQ
         k772KXuS7in01OK5Uu3HJW/lq+ZYhsmDVmSQFsF8E9bJ+CAW1MsnLz429wCf5qgu3n5U
         kSd0zB0bbATK3GHXwG2RnK1Yn21Q+zWzSyivr+gjEfxX7dopytwILid1VvSajQmjfGsu
         Ws6c9L+NGxUCMab+diFNfn4qHOpUF0zZWaE7XU1sCYGqYtXiZ/TrnYNLQv7FKFQKb6yQ
         SljKZh/jhTsrpBfBO3ASE6HUzRc1LXl7TOV2x26vZIPjYRaCkJboE2gX8HXHmuG5wcxF
         JC4g==
X-Gm-Message-State: APjAAAW8hW/Ycbl911Cvujt6hoH39yvFkYPr+mjwjyxf4I/OU84oL0uW
        2P8EHpw1/ECqyWeMV/aa5VY=
X-Google-Smtp-Source: APXvYqx01mVsNW6pIQK0hwBzQcE1nW+e4GzPg6f2gyQVuJls5woMO9c9GDOi7DlASV/rWA1A7XKMvA==
X-Received: by 2002:a9d:378b:: with SMTP id x11mr3987037otb.184.1559253290577;
        Thu, 30 May 2019 14:54:50 -0700 (PDT)
Received: from localhost.localdomain (50-126-100-225.drr01.csby.or.frontiernet.net. [50.126.100.225])
        by smtp.gmail.com with ESMTPSA id u8sm1544640otk.53.2019.05.30.14.54.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 May 2019 14:54:50 -0700 (PDT)
Subject: [RFC PATCH 10/11] virtio-balloon: Add support for aerating memory
 via bubble hinting
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     nitesh@redhat.com, kvm@vger.kernel.org, david@redhat.com,
        mst@redhat.com, dave.hansen@intel.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc:     yang.zhang.wz@gmail.com, pagupta@redhat.com, riel@surriel.com,
        konrad.wilk@oracle.com, lcapitulino@redhat.com,
        wei.w.wang@intel.com, aarcange@redhat.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, alexander.h.duyck@linux.intel.com
Date:   Thu, 30 May 2019 14:54:48 -0700
Message-ID: <20190530215448.13974.59362.stgit@localhost.localdomain>
In-Reply-To: <20190530215223.13974.22445.stgit@localhost.localdomain>
References: <20190530215223.13974.22445.stgit@localhost.localdomain>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Alexander Duyck <alexander.h.duyck@linux.intel.com>

Add support for aerating memory using the bubble hinting feature provided
by virtio-balloon. Bubble hinting differs from the regular balloon
functionality in that is is much less durable than a standard memory
balloon. Instead of creating a list of pages that cannot be accessed the
pages are only inaccessible while they are being indicated to the virtio
interface. Once the interface has acknowledged them they are placed back
into their respective free lists and are once again accessible by the guest
system.

Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
---
 drivers/virtio/Kconfig              |    1 
 drivers/virtio/virtio_balloon.c     |   89 +++++++++++++++++++++++++++++++++++
 include/uapi/linux/virtio_balloon.h |    1 
 3 files changed, 90 insertions(+), 1 deletion(-)

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
index 44339fc87cc7..e1399991bc1f 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -18,6 +18,7 @@
 #include <linux/mm.h>
 #include <linux/mount.h>
 #include <linux/magic.h>
+#include <linux/memory_aeration.h>
 
 /*
  * Balloon device works in 4K page units.  So each page is pointed to by
@@ -45,6 +46,7 @@ enum virtio_balloon_vq {
 	VIRTIO_BALLOON_VQ_DEFLATE,
 	VIRTIO_BALLOON_VQ_STATS,
 	VIRTIO_BALLOON_VQ_FREE_PAGE,
+	VIRTIO_BALLOON_VQ_HINTING,
 	VIRTIO_BALLOON_VQ_MAX
 };
 
@@ -52,9 +54,16 @@ enum virtio_balloon_config_read {
 	VIRTIO_BALLOON_CONFIG_READ_CMD_ID = 0,
 };
 
+#define VIRTIO_BUBBLE_ARRAY_HINTS_MAX	32
+struct virtio_bubble_page_hint {
+	__virtio32 pfn;
+	__virtio32 size;
+};
+
 struct virtio_balloon {
 	struct virtio_device *vdev;
-	struct virtqueue *inflate_vq, *deflate_vq, *stats_vq, *free_page_vq;
+	struct virtqueue *inflate_vq, *deflate_vq, *stats_vq, *free_page_vq,
+								*hinting_vq;
 
 	/* Balloon's own wq for cpu-intensive work items */
 	struct workqueue_struct *balloon_wq;
@@ -107,6 +116,11 @@ struct virtio_balloon {
 	unsigned int num_pfns;
 	__virtio32 pfns[VIRTIO_BALLOON_ARRAY_PFNS_MAX];
 
+	/* The array of PFNs we are hinting on */
+	unsigned int num_hints;
+	struct virtio_bubble_page_hint hints[VIRTIO_BUBBLE_ARRAY_HINTS_MAX];
+	struct aerator_dev_info a_dev_info;
+
 	/* Memory statistics */
 	struct virtio_balloon_stat stats[VIRTIO_BALLOON_S_NR];
 
@@ -151,6 +165,54 @@ static void tell_host(struct virtio_balloon *vb, struct virtqueue *vq)
 
 }
 
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
+	vb->num_hints = 0;
+
+	list_for_each_entry(page, &a_dev_info->batch_reactor, lru) {
+		struct virtio_bubble_page_hint *hint;
+		unsigned int size;
+
+		hint = &vb->hints[vb->num_hints++];
+		hint->pfn = cpu_to_virtio32(vb->vdev,
+					    page_to_balloon_pfn(page));
+		size = VIRTIO_BALLOON_PAGES_PER_PAGE << page_private(page);
+		hint->size = cpu_to_virtio32(vb->vdev, size);
+	}
+
+	/* We shouldn't have been called if there is nothing to process */
+	if (WARN_ON(vb->num_hints == 0))
+		return;
+
+	/* Detach all the used buffers from the vq */
+	while (virtqueue_get_buf(vq, &unused))
+		;
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
+}
+
+static void aerator_settled(struct virtqueue *vq)
+{
+	/* Drain the current aerator contents, refill, and start next cycle */
+	aerator_cycle();
+}
+
 static void set_page_pfns(struct virtio_balloon *vb,
 			  __virtio32 pfns[], struct page *page)
 {
@@ -475,6 +537,7 @@ static int init_vqs(struct virtio_balloon *vb)
 	names[VIRTIO_BALLOON_VQ_DEFLATE] = "deflate";
 	names[VIRTIO_BALLOON_VQ_STATS] = NULL;
 	names[VIRTIO_BALLOON_VQ_FREE_PAGE] = NULL;
+	names[VIRTIO_BALLOON_VQ_HINTING] = NULL;
 
 	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_STATS_VQ)) {
 		names[VIRTIO_BALLOON_VQ_STATS] = "stats";
@@ -486,11 +549,19 @@ static int init_vqs(struct virtio_balloon *vb)
 		callbacks[VIRTIO_BALLOON_VQ_FREE_PAGE] = NULL;
 	}
 
+	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_HINTING)) {
+		names[VIRTIO_BALLOON_VQ_HINTING] = "hinting_vq";
+		callbacks[VIRTIO_BALLOON_VQ_HINTING] = aerator_settled;
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
@@ -929,12 +1000,25 @@ static int virtballoon_probe(struct virtio_device *vdev)
 		if (err)
 			goto out_del_balloon_wq;
 	}
+
+	vb->a_dev_info.react = virtballoon_aerator_react;
+	vb->a_dev_info.capacity = VIRTIO_BUBBLE_ARRAY_HINTS_MAX;
+	INIT_LIST_HEAD(&vb->a_dev_info.batch_reactor);
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
@@ -963,6 +1047,8 @@ static void virtballoon_remove(struct virtio_device *vdev)
 {
 	struct virtio_balloon *vb = vdev->priv;
 
+	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_HINTING))
+		aerator_shutdown();
 	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_DEFLATE_ON_OOM))
 		virtio_balloon_unregister_shrinker(vb);
 	spin_lock_irq(&vb->stop_update_lock);
@@ -1032,6 +1118,7 @@ static int virtballoon_validate(struct virtio_device *vdev)
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

