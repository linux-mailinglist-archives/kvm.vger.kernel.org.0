Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E6BC4D7479
	for <lists+kvm@lfdr.de>; Sun, 13 Mar 2022 11:52:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233111AbiCMKxN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Mar 2022 06:53:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232306AbiCMKwq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Mar 2022 06:52:46 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 734821255AC;
        Sun, 13 Mar 2022 03:51:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647168669; x=1678704669;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+k8+ff3MZT0dZaurFb5N+16+FvSx0d0LIcCmcswxmYM=;
  b=Dm34jHGF57eBvtNhZCsR6gc2XCMCKuejuyNOr/cgJbjC9cc/GfxcBbi0
   WnkLQdqTJwlWFJM3A/YH9yjUYgr97DR/28w3QHtVuZoYaNVKY5uMWsSYc
   Z6vxfp6oHAiBq/88RI3/aK6fTwcpvCVA4ZohnGM+nnJlMjINrBAN37qve
   WV+YxRf+lKOscJwaxgEeNcGndrPAoEmaYRQr5K2+g6eetYMlwqQP47s98
   QU399hETOvn7f5O7E0dqtJWFLeR0lS/sUo+Z04fzxUQbJlv0i8dgehVPf
   i/lgCRCif2VkYZZ1IJZh8OcMW8pRv94xk1X62zCQYg9y0mHxEhMlnDgRT
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10284"; a="254689549"
X-IronPort-AV: E=Sophos;i="5.90,178,1643702400"; 
   d="scan'208";a="254689549"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2022 03:51:00 -0700
X-IronPort-AV: E=Sophos;i="5.90,178,1643702400"; 
   d="scan'208";a="645448184"
Received: from mvideche-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.251.130.249])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2022 03:50:56 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     dave.hansen@intel.com, seanjc@google.com, pbonzini@redhat.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, peterz@infradead.org,
        tony.luck@intel.com, ak@linux.intel.com, dan.j.williams@intel.com,
        isaku.yamahata@intel.com, kai.huang@intel.com
Subject: [PATCH v2 15/21] x86/virt/tdx: Reserve TDX module global KeyID
Date:   Sun, 13 Mar 2022 23:49:55 +1300
Message-Id: <9166c08562dd141d4fce552725664a245cdbd34c.1647167475.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1647167475.git.kai.huang@intel.com>
References: <cover.1647167475.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
 arch/x86/virt/vmx/tdx.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/x86/virt/vmx/tdx.c b/arch/x86/virt/vmx/tdx.c
index f6345af29414..f70eee7df0c1 100644
--- a/arch/x86/virt/vmx/tdx.c
+++ b/arch/x86/virt/vmx/tdx.c
@@ -112,6 +112,9 @@ static struct cmr_info tdx_cmr_array[MAX_CMRS] __aligned(CMR_INFO_ARRAY_ALIGNMEN
 static int tdx_cmr_num;
 static struct tdsysinfo_struct tdx_sysinfo;
 
+/* TDX global KeyID to protect TDX metadata */
+static u32 tdx_global_keyid;
+
 static bool __seamrr_enabled(void)
 {
 	return (seamrr_mask & SEAMRR_ENABLED_BITS) == SEAMRR_ENABLED_BITS;
@@ -1316,6 +1319,12 @@ static int init_tdx_module(void)
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

