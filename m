Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A305651B2F
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 08:02:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233319AbiLTHCr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 02:02:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233223AbiLTHBg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 02:01:36 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C4DE14D2E;
        Mon, 19 Dec 2022 23:01:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671519695; x=1703055695;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UOsdS7+owJQ73WNU9ofGpL7BxDN6CoX4IXCHRYhbv+k=;
  b=aHZqzgyTtlJDLGCJrPpbmKXLxccoGPXsrkIsCGJxQaXRpIN5dKV0I4g1
   VZ1+7L4thjzkQhHeHTFrA6V4tRY1o76Sqf0XKnk7EJiXYaH8E3S9zGZLa
   AwigcRFNHkUtBox02rkBxLkTEsSbML+eTD5Sp9INeYoDeiQqS1+RX4qVn
   YkeJ4qudG7vnsDO2KNiC67Gw8kyDojbVCrvT/NwNTqxS2oFjZKbj8ttmi
   FUsc05Sbu07DjXzquKpQS/O7AmoRpq3wXnTg4IaECueqT5W6PkGcOL+si
   6pADefwcBAXwPac9bOEpQ6mG/7cuWFS759QVl2fa/+zhzt72KRXAThwHu
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10566"; a="302972012"
X-IronPort-AV: E=Sophos;i="5.96,258,1665471600"; 
   d="scan'208";a="302972012"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2022 23:01:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10566"; a="644326465"
X-IronPort-AV: E=Sophos;i="5.96,258,1665471600"; 
   d="scan'208";a="644326465"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by orsmga007.jf.intel.com with ESMTP; 19 Dec 2022 23:01:12 -0800
From:   Xin Li <xin3.li@intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, peterz@infradead.org,
        andrew.cooper3@citrix.com, seanjc@google.com, pbonzini@redhat.com,
        ravi.v.shankar@intel.com
Subject: [RFC PATCH 13/32] x86/fred: header file for event types
Date:   Mon, 19 Dec 2022 22:36:39 -0800
Message-Id: <20221220063658.19271-14-xin3.li@intel.com>
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

FRED inherits the Intel VT-x enhancement of classified events with
a two-level event dispatch logic. The first-level dispatch is on
the event type, not the event vector as used in the IDT architecture.
This also means that vectors in different event types are orthogonal,
e.g., vectors 0x10-0x1f become available as hardware interrupts.

Add a header file for event types, and also use it in <asm/vmx.h>.

Suggested-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
---
 arch/x86/include/asm/event-type.h | 17 +++++++++++++++++
 arch/x86/include/asm/vmx.h        | 17 +++++++++--------
 2 files changed, 26 insertions(+), 8 deletions(-)
 create mode 100644 arch/x86/include/asm/event-type.h

diff --git a/arch/x86/include/asm/event-type.h b/arch/x86/include/asm/event-type.h
new file mode 100644
index 000000000000..fedaa0e492c5
--- /dev/null
+++ b/arch/x86/include/asm/event-type.h
@@ -0,0 +1,17 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_X86_EVENT_TYPE_H
+#define _ASM_X86_EVENT_TYPE_H
+
+/*
+ * Event type codes: these are the same that are used by VTx.
+ */
+#define EVENT_TYPE_HWINT	0	/* Maskable external interrupt */
+#define EVENT_TYPE_RESERVED	1
+#define EVENT_TYPE_NMI		2	/* Non-maskable interrupt */
+#define EVENT_TYPE_HWFAULT	3	/* Hardware exceptions (e.g., page fault) */
+#define EVENT_TYPE_SWINT	4	/* Software interrupt (INT n) */
+#define EVENT_TYPE_PRIVSW	5	/* INT1 (ICEBP) */
+#define EVENT_TYPE_SWFAULT	6	/* Software exception (INT3 or INTO) */
+#define EVENT_TYPE_OTHER	7	/* FRED: SYSCALL/SYSENTER */
+
+#endif
diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 498dc600bd5c..8d9b8b0d8e56 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -15,6 +15,7 @@
 #include <linux/bitops.h>
 #include <linux/types.h>
 #include <uapi/asm/vmx.h>
+#include <asm/event-type.h>
 #include <asm/vmxfeatures.h>
 
 #define VMCS_CONTROL_BIT(x)	BIT(VMX_FEATURE_##x & 0x1f)
@@ -372,14 +373,14 @@ enum vmcs_field {
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

