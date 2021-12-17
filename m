Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1058F478FB4
	for <lists+kvm@lfdr.de>; Fri, 17 Dec 2021 16:30:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238271AbhLQPaN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Dec 2021 10:30:13 -0500
Received: from mga03.intel.com ([134.134.136.65]:10842 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238234AbhLQPaH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Dec 2021 10:30:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639755007; x=1671291007;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Lc+hkJ6Zcnttittpo56Xg8lXuQMR5lxzOCxmw+1Adsc=;
  b=EMQu7+wC9Z6cMw1oDTgIGfL3cIC4f00e/CKKy53xkWkjJ/scu1/OC5vU
   EAERjPSV1gLojSW2btugqljLN5UClq2Tw/EYlWz8LTj9hBVW19hlk8voI
   4SGi55UmAv4Or4WhQ+cfN9L75RBP87AMb+A9iNfp/9I73q7wN9xdaUPud
   by5IJwcrt6K3bvNW6m5eDtc0OsQSK8yjv0NuYLdXa3mbR0KUmd3u8aRdx
   ql5w/zdDIcd9Vn9HkoihnzCAvAKnBsu0gZgBKwF1rzsSMbWl/k4fbmxzD
   qNOMMiY0Qn0pCvVMOybcQcYLDaqM5whkZqRNAftJMRNGX+sHwpcXWTZ89
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10200"; a="239723451"
X-IronPort-AV: E=Sophos;i="5.88,213,1635231600"; 
   d="scan'208";a="239723451"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2021 07:30:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,213,1635231600"; 
   d="scan'208";a="615588431"
Received: from 984fee00a228.jf.intel.com ([10.165.56.59])
  by orsmga004.jf.intel.com with ESMTP; 17 Dec 2021 07:30:05 -0800
From:   Jing Liu <jing2.liu@intel.com>
To:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, pbonzini@redhat.com
Cc:     seanjc@google.com, jun.nakajima@intel.com, kevin.tian@intel.com,
        jing2.liu@linux.intel.com, jing2.liu@intel.com,
        guang.zeng@intel.com, wei.w.wang@intel.com, yang.zhong@intel.com
Subject: [PATCH v2 11/23] kvm: x86: Add emulation for IA32_XFD
Date:   Fri, 17 Dec 2021 07:29:51 -0800
Message-Id: <20211217153003.1719189-12-jing2.liu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211217153003.1719189-1-jing2.liu@intel.com>
References: <20211217153003.1719189-1-jing2.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Intel's eXtended Feature Disable (XFD) feature allows the software
to dynamically adjust fpstate buffer size for XSAVE features which
have large state.

Because fpstate has been expanded for all possible dynamic xstates
at KVM_SET_CPUID2, emulation of the IA32_XFD MSR is straightforward.
For write just call fpu_update_guest_xfd() to update the guest fpu
container once all the sanity checks are passed. For read then
return the cached value in the container.

Signed-off-by: Zeng Guang <guang.zeng@intel.com>
Signed-off-by: Wei Wang <wei.w.wang@intel.com>
Signed-off-by: Jing Liu <jing2.liu@intel.com>
---
 arch/x86/kvm/x86.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e0aa4dd53c7f..a274146ef439 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1358,6 +1358,7 @@ static const u32 msrs_to_save_all[] = {
 	MSR_F15H_PERF_CTL3, MSR_F15H_PERF_CTL4, MSR_F15H_PERF_CTL5,
 	MSR_F15H_PERF_CTR0, MSR_F15H_PERF_CTR1, MSR_F15H_PERF_CTR2,
 	MSR_F15H_PERF_CTR3, MSR_F15H_PERF_CTR4, MSR_F15H_PERF_CTR5,
+	MSR_IA32_XFD,
 };
 
 static u32 msrs_to_save[ARRAY_SIZE(msrs_to_save_all)];
@@ -3668,6 +3669,19 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 1;
 		vcpu->arch.msr_misc_features_enables = data;
 		break;
+#ifdef CONFIG_X86_64
+	case MSR_IA32_XFD:
+		if (!msr_info->host_initiated &&
+		    !guest_cpuid_has(vcpu, X86_FEATURE_XFD))
+			return 1;
+
+		if (data & ~(XFEATURE_MASK_USER_DYNAMIC &
+			     vcpu->arch.guest_supported_xcr0))
+			return 1;
+
+		fpu_update_guest_xfd(&vcpu->arch.guest_fpu, data);
+		break;
+#endif
 	default:
 		if (kvm_pmu_is_valid_msr(vcpu, msr))
 			return kvm_pmu_set_msr(vcpu, msr_info);
@@ -3988,6 +4002,15 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_K7_HWCR:
 		msr_info->data = vcpu->arch.msr_hwcr;
 		break;
+#ifdef CONFIG_X86_64
+	case MSR_IA32_XFD:
+		if (!msr_info->host_initiated &&
+		    !guest_cpuid_has(vcpu, X86_FEATURE_XFD))
+			return 1;
+
+		msr_info->data = vcpu->arch.guest_fpu.fpstate->xfd;
+		break;
+#endif
 	default:
 		if (kvm_pmu_is_valid_msr(vcpu, msr_info->index))
 			return kvm_pmu_get_msr(vcpu, msr_info);
@@ -6421,6 +6444,10 @@ static void kvm_init_msr_list(void)
 			    min(INTEL_PMC_MAX_GENERIC, x86_pmu.num_counters_gp))
 				continue;
 			break;
+		case MSR_IA32_XFD:
+			if (!kvm_cpu_cap_has(X86_FEATURE_XFD))
+				continue;
+			break;
 		default:
 			break;
 		}
-- 
2.27.0

