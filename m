Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F123651B2C
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 08:02:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233506AbiLTHCl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 02:02:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233240AbiLTHBi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 02:01:38 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 073B215A19;
        Mon, 19 Dec 2022 23:01:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671519697; x=1703055697;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=umQlTxKGNKLlev+BqP1ZCZCF7yuytMs0GSGunAXbGS4=;
  b=QnK6o9uitIBKnBttTN7XFM2Q15edqEEB49EJTmwB88fLoaGEZPzOqxbO
   EU+dd/AGTnmeSBPbyDmyrWqsH5v9yYBTsW1pOc0ccbIYt46GUKA1MpwTy
   qLkBx6akv2w/IJZvH1p5Dh0cPRXTYQQ9+gRtAbysJRw99ERBRb34R9NiX
   V2A/palY2o5GcoPhEfU7+Jo1XEiBxTAZ7sKuTJ0HIow/2nO1AXX19C3Rz
   oMPG9egcqdPaLA/+1k9//kmt5Etw+/y+xkCPqm7V031X5W0Khe0BDA2SH
   N0lfwgRcdLYhcDiaoEwOAckp8wEhUAzrjhfuh5hA1crUggobIs21Hol0X
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10566"; a="302972051"
X-IronPort-AV: E=Sophos;i="5.96,258,1665471600"; 
   d="scan'208";a="302972051"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2022 23:01:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10566"; a="644326487"
X-IronPort-AV: E=Sophos;i="5.96,258,1665471600"; 
   d="scan'208";a="644326487"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by orsmga007.jf.intel.com with ESMTP; 19 Dec 2022 23:01:14 -0800
From:   Xin Li <xin3.li@intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, peterz@infradead.org,
        andrew.cooper3@citrix.com, seanjc@google.com, pbonzini@redhat.com,
        ravi.v.shankar@intel.com
Subject: [RFC PATCH 17/32] x86/fred: add a page fault entry stub for FRED
Date:   Mon, 19 Dec 2022 22:36:43 -0800
Message-Id: <20221220063658.19271-18-xin3.li@intel.com>
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

Add a page fault entry stub for FRED.

On a FRED system, the faulting address (CR2) is passed on the stack,
to avoid the problem of transient state. Thus we get the page fault
address from the stack instead of CR2.

Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
---
 arch/x86/include/asm/fred.h |  2 ++
 arch/x86/mm/fault.c         | 20 ++++++++++++++++++--
 2 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/fred.h b/arch/x86/include/asm/fred.h
index 6292b28d461d..38a90eae7c0f 100644
--- a/arch/x86/include/asm/fred.h
+++ b/arch/x86/include/asm/fred.h
@@ -92,6 +92,8 @@ static __always_inline unsigned long fred_event_data(struct pt_regs *regs)
 #define DEFINE_FRED_HANDLER(f) noinstr DECLARE_FRED_HANDLER(f)
 typedef DECLARE_FRED_HANDLER((*fred_handler));
 
+DECLARE_FRED_HANDLER(fred_exc_page_fault);
+
 #endif /* __ASSEMBLY__ */
 
 #endif /* CONFIG_X86_FRED */
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 7b0d4ab894c8..f31053f32048 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -33,6 +33,7 @@
 #include <asm/kvm_para.h>		/* kvm_handle_async_pf		*/
 #include <asm/vdso.h>			/* fixup_vdso_exception()	*/
 #include <asm/irq_stack.h>
+#include <asm/fred.h>			/* fred_event_data()	*/
 
 #define CREATE_TRACE_POINTS
 #include <asm/trace/exceptions.h>
@@ -1528,9 +1529,10 @@ handle_page_fault(struct pt_regs *regs, unsigned long error_code,
 	}
 }
 
-DEFINE_IDTENTRY_RAW_ERRORCODE(exc_page_fault)
+static __always_inline void page_fault_common(struct pt_regs *regs,
+					      unsigned int error_code,
+					      unsigned long address)
 {
-	unsigned long address = read_cr2();
 	irqentry_state_t state;
 
 	prefetchw(&current->mm->mmap_lock);
@@ -1577,3 +1579,17 @@ DEFINE_IDTENTRY_RAW_ERRORCODE(exc_page_fault)
 
 	irqentry_exit(regs, state);
 }
+
+DEFINE_IDTENTRY_RAW_ERRORCODE(exc_page_fault)
+{
+	page_fault_common(regs, error_code, read_cr2());
+}
+
+#ifdef CONFIG_X86_FRED
+
+DEFINE_FRED_HANDLER(fred_exc_page_fault)
+{
+	page_fault_common(regs, regs->orig_ax, fred_event_data(regs));
+}
+
+#endif /* CONFIG_X86_FRED */
-- 
2.34.1

