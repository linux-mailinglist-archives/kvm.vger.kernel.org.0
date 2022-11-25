Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16C0C6383C9
	for <lists+kvm@lfdr.de>; Fri, 25 Nov 2022 07:10:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbiKYGKH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Nov 2022 01:10:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229569AbiKYGKG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Nov 2022 01:10:06 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37E911FF9F;
        Thu, 24 Nov 2022 22:10:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669356604; x=1700892604;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=AI/egaNUqDxRR3gqaRVx+qud/1s9AQV7uO5bYN6cCbw=;
  b=MjKTWutU9WXAwrfszMTQtta0ROYbcV5nB4chuxifXvOsPM2ry7Y3Z4Y0
   7upfDhDsKktBLLBm5yRlIdPWtdzianAXBuVYgMEhffZW1cfstJ/XvU+We
   Y/u+cR78+pCoSVPlwmpZH929FhqVeHY5RG6Ruxz573K+ulM/FQ+ZaVq/e
   jfyxStlxpBCnwn8Uh1BBs76m9B/6G50GC805GxiNc46h17q0J8sgBa2PP
   brN8KKahRHnvyk+3NpQjBw/PtCI+USHEExryvnnuva59+Dx7ooKOMxRz9
   g0ic3is8mkPLtdheXPS2UzcD6oArjaYOzhzS0K8E0CHJKFvvTSL0nnE0v
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="313116793"
X-IronPort-AV: E=Sophos;i="5.96,192,1665471600"; 
   d="scan'208";a="313116793"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2022 22:10:02 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="784838444"
X-IronPort-AV: E=Sophos;i="5.96,192,1665471600"; 
   d="scan'208";a="784838444"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2022 22:10:00 -0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, jmattson@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     like.xu.linux@gmail.com, kan.liang@linux.intel.com,
        wei.w.wang@intel.com, weijiang.yang@intel.com,
        Like Xu <like.xu@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH v2 01/15] perf/x86/lbr: Simplify the exposure check for the LBR_INFO registers
Date:   Thu, 24 Nov 2022 23:05:50 -0500
Message-Id: <20221125040604.5051-2-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20221125040604.5051-1-weijiang.yang@intel.com>
References: <20221125040604.5051-1-weijiang.yang@intel.com>
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

From: Like Xu <like.xu@linux.intel.com>

The x86_pmu.lbr_info is 0 unless explicitly initialized, so there's
no point checking x86_pmu.intel_cap.lbr_format.

Cc: Peter Zijlstra <peterz@infradead.org>
Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
Reviewed-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/events/intel/lbr.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/x86/events/intel/lbr.c b/arch/x86/events/intel/lbr.c
index 4dbde69c423b..e7caabfa1377 100644
--- a/arch/x86/events/intel/lbr.c
+++ b/arch/x86/events/intel/lbr.c
@@ -1606,12 +1606,10 @@ void __init intel_pmu_arch_lbr_init(void)
  */
 void x86_perf_get_lbr(struct x86_pmu_lbr *lbr)
 {
-	int lbr_fmt = x86_pmu.intel_cap.lbr_format;
-
 	lbr->nr = x86_pmu.lbr_nr;
 	lbr->from = x86_pmu.lbr_from;
 	lbr->to = x86_pmu.lbr_to;
-	lbr->info = (lbr_fmt == LBR_FORMAT_INFO) ? x86_pmu.lbr_info : 0;
+	lbr->info = x86_pmu.lbr_info;
 }
 EXPORT_SYMBOL_GPL(x86_perf_get_lbr);
 
-- 
2.27.0

