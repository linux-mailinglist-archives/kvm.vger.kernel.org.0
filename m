Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 448DB5A8ADC
	for <lists+kvm@lfdr.de>; Thu,  1 Sep 2022 03:37:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232604AbiIABhI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 21:37:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232628AbiIABhF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 21:37:05 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FF6315C7B3;
        Wed, 31 Aug 2022 18:37:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661996221; x=1693532221;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hxbf2utA2IeEcFqzKPwgIPrC8NPr8bW4YWh+Jt8swY4=;
  b=CYfZkTv3Htdli8igYB8fqci6OnSE9e9kJgF4IH5xTaDGzBYF8NY/fdKG
   dlhiYwLJeAjkc5G+f2LyjxI0QEvhf11GDn5zYcXUkcZE0bENbZZAjue+8
   hp+W/1s6CVeYNCCiiqMGk45sbEgecP+sF/NKHPBmppJKqZfbSPfFtptnH
   ipRpPuP6uCMW7txrKr+XXNWJ2N063SLiUeHCWZ3mH5xM6axoTslp0Zo4W
   irq+d3z5JVk/00v1/yat+GUPPGug12NW//ZOwNeyqW6NOLXRldWWgWzVD
   nB1j8Xp3DFdZKaLDFn76o3CFIuebv1xgr/aAVCkYYNqw975xBrwQPclks
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10456"; a="321735072"
X-IronPort-AV: E=Sophos;i="5.93,279,1654585200"; 
   d="scan'208";a="321735072"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2022 18:36:59 -0700
X-IronPort-AV: E=Sophos;i="5.93,279,1654585200"; 
   d="scan'208";a="754625963"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2022 18:36:59 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org
Cc:     like.xu.linux@gmail.com, kan.liang@linux.intel.com,
        wei.w.wang@intel.com, linux-kernel@vger.kernel.org
Subject: [PATCH 01/15] perf/x86/lbr: Simplify the exposure check for the LBR_INFO registers
Date:   Wed, 31 Aug 2022 18:34:24 -0400
Message-Id: <20220831223438.413090-2-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220831223438.413090-1-weijiang.yang@intel.com>
References: <20220831223438.413090-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <like.xu@linux.intel.com>

The x86_pmu.lbr_info is 0 unless explicitly initialized, so there's
no point checking x86_pmu.intel_cap.lbr_format.

Cc: Peter Zijlstra <peterz@infradead.org>
Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
Reviewed-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Message-Id: <20220517154100.29983-3-weijiang.yang@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/events/intel/lbr.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/x86/events/intel/lbr.c b/arch/x86/events/intel/lbr.c
index 4f70fb6c2c1e..4ed6d3691e10 100644
--- a/arch/x86/events/intel/lbr.c
+++ b/arch/x86/events/intel/lbr.c
@@ -1873,12 +1873,10 @@ void __init intel_pmu_arch_lbr_init(void)
  */
 int x86_perf_get_lbr(struct x86_pmu_lbr *lbr)
 {
-	int lbr_fmt = x86_pmu.intel_cap.lbr_format;
-
 	lbr->nr = x86_pmu.lbr_nr;
 	lbr->from = x86_pmu.lbr_from;
 	lbr->to = x86_pmu.lbr_to;
-	lbr->info = (lbr_fmt == LBR_FORMAT_INFO) ? x86_pmu.lbr_info : 0;
+	lbr->info = x86_pmu.lbr_info;
 
 	return 0;
 }
-- 
2.27.0

