Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6BF874950C
	for <lists+kvm@lfdr.de>; Thu,  6 Jul 2023 07:42:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232731AbjGFFmg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jul 2023 01:42:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231950AbjGFFmf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jul 2023 01:42:35 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F14B819B7;
        Wed,  5 Jul 2023 22:42:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688622153; x=1720158153;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=fhO+nRl8dQCGf5/sU9bXTh4CEf27dyW1SWH8GIwBd0g=;
  b=N/vc52KbRQQypIL00pIZJd7DKMY4oQuFkcavTMknxWJwikmrffLiXhg2
   EfJov0fKfcxlFrkJuD8XEQJt7Fe/oWxsvUeLYqLSShhUA/oWFoMwJiJOG
   dVBIIw7vybvc+eURgtyW+nFEhmyZ9DH07egqsllc0wV+X2xO9LlSDf2Jx
   1yk8wZa5Pw3yYA0RZgeoiW50fZFpfq9TzwqGtF9OakGdKq5SAXrO3KBsw
   dAe9plm85NSN75QLqPI9iFAiMdZUSjbWuUuhuq5K3fexq9Ng4JnW1LU+f
   wYrMBEwAUZrrXLS3i8f04VHLCTB2lwe7tdHlPjBqZSHdT1dC3n2j7rfDk
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10762"; a="362381887"
X-IronPort-AV: E=Sophos;i="6.01,184,1684825200"; 
   d="scan'208";a="362381887"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2023 22:42:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10762"; a="696728942"
X-IronPort-AV: E=Sophos;i="6.01,184,1684825200"; 
   d="scan'208";a="696728942"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by orsmga006.jf.intel.com with ESMTP; 05 Jul 2023 22:42:24 -0700
From:   Xin Li <xin3.li@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, seanjc@google.com,
        pbonzini@redhat.com, xin3.li@intel.com
Subject: [PATCH] x86/trapnr: Add event type macros to <asm/trapnr.h>
Date:   Wed,  5 Jul 2023 22:14:43 -0700
Message-Id: <20230706051443.2054-1-xin3.li@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Intel VT-x classifies events into eight different types, which is
inherited by FRED for event identification. As such, event type
becomes a common x86 concept, and should be defined in a common x86
header.

Add event type macros to <asm/trapnr.h>, and use it in <asm/vmx.h>.

Suggested-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
---
 arch/x86/include/asm/trapnr.h | 18 ++++++++++++++++++
 arch/x86/include/asm/vmx.h    | 17 +++++++++--------
 2 files changed, 27 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/trapnr.h b/arch/x86/include/asm/trapnr.h
index f5d2325aa0b7..356af7ceab4d 100644
--- a/arch/x86/include/asm/trapnr.h
+++ b/arch/x86/include/asm/trapnr.h
@@ -2,6 +2,24 @@
 #ifndef _ASM_X86_TRAPNR_H
 #define _ASM_X86_TRAPNR_H
 
+/*
+ * Event type codes used by both Intel VT-x and FRED
+ */
+/* Maskable external interrupt */
+#define EVENT_TYPE_HWINT	0
+#define EVENT_TYPE_RESERVED	1
+#define EVENT_TYPE_NMI		2
+/* Hardware exceptions (e.g., page fault) */
+#define EVENT_TYPE_HWFAULT	3
+/* Software interrupt (INT n) */
+#define EVENT_TYPE_SWINT	4
+/* INT1 (ICEBP) */
+#define EVENT_TYPE_PRIVSW	5
+/* Software exception (INT3 or INTO) */
+#define EVENT_TYPE_SWFAULT	6
+/* VT-x MTF or FRED SYSCALL/SYSENTER */
+#define EVENT_TYPE_OTHER	7
+
 /* Interrupts/Exceptions */
 
 #define X86_TRAP_DE		 0	/* Divide-by-zero */
diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 0d02c4aafa6f..15a096fceb1d 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -17,6 +17,7 @@
 #include <linux/types.h>
 
 #include <uapi/asm/vmx.h>
+#include <asm/trapnr.h>
 #include <asm/vmxfeatures.h>
 
 #define VMCS_CONTROL_BIT(x)	BIT(VMX_FEATURE_##x & 0x1f)
@@ -374,14 +375,14 @@ enum vmcs_field {
 #define VECTORING_INFO_DELIVER_CODE_MASK    	INTR_INFO_DELIVER_CODE_MASK
 #define VECTORING_INFO_VALID_MASK       	INTR_INFO_VALID_MASK
 
-#define INTR_TYPE_EXT_INTR              (0 << 8) /* external interrupt */
-#define INTR_TYPE_RESERVED              (1 << 8) /* reserved */
-#define INTR_TYPE_NMI_INTR		(2 << 8) /* NMI */
-#define INTR_TYPE_HARD_EXCEPTION	(3 << 8) /* processor exception */
-#define INTR_TYPE_SOFT_INTR             (4 << 8) /* software interrupt */
-#define INTR_TYPE_PRIV_SW_EXCEPTION	(5 << 8) /* ICE breakpoint - undocumented */
-#define INTR_TYPE_SOFT_EXCEPTION	(6 << 8) /* software exception */
-#define INTR_TYPE_OTHER_EVENT           (7 << 8) /* other event */
+#define INTR_TYPE_EXT_INTR		(EVENT_TYPE_HWINT << 8)		/* external interrupt */
+#define INTR_TYPE_RESERVED		(EVENT_TYPE_RESERVED << 8)	/* reserved */
+#define INTR_TYPE_NMI_INTR		(EVENT_TYPE_NMI << 8)		/* NMI */
+#define INTR_TYPE_HARD_EXCEPTION	(EVENT_TYPE_HWFAULT << 8)	/* processor exception */
+#define INTR_TYPE_SOFT_INTR		(EVENT_TYPE_SWINT << 8)		/* software interrupt */
+#define INTR_TYPE_PRIV_SW_EXCEPTION	(EVENT_TYPE_PRIVSW << 8)	/* ICE breakpoint - undocumented */
+#define INTR_TYPE_SOFT_EXCEPTION	(EVENT_TYPE_SWFAULT << 8)	/* software exception */
+#define INTR_TYPE_OTHER_EVENT		(EVENT_TYPE_OTHER << 8)		/* other event */
 
 /* GUEST_INTERRUPTIBILITY_INFO flags. */
 #define GUEST_INTR_STATE_STI		0x00000001
-- 
2.34.1

