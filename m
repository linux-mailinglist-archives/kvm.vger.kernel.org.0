Return-Path: <kvm+bounces-32679-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DD779DB0FE
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 02:42:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B5DC316738D
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 01:42:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F5181AE016;
	Thu, 28 Nov 2024 01:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="arhCNEIQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f201.google.com (mail-il1-f201.google.com [209.85.166.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABC341AA1FE
	for <kvm@vger.kernel.org>; Thu, 28 Nov 2024 01:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732757723; cv=none; b=gkhfZCrcDOuLKMB3+aPvKHSGTw36eSBd6nvX1tWTtsadW3I4G485bXA/1X18gq2xI4nzGmTyNUpljUtUDCO1GHVAjqO2LbPpaALWRuJY5Ci8KONKheCHaeEuN/IkDCEGfj7c7DwiIaYVF3J40awQEGJjAib+S9J46Dko+zqepJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732757723; c=relaxed/simple;
	bh=iscQsFl5jn+TPuQsDMETJQuayZSVqsIm4Yh6FwXeCHc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OAZ+sdjngXvSx8iQoAcsGmxRJl6II6I73J6f2XX8/duOolvB03US1xgfMD0BjA6O6HQXVRRQJeLp+e7QaYvNErZn28gO4ZDTHrFJncxpMlV3kL5sIrr/XO1jqw3AOY5tptZjjaLxjyhZYpHZj5vg6jxHIDgUhQNzeXvhDxFCWxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=arhCNEIQ; arc=none smtp.client-ip=209.85.166.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-il1-f201.google.com with SMTP id e9e14a558f8ab-3a7932544c4so3146355ab.1
        for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 17:35:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732757721; x=1733362521; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=or4dfW5NPPoBHl83ebbhI2Kl40dJajWBKajgnr00qAI=;
        b=arhCNEIQWJxXVCjhwGHwEZ4aie/XqprDER+g+XnJ1elRm5ZDK2IgX+kBJZHMB1fVLi
         gjvUVpUhAWCMwhEPdoxkvzJci0SJpwDvIr1Ybn5NRNsPn1vwOI5f42lNGFUMMSW/AVjz
         vMvu/FOrDK1dGhU7NKMAI9alEf7qxLGY4eJTsSdMTULr2K1hjJGDp8xZGUor8sHKgv3j
         1bG3Tc+SqowgCBEC3FnJqmQ8sy2pMUbq9SvjpQxcfqJu4oJN6c8eaWEgaobWLG3jm5QI
         5qy2XsLpcXIkUP6SvIHiJcyMtjjuUJNzQehfU+/flipcYR9HH/NbS3sahHwhbq0inBKK
         nR4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732757721; x=1733362521;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=or4dfW5NPPoBHl83ebbhI2Kl40dJajWBKajgnr00qAI=;
        b=FTZbjOgBEYVTdiFKB+WleCKl8ZtBPeI+CZxFPViYkKzWJZLRxrJsRRHri0N9b0wI3q
         1fSoHmtvHHTRvajuy6SBzalF9RwYFLXZliVNH79nKYI8tPXf+ajFe7z7Xc2xHCgMP7Oo
         wNDqCYbvBtLS9F4fLXT1DIs/a5qH4+yyIJBB6oh1NSf+j2sGluOxjLQARfMpV1AZ3ISl
         LRwnaQ7xdKTp6GV9Gyg90Ced15PC9Fv+De2K+r4nZ8Dka2Khgzvjf15Bx9m4tETfFTj9
         Zgg9qTfKjeXCE1iV6o20n9Vjujcw2aPvGFGXygr0pc3qihyiswwRWoxERkLbZ/vSsEWp
         /KmQ==
X-Gm-Message-State: AOJu0YxwpHsqwAt9uMJ2Z2pNpNGGEffVagSltXXCTOQWEL1UGLzoMpvs
	FPOZJD+z9ZjwRq0CZrdKO70V0YDs88jHNWVuj/fp72Z6cGo1Ez+54C6Mat5ZzCVusHrHUeZFJUt
	4yA==
X-Google-Smtp-Source: AGHT+IHqvArLP/DTLOy9MpelaMy9pJau/26PUrYe6mAmbmDCvrOFJgFkHYoGtDP5b19XPXc68OHJeJQvhkI=
X-Received: from pgbdl2.prod.google.com ([2002:a05:6a02:d02:b0:7fc:219e:bdd9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6e02:20e3:b0:3a7:87f2:b010
 with SMTP id e9e14a558f8ab-3a7c552574bmr59060575ab.5.1732757720946; Wed, 27
 Nov 2024 17:35:20 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 27 Nov 2024 17:33:55 -0800
In-Reply-To: <20241128013424.4096668-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241128013424.4096668-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241128013424.4096668-29-seanjc@google.com>
Subject: [PATCH v3 28/57] KVM: x86: Harden CPU capabilities processing against
 out-of-scope features
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

Add compile-time assertions to verify that usage of F() and friends in
kvm_set_cpu_caps() is scoped to the correct CPUID word, e.g. to detect
bugs where KVM passes a feature bit from word X into word y.

Add a one-off assertion in the aliased feature macro to ensure that only
word 0x8000_0001.EDX aliased the features defined for 0x1.EDX.

To do so, convert kvm_cpu_cap_init() to a macro and have it define a
local variable to track which CPUID word is being initialized that is
then used to validate usage of F() (all of the inputs are compile-time
constants and thus can be fed into BUILD_BUG_ON()).

Redefine KVM_VALIDATE_CPU_CAP_USAGE after kvm_set_cpu_caps() to be a nop
so that F() can be used in other flows that aren't as easily hardened,
e.g. __do_cpuid_func_emulated() and __do_cpuid_func().

Invoke KVM_VALIDATE_CPU_CAP_USAGE() in SF() and X86_64_F() to ensure the
validation occurs, e.g. if the usage of F() is completely compiled out
(which shouldn't happen for boot_cpu_has(), but could happen in the future,
e.g. if KVM were to use cpu_feature_enabled()).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c | 51 ++++++++++++++++++++++++++++++--------------
 1 file changed, 35 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index efff83da3df3..c9a8513dbc30 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -602,35 +602,53 @@ static __always_inline u32 raw_cpuid_get(struct cpuid_reg cpuid)
 	return *__cpuid_entry_get_reg(&entry, cpuid.reg);
 }
 
-static __always_inline void kvm_cpu_cap_init(u32 leaf, u32 mask)
-{
-	const struct cpuid_reg cpuid = x86_feature_cpuid(leaf * 32);
+/*
+ * For kernel-defined leafs, mask the boot CPU's pre-populated value.  For KVM-
+ * defined leafs, explicitly set the leaf, as KVM is the one and only authority.
+ */
+#define kvm_cpu_cap_init(leaf, mask)					\
+do {									\
+	const struct cpuid_reg cpuid = x86_feature_cpuid(leaf * 32);	\
+	const u32 __maybe_unused kvm_cpu_cap_init_in_progress = leaf;	\
+									\
+	if (leaf < NCAPINTS)						\
+		kvm_cpu_caps[leaf] &= (mask);				\
+	else								\
+		kvm_cpu_caps[leaf] = (mask);				\
+									\
+	kvm_cpu_caps[leaf] &= raw_cpuid_get(cpuid);			\
+} while (0)
 
-	/*
-	 * For kernel-defined leafs, mask the boot CPU's pre-populated value.
-	 * For KVM-defined leafs, explicitly set the leaf, as KVM is the one
-	 * and only authority.
-	 */
-	if (leaf < NCAPINTS)
-		kvm_cpu_caps[leaf] &= mask;
-	else
-		kvm_cpu_caps[leaf] = mask;
+/*
+ * Assert that the feature bit being declared, e.g. via F(), is in the CPUID
+ * word that's being initialized.  Exempt 0x8000_0001.EDX usage of 0x1.EDX
+ * features, as AMD duplicated many 0x1.EDX features into 0x8000_0001.EDX.
+ */
+#define KVM_VALIDATE_CPU_CAP_USAGE(name)				\
+do {									\
+	u32 __leaf = __feature_leaf(X86_FEATURE_##name);		\
+									\
+	BUILD_BUG_ON(__leaf != kvm_cpu_cap_init_in_progress);		\
+} while (0)
 
-	kvm_cpu_caps[leaf] &= raw_cpuid_get(cpuid);
-}
-
-#define F feature_bit
+#define F(name)							\
+({								\
+	KVM_VALIDATE_CPU_CAP_USAGE(name);			\
+	feature_bit(name);					\
+})
 
 /* Scattered Flag - For features that are scattered by cpufeatures.h. */
 #define SF(name)						\
 ({								\
 	BUILD_BUG_ON(X86_FEATURE_##name >= MAX_CPU_FEATURES);	\
+	KVM_VALIDATE_CPU_CAP_USAGE(name);			\
 	(boot_cpu_has(X86_FEATURE_##name) ? F(name) : 0);	\
 })
 
 /* Features that KVM supports only on 64-bit kernels. */
 #define X86_64_F(name)						\
 ({								\
+	KVM_VALIDATE_CPU_CAP_USAGE(name);			\
 	(IS_ENABLED(CONFIG_X86_64) ? F(name) : 0);		\
 })
 
@@ -641,6 +659,7 @@ static __always_inline void kvm_cpu_cap_init(u32 leaf, u32 mask)
 #define ALIASED_1_EDX_F(name)							\
 ({										\
 	BUILD_BUG_ON(__feature_leaf(X86_FEATURE_##name) != CPUID_1_EDX);	\
+	BUILD_BUG_ON(kvm_cpu_cap_init_in_progress != CPUID_8000_0001_EDX);	\
 	feature_bit(name);							\
 })
 
-- 
2.47.0.338.g60cca15819-goog


