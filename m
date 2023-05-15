Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7B4A70322E
	for <lists+kvm@lfdr.de>; Mon, 15 May 2023 18:06:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242529AbjEOQGs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 May 2023 12:06:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242421AbjEOQGq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 May 2023 12:06:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D86C91AD
        for <kvm@vger.kernel.org>; Mon, 15 May 2023 09:05:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1684166717;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3RTU0KY+AKCXPjAVGK6VFXmaxPmUepYrjaJ+R+ed10Q=;
        b=BBHXaFwuRGzuCApqC4C6ZKBorexkrqAXu5GfViLYoODVAUGLxshcJbZDToWN0MRLBh3nob
        SnUVKUrsuoPYc2erJI6CPJ5EVhHVFCQaFbp0TTw3DZjLpSS0c8WZcRHDMGDWMQWsTysuse
        b9U6vhNRfEA4UXEttvee+sOlGGvwdiI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-75-l7eNgC29NjOPNRIH-VThDg-1; Mon, 15 May 2023 12:05:15 -0400
X-MC-Unique: l7eNgC29NjOPNRIH-VThDg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0F424101A5D1;
        Mon, 15 May 2023 16:05:15 +0000 (UTC)
Received: from localhost (unknown [10.39.192.179])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1FD5C35453;
        Mon, 15 May 2023 16:05:13 +0000 (UTC)
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Richard Henderson <rth@twiddle.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        Julia Suvorova <jusual@redhat.com>,
        Aarushi Mehta <mehta.aaru20@gmail.com>,
        Kevin Wolf <kwolf@redhat.com>, kvm@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Raphael Norwitz <raphael.norwitz@nutanix.com>,
        qemu-block@nongnu.org, "Michael S. Tsirkin" <mst@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Hanna Reitz <hreitz@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Fam Zheng <fam@euphon.net>, Sam Li <faithilikerun@gmail.com>,
        Hannes Reinecke <hare@suse.de>,
        Dmitry Fomichev <dmitry.fomichev@wdc.com>
Subject: [PULL v2 03/16] block/block-backend: add block layer APIs resembling Linux ZonedBlockDevice ioctls
Date:   Mon, 15 May 2023 12:04:53 -0400
Message-Id: <20230515160506.1776883-4-stefanha@redhat.com>
In-Reply-To: <20230515160506.1776883-1-stefanha@redhat.com>
References: <20230515160506.1776883-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sam Li <faithilikerun@gmail.com>

Add zoned device option to host_device BlockDriver. It will be presented only
for zoned host block devices. By adding zone management operations to the
host_block_device BlockDriver, users can use the new block layer APIs
including Report Zone and four zone management operations
(open, close, finish, reset, reset_all).

Qemu-io uses the new APIs to perform zoned storage commands of the device:
zone_report(zrp), zone_open(zo), zone_close(zc), zone_reset(zrs),
zone_finish(zf).

For example, to test zone_report, use following command:
$ ./build/qemu-io --image-opts -n driver=host_device, filename=/dev/nullb0
-c "zrp offset nr_zones"

Signed-off-by: Sam Li <faithilikerun@gmail.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Reviewed-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Acked-by: Kevin Wolf <kwolf@redhat.com>
Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
Message-id: 20230508045533.175575-4-faithilikerun@gmail.com
Message-id: 20230324090605.28361-4-faithilikerun@gmail.com
[Adjust commit message prefix as suggested by Philippe Mathieu-Daudé
<philmd@linaro.org> and remove spurious ret = -errno in
raw_co_zone_mgmt().
--Stefan]
Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 meson.build                       |   5 +
 include/block/block-io.h          |   9 +
 include/block/block_int-common.h  |  21 ++
 include/block/raw-aio.h           |   6 +-
 include/sysemu/block-backend-io.h |  18 ++
 block/block-backend.c             | 137 +++++++++++++
 block/file-posix.c                | 313 +++++++++++++++++++++++++++++-
 block/io.c                        |  41 ++++
 qemu-io-cmds.c                    | 149 ++++++++++++++
 9 files changed, 696 insertions(+), 3 deletions(-)

diff --git a/meson.build b/meson.build
index d3cf48960b..25a4b9f2c1 100644
--- a/meson.build
+++ b/meson.build
@@ -2025,6 +2025,8 @@ if rdma.found()
 endif
 
 # has_header_symbol
+config_host_data.set('CONFIG_BLKZONED',
+                     cc.has_header_symbol('linux/blkzoned.h', 'BLKOPENZONE'))
 config_host_data.set('CONFIG_EPOLL_CREATE1',
                      cc.has_header_symbol('sys/epoll.h', 'epoll_create1'))
 config_host_data.set('CONFIG_FALLOCATE_PUNCH_HOLE',
@@ -2060,6 +2062,9 @@ config_host_data.set('HAVE_SIGEV_NOTIFY_THREAD_ID',
 config_host_data.set('HAVE_STRUCT_STAT_ST_ATIM',
                      cc.has_member('struct stat', 'st_atim',
                                    prefix: '#include <sys/stat.h>'))
+config_host_data.set('HAVE_BLK_ZONE_REP_CAPACITY',
+                     cc.has_member('struct blk_zone', 'capacity',
+                                   prefix: '#include <linux/blkzoned.h>'))
 
 # has_type
 config_host_data.set('CONFIG_IOVEC',
diff --git a/include/block/block-io.h b/include/block/block-io.h
index 1f612ec5bd..f099b204bc 100644
--- a/include/block/block-io.h
+++ b/include/block/block-io.h
@@ -114,6 +114,15 @@ int coroutine_fn GRAPH_RDLOCK bdrv_co_flush(BlockDriverState *bs);
 int coroutine_fn GRAPH_RDLOCK bdrv_co_pdiscard(BdrvChild *child, int64_t offset,
                                                int64_t bytes);
 
+/* Report zone information of zone block device. */
+int coroutine_fn GRAPH_RDLOCK bdrv_co_zone_report(BlockDriverState *bs,
+                                                  int64_t offset,
+                                                  unsigned int *nr_zones,
+                                                  BlockZoneDescriptor *zones);
+int coroutine_fn GRAPH_RDLOCK bdrv_co_zone_mgmt(BlockDriverState *bs,
+                                                BlockZoneOp op,
+                                                int64_t offset, int64_t len);
+
 bool bdrv_can_write_zeroes_with_unmap(BlockDriverState *bs);
 int bdrv_block_status(BlockDriverState *bs, int64_t offset,
                       int64_t bytes, int64_t *pnum, int64_t *map,
diff --git a/include/block/block_int-common.h b/include/block/block_int-common.h
index c7ca5a83e9..b2612f06ec 100644
--- a/include/block/block_int-common.h
+++ b/include/block/block_int-common.h
@@ -713,6 +713,12 @@ struct BlockDriver {
     int coroutine_fn GRAPH_RDLOCK_PTR (*bdrv_co_load_vmstate)(
         BlockDriverState *bs, QEMUIOVector *qiov, int64_t pos);
 
+    int coroutine_fn (*bdrv_co_zone_report)(BlockDriverState *bs,
+            int64_t offset, unsigned int *nr_zones,
+            BlockZoneDescriptor *zones);
+    int coroutine_fn (*bdrv_co_zone_mgmt)(BlockDriverState *bs, BlockZoneOp op,
+            int64_t offset, int64_t len);
+
     /* removable device specific */
     bool coroutine_fn GRAPH_RDLOCK_PTR (*bdrv_co_is_inserted)(
         BlockDriverState *bs);
@@ -865,6 +871,21 @@ typedef struct BlockLimits {
 
     /* device zone model */
     BlockZoneModel zoned;
+
+    /* zone size expressed in bytes */
+    uint32_t zone_size;
+
+    /* total number of zones */
+    uint32_t nr_zones;
+
+    /* maximum sectors of a zone append write operation */
+    uint32_t max_append_sectors;
+
+    /* maximum number of open zones */
+    uint32_t max_open_zones;
+
+    /* maximum number of active zones */
+    uint32_t max_active_zones;
 } BlockLimits;
 
 typedef struct BdrvOpBlocker BdrvOpBlocker;
diff --git a/include/block/raw-aio.h b/include/block/raw-aio.h
index e46a29c3f0..afb9bdf51b 100644
--- a/include/block/raw-aio.h
+++ b/include/block/raw-aio.h
@@ -28,6 +28,8 @@
 #define QEMU_AIO_WRITE_ZEROES 0x0020
 #define QEMU_AIO_COPY_RANGE   0x0040
 #define QEMU_AIO_TRUNCATE     0x0080
+#define QEMU_AIO_ZONE_REPORT  0x0100
+#define QEMU_AIO_ZONE_MGMT    0x0200
 #define QEMU_AIO_TYPE_MASK \
         (QEMU_AIO_READ | \
          QEMU_AIO_WRITE | \
@@ -36,7 +38,9 @@
          QEMU_AIO_DISCARD | \
          QEMU_AIO_WRITE_ZEROES | \
          QEMU_AIO_COPY_RANGE | \
-         QEMU_AIO_TRUNCATE)
+         QEMU_AIO_TRUNCATE | \
+         QEMU_AIO_ZONE_REPORT | \
+         QEMU_AIO_ZONE_MGMT)
 
 /* AIO flags */
 #define QEMU_AIO_MISALIGNED   0x1000
diff --git a/include/sysemu/block-backend-io.h b/include/sysemu/block-backend-io.h
index 851a44de96..eb1c1ebfec 100644
--- a/include/sysemu/block-backend-io.h
+++ b/include/sysemu/block-backend-io.h
@@ -46,6 +46,13 @@ BlockAIOCB *blk_aio_pwritev(BlockBackend *blk, int64_t offset,
                             BlockCompletionFunc *cb, void *opaque);
 BlockAIOCB *blk_aio_flush(BlockBackend *blk,
                           BlockCompletionFunc *cb, void *opaque);
+BlockAIOCB *blk_aio_zone_report(BlockBackend *blk, int64_t offset,
+                                unsigned int *nr_zones,
+                                BlockZoneDescriptor *zones,
+                                BlockCompletionFunc *cb, void *opaque);
+BlockAIOCB *blk_aio_zone_mgmt(BlockBackend *blk, BlockZoneOp op,
+                              int64_t offset, int64_t len,
+                              BlockCompletionFunc *cb, void *opaque);
 BlockAIOCB *blk_aio_pdiscard(BlockBackend *blk, int64_t offset, int64_t bytes,
                              BlockCompletionFunc *cb, void *opaque);
 void blk_aio_cancel_async(BlockAIOCB *acb);
@@ -191,6 +198,17 @@ int co_wrapper_mixed blk_pwrite_zeroes(BlockBackend *blk, int64_t offset,
 int coroutine_fn blk_co_pwrite_zeroes(BlockBackend *blk, int64_t offset,
                                       int64_t bytes, BdrvRequestFlags flags);
 
+int coroutine_fn blk_co_zone_report(BlockBackend *blk, int64_t offset,
+                                    unsigned int *nr_zones,
+                                    BlockZoneDescriptor *zones);
+int co_wrapper_mixed blk_zone_report(BlockBackend *blk, int64_t offset,
+                                         unsigned int *nr_zones,
+                                         BlockZoneDescriptor *zones);
+int coroutine_fn blk_co_zone_mgmt(BlockBackend *blk, BlockZoneOp op,
+                                  int64_t offset, int64_t len);
+int co_wrapper_mixed blk_zone_mgmt(BlockBackend *blk, BlockZoneOp op,
+                                       int64_t offset, int64_t len);
+
 int co_wrapper_mixed blk_pdiscard(BlockBackend *blk, int64_t offset,
                                   int64_t bytes);
 int coroutine_fn blk_co_pdiscard(BlockBackend *blk, int64_t offset,
diff --git a/block/block-backend.c b/block/block-backend.c
index e37d55d3e9..4a8d5c4b23 100644
--- a/block/block-backend.c
+++ b/block/block-backend.c
@@ -1845,6 +1845,143 @@ int coroutine_fn blk_co_flush(BlockBackend *blk)
     return ret;
 }
 
+static void coroutine_fn blk_aio_zone_report_entry(void *opaque)
+{
+    BlkAioEmAIOCB *acb = opaque;
+    BlkRwCo *rwco = &acb->rwco;
+
+    rwco->ret = blk_co_zone_report(rwco->blk, rwco->offset,
+                                   (unsigned int*)(uintptr_t)acb->bytes,
+                                   rwco->iobuf);
+    blk_aio_complete(acb);
+}
+
+BlockAIOCB *blk_aio_zone_report(BlockBackend *blk, int64_t offset,
+                                unsigned int *nr_zones,
+                                BlockZoneDescriptor  *zones,
+                                BlockCompletionFunc *cb, void *opaque)
+{
+    BlkAioEmAIOCB *acb;
+    Coroutine *co;
+    IO_CODE();
+
+    blk_inc_in_flight(blk);
+    acb = blk_aio_get(&blk_aio_em_aiocb_info, blk, cb, opaque);
+    acb->rwco = (BlkRwCo) {
+        .blk    = blk,
+        .offset = offset,
+        .iobuf  = zones,
+        .ret    = NOT_DONE,
+    };
+    acb->bytes = (int64_t)(uintptr_t)nr_zones,
+    acb->has_returned = false;
+
+    co = qemu_coroutine_create(blk_aio_zone_report_entry, acb);
+    aio_co_enter(blk_get_aio_context(blk), co);
+
+    acb->has_returned = true;
+    if (acb->rwco.ret != NOT_DONE) {
+        replay_bh_schedule_oneshot_event(blk_get_aio_context(blk),
+                                         blk_aio_complete_bh, acb);
+    }
+
+    return &acb->common;
+}
+
+static void coroutine_fn blk_aio_zone_mgmt_entry(void *opaque)
+{
+    BlkAioEmAIOCB *acb = opaque;
+    BlkRwCo *rwco = &acb->rwco;
+
+    rwco->ret = blk_co_zone_mgmt(rwco->blk,
+                                 (BlockZoneOp)(uintptr_t)rwco->iobuf,
+                                 rwco->offset, acb->bytes);
+    blk_aio_complete(acb);
+}
+
+BlockAIOCB *blk_aio_zone_mgmt(BlockBackend *blk, BlockZoneOp op,
+                              int64_t offset, int64_t len,
+                              BlockCompletionFunc *cb, void *opaque) {
+    BlkAioEmAIOCB *acb;
+    Coroutine *co;
+    IO_CODE();
+
+    blk_inc_in_flight(blk);
+    acb = blk_aio_get(&blk_aio_em_aiocb_info, blk, cb, opaque);
+    acb->rwco = (BlkRwCo) {
+        .blk    = blk,
+        .offset = offset,
+        .iobuf  = (void *)(uintptr_t)op,
+        .ret    = NOT_DONE,
+    };
+    acb->bytes = len;
+    acb->has_returned = false;
+
+    co = qemu_coroutine_create(blk_aio_zone_mgmt_entry, acb);
+    aio_co_enter(blk_get_aio_context(blk), co);
+
+    acb->has_returned = true;
+    if (acb->rwco.ret != NOT_DONE) {
+        replay_bh_schedule_oneshot_event(blk_get_aio_context(blk),
+                                         blk_aio_complete_bh, acb);
+    }
+
+    return &acb->common;
+}
+
+/*
+ * Send a zone_report command.
+ * offset is a byte offset from the start of the device. No alignment
+ * required for offset.
+ * nr_zones represents IN maximum and OUT actual.
+ */
+int coroutine_fn blk_co_zone_report(BlockBackend *blk, int64_t offset,
+                                    unsigned int *nr_zones,
+                                    BlockZoneDescriptor *zones)
+{
+    int ret;
+    IO_CODE();
+
+    blk_inc_in_flight(blk); /* increase before waiting */
+    blk_wait_while_drained(blk);
+    GRAPH_RDLOCK_GUARD();
+    if (!blk_is_available(blk)) {
+        blk_dec_in_flight(blk);
+        return -ENOMEDIUM;
+    }
+    ret = bdrv_co_zone_report(blk_bs(blk), offset, nr_zones, zones);
+    blk_dec_in_flight(blk);
+    return ret;
+}
+
+/*
+ * Send a zone_management command.
+ * op is the zone operation;
+ * offset is the byte offset from the start of the zoned device;
+ * len is the maximum number of bytes the command should operate on. It
+ * should be aligned with the device zone size.
+ */
+int coroutine_fn blk_co_zone_mgmt(BlockBackend *blk, BlockZoneOp op,
+        int64_t offset, int64_t len)
+{
+    int ret;
+    IO_CODE();
+
+    blk_inc_in_flight(blk);
+    blk_wait_while_drained(blk);
+    GRAPH_RDLOCK_GUARD();
+
+    ret = blk_check_byte_request(blk, offset, len);
+    if (ret < 0) {
+        blk_dec_in_flight(blk);
+        return ret;
+    }
+
+    ret = bdrv_co_zone_mgmt(blk_bs(blk), op, offset, len);
+    blk_dec_in_flight(blk);
+    return ret;
+}
+
 void blk_drain(BlockBackend *blk)
 {
     BlockDriverState *bs = blk_bs(blk);
diff --git a/block/file-posix.c b/block/file-posix.c
index 97c597a2a0..11eaa780df 100644
--- a/block/file-posix.c
+++ b/block/file-posix.c
@@ -68,6 +68,9 @@
 #include <sys/param.h>
 #include <sys/syscall.h>
 #include <sys/vfs.h>
+#if defined(CONFIG_BLKZONED)
+#include <linux/blkzoned.h>
+#endif
 #include <linux/cdrom.h>
 #include <linux/fd.h>
 #include <linux/fs.h>
@@ -216,6 +219,13 @@ typedef struct RawPosixAIOData {
             PreallocMode prealloc;
             Error **errp;
         } truncate;
+        struct {
+            unsigned int *nr_zones;
+            BlockZoneDescriptor *zones;
+        } zone_report;
+        struct {
+            unsigned long op;
+        } zone_mgmt;
     };
 } RawPosixAIOData;
 
@@ -1234,6 +1244,7 @@ static int get_sysfs_str_val(struct stat *st, const char *attribute,
 }
 #endif
 
+#if defined(CONFIG_BLKZONED)
 static int get_sysfs_zoned_model(struct stat *st, BlockZoneModel *zoned)
 {
     g_autofree char *val = NULL;
@@ -1255,6 +1266,7 @@ static int get_sysfs_zoned_model(struct stat *st, BlockZoneModel *zoned)
     }
     return 0;
 }
+#endif /* defined(CONFIG_BLKZONED) */
 
 /*
  * Get a sysfs attribute value as a long integer.
@@ -1298,6 +1310,7 @@ static int hdev_get_max_segments(int fd, struct stat *st)
 #endif
 }
 
+#if defined(CONFIG_BLKZONED)
 static void raw_refresh_zoned_limits(BlockDriverState *bs, struct stat *st,
                                      Error **errp)
 {
@@ -1311,7 +1324,54 @@ static void raw_refresh_zoned_limits(BlockDriverState *bs, struct stat *st,
         return;
     }
     bs->bl.zoned = zoned;
+
+    ret = get_sysfs_long_val(st, "max_open_zones");
+    if (ret >= 0) {
+        bs->bl.max_open_zones = ret;
+    }
+
+    ret = get_sysfs_long_val(st, "max_active_zones");
+    if (ret >= 0) {
+        bs->bl.max_active_zones = ret;
+    }
+
+    /*
+     * The zoned device must at least have zone size and nr_zones fields.
+     */
+    ret = get_sysfs_long_val(st, "chunk_sectors");
+    if (ret < 0) {
+        error_setg_errno(errp, -ret, "Unable to read chunk_sectors "
+                                     "sysfs attribute");
+        return;
+    } else if (!ret) {
+        error_setg(errp, "Read 0 from chunk_sectors sysfs attribute");
+        return;
+    }
+    bs->bl.zone_size = ret << BDRV_SECTOR_BITS;
+
+    ret = get_sysfs_long_val(st, "nr_zones");
+    if (ret < 0) {
+        error_setg_errno(errp, -ret, "Unable to read nr_zones "
+                                     "sysfs attribute");
+        return;
+    } else if (!ret) {
+        error_setg(errp, "Read 0 from nr_zones sysfs attribute");
+        return;
+    }
+    bs->bl.nr_zones = ret;
+
+    ret = get_sysfs_long_val(st, "zone_append_max_bytes");
+    if (ret > 0) {
+        bs->bl.max_append_sectors = ret >> BDRV_SECTOR_BITS;
+    }
 }
+#else /* !defined(CONFIG_BLKZONED) */
+static void raw_refresh_zoned_limits(BlockDriverState *bs, struct stat *st,
+                                     Error **errp)
+{
+    bs->bl.zoned = BLK_Z_NONE;
+}
+#endif /* !defined(CONFIG_BLKZONED) */
 
 static void raw_refresh_limits(BlockDriverState *bs, Error **errp)
 {
@@ -1379,9 +1439,12 @@ static int hdev_probe_blocksizes(BlockDriverState *bs, BlockSizes *bsz)
     BDRVRawState *s = bs->opaque;
     int ret;
 
-    /* If DASD, get blocksizes */
+    /* If DASD or zoned devices, get blocksizes */
     if (check_for_dasd(s->fd) < 0) {
-        return -ENOTSUP;
+        /* zoned devices are not DASD */
+        if (bs->bl.zoned == BLK_Z_NONE) {
+            return -ENOTSUP;
+        }
     }
     ret = probe_logical_blocksize(s->fd, &bsz->log);
     if (ret < 0) {
@@ -1849,6 +1912,147 @@ static off_t copy_file_range(int in_fd, off_t *in_off, int out_fd,
 }
 #endif
 
+/*
+ * parse_zone - Fill a zone descriptor
+ */
+#if defined(CONFIG_BLKZONED)
+static inline int parse_zone(struct BlockZoneDescriptor *zone,
+                              const struct blk_zone *blkz) {
+    zone->start = blkz->start << BDRV_SECTOR_BITS;
+    zone->length = blkz->len << BDRV_SECTOR_BITS;
+    zone->wp = blkz->wp << BDRV_SECTOR_BITS;
+
+#ifdef HAVE_BLK_ZONE_REP_CAPACITY
+    zone->cap = blkz->capacity << BDRV_SECTOR_BITS;
+#else
+    zone->cap = blkz->len << BDRV_SECTOR_BITS;
+#endif
+
+    switch (blkz->type) {
+    case BLK_ZONE_TYPE_SEQWRITE_REQ:
+        zone->type = BLK_ZT_SWR;
+        break;
+    case BLK_ZONE_TYPE_SEQWRITE_PREF:
+        zone->type = BLK_ZT_SWP;
+        break;
+    case BLK_ZONE_TYPE_CONVENTIONAL:
+        zone->type = BLK_ZT_CONV;
+        break;
+    default:
+        error_report("Unsupported zone type: 0x%x", blkz->type);
+        return -ENOTSUP;
+    }
+
+    switch (blkz->cond) {
+    case BLK_ZONE_COND_NOT_WP:
+        zone->state = BLK_ZS_NOT_WP;
+        break;
+    case BLK_ZONE_COND_EMPTY:
+        zone->state = BLK_ZS_EMPTY;
+        break;
+    case BLK_ZONE_COND_IMP_OPEN:
+        zone->state = BLK_ZS_IOPEN;
+        break;
+    case BLK_ZONE_COND_EXP_OPEN:
+        zone->state = BLK_ZS_EOPEN;
+        break;
+    case BLK_ZONE_COND_CLOSED:
+        zone->state = BLK_ZS_CLOSED;
+        break;
+    case BLK_ZONE_COND_READONLY:
+        zone->state = BLK_ZS_RDONLY;
+        break;
+    case BLK_ZONE_COND_FULL:
+        zone->state = BLK_ZS_FULL;
+        break;
+    case BLK_ZONE_COND_OFFLINE:
+        zone->state = BLK_ZS_OFFLINE;
+        break;
+    default:
+        error_report("Unsupported zone state: 0x%x", blkz->cond);
+        return -ENOTSUP;
+    }
+    return 0;
+}
+#endif
+
+#if defined(CONFIG_BLKZONED)
+static int handle_aiocb_zone_report(void *opaque)
+{
+    RawPosixAIOData *aiocb = opaque;
+    int fd = aiocb->aio_fildes;
+    unsigned int *nr_zones = aiocb->zone_report.nr_zones;
+    BlockZoneDescriptor *zones = aiocb->zone_report.zones;
+    /* zoned block devices use 512-byte sectors */
+    uint64_t sector = aiocb->aio_offset / 512;
+
+    struct blk_zone *blkz;
+    size_t rep_size;
+    unsigned int nrz;
+    int ret;
+    unsigned int n = 0, i = 0;
+
+    nrz = *nr_zones;
+    rep_size = sizeof(struct blk_zone_report) + nrz * sizeof(struct blk_zone);
+    g_autofree struct blk_zone_report *rep = NULL;
+    rep = g_malloc(rep_size);
+
+    blkz = (struct blk_zone *)(rep + 1);
+    while (n < nrz) {
+        memset(rep, 0, rep_size);
+        rep->sector = sector;
+        rep->nr_zones = nrz - n;
+
+        do {
+            ret = ioctl(fd, BLKREPORTZONE, rep);
+        } while (ret != 0 && errno == EINTR);
+        if (ret != 0) {
+            error_report("%d: ioctl BLKREPORTZONE at %" PRId64 " failed %d",
+                         fd, sector, errno);
+            return -errno;
+        }
+
+        if (!rep->nr_zones) {
+            break;
+        }
+
+        for (i = 0; i < rep->nr_zones; i++, n++) {
+            ret = parse_zone(&zones[n], &blkz[i]);
+            if (ret != 0) {
+                return ret;
+            }
+
+            /* The next report should start after the last zone reported */
+            sector = blkz[i].start + blkz[i].len;
+        }
+    }
+
+    *nr_zones = n;
+    return 0;
+}
+#endif
+
+#if defined(CONFIG_BLKZONED)
+static int handle_aiocb_zone_mgmt(void *opaque)
+{
+    RawPosixAIOData *aiocb = opaque;
+    int fd = aiocb->aio_fildes;
+    uint64_t sector = aiocb->aio_offset / 512;
+    int64_t nr_sectors = aiocb->aio_nbytes / 512;
+    struct blk_zone_range range;
+    int ret;
+
+    /* Execute the operation */
+    range.sector = sector;
+    range.nr_sectors = nr_sectors;
+    do {
+        ret = ioctl(fd, aiocb->zone_mgmt.op, &range);
+    } while (ret != 0 && errno == EINTR);
+
+    return ret;
+}
+#endif
+
 static int handle_aiocb_copy_range(void *opaque)
 {
     RawPosixAIOData *aiocb = opaque;
@@ -3028,6 +3232,104 @@ static void raw_account_discard(BDRVRawState *s, uint64_t nbytes, int ret)
     }
 }
 
+/*
+ * zone report - Get a zone block device's information in the form
+ * of an array of zone descriptors.
+ * zones is an array of zone descriptors to hold zone information on reply;
+ * offset can be any byte within the entire size of the device;
+ * nr_zones is the maxium number of sectors the command should operate on.
+ */
+#if defined(CONFIG_BLKZONED)
+static int coroutine_fn raw_co_zone_report(BlockDriverState *bs, int64_t offset,
+                                           unsigned int *nr_zones,
+                                           BlockZoneDescriptor *zones) {
+    BDRVRawState *s = bs->opaque;
+    RawPosixAIOData acb = (RawPosixAIOData) {
+        .bs         = bs,
+        .aio_fildes = s->fd,
+        .aio_type   = QEMU_AIO_ZONE_REPORT,
+        .aio_offset = offset,
+        .zone_report    = {
+            .nr_zones       = nr_zones,
+            .zones          = zones,
+        },
+    };
+
+    return raw_thread_pool_submit(handle_aiocb_zone_report, &acb);
+}
+#endif
+
+/*
+ * zone management operations - Execute an operation on a zone
+ */
+#if defined(CONFIG_BLKZONED)
+static int coroutine_fn raw_co_zone_mgmt(BlockDriverState *bs, BlockZoneOp op,
+        int64_t offset, int64_t len) {
+    BDRVRawState *s = bs->opaque;
+    RawPosixAIOData acb;
+    int64_t zone_size, zone_size_mask;
+    const char *op_name;
+    unsigned long zo;
+    int ret;
+    int64_t capacity = bs->total_sectors << BDRV_SECTOR_BITS;
+
+    zone_size = bs->bl.zone_size;
+    zone_size_mask = zone_size - 1;
+    if (offset & zone_size_mask) {
+        error_report("sector offset %" PRId64 " is not aligned to zone size "
+                     "%" PRId64 "", offset / 512, zone_size / 512);
+        return -EINVAL;
+    }
+
+    if (((offset + len) < capacity && len & zone_size_mask) ||
+        offset + len > capacity) {
+        error_report("number of sectors %" PRId64 " is not aligned to zone size"
+                      " %" PRId64 "", len / 512, zone_size / 512);
+        return -EINVAL;
+    }
+
+    switch (op) {
+    case BLK_ZO_OPEN:
+        op_name = "BLKOPENZONE";
+        zo = BLKOPENZONE;
+        break;
+    case BLK_ZO_CLOSE:
+        op_name = "BLKCLOSEZONE";
+        zo = BLKCLOSEZONE;
+        break;
+    case BLK_ZO_FINISH:
+        op_name = "BLKFINISHZONE";
+        zo = BLKFINISHZONE;
+        break;
+    case BLK_ZO_RESET:
+        op_name = "BLKRESETZONE";
+        zo = BLKRESETZONE;
+        break;
+    default:
+        error_report("Unsupported zone op: 0x%x", op);
+        return -ENOTSUP;
+    }
+
+    acb = (RawPosixAIOData) {
+        .bs             = bs,
+        .aio_fildes     = s->fd,
+        .aio_type       = QEMU_AIO_ZONE_MGMT,
+        .aio_offset     = offset,
+        .aio_nbytes     = len,
+        .zone_mgmt  = {
+            .op = zo,
+        },
+    };
+
+    ret = raw_thread_pool_submit(handle_aiocb_zone_mgmt, &acb);
+    if (ret != 0) {
+        error_report("ioctl %s failed %d", op_name, ret);
+    }
+
+    return ret;
+}
+#endif
+
 static coroutine_fn int
 raw_do_pdiscard(BlockDriverState *bs, int64_t offset, int64_t bytes,
                 bool blkdev)
@@ -3783,6 +4085,13 @@ static BlockDriver bdrv_host_device = {
 #ifdef __linux__
     .bdrv_co_ioctl          = hdev_co_ioctl,
 #endif
+
+    /* zoned device */
+#if defined(CONFIG_BLKZONED)
+    /* zone management operations */
+    .bdrv_co_zone_report = raw_co_zone_report,
+    .bdrv_co_zone_mgmt = raw_co_zone_mgmt,
+#endif
 };
 
 #if defined(__linux__) || defined(__FreeBSD__) || defined(__FreeBSD_kernel__)
diff --git a/block/io.c b/block/io.c
index 58557f2f96..12bf90e9bc 100644
--- a/block/io.c
+++ b/block/io.c
@@ -3113,6 +3113,47 @@ out:
     return co.ret;
 }
 
+int coroutine_fn bdrv_co_zone_report(BlockDriverState *bs, int64_t offset,
+                        unsigned int *nr_zones,
+                        BlockZoneDescriptor *zones)
+{
+    BlockDriver *drv = bs->drv;
+    CoroutineIOCompletion co = {
+            .coroutine = qemu_coroutine_self(),
+    };
+    IO_CODE();
+
+    bdrv_inc_in_flight(bs);
+    if (!drv || !drv->bdrv_co_zone_report || bs->bl.zoned == BLK_Z_NONE) {
+        co.ret = -ENOTSUP;
+        goto out;
+    }
+    co.ret = drv->bdrv_co_zone_report(bs, offset, nr_zones, zones);
+out:
+    bdrv_dec_in_flight(bs);
+    return co.ret;
+}
+
+int coroutine_fn bdrv_co_zone_mgmt(BlockDriverState *bs, BlockZoneOp op,
+        int64_t offset, int64_t len)
+{
+    BlockDriver *drv = bs->drv;
+    CoroutineIOCompletion co = {
+            .coroutine = qemu_coroutine_self(),
+    };
+    IO_CODE();
+
+    bdrv_inc_in_flight(bs);
+    if (!drv || !drv->bdrv_co_zone_mgmt || bs->bl.zoned == BLK_Z_NONE) {
+        co.ret = -ENOTSUP;
+        goto out;
+    }
+    co.ret = drv->bdrv_co_zone_mgmt(bs, op, offset, len);
+out:
+    bdrv_dec_in_flight(bs);
+    return co.ret;
+}
+
 void *qemu_blockalign(BlockDriverState *bs, size_t size)
 {
     IO_CODE();
diff --git a/qemu-io-cmds.c b/qemu-io-cmds.c
index e7a02f5b99..f35ea627d7 100644
--- a/qemu-io-cmds.c
+++ b/qemu-io-cmds.c
@@ -1730,6 +1730,150 @@ static const cmdinfo_t flush_cmd = {
     .oneline    = "flush all in-core file state to disk",
 };
 
+static inline int64_t tosector(int64_t bytes)
+{
+    return bytes >> BDRV_SECTOR_BITS;
+}
+
+static int zone_report_f(BlockBackend *blk, int argc, char **argv)
+{
+    int ret;
+    int64_t offset;
+    unsigned int nr_zones;
+
+    ++optind;
+    offset = cvtnum(argv[optind]);
+    ++optind;
+    nr_zones = cvtnum(argv[optind]);
+
+    g_autofree BlockZoneDescriptor *zones = NULL;
+    zones = g_new(BlockZoneDescriptor, nr_zones);
+    ret = blk_zone_report(blk, offset, &nr_zones, zones);
+    if (ret < 0) {
+        printf("zone report failed: %s\n", strerror(-ret));
+    } else {
+        for (int i = 0; i < nr_zones; ++i) {
+            printf("start: 0x%" PRIx64 ", len 0x%" PRIx64 ", "
+                   "cap"" 0x%" PRIx64 ", wptr 0x%" PRIx64 ", "
+                   "zcond:%u, [type: %u]\n",
+                    tosector(zones[i].start), tosector(zones[i].length),
+                    tosector(zones[i].cap), tosector(zones[i].wp),
+                    zones[i].state, zones[i].type);
+        }
+    }
+    return ret;
+}
+
+static const cmdinfo_t zone_report_cmd = {
+    .name = "zone_report",
+    .altname = "zrp",
+    .cfunc = zone_report_f,
+    .argmin = 2,
+    .argmax = 2,
+    .args = "offset number",
+    .oneline = "report zone information",
+};
+
+static int zone_open_f(BlockBackend *blk, int argc, char **argv)
+{
+    int ret;
+    int64_t offset, len;
+    ++optind;
+    offset = cvtnum(argv[optind]);
+    ++optind;
+    len = cvtnum(argv[optind]);
+    ret = blk_zone_mgmt(blk, BLK_ZO_OPEN, offset, len);
+    if (ret < 0) {
+        printf("zone open failed: %s\n", strerror(-ret));
+    }
+    return ret;
+}
+
+static const cmdinfo_t zone_open_cmd = {
+    .name = "zone_open",
+    .altname = "zo",
+    .cfunc = zone_open_f,
+    .argmin = 2,
+    .argmax = 2,
+    .args = "offset len",
+    .oneline = "explicit open a range of zones in zone block device",
+};
+
+static int zone_close_f(BlockBackend *blk, int argc, char **argv)
+{
+    int ret;
+    int64_t offset, len;
+    ++optind;
+    offset = cvtnum(argv[optind]);
+    ++optind;
+    len = cvtnum(argv[optind]);
+    ret = blk_zone_mgmt(blk, BLK_ZO_CLOSE, offset, len);
+    if (ret < 0) {
+        printf("zone close failed: %s\n", strerror(-ret));
+    }
+    return ret;
+}
+
+static const cmdinfo_t zone_close_cmd = {
+    .name = "zone_close",
+    .altname = "zc",
+    .cfunc = zone_close_f,
+    .argmin = 2,
+    .argmax = 2,
+    .args = "offset len",
+    .oneline = "close a range of zones in zone block device",
+};
+
+static int zone_finish_f(BlockBackend *blk, int argc, char **argv)
+{
+    int ret;
+    int64_t offset, len;
+    ++optind;
+    offset = cvtnum(argv[optind]);
+    ++optind;
+    len = cvtnum(argv[optind]);
+    ret = blk_zone_mgmt(blk, BLK_ZO_FINISH, offset, len);
+    if (ret < 0) {
+        printf("zone finish failed: %s\n", strerror(-ret));
+    }
+    return ret;
+}
+
+static const cmdinfo_t zone_finish_cmd = {
+    .name = "zone_finish",
+    .altname = "zf",
+    .cfunc = zone_finish_f,
+    .argmin = 2,
+    .argmax = 2,
+    .args = "offset len",
+    .oneline = "finish a range of zones in zone block device",
+};
+
+static int zone_reset_f(BlockBackend *blk, int argc, char **argv)
+{
+    int ret;
+    int64_t offset, len;
+    ++optind;
+    offset = cvtnum(argv[optind]);
+    ++optind;
+    len = cvtnum(argv[optind]);
+    ret = blk_zone_mgmt(blk, BLK_ZO_RESET, offset, len);
+    if (ret < 0) {
+        printf("zone reset failed: %s\n", strerror(-ret));
+    }
+    return ret;
+}
+
+static const cmdinfo_t zone_reset_cmd = {
+    .name = "zone_reset",
+    .altname = "zrs",
+    .cfunc = zone_reset_f,
+    .argmin = 2,
+    .argmax = 2,
+    .args = "offset len",
+    .oneline = "reset a zone write pointer in zone block device",
+};
+
 static int truncate_f(BlockBackend *blk, int argc, char **argv);
 static const cmdinfo_t truncate_cmd = {
     .name       = "truncate",
@@ -2523,6 +2667,11 @@ static void __attribute((constructor)) init_qemuio_commands(void)
     qemuio_add_command(&aio_write_cmd);
     qemuio_add_command(&aio_flush_cmd);
     qemuio_add_command(&flush_cmd);
+    qemuio_add_command(&zone_report_cmd);
+    qemuio_add_command(&zone_open_cmd);
+    qemuio_add_command(&zone_close_cmd);
+    qemuio_add_command(&zone_finish_cmd);
+    qemuio_add_command(&zone_reset_cmd);
     qemuio_add_command(&truncate_cmd);
     qemuio_add_command(&length_cmd);
     qemuio_add_command(&info_cmd);
-- 
2.40.1

