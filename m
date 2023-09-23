Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84ACD7AC012
	for <lists+kvm@lfdr.de>; Sat, 23 Sep 2023 12:17:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231384AbjIWKMR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 23 Sep 2023 06:12:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231393AbjIWKLw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 23 Sep 2023 06:11:52 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 119511A8;
        Sat, 23 Sep 2023 03:11:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695463905; x=1726999905;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/vulkjS/nAxN+RJ3C7R6J4h15cqNiAED/GUC9x16vUQ=;
  b=QOYoVbkxcmt/7LwWVahKIIt/Sz4sD0tXHIC3jexpGOx4UiGMHFKD+QIt
   /qFCKQ5AOgBSWiS0ODeiKZ/lsahrW+Ktz+WW9tdduvzyDpo/HbWw59Tj5
   JfxsmnYAjlW2OgLlgoQkvc0wUrKunrp1ZSlzb0O+okR+71sJ6V85v/DwW
   Q7TnCL25UA5OpLPKopfEMTJsgDllIX4SQZknGdTlNTwAqoUedpApNmN/d
   I5HXbziikfegppcUIZ8Jo/rZiHptCTbrVsj3towi1G8W6PCMeFTdApUMM
   C+wWRKmZqta/7b4tOeUYFarOI798RCfGbup8/y5TkYx5RTUdSlN76z5sz
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10841"; a="447492265"
X-IronPort-AV: E=Sophos;i="6.03,171,1694761200"; 
   d="scan'208";a="447492265"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2023 03:11:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10841"; a="813388154"
X-IronPort-AV: E=Sophos;i="6.03,171,1694761200"; 
   d="scan'208";a="813388154"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by fmsmga008.fm.intel.com with ESMTP; 23 Sep 2023 03:11:43 -0700
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
Subject: [PATCH v11 16/37] x86/ptrace: Add FRED additional information to the pt_regs structure
Date:   Sat, 23 Sep 2023 02:41:51 -0700
Message-Id: <20230923094212.26520-17-xin3.li@intel.com>
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
 arch/x86/include/asm/ptrace.h | 51 +++++++++++++++++++++++++++++++----
 1 file changed, 46 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/ptrace.h b/arch/x86/include/asm/ptrace.h
index f08ea073edd6..5786c8ca5f4c 100644
--- a/arch/x86/include/asm/ptrace.h
+++ b/arch/x86/include/asm/ptrace.h
@@ -56,6 +56,25 @@ struct pt_regs {
 
 #else /* __i386__ */
 
+struct fred_ss {
+	u64	ss	: 16,	// SS selector
+		sti	:  1,	// STI state
+		swevent	:  1,	// Set if syscall, sysenter or INT n
+		nmi	:  1,	// Event is NMI type
+			: 13,
+		vector	:  8,	// Event vector
+			:  8,
+		type	:  4,	// Event type
+			:  4,
+		enclave	:  1,	// Event was incident to enclave execution
+		lm	:  1,	// CPU was in long mode
+		nested	:  1,	// Nested exception during FRED delivery
+				// not set for #DF
+			:  1,
+		insnlen	:  4;	// The length of the instruction causing the event
+				// Only set for INT0, INT1, INT3, INT n, SYSCALL
+};				// and SYSENTER. 0 otherwise.
+
 struct pt_regs {
 	/*
 	 * C ABI says these regs are callee-preserved. They aren't saved on
@@ -85,6 +104,12 @@ struct pt_regs {
 	 * - the syscall number (syscall, sysenter, int80)
 	 * - error_code stored by the CPU on traps and exceptions
 	 * - the interrupt number for device interrupts
+	 *
+	 * A FRED stack frame starts here:
+	 *   1) It _always_ includes an error code;
+	 *
+	 *   2) The return frame for ERET[US] starts here, but
+	 *	the content of orig_ax is ignored.
 	 */
 	unsigned long orig_ax;
 
@@ -92,20 +117,36 @@ struct pt_regs {
 	unsigned long ip;
 
 	union {
-		u64	csx;	// The full 64-bit data slot containing CS
-		u16	cs;	// CS selector
+		u64	csx;		// The full data for FRED
+		/*
+		 * The 'cs' member should be defined as a 16-bit bit-field
+		 * along with the 'sl' and 'wfe' members, which however
+		 * breaks compiling REG_OFFSET_NAME(cs), because compilers
+		 * disallow calculating the address of a bit-field.
+		 *
+		 * Therefore 'cs" is defined as an individual member with
+		 * type u16.
+		 */
+		u16	cs;		// CS selector
+		u64		: 16,
+			sl	:  2,	// Stack level at event time
+			wfe	:  1,	// IBT is in WAIT_FOR_BRANCH_STATE
+				: 45;
 	};
 
 	unsigned long flags;
 	unsigned long sp;
 
 	union {
-		u64	ssx;	// The full 64-bit data slot containing SS
-		u16	ss;	// SS selector
+		u64		ssx;		// The full data for FRED
+		u16		ss;		// SS selector
+		struct fred_ss	fred_ss;	// The fred extension
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

