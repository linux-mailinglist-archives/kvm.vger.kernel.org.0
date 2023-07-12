Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDA1A750222
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 10:56:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232984AbjGLI4K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 04:56:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232981AbjGLIz4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 04:55:56 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05DE21999;
        Wed, 12 Jul 2023 01:55:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689152151; x=1720688151;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kOFOJ7DYKH+TkC4p/DHkbRzB9d4nwuYwHUYGrapzAoM=;
  b=R+rdrtLQ/iJPGlcXkUWqlEzVBGIhXRFzKfkgVCAFYO23UGmxwlfI2nam
   qPINm0/rc530+GD9O4d3zUu5VdNu0p7zsq1+U/zEgZ8sti5W8VvYWg2Br
   PbMOAsR7vDpA6fuMW/V928Xv0MkklieIDK2cWz/NiO0rAJJwgFH3+B6JR
   0qoTE4MJ6DJRq3OquEoTzq162X+8UJedH2WsXGwbq+jr8SmjOapymWVgr
   +6iH9TvWDmwbsqaOzCBrqjB32fCixjbQvv52yycjGVHMbaQVxiCcISqps
   tjENpWKCwUPfjXQ7OHNwNij6IiONjnRiP1RlTEHqWCQ5z2jCWpa2EcGui
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10768"; a="344439181"
X-IronPort-AV: E=Sophos;i="6.01,199,1684825200"; 
   d="scan'208";a="344439181"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2023 01:55:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10768"; a="845573377"
X-IronPort-AV: E=Sophos;i="6.01,199,1684825200"; 
   d="scan'208";a="845573377"
Received: from mjamatan-mobl2.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.209.168.102])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2023 01:55:47 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     peterz@infradead.org, kirill.shutemov@linux.intel.com,
        linux-kernel@vger.kernel.org
Cc:     dave.hansen@intel.com, tglx@linutronix.de, bp@alien8.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org, seanjc@google.com,
        pbonzini@redhat.com, kvm@vger.kernel.org, isaku.yamahata@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, kai.huang@intel.com
Subject: [PATCH 04/10] x86/tdx: Make macros of TDCALLs consistent with the spec
Date:   Wed, 12 Jul 2023 20:55:18 +1200
Message-ID: <ba4b4ff1fe77ca76cca370b2fd4aa57a2d23c86d.1689151537.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1689151537.git.kai.huang@intel.com>
References: <cover.1689151537.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The TDX spec names all TDCALLs with prefix "TDG".  Currently, the kernel
doesn't follow such convention for the macros of those TDCALLs but uses
prefix "TDX_" for all of them.  Although it's arguable whether the TDX
spec names those TDCALLs properly, it's better for the kernel to follow
the spec when naming those macros.

Change all macros of TDCALLs to make them consistent with the spec.  As
a bonus, they get distinguished easily from the host-side SEAMCALLs,
which all have prefix "TDH".

No functional change intended.

Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/coco/tdx/tdx.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/x86/coco/tdx/tdx.c b/arch/x86/coco/tdx/tdx.c
index 5b8056f6c83f..de021df92009 100644
--- a/arch/x86/coco/tdx/tdx.c
+++ b/arch/x86/coco/tdx/tdx.c
@@ -15,11 +15,11 @@
 #include <asm/pgtable.h>
 
 /* TDX module Call Leaf IDs */
-#define TDX_GET_INFO			1
-#define TDX_GET_VEINFO			3
-#define TDX_GET_REPORT			4
-#define TDX_ACCEPT_PAGE			6
-#define TDX_WR				8
+#define TDG_VP_INFO			1
+#define TDG_VP_VEINFO_GET		3
+#define TDG_MR_REPORT			4
+#define TDG_MEM_PAGE_ACCEPT		6
+#define TDG_VM_WR			8
 
 /* TDCS fields. To be used by TDG.VM.WR and TDG.VM.RD module calls */
 #define TDCS_NOTIFY_ENABLES		0x9100000000000010
@@ -123,7 +123,7 @@ int tdx_mcall_get_report0(u8 *reportdata, u8 *tdreport)
 {
 	u64 ret;
 
-	ret = __tdx_module_call(TDX_GET_REPORT, virt_to_phys(tdreport),
+	ret = __tdx_module_call(TDG_MR_REPORT, virt_to_phys(tdreport),
 				virt_to_phys(reportdata), TDREPORT_SUBTYPE_0,
 				0, NULL);
 	if (ret) {
@@ -184,7 +184,7 @@ static void tdx_parse_tdinfo(u64 *cc_mask)
 	 * Guest-Host-Communication Interface (GHCI), section 2.4.2 TDCALL
 	 * [TDG.VP.INFO].
 	 */
-	tdx_module_call(TDX_GET_INFO, 0, 0, 0, 0, &out);
+	tdx_module_call(TDG_VP_INFO, 0, 0, 0, 0, &out);
 
 	/*
 	 * The highest bit of a guest physical address is the "sharing" bit.
@@ -626,7 +626,7 @@ void tdx_get_ve_info(struct ve_info *ve)
 	 * Note, the TDX module treats virtual NMIs as inhibited if the #VE
 	 * valid flag is set. It means that NMI=>#VE will not result in a #DF.
 	 */
-	tdx_module_call(TDX_GET_VEINFO, 0, 0, 0, 0, &out);
+	tdx_module_call(TDG_VP_VEINFO_GET, 0, 0, 0, 0, &out);
 
 	/* Transfer the output parameters */
 	ve->exit_reason = out.rcx;
@@ -768,7 +768,7 @@ static bool try_accept_one(phys_addr_t *start, unsigned long len,
 	}
 
 	tdcall_rcx = *start | page_size;
-	if (__tdx_module_call(TDX_ACCEPT_PAGE, tdcall_rcx, 0, 0, 0, NULL))
+	if (__tdx_module_call(TDG_MEM_PAGE_ACCEPT, tdcall_rcx, 0, 0, 0, NULL))
 		return false;
 
 	*start += accept_size;
@@ -805,7 +805,7 @@ static bool tdx_enc_status_changed(unsigned long vaddr, int numpages, bool enc)
 
 	/*
 	 * For shared->private conversion, accept the page using
-	 * TDX_ACCEPT_PAGE TDX module call.
+	 * TDG_MEM_PAGE_ACCEPT TDX module call.
 	 */
 	while (start < end) {
 		unsigned long len = end - start;
@@ -870,7 +870,7 @@ void __init tdx_early_init(void)
 	cc_set_mask(cc_mask);
 
 	/* Kernel does not use NOTIFY_ENABLES and does not need random #VEs */
-	tdx_module_call(TDX_WR, 0, TDCS_NOTIFY_ENABLES, 0, -1ULL, NULL);
+	tdx_module_call(TDG_VM_WR, 0, TDCS_NOTIFY_ENABLES, 0, -1ULL, NULL);
 
 	/*
 	 * All bits above GPA width are reserved and kernel treats shared bit
-- 
2.41.0

