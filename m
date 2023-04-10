Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5766F6DC48C
	for <lists+kvm@lfdr.de>; Mon, 10 Apr 2023 10:42:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229851AbjDJImb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Apr 2023 04:42:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbjDJIlu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Apr 2023 04:41:50 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F06D655A4;
        Mon, 10 Apr 2023 01:41:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681116074; x=1712652074;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vN6NNJbHk9GIVKoaWU6Utrw1wfL7ZoQD1u7WUYVyJf0=;
  b=EY2ITdTxl/gcPeDAJb5SrwIBxmt5wLwcctZyKXxSzM82uKctwloC3jBm
   2DpXuWNXZnSfK1B45KuxYQCdMF0NUfFJbs/jv24OfAOi0JgeHhBNp7Eeb
   shiujiBlvExdETnj+PnI9FMygA/K4HrI6sTtdXMozY1WNXI5FjmqX4KZg
   3bFUu81d9JnNq44F055PB7x9R+oI/DchHHcdpyj8akC6oBMhKyZCcd4Kl
   9U2ImmM+S6BXMOwjMD27IZjC/Zv6RwD/O+zUM+S28jhHMV9L6jD7xm6YQ
   s1GIsH9sY+lvm4RKFJcKJqG++PKQCbpIylmQks8I4GlggsjbjJgAeJVZE
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10675"; a="342078161"
X-IronPort-AV: E=Sophos;i="5.98,333,1673942400"; 
   d="scan'208";a="342078161"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2023 01:41:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10675"; a="799436350"
X-IronPort-AV: E=Sophos;i="5.98,333,1673942400"; 
   d="scan'208";a="799436350"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by fmsmga002.fm.intel.com with ESMTP; 10 Apr 2023 01:41:07 -0700
From:   Xin Li <xin3.li@intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, peterz@infradead.org,
        andrew.cooper3@citrix.com, seanjc@google.com, pbonzini@redhat.com,
        ravi.v.shankar@intel.com, jiangshanlai@gmail.com,
        shan.kang@intel.com
Subject: [PATCH v8 27/33] x86/fred: fixup fault on ERETU by jumping to fred_entrypoint_user
Date:   Mon, 10 Apr 2023 01:14:32 -0700
Message-Id: <20230410081438.1750-28-xin3.li@intel.com>
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

Changes since v6:
* Add a comment to explain why it is safe to write to the previous FRED stack
  frame. (Lai Jiangshan).

Changes since v5:
* Move the NMI bit from an invalid stack frame, which caused ERETU to fault,
  to the fault handler's stack frame, thus to unblock NMI ASAP if NMI is blocked
  (Lai Jiangshan).
---
 arch/x86/entry/entry_64_fred.S             |  8 ++-
 arch/x86/include/asm/extable_fixup_types.h |  4 +-
 arch/x86/mm/extable.c                      | 76 ++++++++++++++++++++++
 3 files changed, 85 insertions(+), 3 deletions(-)

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
index 60814e110a54..9d82193adf3c 100644
--- a/arch/x86/mm/extable.c
+++ b/arch/x86/mm/extable.c
@@ -6,6 +6,7 @@
 #include <xen/xen.h>
 
 #include <asm/fpu/api.h>
+#include <asm/fred.h>
 #include <asm/sev.h>
 #include <asm/traps.h>
 #include <asm/kdebug.h>
@@ -195,6 +196,77 @@ static bool ex_handler_ucopy_len(const struct exception_table_entry *fixup,
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
+	/*
+	 * Copy error code to uregs and adjust stack pointer accordingly.
+	 *
+	 * The RSP used by FRED to push a stack frame is not the value in %rsp,
+	 * it is calculated from %rsp with the following 2 steps:
+	 * 1) RSP = %rsp - (IA32_FRED_CONFIG & 0x1c0)	// Reserve N*64 bytes
+	 * 2) RSP = RSP & ~0x3f		// Align to a 64-byte cache line
+	 * when the event delivery doesn't trigger a stack level change.
+	 *
+	 * Here is an example with N*64 (N=1) bytes reserved:
+	 *
+	 *  64-byte cache line ==>  ______________
+	 *                         |___Reserved___|
+	 *                         |__Event_data__|
+	 *                         |_____SS_______|
+	 *                         |_____RSP______|
+	 *                         |_____FLAGS____|
+	 *                         |_____CS_______|
+	 *                         |_____IP_______|  <== ERETU stack frame
+	 *  64-byte cache line ==> |__Error_code__|
+	 *                         |______________|
+	 *                         |______________|
+	 *                         |______________|
+	 *                         |______________|
+	 *                         |______________|
+	 *                         |______________|
+	 *                         |______________|  <== RSP after step 1)
+	 *  64-byte cache line ==> |______________|  <== RSP after step 2)
+	 *                         |___Reserved___|
+	 *                         |__Event_data__|
+	 *                         |_____SS_______|
+	 *                         |_____RSP______|
+	 *                         |_____FLAGS____|
+	 *                         |_____CS_______|
+	 *                         |_____IP_______|  <== ERETS stack frame
+	 *  64-byte cache line ==> |__Error_code__|
+	 *
+	 * Thus a new FRED stack frame will always be pushed below a previous
+	 * FRED stack frame ((N*64) bytes may be reserved between), and it is
+	 * safe to write to a previous FRED stack frame as they never overlap.
+	 */
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
@@ -272,6 +344,10 @@ int fixup_exception(struct pt_regs *regs, int trapnr, unsigned long error_code,
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

