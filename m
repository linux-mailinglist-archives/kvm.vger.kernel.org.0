Return-Path: <kvm+bounces-37028-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E9269A24649
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2025 02:40:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CB1E83A7D59
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2025 01:40:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4B7220B22;
	Sat,  1 Feb 2025 01:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KWsKTAKh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 635D97081D
	for <kvm@vger.kernel.org>; Sat,  1 Feb 2025 01:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738373922; cv=none; b=XVUwx6Bi/KvdCfD3kCoERDOcyrcxyD19NAuSSB+2uXHqNmYzwoD1dP+K+Saem/i3NIXgaMt0o/WBkuw/iLyr7bmrxNJruj6EZH019+tpp8/hS4QRdDraG/T0NZoWJ2nngUSv4XEt8SOxzi65xgsUn3KQ/U+3sXXBXeLn3j4i4+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738373922; c=relaxed/simple;
	bh=FxR3NlhqjaxyvZuR88P+kPdnNxxn6TSgaLJ91JhSPhM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TAVwxG/ALNLIfBzZLeD5Y7XjoBw5JNQzzROq51xr1O91cCMycftC6DCCQlsIZsdH0IlgafhWUxOwqC2fELvTvduqg6/S/pviygQ7nqICKwF4OeC9K1bLEdDd6I7VVefsuJS8bNm3rlB547B0RCu6INh8Q8Ar/gDA4pPOljStxVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KWsKTAKh; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-21681a2c0d5so45891395ad.2
        for <kvm@vger.kernel.org>; Fri, 31 Jan 2025 17:38:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738373920; x=1738978720; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=MZzFZJ/ti1ZasZwSICIUNU12dHfHQJu6sx5F72/iN6A=;
        b=KWsKTAKhdKSiyVZNP/v/akSGiJtQVE0gZGu4ff7b3WiJyTLZmlPTreRQkmdiqv9+ck
         ShWKvvsF6JE6S89ymCC4sWOZhCPAdWh/m06ZJ6VYt4tpGVByKmKVYPveJbK2ofPH1OkA
         58o2mfNa8l1kosAjf4Y1NZBlkKfuKcSl+XtbiqNXiQtNE68tSOQ75QKMtV37FTCRQSs+
         rNn5yBb154pw/ULbVxtVnbtuOk2S79Kx5UQHT4NncimFVt0beod+MjtVidzAo2RwFgBD
         qJ3LBC4DM3fgHWjp0K81SpwPFhiun5Dmq9J6vkTRV+cSR/Ou6UbY41bN1Qd/RsCs9ZB8
         3Vfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738373920; x=1738978720;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MZzFZJ/ti1ZasZwSICIUNU12dHfHQJu6sx5F72/iN6A=;
        b=PvnVptnhHsbOSnc3Fkq7AZ8Fz864fxM6LZJB259APP/AUu4iobuu9Fmw78xbqcJfYO
         icTcD/GHMQxj9/w0GlEsFTcZyp32tS80DPS7zTt4usgx9saMynkVwR79Qsk6jUD2HPGH
         su4mWL273moxge3WfseTI4Z2uWMcrFcbeppl6rAsHz9dA+RcQu3hQtSWG/Q3OAEEKhWE
         tfREB8rwbhxGOfVu2nZYE9kk99HLtNuBFU2ZtTDJq2gyf/4Ft2BvDP01nTF9e4O2Xr80
         VYjBVFb3LVzu/L3PDSfH2dCcFrMp/3rNry5ii+5UcZ6wqicfkG2HeMBe65B8kxUPTLUm
         02EA==
X-Gm-Message-State: AOJu0YydYxwdLlQZv3cvqU57scm3hZLL2Q+yphuOTP0Vf1jAIYCixFrz
	xkSJU3ohJnf0MPfUc9el+5uZmg22Wsh9k6YMAhqpj0hCo3KbcFH1ZzYpKAqFOIVmJYE/AelUaAW
	IoA==
X-Google-Smtp-Source: AGHT+IGINrKcjMYRORFQEHt3bDlZ15bD44RFlDg8hRTr/ZtpYuPlB3mzVJHhLezZwRgBsysW3kb9Q+jlHIU=
X-Received: from plkp2.prod.google.com ([2002:a17:902:6b82:b0:20c:a78c:2b70])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:166d:b0:215:6489:cfb8
 with SMTP id d9443c01a7336-21dd7c4c2aamr232050175ad.10.1738373920608; Fri, 31
 Jan 2025 17:38:40 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 31 Jan 2025 17:38:22 -0800
In-Reply-To: <20250201013827.680235-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250201013827.680235-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.362.g079036d154-goog
Message-ID: <20250201013827.680235-7-seanjc@google.com>
Subject: [PATCH v2 06/11] KVM: x86: Don't bleed PVCLOCK_GUEST_STOPPED across
 PV clocks
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	David Woodhouse <dwmw2@infradead.org>, Paul Durrant <paul@xen.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+352e553a86e0d75f5120@syzkaller.appspotmail.com, 
	Paul Durrant <pdurrant@amazon.com>, David Woodhouse <dwmw@amazon.co.uk>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"

When updating a specific PV clock, make a full copy of KVM's reference
copy/cache so that PVCLOCK_GUEST_STOPPED doesn't bleed across clocks.
E.g. in the unlikely scenario the guest has enabled both kvmclock and Xen
PV clock, a dangling GUEST_STOPPED in kvmclock would bleed into Xen PV
clock.

Using a local copy of the pvclock structure also sets the stage for
eliminating the per-vCPU copy/cache (only the TSC frequency information
actually "needs" to be cached/persisted).

Fixes: aa096aa0a05f ("KVM: x86/xen: setup pvclock updates")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index de281c328cb1..3971a13bddbe 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3123,8 +3123,11 @@ static void kvm_setup_guest_pvclock(struct kvm_vcpu *v,
 {
 	struct kvm_vcpu_arch *vcpu = &v->arch;
 	struct pvclock_vcpu_time_info *guest_hv_clock;
+	struct pvclock_vcpu_time_info hv_clock;
 	unsigned long flags;
 
+	memcpy(&hv_clock, &vcpu->hv_clock, sizeof(hv_clock));
+
 	read_lock_irqsave(&gpc->lock, flags);
 	while (!kvm_gpc_check(gpc, offset + sizeof(*guest_hv_clock))) {
 		read_unlock_irqrestore(&gpc->lock, flags);
@@ -3144,25 +3147,25 @@ static void kvm_setup_guest_pvclock(struct kvm_vcpu *v,
 	 * it is consistent.
 	 */
 
-	guest_hv_clock->version = vcpu->hv_clock.version = (guest_hv_clock->version + 1) | 1;
+	guest_hv_clock->version = hv_clock.version = (guest_hv_clock->version + 1) | 1;
 	smp_wmb();
 
 	/* retain PVCLOCK_GUEST_STOPPED if set in guest copy */
-	vcpu->hv_clock.flags |= (guest_hv_clock->flags & PVCLOCK_GUEST_STOPPED);
+	hv_clock.flags |= (guest_hv_clock->flags & PVCLOCK_GUEST_STOPPED);
 
-	memcpy(guest_hv_clock, &vcpu->hv_clock, sizeof(*guest_hv_clock));
+	memcpy(guest_hv_clock, &hv_clock, sizeof(*guest_hv_clock));
 
 	if (force_tsc_unstable)
 		guest_hv_clock->flags &= ~PVCLOCK_TSC_STABLE_BIT;
 
 	smp_wmb();
 
-	guest_hv_clock->version = ++vcpu->hv_clock.version;
+	guest_hv_clock->version = ++hv_clock.version;
 
 	kvm_gpc_mark_dirty_in_slot(gpc);
 	read_unlock_irqrestore(&gpc->lock, flags);
 
-	trace_kvm_pvclock_update(v->vcpu_id, &vcpu->hv_clock);
+	trace_kvm_pvclock_update(v->vcpu_id, &hv_clock);
 }
 
 static int kvm_guest_time_update(struct kvm_vcpu *v)
-- 
2.48.1.362.g079036d154-goog


