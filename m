Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EB4A30A238
	for <lists+kvm@lfdr.de>; Mon,  1 Feb 2021 07:50:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231920AbhBAGmz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 01:42:55 -0500
Received: from mga17.intel.com ([192.55.52.151]:9254 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230389AbhBAFWT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Feb 2021 00:22:19 -0500
IronPort-SDR: ruT/QqMv5UPa1L6apYgJdqr1t0kWa0foUT88B5isTBU4DQuKDl0HKUj4SIiR4JhNT2dxpQ7BhP
 DHFptpdU3bOQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9881"; a="160401842"
X-IronPort-AV: E=Sophos;i="5.79,391,1602572400"; 
   d="scan'208";a="160401842"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2021 21:17:29 -0800
IronPort-SDR: WV1H6qPMGULQEbnSkYbRw2FsqO8/0DFP5yc3UHp1wAcZKXfmjySJVBp9tc1+YmfB9HWre2uz38
 6Rfh3IutH92A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,391,1602572400"; 
   d="scan'208";a="390694306"
Received: from clx-ap-likexu.sh.intel.com ([10.239.48.108])
  by orsmga008.jf.intel.com with ESMTP; 31 Jan 2021 21:17:26 -0800
From:   Like Xu <like.xu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, ak@linux.intel.com,
        wei.w.wang@intel.com, kan.liang@intel.com,
        alex.shi@linux.alibaba.com, kvm@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v14 07/11] KVM: vmx/pmu: Reduce the overhead of LBR pass-through or cancellation
Date:   Mon,  1 Feb 2021 13:10:35 +0800
Message-Id: <20210201051039.255478-8-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210201051039.255478-1-like.xu@linux.intel.com>
References: <20210201051039.255478-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When the LBR records msrs has already been pass-through, there is no
need to call vmx_update_intercept_for_lbr_msrs() again and again, and
vice versa.

Signed-off-by: Like Xu <like.xu@linux.intel.com>
Reviewed-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kvm/vmx/pmu_intel.c | 13 +++++++++++++
 arch/x86/kvm/vmx/vmx.h       |  3 +++
 2 files changed, 16 insertions(+)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 287fc14f0445..60f395e18446 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -550,6 +550,7 @@ static void intel_pmu_init(struct kvm_vcpu *vcpu)
 	vcpu->arch.perf_capabilities = 0;
 	lbr_desc->records.nr = 0;
 	lbr_desc->event = NULL;
+	lbr_desc->msr_passthrough = false;
 }
 
 static void intel_pmu_reset(struct kvm_vcpu *vcpu)
@@ -596,12 +597,24 @@ static void vmx_update_intercept_for_lbr_msrs(struct kvm_vcpu *vcpu, bool set)
 
 static inline void vmx_disable_lbr_msrs_passthrough(struct kvm_vcpu *vcpu)
 {
+	struct lbr_desc *lbr_desc = vcpu_to_lbr_desc(vcpu);
+
+	if (!lbr_desc->msr_passthrough)
+		return;
+
 	vmx_update_intercept_for_lbr_msrs(vcpu, true);
+	lbr_desc->msr_passthrough = false;
 }
 
 static inline void vmx_enable_lbr_msrs_passthrough(struct kvm_vcpu *vcpu)
 {
+	struct lbr_desc *lbr_desc = vcpu_to_lbr_desc(vcpu);
+
+	if (lbr_desc->msr_passthrough)
+		return;
+
 	vmx_update_intercept_for_lbr_msrs(vcpu, false);
+	lbr_desc->msr_passthrough = true;
 }
 
 /*
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 863bb3fe73d4..4d6a2624a204 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -90,6 +90,9 @@ struct lbr_desc {
 	 * The records may be inaccurate if the host reclaims the LBR.
 	 */
 	struct perf_event *event;
+
+	/* True if LBRs are marked as not intercepted in the MSR bitmap */
+	bool msr_passthrough;
 };
 
 /*
-- 
2.29.2

