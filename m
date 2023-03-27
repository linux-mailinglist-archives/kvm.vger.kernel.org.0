Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A6A56C9DBA
	for <lists+kvm@lfdr.de>; Mon, 27 Mar 2023 10:25:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233165AbjC0IZV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Mar 2023 04:25:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233102AbjC0IYx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Mar 2023 04:24:53 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C20449D7;
        Mon, 27 Mar 2023 01:24:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679905477; x=1711441477;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=z2X5VK9fQIUiWFOXZ/Z/uPBIrWUORMITtKdHy89L3Wo=;
  b=Z7oLudKy5gVHckeP44adoQ7ZTo+YnBF3t5Oo1ih6KQDnlWkJvQfN9Vvh
   3eMXTfySEJPgx4wP17+JwbdfeiXpn9CLxb65fcrY9meH5moAjZsqCu9px
   6DUjuBeRr4evLnUrQ3Meta1lZUWr3yvata5WRbV9O4f+o8KERpxXI+Sv4
   aOp8bTTA0Q5RNwrk9g73FajYOOATvGU5co0lZjgmRBwK9CGBPx8DS/1eA
   RfMDuyTNleZNdMOk4gbeZyIoHhq0uZlA1rVVs+rVu78Go6UZuIY2sYUYa
   kM2XGyAe0O8xdIegWdOVwvslmHXnHCtHi/BE+X0AfRg0ZXptDopoqp1hv
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10661"; a="338930273"
X-IronPort-AV: E=Sophos;i="5.98,294,1673942400"; 
   d="scan'208";a="338930273"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2023 01:24:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10661"; a="713787101"
X-IronPort-AV: E=Sophos;i="5.98,294,1673942400"; 
   d="scan'208";a="713787101"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by orsmga008.jf.intel.com with ESMTP; 27 Mar 2023 01:24:36 -0700
From:   Xin Li <xin3.li@intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, peterz@infradead.org,
        andrew.cooper3@citrix.com, seanjc@google.com, pbonzini@redhat.com,
        ravi.v.shankar@intel.com, jiangshanlai@gmail.com,
        shan.kang@intel.com
Subject: [PATCH v6 18/33] x86/fred: add a NMI entry stub for FRED
Date:   Mon, 27 Mar 2023 00:58:23 -0700
Message-Id: <20230327075838.5403-19-xin3.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230327075838.5403-1-xin3.li@intel.com>
References: <20230327075838.5403-1-xin3.li@intel.com>
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

On a FRED system, NMIs nest both with themselves and faults, transient
information is saved into the stack frame, and NMI unblocking only
happens when the stack frame indicates that so should happen.

Thus, the NMI entry stub for FRED is really quite small...

Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Tested-by: Shan Kang <shan.kang@intel.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
---
 arch/x86/include/asm/fred.h |  1 +
 arch/x86/kernel/nmi.c       | 19 +++++++++++++++++++
 2 files changed, 20 insertions(+)

diff --git a/arch/x86/include/asm/fred.h b/arch/x86/include/asm/fred.h
index 633dd9e6a68e..f928a03082af 100644
--- a/arch/x86/include/asm/fred.h
+++ b/arch/x86/include/asm/fred.h
@@ -94,6 +94,7 @@ static __always_inline unsigned long fred_event_data(struct pt_regs *regs)
 #define DEFINE_FRED_HANDLER(f) noinstr DECLARE_FRED_HANDLER(f)
 typedef DECLARE_FRED_HANDLER((*fred_handler));
 
+DECLARE_FRED_HANDLER(fred_exc_nmi);
 DECLARE_FRED_HANDLER(fred_exc_debug);
 DECLARE_FRED_HANDLER(fred_exc_page_fault);
 
diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index 776f4b1e395b..e7b2abe42583 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -34,6 +34,7 @@
 #include <asm/cache.h>
 #include <asm/nospec-branch.h>
 #include <asm/sev.h>
+#include <asm/fred.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/nmi.h>
@@ -643,6 +644,24 @@ void nmi_backtrace_stall_check(const struct cpumask *btp)
 
 #endif
 
+#ifdef CONFIG_X86_FRED
+DEFINE_FRED_HANDLER(fred_exc_nmi)
+{
+	/*
+	 * With FRED, CR2 and DR6 are pushed atomically on faults,
+	 * so we don't have to worry about saving and restoring them.
+	 * Breakpoint faults nest, so assume it is OK to leave DR7
+	 * enabled.
+	 */
+	irqentry_state_t irq_state = irqentry_nmi_enter(regs);
+
+	inc_irq_stat(__nmi_count);
+	default_do_nmi(regs);
+
+	irqentry_nmi_exit(regs, irq_state);
+}
+#endif
+
 void stop_nmi(void)
 {
 	ignore_nmis++;
-- 
2.34.1

