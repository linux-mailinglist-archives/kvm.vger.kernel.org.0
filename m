Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C96BF4E1F40
	for <lists+kvm@lfdr.de>; Mon, 21 Mar 2022 04:13:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241681AbiCUDPP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 20 Mar 2022 23:15:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234851AbiCUDPN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 20 Mar 2022 23:15:13 -0400
Received: from chinatelecom.cn (prt-mail.chinatelecom.cn [42.123.76.222])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 583FB192A8
        for <kvm@vger.kernel.org>; Sun, 20 Mar 2022 20:13:49 -0700 (PDT)
HMM_SOURCE_IP: 172.18.0.48:41376.1192774366
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-36.111.64.85 (unknown [172.18.0.48])
        by chinatelecom.cn (HERMES) with SMTP id 8D4D12800D2;
        Mon, 21 Mar 2022 11:13:41 +0800 (CST)
X-189-SAVE-TO-SEND: wucy11@chinatelecom.cn
Received: from  ([172.18.0.48])
        by app0024 with ESMTP id 702cfc2060884eeb8b68c600a5e832d9 for kvm@vger.kernel.org;
        Mon, 21 Mar 2022 11:13:48 CST
X-Transaction-ID: 702cfc2060884eeb8b68c600a5e832d9
X-Real-From: wucy11@chinatelecom.cn
X-Receive-IP: 172.18.0.48
X-MEDUSA-Status: 0
Sender: wucy11@chinatelecom.cn
Message-ID: <e4e1ffea-0b18-fb93-c9fb-efd3b182e99f@chinatelecom.cn>
Date:   Mon, 21 Mar 2022 11:13:40 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
From:   Chongyun Wu <wucy11@chinatelecom.cn>
Subject: [PATCH 4/5] kvm: Introduce a dirty rate calculation method based on
 dirty ring
To:     kvm@vger.kernel.org, qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Juan Quintela <quintela@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        yubin1@chinatelecom.cn,
        "ligh10@chinatelecom.cn" <ligh10@chinatelecom.cn>,
        zhengwenm@chinatelecom.cn
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A new structure KVMDirtyRingDirtyCounter is introduced in
KVMDirtyRingReaper to record the number of dirty pages
within a period of time.

When kvm_dirty_ring_mark_page collects dirty pages, if it
finds that the current dirty pages are not duplicates, it
increases the dirty_pages_period count.

Divide the dirty_pages_period count by the interval to get
the dirty page rate for this period.

And use dirty_pages_period_peak_rate to count the highest
dirty page rate, to solve the problem that the dirty page
collection rate may change greatly during a period of time,
resulting in a large change in the dirty page rate.

Through sufficient testing, it is found that the dirty rate
calculated after kvm_dirty_ring_flush usually matches the actual
pressure, and the dirty rate counted per second may change in the
subsequent seconds, so record the peak dirty rate as the real
dirty pages rate.

This dirty pages rate is mainly used as the subsequent autoconverge
calculation speed limit throttle.

Signed-off-by: Chongyun Wu <wucy11@chinatelecom.cn>
---
  accel/kvm/kvm-all.c  | 64 +++++++++++++++++++++++++++++++++++++++++++++++++++-
  include/sysemu/kvm.h |  2 ++
  2 files changed, 65 insertions(+), 1 deletion(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 64a211b..05af6ce 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -112,6 +112,13 @@ enum KVMDirtyRingReaperSpeedControl {
      KVM_DIRTY_RING_REAPER_SPEED_CONTROL_DOWN
  };

+struct KVMDirtyRingDirtyCounter {
+    int64_t time_last_count;
+    uint64_t dirty_pages_period;
+    int64_t dirty_pages_rate;
+    int64_t dirty_pages_period_peak_rate;
+};
+
  /*
   * KVM reaper instance, responsible for collecting the KVM dirty bits
   * via the dirty ring.
@@ -126,6 +133,7 @@ struct KVMDirtyRingReaper {
      uint64_t ring_full_cnt;
      float ratio_adjust_threshold;
      int stable_count_threshold;
+    struct KVMDirtyRingDirtyCounter counter; /* Calculate dirty pages rate */
  };

  struct KVMState
@@ -737,7 +745,9 @@ static void kvm_dirty_ring_mark_page(KVMState *s, uint32_t 
as_id,
          return;
      }

-    set_bit(offset, mem->dirty_bmap);
+    if (!test_and_set_bit(offset, mem->dirty_bmap)) {
+        s->reaper.counter.dirty_pages_period++;
+    }
  }

  static bool dirty_gfn_is_dirtied(struct kvm_dirty_gfn *gfn)
@@ -781,6 +791,56 @@ static uint32_t kvm_dirty_ring_reap_one(KVMState *s, 
CPUState *cpu)
      return count;
  }

+int64_t kvm_dirty_ring_get_rate(void)
+{
+    return kvm_state->reaper.counter.dirty_pages_rate;
+}
+
+int64_t kvm_dirty_ring_get_peak_rate(void)
+{
+    return kvm_state->reaper.counter.dirty_pages_period_peak_rate;
+}
+
+static void kvm_dirty_ring_reap_count(KVMState *s)
+{
+    int64_t spend_time = 0;
+    int64_t end_time;
+
+    if (!s->reaper.counter.time_last_count) {
+        s->reaper.counter.time_last_count =
+            qemu_clock_get_ms(QEMU_CLOCK_REALTIME);
+    }
+
+    end_time = qemu_clock_get_ms(QEMU_CLOCK_REALTIME);
+    spend_time = end_time - s->reaper.counter.time_last_count;
+
+    if (!s->reaper.counter.dirty_pages_period ||
+        !spend_time) {
+        return;
+    }
+
+    /*
+     * More than 1 second = 1000 millisecons,
+     * or trigger by kvm_log_sync_global which spend time
+     * more than 300 milliscons.
+     */
+    if (spend_time > 1000) {
+        /* Count the dirty page rate during this period */
+        s->reaper.counter.dirty_pages_rate =
+            s->reaper.counter.dirty_pages_period * 1000 / spend_time;
+        /* Update the peak dirty page rate at this period */
+        if (s->reaper.counter.dirty_pages_rate >
+            s->reaper.counter.dirty_pages_period_peak_rate) {
+            s->reaper.counter.dirty_pages_period_peak_rate =
+                s->reaper.counter.dirty_pages_rate;
+        }
+
+        /* Reset counters */
+        s->reaper.counter.dirty_pages_period = 0;
+        s->reaper.counter.time_last_count = 0;
+    }
+}
+
  /* Must be with slots_lock held */
  static uint64_t kvm_dirty_ring_reap_locked(KVMState *s)
  {
@@ -791,6 +851,8 @@ static uint64_t kvm_dirty_ring_reap_locked(KVMState *s)

      stamp = get_clock();

+    kvm_dirty_ring_reap_count(s);
+
      CPU_FOREACH(cpu) {
          total += kvm_dirty_ring_reap_one(s, cpu);
      }
diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
index 6eb39a0..565b1e7 100644
--- a/include/sysemu/kvm.h
+++ b/include/sysemu/kvm.h
@@ -563,4 +563,6 @@ bool kvm_cpu_check_are_resettable(void);
  bool kvm_arch_cpu_check_are_resettable(void);

  bool kvm_dirty_ring_enabled(void);
+int64_t kvm_dirty_ring_get_rate(void);
+int64_t kvm_dirty_ring_get_peak_rate(void);
  #endif
--
1.8.3.1

-- 
Best Regard,
Chongyun Wu
