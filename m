Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B4B044230C
	for <lists+kvm@lfdr.de>; Mon,  1 Nov 2021 23:09:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232273AbhKAWL5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Nov 2021 18:11:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:39872 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232027AbhKAWL4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Nov 2021 18:11:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635804562;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zC+zxEH+pUhjgORZ5ETFB7/+CsNzKhs7SNRZ+CUF1/0=;
        b=D0ygIqxRSY5Sl+3gvqB/NSQ8h4qa/gD/WFYh5IuLJraAntcO8uP6NH0Ci5xFMQuthBGBxG
        jhiX9O8doGFwN36n5ItLILypvBkTjo4IiIgvqpngg6WrPT2BnaIJHzXnGPq94AMNJEuZnH
        EE5oCAg4SoyUOSUAEj6pyJEFrz9ZajY=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-145-EqeP25fDP9yMszYkFXiEIg-1; Mon, 01 Nov 2021 18:09:21 -0400
X-MC-Unique: EqeP25fDP9yMszYkFXiEIg-1
Received: by mail-wr1-f71.google.com with SMTP id q17-20020adfcd91000000b0017bcb12ad4fso3953582wrj.12
        for <kvm@vger.kernel.org>; Mon, 01 Nov 2021 15:09:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zC+zxEH+pUhjgORZ5ETFB7/+CsNzKhs7SNRZ+CUF1/0=;
        b=RMkFJXZr2q1BZY9Oq1Sp9aiDPZKlOmm8f6Ks8F3Lea/N1G4ZyxRxRCRqcn78fvOut/
         6bT2a8E6L6oHsyhmAY4LteGTIhW1+W0mxj0m/wxrQRrr2czB/YWTlQDCEqQttS//faqC
         lec+KLvQ2K60mjnwflVRF1fajJVKjyDmDVDoOrkq3YVHkkfr9uc0IgkgARL0v1bSTk+U
         l4InZox2i2CN2dMcF5yb7AiOTl+B5uOnMmv8nKQcEtSbo4yUEvWxJPvUYFN3QDq3UO/j
         prGol1Vb4q7LTdNn0wp36hdl/xvNAQENbRP2ovNtysTpteMJMNszpFtA0Gisl3idcsfH
         AJ1w==
X-Gm-Message-State: AOAM532uxcd9qctWleIhX5e4wlv274cfLDA3aEzPKY9Qsi6kGJBWZq0Z
        PCngEqkgbzigFW6Z5wpTT4jBTChC+DcIuFxH5pn4S+nwmSz/rqWyGHv6GKsDLWYVHGNDkgDSu98
        Ew6TdB4bVpYI9
X-Received: by 2002:a5d:46cb:: with SMTP id g11mr24140821wrs.26.1635804559961;
        Mon, 01 Nov 2021 15:09:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwOqU8wWYVaIjRWd2sjZqSUpY8HCgD5Gu3n1DFyO90oDUDzJdkVJM68NrFLzLaF6oWA+5DyZw==
X-Received: by 2002:a5d:46cb:: with SMTP id g11mr24140791wrs.26.1635804559728;
        Mon, 01 Nov 2021 15:09:19 -0700 (PDT)
Received: from localhost (static-233-86-86-188.ipcom.comunitel.net. [188.86.86.233])
        by smtp.gmail.com with ESMTPSA id g5sm709951wmi.2.2021.11.01.15.09.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 15:09:19 -0700 (PDT)
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
        =?UTF-8?q?Hyman=20Huang=28=C3=A9=C2=BB=E2=80=9E=C3=A5=E2=80=B9?=
         =?UTF-8?q?=E2=80=A1=29?= <huangy81@chinatelecom.cn>
Subject: [PULL 04/20] migration/dirtyrate: introduce struct and adjust DirtyRateStat
Date:   Mon,  1 Nov 2021 23:08:56 +0100
Message-Id: <20211101220912.10039-5-quintela@redhat.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101220912.10039-1-quintela@redhat.com>
References: <20211101220912.10039-1-quintela@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Hyman Huang(é»„å‹‡) <huangy81@chinatelecom.cn>

introduce "DirtyRateMeasureMode" to specify what method should be
used to calculate dirty rate, introduce "DirtyRateVcpu" to store
dirty rate for each vcpu.

use union to store stat data of specific mode

Signed-off-by: Hyman Huang(é»„å‹‡) <huangy81@chinatelecom.cn>
Message-Id: <661c98c40f40e163aa58334337af8f3ddf41316a.1624040308.git.huangy81@chinatelecom.cn>
Reviewed-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Juan Quintela <quintela@redhat.com>
Signed-off-by: Juan Quintela <quintela@redhat.com>
---
 qapi/migration.json   | 30 +++++++++++++++++++++++++++
 migration/dirtyrate.h | 21 +++++++++++++++----
 migration/dirtyrate.c | 48 +++++++++++++++++++++++++------------------
 3 files changed, 75 insertions(+), 24 deletions(-)

diff --git a/qapi/migration.json b/qapi/migration.json
index 9aa8bc5759..94eece16e1 100644
--- a/qapi/migration.json
+++ b/qapi/migration.json
@@ -1731,6 +1731,21 @@
 { 'event': 'UNPLUG_PRIMARY',
   'data': { 'device-id': 'str' } }
 
+##
+# @DirtyRateVcpu:
+#
+# Dirty rate of vcpu.
+#
+# @id: vcpu index.
+#
+# @dirty-rate: dirty rate.
+#
+# Since: 6.1
+#
+##
+{ 'struct': 'DirtyRateVcpu',
+  'data': { 'id': 'int', 'dirty-rate': 'int64' } }
+
 ##
 # @DirtyRateStatus:
 #
@@ -1748,6 +1763,21 @@
 { 'enum': 'DirtyRateStatus',
   'data': [ 'unstarted', 'measuring', 'measured'] }
 
+##
+# @DirtyRateMeasureMode:
+#
+# An enumeration of mode of measuring dirtyrate.
+#
+# @page-sampling: calculate dirtyrate by sampling pages.
+#
+# @dirty-ring: calculate dirtyrate by via dirty ring.
+#
+# Since: 6.1
+#
+##
+{ 'enum': 'DirtyRateMeasureMode',
+  'data': ['page-sampling', 'dirty-ring'] }
+
 ##
 # @DirtyRateInfo:
 #
diff --git a/migration/dirtyrate.h b/migration/dirtyrate.h
index e1fd29089e..69d4c5b865 100644
--- a/migration/dirtyrate.h
+++ b/migration/dirtyrate.h
@@ -43,6 +43,7 @@
 struct DirtyRateConfig {
     uint64_t sample_pages_per_gigabytes; /* sample pages per GB */
     int64_t sample_period_seconds; /* time duration between two sampling */
+    DirtyRateMeasureMode mode; /* mode of dirtyrate measurement */
 };
 
 /*
@@ -58,17 +59,29 @@ struct RamblockDirtyInfo {
     uint32_t *hash_result; /* array of hash result for sampled pages */
 };
 
-/*
- * Store calculation statistics for each measure.
- */
-struct DirtyRateStat {
+typedef struct SampleVMStat {
     uint64_t total_dirty_samples; /* total dirty sampled page */
     uint64_t total_sample_count; /* total sampled pages */
     uint64_t total_block_mem_MB; /* size of total sampled pages in MB */
+} SampleVMStat;
+
+typedef struct VcpuStat {
+    int nvcpu; /* number of vcpu */
+    DirtyRateVcpu *rates; /* array of dirty rate for each vcpu */
+} VcpuStat;
+
+/*
+ * Store calculation statistics for each measure.
+ */
+struct DirtyRateStat {
     int64_t dirty_rate; /* dirty rate in MB/s */
     int64_t start_time; /* calculation start time in units of second */
     int64_t calc_time; /* time duration of two sampling in units of second */
     uint64_t sample_pages; /* sample pages per GB */
+    union {
+        SampleVMStat page_sampling;
+        VcpuStat dirty_ring;
+    };
 };
 
 void *get_dirtyrate_thread(void *arg);
diff --git a/migration/dirtyrate.c b/migration/dirtyrate.c
index 320c56ba2c..e0a27a992c 100644
--- a/migration/dirtyrate.c
+++ b/migration/dirtyrate.c
@@ -88,33 +88,44 @@ static struct DirtyRateInfo *query_dirty_rate_info(void)
     return info;
 }
 
-static void init_dirtyrate_stat(int64_t start_time, int64_t calc_time,
-                                uint64_t sample_pages)
+static void init_dirtyrate_stat(int64_t start_time,
+                                struct DirtyRateConfig config)
 {
-    DirtyStat.total_dirty_samples = 0;
-    DirtyStat.total_sample_count = 0;
-    DirtyStat.total_block_mem_MB = 0;
     DirtyStat.dirty_rate = -1;
     DirtyStat.start_time = start_time;
-    DirtyStat.calc_time = calc_time;
-    DirtyStat.sample_pages = sample_pages;
+    DirtyStat.calc_time = config.sample_period_seconds;
+    DirtyStat.sample_pages = config.sample_pages_per_gigabytes;
+
+    switch (config.mode) {
+    case DIRTY_RATE_MEASURE_MODE_PAGE_SAMPLING:
+        DirtyStat.page_sampling.total_dirty_samples = 0;
+        DirtyStat.page_sampling.total_sample_count = 0;
+        DirtyStat.page_sampling.total_block_mem_MB = 0;
+        break;
+    case DIRTY_RATE_MEASURE_MODE_DIRTY_RING:
+        DirtyStat.dirty_ring.nvcpu = -1;
+        DirtyStat.dirty_ring.rates = NULL;
+        break;
+    default:
+        break;
+    }
 }
 
 static void update_dirtyrate_stat(struct RamblockDirtyInfo *info)
 {
-    DirtyStat.total_dirty_samples += info->sample_dirty_count;
-    DirtyStat.total_sample_count += info->sample_pages_count;
+    DirtyStat.page_sampling.total_dirty_samples += info->sample_dirty_count;
+    DirtyStat.page_sampling.total_sample_count += info->sample_pages_count;
     /* size of total pages in MB */
-    DirtyStat.total_block_mem_MB += (info->ramblock_pages *
-                                     TARGET_PAGE_SIZE) >> 20;
+    DirtyStat.page_sampling.total_block_mem_MB += (info->ramblock_pages *
+                                                   TARGET_PAGE_SIZE) >> 20;
 }
 
 static void update_dirtyrate(uint64_t msec)
 {
     uint64_t dirtyrate;
-    uint64_t total_dirty_samples = DirtyStat.total_dirty_samples;
-    uint64_t total_sample_count = DirtyStat.total_sample_count;
-    uint64_t total_block_mem_MB = DirtyStat.total_block_mem_MB;
+    uint64_t total_dirty_samples = DirtyStat.page_sampling.total_dirty_samples;
+    uint64_t total_sample_count = DirtyStat.page_sampling.total_sample_count;
+    uint64_t total_block_mem_MB = DirtyStat.page_sampling.total_block_mem_MB;
 
     dirtyrate = total_dirty_samples * total_block_mem_MB *
                 1000 / (total_sample_count * msec);
@@ -327,7 +338,7 @@ static bool compare_page_hash_info(struct RamblockDirtyInfo *info,
         update_dirtyrate_stat(block_dinfo);
     }
 
-    if (DirtyStat.total_sample_count == 0) {
+    if (DirtyStat.page_sampling.total_sample_count == 0) {
         return false;
     }
 
@@ -372,8 +383,6 @@ void *get_dirtyrate_thread(void *arg)
     struct DirtyRateConfig config = *(struct DirtyRateConfig *)arg;
     int ret;
     int64_t start_time;
-    int64_t calc_time;
-    uint64_t sample_pages;
 
     ret = dirtyrate_set_state(&CalculatingState, DIRTY_RATE_STATUS_UNSTARTED,
                               DIRTY_RATE_STATUS_MEASURING);
@@ -383,9 +392,7 @@ void *get_dirtyrate_thread(void *arg)
     }
 
     start_time = qemu_clock_get_ms(QEMU_CLOCK_REALTIME) / 1000;
-    calc_time = config.sample_period_seconds;
-    sample_pages = config.sample_pages_per_gigabytes;
-    init_dirtyrate_stat(start_time, calc_time, sample_pages);
+    init_dirtyrate_stat(start_time, config);
 
     calculate_dirtyrate(config);
 
@@ -442,6 +449,7 @@ void qmp_calc_dirty_rate(int64_t calc_time, bool has_sample_pages,
 
     config.sample_period_seconds = calc_time;
     config.sample_pages_per_gigabytes = sample_pages;
+    config.mode = DIRTY_RATE_MEASURE_MODE_PAGE_SAMPLING;
     qemu_thread_create(&thread, "get_dirtyrate", get_dirtyrate_thread,
                        (void *)&config, QEMU_THREAD_DETACHED);
 }
-- 
2.33.1

