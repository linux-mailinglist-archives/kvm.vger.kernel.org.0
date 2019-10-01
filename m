Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B329C3919
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2019 17:32:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389733AbfJAPbH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Oct 2019 11:31:07 -0400
Received: from mail-pf1-f181.google.com ([209.85.210.181]:39447 "EHLO
        mail-pf1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388916AbfJAPbG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Oct 2019 11:31:06 -0400
Received: by mail-pf1-f181.google.com with SMTP id v4so8249737pff.6;
        Tue, 01 Oct 2019 08:31:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=yOvpSx16yNanZpbvFfAUMxFv0SM7m3MFplEES/wscuI=;
        b=V8K9ubyPUrdpnrmSOAC73089fGmxD7KrIocxPwWm1QzVfdt3FcuTZEGONzAFdyth6u
         sGefLFPqh2EbWni4qEdxD2GIeZLuWpOLwO6ECoPUxIooVjs/9rQSXRaQVdUG+ywp/EH3
         dYWS5wMSb6sbqVPzIHlDDnm78+QO1dVNS1a8IVvIxM/fZnkZ/OnRRywNonMqTz3cN+cw
         gkYozCp/HqkY2G471L9pfTKkYJ6N5IRWdIn+FYFCh/9eMNyT+KShuHDhu3W8u6O7/C3x
         iFdFYddCLvcLG/g6nYfLePdjN5uOwn1bcRm21Yegjb5L0reVWMxPb17QJEiLaSVhLtq+
         D1sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=yOvpSx16yNanZpbvFfAUMxFv0SM7m3MFplEES/wscuI=;
        b=URb7lOKry2qiFkGH/vmXLS+7U5SKxLM4DPw/W0s1CcGCT8Vy4QIKBQddBx+EbhHh4u
         YuLy4JXExFSfEOHjhequQuR8FbV9OqJe+rdi0xpzB2dnuWBex5b1agNtdfiqSy9C3qYW
         pzsMAj2ZhQsA7Gbgj1suCF3w3xjSoeHZuTFoVj1rt7KVZ4HrjZRNnKsYrCN/0/kq3Sdv
         WCt5RtBK7frQUEs/z0YGRUkNZZ7bpWg93O/76W9m8E/ZqcMmgOFsUb/a8Ixb6JxQ0cl8
         ADF/DrcTmZHq9lodqbO2GGpi+omTjZif7cZr+jhNv6hsIhKfWGVCNTb7c9DEDwonAeu7
         YmqA==
X-Gm-Message-State: APjAAAUyj6OdEpMZzDAf/7aC0po81jBRAvYzAErakTbleQzywZAU0C2Q
        ZNeibPoowLVr/TK5UMbrcvI=
X-Google-Smtp-Source: APXvYqy5jTzWyFjT2sA9x7lttfBhyQ4DIf4lDr9fYdux1MCucUsEe+ziZfR1t5cq8ZSqgxo/kOtPWg==
X-Received: by 2002:aa7:870a:: with SMTP id b10mr28512461pfo.5.1569943865813;
        Tue, 01 Oct 2019 08:31:05 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id l12sm21924491pgs.44.2019.10.01.08.31.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 01 Oct 2019 08:31:05 -0700 (PDT)
Subject: [PATCH v11 QEMU 1/3] virtio-ballon: Implement support for page
 poison tracking feature
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     virtio-dev@lists.oasis-open.org, kvm@vger.kernel.org,
        mst@redhat.com, david@redhat.com, dave.hansen@intel.com,
        linux-kernel@vger.kernel.org, willy@infradead.org,
        mhocko@kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org,
        mgorman@techsingularity.net, vbabka@suse.cz, osalvador@suse.de
Cc:     yang.zhang.wz@gmail.com, pagupta@redhat.com,
        konrad.wilk@oracle.com, nitesh@redhat.com, riel@surriel.com,
        lcapitulino@redhat.com, wei.w.wang@intel.com, aarcange@redhat.com,
        pbonzini@redhat.com, dan.j.williams@intel.com,
        alexander.h.duyck@linux.intel.com
Date:   Tue, 01 Oct 2019 08:31:04 -0700
Message-ID: <20191001153104.4422.12747.stgit@localhost.localdomain>
In-Reply-To: <20191001152441.27008.99285.stgit@localhost.localdomain>
References: <20191001152441.27008.99285.stgit@localhost.localdomain>
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
index 40b04f518028..6ecfec422309 100644
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
@@ -847,6 +860,8 @@ static void virtio_balloon_device_reset(VirtIODevice *vdev)
         g_free(s->stats_vq_elem);
         s->stats_vq_elem = NULL;
     }
+
+    s->poison_val = 0;
 }
 
 static void virtio_balloon_set_status(VirtIODevice *vdev, uint8_t status)
@@ -909,6 +924,8 @@ static Property virtio_balloon_properties[] = {
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

