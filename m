Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B87F37B619D
	for <lists+kvm@lfdr.de>; Tue,  3 Oct 2023 08:56:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239288AbjJCG4L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Oct 2023 02:56:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230243AbjJCGzu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Oct 2023 02:55:50 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 927A9CF7;
        Mon,  2 Oct 2023 23:55:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696316102; x=1727852102;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=m7R91mzhAyMwuxf88uvtu3V1UGcA6vznqDxNdL57F/c=;
  b=FdtT006N+CmTdugo9f0Ur8OnsM+Li+bpTa1btmxsFOOOb9e+DtqgSUAk
   o/jYpD04P10pQ7Ay1GFpw5urcqpoqG7YLTgXGMBwuweRwOiKzEyNoH72Q
   u5zjDsghgI6O8JXnLa1kC6YTW6pxLyTJGx0Vs46SK+J/FOKijSR82nUok
   WX4+4OwNcG7Il/1fBGz3mcmLec7zBXyWHjte3C5rLgZM2mBWxdre+/vHv
   eGXBicCXBH1YFKZp9bZk5hGn/OCfaVUOp/Pm3i4uMEBhnFqo+8dJSYzKo
   rtDUFmd7tGENHcohGYAbaEbDj12pZvmycmEA4vlAngVY2jSURvYoFwgPa
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10851"; a="367858169"
X-IronPort-AV: E=Sophos;i="6.03,196,1694761200"; 
   d="scan'208";a="367858169"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2023 23:54:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10851"; a="1081900966"
X-IronPort-AV: E=Sophos;i="6.03,196,1694761200"; 
   d="scan'208";a="1081900966"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by fmsmga005.fm.intel.com with ESMTP; 02 Oct 2023 23:54:45 -0700
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
Subject: [PATCH v12 22/37] x86/fred: Allow single-step trap and NMI when starting a new task
Date:   Mon,  2 Oct 2023 23:24:43 -0700
Message-Id: <20231003062458.23552-23-xin3.li@intel.com>
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

