Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8248F6317A0
	for <lists+kvm@lfdr.de>; Mon, 21 Nov 2022 01:27:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbiKUA1f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 20 Nov 2022 19:27:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229874AbiKUA1R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 20 Nov 2022 19:27:17 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29D382CDCF;
        Sun, 20 Nov 2022 16:27:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668990420; x=1700526420;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JrAeTTu2WnvvJ3eZU1SYcarqNb52NmG09HTDLPmjcXs=;
  b=a4dJT29FA4LCvaCheONAJNeZy7sL/jV9XcZVCFFP4K1BpqiIRMcnxKqi
   so+W4SFhwrjYK+U/rKxyZg4GyiDzNOHbpocuwmGv+e0v6ayjc2b/wPrtt
   SENOl8R2bkwKFudzon5KLLnZt/J+udDCdMCmimZTusrhuRao+oZgZ+fnV
   zVudIlmUEWGz0hYBHevLSBdZDmwWTsBAoBRtdOS65q76BcS4obcfqgCP9
   SG6BHhc1LO3n7TUVA/tcZSW0XMZ3OXcjWnHDYz+Dsjj/LOfN78YeVsdef
   mP2AiV9/s2NMzcchkWe35Tp+4fEuaQFfLChacVdmPUT5mZw11zsupallu
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10537"; a="399732270"
X-IronPort-AV: E=Sophos;i="5.96,180,1665471600"; 
   d="scan'208";a="399732270"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2022 16:26:59 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10537"; a="729825134"
X-IronPort-AV: E=Sophos;i="5.96,180,1665471600"; 
   d="scan'208";a="729825134"
Received: from tomnavar-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.209.176.15])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2022 16:26:55 -0800
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, seanjc@google.com, pbonzini@redhat.com,
        dave.hansen@intel.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, kirill.shutemov@linux.intel.com,
        ying.huang@intel.com, reinette.chatre@intel.com,
        len.brown@intel.com, tony.luck@intel.com, peterz@infradead.org,
        ak@linux.intel.com, isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com, kai.huang@intel.com
Subject: [PATCH v7 01/20] x86/tdx: Define TDX supported page sizes as macros
Date:   Mon, 21 Nov 2022 13:26:23 +1300
Message-Id: <d6c6e664c445e9ccf1528625f0e21bbb8471d35f.1668988357.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1668988357.git.kai.huang@intel.com>
References: <cover.1668988357.git.kai.huang@intel.com>
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

TDX supports 4K, 2M and 1G page sizes.  The corresponding values are
defined by the TDX module spec and used as TDX module ABI.  Currently,
they are used in try_accept_one() when the TDX guest tries to accept a
page.  However currently try_accept_one() uses hard-coded magic values.

Define TDX supported page sizes as macros and get rid of the hard-coded
values in try_accept_one().  TDX host support will need to use them too.

Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
---

v6 -> v7:

 - Removed the helper to convert kernel page level to TDX page level.
 - Changed to use macro to define TDX supported page sizes.

---
 arch/x86/coco/tdx/tdx.c    | 6 +++---
 arch/x86/include/asm/tdx.h | 9 +++++++++
 2 files changed, 12 insertions(+), 3 deletions(-)

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
index 28d889c9aa16..e9a3f4a6fba1 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -20,6 +20,15 @@
 
 #ifndef __ASSEMBLY__
 
+/*
+ * TDX supported page sizes (4K/2M/1G).
+ *
+ * Those values are part of the TDX module ABI.  Do not change them.
+ */
+#define TDX_PS_4K	0
+#define TDX_PS_2M	1
+#define TDX_PS_1G	2
+
 /*
  * Used to gather the output registers values of the TDCALL and SEAMCALL
  * instructions when requesting services from the TDX module.
-- 
2.38.1

