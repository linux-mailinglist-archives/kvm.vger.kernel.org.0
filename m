Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 392606A171F
	for <lists+kvm@lfdr.de>; Fri, 24 Feb 2023 08:28:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbjBXH2Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Feb 2023 02:28:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbjBXH2A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Feb 2023 02:28:00 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0475865AD;
        Thu, 23 Feb 2023 23:27:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677223675; x=1708759675;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5ojl4mrz7EluvMPfPkXTnSlfudBddxu4Pmb5fcSRBp4=;
  b=Tp63Vz3gpKZhF217zJNL3ZZ6XzIRQ0GD+MZOhoYw0XZIPXlNh/vdLLjP
   wf1M4gksykRmZ/m0jCBV6r4RJfCyOybh1ap6/I85Rtp6NOYZU2vq75+LF
   yPTfBbkM7PbpztJyyHMck0kbE6jp/AzswcQ6GajRpS5pf0H19QPMT2ETD
   EPuw9uBJj5sfv4jv/n8+6v5liiJDTpTlBmZs/bPhNzGlv4l7Z/HnlnotQ
   HKQMRr3xraXQC0nEDio/o7+kyeR4ywSy1wCXY4XsbkJTQWml6hTfYnEpa
   gHP+k1ed3AFa1y6RqncyA5IWkq+j+mo1NKzeO+h9lnqwmw/Ju1gb2ufsH
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10630"; a="334835959"
X-IronPort-AV: E=Sophos;i="5.97,324,1669104000"; 
   d="scan'208";a="334835959"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2023 23:27:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10630"; a="815639200"
X-IronPort-AV: E=Sophos;i="5.97,324,1669104000"; 
   d="scan'208";a="815639200"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by fmsmga001.fm.intel.com with ESMTP; 23 Feb 2023 23:27:20 -0800
From:   Xin Li <xin3.li@intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, peterz@infradead.org,
        andrew.cooper3@citrix.com, seanjc@google.com, pbonzini@redhat.com,
        ravi.v.shankar@intel.com
Subject: [RFC PATCH v3 05/32] x86/traps: export external_interrupt() for VMX IRQ reinjection
Date:   Thu, 23 Feb 2023 23:01:18 -0800
Message-Id: <20230224070145.3572-6-xin3.li@intel.com>
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

To eliminate dispatching IRQ through the IDT, export external_interrupt()
for VMX IRQ reinjection.

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

