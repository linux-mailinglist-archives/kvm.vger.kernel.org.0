Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C415E4701E9
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 14:37:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242096AbhLJNk4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 08:40:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242348AbhLJNk0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Dec 2021 08:40:26 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C14FC0698DE;
        Fri, 10 Dec 2021 05:36:37 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id n26so8513462pff.3;
        Fri, 10 Dec 2021 05:36:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2ykxillP8HPbXSqX4iVaAV/uW81eRwsuhWePvtMN1nM=;
        b=DT6FWpArUSEWrEXjX6iYpU4WuSAK2N7uhdwaKx7Ft+4rxF6i09/aryxMUkyg3k8gKT
         AsE8fUermbmD47ZkSew8mrd9gaYdxlwt2Q5vy7r8YD/9+L0ijtJaDgPd25P1taTPAfAo
         72vqoKF/Db8HWvajpkc4GeQwbezcceFidKRTc5I6nl5tdPPl4vf+HR9TUWZ8ZWnA1SCz
         juBnCH/Snru4b8jmeWYMPnnXw6shWBX4fTxQGZ2gzD4IUWpTibT4L2pQJ3oXiMAXUpC+
         Tkc+Gx7lHD4bdM4ArpTpywzMvZUtn9x41a6AUaal9tH5kzxi2in7cPPEXtVCpgAZIPNF
         c71w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2ykxillP8HPbXSqX4iVaAV/uW81eRwsuhWePvtMN1nM=;
        b=SGxlxSPEjh0DotYdho1+sG+5GibGEur6E0L62XOg5MZ4+ryKqfPwBK5I14CiW/jsr3
         bdGkqNnkmA4mPrdVB+bmXRo0YVa+lDBLfVdwGEpN2b2ZpC9lavQ9RF7fT/Dyz8az+v9Z
         fNCvdeohQcb0lzg1hWJf9D2dqw49km1sxDiwcIbuedMBs6oF01E9lvCO3uqxBGH3WC7L
         TYn5WPkp9WfAFovocAM6jqHlxX9LysaIhPNzE1fm7IyjPvjex9LzyBFs3QM22qoltz44
         9ViozGpRYYPlMucIMP6S0K/S3RGEI3OJnhH+m33aCNmwE3fU/q304kK6hvCoI6lVP2ZR
         GYZg==
X-Gm-Message-State: AOAM530ph/hytNeAMyB1QO5mhsYSbYx+Ew+3oFkMhOu4zibLlzuobJEI
        f+aFfyVlYlBPIeDpAY7b8Oo4YKmmjns=
X-Google-Smtp-Source: ABdhPJzEeOyMELGbuDeBsmjD8Kau/JUIgRJfD7wd/EHEO/2FG3/b15ii/lD5Ym+H0CUpZzOcuEYHjw==
X-Received: by 2002:a05:6a00:230b:b0:4ae:d8b2:dc0c with SMTP id h11-20020a056a00230b00b004aed8b2dc0cmr18302250pfh.67.1639143396811;
        Fri, 10 Dec 2021 05:36:36 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id t4sm3596068pfj.168.2021.12.10.05.36.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 10 Dec 2021 05:36:36 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Like Xu <likexu@tencent.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v11 17/17] KVM: x86/pmu: Expose CPUIDs feature bits PDCM, DS, DTES64
Date:   Fri, 10 Dec 2021 21:35:25 +0800
Message-Id: <20211210133525.46465-18-likexu@tencent.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211210133525.46465-1-likexu@tencent.com>
References: <20211210133525.46465-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <like.xu@linux.intel.com>

From: Like Xu <like.xu@linux.intel.com>

The CPUID features PDCM, DS and DTES64 are required for PEBS feature.
KVM would expose CPUID feature PDCM, DS and DTES64 to guest when PEBS
is supported in the KVM on the Ice Lake server platforms.

Originally-by: Andi Kleen <ak@linux.intel.com>
Co-developed-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Co-developed-by: Luwei Kang <luwei.kang@intel.com>
Signed-off-by: Luwei Kang <luwei.kang@intel.com>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 arch/x86/kvm/vmx/capabilities.h | 26 ++++++++++++++++++--------
 arch/x86/kvm/vmx/vmx.c          | 15 +++++++++++++++
 2 files changed, 33 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index c8029b7845b6..1c47c266aca4 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -5,6 +5,7 @@
 #include <asm/vmx.h>
 
 #include "lapic.h"
+#include "pmu.h"
 
 extern bool __read_mostly enable_vpid;
 extern bool __read_mostly flexpriority_enabled;
@@ -385,20 +386,29 @@ static inline bool vmx_pt_mode_is_host_guest(void)
 	return pt_mode == PT_MODE_HOST_GUEST;
 }
 
-static inline u64 vmx_get_perf_capabilities(void)
+static inline bool vmx_pebs_supported(void)
 {
-	u64 perf_cap = 0;
-
-	if (boot_cpu_has(X86_FEATURE_PDCM))
-		rdmsrl(MSR_IA32_PERF_CAPABILITIES, perf_cap);
-
-	perf_cap &= PMU_CAP_LBR_FMT;
+	return boot_cpu_has(X86_FEATURE_PEBS) && kvm_pmu_cap.pebs_vmx;
+}
 
+static inline u64 vmx_get_perf_capabilities(void)
+{
 	/*
 	 * Since counters are virtualized, KVM would support full
 	 * width counting unconditionally, even if the host lacks it.
 	 */
-	return PMU_CAP_FW_WRITES | perf_cap;
+	u64 perf_cap = PMU_CAP_FW_WRITES;
+	u64 host_perf_cap = 0;
+
+	if (boot_cpu_has(X86_FEATURE_PDCM))
+		rdmsrl(MSR_IA32_PERF_CAPABILITIES, host_perf_cap);
+
+	perf_cap |= host_perf_cap & PMU_CAP_LBR_FMT;
+
+	if (vmx_pebs_supported())
+		perf_cap |= host_perf_cap & PERF_CAP_PEBS_MASK;
+
+	return perf_cap;
 }
 
 static inline u64 vmx_supported_debugctl(void)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index bd53f39e6283..42e46ef9e20f 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2219,6 +2219,17 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
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
 
@@ -7255,6 +7266,10 @@ static __init void vmx_set_cpu_caps(void)
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
2.33.1

