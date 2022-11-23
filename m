Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61967635CB6
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 13:24:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236054AbiKWMX7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 07:23:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235409AbiKWMX5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 07:23:57 -0500
X-Greylist: delayed 397 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 23 Nov 2022 04:23:56 PST
Received: from mr85p00im-zteg06021901.me.com (mr85p00im-zteg06021901.me.com [17.58.23.194])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 821DF59FDE
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 04:23:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ynddal.dk; s=sig1;
        t=1669205838; bh=Aut9ZXf9F14OuFZUq+1kZwYBZufehGQHszc7xp6jek0=;
        h=From:To:Subject:Date:Message-Id:MIME-Version;
        b=R2koUfr9v/zuaU4nuBelNsx9BDzGQY1Cuca6KBd1H3UupGPPMQ6k0iEljApCRhNui
         lFJzykK0hRaHRo2XX0d7cD4YLFFnq5ZyGp+vbHSZFJPwF56vtT+2J4PG51K2ZLmQ2/
         BBjZy1PMVENBYUziZn95qmjenAiH73elGVPbZWp8rQ5sQeBR6mA5bPX76JEFC/xu5m
         3djqRfHMYhUnErzpxHichiSk7zTJ7Vh6aaTZU4XAeZ+vX+IwG7BsTtUAhg5FFrW/A+
         AqlkCBxz/gZAAWEXCY1OnxhAqUHSbrvfnn3G4RggJe/rR5GQ+7Nf/NsMMPvtiSj+yQ
         SAz4eyr+Ghqwg==
Received: from localhost.localdomain (mr38p00im-dlb-asmtp-mailmevip.me.com [17.57.152.18])
        by mr85p00im-zteg06021901.me.com (Postfix) with ESMTPSA id 9D4B3740615;
        Wed, 23 Nov 2022 12:17:16 +0000 (UTC)
From:   Mads Ynddal <mads@ynddal.dk>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, Yanan Wang <wangyanan55@huawei.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>
Subject: [PATCH] gdbstub: move update guest debug to accel ops
Date:   Wed, 23 Nov 2022 13:17:12 +0100
Message-Id: <20221123121712.72817-1-mads@ynddal.dk>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: qzeEWYv33anWYhSjHxToGt3-6N3b3HwE
X-Proofpoint-GUID: qzeEWYv33anWYhSjHxToGt3-6N3b3HwE
X-Proofpoint-Virus-Version: =?UTF-8?Q?vendor=3Dfsecure_engine=3D1.1.170-22c6f66c430a71ce266a39bfe25bc?=
 =?UTF-8?Q?2903e8d5c8f:6.0.425,18.0.816,17.11.62.513.0000000_definitions?=
 =?UTF-8?Q?=3D2022-01-18=5F01:2022-01-14=5F01,2022-01-18=5F01,2021-12-02?=
 =?UTF-8?Q?=5F01_signatures=3D0?=
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 spamscore=0 clxscore=1030 adultscore=0 phishscore=0 mlxlogscore=999
 mlxscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2211230091
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Mads Ynddal <m.ynddal@samsung.com>

Continuing the refactor of a48e7d9e52 (gdbstub: move guest debug support
check to ops) by removing hardcoded kvm_enabled() from generic cpu.c
code, and replace it with a property of AccelOpsClass.

Signed-off-by: Mads Ynddal <m.ynddal@samsung.com>
---
 accel/kvm/kvm-accel-ops.c  |  1 +
 cpu.c                      | 10 +++++++---
 include/sysemu/accel-ops.h |  1 +
 3 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/accel/kvm/kvm-accel-ops.c b/accel/kvm/kvm-accel-ops.c
index fbf4fe3497..6ebf9a644f 100644
--- a/accel/kvm/kvm-accel-ops.c
+++ b/accel/kvm/kvm-accel-ops.c
@@ -99,6 +99,7 @@ static void kvm_accel_ops_class_init(ObjectClass *oc, void *data)
     ops->synchronize_pre_loadvm = kvm_cpu_synchronize_pre_loadvm;
 
 #ifdef KVM_CAP_SET_GUEST_DEBUG
+    ops->update_guest_debug = kvm_update_guest_debug;
     ops->supports_guest_debug = kvm_supports_guest_debug;
     ops->insert_breakpoint = kvm_insert_breakpoint;
     ops->remove_breakpoint = kvm_remove_breakpoint;
diff --git a/cpu.c b/cpu.c
index 2a09b05205..ef433a79e3 100644
--- a/cpu.c
+++ b/cpu.c
@@ -31,8 +31,8 @@
 #include "hw/core/sysemu-cpu-ops.h"
 #include "exec/address-spaces.h"
 #endif
+#include "sysemu/cpus.h"
 #include "sysemu/tcg.h"
-#include "sysemu/kvm.h"
 #include "sysemu/replay.h"
 #include "exec/cpu-common.h"
 #include "exec/exec-all.h"
@@ -378,10 +378,14 @@ void cpu_breakpoint_remove_all(CPUState *cpu, int mask)
 void cpu_single_step(CPUState *cpu, int enabled)
 {
     if (cpu->singlestep_enabled != enabled) {
+        const AccelOpsClass *ops = cpus_get_accel();
+
         cpu->singlestep_enabled = enabled;
-        if (kvm_enabled()) {
-            kvm_update_guest_debug(cpu, 0);
+
+        if (ops->update_guest_debug) {
+            ops->update_guest_debug(cpu, 0);
         }
+
         trace_breakpoint_singlestep(cpu->cpu_index, enabled);
     }
 }
diff --git a/include/sysemu/accel-ops.h b/include/sysemu/accel-ops.h
index 8cc7996def..0a47a2f00c 100644
--- a/include/sysemu/accel-ops.h
+++ b/include/sysemu/accel-ops.h
@@ -48,6 +48,7 @@ struct AccelOpsClass {
 
     /* gdbstub hooks */
     bool (*supports_guest_debug)(void);
+    int (*update_guest_debug)(CPUState *cpu, unsigned long flags);
     int (*insert_breakpoint)(CPUState *cpu, int type, hwaddr addr, hwaddr len);
     int (*remove_breakpoint)(CPUState *cpu, int type, hwaddr addr, hwaddr len);
     void (*remove_all_breakpoints)(CPUState *cpu);
-- 
2.38.1

