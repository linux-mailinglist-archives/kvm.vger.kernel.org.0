Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 770E6E0E3C
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2019 00:30:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389371AbfJVW3k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Oct 2019 18:29:40 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:46703 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731220AbfJVW3j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Oct 2019 18:29:39 -0400
Received: by mail-pg1-f194.google.com with SMTP id e15so10798401pgu.13;
        Tue, 22 Oct 2019 15:29:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=IYnIZF3ya8GRMyw0Z8v44wRFjachYcZ/Qaw0Oz7Yqys=;
        b=iKFrq92yC0OttYiOPOr/01Xrnyzk4LoPd7Kcq49VUCN6eCevIwwnzOhDsuG7WKAr8O
         r/tdirFVwlmIF4XVYxJFp8SMy32fgK5tLn8fTB3UFfxB/f/ERF5gnBU0unC7O+CBNIaG
         tH/jGGoZpWYS3TUu0CBrAfDgx38RUWQa8YNRUFfb+XQZm2LuLisSnddhJdwMYa+hRLmi
         FG51Yo0v/rEZdthSazebVEJha9R7TzUojsB7wi/epBbyrsC21X825kMkvtdovDrYcAPU
         AkTswIZmv7maSnB0W+OsWy0E7hHp/Qc7EHAMeBROhHub00ymWR/lHhP7F1vKpuzss+SG
         pIVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=IYnIZF3ya8GRMyw0Z8v44wRFjachYcZ/Qaw0Oz7Yqys=;
        b=Yjq2JfBU9ZOjMtk/LOExbLGNNFPWL1PgdsGj+kJYRrEB34XcCzWsG8x668/jtvozc7
         laZ324v/becppJXKqIIpNTI38MC0yf8Wx1ULiSZ701PyGj6jVg6QHWgxQJ3FiTtnXUlb
         8+ubUBZ/idgA8qHVgEXXpYQ6MBLYsOfPhoaB2wdrKZPskwC/tC2KDcoduIjXBZyK06uT
         LJRNJ6k2BBOocyx06WETzvFamMU+DagtesVMpkmseDHE/wTTp3uCU5vMyHJaWJL9i3Ud
         1DmFaH3Fb+czSUYmPgVG3i6MwPLoSh2rvgUukIRKf9jkteeon1cmxSKeL3NeUz87u/v3
         pztg==
X-Gm-Message-State: APjAAAUIx1kaMpY63hy/1eYGzH7TK8HmmGtkDEGVCVb0oOCaJRq4hASZ
        pfLltarGuJtgwgvqqqKTEcE=
X-Google-Smtp-Source: APXvYqxYOPYId/zCW4hr+ch1HRgSCj3NHWSShCU2POCjbAJhcHE4hlH9edmKaMVP7+uqCPxzCvmVBA==
X-Received: by 2002:a65:4bc3:: with SMTP id p3mr6338350pgr.188.1571783378951;
        Tue, 22 Oct 2019 15:29:38 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id o123sm7482309pfg.161.2019.10.22.15.29.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 22 Oct 2019 15:29:38 -0700 (PDT)
Subject: [PATCH v12 QEMU 3/3] virtio-balloon: Provide a interface for unused
 page reporting
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     kvm@vger.kernel.org, mst@redhat.com, linux-kernel@vger.kernel.org,
        willy@infradead.org, mhocko@kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, mgorman@techsingularity.net,
        vbabka@suse.cz
Cc:     yang.zhang.wz@gmail.com, nitesh@redhat.com, konrad.wilk@oracle.com,
        david@redhat.com, pagupta@redhat.com, riel@surriel.com,
        lcapitulino@redhat.com, dave.hansen@intel.com,
        wei.w.wang@intel.com, aarcange@redhat.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, alexander.h.duyck@linux.intel.com,
        osalvador@suse.de
Date:   Tue, 22 Oct 2019 15:29:37 -0700
Message-ID: <20191022222937.17594.71516.stgit@localhost.localdomain>
In-Reply-To: <20191022221223.17338.5860.stgit@localhost.localdomain>
References: <20191022221223.17338.5860.stgit@localhost.localdomain>
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
index 6ecfec422309..47f253d016db 100644
--- a/hw/virtio/virtio-balloon.c
+++ b/hw/virtio/virtio-balloon.c
@@ -321,6 +321,40 @@ static void balloon_stats_set_poll_interval(Object *obj, Visitor *v,
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
@@ -628,7 +662,8 @@ static size_t virtio_balloon_config_size(VirtIOBalloon *s)
         return sizeof(struct virtio_balloon_config);
     }
     if (virtio_has_feature(features, VIRTIO_BALLOON_F_PAGE_POISON) ||
-        virtio_has_feature(features, VIRTIO_BALLOON_F_FREE_PAGE_HINT)) {
+        virtio_has_feature(features, VIRTIO_BALLOON_F_FREE_PAGE_HINT) ||
+        virtio_has_feature(features, VIRTIO_BALLOON_F_REPORTING)) {
         return sizeof(struct virtio_balloon_config);
     }
     return offsetof(struct virtio_balloon_config, free_page_report_cmd_id);
@@ -716,7 +751,8 @@ static uint64_t virtio_balloon_get_features(VirtIODevice *vdev, uint64_t f,
     VirtIOBalloon *dev = VIRTIO_BALLOON(vdev);
     f |= dev->host_features;
     virtio_add_feature(&f, VIRTIO_BALLOON_F_STATS_VQ);
-    if (virtio_has_feature(f, VIRTIO_BALLOON_F_FREE_PAGE_HINT)) {
+    if (virtio_has_feature(f, VIRTIO_BALLOON_F_FREE_PAGE_HINT) ||
+        virtio_has_feature(f, VIRTIO_BALLOON_F_REPORTING)) {
         virtio_add_feature(&f, VIRTIO_BALLOON_F_PAGE_POISON);
     }
 
@@ -806,6 +842,10 @@ static void virtio_balloon_device_realize(DeviceState *dev, Error **errp)
     s->dvq = virtio_add_queue(vdev, 128, virtio_balloon_handle_output);
     s->svq = virtio_add_queue(vdev, 128, virtio_balloon_receive_stats);
 
+    if (virtio_has_feature(s->host_features, VIRTIO_BALLOON_F_REPORTING)) {
+        s->rvq = virtio_add_queue(vdev, 32, virtio_balloon_handle_report);
+    }
+
     if (virtio_has_feature(s->host_features,
                            VIRTIO_BALLOON_F_FREE_PAGE_HINT)) {
         s->free_page_vq = virtio_add_queue(vdev, VIRTQUEUE_MAX_SIZE,
@@ -932,6 +972,8 @@ static Property virtio_balloon_properties[] = {
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

