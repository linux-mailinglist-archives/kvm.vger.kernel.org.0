Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEC6D32C631
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 02:02:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381657AbhCDA16 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 19:27:58 -0500
Received: from mga11.intel.com ([192.55.52.93]:44167 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237820AbhCCOHF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Mar 2021 09:07:05 -0500
IronPort-SDR: E6QrcAV/BdPf1uD+RY9MIu+8OnQ9ekhwSzaeVKLirk//2PQwNJODkYmTn3T2M93T8PEqff5aJ0
 hii7wqzgmJ9Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9911"; a="183818863"
X-IronPort-AV: E=Sophos;i="5.81,220,1610438400"; 
   d="scan'208";a="183818863"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2021 06:05:21 -0800
IronPort-SDR: 6Wx2avFZ5NZp2xVnxL+aL91JvjJZFYXOZ39fhjwpVQcXzC8J82qZzKUM2jJE09cwXhEHrQNX5b
 rwoHWjarqz5w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,220,1610438400"; 
   d="scan'208";a="399729328"
Received: from clx-ap-likexu.sh.intel.com ([10.239.48.108])
  by fmsmga008.fm.intel.com with ESMTP; 03 Mar 2021 06:05:14 -0800
From:   Like Xu <like.xu@linux.intel.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Dave Hansen <dave.hansen@intel.com>, wei.w.wang@intel.com,
        Borislav Petkov <bp@alien8.de>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Like Xu <like.xu@linux.intel.com>
Subject: [PATCH v3 2/9] perf/x86/lbr: Simplify the exposure check for the LBR_INFO registers
Date:   Wed,  3 Mar 2021 21:57:48 +0800
Message-Id: <20210303135756.1546253-3-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210303135756.1546253-1-like.xu@linux.intel.com>
References: <20210303135756.1546253-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If the platform supports LBR_INFO register, the x86_pmu.lbr_info will
be assigned in intel_pmu_?_lbr_init_?() and it's safe to expose LBR_INFO
in the x86_perf_get_lbr() directly, instead of relying on lbr_format check.

Also Architectural LBR has IA32_LBR_x_INFO instead of LBR_FORMAT_INFO_x
to hold metadata for the operation, including mispredict, TSX, and
elapsed cycle time information.

Cc: Peter Zijlstra <peterz@infradead.org>
Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/events/intel/lbr.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/x86/events/intel/lbr.c b/arch/x86/events/intel/lbr.c
index 21890dacfcfe..355ea70f1879 100644
--- a/arch/x86/events/intel/lbr.c
+++ b/arch/x86/events/intel/lbr.c
@@ -1832,12 +1832,10 @@ void __init intel_pmu_arch_lbr_init(void)
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
2.29.2

