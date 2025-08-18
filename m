Return-Path: <kvm+bounces-54900-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CC16DB2AFF7
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 20:08:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7F1F83B3525
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 18:08:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 485F932BF3B;
	Mon, 18 Aug 2025 18:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pB033TwY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E462D32BF22
	for <kvm@vger.kernel.org>; Mon, 18 Aug 2025 18:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755540522; cv=none; b=iqDKvMwEbs8sVTuClkeAmxj/MaGCbm+bwdlRC4+qBcFnNjY0hCk7UDBPVxXNmGoSkJGWePdkL9geUUcEbU27y3hqW3mNZ3enKBDU41LzWiWI2xbXIRertymjtCT2WRzgoND/l1ETpzDKPV0sPWUBHiqFerZZ8OnY4XRB+IreXqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755540522; c=relaxed/simple;
	bh=v3wUxTe/oczfV17Ur6CgCV11cP8tQI+5ZOqEY7Q1eQU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DEIssadC3GLjXor7qzWqqx44VC+1T4qBG0Ij5XU/c5VnnDb5HC6gPilvRPxFoxfQhe4uvrxxpqZcHkczGqWH7YpHYXY1jaKKIOOZz6WSORYz07KcsvPMOqTHFRax5I4+VLW5tTbI7jEjrlNZhQxi9g3WVGVHS3g3FTmoMc6d+U8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pB033TwY; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-76e2ea9366aso3981960b3a.2
        for <kvm@vger.kernel.org>; Mon, 18 Aug 2025 11:08:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755540520; x=1756145320; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YhyFTTY2gxFziV/t1dr06cUEDVJ2jOT7w1mNz7Rq2RU=;
        b=pB033TwYyMYhWLwCwc2MWXbE7kL5qV9TgEyy2yEoDLBBz9xgVbqEfUAdXtwrYarEpk
         TR0fs7BaeyAPdUCWuOLZhqzk8V32rlniFo6RXyymh5PuNjU2JESHivChrsm3Hd7yqNIA
         +ivCdJl/lEWRiXpQaoYlKA3AyJB8LAdGtqDK3z3je/m4ZvulPW+DmhCci38GfoJVAsE2
         GrVNEgUGETsq1i4PndTCwkZuaHXPDmReqN4WECPmKAxeDPXsjIfuWCfofMKwz4t7VYlP
         F9mk+mzRxuWioTPzAr1T05toNbqJZpIBi+j7pzNvKV2iF0AeH+hOFIQbVpbeBSMgoSw8
         gt/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755540520; x=1756145320;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YhyFTTY2gxFziV/t1dr06cUEDVJ2jOT7w1mNz7Rq2RU=;
        b=ElLPidoB5bp4B+YOBdxeCt9h3Xh2+1cXy3hCfaJnwp2F/8hm2PTZcN8/eGn9kkMt60
         CmLJ8IRkcYpYosB+t+tz/JkfdF/FkPZV9SeGM8zeF4BnbSdqCb4VnHvH0iitCm/UDEN0
         1XvYb+xwtAsbsW21qVKotoRlNqgP48apffTtD21rY7yGxTWQqHeeslWX/LdaVC6NIomk
         rkURdcvALuwfyj9LcTrAhSYDAWpJdB9/Mmc79Jgndtg+Xw8K5MdQGLzV9ji3j9EyDP2y
         YBJIbAkuJVvBREd96Asqev508q/EIFQzL1wRSncB095Z9e54XXQqf4+2+d58tGHUrhJX
         wf7w==
X-Gm-Message-State: AOJu0YxX7JVzwkyMYShC/rFzb33aF2boNI2olKpURdk0q31nx7AqJ+wb
	lieV3OdQHynShfWpJACJ9f0jr9taKzXirVRdxvQ9lAinKY3Br88R/8dCbZ6cbWr/bC7MVzJQUTw
	z+y5AOg==
X-Google-Smtp-Source: AGHT+IEuRj/ZPaUh1DyEWU8zUq0bCPdsuEfkK3N4jW/6sjoBpobHBvIOiu/oe68da2aXndSCQQ4o+XsXmJ8=
X-Received: from pgbdt13.prod.google.com ([2002:a05:6a02:438d:b0:b42:a176:cd09])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:3290:b0:240:17d2:c004
 with SMTP id adf61e73a8af0-2430a87fd95mr354744637.43.1755540520150; Mon, 18
 Aug 2025 11:08:40 -0700 (PDT)
Date: Mon, 18 Aug 2025 11:08:38 -0700
In-Reply-To: <20250813192313.132431-3-mlevitsk@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250813192313.132431-1-mlevitsk@redhat.com> <20250813192313.132431-3-mlevitsk@redhat.com>
Message-ID: <aKNsJoslekEMI-FT@google.com>
Subject: Re: [PATCH 2/3] KVM: x86: Fix a semi theoretical bug in kvm_arch_async_page_present_queued
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: kvm@vger.kernel.org, Dave Hansen <dave.hansen@linux.intel.com>, 
	"H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org, Borislav Petkov <bp@alien8.de>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Aug 13, 2025, Maxim Levitsky wrote:
> Fix a semi theoretical race condition in reading of page_ready_pending
> in kvm_arch_async_page_present_queued.

This needs to explain what can actually go wrong if the race is "hit".  After
staring at all of this for far, far too long, I'm 99.9% confident the race is
benign.

If the worker "incorrectly" sees pageready_pending as %false, then the result
is simply a spurious kick, and that spurious kick is all but guaranteed to be a
nop since if kvm_arch_async_page_present() is setting the flag, then (a) the
vCPU isn't blocking and (b) isn't IN_GUEST_MODE and thus won't be IPI'd.

If the worker incorrectly sees pageready_pending as %true, then the vCPU has
*just* written MSR_KVM_ASYNC_PF_ACK, and is guaranteed to observe and process
KVM_REQ_APF_READY before re-entering the guest, and the sole purpose of the kick
is to ensure the request is processed.

> Only trust the value of page_ready_pending if the guest is about to
> enter guest mode (vcpu->mode).

This is misleading, e.g. IN_GUEST_MODE can be true if the vCPU just *exited*.
All IN_GUEST_MODE says is that the vCPU task is somewhere in KVM's inner run loop.

> To achieve this, read the vcpu->mode using smp_load_acquire which is
> paired with smp_store_release in vcpu_enter_guest.
> 
> Then only if vcpu_mode is IN_GUEST_MODE, trust the value of the
> page_ready_pending because it was written before and therefore its correct
> value is visible.
> 
> Also if the above mentioned check is true, avoid raising the request
> on the target vCPU.

Why?  At worst, a dangling KVM_REQ_APF_READY will cause KVM to bail from the
fastpath when it's not strictly necessary to do so.  On the other hand, a missing
request could hang the guest.  So I don't see any reason to try and be super
precise when setting KVM_REQ_APF_READY.

> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  arch/x86/kvm/x86.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 9018d56b4b0a..3d45a4cd08a4 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -13459,9 +13459,14 @@ void kvm_arch_async_page_present(struct kvm_vcpu *vcpu,
>  
>  void kvm_arch_async_page_present_queued(struct kvm_vcpu *vcpu)
>  {
> -	kvm_make_request(KVM_REQ_APF_READY, vcpu);
> -	if (!vcpu->arch.apf.pageready_pending)
> +	/* Pairs with smp_store_release in vcpu_enter_guest. */
> +	bool in_guest_mode = (smp_load_acquire(&vcpu->mode) == IN_GUEST_MODE);

In terms of arch.apf.pageready_pending being modified, it's not IN_GUEST_MODE
that's special, it's OUTSIDE_GUEST_MODE that's special, because that's the only
time the task that hold vcpu->mutex can clear pageready_pending.

> +	bool page_ready_pending = READ_ONCE(vcpu->arch.apf.pageready_pending);

This should be paired with WRITE_ONCE() on the vCPU.

> +
> +	if (!in_guest_mode || !page_ready_pending) {
> +		kvm_make_request(KVM_REQ_APF_READY, vcpu);
>  		kvm_vcpu_kick(vcpu);
> +	}

Given that the race is guaranteed to be bening (assuming my analysis is correct),
I definitely think there should be a comment here explaining that pageready_pending
is "technically unstable".  Otherwise, it takes a lot of staring to understand
what this code is actually doing.

I also think it makes sense to do the bare minimum for OUTSIDE_GUEST_MODE, which
is to wake the vCPU.  Because calling kvm_vcpu_kick() when the vCPU is known to
not be IN_GUEST_MODE is weird.

For the code+comment, how about this?

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6bdf7ef0b535..d721fab3418d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4000,7 +4000,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
                if (!guest_pv_has(vcpu, KVM_FEATURE_ASYNC_PF_INT))
                        return 1;
                if (data & 0x1) {
-                       vcpu->arch.apf.pageready_pending = false;
+                       WRITE_ONCE(vcpu->arch.apf.pageready_pending, false);
                        kvm_check_async_pf_completion(vcpu);
                }
                break;
@@ -13457,7 +13457,7 @@ void kvm_arch_async_page_present(struct kvm_vcpu *vcpu,
        if ((work->wakeup_all || work->notpresent_injected) &&
            kvm_pv_async_pf_enabled(vcpu) &&
            !apf_put_user_ready(vcpu, work->arch.token)) {
-               vcpu->arch.apf.pageready_pending = true;
+               WRITE_ONCE(vcpu->arch.apf.pageready_pending, true);
                kvm_apic_set_irq(vcpu, &irq, NULL);
        }
 
@@ -13468,7 +13468,20 @@ void kvm_arch_async_page_present(struct kvm_vcpu *vcpu,
 void kvm_arch_async_page_present_queued(struct kvm_vcpu *vcpu)
 {
        kvm_make_request(KVM_REQ_APF_READY, vcpu);
-       if (!vcpu->arch.apf.pageready_pending)
+
+       /*
+        * Don't kick the vCPU if it has an outstanding "page ready" event as
+        * KVM won't be able to deliver the next "page ready" token until the
+        * outstanding one is handled.  Ignore pageready_pending if the vCPU is
+        * outside "guest mode", i.e. if KVM might be sending "page ready" or
+        * servicing a MSR_KVM_ASYNC_PF_ACK write, as the flag is technically
+        * unstable.  However, in that case, there's obviously no need to kick
+        * the vCPU out of the guest, so just ensure the vCPU is awakened if
+        * it's blocking.
+        */
+       if (smp_load_acquire(vcpu->mode) == OUTSIDE_GUEST_MODE)
+               kvm_vcpu_wake_up(vcpu);
+       else if (!READ_ONCE(vcpu->arch.apf.pageready_pending))
                kvm_vcpu_kick(vcpu);
 }

