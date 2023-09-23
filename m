Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E941E7AC039
	for <lists+kvm@lfdr.de>; Sat, 23 Sep 2023 12:17:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231840AbjIWKPP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 23 Sep 2023 06:15:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231674AbjIWKPC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 23 Sep 2023 06:15:02 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDE05E5C;
        Sat, 23 Sep 2023 03:11:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695463917; x=1726999917;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=I/WDYuAd3nxCrdi9nQ03uROwALnkbrNhAERS8D1SLLE=;
  b=Tx3TkyCCjCVXjf0rj3Nz5YDTdSS+WvV9vLsawe+1ZSMGtqvqmb8jCFjZ
   Fa87W//jst/MhetknBuAWx7Q3GcCWek+PU1hXzpKU6UouWUr6uDDqYLTC
   oZeASKT7ieA/xBgriDLLVm4GeFL9oNFlXOAMmfMmLgWI8uYcbNsMRc7le
   RCyVyFt+nCwuLN0G1Rz4D0FKPReKfNS/DeOV3DYM9j3+Dug2GVgGHV6DN
   O68TiXGlvq1bvT6H6E0KxRT+xe6YX/yC2dEaM6aN4oASflIW9Ju1YTukK
   HhWNmia4XMfG7R/aU1ahyf+I80fGHkFlOwlk5QZhkDyOIJ6sMPEfSOIvJ
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10841"; a="447492448"
X-IronPort-AV: E=Sophos;i="6.03,171,1694761200"; 
   d="scan'208";a="447492448"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2023 03:11:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10841"; a="813388209"
X-IronPort-AV: E=Sophos;i="6.03,171,1694761200"; 
   d="scan'208";a="813388209"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by fmsmga008.fm.intel.com with ESMTP; 23 Sep 2023 03:11:51 -0700
From:   Xin Li <xin3.li@intel.com>
To:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-edac@vger.kernel.org, linux-hyperv@vger.kernel.org,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        luto@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        peterz@infradead.org, jgross@suse.com, ravi.v.shankar@intel.com,
        mhiramat@kernel.org, andrew.cooper3@citrix.com,
        jiangshanlai@gmail.com, nik.borisov@suse.com
Subject: [PATCH v11 31/37] x86/fred: Fixup fault on ERETU by jumping to fred_entrypoint_user
Date:   Sat, 23 Sep 2023 02:42:06 -0700
Message-Id: <20230923094212.26520-32-xin3.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230923094212.26520-1-xin3.li@intel.com>
References: <20230923094212.26520-1-xin3.li@intel.com>
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

Changes since v8:
* Reflect the FRED spec 5.0 change that ERETS and ERETU add 8 to %rsp
  before popping the return context from the stack.

Changes since v6:
* Add a comment to explain why it is safe to write to the previous FRED stack
  frame. (Lai Jiangshan).

Changes since v5:
* Move the NMI bit from an invalid stack frame, which caused ERETU to fault,
  to the fault handler's stack frame, thus to unblock NMI ASAP if NMI is blocked
  (Lai Jiangshan).
---
 arch/x86/entry/entry_64_fred.S             |  5 +-
 arch/x86/include/asm/extable_fixup_types.h |  4 +-
 arch/x86/mm/extable.c                      | 79 ++++++++++++++++++++++
 3 files changed, 86 insertions(+), 2 deletions(-)

diff --git a/arch/x86/entry/entry_64_fred.S b/arch/x86/entry/entry_64_fred.S
index 5781c3411b44..d1c2fc4af8ae 100644
--- a/arch/x86/entry/entry_64_fred.S
+++ b/arch/x86/entry/entry_64_fred.S
@@ -3,6 +3,7 @@
  * The actual FRED entry points.
  */
 
+#include <asm/asm.h>
 #include <asm/fred.h>
 
 #include "calling.h"
@@ -34,7 +35,9 @@ SYM_CODE_START_NOALIGN(asm_fred_entrypoint_user)
 	call	fred_entry_from_user
 SYM_INNER_LABEL(asm_fred_exit_user, SYM_L_GLOBAL)
 	FRED_EXIT
-	ERETU
+1:	ERETU
+
+	_ASM_EXTABLE_TYPE(1b, asm_fred_entrypoint_user, EX_TYPE_ERETU)
 SYM_CODE_END(asm_fred_entrypoint_user)
 
 .fill asm_fred_entrypoint_kernel - ., 1, 0xcc
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
index 271dcb2deabc..bc7af7e8587b 100644
--- a/arch/x86/mm/extable.c
+++ b/arch/x86/mm/extable.c
@@ -6,6 +6,7 @@
 #include <xen/xen.h>
 
 #include <asm/fpu/api.h>
+#include <asm/fred.h>
 #include <asm/sev.h>
 #include <asm/traps.h>
 #include <asm/kdebug.h>
@@ -223,6 +224,80 @@ static bool ex_handler_ucopy_len(const struct exception_table_entry *fixup,
 	return ex_handler_uaccess(fixup, regs, trapnr, fault_address);
 }
 
+#ifdef CONFIG_X86_FRED
+static bool ex_handler_eretu(const struct exception_table_entry *fixup,
+			     struct pt_regs *regs, unsigned long error_code)
+{
+	struct pt_regs *uregs = (struct pt_regs *)
+		(regs->sp - offsetof(struct pt_regs, orig_ax));
+	unsigned short ss = uregs->ss;
+	unsigned short cs = uregs->cs;
+
+	/*
+	 * Move the NMI bit from the invalid stack frame, which caused ERETU
+	 * to fault, to the fault handler's stack frame, thus to unblock NMI
+	 * with the fault handler's ERETS instruction ASAP if NMI is blocked.
+	 */
+	regs->fred_ss.nmi = uregs->fred_ss.nmi;
+
+	/*
+	 * Sync event information to uregs, i.e., the ERETU return frame, but
+	 * is it safe to write to the ERETU return frame which is just above
+	 * current event stack frame?
+	 *
+	 * The RSP used by FRED to push a stack frame is not the value in %rsp,
+	 * it is calculated from %rsp with the following 2 steps:
+	 * 1) RSP = %rsp - (IA32_FRED_CONFIG & 0x1c0)	// Reserve N*64 bytes
+	 * 2) RSP = RSP & ~0x3f		// Align to a 64-byte cache line
+	 * when an event delivery doesn't trigger a stack level change.
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
+	 *                         |_____IP_______|
+	 *  64-byte cache line ==> |__Error_code__| <== ERETU return frame
+	 *                         |______________|
+	 *                         |______________|
+	 *                         |______________|
+	 *                         |______________|
+	 *                         |______________|
+	 *                         |______________|
+	 *                         |______________|
+	 *  64-byte cache line ==> |______________| <== RSP after step 1) and 2)
+	 *                         |___Reserved___|
+	 *                         |__Event_data__|
+	 *                         |_____SS_______|
+	 *                         |_____RSP______|
+	 *                         |_____FLAGS____|
+	 *                         |_____CS_______|
+	 *                         |_____IP_______|
+	 *  64-byte cache line ==> |__Error_code__| <== ERETS return frame
+	 *
+	 * Thus a new FRED stack frame will always be pushed below a previous
+	 * FRED stack frame ((N*64) bytes may be reserved between), and it is
+	 * safe to write to a previous FRED stack frame as they never overlap.
+	 */
+	fred_info(uregs)->edata = fred_event_data(regs);
+	uregs->ssx = regs->ssx;
+	uregs->fred_ss.ss = ss;
+	/* The NMI bit was moved away above */
+	uregs->fred_ss.nmi = 0;
+	uregs->csx = regs->csx;
+	uregs->sl = 0;
+	uregs->wfe = 0;
+	uregs->cs = cs;
+	uregs->orig_ax = error_code;
+
+	return ex_handler_default(fixup, regs);
+}
+#endif
+
 int ex_get_fixup_type(unsigned long ip)
 {
 	const struct exception_table_entry *e = search_exception_tables(ip);
@@ -300,6 +375,10 @@ int fixup_exception(struct pt_regs *regs, int trapnr, unsigned long error_code,
 		return ex_handler_ucopy_len(e, regs, trapnr, fault_addr, reg, imm);
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

