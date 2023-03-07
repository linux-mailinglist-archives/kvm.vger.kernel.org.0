Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69DF26AD578
	for <lists+kvm@lfdr.de>; Tue,  7 Mar 2023 04:09:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230375AbjCGDGN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Mar 2023 22:06:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230288AbjCGDFi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Mar 2023 22:05:38 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB54480E11;
        Mon,  6 Mar 2023 19:05:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678158328; x=1709694328;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zbDdVunyGdhXyhjUE3Gbpn/xbHM27xiNyk5ThtGHdLg=;
  b=WSnUtph0QARn0INbhnOoBf4MleluUfXqnfnu3zZprlThmKh2TiURwpO3
   1cZBhAwTItB/+4U5xQRrdodne7xXCQP/GkbNNdYdB+vcN2dtvfjdpEKdl
   cdLZRHtBtgQ0F8u5RmCENmFN5BpSd94L9Q+DgwyWmGFl3t1RYcy6k1cr+
   rRmKhGOrgZMQ0RNJa6F8XVEiikbpY0josV9dQgTwZ3NqwEesIAsXGqYGH
   iBLP2sxihOJSobfgLrgwKr56WmZFlzg3rx/46TT/KhBSQiTOsZ5iU50nB
   3ecC6b4oN5+Oo8Xx9vDEe/8ELNFM+Cvg7gfDQSQOotPOxl23zsBVfERxx
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10641"; a="338072468"
X-IronPort-AV: E=Sophos;i="5.98,238,1673942400"; 
   d="scan'208";a="338072468"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2023 19:05:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10641"; a="676409832"
X-IronPort-AV: E=Sophos;i="5.98,238,1673942400"; 
   d="scan'208";a="676409832"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by orsmga002.jf.intel.com with ESMTP; 06 Mar 2023 19:05:17 -0800
From:   Xin Li <xin3.li@intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, peterz@infradead.org,
        andrew.cooper3@citrix.com, seanjc@google.com, pbonzini@redhat.com,
        ravi.v.shankar@intel.com
Subject: [PATCH v5 17/34] x86/fred: add a page fault entry stub for FRED
Date:   Mon,  6 Mar 2023 18:39:29 -0800
Message-Id: <20230307023946.14516-18-xin3.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230307023946.14516-1-xin3.li@intel.com>
References: <20230307023946.14516-1-xin3.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
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
Tested-by: Shan Kang <shan.kang@intel.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
---
 arch/x86/include/asm/fred.h |  2 ++
 arch/x86/mm/fault.c         | 20 ++++++++++++++++++--
 2 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/fred.h b/arch/x86/include/asm/fred.h
index 2f337162da73..57affbf80ced 100644
--- a/arch/x86/include/asm/fred.h
+++ b/arch/x86/include/asm/fred.h
@@ -94,6 +94,8 @@ static __always_inline unsigned long fred_event_data(struct pt_regs *regs)
 #define DEFINE_FRED_HANDLER(f) noinstr DECLARE_FRED_HANDLER(f)
 typedef DECLARE_FRED_HANDLER((*fred_handler));
 
+DECLARE_FRED_HANDLER(fred_exc_page_fault);
+
 #endif /* __ASSEMBLY__ */
 
 #endif /* CONFIG_X86_FRED */
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index a498ae1fbe66..0f946121de14 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -33,6 +33,7 @@
 #include <asm/kvm_para.h>		/* kvm_handle_async_pf		*/
 #include <asm/vdso.h>			/* fixup_vdso_exception()	*/
 #include <asm/irq_stack.h>
+#include <asm/fred.h>			/* fred_event_data()	*/
 
 #define CREATE_TRACE_POINTS
 #include <asm/trace/exceptions.h>
@@ -1507,9 +1508,10 @@ handle_page_fault(struct pt_regs *regs, unsigned long error_code,
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
@@ -1556,3 +1558,17 @@ DEFINE_IDTENTRY_RAW_ERRORCODE(exc_page_fault)
 
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

