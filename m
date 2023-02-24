Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30E556A172F
	for <lists+kvm@lfdr.de>; Fri, 24 Feb 2023 08:28:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229961AbjBXH2b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Feb 2023 02:28:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229846AbjBXH2Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Feb 2023 02:28:16 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5653B3B0ED;
        Thu, 23 Feb 2023 23:28:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677223683; x=1708759683;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pK1C/4R/Ql5OExvB2mamuI7H7wuXRltv3yNxaC0U3E0=;
  b=HV0h3HnNVAxy1wTr0vzeRl1lAfBJfMvAC2svkWn3vGaCo+403FpqEonJ
   TepuTxBIX9TtYuyEft7L93TtTQX1FQU56KFAzK4XlHuuKsakcXaGwpTkt
   rwMPP4BpW4sLud7uWWd+kwdZh9sbp8ONLt7TB0LE4KcamZV6j6Fy0mVMG
   4v0IlCtoHhvMCk4a8jwZvx7S1VobtFS4IZe8NmaX7jrE9SCQDenoemwFU
   PrL4vVggcRI/9F0lgua4Fs4I79LG0BNzpjbhiuaVj0vdw8z8eZD/P/G6S
   GW4H6aRrvfM8InU+1lTa+NSA5MDWXGTkAbu7GrDTEvTHa7H4vUqTHO3QV
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10630"; a="334836042"
X-IronPort-AV: E=Sophos;i="5.97,324,1669104000"; 
   d="scan'208";a="334836042"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2023 23:27:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10630"; a="815639232"
X-IronPort-AV: E=Sophos;i="5.97,324,1669104000"; 
   d="scan'208";a="815639232"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by fmsmga001.fm.intel.com with ESMTP; 23 Feb 2023 23:27:22 -0800
From:   Xin Li <xin3.li@intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, peterz@infradead.org,
        andrew.cooper3@citrix.com, seanjc@google.com, pbonzini@redhat.com,
        ravi.v.shankar@intel.com
Subject: [RFC PATCH v3 15/32] x86/fred: make unions for the cs and ss fields in struct pt_regs
Date:   Thu, 23 Feb 2023 23:01:28 -0800
Message-Id: <20230224070145.3572-16-xin3.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230224070145.3572-1-xin3.li@intel.com>
References: <20230224070145.3572-1-xin3.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
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
Signed-off-by: Xin Li <xin3.li@intel.com>
---
 arch/x86/entry/vsyscall/vsyscall_64.c |  2 +-
 arch/x86/include/asm/ptrace.h         | 36 ++++++++++++++++++++++++---
 arch/x86/kernel/process_64.c          |  2 +-
 3 files changed, 34 insertions(+), 6 deletions(-)

diff --git a/arch/x86/entry/vsyscall/vsyscall_64.c b/arch/x86/entry/vsyscall/vsyscall_64.c
index 4af81df133ee..6349c818d20a 100644
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
index f4db78b09c8f..341e44847cc1 100644
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
+		unsigned long  csl; /* CS + any fields above it */
+		struct __attribute__((__packed__)) {
+			unsigned short cs;  /* CS selector proper */
+			unsigned int current_stack_level: 2;
+			unsigned int __csl_resv1	: 6;
+			unsigned int interrupt_shadowed	: 1;
+			unsigned int software_initiated	: 1;
+			unsigned int __csl_resv2	: 2;
+			unsigned int nmi		: 1;
+			unsigned int __csl_resv3	: 3;
+			unsigned int __csl_resv4	: 32;
+		};
+	};
 	unsigned long flags;
 	unsigned long sp;
-	unsigned long ss;
-/* top of stack page */
+	union {
+		unsigned long  ssl; /* SS + any fields above it */
+		struct __attribute__((__packed__)) {
+			unsigned short ss;  /* SS selector proper */
+			unsigned int __ssl_resv1: 16;
+			unsigned int vector	: 8;
+			unsigned int __ssl_resv2: 8;
+			unsigned int type	: 4;
+			unsigned int __ssl_resv3: 4;
+			unsigned int enclv	: 1;
+			unsigned int long_mode	: 1;
+			unsigned int nested	: 1;
+			unsigned int __ssl_resv4: 1;
+			unsigned int instr_len	: 4;
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

