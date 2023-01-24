Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DC7C67A729
	for <lists+kvm@lfdr.de>; Wed, 25 Jan 2023 00:49:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234160AbjAXXtS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 18:49:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234282AbjAXXtQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 18:49:16 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91914271E
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 15:49:15 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id n93-20020a17090a2ce600b0022beeabcf6cso156079pjd.0
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 15:49:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=xHI4355sZtl+nMxSrviADFAGPhVPX2cjlZsacGsw9pI=;
        b=RAAd1Iu4UYOh1XsF8Cfe52BTlzhxuWODb0kKCcvoM9rqv0AU2jMW7496Q3aayEBvSQ
         neTdVSs7NeBj8zQJoFhhPzVm4joC8mZ8YbsOFxm5lNQKU799j0EnbwviVogAmKs8Ab1c
         fqS18Q9i6Nn0gHXXGy/B2LkZR7WW+r80VpeFpfcDNbJXHe2wRky4HEb6hHsxiUCk0P8u
         h9rY0X2k6Jt+brsvgb/OoozZLc/VmyA2i597RiNFtjRGBnXywLqsLHtWIG4FkJethTsc
         V9zGA5ufPSq/AnK4LrkicqQCJOeYOFd7ga8eRDs+oArYI8rhs6ln+HkHH/9o+/AxO0cD
         hAXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xHI4355sZtl+nMxSrviADFAGPhVPX2cjlZsacGsw9pI=;
        b=wbBpgm31ywFo7NSkKBM1h2x0vw0k2FzCeLx+t4b/RCQF5ZmhbLupk4kjtTkzY4SlXd
         L9RLqoYz1OPI4OxIj2FeL6ZH0wEAtqNH3Nsju4pIcg6VT53HDzSnRD7iz6nx5N/65VEz
         6u+Zc2NFkM0rquiajnA76zoIaVv7npUJgO7hW6yckAeIjsqVCCFlba3qD26hVysjIv6i
         rIMSw1SbV3KLz49AWTiT+ua+GrUs20fLSW0RgbylB5hEqz/nyuodIW9dykbmlaRPDK7p
         vG58CLexVCJTyp14fcg5BK1erpyWWIfe2Aem5TQCxIXpjKbVMtOsldNHhO9iMJadPJsx
         yzdA==
X-Gm-Message-State: AFqh2krwx0yge+GSQcgh3qkw4KAJnj8COl68X/kYRv5XqC6dI75SknU0
        32DGTlkqhmDHti5M45h7F9UGmKsAVFI=
X-Google-Smtp-Source: AMrXdXvYyk1sWuRZ5UE/FSLyVafxn2kpbItwCV1ruZJj5qGZULz4RlmSKkf8HnPq/QxXtVj4pEO2mBr8YmE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:aa7:972c:0:b0:579:6402:5b39 with SMTP id
 k12-20020aa7972c000000b0057964025b39mr3200002pfg.11.1674604155069; Tue, 24
 Jan 2023 15:49:15 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 24 Jan 2023 23:49:00 +0000
In-Reply-To: <20230124234905.3774678-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230124234905.3774678-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.1.456.gfc5497dd1b-goog
Message-ID: <20230124234905.3774678-2-seanjc@google.com>
Subject: [PATCH 1/6] KVM: x86/pmu: Cap kvm_pmu_cap.num_counters_gp at KVM's
 internal max
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Aaron Lewis <aaronlewis@google.com>,
        Weijiang Yang <weijiang.yang@intel.com>,
        Like Xu <likexu@tencent.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Limit kvm_pmu_cap.num_counters_gp during kvm_init_pmu_capability() based
on the vendor PMU capabilities so that consuming num_counters_gp naturally
does the right thing.  This fixes a mostly theoretical bug where KVM could
over-report its PMU support in KVM_GET_SUPPORTED_CPUID for leaf 0xA, e.g.
if the number of counters reported by perf is greater than KVM's
hardcoded internal limit.  Incorporating input from the AMD PMU also
avoids over-reporting MSRs to save when running on AMD.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/pmu.h           | 5 ++++-
 arch/x86/kvm/svm/pmu.c       | 1 +
 arch/x86/kvm/vmx/pmu_intel.c | 1 +
 arch/x86/kvm/x86.c           | 6 +++---
 4 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 30bfccc6df60..8c04e9109db0 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -42,6 +42,7 @@ struct kvm_pmu_ops {
 	void (*cleanup)(struct kvm_vcpu *vcpu);
 
 	const u64 EVENTSEL_EVENT;
+	const int MAX_NR_GP_COUNTERS;
 };
 
 void kvm_pmu_ops_update(const struct kvm_pmu_ops *pmu_ops);
@@ -163,7 +164,7 @@ static inline bool pmc_speculative_in_use(struct kvm_pmc *pmc)
 
 extern struct x86_pmu_capability kvm_pmu_cap;
 
-static inline void kvm_init_pmu_capability(void)
+static inline void kvm_init_pmu_capability(const struct kvm_pmu_ops *pmu_ops)
 {
 	bool is_intel = boot_cpu_data.x86_vendor == X86_VENDOR_INTEL;
 
@@ -182,6 +183,8 @@ static inline void kvm_init_pmu_capability(void)
 	}
 
 	kvm_pmu_cap.version = min(kvm_pmu_cap.version, 2);
+	kvm_pmu_cap.num_counters_gp = min(kvm_pmu_cap.num_counters_gp,
+					  pmu_ops->MAX_NR_GP_COUNTERS);
 	kvm_pmu_cap.num_counters_fixed = min(kvm_pmu_cap.num_counters_fixed,
 					     KVM_PMC_MAX_FIXED);
 }
diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index 5da8c292e3e3..cc77a0681800 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -232,4 +232,5 @@ struct kvm_pmu_ops amd_pmu_ops __initdata = {
 	.init = amd_pmu_init,
 	.reset = amd_pmu_reset,
 	.EVENTSEL_EVENT = AMD64_EVENTSEL_EVENT,
+	.MAX_NR_GP_COUNTERS = KVM_AMD_PMC_MAX_GENERIC,
 };
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 7980fda3978d..5d525d677967 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -812,4 +812,5 @@ struct kvm_pmu_ops intel_pmu_ops __initdata = {
 	.deliver_pmi = intel_pmu_deliver_pmi,
 	.cleanup = intel_pmu_cleanup,
 	.EVENTSEL_EVENT = ARCH_PERFMON_EVENTSEL_EVENT,
+	.MAX_NR_GP_COUNTERS = KVM_INTEL_PMC_MAX_GENERIC,
 };
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index da02a08e21b5..ad95ce92a154 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7061,12 +7061,12 @@ static void kvm_init_msr_list(void)
 			break;
 		case MSR_ARCH_PERFMON_PERFCTR0 ... MSR_ARCH_PERFMON_PERFCTR_MAX:
 			if (msrs_to_save_all[i] - MSR_ARCH_PERFMON_PERFCTR0 >=
-			    min(KVM_INTEL_PMC_MAX_GENERIC, kvm_pmu_cap.num_counters_gp))
+			    kvm_pmu_cap.num_counters_gp)
 				continue;
 			break;
 		case MSR_ARCH_PERFMON_EVENTSEL0 ... MSR_ARCH_PERFMON_EVENTSEL_MAX:
 			if (msrs_to_save_all[i] - MSR_ARCH_PERFMON_EVENTSEL0 >=
-			    min(KVM_INTEL_PMC_MAX_GENERIC, kvm_pmu_cap.num_counters_gp))
+			    kvm_pmu_cap.num_counters_gp)
 				continue;
 			break;
 		case MSR_IA32_XFD:
@@ -9386,7 +9386,7 @@ static int __kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
 	if (boot_cpu_has(X86_FEATURE_XSAVES))
 		rdmsrl(MSR_IA32_XSS, host_xss);
 
-	kvm_init_pmu_capability();
+	kvm_init_pmu_capability(ops->pmu_ops);
 
 	r = ops->hardware_setup();
 	if (r != 0)
-- 
2.39.1.456.gfc5497dd1b-goog

