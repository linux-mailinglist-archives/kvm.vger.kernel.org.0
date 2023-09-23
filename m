Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F03087AC058
	for <lists+kvm@lfdr.de>; Sat, 23 Sep 2023 12:17:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231440AbjIWKMn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 23 Sep 2023 06:12:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231555AbjIWKMD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 23 Sep 2023 06:12:03 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 455E5CDF;
        Sat, 23 Sep 2023 03:11:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695463912; x=1726999912;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bNtEfhEic2/4eI6U3F6LZD3GtdQN7TZ08d/4AOd+L9I=;
  b=LZ2QO50YfqdDo8MkxH7jn0cK9EzSuhuOH0Liq8Ra7laGgJV7BFrLvuWl
   5ck1IsGyzIYRExmfyAhQ+Np1MkhaCqbwV5hCpRg/4RmtJcKhzewsFR+BQ
   HvsQMGqpdeutNBdeoLotc22LW+zOBTxNbIdzWRYKUK+sAthn8iil/M8wo
   oRa4ZMrcRqwnx1/3B5UqTIm73vkbGSDY/FkC7V2rfXftOAf4ukNvTZTDT
   L+aUA9o3YbVNQ8XlAS/HTEgWI9y1H+H/errtdLfVo5TYuAj1ncCgOxifO
   SfJ23tBhmkeVnFxQbrAqWqAaQfrtTGCTS7DfVmlIymV9JpAtEHLl3iZFI
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10841"; a="447492399"
X-IronPort-AV: E=Sophos;i="6.03,171,1694761200"; 
   d="scan'208";a="447492399"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2023 03:11:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10841"; a="813388196"
X-IronPort-AV: E=Sophos;i="6.03,171,1694761200"; 
   d="scan'208";a="813388196"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by fmsmga008.fm.intel.com with ESMTP; 23 Sep 2023 03:11:49 -0700
From:   Xin Li <xin3.li@intel.com>
To:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-edac@vger.kernel.org, linux-hyperv@vger.kernel.org,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        luto@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        peterz@infradead.org, jgross@suse.com, ravi.v.shankar@intel.com,
        mhiramat@kernel.org, andrew.cooper3@citrix.com,
        jiangshanlai@gmail.com, nik.borisov@suse.com
Subject: [PATCH v11 27/37] x86/fred: Add a machine check entry stub for FRED
Date:   Sat, 23 Sep 2023 02:42:02 -0700
Message-Id: <20230923094212.26520-28-xin3.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230923094212.26520-1-xin3.li@intel.com>
References: <20230923094212.26520-1-xin3.li@intel.com>
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

Like #DB, when occurred on different ring level, i.e., from user or kernel
context, #MCE needs to be handled on different stack: User #MCE on current
task stack, while kernel #MCE on a dedicated stack.

This is exactly how FRED event delivery invokes an exception handler: ring
3 event on level 0 stack, i.e., current task stack; ring 0 event on the
#MCE dedicated stack specified in the IA32_FRED_STKLVLS MSR. So unlike IDT,
the FRED machine check entry stub doesn't do stack switch.

Tested-by: Shan Kang <shan.kang@intel.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
---

Changes since v5:
* Disallow #DB inside #MCE for robustness sake (Peter Zijlstra).
---
 arch/x86/kernel/cpu/mce/core.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/arch/x86/kernel/cpu/mce/core.c b/arch/x86/kernel/cpu/mce/core.c
index 6f35f724cc14..da0a4a102afe 100644
--- a/arch/x86/kernel/cpu/mce/core.c
+++ b/arch/x86/kernel/cpu/mce/core.c
@@ -52,6 +52,7 @@
 #include <asm/mce.h>
 #include <asm/msr.h>
 #include <asm/reboot.h>
+#include <asm/fred.h>
 
 #include "internal.h"
 
@@ -2144,6 +2145,31 @@ DEFINE_IDTENTRY_MCE_USER(exc_machine_check)
 	exc_machine_check_user(regs);
 	local_db_restore(dr7);
 }
+
+#ifdef CONFIG_X86_FRED
+/*
+ * When occurred on different ring level, i.e., from user or kernel
+ * context, #MCE needs to be handled on different stack: User #MCE
+ * on current task stack, while kernel #MCE on a dedicated stack.
+ *
+ * This is exactly how FRED event delivery invokes an exception
+ * handler: ring 3 event on level 0 stack, i.e., current task stack;
+ * ring 0 event on the #MCE dedicated stack specified in the
+ * IA32_FRED_STKLVLS MSR. So unlike IDT, the FRED machine check entry
+ * stub doesn't do stack switch.
+ */
+DEFINE_FREDENTRY_MCE(exc_machine_check)
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

