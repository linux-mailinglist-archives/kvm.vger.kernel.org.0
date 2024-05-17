Return-Path: <kvm+bounces-17677-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D7058C8B7A
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 19:47:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C1ABC28A244
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 17:47:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90A6315219B;
	Fri, 17 May 2024 17:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="a5FjFnp1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3469C1509B8
	for <kvm@vger.kernel.org>; Fri, 17 May 2024 17:40:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715967633; cv=none; b=n7FK7kBs9VTt37kuElXk+Uzu/LEc4Co2gsHQMfELCuFct5fmATpJnGoV+EhrFLtaiPRfQqEKkx+UVHxwdQvarRJIKqhwn3mSDWnKtOrcZG7eJ7QCg75KdSd4jufzH8V6GRn1CIiVDI+pPRGtBHbmfmwKuJELg1F49hrRaaws0+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715967633; c=relaxed/simple;
	bh=NqsRgHWRN6F44HPpFxnftLqdK5RpQV2+BDjK35Q0DRk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kTc++v/tXsuF7zo3ayt73HuTfZ0arx3bThYjku6FkM8BBrdnjCWxFxxYBNtQcQq7Xs/w03OtzCmHofhcaOI4N2iln1yzkgWJSRVIXaDN7X9GLbH0fyfPBN6iekZepMsV/OH+b8Zh8yKWmV7JtINOyV209+by5Xta9YjAvlZuFEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=a5FjFnp1; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-61c9e368833so180137657b3.3
        for <kvm@vger.kernel.org>; Fri, 17 May 2024 10:40:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715967631; x=1716572431; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=afJWK5FLO96r/JX5VZZ/glVEZp394HL111OEQ71TOyU=;
        b=a5FjFnp1Bg5CKZHs7JdTMQX9kWpDCxxXPvvlC+J/im9hOuJTDGyN2RohASe4fuIIqD
         h6yQ0rgoQ7vy9dwLHav3GT6XO8P6ZtRlhjQ6X6ySQ7MUC++cAmZVIPSYBE90QTiq2P6b
         Wacya9p03eks1DJctOc5eDTkI3TD0andW/zS28Y80Z0OceJY8Kb2zgX3Qupiv0RMVVJf
         k/vmxTfYF6PwYItgMPIQs0rYAv3kDK8YowEDgW9GZHLBEgrLQ7ytXTkw+d8Oc4ssV7GI
         r6NJSBV0nFwD+DC/wUmeaa1RFnjbX4YACWwJ65M1z75A4epmDkSOpAN51f12q1x1h+dY
         92PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715967631; x=1716572431;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=afJWK5FLO96r/JX5VZZ/glVEZp394HL111OEQ71TOyU=;
        b=An/NS6ygp7a7MZw77XbPmPKK6XRdfvRPqQERwddlE/AA/6740dVvf2MvVOFQzVirLp
         w4rLAeXCDUEG2pgGbihLzK7LQLrVLVUZSeS8p2MNq9wVdci3u1GbZ0VZIC2czLIM5484
         d7NaO8zBpy9KGA2CalB8MmL2iI7Gs7NfGFj22kDYMn6D7BsJB33n9pRFngQLtstVKJme
         XUmUyK9GCVw4TIOf3LKs9oKbT7OknLzwvcrzFN1A8wgL5uW1pmQ/HzNW0V2bDh30dtGP
         2D8YE14yB04AT7xP4JFC95+zdTUPVl/cE9BP8+olrhu+sJWZjGneTkfpHX4TJhYgW8lD
         pc3w==
X-Gm-Message-State: AOJu0YxvQTbkj8npngNqOu+WH6sAdA01KxL5xPSUkYdA5smln5Q5eft7
	jbrgWU7kHrlnMl4aPsK9RCtlyhUv3PrV7fiqTUSQIPaaHyVPDrXieWnI24Is6Mc8nHgSdbrBZdC
	PNw==
X-Google-Smtp-Source: AGHT+IFrZKsGEJGS1S/CwuQF2ov/IS775/VqwG2RQf97kyUSXSruoGHTyK8ovIRSZ6CHbafgkW04DSAj4mQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:6687:b0:61b:e73d:bea2 with SMTP id
 00721157ae682-622aff9bee6mr55768057b3.5.1715967631297; Fri, 17 May 2024
 10:40:31 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 17 May 2024 10:39:02 -0700
In-Reply-To: <20240517173926.965351-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240517173926.965351-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.0.215.g3402c0e53f-goog
Message-ID: <20240517173926.965351-26-seanjc@google.com>
Subject: [PATCH v2 25/49] KVM: x86: Harden CPU capabilities processing against
 out-of-scope features
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Hou Wenlong <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Maxim Levitsky <mlevitsk@redhat.com>, 
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
 arch/x86/kvm/cpuid.c | 55 +++++++++++++++++++++++++++++++-------------
 1 file changed, 39 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index a16d6e070c11..1064e4d68718 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -61,18 +61,24 @@ u32 xstate_required_size(u64 xstate_bv, bool compacted)
 	return ret;
 }
 
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
 
@@ -95,6 +101,7 @@ u32 xstate_required_size(u64 xstate_bv, bool compacted)
 #define AF(name)								\
 ({										\
 	BUILD_BUG_ON(__feature_leaf(X86_FEATURE_##name) != CPUID_1_EDX);	\
+	BUILD_BUG_ON(kvm_cpu_cap_init_in_progress != CPUID_8000_0001_EDX);	\
 	feature_bit(name);							\
 })
 
@@ -622,22 +629,34 @@ static __always_inline u32 raw_cpuid_get(struct cpuid_reg cpuid)
 	return *__cpuid_entry_get_reg(&entry, cpuid.reg);
 }
 
-static __always_inline void kvm_cpu_cap_init(u32 leaf, u32 mask)
-{
-	const struct cpuid_reg cpuid = x86_feature_cpuid(leaf * 32);
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
 
-	/*
-	 * For kernel-defined leafs, mask the boot CPU's pre-populated value.
-	 * For KVM-defined leafs, explicitly set the leaf, as KVM is the one
-	 * and only authority.
-	 */
-	if (leaf < NCAPINTS)
-		kvm_cpu_caps[leaf] &= mask;
-	else
-		kvm_cpu_caps[leaf] = mask;
-
-	kvm_cpu_caps[leaf] &= raw_cpuid_get(cpuid);
-}
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
 
 /*
  * Undefine the MSR bit macro to avoid token concatenation issues when
@@ -870,6 +889,10 @@ void kvm_set_cpu_caps(void)
 }
 EXPORT_SYMBOL_GPL(kvm_set_cpu_caps);
 
+#undef kvm_cpu_cap_init
+#undef KVM_VALIDATE_CPU_CAP_USAGE
+#define KVM_VALIDATE_CPU_CAP_USAGE(name)
+
 struct kvm_cpuid_array {
 	struct kvm_cpuid_entry2 *entries;
 	int maxnent;
-- 
2.45.0.215.g3402c0e53f-goog


