Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 796EB647E06
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 07:53:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbiLIGxU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Dec 2022 01:53:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbiLIGxP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Dec 2022 01:53:15 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 093021F63B;
        Thu,  8 Dec 2022 22:53:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670568786; x=1702104786;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tpNWTLiIlps42i61R7np9UDYahZOICSBhQnhpwefLwQ=;
  b=SR5fs889scheak+u+Ts2Zs1nPhUdXNVNs+YR7+OztS3dzl3ahrlIIydp
   Zpn2RuYR+CaoiLoLEIPCCKS1kTuIlUjigGVOy4tc1Y4eiUlaeDOHfoJwJ
   i1NzXz2KJDSxrRM2l7rg8DLgMfKWnv2bxJXmZmdfR9gohWlNNVe6TqS/E
   9UfLxgLtMsdC4DkYlOP8YStZddqywCpPkXifyLE4maG5wChGIZHig82Z9
   BKCgJr4YUiGwdtpjGLJJAHGCuspJbvW1kw1d58MKZFO6mg74wk3PmiBq8
   DhcaEwuYPJmuCe8BJAXY+bb57vNmMblBl1Av1PsGHK0A0i375XkMe3NVJ
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="318551253"
X-IronPort-AV: E=Sophos;i="5.96,230,1665471600"; 
   d="scan'208";a="318551253"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 22:53:05 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="679836792"
X-IronPort-AV: E=Sophos;i="5.96,230,1665471600"; 
   d="scan'208";a="679836792"
Received: from omiramon-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.28.82])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 22:53:00 -0800
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, dave.hansen@intel.com, peterz@infradead.org,
        tglx@linutronix.de, seanjc@google.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, rafael.j.wysocki@intel.com,
        kirill.shutemov@linux.intel.com, ying.huang@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com,
        tony.luck@intel.com, ak@linux.intel.com, isaku.yamahata@intel.com,
        chao.gao@intel.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        bagasdotme@gmail.com, sagis@google.com, imammedo@redhat.com,
        kai.huang@intel.com
Subject: [PATCH v8 01/16] x86/tdx: Define TDX supported page sizes as macros
Date:   Fri,  9 Dec 2022 19:52:22 +1300
Message-Id: <2436106b4de8df75ab304c43128fe5b174bb0bf4.1670566861.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1670566861.git.kai.huang@intel.com>
References: <cover.1670566861.git.kai.huang@intel.com>
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

TDX supports 4K, 2M and 1G page sizes.  The corresponding values are
defined by the TDX module spec and used as TDX module ABI.  Currently,
they are used in try_accept_one() when the TDX guest tries to accept a
page.  However currently try_accept_one() uses hard-coded magic values.

Define TDX supported page sizes as macros and get rid of the hard-coded
values in try_accept_one().  TDX host support will need to use them too.

Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
---

v7 -> v8:
 - Improved the comment of TDX supported page sizes macros (Dave)

v6 -> v7:
 - Removed the helper to convert kernel page level to TDX page level.
 - Changed to use macro to define TDX supported page sizes.

---
 arch/x86/coco/tdx/tdx.c    | 6 +++---
 arch/x86/include/asm/tdx.h | 5 +++++
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/x86/coco/tdx/tdx.c b/arch/x86/coco/tdx/tdx.c
index cfd4c95b9f04..7fa7fb54f438 100644
--- a/arch/x86/coco/tdx/tdx.c
+++ b/arch/x86/coco/tdx/tdx.c
@@ -722,13 +722,13 @@ static bool try_accept_one(phys_addr_t *start, unsigned long len,
 	 */
 	switch (pg_level) {
 	case PG_LEVEL_4K:
-		page_size = 0;
+		page_size = TDX_PS_4K;
 		break;
 	case PG_LEVEL_2M:
-		page_size = 1;
+		page_size = TDX_PS_2M;
 		break;
 	case PG_LEVEL_1G:
-		page_size = 2;
+		page_size = TDX_PS_1G;
 		break;
 	default:
 		return false;
diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 28d889c9aa16..25fd6070dc0b 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -20,6 +20,11 @@
 
 #ifndef __ASSEMBLY__
 
+/* TDX supported page sizes from the TDX module ABI. */
+#define TDX_PS_4K	0
+#define TDX_PS_2M	1
+#define TDX_PS_1G	2
+
 /*
  * Used to gather the output registers values of the TDCALL and SEAMCALL
  * instructions when requesting services from the TDX module.
-- 
2.38.1

