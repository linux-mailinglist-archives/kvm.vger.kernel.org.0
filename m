Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20DA12EEB13
	for <lists+kvm@lfdr.de>; Fri,  8 Jan 2021 02:49:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729976AbhAHBre (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 20:47:34 -0500
Received: from mga09.intel.com ([134.134.136.24]:27995 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729552AbhAHBre (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 20:47:34 -0500
IronPort-SDR: cHKzTVQdw6Kf5Y85H02hDlTRcNLidgmxMH6bbTxBNz3dDn83oTW5WoxLQcFAuGHup8LkqUzrgu
 H2C53ofpJg1A==
X-IronPort-AV: E=McAfee;i="6000,8403,9857"; a="177672405"
X-IronPort-AV: E=Sophos;i="5.79,330,1602572400"; 
   d="scan'208";a="177672405"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2021 17:43:29 -0800
IronPort-SDR: 3xIHeUASsErE4WcrB9BqCPaC3ceRlZNEm/CAg3an5IheGEC93Nj/xuJccc85yoq5cLLFBWlV4J
 ehghsyZFGrOA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,330,1602572400"; 
   d="scan'208";a="379938093"
Received: from clx-ap-likexu.sh.intel.com ([10.239.48.108])
  by orsmga008.jf.intel.com with ESMTP; 07 Jan 2021 17:43:25 -0800
From:   Like Xu <like.xu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>, ak@linux.intel.com,
        wei.w.wang@intel.com, kan.liang@intel.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RESEND v13 07/10] KVM: vmx/pmu: Reduce the overhead of LBR pass-through or cancellation
Date:   Fri,  8 Jan 2021 09:37:01 +0800
Message-Id: <20210108013704.134985-8-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210108013704.134985-1-like.xu@linux.intel.com>
References: <20210108013704.134985-1-like.xu@linux.intel.com>
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
index 6b3319dbfa72..72a6dd6ca0ac 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -562,6 +562,7 @@ static void intel_pmu_init(struct kvm_vcpu *vcpu)
 		vmx_get_perf_capabilities() : 0;
 	lbr_desc->records.nr = 0;
 	lbr_desc->event = NULL;
+	lbr_desc->already_passthrough = false;
 }
 
 static void intel_pmu_reset(struct kvm_vcpu *vcpu)
@@ -607,12 +608,24 @@ static void vmx_update_intercept_for_lbr_msrs(struct kvm_vcpu *vcpu, bool set)
 
 static inline void vmx_disable_lbr_msrs_passthrough(struct kvm_vcpu *vcpu)
 {
+	struct lbr_desc *lbr_desc = vcpu_to_lbr_desc(vcpu);
+
+	if (!lbr_desc->already_passthrough)
+		return;
+
 	vmx_update_intercept_for_lbr_msrs(vcpu, true);
+	lbr_desc->already_passthrough = false;
 }
 
 static inline void vmx_enable_lbr_msrs_passthrough(struct kvm_vcpu *vcpu)
 {
+	struct lbr_desc *lbr_desc = vcpu_to_lbr_desc(vcpu);
+
+	if (lbr_desc->already_passthrough)
+		return;
+
 	vmx_update_intercept_for_lbr_msrs(vcpu, false);
+	lbr_desc->already_passthrough = true;
 }
 
 /*
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 863bb3fe73d4..b79244bd44bb 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -90,6 +90,9 @@ struct lbr_desc {
 	 * The records may be inaccurate if the host reclaims the LBR.
 	 */
 	struct perf_event *event;
+
+	/* A flag to reduce the overhead of LBR pass-through or cancellation. */
+	bool already_passthrough;
 };
 
 /*
-- 
2.29.2

