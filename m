Return-Path: <kvm+bounces-62569-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D524C48907
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 19:30:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 02E7A34A5CD
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 18:30:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A17EB338932;
	Mon, 10 Nov 2025 18:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AvwX9pj3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36BA83385A1;
	Mon, 10 Nov 2025 18:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762799109; cv=none; b=F3f/uHHWJNZFvzs8YkfLgqatBot/FJokgmKemP8qYbVgK+Tg2TAUauzuj7sJXzvs7P/isweLn/F2fVLDryg+5Jd27rvAZhlBNvMD4gimGoo7MRnwQOcQ6p6kqxeoMwHrAtdvXy1Mdf7DRbSEXztinuApDH8Il5ul+yBKHCdlTio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762799109; c=relaxed/simple;
	bh=YMofdhrpUU9PJUyQ+P3EJM5wMG7SVst7KrVlO53ZPUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tGoCy4WWbli+Ueh6apfAwKwPD0oSdS6AA4+PtEIy5LgR7jBbXASVbkQ5FN7rX2jwaw0Jk0Z8XERhVYesiHo8y4T9pb6wJ+KfWikcx3GwrANTNRLzh6+TnLDlzj5snjhImr9MiV6BpxQEFEXGdBVAHiqXmTLOzh74M1QLtCarSvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AvwX9pj3; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762799108; x=1794335108;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YMofdhrpUU9PJUyQ+P3EJM5wMG7SVst7KrVlO53ZPUQ=;
  b=AvwX9pj3xvXyqPM+iQ9xCA/jP6IWheYCmxq0BZ5l70A3LGJDhLSHqFp+
   5fhSw43jaoUWlmDcrSvt61tL42z/Y1UneLv45NqMgqbREMbQvXA54HAJA
   kvl7sa7Y+skng9wrosiz0nntksvHhN8bcZuIXqCM2FbUfBQW+qDrbMXkG
   Wquu5u+9X9hNkkkbFw6R5M3dKt4i0Rk4NgSAYMCVCc7rZTBIBNtP+TUMR
   9HcvMbQm1fWoXKsKiUco+6yVBlyPc/1y58nk/heZHpx70NfbE9z9L6R+W
   T3NUy2dUVQJKuY7PkA7Ii+jyoqtKOC7WCqe4MShhC2lL+26Qk8OYrq798
   Q==;
X-CSE-ConnectionGUID: tCB/QqRCTku2gAWnAZfKaA==
X-CSE-MsgGUID: ljXudI8oQeu0GMIhsFjbAA==
X-IronPort-AV: E=McAfee;i="6800,10657,11609"; a="76305526"
X-IronPort-AV: E=Sophos;i="6.19,294,1754982000"; 
   d="scan'208";a="76305526"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2025 10:25:08 -0800
X-CSE-ConnectionGUID: PJPNq06hRkO2B462uQn/9Q==
X-CSE-MsgGUID: edr6w08QSsOF/EdmhPkXZA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,294,1754982000"; 
   d="scan'208";a="219396249"
Received: from chang-linux-3.sc.intel.com (HELO chang-linux-3) ([172.25.66.172])
  by orviesa002.jf.intel.com with ESMTP; 10 Nov 2025 10:25:08 -0800
From: "Chang S. Bae" <chang.seok.bae@intel.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: pbonzini@redhat.com,
	seanjc@google.com,
	chao.gao@intel.com,
	zhao1.liu@intel.com,
	chang.seok.bae@intel.com,
	Peter Fang <peter.fang@intel.com>
Subject: [PATCH RFC v1 18/20] KVM: x86: Expose APX foundational feature bit to guests
Date: Mon, 10 Nov 2025 18:01:29 +0000
Message-ID: <20251110180131.28264-19-chang.seok.bae@intel.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251110180131.28264-1-chang.seok.bae@intel.com>
References: <20251110180131.28264-1-chang.seok.bae@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Peter Fang <peter.fang@intel.com>

Add the APX xfeature bit to the list of supported XCR0 components and
expose the APX feature to guests. Define the APX CPUID feature bits and
update the maximum supported CPUID leaf to 0x29 to include the APX leaf.
On SVM systems, ensure that the feature is not advertised as EGPR support
is not yet supported.

No APX sub-features are enumerated yet. Those will be exposed in a
separate patch.

Signed-off-by: Peter Fang <peter.fang@intel.com>
Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
---
Peter had figured out establishing this change by spotting the CPUID
maximum updates.
---
 arch/x86/kvm/cpuid.c         | 8 +++++++-
 arch/x86/kvm/reverse_cpuid.h | 2 ++
 arch/x86/kvm/svm/svm.c       | 8 ++++++++
 arch/x86/kvm/x86.c           | 3 ++-
 4 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 52524e0ca97f..b90e58f2a42f 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1031,6 +1031,7 @@ void kvm_set_cpu_caps(void)
 		F(AVX_VNNI_INT16),
 		F(PREFETCHITI),
 		F(AVX10),
+		SCATTERED_F(APX),
 	);
 
 	kvm_cpu_cap_init(CPUID_7_2_EDX,
@@ -1393,7 +1394,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 	switch (function) {
 	case 0:
 		/* Limited to the highest leaf implemented in KVM. */
-		entry->eax = min(entry->eax, 0x24U);
+		entry->eax = min(entry->eax, 0x29U);
 		break;
 	case 1:
 		cpuid_entry_override(entry, CPUID_1_EDX);
@@ -1638,6 +1639,11 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		entry->edx = 0;
 		break;
 	}
+	case 0x29: {
+		/* No APX sub-features are supported yet */
+		entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
+		break;
+	}
 	case KVM_CPUID_SIGNATURE: {
 		const u32 *sigptr = (const u32 *)KVM_SIGNATURE;
 		entry->eax = KVM_CPUID_FEATURES;
diff --git a/arch/x86/kvm/reverse_cpuid.h b/arch/x86/kvm/reverse_cpuid.h
index 743ab25ba787..e9d9fb4070ca 100644
--- a/arch/x86/kvm/reverse_cpuid.h
+++ b/arch/x86/kvm/reverse_cpuid.h
@@ -35,6 +35,7 @@
 #define X86_FEATURE_AVX_VNNI_INT16      KVM_X86_FEATURE(CPUID_7_1_EDX, 10)
 #define X86_FEATURE_PREFETCHITI         KVM_X86_FEATURE(CPUID_7_1_EDX, 14)
 #define X86_FEATURE_AVX10               KVM_X86_FEATURE(CPUID_7_1_EDX, 19)
+#define KVM_X86_FEATURE_APX             KVM_X86_FEATURE(CPUID_7_1_EDX, 21)
 
 /* Intel-defined sub-features, CPUID level 0x00000007:2 (EDX) */
 #define X86_FEATURE_INTEL_PSFD		KVM_X86_FEATURE(CPUID_7_2_EDX, 0)
@@ -126,6 +127,7 @@ static __always_inline u32 __feature_translate(int x86_feature)
 	KVM_X86_TRANSLATE_FEATURE(SGX1);
 	KVM_X86_TRANSLATE_FEATURE(SGX2);
 	KVM_X86_TRANSLATE_FEATURE(SGX_EDECCSSA);
+	KVM_X86_TRANSLATE_FEATURE(APX);
 	KVM_X86_TRANSLATE_FEATURE(CONSTANT_TSC);
 	KVM_X86_TRANSLATE_FEATURE(PERFMON_V2);
 	KVM_X86_TRANSLATE_FEATURE(RRSBA_CTRL);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index e6a082686000..da57f7506f88 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5271,6 +5271,14 @@ static __init void svm_set_cpu_caps(void)
 	 */
 	kvm_cpu_cap_clear(X86_FEATURE_BUS_LOCK_DETECT);
 	kvm_cpu_cap_clear(X86_FEATURE_MSR_IMM);
+
+	/*
+	 * If the APX xfeature bit is not supported, meaning that VMCB
+	 * support for EGPRs is unavailable, then the APX feature should
+	 * not be exposed to the guest.
+	 */
+	if (!(kvm_caps.supported_xcr0 & XFEATURE_MASK_APX))
+		kvm_cpu_cap_clear(X86_FEATURE_APX);
 }
 
 static __init int svm_hardware_setup(void)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e087db0f4153..bcf8e95d88dc 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -217,7 +217,8 @@ static struct kvm_user_return_msrs __percpu *user_return_msrs;
 #define KVM_SUPPORTED_XCR0     (XFEATURE_MASK_FP | XFEATURE_MASK_SSE \
 				| XFEATURE_MASK_YMM | XFEATURE_MASK_BNDREGS \
 				| XFEATURE_MASK_BNDCSR | XFEATURE_MASK_AVX512 \
-				| XFEATURE_MASK_PKRU | XFEATURE_MASK_XTILE)
+				| XFEATURE_MASK_PKRU | XFEATURE_MASK_XTILE \
+				| XFEATURE_MASK_APX)
 
 #define XFEATURE_MASK_CET_ALL	(XFEATURE_MASK_CET_USER | XFEATURE_MASK_CET_KERNEL)
 /*
-- 
2.51.0


