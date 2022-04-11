Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1198E4FB95B
	for <lists+kvm@lfdr.de>; Mon, 11 Apr 2022 12:21:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345377AbiDKKXW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Apr 2022 06:23:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345540AbiDKKW6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Apr 2022 06:22:58 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C38E342A1D;
        Mon, 11 Apr 2022 03:20:44 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id q19so13770973pgm.6;
        Mon, 11 Apr 2022 03:20:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Mvy32fFi5YJOBeISNyxGvIi42aJ+4st7zh32R3vsPtY=;
        b=hWyp/lvw1ZoGzyvX7x5uSNQz/NpCfWwZQmxtO1tQB3nMrzhC202g6b99MseRqCkMf6
         Hpx00nK5L3l3oRTj41MtYLFh17Mfss4kZeavMb3G77C10vxyrRFjyHfhMxX1i6X1qTb0
         +jm8uYxuEai0E8LSX0NMJ020oUYXbzBUwr2bhHFdABHYDyKHDm19QP2owQjLn6+Bvwgq
         U22LQ2tXaX3d9287YA54zDOBnu073SpZNyVXZwYa6emyy3Fip5bXSrSG8V2MqUxuEcm9
         Na1aDU2/JtYY2W9zmvPKD01dVqGWsPVEztSFQOKQ56jwqzWaBWlQG0ti9kUi9YvFQ1rx
         ECCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Mvy32fFi5YJOBeISNyxGvIi42aJ+4st7zh32R3vsPtY=;
        b=PGvj+7lMOgYfIh8GOgw8nYzwkUkahVU5uXqtpiZ/iKluETszAZ6rKLV941+tgeXSAN
         BAWTG4uaMw3GdLnpDyen9dydnDGaxX7HBF+dOnDm4YNJ3tBKzUi7tftza0N44yGfzlpZ
         ghCFMOQvAenIIuQLVS0Qk3X3GxGNlHifjigUwZfhDEceTE1hscnHCNurRwvKED5ry24F
         hc1pOx5cF2FW3jnT8umtfHKQjQrRjm6p9QF6J5wTNDtSUVellXVpibCRd+0Zi1ho3CQ7
         idPbIwCAqfOAsBFkIgNgXMqtRuq3ONzMcINtGMUynQcBLXzDnNVS1nf+av8faeKcYqvK
         ORFQ==
X-Gm-Message-State: AOAM532Wb5A7Gi99DHSvcJBtloPEEXlWFOsoCJJI1PxHqc0oTQ1/8rP5
        QUBzwsQ8MaBuSNKMbTPfH6o=
X-Google-Smtp-Source: ABdhPJzrxfTYhS3+b4VILBWfmydjH88h4ESSbV4PPOYxEutQZJQPzVEgHCN4FaI7t2E86zl/VDZMHQ==
X-Received: by 2002:a63:7f15:0:b0:398:5224:9b52 with SMTP id a21-20020a637f15000000b0039852249b52mr25693692pgd.249.1649672444171;
        Mon, 11 Apr 2022 03:20:44 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.112])
        by smtp.gmail.com with ESMTPSA id h10-20020a056a00230a00b004faa0f67c3esm34012280pfh.23.2022.04.11.03.20.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 03:20:43 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH RESEND v12 17/17] KVM: x86/pmu: Expose CPUIDs feature bits PDCM, DS, DTES64
Date:   Mon, 11 Apr 2022 18:19:46 +0800
Message-Id: <20220411101946.20262-18-likexu@tencent.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220411101946.20262-1-likexu@tencent.com>
References: <20220411101946.20262-1-likexu@tencent.com>
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
index 945d169eb07f..a6d6bb6ec9f0 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2240,6 +2240,17 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
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
 
@@ -7415,6 +7426,10 @@ static __init void vmx_set_cpu_caps(void)
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

