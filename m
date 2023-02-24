Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30F816A1739
	for <lists+kvm@lfdr.de>; Fri, 24 Feb 2023 08:28:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230011AbjBXH2t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Feb 2023 02:28:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbjBXH2R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Feb 2023 02:28:17 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0D7C410A8;
        Thu, 23 Feb 2023 23:28:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677223685; x=1708759685;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=AmI4CVrrpson0KuyKSQFz12EZ8608BBLxIPOHAFvgP0=;
  b=QCQhjcTBjz5E6UsJL3EzuYgEs/2g6xWZ8LbQr3qjVvVOrji01eF9VnCq
   bwqvQ87BFSQsY6QFca07/031VcMyEPA+8kaMW5ly22WiE5KdTKAGt7qBb
   IAL6RBQfgb4pYdWCRUIFtDcv8y2UQeZSJYBIb/0LmBHKChFLEB6UDPFCg
   3AblL7gS636qzLwxZZINzYzpdcYnZ9WEXhaD/Auzddg6CpQwbQZ5+xrBF
   DGi0hbrtB/tL6Gq8gpeA+JPaKIaN8VUOKbIS2t8DfZOf1z8olXlMDIjvX
   YbxjerX8+aDkX62ZhGQExD1psMgBnW9RKz4jozUFSFy1aRHNdu68yBQJe
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10630"; a="334836077"
X-IronPort-AV: E=Sophos;i="5.97,324,1669104000"; 
   d="scan'208";a="334836077"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2023 23:27:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10630"; a="815639248"
X-IronPort-AV: E=Sophos;i="5.97,324,1669104000"; 
   d="scan'208";a="815639248"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by fmsmga001.fm.intel.com with ESMTP; 23 Feb 2023 23:27:23 -0800
From:   Xin Li <xin3.li@intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, peterz@infradead.org,
        andrew.cooper3@citrix.com, seanjc@google.com, pbonzini@redhat.com,
        ravi.v.shankar@intel.com
Subject: [RFC PATCH v3 19/32] x86/fred: add a NMI entry stub for FRED
Date:   Thu, 23 Feb 2023 23:01:32 -0800
Message-Id: <20230224070145.3572-20-xin3.li@intel.com>
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

On a FRED system, NMIs nest both with themselves and faults, transient
information is saved into the stack frame, and NMI unblocking only
happens when the stack frame indicates that so should happen.

Thus, the NMI entry stub for FRED is really quite small...

Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
---
 arch/x86/include/asm/fred.h |  1 +
 arch/x86/kernel/nmi.c       | 28 ++++++++++++++++++++++++++++
 2 files changed, 29 insertions(+)

diff --git a/arch/x86/include/asm/fred.h b/arch/x86/include/asm/fred.h
index def4b3455c1f..753ae2adf422 100644
--- a/arch/x86/include/asm/fred.h
+++ b/arch/x86/include/asm/fred.h
@@ -94,6 +94,7 @@ static __always_inline unsigned long fred_event_data(struct pt_regs *regs)
 #define DEFINE_FRED_HANDLER(f) noinstr DECLARE_FRED_HANDLER(f)
 typedef DECLARE_FRED_HANDLER((*fred_handler));
 
+DECLARE_FRED_HANDLER(fred_exc_nmi);
 DECLARE_FRED_HANDLER(fred_exc_debug);
 DECLARE_FRED_HANDLER(fred_exc_page_fault);
 
diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index cec0bfa3bc04..b8f0357e4663 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -34,6 +34,7 @@
 #include <asm/cache.h>
 #include <asm/nospec-branch.h>
 #include <asm/sev.h>
+#include <asm/fred.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/nmi.h>
@@ -537,6 +538,33 @@ DEFINE_IDTENTRY_RAW(exc_nmi_noist)
 EXPORT_SYMBOL_GPL(asm_exc_nmi_noist);
 #endif
 
+#ifdef CONFIG_X86_FRED
+DEFINE_FRED_HANDLER(fred_exc_nmi)
+{
+	/*
+	 * With FRED, CR2 and DR6 are pushed atomically on faults,
+	 * so we don't have to worry about saving and restoring them.
+	 * Breakpoint faults nest, so assume it is OK to leave DR7
+	 * enabled.
+	 */
+	irqentry_state_t irq_state = irqentry_nmi_enter(regs);
+
+	/*
+	 * VM exits induced by NMIs keep NMI blocked, and we do
+	 * "int $2" to reinject the NMI w/ NMI kept being blocked.
+	 * However "int $2" doesn't set the nmi bit in the FRED
+	 * stack frame, so we explicitly set it to make sure a
+	 * later ERETS will unblock NMI immediately.
+	 */
+	regs->nmi = 1;
+
+	inc_irq_stat(__nmi_count);
+	default_do_nmi(regs);
+
+	irqentry_nmi_exit(regs, irq_state);
+}
+#endif
+
 void stop_nmi(void)
 {
 	ignore_nmis++;
-- 
2.34.1

