Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 995D55395A6
	for <lists+kvm@lfdr.de>; Tue, 31 May 2022 19:55:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346721AbiEaRzF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 May 2022 13:55:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346734AbiEaRy5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 May 2022 13:54:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BBDB09AE7B
        for <kvm@vger.kernel.org>; Tue, 31 May 2022 10:54:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654019694;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IdAhXacthggldbcUuwa6ssjUCrHr+jCF1itLOAVBnI4=;
        b=SO8POVTGRHZjLTaWTSjKtN/Qp5s6HtZ5hwOefP7qxXnD8Qfj1H+IBhmIPiwpxpTnQSrIW8
        zS4BhPR09Eno2OPatG6m6dJBpoEjCXMjf3AOkTJHQvYQPsFGDzqQOmUK94Mhpaxpo/pn54
        D8++YbegJilfgv80ZSitjhHJ9ZA5Rm8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-643-Cqhod5AWP1eX3to8RUtaaQ-1; Tue, 31 May 2022 13:54:51 -0400
X-MC-Unique: Cqhod5AWP1eX3to8RUtaaQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 357163C0F728;
        Tue, 31 May 2022 17:54:51 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 190BDC23DBF;
        Tue, 31 May 2022 17:54:51 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     likexu@tencent.com
Subject: [PATCH 2/2] KVM: x86: always allow host-initiated writes to PMU MSRs
Date:   Tue, 31 May 2022 13:54:50 -0400
Message-Id: <20220531175450.295552-3-pbonzini@redhat.com>
In-Reply-To: <20220531175450.295552-1-pbonzini@redhat.com>
References: <20220531175450.295552-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Whenever an MSR is part of KVM_GET_MSR_INDEX_LIST, it has to be always
retrievable and settable with KVM_GET_MSR and KVM_SET_MSR.  Accept
the PMU MSRs unconditionally in intel_is_valid_msr, if the access was
host-initiated.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/pmu.c           |  4 ++--
 arch/x86/kvm/pmu.h           |  4 ++--
 arch/x86/kvm/svm/pmu.c       |  2 +-
 arch/x86/kvm/vmx/pmu_intel.c | 27 +++++++++++++++++----------
 arch/x86/kvm/x86.c           | 10 +++++-----
 5 files changed, 27 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index a2eaae85d97b..c6e57367f009 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -455,10 +455,10 @@ void kvm_pmu_deliver_pmi(struct kvm_vcpu *vcpu)
 	}
 }
 
-bool kvm_pmu_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
+bool kvm_pmu_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr, bool host_initiated)
 {
 	return static_call(kvm_x86_pmu_msr_idx_to_pmc)(vcpu, msr) ||
-		static_call(kvm_x86_pmu_is_valid_msr)(vcpu, msr);
+		static_call(kvm_x86_pmu_is_valid_msr)(vcpu, msr, host_initiated);
 }
 
 static void kvm_pmu_mark_pmc_in_use(struct kvm_vcpu *vcpu, u32 msr)
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 7824bdd8626e..cea52d1bcc76 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -29,7 +29,7 @@ struct kvm_pmu_ops {
 		unsigned int idx, u64 *mask);
 	struct kvm_pmc *(*msr_idx_to_pmc)(struct kvm_vcpu *vcpu, u32 msr);
 	bool (*is_valid_rdpmc_ecx)(struct kvm_vcpu *vcpu, unsigned int idx);
-	bool (*is_valid_msr)(struct kvm_vcpu *vcpu, u32 msr);
+	bool (*is_valid_msr)(struct kvm_vcpu *vcpu, u32 msr, bool host_initiated);
 	int (*get_msr)(struct kvm_vcpu *vcpu, struct msr_data *msr_info);
 	int (*set_msr)(struct kvm_vcpu *vcpu, struct msr_data *msr_info);
 	void (*refresh)(struct kvm_vcpu *vcpu);
@@ -186,7 +186,7 @@ void kvm_pmu_deliver_pmi(struct kvm_vcpu *vcpu);
 void kvm_pmu_handle_event(struct kvm_vcpu *vcpu);
 int kvm_pmu_rdpmc(struct kvm_vcpu *vcpu, unsigned pmc, u64 *data);
 bool kvm_pmu_is_valid_rdpmc_ecx(struct kvm_vcpu *vcpu, unsigned int idx);
-bool kvm_pmu_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr);
+bool kvm_pmu_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr, bool host_initiated);
 int kvm_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info);
 int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info);
 void kvm_pmu_refresh(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index 136039fc6d01..0e5784371ac0 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -229,7 +229,7 @@ static struct kvm_pmc *amd_rdpmc_ecx_to_pmc(struct kvm_vcpu *vcpu,
 	return &counters[idx];
 }
 
-static bool amd_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
+static bool amd_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr, bool host_initiated)
 {
 	/* All MSRs refer to exactly one PMC, so msr_idx_to_pmc is enough.  */
 	return false;
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 66496cb41494..c8c3f55630ea 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -207,38 +207,45 @@ static bool intel_pmu_is_valid_lbr_msr(struct kvm_vcpu *vcpu, u32 index)
 	return false;
 }
 
-static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
+static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr, bool host_initiated)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 	u64 perf_capabilities = vcpu->arch.perf_capabilities;
-	int ret;
 
 	switch (msr) {
 	case MSR_CORE_PERF_FIXED_CTR_CTRL:
 	case MSR_CORE_PERF_GLOBAL_STATUS:
 	case MSR_CORE_PERF_GLOBAL_CTRL:
 	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
-		ret = pmu->version > 1;
+		if (host_initiated)
+			return true;
+		return pmu->version > 1;
 		break;
 	case MSR_IA32_PEBS_ENABLE:
-		ret = perf_capabilities & PERF_CAP_PEBS_FORMAT;
+		if (host_initiated)
+			return true;
+		return perf_capabilities & PERF_CAP_PEBS_FORMAT;
 		break;
 	case MSR_IA32_DS_AREA:
-		ret = guest_cpuid_has(vcpu, X86_FEATURE_DS);
+		if (host_initiated)
+			return true;
+		return guest_cpuid_has(vcpu, X86_FEATURE_DS);
 		break;
 	case MSR_PEBS_DATA_CFG:
-		ret = (perf_capabilities & PERF_CAP_PEBS_BASELINE) &&
+		if (host_initiated)
+			return true;
+		return (perf_capabilities & PERF_CAP_PEBS_BASELINE) &&
 			((perf_capabilities & PERF_CAP_PEBS_FORMAT) > 3);
 		break;
 	default:
-		ret = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0) ||
+		if (host_initiated)
+			return true;
+		return get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0) ||
 			get_gp_pmc(pmu, msr, MSR_P6_EVNTSEL0) ||
 			get_fixed_pmc(pmu, msr) || get_fw_gp_pmc(pmu, msr) ||
 			intel_pmu_is_valid_lbr_msr(vcpu, msr);
 		break;
 	}
-
-	return ret;
 }
 
 static struct kvm_pmc *intel_msr_idx_to_pmc(struct kvm_vcpu *vcpu, u32 msr)
@@ -688,7 +695,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 		INTEL_PMC_MAX_GENERIC, pmu->nr_arch_fixed_counters);
 
 	nested_vmx_pmu_refresh(vcpu,
-			       intel_is_valid_msr(vcpu, MSR_CORE_PERF_GLOBAL_CTRL));
+			       intel_is_valid_msr(vcpu, MSR_CORE_PERF_GLOBAL_CTRL, false));
 
 	if (cpuid_model_is_consistent(vcpu)) {
 		x86_perf_get_lbr(&lbr_desc->records);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a291236b4695..7460b9a77d9a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3725,7 +3725,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		fallthrough;
 	case MSR_K7_EVNTSEL0 ... MSR_K7_EVNTSEL3:
 	case MSR_P6_EVNTSEL0 ... MSR_P6_EVNTSEL1:
-		if (kvm_pmu_is_valid_msr(vcpu, msr))
+		if (kvm_pmu_is_valid_msr(vcpu, msr, msr_info->host_initiated))
 			return kvm_pmu_set_msr(vcpu, msr_info);
 
 		if (pr || data != 0)
@@ -3808,7 +3808,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		break;
 #endif
 	default:
-		if (kvm_pmu_is_valid_msr(vcpu, msr))
+		if (kvm_pmu_is_valid_msr(vcpu, msr, msr_info->host_initiated))
 			return kvm_pmu_set_msr(vcpu, msr_info);
 		return KVM_MSR_RET_INVALID;
 	}
@@ -3888,7 +3888,7 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		msr_info->data = 0;
 		break;
 	case MSR_F15H_PERF_CTL0 ... MSR_F15H_PERF_CTR5:
-		if (kvm_pmu_is_valid_msr(vcpu, msr_info->index))
+		if (kvm_pmu_is_valid_msr(vcpu, msr_info->index, msr_info->host_initiated))
 			return kvm_pmu_get_msr(vcpu, msr_info);
 		if (!msr_info->host_initiated)
 			return 1;
@@ -3898,7 +3898,7 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_K7_PERFCTR0 ... MSR_K7_PERFCTR3:
 	case MSR_P6_PERFCTR0 ... MSR_P6_PERFCTR1:
 	case MSR_P6_EVNTSEL0 ... MSR_P6_EVNTSEL1:
-		if (kvm_pmu_is_valid_msr(vcpu, msr_info->index))
+		if (kvm_pmu_is_valid_msr(vcpu, msr_info->index, msr_info->host_initiated))
 			return kvm_pmu_get_msr(vcpu, msr_info);
 		msr_info->data = 0;
 		break;
@@ -4144,7 +4144,7 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		break;
 #endif
 	default:
-		if (kvm_pmu_is_valid_msr(vcpu, msr_info->index))
+		if (kvm_pmu_is_valid_msr(vcpu, msr_info->index, msr_info->host_initiated))
 			return kvm_pmu_get_msr(vcpu, msr_info);
 		return KVM_MSR_RET_INVALID;
 	}
-- 
2.31.1

