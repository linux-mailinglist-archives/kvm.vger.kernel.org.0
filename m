Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 569446AD546
	for <lists+kvm@lfdr.de>; Tue,  7 Mar 2023 04:05:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230207AbjCGDFW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Mar 2023 22:05:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230176AbjCGDFS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Mar 2023 22:05:18 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A23446098;
        Mon,  6 Mar 2023 19:05:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678158311; x=1709694311;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CJ5cn83oehVUqkHaIiQkGH139f3gJuf37y85qUnwXYY=;
  b=HFPC4MWW2gq7b5gLkRRs1I+shOwuNJzvfNIJIPqtqRi3IPPWhZC1veWG
   5FaAHrCVv1ed3iy3f9KXqrSR7RrlbytVgX3tQy+IAP96/zsd6Fu8cBnrU
   hoPougNGzgxrkD+4X/6GrkUupvsd2QyK7A/seqxCrdUh1j2yzdAFtmFHN
   QKqFyM7duHPfHzFHVU8u5yr0zHCDmUYpHCm0A4T9+Q7TpQJJBiOeQHlnT
   ShJ0QHJPMLp6uOD/0siPNimbCarzkLMOQi0i03aVVkTzPQ5OvdxixBYdA
   m5mKg5YyU5ly254/e/LzueaqNS/76Wdhrd37YLithoAYGj2RNX7sm5bva
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10641"; a="338072313"
X-IronPort-AV: E=Sophos;i="5.98,238,1673942400"; 
   d="scan'208";a="338072313"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2023 19:05:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10641"; a="676409688"
X-IronPort-AV: E=Sophos;i="5.98,238,1673942400"; 
   d="scan'208";a="676409688"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by orsmga002.jf.intel.com with ESMTP; 06 Mar 2023 19:05:09 -0800
From:   Xin Li <xin3.li@intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, peterz@infradead.org,
        andrew.cooper3@citrix.com, seanjc@google.com, pbonzini@redhat.com,
        ravi.v.shankar@intel.com
Subject: [PATCH v5 01/34] x86/traps: let common_interrupt() handle IRQ_MOVE_CLEANUP_VECTOR
Date:   Mon,  6 Mar 2023 18:39:13 -0800
Message-Id: <20230307023946.14516-2-xin3.li@intel.com>
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

IRQ_MOVE_CLEANUP_VECTOR is the only one of the system IRQ vectors that
is *below* FIRST_SYSTEM_VECTOR. It is a slow path, so just push it
into common_interrupt() just before the spurious interrupt handling.

Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Tested-by: Shan Kang <shan.kang@intel.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
---
 arch/x86/kernel/irq.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 766ffe3ba313..7e125fff45ab 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -248,6 +248,10 @@ DEFINE_IDTENTRY_IRQ(common_interrupt)
 	desc = __this_cpu_read(vector_irq[vector]);
 	if (likely(!IS_ERR_OR_NULL(desc))) {
 		handle_irq(desc, regs);
+#ifdef CONFIG_SMP
+	} else if (vector == IRQ_MOVE_CLEANUP_VECTOR) {
+		sysvec_irq_move_cleanup(regs);
+#endif
 	} else {
 		ack_APIC_irq();
 
-- 
2.34.1

