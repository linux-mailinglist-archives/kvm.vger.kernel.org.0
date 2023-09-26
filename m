Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE6997AF393
	for <lists+kvm@lfdr.de>; Tue, 26 Sep 2023 21:00:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235704AbjIZTAt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Sep 2023 15:00:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235643AbjIZTAp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Sep 2023 15:00:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F381919A
        for <kvm@vger.kernel.org>; Tue, 26 Sep 2023 11:59:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695754797;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ntTc+iP8L3yWrsrYKBBm9BSj/8eg/GV85E1SzdVW1Ig=;
        b=Q2y0WtSZzyGcFP73CsknjG8u6wwXqqRAr/640DLMGHNCQjqQMMDzXHjyrG1zY/5ZBIUJPO
        ebiuotlTCugL0xJKvJeNYpWUtwoTGqyC/4MA7Zo7Qy8pK7vUtNJt+jUw7KYz0rPCn4itH8
        hSIl7z3rBlnwroAA+dWn4qJF7O5+Gr4=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-86-yclTkQ33N6O_cZeOs2BOmA-1; Tue, 26 Sep 2023 14:59:52 -0400
X-MC-Unique: yclTkQ33N6O_cZeOs2BOmA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 46C3A3814581;
        Tue, 26 Sep 2023 18:59:52 +0000 (UTC)
Received: from t14s.fritz.box (unknown [10.39.192.33])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 75CBD2026D4B;
        Tue, 26 Sep 2023 18:59:47 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     David Hildenbrand <david@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        Michal Privoznik <mprivozn@redhat.com>,
        =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Maciej S . Szmigiero" <mail@maciej.szmigiero.name>,
        kvm@vger.kernel.org
Subject: [PATCH v4 15/18] virtio-mem: Update state to match bitmap as soon as it's been migrated
Date:   Tue, 26 Sep 2023 20:57:35 +0200
Message-ID: <20230926185738.277351-16-david@redhat.com>
In-Reply-To: <20230926185738.277351-1-david@redhat.com>
References: <20230926185738.277351-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,RCVD_IN_SBL_CSS,SPF_HELO_NONE,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It's cleaner and future-proof to just have other state that depends on the
bitmap state to be updated as soon as possible when restoring the bitmap.

So factor out informing RamDiscardListener into a functon and call it in
case of early migration right after we restored the bitmap.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 hw/virtio/virtio-mem.c | 26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/hw/virtio/virtio-mem.c b/hw/virtio/virtio-mem.c
index 0b0e6c5090..0cf47df9cf 100644
--- a/hw/virtio/virtio-mem.c
+++ b/hw/virtio/virtio-mem.c
@@ -984,9 +984,8 @@ static int virtio_mem_restore_unplugged(VirtIOMEM *vmem)
                                                virtio_mem_discard_range_cb);
 }
 
-static int virtio_mem_post_load(void *opaque, int version_id)
+static int virtio_mem_post_load_bitmap(VirtIOMEM *vmem)
 {
-    VirtIOMEM *vmem = VIRTIO_MEM(opaque);
     RamDiscardListener *rdl;
     int ret;
 
@@ -1001,6 +1000,20 @@ static int virtio_mem_post_load(void *opaque, int version_id)
             return ret;
         }
     }
+    return 0;
+}
+
+static int virtio_mem_post_load(void *opaque, int version_id)
+{
+    VirtIOMEM *vmem = VIRTIO_MEM(opaque);
+    int ret;
+
+    if (!vmem->early_migration) {
+        ret = virtio_mem_post_load_bitmap(vmem);
+        if (ret) {
+            return ret;
+        }
+    }
 
     /*
      * If shared RAM is migrated using the file content and not using QEMU,
@@ -1043,7 +1056,7 @@ static int virtio_mem_post_load_early(void *opaque, int version_id)
     int ret;
 
     if (!vmem->prealloc) {
-        return 0;
+        goto post_load_bitmap;
     }
 
     /*
@@ -1051,7 +1064,7 @@ static int virtio_mem_post_load_early(void *opaque, int version_id)
      * don't mess with preallocation and postcopy.
      */
     if (migrate_ram_is_ignored(rb)) {
-        return 0;
+        goto post_load_bitmap;
     }
 
     /*
@@ -1084,7 +1097,10 @@ static int virtio_mem_post_load_early(void *opaque, int version_id)
             return -EBUSY;
         }
     }
-    return 0;
+
+post_load_bitmap:
+    /* Finally, update any other state to be consistent with the new bitmap. */
+    return virtio_mem_post_load_bitmap(vmem);
 }
 
 typedef struct VirtIOMEMMigSanityChecks {
-- 
2.41.0

