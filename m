Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DDC46317AB
	for <lists+kvm@lfdr.de>; Mon, 21 Nov 2022 01:28:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229842AbiKUA2J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 20 Nov 2022 19:28:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbiKUA1b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 20 Nov 2022 19:27:31 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D37B0B63;
        Sun, 20 Nov 2022 16:27:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668990449; x=1700526449;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gOZ0T77u1owzOZnOoSrcaq1f36vBbh2UkFPGd0zudQU=;
  b=fshP4RzAcPivCZj9voHBLtObrFqIdBHHUw6YCKJkzpzrfb70Yrw2mXjE
   GRC4x/1V1l3HBSczukuhLob81yms3MdDjLnOBta40Jm9mIEmGC3WFsixG
   gaBWVH18haj7xzbaoLGuoroMNq3P1wfngG4XHZhgkmMhkM5YUhrkE6SUk
   8Phd6FJ4CWaIuuQWBnkSdCXL+1CYhqGEG9l3Pab1Aq2pWvdS3LaeCLK/h
   OhVJSZyEiNhVKv/JMvwiuDQI1fSSMpgbvkfIm+7gdriBlxT7R0FuiXcf+
   qd6nh8tF4LjhwxleTUe99zV16JyPrn8KNtqpdZh7h1ofJpwV7A9U4miJ9
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10537"; a="399732315"
X-IronPort-AV: E=Sophos;i="5.96,180,1665471600"; 
   d="scan'208";a="399732315"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2022 16:27:29 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10537"; a="729825319"
X-IronPort-AV: E=Sophos;i="5.96,180,1665471600"; 
   d="scan'208";a="729825319"
Received: from tomnavar-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.209.176.15])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2022 16:27:25 -0800
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
Subject: [PATCH v7 08/20] x86/virt/tdx: Do logical-cpu scope TDX module initialization
Date:   Mon, 21 Nov 2022 13:26:30 +1300
Message-Id: <083f32ce0721611b7fc9297641cc8f5f222b937e.1668988357.git.kai.huang@intel.com>
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

After the global module initialization, the next step is logical-cpu
scope module initialization.  Logical-cpu initialization requires
calling TDH.SYS.LP.INIT on all BIOS-enabled CPUs.  This SEAMCALL can run
concurrently on all CPUs.

Use the helper introduced for shutting down the module to do logical-cpu
scope initialization.

Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/virt/vmx/tdx/tdx.c | 14 ++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h |  1 +
 2 files changed, 15 insertions(+)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index f292292313bd..2cf7090667aa 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -199,6 +199,15 @@ static void seamcall_on_each_cpu(struct seamcall_ctx *sc)
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
@@ -218,6 +227,11 @@ static int init_tdx_module(void)
 	if (ret)
 		goto out;
 
+	/* Logical-cpu scope initialization */
+	ret = tdx_module_init_cpus();
+	if (ret)
+		goto out;
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
2.38.1

