Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5A6B60EC23
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 01:18:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234173AbiJZXSV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Oct 2022 19:18:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233663AbiJZXRs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Oct 2022 19:17:48 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0695B56EB;
        Wed, 26 Oct 2022 16:17:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666826257; x=1698362257;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BGweU50UTahVYU2MdgumkpFBV2AQXxV1CrnaJ1vi394=;
  b=DNkrCyLTAqRI41ug6SXfssdOP8Rcik1itWCK2uHw0nRWtJqdWoiKBM9j
   che40Gq1Efmr/1dttRTtbdcuvdc0TbUJn78ETxg0IvJj3CnTwVhcg/UaG
   tGrWPBhOvFQsZgRyUn41yPrTpznyRKQ+CQER1YE0iESdiGx0IbfgHUm/a
   Pb/y6kjBr9WeiS88s+JjWuHtbjuiAnhILryVgpa02jUSJqBb2AFGtee+n
   iYD9k33Y9xlCKryOUlNDnqbFOv6D1Mn5NCCkH7by5d573qpvBunymEy3u
   MGXSJDJbC3qfnS1bNnXy9qjd95l94hQ6u9WIHs44XdAW2ML/ugLi0CrSL
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="309175537"
X-IronPort-AV: E=Sophos;i="5.95,215,1661842800"; 
   d="scan'208";a="309175537"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2022 16:17:37 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="737446332"
X-IronPort-AV: E=Sophos;i="5.95,215,1661842800"; 
   d="scan'208";a="737446332"
Received: from fordon1x-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.24.177])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2022 16:17:33 -0700
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
Subject: [PATCH v6 09/21] x86/virt/tdx: Do logical-cpu scope TDX module initialization
Date:   Thu, 27 Oct 2022 12:16:08 +1300
Message-Id: <1d01bf0cffc558c408319bb3758a87d21fe655c2.1666824663.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <cover.1666824663.git.kai.huang@intel.com>
References: <cover.1666824663.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
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
index 68fb9bc201d6..8a1c98d961f3 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -342,6 +342,15 @@ static void seamcall_on_each_cpu(struct seamcall_ctx *sc)
 	on_each_cpu(seamcall_smp_call_function, sc, true);
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
@@ -361,6 +370,12 @@ static int init_tdx_module(void)
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
index 0b415805c921..9ba11808bd45 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -16,6 +16,7 @@
  * TDX module SEAMCALL leaf functions
  */
 #define TDH_SYS_INIT		33
+#define TDH_SYS_LP_INIT		35
 #define TDH_SYS_LP_SHUTDOWN	44
 
 /*
-- 
2.37.3

