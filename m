Return-Path: <kvm+bounces-30611-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 22E1F9BC472
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 05:54:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 43DC71C2127C
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 04:54:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 780AB1B3936;
	Tue,  5 Nov 2024 04:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4PpPotR1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1320E817
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 04:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730782463; cv=none; b=t+qyvy28BBKvuwKfw1qWGBmqJrQOVoThPs05Aa9QpmxH/fRuVMUjTC5SZYTETXZaeQT8muxfPifNf5nbRVdH9xVgBO2YURpaAvKRM5TMoR3+SBEyj1RaIDpArqPKCZZn9fONMGuyOyEhEOhDQIyKjRajXEjEM8FFXF+kjHTe4HU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730782463; c=relaxed/simple;
	bh=sa5u36kVEuWP8p7zcYfL7g+MYf/Q1YzLHNWBiknbHC8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bt3jI6fwF1cx3yqs1jgu1ss9DJnK7Dw75fDCm0YxGocM9AK1k6I+YLtDoTtuIKi3vVFBUn7sbe2slaLZNs6EaHR29VTYh307b2wz47AEaaFtTmgHI12gO+vx6u+HH6Zzu8NwbfKTNISFqUuMpy1rRRckrRbHWYkf44n3/Ke5qtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4PpPotR1; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2e2ebab7abfso5086388a91.0
        for <kvm@vger.kernel.org>; Mon, 04 Nov 2024 20:54:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730782461; x=1731387261; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yQ8oqOdF80DzKJNpPyXZRSrJbMTHHUmvfCmvacNZPBM=;
        b=4PpPotR1hi2veqdHVopgufoGbgvc7wa4HeW2mL1/KOKvPaxuGWAxG9CrmW+CQoBhTF
         Xs2pyjb9FkAnBr07KGM4KcOuhOk+8PodeIGlJPKLJ/zrjZL2LR3QaCuiFvrdVmLSPtjo
         NMZACr/vQq7ndeNU7JeblLiKbFvnO6oz6nrYy9KDiHZAVh/HGfyKZvZnosqnx8MMxIfl
         tVoiRqXnSm3eBPld1/q03f+YpLstsQLchoRZc5GxdEyhv7RqaZYadGjEmJRDrWRBjV6J
         GVntAG0urLvvF5CTLpgrO4F3d2g6CUwx9DFCPncdEBS2NEuIHfiyQ35m7JtOyUESGqDg
         OLTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730782461; x=1731387261;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yQ8oqOdF80DzKJNpPyXZRSrJbMTHHUmvfCmvacNZPBM=;
        b=ZPLRqkaFjj9GcNFQ3CiKEhJtto61g5V+NWiUo9TUY9XypULMNoZctpXAd5qlJCP0KF
         3gehe/sIeFLJSfRuvSQ9bgfh/4BDR+PyS74uKmKrobL8MwSIwi+BmNbzzSBlGyozhSPo
         17MuN1Cmvc3jDMlsb/sDTSl61ySigQJE6KDhp50dOohNq04zM2prIBAQ64y6BWQ2lTLt
         rvP9kR/bWfq4hutMAvG4KmuYTkt5HP+5Dc2GQNmX1qMUtnKAJs2ZSuV9GE0Cpp0TmB8S
         wW3GhjfR68kj2rGvK5tmvc6x+QOHSv6HGHpuWJB9mPGKTcKF9U2oyvjoxrOss2mOpteq
         aTdw==
X-Forwarded-Encrypted: i=1; AJvYcCWG4wnvTHR2H0vdOSzG6gmxm6UPcv2lUE5qdaZ7rukPfE6cQ+ikyCnEKmGRsAPVe6j4l64=@vger.kernel.org
X-Gm-Message-State: AOJu0YxH3Sgag2biBE/hrKlBBGjD4f0qRgt5TPEdEcHren/0ugSLy61r
	ZwJG+sIq3hopQsZBlpgVm/gV9NUCoPold5QQ1QuAXMOxyvO6rnsvsZ8oiRM+dMRGCLmms8HzJ5b
	n9A==
X-Google-Smtp-Source: AGHT+IFmJXJc0gcY9bqqaeHzAKiJM4Ch3Ys6g2m+H6Cm/I8d/cnQQJkswDmSRDQq7HUeL+JuLNhhHERxTkg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a17:90b:2b85:b0:2e2:b937:eeb0 with SMTP id
 98e67ed59e1d1-2e93e0b7b65mr48491a91.2.1730782461403; Mon, 04 Nov 2024
 20:54:21 -0800 (PST)
Date: Mon, 4 Nov 2024 20:54:20 -0800
In-Reply-To: <20241101193532.1817004-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241101193532.1817004-1-seanjc@google.com>
Message-ID: <Zymk_EaHkk7FPqru@google.com>
Subject: Re: [PATCH] KVM: x86: Update irr_pending when setting APIC state with
 APICv disabled
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yong He <zhuangel570@gmail.com>
Cc: Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="us-ascii"

+Maxim

On Fri, Nov 01, 2024, Sean Christopherson wrote:
> Explicitly set apic->irr_pending after stuffing the vIRR when userspace
> sets APIC state and APICv is disabled, otherwise KVM will skip scanning
> the vIRR in subsequent calls to apic_find_highest_irr(), and ultimately
> fail to inject the interrupt until another interrupt happens to be added
> to the vIRR.
> 
> Only the APICv-disabled case is flawed, as KVM forces apic->irr_pending to
> be true if APICv is enabled, because not all vIRR updates will be visible
> to KVM.
> 
> Note, irr_pending is intentionally not updated in kvm_apic_update_apicv(),
> because when APICv is being inhibited/disabled, KVM needs to keep the flag
> set until the next emulated EOI so that KVM will correctly handle any
> in-flight updates to the vIRR from hardware.  But when setting APIC state,
> neither the VM nor the VMM can assume specific ordering between an update
> from hardware and overwriting all state in kvm_apic_set_state(), thus KVM
> can safely clear irr_pending if the vIRR is empty.
> 
> Reported-by: Yong He <zhuangel570@gmail.com>
> Closes: https://lkml.kernel.org/r/20241023124527.1092810-1-alexyonghe%40tencent.com
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/lapic.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 65412640cfc7..deb73aea2c06 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -3086,6 +3086,15 @@ int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s)
>  		kvm_x86_call(hwapic_irr_update)(vcpu,
>  						apic_find_highest_irr(apic));
>  		kvm_x86_call(hwapic_isr_update)(apic_find_highest_isr(apic));
> +	} else {
> +		/*
> +		 * Note, kvm_apic_update_apicv() is responsible for updating
> +		 * isr_count and highest_isr_cache.  irr_pending is somewhat
> +		 * special because it mustn't be cleared when APICv is disabled
> +		 * at runtime, and only state restore can cause an IRR bit to
> +		 * be set without also refreshing irr_pending.
> +		 */
> +		apic->irr_pending = apic_search_irr(apic) != -1;

I did a bit more archaeology in order to give this a Fixes tag (and a Cc: stable),
and found two interesting evolutions of this code.

The bug was introduced by commit 755c2bf87860 ("KVM: x86: lapic: don't touch
irr_pending in kvm_apic_update_apicv when inhibiting it"), which as the shortlog
suggests, deleted code that update irr_pending.

Before that commit, kvm_apic_update_apicv() did more or less what I am proposing
here, with the obvious difference that the proposed fix is specific to
kvm_lapic_reset().

        struct kvm_lapic *apic = vcpu->arch.apic;

        if (vcpu->arch.apicv_active) {
                /* irr_pending is always true when apicv is activated. */
                apic->irr_pending = true;
                apic->isr_count = 1;
        } else {
                apic->irr_pending = (apic_search_irr(apic) != -1);
                apic->isr_count = count_vectors(apic->regs + APIC_ISR);
        }

And _that_ bug (clearing irr_pending) was introduced by commit b26a695a1d78 ("kvm:
lapic: Introduce APICv update helper function").  Prior to 97a71c444a14, KVM
unconditionally set irr_pending to true in kvm_apic_set_state(), i.e. assumed
that the new virtual APIC state could have a pending IRQ (which isn't a terrible
assumption.

Furthermore, in addition to introducing this issue, commit 755c2bf87860 also
papered over the underlying bug: KVM doesn't ensure CPUs and devices see APICv
as disabled prior to searching the IRR.  Waiting until KVM emulates EOI to update
irr_pending works because KVM won't emulate EOI until after refresh_apicv_exec_ctrl(),
and because there are plenty of memory barries in between, but leaving irr_pending
set is basically hacking around bad ordering, which I _think_ can be fixed by:

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 83fe0a78146f..85d330b56c7e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10548,8 +10548,8 @@ void __kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
                goto out;
 
        apic->apicv_active = activate;
-       kvm_apic_update_apicv(vcpu);
        kvm_x86_call(refresh_apicv_exec_ctrl)(vcpu);
+       kvm_apic_update_apicv(vcpu);
 
        /*
         * When APICv gets disabled, we may still have injected interrupts

So, while searching the IRR is technically sufficient to fix the bug, I'm leaning
*very* strongly torward fixing this bug by unconditionally setting irr_pending
to true in kvm_apic_update_apicv(), with a FIXME to call out what KVM should be
doing.  And then address that FIXME in a future series (I have a rather massive
pile of fixes and cleanups that are closely related, so there will be ample
opportunity).

From: Sean Christopherson <seanjc@google.com>
Date: Fri, 1 Nov 2024 12:35:32 -0700
Subject: [PATCH] KVM: x86: Unconditionally set irr_pending when updating APICv
 state

TODO: writeme

Fixes: 755c2bf87860 ("KVM: x86: lapic: don't touch irr_pending in kvm_apic_update_apicv when inhibiting it")
Cc: stable@vger.kernel.org
Reported-by: Yong He <zhuangel570@gmail.com>
Closes: https://lkml.kernel.org/r/20241023124527.1092810-1-alexyonghe%40tencent.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/lapic.c | 29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 2098dc689088..95c6beb8ce27 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2629,19 +2629,26 @@ void kvm_apic_update_apicv(struct kvm_vcpu *vcpu)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
 
-	if (apic->apicv_active) {
-		/* irr_pending is always true when apicv is activated. */
-		apic->irr_pending = true;
+	/*
+	 * When APICv is enabled, KVM must always search the IRR for a pending
+	 * IRQ, as other vCPUs and devices can set IRR bits even if the vCPU
+	 * isn't running.  If APICv is disabled, KVM _should_ search the IRR
+	 * for a pending IRQ.  But KVM currently doesn't ensure *all* hardware,
+	 * e.g. CPUs and IOMMUs, has seen the change in state, i.e. searching
+	 * the IRR at this time could race with IRQ delivery from hardware that
+	 * still sees APICv as being enabled.
+	 *
+	 * FIXME: Ensure other vCPUs and devices observe the change in APICv
+	 *        state prior to updating KVM's metadata caches, so that KVM
+	 *        can safely search the IRR and set irr_pending accordingly.
+	 */
+	apic->irr_pending = true;
+
+	if (apic->apicv_active)
 		apic->isr_count = 1;
-	} else {
-		/*
-		 * Don't clear irr_pending, searching the IRR can race with
-		 * updates from the CPU as APICv is still active from hardware's
-		 * perspective.  The flag will be cleared as appropriate when
-		 * KVM injects the interrupt.
-		 */
+	else
 		apic->isr_count = count_vectors(apic->regs + APIC_ISR);
-	}
+
 	apic->highest_isr_cache = -1;
 }
 

base-commit: 8fe4fefefa1b9ea01557d454699c20fdf709e890
-- 

