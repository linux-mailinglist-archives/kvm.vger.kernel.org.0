Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC9CB5B965F
	for <lists+kvm@lfdr.de>; Thu, 15 Sep 2022 10:31:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbiIOIbd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Sep 2022 04:31:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiIOIbb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Sep 2022 04:31:31 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADF6689CFD;
        Thu, 15 Sep 2022 01:31:29 -0700 (PDT)
Received: from dggpemm500022.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MSr0C0z5nzNmJX;
        Thu, 15 Sep 2022 16:26:51 +0800 (CST)
Received: from huawei.com (10.175.103.91) by dggpemm500022.china.huawei.com
 (7.185.36.162) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Thu, 15 Sep
 2022 16:31:27 +0800
From:   Zeng Heng <zengheng4@huawei.com>
To:     <pbonzini@redhat.com>, <paulmck@kernel.org>, <frederic@kernel.org>,
        <quic_neeraju@quicinc.com>, <josh@joshtriplett.org>,
        <rostedt@goodmis.org>, <mathieu.desnoyers@efficios.com>,
        <jiangshanlai@gmail.com>, <joel@joelfernandes.org>
CC:     <kvm@vger.kernel.org>, <rcu@vger.kernel.org>, <liwei391@huawei.com>
Subject: [PATCH -next] rcu: remove unused 'cpu' in rcu_virt_note_context_switch
Date:   Thu, 15 Sep 2022 16:38:24 +0800
Message-ID: <20220915083824.766645-1-zengheng4@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500022.china.huawei.com (7.185.36.162)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove unused function argument, and there is
no logic changes.

Signed-off-by: Zeng Heng <zengheng4@huawei.com>
---
 include/linux/kvm_host.h | 2 +-
 include/linux/rcutiny.h  | 2 +-
 include/linux/rcutree.h  | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index f4519d3689e1..9cf0c503daf5 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -417,7 +417,7 @@ static __always_inline void guest_context_enter_irqoff(void)
 	 */
 	if (!context_tracking_guest_enter()) {
 		instrumentation_begin();
-		rcu_virt_note_context_switch(smp_processor_id());
+		rcu_virt_note_context_switch();
 		instrumentation_end();
 	}
 }
diff --git a/include/linux/rcutiny.h b/include/linux/rcutiny.h
index 768196a5f39d..9bc025aa79a3 100644
--- a/include/linux/rcutiny.h
+++ b/include/linux/rcutiny.h
@@ -142,7 +142,7 @@ static inline int rcu_needs_cpu(void)
  * Take advantage of the fact that there is only one CPU, which
  * allows us to ignore virtualization-based context switches.
  */
-static inline void rcu_virt_note_context_switch(int cpu) { }
+static inline void rcu_virt_note_context_switch(void) { }
 static inline void rcu_cpu_stall_reset(void) { }
 static inline int rcu_jiffies_till_stall_check(void) { return 21 * HZ; }
 static inline void rcu_irq_exit_check_preempt(void) { }
diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index 5efb51486e8a..70795386b9ff 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -27,7 +27,7 @@ void rcu_cpu_stall_reset(void);
  * wrapper around rcu_note_context_switch(), which allows TINY_RCU
  * to save a few bytes. The caller must have disabled interrupts.
  */
-static inline void rcu_virt_note_context_switch(int cpu)
+static inline void rcu_virt_note_context_switch(void)
 {
 	rcu_note_context_switch(false);
 }
-- 
2.25.1

