Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A710E1ED76F
	for <lists+kvm@lfdr.de>; Wed,  3 Jun 2020 22:33:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726126AbgFCUdF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Jun 2020 16:33:05 -0400
Received: from mga05.intel.com ([192.55.52.43]:45491 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725821AbgFCUdF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Jun 2020 16:33:05 -0400
IronPort-SDR: ixakrZKy0djqqq32V61yBwYyAG9Dg7sZzmGTqJfn2y78xnocC3EQva11s3FpGzeh0V2syX2yJr
 ZwlerNkunJyg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2020 13:33:05 -0700
IronPort-SDR: uN5rqF5/QSJRCFmpf7SBwVkazagR2ifEkLz+T4mDp01oqNHwiB3THuValIjq/o8IgvJsb4poP5
 VlclBhG3n8fw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,469,1583222400"; 
   d="scan'208";a="416679395"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by orsmga004.jf.intel.com with ESMTP; 03 Jun 2020 13:33:04 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <like.xu@linux.intel.com>
Subject: [PATCH] KVM: VMX: Always treat MSR_IA32_PERF_CAPABILITIES as a valid PMU MSR
Date:   Wed,  3 Jun 2020 13:33:03 -0700
Message-Id: <20200603203303.28545-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Unconditionally return true when querying the validity of
MSR_IA32_PERF_CAPABILITIES so as to defer the validity check to
intel_pmu_{get,set}_msr(), which can properly give the MSR a pass when
the access is initiated from host userspace.  The MSR is emulated so
there is no underlying hardware dependency to worry about.

Fixes: 27461da31089a ("KVM: x86/pmu: Support full width counting")
Cc: Like Xu <like.xu@linux.intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---

KVM selftests are completely hosed for me, everything fails on KVM_GET_MSRS.

 arch/x86/kvm/vmx/pmu_intel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index d33d890b605f..bdcce65c7a1d 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -181,7 +181,7 @@ static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 		ret = pmu->version > 1;
 		break;
 	case MSR_IA32_PERF_CAPABILITIES:
-		ret = guest_cpuid_has(vcpu, X86_FEATURE_PDCM);
+		ret = 1;
 		break;
 	default:
 		ret = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0) ||
-- 
2.26.0

