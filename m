Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7C047B6150
	for <lists+kvm@lfdr.de>; Tue,  3 Oct 2023 08:55:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239260AbjJCGzG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Oct 2023 02:55:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239183AbjJCGyx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Oct 2023 02:54:53 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA6E6107;
        Mon,  2 Oct 2023 23:54:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696316086; x=1727852086;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=V+OPmxsacyHhQwU2DRsayMn8eLFfcoR2lqYdblOZ50U=;
  b=kGii2U8rVWjB4mjtPAI+wr5f9N90M6Evml4WUwY4m/tVrW1fDZ8duQmL
   FRwATYYzX7YSCTGk6uFhsldgvuJE/9P+9Ib5xjxndykaQT6BMQ1Tjd1Xp
   ppnqq657h2DERj4rtBqIxWFD4F4sM0N/OC7e9lnrgMSMbKMNuaK227gS5
   C8lIaJg2D6pbwzvwkx520GPnsY6CWtgZOMAo4eqXYB3TieRTJ6LKTBaKV
   f49Jz/1DpUdPpX9eqh34G1nqwjlvstiXrqz8ZLhFPaVRiw3vVTm6TWZY/
   IuQawgWR1GTSeiaJBwrvDUdAhTaE1QEz0+aWCjCUahRjyecSGR/kphMct
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10851"; a="367858087"
X-IronPort-AV: E=Sophos;i="6.03,196,1694761200"; 
   d="scan'208";a="367858087"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2023 23:54:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10851"; a="1081900943"
X-IronPort-AV: E=Sophos;i="6.03,196,1694761200"; 
   d="scan'208";a="1081900943"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by fmsmga005.fm.intel.com with ESMTP; 02 Oct 2023 23:54:42 -0700
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
Subject: [PATCH v12 16/37] x86/ptrace: Add FRED additional information to the pt_regs structure
Date:   Mon,  2 Oct 2023 23:24:37 -0700
Message-Id: <20231003062458.23552-17-xin3.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231003062458.23552-1-xin3.li@intel.com>
References: <20231003062458.23552-1-xin3.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

FRED defines additional information in the upper 48 bits of cs/ss
fields. Therefore add the information definitions into the pt_regs
structure.

Specially introduce a new structure fred_ss to denote the FRED flags
above SS selector, which avoids FRED_SSX_ macros and makes the code
simpler and easier to read.

Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Tested-by: Shan Kang <shan.kang@intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Xin Li <xin3.li@intel.com>
---

Changes since v11:
* Add a new structure fred_cs to denote the FRED flags above CS
  selector as what is done for SS (H. Peter Anvin).

Changes since v9:
* Introduce a new structure fred_ss to denote the FRED flags above SS
  selector, which avoids FRED_SSX_ macros and makes the code simpler
  and easier to read (Thomas Gleixner).
* Use type u64 to define FRED bit fields instead of type unsigned int
  (Thomas Gleixner).

Changes since v8:
* Reflect stack frame definition changes from FRED spec 3.0 to 5.0.
* Use __packed instead of __attribute__((__packed__)) (Borislav Petkov).
* Put all comments above the members, like the rest of the file does
  (Borislav Petkov).

Changes since v3:
* Rename csl/ssl of the pt_regs structure to csx/ssx (x for extended)
  (Andrew Cooper).
---
 arch/x86/include/asm/ptrace.h | 70 ++++++++++++++++++++++++++++++++---
 1 file changed, 65 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/ptrace.h b/arch/x86/include/asm/ptrace.h
index f08ea073edd6..5a83fbd9bc0b 100644
--- a/arch/x86/include/asm/ptrace.h
+++ b/arch/x86/include/asm/ptrace.h
@@ -56,6 +56,50 @@ struct pt_regs {
 
 #else /* __i386__ */
 
+struct fred_cs {
+		/* CS selector */
+	u64	cs	: 16,
+		/* Stack level at event time */
+		sl	:  2,
+		/* IBT in WAIT_FOR_ENDBRANCH state */
+		wfe	:  1,
+			: 45;
+};
+
+struct fred_ss {
+		/* SS selector */
+	u64	ss	: 16,
+		/* STI state */
+		sti	:  1,
+		/* Set if syscall, sysenter or INT n */
+		swevent	:  1,
+		/* Event is NMI type */
+		nmi	:  1,
+			: 13,
+		/* Event vector */
+		vector	:  8,
+			:  8,
+		/* Event type */
+		type	:  4,
+			:  4,
+		/* Event was incident to enclave execution */
+		enclave	:  1,
+		/* CPU was in long mode */
+		lm	:  1,
+		/*
+		 * Nested exception during FRED delivery, not set
+		 * for #DF.
+		 */
+		nested	:  1,
+			:  1,
+		/*
+		 * The length of the instruction causing the event.
+		 * Only set for INTO, INT1, INT3, INT n, SYSCALL
+		 * and SYSENTER.  0 otherwise.
+		 */
+		insnlen	:  4;
+};
+
 struct pt_regs {
 	/*
 	 * C ABI says these regs are callee-preserved. They aren't saved on
@@ -85,6 +129,12 @@ struct pt_regs {
 	 * - the syscall number (syscall, sysenter, int80)
 	 * - error_code stored by the CPU on traps and exceptions
 	 * - the interrupt number for device interrupts
+	 *
+	 * A FRED stack frame starts here:
+	 *   1) It _always_ includes an error code;
+	 *
+	 *   2) The return frame for ERET[US] starts here, but
+	 *      the content of orig_ax is ignored.
 	 */
 	unsigned long orig_ax;
 
@@ -92,20 +142,30 @@ struct pt_regs {
 	unsigned long ip;
 
 	union {
-		u64	csx;	// The full 64-bit data slot containing CS
-		u16	cs;	// CS selector
+		/* CS selector */
+		u16		cs;
+		/* The extended 64-bit data slot containing CS */
+		u64		csx;
+		/* The FRED CS extension */
+		struct fred_cs	fred_cs;
 	};
 
 	unsigned long flags;
 	unsigned long sp;
 
 	union {
-		u64	ssx;	// The full 64-bit data slot containing SS
-		u16	ss;	// SS selector
+		/* SS selector */
+		u16		ss;
+		/* The extended 64-bit data slot containing SS */
+		u64		ssx;
+		/* The FRED SS extension */
+		struct fred_ss	fred_ss;
 	};
 
 	/*
-	 * Top of stack on IDT systems.
+	 * Top of stack on IDT systems, while FRED systems have extra fields
+	 * defined above for storing exception related information, e.g. CR2 or
+	 * DR6.
 	 */
 };
 
-- 
2.34.1

