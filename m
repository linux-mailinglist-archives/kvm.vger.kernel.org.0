Return-Path: <kvm+bounces-54138-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BFFD0B1CBD9
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 20:20:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DE1D456555C
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 18:20:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6732C292B53;
	Wed,  6 Aug 2025 18:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wKPDXrb1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 295CA1B5EB5
	for <kvm@vger.kernel.org>; Wed,  6 Aug 2025 18:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754504437; cv=none; b=AwMLFKws9iCD51FZKps9W0xhT2kwSk2ukfP1/naG+TvZD1emDvG/Rl6XPECcJr3k56CMg4F3gKNZzSgqsOfDxIITZLrZaGaBks933UXFug0FTTam/KzPXnyt2USYxojC7U7UsK3WvN9Gg2QeJF/K2FxKqx/QjTKJQv0ImUgETn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754504437; c=relaxed/simple;
	bh=otbA2DBaPpKkc6uRnoJZTfAmFrl25nkaW75pt3VYzgg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=S3Cg4vyUob+bX78z97yg8CIZwQ9NYIyfmc2HSBDlfNalWd6Owg9y2EOZ3mv14R+HVPW6M2lxSi3/lPscMmyasOYcqp5703bIKlpnkkl4Fn0A5666U87Ll6rTqAYHgxmfQ1Hwebkx2V1CYPQ93TjJ9XxUk+10+yuZgxXXag0Ff7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wKPDXrb1; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b2c36d3f884so64374a12.2
        for <kvm@vger.kernel.org>; Wed, 06 Aug 2025 11:20:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754504435; x=1755109235; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0FA0pWAS7pKVbwQEHt3LE0txlNynIPpxZJlwpFzkgno=;
        b=wKPDXrb1JodMIOhA2XJ19nufT9PujZBk4iMX2fIXGYmXXo/0v23FtEo1wIZj+RNqCU
         7zzRTHe7PXYFAgDWoLMwJntxsqjeTm3SzxP4w9k9VH/d36syg7TbGgD3aPrucugwDMl6
         9fPIY4gn1TPJMeSY76cV07gTG9Z6mawO7UARx3eudIUcNjIJOj6RkaQFFEof3oVOk5lj
         Rl4IYsDYxyfom9uz95HDfuaq8W6JDnKVQlaAQxWpA/DaredJu+2m5so34fnBpltNjbtR
         ivFyPzW25DWqrTMqiXWMp6wT6Q9XZl8wJVerplBeWWUjmkyU0PXvfBo1A4yK6MrejLuk
         pNcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754504435; x=1755109235;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0FA0pWAS7pKVbwQEHt3LE0txlNynIPpxZJlwpFzkgno=;
        b=s+Vz/SXNHS61f8G6h0lBcHrUjjq3rxlETCFZiyJSndMfZINa1sAb1sTTN7x0pHXJl8
         i5Cs5qDWPWbQ+cqTgEGqdmHmXv77Cj6XoH6woaOvWbSeP78U72iOvZ9shtFbl8WNMbTx
         gFdfu8wybvI52bOoLYcWIi7LaAImSXGYSRExBj1Krt6Ax+pUai0yYj0JK2eyNsG1Vhs1
         AT4WnwaN0563m9XkvF04viE0ZH+Ses+d97K3uXLhaKCNiByytWszU/zDG1bSJJ1QDOg/
         Aji/i1H/EOuwYozMbA5K8Ep4RTYufRuvYQEbd9VpB9EOKMMvAVAHDWjh3fUQM6UxJCtD
         lSdA==
X-Forwarded-Encrypted: i=1; AJvYcCUX5AvkFVq+wV3izo276nZ2mckdJJD1zA8SKgBkgyPZSfTxvZyAs3GuOfuXtEdINo1yy+w=@vger.kernel.org
X-Gm-Message-State: AOJu0YwFK+x5eUw1lzR8RoehLp9fR+cUNNdodGaUxw1ovChV+4dcwjkk
	9vUfdMuqpOGzm1akcaMheouA+mwSpoOzYDpgB2Jh59WetUlJ/kBnGsfqfRyVVZnVlbPHDt6Awxu
	7fn6PfA==
X-Google-Smtp-Source: AGHT+IFnlU2HwxqSmiqbXbvXranwQEnrrBs3QUOH7DXNJk8uzF5jhChqGI599XzfVoNFPVdM73TZbRC/UOY=
X-Received: from pjsk12.prod.google.com ([2002:a17:90a:62cc:b0:31f:37f:d381])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:4b43:b0:240:79ef:ae80
 with SMTP id d9443c01a7336-2429f5224f7mr52653655ad.8.1754504435574; Wed, 06
 Aug 2025 11:20:35 -0700 (PDT)
Date: Wed, 6 Aug 2025 11:20:34 -0700
In-Reply-To: <20250806081051.3533470-1-hugoolli@tencent.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250806081051.3533470-1-hugoolli@tencent.com>
Message-ID: <aJOc8vIkds_t3e8C@google.com>
Subject: Re: [PATCH] KVM: x86: Synchronize APIC State with QEMU when irqchip=split
From: Sean Christopherson <seanjc@google.com>
To: Yuguo Li <cs.hugolee@gmail.com>
Cc: pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, hpa@zytor.com, x86@kernel.org, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yuguo Li <hugoolli@tencent.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Aug 06, 2025, Yuguo Li wrote:
> When using split irqchip mode, IOAPIC is handled by QEMU while the LAPIC is
> emulated by KVM.  When guest disables LINT0, KVM doesn't exit to QEMU for
> synchronization, leaving IOAPIC unaware of this change.  This may cause vCPU
> to be kicked when external devices(e.g. PIT)keep sending interrupts.

I don't entirely follow what the problem is.  Is the issue that QEMU injects an
IRQ that should have been blocked?  Or is QEMU forcing the vCPU to exit unnecessarily?

> This patch ensure that KVM exits to QEMU for synchronization when the guest
> disables LINT0.

Please wrap at ~75 characters.

> Signed-off-by: Yuguo Li <hugoolli@tencent.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 1 +
>  arch/x86/kvm/lapic.c            | 4 ++++
>  arch/x86/kvm/x86.c              | 5 +++++
>  include/uapi/linux/kvm.h        | 1 +
>  4 files changed, 11 insertions(+)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index f19a76d3ca0e..f69ce111bbe0 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -129,6 +129,7 @@
>  	KVM_ARCH_REQ_FLAGS(32, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
>  #define KVM_REQ_UPDATE_PROTECTED_GUEST_STATE \
>  	KVM_ARCH_REQ_FLAGS(34, KVM_REQUEST_WAIT)
> +#define KVM_REQ_LAPIC_UPDATE              KVM_ARCH_REQ(35)
>  
>  #define CR0_RESERVED_BITS                                               \
>  	(~(unsigned long)(X86_CR0_PE | X86_CR0_MP | X86_CR0_EM | X86_CR0_TS \
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 8172c2042dd6..65ffa89bf8a6 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -2329,6 +2329,10 @@ static int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
>  			val |= APIC_LVT_MASKED;
>  		val &= apic_lvt_mask[index];
>  		kvm_lapic_set_reg(apic, reg, val);
> +		if (irqchip_split(apic->vcpu->kvm) && (val & APIC_LVT_MASKED)) {

This applies to much more than just LINT0, and for at least LVTPC and LVTCMCI,
KVM definitely doesn't want to exit on every change.

Even for LINT0, it's not obvious that "pushing" from KVM is a better option than
having QEMU "pull" as needed.

At the very least, this would need to be guarded by a capability, otherwise
the new userspace exit would confuse existing VMMs (and probably result in the
VM being terminated).


> +			kvm_make_request(KVM_REQ_LAPIC_UPDATE, apic->vcpu);
> +			kvm_vcpu_kick(apic->vcpu);

Why kick?  Cross-vCPU writes to LINT0 shouldn't be a thing, i.e. the kick should
effectivel be a nop.

