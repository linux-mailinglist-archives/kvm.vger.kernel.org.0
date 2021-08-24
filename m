Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C4C13F5926
	for <lists+kvm@lfdr.de>; Tue, 24 Aug 2021 09:40:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235290AbhHXHll (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Aug 2021 03:41:41 -0400
Received: from mga02.intel.com ([134.134.136.20]:33546 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235110AbhHXHl2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Aug 2021 03:41:28 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10085"; a="204453449"
X-IronPort-AV: E=Sophos;i="5.84,346,1620716400"; 
   d="scan'208";a="204453449"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2021 00:40:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,346,1620716400"; 
   d="scan'208";a="473402081"
Received: from michael-optiplex-9020.sh.intel.com ([10.239.159.182])
  by orsmga008.jf.intel.com with ESMTP; 24 Aug 2021 00:40:41 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        like.xu.linux@gmail.com, vkuznets@redhat.com, wei.w.wang@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Like Xu <like.xu@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v8 02/15] perf/x86/lbr: Simplify the exposure check for the LBR_INFO registers
Date:   Tue, 24 Aug 2021 15:56:04 +0800
Message-Id: <1629791777-16430-3-git-send-email-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1629791777-16430-1-git-send-email-weijiang.yang@intel.com>
References: <1629791777-16430-1-git-send-email-weijiang.yang@intel.com>
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
index 9e6d6eaeb4cb..ceff16eb4bcb 100644
--- a/arch/x86/events/intel/lbr.c
+++ b/arch/x86/events/intel/lbr.c
@@ -1848,12 +1848,10 @@ void __init intel_pmu_arch_lbr_init(void)
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
2.25.1

