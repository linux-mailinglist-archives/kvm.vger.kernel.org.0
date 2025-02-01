Return-Path: <kvm+bounces-37033-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D083A24653
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2025 02:42:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EB33F7A3A48
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2025 01:41:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CF5F19D060;
	Sat,  1 Feb 2025 01:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Wga9SqZU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA71317CA12
	for <kvm@vger.kernel.org>; Sat,  1 Feb 2025 01:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738373931; cv=none; b=WJIYm+SpNo1KS9eXy0d4wDeqJWy3rJ+FfFOCGbp7nREDQ2ruqbF+VsuF5wUN/joS4DwooEZmMGvZyAVFphZdWt20HsKXsyBo5dcPnGt6/9uFU4wbYYldNX2oEVsjq8rGuLTLY91UfnpBGiFeeamRJlPo6luPQnRwGY7KglLB8Ig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738373931; c=relaxed/simple;
	bh=k8wxsOE443NggaCrOV7dF04ykNDJ9RadB60SKgkrT5M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=u/oLdmrKPk+yfcHQXayOG5RLzImBEAdhRFfq7mshYiWAxsjnMKe4VVsZXLGMHrDjg0TQeRHSg02stgjqqAt/1gC3cR3c2DIeP4O+iq+Rj465Q88Z33U3TjYaFpLdSDU1dqgLzBQN8F4fNC2LuoAih81xXfedzvrki55MNDKpS2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Wga9SqZU; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-21681a2c0d5so45893465ad.2
        for <kvm@vger.kernel.org>; Fri, 31 Jan 2025 17:38:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738373929; x=1738978729; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=sE/Rfgm5mvZA9XECaHOz947FprssysVyUkm3w4GqLVg=;
        b=Wga9SqZU9jHACXKmEKMYG9ZiIL35h2Mx2pn+ozdbDB1Jn4FEuiNFj7/CkR5Ffhu6ck
         BWzmgEDRYgnUO7d7F2syKZUtLtjhV3yhKNwMgzcc6j3sI0FioBZpXm5FlwsjOztYZfbB
         yKCaQ/6opHD2FN77tEHOKH0xDtMy/mZZDEDeqX7pWG5h4KQ2YAwInM/GJEx/6Hk6o/rh
         wOyDPkrFIfe0zekCuWODatVmr983UTax/u2J1DrGDiFR5D9KnhbBxok4zI0zTi2HBFTU
         3FDIcvmtUbXjILz8QPNleKwKmgICBJQXh5qe8bb/YbLgbHL82IhQN2evnGATXrgLIIYz
         6Fow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738373929; x=1738978729;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sE/Rfgm5mvZA9XECaHOz947FprssysVyUkm3w4GqLVg=;
        b=mMbK1ff5cLVRJLW70NPt9BLx837QhcIjvZOV3tbKU0UvfdUAr5MjuY6kV88eMaVTHT
         fs459esyxBcV94jjrziGU/83Dzl3v2yzT8JiZLFN4rJH8qcOfqOp8u98BFAXsjxluW4Q
         pINsug5k1HZXTLPa9ODSWBi8qK1CU9pmvlvq3bw2BVxsCcaJjWBNpvU4dr19dHnLNNLd
         6qGoCXt9TV63yxWhEQ98XBmO6qep30MfmN5YV7GGz5TkfYS61kZViO8UonMNMDHYcwlK
         +IvTVWpq75L09tipb6bfn3BgHLOwZLTmjEUc8W2upcWk5wzx7L/6R6VplC1eMZWjpvKO
         P3Tg==
X-Gm-Message-State: AOJu0Yy9pshiWQPQ9TnO/Yrv3mhF1InWSwCOA7oM8MgpOKh8A5PJXowA
	7eIla+MCNWHlBurbc9OBh8gFgzekA6Vr7pR/JR9fCI5VfvSx0s5ZxcrIDYajvxYpoLU0BOP3vyR
	+KQ==
X-Google-Smtp-Source: AGHT+IHUMlCNgV3o1DxuBhC0GH3ufcaAMDOedqCRUviFnMxqgNjrYr6qtvvaw2bZC0boO+KzbUlr4m6PsiA=
X-Received: from plbld4.prod.google.com ([2002:a17:902:fac4:b0:21c:2d63:f756])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:d542:b0:216:2b14:b625
 with SMTP id d9443c01a7336-21dd7d7f818mr215027835ad.31.1738373929411; Fri, 31
 Jan 2025 17:38:49 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 31 Jan 2025 17:38:27 -0800
In-Reply-To: <20250201013827.680235-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250201013827.680235-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.362.g079036d154-goog
Message-ID: <20250201013827.680235-12-seanjc@google.com>
Subject: [PATCH v2 11/11] KVM: x86: Override TSC_STABLE flag for Xen PV clocks
 in kvm_guest_time_update()
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
Reviewed-by: Paul Durrant <paul@xen.org>
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
2.48.1.362.g079036d154-goog


