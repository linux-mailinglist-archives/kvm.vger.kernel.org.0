Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D83BA6317BD
	for <lists+kvm@lfdr.de>; Mon, 21 Nov 2022 01:30:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230085AbiKUAae (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 20 Nov 2022 19:30:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229969AbiKUAaR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 20 Nov 2022 19:30:17 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 201F867F70;
        Sun, 20 Nov 2022 16:28:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668990532; x=1700526532;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=p0XEmMAPhmR4juGNDpcaQB3QmsMbWYRHbmAUiytIe9Q=;
  b=ma7P+Uxg39RKNUwrsWoY+bqQiG5MOmBc4gVwlymDrjwSynKviTHVM8Pe
   2cd+JqzbPweC0mB0m8tZPB3baogCrTDYSIeHvkRQ1CV7BNIJi3TVhxkxa
   11In/vaoaE913S3BTp4P5g8sHzUxuFxNt3gMZ8JbpuT8SYNEKwjBQo0hO
   +zZf1FCDptI8PVK5+noakrN0TI9XlKpUVBJ3fEkF86WH7BV7SeVIntsSm
   rTTewheaMf9ynHxtdOM3PyrMOkFCDJ5aVA9KNVxy1YgRR0I+lPQBF8p7Q
   rJ1ieBHOxQ1/WI+qFGm9EH78+MeAoDyLnshym4d9O+eY9Fuh5VGEWLqPz
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10537"; a="377705750"
X-IronPort-AV: E=Sophos;i="5.96,180,1665471600"; 
   d="scan'208";a="377705750"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2022 16:28:00 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10537"; a="729825498"
X-IronPort-AV: E=Sophos;i="5.96,180,1665471600"; 
   d="scan'208";a="729825498"
Received: from tomnavar-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.209.176.15])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2022 16:27:56 -0800
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
Subject: [PATCH v7 15/20] x86/virt/tdx: Reserve TDX module global KeyID
Date:   Mon, 21 Nov 2022 13:26:37 +1300
Message-Id: <fec007c0193e5f0509450de78052346da1045b23.1668988357.git.kai.huang@intel.com>
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
index 1fbf33f2f210..e2cbeeb7f0dc 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -62,6 +62,9 @@ static int tdx_cmr_num;
 /* All TDX-usable memory regions */
 static LIST_HEAD(tdx_memlist);
 
+/* TDX module global KeyID.  Used in TDH.SYS.CONFIG ABI. */
+static u32 tdx_global_keyid;
+
 /*
  * Detect TDX private KeyIDs to see whether TDX has been enabled by the
  * BIOS.  Both initializing the TDX module and running TDX guest require
@@ -1053,6 +1056,12 @@ static int init_tdx_module(void)
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
2.38.1

