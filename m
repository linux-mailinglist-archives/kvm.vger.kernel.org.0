Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 798431F81AA
	for <lists+kvm@lfdr.de>; Sat, 13 Jun 2020 10:12:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726551AbgFMILk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 13 Jun 2020 04:11:40 -0400
Received: from mga07.intel.com ([134.134.136.100]:64588 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726553AbgFMILf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 13 Jun 2020 04:11:35 -0400
IronPort-SDR: ROT/FVHTNhFtjDcxJ2n4uSZ5SoYC89vC0Al4d9tBXqtoAO/gkBi288w8VXZDmPy2Q1DdZxGN4g
 yH2k/sAYE+7g==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2020 01:11:34 -0700
IronPort-SDR: DsydGXdWvck1TnL/AtC4qj2yDMHJCD7/zQgLXVI3sRRGgrSiuaDcE7wf5HHOtaCtpDyrvEHnf0
 W2jVNiH5HSGA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,506,1583222400"; 
   d="scan'208";a="474467453"
Received: from sqa-gate.sh.intel.com (HELO clx-ap-likexu.tsp.org) ([10.239.48.212])
  by fmsmga006.fm.intel.com with ESMTP; 13 Jun 2020 01:11:32 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, ak@linux.intel.com,
        wei.w.wang@intel.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Like Xu <like.xu@linux.intel.com>
Subject: [PATCH v12 10/11] KVM: vmx/pmu: Reduce the overhead of LBR pass-through or cancellation
Date:   Sat, 13 Jun 2020 16:09:55 +0800
Message-Id: <20200613080958.132489-11-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20200613080958.132489-1-like.xu@linux.intel.com>
References: <20200613080958.132489-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When the LBR record msrs has already been pass-through, there is no
need to call vmx_update_intercept_for_lbr_msrs() again and again, and
vice versa.

Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/kvm/vmx/pmu_intel.c |  1 +
 arch/x86/kvm/vmx/vmx.c       | 12 ++++++++++++
 arch/x86/kvm/vmx/vmx.h       |  3 +++
 3 files changed, 16 insertions(+)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 85a675004cbb..75ba0444b4d1 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -614,6 +614,7 @@ static void intel_pmu_init(struct kvm_vcpu *vcpu)
 		vmx_get_perf_capabilities() : 0;
 	lbr_desc->lbr.nr = 0;
 	lbr_desc->event = NULL;
+	lbr_desc->already_passthrough = false;
 }
 
 static void intel_pmu_reset(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 58a8af433741..800a26e3b571 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3880,12 +3880,24 @@ static void vmx_update_intercept_for_lbr_msrs(struct kvm_vcpu *vcpu, bool set)
 
 static inline void vmx_lbr_disable_passthrough(struct kvm_vcpu *vcpu)
 {
+	struct lbr_desc *lbr_desc = &to_vmx(vcpu)->lbr_desc;
+
+	if (!lbr_desc->already_passthrough)
+		return;
+
 	vmx_update_intercept_for_lbr_msrs(vcpu, true);
+	lbr_desc->already_passthrough = false;
 }
 
 static inline void vmx_lbr_enable_passthrough(struct kvm_vcpu *vcpu)
 {
+	struct lbr_desc *lbr_desc = &to_vmx(vcpu)->lbr_desc;
+
+	if (lbr_desc->already_passthrough)
+		return;
+
 	vmx_update_intercept_for_lbr_msrs(vcpu, false);
+	lbr_desc->already_passthrough = true;
 }
 
 /*
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index c67ce758412e..c931463f75d9 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -102,6 +102,9 @@ struct lbr_desc {
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

