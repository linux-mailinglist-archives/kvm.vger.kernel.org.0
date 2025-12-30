Return-Path: <kvm+bounces-66856-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 58C8CCEAA54
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 22:04:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2350630221AE
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 21:03:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5B2E263C7F;
	Tue, 30 Dec 2025 21:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="StYbdgis"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66E4F1DE8AD
	for <kvm@vger.kernel.org>; Tue, 30 Dec 2025 21:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767128628; cv=none; b=ikpkzzFSNOrR/b9fRZ3E8u0CeVXUGdTlHVjqXRyfvIjqkZYdli58PYSnpVawvwXWwuCcHhIZ96RtDkOcY4lXv1gZVejruCZ9g4fzIwnBRyVJRlEP3tD08XHh4wJC2WoaR8p3R1Pzi0mE7Lw5IEa4uoycgmG/QUWyZSJtnog78jw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767128628; c=relaxed/simple;
	bh=4+7jjQn6JzQNnlhRmzZZE4sdlO+Oh+y4wNWPEles7Qw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hnxSbaKIyRCZ4tX3+1SH7f8UvRA/pbeTk8wzUBOVmfe5NBBliivXGsGfzNagaGxFLkpSXfaWVxSB/1dDymHE/3wJdm3xI7zRS0vF+94fjenH890jqYbebZ+4W++DxGaPIRG3uJNPR4HS8g83auSSJ85J5HsxcH4lHE+AlevCj3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=StYbdgis; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34c66cb671fso14302285a91.3
        for <kvm@vger.kernel.org>; Tue, 30 Dec 2025 13:03:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767128626; x=1767733426; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ym4S0QyvPMG0XiW+HIJvIT/hvfPyeKcaVKLj0gbxhNQ=;
        b=StYbdgis5smx/HqLl59qmx8b9yVJu44NjPdSjste1uFJVyV/+QgME4PNkNCgr5ezli
         IOBdLQ7WCyCkBLNQcvtxkdtzN/MrEcznka2rVCptdi9/YXdIdMifEfNwn7cWgbPynzW3
         8GFUB2jQMDHtSfQ3PbunMpcrvgGJw5dVrsXfrg66GNF3XRiK4Cb0Za6ckm+C4sBZC6rw
         SINGKeguqJCl/kwlsW2ruFCO9MsqMQraLTCvw8yQgm47erE3VJhVZawKICme7BNyGVQF
         z9BpevMyi6abfxM+7XxYMceG4RNIi7LxaW2XbqDfU+4qASllmbvjD8n22UHwHjgfEywL
         a9pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767128626; x=1767733426;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ym4S0QyvPMG0XiW+HIJvIT/hvfPyeKcaVKLj0gbxhNQ=;
        b=CPB3rgbvbfOw/snHnZBQvaOF1NJSv+e2bUGeimm/Ay8xeOcsg+PuVErRL7HKJU8jL6
         E+qdSTgIb+WyC/649ZO0kzo+ZXtVtXBCmsNwBD8hea6qtclhuERLJTSzVL3vHaautIax
         4/5elxAvg5liLr1YY10IQgyAetw+6Xhls12wXSRb0PxTlGYFvBANyetMMMNA+/Nqw15b
         cAnLoQKqFs2CxAL/wPDFEx3jYEQmPK8s07tjr3+LFO9OJOWfc2J4zJzlm3yKnltqAyCQ
         QRJ9axEbm7gV7ZgqanpV4qma+dW4vMoAsl7pwQwVZaiEvr+OOEKc2irwyQWlFThBqo72
         OCSQ==
X-Forwarded-Encrypted: i=1; AJvYcCWHqeE0/82F4z9dNGBa3VDSd+cN7Nh8B8d3JZXxZwG+uQzLmQyML3h1EHaR+WlAuTfp/7s=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzj858+1wtEvnBIFyw18IwpTgK8tLdU5KvlPfKT8vv+10ni6RC/
	xGphS4xeO17N9NH1wftkJ5NhlYEOva4agSUT4kFPnjk9cHHcEm/zgXSKfA1siD+zN3o9mxR00Ox
	v6ZomSg==
X-Google-Smtp-Source: AGHT+IFLYyERmex9TveHvRNqbQTL0j6gSDW/CkDKRhvyrotz4Q+v2kV0VwCqI9KSie6bNkqYczyCbX9S7UY=
X-Received: from pjbbj19.prod.google.com ([2002:a17:90b:893:b0:34c:a40f:705a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:3d86:b0:366:58cc:b74b
 with SMTP id adf61e73a8af0-376a7aed58cmr35177912637.21.1767128625750; Tue, 30
 Dec 2025 13:03:45 -0800 (PST)
Date: Tue, 30 Dec 2025 13:03:44 -0800
In-Reply-To: <aUz2J/cK2PN/n0of@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251205231913.441872-1-seanjc@google.com> <20251205231913.441872-7-seanjc@google.com>
 <aUz2J/cK2PN/n0of@intel.com>
Message-ID: <aVQ-MNmUa1fb83zH@google.com>
Subject: Re: [PATCH v3 06/10] KVM: nVMX: Switch to vmcs01 to update SVI
 on-demand if L2 is active
From: Sean Christopherson <seanjc@google.com>
To: Chao Gao <chao.gao@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Dongli Zhang <dongli.zhang@oracle.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Dec 25, 2025, Chao Gao wrote:
> On Fri, Dec 05, 2025 at 03:19:09PM -0800, Sean Christopherson wrote:
> >@@ -6963,21 +6963,16 @@ void vmx_hwapic_isr_update(struct kvm_vcpu *vcpu, int max_isr)
> > 	u16 status;
> > 	u8 old;
> > 
> >-	/*
> >-	 * If L2 is active, defer the SVI update until vmcs01 is loaded, as SVI
> >-	 * is only relevant for if and only if Virtual Interrupt Delivery is
> >-	 * enabled in vmcs12, and if VID is enabled then L2 EOIs affect L2's
> >-	 * vAPIC, not L1's vAPIC.  KVM must update vmcs01 on the next nested
> >-	 * VM-Exit, otherwise L1 with run with a stale SVI.
> >-	 */
> >-	if (is_guest_mode(vcpu)) {
> >-		to_vmx(vcpu)->nested.update_vmcs01_hwapic_isr = true;
> >-		return;
> >-	}
> >-
> > 	if (max_isr == -1)
> > 		max_isr = 0;
> > 
> >+	/*
> >+	 * Always update SVI in vmcs01, as SVI is only relevant for L2 if and
> >+	 * only if Virtual Interrupt Delivery is enabled in vmcs12, and if VID
> >+	 * is enabled then L2 EOIs affect L2's vAPIC, not L1's vAPIC.
> >+	 */
> >+	guard(vmx_vmcs01)(vcpu);
> 
> KVM calls this function when virtualizing EOI for L2, and in a previous
> discussion, you mentioned that the overhead of switching to VMCS01 is
> "non-trivial and unnecessary" (see [1]).
> 
> My testing shows that guard(vmx_vmcs01) takes about 140-250 cycles. I think
> this overhead is acceptable for nested scenarios, since it only affects
> EOI-induced VM-exits in specific/suboptimal configurations.
> 
> But I'm wondering whether KVM should update SVI on every VM-entry instead of
> doing it on-demand (i.e., when vISR gets changed). We've encountered two
> SVI-related bugs [1][2] that were difficult to debug. Preventing these issues
> entirely seems worthwhile, and the overhead of always updating SVI during
> VM-entry should be minimal since KVM already updates RVI (RVI and SVI are in
> the the same VMCS field) in vmx_sync_irr_to_pir() when APICv is enabled.

Hmm.  At first glance, I _really_ like this idea, but I'm leaning fairly strongly
towards keeping .hwapic_isr_update().

While small (~28 cycles on EMR), the runtime cost isn't zero, and it affects the
fastpath.  And number of useful updates is comically small.  E.g. without a nested
VM, AFAICT they basically never happen post-boot.  Even when running nested VMs,
the number of useful update when running L1 hovers around ~0.001%.

More importantly, KVM will carry most of the complexity related to vISR updates
regardless of how KVM handles SVI because of the ISR caching for non-APICv
systems.  So while I acknowledge that we've had some nasty bugs and 100% agree
that squashing them entirely is _very_ enticing, I think those bugs were due to
what were effectively two systemic flaws in KVM: (1) not aligning SVI with KVM's
ISR caching code, and (2) the whole "defer updates to nested VM-Exit" mess.

At the end of this series, both (1) and (2) are "solved".  Huh.  And now that I
look at (1) again, the last patch is wrong (benignly wrong, but still wrong).
The changelog says this:

  First, it adds a call during kvm_lapic_reset(), but that's a glorified nop as
  the ISR has already been zeroed.

but that's simply not true.  There's already a call in kvm_lapic_reset().  So
that patch can be amended with:

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 7be4d759884c..55a7a2be3a2e 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2907,10 +2907,8 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
 
        vcpu->arch.pv_eoi.msr_val = 0;
        apic_update_ppr(apic);
-       if (apic->apicv_active) {
+       if (apic->apicv_active)
                kvm_x86_call(apicv_post_state_restore)(vcpu);
-               kvm_x86_call(hwapic_isr_update)(vcpu, -1);
-       }
 
        vcpu->arch.apic_arb_prio = 0;
        vcpu->arch.apic_attention = 0;


At which point updates to highest_isr_cache and .hwapic_isr_update() are fully
symmetrical (ignoring that KVM simply invalidates highest_isr_cache instead of
scanning the vISR on EOI and APICv changes).

So yeah, the more I look at all of this, the more I'm in favor of keeping
.hwapic_isr_update(), e.g. if only to let it serve as a canary for finding issues
related to highest_isr_cache and/or isr_count.

> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index ef8d29c677b9..e7883bf7665f 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6957,45 +6957,20 @@ void vmx_set_apic_access_page_addr(struct kvm_vcpu *vcpu)
> 	read_unlock(&vcpu->kvm->mmu_lock);
>  }
>  
> -void vmx_hwapic_isr_update(struct kvm_vcpu *vcpu, int max_isr)
> +static void vmx_set_rvi_svi(int rvi, int svi)

If this ever goes anywhere, my vote would be to call this vmx_sync_guest_intr_status(),
and pass in only @rvi, e.g. 

  static void vmx_sync_guest_intr_status(struct kvm_vcpu *vcpu, int rvi)
  {
	int svi = kvm_lapic_find_highest_isr(vcpu);
	u16 status, new;

	...
  }

> 	status = vmcs_read16(GUEST_INTR_STATUS);
> +	new = (rvi & 0xff) | ((u8)svi << 8);

I think this is technically undefined behavior?  Due to a shift larger than type
(casting to an 8-bit value and then shifting by 8).  svi[31:8] should always be
'0', but to be paranoid we could do:

	new = (rvi & 0xff) | ((svi & 0xff) << 8);

> +	if (new != status)
> +		vmcs_write16(GUEST_INTR_STATUS, new);
>  }

