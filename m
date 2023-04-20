Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59E736E93D4
	for <lists+kvm@lfdr.de>; Thu, 20 Apr 2023 14:11:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234602AbjDTMLX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Apr 2023 08:11:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234687AbjDTMLQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Apr 2023 08:11:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E5314C00
        for <kvm@vger.kernel.org>; Thu, 20 Apr 2023 05:10:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681992628;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Zv4qFHHFhKR8pNTeKmXr5iiv0yWC3pqkRu90BlIzQI0=;
        b=iqLpIBX1RGyueWetMwBvAcREFI9xa5tXzwcRIZ7p2V8JRkyHkxijztK9wHHONUudQcwStU
        p1RbpEbW0Be6hzx6iSwBtnIYdFIP8+h8vtGAHhAcP6slcnlQ1LlODwYbcwJg/b7oSxuw+b
        dZ+QrVawZVZf9H+K67rM4qVcpC1XfPk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-596-5isHoiuePLGfWf_qg1iF4Q-1; Thu, 20 Apr 2023 08:10:22 -0400
X-MC-Unique: 5isHoiuePLGfWf_qg1iF4Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 23B51811E7C;
        Thu, 20 Apr 2023 12:10:22 +0000 (UTC)
Received: from localhost (unknown [10.39.193.254])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 23D521121315;
        Thu, 20 Apr 2023 12:10:20 +0000 (UTC)
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Raphael Norwitz <raphael.norwitz@nutanix.com>,
        Kevin Wolf <kwolf@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Julia Suvorova <jusual@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Thomas Huth <thuth@redhat.com>, qemu-block@nongnu.org,
        Cornelia Huck <cohuck@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Stefano Garzarella <sgarzare@redhat.com>, kvm@vger.kernel.org,
        virtio-fs@redhat.com, Stefan Hajnoczi <stefanha@redhat.com>,
        Hanna Reitz <hreitz@redhat.com>, Fam Zheng <fam@euphon.net>,
        Aarushi Mehta <mehta.aaru20@gmail.com>,
        Sam Li <faithilikerun@gmail.com>
Subject: [PULL 11/20] file-posix: add tracking of the zone write pointers
Date:   Thu, 20 Apr 2023 08:09:39 -0400
Message-Id: <20230420120948.436661-12-stefanha@redhat.com>
In-Reply-To: <20230420120948.436661-1-stefanha@redhat.com>
References: <20230420120948.436661-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sam Li <faithilikerun@gmail.com>

Since Linux doesn't have a user API to issue zone append operations to
zoned devices from user space, the file-posix driver is modified to add
zone append emulation using regular writes. To do this, the file-posix
driver tracks the wp location of all zones of the device. It uses an
array of uint64_t. The most significant bit of each wp location indicates
if the zone type is conventional zones.

The zones wp can be changed due to the following operations issued:
- zone reset: change the wp to the start offset of that zone
- zone finish: change to the end location of that zone
- write to a zone
- zone append

Signed-off-by: Sam Li <faithilikerun@gmail.com>
Message-id: 20230407081657.17947-2-faithilikerun@gmail.com
Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 include/block/block-common.h     |  14 +++
 include/block/block_int-common.h |   5 +
 block/file-posix.c               | 173 ++++++++++++++++++++++++++++++-
 3 files changed, 189 insertions(+), 3 deletions(-)

diff --git a/include/block/block-common.h b/include/block/block-common.h
index 1576fcf2ed..93196229ac 100644
--- a/include/block/block-common.h
+++ b/include/block/block-common.h
@@ -118,6 +118,14 @@ typedef struct BlockZoneDescriptor {
     BlockZoneState state;
 } BlockZoneDescriptor;
 
+/*
+ * Track write pointers of a zone in bytes.
+ */
+typedef struct BlockZoneWps {
+    CoMutex colock;
+    uint64_t wp[];
+} BlockZoneWps;
+
 typedef struct BlockDriverInfo {
     /* in bytes, 0 if irrelevant */
     int cluster_size;
@@ -240,6 +248,12 @@ typedef enum {
 #define BDRV_SECTOR_BITS   9
 #define BDRV_SECTOR_SIZE   (1ULL << BDRV_SECTOR_BITS)
 
+/*
+ * Get the first most significant bit of wp. If it is zero, then
+ * the zone type is SWR.
+ */
+#define BDRV_ZT_IS_CONV(wp)    (wp & (1ULL << 63))
+
 #define BDRV_REQUEST_MAX_SECTORS MIN_CONST(SIZE_MAX >> BDRV_SECTOR_BITS, \
                                            INT_MAX >> BDRV_SECTOR_BITS)
 #define BDRV_REQUEST_MAX_BYTES (BDRV_REQUEST_MAX_SECTORS << BDRV_SECTOR_BITS)
diff --git a/include/block/block_int-common.h b/include/block/block_int-common.h
index 0164dc76e2..fba95181bd 100644
--- a/include/block/block_int-common.h
+++ b/include/block/block_int-common.h
@@ -890,6 +890,8 @@ typedef struct BlockLimits {
 
     /* maximum number of active zones */
     int64_t max_active_zones;
+
+    int64_t write_granularity;
 } BlockLimits;
 
 typedef struct BdrvOpBlocker BdrvOpBlocker;
@@ -1251,6 +1253,9 @@ struct BlockDriverState {
     CoMutex bsc_modify_lock;
     /* Always non-NULL, but must only be dereferenced under an RCU read guard */
     BdrvBlockStatusCache *block_status_cache;
+
+    /* array of write pointers' location of each zone in the zoned device. */
+    BlockZoneWps *wps;
 };
 
 struct BlockBackendRootState {
diff --git a/block/file-posix.c b/block/file-posix.c
index 88ec87de21..e6d0df052e 100644
--- a/block/file-posix.c
+++ b/block/file-posix.c
@@ -1324,6 +1324,90 @@ static int hdev_get_max_segments(int fd, struct stat *st)
 #endif
 }
 
+#if defined(CONFIG_BLKZONED)
+/*
+ * If the reset_all flag is true, then the wps of zone whose state is
+ * not readonly or offline should be all reset to the start sector.
+ * Else, take the real wp of the device.
+ */
+static int get_zones_wp(BlockDriverState *bs, int fd, int64_t offset,
+                        unsigned int nrz, bool reset_all)
+{
+    struct blk_zone *blkz;
+    size_t rep_size;
+    uint64_t sector = offset >> BDRV_SECTOR_BITS;
+    BlockZoneWps *wps = bs->wps;
+    int j = offset / bs->bl.zone_size;
+    int ret, n = 0, i = 0;
+    rep_size = sizeof(struct blk_zone_report) + nrz * sizeof(struct blk_zone);
+    g_autofree struct blk_zone_report *rep = NULL;
+
+    rep = g_malloc(rep_size);
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
+                    fd, offset, errno);
+            return -errno;
+        }
+
+        if (!rep->nr_zones) {
+            break;
+        }
+
+        for (i = 0; i < rep->nr_zones; ++i, ++n, ++j) {
+            /*
+             * The wp tracking cares only about sequential writes required and
+             * sequential write preferred zones so that the wp can advance to
+             * the right location.
+             * Use the most significant bit of the wp location to indicate the
+             * zone type: 0 for SWR/SWP zones and 1 for conventional zones.
+             */
+            if (blkz[i].type == BLK_ZONE_TYPE_CONVENTIONAL) {
+                wps->wp[j] |= 1ULL << 63;
+            } else {
+                switch(blkz[i].cond) {
+                case BLK_ZONE_COND_FULL:
+                case BLK_ZONE_COND_READONLY:
+                    /* Zone not writable */
+                    wps->wp[j] = (blkz[i].start + blkz[i].len) << BDRV_SECTOR_BITS;
+                    break;
+                case BLK_ZONE_COND_OFFLINE:
+                    /* Zone not writable nor readable */
+                    wps->wp[j] = (blkz[i].start) << BDRV_SECTOR_BITS;
+                    break;
+                default:
+                    if (reset_all) {
+                        wps->wp[j] = blkz[i].start << BDRV_SECTOR_BITS;
+                    } else {
+                        wps->wp[j] = blkz[i].wp << BDRV_SECTOR_BITS;
+                    }
+                    break;
+                }
+            }
+        }
+        sector = blkz[i - 1].start + blkz[i - 1].len;
+    }
+
+    return 0;
+}
+
+static void update_zones_wp(BlockDriverState *bs, int fd, int64_t offset,
+                            unsigned int nrz)
+{
+    if (get_zones_wp(bs, fd, offset, nrz, 0) < 0) {
+        error_report("update zone wp failed");
+    }
+}
+#endif
+
 static void raw_refresh_limits(BlockDriverState *bs, Error **errp)
 {
     BDRVRawState *s = bs->opaque;
@@ -1413,6 +1497,23 @@ static void raw_refresh_limits(BlockDriverState *bs, Error **errp)
         if (ret >= 0) {
             bs->bl.max_active_zones = ret;
         }
+
+        ret = get_sysfs_long_val(&st, "physical_block_size");
+        if (ret >= 0) {
+            bs->bl.write_granularity = ret;
+        }
+
+        /* The refresh_limits() function can be called multiple times. */
+        g_free(bs->wps);
+        bs->wps = g_malloc(sizeof(BlockZoneWps) +
+                sizeof(int64_t) * bs->bl.nr_zones);
+        ret = get_zones_wp(bs, s->fd, 0, bs->bl.nr_zones, 0);
+        if (ret < 0) {
+            error_setg_errno(errp, -ret, "report wps failed");
+            bs->wps = NULL;
+            return;
+        }
+        qemu_co_mutex_init(&bs->wps->colock);
         return;
     }
 out:
@@ -2338,9 +2439,15 @@ static int coroutine_fn raw_co_prw(BlockDriverState *bs, uint64_t offset,
 {
     BDRVRawState *s = bs->opaque;
     RawPosixAIOData acb;
+    int ret;
 
     if (fd_open(bs) < 0)
         return -EIO;
+#if defined(CONFIG_BLKZONED)
+    if (type & QEMU_AIO_WRITE && bs->wps) {
+        qemu_co_mutex_lock(&bs->wps->colock);
+    }
+#endif
 
     /*
      * When using O_DIRECT, the request must be aligned to be able to use
@@ -2354,14 +2461,16 @@ static int coroutine_fn raw_co_prw(BlockDriverState *bs, uint64_t offset,
     } else if (s->use_linux_io_uring) {
         LuringState *aio = aio_get_linux_io_uring(bdrv_get_aio_context(bs));
         assert(qiov->size == bytes);
-        return luring_co_submit(bs, aio, s->fd, offset, qiov, type);
+        ret = luring_co_submit(bs, aio, s->fd, offset, qiov, type);
+        goto out;
 #endif
 #ifdef CONFIG_LINUX_AIO
     } else if (s->use_linux_aio) {
         LinuxAioState *aio = aio_get_linux_aio(bdrv_get_aio_context(bs));
         assert(qiov->size == bytes);
-        return laio_co_submit(bs, aio, s->fd, offset, qiov, type,
+        ret = laio_co_submit(bs, aio, s->fd, offset, qiov, type,
                               s->aio_max_batch);
+        goto out;
 #endif
     }
 
@@ -2378,7 +2487,32 @@ static int coroutine_fn raw_co_prw(BlockDriverState *bs, uint64_t offset,
     };
 
     assert(qiov->size == bytes);
-    return raw_thread_pool_submit(bs, handle_aiocb_rw, &acb);
+    ret = raw_thread_pool_submit(bs, handle_aiocb_rw, &acb);
+
+out:
+#if defined(CONFIG_BLKZONED)
+    BlockZoneWps *wps = bs->wps;
+    if (ret == 0) {
+        if (type & QEMU_AIO_WRITE && wps && bs->bl.zone_size) {
+            uint64_t *wp = &wps->wp[offset / bs->bl.zone_size];
+            if (!BDRV_ZT_IS_CONV(*wp)) {
+                /* Advance the wp if needed */
+                if (offset + bytes > *wp) {
+                    *wp = offset + bytes;
+                }
+            }
+        }
+    } else {
+        if (type & QEMU_AIO_WRITE) {
+            update_zones_wp(bs, s->fd, 0, 1);
+        }
+    }
+
+    if (type & QEMU_AIO_WRITE && wps) {
+        qemu_co_mutex_unlock(&wps->colock);
+    }
+#endif
+    return ret;
 }
 
 static int coroutine_fn raw_co_preadv(BlockDriverState *bs, int64_t offset,
@@ -2486,6 +2620,9 @@ static void raw_close(BlockDriverState *bs)
     BDRVRawState *s = bs->opaque;
 
     if (s->fd >= 0) {
+#if defined(CONFIG_BLKZONED)
+        g_free(bs->wps);
+#endif
         qemu_close(s->fd);
         s->fd = -1;
     }
@@ -3283,6 +3420,7 @@ static int coroutine_fn raw_co_zone_mgmt(BlockDriverState *bs, BlockZoneOp op,
     const char *op_name;
     unsigned long zo;
     int ret;
+    BlockZoneWps *wps = bs->wps;
     int64_t capacity = bs->total_sectors << BDRV_SECTOR_BITS;
 
     zone_size = bs->bl.zone_size;
@@ -3300,6 +3438,15 @@ static int coroutine_fn raw_co_zone_mgmt(BlockDriverState *bs, BlockZoneOp op,
         return -EINVAL;
     }
 
+    QEMU_LOCK_GUARD(&wps->colock);
+    uint32_t i = offset / bs->bl.zone_size;
+    uint32_t nrz = len / bs->bl.zone_size;
+    uint64_t *wp = &wps->wp[i];
+    if (BDRV_ZT_IS_CONV(*wp) && len != capacity) {
+        error_report("zone mgmt operations are not allowed for conventional zones");
+        return -EIO;
+    }
+
     switch (op) {
     case BLK_ZO_OPEN:
         op_name = "BLKOPENZONE";
@@ -3337,7 +3484,27 @@ static int coroutine_fn raw_co_zone_mgmt(BlockDriverState *bs, BlockZoneOp op,
                         len >> BDRV_SECTOR_BITS);
     ret = raw_thread_pool_submit(bs, handle_aiocb_zone_mgmt, &acb);
     if (ret != 0) {
+        update_zones_wp(bs, s->fd, offset, i);
         error_report("ioctl %s failed %d", op_name, ret);
+        return ret;
+    }
+
+    if (zo == BLKRESETZONE && len == capacity) {
+        ret = get_zones_wp(bs, s->fd, 0, bs->bl.nr_zones, 1);
+        if (ret < 0) {
+            error_report("reporting single wp failed");
+            return ret;
+        }
+    } else if (zo == BLKRESETZONE) {
+        for (int j = 0; j < nrz; ++j) {
+            wp[j] = offset + j * zone_size;
+        }
+    } else if (zo == BLKFINISHZONE) {
+        for (int j = 0; j < nrz; ++j) {
+            /* The zoned device allows the last zone smaller that the
+             * zone size. */
+            wp[j] = MIN(offset + (j + 1) * zone_size, offset + len);
+        }
     }
 
     return ret;
-- 
2.39.2

