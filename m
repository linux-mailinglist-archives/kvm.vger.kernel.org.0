Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B6F94D747C
	for <lists+kvm@lfdr.de>; Sun, 13 Mar 2022 11:52:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232753AbiCMKxw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Mar 2022 06:53:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233163AbiCMKwr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Mar 2022 06:52:47 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66FD31255A0;
        Sun, 13 Mar 2022 03:51:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647168669; x=1678704669;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6ZRv+WOPesQ1kchQgRV/AzyEwsvdCFvGUJKYSSVphAA=;
  b=EWvTbwZqQ16UT2iSyTaISXWY5r2bYhqqe/GY8bU9qes1/Dff6uCkrjro
   HQJ+NinjD8KoIKqmheUo5KmUrJaRrks+W6nWvRVD3+aH3GHiI6KZ70LcT
   n+GKKjdTY68x4jCtcDnVpgdwLN79mQ0d1i4XgN3aYyng5uNRd0idJ2Svc
   HEZ3RBvMgFC03uUqawAwZ1WbPcBLh/YCw8r7G0l8ET+9KM+Yibiq4ybWr
   G7QiJ+GMWzqpSKf+G2QmH6W5Csgb9qEWRQLtOTR9z6Vjbqx6rr51hi6BC
   YtM4Hdy5GjdTRiqgVfA25OBlpB5zkom88CsDmfNwKi0ZS4MMl54if+w9q
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10284"; a="255590702"
X-IronPort-AV: E=Sophos;i="5.90,178,1643702400"; 
   d="scan'208";a="255590702"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2022 03:51:03 -0700
X-IronPort-AV: E=Sophos;i="5.90,178,1643702400"; 
   d="scan'208";a="645448202"
Received: from mvideche-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.251.130.249])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2022 03:50:59 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     dave.hansen@intel.com, seanjc@google.com, pbonzini@redhat.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, peterz@infradead.org,
        tony.luck@intel.com, ak@linux.intel.com, dan.j.williams@intel.com,
        isaku.yamahata@intel.com, kai.huang@intel.com
Subject: [PATCH v2 16/21] x86/virt/tdx: Configure TDX module with TDMRs and global KeyID
Date:   Sun, 13 Mar 2022 23:49:56 +1300
Message-Id: <52f8123ee1028549e1207b1582f00737c42ef2c2.1647167475.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1647167475.git.kai.huang@intel.com>
References: <cover.1647167475.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

After the TDX usable memory regions are constructed in an array of TDMRs
and the global KeyID is reserved, configure them to the TDX module.  The
configuration is done via TDH.SYS.CONFIG, which is one call and can be
done on any logical cpu.

Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/virt/vmx/tdx.c | 42 +++++++++++++++++++++++++++++++++++++++++
 arch/x86/virt/vmx/tdx.h |  2 ++
 2 files changed, 44 insertions(+)

diff --git a/arch/x86/virt/vmx/tdx.c b/arch/x86/virt/vmx/tdx.c
index f70eee7df0c1..e03dc3e420db 100644
--- a/arch/x86/virt/vmx/tdx.c
+++ b/arch/x86/virt/vmx/tdx.c
@@ -1280,6 +1280,42 @@ static int construct_tdmrs(struct tdmr_info **tdmr_array, int *tdmr_num)
 	return ret;
 }
 
+static int config_tdx_module(struct tdmr_info **tdmr_array, int tdmr_num,
+			     u64 global_keyid)
+{
+	u64 *tdmr_pa_array;
+	int i, array_sz;
+	int ret;
+
+	/*
+	 * TDMR_INFO entries are configured to the TDX module via an
+	 * array of the physical address of each TDMR_INFO.  TDX requires
+	 * the array itself must be 512 aligned.  Round up the array size
+	 * to 512 aligned so the buffer allocated by kzalloc() meets the
+	 * alignment requirement.
+	 */
+	array_sz = ALIGN(tdmr_num * sizeof(u64), TDMR_INFO_PA_ARRAY_ALIGNMENT);
+	tdmr_pa_array = kzalloc(array_sz, GFP_KERNEL);
+	if (!tdmr_pa_array)
+		return -ENOMEM;
+
+	for (i = 0; i < tdmr_num; i++)
+		tdmr_pa_array[i] = __pa(tdmr_array[i]);
+
+	/*
+	 * TDH.SYS.CONFIG fails when TDH.SYS.LP.INIT is not done on all
+	 * BIOS-enabled cpus.  tdx_init() only disables CPU hotplug but
+	 * doesn't do early check whether all BIOS-enabled cpus are
+	 * online, so TDH.SYS.CONFIG can fail here.
+	 */
+	ret = seamcall(TDH_SYS_CONFIG, __pa(tdmr_pa_array), tdmr_num,
+				global_keyid, 0, NULL, NULL);
+	/* Free the array as it is not required any more. */
+	kfree(tdmr_pa_array);
+
+	return ret;
+}
+
 static int init_tdx_module(void)
 {
 	struct tdmr_info **tdmr_array;
@@ -1325,11 +1361,17 @@ static int init_tdx_module(void)
 	 */
 	tdx_global_keyid = tdx_keyid_start;
 
+	/* Config the TDX module with TDMRs and global KeyID */
+	ret = config_tdx_module(tdmr_array, tdmr_num, tdx_global_keyid);
+	if (ret)
+		goto out_free_pamts;
+
 	/*
 	 * Return -EFAULT until all steps of TDX module
 	 * initialization are done.
 	 */
 	ret = -EFAULT;
+out_free_pamts:
 	/*
 	 * Free PAMTs allocated in construct_tdmrs() when TDX module
 	 * initialization fails.
diff --git a/arch/x86/virt/vmx/tdx.h b/arch/x86/virt/vmx/tdx.h
index 05bf9fe6bd00..d8e2800397af 100644
--- a/arch/x86/virt/vmx/tdx.h
+++ b/arch/x86/virt/vmx/tdx.h
@@ -95,6 +95,7 @@ struct tdmr_reserved_area {
 } __packed;
 
 #define TDMR_INFO_ALIGNMENT	512
+#define TDMR_INFO_PA_ARRAY_ALIGNMENT	512
 
 struct tdmr_info {
 	u64 base;
@@ -125,6 +126,7 @@ struct tdmr_info {
 #define TDH_SYS_INIT		33
 #define TDH_SYS_LP_INIT		35
 #define TDH_SYS_LP_SHUTDOWN	44
+#define TDH_SYS_CONFIG		45
 
 struct tdx_module_output;
 u64 __seamcall(u64 fn, u64 rcx, u64 rdx, u64 r8, u64 r9,
-- 
2.35.1

