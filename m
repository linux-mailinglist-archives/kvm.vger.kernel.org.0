Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 347136AD541
	for <lists+kvm@lfdr.de>; Tue,  7 Mar 2023 04:05:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230257AbjCGDFb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Mar 2023 22:05:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230218AbjCGDFZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Mar 2023 22:05:25 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D60B75849D;
        Mon,  6 Mar 2023 19:05:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678158318; x=1709694318;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0uFNdDkUqLm94ae1U1jdZV+knFHrk6JmxBSxXFP+9lc=;
  b=Y8fQdiJwYH44xBdiFGaDHBjqXoggI062RPNCzzPWrxBfJZUcLC399FGL
   t5PSecNLTfvIGzDZ8hj+s4/i9c/gBiWuzCHkOMYl6jj3Dfi3qORu1/FUc
   hRUyzPuDrwChGLsC4vEf0Hm7+aTIOK/KvqdlhoBDHXdcMg4W7weAQogz2
   bvyUEgynjGKRidtxG33u+neHBRt2N7H0jkoQ09dOaVpTf8tdkv9dqIOfB
   Dj/+xUSuGZhZLSVTE+lc6wbDEVlunfgi7DmGJwcPjg/KV97GO3StWVW1w
   Jkosm1W8WGt03+orTJnrJhv8VapYv8Buzmi6VDrV7SdOMXxI2GZQA6mkj
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10641"; a="338072341"
X-IronPort-AV: E=Sophos;i="5.98,238,1673942400"; 
   d="scan'208";a="338072341"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2023 19:05:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10641"; a="676409718"
X-IronPort-AV: E=Sophos;i="5.98,238,1673942400"; 
   d="scan'208";a="676409718"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by orsmga002.jf.intel.com with ESMTP; 06 Mar 2023 19:05:11 -0800
From:   Xin Li <xin3.li@intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, peterz@infradead.org,
        andrew.cooper3@citrix.com, seanjc@google.com, pbonzini@redhat.com,
        ravi.v.shankar@intel.com
Subject: [PATCH v5 04/34] x86/traps: add external_interrupt() to dispatch external interrupts
Date:   Mon,  6 Mar 2023 18:39:16 -0800
Message-Id: <20230307023946.14516-5-xin3.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230307023946.14516-1-xin3.li@intel.com>
References: <20230307023946.14516-1-xin3.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
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
Tested-by: Shan Kang <shan.kang@intel.com>
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

