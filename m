Return-Path: <kvm+bounces-5001-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E31CD81B1E2
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 10:16:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 20D711C21C42
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 09:16:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2485857305;
	Thu, 21 Dec 2023 09:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XpkKiNh7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B163B55763;
	Thu, 21 Dec 2023 09:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1703149432; x=1734685432;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4OgIxio6Sgg6qCqmMI3dmUyrNdmCfi/Fz+DUsVjuAWg=;
  b=XpkKiNh7AXE07srRYCPCA5mSUfU6FuTZoVm0JNpq6GIYR+dW8YU11KBJ
   vj4JBWrAIH+VKT9wbBGxuwKuNJVfxJSw+R+F8eIfMSyKRuS8WB/8hf+Wa
   Zt26F9WeXssrgd42OWjJg/ZY9OsxKorrXJPJI+J4pcAKmtB+AEqGJ2gOj
   YOQ/fliFqyFk9JYVBaEH/sScB592zrTjR1DMwlJJ9uVAqPyjVZZAvUBFI
   2aPvJ4s/dzPnUYMPXuOIfxfScFN6iPP0zLIXmd/+KfTaMb8HuDnClm1R3
   C+qzknQK9s+cooL5gcXSDQuDbFSDGlBtSmv+bwhRPqwolzayFyunQjq8Z
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10930"; a="398729678"
X-IronPort-AV: E=Sophos;i="6.04,293,1695711600"; 
   d="scan'208";a="398729678"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2023 01:03:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10930"; a="900028617"
X-IronPort-AV: E=Sophos;i="6.04,293,1695711600"; 
   d="scan'208";a="900028617"
Received: from 984fee00a5ca.jf.intel.com (HELO embargo.jf.intel.com) ([10.165.9.183])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2023 01:03:11 -0800
From: Yang Weijiang <weijiang.yang@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	dave.hansen@intel.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: peterz@infradead.org,
	chao.gao@intel.com,
	rick.p.edgecombe@intel.com,
	mlevitsk@redhat.com,
	john.allen@amd.com,
	weijiang.yang@intel.com
Subject: [PATCH v8 17/26] KVM: x86: Report KVM supported CET MSRs as to-be-saved
Date: Thu, 21 Dec 2023 09:02:30 -0500
Message-Id: <20231221140239.4349-18-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20231221140239.4349-1-weijiang.yang@intel.com>
References: <20231221140239.4349-1-weijiang.yang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add CET MSRs to the list of MSRs reported to userspace if the feature,
i.e. IBT or SHSTK, associated with the MSRs is supported by KVM.

SSP can only be read via RDSSP. Writing even requires destructive and
potentially faulting operations such as SAVEPREVSSP/RSTORSSP or
SETSSBSY/CLRSSBSY. Let the host use a pseudo-MSR that is just a wrapper
for the GUEST_SSP field of the VMCS.

Suggested-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/include/uapi/asm/kvm_para.h |  1 +
 arch/x86/kvm/vmx/vmx.c               |  2 ++
 arch/x86/kvm/x86.c                   | 18 ++++++++++++++++++
 3 files changed, 21 insertions(+)

diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
index 6e64b27b2c1e..9864bbcf2470 100644
--- a/arch/x86/include/uapi/asm/kvm_para.h
+++ b/arch/x86/include/uapi/asm/kvm_para.h
@@ -58,6 +58,7 @@
 #define MSR_KVM_ASYNC_PF_INT	0x4b564d06
 #define MSR_KVM_ASYNC_PF_ACK	0x4b564d07
 #define MSR_KVM_MIGRATION_CONTROL	0x4b564d08
+#define MSR_KVM_SSP	0x4b564d09
 
 struct kvm_steal_time {
 	__u64 steal;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d21f55f323ea..b2f6bcf3bf9b 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7007,6 +7007,8 @@ static bool vmx_has_emulated_msr(struct kvm *kvm, u32 index)
 	case MSR_AMD64_TSC_RATIO:
 		/* This is AMD only.  */
 		return false;
+	case MSR_KVM_SSP:
+		return kvm_cpu_cap_has(X86_FEATURE_SHSTK);
 	default:
 		return true;
 	}
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b418e4f5277b..a7368adad6b8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1476,6 +1476,9 @@ static const u32 msrs_to_save_base[] = {
 
 	MSR_IA32_XFD, MSR_IA32_XFD_ERR,
 	MSR_IA32_XSS,
+	MSR_IA32_U_CET, MSR_IA32_S_CET,
+	MSR_IA32_PL0_SSP, MSR_IA32_PL1_SSP, MSR_IA32_PL2_SSP,
+	MSR_IA32_PL3_SSP, MSR_IA32_INT_SSP_TAB,
 };
 
 static const u32 msrs_to_save_pmu[] = {
@@ -1579,6 +1582,7 @@ static const u32 emulated_msrs_all[] = {
 
 	MSR_K7_HWCR,
 	MSR_KVM_POLL_CONTROL,
+	MSR_KVM_SSP,
 };
 
 static u32 emulated_msrs[ARRAY_SIZE(emulated_msrs_all)];
@@ -7428,6 +7432,20 @@ static void kvm_probe_msr_to_save(u32 msr_index)
 		if (!kvm_caps.supported_xss)
 			return;
 		break;
+	case MSR_IA32_U_CET:
+	case MSR_IA32_S_CET:
+		if (!kvm_cpu_cap_has(X86_FEATURE_SHSTK) &&
+		    !kvm_cpu_cap_has(X86_FEATURE_IBT))
+			return;
+		break;
+	case MSR_IA32_INT_SSP_TAB:
+		if (!kvm_cpu_cap_has(X86_FEATURE_LM))
+			return;
+		fallthrough;
+	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
+		if (!kvm_cpu_cap_has(X86_FEATURE_SHSTK))
+			return;
+		break;
 	default:
 		break;
 	}
-- 
2.39.3


