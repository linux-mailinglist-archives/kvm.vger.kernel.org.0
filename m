Return-Path: <kvm+bounces-63767-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C591C72358
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 05:46:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by tor.lore.kernel.org (Postfix) with ESMTPS id 771D129C36
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 04:46:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23257302CB5;
	Thu, 20 Nov 2025 04:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HvmgsnBo"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67F8C3002A8;
	Thu, 20 Nov 2025 04:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763613957; cv=none; b=baYUJdzqOauqRHc5eDdkosb8JHdt0q8KjqyDvDmoknEQegqudnDN5ZQ+CI0aY4Ipq69TA4Rc42lvcI11cBCLdbNhvfjYwLtwAelr6JmcueO8ceWYK6TJWAfJ3p3uQd+IJegQ6gvZcE0MK/NziffaiRea3Eczgr1m7OLdHBUzqX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763613957; c=relaxed/simple;
	bh=IQuCfTWe01vhAbdTgWfZeYThEWknWjy3fKBQ4X+XMSc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nrVXkEemyP6K8hp6Fcem5jr7Eb86GJEPGZQi+SclxbIsFBbllO1t+9ObNxtttRyzOks+mReseqKsFM58oJQJuTGjBfLDg3Gl4J6lJVWIFkOfFl79yp0Yfw+ajMk7j3Et/7Cy/IQzigAa51Yv7FgscIWm6o0SlHmzA8eWwf6VknM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HvmgsnBo; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763613955; x=1795149955;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IQuCfTWe01vhAbdTgWfZeYThEWknWjy3fKBQ4X+XMSc=;
  b=HvmgsnBor3n4+XPEORbW2VEYHucseCuzMj81jTLrcf3tDaXsH7opzP/P
   R+0N+XdSEszf+LxVW+mBM4LhLXaSkgJVcPpV8O9PIP1T8Min10R64BaN4
   ApLcvAdzRY6xFtO173iKlayG5F/Q8e3IlfhCevD2A4T0EzWJnS/MpEzgl
   Ds/2a8o2P1r44z8b818zU42AfLGmDmv8JfnqK84GEB9gwmx/hQ3Ag698b
   tzUOZHjOG6vV8PDhZ9ybm0Z8L/rU1NO4yT662i+9SrZtj9/fr3vo4joeH
   hHyOEMLm6mOLEoNNizRlJ+jsvj8MXCKo9k0kEZgrdlTpPbVsBzB3m6Qa3
   Q==;
X-CSE-ConnectionGUID: Iy3WzxDQQjmu3AZRTPn2lw==
X-CSE-MsgGUID: 7IPtmVf0QqG3IVcJxwktmg==
X-IronPort-AV: E=McAfee;i="6800,10657,11618"; a="65602265"
X-IronPort-AV: E=Sophos;i="6.19,317,1754982000"; 
   d="scan'208";a="65602265"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2025 20:45:55 -0800
X-CSE-ConnectionGUID: rSK70yxqQPW3UG3G2aOPrw==
X-CSE-MsgGUID: f/5HBFHNTXWV5vdWFwkraw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,317,1754982000"; 
   d="scan'208";a="196380886"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa005.jf.intel.com with ESMTP; 19 Nov 2025 20:45:52 -0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Chao Gao <chao.gao@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	Xudong Hao <xudong.hao@intel.com>
Subject: [PATCH 2/4] KVM: x86: Advertise AMX CPUIDs in subleaf 0x1E.0x1 to userspace
Date: Thu, 20 Nov 2025 13:07:18 +0800
Message-Id: <20251120050720.931449-3-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251120050720.931449-1-zhao1.liu@intel.com>
References: <20251120050720.931449-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Define and pass AMX CPUIDs (0x1E.0x1) through to userspace.

Intel Diamond Rapids adds new AMX instructions to support new formats
and memory operations [*], and introduces the CPUID subleaf 0x1E.0x1
to centralize the discrete AMX feature bits within EAX.

Since these AMX features have no actual kernel usages, define them as
KVM-only features in reverse_cpuid.h.

In addition to the new features, CPUID 0x1E.0x1.EAX[bits 0-3] are
mirrored positions of existing AMX feature bits distributed across the
0x7 leaves. To avoid duplicate feature names, name these mirror bits
with a *_MIRROR suffix, and define them in reverse_cpuid.h as KVM-only
features as well.

Advertise new CPUID subleaf 0x1E.0x1 with its AMX CPUID feature bits to
userspace for guest use. It's safe since no additional enabling work
is needed in the host kernel.

[*]: Intel Architecture Instruction Set Extensions and Future Features
     (rev.059).

Tested-by: Xudong Hao <xudong.hao@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
Reference link: https://cdrdv2.intel.com/v1/dl/getContent/865891
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/cpuid.c            | 25 +++++++++++++++++++++++++
 arch/x86/kvm/reverse_cpuid.h    | 11 +++++++++++
 3 files changed, 37 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 48598d017d6f..db7bf364f4fc 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -776,6 +776,7 @@ enum kvm_only_cpuid_leafs {
 	CPUID_24_0_EBX,
 	CPUID_8000_0021_ECX,
 	CPUID_7_1_ECX,
+	CPUID_1E_1_EAX,
 	NR_KVM_CPU_CAPS,
 
 	NKVMCAPINTS = NR_KVM_CPU_CAPS - NCAPINTS,
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 372d82bae272..0795c9ecfd4b 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1057,6 +1057,17 @@ void kvm_set_cpu_caps(void)
 		SCATTERED_F(SGX_EDECCSSA),
 	);
 
+	kvm_cpu_cap_init(CPUID_1E_1_EAX,
+		F(AMX_INT8_MIRROR),
+		F(AMX_BF16_MIRROR),
+		F(AMX_COMPLEX_MIRROR),
+		F(AMX_FP16_MIRROR),
+		F(AMX_FP8),
+		F(AMX_TF32),
+		F(AMX_AVX512),
+		F(AMX_MOVRS),
+	);
+
 	kvm_cpu_cap_init(CPUID_24_0_EBX,
 		F(AVX10_128),
 		F(AVX10_256),
@@ -1616,6 +1627,20 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 			entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
 			break;
 		}
+
+		max_idx = entry->eax = min(entry->eax, 1u);
+
+		/* KVM only supports up to 0x1e.0x1, capped above via min(). */
+		if (max_idx >= 1) {
+			entry = do_host_cpuid(array, function, 1);
+			if (!entry)
+				goto out;
+
+			cpuid_entry_override(entry, CPUID_1E_1_EAX);
+			entry->ebx = 0;
+			entry->ecx = 0;
+			entry->edx = 0;
+		}
 		break;
 	case 0x24: {
 		u8 avx10_version;
diff --git a/arch/x86/kvm/reverse_cpuid.h b/arch/x86/kvm/reverse_cpuid.h
index 743ab25ba787..99ec9e656655 100644
--- a/arch/x86/kvm/reverse_cpuid.h
+++ b/arch/x86/kvm/reverse_cpuid.h
@@ -44,6 +44,16 @@
 #define KVM_X86_FEATURE_BHI_CTRL	KVM_X86_FEATURE(CPUID_7_2_EDX, 4)
 #define X86_FEATURE_MCDT_NO		KVM_X86_FEATURE(CPUID_7_2_EDX, 5)
 
+/* Intel-defined sub-features, CPUID level 0x0000001E:1 (EAX) */
+#define X86_FEATURE_AMX_INT8_MIRROR	KVM_X86_FEATURE(CPUID_1E_1_EAX, 0) /* Mirror of X86_FEATURE_AMX_INT8 */
+#define X86_FEATURE_AMX_BF16_MIRROR	KVM_X86_FEATURE(CPUID_1E_1_EAX, 1) /* Mirror of X86_FEATURE_AMX_BF16 */
+#define X86_FEATURE_AMX_COMPLEX_MIRROR	KVM_X86_FEATURE(CPUID_1E_1_EAX, 2) /* Mirror of X86_FEATURE_AMX_COMPLEX */
+#define X86_FEATURE_AMX_FP16_MIRROR	KVM_X86_FEATURE(CPUID_1E_1_EAX, 3) /* Mirror of X86_FEATURE_AMX_FP16 */
+#define X86_FEATURE_AMX_FP8		KVM_X86_FEATURE(CPUID_1E_1_EAX, 4)
+#define X86_FEATURE_AMX_TF32		KVM_X86_FEATURE(CPUID_1E_1_EAX, 6)
+#define X86_FEATURE_AMX_AVX512		KVM_X86_FEATURE(CPUID_1E_1_EAX, 7)
+#define X86_FEATURE_AMX_MOVRS		KVM_X86_FEATURE(CPUID_1E_1_EAX, 8)
+
 /* Intel-defined sub-features, CPUID level 0x00000024:0 (EBX) */
 #define X86_FEATURE_AVX10_128		KVM_X86_FEATURE(CPUID_24_0_EBX, 16)
 #define X86_FEATURE_AVX10_256		KVM_X86_FEATURE(CPUID_24_0_EBX, 17)
@@ -91,6 +101,7 @@ static const struct cpuid_reg reverse_cpuid[] = {
 	[CPUID_24_0_EBX]      = {      0x24, 0, CPUID_EBX},
 	[CPUID_8000_0021_ECX] = {0x80000021, 0, CPUID_ECX},
 	[CPUID_7_1_ECX]       = {         7, 1, CPUID_ECX},
+	[CPUID_1E_1_EAX]      = {      0x1e, 1, CPUID_EAX},
 };
 
 /*
-- 
2.34.1


