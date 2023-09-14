Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E3C479FA53
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 07:19:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235506AbjINFTy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 01:19:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235144AbjINFT3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 01:19:29 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C28591FDC;
        Wed, 13 Sep 2023 22:19:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694668762; x=1726204762;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=m7R91mzhAyMwuxf88uvtu3V1UGcA6vznqDxNdL57F/c=;
  b=dDcQJUjJrPEaEE6iYwnAL4W+3ZiDIqKPvQ80QJvHyunisaaptRhg7MCW
   XZRBi9uAnGvZEAFpZMRKwcA5hFVqhWOAx5rg3kgtqRhB+QVIo438n7O19
   pvieavFEU4bIepgwFDoWANfM9Eor1UeDIjfPBNk9WbEF6KexYkZyB5BRS
   Mtvvi0O7GCQZVrseJ7KHxo28SKLR1p92rce7YYwGvLzKaR82fTqI8L3/7
   fvGxFZPyUZa0+6f5OtOR/8o6zVo/7IMx0Esp3QPO/iZgpUbpMLq8vxanS
   vHcHVerWIyuQ2Ga8GwfullB3Tnb3DiC9iwjWynyeMt8eVC2yz1Ya2pgKD
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="382661356"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="382661356"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 22:17:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="779488805"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="779488805"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by orsmga001.jf.intel.com with ESMTP; 13 Sep 2023 22:17:40 -0700
From:   Xin Li <xin3.li@intel.com>
To:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-edac@vger.kernel.org, linux-hyperv@vger.kernel.org,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        luto@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        peterz@infradead.org, jgross@suse.com, ravi.v.shankar@intel.com,
        mhiramat@kernel.org, andrew.cooper3@citrix.com,
        jiangshanlai@gmail.com
Subject: [PATCH v10 22/38] x86/fred: Allow single-step trap and NMI when starting a new task
Date:   Wed, 13 Sep 2023 21:47:49 -0700
Message-Id: <20230914044805.301390-23-xin3.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230914044805.301390-1-xin3.li@intel.com>
References: <20230914044805.301390-1-xin3.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: "H. Peter Anvin (Intel)" <hpa@zytor.com>

Entering a new task is logically speaking a return from a system call
(exec, fork, clone, etc.). As such, if ptrace enables single stepping
a single step exception should be allowed to trigger immediately upon
entering user space. This is not optional.

NMI should *never* be disabled in user space. As such, this is an
optional, opportunistic way to catch errors.

Allow single-step trap and NMI when starting a new task, thus once
the new task enters user space, single-step trap and NMI are both
enabled immediately.

Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Tested-by: Shan Kang <shan.kang@intel.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
---

Changes since v8:
* Use high-order 48 bits above the lowest 16 bit SS only when FRED
  is enabled (Thomas Gleixner).
---
 arch/x86/kernel/process_64.c | 38 ++++++++++++++++++++++++++++++------
 1 file changed, 32 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 4f87f5987ae8..c075591b7b46 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -56,6 +56,7 @@
 #include <asm/resctrl.h>
 #include <asm/unistd.h>
 #include <asm/fsgsbase.h>
+#include <asm/fred.h>
 #ifdef CONFIG_IA32_EMULATION
 /* Not included via unistd.h */
 #include <asm/unistd_32_ia32.h>
@@ -528,7 +529,7 @@ void x86_gsbase_write_task(struct task_struct *task, unsigned long gsbase)
 static void
 start_thread_common(struct pt_regs *regs, unsigned long new_ip,
 		    unsigned long new_sp,
-		    unsigned int _cs, unsigned int _ss, unsigned int _ds)
+		    u16 _cs, u16 _ss, u16 _ds)
 {
 	WARN_ON_ONCE(regs != current_pt_regs());
 
@@ -545,11 +546,36 @@ start_thread_common(struct pt_regs *regs, unsigned long new_ip,
 	loadsegment(ds, _ds);
 	load_gs_index(0);
 
-	regs->ip		= new_ip;
-	regs->sp		= new_sp;
-	regs->cs		= _cs;
-	regs->ss		= _ss;
-	regs->flags		= X86_EFLAGS_IF;
+	regs->ip	= new_ip;
+	regs->sp	= new_sp;
+	regs->csx	= _cs;
+	regs->ssx	= _ss;
+	/*
+	 * Allow single-step trap and NMI when starting a new task, thus
+	 * once the new task enters user space, single-step trap and NMI
+	 * are both enabled immediately.
+	 *
+	 * Entering a new task is logically speaking a return from a
+	 * system call (exec, fork, clone, etc.). As such, if ptrace
+	 * enables single stepping a single step exception should be
+	 * allowed to trigger immediately upon entering user space.
+	 * This is not optional.
+	 *
+	 * NMI should *never* be disabled in user space. As such, this
+	 * is an optional, opportunistic way to catch errors.
+	 *
+	 * Paranoia: High-order 48 bits above the lowest 16 bit SS are
+	 * discarded by the legacy IRET instruction on all Intel, AMD,
+	 * and Cyrix/Centaur/VIA CPUs, thus can be set unconditionally,
+	 * even when FRED is not enabled. But we choose the safer side
+	 * to use these bits only when FRED is enabled.
+	 */
+	if (cpu_feature_enabled(X86_FEATURE_FRED)) {
+		regs->fred_ss.swevent	= true;
+		regs->fred_ss.nmi	= true;
+	}
+
+	regs->flags	= X86_EFLAGS_IF | X86_EFLAGS_FIXED;
 }
 
 void
-- 
2.34.1

