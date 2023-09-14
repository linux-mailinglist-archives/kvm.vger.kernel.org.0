Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A9E07A0051
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 11:38:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237382AbjINJib (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 05:38:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236923AbjINJiV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 05:38:21 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B73C71BEF;
        Thu, 14 Sep 2023 02:38:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694684297; x=1726220297;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7cLERNq1vvTBAZ52sQIMEUGAduSmp4Knqxddo4MpnMo=;
  b=Q+uN2PFZ/YM49u3guS8f3wncn9EMDc7BCIpgsnE3evehRTkaNepQ0zmH
   f34zdTgtYxzFtHv0Y8T/GWvGSGVvT1ovgPoFXVGY7HKxPjLcFbKcWRlUu
   tlMNJmrTcUHfY0puW2k6Y4jM/8S8eMWY0pXt0zdnQBCatoS34nrrOYrIF
   uIEw3SNKvIWYDdfR9soCrRlXnG8s9jjsP3FBJshzRgyrPnOt7I6DTlhg2
   VgvkKTwUyJyFcCULM6MwzlZtLhBgxMwf/9UYgkFWlc2klZ4HJ7eMl53qv
   nXzxhvtgedBuLfp3zWc3vxYCstuTlemyS6flDUf5W8HAjC6Ap+dijOrAG
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="409857328"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="409857328"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2023 02:38:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="747656226"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="747656226"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2023 02:38:16 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     dave.hansen@intel.com, peterz@infradead.org, chao.gao@intel.com,
        rick.p.edgecombe@intel.com, weijiang.yang@intel.com,
        john.allen@amd.com
Subject: [PATCH v6 05/25] x86/fpu/xstate: Remove kernel dynamic xfeatures from kernel default_features
Date:   Thu, 14 Sep 2023 02:33:05 -0400
Message-Id: <20230914063325.85503-6-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230914063325.85503-1-weijiang.yang@intel.com>
References: <20230914063325.85503-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The kernel dynamic xfeatures are supported by host, i.e., they're enabled
in xsaves/xrstors operating xfeature set (XCR0 | XSS), but the corresponding
CPU features are disabled for the time-being in host kernel so the bits are
not necessarily set by default.

Remove the bits from fpu_kernel_cfg.default_features so that the bits in
xstate_bv and xcomp_bv are cleared and xsaves/xrstors can be optimized by HW
for normal fpstate.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kernel/fpu/xstate.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index eaec05bc1b3c..4753c677e2e1 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -845,6 +845,7 @@ void __init fpu__init_system_xstate(unsigned int legacy_size)
 	/* Clean out dynamic features from default */
 	fpu_kernel_cfg.default_features = fpu_kernel_cfg.max_features;
 	fpu_kernel_cfg.default_features &= ~XFEATURE_MASK_USER_DYNAMIC;
+	fpu_kernel_cfg.default_features &= ~fpu_kernel_dynamic_xfeatures;
 
 	fpu_user_cfg.default_features = fpu_user_cfg.max_features;
 	fpu_user_cfg.default_features &= ~XFEATURE_MASK_USER_DYNAMIC;
-- 
2.27.0

