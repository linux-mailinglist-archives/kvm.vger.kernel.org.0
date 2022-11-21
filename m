Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A1056317AD
	for <lists+kvm@lfdr.de>; Mon, 21 Nov 2022 01:28:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbiKUA2O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 20 Nov 2022 19:28:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229841AbiKUA1b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 20 Nov 2022 19:27:31 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D6D612B;
        Sun, 20 Nov 2022 16:27:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668990445; x=1700526445;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KhP8T6MQSf6upYtvCFaMabziPVPSa54uAPjTpE/5J6U=;
  b=mjejGvAfYHGUuXM1+JRE7TbQbsl/23UP1L68UOtB5ACr70Batjb0tLVN
   9k42Ii9qSCffjiJVgoPOmgSeBXHg8AmY1fdqtIGbQ3+WO+8tQRlppZTj9
   fV5pji0I48imGZE4U/dZQEs/yIZOQ6XSJY7uvR0DV1aO/k2eT9vEXSDSF
   BSjonsPdJGbyqQ/pj71Y/evYkEa9LYqLECN7KMaakkxCIqkiAZw6HXWgz
   C5aheeTjY9lUonds1Oyzb8wjDenL4lcro4H8Sa1yNSNnAL+QtryT6bTSk
   mbDnE7Ag1akAYPs50Nzy6jSpiIsmWBEk3NnFC13+77rwwNzS15cpcerzi
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10537"; a="399732311"
X-IronPort-AV: E=Sophos;i="5.96,180,1665471600"; 
   d="scan'208";a="399732311"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2022 16:27:25 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10537"; a="729825287"
X-IronPort-AV: E=Sophos;i="5.96,180,1665471600"; 
   d="scan'208";a="729825287"
Received: from tomnavar-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.209.176.15])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2022 16:27:21 -0800
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
Subject: [PATCH v7 07/20] x86/virt/tdx: Do TDX module global initialization
Date:   Mon, 21 Nov 2022 13:26:29 +1300
Message-Id: <40824ec3e3dc759705dcfa1cb2929d18c12b417a.1668988357.git.kai.huang@intel.com>
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

The first step of initializing the module is to call TDH.SYS.INIT once
on any logical cpu to do module global initialization.  Do the module
global initialization.

It also detects the TDX module, as seamcall() returns -ENODEV when the
module is not loaded.

Signed-off-by: Kai Huang <kai.huang@intel.com>
---

v6 -> v7:
 - Improved changelog.

---
 arch/x86/virt/vmx/tdx/tdx.c | 19 +++++++++++++++++--
 arch/x86/virt/vmx/tdx/tdx.h |  1 +
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 5db1a05cb4bd..f292292313bd 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -208,8 +208,23 @@ static void seamcall_on_each_cpu(struct seamcall_ctx *sc)
  */
 static int init_tdx_module(void)
 {
-	/* The TDX module hasn't been detected */
-	return -ENODEV;
+	int ret;
+
+	/*
+	 * Call TDH.SYS.INIT to do the global initialization of
+	 * the TDX module.  It also detects the module.
+	 */
+	ret = seamcall(TDH_SYS_INIT, 0, 0, 0, 0, NULL, NULL);
+	if (ret)
+		goto out;
+
+	/*
+	 * Return -EINVAL until all steps of TDX module initialization
+	 * process are done.
+	 */
+	ret = -EINVAL;
+out:
+	return ret;
 }
 
 static void shutdown_tdx_module(void)
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 215cc1065d78..0b415805c921 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -15,6 +15,7 @@
 /*
  * TDX module SEAMCALL leaf functions
  */
+#define TDH_SYS_INIT		33
 #define TDH_SYS_LP_SHUTDOWN	44
 
 /*
-- 
2.38.1

