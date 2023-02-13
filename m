Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9018694502
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 13:00:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230356AbjBMMAl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 07:00:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230121AbjBMMAf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 07:00:35 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF31E18B02;
        Mon, 13 Feb 2023 04:00:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676289617; x=1707825617;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QEso+vBOOoVux/wtjNoZkk+xLB3AIptATSZNTVaGYfg=;
  b=TLEJrUg/CZcZE2QzVS+AhOWYkyAQTzzZNh7twhou09OFQX7Xnm3AX7Mx
   jkBFukoVjO90gybjj5A34AB1isf930QcZcipzdHsOhebMLCSQjoql3ebQ
   5ZOvaoHs3HgJSymed6hpgg+ZS+KHZrg6/hV4HmuJZz8xrK/tVpLNfSeTA
   ztaVzC2mfFM+TTAw46lnXQav74OEPAd+3/qCZgMwRQfxUNhbK1clgf10q
   1nKPZkXf9WceWJoqL1oB6ckgKEqz7uzkE5ZZbVCQBr8254DX688N0MWVv
   Dn2NaolDdKFdkS+E2CYK0/gCbCXI8NKgk3Ros0Q3Hdr0213H6S4FujMSz
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10619"; a="358283045"
X-IronPort-AV: E=Sophos;i="5.97,293,1669104000"; 
   d="scan'208";a="358283045"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 04:00:17 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10619"; a="701243098"
X-IronPort-AV: E=Sophos;i="5.97,293,1669104000"; 
   d="scan'208";a="701243098"
Received: from wonger-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.209.188.34])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 04:00:10 -0800
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
Subject: [PATCH v9 01/18] x86/tdx: Define TDX supported page sizes as macros
Date:   Tue, 14 Feb 2023 00:59:08 +1300
Message-Id: <ce67ff8c775a29ad2482b28e007f7eebc264251b.1676286526.git.kai.huang@intel.com>
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

TDX supports 4K, 2M and 1G page sizes.  The corresponding values are
defined by the TDX module spec and used as TDX module ABI.  Currently,
they are used in try_accept_one() when the TDX guest tries to accept a
page.  However currently try_accept_one() uses hard-coded magic values.

Define TDX supported page sizes as macros and get rid of the hard-coded
values in try_accept_one().  TDX host support will need to use them too.

Signed-off-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Dave Hansen <dave.hansen@linux.intel.com>
---

v8 -> v9:
 - Added Dave's Reviewed-by

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
index b593009b30ab..e27c3cd97fcb 100644
--- a/arch/x86/coco/tdx/tdx.c
+++ b/arch/x86/coco/tdx/tdx.c
@@ -777,13 +777,13 @@ static bool try_accept_one(phys_addr_t *start, unsigned long len,
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
2.39.1

