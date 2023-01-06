Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1DE065FD8D
	for <lists+kvm@lfdr.de>; Fri,  6 Jan 2023 10:21:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232921AbjAFJUv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Jan 2023 04:20:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232926AbjAFJUR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Jan 2023 04:20:17 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 294976B5B4;
        Fri,  6 Jan 2023 01:20:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672996817; x=1704532817;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DCWXhKrktyBv8aibjttu3M7wa+RfYSum0IIVl7wgtzY=;
  b=MF95Ip/PsAGSx4tXW3kUwus4xpPRWD7jQj1WQAvdwoDaDwAwBx8QwqSy
   j6dlp+mS1L/EIwbRJGnxaILr0xPSFI1A9Sn7PZL63p4E1kK9T3b+PtMHg
   X9M7E/uWL+F1XLsCsudG//7CV81DY5VY+SFDVD7u+LkEtNnUxgHMS9i3h
   IKWMG3LRjWALI0+Xr5KgTEHg7sF7feAKcL97tKMjH/ex5rstLfsMHLkte
   Vv//u7vI+FpTZ9gh2QfD//kxXq3Kfp+b3WGeDnpNlcv6tixrLxoq4gqWU
   JumMrnQg5kD5LrEbwuqcAEz6TOvvh/hrRWoChxxUsQT/TTsaFcEbvJcUj
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10581"; a="322511409"
X-IronPort-AV: E=Sophos;i="5.96,304,1665471600"; 
   d="scan'208";a="322511409"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2023 01:20:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10581"; a="719139352"
X-IronPort-AV: E=Sophos;i="5.96,304,1665471600"; 
   d="scan'208";a="719139352"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by fmsmga008.fm.intel.com with ESMTP; 06 Jan 2023 01:20:12 -0800
From:   Xin Li <xin3.li@intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, peterz@infradead.org,
        andrew.cooper3@citrix.com, seanjc@google.com, pbonzini@redhat.com,
        ravi.v.shankar@intel.com
Subject: [RFC PATCH v2 04/32] x86/traps: add external_interrupt() to dispatch external interrupts
Date:   Fri,  6 Jan 2023 00:55:49 -0800
Message-Id: <20230106085617.17248-5-xin3.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230106085617.17248-1-xin3.li@intel.com>
References: <20230106085617.17248-1-xin3.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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

