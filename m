Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 582C7651B17
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 08:01:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233324AbiLTHBq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 02:01:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232858AbiLTHBb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 02:01:31 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0596E2ADE;
        Mon, 19 Dec 2022 23:01:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671519690; x=1703055690;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DCWXhKrktyBv8aibjttu3M7wa+RfYSum0IIVl7wgtzY=;
  b=ZbEX1h4+x9FlSbSJjDtzmwJSAx/UxRoI4QK35371x6/3wnU95Fs6iM4N
   QQnsV5Jb5Sld5P41pfAU145ybYCoBnOSeVmF+h+LufYj6k5Fc2TL2Im/t
   nqHkyWiLTNSRq9Ezpz89wFycqpWsU8fMAO0WklXFXR1aE9wzt5IYE4mWD
   hAVOfWoP0WrMQdS8AbDzn3fKtXsO+eIiGpdSKlQcmDamBO08OpoV9hiSZ
   621E07VVw3r+g3+cPEj5/LI9W1XXEle2cvH2ZUvrJ1qNybSE6TpizqIFu
   VicJhpc4My/f4oMkVwZqPf9mQtpQiMvqI5JtbiTs0au1LaeYBXo504dcy
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10566"; a="302971919"
X-IronPort-AV: E=Sophos;i="5.96,258,1665471600"; 
   d="scan'208";a="302971919"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2022 23:01:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10566"; a="644326421"
X-IronPort-AV: E=Sophos;i="5.96,258,1665471600"; 
   d="scan'208";a="644326421"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by orsmga007.jf.intel.com with ESMTP; 19 Dec 2022 23:01:09 -0800
From:   Xin Li <xin3.li@intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, peterz@infradead.org,
        andrew.cooper3@citrix.com, seanjc@google.com, pbonzini@redhat.com,
        ravi.v.shankar@intel.com
Subject: [RFC PATCH 04/32] x86/traps: add external_interrupt() to dispatch external interrupts
Date:   Mon, 19 Dec 2022 22:36:30 -0800
Message-Id: <20221220063658.19271-5-xin3.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221220063658.19271-1-xin3.li@intel.com>
References: <20221220063658.19271-1-xin3.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: "H. Peter Anvin (Intel)" <hpa@zytor.com>

Add external_interrupt() to dispatch external interrupts to their
handlers. If an external interrupt is a system interrupt, dipatch
it through system_interrupt_handler_table, otherwise call into
dispatch_common_interrupt().

Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Co-developed-by: Xin Li <xin3.li@intel.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
---
 arch/x86/kernel/traps.c | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 2b8530235e47..c35dd2b4d146 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -1499,6 +1499,43 @@ void __init install_system_interrupt_handler(unsigned int n, const void *asm_add
 	alloc_intr_gate(n, asm_addr);
 }
 
+#ifndef CONFIG_X86_LOCAL_APIC
+DEFINE_IDTENTRY_IRQ(spurious_interrupt)
+{
+	pr_info("Spurious interrupt (vector 0x%x) on CPU#%d, should never happen.\n",
+		vector, smp_processor_id());
+}
+#endif
+
+/*
+ * External interrupt dispatch function.
+ *
+ * Until/unless dispatch_common_interrupt() can be taught to deal with the
+ * special system vectors, split the dispatch.
+ *
+ * Note: dispatch_common_interrupt() already deals with IRQ_MOVE_CLEANUP_VECTOR.
+ */
+int external_interrupt(struct pt_regs *regs, unsigned int vector)
+{
+	unsigned int sysvec = vector - FIRST_SYSTEM_VECTOR;
+
+	if (vector < FIRST_EXTERNAL_VECTOR) {
+		pr_err("invalid external interrupt vector %d\n", vector);
+		return -EINVAL;
+	}
+
+	if (sysvec < NR_SYSTEM_VECTORS) {
+		if (system_interrupt_handlers[sysvec])
+			system_interrupt_handlers[sysvec](regs);
+		else
+			dispatch_spurious_interrupt(regs, vector);
+	} else {
+		dispatch_common_interrupt(regs, vector);
+	}
+
+	return 0;
+}
+
 void __init trap_init(void)
 {
 	/* Init cpu_entry_area before IST entries are set up */
-- 
2.34.1

