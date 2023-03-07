Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0617E6AD548
	for <lists+kvm@lfdr.de>; Tue,  7 Mar 2023 04:05:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230266AbjCGDFd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Mar 2023 22:05:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230222AbjCGDFZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Mar 2023 22:05:25 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF39B74335;
        Mon,  6 Mar 2023 19:05:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678158319; x=1709694319;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=n5Ln656oJnJmTILrzTkjrWNEu25opZektOWvxvWKy2E=;
  b=MYk0z84/HgtYlx4WOUKXH+jbwrikWGWcC3MqpXTy7JSPJBqRs/FUgjNq
   hyP1c6C1lCUrXMVmmDb7LmEY3SbvSoWTlLSoJcR9xiwMaOnapfY3Z343t
   t91yld+NqNAm8zBszN0BR/94WQpJDHbsqAcEnIlYSMnyQHzX/sjxsKnHW
   DX4yOA6I7icVLa7rK731M9Lv5jf39cbMrBkjoAGCF6UZDXxjUw6FlSnq7
   puDSdM17OAUHCPSUTIl3d00l3qJHjnAJie4KscyjyusKF0rHjCUCNzEBU
   4nsdkOr73fjJtWsvqUYOg4I1yTr+tN4XXAOlmWD+Z3lD/L0Q2qcgI+jnT
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10641"; a="338072350"
X-IronPort-AV: E=Sophos;i="5.98,238,1673942400"; 
   d="scan'208";a="338072350"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2023 19:05:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10641"; a="676409724"
X-IronPort-AV: E=Sophos;i="5.98,238,1673942400"; 
   d="scan'208";a="676409724"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by orsmga002.jf.intel.com with ESMTP; 06 Mar 2023 19:05:11 -0800
From:   Xin Li <xin3.li@intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, peterz@infradead.org,
        andrew.cooper3@citrix.com, seanjc@google.com, pbonzini@redhat.com,
        ravi.v.shankar@intel.com
Subject: [PATCH v5 05/34] x86/traps: export external_interrupt() for VMX IRQ reinjection
Date:   Mon,  6 Mar 2023 18:39:17 -0800
Message-Id: <20230307023946.14516-6-xin3.li@intel.com>
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

