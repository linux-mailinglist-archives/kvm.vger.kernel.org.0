Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B151759F5E1
	for <lists+kvm@lfdr.de>; Wed, 24 Aug 2022 11:06:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235250AbiHXJGx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Aug 2022 05:06:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234588AbiHXJGv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Aug 2022 05:06:51 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE38B78227;
        Wed, 24 Aug 2022 02:06:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661332010; x=1692868010;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=1ivgFtNK8oJwUiWoMzbdW9yT/YWt2E72t+WodHgJScQ=;
  b=VKyfGn8HR4S7JDL8O/1u1He1vQtG1Ms48Tidoedq4ctmtT3+F0pE/nc/
   6PYOQvalALUu29nxROR0hcIRV5vXQfaT+H3zS6DpGN94puUl5JmmVSAWn
   S9WcMnF49o3/f1dCtXPWlnp2li1ipm8pR8x2d4IGsr5hVsR+PiWhZl4k+
   Epe6Ip6o06rvM0KIaOWA0ILz9jYncKYDRd+P1GEp9Pp78NWmI5z4/lSJl
   3qwc2iX6WaFXsULvLUCe5GzzQ0qxWkctgJHg2xF/BtCrUPmum1zsDBDFG
   iv+m7urcd3ni7HrshtzitnxuF0M7GsKmJSuujkO9C2c7CV4mMT/PwukXf
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10448"; a="319972877"
X-IronPort-AV: E=Sophos;i="5.93,260,1654585200"; 
   d="scan'208";a="319972877"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2022 02:06:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,260,1654585200"; 
   d="scan'208";a="785560403"
Received: from dmi-pnp-i7.sh.intel.com ([10.239.159.145])
  by orsmga005.jf.intel.com with ESMTP; 24 Aug 2022 02:06:48 -0700
From:   Dapeng Mi <dapeng1.mi@intel.com>
To:     rafael@kernel.org, daniel.lezcano@linaro.org, pbonzini@redhat.com
Cc:     linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, zhenyuw@linux.intel.com,
        Dapeng Mi <dapeng1.mi@intel.com>
Subject: [PATCH] KVM: x86: use TPAUSE to replace PAUSE in halt polling
Date:   Wed, 24 Aug 2022 17:11:17 +0800
Message-Id: <20220824091117.767363-1-dapeng1.mi@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

TPAUSE is a new instruction on Intel processors which can instruct
processor enters a power/performance optimized state. Halt polling
uses PAUSE instruction to wait vCPU is waked up. The polling time
could be long and cause extra power consumption in some cases.

Use TPAUSE to replace the PAUSE instruction in halt polling to get
a better power saving and performance.

Signed-off-by: Dapeng Mi <dapeng1.mi@intel.com>
---
 drivers/cpuidle/poll_state.c |  3 ++-
 include/linux/kvm_host.h     | 20 ++++++++++++++++++++
 virt/kvm/kvm_main.c          |  2 +-
 3 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/drivers/cpuidle/poll_state.c b/drivers/cpuidle/poll_state.c
index f7e83613ae94..51ec333cbf80 100644
--- a/drivers/cpuidle/poll_state.c
+++ b/drivers/cpuidle/poll_state.c
@@ -7,6 +7,7 @@
 #include <linux/sched.h>
 #include <linux/sched/clock.h>
 #include <linux/sched/idle.h>
+#include <linux/kvm_host.h>
 
 #define POLL_IDLE_RELAX_COUNT	200
 
@@ -25,7 +26,7 @@ static int __cpuidle poll_idle(struct cpuidle_device *dev,
 		limit = cpuidle_poll_time(drv, dev);
 
 		while (!need_resched()) {
-			cpu_relax();
+			kvm_cpu_poll_pause(limit);
 			if (loop_count++ < POLL_IDLE_RELAX_COUNT)
 				continue;
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index f4519d3689e1..810e749949b7 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -35,6 +35,7 @@
 #include <linux/interval_tree.h>
 #include <linux/rbtree.h>
 #include <linux/xarray.h>
+#include <linux/delay.h>
 #include <asm/signal.h>
 
 #include <linux/kvm.h>
@@ -2247,6 +2248,25 @@ static inline void kvm_handle_signal_exit(struct kvm_vcpu *vcpu)
 }
 #endif /* CONFIG_KVM_XFER_TO_GUEST_WORK */
 
+/*
+ * This function is intended to replace the cpu_relax function in
+ * halt polling. If TPAUSE instruction is supported, use TPAUSE
+ * instead fo PAUSE to get better power saving and performance.
+ * Selecting 1 us is a compromise between scheduling latency and
+ * power saving time.
+ */
+static inline void kvm_cpu_poll_pause(u64 timeout_ns)
+{
+#ifdef CONFIG_X86
+	if (static_cpu_has(X86_FEATURE_WAITPKG) && timeout_ns > 1000)
+		udelay(1);
+	else
+		cpu_relax();
+#else
+	cpu_relax();
+#endif
+}
+
 /*
  * This defines how many reserved entries we want to keep before we
  * kick the vcpu to the userspace to avoid dirty ring full.  This
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 584a5bab3af3..4afa776d21bd 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3510,7 +3510,7 @@ void kvm_vcpu_halt(struct kvm_vcpu *vcpu)
 			 */
 			if (kvm_vcpu_check_block(vcpu) < 0)
 				goto out;
-			cpu_relax();
+			kvm_cpu_poll_pause(vcpu->halt_poll_ns);
 			poll_end = cur = ktime_get();
 		} while (kvm_vcpu_can_poll(cur, stop));
 	}
-- 
2.34.1

