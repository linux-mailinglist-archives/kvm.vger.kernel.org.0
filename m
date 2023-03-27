Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2061A6C9DB8
	for <lists+kvm@lfdr.de>; Mon, 27 Mar 2023 10:25:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233157AbjC0IZT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Mar 2023 04:25:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233104AbjC0IYx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Mar 2023 04:24:53 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3124330E0;
        Mon, 27 Mar 2023 01:24:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679905478; x=1711441478;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Vo6Y4KRnake/BwUScJbQdgNXqARSX4a72bEPCU1WlFI=;
  b=nwbf75yHdOzlvPni92iNUJ1hhhO2QIRfooXInYALgdtKmhV5j6pJJ87r
   u7R3383QwbZtQPIHWSRkEu72tqOIldA4vn85VP4SKT4T4Gj6F49PQbLYu
   7/+UEoBeQKzTsliTPIPqrZf5T+Syt0N7xJQ2KaSMbC5T/nRBTJOcQhH11
   Yxt0F5QXcbpOI/ZE+KqnxwlOo9j96qLP2f9ryQJ3C4+lhGffZUGV35OC+
   uwzs39AHR5TdGCV/zXASS68Tb5JWLogd9dYe7Xi27jxTxvf9H93gH6MiV
   aiQQqTz2abVrzgpd+8e6euDSM7QWAy0ACHcIkfOoTcYtmsxKCwZ2rPzcb
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10661"; a="338930284"
X-IronPort-AV: E=Sophos;i="5.98,294,1673942400"; 
   d="scan'208";a="338930284"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2023 01:24:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10661"; a="713787104"
X-IronPort-AV: E=Sophos;i="5.98,294,1673942400"; 
   d="scan'208";a="713787104"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by orsmga008.jf.intel.com with ESMTP; 27 Mar 2023 01:24:36 -0700
From:   Xin Li <xin3.li@intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, peterz@infradead.org,
        andrew.cooper3@citrix.com, seanjc@google.com, pbonzini@redhat.com,
        ravi.v.shankar@intel.com, jiangshanlai@gmail.com,
        shan.kang@intel.com
Subject: [PATCH v6 19/33] x86/fred: add a machine check entry stub for FRED
Date:   Mon, 27 Mar 2023 00:58:24 -0700
Message-Id: <20230327075838.5403-20-xin3.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230327075838.5403-1-xin3.li@intel.com>
References: <20230327075838.5403-1-xin3.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
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
index f928a03082af..54746e8c0a17 100644
--- a/arch/x86/include/asm/fred.h
+++ b/arch/x86/include/asm/fred.h
@@ -97,6 +97,7 @@ typedef DECLARE_FRED_HANDLER((*fred_handler));
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

