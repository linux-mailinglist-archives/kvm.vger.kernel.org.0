Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E2A44C3C5
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2019 00:37:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730259AbfFSWhR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jun 2019 18:37:17 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:44581 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726322AbfFSWhR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jun 2019 18:37:17 -0400
Received: by mail-io1-f65.google.com with SMTP id s7so266698iob.11;
        Wed, 19 Jun 2019 15:37:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=rcB09Esy94C7aChcgEU5ub/5hCFzSMInAKoZyHyAl/0=;
        b=LZXgUEf2jH6LL8isvS0SoC4yM3DSuvpULKrmFDjMu5bU+6TBb6nAYRPQUz8lFzWJRu
         gyysj5UuzA6V4jGjWO5zNOTav1bATCNgO6vHJf+3rbOsVHmDV+rZYOjL+bZ5P+qROwJm
         s74ZcJhFwkjUZuhCn6r5GqKbzxBT/Cnfxtn/FeIz0L6Q7rX2oGA1ocFb+R7Vyx450ARN
         qoqQ4guMuYV/KkCfiNhOv3R/xCkdx3vDwN+dOnLI6cgMj5k9m1mkUHIX2rAgTC82c4J+
         ahIHc2oUFLBsdpgxhZ4NgyplBSEiPkGsYiI8Z9ucSQSIuPw83S267tsWnRgYHx71aNYN
         awIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=rcB09Esy94C7aChcgEU5ub/5hCFzSMInAKoZyHyAl/0=;
        b=uXEZp9hjTvKzyevn9ZOIhRugFJKvJf0PyxiWnfhY4vCWdC8DeaMRHwtg/IBzzY0uZJ
         3kTGDZXRk6iEVJAl0Xx00RI/Jn+DFGo78IiOEG/JN4in/gtEJOEtvt7WzZZ1PB3w7MmQ
         TJ+zsVH7pGQ2JYaep57JUPTxLT0jaurA2ZhKyOQ8A8MJdzGrrGgjtNmJhX/zMgonFcs6
         OCrx9FOdyVaSqXIkEmxuwS6KISfE84z61qH8Si898sbdK9Xnxs5IgOsLOEFqg+9cDuQC
         xX+tOFLRfwQQg6M3PvJ7T3jfsZNRLeeiCxa7uNX3vlYnt/7EqJGdNYj3ekdtyX6RFhSL
         s9JQ==
X-Gm-Message-State: APjAAAURDbq0wAY5YeOeTxdvXw4qDJsdjiPQ5+3ko0NoesQyHsni6OzF
        1GSJm8pj+zziKR+f6igVAzI=
X-Google-Smtp-Source: APXvYqzfCZXJ6ZYmgDdjSyNXw8kk4GtmA9Co/QnObvMoQH5mbGA51G3bhAlOwrkVwB/hMuhvFYspKg==
X-Received: by 2002:a5e:8f08:: with SMTP id c8mr2859494iok.52.1560983836332;
        Wed, 19 Jun 2019 15:37:16 -0700 (PDT)
Received: from localhost.localdomain (50-126-100-225.drr01.csby.or.frontiernet.net. [50.126.100.225])
        by smtp.gmail.com with ESMTPSA id v25sm15377416ioh.25.2019.06.19.15.37.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 19 Jun 2019 15:37:15 -0700 (PDT)
Subject: [PATCH v1 QEMU] QEMU: Provide a interface for hinting based off of
 the balloon infrastructure
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     nitesh@redhat.com, kvm@vger.kernel.org, david@redhat.com,
        mst@redhat.com, dave.hansen@intel.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org
Cc:     yang.zhang.wz@gmail.com, pagupta@redhat.com, riel@surriel.com,
        konrad.wilk@oracle.com, lcapitulino@redhat.com,
        wei.w.wang@intel.com, aarcange@redhat.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, alexander.h.duyck@linux.intel.com
Date:   Wed, 19 Jun 2019 15:37:13 -0700
Message-ID: <20190619223535.1403.32612.stgit@localhost.localdomain>
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
 hw/virtio/trace-events                          |    1 
 hw/virtio/virtio-balloon.c                      |   73 +++++++++++++++++++++++
 include/hw/virtio/virtio-balloon.h              |    2 -
 include/standard-headers/linux/virtio_balloon.h |    1 
 4 files changed, 76 insertions(+), 1 deletion(-)

diff --git a/hw/virtio/trace-events b/hw/virtio/trace-events
index e28ba48da621..b56daf460769 100644
--- a/hw/virtio/trace-events
+++ b/hw/virtio/trace-events
@@ -46,6 +46,7 @@ virtio_balloon_handle_output(const char *name, uint64_t gpa) "section name: %s g
 virtio_balloon_get_config(uint32_t num_pages, uint32_t actual) "num_pages: %d actual: %d"
 virtio_balloon_set_config(uint32_t actual, uint32_t oldactual) "actual: %d oldactual: %d"
 virtio_balloon_to_target(uint64_t target, uint32_t num_pages) "balloon target: 0x%"PRIx64" num_pages: %d"
+virtio_bubble_handle_output(const char *name, uint64_t gpa, uint64_t size) "section name: %s gpa: 0x%" PRIx64 " size: %" PRIx64
 
 # virtio-mmio.c
 virtio_mmio_read(uint64_t offset) "virtio_mmio_read offset 0x%" PRIx64
diff --git a/hw/virtio/virtio-balloon.c b/hw/virtio/virtio-balloon.c
index 2112874055fb..93ee165d2db2 100644
--- a/hw/virtio/virtio-balloon.c
+++ b/hw/virtio/virtio-balloon.c
@@ -328,6 +328,75 @@ static void balloon_stats_set_poll_interval(Object *obj, Visitor *v,
     balloon_stats_change_timer(s, 0);
 }
 
+static void bubble_inflate_page(VirtIOBalloon *balloon,
+                                MemoryRegion *mr, hwaddr offset, size_t size)
+{
+    void *addr = memory_region_get_ram_ptr(mr) + offset;
+    ram_addr_t ram_offset;
+    size_t rb_page_size;
+    RAMBlock *rb;
+
+    rb = qemu_ram_block_from_host(addr, false, &ram_offset);
+    rb_page_size = qemu_ram_pagesize(rb);
+
+    /* For now we will simply ignore unaligned memory regions */
+    if ((ram_offset | size) & (rb_page_size - 1))
+        return;
+
+    ram_block_discard_range(rb, ram_offset, size);
+}
+
+static void virtio_bubble_handle_output(VirtIODevice *vdev, VirtQueue *vq)
+{
+    VirtIOBalloon *s = VIRTIO_BALLOON(vdev);
+    VirtQueueElement *elem;
+    MemoryRegionSection section;
+
+    for (;;) {
+        size_t offset = 0;
+	uint64_t pa_order;
+
+        elem = virtqueue_pop(vq, sizeof(VirtQueueElement));
+        if (!elem) {
+            return;
+        }
+
+        while (iov_to_buf(elem->out_sg, elem->out_num, offset, &pa_order, 8) == 8) {
+            hwaddr pa = virtio_ldq_p(vdev, &pa_order);
+            size_t size = 1ul << (VIRTIO_BALLOON_PFN_SHIFT + (pa & 0xFF));
+
+            pa -= pa & 0xFF;
+            offset += 8;
+
+            if (qemu_balloon_is_inhibited())
+                continue;
+
+            section = memory_region_find(get_system_memory(), pa, size);
+            if (!section.mr) {
+                trace_virtio_balloon_bad_addr(pa);
+                continue;
+            }
+
+            if (!memory_region_is_ram(section.mr) ||
+                memory_region_is_rom(section.mr) ||
+                memory_region_is_romd(section.mr)) {
+                trace_virtio_balloon_bad_addr(pa);
+            } else {
+                trace_virtio_bubble_handle_output(memory_region_name(section.mr),
+                                                  pa, size);
+                bubble_inflate_page(s, section.mr,
+                                    section.offset_within_region, size);
+            }
+
+            memory_region_unref(section.mr);
+        }
+
+        virtqueue_push(vq, elem, offset);
+        virtio_notify(vdev, vq);
+        g_free(elem);
+    }
+}
+
 static void virtio_balloon_handle_output(VirtIODevice *vdev, VirtQueue *vq)
 {
     VirtIOBalloon *s = VIRTIO_BALLOON(vdev);
@@ -694,6 +763,7 @@ static uint64_t virtio_balloon_get_features(VirtIODevice *vdev, uint64_t f,
     VirtIOBalloon *dev = VIRTIO_BALLOON(vdev);
     f |= dev->host_features;
     virtio_add_feature(&f, VIRTIO_BALLOON_F_STATS_VQ);
+    virtio_add_feature(&f, VIRTIO_BALLOON_F_HINTING);
 
     return f;
 }
@@ -780,6 +850,7 @@ static void virtio_balloon_device_realize(DeviceState *dev, Error **errp)
     s->ivq = virtio_add_queue(vdev, 128, virtio_balloon_handle_output);
     s->dvq = virtio_add_queue(vdev, 128, virtio_balloon_handle_output);
     s->svq = virtio_add_queue(vdev, 128, virtio_balloon_receive_stats);
+    s->hvq = virtio_add_queue(vdev, 128, virtio_bubble_handle_output);
 
     if (virtio_has_feature(s->host_features,
                            VIRTIO_BALLOON_F_FREE_PAGE_HINT)) {
@@ -875,6 +946,8 @@ static void virtio_balloon_instance_init(Object *obj)
 
     object_property_add(obj, "guest-stats", "guest statistics",
                         balloon_stats_get_all, NULL, NULL, s, NULL);
+    object_property_add(obj, "guest-page-hinting", "guest page hinting",
+                        NULL, NULL, NULL, s, NULL);
 
     object_property_add(obj, "guest-stats-polling-interval", "int",
                         balloon_stats_get_poll_interval,
diff --git a/include/hw/virtio/virtio-balloon.h b/include/hw/virtio/virtio-balloon.h
index 1afafb12f6bc..dd6d4d0e45fd 100644
--- a/include/hw/virtio/virtio-balloon.h
+++ b/include/hw/virtio/virtio-balloon.h
@@ -44,7 +44,7 @@ enum virtio_balloon_free_page_report_status {
 
 typedef struct VirtIOBalloon {
     VirtIODevice parent_obj;
-    VirtQueue *ivq, *dvq, *svq, *free_page_vq;
+    VirtQueue *ivq, *dvq, *svq, *hvq, *free_page_vq;
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

