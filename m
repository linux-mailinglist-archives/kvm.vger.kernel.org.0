Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8F14539740
	for <lists+kvm@lfdr.de>; Tue, 31 May 2022 21:43:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347477AbiEaTlX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 May 2022 15:41:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347391AbiEaTlE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 May 2022 15:41:04 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BA519D071;
        Tue, 31 May 2022 12:40:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654026051; x=1685562051;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=t4a5tuZptExmTkLsreePI0/ZzTlSd7Cm++5ACk06E8M=;
  b=Gv1wS5g3DCZ8NBuvH5UeoMtz3h4CP3eCkvyqpIzlXB2IVSyLHq7eoVTV
   PDzz5o1WqfnwXJWduncBKT9ImUs2uLeXM1cOiHIKxV4CVBMfqQrQ8mDSB
   FJM5X7GIRR11CQ2KastvAtVPRVSPDGeG+0B8HeyWomIWHEgHT034EBSJw
   7ubFUNAdofXvnclO839eX9Ulv0U5KPRPLBXs3K+GRsOKmgxZGf0REoIRj
   37swlR2985lV1dtnUIRACgw96KWwGX1DpIg7fHMKux/ccYWlNqm+TrV3a
   m3O374dIkm8It477Evr8jh1e2aoDr84Qu5aETztVFHXVYMLvA+5uU+GFh
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10364"; a="272935095"
X-IronPort-AV: E=Sophos;i="5.91,266,1647327600"; 
   d="scan'208";a="272935095"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2022 12:40:29 -0700
X-IronPort-AV: E=Sophos;i="5.91,266,1647327600"; 
   d="scan'208";a="645164397"
Received: from maciejwo-mobl1.ger.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.36.207])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2022 12:40:26 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, dave.hansen@intel.com,
        len.brown@intel.com, tony.luck@intel.com,
        rafael.j.wysocki@intel.com, reinette.chatre@intel.com,
        dan.j.williams@intel.com, peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com, kai.huang@intel.com
Subject: [PATCH v4 10/22] x86/virt/tdx: Do logical-cpu scope TDX module initialization
Date:   Wed,  1 Jun 2022 07:39:33 +1200
Message-Id: <f87ac9fd402279bd2960d345f12228a8f5be7cd1.1654025431.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <cover.1654025430.git.kai.huang@intel.com>
References: <cover.1654025430.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

After the global module initialization, the next step is logical-cpu
scope module initialization.  Logical-cpu initialization requires
calling TDH.SYS.LP.INIT on all BIOS-enabled CPUs.  This SEAMCALL can run
concurrently on all CPUs.

Use the helper introduced for shutting down the module to do logical-cpu
scope initialization.

Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/virt/vmx/tdx/tdx.c | 15 +++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h |  1 +
 2 files changed, 16 insertions(+)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 37a5f37dc013..081aa7e280d8 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -201,6 +201,15 @@ static int tdx_module_init_global(void)
 	return ret ? -EFAULT : 0;
 }
 
+static int tdx_module_init_cpus(void)
+{
+	struct seamcall_ctx sc = { .fn = TDH_SYS_LP_INIT };
+
+	seamcall_on_each_cpu(&sc);
+
+	return atomic_read(&sc.err);
+}
+
 /*
  * Detect and initialize the TDX module.
  *
@@ -225,6 +234,12 @@ static int init_tdx_module(void)
 	if (ret)
 		goto out;
 
+	/* Logical-cpu scope initialization */
+	ret = tdx_module_init_cpus();
+	if (ret)
+		goto out;
+
+
 	/*
 	 * Return -EINVAL until all steps of TDX module initialization
 	 * process are done.
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 9e694789eb91..56164bf27378 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -50,6 +50,7 @@
  * TDX module SEAMCALL leaf functions
  */
 #define TDH_SYS_INIT		33
+#define TDH_SYS_LP_INIT		35
 #define TDH_SYS_LP_SHUTDOWN	44
 
 /*
-- 
2.35.3

