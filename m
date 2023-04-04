Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEF866D5E27
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 12:53:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234775AbjDDKxu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 06:53:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234643AbjDDKxV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 06:53:21 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBCDB3C00;
        Tue,  4 Apr 2023 03:53:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680605582; x=1712141582;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Nl6wMwkpqmIYYyq7+MpcXBB5xF17anU3m57tPiay76c=;
  b=bwyuGNPLlWdBVcTyG3QFt99fPskgXjZwSI0LZVSOxtqHYrBzGiwtuHYx
   cW+j+7MUNnBW7mF+ttEwmoES4COs0YPPqgJXbDNXHKQfLNvKrpnc4756U
   8uz879EZNe+Df0Dlxw3ASd29j2K1cfRnOU5sxCRsQpiTAJf2LX95VHcr7
   Khj3OoXPSMmC42mYz8yvz6mZSdzrzZUiLevQEiFOHgIH4zX8h4pXK6s5+
   v72sMuxsdbcBc/dhgEY4e5qqSEWBeIHZFmBFT5QFD3apJq3ltuRk0uITy
   qo0U7xesh3tWhtytNFndSY9OypzKVO39hjL6CW4wRj/QC05zwisW0nIDR
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="330733935"
X-IronPort-AV: E=Sophos;i="5.98,317,1673942400"; 
   d="scan'208";a="330733935"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2023 03:53:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="775597782"
X-IronPort-AV: E=Sophos;i="5.98,317,1673942400"; 
   d="scan'208";a="775597782"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by FMSMGA003.fm.intel.com with ESMTP; 04 Apr 2023 03:52:59 -0700
From:   Xin Li <xin3.li@intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, peterz@infradead.org,
        andrew.cooper3@citrix.com, seanjc@google.com, pbonzini@redhat.com,
        ravi.v.shankar@intel.com, jiangshanlai@gmail.com,
        shan.kang@intel.com
Subject: [PATCH v7 02/33] x86/fred: make unions for the cs and ss fields in struct pt_regs
Date:   Tue,  4 Apr 2023 03:26:45 -0700
Message-Id: <20230404102716.1795-3-xin3.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230404102716.1795-1-xin3.li@intel.com>
References: <20230404102716.1795-1-xin3.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
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
 arch/x86/include/asm/ptrace.h         | 34 ++++++++++++++++++++++++---
 arch/x86/kernel/process_64.c          |  2 +-
 3 files changed, 33 insertions(+), 5 deletions(-)

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
index f4db78b09c8f..2abb23e6c1e2 100644
--- a/arch/x86/include/asm/ptrace.h
+++ b/arch/x86/include/asm/ptrace.h
@@ -82,12 +82,40 @@ struct pt_regs {
  * On hw interrupt, it's IRQ number:
  */
 	unsigned long orig_ax;
-/* Return frame for iretq */
+/* Return frame for iretq/eretu/erets */
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
 /* top of stack page */
 };
 
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index bb65a68b4b49..a1aa74864c8b 100644
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

