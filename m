Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68C3130458
	for <lists+kvm@lfdr.de>; Thu, 30 May 2019 23:57:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726724AbfE3V5P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 May 2019 17:57:15 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:36499 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726307AbfE3V5P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 May 2019 17:57:15 -0400
Received: by mail-pg1-f193.google.com with SMTP id a3so2781344pgb.3;
        Thu, 30 May 2019 14:57:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=hRtJSBK7hOO2HxW36GCGs67i+7Qs4gI8yBkC+IiPEzA=;
        b=A8TPUAyM7D9PNJyF7BVZzPlObfCFCc59wtEx1tW0J7TG+wTsG/Y3ZacpA78D0FN+zX
         uSjKZOQTH/K3+L8Nh+DdKSRyZ9Nc9LCHvzlvvfOlDQeVx3ol4O9MsvLlO4qLH5u08Uqv
         AZxFBOseylxOrjR12xdoqjq3HbXX8xM1ARAL8TEjoLm7Df6rzarhdti1c2W/DZmu3cDt
         tbhmvtxuG4oyP0X1bKJXfHL4GpMF0gaA5/pZqITUJLyW8f4Rhl/00cMdv6aBLHi6xSdG
         mfUjuJkHoKnb+OB9+5azdHhLq7f+ukrIN2/IuOxPxXtQL8Gnxz0Y/pz1ePg+5IH2t/lZ
         Rq6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=hRtJSBK7hOO2HxW36GCGs67i+7Qs4gI8yBkC+IiPEzA=;
        b=MgCLUfx6lGVMzLfIf0ihUkLGtEDSRWlQ4A+h+85dpVAUeVRfu1pNBrgFpvnK0Jhgj1
         6ZsxRKabUzAoxDhxgsRXA5GmDhl9BIdkYj34SJf2pb3fu9DUwcYDHfXfK6fKhhbL+vM+
         0R0RLUdZ4S5hXp0xmUnpwsBfPER8tT4Qhi4QCDt8LvKdqEZ1zjLSGZZ26nc1Vlibz3kl
         aKRK6wLNMazU1lczx2rG32VVKwgoKGo0ywjt05s4S16CSbn8bOT2Ky56bHywTGLhIRg1
         z2MMikTQI2lm51JW+lnRj0ZuVDV4dAekPl+bIvfzeOVMUPy3mA4KBL0Qnj7Tn0V96lR/
         hLCQ==
X-Gm-Message-State: APjAAAV6BVXdWJtta2fMO8iavDdM44y58utEaeMdmGjvsWtU+EHRGm8O
        EbFzrXEEpcHuOI0FqZlN6D0=
X-Google-Smtp-Source: APXvYqza9LItj53rC/Lk/5f/6GzO1gMW2j4r3pHNQec+Fng2dDwtZIBZAZvJmQjRCmneOAd0OAZcww==
X-Received: by 2002:a17:90a:9289:: with SMTP id n9mr5486760pjo.35.1559253433357;
        Thu, 30 May 2019 14:57:13 -0700 (PDT)
Received: from localhost.localdomain (50-126-100-225.drr01.csby.or.frontiernet.net. [50.126.100.225])
        by smtp.gmail.com with ESMTPSA id a12sm3467604pgq.0.2019.05.30.14.57.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 May 2019 14:57:12 -0700 (PDT)
Subject: [RFC QEMU PATCH] QEMU: Provide a interface for hinting based off of
 the balloon infrastructure
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     nitesh@redhat.com, kvm@vger.kernel.org, david@redhat.com,
        mst@redhat.com, dave.hansen@intel.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc:     yang.zhang.wz@gmail.com, pagupta@redhat.com, riel@surriel.com,
        konrad.wilk@oracle.com, lcapitulino@redhat.com,
        wei.w.wang@intel.com, aarcange@redhat.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, alexander.h.duyck@linux.intel.com
Date:   Thu, 30 May 2019 14:57:12 -0700
Message-ID: <20190530215640.14712.87802.stgit@localhost.localdomain>
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

So this is meant to be a simplification of the existing balloon interface
to use for providing hints to what memory needs to be freed. I am assuming
this is safe to do as the deflate logic does not actually appear to do very
much other than tracking what subpages have been released and which ones
haven't.

I suspect this is still a bit crude and will need some more work.
Suggestions welcome.

Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
---
 hw/virtio/trace-events                          |    1 
 hw/virtio/virtio-balloon.c                      |   85 +++++++++++++++++++++++
 include/hw/virtio/virtio-balloon.h              |    2 -
 include/standard-headers/linux/virtio_balloon.h |    1 
 4 files changed, 88 insertions(+), 1 deletion(-)

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
index 2112874055fb..eb819ec8f436 100644
--- a/hw/virtio/virtio-balloon.c
+++ b/hw/virtio/virtio-balloon.c
@@ -34,6 +34,13 @@
 
 #define BALLOON_PAGE_SIZE  (1 << VIRTIO_BALLOON_PFN_SHIFT)
 
+struct guest_pages {
+	unsigned long pfn;
+	unsigned int order;
+};
+
+void page_hinting_request(uint64_t addr, uint32_t len);
+
 struct PartiallyBalloonedPage {
     RAMBlock *rb;
     ram_addr_t base;
@@ -328,6 +335,80 @@ static void balloon_stats_set_poll_interval(Object *obj, Visitor *v,
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
+	struct {
+            uint32_t pfn;
+            uint32_t size;
+	} hint;
+
+        elem = virtqueue_pop(vq, sizeof(VirtQueueElement));
+        if (!elem) {
+            return;
+        }
+
+        while (iov_to_buf(elem->out_sg, elem->out_num, offset, &hint, 8) == 8) {
+            size_t size = virtio_ldl_p(vdev, &hint.size);
+            hwaddr pa = virtio_ldl_p(vdev, &hint.pfn);
+
+            offset += 8;
+
+            if (qemu_balloon_is_inhibited())
+                continue;
+
+            pa <<= VIRTIO_BALLOON_PFN_SHIFT;
+            size <<= VIRTIO_BALLOON_PFN_SHIFT;
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
@@ -694,6 +775,7 @@ static uint64_t virtio_balloon_get_features(VirtIODevice *vdev, uint64_t f,
     VirtIOBalloon *dev = VIRTIO_BALLOON(vdev);
     f |= dev->host_features;
     virtio_add_feature(&f, VIRTIO_BALLOON_F_STATS_VQ);
+    virtio_add_feature(&f, VIRTIO_BALLOON_F_HINTING);
 
     return f;
 }
@@ -780,6 +862,7 @@ static void virtio_balloon_device_realize(DeviceState *dev, Error **errp)
     s->ivq = virtio_add_queue(vdev, 128, virtio_balloon_handle_output);
     s->dvq = virtio_add_queue(vdev, 128, virtio_balloon_handle_output);
     s->svq = virtio_add_queue(vdev, 128, virtio_balloon_receive_stats);
+    s->hvq = virtio_add_queue(vdev, 128, virtio_bubble_handle_output);
 
     if (virtio_has_feature(s->host_features,
                            VIRTIO_BALLOON_F_FREE_PAGE_HINT)) {
@@ -875,6 +958,8 @@ static void virtio_balloon_instance_init(Object *obj)
 
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

