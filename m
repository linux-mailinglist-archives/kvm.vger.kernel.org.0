Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AFA479FBEE
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 08:28:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235548AbjING2z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 02:28:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235411AbjING2s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 02:28:48 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FCEBF9;
        Wed, 13 Sep 2023 23:28:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694672924; x=1726208924;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kg4jzy9ndQH5j3Qk6jXnrqWtPLjorVO+dQ5iT2oQlDE=;
  b=dyyBO5i0YubFNjkr5xUeIVfW/RTxmsNv+smF/gQFoyXYvGjquQ8ikW9c
   lu8Wo4JX09VUdX7N+9MWZNCdgHD9BQ0DnMif7eQ1JdFtyRGxfLRKexkz5
   E91+0Gp9qT/pSRuRh7Qz1Rl1qy0Q6/gKAld6FFMz9l3SDBIAQXiDqrj1R
   41cXPfUEQQWwK8F4oyFRMmvBqoD2GmUCob+jz/FEmLH3S2TXketA/oe9x
   REkkJ4VhwI1sklm8oFIT5BGCE72MO6nUsTLVzU50LMRbI7UJGMjYQc0Fd
   YRKiw4UwKwJ6PHlJtuObvhGpgSLTbpUTwgoL73ZWljnuC5mIvbnPZ8Y2N
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="382672467"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="382672467"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 23:28:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="809937993"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="809937993"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 23:28:43 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org
Cc:     dave.hansen@intel.com, tglx@linutronix.de, peterz@infradead.org,
        seanjc@google.com, pbonzini@redhat.com, rick.p.edgecombe@intel.com,
        kvm@vger.kernel.org, yang.zhong@intel.com, jing2.liu@intel.com,
        chao.gao@intel.com, Yang Weijiang <weijiang.yang@intel.com>
Subject: [RFC PATCH 6/8] x86/fpu/xstate: Opt-in kernel dynamic bits when calculate guest xstate size
Date:   Wed, 13 Sep 2023 23:23:32 -0400
Message-Id: <20230914032334.75212-7-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230914032334.75212-1-weijiang.yang@intel.com>
References: <20230914032334.75212-1-weijiang.yang@intel.com>
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

