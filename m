Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61B295548C7
	for <lists+kvm@lfdr.de>; Wed, 22 Jun 2022 14:16:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357324AbiFVLSF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jun 2022 07:18:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357278AbiFVLRc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jun 2022 07:17:32 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6F993C4B9;
        Wed, 22 Jun 2022 04:17:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655896640; x=1687432640;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Fm6WKLtKp2WdA8yKi9Sm82sS1NqYszbzPYmVtNEb02k=;
  b=Vi7Dkcac7NdvqiE64lkkXvNI8YUa/uWy1MsX9PBNPcx32Y7/W9mL98PX
   ZEy9dABlMRMLvm+MFNCW2by7a8/gzQo47H9fXcySyl56nwnpDgg+QpdSr
   yaxHgFm3q1L+tkYP7sEH1Hb21Qh8lcFMSpy4lbQoE1kAAEv1WEKEInqp0
   OM1Xql84vZptKBJFwwu0uqMCS1vqFQEpP/XRnM1pVXKXAk5bixvMmikVK
   cJAjade1T6AyY3eHbOWlEdD1b+HOwKqhpRA35crQ8JK9S894KeK7zHwfX
   AM+UyM5SkugwTMGeO5U/7h4ALjUMah+SbKlqzhdnJY9n+eoVD57NmheOg
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10385"; a="281464711"
X-IronPort-AV: E=Sophos;i="5.92,212,1650956400"; 
   d="scan'208";a="281464711"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2022 04:17:20 -0700
X-IronPort-AV: E=Sophos;i="5.92,212,1650956400"; 
   d="scan'208";a="730302229"
Received: from jmatsis-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.209.178.197])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2022 04:17:16 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, dave.hansen@intel.com,
        len.brown@intel.com, tony.luck@intel.com,
        rafael.j.wysocki@intel.com, reinette.chatre@intel.com,
        dan.j.williams@intel.com, peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com, kai.huang@intel.com
Subject: [PATCH v5 10/22] x86/virt/tdx: Do logical-cpu scope TDX module initialization
Date:   Wed, 22 Jun 2022 23:16:59 +1200
Message-Id: <41c84840443d7ba5fa2d23a5b96784d704a32a05.1655894131.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655894131.git.kai.huang@intel.com>
References: <cover.1655894131.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
index de4efc16ed45..f3f6e20aa30e 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -195,6 +195,15 @@ static int tdx_module_init_global(void)
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
@@ -219,6 +228,12 @@ static int init_tdx_module(void)
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
2.36.1

