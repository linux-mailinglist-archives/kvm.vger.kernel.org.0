Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DAA8651B39
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 08:03:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233283AbiLTHDE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 02:03:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233296AbiLTHBo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 02:01:44 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E09B15FFC;
        Mon, 19 Dec 2022 23:01:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671519702; x=1703055702;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uggmxMn6oJUIBEOGX26R5VtrTEJ+CYj34lHFi9H82Hs=;
  b=nFU7lkN3HiG5nD4TTdl2XA1ZZHOIShVI9Yv3dSezTsTr4iBLB3O4BK1E
   ZXysdbDlOSPxZHvHv89JAr6hoQ/iQF4MboQf9zBSFZYLEeeHKtnBj/SDz
   L/x8j5Mpj7eaG6OJ8AoGmgwrvipO+Vqc1b5cjGAnUpxEqK4U9mbpl4/2q
   V6ZW83XzwPlbMnK+XtddkUJFoptyqxYA/BX2uXw0L0VA7BkC2PPiKXq9m
   Me8JUGPsQXdyfwVXiZjr1INt4GAySMM9CjjbxNq8cKn2Sy3VMGb+geGPD
   sisWt3hc2b4CWazxbBf+xOeh8NK3ZzV9xJUQWqFZ1hXrsMWYh1nUPRxqW
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10566"; a="302972155"
X-IronPort-AV: E=Sophos;i="5.96,258,1665471600"; 
   d="scan'208";a="302972155"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2022 23:01:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10566"; a="644326547"
X-IronPort-AV: E=Sophos;i="5.96,258,1665471600"; 
   d="scan'208";a="644326547"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by orsmga007.jf.intel.com with ESMTP; 19 Dec 2022 23:01:19 -0800
From:   Xin Li <xin3.li@intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, peterz@infradead.org,
        andrew.cooper3@citrix.com, seanjc@google.com, pbonzini@redhat.com,
        ravi.v.shankar@intel.com
Subject: [RFC PATCH 28/32] x86/fred: fixup fault on ERETU by jumping to fred_entrypoint_user
Date:   Mon, 19 Dec 2022 22:36:54 -0800
Message-Id: <20221220063658.19271-29-xin3.li@intel.com>
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
 arch/x86/include/asm/extable_fixup_types.h |  4 ++++
 arch/x86/mm/extable.c                      | 28 ++++++++++++++++++++++
 3 files changed, 38 insertions(+), 2 deletions(-)

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
index 991e31cfde94..ddebd5b8b340 100644
--- a/arch/x86/include/asm/extable_fixup_types.h
+++ b/arch/x86/include/asm/extable_fixup_types.h
@@ -66,4 +66,8 @@
 
 #define EX_TYPE_ZEROPAD			20 /* longword load with zeropad on fault */
 
+#ifdef CONFIG_X86_FRED
+#define	EX_TYPE_ERETU			21
+#endif
+
 #endif
diff --git a/arch/x86/mm/extable.c b/arch/x86/mm/extable.c
index 60814e110a54..be9d75358f50 100644
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
+	uregs->orig_ax = error_code;
+
+	/* drop error code */
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

