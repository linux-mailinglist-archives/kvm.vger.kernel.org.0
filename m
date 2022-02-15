Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E83A4B859C
	for <lists+kvm@lfdr.de>; Wed, 16 Feb 2022 11:30:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232871AbiBPK1G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Feb 2022 05:27:06 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232844AbiBPK1D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Feb 2022 05:27:03 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27909206995;
        Wed, 16 Feb 2022 02:26:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645007212; x=1676543212;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ua7eKMjMgbuMUSWoTvt/pD+pRNzX252qQBMst8H9K0Q=;
  b=hobkwhKTofj16e8qfnLlf3GJudJUOVEfMqdky7qUwF+1lMXHeSEtw+P8
   KJmU+/fM+mq8qhU53b3VxtwxxPrXCf5b0ycUyzX3xaDfrmN++DFc2UAqS
   kPkJcbipHmty2CTCr/7+gRYccZxdm2jEx76uTPucREMQu2qHvEHQgi/+p
   Nf4LTgV9URpLmuY0LcPkkJnNzScrr6kxHPdano1GDTAPP4hDkCm03s0w2
   Ak4hh6Pq1F1kZHex7KONUKg+EskNBvl+uDlabO+h52d8GTEFSG3IZ+NMh
   M1h/KZanzgZwZk3nNP9GZw8RDTKokN/RL5hD8NO7IugGaz2VfU0hW2XTZ
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10259"; a="250312473"
X-IronPort-AV: E=Sophos;i="5.88,373,1635231600"; 
   d="scan'208";a="250312473"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2022 02:26:51 -0800
X-IronPort-AV: E=Sophos;i="5.88,373,1635231600"; 
   d="scan'208";a="498708584"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2022 02:26:50 -0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        like.xu.linux@gmail.com, vkuznets@redhat.com, wei.w.wang@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Like Xu <like.xu@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v9 05/17] perf/x86/lbr: Simplify the exposure check for the LBR_INFO registers
Date:   Tue, 15 Feb 2022 16:25:32 -0500
Message-Id: <20220215212544.51666-6-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220215212544.51666-1-weijiang.yang@intel.com>
References: <20220215212544.51666-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DATE_IN_PAST_12_24,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
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
---
 arch/x86/events/intel/lbr.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/x86/events/intel/lbr.c b/arch/x86/events/intel/lbr.c
index 669c2be14784..4ab358ca7290 100644
--- a/arch/x86/events/intel/lbr.c
+++ b/arch/x86/events/intel/lbr.c
@@ -1874,12 +1874,10 @@ void __init intel_pmu_arch_lbr_init(void)
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

