Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF42E4CD0C3
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 10:08:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236748AbiCDJHK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 04:07:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236386AbiCDJGd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 04:06:33 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 920AF1A2707;
        Fri,  4 Mar 2022 01:05:34 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id g1so7130430pfv.1;
        Fri, 04 Mar 2022 01:05:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rSZw5WOpQAEpUEgtYh+INrnBDUAdQGRxTNgHOThShkg=;
        b=APPYeRVmSzJD2Y08Z4fY0gxQC2WNOXSvTLQ2JNSj0wKzZ0IEe9DCtVMpRQYdzYJ7bj
         9Ns/BRMG7c6ZSx1HGqVEpJw6M3fPFWj0deQr8Bp/IWdIRUy+Cs3uzdrS8JPEpXd8wTZ4
         vzn8FQBYkM4C6DTN9rERJvUawb5wTbtKLqk8Cw64wHcyGnl601dXawrUoC8yGr4Z93gV
         WiBA4ErgQVnAKnfL/fhjmmEl9gNtV+lEQdle9i6I5+rUGdraQEPvnsG2v0v/B5wmEjMX
         GV/lbo0cxlPHUrY6OgbWe+lVeh3VS/H4DD9p7RD+/hmrFUQIMB8qFZ1AmSffp1ihN3SP
         QYCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rSZw5WOpQAEpUEgtYh+INrnBDUAdQGRxTNgHOThShkg=;
        b=nncb81DralolcFxagtYj9DOadVkz1ErcpZk9n+iwrTYShrdzNmQiVlEngK5Z/GUhyT
         RC0BKgZ0lxTWkNlvwIr9njW6kCJ0hCWItGt0PLGYu7bbKy77FW2g3ZdVEHI1YYc9KirW
         CKECE1TiLny2+xz6X1sIHCD0VIN27cATCQMEMo4HmnSENiBqkxlJBE8G1POAoh877Dfe
         n1YSQZ7jaEovkNiqlJSArizQNHfafPLEn0S1SuJSP0Id/Iz+9Cbya66Z7VxalUuUzXyR
         sNpnbyp+TCQxUzRqU6lt6oTbABOT33inVeW/3cfOzPqCkvlm4dIyi01Adyhr7dluK6ep
         1HiA==
X-Gm-Message-State: AOAM531NUwRAx9gqFHq7t1cAlkgPdOblTvBkFq+XsNFay7uAD01XtoBA
        FyCNkQglZxbNdgntlsnhvkc=
X-Google-Smtp-Source: ABdhPJxZzUu6amZAHGO3WwAVsc967OsoYvorbdXv3dlwbji/aQ5AIyXRnno1TriqzNXgyxoTqF6x9w==
X-Received: by 2002:a63:1662:0:b0:378:8b0b:1c9 with SMTP id 34-20020a631662000000b003788b0b01c9mr22380522pgw.537.1646384734003;
        Fri, 04 Mar 2022 01:05:34 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id j2-20020a655582000000b00372b2b5467asm4192968pgs.10.2022.03.04.01.05.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Mar 2022 01:05:33 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v12 16/17] KVM: x86/cpuid: Refactor host/guest CPU model consistency check
Date:   Fri,  4 Mar 2022 17:04:26 +0800
Message-Id: <20220304090427.90888-17-likexu@tencent.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220304090427.90888-1-likexu@tencent.com>
References: <20220304090427.90888-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <like.xu@linux.intel.com>

For the same purpose, the leagcy intel_pmu_lbr_is_compatible() can be
renamed for reuse by more callers, and remove the comment about LBR
use case can be deleted by the way.

Signed-off-by: Like Xu <like.xu@linux.intel.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 arch/x86/kvm/cpuid.h         |  5 +++++
 arch/x86/kvm/vmx/pmu_intel.c | 12 +-----------
 arch/x86/kvm/vmx/vmx.c       |  2 +-
 arch/x86/kvm/vmx/vmx.h       |  1 -
 4 files changed, 7 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index 8a770b481d9d..ac72aabba981 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -145,6 +145,11 @@ static inline int guest_cpuid_model(struct kvm_vcpu *vcpu)
 	return x86_model(best->eax);
 }
 
+static inline bool cpuid_model_is_consistent(struct kvm_vcpu *vcpu)
+{
+	return boot_cpu_data.x86_model == guest_cpuid_model(vcpu);
+}
+
 static inline int guest_cpuid_stepping(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpuid_entry2 *best;
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 7707ec01fb1f..45148fa4df36 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -167,16 +167,6 @@ static inline struct kvm_pmc *get_fw_gp_pmc(struct kvm_pmu *pmu, u32 msr)
 	return get_gp_pmc(pmu, msr, MSR_IA32_PMC0);
 }
 
-bool intel_pmu_lbr_is_compatible(struct kvm_vcpu *vcpu)
-{
-	/*
-	 * As a first step, a guest could only enable LBR feature if its
-	 * cpu model is the same as the host because the LBR registers
-	 * would be pass-through to the guest and they're model specific.
-	 */
-	return boot_cpu_data.x86_model == guest_cpuid_model(vcpu);
-}
-
 bool intel_pmu_lbr_is_enabled(struct kvm_vcpu *vcpu)
 {
 	struct x86_pmu_lbr *lbr = vcpu_to_lbr_records(vcpu);
@@ -591,7 +581,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	nested_vmx_pmu_refresh(vcpu,
 			       intel_is_valid_msr(vcpu, MSR_CORE_PERF_GLOBAL_CTRL));
 
-	if (intel_pmu_lbr_is_compatible(vcpu))
+	if (cpuid_model_is_consistent(vcpu))
 		x86_perf_get_lbr(&lbr_desc->records);
 	else
 		lbr_desc->records.nr = 0;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 84635d6950c9..7ae0a82a2a78 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2244,7 +2244,7 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			if ((data & PMU_CAP_LBR_FMT) !=
 			    (vmx_get_perf_capabilities() & PMU_CAP_LBR_FMT))
 				return 1;
-			if (!intel_pmu_lbr_is_compatible(vcpu))
+			if (!cpuid_model_is_consistent(vcpu))
 				return 1;
 		}
 		ret = kvm_set_msr_common(vcpu, msr_info);
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 2abb1cb63616..3f33883f6fa9 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -95,7 +95,6 @@ union vmx_exit_reason {
 #define vcpu_to_lbr_records(vcpu) (&to_vmx(vcpu)->lbr_desc.records)
 
 void intel_pmu_cross_mapped_check(struct kvm_pmu *pmu);
-bool intel_pmu_lbr_is_compatible(struct kvm_vcpu *vcpu);
 bool intel_pmu_lbr_is_enabled(struct kvm_vcpu *vcpu);
 
 int intel_pmu_create_guest_lbr_event(struct kvm_vcpu *vcpu);
-- 
2.35.1

