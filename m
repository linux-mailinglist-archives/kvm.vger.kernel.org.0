Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3633A651B26
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 08:02:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233346AbiLTHCX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 02:02:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233257AbiLTHBj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 02:01:39 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D494315A2C;
        Mon, 19 Dec 2022 23:01:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671519697; x=1703055697;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Aj4SBgFDxPyxr8I0rdhDIUq7owde47aPDFKuZiENGTs=;
  b=Rc/SPy8Hg5wH4yerMUlfgNjm5r+WYA46wDlpbMSnQVOxOD4kxBY2Qbzy
   20ZO5YjYv6Rmh2575lennzpoO++qhi2XuXsb2wslmleArmkUzddX3Joye
   Q5hYk2jbYzXq2vRrA4bYP7qpCz3gjj+18oqiXzvd5XMVlGrLp/k6G3K2L
   1fPj410dvsl8W8y4/DxkaBQ+iWaFzolIJYKL2/KxBZSMKYB7aAFq07WlP
   0ukzuOoOD+ewG0IN/lP2wMnnjsNq2UijmaMXxd7xMTNoba7ze5ZD8WIS/
   23mzTjlQ/0+BeEkM4M1+gAz9rlXL3CFipC0KwnIaS1JYRIl5EnO4Vav2k
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10566"; a="302972071"
X-IronPort-AV: E=Sophos;i="5.96,258,1665471600"; 
   d="scan'208";a="302972071"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2022 23:01:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10566"; a="644326501"
X-IronPort-AV: E=Sophos;i="5.96,258,1665471600"; 
   d="scan'208";a="644326501"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by orsmga007.jf.intel.com with ESMTP; 19 Dec 2022 23:01:15 -0800
From:   Xin Li <xin3.li@intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, peterz@infradead.org,
        andrew.cooper3@citrix.com, seanjc@google.com, pbonzini@redhat.com,
        ravi.v.shankar@intel.com
Subject: [RFC PATCH 19/32] x86/fred: add a NMI entry stub for FRED
Date:   Mon, 19 Dec 2022 22:36:45 -0800
Message-Id: <20221220063658.19271-20-xin3.li@intel.com>
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

On a FRED system, NMIs nest both with themselves and faults, transient
information is saved into the stack frame, and NMI unblocking only
happens when the stack frame indicates that so should happen.

Thus, the NMI entry stub for FRED is really quite small...

Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
---
 arch/x86/include/asm/fred.h |  1 +
 arch/x86/kernel/nmi.c       | 28 ++++++++++++++++++++++++++++
 2 files changed, 29 insertions(+)

diff --git a/arch/x86/include/asm/fred.h b/arch/x86/include/asm/fred.h
index 3089d1c70771..66c274a12e26 100644
--- a/arch/x86/include/asm/fred.h
+++ b/arch/x86/include/asm/fred.h
@@ -92,6 +92,7 @@ static __always_inline unsigned long fred_event_data(struct pt_regs *regs)
 #define DEFINE_FRED_HANDLER(f) noinstr DECLARE_FRED_HANDLER(f)
 typedef DECLARE_FRED_HANDLER((*fred_handler));
 
+DECLARE_FRED_HANDLER(fred_exc_nmi);
 DECLARE_FRED_HANDLER(fred_exc_debug);
 DECLARE_FRED_HANDLER(fred_exc_page_fault);
 
diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index cec0bfa3bc04..d497071a79f2 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -34,6 +34,7 @@
 #include <asm/cache.h>
 #include <asm/nospec-branch.h>
 #include <asm/sev.h>
+#include <asm/fred.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/nmi.h>
@@ -537,6 +538,33 @@ DEFINE_IDTENTRY_RAW(exc_nmi_noist)
 EXPORT_SYMBOL_GPL(asm_exc_nmi_noist);
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
+	/*
+	 * VM exit induced by a NMI keeps NMI blocked, and we do
+	 * "int $2" to reinject the NMI w/ NMI kept being blocked.
+	 * However "int $2" doesn't set the nmi bit in the FRED
+	 * stack frame, so we explicitly set it to make sure a
+	 * later ERETS will unblock NMI immediately.
+	 */
+	regs->nmi = 1;
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

