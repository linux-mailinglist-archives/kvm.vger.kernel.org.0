Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70D9044231B
	for <lists+kvm@lfdr.de>; Mon,  1 Nov 2021 23:09:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232397AbhKAWMW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Nov 2021 18:12:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:39386 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232363AbhKAWMR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Nov 2021 18:12:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635804583;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jP/I5apHpfB9miqWjOSmHHOjh4FLTnrs+cMqC3xHGrM=;
        b=UJ5ZYR8tosx+CzcwON4T+X4Pi1p9fiytMUwu6K59IdAOrEjcL6tYOckZh6mWgAEMaWzGNb
        GJsPqHbPkym0ee8SwOdKSLQXidEtiXVZUgTjkyK+QblnVNU4R9BH13RooVy4Fcax8pQ/jC
        Gf+M7G/GN81pNH1GLN9S/L/bL4GtVqg=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-193-B3mBpnEbPPaU_3amosRpJQ-1; Mon, 01 Nov 2021 18:09:42 -0400
X-MC-Unique: B3mBpnEbPPaU_3amosRpJQ-1
Received: by mail-wm1-f72.google.com with SMTP id n189-20020a1c27c6000000b00322f2e380f2so171879wmn.6
        for <kvm@vger.kernel.org>; Mon, 01 Nov 2021 15:09:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jP/I5apHpfB9miqWjOSmHHOjh4FLTnrs+cMqC3xHGrM=;
        b=d0d6C5Zn2L7YNhUOGwVG+r6KQyUELO5GM0IDehI6q2wyimrQI1BgKbxFhr4nx2hvqf
         /dQNlp4mKD80oJn5iETRkgRboQafWBeDlCiVmNEkhwtTaD1JqpxS7Aj8MBGnFiRl9LE2
         vtrumKZNyOcBDx5DsXQCHBTFHVTLfryDcVj9EzFRGCyvtsOf4p9FXahhMEFOwtt7+Lmk
         H3noZMgtgLtSmAT1nH8DSxdbwmWStiVV0YWw1iUBEnccumeKKYmYWCD4Q57NWnpHd+4X
         2cVjhR75FoUYkLRFoRJQyuZf1BfwenvZ414eKyQynd1wzCs604kpsY/x/xB+wtcBoMaD
         olrg==
X-Gm-Message-State: AOAM532vQRccGX4B1iaMjUz29+4L3p7dxcfwIresifD6NkQZntRLvF+Y
        1IHg1/9/lA4qBdOubO8snhdzF48v3oDzWUH/tgdoy80y0b6GBdwHT2t7CRx2XbsqTosrZUGGLOf
        4bx4DaD/JxAAT
X-Received: by 2002:a5d:69ca:: with SMTP id s10mr17619039wrw.312.1635804581263;
        Mon, 01 Nov 2021 15:09:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwekiY665T3KtWYk+MojmKh2E8nDk/brzhW8Smm/r4bdKRN1BvOX4dI3pL5wzRW0aYS3i58/A==
X-Received: by 2002:a5d:69ca:: with SMTP id s10mr17619009wrw.312.1635804581077;
        Mon, 01 Nov 2021 15:09:41 -0700 (PDT)
Received: from localhost (static-233-86-86-188.ipcom.comunitel.net. [188.86.86.233])
        by smtp.gmail.com with ESMTPSA id k8sm688985wms.41.2021.11.01.15.09.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 15:09:40 -0700 (PDT)
From:   Juan Quintela <quintela@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Markus Armbruster <armbru@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        xen-devel@lists.xenproject.org,
        Richard Henderson <richard.henderson@linaro.org>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Eric Blake <eblake@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        kvm@vger.kernel.org, Peter Xu <peterx@redhat.com>,
        =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
        Paul Durrant <paul@xen.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Anthony Perard <anthony.perard@citrix.com>,
        =?UTF-8?q?Hyman=20Huang=28=E9=BB=84=E5=8B=87=29?= 
        <huangy81@chinatelecom.cn>
Subject: [PULL 20/20] migration/dirtyrate: implement dirty-bitmap dirtyrate calculation
Date:   Mon,  1 Nov 2021 23:09:12 +0100
Message-Id: <20211101220912.10039-21-quintela@redhat.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101220912.10039-1-quintela@redhat.com>
References: <20211101220912.10039-1-quintela@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Hyman Huang(黄勇) <huangy81@chinatelecom.cn>

introduce dirty-bitmap mode as the third method of calc-dirty-rate.
implement dirty-bitmap dirtyrate calculation, which can be used
to measuring dirtyrate in the absence of dirty-ring.

introduce "dirty_bitmap:-b" option in hmp calc_dirty_rate to
indicate dirty bitmap method should be used for calculation.

Signed-off-by: Hyman Huang(黄勇) <huangy81@chinatelecom.cn>
Reviewed-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Juan Quintela <quintela@redhat.com>
Signed-off-by: Juan Quintela <quintela@redhat.com>
---
 qapi/migration.json   |   6 ++-
 migration/dirtyrate.c | 112 ++++++++++++++++++++++++++++++++++++++----
 hmp-commands.hx       |   9 ++--
 3 files changed, 112 insertions(+), 15 deletions(-)

diff --git a/qapi/migration.json b/qapi/migration.json
index fae4bc608c..87146ceea2 100644
--- a/qapi/migration.json
+++ b/qapi/migration.json
@@ -1770,13 +1770,15 @@
 #
 # @page-sampling: calculate dirtyrate by sampling pages.
 #
-# @dirty-ring: calculate dirtyrate by via dirty ring.
+# @dirty-ring: calculate dirtyrate by dirty ring.
+#
+# @dirty-bitmap: calculate dirtyrate by dirty bitmap.
 #
 # Since: 6.1
 #
 ##
 { 'enum': 'DirtyRateMeasureMode',
-  'data': ['page-sampling', 'dirty-ring'] }
+  'data': ['page-sampling', 'dirty-ring', 'dirty-bitmap'] }
 
 ##
 # @DirtyRateInfo:
diff --git a/migration/dirtyrate.c b/migration/dirtyrate.c
index 17b3d2cbb5..d65e744af9 100644
--- a/migration/dirtyrate.c
+++ b/migration/dirtyrate.c
@@ -15,6 +15,7 @@
 #include "qapi/error.h"
 #include "cpu.h"
 #include "exec/ramblock.h"
+#include "exec/ram_addr.h"
 #include "qemu/rcu_queue.h"
 #include "qemu/main-loop.h"
 #include "qapi/qapi-commands-migration.h"
@@ -118,6 +119,10 @@ static struct DirtyRateInfo *query_dirty_rate_info(void)
             }
             info->vcpu_dirty_rate = head;
         }
+
+        if (dirtyrate_mode == DIRTY_RATE_MEASURE_MODE_DIRTY_BITMAP) {
+            info->sample_pages = 0;
+        }
     }
 
     trace_query_dirty_rate_info(DirtyRateStatus_str(CalculatingState));
@@ -429,6 +434,79 @@ static int64_t do_calculate_dirtyrate_vcpu(DirtyPageRecord dirty_pages)
     return memory_size_MB / time_s;
 }
 
+static inline void record_dirtypages_bitmap(DirtyPageRecord *dirty_pages,
+                                            bool start)
+{
+    if (start) {
+        dirty_pages->start_pages = total_dirty_pages;
+    } else {
+        dirty_pages->end_pages = total_dirty_pages;
+    }
+}
+
+static void do_calculate_dirtyrate_bitmap(DirtyPageRecord dirty_pages)
+{
+    DirtyStat.dirty_rate = do_calculate_dirtyrate_vcpu(dirty_pages);
+}
+
+static inline void dirtyrate_manual_reset_protect(void)
+{
+    RAMBlock *block = NULL;
+
+    WITH_RCU_READ_LOCK_GUARD() {
+        RAMBLOCK_FOREACH_MIGRATABLE(block) {
+            memory_region_clear_dirty_bitmap(block->mr, 0,
+                                             block->used_length);
+        }
+    }
+}
+
+static void calculate_dirtyrate_dirty_bitmap(struct DirtyRateConfig config)
+{
+    int64_t msec = 0;
+    int64_t start_time;
+    DirtyPageRecord dirty_pages;
+
+    qemu_mutex_lock_iothread();
+    memory_global_dirty_log_start(GLOBAL_DIRTY_DIRTY_RATE);
+
+    /*
+     * 1'round of log sync may return all 1 bits with
+     * KVM_DIRTY_LOG_INITIALLY_SET enable
+     * skip it unconditionally and start dirty tracking
+     * from 2'round of log sync
+     */
+    memory_global_dirty_log_sync();
+
+    /*
+     * reset page protect manually and unconditionally.
+     * this make sure kvm dirty log be cleared if
+     * KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE cap is enabled.
+     */
+    dirtyrate_manual_reset_protect();
+    qemu_mutex_unlock_iothread();
+
+    record_dirtypages_bitmap(&dirty_pages, true);
+
+    start_time = qemu_clock_get_ms(QEMU_CLOCK_REALTIME);
+    DirtyStat.start_time = start_time / 1000;
+
+    msec = config.sample_period_seconds * 1000;
+    msec = set_sample_page_period(msec, start_time);
+    DirtyStat.calc_time = msec / 1000;
+
+    /*
+     * dirtyrate_global_dirty_log_stop do two things.
+     * 1. fetch dirty bitmap from kvm
+     * 2. stop dirty tracking
+     */
+    dirtyrate_global_dirty_log_stop();
+
+    record_dirtypages_bitmap(&dirty_pages, false);
+
+    do_calculate_dirtyrate_bitmap(dirty_pages);
+}
+
 static void calculate_dirtyrate_dirty_ring(struct DirtyRateConfig config)
 {
     CPUState *cpu;
@@ -514,7 +592,9 @@ out:
 
 static void calculate_dirtyrate(struct DirtyRateConfig config)
 {
-    if (config.mode == DIRTY_RATE_MEASURE_MODE_DIRTY_RING) {
+    if (config.mode == DIRTY_RATE_MEASURE_MODE_DIRTY_BITMAP) {
+        calculate_dirtyrate_dirty_bitmap(config);
+    } else if (config.mode == DIRTY_RATE_MEASURE_MODE_DIRTY_RING) {
         calculate_dirtyrate_dirty_ring(config);
     } else {
         calculate_dirtyrate_sample_vm(config);
@@ -597,12 +677,15 @@ void qmp_calc_dirty_rate(int64_t calc_time,
 
     /*
      * dirty ring mode only works when kvm dirty ring is enabled.
+     * on the contrary, dirty bitmap mode is not.
      */
-    if ((mode == DIRTY_RATE_MEASURE_MODE_DIRTY_RING) &&
-        !kvm_dirty_ring_enabled()) {
-        error_setg(errp, "dirty ring is disabled, use sample-pages method "
-                         "or remeasure later.");
-        return;
+    if (((mode == DIRTY_RATE_MEASURE_MODE_DIRTY_RING) &&
+        !kvm_dirty_ring_enabled()) ||
+        ((mode == DIRTY_RATE_MEASURE_MODE_DIRTY_BITMAP) &&
+         kvm_dirty_ring_enabled())) {
+        error_setg(errp, "mode %s is not enabled, use other method instead.",
+                         DirtyRateMeasureMode_str(mode));
+         return;
     }
 
     /*
@@ -678,9 +761,8 @@ void hmp_calc_dirty_rate(Monitor *mon, const QDict *qdict)
     int64_t sample_pages = qdict_get_try_int(qdict, "sample_pages_per_GB", -1);
     bool has_sample_pages = (sample_pages != -1);
     bool dirty_ring = qdict_get_try_bool(qdict, "dirty_ring", false);
-    DirtyRateMeasureMode mode =
-        (dirty_ring ? DIRTY_RATE_MEASURE_MODE_DIRTY_RING :
-         DIRTY_RATE_MEASURE_MODE_PAGE_SAMPLING);
+    bool dirty_bitmap = qdict_get_try_bool(qdict, "dirty_bitmap", false);
+    DirtyRateMeasureMode mode = DIRTY_RATE_MEASURE_MODE_PAGE_SAMPLING;
     Error *err = NULL;
 
     if (!sec) {
@@ -688,6 +770,18 @@ void hmp_calc_dirty_rate(Monitor *mon, const QDict *qdict)
         return;
     }
 
+    if (dirty_ring && dirty_bitmap) {
+        monitor_printf(mon, "Either dirty ring or dirty bitmap "
+                       "can be specified!\n");
+        return;
+    }
+
+    if (dirty_bitmap) {
+        mode = DIRTY_RATE_MEASURE_MODE_DIRTY_BITMAP;
+    } else if (dirty_ring) {
+        mode = DIRTY_RATE_MEASURE_MODE_DIRTY_RING;
+    }
+
     qmp_calc_dirty_rate(sec, has_sample_pages, sample_pages, true,
                         mode, &err);
     if (err) {
diff --git a/hmp-commands.hx b/hmp-commands.hx
index b6d47bd03f..3a5aeba3fe 100644
--- a/hmp-commands.hx
+++ b/hmp-commands.hx
@@ -1737,9 +1737,10 @@ ERST
 
     {
         .name       = "calc_dirty_rate",
-        .args_type  = "dirty_ring:-r,second:l,sample_pages_per_GB:l?",
-        .params     = "[-r] second [sample_pages_per_GB]",
-        .help       = "start a round of guest dirty rate measurement (using -d to"
-                      "\n\t\t\t specify dirty ring as the method of calculation)",
+        .args_type  = "dirty_ring:-r,dirty_bitmap:-b,second:l,sample_pages_per_GB:l?",
+        .params     = "[-r] [-b] second [sample_pages_per_GB]",
+        .help       = "start a round of guest dirty rate measurement (using -r to"
+                      "\n\t\t\t specify dirty ring as the method of calculation and"
+                      "\n\t\t\t -b to specify dirty bitmap as method of calculation)",
         .cmd        = hmp_calc_dirty_rate,
     },
-- 
2.33.1

