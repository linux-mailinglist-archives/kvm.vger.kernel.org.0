Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BC676B6463
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 10:55:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbjCLJzc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 05:55:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbjCLJzT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 05:55:19 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ECAD5072F
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 01:55:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678614906; x=1710150906;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LNTFtUiigOibihayZcnv1cL/I3YYoYROrW1OP2eXIPg=;
  b=np4GMh/RyvbCGwbr0b3uEiC6wKeXBWJ/gd/D9HcuCrKJsUQ+/iCasEDj
   N9wIv80kZ3flvvaZcaq+N+kWplovF3ziV1P/OV8woLmPc690pnJ/Piz9R
   H7iVBP3oIcGi9srm8SBu7sFo/T+hbcTa8s3DtVeb/c/4vOQ5Jbk6DK5vi
   sPcr2tl7Q50tDJ+9fF7GSjW8IQEaFD9MlzYuBJDC5MoAli947PkHLeBYf
   uN4H2sw57aAVbzhfJ1ToO6UmEXwng0Ek0yWbvNxHpcy1qGNlg+n61+Te5
   f/SPwRKA/2m1tI9uuXq8QmENV2pcGy6x6nEodAZr7JabAE6CEArI83VYL
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="316623016"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="316623016"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:55:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="655660786"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="655660786"
Received: from jiechen-ubuntu-dev.sh.intel.com ([10.239.154.150])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:55:01 -0800
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     kvm@vger.kernel.org
Cc:     Jason Chen CJ <jason.cj.chen@intel.com>,
        Shaoqin Huang <shaoqin.huang@intel.com>,
        Chuanxiao Dong <chuanxiao.dong@intel.com>
Subject: [RFC PATCH part-3 02/22] pkvm: x86: Add arch specific spinlock
Date:   Mon, 13 Mar 2023 02:01:32 +0800
Message-Id: <20230312180152.1778338-3-jason.cj.chen@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230312180152.1778338-1-jason.cj.chen@intel.com>
References: <20230312180152.1778338-1-jason.cj.chen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

pKVM on Intel platform need its own spinlock implementation.
Add arch specific spinlock APIs for it.

Signed-off-by: Shaoqin Huang <shaoqin.huang@intel.com>
Signed-off-by: Chuanxiao Dong <chuanxiao.dong@intel.com>
Signed-off-by: Jason Chen CJ <jason.cj.chen@intel.com>
---
 arch/x86/include/asm/pkvm_spinlock.h | 64 ++++++++++++++++++++++++++++
 1 file changed, 64 insertions(+)

diff --git a/arch/x86/include/asm/pkvm_spinlock.h b/arch/x86/include/asm/pkvm_spinlock.h
new file mode 100644
index 000000000000..1af9c1243576
--- /dev/null
+++ b/arch/x86/include/asm/pkvm_spinlock.h
@@ -0,0 +1,64 @@
+// SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0
+/*
+ * Copyright (C) 2018-2022 Intel Corporation
+ *
+ * pkvm runs in a self-contained environment
+ * and requires a self-contained spinlock implementation
+ * which doesn't rely on any other external symbols.
+ *
+ * This is arch specific implementation
+ */
+#ifndef _X86_ASM_PKVM_SPINLOCK_H
+#define _X86_ASM_PKVM_SPINLOCK_H
+
+#include <linux/types.h>
+
+typedef union pkvm_spinlock {
+	u64	__val;
+	struct {
+		u32 head;
+		u32 tail;
+	};
+} pkvm_spinlock_t;
+
+#define __PKVM_SPINLOCK_UNLOCKED 			\
+	((pkvm_spinlock_t){ .__val = 0 })
+
+#define pkvm_spin_lock_init(l) 				\
+do {							\
+	*(l) = __PKVM_SPINLOCK_UNLOCKED;		\
+} while (0);
+
+static inline void pkvm_spin_lock(pkvm_spinlock_t *lock)
+{
+	/* The lock function atomically increments and exchanges the head
+	 * counter of the queue. If the old head of the queue is equal to the
+	 * tail, we have locked the spinlock. Otherwise we have to wait.
+	 */
+
+	asm volatile ("   movl $0x1,%%eax\n"
+		      "   lock xaddl %%eax,%[head]\n"
+		      "   cmpl %%eax,%[tail]\n"
+		      "   jz 1f\n"
+		      "2: pause\n"
+		      "   cmpl %%eax,%[tail]\n"
+		      "   jnz 2b\n"
+		      "1:\n"
+		      :
+		      :
+		      [head] "m"(lock->head),
+		      [tail] "m"(lock->tail)
+		      : "cc", "memory", "eax");
+}
+
+static inline void pkvm_spin_unlock(pkvm_spinlock_t *lock)
+{
+	/* Increment tail of queue */
+	asm volatile ("   lock incl %[tail]\n"
+				:
+				: [tail] "m" (lock->tail)
+				: "cc", "memory");
+
+}
+
+#endif
-- 
2.25.1

