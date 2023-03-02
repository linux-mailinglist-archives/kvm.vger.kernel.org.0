Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 426E76A7AE3
	for <lists+kvm@lfdr.de>; Thu,  2 Mar 2023 06:51:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229765AbjCBFux (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Mar 2023 00:50:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbjCBFut (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Mar 2023 00:50:49 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA7771A974;
        Wed,  1 Mar 2023 21:50:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677736247; x=1709272247;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=n5Ln656oJnJmTILrzTkjrWNEu25opZektOWvxvWKy2E=;
  b=DDGxUA2XEVd3Cqm0Nhhf5MqfsXS/gB3fw73sK0yrbbL5YQKkAgWrs8o8
   Egc6Ky0vAfj8cTyEr0MCVl1mmmXuRZGjc8h4+kpX3VNh0GJ/g3Hxi2Y4M
   7yA1F00ryGF5Ih0vfcoJPR8lrsdKzIEj5llIpbaDSPORSA/W4AF6l3ADD
   1So99IuZMk546CsdFx4h7WenDpHkFUurWgNMDcRA3ltn9iygXRiUxbw0W
   X958xNPEri+ovDMFASxRStJY1ycfPPz57GQkhZLMkCyp5BW9HYvINTRNE
   +OpdjuUatqr6bmCI7BayAp46nksdcKFNqxOcdvc2NnkhCeij7JY1CCEys
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10636"; a="420887052"
X-IronPort-AV: E=Sophos;i="5.98,226,1673942400"; 
   d="scan'208";a="420887052"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2023 21:50:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10636"; a="920530884"
X-IronPort-AV: E=Sophos;i="5.98,226,1673942400"; 
   d="scan'208";a="920530884"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by fmsmga006.fm.intel.com with ESMTP; 01 Mar 2023 21:50:45 -0800
From:   Xin Li <xin3.li@intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, peterz@infradead.org,
        andrew.cooper3@citrix.com, seanjc@google.com, pbonzini@redhat.com,
        ravi.v.shankar@intel.com
Subject: [PATCH v4 05/34] x86/traps: export external_interrupt() for VMX IRQ reinjection
Date:   Wed,  1 Mar 2023 21:24:42 -0800
Message-Id: <20230302052511.1918-6-xin3.li@intel.com>
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

To eliminate dispatching IRQ through the IDT, export external_interrupt()
for VMX IRQ reinjection.

Tested-by: Shan Kang <shan.kang@intel.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
---
 arch/x86/include/asm/traps.h |  2 ++
 arch/x86/kernel/traps.c      | 14 ++++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/arch/x86/include/asm/traps.h b/arch/x86/include/asm/traps.h
index 46f5e4e2a346..da4c21ed68b4 100644
--- a/arch/x86/include/asm/traps.h
+++ b/arch/x86/include/asm/traps.h
@@ -56,4 +56,6 @@ void __noreturn handle_stack_overflow(struct pt_regs *regs,
 	void f (struct pt_regs *regs)
 typedef DECLARE_SYSTEM_INTERRUPT_HANDLER((*system_interrupt_handler));
 
+int external_interrupt(struct pt_regs *regs, unsigned int vector);
+
 #endif /* _ASM_X86_TRAPS_H */
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 31ad645be2fb..cebba1f49e19 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -1540,6 +1540,20 @@ int external_interrupt(struct pt_regs *regs, unsigned int vector)
 	return 0;
 }
 
+#if IS_ENABLED(CONFIG_KVM_INTEL)
+/*
+ * KVM VMX reinjects IRQ on its current stack, it's a sync call
+ * thus the values in the pt_regs structure are not used in
+ * executing IRQ handlers, except cs.RPL and flags.IF, which
+ * are both always 0 in the VMX IRQ reinjection context.
+ *
+ * However, the pt_regs structure is sometimes used in stack
+ * dump, e.g., show_regs(). So let the caller, i.e., KVM VMX
+ * decide how to initialize the input pt_regs structure.
+ */
+EXPORT_SYMBOL_GPL(external_interrupt);
+#endif
+
 void __init trap_init(void)
 {
 	/* Init cpu_entry_area before IST entries are set up */
-- 
2.34.1

