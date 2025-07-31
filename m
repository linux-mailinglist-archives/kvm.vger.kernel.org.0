Return-Path: <kvm+bounces-53810-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CD059B177FE
	for <lists+kvm@lfdr.de>; Thu, 31 Jul 2025 23:20:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 88F983B5C51
	for <lists+kvm@lfdr.de>; Thu, 31 Jul 2025 21:20:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34F1E2641E3;
	Thu, 31 Jul 2025 21:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IwA0u8Bv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C80B6263899
	for <kvm@vger.kernel.org>; Thu, 31 Jul 2025 21:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753996811; cv=none; b=ImcaYQPXIIZpSjEVKIufRDXCSV/ZUb17BHCsa+9zBUIRPKzGoFMnLjbEpIQg+OTtxrfthBggnITD8CTrhrZhU7qQcjRH9fnMs7BlAgXoKkC6JvMX9dgZ/+GidGF0FCOiKQqpTitcFRJDfe4Tb6KERKRyl8d6qCTofMixFxwaBc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753996811; c=relaxed/simple;
	bh=fEO5flYiBAmmrUTW30Vl0BFDykqnaU/ipG51NplHMZM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WN9PDOA64RVroHdAA0D902zu9eLG2yRmyPApPPrU33i7fRWidpSl3QFyfbq6NjuoOAUnIj/6BDjWcYqGLZxhjOSYy2KVt+cl0XufzxefQAoMvq0N0zCM3gkeIWOJdlR3lM2hR7JWQVRjQgZl3nfKWDvVkgGZIAZ2jPy3XEdt83w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jiaqiyan.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IwA0u8Bv; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jiaqiyan.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3132e7266d3so217315a91.2
        for <kvm@vger.kernel.org>; Thu, 31 Jul 2025 14:20:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753996809; x=1754601609; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3qNS6IJrJZV1lITbvwt6t07h5m493TGqR/NU0h0LQEg=;
        b=IwA0u8Bv2BjRha8fTY+anX5K4JH08WQ2p++FJm0pKA9+0vBEt6yuh5aqO9HvxgBwwD
         OlLvOM2vqI448fWe0gMoGzlRR2moGhxMdvLU7kBqrGTbqlHmbTB6vdi17wGXjAsA7XUK
         ZF7OVIyZRE/LkGRbWzUHVc/2f2EIWgZlTjsVQXGbz88r8Mr1Ewa6Yh71e0bOB00NAAfV
         Wvz8KqCM/ufuupGYQ5pHnY9Y+NUp2spzMSRJXUJ0ZOGtkFufT173/hfUsKT7co9+ye4R
         CSN7vkY0LpBPM/HpuTF1KvSDACfT3lOZmDwP5UrO7hKWq2SOwwdDF5ZZ4LZOaztbTgUn
         W1kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753996809; x=1754601609;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3qNS6IJrJZV1lITbvwt6t07h5m493TGqR/NU0h0LQEg=;
        b=NCHMgNoeSoOBLmvJkmIJ+D6PqVY2L9G+WB/GpOzXSoGhRiGYemNvJ2co1QAUPAeRJ3
         bW4hBXihC6siHw3RA5okz1FpJCf7Mn7fOV4gaIFKg19cfaBf3LnqwaIGPGjWBfFrlxpq
         1yTxuafe5NO7E5pYeByUzxhSg9IyWOQ2szDVw1NrdE4qa6nwfen85I2Jzo0UiNSGWUoz
         BJnMh2ek5Sqjc2m8FWMu+y0BkAINeprFcK4EK8S0u62hkNi80kwZb10APq8WqYxoSZrE
         KvCj1QM+0rxCo1FmT8wZwAakZEn3ILmK9sI7KNP1IevfZe1g6nnHfDLd2TfN7PIoizAp
         vIFQ==
X-Forwarded-Encrypted: i=1; AJvYcCWnGb2D0OrzKMyW2clb7s+3CxHyMP96swJhMo1Oalf6cn9yf4gVi/T+mD3JYpTXKH2CFIY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy0AnzusDpCWY1DguYB4jPxk5JQpkDVd1sDxSuN0wgOo0rO+eOc
	NhPTHzxISqHoNYw1OxaCRDEx7tqU9C2s/YQ5QhTZrG7YRJK+e6BkV5rVN4Kwg7aK8+xh/xezW0S
	PmvOwfRFfD8lBow==
X-Google-Smtp-Source: AGHT+IGi3W8REoNKT4VRn0WWKc9QG1YF4F8owx+E1JqaZjpyHJlhcdTCOBswIo9sfFOEAW14j8Fh6YM2HTafvw==
X-Received: from pjpo9.prod.google.com ([2002:a17:90a:9f89:b0:31e:d618:a29c])
 (user=jiaqiyan job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:3d8f:b0:311:a314:c2d1 with SMTP id 98e67ed59e1d1-31f5dd6fd1bmr12129421a91.6.1753996809220;
 Thu, 31 Jul 2025 14:20:09 -0700 (PDT)
Date: Thu, 31 Jul 2025 21:20:01 +0000
In-Reply-To: <20250731212004.1437336-1-jiaqiyan@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250731212004.1437336-1-jiaqiyan@google.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
Message-ID: <20250731212004.1437336-2-jiaqiyan@google.com>
Subject: [PATCH v1 1/4] KVM: arm64: Allow userspace to inject external
 instruction abort
From: Jiaqi Yan <jiaqiyan@google.com>
To: maz@kernel.org, oliver.upton@linux.dev
Cc: joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, pbonzini@redhat.com, corbet@lwn.net, 
	shuah@kernel.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	rananta@google.com, Jiaqi Yan <jiaqiyan@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Raghavendra Rao Ananta <rananta@google.com>

When guest causes synchronous instruction external abort, VMM may
need to inject instruction abort to guest. However, KVM_SET_VCPU_EVENTS
currently only allows injecting external data aborts.

Extend the KVM_SET_VCPU_EVENTS ioctl to allow userspace injecting
instruction abort into the guest.

Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 arch/arm64/include/uapi/asm/kvm.h |  3 ++-
 arch/arm64/kvm/arm.c              |  1 +
 arch/arm64/kvm/guest.c            | 15 ++++++++++-----
 include/uapi/linux/kvm.h          |  1 +
 4 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index ed5f3892674c7..643e8c4825451 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -184,8 +184,9 @@ struct kvm_vcpu_events {
 		__u8 serror_pending;
 		__u8 serror_has_esr;
 		__u8 ext_dabt_pending;
+		__u8 ext_iabt_pending;
 		/* Align it to 8 bytes */
-		__u8 pad[5];
+		__u8 pad[4];
 		__u64 serror_esr;
 	} exception;
 	__u32 reserved[12];
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 7a1a8210ff918..3d86d0ae7898b 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -315,6 +315,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_ARM_IRQ_LINE_LAYOUT_2:
 	case KVM_CAP_ARM_NISV_TO_USER:
 	case KVM_CAP_ARM_INJECT_EXT_DABT:
+	case KVM_CAP_ARM_INJECT_EXT_IABT:
 	case KVM_CAP_SET_GUEST_DEBUG:
 	case KVM_CAP_VCPU_ATTRIBUTES:
 	case KVM_CAP_PTP_KVM:
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 16ba5e9ac86c3..d3c7b5015f20e 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -826,9 +826,9 @@ int __kvm_arm_vcpu_get_events(struct kvm_vcpu *vcpu,
 		events->exception.serror_esr = vcpu_get_vsesr(vcpu);
 
 	/*
-	 * We never return a pending ext_dabt here because we deliver it to
-	 * the virtual CPU directly when setting the event and it's no longer
-	 * 'pending' at this point.
+	 * We never return a pending ext_dabt or ext_iabt here because we
+	 * deliver it to the virtual CPU directly when setting the event
+	 * and it's no longer 'pending' at this point.
 	 */
 
 	return 0;
@@ -853,16 +853,21 @@ int __kvm_arm_vcpu_set_events(struct kvm_vcpu *vcpu,
 	bool serror_pending = events->exception.serror_pending;
 	bool has_esr = events->exception.serror_has_esr;
 	bool ext_dabt_pending = events->exception.ext_dabt_pending;
+	bool ext_iabt_pending = events->exception.ext_iabt_pending;
 	u64 esr = events->exception.serror_esr;
 	int ret = 0;
 
+	/* DABT and IABT cannot happen at the same time. */
+	if (ext_dabt_pending && ext_iabt_pending)
+		return -EINVAL;
 	/*
 	 * Immediately commit the pending SEA to the vCPU's architectural
 	 * state which is necessary since we do not return a pending SEA
 	 * to userspace via KVM_GET_VCPU_EVENTS.
 	 */
-	if (ext_dabt_pending) {
-		ret = kvm_inject_sea_dabt(vcpu, kvm_vcpu_get_hfar(vcpu));
+	if (ext_dabt_pending || ext_iabt_pending) {
+		ret = kvm_inject_sea(vcpu, ext_iabt_pending,
+				     kvm_vcpu_get_hfar(vcpu));
 		commit_pending_events(vcpu);
 	}
 
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index e4e566ff348b0..a7b047f95887c 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -957,6 +957,7 @@ struct kvm_enable_cap {
 #define KVM_CAP_ARM_EL2_E2H0 241
 #define KVM_CAP_RISCV_MP_STATE_RESET 242
 #define KVM_CAP_ARM_CACHEABLE_PFNMAP_SUPPORTED 243
+#define KVM_CAP_ARM_INJECT_EXT_IABT 245
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
-- 
2.50.1.565.gc32cd1483b-goog


