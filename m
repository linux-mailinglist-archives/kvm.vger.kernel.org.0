Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8619A159C92
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 23:51:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727729AbgBKWvX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 17:51:23 -0500
Received: from mail-wr1-f48.google.com ([209.85.221.48]:45404 "EHLO
        mail-wr1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727199AbgBKWvX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 17:51:23 -0500
Received: by mail-wr1-f48.google.com with SMTP id g3so13519339wrs.12;
        Tue, 11 Feb 2020 14:51:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=V78oNbusAm5S3e7SX3vKPs7Z58CB44qhuhwypR7BDJE=;
        b=tkJ7JpujzDe/vkZ7f0cEcHQmCX/gFd6QYBQA87yNi8nsa73sXyMOvE9gt0JKVqF/r/
         KTFdJ8XrayTXODVP0ZiabnUGNw1sY5YptGY7Rtg+9WsToxeWxCw5FAzPSnYdQSbQPfpo
         Mw6eydDn+0mEwIVWLLN/j9SFgokKtCPEAnp8jgsuldgU1t6z3w9+DvoonjlyjSbzxfUv
         XyzRFsOezR4J7SqKC5wTkWiFkqzMVpJXClvc28OB8BNSdJPj2J4FYCjWq6niTxbg0GYP
         LnB2Hl/XE7Wp+INlpdJw/YIlure+u3hxuLlnHMbBnGccGd/X3+tqDF9tQ6haf7O9VI9S
         CRaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=V78oNbusAm5S3e7SX3vKPs7Z58CB44qhuhwypR7BDJE=;
        b=pnSwFWlQ+0r/xoMB2zSbSTr55IvdHFWu7HcfIDtcRwBKCuS1NlTjAV/TSozGKTMKIv
         S7LAJVEZzTMg2Fuv5H+1c1lLuevgChBxNIqx9BffS7KIMfBwBmK0dSy6Nxi38v6BsWej
         LNpA2HLQ6DrcWNzHYAcaXipr5aQUSPGfdMfopf/26ehcRrImgfXaFhfwv3YXj8knFmhp
         B+0QkDt60LV9diFBJxX1m3ya7wZ3w0URqKacw/Kj75rOIwLTxxUXO6EsPSXkUQ9aPuEz
         5SR7WbMXd4geqPSHjSgDZPexu2O85VZXn2RPfEJxsOOttFDrLPs0LDlcQqff5r6q9wpl
         LpCw==
X-Gm-Message-State: APjAAAVgB/1jpNGrcXONndne1UnCyEkSNS4wh90L2/8jAwVHC0oHNTy9
        +RZPxhuaSigT9nsfSL2RlUs=
X-Google-Smtp-Source: APXvYqyWvUNn0Zh0X0txT2rjYhlQesS3m83PdisyyeVh5FX2cc1ZW1sF6ykII9WMGQUBmq25CcQqBw==
X-Received: by 2002:a5d:4692:: with SMTP id u18mr11162348wrq.206.1581461480116;
        Tue, 11 Feb 2020 14:51:20 -0800 (PST)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id r1sm6869786wrx.11.2020.02.11.14.51.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 11 Feb 2020 14:51:19 -0800 (PST)
Subject: [PATCH v17 QEMU 1/3] virtio-ballon: Implement support for page
 poison tracking feature
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     virtio-dev@lists.oasis-open.org, kvm@vger.kernel.org,
        mst@redhat.com, david@redhat.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, akpm@linux-foundation.org
Cc:     yang.zhang.wz@gmail.com, pagupta@redhat.com,
        konrad.wilk@oracle.com, nitesh@redhat.com, riel@surriel.com,
        willy@infradead.org, lcapitulino@redhat.com, dave.hansen@intel.com,
        wei.w.wang@intel.com, aarcange@redhat.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, mhocko@kernel.org,
        mgorman@techsingularity.net, alexander.h.duyck@linux.intel.com,
        vbabka@suse.cz, osalvador@suse.de
Date:   Tue, 11 Feb 2020 14:51:14 -0800
Message-ID: <20200211225114.30409.17424.stgit@localhost.localdomain>
In-Reply-To: <20200211224416.29318.44077.stgit@localhost.localdomain>
References: <20200211224416.29318.44077.stgit@localhost.localdomain>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Alexander Duyck <alexander.h.duyck@linux.intel.com>

We need to make certain to advertise support for page poison tracking if
we want to actually get data on if the guest will be poisoning pages. So
if free page hinting is active we should add page poisoning support and
let the guest disable it if it isn't using it.

Page poisoning will result in a page being dirtied on free. As such we
cannot really avoid having to copy the page at least one more time since
we will need to write the poison value to the destination. As such we can
just ignore free page hinting if page poisoning is enabled as it will
actually reduce the work we have to do.

Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
---
 hw/virtio/virtio-balloon.c         |   25 +++++++++++++++++++++----
 include/hw/virtio/virtio-balloon.h |    1 +
 2 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/hw/virtio/virtio-balloon.c b/hw/virtio/virtio-balloon.c
index a4729f7fc930..455d85b7082f 100644
--- a/hw/virtio/virtio-balloon.c
+++ b/hw/virtio/virtio-balloon.c
@@ -531,6 +531,15 @@ static void virtio_balloon_free_page_start(VirtIOBalloon *s)
         return;
     }
 
+    /*
+     * If page poisoning is enabled then we probably shouldn't bother with
+     * the hinting since the poisoning will dirty the page and invalidate
+     * the work we are doing anyway.
+     */
+    if (virtio_vdev_has_feature(vdev, VIRTIO_BALLOON_F_PAGE_POISON)) {
+        return;
+    }
+
     if (s->free_page_report_cmd_id == UINT_MAX) {
         s->free_page_report_cmd_id =
                        VIRTIO_BALLOON_FREE_PAGE_REPORT_CMD_ID_MIN;
@@ -618,12 +627,10 @@ static size_t virtio_balloon_config_size(VirtIOBalloon *s)
     if (s->qemu_4_0_config_size) {
         return sizeof(struct virtio_balloon_config);
     }
-    if (virtio_has_feature(features, VIRTIO_BALLOON_F_PAGE_POISON)) {
+    if (virtio_has_feature(features, VIRTIO_BALLOON_F_PAGE_POISON) ||
+        virtio_has_feature(features, VIRTIO_BALLOON_F_FREE_PAGE_HINT)) {
         return sizeof(struct virtio_balloon_config);
     }
-    if (virtio_has_feature(features, VIRTIO_BALLOON_F_FREE_PAGE_HINT)) {
-        return offsetof(struct virtio_balloon_config, poison_val);
-    }
     return offsetof(struct virtio_balloon_config, free_page_report_cmd_id);
 }
 
@@ -634,6 +641,7 @@ static void virtio_balloon_get_config(VirtIODevice *vdev, uint8_t *config_data)
 
     config.num_pages = cpu_to_le32(dev->num_pages);
     config.actual = cpu_to_le32(dev->actual);
+    config.poison_val = cpu_to_le32(dev->poison_val);
 
     if (dev->free_page_report_status == FREE_PAGE_REPORT_S_REQUESTED) {
         config.free_page_report_cmd_id =
@@ -697,6 +705,8 @@ static void virtio_balloon_set_config(VirtIODevice *vdev,
         qapi_event_send_balloon_change(vm_ram_size -
                         ((ram_addr_t) dev->actual << VIRTIO_BALLOON_PFN_SHIFT));
     }
+    dev->poison_val = virtio_vdev_has_feature(vdev, VIRTIO_BALLOON_F_PAGE_POISON) ? 
+                      le32_to_cpu(config.poison_val) : 0;
     trace_virtio_balloon_set_config(dev->actual, oldactual);
 }
 
@@ -706,6 +716,9 @@ static uint64_t virtio_balloon_get_features(VirtIODevice *vdev, uint64_t f,
     VirtIOBalloon *dev = VIRTIO_BALLOON(vdev);
     f |= dev->host_features;
     virtio_add_feature(&f, VIRTIO_BALLOON_F_STATS_VQ);
+    if (virtio_has_feature(f, VIRTIO_BALLOON_F_FREE_PAGE_HINT)) {
+        virtio_add_feature(&f, VIRTIO_BALLOON_F_PAGE_POISON);
+    }
 
     return f;
 }
@@ -854,6 +867,8 @@ static void virtio_balloon_device_reset(VirtIODevice *vdev)
         g_free(s->stats_vq_elem);
         s->stats_vq_elem = NULL;
     }
+
+    s->poison_val = 0;
 }
 
 static void virtio_balloon_set_status(VirtIODevice *vdev, uint8_t status)
@@ -916,6 +931,8 @@ static Property virtio_balloon_properties[] = {
                     VIRTIO_BALLOON_F_DEFLATE_ON_OOM, false),
     DEFINE_PROP_BIT("free-page-hint", VirtIOBalloon, host_features,
                     VIRTIO_BALLOON_F_FREE_PAGE_HINT, false),
+    DEFINE_PROP_BIT("x-page-poison", VirtIOBalloon, host_features,
+                    VIRTIO_BALLOON_F_PAGE_POISON, false),
     /* QEMU 4.0 accidentally changed the config size even when free-page-hint
      * is disabled, resulting in QEMU 3.1 migration incompatibility.  This
      * property retains this quirk for QEMU 4.1 machine types.
diff --git a/include/hw/virtio/virtio-balloon.h b/include/hw/virtio/virtio-balloon.h
index d1c968d2376e..7fe78e5c14d7 100644
--- a/include/hw/virtio/virtio-balloon.h
+++ b/include/hw/virtio/virtio-balloon.h
@@ -70,6 +70,7 @@ typedef struct VirtIOBalloon {
     uint32_t host_features;
 
     bool qemu_4_0_config_size;
+    uint32_t poison_val;
 } VirtIOBalloon;
 
 #endif

