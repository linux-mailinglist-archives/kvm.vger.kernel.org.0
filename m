Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB2266DC487
	for <lists+kvm@lfdr.de>; Mon, 10 Apr 2023 10:42:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbjDJImI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Apr 2023 04:42:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229849AbjDJIlq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Apr 2023 04:41:46 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2893C4EDF;
        Mon, 10 Apr 2023 01:41:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681116072; x=1712652072;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kdsDSL0FM4cOW58nPFQAA0OCrgImaKiH8KbKpW/8YIw=;
  b=gxJjjazOaw3J9dLuyYd1JSYpFwJY74yDhPZFwTWkVBIikARDrUYDNxMK
   d20iCrkCixrnWfQxxuOfk3asGW+hkJcOxtay/cwkyNTxBm2eTPYrFckJg
   X/YVOwHMikwkuGmWaFXfzLcQhgZqyw1Bv4D7ZZ7W+ZIDQqUn2qU1euXig
   jRNki5oMvOuCBi86XPXOW7NGhNI0qk6JdFZg+zC95brQdEmt2wiiehmqN
   GH7QDu7/uBbEe00G4HP6iyopJWfQpDpE+L18gKXbTmMa+PaHlKUeXq6m7
   57V85GMDLXaWPt1GOIqtEMPFlMQGixFbLKxZvTdwCgBgYRrf2xTVSuA47
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10675"; a="342078151"
X-IronPort-AV: E=Sophos;i="5.98,333,1673942400"; 
   d="scan'208";a="342078151"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2023 01:41:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10675"; a="799436346"
X-IronPort-AV: E=Sophos;i="5.98,333,1673942400"; 
   d="scan'208";a="799436346"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by fmsmga002.fm.intel.com with ESMTP; 10 Apr 2023 01:41:07 -0700
From:   Xin Li <xin3.li@intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, peterz@infradead.org,
        andrew.cooper3@citrix.com, seanjc@google.com, pbonzini@redhat.com,
        ravi.v.shankar@intel.com, jiangshanlai@gmail.com,
        shan.kang@intel.com
Subject: [PATCH v8 26/33] x86/fred: allow single-step trap and NMI when starting a new thread
Date:   Mon, 10 Apr 2023 01:14:31 -0700
Message-Id: <20230410081438.1750-27-xin3.li@intel.com>
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

From: "H. Peter Anvin (Intel)" <hpa@zytor.com>

Allow single-step trap and NMI when starting a new thread, thus once
the new thread returns to ring3, single-step trap and NMI are both
enabled immediately.

High-order 48 bits above the lowest 16 bit CS are discarded by the
legacy IRET instruction, thus can be set unconditionally, even when
FRED is not enabled.

Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Tested-by: Shan Kang <shan.kang@intel.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
---
 arch/x86/include/asm/fred.h  | 11 +++++++++++
 arch/x86/kernel/process_64.c | 13 +++++++------
 2 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/fred.h b/arch/x86/include/asm/fred.h
index c5fbc4f18059..f7caf3b2f3f7 100644
--- a/arch/x86/include/asm/fred.h
+++ b/arch/x86/include/asm/fred.h
@@ -70,6 +70,14 @@
  */
 #define FRED_DF_STACK_LEVEL		3
 
+/*
+ * High-order 48 bits above the lowest 16 bit CS are discarded by the
+ * legacy IRET instruction, thus can be set unconditionally, even when
+ * FRED is not enabled.
+ */
+#define CSX_PROCESS_START \
+	(FRED_CSX_ENABLE_NMI | FRED_CSX_ALLOW_SINGLE_STEP)
+
 #ifndef __ASSEMBLY__
 
 #include <linux/kernel.h>
@@ -133,6 +141,9 @@ void fred_setup_apic(void);
 #else
 #define cpu_init_fred_exceptions() BUG()
 #define fred_setup_apic() BUG()
+
+#define CSX_PROCESS_START 0
+
 #endif /* CONFIG_X86_FRED */
 
 #endif /* ASM_X86_FRED_H */
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 2bea86073646..c732d9dbff3a 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -55,6 +55,7 @@
 #include <asm/resctrl.h>
 #include <asm/unistd.h>
 #include <asm/fsgsbase.h>
+#include <asm/fred.h>
 #ifdef CONFIG_IA32_EMULATION
 /* Not included via unistd.h */
 #include <asm/unistd_32_ia32.h>
@@ -506,7 +507,7 @@ void x86_gsbase_write_task(struct task_struct *task, unsigned long gsbase)
 static void
 start_thread_common(struct pt_regs *regs, unsigned long new_ip,
 		    unsigned long new_sp,
-		    unsigned int _cs, unsigned int _ss, unsigned int _ds)
+		    u16 _cs, u16 _ss, u16 _ds)
 {
 	WARN_ON_ONCE(regs != current_pt_regs());
 
@@ -521,11 +522,11 @@ start_thread_common(struct pt_regs *regs, unsigned long new_ip,
 	loadsegment(ds, _ds);
 	load_gs_index(0);
 
-	regs->ip		= new_ip;
-	regs->sp		= new_sp;
-	regs->cs		= _cs;
-	regs->ss		= _ss;
-	regs->flags		= X86_EFLAGS_IF;
+	regs->ip	= new_ip;
+	regs->sp	= new_sp;
+	regs->csx	= _cs | CSX_PROCESS_START;
+	regs->ssx	= _ss;
+	regs->flags	= X86_EFLAGS_IF | X86_EFLAGS_FIXED;
 }
 
 void
-- 
2.34.1

