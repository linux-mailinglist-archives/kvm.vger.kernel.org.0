Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED48B651B19
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 08:01:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233354AbiLTHBv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 02:01:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232678AbiLTHBa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 02:01:30 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F4CC14D2E;
        Mon, 19 Dec 2022 23:01:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671519688; x=1703055688;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=b2h40hZlbzAYlSPYHfekdfFFlQufXWZBJiq+lRFxfWo=;
  b=HrRLsLqEhd0sRfW/H3OVWvOCi8quRwLkvMASsElbRI4DrOpksHhUCkjO
   WpOwAu9J4/VteZ71fKbQ4ZdsY1TBWHu9Fp+GanBgvCNPhWGNC8wNLZbhR
   EZaD0yzzhQb4m75w6f7QnQD6WNklg9tFx8YvYXKD5DBhx3+2F58dq6tEr
   zt/iqsgfy+KDXSGwFi5sMTDC5cim4aaX3RyxPj9f4Fl0BGCjpF8fm/rw7
   cdNV2hgoyf3ZmP+l+yp9AcmYNF+QD3DJWCA2gthPRnBhIb61Af6zRCCPX
   oATmulEOr4V0Zv7hptLLUdaH8Z/mioVjw+V3RvMoX8QIswvRkcN0IQKoC
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10566"; a="302971929"
X-IronPort-AV: E=Sophos;i="5.96,258,1665471600"; 
   d="scan'208";a="302971929"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2022 23:01:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10566"; a="644326426"
X-IronPort-AV: E=Sophos;i="5.96,258,1665471600"; 
   d="scan'208";a="644326426"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by orsmga007.jf.intel.com with ESMTP; 19 Dec 2022 23:01:09 -0800
From:   Xin Li <xin3.li@intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, peterz@infradead.org,
        andrew.cooper3@citrix.com, seanjc@google.com, pbonzini@redhat.com,
        ravi.v.shankar@intel.com
Subject: [RFC PATCH 05/32] x86/traps: add exc_raise_irq() for VMX IRQ reinjection
Date:   Mon, 19 Dec 2022 22:36:31 -0800
Message-Id: <20221220063658.19271-6-xin3.li@intel.com>
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

