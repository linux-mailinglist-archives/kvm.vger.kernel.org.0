Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF85E6C5ECB
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 06:30:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230335AbjCWFaJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 01:30:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230299AbjCWFaB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 01:30:01 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAA3C20040
        for <kvm@vger.kernel.org>; Wed, 22 Mar 2023 22:29:56 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id o2so13908909plg.4
        for <kvm@vger.kernel.org>; Wed, 22 Mar 2023 22:29:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679549396;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HfwuIqOMAsPZcIyWZ3B0EhxHRj5yKxCrI+6IZLrn1MI=;
        b=ANj+yN9oMbCrqMfkxZgB3S5TwDqWJKSBZycLGh9KOBVY3wC/5RgTBGJumugY0cMZ+0
         eZomjaKCj50wTda/je0oIUCW/3eZtgdMvoUblCOsN9fIYMoVS+5+Kj6G54rV3CBcngbC
         gYFTlgOdoqLhZ70EhuKsyvc2rEV1Yya3Ybc9W14Kp/I57spASm/hU624tKOs5BuhbRNT
         3SrSV9wmyZmFQRJ3H+wWBgy8EVjAZMCSuysIz9M+WHdPDTUWABxskjFFE6NDklT72Iyl
         m5/5mrm+oYYppAmY160CYvEHWTkXzBCi4ueUUQnL+IpdBxDkaL2e2zUcNeRS4clfZLc+
         gHJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679549396;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HfwuIqOMAsPZcIyWZ3B0EhxHRj5yKxCrI+6IZLrn1MI=;
        b=NBIws+doLwdeB4vtMin8NmYER89ENkvit9Xn+fBisYE7b2DM/lrkdQ16mSQrj3J/Fe
         fiwljhhcEMBX4emwQhJiVfoMtWXYFU8A+qY9gc04pHnFw5JkAMWleBXghFZrVrIGrYbb
         QWIjzyBgt6KD8LzD55rJLhEeBXT7jYU8GI2QWTQaxMHdWptt0R6MYOhLh+ip14Fwn5S+
         S/swQpiTJ51l4/Hf4y3X3gNLBWIw1QvLUTZAdogbLK6+fuFhh6K4du1GaKG7VLxHSKH6
         x5MlZCbp1f6s/4+6FRlMbe5GdtD091PWcrnLaW7d6H4bqvLPg6RowQibbbjW1Q0f0dBp
         G5QQ==
X-Gm-Message-State: AO0yUKX5Gvw54Pp6Xp2lf5YiONmZaIKTdUvph1TnPpkjEHQ/kHCO/kC0
        TkGqGMX8T4DF+SN62NoQCUY=
X-Google-Smtp-Source: AK7set+GABiA81vrLnNipxl95yLLGQDia1RpnUHgIinR6tEXzs7WwAyubIHZ2sXmnbXchQL11dMgew==
X-Received: by 2002:a17:902:fb10:b0:19e:9807:de48 with SMTP id le16-20020a170902fb1000b0019e9807de48mr4309354plb.23.1679549395854;
        Wed, 22 Mar 2023 22:29:55 -0700 (PDT)
Received: from fedlinux.. ([106.84.129.82])
        by smtp.gmail.com with ESMTPSA id r18-20020a63ce52000000b00502f4c62fd3sm3302965pgi.33.2023.03.22.22.29.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 22:29:55 -0700 (PDT)
From:   Sam Li <faithilikerun@gmail.com>
To:     qemu-devel@nongnu.org
Cc:     Kevin Wolf <kwolf@redhat.com>,
        Raphael Norwitz <raphael.norwitz@nutanix.com>,
        qemu-block@nongnu.org, Stefan Hajnoczi <stefanha@redhat.com>,
        damien.lemoal@opensource.wdc.com, kvm@vger.kernel.org,
        hare@suse.de, Paolo Bonzini <pbonzini@redhat.com>,
        dmitry.fomichev@wdc.com, Hanna Reitz <hreitz@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sam Li <faithilikerun@gmail.com>
Subject: [PATCH v8 3/4] block: add accounting for zone append operation
Date:   Thu, 23 Mar 2023 13:28:27 +0800
Message-Id: <20230323052828.6545-4-faithilikerun@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230323052828.6545-1-faithilikerun@gmail.com>
References: <20230323052828.6545-1-faithilikerun@gmail.com>
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

Taking account of the new zone append write operation for zoned devices,
BLOCK_ACCT_ZONE_APPEND enum is introduced as other I/O request type (read,
write, flush).

Signed-off-by: Sam Li <faithilikerun@gmail.com>
---
 block/qapi-sysemu.c        | 11 +++++++
 block/qapi.c               | 18 +++++++++++
 hw/block/virtio-blk.c      |  4 +++
 include/block/accounting.h |  1 +
 qapi/block-core.json       | 62 +++++++++++++++++++++++++++++++-------
 qapi/block.json            |  4 +++
 6 files changed, 89 insertions(+), 11 deletions(-)

diff --git a/block/qapi-sysemu.c b/block/qapi-sysemu.c
index 7bd7554150..cec3c1afb4 100644
--- a/block/qapi-sysemu.c
+++ b/block/qapi-sysemu.c
@@ -517,6 +517,7 @@ void qmp_block_latency_histogram_set(
     bool has_boundaries, uint64List *boundaries,
     bool has_boundaries_read, uint64List *boundaries_read,
     bool has_boundaries_write, uint64List *boundaries_write,
+    bool has_boundaries_append, uint64List *boundaries_append,
     bool has_boundaries_flush, uint64List *boundaries_flush,
     Error **errp)
 {
@@ -557,6 +558,16 @@ void qmp_block_latency_histogram_set(
         }
     }
 
+    if (has_boundaries || has_boundaries_append) {
+        ret = block_latency_histogram_set(
+                stats, BLOCK_ACCT_ZONE_APPEND,
+                has_boundaries_append ? boundaries_append : boundaries);
+        if (ret) {
+            error_setg(errp, "Device '%s' set append write boundaries fail", id);
+            return;
+        }
+    }
+
     if (has_boundaries || has_boundaries_flush) {
         ret = block_latency_histogram_set(
             stats, BLOCK_ACCT_FLUSH,
diff --git a/block/qapi.c b/block/qapi.c
index c84147849d..2684484e9d 100644
--- a/block/qapi.c
+++ b/block/qapi.c
@@ -533,27 +533,36 @@ static void bdrv_query_blk_stats(BlockDeviceStats *ds, BlockBackend *blk)
 
     ds->rd_bytes = stats->nr_bytes[BLOCK_ACCT_READ];
     ds->wr_bytes = stats->nr_bytes[BLOCK_ACCT_WRITE];
+    ds->zone_append_bytes = stats->nr_bytes[BLOCK_ACCT_ZONE_APPEND];
     ds->unmap_bytes = stats->nr_bytes[BLOCK_ACCT_UNMAP];
     ds->rd_operations = stats->nr_ops[BLOCK_ACCT_READ];
     ds->wr_operations = stats->nr_ops[BLOCK_ACCT_WRITE];
+    ds->zone_append_operations = stats->nr_ops[BLOCK_ACCT_ZONE_APPEND];
     ds->unmap_operations = stats->nr_ops[BLOCK_ACCT_UNMAP];
 
     ds->failed_rd_operations = stats->failed_ops[BLOCK_ACCT_READ];
     ds->failed_wr_operations = stats->failed_ops[BLOCK_ACCT_WRITE];
+    ds->failed_zone_append_operations =
+        stats->failed_ops[BLOCK_ACCT_ZONE_APPEND];
     ds->failed_flush_operations = stats->failed_ops[BLOCK_ACCT_FLUSH];
     ds->failed_unmap_operations = stats->failed_ops[BLOCK_ACCT_UNMAP];
 
     ds->invalid_rd_operations = stats->invalid_ops[BLOCK_ACCT_READ];
     ds->invalid_wr_operations = stats->invalid_ops[BLOCK_ACCT_WRITE];
+    ds->invalid_zone_append_operations =
+        stats->invalid_ops[BLOCK_ACCT_ZONE_APPEND];
     ds->invalid_flush_operations =
         stats->invalid_ops[BLOCK_ACCT_FLUSH];
     ds->invalid_unmap_operations = stats->invalid_ops[BLOCK_ACCT_UNMAP];
 
     ds->rd_merged = stats->merged[BLOCK_ACCT_READ];
     ds->wr_merged = stats->merged[BLOCK_ACCT_WRITE];
+    ds->zone_append_merged = stats->merged[BLOCK_ACCT_ZONE_APPEND];
     ds->unmap_merged = stats->merged[BLOCK_ACCT_UNMAP];
     ds->flush_operations = stats->nr_ops[BLOCK_ACCT_FLUSH];
     ds->wr_total_time_ns = stats->total_time_ns[BLOCK_ACCT_WRITE];
+    ds->zone_append_total_time_ns =
+        stats->total_time_ns[BLOCK_ACCT_ZONE_APPEND];
     ds->rd_total_time_ns = stats->total_time_ns[BLOCK_ACCT_READ];
     ds->flush_total_time_ns = stats->total_time_ns[BLOCK_ACCT_FLUSH];
     ds->unmap_total_time_ns = stats->total_time_ns[BLOCK_ACCT_UNMAP];
@@ -571,6 +580,7 @@ static void bdrv_query_blk_stats(BlockDeviceStats *ds, BlockBackend *blk)
 
         TimedAverage *rd = &ts->latency[BLOCK_ACCT_READ];
         TimedAverage *wr = &ts->latency[BLOCK_ACCT_WRITE];
+        TimedAverage *zap = &ts->latency[BLOCK_ACCT_ZONE_APPEND];
         TimedAverage *fl = &ts->latency[BLOCK_ACCT_FLUSH];
 
         dev_stats->interval_length = ts->interval_length;
@@ -583,6 +593,10 @@ static void bdrv_query_blk_stats(BlockDeviceStats *ds, BlockBackend *blk)
         dev_stats->max_wr_latency_ns = timed_average_max(wr);
         dev_stats->avg_wr_latency_ns = timed_average_avg(wr);
 
+        dev_stats->min_zone_append_latency_ns = timed_average_min(zap);
+        dev_stats->max_zone_append_latency_ns = timed_average_max(zap);
+        dev_stats->avg_zone_append_latency_ns = timed_average_avg(zap);
+
         dev_stats->min_flush_latency_ns = timed_average_min(fl);
         dev_stats->max_flush_latency_ns = timed_average_max(fl);
         dev_stats->avg_flush_latency_ns = timed_average_avg(fl);
@@ -591,6 +605,8 @@ static void bdrv_query_blk_stats(BlockDeviceStats *ds, BlockBackend *blk)
             block_acct_queue_depth(ts, BLOCK_ACCT_READ);
         dev_stats->avg_wr_queue_depth =
             block_acct_queue_depth(ts, BLOCK_ACCT_WRITE);
+        dev_stats->avg_zone_append_queue_depth =
+            block_acct_queue_depth(ts, BLOCK_ACCT_ZONE_APPEND);
 
         QAPI_LIST_PREPEND(ds->timed_stats, dev_stats);
     }
@@ -600,6 +616,8 @@ static void bdrv_query_blk_stats(BlockDeviceStats *ds, BlockBackend *blk)
         = bdrv_latency_histogram_stats(&hgram[BLOCK_ACCT_READ]);
     ds->wr_latency_histogram
         = bdrv_latency_histogram_stats(&hgram[BLOCK_ACCT_WRITE]);
+    ds->zone_append_latency_histogram
+        = bdrv_latency_histogram_stats(&hgram[BLOCK_ACCT_ZONE_APPEND]);
     ds->flush_latency_histogram
         = bdrv_latency_histogram_stats(&hgram[BLOCK_ACCT_FLUSH]);
 }
diff --git a/hw/block/virtio-blk.c b/hw/block/virtio-blk.c
index 66c2bc4b16..0d85c2c9b0 100644
--- a/hw/block/virtio-blk.c
+++ b/hw/block/virtio-blk.c
@@ -919,6 +919,10 @@ static int virtio_blk_handle_zone_append(VirtIOBlockReq *req,
     data->in_num = in_num;
     data->zone_append_data.offset = offset;
     qemu_iovec_init_external(&req->qiov, out_iov, out_num);
+
+    block_acct_start(blk_get_stats(s->blk), &req->acct, len,
+                     BLOCK_ACCT_ZONE_APPEND);
+
     blk_aio_zone_append(s->blk, &data->zone_append_data.offset, &req->qiov, 0,
                         virtio_blk_zone_append_complete, data);
     return 0;
diff --git a/include/block/accounting.h b/include/block/accounting.h
index b9caad60d5..a59e39f49d 100644
--- a/include/block/accounting.h
+++ b/include/block/accounting.h
@@ -37,6 +37,7 @@ enum BlockAcctType {
     BLOCK_ACCT_READ,
     BLOCK_ACCT_WRITE,
     BLOCK_ACCT_FLUSH,
+    BLOCK_ACCT_ZONE_APPEND,
     BLOCK_ACCT_UNMAP,
     BLOCK_MAX_IOTYPE,
 };
diff --git a/qapi/block-core.json b/qapi/block-core.json
index c05ad0c07e..501b554fc5 100644
--- a/qapi/block-core.json
+++ b/qapi/block-core.json
@@ -849,6 +849,9 @@
 # @min_wr_latency_ns: Minimum latency of write operations in the
 #                     defined interval, in nanoseconds.
 #
+# @min_zone_append_latency_ns: Minimum latency of zone append operations
+#                              in the defined interval, in nanoseconds.
+#
 # @min_flush_latency_ns: Minimum latency of flush operations in the
 #                        defined interval, in nanoseconds.
 #
@@ -858,6 +861,9 @@
 # @max_wr_latency_ns: Maximum latency of write operations in the
 #                     defined interval, in nanoseconds.
 #
+# @max_zone_append_latency_ns: Maximum latency of zone append operations
+#                              in the defined interval, in nanoseconds.
+#
 # @max_flush_latency_ns: Maximum latency of flush operations in the
 #                        defined interval, in nanoseconds.
 #
@@ -867,6 +873,9 @@
 # @avg_wr_latency_ns: Average latency of write operations in the
 #                     defined interval, in nanoseconds.
 #
+# @avg_zone_append_latency_ns: Average latency of zone append operations
+#                              in the defined interval, in nanoseconds.
+#
 # @avg_flush_latency_ns: Average latency of flush operations in the
 #                        defined interval, in nanoseconds.
 #
@@ -876,15 +885,22 @@
 # @avg_wr_queue_depth: Average number of pending write operations
 #                      in the defined interval.
 #
+# @avg_zone_append_queue_depth: Average number of pending zone append
+#                               operations in the defined interval.
+#
 # Since: 2.5
 ##
 { 'struct': 'BlockDeviceTimedStats',
   'data': { 'interval_length': 'int', 'min_rd_latency_ns': 'int',
             'max_rd_latency_ns': 'int', 'avg_rd_latency_ns': 'int',
             'min_wr_latency_ns': 'int', 'max_wr_latency_ns': 'int',
-            'avg_wr_latency_ns': 'int', 'min_flush_latency_ns': 'int',
-            'max_flush_latency_ns': 'int', 'avg_flush_latency_ns': 'int',
-            'avg_rd_queue_depth': 'number', 'avg_wr_queue_depth': 'number' } }
+            'avg_wr_latency_ns': 'int', 'min_zone_append_latency_ns': 'int',
+            'max_zone_append_latency_ns': 'int',
+            'avg_zone_append_latency_ns': 'int',
+            'min_flush_latency_ns': 'int', 'max_flush_latency_ns': 'int',
+            'avg_flush_latency_ns': 'int', 'avg_rd_queue_depth': 'number',
+            'avg_wr_queue_depth': 'number',
+            'avg_zone_append_queue_depth': 'number'  } }
 
 ##
 # @BlockDeviceStats:
@@ -895,12 +911,17 @@
 #
 # @wr_bytes: The number of bytes written by the device.
 #
+# @zone_append_bytes: The number of bytes appended by the zoned devices.
+#
 # @unmap_bytes: The number of bytes unmapped by the device (Since 4.2)
 #
 # @rd_operations: The number of read operations performed by the device.
 #
 # @wr_operations: The number of write operations performed by the device.
 #
+# @zone_append_operations: The number of zone append operations performed
+#                          by the zoned devices.
+#
 # @flush_operations: The number of cache flush operations performed by the
 #                    device (since 0.15)
 #
@@ -911,6 +932,9 @@
 #
 # @wr_total_time_ns: Total time spent on writes in nanoseconds (since 0.15).
 #
+# @zone_append_total_time_ns: Total time spent on zone append writes
+#                             in nanoseconds.
+#
 # @flush_total_time_ns: Total time spent on cache flushes in nanoseconds
 #                       (since 0.15).
 #
@@ -928,6 +952,9 @@
 # @wr_merged: Number of write requests that have been merged into another
 #             request (Since 2.3).
 #
+# @zone_append_merged: Number of zone append requests that have been merged
+#                      into another request.
+#
 # @unmap_merged: Number of unmap requests that have been merged into another
 #                request (Since 4.2)
 #
@@ -941,6 +968,9 @@
 # @failed_wr_operations: The number of failed write operations
 #                        performed by the device (Since 2.5)
 #
+# @failed_zone_append_operations: The number of failed zone append write
+#                                 operations performed by the zoned devices
+#
 # @failed_flush_operations: The number of failed flush operations
 #                           performed by the device (Since 2.5)
 #
@@ -953,6 +983,9 @@
 # @invalid_wr_operations: The number of invalid write operations
 #                         performed by the device (Since 2.5)
 #
+# @invalid_zone_append_operations: The number of invalid zone append operations
+#                                  performed by the zoned device
+#
 # @invalid_flush_operations: The number of invalid flush operations
 #                            performed by the device (Since 2.5)
 #
@@ -972,27 +1005,34 @@
 #
 # @wr_latency_histogram: @BlockLatencyHistogramInfo. (Since 4.0)
 #
+# @zone_append_latency_histogram: @BlockLatencyHistogramInfo.
+#
 # @flush_latency_histogram: @BlockLatencyHistogramInfo. (Since 4.0)
 #
 # Since: 0.14
 ##
 { 'struct': 'BlockDeviceStats',
-  'data': {'rd_bytes': 'int', 'wr_bytes': 'int', 'unmap_bytes' : 'int',
-           'rd_operations': 'int', 'wr_operations': 'int',
+  'data': {'rd_bytes': 'int', 'wr_bytes': 'int', 'zone_append_bytes': 'int',
+           'unmap_bytes' : 'int', 'rd_operations': 'int',
+           'wr_operations': 'int', 'zone_append_operations': 'int',
            'flush_operations': 'int', 'unmap_operations': 'int',
            'rd_total_time_ns': 'int', 'wr_total_time_ns': 'int',
-           'flush_total_time_ns': 'int', 'unmap_total_time_ns': 'int',
-           'wr_highest_offset': 'int',
-           'rd_merged': 'int', 'wr_merged': 'int', 'unmap_merged': 'int',
-           '*idle_time_ns': 'int',
+           'zone_append_total_time_ns': 'int', 'flush_total_time_ns': 'int',
+           'unmap_total_time_ns': 'int', 'wr_highest_offset': 'int',
+           'rd_merged': 'int', 'wr_merged': 'int', 'zone_append_merged': 'int',
+           'unmap_merged': 'int', '*idle_time_ns': 'int',
            'failed_rd_operations': 'int', 'failed_wr_operations': 'int',
-           'failed_flush_operations': 'int', 'failed_unmap_operations': 'int',
-           'invalid_rd_operations': 'int', 'invalid_wr_operations': 'int',
+           'failed_zone_append_operations': 'int',
+           'failed_flush_operations': 'int',
+           'failed_unmap_operations': 'int', 'invalid_rd_operations': 'int',
+           'invalid_wr_operations': 'int',
+           'invalid_zone_append_operations': 'int',
            'invalid_flush_operations': 'int', 'invalid_unmap_operations': 'int',
            'account_invalid': 'bool', 'account_failed': 'bool',
            'timed_stats': ['BlockDeviceTimedStats'],
            '*rd_latency_histogram': 'BlockLatencyHistogramInfo',
            '*wr_latency_histogram': 'BlockLatencyHistogramInfo',
+           '*zone_append_latency_histogram': 'BlockLatencyHistogramInfo',
            '*flush_latency_histogram': 'BlockLatencyHistogramInfo' } }
 
 ##
diff --git a/qapi/block.json b/qapi/block.json
index 5fe068f903..5a57ef4a9f 100644
--- a/qapi/block.json
+++ b/qapi/block.json
@@ -525,6 +525,9 @@
 # @boundaries-write: list of interval boundary values for write latency
 #                    histogram.
 #
+# @boundaries-zap: list of interval boundary values for zone append write
+#                  latency histogram.
+#
 # @boundaries-flush: list of interval boundary values for flush latency
 #                    histogram.
 #
@@ -573,5 +576,6 @@
            '*boundaries': ['uint64'],
            '*boundaries-read': ['uint64'],
            '*boundaries-write': ['uint64'],
+           '*boundaries-zap': ['uint64'],
            '*boundaries-flush': ['uint64'] },
   'allow-preconfig': true }
-- 
2.39.2

