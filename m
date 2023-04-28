Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 634E36F1834
	for <lists+kvm@lfdr.de>; Fri, 28 Apr 2023 14:41:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346092AbjD1MlT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Apr 2023 08:41:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345591AbjD1MlQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Apr 2023 08:41:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8A081720
        for <kvm@vger.kernel.org>; Fri, 28 Apr 2023 05:40:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682685627;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UIhiZvhw4a5alv+XgMvVCIKlM42FanA9cKWfI6IFspk=;
        b=jJnzCQu+lOf2mWMrIdBOyTJUJZUXllwU9+MBpSotHvS8yp7ctX80GOYjW3uRWaXnpSXSjq
        mXkwfSTw4JNCK0uOsdlkMipeVs/iWDz4kDlKdO+0XRAbCgz2AMq4F2OpiFrpTzMAsVJYd7
        Mwtw8ILvhh7CVxw6M5SNL3diGR0klSE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-209-kV5JVlKZNiyytNhpAR1xAQ-1; Fri, 28 Apr 2023 08:40:24 -0400
X-MC-Unique: kV5JVlKZNiyytNhpAR1xAQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B91A8887404;
        Fri, 28 Apr 2023 12:40:23 +0000 (UTC)
Received: from localhost (unknown [10.39.192.223])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B75B114171FF;
        Fri, 28 Apr 2023 12:40:22 +0000 (UTC)
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Thomas Huth <thuth@redhat.com>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        Raphael Norwitz <raphael.norwitz@nutanix.com>,
        Julia Suvorova <jusual@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aarushi Mehta <mehta.aaru20@gmail.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Kevin Wolf <kwolf@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        qemu-block@nongnu.org, Hanna Reitz <hreitz@redhat.com>,
        Fam Zheng <fam@euphon.net>,
        =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Sam Li <faithilikerun@gmail.com>,
        Dmitry Fomichev <dmitry.fomichev@wdc.com>
Subject: [PULL 10/17] block: introduce zone append write for zoned devices
Date:   Fri, 28 Apr 2023 08:39:47 -0400
Message-Id: <20230428123954.179035-11-stefanha@redhat.com>
In-Reply-To: <20230428123954.179035-1-stefanha@redhat.com>
References: <20230428123954.179035-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sam Li <faithilikerun@gmail.com>

A zone append command is a write operation that specifies the first
logical block of a zone as the write position. When writing to a zoned
block device using zone append, the byte offset of the call may point at
any position within the zone to which the data is being appended. Upon
completion the device will respond with the position where the data has
been written in the zone.

Signed-off-by: Sam Li <faithilikerun@gmail.com>
Reviewed-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Message-id: 20230427172339.3709-3-faithilikerun@gmail.com
Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 include/block/block-io.h          |  4 ++
 include/block/block_int-common.h  |  3 ++
 include/block/raw-aio.h           |  4 +-
 include/sysemu/block-backend-io.h |  9 +++++
 block/block-backend.c             | 61 +++++++++++++++++++++++++++++++
 block/file-posix.c                | 58 +++++++++++++++++++++++++----
 block/io.c                        | 27 ++++++++++++++
 block/io_uring.c                  |  4 ++
 block/linux-aio.c                 |  3 ++
 block/raw-format.c                |  8 ++++
 10 files changed, 173 insertions(+), 8 deletions(-)

diff --git a/include/block/block-io.h b/include/block/block-io.h
index 58f415ab64..f44e524a1c 100644
--- a/include/block/block-io.h
+++ b/include/block/block-io.h
@@ -119,6 +119,10 @@ int coroutine_fn GRAPH_RDLOCK bdrv_co_zone_report(BlockDriverState *bs,
 int coroutine_fn GRAPH_RDLOCK bdrv_co_zone_mgmt(BlockDriverState *bs,
                                                 BlockZoneOp op,
                                                 int64_t offset, int64_t len);
+int coroutine_fn GRAPH_RDLOCK bdrv_co_zone_append(BlockDriverState *bs,
+                                                  int64_t *offset,
+                                                  QEMUIOVector *qiov,
+                                                  BdrvRequestFlags flags);
 
 bool bdrv_can_write_zeroes_with_unmap(BlockDriverState *bs);
 int bdrv_block_status(BlockDriverState *bs, int64_t offset,
diff --git a/include/block/block_int-common.h b/include/block/block_int-common.h
index d138a399c7..9a20ff1768 100644
--- a/include/block/block_int-common.h
+++ b/include/block/block_int-common.h
@@ -722,6 +722,9 @@ struct BlockDriver {
             BlockZoneDescriptor *zones);
     int coroutine_fn (*bdrv_co_zone_mgmt)(BlockDriverState *bs, BlockZoneOp op,
             int64_t offset, int64_t len);
+    int coroutine_fn (*bdrv_co_zone_append)(BlockDriverState *bs,
+            int64_t *offset, QEMUIOVector *qiov,
+            BdrvRequestFlags flags);
 
     /* removable device specific */
     bool coroutine_fn GRAPH_RDLOCK_PTR (*bdrv_co_is_inserted)(
diff --git a/include/block/raw-aio.h b/include/block/raw-aio.h
index afb9bdf51b..0fe85ade77 100644
--- a/include/block/raw-aio.h
+++ b/include/block/raw-aio.h
@@ -30,6 +30,7 @@
 #define QEMU_AIO_TRUNCATE     0x0080
 #define QEMU_AIO_ZONE_REPORT  0x0100
 #define QEMU_AIO_ZONE_MGMT    0x0200
+#define QEMU_AIO_ZONE_APPEND  0x0400
 #define QEMU_AIO_TYPE_MASK \
         (QEMU_AIO_READ | \
          QEMU_AIO_WRITE | \
@@ -40,7 +41,8 @@
          QEMU_AIO_COPY_RANGE | \
          QEMU_AIO_TRUNCATE | \
          QEMU_AIO_ZONE_REPORT | \
-         QEMU_AIO_ZONE_MGMT)
+         QEMU_AIO_ZONE_MGMT | \
+         QEMU_AIO_ZONE_APPEND)
 
 /* AIO flags */
 #define QEMU_AIO_MISALIGNED   0x1000
diff --git a/include/sysemu/block-backend-io.h b/include/sysemu/block-backend-io.h
index eb1c1ebfec..d62a7ee773 100644
--- a/include/sysemu/block-backend-io.h
+++ b/include/sysemu/block-backend-io.h
@@ -53,6 +53,9 @@ BlockAIOCB *blk_aio_zone_report(BlockBackend *blk, int64_t offset,
 BlockAIOCB *blk_aio_zone_mgmt(BlockBackend *blk, BlockZoneOp op,
                               int64_t offset, int64_t len,
                               BlockCompletionFunc *cb, void *opaque);
+BlockAIOCB *blk_aio_zone_append(BlockBackend *blk, int64_t *offset,
+                                QEMUIOVector *qiov, BdrvRequestFlags flags,
+                                BlockCompletionFunc *cb, void *opaque);
 BlockAIOCB *blk_aio_pdiscard(BlockBackend *blk, int64_t offset, int64_t bytes,
                              BlockCompletionFunc *cb, void *opaque);
 void blk_aio_cancel_async(BlockAIOCB *acb);
@@ -208,6 +211,12 @@ int coroutine_fn blk_co_zone_mgmt(BlockBackend *blk, BlockZoneOp op,
                                   int64_t offset, int64_t len);
 int co_wrapper_mixed blk_zone_mgmt(BlockBackend *blk, BlockZoneOp op,
                                        int64_t offset, int64_t len);
+int coroutine_fn blk_co_zone_append(BlockBackend *blk, int64_t *offset,
+                                    QEMUIOVector *qiov,
+                                    BdrvRequestFlags flags);
+int co_wrapper_mixed blk_zone_append(BlockBackend *blk, int64_t *offset,
+                                         QEMUIOVector *qiov,
+                                         BdrvRequestFlags flags);
 
 int co_wrapper_mixed blk_pdiscard(BlockBackend *blk, int64_t offset,
                                   int64_t bytes);
diff --git a/block/block-backend.c b/block/block-backend.c
index 67722eb46d..aa8657e5c8 100644
--- a/block/block-backend.c
+++ b/block/block-backend.c
@@ -1929,6 +1929,45 @@ BlockAIOCB *blk_aio_zone_mgmt(BlockBackend *blk, BlockZoneOp op,
     return &acb->common;
 }
 
+static void coroutine_fn blk_aio_zone_append_entry(void *opaque)
+{
+    BlkAioEmAIOCB *acb = opaque;
+    BlkRwCo *rwco = &acb->rwco;
+
+    rwco->ret = blk_co_zone_append(rwco->blk, (int64_t *)(uintptr_t)acb->bytes,
+                                   rwco->iobuf, rwco->flags);
+    blk_aio_complete(acb);
+}
+
+BlockAIOCB *blk_aio_zone_append(BlockBackend *blk, int64_t *offset,
+                                QEMUIOVector *qiov, BdrvRequestFlags flags,
+                                BlockCompletionFunc *cb, void *opaque) {
+    BlkAioEmAIOCB *acb;
+    Coroutine *co;
+    IO_CODE();
+
+    blk_inc_in_flight(blk);
+    acb = blk_aio_get(&blk_aio_em_aiocb_info, blk, cb, opaque);
+    acb->rwco = (BlkRwCo) {
+        .blk    = blk,
+        .ret    = NOT_DONE,
+        .flags  = flags,
+        .iobuf  = qiov,
+    };
+    acb->bytes = (int64_t)(uintptr_t)offset;
+    acb->has_returned = false;
+
+    co = qemu_coroutine_create(blk_aio_zone_append_entry, acb);
+    aio_co_enter(blk_get_aio_context(blk), co);
+    acb->has_returned = true;
+    if (acb->rwco.ret != NOT_DONE) {
+        replay_bh_schedule_oneshot_event(blk_get_aio_context(blk),
+                                         blk_aio_complete_bh, acb);
+    }
+
+    return &acb->common;
+}
+
 /*
  * Send a zone_report command.
  * offset is a byte offset from the start of the device. No alignment
@@ -1982,6 +2021,28 @@ int coroutine_fn blk_co_zone_mgmt(BlockBackend *blk, BlockZoneOp op,
     return ret;
 }
 
+/*
+ * Send a zone_append command.
+ */
+int coroutine_fn blk_co_zone_append(BlockBackend *blk, int64_t *offset,
+        QEMUIOVector *qiov, BdrvRequestFlags flags)
+{
+    int ret;
+    IO_CODE();
+
+    blk_inc_in_flight(blk);
+    blk_wait_while_drained(blk);
+    GRAPH_RDLOCK_GUARD();
+    if (!blk_is_available(blk)) {
+        blk_dec_in_flight(blk);
+        return -ENOMEDIUM;
+    }
+
+    ret = bdrv_co_zone_append(blk_bs(blk), offset, qiov, flags);
+    blk_dec_in_flight(blk);
+    return ret;
+}
+
 void blk_drain(BlockBackend *blk)
 {
     BlockDriverState *bs = blk_bs(blk);
diff --git a/block/file-posix.c b/block/file-posix.c
index e7ad6bb4e7..8fca0eab7b 100644
--- a/block/file-posix.c
+++ b/block/file-posix.c
@@ -160,6 +160,7 @@ typedef struct BDRVRawState {
     bool has_write_zeroes:1;
     bool use_linux_aio:1;
     bool use_linux_io_uring:1;
+    int64_t *offset; /* offset of zone append operation */
     int page_cache_inconsistent; /* errno from fdatasync failure */
     bool has_fallocate;
     bool needs_alignment;
@@ -1702,7 +1703,7 @@ static ssize_t handle_aiocb_rw_vector(RawPosixAIOData *aiocb)
     ssize_t len;
 
     len = RETRY_ON_EINTR(
-        (aiocb->aio_type & QEMU_AIO_WRITE) ?
+        (aiocb->aio_type & (QEMU_AIO_WRITE | QEMU_AIO_ZONE_APPEND)) ?
             qemu_pwritev(aiocb->aio_fildes,
                            aiocb->io.iov,
                            aiocb->io.niov,
@@ -1731,7 +1732,7 @@ static ssize_t handle_aiocb_rw_linear(RawPosixAIOData *aiocb, char *buf)
     ssize_t len;
 
     while (offset < aiocb->aio_nbytes) {
-        if (aiocb->aio_type & QEMU_AIO_WRITE) {
+        if (aiocb->aio_type & (QEMU_AIO_WRITE | QEMU_AIO_ZONE_APPEND)) {
             len = pwrite(aiocb->aio_fildes,
                          (const char *)buf + offset,
                          aiocb->aio_nbytes - offset,
@@ -1824,7 +1825,7 @@ static int handle_aiocb_rw(void *opaque)
     }
 
     nbytes = handle_aiocb_rw_linear(aiocb, buf);
-    if (!(aiocb->aio_type & QEMU_AIO_WRITE)) {
+    if (!(aiocb->aio_type & (QEMU_AIO_WRITE | QEMU_AIO_ZONE_APPEND))) {
         char *p = buf;
         size_t count = aiocb->aio_nbytes, copy;
         int i;
@@ -2457,8 +2458,12 @@ static int coroutine_fn raw_co_prw(BlockDriverState *bs, uint64_t offset,
     if (fd_open(bs) < 0)
         return -EIO;
 #if defined(CONFIG_BLKZONED)
-    if (type & QEMU_AIO_WRITE && bs->wps) {
+    if ((type & (QEMU_AIO_WRITE | QEMU_AIO_ZONE_APPEND)) && bs->wps) {
         qemu_co_mutex_lock(&bs->wps->colock);
+        if (type & QEMU_AIO_ZONE_APPEND && bs->bl.zone_size) {
+            int index = offset / bs->bl.zone_size;
+            offset = bs->wps->wp[index];
+        }
     }
 #endif
 
@@ -2506,9 +2511,13 @@ out:
 {
     BlockZoneWps *wps = bs->wps;
     if (ret == 0) {
-        if (type & QEMU_AIO_WRITE && wps && bs->bl.zone_size) {
+        if ((type & (QEMU_AIO_WRITE | QEMU_AIO_ZONE_APPEND))
+            && wps && bs->bl.zone_size) {
             uint64_t *wp = &wps->wp[offset / bs->bl.zone_size];
             if (!BDRV_ZT_IS_CONV(*wp)) {
+                if (type & QEMU_AIO_ZONE_APPEND) {
+                    *s->offset = *wp;
+                }
                 /* Advance the wp if needed */
                 if (offset + bytes > *wp) {
                     *wp = offset + bytes;
@@ -2516,12 +2525,12 @@ out:
             }
         }
     } else {
-        if (type & QEMU_AIO_WRITE) {
+        if (type & (QEMU_AIO_WRITE | QEMU_AIO_ZONE_APPEND)) {
             update_zones_wp(bs, s->fd, 0, 1);
         }
     }
 
-    if (type & QEMU_AIO_WRITE && wps) {
+    if ((type & (QEMU_AIO_WRITE | QEMU_AIO_ZONE_APPEND)) && wps) {
         qemu_co_mutex_unlock(&wps->colock);
     }
 }
@@ -3519,6 +3528,40 @@ static int coroutine_fn raw_co_zone_mgmt(BlockDriverState *bs, BlockZoneOp op,
 }
 #endif
 
+#if defined(CONFIG_BLKZONED)
+static int coroutine_fn raw_co_zone_append(BlockDriverState *bs,
+                                           int64_t *offset,
+                                           QEMUIOVector *qiov,
+                                           BdrvRequestFlags flags) {
+    assert(flags == 0);
+    int64_t zone_size_mask = bs->bl.zone_size - 1;
+    int64_t iov_len = 0;
+    int64_t len = 0;
+    BDRVRawState *s = bs->opaque;
+    s->offset = offset;
+
+    if (*offset & zone_size_mask) {
+        error_report("sector offset %" PRId64 " is not aligned to zone size "
+                     "%" PRId32 "", *offset / 512, bs->bl.zone_size / 512);
+        return -EINVAL;
+    }
+
+    int64_t wg = bs->bl.write_granularity;
+    int64_t wg_mask = wg - 1;
+    for (int i = 0; i < qiov->niov; i++) {
+        iov_len = qiov->iov[i].iov_len;
+        if (iov_len & wg_mask) {
+            error_report("len of IOVector[%d] %" PRId64 " is not aligned to "
+                         "block size %" PRId64 "", i, iov_len, wg);
+            return -EINVAL;
+        }
+        len += iov_len;
+    }
+
+    return raw_co_prw(bs, *offset, len, qiov, QEMU_AIO_ZONE_APPEND);
+}
+#endif
+
 static coroutine_fn int
 raw_do_pdiscard(BlockDriverState *bs, int64_t offset, int64_t bytes,
                 bool blkdev)
@@ -4280,6 +4323,7 @@ static BlockDriver bdrv_host_device = {
     /* zone management operations */
     .bdrv_co_zone_report = raw_co_zone_report,
     .bdrv_co_zone_mgmt = raw_co_zone_mgmt,
+    .bdrv_co_zone_append = raw_co_zone_append,
 #endif
 };
 
diff --git a/block/io.c b/block/io.c
index 74bab69b0f..20d1da8dc9 100644
--- a/block/io.c
+++ b/block/io.c
@@ -3156,6 +3156,33 @@ out:
     return co.ret;
 }
 
+int coroutine_fn bdrv_co_zone_append(BlockDriverState *bs, int64_t *offset,
+                        QEMUIOVector *qiov,
+                        BdrvRequestFlags flags)
+{
+    int ret;
+    BlockDriver *drv = bs->drv;
+    CoroutineIOCompletion co = {
+            .coroutine = qemu_coroutine_self(),
+    };
+    IO_CODE();
+
+    ret = bdrv_check_qiov_request(*offset, qiov->size, qiov, 0, NULL);
+    if (ret < 0) {
+        return ret;
+    }
+
+    bdrv_inc_in_flight(bs);
+    if (!drv || !drv->bdrv_co_zone_append || bs->bl.zoned == BLK_Z_NONE) {
+        co.ret = -ENOTSUP;
+        goto out;
+    }
+    co.ret = drv->bdrv_co_zone_append(bs, offset, qiov, flags);
+out:
+    bdrv_dec_in_flight(bs);
+    return co.ret;
+}
+
 void *qemu_blockalign(BlockDriverState *bs, size_t size)
 {
     IO_CODE();
diff --git a/block/io_uring.c b/block/io_uring.c
index 989f9a99ed..82cab6a5bd 100644
--- a/block/io_uring.c
+++ b/block/io_uring.c
@@ -350,6 +350,10 @@ static int luring_do_submit(int fd, LuringAIOCB *luringcb, LuringState *s,
         io_uring_prep_writev(sqes, fd, luringcb->qiov->iov,
                              luringcb->qiov->niov, offset);
         break;
+    case QEMU_AIO_ZONE_APPEND:
+        io_uring_prep_writev(sqes, fd, luringcb->qiov->iov,
+                             luringcb->qiov->niov, offset);
+        break;
     case QEMU_AIO_READ:
         io_uring_prep_readv(sqes, fd, luringcb->qiov->iov,
                             luringcb->qiov->niov, offset);
diff --git a/block/linux-aio.c b/block/linux-aio.c
index fc50cdd1bf..442c86209b 100644
--- a/block/linux-aio.c
+++ b/block/linux-aio.c
@@ -394,6 +394,9 @@ static int laio_do_submit(int fd, struct qemu_laiocb *laiocb, off_t offset,
     case QEMU_AIO_WRITE:
         io_prep_pwritev(iocbs, fd, qiov->iov, qiov->niov, offset);
         break;
+    case QEMU_AIO_ZONE_APPEND:
+        io_prep_pwritev(iocbs, fd, qiov->iov, qiov->niov, offset);
+        break;
     case QEMU_AIO_READ:
         io_prep_preadv(iocbs, fd, qiov->iov, qiov->niov, offset);
         break;
diff --git a/block/raw-format.c b/block/raw-format.c
index 1a1dce8da4..9816f1af80 100644
--- a/block/raw-format.c
+++ b/block/raw-format.c
@@ -332,6 +332,13 @@ raw_co_zone_mgmt(BlockDriverState *bs, BlockZoneOp op,
     return bdrv_co_zone_mgmt(bs->file->bs, op, offset, len);
 }
 
+static int coroutine_fn GRAPH_RDLOCK
+raw_co_zone_append(BlockDriverState *bs,int64_t *offset, QEMUIOVector *qiov,
+                   BdrvRequestFlags flags)
+{
+    return bdrv_co_zone_append(bs->file->bs, offset, qiov, flags);
+}
+
 static int64_t coroutine_fn GRAPH_RDLOCK
 raw_co_getlength(BlockDriverState *bs)
 {
@@ -637,6 +644,7 @@ BlockDriver bdrv_raw = {
     .bdrv_co_pdiscard     = &raw_co_pdiscard,
     .bdrv_co_zone_report  = &raw_co_zone_report,
     .bdrv_co_zone_mgmt  = &raw_co_zone_mgmt,
+    .bdrv_co_zone_append = &raw_co_zone_append,
     .bdrv_co_block_status = &raw_co_block_status,
     .bdrv_co_copy_range_from = &raw_co_copy_range_from,
     .bdrv_co_copy_range_to  = &raw_co_copy_range_to,
-- 
2.40.0

