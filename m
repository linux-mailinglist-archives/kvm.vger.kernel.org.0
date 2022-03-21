Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B9B74E1F4F
	for <lists+kvm@lfdr.de>; Mon, 21 Mar 2022 04:22:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244561AbiCUDXx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 20 Mar 2022 23:23:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235876AbiCUDXv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 20 Mar 2022 23:23:51 -0400
Received: from chinatelecom.cn (prt-mail.chinatelecom.cn [42.123.76.228])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 38CF723BFD
        for <kvm@vger.kernel.org>; Sun, 20 Mar 2022 20:22:27 -0700 (PDT)
HMM_SOURCE_IP: 172.18.0.188:56498.1142451369
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-36.111.64.85 (unknown [172.18.0.188])
        by chinatelecom.cn (HERMES) with SMTP id BBEB4280121;
        Mon, 21 Mar 2022 11:13:01 +0800 (CST)
X-189-SAVE-TO-SEND: wucy11@chinatelecom.cn
Received: from  ([172.18.0.188])
        by app0023 with ESMTP id 03cc16217acd4594baad444239715a21 for kvm@vger.kernel.org;
        Mon, 21 Mar 2022 11:13:06 CST
X-Transaction-ID: 03cc16217acd4594baad444239715a21
X-Real-From: wucy11@chinatelecom.cn
X-Receive-IP: 172.18.0.188
X-MEDUSA-Status: 0
Sender: wucy11@chinatelecom.cn
Message-ID: <0cc500bb-d53f-605a-b4a1-5f3c9115c326@chinatelecom.cn>
Date:   Mon, 21 Mar 2022 11:12:59 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
From:   Chongyun Wu <wucy11@chinatelecom.cn>
Subject: [PATCH 2/5] kvm: Dynamically adjust the rate of dirty ring reaper
 thread
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

Dynamically adjust the dirty ring collection thread to
reduce the occurrence of ring full, thereby reducing the
impact on customers, improving the efficiency of dirty
page collection, and thus improving the migration efficiency.

Implementation:
1) Define different collection speeds for the reap thread.

2) Divide the total number of dirty pages collected each
time by the ring size to get a ratio which indicates the
occupancy rate of dirty pages in the ring. The higher the
ratio, the higher the possibility that the ring will be full.

3) Different ratios correspond to different running speeds.
A higher ratio value indicates that a higher running speed
is required to collect dirty pages as soon as possible to
ensure that too many ring fulls will not be generated,
which will affect the customer's business.

This patch can significantly reduce the number of ring full
occurrences in the case of high memory dirty page pressure,
and minimize the impact on guests.

Using this patch for the qeum guestperf test, the memory
performance during the migration process is somewhat improved
compared to the bitmap method, and is significantly improved
compared to the unoptimized dirty ring method. For detailed
test data, please refer to the follow-up series of patches.

Signed-off-by: Chongyun Wu <wucy11@chinatelecom.cn>
---
  accel/kvm/kvm-all.c | 149 ++++++++++++++++++++++++++++++++++++++++++++++++++--
  1 file changed, 144 insertions(+), 5 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 0e66ebb..51012f4 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -91,6 +91,27 @@ enum KVMDirtyRingReaperState {
      KVM_DIRTY_RING_REAPER_REAPING,
  };

+enum KVMDirtyRingReaperRunLevel {
+    /* The reaper runs at default normal speed */
+    KVM_DIRTY_RING_REAPER_RUN_NORMAL = 0,
+    /* The reaper starts to accelerate in different gears */
+    KVM_DIRTY_RING_REAPER_RUN_FAST1,
+    KVM_DIRTY_RING_REAPER_RUN_FAST2,
+    KVM_DIRTY_RING_REAPER_RUN_FAST3,
+    KVM_DIRTY_RING_REAPER_RUN_FAST4,
+    /* The reaper runs at the fastest speed */
+    KVM_DIRTY_RING_REAPER_RUN_MAX_SPEED,
+};
+
+enum KVMDirtyRingReaperSpeedControl {
+    /* Maintain current speed */
+    KVM_DIRTY_RING_REAPER_SPEED_CONTROL_KEEP = 0,
+    /* Accelerate current speed */
+    KVM_DIRTY_RING_REAPER_SPEED_CONTROL_UP,
+    /* Decrease current speed */
+    KVM_DIRTY_RING_REAPER_SPEED_CONTROL_DOWN
+};
+
  /*
   * KVM reaper instance, responsible for collecting the KVM dirty bits
   * via the dirty ring.
@@ -100,6 +121,11 @@ struct KVMDirtyRingReaper {
      QemuThread reaper_thr;
      volatile uint64_t reaper_iteration; /* iteration number of reaper thr */
      volatile enum KVMDirtyRingReaperState reaper_state; /* reap thr state */
+    /* Control the running speed of the reaper thread to fit dirty page rate */
+    enum KVMDirtyRingReaperRunLevel run_level;
+    uint64_t ring_full_cnt;
+    float ratio_adjust_threshold;
+    int stable_count_threshold;
  };

  struct KVMState
@@ -1449,11 +1475,115 @@ out:
      kvm_slots_unlock();
  }

+static uint64_t calcu_sleep_time(KVMState *s,
+                                       uint64_t dirty_count,
+                                       uint64_t ring_full_cnt_last,
+                                       uint32_t *speed_down_cnt)
+{
+    float ratio = 0.0;
+    uint64_t sleep_time = 1000000;
+    enum KVMDirtyRingReaperRunLevel run_level_want;
+    enum KVMDirtyRingReaperSpeedControl speed_control;
+
+    /*
+     * When the number of dirty pages collected exceeds
+     * the given percentage of the ring size,the speed
+     * up action will be triggered.
+     */
+    s->reaper.ratio_adjust_threshold = 0.1;
+    s->reaper.stable_count_threshold = 5;
+
+    ratio = (float)dirty_count / s->kvm_dirty_ring_size;
+
+    if (s->reaper.ring_full_cnt > ring_full_cnt_last) {
+        /* If get a new ring full need speed up reaper thread */
+        if (s->reaper.run_level != KVM_DIRTY_RING_REAPER_RUN_MAX_SPEED) {
+            s->reaper.run_level++;
+        }
+    } else {
+        /*
+         * If get more dirty pages this loop and this status continus
+         * for many times try to speed up reaper thread.
+         * If the status is stable and need to decide which speed need
+         * to use.
+         */
+        if (ratio < s->reaper.ratio_adjust_threshold) {
+            run_level_want = KVM_DIRTY_RING_REAPER_RUN_NORMAL;
+        } else if (ratio < s->reaper.ratio_adjust_threshold * 2) {
+            run_level_want = KVM_DIRTY_RING_REAPER_RUN_FAST1;
+        } else if (ratio < s->reaper.ratio_adjust_threshold * 3) {
+            run_level_want = KVM_DIRTY_RING_REAPER_RUN_FAST2;
+        } else if (ratio < s->reaper.ratio_adjust_threshold * 4) {
+            run_level_want = KVM_DIRTY_RING_REAPER_RUN_FAST3;
+        } else if (ratio < s->reaper.ratio_adjust_threshold * 5) {
+            run_level_want = KVM_DIRTY_RING_REAPER_RUN_FAST4;
+        } else {
+            run_level_want = KVM_DIRTY_RING_REAPER_RUN_MAX_SPEED;
+        }
+
+        /* Get if need speed up or slow down */
+        if (run_level_want > s->reaper.run_level) {
+            speed_control = KVM_DIRTY_RING_REAPER_SPEED_CONTROL_UP;
+            *speed_down_cnt = 0;
+        } else if (run_level_want < s->reaper.run_level) {
+            speed_control = KVM_DIRTY_RING_REAPER_SPEED_CONTROL_DOWN;
+            *speed_down_cnt++;
+        } else {
+            speed_control = KVM_DIRTY_RING_REAPER_SPEED_CONTROL_KEEP;
+        }
+
+        /* Control reaper thread run in sutiable run speed level */
+        if (speed_control == KVM_DIRTY_RING_REAPER_SPEED_CONTROL_UP) {
+            /* If need speed up do not check its stable just do it */
+            s->reaper.run_level++;
+        } else if (speed_control ==
+            KVM_DIRTY_RING_REAPER_SPEED_CONTROL_DOWN) {
+            /* If need speed down we should filter this status */
+            if (*speed_down_cnt > s->reaper.stable_count_threshold) {
+                s->reaper.run_level--;
+            }
+        }
+    }
+
+    /* Set the actual running rate of the reaper */
+    switch (s->reaper.run_level) {
+    case KVM_DIRTY_RING_REAPER_RUN_NORMAL:
+        sleep_time = 1000000;
+        break;
+    case KVM_DIRTY_RING_REAPER_RUN_FAST1:
+        sleep_time = 500000;
+        break;
+    case KVM_DIRTY_RING_REAPER_RUN_FAST2:
+        sleep_time = 250000;
+        break;
+    case KVM_DIRTY_RING_REAPER_RUN_FAST3:
+        sleep_time = 125000;
+        break;
+    case KVM_DIRTY_RING_REAPER_RUN_FAST4:
+        sleep_time = 100000;
+        break;
+    case KVM_DIRTY_RING_REAPER_RUN_MAX_SPEED:
+        sleep_time = 80000;
+        break;
+    default:
+        sleep_time = 1000000;
+        error_report("Bad reaper thread run level, use default");
+    }
+
+    return sleep_time;
+}
+
  static void *kvm_dirty_ring_reaper_thread(void *data)
  {
      KVMState *s = data;
      struct KVMDirtyRingReaper *r = &s->reaper;

+    uint64_t count = 0;
+    uint64_t sleep_time = 1000000;
+    uint64_t ring_full_cnt_last = 0;
+    /* Filter speed jitter */
+    uint32_t speed_down_cnt = 0;
+
      rcu_register_thread();

      trace_kvm_dirty_ring_reaper("init");
@@ -1461,18 +1591,26 @@ static void *kvm_dirty_ring_reaper_thread(void *data)
      while (true) {
          r->reaper_state = KVM_DIRTY_RING_REAPER_WAIT;
          trace_kvm_dirty_ring_reaper("wait");
-        /*
-         * TODO: provide a smarter timeout rather than a constant?
-         */
-        sleep(1);
+
+       ring_full_cnt_last = s->reaper.ring_full_cnt;
+
+        usleep(sleep_time);

          trace_kvm_dirty_ring_reaper("wakeup");
          r->reaper_state = KVM_DIRTY_RING_REAPER_REAPING;

          qemu_mutex_lock_iothread();
-        kvm_dirty_ring_reap(s);
+        count = kvm_dirty_ring_reap(s);
          qemu_mutex_unlock_iothread();

+        /*
+         * Calculate the appropriate sleep time according to
+         * the speed of the current dirty page.
+         */
+        sleep_time = calcu_sleep_time(s, count,
+                                      ring_full_cnt_last,
+                                      &speed_down_cnt);
+
          r->reaper_iteration++;
      }

@@ -2957,6 +3095,7 @@ int kvm_cpu_exec(CPUState *cpu)
              trace_kvm_dirty_ring_full(cpu->cpu_index);
              qemu_mutex_lock_iothread();
              kvm_dirty_ring_reap(kvm_state);
+            kvm_state->reaper.ring_full_cnt++;
              qemu_mutex_unlock_iothread();
              ret = 0;
              break;
--
1.8.3.1

-- 
Best Regard,
Chongyun Wu
