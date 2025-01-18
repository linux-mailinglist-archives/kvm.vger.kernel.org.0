Return-Path: <kvm+bounces-35906-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D2D6A15AAC
	for <lists+kvm@lfdr.de>; Sat, 18 Jan 2025 01:57:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6B9973A9D3F
	for <lists+kvm@lfdr.de>; Sat, 18 Jan 2025 00:56:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 556541487DC;
	Sat, 18 Jan 2025 00:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IbMLZtDm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04A0C13633F
	for <kvm@vger.kernel.org>; Sat, 18 Jan 2025 00:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737161764; cv=none; b=aDj7Mrs7VqVOiwAfhqNkngq+SrnWVDGLNSAycIlU5bRBk/ys9LwP/54wz+sABprB7H49K0UFIJz7gPF87nLTdqsQw3J2tx+Sq8qJMo22VDNAGQzH6OSy9/rT8ItYH/7yLGiudmo0tsHreO/RiqB9pAwKRKr/8B8kGDiCNkoniCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737161764; c=relaxed/simple;
	bh=sA0hS9Id9jjgEzQ/Xw9LNPSamWlk+dIcdiS07KzlWPU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CUaAhngw58CeCxYRkFc3HnDsv+v7HgEu4UOt9DZwYO79Urgf/WAz3x1PjVIC18Ot7SgiOt7r6LdZ1HWOENOKya5wi1cFlkvbW0JjwvEUCY0riIE51rebsfACENSlZQGScuQ0ogKYTdHYLvvyj7nC/rjCIvYWNZZyNc6N8w9po9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IbMLZtDm; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ee46799961so7692577a91.2
        for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 16:56:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737161762; x=1737766562; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=TtGZFtu7QgB0Mt5t6w7JlRT99J1dCdQK9yh6ZvZlQk8=;
        b=IbMLZtDm+GLDjVyG+YspLHQBY6W3r0mRQpJhQ0YxloifoGPPqVpOXB881Rw8oK3kvr
         NqXQ2eRvR95szs+PLy9yAtC5Hj2o3YF40X/z63fhvrH1SCgDYxu2wvSl7hU6Y81ypCJx
         3xn6yGMeENgXsfFS5vu7PpXapLNXyKA1NC9gnbKS19jWD9+hh4hdGcjKm28vDGnKrU0l
         HhWYWasMN8seAXgZOKn8YJbSmbES+QYE9gqvnUeVh2BHfwNN/HDmTOIc89I+mv6Kgccz
         FYSjcTFvvuRZxm3NB+JhU9sFVL/Hgmvngf4ouROkDTRz2wDnEC3LM9RAzc5QpvejzOZ+
         CXCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737161762; x=1737766562;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TtGZFtu7QgB0Mt5t6w7JlRT99J1dCdQK9yh6ZvZlQk8=;
        b=snsMhCV4og8F+KMl/XWOgbW892jZHlij0uUQMLvEOGRrzuMPpJHxeShst+Tn7YWN4g
         rsyeOCjqETMyE2cZxIljGqtQCu4EwViApLbdaCIy/3VpklaMIghfMlUALSNZ1xvANPPk
         cIEAFI71cHjtptcIO8D/LVpm8kwwRjzGvEdXLAV12KQwCbl8J2fTosLEBolLdRwroVV0
         +SWM/jg7+N+7KgEDPcAV4R3vYMLBh16Y0ZFJtaMleucPfeILeSIMJRhNdnnwHCwOqMSe
         Vehahtnp0+5vqx7jmhLNZVVTwoGqnhZVqTey2IYS1vuxFN+2MTFuPxOY9ju6fJ7esZs9
         SKrA==
X-Gm-Message-State: AOJu0YzjNro+OknCfT/5UuLHT90kAmcTIbrpqk+0apkYzuGLD9KMUQ95
	p/A4xe/FCXiVAbLTlcRt+PkLkNk2JldXDyk+Nw805N3+wtMP2fstH33SFfPFLmXK28NzFuw8BRm
	PiQ==
X-Google-Smtp-Source: AGHT+IHDYfqDDUj6f3R/znriaiY2WAmKD2wdWDEcZoF0YWTsbhbe/fN7Idxp7RtwGR0Ou3LzEh3pKLjTXLA=
X-Received: from pjz13.prod.google.com ([2002:a17:90b:56cd:b0:2f4:3eb4:f8bf])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3cd0:b0:2ee:aed6:9ec2
 with SMTP id 98e67ed59e1d1-2f782c926d5mr7786710a91.14.1737161762414; Fri, 17
 Jan 2025 16:56:02 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 17 Jan 2025 16:55:46 -0800
In-Reply-To: <20250118005552.2626804-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250118005552.2626804-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.0.rc2.279.g1de40edade-goog
Message-ID: <20250118005552.2626804-5-seanjc@google.com>
Subject: [PATCH 04/10] KVM: x86: Set PVCLOCK_GUEST_STOPPED only for kvmclock,
 not for Xen PV clock
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	David Woodhouse <dwmw2@infradead.org>, Paul Durrant <paul@xen.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+352e553a86e0d75f5120@syzkaller.appspotmail.com, 
	Paul Durrant <pdurrant@amazon.com>, David Woodhouse <dwmw@amazon.co.uk>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"

Handle "guest stopped" propagation only for kvmclock, as the flag is set
if and only if kvmclock is "active", i.e. can only be set for Xen PV clock
if kvmclock *and* Xen PV clock are in-use by the guest, which creates very
bizarre behavior for the guest.

Simply restrict the flag to kvmclock, e.g. instead of trying to handle
Xen PV clock, as propagation of PVCLOCK_GUEST_STOPPED was unintentionally
added during a refactoring, and while Xen proper defines
XEN_PVCLOCK_GUEST_STOPPED, there's no evidence that Xen guests actually
support the flag.

Check and clear pvclock_set_guest_stopped_request if and only if kvmclock
is active to preserve the original behavior, i.e. keep the flag pending
if kvmclock happens to be disabled when KVM processes the initial request.

Fixes: aa096aa0a05f ("KVM: x86/xen: setup pvclock updates")
Cc: Paul Durrant <pdurrant@amazon.com>
Cc: David Woodhouse <dwmw@amazon.co.uk>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d8ee37dd2b57..3c4d210e8a9e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3150,11 +3150,6 @@ static void kvm_setup_guest_pvclock(struct kvm_vcpu *v,
 	/* retain PVCLOCK_GUEST_STOPPED if set in guest copy */
 	vcpu->hv_clock.flags |= (guest_hv_clock->flags & PVCLOCK_GUEST_STOPPED);
 
-	if (vcpu->pvclock_set_guest_stopped_request) {
-		vcpu->hv_clock.flags |= PVCLOCK_GUEST_STOPPED;
-		vcpu->pvclock_set_guest_stopped_request = false;
-	}
-
 	memcpy(guest_hv_clock, &vcpu->hv_clock, sizeof(*guest_hv_clock));
 
 	if (force_tsc_unstable)
@@ -3264,8 +3259,21 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 	if (use_master_clock)
 		vcpu->hv_clock.flags |= PVCLOCK_TSC_STABLE_BIT;
 
-	if (vcpu->pv_time.active)
+	if (vcpu->pv_time.active) {
+		/*
+		 * GUEST_STOPPED is only supported by kvmclock, and KVM's
+		 * historic behavior is to only process the request if kvmclock
+		 * is active/enabled.
+		 */
+		if (vcpu->pvclock_set_guest_stopped_request) {
+			vcpu->hv_clock.flags |= PVCLOCK_GUEST_STOPPED;
+			vcpu->pvclock_set_guest_stopped_request = false;
+		}
 		kvm_setup_guest_pvclock(v, &vcpu->pv_time, 0, false);
+
+		vcpu->hv_clock.flags &= ~PVCLOCK_GUEST_STOPPED;
+	}
+
 #ifdef CONFIG_KVM_XEN
 	if (vcpu->xen.vcpu_info_cache.active)
 		kvm_setup_guest_pvclock(v, &vcpu->xen.vcpu_info_cache,
-- 
2.48.0.rc2.279.g1de40edade-goog


