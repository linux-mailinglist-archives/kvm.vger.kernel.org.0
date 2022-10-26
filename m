Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37E5260EC3C
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 01:19:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234333AbiJZXTp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Oct 2022 19:19:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234138AbiJZXTI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Oct 2022 19:19:08 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05E1CD0188;
        Wed, 26 Oct 2022 16:18:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666826295; x=1698362295;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YQ8aEQPLV6Y2LINJF6mbeLLSFafErnmZ9drqr9B4TTw=;
  b=j79ftuy+w+G6qyKvDe7SQdmB652i6+JB2JwCBgmE59mgEBHigWyRFYAX
   5GU6YtnYb2HHnBdOkd++V5DqNFqFMgOSQP+6As1fP/CzYY3NRrZLqik22
   tyFUlnBbBFMBpdOxGlUgKThJRl0aNYVbGIabkOsIOD6eqEySY0lR7xQ0q
   ceOeLUtsmXRbpCTyIRn5qZQCPPg61e8lDrVVM1ul46399Z9k+hGDNpcA6
   A2uXST4VbWG1i1usA5h06DTzZItgVqNLidFpnV4OfAemmdQDo0h1ar8k7
   dGhd+rngilmYpqKyPZjV6IN032jJEg4P3TGjfwbtS11bN84hbNh2W2TcO
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="309175651"
X-IronPort-AV: E=Sophos;i="5.95,215,1661842800"; 
   d="scan'208";a="309175651"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2022 16:18:14 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="737446538"
X-IronPort-AV: E=Sophos;i="5.95,215,1661842800"; 
   d="scan'208";a="737446538"
Received: from fordon1x-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.24.177])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2022 16:18:10 -0700
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
Subject: [PATCH v6 18/21] x86/virt/tdx: Configure global KeyID on all packages
Date:   Thu, 27 Oct 2022 12:16:17 +1300
Message-Id: <c88eb1d501abffc5b9181ef0930579871b7fcbff.1666824663.git.kai.huang@intel.com>
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

After the array of TDMRs and the global KeyID are configured to the TDX
module, use TDH.SYS.KEY.CONFIG to configure the key of the global KeyID
on all packages.

TDH.SYS.KEY.CONFIG must be done on one (any) cpu for each package.  And
it cannot run concurrently on different CPUs.  Implement a helper to
run SEAMCALL on one cpu for each package one by one, and use it to
configure the global KeyID on all packages.

Intel hardware doesn't guarantee cache coherency across different
KeyIDs.  The kernel needs to flush PAMT's dirty cachelines (associated
with KeyID 0) before the TDX module uses the global KeyID to access the
PAMT.  Following the TDX module specification, flush cache before
configuring the global KeyID on all packages.

Given the PAMT size can be large (~1/256th of system RAM), just use
WBINVD on all CPUs to flush.

Reviewed-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/virt/vmx/tdx/tdx.c | 83 ++++++++++++++++++++++++++++++++++++-
 arch/x86/virt/vmx/tdx/tdx.h |  1 +
 2 files changed, 82 insertions(+), 2 deletions(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index fdfce715dda6..9cfb01e7666a 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -354,6 +354,46 @@ static void seamcall_on_each_cpu(struct seamcall_ctx *sc)
 	on_each_cpu(seamcall_smp_call_function, sc, true);
 }
 
+/*
+ * Call one SEAMCALL on one (any) cpu for each physical package in
+ * serialized way.  Return immediately in case of any error if
+ * SEAMCALL fails on any cpu.
+ *
+ * Note for serialized calls 'struct seamcall_ctx::err' doesn't have
+ * to be atomic, but for simplicity just reuse it instead of adding
+ * a new one.
+ */
+static int seamcall_on_each_package_serialized(struct seamcall_ctx *sc)
+{
+	cpumask_var_t packages;
+	int cpu, ret = 0;
+
+	if (!zalloc_cpumask_var(&packages, GFP_KERNEL))
+		return -ENOMEM;
+
+	for_each_online_cpu(cpu) {
+		if (cpumask_test_and_set_cpu(topology_physical_package_id(cpu),
+					packages))
+			continue;
+
+		ret = smp_call_function_single(cpu, seamcall_smp_call_function,
+				sc, true);
+		if (ret)
+			break;
+
+		/*
+		 * Doesn't have to use atomic_read(), but it doesn't
+		 * hurt either.
+		 */
+		ret = atomic_read(&sc->err);
+		if (ret)
+			break;
+	}
+
+	free_cpumask_var(packages);
+	return ret;
+}
+
 static int tdx_module_init_cpus(void)
 {
 	struct seamcall_ctx sc = { .fn = TDH_SYS_LP_INIT };
@@ -1096,6 +1136,21 @@ static int config_tdx_module(struct tdmr_info *tdmr_array, int tdmr_num,
 	return ret;
 }
 
+static int config_global_keyid(void)
+{
+	struct seamcall_ctx sc = { .fn = TDH_SYS_KEY_CONFIG };
+
+	/*
+	 * Configure the key of the global KeyID on all packages by
+	 * calling TDH.SYS.KEY.CONFIG on all packages.
+	 *
+	 * TDH.SYS.KEY.CONFIG may fail with entropy error (which is
+	 * a recoverable error).  Assume this is exceedingly rare and
+	 * just return error if encountered instead of retrying.
+	 */
+	return seamcall_on_each_package_serialized(&sc);
+}
+
 /*
  * Detect and initialize the TDX module.
  *
@@ -1159,15 +1214,39 @@ static int init_tdx_module(void)
 	if (ret)
 		goto out_free_pamts;
 
+	/*
+	 * Hardware doesn't guarantee cache coherency across different
+	 * KeyIDs.  The kernel needs to flush PAMT's dirty cachelines
+	 * (associated with KeyID 0) before the TDX module can use the
+	 * global KeyID to access the PAMT.  Given PAMTs are potentially
+	 * large (~1/256th of system RAM), just use WBINVD on all cpus
+	 * to flush the cache.
+	 *
+	 * Follow the TDX spec to flush cache before configuring the
+	 * global KeyID on all packages.
+	 */
+	wbinvd_on_all_cpus();
+
+	/* Config the key of global KeyID on all packages */
+	ret = config_global_keyid();
+	if (ret)
+		goto out_free_pamts;
+
 	/*
 	 * Return -EINVAL until all steps of TDX module initialization
 	 * process are done.
 	 */
 	ret = -EINVAL;
 out_free_pamts:
-	if (ret)
+	if (ret) {
+		/*
+		 * Part of PAMT may already have been initialized by
+		 * TDX module.  Flush cache before returning PAMT back
+		 * to the kernel.
+		 */
+		wbinvd_on_all_cpus();
 		tdmrs_free_pamt_all(tdmr_array, tdmr_num);
-	else
+	} else
 		pr_info("%lu pages allocated for PAMT.\n",
 				tdmrs_count_pamt_pages(tdmr_array, tdmr_num));
 out_free_tdmrs:
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index c26bab2555ca..768d097412ab 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -15,6 +15,7 @@
 /*
  * TDX module SEAMCALL leaf functions
  */
+#define TDH_SYS_KEY_CONFIG	31
 #define TDH_SYS_INFO		32
 #define TDH_SYS_INIT		33
 #define TDH_SYS_LP_INIT		35
-- 
2.37.3

