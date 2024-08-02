Return-Path: <kvm+bounces-23090-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 788EE9462EF
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 20:20:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EA437B21728
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 18:20:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1716136343;
	Fri,  2 Aug 2024 18:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Xk7fgdCi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DF56166F14
	for <kvm@vger.kernel.org>; Fri,  2 Aug 2024 18:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722622785; cv=none; b=r5o5xz/2y15Ro7ngdTQoRTkMzOq8ZEtShwyFt+U+Zu3lZ0kedIm5zZgsthy5aLyHFFpiYvjm+JYrQPBWnPY2Nn/rsiXJCQkAfm4bwyIXA9nnhgpHqH2qDzeYJXxEwr4j5XIO+rLDnWzHIIdKavQXOiqYCO7IfLA1Y4+oFsKFdnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722622785; c=relaxed/simple;
	bh=7mpv0WRXnriZ+ipajLIvZWgSDl6S0mMqoBXa5xqtiV8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DwNQquTKl0DIdzi3DhZjUIK6cLeaHyyWz1JK0EybaA1xhC7eN0RZXk61U6sq7RWw5y0wjw3/ZK3C7JDy5eDita9jDbkj0lk8v5C5e1zUAoEn3LSgE9HQ5Se7SawWp0xs6XXM0+ieoFzB0DADkgNCHLNyhIKfsr4qEvijakX+9D4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Xk7fgdCi; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2cfe9270d82so2784034a91.3
        for <kvm@vger.kernel.org>; Fri, 02 Aug 2024 11:19:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722622784; x=1723227584; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=5QRnNh3YRBJv0dAIk1Fm70RjmCsyrcZMMCD1sVPx4ww=;
        b=Xk7fgdCiQWqNCT0M//tJhA6qVv4NWwlpUYOcQ6i613cAXrjczJdSDRkVpyM1RfKDVp
         H/srua34f22qTVXZ37OEP//otbP7XyfBabMyoIvdXRbTyN9FqaNq9sJ42ILWdZ47XKyj
         uFqr3Lt7WfwqHeJC/hcuNf1rracnKu+Rl//tuggIHI4fIxEJTaE+xv+ZYINnCJ5ci0vw
         q1CHiyqJVh6jRSf5pIYIuF1/fixlFiG7jupFkqr6s5eO9ic4uWw8OHYXHyOZg+6bh1Ie
         kO0FWPg+HXYjA1NzCCttYHsof2IYpLxcZisClXuHH88vWuNKRX+ph/EryCwVfOW2LhRu
         CT3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722622784; x=1723227584;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5QRnNh3YRBJv0dAIk1Fm70RjmCsyrcZMMCD1sVPx4ww=;
        b=Ha4toYuKcyJt9M/Z3k8BHHWwxrN/FqAuxfKGbuvJs1Blkrn21hv1BoR4CjPrb+alge
         R08IQ7KZLV8OGwk1SkPtBpuA+F0n6byujLkYKgs6tlaEZMIh0mK03Ki1E0AuDyIt5ck5
         QiXmYMnjWBiLnkMZFdMr+USZJxRF11bzbOBnusAUUEMe3CicTktTmP/fKI2ZcZuufJhC
         +/KXzWD++HmRY4NaFP7aeBuCOGLMTkvzWWVw3UkVd5fBQupymKtyNlBCN/zIzl8Nc0vd
         k46PqHLEmme8qJF1iYbhTcrDjDujbLzfJB0ucZnBOnlWvWGpFHEa0RkX+MvcVYC7D1ek
         zcuA==
X-Gm-Message-State: AOJu0YyTBEnw3vKew33p9/fXPafj0gTCi2v7p+1SZ5DXulo38PMhkeJr
	KiTjuFLF8qr30iL9QN+qvBXzd8S5eSzk3lH3sYAaPhgn1ADnPxsXMe1xr/VvvV1TFYb43UXczUD
	eoA==
X-Google-Smtp-Source: AGHT+IG9EtujUXdUt9x1n6wGTS9FhvTMc2FM7+sO8N3xBRvblPza38AzfxzYkyAXy2wLoSzLwyGHfK9p5f4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:3a90:b0:2cd:1e0d:a4c7 with SMTP id
 98e67ed59e1d1-2cff93c4f4dmr67783a91.1.1722622783676; Fri, 02 Aug 2024
 11:19:43 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  2 Aug 2024 11:19:28 -0700
In-Reply-To: <20240802181935.292540-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240802181935.292540-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc2.264.g509ed76dc8-goog
Message-ID: <20240802181935.292540-4-seanjc@google.com>
Subject: [PATCH v2 03/10] KVM: x86: Rename KVM_MSR_RET_INVALID to KVM_MSR_RET_UNSUPPORTED
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Weijiang Yang <weijiang.yang@intel.com>
Content-Type: text/plain; charset="UTF-8"

Rename the "INVALID" internal MSR error return code to "UNSUPPORTED" to
try and make it more clear that access was denied because the MSR itself
is unsupported/unknown.  "INVALID" is too ambiguous, as it could just as
easily mean the value for WRMSR as invalid.

Avoid UNKNOWN and UNIMPLEMENTED, as the error code is used for MSRs that
_are_ actually implemented by KVM, e.g. if the MSR is unsupported because
an associated feature flag is not present in guest CPUID.

Opportunistically beef up the comments for the internal MSR error codes.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c |  2 +-
 arch/x86/kvm/vmx/vmx.c |  2 +-
 arch/x86/kvm/x86.c     | 12 ++++++------
 arch/x86/kvm/x86.h     | 15 +++++++++++----
 4 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 550ead197543..909ba79067f8 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2835,7 +2835,7 @@ static int svm_get_msr_feature(struct kvm_msr_entry *msr)
 			msr->data |= MSR_AMD64_DE_CFG_LFENCE_SERIALIZE;
 		break;
 	default:
-		return KVM_MSR_RET_INVALID;
+		return KVM_MSR_RET_UNSUPPORTED;
 	}
 
 	return 0;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index f18c2d8c7476..e5b253e4d421 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2006,7 +2006,7 @@ int vmx_get_msr_feature(struct kvm_msr_entry *msr)
 			return 1;
 		return vmx_get_vmx_msr(&vmcs_config.nested, msr->index, &msr->data);
 	default:
-		return KVM_MSR_RET_INVALID;
+		return KVM_MSR_RET_UNSUPPORTED;
 	}
 }
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index af6c8cf6a37a..a55f73ce7b2e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1690,7 +1690,7 @@ static int do_get_msr_feature(struct kvm_vcpu *vcpu, unsigned index, u64 *data)
 	msr.index = index;
 	r = kvm_get_msr_feature(&msr);
 
-	if (r == KVM_MSR_RET_INVALID && kvm_msr_ignored_check(index, 0, false))
+	if (r == KVM_MSR_RET_UNSUPPORTED && kvm_msr_ignored_check(index, 0, false))
 		r = 0;
 
 	*data = msr.data;
@@ -1887,7 +1887,7 @@ static int kvm_set_msr_ignored_check(struct kvm_vcpu *vcpu,
 {
 	int ret = __kvm_set_msr(vcpu, index, data, host_initiated);
 
-	if (ret == KVM_MSR_RET_INVALID)
+	if (ret == KVM_MSR_RET_UNSUPPORTED)
 		if (kvm_msr_ignored_check(index, data, true))
 			ret = 0;
 
@@ -1932,7 +1932,7 @@ static int kvm_get_msr_ignored_check(struct kvm_vcpu *vcpu,
 {
 	int ret = __kvm_get_msr(vcpu, index, data, host_initiated);
 
-	if (ret == KVM_MSR_RET_INVALID) {
+	if (ret == KVM_MSR_RET_UNSUPPORTED) {
 		/* Unconditionally clear *data for simplicity */
 		*data = 0;
 		if (kvm_msr_ignored_check(index, 0, false))
@@ -2001,7 +2001,7 @@ static int complete_fast_rdmsr(struct kvm_vcpu *vcpu)
 static u64 kvm_msr_reason(int r)
 {
 	switch (r) {
-	case KVM_MSR_RET_INVALID:
+	case KVM_MSR_RET_UNSUPPORTED:
 		return KVM_MSR_EXIT_REASON_UNKNOWN;
 	case KVM_MSR_RET_FILTERED:
 		return KVM_MSR_EXIT_REASON_FILTER;
@@ -4149,7 +4149,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		    kvm_is_msr_to_save(msr))
 			break;
 
-		return KVM_MSR_RET_INVALID;
+		return KVM_MSR_RET_UNSUPPORTED;
 	}
 	return 0;
 }
@@ -4510,7 +4510,7 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			break;
 		}
 
-		return KVM_MSR_RET_INVALID;
+		return KVM_MSR_RET_UNSUPPORTED;
 	}
 	return 0;
 }
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 499adef96038..f47b9905ba78 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -512,11 +512,18 @@ enum kvm_msr_access {
 
 /*
  * Internal error codes that are used to indicate that MSR emulation encountered
- * an error that should result in #GP in the guest, unless userspace
- * handles it.
+ * an error that should result in #GP in the guest, unless userspace handles it.
+ * Note, '1', '0', and negative numbers are off limits, as they are used by KVM
+ * as part of KVM's lightly documented internal KVM_RUN return codes.
+ *
+ * UNSUPPORTED	- The MSR isn't supported, either because it is completely
+ *		  unknown to KVM, or because the MSR should not exist according
+ *		  to the vCPU model.
+ *
+ * FILTERED	- Access to the MSR is denied by a userspace MSR filter.
  */
-#define  KVM_MSR_RET_INVALID	2	/* in-kernel MSR emulation #GP condition */
-#define  KVM_MSR_RET_FILTERED	3	/* #GP due to userspace MSR filter */
+#define  KVM_MSR_RET_UNSUPPORTED	2
+#define  KVM_MSR_RET_FILTERED		3
 
 #define __cr4_reserved_bits(__cpu_has, __c)             \
 ({                                                      \
-- 
2.46.0.rc2.264.g509ed76dc8-goog


