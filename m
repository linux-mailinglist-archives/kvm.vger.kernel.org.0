Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBDEF60EC14
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 01:17:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233454AbiJZXRH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Oct 2022 19:17:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233532AbiJZXRF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Oct 2022 19:17:05 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E01409E0FD;
        Wed, 26 Oct 2022 16:17:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666826224; x=1698362224;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/Fkx/wRum4GQ1qdlfSoQ8YU5mQQZ4srGg/5mX9tS/b0=;
  b=aiJPog2h9aZlZvLg7jBsEkcxg83PDsSremCZHXxzXjMJ9utMBQJY/Aff
   WIMlQBvfG0yPfo2e3UCjWjgNyjHKA9hxaibUzsEE70rvwn/mILnstt4qN
   Zn4htAr8aMfn79bvtJ1xJgRi3mA0xk12XZHqCxQAEVvgM5uqeLzkRLogR
   HX6YWx8F5RRS93KJ+HKfYjWB25PL3M4vjjUIHj45XRaxn0eSBI7vmqKvW
   Xsv/vk1jyVgUB0djG+FZWgx6v7H1bx4dQ7uxUEe+ngGAT0Fu9Fs2HykOw
   LVzKeFfoHKaEpoAAH4j6Xeu/enicst13pEWaNqq/jmxHiovNU3Dtk/p/A
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="306814187"
X-IronPort-AV: E=Sophos;i="5.95,215,1661842800"; 
   d="scan'208";a="306814187"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2022 16:17:04 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="737446189"
X-IronPort-AV: E=Sophos;i="5.95,215,1661842800"; 
   d="scan'208";a="737446189"
Received: from fordon1x-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.24.177])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2022 16:17:00 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, seanjc@google.com, pbonzini@redhat.com,
        dave.hansen@intel.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, kirill.shutemov@linux.intel.com,
        reinette.chatre@intel.com, len.brown@intel.com,
        tony.luck@intel.com, peterz@infradead.org, ak@linux.intel.com,
        isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com, kai.huang@intel.com
Subject: [PATCH v6 01/21] x86/tdx: Use enum to define page level of TDX supported page sizes
Date:   Thu, 27 Oct 2022 12:16:00 +1300
Message-Id: <8a5b40d43f8b993a48b99d6647b16a82b433627c.1666824663.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <cover.1666824663.git.kai.huang@intel.com>
References: <cover.1666824663.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

TDX supports 4K, 2M and 1G page sizes.  When TDX guest accepts one page
via try_accept_one(), it passes the page size level to the TDX module.
Currently try_accept_one() uses hard-coded magic number for that.

Introduce a new enum type to represent the page level of TDX supported
page sizes to replace the hard-coded values.  Both initializing the TDX
module and KVM TDX support will need to use that too.

Also, currently try_accept_one() uses an open-coded switch statement to
get the TDX page level from the kernel page level.  As KVM will also
need to do the same thing, introduce a common helper to convert the
kernel page level to the TDX page level.

Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/coco/tdx/tdx.c    | 20 ++++----------------
 arch/x86/include/asm/tdx.h | 33 +++++++++++++++++++++++++++++++++
 2 files changed, 37 insertions(+), 16 deletions(-)

diff --git a/arch/x86/coco/tdx/tdx.c b/arch/x86/coco/tdx/tdx.c
index 928dcf7a20d9..c5ff9647213d 100644
--- a/arch/x86/coco/tdx/tdx.c
+++ b/arch/x86/coco/tdx/tdx.c
@@ -655,7 +655,6 @@ static bool try_accept_one(phys_addr_t *start, unsigned long len,
 {
 	unsigned long accept_size = page_level_size(pg_level);
 	u64 tdcall_rcx;
-	u8 page_size;
 
 	if (!IS_ALIGNED(*start, accept_size))
 		return false;
@@ -663,27 +662,16 @@ static bool try_accept_one(phys_addr_t *start, unsigned long len,
 	if (len < accept_size)
 		return false;
 
+	/* TDX only supports 4K/2M/1G page sizes */
+	if (pg_level < PG_LEVEL_4K || pg_level > PG_LEVEL_1G)
+		return false;
 	/*
 	 * Pass the page physical address to the TDX module to accept the
 	 * pending, private page.
 	 *
 	 * Bits 2:0 of RCX encode page size: 0 - 4K, 1 - 2M, 2 - 1G.
 	 */
-	switch (pg_level) {
-	case PG_LEVEL_4K:
-		page_size = 0;
-		break;
-	case PG_LEVEL_2M:
-		page_size = 1;
-		break;
-	case PG_LEVEL_1G:
-		page_size = 2;
-		break;
-	default:
-		return false;
-	}
-
-	tdcall_rcx = *start | page_size;
+	tdcall_rcx = *start | to_tdx_pg_level(pg_level);
 	if (__tdx_module_call(TDX_ACCEPT_PAGE, tdcall_rcx, 0, 0, 0, NULL))
 		return false;
 
diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 020c81a7c729..1c166fb9c22f 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -20,6 +20,39 @@
 
 #ifndef __ASSEMBLY__
 
+#include <asm/pgtable_types.h>
+
+/*
+ * The page levels of TDX supported page sizes (4K/2M/1G).
+ *
+ * Those values are part of the TDX module ABI.  Do not change them.
+ */
+enum tdx_pg_level {
+	TDX_PG_LEVEL_4K,
+	TDX_PG_LEVEL_2M,
+	TDX_PG_LEVEL_1G,
+	TDX_PG_LEVEL_NUM
+};
+
+/*
+ * Get the TDX page level based on the kernel page level.  The caller
+ * to make sure only pass 4K/2M/1G kernel page level.
+ */
+static inline enum tdx_pg_level to_tdx_pg_level(enum pg_level pglvl)
+{
+	switch (pglvl) {
+	case PG_LEVEL_4K:
+		return TDX_PG_LEVEL_4K;
+	case PG_LEVEL_2M:
+		return TDX_PG_LEVEL_2M;
+	case PG_LEVEL_1G:
+		return TDX_PG_LEVEL_1G;
+	default:
+		WARN_ON_ONCE(1);
+	}
+	return TDX_PG_LEVEL_NUM;
+}
+
 /*
  * Used to gather the output registers values of the TDCALL and SEAMCALL
  * instructions when requesting services from the TDX module.
-- 
2.37.3

