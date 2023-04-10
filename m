Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E4926DC45B
	for <lists+kvm@lfdr.de>; Mon, 10 Apr 2023 10:41:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbjDJIlM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Apr 2023 04:41:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbjDJIlF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Apr 2023 04:41:05 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C5733AAD;
        Mon, 10 Apr 2023 01:41:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681116064; x=1712652064;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BCbf0Vj9ZyZPtbZTSgD/ohjbP2Y9NHqyEC0o1Sj/JgM=;
  b=GLi1NB3HM7JxG3th5VQR+LrMVv+XTvpezi97IdF+STW+5oIarJ+0Ete5
   mESESepyiE9n4UpY614rl7mrAtAMyhx/X+Qi1RNMm4KKuI4vuAaZ80iCs
   mpXPP34sWvQSUDqE+VvVNEkg33K4ouEzUiyUeMqrSONZPr7o36mI7m74o
   ulqjqYIqtM5g/LEre5/cAmETYN3CSIHv4LKWj9/08iOXG21IH0tbhpRub
   /eqSayLY57IiSBF26+Gj5PYG33SfuQWcUT1kbmKHqS623/5mI4G4XuQra
   BBDjgwju1B/OY+7nyCZGp0R5mjSS7qwyYpYj3yKnkqud69XDSyLZ7AQiA
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10675"; a="342077913"
X-IronPort-AV: E=Sophos;i="5.98,333,1673942400"; 
   d="scan'208";a="342077913"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2023 01:41:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10675"; a="799436254"
X-IronPort-AV: E=Sophos;i="5.98,333,1673942400"; 
   d="scan'208";a="799436254"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by fmsmga002.fm.intel.com with ESMTP; 10 Apr 2023 01:41:02 -0700
From:   Xin Li <xin3.li@intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, peterz@infradead.org,
        andrew.cooper3@citrix.com, seanjc@google.com, pbonzini@redhat.com,
        ravi.v.shankar@intel.com, jiangshanlai@gmail.com,
        shan.kang@intel.com
Subject: [PATCH v8 05/33] x86/traps: add external_interrupt() to dispatch external interrupts
Date:   Mon, 10 Apr 2023 01:14:10 -0700
Message-Id: <20230410081438.1750-6-xin3.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230410081438.1750-1-xin3.li@intel.com>
References: <20230410081438.1750-1-xin3.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
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

