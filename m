Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95E67651B37
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 08:03:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233583AbiLTHDC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 02:03:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233298AbiLTHBo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 02:01:44 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DAAA15F1B;
        Mon, 19 Dec 2022 23:01:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671519701; x=1703055701;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=w5B5k+hmkxOaK+wejq61l/Q17ercfMb2xEXn5kh7ENU=;
  b=n5nY4xcVJ7PQZzrLyCeEiXggq9YuQ60yQZO60xDcad0vNkFKtrnqK6bn
   kUSlh+R03k6lePnwWHZhEeRWhDBT26oWM9crsdYRkY/a5+ZY1OF8R6FQ+
   RAzlB/RHfgmGGdSSm34u+npxooK070+IvmOj5RrVFZHeuxnIHNZmrWZkm
   d6yLevDCuuTv/h3u0VSCbKZjHnjMkd/qhi4mLkt1CbLKcUxKogqB2jnyW
   +615M1oyiB79LQ7+zU47xdjVjTV0G1C7V1ubE9mU2kgTaedzXm8BJyDdq
   smXYYTRoowhJ8BX/hwTzTaVRs6jCXfpiwGf12igo0buNpMSREpsO75egu
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10566"; a="302972146"
X-IronPort-AV: E=Sophos;i="5.96,258,1665471600"; 
   d="scan'208";a="302972146"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2022 23:01:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10566"; a="644326542"
X-IronPort-AV: E=Sophos;i="5.96,258,1665471600"; 
   d="scan'208";a="644326542"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by orsmga007.jf.intel.com with ESMTP; 19 Dec 2022 23:01:18 -0800
From:   Xin Li <xin3.li@intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, peterz@infradead.org,
        andrew.cooper3@citrix.com, seanjc@google.com, pbonzini@redhat.com,
        ravi.v.shankar@intel.com
Subject: [RFC PATCH 27/32] x86/fred: allow single-step trap and NMI when starting a new thread
Date:   Mon, 19 Dec 2022 22:36:53 -0800
Message-Id: <20221220063658.19271-28-xin3.li@intel.com>
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
index b6308e351e14..730e69d2bb87 100644
--- a/arch/x86/include/asm/fred.h
+++ b/arch/x86/include/asm/fred.h
@@ -50,6 +50,14 @@
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
@@ -113,6 +121,9 @@ void fred_setup_apic(void);
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

