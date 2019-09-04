Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8133CA8962
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2019 21:24:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731316AbfIDPL6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Sep 2019 11:11:58 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:40429 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731212AbfIDPL6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Sep 2019 11:11:58 -0400
Received: by mail-pf1-f196.google.com with SMTP id x127so745688pfb.7;
        Wed, 04 Sep 2019 08:11:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=R9EIePxtKgh7rutMNGBvqWvR/nyIQIv1yBQVlI6lc80=;
        b=Icdioip/LrE7zC1LjFhruymYKz5CChvFweZFNaQHSt0elL4kf0rEcwoiDnrDAo4wsd
         lculUOTKABzUpllh/6JcZEK1C9+szQUevDm2233hJRsBXFMqL+lPRscj3lXDE/HHlbPc
         IBQXiIFzd2gHcYCAeLDhNUCB6KcdFk+xudcysNTpWBn1q0+V0ZbnDtTTKUv4dZtnXFTF
         SDeiUW0XA4dD6JYzcDZrrCDgkttwlOmQb5RhC2E0bY2x7KP9gIYZHnqGku9VfUVUpUzw
         weh3WeDoEkbWkXv/rneDrEogXrWTovdbhvtRNFXL0460yxwc4bSW4ENUncFhf71IfM/p
         s5zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=R9EIePxtKgh7rutMNGBvqWvR/nyIQIv1yBQVlI6lc80=;
        b=biJkbAYVTCLJT2t288O0Xzi4TBwUdQXD7EUJTsg82kb3u168n54OOKv/RXQk8cCnhE
         5iWHUdxvSwZRKkp1hp0ogU0RM0R1oINOZl1oQlhjdX1NXA4RgoXnImAIuxcwz2H9bYYz
         usUSSZVWPzMCJeF5RSZWlVXpvIBqIsNGaLCI9MtN5UYZAWN4tyFOJjrKFZ3px+FI71Sk
         r8A6v1cD9strkNxViDqLjjFE9QBRx8YMSy0Lq5LuGMh9mq+IqD5xE0D2r4GRgZrWB/Mm
         fGJC7wimp1MGEIn0jueSd5G5AhnPRcZIMtfY3z9WaPNVocBNFO/AjHq4eFj7PHnX4QY4
         GYzg==
X-Gm-Message-State: APjAAAXwQW3IySmrSuO9W53fgT79Yz796fVF51GkUMB012Lc0MiZF4/e
        DeQW89dygcAWX1qbQFy99zM=
X-Google-Smtp-Source: APXvYqz8hxh9LJuvHBkIwHPd7Zgipkz7Ryft0mOHwrXV6Llo7seFR+xT4mPT1M5fYnrbzjbkIZxxvQ==
X-Received: by 2002:a65:4505:: with SMTP id n5mr21223408pgq.301.1567609917279;
        Wed, 04 Sep 2019 08:11:57 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id q186sm11375401pfb.47.2019.09.04.08.11.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Sep 2019 08:11:56 -0700 (PDT)
Subject: [PATCH v7 QEMU 3/3] virtio-balloon: Provide a interface for unused
 page reporting
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     nitesh@redhat.com, kvm@vger.kernel.org, mst@redhat.com,
        david@redhat.com, dave.hansen@intel.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, virtio-dev@lists.oasis-open.org
Cc:     yang.zhang.wz@gmail.com, pagupta@redhat.com, riel@surriel.com,
        konrad.wilk@oracle.com, willy@infradead.org,
        lcapitulino@redhat.com, wei.w.wang@intel.com, aarcange@redhat.com,
        pbonzini@redhat.com, dan.j.williams@intel.com, mhocko@kernel.org,
        alexander.h.duyck@linux.intel.com, osalvador@suse.de
Date:   Wed, 04 Sep 2019 08:11:56 -0700
Message-ID: <20190904151156.14270.25192.stgit@localhost.localdomain>
In-Reply-To: <20190904150920.13848.32271.stgit@localhost.localdomain>
References: <20190904150920.13848.32271.stgit@localhost.localdomain>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Alexander Duyck <alexander.h.duyck@linux.intel.com>

Add support for what I am referring to as "unused page reporting".
Basically the idea is to function very similar to how the balloon works
in that we basically end up madvising the page as not being used. However
we don't really need to bother with any deflate type logic since the page
will be faulted back into the guest when it is read or written to.

This is meant to be a simplification of the existing balloon interface
to use for providing hints to what memory needs to be freed. I am assuming
this is safe to do as the deflate logic does not actually appear to do very
much other than tracking what subpages have been released and which ones
haven't.

Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
---
 hw/virtio/virtio-balloon.c         |   46 ++++++++++++++++++++++++++++++++++--
 include/hw/virtio/virtio-balloon.h |    2 +-
 2 files changed, 45 insertions(+), 3 deletions(-)

diff --git a/hw/virtio/virtio-balloon.c b/hw/virtio/virtio-balloon.c
index 003b3ebcfdfb..7a30df63bc77 100644
--- a/hw/virtio/virtio-balloon.c
+++ b/hw/virtio/virtio-balloon.c
@@ -320,6 +320,40 @@ static void balloon_stats_set_poll_interval(Object *obj, Visitor *v,
     balloon_stats_change_timer(s, 0);
 }
 
+static void virtio_balloon_handle_report(VirtIODevice *vdev, VirtQueue *vq)
+{
+    VirtIOBalloon *dev = VIRTIO_BALLOON(vdev);
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
+            if (qemu_balloon_is_inhibited() || dev->poison_val)
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
@@ -627,7 +661,8 @@ static size_t virtio_balloon_config_size(VirtIOBalloon *s)
         return sizeof(struct virtio_balloon_config);
     }
     if (virtio_has_feature(features, VIRTIO_BALLOON_F_PAGE_POISON) ||
-        virtio_has_feature(features, VIRTIO_BALLOON_F_FREE_PAGE_HINT)) {
+        virtio_has_feature(features, VIRTIO_BALLOON_F_FREE_PAGE_HINT) ||
+        virtio_has_feature(features, VIRTIO_BALLOON_F_REPORTING)) {
         return sizeof(struct virtio_balloon_config);
     }
     return offsetof(struct virtio_balloon_config, free_page_report_cmd_id);
@@ -715,7 +750,8 @@ static uint64_t virtio_balloon_get_features(VirtIODevice *vdev, uint64_t f,
     VirtIOBalloon *dev = VIRTIO_BALLOON(vdev);
     f |= dev->host_features;
     virtio_add_feature(&f, VIRTIO_BALLOON_F_STATS_VQ);
-    if (virtio_has_feature(f, VIRTIO_BALLOON_F_FREE_PAGE_HINT)) {
+    if (virtio_has_feature(f, VIRTIO_BALLOON_F_FREE_PAGE_HINT) ||
+        virtio_has_feature(f, VIRTIO_BALLOON_F_REPORTING)) {
         virtio_add_feature(&f, VIRTIO_BALLOON_F_PAGE_POISON);
     }
 
@@ -805,6 +841,10 @@ static void virtio_balloon_device_realize(DeviceState *dev, Error **errp)
     s->dvq = virtio_add_queue(vdev, 128, virtio_balloon_handle_output);
     s->svq = virtio_add_queue(vdev, 128, virtio_balloon_receive_stats);
 
+    if (virtio_has_feature(s->host_features, VIRTIO_BALLOON_F_REPORTING)) {
+        s->rvq = virtio_add_queue(vdev, 32, virtio_balloon_handle_report);
+    }
+
     if (virtio_has_feature(s->host_features,
                            VIRTIO_BALLOON_F_FREE_PAGE_HINT)) {
         s->free_page_vq = virtio_add_queue(vdev, VIRTQUEUE_MAX_SIZE,
@@ -931,6 +971,8 @@ static Property virtio_balloon_properties[] = {
      */
     DEFINE_PROP_BOOL("qemu-4-0-config-size", VirtIOBalloon,
                      qemu_4_0_config_size, false),
+    DEFINE_PROP_BIT("unused-page-reporting", VirtIOBalloon, host_features,
+                    VIRTIO_BALLOON_F_REPORTING, true),
     DEFINE_PROP_LINK("iothread", VirtIOBalloon, iothread, TYPE_IOTHREAD,
                      IOThread *),
     DEFINE_PROP_END_OF_LIST(),
diff --git a/include/hw/virtio/virtio-balloon.h b/include/hw/virtio/virtio-balloon.h
index 7fe78e5c14d7..db5bf7127112 100644
--- a/include/hw/virtio/virtio-balloon.h
+++ b/include/hw/virtio/virtio-balloon.h
@@ -42,7 +42,7 @@ enum virtio_balloon_free_page_report_status {
 
 typedef struct VirtIOBalloon {
     VirtIODevice parent_obj;
-    VirtQueue *ivq, *dvq, *svq, *free_page_vq;
+    VirtQueue *ivq, *dvq, *svq, *free_page_vq, *rvq;
     uint32_t free_page_report_status;
     uint32_t num_pages;
     uint32_t actual;

