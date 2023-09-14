Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 890F979FA7D
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 07:20:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235619AbjINFUG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 01:20:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235353AbjINFTp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 01:19:45 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EBB61FF0;
        Wed, 13 Sep 2023 22:19:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694668763; x=1726204763;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bNtEfhEic2/4eI6U3F6LZD3GtdQN7TZ08d/4AOd+L9I=;
  b=Qpf19+RaO/+rNSUYgEK7ndADjr3LeHPs76DLwBipJExN6G1CQrM8P+m3
   nwC0BWdGNC0d+Z51WvlTlTSr6va2ap5B5QsuwyRKgGnb1PoeGuco/jCgc
   lYVTCj4+nr8bEWaDYYWYMqQTx19SwSwwiu4offfYDea4RRG/bGKOi6nPw
   jpw49Yu5EUg+9JaSU/TTCZ9YOZmE/0YQ5MAdAtYE700XEclWxPe7pBWkX
   b/xZLe85BM692YVUNBcFnuq6Y3otYNTEo3Lw25lOapfhyYDHi0t7nWp92
   14H45rVITSYZJyR9HlpUo2mju6wCfObZZOXvmzkE3wQxGvlzGcjJ96Bq4
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="382661419"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="382661419"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 22:17:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="779488820"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="779488820"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by orsmga001.jf.intel.com with ESMTP; 13 Sep 2023 22:17:42 -0700
From:   Xin Li <xin3.li@intel.com>
To:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-edac@vger.kernel.org, linux-hyperv@vger.kernel.org,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        luto@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        peterz@infradead.org, jgross@suse.com, ravi.v.shankar@intel.com,
        mhiramat@kernel.org, andrew.cooper3@citrix.com,
        jiangshanlai@gmail.com
Subject: [PATCH v10 27/38] x86/fred: Add a machine check entry stub for FRED
Date:   Wed, 13 Sep 2023 21:47:54 -0700
Message-Id: <20230914044805.301390-28-xin3.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230914044805.301390-1-xin3.li@intel.com>
References: <20230914044805.301390-1-xin3.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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

