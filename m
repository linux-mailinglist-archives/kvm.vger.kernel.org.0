Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5516623BFF
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 07:39:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232635AbiKJGje (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Nov 2022 01:39:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232560AbiKJGj2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Nov 2022 01:39:28 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F11FA2A94F;
        Wed,  9 Nov 2022 22:39:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668062363; x=1699598363;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Oc0mQKbv3vl2yWZXC3YWNJd1AfkG2RvOnJu/bF1aWjE=;
  b=fuHH37zAkdJQrJAzoNSJWpN/L1cY1vNCU+UvuRAliNUEsvlj+HL8gVkt
   AHAclFPQQQ+gpM1AKS1j0x0BHgyGey7dfgl15IJTLU6oQxKwYePndnSbm
   hnRWgV/JiABXdArZ17Qyt9DYV46vdv0JO8H3GUyoKhsn564PGoZaZ3vw4
   vviw2c9QaQahJqqSmtZOOzezVyTVsZw2FchejMpzIMB2+Utt90tr62Kxj
   GSO2oFN3J7d7qBrtNdSscmA+s/ztJpMEOO4GhShjE2XU2HhDJ9h8f+BLB
   hCgq2LbL5WNz+88bTXiBfMCeoTNBKPB7LbRp4tQzN2Aea/EOZ4hrRUYTh
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="375474007"
X-IronPort-AV: E=Sophos;i="5.96,153,1665471600"; 
   d="scan'208";a="375474007"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2022 22:39:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="588057232"
X-IronPort-AV: E=Sophos;i="5.96,153,1665471600"; 
   d="scan'208";a="588057232"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by orsmga003.jf.intel.com with ESMTP; 09 Nov 2022 22:39:21 -0800
From:   Xin Li <xin3.li@intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, seanjc@google.com,
        pbonzini@redhat.com, kevin.tian@intel.com
Subject: [RESEND PATCH 4/6] x86/traps: add external_interrupt() to dispatch external interrupts
Date:   Wed,  9 Nov 2022 22:15:43 -0800
Message-Id: <20221110061545.1531-5-xin3.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221110061545.1531-1-xin3.li@intel.com>
References: <20221110061545.1531-1-xin3.li@intel.com>
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

Add external_interrupt() to dispatch external interrupts to their
handlers. If an external interrupt is a system interrupt, dipatch
it through system_interrupt_handler_table, otherwise call into
common_interrupt().

Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
---
 arch/x86/kernel/traps.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 9c7826e588bc..c1eb3bd335ce 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -1507,6 +1507,27 @@ void __init install_system_interrupt_handler(unsigned int n, const void *asm_add
 	alloc_intr_gate(n, asm_addr);
 }
 
+/*
+ * External interrupt dispatch function.
+ *
+ * Until/unless common_interrupt() can be taught to deal with the
+ * special system vectors, split the dispatch.
+ *
+ * Note: common_interrupt() already deals with IRQ_MOVE_CLEANUP_VECTOR.
+ */
+__visible noinstr void external_interrupt(struct pt_regs *regs,
+					  unsigned int vector)
+{
+	unsigned int sysvec = vector - FIRST_SYSTEM_VECTOR;
+
+	BUG_ON(vector < FIRST_EXTERNAL_VECTOR);
+
+	if (sysvec < NR_SYSTEM_VECTORS)
+		return system_interrupt_handler_table[sysvec](regs, vector);
+
+	common_interrupt(regs, vector);
+}
+
 void __init trap_init(void)
 {
 	/* Init cpu_entry_area before IST entries are set up */
-- 
2.34.1

