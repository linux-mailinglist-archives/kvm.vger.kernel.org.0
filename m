Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BA056D5E2C
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 12:54:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234613AbjDDKyI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 06:54:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234747AbjDDKxZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 06:53:25 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 057371FEE;
        Tue,  4 Apr 2023 03:53:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680605586; x=1712141586;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BCbf0Vj9ZyZPtbZTSgD/ohjbP2Y9NHqyEC0o1Sj/JgM=;
  b=TrenjyG3RJT0DCB6/zvBjzwIods1png+u5WY8Rp0LC3xZ0b+CXPfKyUq
   sbdts3mpd8DXMS3DbnZ5NgD/ky3lr4Z3OHMnKKYgfGBWNqUwNXKIEIW7Z
   2Bl+vIa4I/n0htiCGHYOUdqt6CTw4u7QXoOxtQgmXOC855qYqapMlXRC5
   p7HL2C4Mgr9mDhBpHzP3mNptsxVPVdVGNQDU0SPRUdGXlY2xZDunIbVtq
   jSqrCMIbMg8uY2OWdMAGYNAfoR7X5iy2zrmjgzJRUgx15Sx4oVL0GJlQL
   duPg8O4aeb3BU/LSAhH7BduwE3mnLoBclVTlNDWIT5xgOWjKEJinR5P/y
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="330733969"
X-IronPort-AV: E=Sophos;i="5.98,317,1673942400"; 
   d="scan'208";a="330733969"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2023 03:53:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="775597792"
X-IronPort-AV: E=Sophos;i="5.98,317,1673942400"; 
   d="scan'208";a="775597792"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by FMSMGA003.fm.intel.com with ESMTP; 04 Apr 2023 03:53:00 -0700
From:   Xin Li <xin3.li@intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, peterz@infradead.org,
        andrew.cooper3@citrix.com, seanjc@google.com, pbonzini@redhat.com,
        ravi.v.shankar@intel.com, jiangshanlai@gmail.com,
        shan.kang@intel.com
Subject: [PATCH v7 05/33] x86/traps: add external_interrupt() to dispatch external interrupts
Date:   Tue,  4 Apr 2023 03:26:48 -0700
Message-Id: <20230404102716.1795-6-xin3.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230404102716.1795-1-xin3.li@intel.com>
References: <20230404102716.1795-1-xin3.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: "H. Peter Anvin (Intel)" <hpa@zytor.com>

Add external_interrupt() to dispatch external interrupts to their handlers.

If an external interrupt is a system interrupt, dipatch it through
system_interrupt_handlers table, otherwise to dispatch_common_interrupt().

Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Co-developed-by: Xin Li <xin3.li@intel.com>
Tested-by: Shan Kang <shan.kang@intel.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
---

Changes since v5:
* Initialize system_interrupt_handlers with dispatch_table_spurious_interrupt()
  instead of NULL to get rid of a branch (Peter Zijlstra).
---
 arch/x86/kernel/traps.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 12072e2af4a6..f86cd233b00b 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -1511,6 +1511,32 @@ static system_interrupt_handler system_interrupt_handlers[NR_SYSTEM_VECTORS] = {
 
 #undef SYSV
 
+/*
+ * External interrupt dispatch function.
+ *
+ * Until/unless dispatch_common_interrupt() can be taught to deal with the
+ * special system vectors, split the dispatch.
+ *
+ * Note: dispatch_common_interrupt() already deals with IRQ_MOVE_CLEANUP_VECTOR.
+ */
+int external_interrupt(struct pt_regs *regs)
+{
+	unsigned int vector = regs->vector;
+	unsigned int sysvec = vector - FIRST_SYSTEM_VECTOR;
+
+	if (vector < FIRST_EXTERNAL_VECTOR) {
+		pr_err("invalid external interrupt vector %d\n", vector);
+		return -EINVAL;
+	}
+
+	if (sysvec < NR_SYSTEM_VECTORS)
+		system_interrupt_handlers[sysvec](regs);
+	else
+		dispatch_common_interrupt(regs, vector);
+
+	return 0;
+}
+
 #endif /* CONFIG_X86_64 */
 
 void __init install_system_interrupt_handler(unsigned int n, const void *asm_addr, const void *addr)
-- 
2.34.1

