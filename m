Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AE613966B5
	for <lists+kvm@lfdr.de>; Mon, 31 May 2021 19:16:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231971AbhEaRSb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 May 2021 13:18:31 -0400
Received: from prt-mail.chinatelecom.cn ([42.123.76.219]:58424 "EHLO
        chinatelecom.cn" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S233794AbhEaRRY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 May 2021 13:17:24 -0400
HMM_SOURCE_IP: 172.18.0.218:42706.1466219582
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-202.80.192.39?logid-8790cfef0ba147a299cbd8acf210f1a0 (unknown [172.18.0.218])
        by chinatelecom.cn (HERMES) with SMTP id 5A2E42800B2;
        Tue,  1 Jun 2021 01:06:29 +0800 (CST)
X-189-SAVE-TO-SEND: +huangy81@chinatelecom.cn
Received: from  ([172.18.0.218])
        by app0025 with ESMTP id 8790cfef0ba147a299cbd8acf210f1a0 for qemu-devel@nongnu.org;
        Tue Jun  1 01:06:27 2021
X-Transaction-ID: 8790cfef0ba147a299cbd8acf210f1a0
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
Subject: [PATCH v1 6/6] migration/dirtyrate: implement dirty-ring dirtyrate calculation
Date:   Tue,  1 Jun 2021 01:06:29 +0800
Message-Id: <27607e12038273706273203b2146c5d4a40ac487.1622479162.git.huangy81@chinatelecom.cn>
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

use dirty ring feature to implement dirtyrate calculation.
to enable it, set vcpu option as true in qmp calc-dirty-rate.

Signed-off-by: Hyman Huang(黄勇) <huangy81@chinatelecom.cn>
---
 migration/dirtyrate.c  | 146 ++++++++++++++++++++++++++++++++++++++---
 migration/trace-events |   1 +
 2 files changed, 139 insertions(+), 8 deletions(-)

diff --git a/migration/dirtyrate.c b/migration/dirtyrate.c
index da6500c8ec..028c11d117 100644
--- a/migration/dirtyrate.c
+++ b/migration/dirtyrate.c
@@ -16,14 +16,22 @@
 #include "cpu.h"
 #include "exec/ramblock.h"
 #include "qemu/rcu_queue.h"
+#include "qemu/main-loop.h"
 #include "sysemu/kvm.h"
 #include "qapi/qapi-commands-migration.h"
 #include "ram.h"
 #include "trace.h"
 #include "dirtyrate.h"
 
+typedef enum {
+    CALC_NONE = 0,
+    CALC_DIRTY_RING,
+    CALC_SAMPLE_PAGES,
+} CalcMethod;
+
 static int CalculatingState = DIRTY_RATE_STATUS_UNSTARTED;
 static struct DirtyRateStat DirtyStat;
+static CalcMethod last_method = CALC_NONE;
 
 static int64_t set_sample_page_period(int64_t msec, int64_t initial_time)
 {
@@ -64,6 +72,7 @@ static struct DirtyRateInfo *query_dirty_rate_info(void)
 {
     int64_t dirty_rate = DirtyStat.dirty_rate;
     struct DirtyRateInfo *info = g_malloc0(sizeof(DirtyRateInfo));
+    DirtyRateVcpuList *head = NULL, **tail = &head;
 
     if (qatomic_read(&CalculatingState) == DIRTY_RATE_STATUS_MEASURED) {
         info->has_dirty_rate = true;
@@ -73,6 +82,22 @@ static struct DirtyRateInfo *query_dirty_rate_info(void)
     info->status = CalculatingState;
     info->start_time = DirtyStat.start_time;
     info->calc_time = DirtyStat.calc_time;
+    info->has_vcpu = true;
+
+    if (last_method == CALC_DIRTY_RING) {
+        int i = 0;
+        info->vcpu = true;
+        info->has_vcpu_dirty_rate = true;
+        for (i = 0; i < DirtyStat.method.vcpu.nvcpu; i++) {
+            DirtyRateVcpu *rate = g_malloc0(sizeof(DirtyRateVcpu));
+            rate->id = DirtyStat.method.vcpu.rates[i].id;
+            rate->dirty_rate = DirtyStat.method.vcpu.rates[i].dirty_rate;
+            QAPI_LIST_APPEND(tail, rate);
+        }
+        info->vcpu_dirty_rate = head;
+    } else {
+        info->vcpu = false;
+    }
 
     trace_query_dirty_rate_info(DirtyRateStatus_str(CalculatingState));
 
@@ -87,13 +112,29 @@ static void init_dirtyrate_stat(int64_t start_time,
     DirtyStat.start_time = start_time;
     DirtyStat.calc_time = calc_time;
 
-    if (config.vcpu) {
-        DirtyStat.method.vcpu.nvcpu = -1;
-        DirtyStat.method.vcpu.rates = NULL;
-    } else {
-        DirtyStat.method.vm.total_dirty_samples = 0;
-        DirtyStat.method.vm.total_sample_count = 0;
-        DirtyStat.method.vm.total_block_mem_MB = 0;
+    switch (last_method) {
+    case CALC_NONE:
+    case CALC_SAMPLE_PAGES:
+        if (config.vcpu) {
+            DirtyStat.method.vcpu.nvcpu = -1;
+            DirtyStat.method.vcpu.rates = NULL;
+        } else {
+            DirtyStat.method.vm.total_dirty_samples = 0;
+            DirtyStat.method.vm.total_sample_count = 0;
+            DirtyStat.method.vm.total_block_mem_MB = 0;
+        }
+        break;
+    case CALC_DIRTY_RING:
+        if (!config.vcpu) {
+            g_free(DirtyStat.method.vcpu.rates);
+            DirtyStat.method.vcpu.rates = NULL;
+            DirtyStat.method.vm.total_dirty_samples = 0;
+            DirtyStat.method.vm.total_sample_count = 0;
+            DirtyStat.method.vm.total_block_mem_MB = 0;
+        }
+        break;
+    default:
+        break;
     }
 }
 
@@ -331,7 +372,84 @@ static bool compare_page_hash_info(struct RamblockDirtyInfo *info,
     return true;
 }
 
-static void calculate_dirtyrate(struct DirtyRateConfig config)
+static void stat_dirtypages(CPUState *cpu, bool start)
+{
+    cpu->stat_dirty_pages = start;
+}
+
+static void start_kvm_dirty_log(void)
+{
+    qemu_mutex_lock_iothread();
+    memory_global_dirty_log_start();
+    qemu_mutex_unlock_iothread();
+}
+
+static void stop_kvm_dirty_log(void)
+{
+    qemu_mutex_lock_iothread();
+    memory_global_dirty_log_stop();
+    qemu_mutex_unlock_iothread();
+}
+
+static int64_t do_calculate_dirtyrate_vcpu(CPUState *cpu)
+{
+    uint64_t memory_size_MB;
+    int64_t time_s;
+
+    memory_size_MB = (cpu->dirty_pages * TARGET_PAGE_SIZE) >> 20;
+    time_s = DirtyStat.calc_time;
+
+    return memory_size_MB / time_s;
+}
+
+static void calculate_dirtyrate_vcpu(struct DirtyRateConfig config)
+{
+    CPUState *cpu;
+    int64_t msec = 0;
+    int64_t start_time;
+    uint64_t dirtyrate = 0;
+    uint64_t dirtyrate_sum = 0;
+    int nvcpu, i = 0;
+
+    CPU_FOREACH(cpu) {
+        stat_dirtypages(cpu, true);
+        nvcpu++;
+    }
+
+    DirtyStat.method.vcpu.nvcpu = nvcpu;
+
+    if (last_method != CALC_DIRTY_RING) {
+        DirtyStat.method.vcpu.rates =
+            g_malloc0(sizeof(DirtyRateVcpu) * nvcpu);
+    }
+
+    start_time = qemu_clock_get_ms(QEMU_CLOCK_REALTIME);
+    DirtyStat.start_time = start_time / 1000;
+
+    start_kvm_dirty_log();
+
+    msec = config.sample_period_seconds * 1000;
+    msec = set_sample_page_period(msec, start_time);
+    DirtyStat.calc_time = msec / 1000;
+
+    CPU_FOREACH(cpu) {
+        stat_dirtypages(cpu, false);
+    }
+
+    stop_kvm_dirty_log();
+
+    CPU_FOREACH(cpu) {
+        dirtyrate = do_calculate_dirtyrate_vcpu(cpu);
+        DirtyStat.method.vcpu.rates[i].id = cpu->cpu_index;
+        DirtyStat.method.vcpu.rates[i].dirty_rate = dirtyrate;
+        dirtyrate_sum += dirtyrate;
+        i++;
+    }
+
+    DirtyStat.dirty_rate = dirtyrate_sum / nvcpu;
+}
+
+static void calculate_dirtyrate_sample_vm(struct DirtyRateConfig config)
 {
     struct RamblockDirtyInfo *block_dinfo = NULL;
     int block_count = 0;
@@ -364,6 +482,18 @@ out:
     rcu_unregister_thread();
 }
 
+static void calculate_dirtyrate(struct DirtyRateConfig config)
+{
+    if (config.vcpu) {
+        calculate_dirtyrate_vcpu(config);
+        last_method = CALC_DIRTY_RING;
+    } else {
+        calculate_dirtyrate_sample_vm(config);
+        last_method = CALC_SAMPLE_PAGES;
+    }
+    trace_calculate_dirtyrate(DirtyStat.dirty_rate);
+}
+
 void *get_dirtyrate_thread(void *arg)
 {
     struct DirtyRateConfig config = *(struct DirtyRateConfig *)arg;
diff --git a/migration/trace-events b/migration/trace-events
index 668c562fed..5a80b39a62 100644
--- a/migration/trace-events
+++ b/migration/trace-events
@@ -330,6 +330,7 @@ get_ramblock_vfn_hash(const char *idstr, uint64_t vfn, uint32_t crc) "ramblock n
 calc_page_dirty_rate(const char *idstr, uint32_t new_crc, uint32_t old_crc) "ramblock name: %s, new crc: %" PRIu32 ", old crc: %" PRIu32
 skip_sample_ramblock(const char *idstr, uint64_t ramblock_size) "ramblock name: %s, ramblock size: %" PRIu64
 find_page_matched(const char *idstr) "ramblock %s addr or size changed"
+calculate_dirtyrate(int64_t dirtyrate) "dirty rate: %" PRIi64
 
 # block.c
 migration_block_init_shared(const char *blk_device_name) "Start migration for %s with shared base image"
-- 
2.24.3

