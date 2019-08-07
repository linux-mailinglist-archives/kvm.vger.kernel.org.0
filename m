Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6ACF38562A
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2019 00:44:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389651AbfHGWn0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Aug 2019 18:43:26 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:36655 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389647AbfHGWnZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Aug 2019 18:43:25 -0400
Received: by mail-pl1-f193.google.com with SMTP id k8so42661275plt.3;
        Wed, 07 Aug 2019 15:43:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=R9EIePxtKgh7rutMNGBvqWvR/nyIQIv1yBQVlI6lc80=;
        b=mL9CoipYppYg9TvgaxvW3rlAJ3cRgHGNuMlvCCVxbFer5O88XcNEYdHLJUlBnTbmcS
         D/ddFTZlvnguCqCjBdBZojggBwQK+k4JAC6YJiDQvHJDhO06ebhFIn32qxshi0LUy1+9
         Q0Ows9tRakkUSbaQRO6KpylgPFrCPMuO07wxB1COscKMaI+XtA0OH+cZFiVNe9dib6gm
         NgU6IOL7XT9bjhTmkGvJFh2Db0VsELCYdDlsJiAQgp+5VECNKpiAyTKsm16d3r5Iw0nq
         3Ydx9X+Nkoy3/I1P2Mu70YRQgBmsBxk+5WIJsajIoHRW1MiyIuhr+3mzskgQR1lJWrD0
         3vKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=R9EIePxtKgh7rutMNGBvqWvR/nyIQIv1yBQVlI6lc80=;
        b=ryjpygGuKmoS6NqGBu2QchfJpWrttBCkofnEOgmgrf+urwFuuMCbNwTYNr7jmnnAs7
         rmyEk8j4Irs+aY5US8i2jQeorbQzxzA7tLR2wvZ81SbcGQkvUv71pupXrVLmvpTlt6rT
         FTdvPEdF8CSCuXwXAR+fsZz1FG40DdmPgrNm2btP+MOuSkWsndSe8gUy+9Qk8t2NUTOp
         yRaG0pHO/7K3PrgexugYsk9i98wDdLtoKuud4vX8oHQXPRZA7us14IMo3i3g9nrG+eW1
         gSxBtBd5LHWJm3mMFX8qB82ptu+B3FPhoXZVP7oe75dbYx8qmZ1Di4TqCcuUnEadpq6n
         dKsw==
X-Gm-Message-State: APjAAAVRQ2hXcjk7PLAk6q2mvOvusLkawmGLJDy5vIKh6+WiquL+sNVs
        PTUgollLxz6hF8/pBzlEyI4=
X-Google-Smtp-Source: APXvYqzt2235UK45pP6zV7IF86Iz17ZaDjI4fbCSaevrbzSonGjf1QqChod57+61jhscibCu/vVY4w==
X-Received: by 2002:a17:902:b212:: with SMTP id t18mr3980622plr.246.1565217804789;
        Wed, 07 Aug 2019 15:43:24 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id x67sm96679320pfb.21.2019.08.07.15.43.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Aug 2019 15:43:24 -0700 (PDT)
Subject: [PATCH v4 QEMU 3/3] virtio-balloon: Provide a interface for unused
 page reporting
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     nitesh@redhat.com, kvm@vger.kernel.org, david@redhat.com,
        mst@redhat.com, dave.hansen@intel.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org
Cc:     yang.zhang.wz@gmail.com, pagupta@redhat.com, riel@surriel.com,
        konrad.wilk@oracle.com, willy@infradead.org,
        lcapitulino@redhat.com, wei.w.wang@intel.com, aarcange@redhat.com,
        pbonzini@redhat.com, dan.j.williams@intel.com,
        alexander.h.duyck@linux.intel.com
Date:   Wed, 07 Aug 2019 15:43:23 -0700
Message-ID: <20190807224323.7333.15220.stgit@localhost.localdomain>
In-Reply-To: <20190807224037.6891.53512.stgit@localhost.localdomain>
References: <20190807224037.6891.53512.stgit@localhost.localdomain>
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

