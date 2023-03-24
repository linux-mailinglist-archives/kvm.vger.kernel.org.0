Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B63F6C7CE6
	for <lists+kvm@lfdr.de>; Fri, 24 Mar 2023 11:54:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231667AbjCXKyh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Mar 2023 06:54:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231783AbjCXKyd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Mar 2023 06:54:33 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1D29274A6
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 03:54:28 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id fb38so983629pfb.7
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 03:54:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679655268;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ndBDr/zFeh0RMjD6v3yNcN9LNQI/fMto1wPl1SoEh2M=;
        b=kXNOStra8M6YPCaYO/8REUv8WOAY3RP9f9LWDQP3DF1ciTycGDV8yutNH4Ku0tfGXp
         D3fj3oTeP5dKvTgYegUghTpMnBHt0e1xxZ84Oa0qVxyCwcvzAtrmG1ck8t0HkPjviHuD
         Kh8M+lueFHI/lz2vDMBlhFogQ1Iq20fH2N15vWYNkSvgPUB6mamvgTkG2t70FjihrSMu
         3MoTzg/n7fhNF14hk0Yfu5LWDbimSrcVvJdLW1FsStby0ZbZfx01gQlRCy0w2InXnQpG
         ii1nzzaemGiJzefAxSYz+2f1/cVijiyBGyhEA76Mp9G3N3rVKaEpIaDBmI/74fq32p3f
         7+rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679655268;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ndBDr/zFeh0RMjD6v3yNcN9LNQI/fMto1wPl1SoEh2M=;
        b=Ymdb8IbatplnixRUBRH/aQf8UFrss+NDrtKmknbqC1lMmOrBB5Ks8Y11UZ+3uWB215
         U7Q7xi5iMYFTuW6gNn5CfEJcLyGYRLBFEnVMfWGYsfJiC68s5NSiJdIxARlPnMozo+De
         JWj7V27MuofszLq7LLm396HoNTdVlXObHLCXdAPpQ9qVDVlARnh3RC+H4l3mTP0/TuV8
         DCtP5WIJ8Y9ZX+icwc09tSmvGe0rrWDKAG7sSXNQSg7xLiK0Esu55lUmcNDrTa1f8bEb
         yQ1+olX0JyCowvXnorTJe35hYa54lKOgRgsQuu5YvWsy2NQXhafuPNM04mFZUezq8E2U
         Z/Jg==
X-Gm-Message-State: AAQBX9ePHNsNRCJR4cToEZOe8gx/2xjcED8dJex+sDA85ZAMY29Qbht+
        JJeIrCaJDmyQDY68/HVJdw8=
X-Google-Smtp-Source: AKy350ZpK1RngwjRGtwzuDVfNxI1/KCkyk7NtpNQDqPuwul2y/CTaZmKO5r1OwkRcH0CZiEqvAPCGA==
X-Received: by 2002:aa7:950d:0:b0:625:e728:4c5f with SMTP id b13-20020aa7950d000000b00625e7284c5fmr2577761pfp.22.1679655267433;
        Fri, 24 Mar 2023 03:54:27 -0700 (PDT)
Received: from fedlinux.. ([106.84.130.185])
        by smtp.gmail.com with ESMTPSA id bn10-20020a056a00324a00b005d72e54a7e1sm13617355pfb.215.2023.03.24.03.54.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Mar 2023 03:54:26 -0700 (PDT)
From:   Sam Li <faithilikerun@gmail.com>
To:     qemu-devel@nongnu.org
Cc:     Kevin Wolf <kwolf@redhat.com>, stefanha@redhat.com,
        Hanna Reitz <hreitz@redhat.com>, qemu-block@nongnu.org,
        Eric Blake <eblake@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Raphael Norwitz <raphael.norwitz@nutanix.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        damien.lemoal@opensource.wdc.com, hare@suse.de,
        kvm@vger.kernel.org, Markus Armbruster <armbru@redhat.com>,
        dmitry.fomichev@wdc.com, Sam Li <faithilikerun@gmail.com>
Subject: [PATCH v9 4/5] virtio-blk: add some trace events for zoned emulation
Date:   Fri, 24 Mar 2023 18:54:17 +0800
Message-Id: <20230324105418.3752-1-faithilikerun@gmail.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Sam Li <faithilikerun@gmail.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 hw/block/trace-events |  7 +++++++
 hw/block/virtio-blk.c | 12 ++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/hw/block/trace-events b/hw/block/trace-events
index 2c45a62bd5..34be8b9135 100644
--- a/hw/block/trace-events
+++ b/hw/block/trace-events
@@ -44,9 +44,16 @@ pflash_write_unknown(const char *name, uint8_t cmd) "%s: unknown command 0x%02x"
 # virtio-blk.c
 virtio_blk_req_complete(void *vdev, void *req, int status) "vdev %p req %p status %d"
 virtio_blk_rw_complete(void *vdev, void *req, int ret) "vdev %p req %p ret %d"
+virtio_blk_zone_report_complete(void *vdev, void *req, unsigned int nr_zones, int ret) "vdev %p req %p nr_zones %u ret %d"
+virtio_blk_zone_mgmt_complete(void *vdev, void *req, int ret) "vdev %p req %p ret %d"
+virtio_blk_zone_append_complete(void *vdev, void *req, int64_t sector, int ret) "vdev %p req %p, append sector 0x%" PRIx64 " ret %d"
 virtio_blk_handle_write(void *vdev, void *req, uint64_t sector, size_t nsectors) "vdev %p req %p sector %"PRIu64" nsectors %zu"
 virtio_blk_handle_read(void *vdev, void *req, uint64_t sector, size_t nsectors) "vdev %p req %p sector %"PRIu64" nsectors %zu"
 virtio_blk_submit_multireq(void *vdev, void *mrb, int start, int num_reqs, uint64_t offset, size_t size, bool is_write) "vdev %p mrb %p start %d num_reqs %d offset %"PRIu64" size %zu is_write %d"
+virtio_blk_handle_zone_report(void *vdev, void *req, int64_t sector, unsigned int nr_zones) "vdev %p req %p sector 0x%" PRIx64 " nr_zones %u"
+virtio_blk_handle_zone_mgmt(void *vdev, void *req, uint8_t op, int64_t sector, int64_t len) "vdev %p req %p op 0x%x sector 0x%" PRIx64 " len 0x%" PRIx64 ""
+virtio_blk_handle_zone_reset_all(void *vdev, void *req, int64_t sector, int64_t len) "vdev %p req %p sector 0x%" PRIx64 " cap 0x%" PRIx64 ""
+virtio_blk_handle_zone_append(void *vdev, void *req, int64_t sector) "vdev %p req %p, append sector 0x%" PRIx64 ""
 
 # hd-geometry.c
 hd_geometry_lchs_guess(void *blk, int cyls, int heads, int secs) "blk %p LCHS %d %d %d"
diff --git a/hw/block/virtio-blk.c b/hw/block/virtio-blk.c
index 0d85c2c9b0..2afd5cf96c 100644
--- a/hw/block/virtio-blk.c
+++ b/hw/block/virtio-blk.c
@@ -676,6 +676,7 @@ static void virtio_blk_zone_report_complete(void *opaque, int ret)
     int64_t nz = data->zone_report_data.nr_zones;
     int8_t err_status = VIRTIO_BLK_S_OK;
 
+    trace_virtio_blk_zone_report_complete(vdev, req, nz, ret);
     if (ret) {
         err_status = VIRTIO_BLK_S_ZONE_INVALID_CMD;
         goto out;
@@ -792,6 +793,8 @@ static void virtio_blk_handle_zone_report(VirtIOBlockReq *req,
     nr_zones = (req->in_len - sizeof(struct virtio_blk_inhdr) -
                 sizeof(struct virtio_blk_zone_report)) /
                sizeof(struct virtio_blk_zone_descriptor);
+    trace_virtio_blk_handle_zone_report(vdev, req,
+                                        offset >> BDRV_SECTOR_BITS, nr_zones);
 
     zone_size = sizeof(BlockZoneDescriptor) * nr_zones;
     data = g_malloc(sizeof(ZoneCmdData));
@@ -814,7 +817,9 @@ static void virtio_blk_zone_mgmt_complete(void *opaque, int ret)
 {
     VirtIOBlockReq *req = opaque;
     VirtIOBlock *s = req->dev;
+    VirtIODevice *vdev = VIRTIO_DEVICE(s);
     int8_t err_status = VIRTIO_BLK_S_OK;
+    trace_virtio_blk_zone_mgmt_complete(vdev, req,ret);
 
     if (ret) {
         err_status = VIRTIO_BLK_S_ZONE_INVALID_CMD;
@@ -841,6 +846,8 @@ static int virtio_blk_handle_zone_mgmt(VirtIOBlockReq *req, BlockZoneOp op)
         /* Entire drive capacity */
         offset = 0;
         len = capacity;
+        trace_virtio_blk_handle_zone_reset_all(vdev, req, 0,
+                                               bs->total_sectors);
     } else {
         if (bs->bl.zone_size > capacity - offset) {
             /* The zoned device allows the last smaller zone. */
@@ -848,6 +855,9 @@ static int virtio_blk_handle_zone_mgmt(VirtIOBlockReq *req, BlockZoneOp op)
         } else {
             len = bs->bl.zone_size;
         }
+        trace_virtio_blk_handle_zone_mgmt(vdev, req, op,
+                                          offset >> BDRV_SECTOR_BITS,
+                                          len >> BDRV_SECTOR_BITS);
     }
 
     if (!check_zoned_request(s, offset, len, false, &err_status)) {
@@ -888,6 +898,7 @@ static void virtio_blk_zone_append_complete(void *opaque, int ret)
         err_status = VIRTIO_BLK_S_ZONE_INVALID_CMD;
         goto out;
     }
+    trace_virtio_blk_zone_append_complete(vdev, req, append_sector, ret);
 
 out:
     aio_context_acquire(blk_get_aio_context(s->conf.conf.blk));
@@ -909,6 +920,7 @@ static int virtio_blk_handle_zone_append(VirtIOBlockReq *req,
     int64_t offset = virtio_ldq_p(vdev, &req->out.sector) << BDRV_SECTOR_BITS;
     int64_t len = iov_size(out_iov, out_num);
 
+    trace_virtio_blk_handle_zone_append(vdev, req, offset >> BDRV_SECTOR_BITS);
     if (!check_zoned_request(s, offset, len, true, &err_status)) {
         goto out;
     }
-- 
2.39.2

