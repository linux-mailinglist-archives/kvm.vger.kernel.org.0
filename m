Return-Path: <kvm+bounces-17697-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 01E008C8BAB
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 19:53:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 325C31C2258C
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 17:53:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2699158DCC;
	Fri, 17 May 2024 17:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="l0VZBm7Q"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBBA213DDCF
	for <kvm@vger.kernel.org>; Fri, 17 May 2024 17:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715967671; cv=none; b=O72kMkQgDCY9nZ7Gw0Ktz2Dpj75pyxLLjA1tbHdYPMXpukPXp2YwFPWZ+wXjni5IpVNVn9DuK+bBcmWIzDxkXISjWzWdHxDYPZSXPspN5gSY+c/VCqG0MBZndJlCj/zMu9iJljaKrWQZYmWwhDNniYgKIFDMWcBLoUiIabX10SQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715967671; c=relaxed/simple;
	bh=ln2oK/KM1gDoYeYR3eZfciWq5Jni2fklzotf5eA5PH0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=O1D+wD3vAM3vve/8kkFOGlqgC4tD2j5pdu1WsXTPc+PRE53UFHPCVfQ26IFdoimqq6felOfQiTsAj1F2HD0VIzMm06LI9LJHqnt6X+Ech7uS19IsrEjdQAaTIwzYWjlf5YJt/dTEHZgCnqIG/+qMrOm6ld2EC87fyVWqkaPZm7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=l0VZBm7Q; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-622d157d9fbso106140417b3.0
        for <kvm@vger.kernel.org>; Fri, 17 May 2024 10:41:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715967669; x=1716572469; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=lWJTyML0btVQwtFr3Kj+PF9ZU7fFVwzZvNC575eeaaY=;
        b=l0VZBm7Qa8qhk+V7SbE4WxiWD6ZJx6zcTHELTiN3ApWBtt80BnoXr7Y7pVonVh5clq
         zQatdburDI2XZU7bN431vdLwReIbkIkNkejT8mJQ1/qHQ/T4OGyXBhZsRyxyhiqLQvZJ
         Myf96Mxf+Wl3RQBRvQnIRVnhWDJM0K27ssmPTIHhwQGXBUQWglLIM4kAVr/NcnPFLenq
         +ASWR/k3W/TcZp12ytSC4EyNVr0aBpN42VzYSvte0H4209kaQUvkFCaZcboGLcf0yM6O
         PvI883LCyGuBaL25Uw3ecbwSAfA5TRJZgAJZSExomfy8cIxIxG/wMBxCwy74YECLoLNf
         Yb0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715967669; x=1716572469;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lWJTyML0btVQwtFr3Kj+PF9ZU7fFVwzZvNC575eeaaY=;
        b=YT2esKTc9SMAC1YmFPD58TYnwJcVC+7gHL+/YzjMiKfpdU2ZbCq4kH4BtoWxUKYyfM
         Tll4Vm86IXMkAPQ/orn1tWOwJT7HqEwnwNzrR4Z/AC8Lpu5nWSV2jhqrCJXj9XdyLcQ+
         UU2EF3keVipBBwznvKBhFyIX6ztTAUeaBgBAmN9ZQZbKRDZPvrysQs/ue2UYP032pPn1
         6oHxaUjPh6WP3+pA8mHKo8RSFx6w8PpQJcG6r3oW4zkh0BU8FhIWawqkJ+SXbDdueZ8n
         Nwog1pXp89iAzbF2RcyXvkT4SEFBLlJ3Lbf31Ea86tgwhXYciO/LBrlNmsEpwTiBHYVn
         ttDg==
X-Gm-Message-State: AOJu0YxwnadpvVZFXuIrYuI0U9ezwBdeBstT2SOVpoHIWvlnRxW1RFCW
	vHcX3qs6Si0w/g/+jiuwSyfzyKtd0E+qHevhpj9LcHEz+k+g0RNdr7HNlFuzRZfrWqcPT69ChXf
	lUg==
X-Google-Smtp-Source: AGHT+IH770L4K1w+W/o94HrKzOsLDXb4Gu5UdwayEh46aYhNdxSnOv53qbdkgC8IMA/Dpdta9IJeX8mRa30=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:10c3:b0:dee:7c5c:e336 with SMTP id
 3f1490d57ef6-dee7c5ce8a4mr1390438276.10.1715967668833; Fri, 17 May 2024
 10:41:08 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 17 May 2024 10:39:22 -0700
In-Reply-To: <20240517173926.965351-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240517173926.965351-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.0.215.g3402c0e53f-goog
Message-ID: <20240517173926.965351-46-seanjc@google.com>
Subject: [PATCH v2 45/49] KVM: x86: Shuffle code to prepare for dropping guest_cpuid_has()
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Hou Wenlong <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Yang Weijiang <weijiang.yang@intel.com>, 
	Robert Hoo <robert.hoo.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Move the implementations of guest_has_{spec_ctrl,pred_cmd}_msr() down
below guest_cpu_cap_has() so that their use of guest_cpuid_has() can be
replaced with calls to guest_cpu_cap_has().

No functional change intended.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.h | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index 60da304db4e4..7be56fa62342 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -168,21 +168,6 @@ static inline int guest_cpuid_stepping(struct kvm_vcpu *vcpu)
 	return x86_stepping(best->eax);
 }
 
-static inline bool guest_has_spec_ctrl_msr(struct kvm_vcpu *vcpu)
-{
-	return (guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL) ||
-		guest_cpuid_has(vcpu, X86_FEATURE_AMD_STIBP) ||
-		guest_cpuid_has(vcpu, X86_FEATURE_AMD_IBRS) ||
-		guest_cpuid_has(vcpu, X86_FEATURE_AMD_SSBD));
-}
-
-static inline bool guest_has_pred_cmd_msr(struct kvm_vcpu *vcpu)
-{
-	return (guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL) ||
-		guest_cpuid_has(vcpu, X86_FEATURE_AMD_IBPB) ||
-		guest_cpuid_has(vcpu, X86_FEATURE_SBPB));
-}
-
 static inline bool supports_cpuid_fault(struct kvm_vcpu *vcpu)
 {
 	return vcpu->arch.msr_platform_info & MSR_PLATFORM_INFO_CPUID_FAULT;
@@ -301,4 +286,19 @@ static inline bool kvm_vcpu_is_legal_cr3(struct kvm_vcpu *vcpu, unsigned long cr
 	return kvm_vcpu_is_legal_gpa(vcpu, cr3);
 }
 
+static inline bool guest_has_spec_ctrl_msr(struct kvm_vcpu *vcpu)
+{
+	return (guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL) ||
+		guest_cpuid_has(vcpu, X86_FEATURE_AMD_STIBP) ||
+		guest_cpuid_has(vcpu, X86_FEATURE_AMD_IBRS) ||
+		guest_cpuid_has(vcpu, X86_FEATURE_AMD_SSBD));
+}
+
+static inline bool guest_has_pred_cmd_msr(struct kvm_vcpu *vcpu)
+{
+	return (guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL) ||
+		guest_cpuid_has(vcpu, X86_FEATURE_AMD_IBPB) ||
+		guest_cpuid_has(vcpu, X86_FEATURE_SBPB));
+}
+
 #endif
-- 
2.45.0.215.g3402c0e53f-goog


