Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65A14732FF3
	for <lists+kvm@lfdr.de>; Fri, 16 Jun 2023 13:35:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344442AbjFPLfN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jun 2023 07:35:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343865AbjFPLfI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jun 2023 07:35:08 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D7AE297A;
        Fri, 16 Jun 2023 04:35:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686915302; x=1718451302;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=P0Ef/wcWeoHTMDJTOMLAMTncNnZ3MdjPMPWdi8D3e7g=;
  b=mRNLD3amWXTzFtaQD+xqWlSAj+UG/GTSbU+y1A+DbWpQ6nMXXUjaRpIt
   xdZOw6ysNqlItYuTaOnWPc69PaOW15GMkDdRNVeU+jGsxSKQstY/O7Uqs
   YGAE93Opg0LInOvKrgtlFM2VgFYI+saWgbyys7FoM22s1ME369ulgAztS
   uQwSY1T33FAeUzK58jcMqAsfhPRcMOstW8ysPTpKvjTj6PlTDXjwxzQUl
   7PFo23YNFTunsCV+Q9Ix2JFheharG9Ryx/qdJg7IoDZi2U1kwBMQE9rUE
   5UQ/lUgxE0CkF7rwCxlZ9UsjaBSUx7bIGoe5gJ40g+g9CNcGKNO4lrchd
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="445574794"
X-IronPort-AV: E=Sophos;i="6.00,247,1681196400"; 
   d="scan'208";a="445574794"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2023 04:35:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="782872338"
X-IronPort-AV: E=Sophos;i="6.00,247,1681196400"; 
   d="scan'208";a="782872338"
Received: from youzhiji-mobl.ccr.corp.intel.com (HELO xiongzha-desk1.ccr.corp.intel.com) ([10.249.173.213])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2023 04:34:59 -0700
From:   Xiong Zhang <xiong.y.zhang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, peterz@infradead.org,
        like.xu.linux@gmail.com, kan.liang@linux.intel.com,
        zhenyuw@linux.intel.com, zhiyuan.lv@intel.com,
        Xiong Zhang <xiong.y.zhang@intel.com>
Subject: [PATCH 3/4] KVM: VMX/pmu: Enable inactive vLBR event in guest LBR MSR emulation
Date:   Fri, 16 Jun 2023 19:33:52 +0800
Message-Id: <20230616113353.45202-4-xiong.y.zhang@intel.com>
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

vLBR event could be inactive in two case:
a. host per cpu pinned LBR event occupy LBR when vLBR event is created
b. vLBR event is preempted by host per cpu pinned LBR event during vm
exit handler.
When vLBR event is inactive, guest couldn't access LBR msr, and it is
forced into error state and is excluded from schedule by perf scheduler.
So vLBR event couldn't be active through perf scheduler even if host per
cpu pinned LBR event has released LBR, kvm could enable vLBR event
proactively, then vLBR event may be active and LBR msr could be passthrough
into guest.

Signed-off-by: Xiong Zhang <xiong.y.zhang@intel.com>
---
 arch/x86/kvm/vmx/pmu_intel.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 741efe2c497b..5a3ab8c8711b 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -314,7 +314,16 @@ static bool intel_pmu_handle_lbr_msrs_access(struct kvm_vcpu *vcpu,
 	if (!intel_pmu_is_valid_lbr_msr(vcpu, index))
 		return false;
 
-	if (!lbr_desc->event && intel_pmu_create_guest_lbr_event(vcpu) < 0)
+	/* vLBR event may be inactive, but physical LBR may be free now.
+	 * but vLBR event is pinned event, once it is inactive state, perf
+	 * will force it to error state in merge_sched_in() and exclude it from
+	 * perf schedule, so even if LBR is free now, vLBR event couldn't be active
+	 * through perf scheduler and vLBR event could be active through
+	 * perf_event_enable().
+	 */
+	if (lbr_desc->event && (lbr_desc->event->state == PERF_EVENT_STATE_ERROR))
+		perf_event_enable(lbr_desc->event);
+	else if (!lbr_desc->event && intel_pmu_create_guest_lbr_event(vcpu) < 0)
 		goto dummy;
 
 	/*
-- 
2.25.1

