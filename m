Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67DDA7217B4
	for <lists+kvm@lfdr.de>; Sun,  4 Jun 2023 16:30:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231742AbjFDOab (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 4 Jun 2023 10:30:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231747AbjFDOa3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 4 Jun 2023 10:30:29 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96E351BB;
        Sun,  4 Jun 2023 07:30:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685889008; x=1717425008;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hjGnxy/CDXaTnuzdMnNbw9yu+BMw409/8RKOfc9ahyc=;
  b=Z6z0r89QBIGf0d7N9miNjGoTZdywrYCaLacLbci2cHgdpIX8lJozI1m7
   gjasSMLUCEdcT+84Kvy4KCPnPXkQIEsLdJMlcCy6Jyu5O2SvXI4QrxzVb
   tJqQDRbNWJBNck/0kqQ5un9Jdk9miii0Y5QM//0jWuRO7lAlI3OGWFnGy
   qSfDShffl3G2nuUbBtra1epfa+Hl/X1tmzs4cyRCStcht3pL5DjK4WGgG
   E5SHaDN+4BmxsflsIFX5BYolb/f3BleoLjYL+WpCWi3lJE9/HFiCY436F
   nZSboEq9F+eNkD4L7WbIDdE7rYg47xqT5jenZm2zAZLolbRN/HW0QV2kA
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10731"; a="353683487"
X-IronPort-AV: E=Sophos;i="6.00,217,1681196400"; 
   d="scan'208";a="353683487"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2023 07:28:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10731"; a="1038501077"
X-IronPort-AV: E=Sophos;i="6.00,217,1681196400"; 
   d="scan'208";a="1038501077"
Received: from tdhastx-mobl2.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.50.31])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2023 07:28:23 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, dave.hansen@intel.com,
        kirill.shutemov@linux.intel.com, tony.luck@intel.com,
        peterz@infradead.org, tglx@linutronix.de, seanjc@google.com,
        pbonzini@redhat.com, david@redhat.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, ying.huang@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com, kai.huang@intel.com
Subject: [PATCH v11 06/20] x86/virt/tdx: Handle SEAMCALL running out of entropy error
Date:   Mon,  5 Jun 2023 02:27:19 +1200
Message-Id: <9b3582c9f3a81ae68b32d9997fcd20baecb63b9b.1685887183.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1685887183.git.kai.huang@intel.com>
References: <cover.1685887183.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Certain SEAMCALL leaf functions may return error due to running out of
entropy, in which case the SEAMCALL should be retried as suggested by
the TDX spec.

Handle this case in SEAMCALL common function.  Mimic the existing
rdrand_long() to retry RDRAND_RETRY_LOOPS times.

Signed-off-by: Kai Huang <kai.huang@intel.com>
---

v10 -> v11:
 - New patch

---
 arch/x86/virt/vmx/tdx/tdx.c | 15 ++++++++++++++-
 arch/x86/virt/vmx/tdx/tdx.h | 17 +++++++++++++++++
 2 files changed, 31 insertions(+), 1 deletion(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index e82713dd5d54..e62e978eba1b 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -15,6 +15,7 @@
 #include <linux/smp.h>
 #include <asm/msr-index.h>
 #include <asm/msr.h>
+#include <asm/archrandom.h>
 #include <asm/tdx.h>
 #include "tdx.h"
 
@@ -33,12 +34,24 @@ static int __always_unused seamcall(u64 fn, u64 rcx, u64 rdx, u64 r8, u64 r9,
 				    struct tdx_module_output *out)
 {
 	int cpu, ret = 0;
+	int retry;
 	u64 sret;
 
 	/* Need a stable CPU id for printing error message */
 	cpu = get_cpu();
 
-	sret = __seamcall(fn, rcx, rdx, r8, r9, out);
+	/*
+	 * Certain SEAMCALL leaf functions may return error due to
+	 * running out of entropy, in which case the SEAMCALL should
+	 * be retried.  Handle this in SEAMCALL common function.
+	 *
+	 * Mimic the existing rdrand_long() to retry
+	 * RDRAND_RETRY_LOOPS times.
+	 */
+	retry = RDRAND_RETRY_LOOPS;
+	do {
+		sret = __seamcall(fn, rcx, rdx, r8, r9, out);
+	} while (sret == TDX_RND_NO_ENTROPY && --retry);
 
 	/* Save SEAMCALL return code if the caller wants it */
 	if (seamcall_ret)
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 48ad1a1ba737..55dbb1b8c971 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -4,6 +4,23 @@
 
 #include <linux/types.h>
 
+/*
+ * This file contains both macros and data structures defined by the TDX
+ * architecture and Linux defined software data structures and functions.
+ * The two should not be mixed together for better readability.  The
+ * architectural definitions come first.
+ */
+
+/*
+ * TDX SEAMCALL error codes
+ */
+#define TDX_RND_NO_ENTROPY	0x8000020300000000ULL
+
+/*
+ * Do not put any hardware-defined TDX structure representations below
+ * this comment!
+ */
+
 struct tdx_module_output;
 u64 __seamcall(u64 fn, u64 rcx, u64 rdx, u64 r8, u64 r9,
 	       struct tdx_module_output *out);
-- 
2.40.1

