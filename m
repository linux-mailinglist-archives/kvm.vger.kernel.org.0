Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9FCD732FEF
	for <lists+kvm@lfdr.de>; Fri, 16 Jun 2023 13:34:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245538AbjFPLe6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jun 2023 07:34:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344219AbjFPLez (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jun 2023 07:34:55 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 075862710;
        Fri, 16 Jun 2023 04:34:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686915294; x=1718451294;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7ywaFnTVKZvnETKLlHQFg1Dh9g62mSeY+NetTSfpD50=;
  b=F6ihkeMdVRf+a15SWp1Rzk8rnSPOf+WdPLUWQkgn9CHM5f+ULLrfC7/j
   UnderRWERKv83LkFTZ1dlItHJ5e6o/3F+A8eTc+tx+Beq5v57qqjKyPOV
   hAQ4CHRqc82BYcrBCftRC6gPvWn+Y7yuQJY+sn8Pt2M44LXR/aTNXe/vH
   /9mDwe0F4QarkhbiILxwBRX4OS5JmT0eQLmkcbY2v0ljHJLCXDUu23HwX
   7RglIy1ziJiS6ppIgolcfckDvs4GOtHYa1DzgsTFq8xcyJ/xBJfv8e6L8
   LsNF6Jqq1OgGrLBqO8gp4yZb9fUsptvAjb1i8wLH4oI+9ukQlY29UJBTD
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="445574768"
X-IronPort-AV: E=Sophos;i="6.00,247,1681196400"; 
   d="scan'208";a="445574768"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2023 04:34:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="782872287"
X-IronPort-AV: E=Sophos;i="6.00,247,1681196400"; 
   d="scan'208";a="782872287"
Received: from youzhiji-mobl.ccr.corp.intel.com (HELO xiongzha-desk1.ccr.corp.intel.com) ([10.249.173.213])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2023 04:34:51 -0700
From:   Xiong Zhang <xiong.y.zhang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, peterz@infradead.org,
        like.xu.linux@gmail.com, kan.liang@linux.intel.com,
        zhenyuw@linux.intel.com, zhiyuan.lv@intel.com,
        Xiong Zhang <xiong.y.zhang@intel.com>
Subject: [PATCH 1/4] perf/x86/intel: Get shared reg constraints first for vLBR
Date:   Fri, 16 Jun 2023 19:33:50 +0800
Message-Id: <20230616113353.45202-2-xiong.y.zhang@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230616113353.45202-1-xiong.y.zhang@intel.com>
References: <20230616113353.45202-1-xiong.y.zhang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When host has per cpu pinned LBR event and guest use LBR also, host
couldn't get correct LBR data, as the physical LBR is preempted by
guest.

The rule for multi events sharing LBR is defined in
__intel_shared_reg_get_constraints(), but guest vLBR event skips this
function, so even if host has per cpu pinned LBR event, guest vLBR event
could get constraints successfully and make vlbr_exclude_host returns true,
finally host couldn't enable LBR in intel_pmu_lbr_enable_all().

This commit move intel_vlbr_constraints() behind
intel_shared_regs_constraints(), guest vLBR event will use LBR also and it
should get LBR resource through intel_shared_regs_constraints().

Fixes: 097e4311cda9 ("perf/x86: Add constraint to create guest LBR event without hw counter")
Signed-off-by: Xiong Zhang <xiong.y.zhang@intel.com>
---
 arch/x86/events/intel/core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 6fd3cd97a6ac..2e27a69e9725 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -3347,15 +3347,15 @@ __intel_get_event_constraints(struct cpu_hw_events *cpuc, int idx,
 {
 	struct event_constraint *c;
 
-	c = intel_vlbr_constraints(event);
+	c = intel_bts_constraints(event);
 	if (c)
 		return c;
 
-	c = intel_bts_constraints(event);
+	c = intel_shared_regs_constraints(cpuc, event);
 	if (c)
 		return c;
 
-	c = intel_shared_regs_constraints(cpuc, event);
+	c = intel_vlbr_constraints(event);
 	if (c)
 		return c;
 
-- 
2.25.1

