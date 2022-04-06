Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB95C4F6466
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 18:08:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236847AbiDFQGY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 12:06:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236964AbiDFQFz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 12:05:55 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A04A16249C;
        Tue,  5 Apr 2022 21:50:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649220656; x=1680756656;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eHwghcfLHXsMY9IOJjx34UuVcdIv13Ep0z+VBduV9pk=;
  b=CcSPUB7o0AZNDulqHZugGTedxNwb4TTc4vrpSxTIrjti9z6bF4ldcjV0
   sW8cfffmW0HiPgiMmphhuvn77CYyi1pDXNOj6ULgdGtzY2SwWlRVEUxVc
   uVolkxa5JFSrRFCv62lXMr0Uaf3x7cTUxqD23/DJH6gLMH7PnXxiKpf+z
   6N6/opq5GRnHFHodzKKWeC5cOQx5z9mNIsTLP+bd9Vu+dsmXk5tUgszzo
   FLCSfWlR0kJAJvNhPMehIXZdCbsqCEV/LphgTOwD1fPlH71LuWUG9P5Fc
   bFMMIeQwXYD1BdoewVpzyqO7DnEBrlMBTQFuunBs1TH+eTSvTHIAEFSGk
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10308"; a="243089880"
X-IronPort-AV: E=Sophos;i="5.90,239,1643702400"; 
   d="scan'208";a="243089880"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2022 21:50:44 -0700
X-IronPort-AV: E=Sophos;i="5.90,239,1643702400"; 
   d="scan'208";a="524302416"
Received: from dchang1-mobl3.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.29.17])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2022 21:50:40 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, dave.hansen@intel.com,
        len.brown@intel.com, tony.luck@intel.com,
        rafael.j.wysocki@intel.com, reinette.chatre@intel.com,
        dan.j.williams@intel.com, peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com, kai.huang@intel.com
Subject: [PATCH v3 15/21] x86/virt/tdx: Reserve TDX module global KeyID
Date:   Wed,  6 Apr 2022 16:49:27 +1200
Message-Id: <3e4929500a7b5bbaaf8ed23cde088172862acae0.1649219184.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1649219184.git.kai.huang@intel.com>
References: <cover.1649219184.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

TDX module initialization requires to use one TDX private KeyID as the
global KeyID to crypto protect TDX metadata.  The global KeyID is
configured to the TDX module along with TDMRs.

Just reserve the first TDX private KeyID as the global KeyID.

Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/virt/vmx/tdx/tdx.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index bf0d13644898..ecd65f7014e2 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -112,6 +112,9 @@ static struct cmr_info tdx_cmr_array[MAX_CMRS] __aligned(CMR_INFO_ARRAY_ALIGNMEN
 static int tdx_cmr_num;
 static struct tdsysinfo_struct tdx_sysinfo;
 
+/* TDX global KeyID to protect TDX metadata */
+static u32 tdx_global_keyid;
+
 static bool __seamrr_enabled(void)
 {
 	return (seamrr_mask & SEAMRR_ENABLED_BITS) == SEAMRR_ENABLED_BITS;
@@ -1320,6 +1323,12 @@ static int init_tdx_module(void)
 	if (ret)
 		goto out_free_tdmrs;
 
+	/*
+	 * Reserve the first TDX KeyID as global KeyID to protect
+	 * TDX module metadata.
+	 */
+	tdx_global_keyid = tdx_keyid_start;
+
 	/*
 	 * Return -EFAULT until all steps of TDX module
 	 * initialization are done.
-- 
2.35.1

