Return-Path: <kvm+bounces-32653-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BE3BE9DB0C7
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 02:35:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 327E4B20BC1
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 01:35:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 877D381741;
	Thu, 28 Nov 2024 01:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dHZGYmXU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D45A4CDEC
	for <kvm@vger.kernel.org>; Thu, 28 Nov 2024 01:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732757677; cv=none; b=uY20dpZ07O53+4BvdYAhQoZiIJcuCAQwrGCjHMAZOEGvPaexW8g0F6MLH/J6Qn5L/6jeTNg+/dnQzQjpUdQA4Edx7x9kP5kSO79XT/RjKhNGq1GEOn85fzdcan1OjwfYI3etOeWbjFDrNjFij3NXutksqREh51Th5UVDcmGYuRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732757677; c=relaxed/simple;
	bh=hYeQH0cnFNph4gq4o9bmGO4zv0NeN0pKqksbk4WKQVo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NoGHEmwMiFXJt7fKM9vX9uiLzr37crsZ5AQT3EZ39cH5zSlUBuLn2iyLzA8jC7D5Y4NVK7ftBZyEj2Ivga5GHkyXSuUBWCN38B8c1WbrUvpUz174N4NZajUAlYQbawgJIzeFXyTSYAufB2kjJkTD+R+5TciXFB/RJsj5prlQ9xY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dHZGYmXU; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2edeef8a994so387285a91.2
        for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 17:34:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732757675; x=1733362475; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=w0T1o7JOZFfzGvrXyxDf48T55kuY+CtU7N9pEQ+8xFU=;
        b=dHZGYmXUlg17fuDqtOqfMeqBcLMCsR5867e80+2csvlmUkPjiYleH3LPes5F669Lii
         bwE/D4Ya3ZMxruRs0GirjmWamMUT9hjU4la/uQNi/fI0I3U6kaQz66FEyhvRWJnyfyg/
         Pxmvyfi5j8Yq6QGofaLKWm4xmAWta5iuyaTbGAtjuuwV5VyWI8cU4i5/zts4ar3Xf4/U
         v+6Qh7abV4P1vQK6n9f0Q7ME+qkVy2EZ9HQX54bmPIVoWbEv9uERs3dbhxQHToEBRPDM
         UfGdclGccaybePtKcBqpFRaOrvukus2mug45gfxxIXx7kGUHs/RtoMnaP6jimsBstbAr
         F3bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732757675; x=1733362475;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=w0T1o7JOZFfzGvrXyxDf48T55kuY+CtU7N9pEQ+8xFU=;
        b=wfMNWE2PI1sah0P5YEnGMRmmq2v6YdpNw0XPrfGIt9x64eZSuqfYA1kn0OXWOQtbxE
         SAhAQ+DrTPGItsLXHfzjTZFX/eRT9QB3iRhAPlz9cFsUgEeMsUeTrYDX/IXIansjgcTM
         /GRqQ9s/BEcGmaNKYezzVWJNnbb/MpPUF3X3s64Uw1AYEl4zLdOok3LPFA4HxtO5LJ/2
         fgut2rPMzDDKUl24319rrmXywngSezqvQO6+lE4KVv0ZrdQj4c8X37zubUnnpsa+J2ky
         mRSQmQusydAugHvzCAtVI7cI0OOOnpOnuM0dqI537bT8nTeO213loWCxk/QoDj0XW+M3
         jcAA==
X-Gm-Message-State: AOJu0Yx3gHD1iJdxe6JhjpQueVIlKIRmKbQBbHR1cHpysF8OEG9PbAH5
	OGJAWod9Vrm//V3Y7g4v1Hs53UgEiKXZ7E+rrbnRV5/tAg0bKizWmT4yRySFXisBca8hjdTUqtG
	eZw==
X-Google-Smtp-Source: AGHT+IHDd5pGSMVrB0JSh8VsrZ6k2engOzJtEji7Z7aPSZjMqbRPkWEXgFxjpCwpDi/5EAV05cqaqCdDPHU=
X-Received: from pjbst14.prod.google.com ([2002:a17:90b:1fce:b0:2ea:9d23:79a0])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:164a:b0:2ea:9309:7594
 with SMTP id 98e67ed59e1d1-2ee08e997e9mr6634363a91.4.1732757675429; Wed, 27
 Nov 2024 17:34:35 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 27 Nov 2024 17:33:29 -0800
In-Reply-To: <20241128013424.4096668-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241128013424.4096668-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241128013424.4096668-3-seanjc@google.com>
Subject: [PATCH v3 02/57] KVM: x86: Limit use of F() and SF() to kvm_cpu_cap_{mask,init_kvm_defined}()
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, Jarkko Sakkinen <jarkko@kernel.org>
Cc: kvm@vger.kernel.org, linux-sgx@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>, 
	Hou Wenlong <houwenlong.hwl@antgroup.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Kechen Lu <kechenl@nvidia.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Yang Weijiang <weijiang.yang@intel.com>, 
	Robert Hoo <robert.hoo.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Define and undefine the F() and SF() macros precisely around
kvm_set_cpu_caps() to make it all but impossible to use the macros outside
of kvm_cpu_cap_{mask,init_kvm_defined}().  Currently, F() is a simple
passthrough, but SF() is actively dangerous as it checks that the scattered
feature is supported by the host kernel.

And usage outside of the aforementioned helpers will run afoul of future
changes to harden KVM's CPUID management.

Opportunistically switch to feature_bit() when stuffing LA57 based on raw
hardware support.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c | 31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 776f24408fa3..eb4b32bcfa56 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -61,15 +61,6 @@ u32 xstate_required_size(u64 xstate_bv, bool compacted)
 	return ret;
 }
 
-#define F feature_bit
-
-/* Scattered Flag - For features that are scattered by cpufeatures.h. */
-#define SF(name)						\
-({								\
-	BUILD_BUG_ON(X86_FEATURE_##name >= MAX_CPU_FEATURES);	\
-	(boot_cpu_has(X86_FEATURE_##name) ? F(name) : 0);	\
-})
-
 /*
  * Magic value used by KVM when querying userspace-provided CPUID entries and
  * doesn't care about the CPIUD index because the index of the function in
@@ -604,6 +595,15 @@ static __always_inline void kvm_cpu_cap_mask(enum cpuid_leafs leaf, u32 mask)
 	__kvm_cpu_cap_mask(leaf);
 }
 
+#define F feature_bit
+
+/* Scattered Flag - For features that are scattered by cpufeatures.h. */
+#define SF(name)						\
+({								\
+	BUILD_BUG_ON(X86_FEATURE_##name >= MAX_CPU_FEATURES);	\
+	(boot_cpu_has(X86_FEATURE_##name) ? F(name) : 0);	\
+})
+
 void kvm_set_cpu_caps(void)
 {
 #ifdef CONFIG_X86_64
@@ -668,7 +668,7 @@ void kvm_set_cpu_caps(void)
 		F(SGX_LC) | F(BUS_LOCK_DETECT)
 	);
 	/* Set LA57 based on hardware capability. */
-	if (cpuid_ecx(7) & F(LA57))
+	if (cpuid_ecx(7) & feature_bit(LA57))
 		kvm_cpu_cap_set(X86_FEATURE_LA57);
 
 	/*
@@ -850,6 +850,9 @@ void kvm_set_cpu_caps(void)
 }
 EXPORT_SYMBOL_GPL(kvm_set_cpu_caps);
 
+#undef F
+#undef SF
+
 struct kvm_cpuid_array {
 	struct kvm_cpuid_entry2 *entries;
 	int maxnent;
@@ -925,14 +928,14 @@ static int __do_cpuid_func_emulated(struct kvm_cpuid_array *array, u32 func)
 		++array->nent;
 		break;
 	case 1:
-		entry->ecx = F(MOVBE);
+		entry->ecx = feature_bit(MOVBE);
 		++array->nent;
 		break;
 	case 7:
 		entry->flags |= KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
 		entry->eax = 0;
 		if (kvm_cpu_cap_has(X86_FEATURE_RDTSCP))
-			entry->ecx = F(RDPID);
+			entry->ecx = feature_bit(RDPID);
 		++array->nent;
 		break;
 	default:
@@ -1082,7 +1085,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 			goto out;
 
 		cpuid_entry_override(entry, CPUID_D_1_EAX);
-		if (entry->eax & (F(XSAVES)|F(XSAVEC)))
+		if (entry->eax & (feature_bit(XSAVES) | feature_bit(XSAVEC)))
 			entry->ebx = xstate_required_size(permitted_xcr0 | permitted_xss,
 							  true);
 		else {
@@ -1627,7 +1630,7 @@ bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
 			u64 data;
 		        if (!__kvm_get_msr(vcpu, MSR_IA32_TSX_CTRL, &data, true) &&
 			    (data & TSX_CTRL_CPUID_CLEAR))
-				*ebx &= ~(F(RTM) | F(HLE));
+				*ebx &= ~(feature_bit(RTM) | feature_bit(HLE));
 		} else if (function == 0x80000007) {
 			if (kvm_hv_invtsc_suppressed(vcpu))
 				*edx &= ~feature_bit(CONSTANT_TSC);
-- 
2.47.0.338.g60cca15819-goog


