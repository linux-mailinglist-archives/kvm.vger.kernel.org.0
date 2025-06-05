Return-Path: <kvm+bounces-48606-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 57657ACF85F
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 21:51:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C496E3AFD0F
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 19:50:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85AA327FB33;
	Thu,  5 Jun 2025 19:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Z0vCB+pS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 278A127F198
	for <kvm@vger.kernel.org>; Thu,  5 Jun 2025 19:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749153030; cv=none; b=o9TSss6FWgg0l6cLudqN7LL+CEXS+8dszy39b85dUHQEptT0P+efA7owu0H0IEa7poKV3bHCakx4YMSLE/rrtlnx8T0bqzWOZOxol9/2mfUzfm7jQoUm3UksADiBwIcOanJHsruMX0fZLRn0MBoyh1ppUGhN3VzK0cfrI+DhVZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749153030; c=relaxed/simple;
	bh=dMMmeVqG6y64MjPQv22VwPgGnCrbMuVJu5GSj+ydhl0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZNfNLLIiKjTeD0rpLk28JevDiKPlPv/casKbbp/mSysbriD/JXEv7r12kmMHSQ5OkgRPH22ldhcxI9nJb2RfLqickHxO3LWeDbmPwk+9rD/aE96c40iWXx64fKeUIOZF6U49H1axjMun5G3bfYki41ngfk2kkn46H8PTc+m8TQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Z0vCB+pS; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-312df02acf5so1964378a91.1
        for <kvm@vger.kernel.org>; Thu, 05 Jun 2025 12:50:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749153028; x=1749757828; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=e5/ya4b8F4i6OaZk//U+SRw0E/FULSSadOHslX+QOmc=;
        b=Z0vCB+pSagNZB5OyKJKNZov6STd8iuhhlIpFDoZMVkB55vprgsNTFwp1j53o762uX1
         775gVQLvRnre/iTV6WR0IsW8UBsslakXcc9mrZd01B9TC9aRYMu770eeaapInwnAm29V
         OyswQXrYmum2ILnKJOtoVhAhhOpghrF4kywmxEby0iLNiJGTUJA7mUsjUGxabKl6Gzup
         JOHx1q4xaaC/n6pidysWmfBXQeT1fTcmh3KUoZ7hp6yiexKg1Esap3ASy8CjIYSRqIjP
         sHn3wmk91neq6Z4wpMYk4Jzx9ocoUe0TvpkJntxBTl5KRKOa0ym+XHgwydovLHb6mre6
         c7gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749153028; x=1749757828;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=e5/ya4b8F4i6OaZk//U+SRw0E/FULSSadOHslX+QOmc=;
        b=IGb3yrmO33DfeAk56HPyAV5Acjjy63w3qQxPxr4683FR43kzErEgqiub21YwFcFiql
         y0EoipLH8inws1IUfvBXVmP6f1q7aJBI+gplN8yeSBDCpWk7/oYzc669cDk5f2U04ddg
         bzKtYXv12AgG7rE8eWKRtifvt/2rvtf4Cj85hbRe/d7+Jix9ftQCqfYuaUrURgwb8JcA
         jEXUjG7RrWdxEjcBqH+XT/4yvQc0HGB+Ah7BIZkBL8SmToPjhTpSll7RnlsvgIORh1sr
         nk7fjfcZRvzY5Yo4lF4pqZidWU4bNRvyy/NzF1Sbky6w8HAsdw3XLGqs/0Ns++0d4qgG
         1BEw==
X-Gm-Message-State: AOJu0YxjYvmk6zrl98eMZViO65AB7lixHpOIm5aTn81m2B2+VAGqE00V
	HhSiAa27pEWImMnQF5EweVSGETfajHQNBDbmXl2XVRuVUy6tmpjEvmow0+9O0JQSFpp1RQe8nBU
	J6TpEIA==
X-Google-Smtp-Source: AGHT+IES7OKRIKK/BU05Qe7TJH5y0xsr3cOFiTR2JP9IX0NjNsoT6bbpcvX5TnLErMO9fBPCLPkFIeaGAT4=
X-Received: from pjbeu15.prod.google.com ([2002:a17:90a:f94f:b0:311:6040:2c7a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5866:b0:311:be43:f09a
 with SMTP id 98e67ed59e1d1-31349f53ea6mr632451a91.9.1749153028181; Thu, 05
 Jun 2025 12:50:28 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  5 Jun 2025 12:50:17 -0700
In-Reply-To: <20250605195018.539901-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250605195018.539901-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc0.604.gd4ff7b7c86-goog
Message-ID: <20250605195018.539901-4-seanjc@google.com>
Subject: [PATCH 3/4] KVM: x86: Move INIT_RECEIVED vs. INIT/SIPI blocked check
 to KVM_RUN
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+c1cbaedc2613058d5194@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"

Check for the should-be-impossible scenario of a vCPU being in
Wait-For-SIPI with INIT/SIPI blocked during KVM_RUN instead of trying to
detect and prevent illegal combinations in every ioctl that sets relevant
state.  Attempting to handle every possible "set" path is a losing game of
whack-a-mole, and risks breaking userspace.  E.g. INIT/SIPI are blocked on
Intel if the vCPU is in VMX Root mode (post-VMXON), and on AMD if GIF=0.
Handling those scenarios would require potentially breaking changes to
{vmx,svm}_set_nested_state().

Moving the check to KVM_RUN fixes a syzkaller-induced splat due to the
aforementioned VMXON case, and in theory should close the hole once and for
all.

Note, kvm_x86_vcpu_pre_run() already handles SIPI_RECEIVED, only the WFS
case needs additional attention.

Reported-by: syzbot+c1cbaedc2613058d5194@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?id=490ae63d8d89cb82c5d462d16962cf371df0e476
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 24 ++++++++----------------
 1 file changed, 8 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c3cbcd9e39f6..9935307ad41f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5487,12 +5487,6 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
 	    (events->exception.nr > 31 || events->exception.nr == NMI_VECTOR))
 		return -EINVAL;
 
-	/* INITs are latched while in SMM */
-	if (events->flags & KVM_VCPUEVENT_VALID_SMM &&
-	    (events->smi.smm || events->smi.pending) &&
-	    vcpu->arch.mp_state == KVM_MP_STATE_INIT_RECEIVED)
-		return -EINVAL;
-
 	process_nmi(vcpu);
 
 	/*
@@ -11558,6 +11552,14 @@ static int kvm_x86_vcpu_pre_run(struct kvm_vcpu *vcpu)
 	if (WARN_ON_ONCE(vcpu->arch.mp_state == KVM_MP_STATE_SIPI_RECEIVED))
 		return -EINVAL;
 
+	/*
+	 * Disallow running the vCPU if userspace forced it into an impossible
+	 * MP_STATE, e.g. if the vCPU is in WFS but SIPI is blocked.
+	 */
+	if (vcpu->arch.mp_state == KVM_MP_STATE_INIT_RECEIVED &&
+	    !kvm_apic_init_sipi_allowed(vcpu))
+		return -EINVAL;
+
 	return kvm_x86_call(vcpu_pre_run)(vcpu);
 }
 
@@ -11906,16 +11908,6 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
 		goto out;
 	}
 
-	/*
-	 * Pending INITs are reported using KVM_SET_VCPU_EVENTS, disallow
-	 * forcing the guest into INIT/SIPI if those events are supposed to be
-	 * blocked.
-	 */
-	if (!kvm_apic_init_sipi_allowed(vcpu) &&
-	    (mp_state->mp_state == KVM_MP_STATE_SIPI_RECEIVED ||
-	     mp_state->mp_state == KVM_MP_STATE_INIT_RECEIVED))
-		goto out;
-
 	if (mp_state->mp_state == KVM_MP_STATE_SIPI_RECEIVED) {
 		kvm_set_mp_state(vcpu, KVM_MP_STATE_INIT_RECEIVED);
 		set_bit(KVM_APIC_SIPI, &vcpu->arch.apic->pending_events);
-- 
2.50.0.rc0.604.gd4ff7b7c86-goog


