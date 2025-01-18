Return-Path: <kvm+bounces-35908-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 13679A15AB1
	for <lists+kvm@lfdr.de>; Sat, 18 Jan 2025 01:57:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A4A7B3A66E9
	for <lists+kvm@lfdr.de>; Sat, 18 Jan 2025 00:57:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC70016EB54;
	Sat, 18 Jan 2025 00:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mhrHTauo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82EBC154430
	for <kvm@vger.kernel.org>; Sat, 18 Jan 2025 00:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737161768; cv=none; b=MihShCLHHdvnzZ1ehjVV+429rWeuLHsHI59ZPbxJfzzMop3AfDro11LBMPdXz2UsjeZIkVw/5gIf4ZpRMtNDXnjUZDkc6PfWI8h6w6uZ+K0X4RM7Us7zvykjnirvQpciOYWH6h2WeYm+vnZvOv8S1Inf3ShRBJEI2xUAV1hYBZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737161768; c=relaxed/simple;
	bh=VtQ/uqkwmoTxSj1yTfi+T7RgX+mctOvQzgcA4AyF1HI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fjvQgyzPB+UJ4BO8qPgdoI5NZWM9ylRelkxhQITeAq/OPbrNYAPbs8Sav21dvSsJ1+P3FencfGSSl1aV3GFybhDIYDcOY1NMarAQHQhzk+cbnp0WPVnLFRZwqptJnc2q4uRBCbt8uL/ELs7DfhIUWSTxX/Uf3Xu2NZl5MhUMS7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mhrHTauo; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ef9dbeb848so5128045a91.0
        for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 16:56:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737161766; x=1737766566; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=VKxrwiqgrub7pQIzreEa3TDPAdQtjV/84avIRIDcu/4=;
        b=mhrHTauoTn3tMM4pxb2nNq3XhTbJbkx/KQaolLbKB8SwYDcTpzRm4CpdUVPOe0WtXK
         9PlEkgIu9kC5rvGq3zUamxm6wSCp0EzgqWwB4j+T4G5QN+vlRG+hsJDG7LejdIwXPX1o
         o1nTM9UZqDhgiwj2dtiM2oxk7fps8jg8BB0aItib4FOtRAxfTuHSnKP5umyjQY9J+4+J
         S9e8Z9SlBJpJWcyX3PAtEcOIhiOL5gfHrIEaTUih2BPCLmuOFhxSVTUNoQuwnGh7nD5G
         9BkibsAX0nLYTeY1aupv98zxk6PnmabDyrB5oPeCya2OV76dBjFoQUADI7/f1RSLK72U
         Q69w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737161766; x=1737766566;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VKxrwiqgrub7pQIzreEa3TDPAdQtjV/84avIRIDcu/4=;
        b=RkSKow/Fnxi21uHjYREUlOj67QMqg6x9pzrY64DO6Z2jE1JfFeHUjngXQGT7eNy5a1
         8nBmasyoqtWm/sMVSB5A2/MQHBKjpj6WhYiVOhxsEvLp5a4dksTmcx7wbTH+tNklyVJO
         4a5v0xKXYXDhQT+H+rEZofaiDZoSAUWZoZ+HTL6UimIHUMU1knFc32HoW5SmXFSjyqS0
         D6yG+9uG9BEc5nu1URlL1EIIAx4c/F7avszYm9OcSLeLA//X/kPEgzANwEuWjA3QaSyA
         4ouuiCJ3bVSqZXj8ENAPi8u7UlEfjHVCGJ0VYbGLrwgBEoHRhNcI26DqkMBc+Odnz+aM
         Q27A==
X-Gm-Message-State: AOJu0YwZ6rQH6L5xbnq+Uw3lqq3SrP0Ph6ft0jDNn45NT1vaFXxoQdpP
	fl6h7//sFrwfqOtA1d9gdHEjQxJlngk/gmxIzqGaQk27955OmlIdloNKa54e+g/KcaEF6ufW1Ci
	k3A==
X-Google-Smtp-Source: AGHT+IEYHrG1aHDK2uQ013E8rTso2F2zxpvLHYLI5gh7s2mkwRcNqmAGvyXElMRFxpqYTHTdnDRcju0UmxE=
X-Received: from pjboh12.prod.google.com ([2002:a17:90b:3a4c:b0:2ea:9d23:79a0])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:e18f:b0:2ee:d7d3:3019
 with SMTP id 98e67ed59e1d1-2f782c7a769mr8071130a91.12.1737161765797; Fri, 17
 Jan 2025 16:56:05 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 17 Jan 2025 16:55:48 -0800
In-Reply-To: <20250118005552.2626804-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250118005552.2626804-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.0.rc2.279.g1de40edade-goog
Message-ID: <20250118005552.2626804-7-seanjc@google.com>
Subject: [PATCH 06/10] KVM: x86/xen: Use guest's copy of pvclock when starting timer
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
if and only if at least pvclock is enabled.

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
 arch/x86/kvm/xen.c | 58 ++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 53 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index a909b817b9c0..b82c28223585 100644
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
+	struct pvclock_vcpu_time_info *guest_hv_clock;
+	unsigned long flags;
+	int r;
+
+	read_lock_irqsave(&gpc->lock, flags);
+	while (!kvm_gpc_check(gpc, offset + sizeof(*guest_hv_clock))) {
+		read_unlock_irqrestore(&gpc->lock, flags);
+
+		r = kvm_gpc_refresh(gpc, offset + sizeof(*guest_hv_clock));
+		if (r)
+			return r;
+
+		read_lock_irqsave(&gpc->lock, flags);
+	}
+
+	memcpy(hv_clock, guest_hv_clock, sizeof(*hv_clock));
+	read_unlock_irqrestore(&gpc->lock, flags);
+
+	/*
+	 * Sanity check TSC shift+multiplier to verify the guest's view of time
+	 * is more or less consistent.
+	 */
+	if (hv_clock->tsc_shift != vcpu->arch.hv_clock.tsc_shift ||
+	    hv_clock->tsc_to_system_mul != vcpu->arch.hv_clock.tsc_to_system_mul)
+		return -EINVAL;
+	return 0;
+}
+
 static void kvm_xen_start_timer(struct kvm_vcpu *vcpu, u64 guest_abs,
 				bool linux_wa)
 {
+	struct kvm_vcpu_xen *xen;
 	int64_t kernel_now, delta;
 	uint64_t guest_now;
+	int r = -EOPNOTSUPP;
 
 	/*
 	 * The guest provides the requested timeout in absolute nanoseconds
@@ -173,10 +208,22 @@ static void kvm_xen_start_timer(struct kvm_vcpu *vcpu, u64 guest_abs,
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
+		if (xen->vcpu_info_cache.active)
+			r = xen_get_guest_pvclock(vcpu, &hv_clock, &xen->vcpu_info_cache,
+						offsetof(struct compat_vcpu_info, time));
+		else if (xen->vcpu_time_info_cache.active)
+			r = xen_get_guest_pvclock(vcpu, &hv_clock, &xen->vcpu_time_info_cache, 0);
+		if (r)
+			break;
+
 		if (!IS_ENABLED(CONFIG_64BIT) ||
 		    !kvm_get_monotonic_and_clockread(&kernel_now, &host_tsc)) {
 			/*
@@ -197,9 +244,10 @@ static void kvm_xen_start_timer(struct kvm_vcpu *vcpu, u64 guest_abs,
 
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
2.48.0.rc2.279.g1de40edade-goog


