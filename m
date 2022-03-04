Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D13C4CD0C6
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 10:08:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236997AbiCDJHV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 04:07:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236800AbiCDJGe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 04:06:34 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AA6E1A3636;
        Fri,  4 Mar 2022 01:05:37 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id d17so7151865pfl.0;
        Fri, 04 Mar 2022 01:05:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+OTmcaqceN1v+Oh4qkfoovMiZHBs7YKc5pNVuTTFvLU=;
        b=JaqT8eLwxXQtrA/e6teUBX6c4sMkgfD9NV25PN2QRAFZD8rSQi6CTDt21EF0siYJIH
         AI9tXA3JYcx6uDTjIQD9Ux4KZo/9tVQ6EOZnPKiqlYx/SNDiKJYPRNhJi2JkseBi9aIY
         xzbkD6ya97VhqC+njv0R9nnoGLPuTmsfYfmrVwUAgIW5/vS6aUFuQGOL2Py+JHULs6M/
         nHZqAkBwh53qBdyb5GQ7ZiZdwfZnSU8S2ofgHQJhYablph/LOrqXMQIpdL010Gz2suxi
         nvLaz1rBNEE6CazBcBdUNay2LEqvYCYC8bK13IUKUyVsh2Ke2KSrE5k2Qr/lLJbbaV6z
         OaAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+OTmcaqceN1v+Oh4qkfoovMiZHBs7YKc5pNVuTTFvLU=;
        b=bq6HrTauu5AOtETgtM5a1l0BJi3Rw6+Bn707YyEn+dilVx5vgAeIFJCJfypgV0zV2O
         Jy+gsDcA7SpyJLycl9RVoZlaXEgBKaJtwNa+PAMRVbA9NzHUDVF/tgld7uX9zIAVWCp6
         BQCj7+XlCOCeBSkaFf+xMLruMovSpGDoKduXqnI4qQYyXuVRQjE1S0foB1wLlLOpzo8b
         bzygwkzSQQWdvM/EAMElYLYc81lqjqMx0QKdSsK4hvVSWriYtGnhKxaNwUOU1vLGpnh+
         0cz/XASaJKxnVOw3yKxZoEBE6iwUfWz93HaU0Eh/Moaq69p3wxLku4pPU9inTpe+tM5v
         ls/A==
X-Gm-Message-State: AOAM532FITcAAQIQA9AF4MtqucbjAwpHDOoPIvjinEtE7pLAszclHckY
        +SFlDwhE/JYF7OjSXYeuhr0=
X-Google-Smtp-Source: ABdhPJxQdUdRW57yF2sPo7pyDmfavFgrMQJyQTEISUdcsraHAf+W5NWIFQY9dyGBBR5KjIzVBCM+BA==
X-Received: by 2002:a63:57:0:b0:37c:5bd8:e708 with SMTP id 84-20020a630057000000b0037c5bd8e708mr4956251pga.407.1646384737182;
        Fri, 04 Mar 2022 01:05:37 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id j2-20020a655582000000b00372b2b5467asm4192968pgs.10.2022.03.04.01.05.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Mar 2022 01:05:36 -0800 (PST)
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
Subject: [PATCH v12 17/17] KVM: x86/pmu: Expose CPUIDs feature bits PDCM, DS, DTES64
Date:   Fri,  4 Mar 2022 17:04:27 +0800
Message-Id: <20220304090427.90888-18-likexu@tencent.com>
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

From: Like Xu <likexu@tencent.com>

The CPUID features PDCM, DS and DTES64 are required for PEBS feature.
KVM would expose CPUID feature PDCM, DS and DTES64 to guest when PEBS
is supported in the KVM on the Ice Lake server platforms.

Originally-by: Andi Kleen <ak@linux.intel.com>
Co-developed-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Co-developed-by: Luwei Kang <luwei.kang@intel.com>
Signed-off-by: Luwei Kang <luwei.kang@intel.com>
Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/vmx/capabilities.h | 28 +++++++++++++++++-----------
 arch/x86/kvm/vmx/vmx.c          | 15 +++++++++++++++
 2 files changed, 32 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index 3f430e218375..0e3929ddf9c8 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -6,6 +6,7 @@
 
 #include "lapic.h"
 #include "x86.h"
+#include "pmu.h"
 
 extern bool __read_mostly enable_vpid;
 extern bool __read_mostly flexpriority_enabled;
@@ -385,23 +386,28 @@ static inline bool vmx_pt_mode_is_host_guest(void)
 	return pt_mode == PT_MODE_HOST_GUEST;
 }
 
+static inline bool vmx_pebs_supported(void)
+{
+	return boot_cpu_has(X86_FEATURE_PEBS) && kvm_pmu_cap.pebs_ept;
+}
+
 static inline u64 vmx_get_perf_capabilities(void)
 {
-	u64 perf_cap = 0;
-
-	if (!enable_pmu)
-		return perf_cap;
+	u64 perf_cap = PMU_CAP_FW_WRITES;
+	u64 host_perf_cap = 0;
 
 	if (boot_cpu_has(X86_FEATURE_PDCM))
-		rdmsrl(MSR_IA32_PERF_CAPABILITIES, perf_cap);
+		rdmsrl(MSR_IA32_PERF_CAPABILITIES, host_perf_cap);
 
-	perf_cap &= PMU_CAP_LBR_FMT;
+	perf_cap |= host_perf_cap & PMU_CAP_LBR_FMT;
 
-	/*
-	 * Since counters are virtualized, KVM would support full
-	 * width counting unconditionally, even if the host lacks it.
-	 */
-	return PMU_CAP_FW_WRITES | perf_cap;
+	if (vmx_pebs_supported()) {
+		perf_cap |= host_perf_cap & PERF_CAP_PEBS_MASK;
+		if ((perf_cap & PERF_CAP_PEBS_FORMAT) < 4)
+			perf_cap &= ~PERF_CAP_PEBS_BASELINE;
+	}
+
+	return perf_cap;
 }
 
 static inline u64 vmx_supported_debugctl(void)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 7ae0a82a2a78..89899d1a865d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2247,6 +2247,17 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			if (!cpuid_model_is_consistent(vcpu))
 				return 1;
 		}
+		if (data & PERF_CAP_PEBS_FORMAT) {
+			if ((data & PERF_CAP_PEBS_MASK) !=
+			    (vmx_get_perf_capabilities() & PERF_CAP_PEBS_MASK))
+				return 1;
+			if (!guest_cpuid_has(vcpu, X86_FEATURE_DS))
+				return 1;
+			if (!guest_cpuid_has(vcpu, X86_FEATURE_DTES64))
+				return 1;
+			if (!cpuid_model_is_consistent(vcpu))
+				return 1;
+		}
 		ret = kvm_set_msr_common(vcpu, msr_info);
 		break;
 
@@ -7416,6 +7427,10 @@ static __init void vmx_set_cpu_caps(void)
 		kvm_cpu_cap_clear(X86_FEATURE_INVPCID);
 	if (vmx_pt_mode_is_host_guest())
 		kvm_cpu_cap_check_and_set(X86_FEATURE_INTEL_PT);
+	if (vmx_pebs_supported()) {
+		kvm_cpu_cap_check_and_set(X86_FEATURE_DS);
+		kvm_cpu_cap_check_and_set(X86_FEATURE_DTES64);
+	}
 
 	if (!enable_sgx) {
 		kvm_cpu_cap_clear(X86_FEATURE_SGX);
-- 
2.35.1

