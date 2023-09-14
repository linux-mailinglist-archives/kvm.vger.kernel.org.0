Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2592E7A0053
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 11:38:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237299AbjINJid (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 05:38:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237227AbjINJiW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 05:38:22 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAA1183;
        Thu, 14 Sep 2023 02:38:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694684297; x=1726220297;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kg4jzy9ndQH5j3Qk6jXnrqWtPLjorVO+dQ5iT2oQlDE=;
  b=j0grAlD2pHYOmxYjCnQHRCMwsVtmyClUbLyGPRyq61a+SP2H/yjGsE/e
   Iq947Qgze9ZvHh7VOZR2AYmwKK9tSiGTtfXJFyfKOCpeai4H9a73RaLox
   aWhiF4ZrlWjwb0DMC9tgR4b8Q+wqPwbFuKciTy3dB/lfP9uwd8hBO4UqO
   LrjUO8yXGijYUU33rCi6tTXalk6rX8f2jW37LfALgg3/q6rRDFKsPl43f
   UhyQPpevr3nSg3AV9uIVUfWshaB0+Yq9ULiDcafit3O6ihJObR79VPah/
   HJPLbhaaH+hYgJDGCE+s7TYryHBdC9DUTmZLoVXhsWBBqBIFZLaYyY9zg
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="409857335"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="409857335"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2023 02:38:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="747656229"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="747656229"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2023 02:38:17 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     dave.hansen@intel.com, peterz@infradead.org, chao.gao@intel.com,
        rick.p.edgecombe@intel.com, weijiang.yang@intel.com,
        john.allen@amd.com
Subject: [PATCH v6 06/25] x86/fpu/xstate: Opt-in kernel dynamic bits when calculate guest xstate size
Date:   Thu, 14 Sep 2023 02:33:06 -0400
Message-Id: <20230914063325.85503-7-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230914063325.85503-1-weijiang.yang@intel.com>
References: <20230914063325.85503-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When user space requests guest xstate permits, the sufficient xstate size
is calculated from permitted mask. Currently the max guest permits are set
to fpu_kernel_cfg.default_features, and the latter doesn't include kernel
dynamic xfeatures, so add them back for correct guest fpstate size.

If guest dynamic xfeatures are enabled, KVM re-allocates guest fpstate area
with above resulting size before launches VM.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kernel/fpu/xstate.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index 4753c677e2e1..c5d903b4df4d 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -1636,9 +1636,17 @@ static int __xstate_request_perm(u64 permitted, u64 requested, bool guest)
 
 	/* Calculate the resulting kernel state size */
 	mask = permitted | requested;
-	/* Take supervisor states into account on the host */
+	/*
+	 * Take supervisor states into account on the host. And add
+	 * kernel dynamic xfeatures to guest since guest kernel may
+	 * enable corresponding CPU feaures and the xstate registers
+	 * need to be saved/restored properly.
+	 */
 	if (!guest)
 		mask |= xfeatures_mask_supervisor();
+	else
+		mask |= fpu_kernel_dynamic_xfeatures;
+
 	ksize = xstate_calculate_size(mask, compacted);
 
 	/* Calculate the resulting user state size */
-- 
2.27.0

