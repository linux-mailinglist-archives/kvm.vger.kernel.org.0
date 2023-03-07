Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68F2A6AD558
	for <lists+kvm@lfdr.de>; Tue,  7 Mar 2023 04:09:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230446AbjCGDGv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Mar 2023 22:06:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230340AbjCGDGA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Mar 2023 22:06:00 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCC5A80E16;
        Mon,  6 Mar 2023 19:05:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678158331; x=1709694331;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Y8+C0nkNS1GRT0vpQmI78TLcU0TSh7ChvDXpWBoU34k=;
  b=cSNwpb6hv1Tte6ZVpw8etzk4/PBVO4fSKejgAwXHs9RyM3FVlijrUP2n
   lX+cpFZblSEE8At0il4LV52gb5TslkquqExGrvWYWhP22jy+APNVpbp/i
   eEIADWxfMl8uI3YjSf1j9C/Liv6hGr0kQ35Fef7/N/NINNDoaRydooxqf
   yqwne5awFi3DTNBYJH7yKh56HyUmMxNBMLDHcqCNbIKo+Z9aMa6WJDasi
   iYNEMd+x1QCA46ewJ+z0L9TfTUfq/VQbgl9b3GkQPDBy99xHQJ9BVGAoF
   h9jWErd5LRYQjL9fe7rIw5A6qXmZERXrD8mtfKzxg9KUtwn0k7N6cXKCt
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10641"; a="338072497"
X-IronPort-AV: E=Sophos;i="5.98,238,1673942400"; 
   d="scan'208";a="338072497"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2023 19:05:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10641"; a="676409852"
X-IronPort-AV: E=Sophos;i="5.98,238,1673942400"; 
   d="scan'208";a="676409852"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by orsmga002.jf.intel.com with ESMTP; 06 Mar 2023 19:05:18 -0800
From:   Xin Li <xin3.li@intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, peterz@infradead.org,
        andrew.cooper3@citrix.com, seanjc@google.com, pbonzini@redhat.com,
        ravi.v.shankar@intel.com
Subject: [PATCH v5 20/34] x86/fred: add a machine check entry stub for FRED
Date:   Mon,  6 Mar 2023 18:39:32 -0800
Message-Id: <20230307023946.14516-21-xin3.li@intel.com>
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

Add a machine check entry stub for FRED.

Unlike IDT, no need to save/restore dr7 in FRED machine check handler.

Tested-by: Shan Kang <shan.kang@intel.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
---
 arch/x86/include/asm/fred.h    |  1 +
 arch/x86/kernel/cpu/mce/core.c | 11 +++++++++++
 2 files changed, 12 insertions(+)

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
index 7832a69d170e..26fa7fa44f30 100644
--- a/arch/x86/kernel/cpu/mce/core.c
+++ b/arch/x86/kernel/cpu/mce/core.c
@@ -52,6 +52,7 @@
 #include <asm/mce.h>
 #include <asm/msr.h>
 #include <asm/reboot.h>
+#include <asm/fred.h>
 
 #include "internal.h"
 
@@ -2111,6 +2112,16 @@ DEFINE_IDTENTRY_MCE_USER(exc_machine_check)
 	exc_machine_check_user(regs);
 	local_db_restore(dr7);
 }
+
+#ifdef CONFIG_X86_FRED
+DEFINE_FRED_HANDLER(fred_exc_machine_check)
+{
+	if (user_mode(regs))
+		exc_machine_check_user(regs);
+	else
+		exc_machine_check_kernel(regs);
+}
+#endif
 #else
 /* 32bit unified entry point */
 DEFINE_IDTENTRY_RAW(exc_machine_check)
-- 
2.34.1

