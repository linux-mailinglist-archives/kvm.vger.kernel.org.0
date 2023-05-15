Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3F17703244
	for <lists+kvm@lfdr.de>; Mon, 15 May 2023 18:07:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242576AbjEOQHS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 May 2023 12:07:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242557AbjEOQHG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 May 2023 12:07:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EAB830D2
        for <kvm@vger.kernel.org>; Mon, 15 May 2023 09:05:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1684166748;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GpRDyTyhkClrLhJDneijJbk5hggQX8EoNvUalTnBBmE=;
        b=iA3JpB0i7zYTTRXJjJkTaVP1eFK6I6+NusNeIqsSJb4o3k86BBj42XvWm/A8H6ECgVHuYh
        N7tEqsOku60UzxNti12dqS4301KnTzq58rjaYf5aQPVDxYWz5wrwcwznsB9O4oTLBwKXvi
        9DOC37IlSLmDeAVNT4zgzpzICoJX1/U=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-617-I3MNNu_lMG2BYMwI7zd8Cw-1; Mon, 15 May 2023 12:05:44 -0400
X-MC-Unique: I3MNNu_lMG2BYMwI7zd8Cw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 61BAE85C073;
        Mon, 15 May 2023 16:05:42 +0000 (UTC)
Received: from localhost (unknown [10.39.192.179])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8D752492B00;
        Mon, 15 May 2023 16:05:36 +0000 (UTC)
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
        Fam Zheng <fam@euphon.net>, Sam Li <faithilikerun@gmail.com>
Subject: [PULL v2 13/16] virtio-blk: add zoned storage emulation for zoned devices
Date:   Mon, 15 May 2023 12:05:03 -0400
Message-Id: <20230515160506.1776883-14-stefanha@redhat.com>
In-Reply-To: <20230515160506.1776883-1-stefanha@redhat.com>
References: <20230515160506.1776883-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
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

This patch extends virtio-blk emulation to handle zoned device commands
by calling the new block layer APIs to perform zoned device I/O on
behalf of the guest. It supports Report Zone, four zone oparations (open,
close, finish, reset), and Append Zone.

The VIRTIO_BLK_F_ZONED feature bit will only be set if the host does
support zoned block devices. Regular block devices(conventional zones)
will not be set.

The guest os can use blktests, fio to test those commands on zoned devices.
Furthermore, using zonefs to test zone append write is also supported.

Signed-off-by: Sam Li <faithilikerun@gmail.com>
Message-id: 20230508051916.178322-2-faithilikerun@gmail.com
Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 hw/block/virtio-blk-common.c |   2 +
 hw/block/virtio-blk.c        | 389 +++++++++++++++++++++++++++++++++++
 hw/virtio/virtio-qmp.c       |   2 +
 3 files changed, 393 insertions(+)

diff --git a/hw/block/virtio-blk-common.c b/hw/block/virtio-blk-common.c
index ac52d7c176..e2f8e2f6da 100644
--- a/hw/block/virtio-blk-common.c
+++ b/hw/block/virtio-blk-common.c
@@ -29,6 +29,8 @@ static const VirtIOFeature feature_sizes[] = {
      .end = endof(struct virtio_blk_config, discard_sector_alignment)},
     {.flags = 1ULL << VIRTIO_BLK_F_WRITE_ZEROES,
      .end = endof(struct virtio_blk_config, write_zeroes_may_unmap)},
+    {.flags = 1ULL << VIRTIO_BLK_F_ZONED,
+     .end = endof(struct virtio_blk_config, zoned)},
     {}
 };
 
diff --git a/hw/block/virtio-blk.c b/hw/block/virtio-blk.c
index cefca93b31..cb741dec39 100644
--- a/hw/block/virtio-blk.c
+++ b/hw/block/virtio-blk.c
@@ -17,6 +17,7 @@
 #include "qemu/module.h"
 #include "qemu/error-report.h"
 #include "qemu/main-loop.h"
+#include "block/block_int.h"
 #include "trace.h"
 #include "hw/block/block.h"
 #include "hw/qdev-properties.h"
@@ -601,6 +602,335 @@ err:
     return err_status;
 }
 
+typedef struct ZoneCmdData {
+    VirtIOBlockReq *req;
+    struct iovec *in_iov;
+    unsigned in_num;
+    union {
+        struct {
+            unsigned int nr_zones;
+            BlockZoneDescriptor *zones;
+        } zone_report_data;
+        struct {
+            int64_t offset;
+        } zone_append_data;
+    };
+} ZoneCmdData;
+
+/*
+ * check zoned_request: error checking before issuing requests. If all checks
+ * passed, return true.
+ * append: true if only zone append requests issued.
+ */
+static bool check_zoned_request(VirtIOBlock *s, int64_t offset, int64_t len,
+                             bool append, uint8_t *status) {
+    BlockDriverState *bs = blk_bs(s->blk);
+    int index;
+
+    if (!virtio_has_feature(s->host_features, VIRTIO_BLK_F_ZONED)) {
+        *status = VIRTIO_BLK_S_UNSUPP;
+        return false;
+    }
+
+    if (offset < 0 || len < 0 || len > (bs->total_sectors << BDRV_SECTOR_BITS)
+        || offset > (bs->total_sectors << BDRV_SECTOR_BITS) - len) {
+        *status = VIRTIO_BLK_S_ZONE_INVALID_CMD;
+        return false;
+    }
+
+    if (append) {
+        if (bs->bl.write_granularity) {
+            if ((offset % bs->bl.write_granularity) != 0) {
+                *status = VIRTIO_BLK_S_ZONE_UNALIGNED_WP;
+                return false;
+            }
+        }
+
+        index = offset / bs->bl.zone_size;
+        if (BDRV_ZT_IS_CONV(bs->wps->wp[index])) {
+            *status = VIRTIO_BLK_S_ZONE_INVALID_CMD;
+            return false;
+        }
+
+        if (len / 512 > bs->bl.max_append_sectors) {
+            if (bs->bl.max_append_sectors == 0) {
+                *status = VIRTIO_BLK_S_UNSUPP;
+            } else {
+                *status = VIRTIO_BLK_S_ZONE_INVALID_CMD;
+            }
+            return false;
+        }
+    }
+    return true;
+}
+
+static void virtio_blk_zone_report_complete(void *opaque, int ret)
+{
+    ZoneCmdData *data = opaque;
+    VirtIOBlockReq *req = data->req;
+    VirtIOBlock *s = req->dev;
+    VirtIODevice *vdev = VIRTIO_DEVICE(req->dev);
+    struct iovec *in_iov = data->in_iov;
+    unsigned in_num = data->in_num;
+    int64_t zrp_size, n, j = 0;
+    int64_t nz = data->zone_report_data.nr_zones;
+    int8_t err_status = VIRTIO_BLK_S_OK;
+
+    if (ret) {
+        err_status = VIRTIO_BLK_S_ZONE_INVALID_CMD;
+        goto out;
+    }
+
+    struct virtio_blk_zone_report zrp_hdr = (struct virtio_blk_zone_report) {
+        .nr_zones = cpu_to_le64(nz),
+    };
+    zrp_size = sizeof(struct virtio_blk_zone_report)
+               + sizeof(struct virtio_blk_zone_descriptor) * nz;
+    n = iov_from_buf(in_iov, in_num, 0, &zrp_hdr, sizeof(zrp_hdr));
+    if (n != sizeof(zrp_hdr)) {
+        virtio_error(vdev, "Driver provided input buffer that is too small!");
+        err_status = VIRTIO_BLK_S_ZONE_INVALID_CMD;
+        goto out;
+    }
+
+    for (size_t i = sizeof(zrp_hdr); i < zrp_size;
+        i += sizeof(struct virtio_blk_zone_descriptor), ++j) {
+        struct virtio_blk_zone_descriptor desc =
+            (struct virtio_blk_zone_descriptor) {
+                .z_start = cpu_to_le64(data->zone_report_data.zones[j].start
+                    >> BDRV_SECTOR_BITS),
+                .z_cap = cpu_to_le64(data->zone_report_data.zones[j].cap
+                    >> BDRV_SECTOR_BITS),
+                .z_wp = cpu_to_le64(data->zone_report_data.zones[j].wp
+                    >> BDRV_SECTOR_BITS),
+        };
+
+        switch (data->zone_report_data.zones[j].type) {
+        case BLK_ZT_CONV:
+            desc.z_type = VIRTIO_BLK_ZT_CONV;
+            break;
+        case BLK_ZT_SWR:
+            desc.z_type = VIRTIO_BLK_ZT_SWR;
+            break;
+        case BLK_ZT_SWP:
+            desc.z_type = VIRTIO_BLK_ZT_SWP;
+            break;
+        default:
+            g_assert_not_reached();
+        }
+
+        switch (data->zone_report_data.zones[j].state) {
+        case BLK_ZS_RDONLY:
+            desc.z_state = VIRTIO_BLK_ZS_RDONLY;
+            break;
+        case BLK_ZS_OFFLINE:
+            desc.z_state = VIRTIO_BLK_ZS_OFFLINE;
+            break;
+        case BLK_ZS_EMPTY:
+            desc.z_state = VIRTIO_BLK_ZS_EMPTY;
+            break;
+        case BLK_ZS_CLOSED:
+            desc.z_state = VIRTIO_BLK_ZS_CLOSED;
+            break;
+        case BLK_ZS_FULL:
+            desc.z_state = VIRTIO_BLK_ZS_FULL;
+            break;
+        case BLK_ZS_EOPEN:
+            desc.z_state = VIRTIO_BLK_ZS_EOPEN;
+            break;
+        case BLK_ZS_IOPEN:
+            desc.z_state = VIRTIO_BLK_ZS_IOPEN;
+            break;
+        case BLK_ZS_NOT_WP:
+            desc.z_state = VIRTIO_BLK_ZS_NOT_WP;
+            break;
+        default:
+            g_assert_not_reached();
+        }
+
+        /* TODO: it takes O(n^2) time complexity. Optimizations required. */
+        n = iov_from_buf(in_iov, in_num, i, &desc, sizeof(desc));
+        if (n != sizeof(desc)) {
+            virtio_error(vdev, "Driver provided input buffer "
+                               "for descriptors that is too small!");
+            err_status = VIRTIO_BLK_S_ZONE_INVALID_CMD;
+        }
+    }
+
+out:
+    aio_context_acquire(blk_get_aio_context(s->conf.conf.blk));
+    virtio_blk_req_complete(req, err_status);
+    virtio_blk_free_request(req);
+    aio_context_release(blk_get_aio_context(s->conf.conf.blk));
+    g_free(data->zone_report_data.zones);
+    g_free(data);
+}
+
+static void virtio_blk_handle_zone_report(VirtIOBlockReq *req,
+                                         struct iovec *in_iov,
+                                         unsigned in_num)
+{
+    VirtIOBlock *s = req->dev;
+    VirtIODevice *vdev = VIRTIO_DEVICE(s);
+    unsigned int nr_zones;
+    ZoneCmdData *data;
+    int64_t zone_size, offset;
+    uint8_t err_status;
+
+    if (req->in_len < sizeof(struct virtio_blk_inhdr) +
+            sizeof(struct virtio_blk_zone_report) +
+            sizeof(struct virtio_blk_zone_descriptor)) {
+        virtio_error(vdev, "in buffer too small for zone report");
+        return;
+    }
+
+    /* start byte offset of the zone report */
+    offset = virtio_ldq_p(vdev, &req->out.sector) << BDRV_SECTOR_BITS;
+    if (!check_zoned_request(s, offset, 0, false, &err_status)) {
+        goto out;
+    }
+    nr_zones = (req->in_len - sizeof(struct virtio_blk_inhdr) -
+                sizeof(struct virtio_blk_zone_report)) /
+               sizeof(struct virtio_blk_zone_descriptor);
+
+    zone_size = sizeof(BlockZoneDescriptor) * nr_zones;
+    data = g_malloc(sizeof(ZoneCmdData));
+    data->req = req;
+    data->in_iov = in_iov;
+    data->in_num = in_num;
+    data->zone_report_data.nr_zones = nr_zones;
+    data->zone_report_data.zones = g_malloc(zone_size),
+
+    blk_aio_zone_report(s->blk, offset, &data->zone_report_data.nr_zones,
+                        data->zone_report_data.zones,
+                        virtio_blk_zone_report_complete, data);
+    return;
+out:
+    virtio_blk_req_complete(req, err_status);
+    virtio_blk_free_request(req);
+}
+
+static void virtio_blk_zone_mgmt_complete(void *opaque, int ret)
+{
+    VirtIOBlockReq *req = opaque;
+    VirtIOBlock *s = req->dev;
+    int8_t err_status = VIRTIO_BLK_S_OK;
+
+    if (ret) {
+        err_status = VIRTIO_BLK_S_ZONE_INVALID_CMD;
+    }
+
+    aio_context_acquire(blk_get_aio_context(s->conf.conf.blk));
+    virtio_blk_req_complete(req, err_status);
+    virtio_blk_free_request(req);
+    aio_context_release(blk_get_aio_context(s->conf.conf.blk));
+}
+
+static int virtio_blk_handle_zone_mgmt(VirtIOBlockReq *req, BlockZoneOp op)
+{
+    VirtIOBlock *s = req->dev;
+    VirtIODevice *vdev = VIRTIO_DEVICE(s);
+    BlockDriverState *bs = blk_bs(s->blk);
+    int64_t offset = virtio_ldq_p(vdev, &req->out.sector) << BDRV_SECTOR_BITS;
+    uint64_t len;
+    uint64_t capacity = bs->total_sectors << BDRV_SECTOR_BITS;
+    uint8_t err_status = VIRTIO_BLK_S_OK;
+
+    uint32_t type = virtio_ldl_p(vdev, &req->out.type);
+    if (type == VIRTIO_BLK_T_ZONE_RESET_ALL) {
+        /* Entire drive capacity */
+        offset = 0;
+        len = capacity;
+    } else {
+        if (bs->bl.zone_size > capacity - offset) {
+            /* The zoned device allows the last smaller zone. */
+            len = capacity - bs->bl.zone_size * (bs->bl.nr_zones - 1);
+        } else {
+            len = bs->bl.zone_size;
+        }
+    }
+
+    if (!check_zoned_request(s, offset, len, false, &err_status)) {
+        goto out;
+    }
+
+    blk_aio_zone_mgmt(s->blk, op, offset, len,
+                      virtio_blk_zone_mgmt_complete, req);
+
+    return 0;
+out:
+    virtio_blk_req_complete(req, err_status);
+    virtio_blk_free_request(req);
+    return err_status;
+}
+
+static void virtio_blk_zone_append_complete(void *opaque, int ret)
+{
+    ZoneCmdData *data = opaque;
+    VirtIOBlockReq *req = data->req;
+    VirtIOBlock *s = req->dev;
+    VirtIODevice *vdev = VIRTIO_DEVICE(req->dev);
+    int64_t append_sector, n;
+    uint8_t err_status = VIRTIO_BLK_S_OK;
+
+    if (ret) {
+        err_status = VIRTIO_BLK_S_ZONE_INVALID_CMD;
+        goto out;
+    }
+
+    virtio_stq_p(vdev, &append_sector,
+                 data->zone_append_data.offset >> BDRV_SECTOR_BITS);
+    n = iov_from_buf(data->in_iov, data->in_num, 0, &append_sector,
+                     sizeof(append_sector));
+    if (n != sizeof(append_sector)) {
+        virtio_error(vdev, "Driver provided input buffer less than size of "
+                           "append_sector");
+        err_status = VIRTIO_BLK_S_ZONE_INVALID_CMD;
+        goto out;
+    }
+
+out:
+    aio_context_acquire(blk_get_aio_context(s->conf.conf.blk));
+    virtio_blk_req_complete(req, err_status);
+    virtio_blk_free_request(req);
+    aio_context_release(blk_get_aio_context(s->conf.conf.blk));
+    g_free(data);
+}
+
+static int virtio_blk_handle_zone_append(VirtIOBlockReq *req,
+                                         struct iovec *out_iov,
+                                         struct iovec *in_iov,
+                                         uint64_t out_num,
+                                         unsigned in_num) {
+    VirtIOBlock *s = req->dev;
+    VirtIODevice *vdev = VIRTIO_DEVICE(s);
+    uint8_t err_status = VIRTIO_BLK_S_OK;
+
+    int64_t offset = virtio_ldq_p(vdev, &req->out.sector) << BDRV_SECTOR_BITS;
+    int64_t len = iov_size(out_iov, out_num);
+
+    if (!check_zoned_request(s, offset, len, true, &err_status)) {
+        goto out;
+    }
+
+    ZoneCmdData *data = g_malloc(sizeof(ZoneCmdData));
+    data->req = req;
+    data->in_iov = in_iov;
+    data->in_num = in_num;
+    data->zone_append_data.offset = offset;
+    qemu_iovec_init_external(&req->qiov, out_iov, out_num);
+    blk_aio_zone_append(s->blk, &data->zone_append_data.offset, &req->qiov, 0,
+                        virtio_blk_zone_append_complete, data);
+    return 0;
+
+out:
+    aio_context_acquire(blk_get_aio_context(s->conf.conf.blk));
+    virtio_blk_req_complete(req, err_status);
+    virtio_blk_free_request(req);
+    aio_context_release(blk_get_aio_context(s->conf.conf.blk));
+    return err_status;
+}
+
 static int virtio_blk_handle_request(VirtIOBlockReq *req, MultiReqBuffer *mrb)
 {
     uint32_t type;
@@ -687,6 +1017,24 @@ static int virtio_blk_handle_request(VirtIOBlockReq *req, MultiReqBuffer *mrb)
     case VIRTIO_BLK_T_FLUSH:
         virtio_blk_handle_flush(req, mrb);
         break;
+    case VIRTIO_BLK_T_ZONE_REPORT:
+        virtio_blk_handle_zone_report(req, in_iov, in_num);
+        break;
+    case VIRTIO_BLK_T_ZONE_OPEN:
+        virtio_blk_handle_zone_mgmt(req, BLK_ZO_OPEN);
+        break;
+    case VIRTIO_BLK_T_ZONE_CLOSE:
+        virtio_blk_handle_zone_mgmt(req, BLK_ZO_CLOSE);
+        break;
+    case VIRTIO_BLK_T_ZONE_FINISH:
+        virtio_blk_handle_zone_mgmt(req, BLK_ZO_FINISH);
+        break;
+    case VIRTIO_BLK_T_ZONE_RESET:
+        virtio_blk_handle_zone_mgmt(req, BLK_ZO_RESET);
+        break;
+    case VIRTIO_BLK_T_ZONE_RESET_ALL:
+        virtio_blk_handle_zone_mgmt(req, BLK_ZO_RESET);
+        break;
     case VIRTIO_BLK_T_SCSI_CMD:
         virtio_blk_handle_scsi(req);
         break;
@@ -705,6 +1053,14 @@ static int virtio_blk_handle_request(VirtIOBlockReq *req, MultiReqBuffer *mrb)
         virtio_blk_free_request(req);
         break;
     }
+    case VIRTIO_BLK_T_ZONE_APPEND & ~VIRTIO_BLK_T_OUT:
+        /*
+         * Passing out_iov/out_num and in_iov/in_num is not safe
+         * to access req->elem.out_sg directly because it may be
+         * modified by virtio_blk_handle_request().
+         */
+        virtio_blk_handle_zone_append(req, out_iov, in_iov, out_num, in_num);
+        break;
     /*
      * VIRTIO_BLK_T_DISCARD and VIRTIO_BLK_T_WRITE_ZEROES are defined with
      * VIRTIO_BLK_T_OUT flag set. We masked this flag in the switch statement,
@@ -890,6 +1246,7 @@ static void virtio_blk_update_config(VirtIODevice *vdev, uint8_t *config)
 {
     VirtIOBlock *s = VIRTIO_BLK(vdev);
     BlockConf *conf = &s->conf.conf;
+    BlockDriverState *bs = blk_bs(s->blk);
     struct virtio_blk_config blkcfg;
     uint64_t capacity;
     int64_t length;
@@ -954,6 +1311,30 @@ static void virtio_blk_update_config(VirtIODevice *vdev, uint8_t *config)
         blkcfg.write_zeroes_may_unmap = 1;
         virtio_stl_p(vdev, &blkcfg.max_write_zeroes_seg, 1);
     }
+    if (bs->bl.zoned != BLK_Z_NONE) {
+        switch (bs->bl.zoned) {
+        case BLK_Z_HM:
+            blkcfg.zoned.model = VIRTIO_BLK_Z_HM;
+            break;
+        case BLK_Z_HA:
+            blkcfg.zoned.model = VIRTIO_BLK_Z_HA;
+            break;
+        default:
+            g_assert_not_reached();
+        }
+
+        virtio_stl_p(vdev, &blkcfg.zoned.zone_sectors,
+                     bs->bl.zone_size / 512);
+        virtio_stl_p(vdev, &blkcfg.zoned.max_active_zones,
+                     bs->bl.max_active_zones);
+        virtio_stl_p(vdev, &blkcfg.zoned.max_open_zones,
+                     bs->bl.max_open_zones);
+        virtio_stl_p(vdev, &blkcfg.zoned.write_granularity, blk_size);
+        virtio_stl_p(vdev, &blkcfg.zoned.max_append_sectors,
+                     bs->bl.max_append_sectors);
+    } else {
+        blkcfg.zoned.model = VIRTIO_BLK_Z_NONE;
+    }
     memcpy(config, &blkcfg, s->config_size);
 }
 
@@ -1163,6 +1544,14 @@ static void virtio_blk_device_realize(DeviceState *dev, Error **errp)
         return;
     }
 
+    BlockDriverState *bs = blk_bs(conf->conf.blk);
+    if (bs->bl.zoned != BLK_Z_NONE) {
+        virtio_add_feature(&s->host_features, VIRTIO_BLK_F_ZONED);
+        if (bs->bl.zoned == BLK_Z_HM) {
+            virtio_clear_feature(&s->host_features, VIRTIO_BLK_F_DISCARD);
+        }
+    }
+
     if (virtio_has_feature(s->host_features, VIRTIO_BLK_F_DISCARD) &&
         (!conf->max_discard_sectors ||
          conf->max_discard_sectors > BDRV_REQUEST_MAX_SECTORS)) {
diff --git a/hw/virtio/virtio-qmp.c b/hw/virtio/virtio-qmp.c
index b70148aba9..e84316dcfd 100644
--- a/hw/virtio/virtio-qmp.c
+++ b/hw/virtio/virtio-qmp.c
@@ -176,6 +176,8 @@ static const qmp_virtio_feature_map_t virtio_blk_feature_map[] = {
             "VIRTIO_BLK_F_DISCARD: Discard command supported"),
     FEATURE_ENTRY(VIRTIO_BLK_F_WRITE_ZEROES, \
             "VIRTIO_BLK_F_WRITE_ZEROES: Write zeroes command supported"),
+    FEATURE_ENTRY(VIRTIO_BLK_F_ZONED, \
+            "VIRTIO_BLK_F_ZONED: Zoned block devices"),
 #ifndef VIRTIO_BLK_NO_LEGACY
     FEATURE_ENTRY(VIRTIO_BLK_F_BARRIER, \
             "VIRTIO_BLK_F_BARRIER: Request barriers supported"),
-- 
2.40.1

