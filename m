Return-Path: <kvm+bounces-37027-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BEC6A24647
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2025 02:40:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8043D1886B0E
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2025 01:40:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 532C61474A2;
	Sat,  1 Feb 2025 01:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kO7w2rtT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF06313C3D5
	for <kvm@vger.kernel.org>; Sat,  1 Feb 2025 01:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738373921; cv=none; b=StwK7y/Bc07ITYgT7s1bqjVncpGnVNddAQzGetCQLZ+IzKX1rCm4cbe5gqL5S+PRuOFsnX8x39XTvW5zNnvTvxJdk++KvcLApm71aUH/rqXmD70YtRd5QrP0V2ygYqnoKhHSdF4kuL+l3rWmgsGqm1Qaz91uIcAwUApSnoRsr2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738373921; c=relaxed/simple;
	bh=jqD6fINm58nrlJC96XXHVdF8NcVOAKSb17n1uydbzUY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UVJH/CMWLYOBkMlx2Y9w9xOsXzgxNCC8GwfxSL81v1bLit94ih91rvMVtS9YORSeyN26hyUiB40gM9xmPU+sFBGiEvGiU13AH6O5b5BOsbKWT/GKvqYI/+iGLM1vKTEETKSjGaB+jKq1xIBErflYV7x4pmrOfJtZ7EV+wbCAgco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kO7w2rtT; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2166a1a5cc4so52475865ad.3
        for <kvm@vger.kernel.org>; Fri, 31 Jan 2025 17:38:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738373919; x=1738978719; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=rCMiScS+NLaVhzTpSO0M+ZWK4RHUIY21ppYPfMWENg4=;
        b=kO7w2rtT8sS5A6RRvNVSmbzxjXWufZdjwFE5I9+laBiuJObeUES4tCFDVN7wEhBgxD
         SbWdOELCX3DQpxzm/BA3jAlmAhIRTKEWRL7gLdq4FgVeWH75cBC+k46exbh4OCnvuFNy
         hWTVkNaHD/dXVKjaK/STGyi5xIM0f2XqNN/xyIrCD2SaptXW0ZIXJMtTglDLG/aBEwXv
         xNNPbQSZv6+Ko4cA+itZJMh4kgdMqMmiDhwd+Z54RuN7ipAsnqwBZ0gvB4FEW/HHroCP
         FDEgAT979LS22wDSBRYCmu1ufpY9wYOcSmJxjPcR6whf0mqUpPaI/nQ/uOePX54acrX0
         8j4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738373919; x=1738978719;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rCMiScS+NLaVhzTpSO0M+ZWK4RHUIY21ppYPfMWENg4=;
        b=RXUa7IyzK2bVbXvtiOJvhexRtee0N/nTyfhmpPCeERsYjDDJxG0/aJKQawScGH2rUf
         DB/p08KRj9W3tU0Y7Z0NQznpryHyQjtsC/QKTmU5/V8JT0SynUBR4b/zJnjFhByxO96l
         ne4sME9toK6lULBGSzKYN3sAfgRbe2ZJyMw7oGflHUbG1k3ll6pkhV6yijbxHPkpVqkY
         WfyP8BziWQohpWnJ5s1TYjGCHMl+67DyYQk5HMNKHWKLU6wJTB9BFGqNlZ9j4uCqKgVP
         SY69FAlQEUnqJ12KmzE717MzrL9oFzR5CrwYRXxtTKiGsPPEdPjAcd2Ps7TaOa2taQpk
         SgEQ==
X-Gm-Message-State: AOJu0YzhgvD7Z94r1cdUzz9KXw13mek9y/YcIBlkQJ0WOQDcl3SzQht4
	mz4srrUQZDTRQQ7TZXmD+vgDNaoqjUwFoCJ+SS2YBhrdEpooOxSN1S8yVaPL2UIx9fEWQIXEHFE
	uzA==
X-Google-Smtp-Source: AGHT+IF/0ykLJ+eIXWfIGrSoBCyHpla92OyK69X3dikfVCHOBJ0I+S0cqlz9orZGrS3UqUgziU9//IFySsw=
X-Received: from pghh13.prod.google.com ([2002:a63:210d:0:b0:7ff:d6:4f0e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:3284:b0:1e8:bd15:6845
 with SMTP id adf61e73a8af0-1ed7a5a50eamr19970517637.1.1738373919154; Fri, 31
 Jan 2025 17:38:39 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 31 Jan 2025 17:38:21 -0800
In-Reply-To: <20250201013827.680235-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250201013827.680235-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.362.g079036d154-goog
Message-ID: <20250201013827.680235-6-seanjc@google.com>
Subject: [PATCH v2 05/11] KVM: x86/xen: Use guest's copy of pvclock when
 starting timer
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	David Woodhouse <dwmw2@infradead.org>, Paul Durrant <paul@xen.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+352e553a86e0d75f5120@syzkaller.appspotmail.com, 
	Paul Durrant <pdurrant@amazon.com>, David Woodhouse <dwmw@amazon.co.uk>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"

Use the guest's copy of its pvclock when starting a Xen timer, as KVM's
reference copy may not be up-to-date, i.e. may yield a false positive of
sorts.  In the unlikely scenario that the guest is starting a Xen timer
and has used a Xen pvclock in the past, but has since but turned it "off",
then vcpu->arch.hv_clock may be stale, as KVM's reference copy is updated
if and only if at least one pvclock is enabled.

Furthermore, vcpu->arch.hv_clock is currently used by three different
pvclocks: kvmclock, Xen, and Xen compat.  While it's extremely unlikely a
guest would ever enable multiple pvclocks, effectively sharing KVM's
reference clock could yield very weird behavior.  Using the guest's active
Xen pvclock instead of KVM's reference will allow dropping KVM's
reference copy.

Fixes: 451a707813ae ("KVM: x86/xen: improve accuracy of Xen timers")
Cc: Paul Durrant <pdurrant@amazon.com>
Cc: David Woodhouse <dwmw@amazon.co.uk>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/xen.c | 65 ++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 60 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index a909b817b9c0..300a79f1fae5 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -150,11 +150,46 @@ static enum hrtimer_restart xen_timer_callback(struct hrtimer *timer)
 	return HRTIMER_NORESTART;
 }
 
+static int xen_get_guest_pvclock(struct kvm_vcpu *vcpu,
+				 struct pvclock_vcpu_time_info *hv_clock,
+				 struct gfn_to_pfn_cache *gpc,
+				 unsigned int offset)
+{
+	unsigned long flags;
+	int r;
+
+	read_lock_irqsave(&gpc->lock, flags);
+	while (!kvm_gpc_check(gpc, offset + sizeof(*hv_clock))) {
+		read_unlock_irqrestore(&gpc->lock, flags);
+
+		r = kvm_gpc_refresh(gpc, offset + sizeof(*hv_clock));
+		if (r)
+			return r;
+
+		read_lock_irqsave(&gpc->lock, flags);
+	}
+
+	memcpy(hv_clock, gpc->khva + offset, sizeof(*hv_clock));
+	read_unlock_irqrestore(&gpc->lock, flags);
+
+	/*
+	 * Sanity check TSC shift+multiplier to verify the guest's view of time
+	 * is more or less consistent.
+	 */
+	if (hv_clock->tsc_shift != vcpu->arch.hv_clock.tsc_shift ||
+	    hv_clock->tsc_to_system_mul != vcpu->arch.hv_clock.tsc_to_system_mul)
+		return -EINVAL;
+
+	return 0;
+}
+
 static void kvm_xen_start_timer(struct kvm_vcpu *vcpu, u64 guest_abs,
 				bool linux_wa)
 {
+	struct kvm_vcpu_xen *xen = &vcpu->arch.xen;
 	int64_t kernel_now, delta;
 	uint64_t guest_now;
+	int r = -EOPNOTSUPP;
 
 	/*
 	 * The guest provides the requested timeout in absolute nanoseconds
@@ -173,10 +208,29 @@ static void kvm_xen_start_timer(struct kvm_vcpu *vcpu, u64 guest_abs,
 	 * the absolute CLOCK_MONOTONIC time at which the timer should
 	 * fire.
 	 */
-	if (vcpu->arch.hv_clock.version && vcpu->kvm->arch.use_master_clock &&
-	    static_cpu_has(X86_FEATURE_CONSTANT_TSC)) {
+	do {
+		struct pvclock_vcpu_time_info hv_clock;
 		uint64_t host_tsc, guest_tsc;
 
+		if (!static_cpu_has(X86_FEATURE_CONSTANT_TSC) ||
+		    !vcpu->kvm->arch.use_master_clock)
+			break;
+
+		/*
+		 * If both Xen PV clocks are active, arbitrarily try to use the
+		 * compat clock first, but also try to use the non-compat clock
+		 * if the compat clock is unusable.  The two PV clocks hold the
+		 * same information, but it's possible one (or both) is stale
+		 * and/or currently unreachable.
+		 */
+		if (xen->vcpu_info_cache.active)
+			r = xen_get_guest_pvclock(vcpu, &hv_clock, &xen->vcpu_info_cache,
+						  offsetof(struct compat_vcpu_info, time));
+		if (r && xen->vcpu_time_info_cache.active)
+			r = xen_get_guest_pvclock(vcpu, &hv_clock, &xen->vcpu_time_info_cache, 0);
+		if (r)
+			break;
+
 		if (!IS_ENABLED(CONFIG_64BIT) ||
 		    !kvm_get_monotonic_and_clockread(&kernel_now, &host_tsc)) {
 			/*
@@ -197,9 +251,10 @@ static void kvm_xen_start_timer(struct kvm_vcpu *vcpu, u64 guest_abs,
 
 		/* Calculate the guest kvmclock as the guest would do it. */
 		guest_tsc = kvm_read_l1_tsc(vcpu, host_tsc);
-		guest_now = __pvclock_read_cycles(&vcpu->arch.hv_clock,
-						  guest_tsc);
-	} else {
+		guest_now = __pvclock_read_cycles(&hv_clock, guest_tsc);
+	} while (0);
+
+	if (r) {
 		/*
 		 * Without CONSTANT_TSC, get_kvmclock_ns() is the only option.
 		 *
-- 
2.48.1.362.g079036d154-goog


