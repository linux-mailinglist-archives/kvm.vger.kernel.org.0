Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60726623BAC
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 07:17:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232364AbiKJGRX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Nov 2022 01:17:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232338AbiKJGRU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Nov 2022 01:17:20 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2BA82E9CC
        for <kvm@vger.kernel.org>; Wed,  9 Nov 2022 22:17:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668061039; x=1699597039;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Oc0mQKbv3vl2yWZXC3YWNJd1AfkG2RvOnJu/bF1aWjE=;
  b=ms5c7T40OYQRwCttr5e4tPBP4PIlhxrQs5mvPYY7MuDXdNo+4/aMNRUL
   mUrzZ0XcBz6n0ZfZKbJhlX3IaVJmXQmHFcAkN5kbJFZwiR+qfIKRmoLeD
   uKDoDtL0WlMXAFPuuNibZm/YOrra29uSzN3JrAkiAqky142uOu4xYnuXy
   eGh8nVne+rG5OOIEu0+t8wVPvPDMiwkl6loIq/fTzK7aXlVPXEBjRcaMV
   mHgF+uS5uFpL8J6ojHDxBPIdB7a6Pi9Cn3/uJL2ZfRmlbqb9G3ciFenWD
   TOA832iTx5xPntGOlDC7g+vhECm6E9lWSmFrjaK4ZImNA/WOeiMXekv7c
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="311223526"
X-IronPort-AV: E=Sophos;i="5.96,152,1665471600"; 
   d="scan'208";a="311223526"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2022 22:17:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="700667271"
X-IronPort-AV: E=Sophos;i="5.96,152,1665471600"; 
   d="scan'208";a="700667271"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by fmsmga008.fm.intel.com with ESMTP; 09 Nov 2022 22:17:17 -0800
From:   Xin Li <xin3.li@intel.com>
To:     linux-kernel@vger.kernnel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, seanjc@google.com,
        pbonzini@redhat.com, kevin.tian@intel.com
Subject: [PATCH 4/6] x86/traps: add external_interrupt() to dispatch external interrupts
Date:   Wed,  9 Nov 2022 21:53:45 -0800
Message-Id: <20221110055347.7463-5-xin3.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221110055347.7463-1-xin3.li@intel.com>
References: <20221110055347.7463-1-xin3.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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

