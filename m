Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E127E6A1751
	for <lists+kvm@lfdr.de>; Fri, 24 Feb 2023 08:29:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbjBXH3y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Feb 2023 02:29:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbjBXH3b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Feb 2023 02:29:31 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E35FC63DE2;
        Thu, 23 Feb 2023 23:28:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677223710; x=1708759710;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JFgGgK1UiImaF1he4az5OO5OcUrrSSoji4V3Q7e0Ou0=;
  b=HENWigI6OocZmtzS48CF///m0o6droz+Zur3LZ1GnFIpBQmUmD63KKcx
   YX+vr7wNMNxQSzUYXvpVgMVlJNXuP4tXWuIz4YvcLU1xCQ2Vkw5SJGu1+
   +ZCXElpgrqeveq8GtN7/Jhlodn6Vrj1Sk4xfDr+GX0AcjJpXeiVHLZbUK
   aB7K6bqOQBY9HJNIprWJtCP/bxLl/NIrY/11uw4Oa+uznz48mJc58P1j4
   7qHAM2YHcVW8ryKICk5ng84PjS5ivIxbv8yyDytMrhT077ZJDPTudbpxQ
   gj5S3pbbj2ggAfbvxq0VOe1fe97bqJTVWpKeU7KjeP7m88jSjtKRHuVqw
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10630"; a="334836160"
X-IronPort-AV: E=Sophos;i="5.97,324,1669104000"; 
   d="scan'208";a="334836160"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2023 23:27:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10630"; a="815639278"
X-IronPort-AV: E=Sophos;i="5.97,324,1669104000"; 
   d="scan'208";a="815639278"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by fmsmga001.fm.intel.com with ESMTP; 23 Feb 2023 23:27:25 -0800
From:   Xin Li <xin3.li@intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, peterz@infradead.org,
        andrew.cooper3@citrix.com, seanjc@google.com, pbonzini@redhat.com,
        ravi.v.shankar@intel.com
Subject: [RFC PATCH v3 28/32] x86/fred: fixup fault on ERETU by jumping to fred_entrypoint_user
Date:   Thu, 23 Feb 2023 23:01:41 -0800
Message-Id: <20230224070145.3572-29-xin3.li@intel.com>
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

If the stack frame contains an invalid user context (e.g. due to invalid SS,
a non-canonical RIP, etc.) the ERETU instruction will trap (#SS or #GP).

From a Linux point of view, this really should be considered a user space
failure, so use the standard fault fixup mechanism to intercept the fault,
fix up the exception frame, and redirect execution to fred_entrypoint_user.
The end result is that it appears just as if the hardware had taken the
exception immediately after completing the transition to user space.

Suggested-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
---
 arch/x86/entry/entry_64_fred.S             |  8 +++++--
 arch/x86/include/asm/extable_fixup_types.h |  4 +++-
 arch/x86/mm/extable.c                      | 28 ++++++++++++++++++++++
 3 files changed, 37 insertions(+), 3 deletions(-)

diff --git a/arch/x86/entry/entry_64_fred.S b/arch/x86/entry/entry_64_fred.S
index 1fb765fd3871..027ef8f1e600 100644
--- a/arch/x86/entry/entry_64_fred.S
+++ b/arch/x86/entry/entry_64_fred.S
@@ -5,8 +5,10 @@
  * The actual FRED entry points.
  */
 #include <linux/linkage.h>
-#include <asm/errno.h>
+#include <asm/asm.h>
 #include <asm/asm-offsets.h>
+#include <asm/errno.h>
+#include <asm/export.h>
 #include <asm/fred.h>
 
 #include "calling.h"
@@ -38,7 +40,9 @@ SYM_CODE_START_NOALIGN(fred_entrypoint_user)
 	call	fred_entry_from_user
 SYM_INNER_LABEL(fred_exit_user, SYM_L_GLOBAL)
 	FRED_EXIT
-	ERETU
+1:	ERETU
+
+	_ASM_EXTABLE_TYPE(1b, fred_entrypoint_user, EX_TYPE_ERETU)
 SYM_CODE_END(fred_entrypoint_user)
 
 /*
diff --git a/arch/x86/include/asm/extable_fixup_types.h b/arch/x86/include/asm/extable_fixup_types.h
index 991e31cfde94..1585c798a02f 100644
--- a/arch/x86/include/asm/extable_fixup_types.h
+++ b/arch/x86/include/asm/extable_fixup_types.h
@@ -64,6 +64,8 @@
 #define	EX_TYPE_UCOPY_LEN4		(EX_TYPE_UCOPY_LEN | EX_DATA_IMM(4))
 #define	EX_TYPE_UCOPY_LEN8		(EX_TYPE_UCOPY_LEN | EX_DATA_IMM(8))
 
-#define EX_TYPE_ZEROPAD			20 /* longword load with zeropad on fault */
+#define	EX_TYPE_ZEROPAD			20 /* longword load with zeropad on fault */
+
+#define	EX_TYPE_ERETU			21
 
 #endif
diff --git a/arch/x86/mm/extable.c b/arch/x86/mm/extable.c
index 60814e110a54..31542a2507ae 100644
--- a/arch/x86/mm/extable.c
+++ b/arch/x86/mm/extable.c
@@ -6,6 +6,7 @@
 #include <xen/xen.h>
 
 #include <asm/fpu/api.h>
+#include <asm/fred.h>
 #include <asm/sev.h>
 #include <asm/traps.h>
 #include <asm/kdebug.h>
@@ -195,6 +196,29 @@ static bool ex_handler_ucopy_len(const struct exception_table_entry *fixup,
 	return ex_handler_uaccess(fixup, regs, trapnr);
 }
 
+#ifdef CONFIG_X86_FRED
+static bool ex_handler_eretu(const struct exception_table_entry *fixup,
+			     struct pt_regs *regs, unsigned long error_code)
+{
+	struct pt_regs *uregs = (struct pt_regs *)(regs->sp - offsetof(struct pt_regs, ip));
+	unsigned short ss = uregs->ss;
+	unsigned short cs = uregs->cs;
+
+	fred_info(uregs)->edata = fred_event_data(regs);
+	uregs->ssl = regs->ssl;
+	uregs->ss = ss;
+	uregs->csl = regs->csl;
+	uregs->current_stack_level = 0;
+	uregs->cs = cs;
+
+	/* Copy error code to uregs and adjust stack pointer accordingly */
+	uregs->orig_ax = error_code;
+	regs->sp -= 8;
+
+	return ex_handler_default(fixup, regs);
+}
+#endif
+
 int ex_get_fixup_type(unsigned long ip)
 {
 	const struct exception_table_entry *e = search_exception_tables(ip);
@@ -272,6 +296,10 @@ int fixup_exception(struct pt_regs *regs, int trapnr, unsigned long error_code,
 		return ex_handler_ucopy_len(e, regs, trapnr, reg, imm);
 	case EX_TYPE_ZEROPAD:
 		return ex_handler_zeropad(e, regs, fault_addr);
+#ifdef CONFIG_X86_FRED
+	case EX_TYPE_ERETU:
+		return ex_handler_eretu(e, regs, error_code);
+#endif
 	}
 	BUG();
 }
-- 
2.34.1

