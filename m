Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90A2571A296
	for <lists+kvm@lfdr.de>; Thu,  1 Jun 2023 17:27:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234350AbjFAP0w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jun 2023 11:26:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233818AbjFAP0u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jun 2023 11:26:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24C48134
        for <kvm@vger.kernel.org>; Thu,  1 Jun 2023 08:26:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685633164;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/KanOY4J9dCjz5B75DsOt8HVMCuzZufc1fAM7/vf+jo=;
        b=bdHA1MtumnETKswAD3ooM2yJrecYCRwtXgI70Jso4+ZwSUk8NnVOwOp6xC1OQvgJ06/rq7
        E5jsgmAJWgIbo4o6hwg2ZOmTav87LJu9On2qSKP0gRep865ZZX8i1hSwzQJA3MWppkwzfd
        L/m0EshstPY8g1ILq8o2BB9Wa9TDG8Q=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-623-0oUwZqO3Oui-d_EN81nNuQ-1; Thu, 01 Jun 2023 11:26:02 -0400
X-MC-Unique: 0oUwZqO3Oui-d_EN81nNuQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 41EFA3823A0B;
        Thu,  1 Jun 2023 15:26:01 +0000 (UTC)
Received: from localhost (unknown [10.39.194.5])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AC307492B0B;
        Thu,  1 Jun 2023 15:26:00 +0000 (UTC)
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
Subject: [PULL 3/8] block/blkio: convert to blk_io_plug_call() API
Date:   Thu,  1 Jun 2023 11:25:47 -0400
Message-Id: <20230601152552.1603119-4-stefanha@redhat.com>
In-Reply-To: <20230601152552.1603119-1-stefanha@redhat.com>
References: <20230601152552.1603119-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
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
Message-id: 20230530180959.1108766-4-stefanha@redhat.com
Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 block/blkio.c | 43 ++++++++++++++++++++++++-------------------
 1 file changed, 24 insertions(+), 19 deletions(-)

diff --git a/block/blkio.c b/block/blkio.c
index 72117fa005..11be8787a3 100644
--- a/block/blkio.c
+++ b/block/blkio.c
@@ -17,6 +17,7 @@
 #include "qemu/error-report.h"
 #include "qapi/qmp/qdict.h"
 #include "qemu/module.h"
+#include "sysemu/block-backend.h"
 #include "exec/memory.h" /* for ram_block_discard_disable() */
 
 #include "block/block-io.h"
@@ -320,16 +321,30 @@ static void blkio_detach_aio_context(BlockDriverState *bs)
                        NULL, NULL, NULL);
 }
 
-/* Call with s->blkio_lock held to submit I/O after enqueuing a new request */
-static void blkio_submit_io(BlockDriverState *bs)
+/*
+ * Called by blk_io_unplug() or immediately if not plugged. Called without
+ * blkio_lock.
+ */
+static void blkio_unplug_fn(void *opaque)
 {
-    if (qatomic_read(&bs->io_plugged) == 0) {
-        BDRVBlkioState *s = bs->opaque;
+    BDRVBlkioState *s = opaque;
 
+    WITH_QEMU_LOCK_GUARD(&s->blkio_lock) {
         blkioq_do_io(s->blkioq, NULL, 0, 0, NULL);
     }
 }
 
+/*
+ * Schedule I/O submission after enqueuing a new request. Called without
+ * blkio_lock.
+ */
+static void blkio_submit_io(BlockDriverState *bs)
+{
+    BDRVBlkioState *s = bs->opaque;
+
+    blk_io_plug_call(blkio_unplug_fn, s);
+}
+
 static int coroutine_fn
 blkio_co_pdiscard(BlockDriverState *bs, int64_t offset, int64_t bytes)
 {
@@ -340,9 +355,9 @@ blkio_co_pdiscard(BlockDriverState *bs, int64_t offset, int64_t bytes)
 
     WITH_QEMU_LOCK_GUARD(&s->blkio_lock) {
         blkioq_discard(s->blkioq, offset, bytes, &cod, 0);
-        blkio_submit_io(bs);
     }
 
+    blkio_submit_io(bs);
     qemu_coroutine_yield();
     return cod.ret;
 }
@@ -373,9 +388,9 @@ blkio_co_preadv(BlockDriverState *bs, int64_t offset, int64_t bytes,
 
     WITH_QEMU_LOCK_GUARD(&s->blkio_lock) {
         blkioq_readv(s->blkioq, offset, iov, iovcnt, &cod, 0);
-        blkio_submit_io(bs);
     }
 
+    blkio_submit_io(bs);
     qemu_coroutine_yield();
 
     if (use_bounce_buffer) {
@@ -418,9 +433,9 @@ static int coroutine_fn blkio_co_pwritev(BlockDriverState *bs, int64_t offset,
 
     WITH_QEMU_LOCK_GUARD(&s->blkio_lock) {
         blkioq_writev(s->blkioq, offset, iov, iovcnt, &cod, blkio_flags);
-        blkio_submit_io(bs);
     }
 
+    blkio_submit_io(bs);
     qemu_coroutine_yield();
 
     if (use_bounce_buffer) {
@@ -439,9 +454,9 @@ static int coroutine_fn blkio_co_flush(BlockDriverState *bs)
 
     WITH_QEMU_LOCK_GUARD(&s->blkio_lock) {
         blkioq_flush(s->blkioq, &cod, 0);
-        blkio_submit_io(bs);
     }
 
+    blkio_submit_io(bs);
     qemu_coroutine_yield();
     return cod.ret;
 }
@@ -467,22 +482,13 @@ static int coroutine_fn blkio_co_pwrite_zeroes(BlockDriverState *bs,
 
     WITH_QEMU_LOCK_GUARD(&s->blkio_lock) {
         blkioq_write_zeroes(s->blkioq, offset, bytes, &cod, blkio_flags);
-        blkio_submit_io(bs);
     }
 
+    blkio_submit_io(bs);
     qemu_coroutine_yield();
     return cod.ret;
 }
 
-static void coroutine_fn blkio_co_io_unplug(BlockDriverState *bs)
-{
-    BDRVBlkioState *s = bs->opaque;
-
-    WITH_QEMU_LOCK_GUARD(&s->blkio_lock) {
-        blkio_submit_io(bs);
-    }
-}
-
 typedef enum {
     BMRR_OK,
     BMRR_SKIP,
@@ -1004,7 +1010,6 @@ static void blkio_refresh_limits(BlockDriverState *bs, Error **errp)
         .bdrv_co_pwritev         = blkio_co_pwritev, \
         .bdrv_co_flush_to_disk   = blkio_co_flush, \
         .bdrv_co_pwrite_zeroes   = blkio_co_pwrite_zeroes, \
-        .bdrv_co_io_unplug       = blkio_co_io_unplug, \
         .bdrv_refresh_limits     = blkio_refresh_limits, \
         .bdrv_register_buf       = blkio_register_buf, \
         .bdrv_unregister_buf     = blkio_unregister_buf, \
-- 
2.40.1

