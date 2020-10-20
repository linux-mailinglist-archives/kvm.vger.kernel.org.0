Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9E53293F27
	for <lists+kvm@lfdr.de>; Tue, 20 Oct 2020 17:02:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406956AbgJTPCW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Oct 2020 11:02:22 -0400
Received: from mga06.intel.com ([134.134.136.31]:19882 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405917AbgJTPCV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Oct 2020 11:02:21 -0400
IronPort-SDR: 46untAN8+2JQILsBWGwtbxzP1i2uAoqziEjAT2r4chyviY3CjlHxg2uh1u0d8+/18PuPmSOg6k
 OrBAQ/IcMeRw==
X-IronPort-AV: E=McAfee;i="6000,8403,9779"; a="228851185"
X-IronPort-AV: E=Sophos;i="5.77,397,1596524400"; 
   d="scan'208";a="228851185"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2020 08:02:20 -0700
IronPort-SDR: nNCBEpHhd0zpQmNwiJUP5M5g6ce2a1I459p2Lx776XxNZVx+WRtl9io7EwY9zj3AFVRQ8+SMDT
 EWe/qPObeGcA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,397,1596524400"; 
   d="scan'208";a="301755401"
Received: from sqa-gate.sh.intel.com (HELO clx-ap-likexu.tsp.org) ([10.239.48.212])
  by fmsmga007.fm.intel.com with ESMTP; 20 Oct 2020 08:02:16 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] KVM: x86/pmu: Set MSR_IA32_MISC_ENABLE_EMON when vPMU is enabled
Date:   Tue, 20 Oct 2020 22:57:54 +0800
Message-Id: <20201020145755.122333-1-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.21.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Intel platforms, software may uses IA32_MISC_ENABLE[7]
bit to detect whether the performance monitoring facility
is supported in the processor.

A write to this PMU available bit will be ignored.

Cc: Yao Yuan <yuan.yao@intel.com>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/kvm/vmx/pmu_intel.c | 2 ++
 arch/x86/kvm/x86.c           | 1 +
 2 files changed, 3 insertions(+)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index a886a47daebd..01c7d84ecf3e 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -339,6 +339,8 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	if (!pmu->version)
 		return;
 
+	vcpu->arch.ia32_misc_enable_msr |= MSR_IA32_MISC_ENABLE_EMON;
+
 	perf_get_x86_pmu_capability(&x86_pmu);
 	if (guest_cpuid_has(vcpu, X86_FEATURE_PDCM))
 		vcpu->arch.perf_capabilities = vmx_get_perf_capabilities();
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c4015a43cc8a..d7b8f98ada93 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3042,6 +3042,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		}
 		break;
 	case MSR_IA32_MISC_ENABLE:
+		data &= ~MSR_IA32_MISC_ENABLE_EMON;
 		if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT) &&
 		    ((vcpu->arch.ia32_misc_enable_msr ^ data) & MSR_IA32_MISC_ENABLE_MWAIT)) {
 			if (!guest_cpuid_has(vcpu, X86_FEATURE_XMM3))
-- 
2.21.3

