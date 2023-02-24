Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9B956A171B
	for <lists+kvm@lfdr.de>; Fri, 24 Feb 2023 08:28:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbjBXH2D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Feb 2023 02:28:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbjBXH15 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Feb 2023 02:27:57 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24F9F63DD1;
        Thu, 23 Feb 2023 23:27:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677223650; x=1708759650;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pa/cUeOfLDEP4cCNm1hlvFI0kYRiN/TNYCvAsLAxF3I=;
  b=jPugHKnk4TE7Gtx3DQcFx9EeDvFRCFz/ZZyEmATFUx7tBZfTOOq9FMF1
   vYufS7WkRzCH4mJoKoVsie0ixlHZVr5cUTRrVEGwHV0Ce210hWF5AaTSl
   bqB02dsWQAmZZkrJyMf8DFfWK9994xQFjrIb9ptJS70SdGWI2OaHXWAEy
   4/PHKCcqF4qeQcr/ptxDDbfkrFhKj1gNcXDIKBysaxawsao3z8Z+xIyM8
   ycajb5Eg3A4UE5mqF36nIpgKe/oRPHjbveYkE5owwA4A0j1LeG2PRaspO
   oGD+tHj6IotiNigX+N8lWi8zqljpH9/Cv5UllGWk0VUGIzJJKOaLAAzK+
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10630"; a="334835948"
X-IronPort-AV: E=Sophos;i="5.97,324,1669104000"; 
   d="scan'208";a="334835948"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2023 23:27:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10630"; a="815639197"
X-IronPort-AV: E=Sophos;i="5.97,324,1669104000"; 
   d="scan'208";a="815639197"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by fmsmga001.fm.intel.com with ESMTP; 23 Feb 2023 23:27:20 -0800
From:   Xin Li <xin3.li@intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, peterz@infradead.org,
        andrew.cooper3@citrix.com, seanjc@google.com, pbonzini@redhat.com,
        ravi.v.shankar@intel.com
Subject: [RFC PATCH v3 04/32] x86/traps: add external_interrupt() to dispatch external interrupts
Date:   Thu, 23 Feb 2023 23:01:17 -0800
Message-Id: <20230224070145.3572-5-xin3.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230224070145.3572-1-xin3.li@intel.com>
References: <20230224070145.3572-1-xin3.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
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
 arch/x86/kernel/traps.c | 41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index c0f7666140da..31ad645be2fb 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -1499,6 +1499,47 @@ void __init install_system_interrupt_handler(unsigned int n, const void *asm_add
 	alloc_intr_gate(n, asm_addr);
 }
 
+#ifndef CONFIG_X86_LOCAL_APIC
+/*
+ * Used when local APIC is not compiled into the kernel, but
+ * external_interrupt() needs dispatch_spurious_interrupt().
+ */
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

