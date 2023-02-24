Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BE7C6A1729
	for <lists+kvm@lfdr.de>; Fri, 24 Feb 2023 08:28:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229938AbjBXH2Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Feb 2023 02:28:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjBXH2M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Feb 2023 02:28:12 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8890B36FF2;
        Thu, 23 Feb 2023 23:28:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677223680; x=1708759680;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CV81LNEfI5DBj7B7dwsrQlKANaQmTPQxLP8wnGG3SkY=;
  b=agcKIy8Sl8mC/QF6Trf1fSSSy2DlpGqKlqUnXgH8Vv8K8O/0JcH7ukrU
   LHa3LKNYqzJI2vMvgXjg2oOfbTdh90dJ4ufH8DvEpW0DsJdg/E77Ffwbs
   +VuoBDhTGhyHInY/MTPX2L+//LaD2In3fGLCEdxevMQMHMsndCap60dkY
   kar8WDwjp3YKuMI2PQoFy7KMSLDREgnD7AOMUNiy6zElWgUIoE3kEQNa7
   m4AcKDNcTUXVji7CpHkVLYsswM92U0m3ylyvp67RfkKwEZfEQs27cbI2P
   3+vh306TlNY3ZL7frA9Zyr4WxrO9w+56xk1/vxIvQQrScWJcn9d6weLA7
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10630"; a="334836002"
X-IronPort-AV: E=Sophos;i="5.97,324,1669104000"; 
   d="scan'208";a="334836002"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2023 23:27:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10630"; a="815639219"
X-IronPort-AV: E=Sophos;i="5.97,324,1669104000"; 
   d="scan'208";a="815639219"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by fmsmga001.fm.intel.com with ESMTP; 23 Feb 2023 23:27:21 -0800
From:   Xin Li <xin3.li@intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, peterz@infradead.org,
        andrew.cooper3@citrix.com, seanjc@google.com, pbonzini@redhat.com,
        ravi.v.shankar@intel.com
Subject: [RFC PATCH v3 11/32] x86/fred: if CONFIG_X86_FRED is disabled, disable FRED support
Date:   Thu, 23 Feb 2023 23:01:24 -0800
Message-Id: <20230224070145.3572-12-xin3.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230224070145.3572-1-xin3.li@intel.com>
References: <20230224070145.3572-1-xin3.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: "H. Peter Anvin (Intel)" <hpa@zytor.com>

Add CONFIG_X86_FRED to <asm/disabled-features.h> to make
cpu_feature_enabled() work correctly with FRED.

Originally-by: Megha Dey <megha.dey@intel.com>
Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
---
 arch/x86/include/asm/disabled-features.h       | 8 +++++++-
 tools/arch/x86/include/asm/disabled-features.h | 8 +++++++-
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/disabled-features.h b/arch/x86/include/asm/disabled-features.h
index 5dfa4fb76f4b..56838de9cb23 100644
--- a/arch/x86/include/asm/disabled-features.h
+++ b/arch/x86/include/asm/disabled-features.h
@@ -99,6 +99,12 @@
 # define DISABLE_TDX_GUEST	(1 << (X86_FEATURE_TDX_GUEST & 31))
 #endif
 
+#ifdef CONFIG_X86_FRED
+# define DISABLE_FRED 0
+#else
+# define DISABLE_FRED (1 << (X86_FEATURE_FRED & 31))
+#endif
+
 /*
  * Make sure to add features to the correct mask
  */
@@ -115,7 +121,7 @@
 #define DISABLED_MASK10	0
 #define DISABLED_MASK11	(DISABLE_RETPOLINE|DISABLE_RETHUNK|DISABLE_UNRET| \
 			 DISABLE_CALL_DEPTH_TRACKING)
-#define DISABLED_MASK12	0
+#define DISABLED_MASK12	(DISABLE_FRED)
 #define DISABLED_MASK13	0
 #define DISABLED_MASK14	0
 #define DISABLED_MASK15	0
diff --git a/tools/arch/x86/include/asm/disabled-features.h b/tools/arch/x86/include/asm/disabled-features.h
index c44b56f7ffba..2d3ec539dcc7 100644
--- a/tools/arch/x86/include/asm/disabled-features.h
+++ b/tools/arch/x86/include/asm/disabled-features.h
@@ -99,6 +99,12 @@
 # define DISABLE_TDX_GUEST	(1 << (X86_FEATURE_TDX_GUEST & 31))
 #endif
 
+#ifdef CONFIG_X86_FRED
+# define DISABLE_FRED 0
+#else
+# define DISABLE_FRED (1 << (X86_FEATURE_FRED & 31))
+#endif
+
 /*
  * Make sure to add features to the correct mask
  */
@@ -115,7 +121,7 @@
 #define DISABLED_MASK10	0
 #define DISABLED_MASK11	(DISABLE_RETPOLINE|DISABLE_RETHUNK|DISABLE_UNRET| \
 			 DISABLE_CALL_DEPTH_TRACKING)
-#define DISABLED_MASK12	0
+#define DISABLED_MASK12	(DISABLE_FRED)
 #define DISABLED_MASK13	0
 #define DISABLED_MASK14	0
 #define DISABLED_MASK15	0
-- 
2.34.1

