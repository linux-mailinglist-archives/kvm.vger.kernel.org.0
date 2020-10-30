Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B8B329FC65
	for <lists+kvm@lfdr.de>; Fri, 30 Oct 2020 04:57:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726365AbgJ3D46 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Oct 2020 23:56:58 -0400
Received: from mga09.intel.com ([134.134.136.24]:4254 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726510AbgJ3D45 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Oct 2020 23:56:57 -0400
IronPort-SDR: V6C64PRa/kHFFRYdpwkMwIbVnd+QBMHKI6TPLL53IP40EcOrOvYHOdRBEaSPin11eUc9AEevEq
 GPcQ8khAs/QA==
X-IronPort-AV: E=McAfee;i="6000,8403,9789"; a="168685748"
X-IronPort-AV: E=Sophos;i="5.77,432,1596524400"; 
   d="scan'208";a="168685748"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2020 20:56:56 -0700
IronPort-SDR: FgOetFluXbyOFh4FUi4MoRUghkSwXD86YQvNsrPaVPs18W/FKMh22rOMc9T/mWTXZT3L5fYxkJ
 bOjh7PDqZgcg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,432,1596524400"; 
   d="scan'208";a="525770454"
Received: from sqa-gate.sh.intel.com (HELO clx-ap-likexu.tsp.org) ([10.239.48.212])
  by fmsmga006.fm.intel.com with ESMTP; 29 Oct 2020 20:56:54 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H . Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH RESEND v13 07/10] KVM: vmx/pmu: Reduce the overhead of LBR pass-through or cancellation
Date:   Fri, 30 Oct 2020 11:52:17 +0800
Message-Id: <20201030035220.102403-8-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20201030035220.102403-1-like.xu@linux.intel.com>
References: <20201030035220.102403-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When the LBR records msrs has already been pass-through, there is no
need to call vmx_update_intercept_for_lbr_msrs() again and again, and
vice versa.

Signed-off-by: Like Xu <like.xu@linux.intel.com>
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
index 2bd866c5a4e4..1869f5090e40 100644
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
2.21.3

