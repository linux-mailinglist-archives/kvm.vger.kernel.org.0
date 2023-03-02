Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA4C46A7AEB
	for <lists+kvm@lfdr.de>; Thu,  2 Mar 2023 06:51:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbjCBFvC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Mar 2023 00:51:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229799AbjCBFu4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Mar 2023 00:50:56 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 476194C6E1;
        Wed,  1 Mar 2023 21:50:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677736254; x=1709272254;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bMX4XCzIvBalTCdycaBebYL7w+KbpVnH8+oaUrz4fJQ=;
  b=bbo9k+K4SsranXdcP4Nwn0PsiTVv4AWuFiQwiUdeXS9vtWpK7OEYi9a3
   JbRJ8cx2l/hK6ENT9ccbQe+s2dtyIKqxl3jzua9iWpPNBNfaEUjsSbj0+
   +LP+f7aWJDFiZDxBPYBZYGJ37D+ngYlge2kIRx0icmWgPd0HDkeEuqSJw
   WrSw+Ruj6WyY8OwD9tFgGLzeMxMNeosM0gmCzOhfR9yy2MCPUTGWTrIFd
   1vvCYepC8JtUqa70oBo44jDRX5LKZmYo1nY/z/GIat6g1hvg55tN3oE8r
   FdPq8zld1p/tIBcBdRNXKUvEKYJYX1Nk5x4sVgURyruKsjSVRHohExczg
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10636"; a="420887114"
X-IronPort-AV: E=Sophos;i="5.98,226,1673942400"; 
   d="scan'208";a="420887114"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2023 21:50:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10636"; a="920530918"
X-IronPort-AV: E=Sophos;i="5.98,226,1673942400"; 
   d="scan'208";a="920530918"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by fmsmga006.fm.intel.com with ESMTP; 01 Mar 2023 21:50:48 -0800
From:   Xin Li <xin3.li@intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, peterz@infradead.org,
        andrew.cooper3@citrix.com, seanjc@google.com, pbonzini@redhat.com,
        ravi.v.shankar@intel.com
Subject: [PATCH v4 15/34] x86/fred: make unions for the cs and ss fields in struct pt_regs
Date:   Wed,  1 Mar 2023 21:24:52 -0800
Message-Id: <20230302052511.1918-16-xin3.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230302052511.1918-1-xin3.li@intel.com>
References: <20230302052511.1918-1-xin3.li@intel.com>
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

Make the cs and ss fields in struct pt_regs unions between the actual
selector and the unsigned long stack slot. FRED uses this space to
store additional flags.

The printk changes are simply due to the cs and ss fields changed to
unsigned short from unsigned long.

Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Tested-by: Shan Kang <shan.kang@intel.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
---

Changes since v3:
* Rename csl/ssl of the pt_regs structure to csx/ssx (x for extended)
  (Andrew Cooper).
---
 arch/x86/entry/vsyscall/vsyscall_64.c |  2 +-
 arch/x86/include/asm/ptrace.h         | 36 ++++++++++++++++++++++++---
 arch/x86/kernel/process_64.c          |  2 +-
 3 files changed, 34 insertions(+), 6 deletions(-)

diff --git a/arch/x86/entry/vsyscall/vsyscall_64.c b/arch/x86/entry/vsyscall/vsyscall_64.c
index d234ca797e4a..2429ad0df068 100644
--- a/arch/x86/entry/vsyscall/vsyscall_64.c
+++ b/arch/x86/entry/vsyscall/vsyscall_64.c
@@ -76,7 +76,7 @@ static void warn_bad_vsyscall(const char *level, struct pt_regs *regs,
 	if (!show_unhandled_signals)
 		return;
 
-	printk_ratelimited("%s%s[%d] %s ip:%lx cs:%lx sp:%lx ax:%lx si:%lx di:%lx\n",
+	printk_ratelimited("%s%s[%d] %s ip:%lx cs:%x sp:%lx ax:%lx si:%lx di:%lx\n",
 			   level, current->comm, task_pid_nr(current),
 			   message, regs->ip, regs->cs,
 			   regs->sp, regs->ax, regs->si, regs->di);
diff --git a/arch/x86/include/asm/ptrace.h b/arch/x86/include/asm/ptrace.h
index f4db78b09c8f..a61d860dc33c 100644
--- a/arch/x86/include/asm/ptrace.h
+++ b/arch/x86/include/asm/ptrace.h
@@ -82,13 +82,41 @@ struct pt_regs {
  * On hw interrupt, it's IRQ number:
  */
 	unsigned long orig_ax;
-/* Return frame for iretq */
+
+	/* Return frame for iretq/eretu/erets */
 	unsigned long ip;
-	unsigned long cs;
+	union {
+		unsigned long  csx;	/* cs extended: CS + any fields above it */
+		struct __attribute__((__packed__)) {
+			unsigned short cs;	/* CS selector proper */
+			unsigned int current_stack_level: 2;
+			unsigned int __csx_resv1	: 6;
+			unsigned int interrupt_shadowed	: 1;
+			unsigned int software_initiated	: 1;
+			unsigned int __csx_resv2	: 2;
+			unsigned int nmi		: 1;
+			unsigned int __csx_resv3	: 3;
+			unsigned int __csx_resv4	: 32;
+		};
+	};
 	unsigned long flags;
 	unsigned long sp;
-	unsigned long ss;
-/* top of stack page */
+	union {
+		unsigned long  ssx;	/* ss extended: SS + any fields above it */
+		struct __attribute__((__packed__)) {
+			unsigned short ss;	/* SS selector proper */
+			unsigned int __ssx_resv1	: 16;
+			unsigned int vector		: 8;
+			unsigned int __ssx_resv2	: 8;
+			unsigned int type		: 4;
+			unsigned int __ssx_resv3	: 4;
+			unsigned int enclv		: 1;
+			unsigned int long_mode		: 1;
+			unsigned int nested		: 1;
+			unsigned int __ssx_resv4	: 1;
+			unsigned int instr_len		: 4;
+		};
+	};
 };
 
 #endif /* !__i386__ */
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 4e34b3b68ebd..57de166dc61c 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -116,7 +116,7 @@ void __show_regs(struct pt_regs *regs, enum show_regs_mode mode,
 
 	printk("%sFS:  %016lx(%04x) GS:%016lx(%04x) knlGS:%016lx\n",
 	       log_lvl, fs, fsindex, gs, gsindex, shadowgs);
-	printk("%sCS:  %04lx DS: %04x ES: %04x CR0: %016lx\n",
+	printk("%sCS:  %04x DS: %04x ES: %04x CR0: %016lx\n",
 		log_lvl, regs->cs, ds, es, cr0);
 	printk("%sCR2: %016lx CR3: %016lx CR4: %016lx\n",
 		log_lvl, cr2, cr3, cr4);
-- 
2.34.1

