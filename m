Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5F9465FDAE
	for <lists+kvm@lfdr.de>; Fri,  6 Jan 2023 10:22:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232411AbjAFJWA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Jan 2023 04:22:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233135AbjAFJU1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Jan 2023 04:20:27 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 646006B5DD;
        Fri,  6 Jan 2023 01:20:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672996826; x=1704532826;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0gMSYFAIPULPy0xB+8ol1EvYvfgiXDpvvSOWr5aDujM=;
  b=hJ/GElowOypCvloXZldCmF7Yjeaiedfi0EbjVXKsZnvKI1vHiOKF53wG
   E+Ge+awFm+7oM+UZyvasp5yQHuI7g+WGwrnogie4obt6dWv0PsbfjjYds
   iFHgMm13tH2HPG2vh8w3XtzKTuR3oFeUqV9H+82xT4pJvZCM4nXXfznmJ
   tbvou/zLBWWeRor0CvoXLYUHuo6AdA9VV9xUyPd9nyMCHAWkkMqM8621L
   KIFt2inIZlPIbco2zzzkeKChQoMf+0AZ/I0NcuCx465QsVwXug9tELYGo
   Bw1NfcM+H43h1UM2sTrZCGdCHEbRCduxToT+C3M81sOHLLZ3DmFK72ykz
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10581"; a="322511621"
X-IronPort-AV: E=Sophos;i="5.96,304,1665471600"; 
   d="scan'208";a="322511621"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2023 01:20:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10581"; a="719139450"
X-IronPort-AV: E=Sophos;i="5.96,304,1665471600"; 
   d="scan'208";a="719139450"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by fmsmga008.fm.intel.com with ESMTP; 06 Jan 2023 01:20:17 -0800
From:   Xin Li <xin3.li@intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, peterz@infradead.org,
        andrew.cooper3@citrix.com, seanjc@google.com, pbonzini@redhat.com,
        ravi.v.shankar@intel.com
Subject: [RFC PATCH v2 27/32] x86/fred: allow single-step trap and NMI when starting a new thread
Date:   Fri,  6 Jan 2023 00:56:12 -0800
Message-Id: <20230106085617.17248-28-xin3.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230106085617.17248-1-xin3.li@intel.com>
References: <20230106085617.17248-1-xin3.li@intel.com>
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

From: "H. Peter Anvin (Intel)" <hpa@zytor.com>

Allow single-step trap and NMI when starting a new thread, thus once
the new thread returns to ring3, single-step trap and NMI are both
enabled immediately.

High-order 48 bits above the lowest 16 bit CS are discarded by the
legacy IRET instruction, thus can be set unconditionally, even when
FRED is not enabled.

Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
---
 arch/x86/include/asm/fred.h  | 11 +++++++++++
 arch/x86/kernel/process_64.c | 13 +++++++------
 2 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/fred.h b/arch/x86/include/asm/fred.h
index 6a417fc1e7ee..958751f16c94 100644
--- a/arch/x86/include/asm/fred.h
+++ b/arch/x86/include/asm/fred.h
@@ -52,6 +52,14 @@
 #define FRED_CSL_ALLOW_SINGLE_STEP	_BITUL(25)
 #define FRED_CSL_INTERRUPT_SHADOW	_BITUL(24)
 
+/*
+ * High-order 48 bits above the lowest 16 bit CS are discarded by the
+ * legacy IRET instruction, thus can be set unconditionally, even when
+ * FRED is not enabled.
+ */
+#define CSL_PROCESS_START \
+	(FRED_CSL_ENABLE_NMI | FRED_CSL_ALLOW_SINGLE_STEP)
+
 #ifndef __ASSEMBLY__
 
 #include <linux/kernel.h>
@@ -115,6 +123,9 @@ void fred_setup_apic(void);
 #else
 #define cpu_init_fred_exceptions() BUG()
 #define fred_setup_apic() BUG()
+
+#define CSL_PROCESS_START 0
+
 #endif /* CONFIG_X86_FRED */
 
 #endif /* ASM_X86_FRED_H */
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 5b6cfd2ca630..128dafc04acf 100644
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
+	regs->ip    = new_ip;
+	regs->sp    = new_sp;
+	regs->csl   = _cs | CSL_PROCESS_START;
+	regs->ssl   = _ss;
+	regs->flags = X86_EFLAGS_IF | X86_EFLAGS_FIXED;
 }
 
 void
-- 
2.34.1

