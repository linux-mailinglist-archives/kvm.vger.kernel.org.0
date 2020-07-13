Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 370DC21B969
	for <lists+kvm@lfdr.de>; Fri, 10 Jul 2020 17:26:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727907AbgGJP0I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jul 2020 11:26:08 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:55837 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726962AbgGJP0H (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 10 Jul 2020 11:26:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594394766;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=o99/BwfqjWQiBTm39Rbe0UIfyhuvQm1bvRYJ0Q0vEoA=;
        b=BU+qQX11FD6JOrgXS/hUE1Oq4P0KVGO0fMcuqw74TP4iP0MmGYrN+5akGjTcEYqwbN1BrY
        Lp2IaN0LXx5HK3emiLt2A8E8K/PmgrU8BUPwK8w2XeQbR+K58QB7j4GcdM6QLPvL5X7UGm
        O3ds10m0nRgs6PnVg5VxZTrh/BW4Sec=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-221-nvi7qKmuMrS-LNMRnbYelg-1; Fri, 10 Jul 2020 11:26:04 -0400
X-MC-Unique: nvi7qKmuMrS-LNMRnbYelg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 63E8B800FEB;
        Fri, 10 Jul 2020 15:26:03 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.35])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1899960C05;
        Fri, 10 Jul 2020 15:26:00 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Like Xu <like.xu@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v3] KVM: x86: move MSR_IA32_PERF_CAPABILITIES emulation to common x86 code
Date:   Fri, 10 Jul 2020 17:25:59 +0200
Message-Id: <20200710152559.1645827-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

state_test/smm_test selftests are failing on AMD with:
"Unexpected result from KVM_GET_MSRS, r: 51 (failed MSR was 0x345)"

MSR_IA32_PERF_CAPABILITIES is an emulated MSR on Intel but it is not
known to AMD code, we can move the emulation to common x86 code. For
AMD, we basically just allow the host to read and write zero to the MSR.

Fixes: 27461da31089 ("KVM: x86/pmu: Support full width counting")
Suggested-by: Jim Mattson <jmattson@google.com>
Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
- This is a succesor of "[PATCH v2] KVM: SVM: emulate MSR_IA32_PERF_CAPABILITIES".
---
 arch/x86/kvm/svm/svm.c       |  2 ++
 arch/x86/kvm/vmx/pmu_intel.c | 17 -----------------
 arch/x86/kvm/x86.c           | 20 ++++++++++++++++++++
 3 files changed, 22 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index c0da4dd78ac5..1b68cc6cd756 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2358,6 +2358,8 @@ static int svm_get_msr_feature(struct kvm_msr_entry *msr)
 		if (boot_cpu_has(X86_FEATURE_LFENCE_RDTSC))
 			msr->data |= MSR_F10H_DECFG_LFENCE_SERIALIZE;
 		break;
+	case MSR_IA32_PERF_CAPABILITIES:
+		return 0;
 	default:
 		return 1;
 	}
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index bdcce65c7a1d..a886a47daebd 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -180,9 +180,6 @@ static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
 		ret = pmu->version > 1;
 		break;
-	case MSR_IA32_PERF_CAPABILITIES:
-		ret = 1;
-		break;
 	default:
 		ret = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0) ||
 			get_gp_pmc(pmu, msr, MSR_P6_EVNTSEL0) ||
@@ -224,12 +221,6 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
 		msr_info->data = pmu->global_ovf_ctrl;
 		return 0;
-	case MSR_IA32_PERF_CAPABILITIES:
-		if (!msr_info->host_initiated &&
-		    !guest_cpuid_has(vcpu, X86_FEATURE_PDCM))
-			return 1;
-		msr_info->data = vcpu->arch.perf_capabilities;
-		return 0;
 	default:
 		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
 		    (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
@@ -289,14 +280,6 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 0;
 		}
 		break;
-	case MSR_IA32_PERF_CAPABILITIES:
-		if (!msr_info->host_initiated)
-			return 1;
-		if (guest_cpuid_has(vcpu, X86_FEATURE_PDCM) ?
-			(data & ~vmx_get_perf_capabilities()) : data)
-			return 1;
-		vcpu->arch.perf_capabilities = data;
-		return 0;
 	default:
 		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
 		    (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3b92db412335..a08bd66cd662 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2817,6 +2817,20 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 1;
 		vcpu->arch.arch_capabilities = data;
 		break;
+	case MSR_IA32_PERF_CAPABILITIES: {
+		struct kvm_msr_entry msr_ent = {.index = msr, .data = 0};
+
+		if (!msr_info->host_initiated)
+			return 1;
+		if (guest_cpuid_has(vcpu, X86_FEATURE_PDCM) && kvm_get_msr_feature(&msr_ent))
+			return 1;
+		if (data & ~msr_ent.data)
+			return 1;
+
+		vcpu->arch.perf_capabilities = data;
+
+		return 0;
+		}
 	case MSR_EFER:
 		return set_efer(vcpu, msr_info);
 	case MSR_K7_HWCR:
@@ -3167,6 +3181,12 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 1;
 		msr_info->data = vcpu->arch.arch_capabilities;
 		break;
+	case MSR_IA32_PERF_CAPABILITIES:
+		if (!msr_info->host_initiated &&
+		    !guest_cpuid_has(vcpu, X86_FEATURE_PDCM))
+			return 1;
+		msr_info->data = vcpu->arch.perf_capabilities;
+		break;
 	case MSR_IA32_POWER_CTL:
 		msr_info->data = vcpu->arch.msr_ia32_power_ctl;
 		break;
-- 
2.25.4

