Return-Path: <kvm+bounces-35912-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D44FDA15AB7
	for <lists+kvm@lfdr.de>; Sat, 18 Jan 2025 01:58:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5A052188BCAE
	for <lists+kvm@lfdr.de>; Sat, 18 Jan 2025 00:58:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 312DF18E756;
	Sat, 18 Jan 2025 00:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XpzwarFr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9EE318A6BA
	for <kvm@vger.kernel.org>; Sat, 18 Jan 2025 00:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737161774; cv=none; b=Dl3sT1uy/WuNAeji80/d3LCz1O4R8u5UQJeK6LIIRR1barUFGOUrnyFF1KgGO/GezDDiNCsEtpZVhrd3RW3nAcGXdeRNiq+21D8i1IgIn+3i58qUImpAoCMnB+51GALfvMc1id0Pqe4KfQiz4ZHaUY+Fnth0TL0TyVSd0Ta3sPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737161774; c=relaxed/simple;
	bh=oF0sBicAPPhUq72I5vlh3+SWBQ+gF99lBN9gOBit1as=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=m3hKUHyL6x0CD3WEltD0nAqipu/0Zk07zN5yewksa6lgLLVwGKR7Wui+KXYQqG8/lOaKMa0HyTqBNCQpKjJ4PWCkGKyg1/6MpeH+72A2pb7C58xqz6UYXOWdEU5Jd6wybgtZSzAKAMb9hMp6ssHIjHi6KKLMuXdQKxN5m991OeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XpzwarFr; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ef79403c5eso7454108a91.0
        for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 16:56:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737161772; x=1737766572; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=sJCtQ5uAUri7iGFBLSXX36fSE63Q0nPcAnEP4m7LVa8=;
        b=XpzwarFrh+X2MWjTOkiaudMxp05TEx+sjzew/6Wc5Y89tGkq8Raz0jIExKGMbiN0P1
         PngG+XR/w6ynQ9vUwPJdHwM3Y30zyhATRjAbQOgHDfFJHZTzIAjGzZpJ/iPggwG10Qvf
         Ssik1ENGOtj0ehLJ4gunOVB2EEEGA4+MXcKpV3pl8ZxVodN8ipm5IBXkE9mwQnddOejI
         l/XIkO+W9kugR/xTO+XVMYUb90T8jkrC4YFo9UHnDY2XcEj93dajF8j2bpcY3sqxI7vw
         zCAMj3hd5Q55aw7vhwJuPwwZI94i59SpChj268V4C/6/yr7ktwT5AqJGa/vdrIHtiS4/
         9VxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737161772; x=1737766572;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sJCtQ5uAUri7iGFBLSXX36fSE63Q0nPcAnEP4m7LVa8=;
        b=R1Ug9lIC+DUPasyE1cmhL3LpB2EkGN8CAJ80rEnwPjZ39f9uAIq+1J8w7E5VxFyFil
         OEl9BSmXXFnWYh6cVU4kHy4jQCkOP541xEScuGFPbWFo5BcVUxPcJgQlFNatd4SIE/TV
         7FLm23pHZUF7bot5sIvNNAs9dnTCUeP5I0494JvRo4dFJviSyAUjOTRonx3dpRftd7kz
         BowoTZejyDnlbeiD9cUHvNMwxYAU/SUl5JhAjPy+63Uu9YDW0Lqa7jmcYiKiuxeQXBzI
         8Y4Gth0x97rHWcx9ajo4hAD/t1449hrAjReGLCx7aOzuk0WBt6FhWtCbmaoKD/77XUMQ
         /v5w==
X-Gm-Message-State: AOJu0YxZ3s/unmTD3QgNNnQbnJ3P/LA3s0+QbVXr9R/sXAOEQOdPdV8x
	EdruFlFHbws944bQcIC4NPTgFiWknftXKFFzBzF+pZTKOjDOKALy05R0mifnfgtBRNii7n0BK91
	swg==
X-Google-Smtp-Source: AGHT+IEdhNCZ24yUQLqPJww/GZu7srCGFAMCewMWioVRnJRojuDg8lwZ2z7ZAQPhZ3+MlNApu7cBlbpgUxU=
X-Received: from pja3.prod.google.com ([2002:a17:90b:5483:b0:2ea:5be5:da6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:da8e:b0:2ee:d024:e4fc
 with SMTP id 98e67ed59e1d1-2f782d860d5mr7587139a91.33.1737161772463; Fri, 17
 Jan 2025 16:56:12 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 17 Jan 2025 16:55:52 -0800
In-Reply-To: <20250118005552.2626804-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250118005552.2626804-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.0.rc2.279.g1de40edade-goog
Message-ID: <20250118005552.2626804-11-seanjc@google.com>
Subject: [PATCH 10/10] KVM: x86: Override TSC_STABLE flag for Xen PV clocks in kvm_guest_time_update()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	David Woodhouse <dwmw2@infradead.org>, Paul Durrant <paul@xen.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+352e553a86e0d75f5120@syzkaller.appspotmail.com, 
	Paul Durrant <pdurrant@amazon.com>, David Woodhouse <dwmw@amazon.co.uk>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"

When updating PV clocks, handle the Xen-specific UNSTABLE_TSC override in
the main kvm_guest_time_update() by simply clearing PVCLOCK_TSC_STABLE_BIT
in the flags of the reference pvclock structure.  Expand the comment to
(hopefully) make it obvious that Xen clocks need to be processed after all
clocks that care about the TSC_STABLE flag.

No functional change intended.

Cc: Paul Durrant <pdurrant@amazon.com>
Cc: David Woodhouse <dwmw@amazon.co.uk>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 35 +++++++++++++++--------------------
 1 file changed, 15 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c68e7f7ba69d..065b349a0218 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3119,8 +3119,7 @@ u64 get_kvmclock_ns(struct kvm *kvm)
 static void kvm_setup_guest_pvclock(struct pvclock_vcpu_time_info *ref_hv_clock,
 				    struct kvm_vcpu *vcpu,
 				    struct gfn_to_pfn_cache *gpc,
-				    unsigned int offset,
-				    bool force_tsc_unstable)
+				    unsigned int offset)
 {
 	struct pvclock_vcpu_time_info *guest_hv_clock;
 	struct pvclock_vcpu_time_info hv_clock;
@@ -3155,9 +3154,6 @@ static void kvm_setup_guest_pvclock(struct pvclock_vcpu_time_info *ref_hv_clock,
 
 	memcpy(guest_hv_clock, &hv_clock, sizeof(*guest_hv_clock));
 
-	if (force_tsc_unstable)
-		guest_hv_clock->flags &= ~PVCLOCK_TSC_STABLE_BIT;
-
 	smp_wmb();
 
 	guest_hv_clock->version = ++hv_clock.version;
@@ -3178,16 +3174,6 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 	s64 kernel_ns;
 	u64 tsc_timestamp, host_tsc;
 	bool use_master_clock;
-#ifdef CONFIG_KVM_XEN
-	/*
-	 * For Xen guests we may need to override PVCLOCK_TSC_STABLE_BIT as unless
-	 * explicitly told to use TSC as its clocksource Xen will not set this bit.
-	 * This default behaviour led to bugs in some guest kernels which cause
-	 * problems if they observe PVCLOCK_TSC_STABLE_BIT in the pvclock flags.
-	 */
-	bool xen_pvclock_tsc_unstable =
-		ka->xen_hvm_config.flags & KVM_XEN_HVM_CONFIG_PVCLOCK_TSC_UNSTABLE;
-#endif
 
 	kernel_ns = 0;
 	host_tsc = 0;
@@ -3275,7 +3261,7 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 			hv_clock.flags |= PVCLOCK_GUEST_STOPPED;
 			vcpu->pvclock_set_guest_stopped_request = false;
 		}
-		kvm_setup_guest_pvclock(&hv_clock, v, &vcpu->pv_time, 0, false);
+		kvm_setup_guest_pvclock(&hv_clock, v, &vcpu->pv_time, 0);
 
 		hv_clock.flags &= ~PVCLOCK_GUEST_STOPPED;
 	}
@@ -3283,13 +3269,22 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 	kvm_hv_setup_tsc_page(v->kvm, &hv_clock);
 
 #ifdef CONFIG_KVM_XEN
+	/*
+	 * For Xen guests we may need to override PVCLOCK_TSC_STABLE_BIT as unless
+	 * explicitly told to use TSC as its clocksource Xen will not set this bit.
+	 * This default behaviour led to bugs in some guest kernels which cause
+	 * problems if they observe PVCLOCK_TSC_STABLE_BIT in the pvclock flags.
+	 *
+	 * Note!  Clear TSC_STABLE only for Xen clocks, i.e. the order matters!
+	 */
+	if (ka->xen_hvm_config.flags & KVM_XEN_HVM_CONFIG_PVCLOCK_TSC_UNSTABLE)
+		hv_clock.flags &= ~PVCLOCK_TSC_STABLE_BIT;
+
 	if (vcpu->xen.vcpu_info_cache.active)
 		kvm_setup_guest_pvclock(&hv_clock, v, &vcpu->xen.vcpu_info_cache,
-					offsetof(struct compat_vcpu_info, time),
-					xen_pvclock_tsc_unstable);
+					offsetof(struct compat_vcpu_info, time));
 	if (vcpu->xen.vcpu_time_info_cache.active)
-		kvm_setup_guest_pvclock(&hv_clock, v, &vcpu->xen.vcpu_time_info_cache, 0,
-					xen_pvclock_tsc_unstable);
+		kvm_setup_guest_pvclock(&hv_clock, v, &vcpu->xen.vcpu_time_info_cache, 0);
 #endif
 	return 0;
 }
-- 
2.48.0.rc2.279.g1de40edade-goog


