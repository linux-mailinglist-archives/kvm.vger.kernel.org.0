Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B2096317C1
	for <lists+kvm@lfdr.de>; Mon, 21 Nov 2022 01:31:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229938AbiKUAbD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 20 Nov 2022 19:31:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229929AbiKUAa2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 20 Nov 2022 19:30:28 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E65991E708;
        Sun, 20 Nov 2022 16:28:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668990537; x=1700526537;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jIBcb5cVMwmxp99dDnDGXF9eYbfG3mWlVut9+yUNmLc=;
  b=T3Vg7vCuQSdz5CNeHk1ybLQkedvecjgDu3L+33rOOaE5zbN81zHyls4w
   0MA6UySZb7sSsoOTizQ1K5mRux81qCxeK2w7PmjjP75Y/lTk0ufiL0u3n
   5oNBKyc02m+uPl88OI0g4kuN0eljC7TI1LqU+Rpsi2+gu3ewvg4Kh3uHJ
   JqnOIlqaiM0KsZzJe6IjNhhfJ1Odw5cWf8pkN2C7Eofb74ihh5ejkoWUV
   Pe2eStsG3Z4pwxbNBRuatz/am5jBL003yO3nOaw1MT/7IMbgxZTbLOGi4
   ibrn2GKqMWx6v6fHsSc1a9OFiQlTzqL9iNhSBmGW+QXlYUkBvlF5jAEdc
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10537"; a="377705756"
X-IronPort-AV: E=Sophos;i="5.96,180,1665471600"; 
   d="scan'208";a="377705756"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2022 16:28:09 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10537"; a="729825533"
X-IronPort-AV: E=Sophos;i="5.96,180,1665471600"; 
   d="scan'208";a="729825533"
Received: from tomnavar-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.209.176.15])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2022 16:28:05 -0800
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
Subject: [PATCH v7 17/20] x86/virt/tdx: Configure global KeyID on all packages
Date:   Mon, 21 Nov 2022 13:26:39 +1300
Message-Id: <8d8285cc5efa6302cf42a3fe2c9153d1a9dbcdac.1668988357.git.kai.huang@intel.com>
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

Note if any TDH.SYS.KEY.CONFIG fails, the TDX module may already have
used the global KeyID to write any PAMT.  Therefore, need to use WBINVD
to flush cache before freeing the PAMTs back to the kernel.  Note using
MOVDIR64B (which changes the page's associated KeyID from the old TDX
private KeyID back to KeyID 0, which is used by the kernel) to clear
PMATs isn't needed, as the KeyID 0 doesn't support integrity check.

Reviewed-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
---

v6 -> v7:
 - Improved changelong and comment to explain why MOVDIR64B isn't used
   when returning PAMTs back to the kernel.

---
 arch/x86/virt/vmx/tdx/tdx.c | 89 ++++++++++++++++++++++++++++++++++++-
 arch/x86/virt/vmx/tdx/tdx.h |  1 +
 2 files changed, 88 insertions(+), 2 deletions(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 3a032930e58a..99d1be5941a7 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -224,6 +224,46 @@ static void seamcall_on_each_cpu(struct seamcall_ctx *sc)
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
@@ -1010,6 +1050,22 @@ static int config_tdx_module(struct tdmr_info *tdmr_array, int tdmr_num,
 	return ret;
 }
 
+static int config_global_keyid(void)
+{
+	struct seamcall_ctx sc = { .fn = TDH_SYS_KEY_CONFIG };
+
+	/*
+	 * Configure the key of the global KeyID on all packages by
+	 * calling TDH.SYS.KEY.CONFIG on all packages in a serialized
+	 * way as it cannot run concurrently on different CPUs.
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
@@ -1098,15 +1154,44 @@ static int init_tdx_module(void)
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
+		 *
+		 * Note there's no need to do MOVDIR64B (which changes
+		 * the page's associated KeyID from the old TDX private
+		 * KeyID back to KeyID 0, which is used by the kernel),
+		 * as KeyID 0 doesn't support integrity check.
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
2.38.1

