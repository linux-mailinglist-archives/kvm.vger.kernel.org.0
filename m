Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6266D7CAD35
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 17:19:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233765AbjJPPTl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 11:19:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233411AbjJPPTk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 11:19:40 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 384EEAB
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 08:19:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=CKGyyzKxuGsuwvI9v9sDpTYzNulOlzm/j1apww1tl2E=; b=uA3k1jxFkJRBbPY6r9+ROrl9xB
        Ed1eunSvi3H/KfvrxrT9lP5H2djfPrnFHcFygKZj4VcGF52CxaRrHRDnTZjj+UZ4Vmx3fme2ifd+8
        jLrO4NXss7pNWzjoHdrAHJMckswmA04WATXDPBzFy1GB/kwDx0q70Asa+juNKTadNvBADrARDRpaq
        qED7epYAiAoHEZ4Mc691xWO7fHvrFofp1UauU0/ULASJmdaKqcMU8KUj1WRBkHIk/dO85a0houl97
        suKAGPYQ0Sa9d51Ix6QAOP2so7mLXRySlKD02UAH/xsCQG0QNTs9AMYKlBF2zNqslKh21c7iwIGu8
        1TscSXxA==;
Received: from [2001:8b0:10b:1::ebe] (helo=i7.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qsPNC-006lqd-K5; Mon, 16 Oct 2023 15:19:14 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qsPNC-0005nm-0O;
        Mon, 16 Oct 2023 16:19:14 +0100
From:   David Woodhouse <dwmw2@infradead.org>
To:     qemu-devel@nongnu.org
Cc:     Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        Paul Durrant <paul@xen.org>,
        =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        David Woodhouse <dwmw2@infradead.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, qemu-block@nongnu.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org
Subject: [PATCH 11/12] hw/xen: automatically assign device index to block devices
Date:   Mon, 16 Oct 2023 16:19:08 +0100
Message-Id: <20231016151909.22133-12-dwmw2@infradead.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20231016151909.22133-1-dwmw2@infradead.org>
References: <20231016151909.22133-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

There's no need to force the user to assign a vdev. We can automatically
assign one, starting at xvda and searching until we find the first disk
name that's unused.

This means we can now allow '-drive if=xen,file=xxx' to work without an
explicit separate -driver argument, just like if=virtio.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 blockdev.c           | 15 ++++++++++++---
 hw/block/xen-block.c | 25 +++++++++++++++++++++++++
 2 files changed, 37 insertions(+), 3 deletions(-)

diff --git a/blockdev.c b/blockdev.c
index 325b7a3bef..9dec4c9c74 100644
--- a/blockdev.c
+++ b/blockdev.c
@@ -255,13 +255,13 @@ void drive_check_orphaned(void)
          * Ignore default drives, because we create certain default
          * drives unconditionally, then leave them unclaimed.  Not the
          * users fault.
-         * Ignore IF_VIRTIO, because it gets desugared into -device,
-         * so we can leave failing to -device.
+         * Ignore IF_VIRTIO or IF_XEN, because it gets desugared into
+         * -device, so we can leave failing to -device.
          * Ignore IF_NONE, because leaving unclaimed IF_NONE remains
          * available for device_add is a feature.
          */
         if (dinfo->is_default || dinfo->type == IF_VIRTIO
-            || dinfo->type == IF_NONE) {
+            || dinfo->type == IF_XEN || dinfo->type == IF_NONE) {
             continue;
         }
         if (!blk_get_attached_dev(blk)) {
@@ -977,6 +977,15 @@ DriveInfo *drive_new(QemuOpts *all_opts, BlockInterfaceType block_default_type,
         qemu_opt_set(devopts, "driver", "virtio-blk", &error_abort);
         qemu_opt_set(devopts, "drive", qdict_get_str(bs_opts, "id"),
                      &error_abort);
+    } else if (type == IF_XEN) {
+        QemuOpts *devopts;
+        devopts = qemu_opts_create(qemu_find_opts("device"), NULL, 0,
+                                   &error_abort);
+        qemu_opt_set(devopts, "driver",
+                     (media == MEDIA_CDROM) ? "xen-cdrom" : "xen-disk",
+                     &error_abort);
+        qemu_opt_set(devopts, "drive", qdict_get_str(bs_opts, "id"),
+                     &error_abort);
     }
 
     filename = qemu_opt_get(legacy_opts, "file");
diff --git a/hw/block/xen-block.c b/hw/block/xen-block.c
index 9262338535..20fa783cbe 100644
--- a/hw/block/xen-block.c
+++ b/hw/block/xen-block.c
@@ -34,6 +34,31 @@ static char *xen_block_get_name(XenDevice *xendev, Error **errp)
     XenBlockDevice *blockdev = XEN_BLOCK_DEVICE(xendev);
     XenBlockVdev *vdev = &blockdev->props.vdev;
 
+    if (blockdev->props.vdev.type == XEN_BLOCK_VDEV_TYPE_INVALID) {
+        char name[11];
+        int disk = 0;
+        unsigned long idx;
+
+        /* Find an unoccupied device name */
+        while (disk < (1 << 20)) {
+            if (disk < (1 << 4)) {
+                idx = (202 << 8) | (disk << 4);
+            } else {
+                idx = (1 << 28) | (disk << 8);
+            }
+            snprintf(name, sizeof(name), "%lu", idx);
+            if (!xen_backend_exists("qdisk", name)) {
+                vdev->type = XEN_BLOCK_VDEV_TYPE_XVD;
+                vdev->partition = 0;
+                vdev->disk = disk;
+                vdev->number = idx;
+                return g_strdup(name);
+            }
+            disk++;
+        }
+        error_setg(errp, "cannot find device vdev for block device");
+        return NULL;
+    }
     return g_strdup_printf("%lu", vdev->number);
 }
 
-- 
2.40.1

