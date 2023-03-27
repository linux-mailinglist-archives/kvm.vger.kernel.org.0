Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB0E06C9DCA
	for <lists+kvm@lfdr.de>; Mon, 27 Mar 2023 10:25:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233270AbjC0IZm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Mar 2023 04:25:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233167AbjC0IY7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Mar 2023 04:24:59 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5348F55AF;
        Mon, 27 Mar 2023 01:24:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679905482; x=1711441482;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VwyNhQio5Socw2IUc5t0oP8YMATfSIZwdBkoKsUZAk4=;
  b=TmApJqE8b8xFgRgi+hOhjSdyzxapoI4qJdTvMTVCZv31IVGjI2z4cTaH
   xGeJFRhctrFdRKr/QzHx88zUip9Kc035Zl/Qv/wc0AaLUOxOf84ZxvOnV
   2zhs342DF7lWxsz0+irVj9olkiUaGFRuXYkNgmfNFow+LYiKcYR6A2QDJ
   eiDeSJaP2Q83MQ9Sm5xnlkPJipBj0JWW5Y/9tOHxIhNF5I/i9b/sL4QPK
   KT4gSHtSfgKgvUPUk6V+aJkABm9i3YnOsKzOV99vZKFo7qLvLDrOyBRc0
   TL2WJJo6mntAtJz9xaZEA777kze+tOxl+rDGS5JAfUBNa3CJMIlwc1gU3
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10661"; a="338930375"
X-IronPort-AV: E=Sophos;i="5.98,294,1673942400"; 
   d="scan'208";a="338930375"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2023 01:24:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10661"; a="713787138"
X-IronPort-AV: E=Sophos;i="5.98,294,1673942400"; 
   d="scan'208";a="713787138"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by orsmga008.jf.intel.com with ESMTP; 27 Mar 2023 01:24:39 -0700
From:   Xin Li <xin3.li@intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, peterz@infradead.org,
        andrew.cooper3@citrix.com, seanjc@google.com, pbonzini@redhat.com,
        ravi.v.shankar@intel.com, jiangshanlai@gmail.com,
        shan.kang@intel.com
Subject: [PATCH v6 27/33] x86/fred: fixup fault on ERETU by jumping to fred_entrypoint_user
Date:   Mon, 27 Mar 2023 00:58:32 -0700
Message-Id: <20230327075838.5403-28-xin3.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230327075838.5403-1-xin3.li@intel.com>
References: <20230327075838.5403-1-xin3.li@intel.com>
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

If the stack frame contains an invalid user context (e.g. due to invalid SS,
a non-canonical RIP, etc.) the ERETU instruction will trap (#SS or #GP).

From a Linux point of view, this really should be considered a user space
failure, so use the standard fault fixup mechanism to intercept the fault,
fix up the exception frame, and redirect execution to fred_entrypoint_user.
The end result is that it appears just as if the hardware had taken the
exception immediately after completing the transition to user space.

Suggested-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Tested-by: Shan Kang <shan.kang@intel.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
---

Changes since v5:
* Move the NMI bit from an invalid stack frame, which caused ERETU to fault,
  to the fault handler's stack frame, thus to unblock NMI ASAP if NMI is blocked
  (Lai Jiangshan).
---
 arch/x86/entry/entry_64_fred.S             |  8 +++--
 arch/x86/include/asm/extable_fixup_types.h |  4 ++-
 arch/x86/mm/extable.c                      | 36 ++++++++++++++++++++++
 3 files changed, 45 insertions(+), 3 deletions(-)

diff --git a/arch/x86/entry/entry_64_fred.S b/arch/x86/entry/entry_64_fred.S
index d975cacd060f..efe2bcd11273 100644
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
 
 .fill fred_entrypoint_kernel - ., 1, 0xcc
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
index 60814e110a54..a5d75b27a993 100644
--- a/arch/x86/mm/extable.c
+++ b/arch/x86/mm/extable.c
@@ -6,6 +6,7 @@
 #include <xen/xen.h>
 
 #include <asm/fpu/api.h>
+#include <asm/fred.h>
 #include <asm/sev.h>
 #include <asm/traps.h>
 #include <asm/kdebug.h>
@@ -195,6 +196,37 @@ static bool ex_handler_ucopy_len(const struct exception_table_entry *fixup,
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
+	/*
+	 * Move the NMI bit from the invalid stack frame, which caused ERETU
+	 * to fault, to the fault handler's stack frame, thus to unblock NMI
+	 * with the fault handler's ERETS instruction ASAP if NMI is blocked.
+	 */
+	regs->nmi = uregs->nmi;
+
+	fred_info(uregs)->edata = fred_event_data(regs);
+	uregs->ssx = regs->ssx;
+	uregs->ss = ss;
+	uregs->csx = regs->csx;
+	uregs->nmi = 0;	/* The NMI bit was moved away above */
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
@@ -272,6 +304,10 @@ int fixup_exception(struct pt_regs *regs, int trapnr, unsigned long error_code,
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

