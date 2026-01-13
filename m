Return-Path: <kvm+bounces-67988-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 083B2D1BAA9
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 00:12:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id ED79F3032960
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 23:11:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFD40368264;
	Tue, 13 Jan 2026 23:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1j8e8IIT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0489531AF31
	for <kvm@vger.kernel.org>; Tue, 13 Jan 2026 23:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768345865; cv=none; b=FmpHHOw+NCcRDRJA3ZJBcVyZ+J0v/LEUqSITuPBv1UvLGuMrQcm+5MqrXYkwPZE6L4/5rHb83xXwLY4WWPAj4kCEEcm7tutX470EsYV0/+zUHXvnvek/8PoSuhKgwFG9kgHLqh+ien7qSwuTYAwQwNEv6N3erZb0Q/hw5H9l4RI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768345865; c=relaxed/simple;
	bh=fLyu+0cU6qmRu11TkEOA4FgiHbBAgNe08/ZJFz1riZQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HoS7HmnCZLppcvt/jApOprGjhhTcH3/KHqUrYoJhZ68SJZ9uU39VG2mEGO1q8davE+jllaBStw9Os6zzXVu0dSIO4Dijhzb/PBUn51UXsLGCN/w1hNn1DjWl5ZHWVpJWmyKeuCrF5HYXk0d8REMn2m3dJRUUiCQaV1ieC8Bxje4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1j8e8IIT; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34aa6655510so8564057a91.1
        for <kvm@vger.kernel.org>; Tue, 13 Jan 2026 15:11:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768345863; x=1768950663; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=gMHd11+SPOANXiJEC1562pMSsk1oD23Ptnjj0uWhAaQ=;
        b=1j8e8IITICKtYyBpej7OJdWxrLBPOCEpDA02lbKoJ69o/y6cdLg+ZBC554touUuPnF
         PXvxZInyUT8ol8yXuyk1c9jSpBqKHjPHqhGa24FCLEKoGMzciJhEVRFnt/GwVra1+vK9
         L3/4sSV2EaWSaBQN49sYPB4pGjJ463epXJ1k3M2m33psbDZtxzNEFT+1ssg7weeKUiA5
         nBTnSqAvQJcYweIlLQg3H0ioXOF9W4ydJdC1cO7IKwDXCHDBWIxwy25puzw0WICbKo8N
         jnwcOMYMiRhMMwymknz3FzAzoL//Vccr5m4IAxUb8ppE9HMcP5dJGPYYMEuI5PjpJDWa
         vUWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768345863; x=1768950663;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gMHd11+SPOANXiJEC1562pMSsk1oD23Ptnjj0uWhAaQ=;
        b=QJJMG+lEp5sTncfpxJD462L4SDA4JKEmQXKzS2WvMcdu/LdYmyipcQo0ZMRaeu8e8L
         hc+j0ua/wAB7v/6DQOPtL8YDg2k+/zFyRQLOx+h32yio5uWi0zhtdlwq6xstfmRv2rpj
         A8pF9BflFpLAGVO7CbA4UdTncFp07SMjaSHrX6bcx738zWYL90L8VavU2RsHv+1GuthW
         B7SbZARWm/46WTUHhLq5tHutnHx71Tv7o70WN2714UD2pt+N4PBOXUAMRyU3tj60zqC0
         744kvV/VIvIvcCKCSM6VbZoAXRDSw5PsgOwW7uBKxG57ZIDXJLUDClxeRNJNt4gHpNIG
         UgJw==
X-Forwarded-Encrypted: i=1; AJvYcCVJ+dW5Gnhfi/aWgYGfCzALPFm6MPHBhUHMm0OiDKQVEsNfIvt/2H4dnK//dxiGZcMUP80=@vger.kernel.org
X-Gm-Message-State: AOJu0YzHcID6DdxkHm5+4tyRvO64+sfjmyFfSkpw4JUR5VNMWGhr7Snx
	GYQXWGJQzKcfwSdDLZq5iPATQEpIleccpH+ICfe0a6FVz98I36HzHp07sI94LGGnjmteQhsYvQw
	2TbNdTw==
X-Received: from pjre16.prod.google.com ([2002:a17:90a:b390:b0:340:9d73:9c06])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:520e:b0:340:2f48:b51a
 with SMTP id 98e67ed59e1d1-351090c679emr708041a91.15.1768345863234; Tue, 13
 Jan 2026 15:11:03 -0800 (PST)
Date: Tue, 13 Jan 2026 15:11:01 -0800
In-Reply-To: <20251229111708.59402-2-khushit.shah@nutanix.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251229111708.59402-1-khushit.shah@nutanix.com> <20251229111708.59402-2-khushit.shah@nutanix.com>
Message-ID: <aWbRBd85eeb0awfF@google.com>
Subject: Re: [PATCH v5 1/3] KVM: x86: Refactor suppress EOI broadcast logic
From: Sean Christopherson <seanjc@google.com>
To: Khushit Shah <khushit.shah@nutanix.com>
Cc: pbonzini@redhat.com, kai.huang@intel.com, dwmw2@infradead.org, 
	mingo@redhat.com, x86@kernel.org, bp@alien8.de, hpa@zytor.com, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	dave.hansen@linux.intel.com, tglx@linutronix.de, jon@nutanix.com, 
	shaju.abraham@nutanix.com
Content-Type: text/plain; charset="us-ascii"

On Mon, Dec 29, 2025, Khushit Shah wrote:
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 0ae7f913d782..2c24fd8d815f 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -105,6 +105,39 @@ bool kvm_apic_pending_eoi(struct kvm_vcpu *vcpu, int vector)
>  		apic_test_vector(vector, apic->regs + APIC_IRR);
>  }
>  
> +bool kvm_lapic_advertise_suppress_eoi_broadcast(struct kvm *kvm)

This can be static, its only caller is kvm_apic_set_version().

> +{
> +	/*
> +	 * The default in-kernel I/O APIC emulates the 82093AA and does not
> +	 * implement an EOI register. Some guests (e.g. Windows with the
> +	 * Hyper-V role enabled) disable LAPIC EOI broadcast without checking
> +	 * the I/O APIC version, which can cause level-triggered interrupts to
> +	 * never be EOI'd.
> +	 *
> +	 * To avoid this, KVM must not advertise Suppress EOI Broadcast support
> +	 * when using the default in-kernel I/O APIC.
> +	 *
> +	 * Historically, in split IRQCHIP mode, KVM always advertised Suppress
> +	 * EOI Broadcast support but did not actually suppress EOIs, resulting
> +	 * in quirky behavior.
> +	 */
> +	return !ioapic_in_kernel(kvm);
> +}
> +
> +bool kvm_lapic_respect_suppress_eoi_broadcast(struct kvm *kvm)

I don't see any point in forcing every caller to check SPIV *and* this helper.
Just do:

bool kvm_lapic_suppress_eoi_broadcast(struct kvm_lapic *apic)
{
	struct kvm *kvm = apic->vcpu->kvm;

	if (!(kvm_lapic_get_reg(apic, APIC_SPIV) & APIC_SPIV_DIRECTED_EOI))
		return false;

	switch (kvm->arch.suppress_eoi_broadcast_mode) {

	...
	}
}

And then callers are much more readable, e.g. (spoiler alert if you haven't read
my other mail, which I haven't sent yet):

	if (trigger_mode != IOAPIC_LEVEL_TRIG ||
	    kvm_lapic_suppress_eoi_broadcast(apic))
		return;

and

	/* Request a KVM exit to inform the userspace IOAPIC. */
	if (irqchip_split(apic->vcpu->kvm)) {
		/*
		 * Don't exit to userspace if the guest has enabled Directed
		 * EOI, a.k.a. Suppress EOI Broadcasts, in which case the local
		 * APIC doesn't broadcast EOIs (the guest must EOI the target
		 * I/O APIC(s) directly).
		 */
		if (kvm_lapic_suppress_eoi_broadcast(apic))
			return;

		apic->vcpu->arch.pending_ioapic_eoi = vector;
		kvm_make_request(KVM_REQ_IOAPIC_EOI_EXIT, apic->vcpu);
		return;
	}

