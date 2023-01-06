Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 675B365FD85
	for <lists+kvm@lfdr.de>; Fri,  6 Jan 2023 10:20:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232169AbjAFJUi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Jan 2023 04:20:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232920AbjAFJUR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Jan 2023 04:20:17 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F32ED6B5DB;
        Fri,  6 Jan 2023 01:20:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672996815; x=1704532815;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=b2h40hZlbzAYlSPYHfekdfFFlQufXWZBJiq+lRFxfWo=;
  b=Y781nNFPzv3PHOj9/ja92AZCyfGbEc6n0QQm07Rkv9gbKSnhLc9W4kjD
   xel75T7hb+LrKAgTqkdGDkYj79W2KI3CfDdABM4WQp2xcCpWGh83YvPJU
   GQW5FKR7ikIzoL1a5UmXIRGZPoq9UkPr+bzGHqPVYeZhc5K8PhnfNtNCI
   InMppAnDEvb4UZzDGN6AE+NL27RecCue/n6bSmrfb7TFxWUQx23tsYiu3
   T62Q+/JzbzGguoArPQDNimqQeZBANTveMYwieoEj3CW5+uqaSGp3quy67
   WctsxHdCGr1BU9zJAyTSId5ZzAksP684Nho519E6krrbMz35gk5G7r1q8
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10581"; a="322511417"
X-IronPort-AV: E=Sophos;i="5.96,304,1665471600"; 
   d="scan'208";a="322511417"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2023 01:20:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10581"; a="719139356"
X-IronPort-AV: E=Sophos;i="5.96,304,1665471600"; 
   d="scan'208";a="719139356"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by fmsmga008.fm.intel.com with ESMTP; 06 Jan 2023 01:20:12 -0800
From:   Xin Li <xin3.li@intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, peterz@infradead.org,
        andrew.cooper3@citrix.com, seanjc@google.com, pbonzini@redhat.com,
        ravi.v.shankar@intel.com
Subject: [RFC PATCH v2 05/32] x86/traps: add exc_raise_irq() for VMX IRQ reinjection
Date:   Fri,  6 Jan 2023 00:55:50 -0800
Message-Id: <20230106085617.17248-6-xin3.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230106085617.17248-1-xin3.li@intel.com>
References: <20230106085617.17248-1-xin3.li@intel.com>
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

To eliminate dispatching IRQ through the IDT, add exc_raise_irq(),
which calls external_interrupt() for IRQ reinjection.

Signed-off-by: Xin Li <xin3.li@intel.com>
---
 arch/x86/include/asm/traps.h |  2 ++
 arch/x86/kernel/traps.c      | 18 ++++++++++++++++++
 2 files changed, 20 insertions(+)

diff --git a/arch/x86/include/asm/traps.h b/arch/x86/include/asm/traps.h
index 46f5e4e2a346..366b1675c033 100644
--- a/arch/x86/include/asm/traps.h
+++ b/arch/x86/include/asm/traps.h
@@ -56,4 +56,6 @@ void __noreturn handle_stack_overflow(struct pt_regs *regs,
 	void f (struct pt_regs *regs)
 typedef DECLARE_SYSTEM_INTERRUPT_HANDLER((*system_interrupt_handler));
 
+int exc_raise_irq(struct pt_regs *regs, u32 vector);
+
 #endif /* _ASM_X86_TRAPS_H */
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index c35dd2b4d146..99386836b02e 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -1536,6 +1536,24 @@ int external_interrupt(struct pt_regs *regs, unsigned int vector)
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
+int exc_raise_irq(struct pt_regs *regs, u32 vector)
+{
+	return external_interrupt(regs, vector);
+}
+EXPORT_SYMBOL_GPL(exc_raise_irq);
+#endif
+
 void __init trap_init(void)
 {
 	/* Init cpu_entry_area before IST entries are set up */
-- 
2.34.1

