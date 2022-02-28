Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 405F54C60E9
	for <lists+kvm@lfdr.de>; Mon, 28 Feb 2022 03:16:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232542AbiB1CPt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 27 Feb 2022 21:15:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232469AbiB1CPf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 27 Feb 2022 21:15:35 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD61354FA9;
        Sun, 27 Feb 2022 18:14:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646014497; x=1677550497;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/QmiEMPw2IIicAjmLMzTawZr+TBnOGP5WhdAWSgfHeE=;
  b=lhNZc7nnKdBXxMKpzGWmrhWpC65EGRCy3oY7ZOEiYnBDWo3dEawCzpn6
   q0K8jCBHkXKv+loiTCUFIYE0T/LWBt+5RE8JHIGHgF/y379mZKjU5gNYO
   /M9etMovZ0gDSPgIWhbf3x1QYpnm5cj9CG81lSFMErWfEDkrw2EWDFT3L
   N98j+DlalxsT8rIlupnSPMQCjFxrxse6kk+uKU5arq6nEYJlJoFoPOxoj
   AfKrLGUTuYz0KatWIAdM8DADfN+RFGSzmOgYuujsjz+ZaHZUIdK3v/90Y
   L1lhlH0NwFFjAKnVpo49LQfCuFQqOVH0ELI0XiSdCgoV8XyHJoadT10Zm
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10271"; a="240191969"
X-IronPort-AV: E=Sophos;i="5.90,142,1643702400"; 
   d="scan'208";a="240191969"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2022 18:14:52 -0800
X-IronPort-AV: E=Sophos;i="5.90,142,1643702400"; 
   d="scan'208";a="777936972"
Received: from jdpanhor-mobl2.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.49.36])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2022 18:14:48 -0800
From:   Kai Huang <kai.huang@intel.com>
To:     x86@kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@intel.com, luto@kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com, seanjc@google.com, hpa@zytor.com,
        peterz@infradead.org, kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, tony.luck@intel.com,
        ak@linux.intel.com, dan.j.williams@intel.com,
        chang.seok.bae@intel.com, keescook@chromium.org,
        hengqi.arch@bytedance.com, laijs@linux.alibaba.com,
        metze@samba.org, linux-kernel@vger.kernel.org, kai.huang@intel.com
Subject: [RFC PATCH 16/21] x86/virt/tdx: Configure TDX module with TDMRs and global KeyID
Date:   Mon, 28 Feb 2022 15:13:04 +1300
Message-Id: <50bee01627c6cfe0a1f53058c41fa775762be035.1646007267.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1646007267.git.kai.huang@intel.com>
References: <cover.1646007267.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index e6c54b2a1f6e..008628674a2f 100644
--- a/arch/x86/virt/vmx/tdx.c
+++ b/arch/x86/virt/vmx/tdx.c
@@ -1203,6 +1203,42 @@ static int construct_tdmrs(struct tdmr_info **tdmr_array, int *tdmr_num)
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
@@ -1248,11 +1284,17 @@ static int init_tdx_module(void)
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
2.33.1

