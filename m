Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA733694513
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 13:01:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231324AbjBMMBi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 07:01:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230523AbjBMMBS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 07:01:18 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE08919682;
        Mon, 13 Feb 2023 04:00:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676289644; x=1707825644;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mUsApv8gVb1LZP98vlXGPOGZoTIkXgs3y140taNjlGw=;
  b=gTglEwWmyIsnq7w464ygpW3xAR6bd2NouiIa39VTLRBCxPsXvSSGfJhF
   KQUOduTkAkD0hksnab6TNFW6Jqjtqhtdx/iBoMsDqmCD6UYnas0gBg/8H
   QHPWuo18VU7xJwmYfK0mrk1TCoJ8cNORag+MUnkvoNH3hmLJ1/cTUQ7us
   vd8l5unfw4gQgKYm3IjmRvowRfiIVndidqOLy0QIeNu7Q6IskuROex5VF
   MiFmxGIZRvY1Rlf9qzikbID+yRzM5JYpU4Mt0vlt1DdjUEZA8lM8QYKjC
   ZQY7fpCjcjSvgdbntT/xrKVigUdjErUheRbMiT5xMs152EA0pmO3HVCwa
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10619"; a="358283216"
X-IronPort-AV: E=Sophos;i="5.97,293,1669104000"; 
   d="scan'208";a="358283216"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 04:00:44 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10619"; a="701243238"
X-IronPort-AV: E=Sophos;i="5.97,293,1669104000"; 
   d="scan'208";a="701243238"
Received: from wonger-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.209.188.34])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 04:00:39 -0800
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, dave.hansen@intel.com, peterz@infradead.org,
        tglx@linutronix.de, seanjc@google.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, rafael.j.wysocki@intel.com,
        kirill.shutemov@linux.intel.com, ying.huang@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com,
        tony.luck@intel.com, ak@linux.intel.com, isaku.yamahata@intel.com,
        chao.gao@intel.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        david@redhat.com, bagasdotme@gmail.com, sagis@google.com,
        imammedo@redhat.com, kai.huang@intel.com
Subject: [PATCH v9 06/18] x86/virt/tdx: Do TDX module global initialization
Date:   Tue, 14 Feb 2023 00:59:13 +1300
Message-Id: <cd1e822a51a2da53a8ef5eee6b319f4423035cc9.1676286526.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1676286526.git.kai.huang@intel.com>
References: <cover.1676286526.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Start to transit out the "multi-steps" of initializing the TDX module as
listed in the skeleton infrastructure.  Do the first step to do module
global initialization, which is one SEAMCALL on any logical cpu.

Signed-off-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Isaku Yamahata <isaku.yamahata@intel.com>
---

v8 -> v9:
 - Added this patch back.

---
 arch/x86/virt/vmx/tdx/tdx.c | 11 ++++++++++-
 arch/x86/virt/vmx/tdx/tdx.h | 12 ++++++++++++
 2 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 5ae3d71b70b4..79cee28c51b5 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -172,10 +172,19 @@ static int __always_unused seamcall(u64 fn, u64 rcx, u64 rdx, u64 r8, u64 r9,
 
 static int init_tdx_module(void)
 {
+	int ret;
+
+	/*
+	 * TDX module global initialization.  All '0's are just
+	 * unused parameters.
+	 */
+	ret = seamcall(TDH_SYS_INIT, 0, 0, 0, 0, NULL, NULL);
+	if (ret)
+		return ret;
+
 	/*
 	 * TODO:
 	 *
-	 *  - TDX module global initialization.
 	 *  - TDX module per-cpu initialization.
 	 *  - Get TDX module information and TDX-capable memory regions.
 	 *  - Build the list of TDX-usable memory regions.
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 931a50f0f44c..55472e085bc8 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -4,6 +4,18 @@
 
 #include <linux/types.h>
 
+/*
+ * This file contains both macros and data structures defined by the TDX
+ * architecture and Linux defined software data structures and functions.
+ * The two should not be mixed together for better readability.  The
+ * architectural definitions come first.
+ */
+
+ /*
+  * TDX module SEAMCALL leaf functions
+  */
+#define TDH_SYS_INIT		33
+
 /* Kernel defined TDX module status during module initialization. */
 enum tdx_module_status_t {
 	TDX_MODULE_UNKNOWN,
-- 
2.39.1

