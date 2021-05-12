Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BF9937B84E
	for <lists+kvm@lfdr.de>; Wed, 12 May 2021 10:46:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231133AbhELIrG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 May 2021 04:47:06 -0400
Received: from mga17.intel.com ([192.55.52.151]:10038 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230411AbhELIqy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 May 2021 04:46:54 -0400
IronPort-SDR: gNCk433QKcVQqyqe2Ys7Ys5QWBxjo3YFYokszGf3jKokIxfMyt6qnqgL+5hx+O1UmyZaGEVRdy
 Z1RH86yqlCew==
X-IronPort-AV: E=McAfee;i="6200,9189,9981"; a="179918870"
X-IronPort-AV: E=Sophos;i="5.82,293,1613462400"; 
   d="scan'208";a="179918870"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2021 01:45:45 -0700
IronPort-SDR: 2w/CnFAmSUUakd5WBAphTyCppkfTkLTie2pSgd7HNrWEUPxGgUFtSOoWzZ9P5IacWg6OnvZ+4f
 qdpvE/nb4p+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,293,1613462400"; 
   d="scan'208";a="392636401"
Received: from clx-ap-likexu.sh.intel.com ([10.239.48.108])
  by orsmga006.jf.intel.com with ESMTP; 12 May 2021 01:45:41 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, peterz@infradead.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, weijiang.yang@intel.com,
        eranian@google.com, wei.w.wang@intel.com, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Like Xu <like.xu@linux.intel.com>
Subject: [PATCH v3 4/5] KVM: x86/pmu: Add counter reload registers to the MSR-load list
Date:   Wed, 12 May 2021 16:44:45 +0800
Message-Id: <20210512084446.342526-5-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512084446.342526-1-like.xu@linux.intel.com>
References: <20210512084446.342526-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The guest counter reload registers need to be loaded to real HW
before VM-entry. Taking into account the existing guest PT
implementation, we add those counter reload registers to MSR-load list
when the corresponding PEBS counters are enabled and the optimization
from clear_atomic_switch_msr() can be reused.

To support that, it needs to expand the value of NR_LOADSTORE_MSRS
from 8 to 16 because when all counters are enabled, up to 7 or 8
counter reload registers need to be added into the MSR-load list.

Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/events/intel/core.c | 27 +++++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.h       |  2 +-
 2 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 4404987bbc57..bd6d9e2a64d9 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -3903,6 +3903,8 @@ static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr, void *data)
 	u64 intel_ctrl = hybrid(cpuc->pmu, intel_ctrl);
 	u64 pebs_mask = (x86_pmu.flags & PMU_FL_PEBS_ALL) ?
 		cpuc->pebs_enabled : (cpuc->pebs_enabled & PEBS_COUNTER_MASK);
+	u64 guest_pebs_enable, base, idx, host_reload_ctr;
+	unsigned long bit;
 
 	*nr = 0;
 	arr[(*nr)++] = (struct perf_guest_switch_msr){
@@ -3964,7 +3966,32 @@ static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr, void *data)
 		arr[0].guest |= arr[*nr].guest;
 	}
 
+	guest_pebs_enable = arr[*nr].guest;
 	++(*nr);
+
+	if (!x86_pmu.intel_cap.pebs_output_pt_available ||
+	    !(guest_pebs_enable & PEBS_OUTPUT_PT))
+		return arr;
+
+	for_each_set_bit(bit, (unsigned long *)&guest_pebs_enable,
+			 X86_PMC_IDX_MAX) {
+		base = (bit < INTEL_PMC_IDX_FIXED) ?
+			MSR_RELOAD_PMC0 : MSR_RELOAD_FIXED_CTR0;
+		idx = (bit < INTEL_PMC_IDX_FIXED) ?
+			bit : (bit - INTEL_PMC_IDX_FIXED);
+
+		/* It's good when the pebs counters are not cross-mapped. */
+		rdmsrl(base, host_reload_ctr);
+
+		arr[(*nr)++] = (struct perf_guest_switch_msr){
+			.msr = base,
+			.host = host_reload_ctr,
+			.guest = (bit < INTEL_PMC_IDX_FIXED) ?
+				pmu->gp_counters[bit].reload_counter :
+				pmu->fixed_counters[bit].reload_counter,
+		};
+	}
+
 	return arr;
 }
 
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 3afdcebb0a11..25aa1cc3cc6a 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -28,7 +28,7 @@ extern const u32 vmx_msr_index[];
 #define MAX_NR_USER_RETURN_MSRS	4
 #endif
 
-#define MAX_NR_LOADSTORE_MSRS	8
+#define MAX_NR_LOADSTORE_MSRS	16
 
 struct vmx_msrs {
 	unsigned int		nr;
-- 
2.31.1

