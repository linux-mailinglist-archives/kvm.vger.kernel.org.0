Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8F347A0050
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 11:38:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237430AbjINJi3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 05:38:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230413AbjINJiV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 05:38:21 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4541783;
        Thu, 14 Sep 2023 02:38:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694684297; x=1726220297;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RiRpO69NN4+D9BiPv1b8kqQ9mDIXR5b5ZIvKZMvuZW0=;
  b=Ip7QVM/FkJrJHMMsv18V7r/amDdzk2zjr6TL2+txRHNxr1Qfpaji8jGp
   ozOU1RHSoB2OtWrFCWQbpZAwc+j5KnX4q9GhcvGZ0++DhYsWQ/qXs4Rii
   7gTLkxuMUIwKCkY8KCvIQdQjf99xKvP4s81lGCs++llFM0Bkas2tE6uia
   try/Oqho+3WkPG5h0oA0eXRZzAa2qwjljKMNLEP/bhJK1YXnWdKPRU1hO
   8PtJaBuUz/8UbIHwQ7J8UgQenrIAJg+hcyZz1pBTEl9kCe+hGzWHEi9R5
   HP061Mg9fVqGBqrgY+wNuU1Wo0P8uzt4ZvH/vVKtFu/txAI/KTIdiAzrw
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="409857323"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="409857323"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2023 02:38:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="747656219"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="747656219"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2023 02:38:16 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     dave.hansen@intel.com, peterz@infradead.org, chao.gao@intel.com,
        rick.p.edgecombe@intel.com, weijiang.yang@intel.com,
        john.allen@amd.com
Subject: [PATCH v6 04/25] x86/fpu/xstate: Introduce kernel dynamic xfeature set
Date:   Thu, 14 Sep 2023 02:33:04 -0400
Message-Id: <20230914063325.85503-5-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230914063325.85503-1-weijiang.yang@intel.com>
References: <20230914063325.85503-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Define a new kernel xfeature set including the features can be dynamically
enabled, i.e., the relevant feature is enabled on demand. The xfeature set
is currently used by KVM to configure __guest__ fpstate, i.e., calculating
the xfeature and fpstate storage size etc. The xfeature set is initialized
once and used whenever it's referenced to avoid repeat calculation.

Currently it's used when 1) guest fpstate __state_size is calculated while
guest permits are configured 2) guest vCPU is created and its fpstate is
initialized.

Suggested-by: Dave Hansen <dave.hansen@intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kernel/fpu/xstate.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index c3ed86732d33..eaec05bc1b3c 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -84,6 +84,8 @@ static unsigned int xstate_sizes[XFEATURE_MAX] __ro_after_init =
 	{ [ 0 ... XFEATURE_MAX - 1] = -1};
 static unsigned int xstate_flags[XFEATURE_MAX] __ro_after_init;
 
+u64 fpu_kernel_dynamic_xfeatures __ro_after_init;
+
 #define XSTATE_FLAG_SUPERVISOR	BIT(0)
 #define XSTATE_FLAG_ALIGNED64	BIT(1)
 
@@ -740,6 +742,23 @@ static void __init fpu__init_disable_system_xstate(unsigned int legacy_size)
 	fpstate_reset(&current->thread.fpu);
 }
 
+static unsigned short xsave_kernel_dynamic_xfeatures[] = {
+	[XFEATURE_CET_KERNEL]	= X86_FEATURE_SHSTK,
+};
+
+static void __init init_kernel_dynamic_xfeatures(void)
+{
+	unsigned short cid;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(xsave_kernel_dynamic_xfeatures); i++) {
+		cid = xsave_kernel_dynamic_xfeatures[i];
+
+		if (cid && boot_cpu_has(cid))
+			fpu_kernel_dynamic_xfeatures |= BIT_ULL(i);
+	}
+}
+
 /*
  * Enable and initialize the xsave feature.
  * Called once per system bootup.
@@ -809,6 +828,8 @@ void __init fpu__init_system_xstate(unsigned int legacy_size)
 	if (boot_cpu_has(X86_FEATURE_SHSTK) || boot_cpu_has(X86_FEATURE_IBT))
 		fpu_kernel_cfg.max_features |= BIT_ULL(XFEATURE_CET_USER);
 
+	init_kernel_dynamic_xfeatures();
+
 	if (!cpu_feature_enabled(X86_FEATURE_XFD))
 		fpu_kernel_cfg.max_features &= ~XFEATURE_MASK_USER_DYNAMIC;
 
-- 
2.27.0

