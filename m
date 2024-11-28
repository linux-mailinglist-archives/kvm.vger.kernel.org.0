Return-Path: <kvm+bounces-32700-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F5DD9DB128
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 02:47:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4587A281E98
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 01:47:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 314CA1CDFC0;
	Thu, 28 Nov 2024 01:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uZUD05qj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9107A1CCEDF
	for <kvm@vger.kernel.org>; Thu, 28 Nov 2024 01:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732757760; cv=none; b=Wqaq6G0VupEcHbiNHHIlFxcvy62PdorqrTtWQ1CeKOHXu3qna+6gga+YAe5+jH1VqXaOcUiJjw7sJWnSHcylMesD4WMAWSDFxPKzOjh/kTf67f91lMJCrtAMipSqYtLqmVVWoUZs2pVRGlsl3cjR5I7aSwsTOJbIoNYWEh+x7I0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732757760; c=relaxed/simple;
	bh=X1KFY9JDaWm435e/48kpMrX7/Px0BLMN53pN+9kw0zE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ppgDO0OA77bOY3pUGIkV5gnd/dTUaufHBIu2tPXE6GvbW6e5ZOulAMfCbWDUNglYcXDauKiTIsHXcIp8SnZUUkiTm376bd37GGDzZX0AX3OaWEjRumTpg4W7DzJvq5Q9jK9+x+5Kgyzsk0bCNHdmskYuCE4UhhSn/w7zLwuiRAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uZUD05qj; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ea4c541b61so399086a91.0
        for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 17:35:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732757758; x=1733362558; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=T/azVSgkTWzv8BfKxc6pAx4oV5kx86H9lfQ2pUatGZc=;
        b=uZUD05qjXCwzPlHFpelfZO9kyiNKkERzx5/4XBuwQ8B7uznlBJI/speX1P5RFoh9O9
         2iLGrkMq+jzwhnJdUvBqggNIvEHZPE2rjEpb+HfGlhCF6IMVzkbW7SwTTpPJLi8s9oLX
         o80TZiXxFDBzUhM3j30JgYA9AnlsMMiBCF6oNlHgww5eDPMePIsowZXi7GJwAyobJIJy
         M7CpxeZc8TgCPXVmrKKFASOkd08lH8JVvjEkc29Cb5D9Nhm1eVi6Pirrb5zlF70t5WeS
         W0f0+CNxqDe51z5gWRxz/fq1qmRIsK7TjFa3D9P+EEjOQZSbQe/ONFTjdHm1oJvxwuo5
         P5dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732757758; x=1733362558;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=T/azVSgkTWzv8BfKxc6pAx4oV5kx86H9lfQ2pUatGZc=;
        b=R2TpG6LRCFRxaj00++kuNnZ933wRQVA9XeIAZ0MKv/14lmm3T9ZTOUQrHZcl+A8QRO
         Y7nObSiLDzhUNsPslxGrfETDTQB0LHSI0KgRHZ11i0ubm/GrqrnfajpqkkRJugnu3NL1
         C7HqAVpAAhLjG39GWY+2dOdlJbm6TSWp3jJf610EQ2tAYOVk//30p83azAWZmCn3DF75
         6QF8IhJBy2wZDOqxfO4kxaaNR7J2x+SsvY6xZFTqF7sE+0leHaZPfkjmZzedoPxQRQBZ
         F/XY2ErpTWPi7AW/fgiuQR61398nF+/DtXYfgyggqEpuENyMqSum2mLRm+gPlOTLwcp5
         3rOw==
X-Gm-Message-State: AOJu0Yx05WnQ6UxbPPG+DpoOGknjRPyR+aI2nFB2jeAteT0Q9mR0xZsC
	W4z4gYmas7hOh3kC2y06XxXHjHxvR1jWWWyF5nHJ2sTH4aLJasVE/QxcydeM1HxPyHuHigPD2Ui
	Cow==
X-Google-Smtp-Source: AGHT+IFdhHXXQ+hWXIP9ZWM5zz75noCfQ39mgDA87KnR6usRc7BuJxpaKOJmZEA1ozX7y4nqiAuKb26SQu4=
X-Received: from pjuj3.prod.google.com ([2002:a17:90a:d003:b0:2e0:9fee:4b86])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2252:b0:2ea:8b06:ffcb
 with SMTP id 98e67ed59e1d1-2ee08eb2b91mr6591707a91.14.1732757757742; Wed, 27
 Nov 2024 17:35:57 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 27 Nov 2024 17:34:16 -0800
In-Reply-To: <20241128013424.4096668-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241128013424.4096668-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241128013424.4096668-50-seanjc@google.com>
Subject: [PATCH v3 49/57] KVM: x86: Shuffle code to prepare for dropping guest_cpuid_has()
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
index 27da0964355c..4901145ba2dc 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -149,21 +149,6 @@ static inline int guest_cpuid_stepping(struct kvm_vcpu *vcpu)
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
@@ -279,4 +264,19 @@ static inline bool kvm_vcpu_is_legal_cr3(struct kvm_vcpu *vcpu, unsigned long cr
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
2.47.0.338.g60cca15819-goog


