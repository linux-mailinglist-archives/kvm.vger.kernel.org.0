Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5533B71A288
	for <lists+kvm@lfdr.de>; Thu,  1 Jun 2023 17:26:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234179AbjFAP0s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jun 2023 11:26:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232667AbjFAP0r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jun 2023 11:26:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1950D12C
        for <kvm@vger.kernel.org>; Thu,  1 Jun 2023 08:26:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685633163;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=56sRbxTeLa9JZmQN0B8QX1cUKslR1+CU7IhQ7z+Xw5c=;
        b=GCkuwf8h0D1LtK4V3BWWO1wPO2sc1DVJkTCtIhFcGyGlhYpjwWaTlpWQRzVf0JOOVSyviY
        na/7uaiR8Hk83dw628aGzhjSHM6gy3U4P+szTpluClOijLs8ZrJd3Eg6tF5EAJgAIBo/X2
        CE1M6fJUjTPa0UAgZ2DSnmCGKsmhUsw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-227-lWN_D032PEW-zCcOIkDfhw-1; Thu, 01 Jun 2023 11:25:59 -0400
X-MC-Unique: lWN_D032PEW-zCcOIkDfhw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 27AEA800159;
        Thu,  1 Jun 2023 15:25:59 +0000 (UTC)
Received: from localhost (unknown [10.39.194.5])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8A0932166B27;
        Thu,  1 Jun 2023 15:25:58 +0000 (UTC)
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     qemu-block@nongnu.org, Stefano Stabellini <sstabellini@kernel.org>,
        Aarushi Mehta <mehta.aaru20@gmail.com>,
        Anthony Perard <anthony.perard@citrix.com>,
        Thomas Huth <thuth@redhat.com>,
        Julia Suvorova <jusual@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Fam Zheng <fam@euphon.net>, Hanna Reitz <hreitz@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
        xen-devel@lists.xenproject.org, Paul Durrant <paul@xen.org>,
        Kevin Wolf <kwolf@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Eric Blake <eblake@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Raphael Norwitz <raphael.norwitz@nutanix.com>,
        kvm@vger.kernel.org
Subject: [PULL 2/8] block/nvme: convert to blk_io_plug_call() API
Date:   Thu,  1 Jun 2023 11:25:46 -0400
Message-Id: <20230601152552.1603119-3-stefanha@redhat.com>
In-Reply-To: <20230601152552.1603119-1-stefanha@redhat.com>
References: <20230601152552.1603119-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Stop using the .bdrv_co_io_plug() API because it is not multi-queue
block layer friendly. Use the new blk_io_plug_call() API to batch I/O
submission instead.

Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
Reviewed-by: Eric Blake <eblake@redhat.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Acked-by: Kevin Wolf <kwolf@redhat.com>
Message-id: 20230530180959.1108766-3-stefanha@redhat.com
Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 block/nvme.c       | 44 ++++++++++++--------------------------------
 block/trace-events |  1 -
 2 files changed, 12 insertions(+), 33 deletions(-)

diff --git a/block/nvme.c b/block/nvme.c
index 17937d398d..7ca85bc44a 100644
--- a/block/nvme.c
+++ b/block/nvme.c
@@ -25,6 +25,7 @@
 #include "qemu/vfio-helpers.h"
 #include "block/block-io.h"
 #include "block/block_int.h"
+#include "sysemu/block-backend.h"
 #include "sysemu/replay.h"
 #include "trace.h"
 
@@ -119,7 +120,6 @@ struct BDRVNVMeState {
     int blkshift;
 
     uint64_t max_transfer;
-    bool plugged;
 
     bool supports_write_zeroes;
     bool supports_discard;
@@ -282,7 +282,7 @@ static void nvme_kick(NVMeQueuePair *q)
 {
     BDRVNVMeState *s = q->s;
 
-    if (s->plugged || !q->need_kick) {
+    if (!q->need_kick) {
         return;
     }
     trace_nvme_kick(s, q->index);
@@ -387,10 +387,6 @@ static bool nvme_process_completion(NVMeQueuePair *q)
     NvmeCqe *c;
 
     trace_nvme_process_completion(s, q->index, q->inflight);
-    if (s->plugged) {
-        trace_nvme_process_completion_queue_plugged(s, q->index);
-        return false;
-    }
 
     /*
      * Support re-entrancy when a request cb() function invokes aio_poll().
@@ -480,6 +476,15 @@ static void nvme_trace_command(const NvmeCmd *cmd)
     }
 }
 
+static void nvme_unplug_fn(void *opaque)
+{
+    NVMeQueuePair *q = opaque;
+
+    QEMU_LOCK_GUARD(&q->lock);
+    nvme_kick(q);
+    nvme_process_completion(q);
+}
+
 static void nvme_submit_command(NVMeQueuePair *q, NVMeRequest *req,
                                 NvmeCmd *cmd, BlockCompletionFunc cb,
                                 void *opaque)
@@ -496,8 +501,7 @@ static void nvme_submit_command(NVMeQueuePair *q, NVMeRequest *req,
            q->sq.tail * NVME_SQ_ENTRY_BYTES, cmd, sizeof(*cmd));
     q->sq.tail = (q->sq.tail + 1) % NVME_QUEUE_SIZE;
     q->need_kick++;
-    nvme_kick(q);
-    nvme_process_completion(q);
+    blk_io_plug_call(nvme_unplug_fn, q);
     qemu_mutex_unlock(&q->lock);
 }
 
@@ -1567,27 +1571,6 @@ static void nvme_attach_aio_context(BlockDriverState *bs,
     }
 }
 
-static void coroutine_fn nvme_co_io_plug(BlockDriverState *bs)
-{
-    BDRVNVMeState *s = bs->opaque;
-    assert(!s->plugged);
-    s->plugged = true;
-}
-
-static void coroutine_fn nvme_co_io_unplug(BlockDriverState *bs)
-{
-    BDRVNVMeState *s = bs->opaque;
-    assert(s->plugged);
-    s->plugged = false;
-    for (unsigned i = INDEX_IO(0); i < s->queue_count; i++) {
-        NVMeQueuePair *q = s->queues[i];
-        qemu_mutex_lock(&q->lock);
-        nvme_kick(q);
-        nvme_process_completion(q);
-        qemu_mutex_unlock(&q->lock);
-    }
-}
-
 static bool nvme_register_buf(BlockDriverState *bs, void *host, size_t size,
                               Error **errp)
 {
@@ -1664,9 +1647,6 @@ static BlockDriver bdrv_nvme = {
     .bdrv_detach_aio_context  = nvme_detach_aio_context,
     .bdrv_attach_aio_context  = nvme_attach_aio_context,
 
-    .bdrv_co_io_plug          = nvme_co_io_plug,
-    .bdrv_co_io_unplug        = nvme_co_io_unplug,
-
     .bdrv_register_buf        = nvme_register_buf,
     .bdrv_unregister_buf      = nvme_unregister_buf,
 };
diff --git a/block/trace-events b/block/trace-events
index 32665158d6..048ad27519 100644
--- a/block/trace-events
+++ b/block/trace-events
@@ -141,7 +141,6 @@ nvme_kick(void *s, unsigned q_index) "s %p q #%u"
 nvme_dma_flush_queue_wait(void *s) "s %p"
 nvme_error(int cmd_specific, int sq_head, int sqid, int cid, int status) "cmd_specific %d sq_head %d sqid %d cid %d status 0x%x"
 nvme_process_completion(void *s, unsigned q_index, int inflight) "s %p q #%u inflight %d"
-nvme_process_completion_queue_plugged(void *s, unsigned q_index) "s %p q #%u"
 nvme_complete_command(void *s, unsigned q_index, int cid) "s %p q #%u cid %d"
 nvme_submit_command(void *s, unsigned q_index, int cid) "s %p q #%u cid %d"
 nvme_submit_command_raw(int c0, int c1, int c2, int c3, int c4, int c5, int c6, int c7) "%02x %02x %02x %02x %02x %02x %02x %02x"
-- 
2.40.1

