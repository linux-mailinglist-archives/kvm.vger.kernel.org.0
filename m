Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B51563966B9
	for <lists+kvm@lfdr.de>; Mon, 31 May 2021 19:17:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232842AbhEaRSi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 May 2021 13:18:38 -0400
Received: from prt-mail.chinatelecom.cn ([42.123.76.227]:41294 "EHLO
        chinatelecom.cn" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S232725AbhEaRRZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 May 2021 13:17:25 -0400
HMM_SOURCE_IP: 172.18.0.218:60136.529866758
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-202.80.192.39?logid-262a242008784dafb9db8682f1ad8717 (unknown [172.18.0.218])
        by chinatelecom.cn (HERMES) with SMTP id 525342800B2;
        Tue,  1 Jun 2021 01:05:28 +0800 (CST)
X-189-SAVE-TO-SEND: +huangy81@chinatelecom.cn
Received: from  ([172.18.0.218])
        by app0025 with ESMTP id 262a242008784dafb9db8682f1ad8717 for qemu-devel@nongnu.org;
        Tue Jun  1 01:05:27 2021
X-Transaction-ID: 262a242008784dafb9db8682f1ad8717
X-filter-score:  filter<0>
X-Real-From: huangy81@chinatelecom.cn
X-Receive-IP: 172.18.0.218
X-MEDUSA-Status: 0
Sender: huangy81@chinatelecom.cn
From:   huangy81@chinatelecom.cn
To:     <qemu-devel@nongnu.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
        Juan Quintela <quintela@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Peter Xu <peterx@redhat.com>, Hyman <huangy81@chinatelecom.cn>
Subject: [PATCH v1 4/6] migration/dirtyrate: adjust struct DirtyRateStat
Date:   Tue,  1 Jun 2021 01:05:29 +0800
Message-Id: <16e0e8f50b3b83f809187dcfed5693026bea0caa.1622479162.git.huangy81@chinatelecom.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <cover.1622479161.git.huangy81@chinatelecom.cn>
References: <cover.1622479161.git.huangy81@chinatelecom.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Hyman Huang(黄勇) <huangy81@chinatelecom.cn>

use union to store stat data of two mutual exclusive methods.

Signed-off-by: Hyman Huang(黄勇) <huangy81@chinatelecom.cn>
---
 migration/dirtyrate.c | 32 ++++++++++++++++++++------------
 migration/dirtyrate.h | 18 +++++++++++++++---
 2 files changed, 35 insertions(+), 15 deletions(-)

diff --git a/migration/dirtyrate.c b/migration/dirtyrate.c
index 3c1a824a41..7952eb6117 100644
--- a/migration/dirtyrate.c
+++ b/migration/dirtyrate.c
@@ -78,31 +78,39 @@ static struct DirtyRateInfo *query_dirty_rate_info(void)
     return info;
 }
 
-static void init_dirtyrate_stat(int64_t start_time, int64_t calc_time)
+static void init_dirtyrate_stat(int64_t start_time,
+                                int64_t calc_time,
+                                struct DirtyRateConfig config)
 {
-    DirtyStat.total_dirty_samples = 0;
-    DirtyStat.total_sample_count = 0;
-    DirtyStat.total_block_mem_MB = 0;
     DirtyStat.dirty_rate = -1;
     DirtyStat.start_time = start_time;
     DirtyStat.calc_time = calc_time;
+
+    if (config.vcpu) {
+        DirtyStat.method.vcpu.nvcpu = -1;
+        DirtyStat.method.vcpu.rates = NULL;
+    } else {
+        DirtyStat.method.vm.total_dirty_samples = 0;
+        DirtyStat.method.vm.total_sample_count = 0;
+        DirtyStat.method.vm.total_block_mem_MB = 0;
+    }
 }
 
 static void update_dirtyrate_stat(struct RamblockDirtyInfo *info)
 {
-    DirtyStat.total_dirty_samples += info->sample_dirty_count;
-    DirtyStat.total_sample_count += info->sample_pages_count;
+    DirtyStat.method.vm.total_dirty_samples += info->sample_dirty_count;
+    DirtyStat.method.vm.total_sample_count += info->sample_pages_count;
     /* size of total pages in MB */
-    DirtyStat.total_block_mem_MB += (info->ramblock_pages *
+    DirtyStat.method.vm.total_block_mem_MB += (info->ramblock_pages *
                                      TARGET_PAGE_SIZE) >> 20;
 }
 
 static void update_dirtyrate(uint64_t msec)
 {
     uint64_t dirtyrate;
-    uint64_t total_dirty_samples = DirtyStat.total_dirty_samples;
-    uint64_t total_sample_count = DirtyStat.total_sample_count;
-    uint64_t total_block_mem_MB = DirtyStat.total_block_mem_MB;
+    uint64_t total_dirty_samples = DirtyStat.method.vm.total_dirty_samples;
+    uint64_t total_sample_count = DirtyStat.method.vm.total_sample_count;
+    uint64_t total_block_mem_MB = DirtyStat.method.vm.total_block_mem_MB;
 
     dirtyrate = total_dirty_samples * total_block_mem_MB *
                 1000 / (total_sample_count * msec);
@@ -315,7 +323,7 @@ static bool compare_page_hash_info(struct RamblockDirtyInfo *info,
         update_dirtyrate_stat(block_dinfo);
     }
 
-    if (DirtyStat.total_sample_count == 0) {
+    if (DirtyStat.method.vm.total_sample_count == 0) {
         return false;
     }
 
@@ -371,7 +379,7 @@ void *get_dirtyrate_thread(void *arg)
 
     start_time = qemu_clock_get_ms(QEMU_CLOCK_REALTIME) / 1000;
     calc_time = config.sample_period_seconds;
-    init_dirtyrate_stat(start_time, calc_time);
+    init_dirtyrate_stat(start_time, calc_time, config);
 
     calculate_dirtyrate(config);
 
diff --git a/migration/dirtyrate.h b/migration/dirtyrate.h
index f20dd52d77..3ab8e81f42 100644
--- a/migration/dirtyrate.h
+++ b/migration/dirtyrate.h
@@ -54,16 +54,28 @@ struct RamblockDirtyInfo {
     uint32_t *hash_result; /* array of hash result for sampled pages */
 };
 
+typedef struct SampleVMStat {
+    uint64_t total_dirty_samples; /* total dirty sampled page */
+    uint64_t total_sample_count; /* total sampled pages */
+    uint64_t total_block_mem_MB; /* size of total sampled pages in MB */
+} SampleVMStat;
+
+typedef struct VcpuStat {
+    int nvcpu; /* number of vcpu */
+    DirtyRateVcpu *rates; /* array of dirty rate for each vcpu */
+} VcpuStat;
+
 /*
  * Store calculation statistics for each measure.
  */
 struct DirtyRateStat {
-    uint64_t total_dirty_samples; /* total dirty sampled page */
-    uint64_t total_sample_count; /* total sampled pages */
-    uint64_t total_block_mem_MB; /* size of total sampled pages in MB */
     int64_t dirty_rate; /* dirty rate in MB/s */
     int64_t start_time; /* calculation start time in units of second */
     int64_t calc_time; /* time duration of two sampling in units of second */
+    union {
+        SampleVMStat vm;
+        VcpuStat vcpu;
+    } method;
 };
 
 void *get_dirtyrate_thread(void *arg);
-- 
2.24.3

