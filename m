Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1F4837B848
	for <lists+kvm@lfdr.de>; Wed, 12 May 2021 10:45:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230196AbhELIqq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 May 2021 04:46:46 -0400
Received: from mga17.intel.com ([192.55.52.151]:10038 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230411AbhELIqm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 May 2021 04:46:42 -0400
IronPort-SDR: eCWfj3GGgRr7hdiMm0uOivpq9iBLi4mZslg34g/ieXzPar6nq8a5cORYC5AJQEyNwxsKK3177x
 J2XXzoKJs0mQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9981"; a="179918820"
X-IronPort-AV: E=Sophos;i="5.82,293,1613462400"; 
   d="scan'208";a="179918820"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2021 01:45:33 -0700
IronPort-SDR: 2RfI0KCX8hls62HKYhihrH2SGRZJJ1OhtCA6lZscHNUH198yTQy8dErxYul8K1+3DWn2v41rU0
 YGyU0isipdAw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,293,1613462400"; 
   d="scan'208";a="392636333"
Received: from clx-ap-likexu.sh.intel.com ([10.239.48.108])
  by orsmga006.jf.intel.com with ESMTP; 12 May 2021 01:45:29 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, peterz@infradead.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, weijiang.yang@intel.com,
        eranian@google.com, wei.w.wang@intel.com, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Like Xu <like.xu@linux.intel.com>,
        Andi Kleen <andi.kleen@intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: [PATCH v3 1/5] KVM: x86/pmu: Add pebs_vmx support for ATOM_TREMONT
Date:   Wed, 12 May 2021 16:44:42 +0800
Message-Id: <20210512084446.342526-2-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512084446.342526-1-like.xu@linux.intel.com>
References: <20210512084446.342526-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The ATOM_TREMONT platform also supports the EPT-Friendly PEBS capability
and we can also safely enable guest PEBS. Per Intel SDM, the PDIR counter
on non-Ice Lake platforms is always GP counter 1;

Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi.kleen@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/events/intel/core.c | 1 +
 arch/x86/kvm/pmu.c           | 5 ++---
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index e7bbd9aab175..4404987bbc57 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -5826,6 +5826,7 @@ __init int intel_pmu_init(void)
 	case INTEL_FAM6_ATOM_TREMONT_D:
 	case INTEL_FAM6_ATOM_TREMONT:
 	case INTEL_FAM6_ATOM_TREMONT_L:
+		x86_pmu.pebs_vmx = 1;
 		x86_pmu.late_ack = true;
 		memcpy(hw_cache_event_ids, glp_hw_cache_event_ids,
 		       sizeof(hw_cache_event_ids));
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 4798bf991b60..8c700a7930c4 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -151,9 +151,8 @@ static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
 		 * the accuracy of the PEBS profiling result, because the "event IP"
 		 * in the PEBS record is calibrated on the guest side.
 		 */
-		attr.precise_ip = 1;
-		if (x86_match_cpu(vmx_icl_pebs_cpu) && pmc->idx == 32)
-			attr.precise_ip = 3;
+		attr.precise_ip = x86_match_cpu(vmx_icl_pebs_cpu) ?
+			((pmc->idx == 32) ? 3 : 1) : ((pmc->idx == 1) ? 3 : 1);
 	}
 
 	event = perf_event_create_kernel_counter(&attr, -1, current,
-- 
2.31.1

