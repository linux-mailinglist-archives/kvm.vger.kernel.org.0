Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94A636B645C
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 10:55:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229996AbjCLJzL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 05:55:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229885AbjCLJyx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 05:54:53 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2FB438E91
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 01:54:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678614891; x=1710150891;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=43+IlWk6p6/5rM+OqLmAMTi68UiLbMtHkHvHuZGXZyA=;
  b=D4CxIYWPM/HYqX8MCxk/cqLPiyXgSH3psbfYlWrw7J7wABmqFl/5uc7n
   4M+GGV3BA0ysJSoAQbOCWQgJ5c0W6baggt1rGf4W1ii653e7hpzH0OGD7
   bnmXVFueyMW5KW1lp2ZN6PQynjTsnw6R5lUxbgsNlc5ArEYkOwHcimDnL
   kapL4wSFc7uXSQcGTvEgf00u+DKVpl+tjnQPs5RmJYWgVQ7a+5v8VbPCt
   esR5P6hO0sjpMY4w7Q1UkKxdumR22SzY6tMep6RF6vGTHj0eQ8CjuJ7Br
   cbUgvOKAWPHzQFJDQSwXtU0sx10wjW0OCIwkTZWAKE87rTebvYNVcVchH
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="316622948"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="316622948"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:54:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="852409036"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="852409036"
Received: from jiechen-ubuntu-dev.sh.intel.com ([10.239.154.150])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:54:36 -0800
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     kvm@vger.kernel.org
Cc:     Jason Chen CJ <jason.cj.chen@intel.com>
Subject: [RFC PATCH part-2 14/17] pkvm: x86: Add pKVM retpoline.S
Date:   Mon, 13 Mar 2023 02:01:09 +0800
Message-Id: <20230312180112.1778254-15-jason.cj.chen@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230312180112.1778254-1-jason.cj.chen@intel.com>
References: <20230312180112.1778254-1-jason.cj.chen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

pKVM need to compile in its own indirect thunk to avoid linking to
host Linux symbols - not reusing arch/x86/lib/retpoline.S is because
its implementation is based on "ALTERNATIVE" which leads to adding
code in __alt_instructions section - pKVM now does not support it.

TODO: support ALTERNATIVE for pKVM, make it be able to reuse
arch/x86/lib/retpoline.S and able to fixup based on HW feature
during runtime.

Signed-off-by: Jason Chen CJ <jason.cj.chen@intel.com>
---
 arch/x86/kvm/vmx/pkvm/hyp/lib/retpoline.S | 113 ++++++++++++++++++++++
 1 file changed, 113 insertions(+)

diff --git a/arch/x86/kvm/vmx/pkvm/hyp/lib/retpoline.S b/arch/x86/kvm/vmx/pkvm/hyp/lib/retpoline.S
new file mode 100644
index 000000000000..63e0ec9e16b1
--- /dev/null
+++ b/arch/x86/kvm/vmx/pkvm/hyp/lib/retpoline.S
@@ -0,0 +1,113 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#include <linux/linkage.h>
+#include <asm/dwarf2.h>
+#include <asm/nospec-branch.h>
+#include <asm/unwind_hints.h>
+#include <asm/frame.h>
+
+	.section .text.__x86.indirect_thunk
+
+.macro RETPOLINE reg
+	ANNOTATE_INTRA_FUNCTION_CALL
+	call    .Ldo_rop_\@
+.Lspec_trap_\@:
+	UNWIND_HINT_EMPTY
+	pause
+	lfence
+	jmp .Lspec_trap_\@
+.Ldo_rop_\@:
+	mov     %\reg, (%_ASM_SP)
+	UNWIND_HINT_FUNC
+	RET
+.endm
+
+.macro THUNK reg
+
+	.align RETPOLINE_THUNK_SIZE
+SYM_INNER_LABEL(__x86_indirect_thunk_\reg, SYM_L_GLOBAL)
+	UNWIND_HINT_EMPTY
+
+	RETPOLINE \reg
+
+.endm
+
+	.align RETPOLINE_THUNK_SIZE
+SYM_CODE_START(__x86_indirect_thunk_array)
+
+#define GEN(reg) THUNK reg
+#include <asm/GEN-for-each-reg.h>
+#undef GEN
+
+	.align RETPOLINE_THUNK_SIZE
+SYM_CODE_END(__x86_indirect_thunk_array)
+
+/*
+ * This function name is magical and is used by -mfunction-return=thunk-extern
+ * for the compiler to generate JMPs to it.
+ */
+#ifdef CONFIG_RETHUNK
+
+	.section .text.__x86.return_thunk
+
+/*
+ * Safety details here pertain to the AMD Zen{1,2} microarchitecture:
+ * 1) The RET at __x86_return_thunk must be on a 64 byte boundary, for
+ *    alignment within the BTB.
+ * 2) The instruction at zen_untrain_ret must contain, and not
+ *    end with, the 0xc3 byte of the RET.
+ * 3) STIBP must be enabled, or SMT disabled, to prevent the sibling thread
+ *    from re-poisioning the BTB prediction.
+ */
+	.align 64
+	.skip 63, 0xcc
+SYM_FUNC_START_NOALIGN(zen_untrain_ret);
+
+	/*
+	 * As executed from zen_untrain_ret, this is:
+	 *
+	 *   TEST $0xcc, %bl
+	 *   LFENCE
+	 *   JMP __x86_return_thunk
+	 *
+	 * Executing the TEST instruction has a side effect of evicting any BTB
+	 * prediction (potentially attacker controlled) attached to the RET, as
+	 * __x86_return_thunk + 1 isn't an instruction boundary at the moment.
+	 */
+	.byte	0xf6
+
+	/*
+	 * As executed from __x86_return_thunk, this is a plain RET.
+	 *
+	 * As part of the TEST above, RET is the ModRM byte, and INT3 the imm8.
+	 *
+	 * We subsequently jump backwards and architecturally execute the RET.
+	 * This creates a correct BTB prediction (type=ret), but in the
+	 * meantime we suffer Straight Line Speculation (because the type was
+	 * no branch) which is halted by the INT3.
+	 *
+	 * With SMT enabled and STIBP active, a sibling thread cannot poison
+	 * RET's prediction to a type of its choice, but can evict the
+	 * prediction due to competitive sharing. If the prediction is
+	 * evicted, __x86_return_thunk will suffer Straight Line Speculation
+	 * which will be contained safely by the INT3.
+	 */
+SYM_INNER_LABEL(__x86_return_thunk, SYM_L_GLOBAL)
+	ret
+	int3
+SYM_CODE_END(__x86_return_thunk)
+
+	/*
+	 * Ensure the TEST decoding / BTB invalidation is complete.
+	 */
+	lfence
+
+	/*
+	 * Jump back and execute the RET in the middle of the TEST instruction.
+	 * INT3 is for SLS protection.
+	 */
+	jmp __x86_return_thunk
+	int3
+SYM_FUNC_END(zen_untrain_ret)
+
+#endif /* CONFIG_RETHUNK */
-- 
2.25.1

