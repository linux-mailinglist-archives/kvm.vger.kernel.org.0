Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E82260EC38
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 01:19:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234309AbiJZXTb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Oct 2022 19:19:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234068AbiJZXSw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Oct 2022 19:18:52 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC5B5C8958;
        Wed, 26 Oct 2022 16:18:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666826287; x=1698362287;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=B9+BH03JuRueFuPcbZL8eGNw4YMtDKBJepkCjrMD21g=;
  b=PrTdKCn93unGu6SccpXW9Xme3pjAgZ+QJ4aISJotCNoaMWSMr+V+1IFY
   GbAdAlJkiTdS3Eeh5/LGaM7jf4mBfL+wgk0t8QCNP7E7ztN0FOLdkgYfz
   IK8sqBa8jKTQoswzInW68nDgRpxmxk86kvsS/kPhvSy8LvXYuX6UaoNrw
   M8vIW8aU5LeAmNczP71UCVHJc3H4v2nn5/t8zOd7eXC8hV7ZZZW3WRPRM
   bYdevSKXm6+fciD/m649b4d9QqxCD3eL0UarlQhey9n1xUbYOk3jLYp2H
   /XCE0nYNhZKQhx6ruSgf8LmXviJlhsKNj2Z/3sHccbHcU6TcAYE+R3Fwc
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="309175633"
X-IronPort-AV: E=Sophos;i="5.95,215,1661842800"; 
   d="scan'208";a="309175633"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2022 16:18:06 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="737446496"
X-IronPort-AV: E=Sophos;i="5.95,215,1661842800"; 
   d="scan'208";a="737446496"
Received: from fordon1x-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.24.177])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2022 16:18:02 -0700
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
Subject: [PATCH v6 16/21] x86/virt/tdx: Reserve TDX module global KeyID
Date:   Thu, 27 Oct 2022 12:16:15 +1300
Message-Id: <7558961d3dff6311c7872f57ac5bd6727f21e140.1666824663.git.kai.huang@intel.com>
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

TDX module initialization requires to use one TDX private KeyID as the
global KeyID to protect the TDX module metadata.  The global KeyID is
configured to the TDX module along with TDMRs.

Just reserve the first TDX private KeyID as the global KeyID.  Keep the
global KeyID as a static variable as KVM will need to use it too.

Reviewed-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/virt/vmx/tdx/tdx.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 5d74ada072ca..0820ba781f97 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -62,6 +62,9 @@ static struct tdsysinfo_struct tdx_sysinfo;
 static struct cmr_info tdx_cmr_array[MAX_CMRS] __aligned(CMR_INFO_ARRAY_ALIGNMENT);
 static int tdx_cmr_num;
 
+/* TDX module global KeyID.  Used in TDH.SYS.CONFIG ABI. */
+static u32 tdx_global_keyid;
+
 /*
  * Detect TDX private KeyIDs to see whether TDX has been enabled by the
  * BIOS.  Both initializing the TDX module and running TDX guest require
@@ -1113,6 +1116,12 @@ static int init_tdx_module(void)
 	if (ret)
 		goto out_free_tdmrs;
 
+	/*
+	 * Reserve the first TDX KeyID as global KeyID to protect
+	 * TDX module metadata.
+	 */
+	tdx_global_keyid = tdx_keyid_start;
+
 	/*
 	 * Return -EINVAL until all steps of TDX module initialization
 	 * process are done.
-- 
2.37.3

