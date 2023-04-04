Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79A3E6D5E47
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 12:55:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234622AbjDDKzN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 06:55:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234851AbjDDKym (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 06:54:42 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D56F4448C;
        Tue,  4 Apr 2023 03:53:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680605629; x=1712141629;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CKPdbZePoSn8pAkjI3IJ+p0apbz+y9vUOwaC2M88CbM=;
  b=NYuiDZfKTpt+q32ltTJRKaFO0j47ls/h3G7rpomY9FgwUO3INz2f/BVi
   r7BKavSKLtZgw9jdTQxxzTzv2+JWA+ai++KT+DOsBDrtRImvkQtgrVOGB
   J7s2dCCefoX9MfjKuAc/AlCszDSq10UpYaTMFygDdq6nh2vDtN5nWEww6
   Q9GBTKW6VX6970spBtj4wAxAr4mkzbKGZ8MAPCJSnBCj7j+lIzfmuTdI8
   fzuvGIKTSR0HrC89wfq8jNlSYasfurCOotnj4bIjq8Tv1KdOWF7FTJdo9
   blEq2r5QB6CIc+3FGWu526BH0WTVZwifTBrA/A2thTiKOTx9SIJJikNnl
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="330734113"
X-IronPort-AV: E=Sophos;i="5.98,317,1673942400"; 
   d="scan'208";a="330734113"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2023 03:53:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="775597835"
X-IronPort-AV: E=Sophos;i="5.98,317,1673942400"; 
   d="scan'208";a="775597835"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by FMSMGA003.fm.intel.com with ESMTP; 04 Apr 2023 03:53:04 -0700
From:   Xin Li <xin3.li@intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, peterz@infradead.org,
        andrew.cooper3@citrix.com, seanjc@google.com, pbonzini@redhat.com,
        ravi.v.shankar@intel.com, jiangshanlai@gmail.com,
        shan.kang@intel.com
Subject: [PATCH v7 19/33] x86/fred: add a machine check entry stub for FRED
Date:   Tue,  4 Apr 2023 03:27:02 -0700
Message-Id: <20230404102716.1795-20-xin3.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230404102716.1795-1-xin3.li@intel.com>
References: <20230404102716.1795-1-xin3.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a machine check entry stub for FRED.

Tested-by: Shan Kang <shan.kang@intel.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
---

Changes since v5:
* Disallow #DB inside #MCE for robustness sake (Peter Zijlstra).
---
 arch/x86/include/asm/fred.h    |  1 +
 arch/x86/kernel/cpu/mce/core.c | 15 +++++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/arch/x86/include/asm/fred.h b/arch/x86/include/asm/fred.h
index 9ce2a6439091..61048aa4e01d 100644
--- a/arch/x86/include/asm/fred.h
+++ b/arch/x86/include/asm/fred.h
@@ -102,6 +102,7 @@ typedef DECLARE_FRED_HANDLER((*fred_handler));
 DECLARE_FRED_HANDLER(fred_exc_nmi);
 DECLARE_FRED_HANDLER(fred_exc_debug);
 DECLARE_FRED_HANDLER(fred_exc_page_fault);
+DECLARE_FRED_HANDLER(fred_exc_machine_check);
 
 #endif /* __ASSEMBLY__ */
 
diff --git a/arch/x86/kernel/cpu/mce/core.c b/arch/x86/kernel/cpu/mce/core.c
index 2eec60f50057..859331a6a7ad 100644
--- a/arch/x86/kernel/cpu/mce/core.c
+++ b/arch/x86/kernel/cpu/mce/core.c
@@ -52,6 +52,7 @@
 #include <asm/mce.h>
 #include <asm/msr.h>
 #include <asm/reboot.h>
+#include <asm/fred.h>
 
 #include "internal.h"
 
@@ -2111,6 +2112,20 @@ DEFINE_IDTENTRY_MCE_USER(exc_machine_check)
 	exc_machine_check_user(regs);
 	local_db_restore(dr7);
 }
+
+#ifdef CONFIG_X86_FRED
+DEFINE_FRED_HANDLER(fred_exc_machine_check)
+{
+	unsigned long dr7;
+
+	dr7 = local_db_save();
+	if (user_mode(regs))
+		exc_machine_check_user(regs);
+	else
+		exc_machine_check_kernel(regs);
+	local_db_restore(dr7);
+}
+#endif
 #else
 /* 32bit unified entry point */
 DEFINE_IDTENTRY_RAW(exc_machine_check)
-- 
2.34.1

