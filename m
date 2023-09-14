Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C5FB79FBED
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 08:28:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235530AbjING2y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 02:28:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235408AbjING2s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 02:28:48 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0981DF7;
        Wed, 13 Sep 2023 23:28:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694672924; x=1726208924;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7cLERNq1vvTBAZ52sQIMEUGAduSmp4Knqxddo4MpnMo=;
  b=DddmQyhubC1R3xKiHIgjXIR7wenWJqr4gRkwV+FSCBn73jBhi6JT/cUy
   /cMsKpy7z70H1xrIRu4ADXqmIP6ShbBA4O/o++Sb0W1iDKsLdv1Hm4qn1
   JrQ7hhUB153MMKcyXqiX2jc/dERZOHBpSpW6r5d9huFZh1o+kNo50Zg0k
   hguStWWyKCHKkzhWLrR4gDF3wl9pifHECJmAcKJ658HhnE2GIXzWLydTf
   xrwoCjSaz7n7+H7pTKxk1YQqOhjui4n9qJplp0vp6fPv8NeAuB9bROjST
   YXHYBuDTxHBfFlBVCX0OwlslHXx/TveCd2bQJ+iZpJsRaMV1gk0v2ImMs
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="382672461"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="382672461"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 23:28:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="809937990"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="809937990"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 23:28:42 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org
Cc:     dave.hansen@intel.com, tglx@linutronix.de, peterz@infradead.org,
        seanjc@google.com, pbonzini@redhat.com, rick.p.edgecombe@intel.com,
        kvm@vger.kernel.org, yang.zhong@intel.com, jing2.liu@intel.com,
        chao.gao@intel.com, Yang Weijiang <weijiang.yang@intel.com>
Subject: [RFC PATCH 5/8] x86/fpu/xstate: Remove kernel dynamic xfeatures from kernel default_features
Date:   Wed, 13 Sep 2023 23:23:31 -0400
Message-Id: <20230914032334.75212-6-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230914032334.75212-1-weijiang.yang@intel.com>
References: <20230914032334.75212-1-weijiang.yang@intel.com>
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

