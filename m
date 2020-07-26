Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38CDC22E0C1
	for <lists+kvm@lfdr.de>; Sun, 26 Jul 2020 17:35:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727820AbgGZPfE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 26 Jul 2020 11:35:04 -0400
Received: from mga03.intel.com ([134.134.136.65]:17603 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727784AbgGZPfD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 26 Jul 2020 11:35:03 -0400
IronPort-SDR: YGQ8mwLMcNGp5tFE1BiFGQq5dbztft1Qkb6ER4aMZOYu1Y/Dm8K9aITDzUCe70bYl2Rt9brHNE
 DEGasmWT/aMA==
X-IronPort-AV: E=McAfee;i="6000,8403,9694"; a="150890985"
X-IronPort-AV: E=Sophos;i="5.75,399,1589266800"; 
   d="scan'208";a="150890985"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2020 08:35:02 -0700
IronPort-SDR: cDPb9d5OIa1Nawr5/CwtWo5ppa3/tcu60F1M5MJL29O/7fF4WV90Y1q9RTNfrCbX8/BbEArkSj
 6bxtluPKoS5A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,399,1589266800"; 
   d="scan'208";a="303177608"
Received: from sqa-gate.sh.intel.com (HELO clx-ap-likexu.tsp.org) ([10.239.48.212])
  by orsmga002.jf.intel.com with ESMTP; 26 Jul 2020 08:35:00 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        Like Xu <like.xu@linux.intel.com>
Subject: [PATCH v13 07/10] KVM: vmx/pmu: Reduce the overhead of LBR pass-through or cancellation
Date:   Sun, 26 Jul 2020 23:32:26 +0800
Message-Id: <20200726153229.27149-9-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20200726153229.27149-1-like.xu@linux.intel.com>
References: <20200726153229.27149-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
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
index 0358ceea34d4..08d195e08deb 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -562,6 +562,7 @@ static void intel_pmu_init(struct kvm_vcpu *vcpu)
 		vmx_get_perf_capabilities() : 0;
 	lbr_desc->records.nr = 0;
 	lbr_desc->event = NULL;
+	lbr_desc->already_passthrough = false;
 }
 
 static void intel_pmu_reset(struct kvm_vcpu *vcpu)
@@ -611,12 +612,24 @@ static void vmx_update_intercept_for_lbr_msrs(struct kvm_vcpu *vcpu, bool set)
 
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
index dd029b57215c..f95d61942a1c 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -112,6 +112,9 @@ struct lbr_desc {
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

