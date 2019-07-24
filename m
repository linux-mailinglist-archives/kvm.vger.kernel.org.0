Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 723A4734C7
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2019 19:14:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726343AbfGXROU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Jul 2019 13:14:20 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:42946 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726074AbfGXROU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Jul 2019 13:14:20 -0400
Received: by mail-io1-f68.google.com with SMTP id e20so60814155iob.9;
        Wed, 24 Jul 2019 10:14:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=ZIoj43NJHCuwdBLKiuQJ9FmxjncTWPcR2MlEt+h7o+U=;
        b=aySNiRYGFQc24x/Bc4iiG2Y8mXw+zOLMrDHCOA4vJM3jewhUf7oe5Txqi/cuNz8M3A
         9vC2fiueKfH9qGdmx3juwgOWXXcyypi9q8eMRv66hGnJRJ1PEt77uS7qmkddIWcKHYCW
         oCfrkvvDIAWj9jlewYnAsSo7AvQ5JWS7/Tu4y0mAgc6+76ATQO47+pWzNqMO/Zwuety5
         Qcr+LZLZo+l9B5D/ltvl0geoeTlAU6GvF5oA0ckB31hR2jfsAry1miFRntQGyiHHr8E2
         Qm5wk/Vd2wJ0vVtr1OqnHkKSjYl/+xaMjM3cfDoFYTCOjj4FdZDRQU62nXEyF1x7i5ax
         XjUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=ZIoj43NJHCuwdBLKiuQJ9FmxjncTWPcR2MlEt+h7o+U=;
        b=hhlKRm+WCg3ac3TNstQITPgH9MiEhdkCjDDUdDlWO9xi/P7Gp9ZafV2YqATYunboOX
         Ueh1phIUfVQTXE+VmtgXB0fZRDfqhFdsRZtEIJQ6UMWa68+ek1Ya+DyiEznFWnHU508R
         8me/YoJOiy+M6qD97rzd5S+AYR2p3fvyUiZUmamDFKU9+USwcaXg+pCnr88IQ/Ys7exa
         tbmoDsUlaWt4eb/eJtYe/zixZ5Sg245A0WPvUEZTGJs9CYsvI85D4GzPrH8PxRs5Z5EU
         AxezinrhzfOpkTxHXIDhjO7btxRePeGJgW8tzfmdlWDsU00kjjC8hkQ505lQp4Eqg0Tl
         kXmQ==
X-Gm-Message-State: APjAAAVXx+B0pXfrgL75p2TNKjNWEizx+W+RaPFuS8t6B7lp+Nj3voPG
        9cgnj3RC7+Cc6ZpYJAqZs0M=
X-Google-Smtp-Source: APXvYqzh3UDl4qShBdx52TKjsvLqQYDrV3cwS9+g5wM2wuTj8B9iWvID3doGQP/xGnP2TWfmTYT7hQ==
X-Received: by 2002:a6b:790d:: with SMTP id i13mr2316801iop.27.1563988459273;
        Wed, 24 Jul 2019 10:14:19 -0700 (PDT)
Received: from localhost.localdomain (50-39-177-61.bvtn.or.frontiernet.net. [50.39.177.61])
        by smtp.gmail.com with ESMTPSA id b8sm38193847ioj.16.2019.07.24.10.14.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Jul 2019 10:14:18 -0700 (PDT)
Subject: [PATCH v2 QEMU] virtio-balloon: Provide a interface for "bubble
 hinting"
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     nitesh@redhat.com, kvm@vger.kernel.org, david@redhat.com,
        mst@redhat.com, dave.hansen@intel.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org
Cc:     yang.zhang.wz@gmail.com, pagupta@redhat.com, riel@surriel.com,
        konrad.wilk@oracle.com, lcapitulino@redhat.com,
        wei.w.wang@intel.com, aarcange@redhat.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, alexander.h.duyck@linux.intel.com
Date:   Wed, 24 Jul 2019 10:12:10 -0700
Message-ID: <20190724171050.7888.62199.stgit@localhost.localdomain>
In-Reply-To: <20190724165158.6685.87228.stgit@localhost.localdomain>
References: <20190724165158.6685.87228.stgit@localhost.localdomain>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Alexander Duyck <alexander.h.duyck@linux.intel.com>

Add support for what I am referring to as "bubble hinting". Basically the
idea is to function very similar to how the balloon works in that we
basically end up madvising the page as not being used. However we don't
really need to bother with any deflate type logic since the page will be
faulted back into the guest when it is read or written to.

This is meant to be a simplification of the existing balloon interface
to use for providing hints to what memory needs to be freed. I am assuming
this is safe to do as the deflate logic does not actually appear to do very
much other than tracking what subpages have been released and which ones
haven't.

Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
---
 hw/virtio/virtio-balloon.c                      |   40 +++++++++++++++++++++++
 include/hw/virtio/virtio-balloon.h              |    2 +
 include/standard-headers/linux/virtio_balloon.h |    1 +
 3 files changed, 42 insertions(+), 1 deletion(-)

diff --git a/hw/virtio/virtio-balloon.c b/hw/virtio/virtio-balloon.c
index 2112874055fb..70c0004c0f88 100644
--- a/hw/virtio/virtio-balloon.c
+++ b/hw/virtio/virtio-balloon.c
@@ -328,6 +328,39 @@ static void balloon_stats_set_poll_interval(Object *obj, Visitor *v,
     balloon_stats_change_timer(s, 0);
 }
 
+static void virtio_bubble_handle_output(VirtIODevice *vdev, VirtQueue *vq)
+{
+    VirtQueueElement *elem;
+
+    while ((elem = virtqueue_pop(vq, sizeof(VirtQueueElement)))) {
+    	unsigned int i;
+
+        for (i = 0; i < elem->in_num; i++) {
+            void *addr = elem->in_sg[i].iov_base;
+            size_t size = elem->in_sg[i].iov_len;
+            ram_addr_t ram_offset;
+            size_t rb_page_size;
+            RAMBlock *rb;
+
+            if (qemu_balloon_is_inhibited())
+                continue;
+
+            rb = qemu_ram_block_from_host(addr, false, &ram_offset);
+            rb_page_size = qemu_ram_pagesize(rb);
+
+            /* For now we will simply ignore unaligned memory regions */
+            if ((ram_offset | size) & (rb_page_size - 1))
+                continue;
+
+            ram_block_discard_range(rb, ram_offset, size);
+        }
+
+        virtqueue_push(vq, elem, 0);
+        virtio_notify(vdev, vq);
+        g_free(elem);
+    }
+}
+
 static void virtio_balloon_handle_output(VirtIODevice *vdev, VirtQueue *vq)
 {
     VirtIOBalloon *s = VIRTIO_BALLOON(vdev);
@@ -782,6 +815,11 @@ static void virtio_balloon_device_realize(DeviceState *dev, Error **errp)
     s->svq = virtio_add_queue(vdev, 128, virtio_balloon_receive_stats);
 
     if (virtio_has_feature(s->host_features,
+                           VIRTIO_BALLOON_F_HINTING)) {
+        s->hvq = virtio_add_queue(vdev, 128, virtio_bubble_handle_output);
+    }
+
+    if (virtio_has_feature(s->host_features,
                            VIRTIO_BALLOON_F_FREE_PAGE_HINT)) {
         s->free_page_vq = virtio_add_queue(vdev, VIRTQUEUE_MAX_SIZE,
                                            virtio_balloon_handle_free_page_vq);
@@ -897,6 +935,8 @@ static Property virtio_balloon_properties[] = {
                     VIRTIO_BALLOON_F_DEFLATE_ON_OOM, false),
     DEFINE_PROP_BIT("free-page-hint", VirtIOBalloon, host_features,
                     VIRTIO_BALLOON_F_FREE_PAGE_HINT, false),
+    DEFINE_PROP_BIT("guest-page-hinting", VirtIOBalloon, host_features,
+                    VIRTIO_BALLOON_F_HINTING, true),
     DEFINE_PROP_LINK("iothread", VirtIOBalloon, iothread, TYPE_IOTHREAD,
                      IOThread *),
     DEFINE_PROP_END_OF_LIST(),
diff --git a/include/hw/virtio/virtio-balloon.h b/include/hw/virtio/virtio-balloon.h
index 1afafb12f6bc..a58b24fdf29d 100644
--- a/include/hw/virtio/virtio-balloon.h
+++ b/include/hw/virtio/virtio-balloon.h
@@ -44,7 +44,7 @@ enum virtio_balloon_free_page_report_status {
 
 typedef struct VirtIOBalloon {
     VirtIODevice parent_obj;
-    VirtQueue *ivq, *dvq, *svq, *free_page_vq;
+    VirtQueue *ivq, *dvq, *svq, *free_page_vq, *hvq;
     uint32_t free_page_report_status;
     uint32_t num_pages;
     uint32_t actual;
diff --git a/include/standard-headers/linux/virtio_balloon.h b/include/standard-headers/linux/virtio_balloon.h
index 9375ca2a70de..f9e3e8256261 100644
--- a/include/standard-headers/linux/virtio_balloon.h
+++ b/include/standard-headers/linux/virtio_balloon.h
@@ -36,6 +36,7 @@
 #define VIRTIO_BALLOON_F_DEFLATE_ON_OOM	2 /* Deflate balloon on OOM */
 #define VIRTIO_BALLOON_F_FREE_PAGE_HINT	3 /* VQ to report free pages */
 #define VIRTIO_BALLOON_F_PAGE_POISON	4 /* Guest is using page poisoning */
+#define VIRTIO_BALLOON_F_HINTING	5 /* Page hinting virtqueue */
 
 /* Size of a PFN in the balloon interface. */
 #define VIRTIO_BALLOON_PFN_SHIFT 12

