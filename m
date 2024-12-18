Return-Path: <kvm+bounces-34070-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 481B89F6D31
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 19:24:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8AFBD169A4E
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 18:24:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B72C1FBC8B;
	Wed, 18 Dec 2024 18:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VT3zVTqs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02D8B3597C
	for <kvm@vger.kernel.org>; Wed, 18 Dec 2024 18:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734546232; cv=none; b=Q211Ee64kJbjFuWU53QepO/7B/kPpU4uf7oRjs88oozUEAwJ7JgKpjWTG/3eFNu1PyfOT58bNob+R6jQlPwixkq/9fDjktHRLA9EJFFeziUJ4my8oBPFCxtPMuOspca0xPciHwO7fxCRiyheI2GatimIJtYuqNX3GZt17AT4ro8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734546232; c=relaxed/simple;
	bh=EeR9KqIYhEJFkzMfRCbIc/g9z9lvZXqPbiNegt1dWew=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hQsjMIKiNnR26wxI++c1J4plDb4I8FBQL19bNqHKyzQMsloa5L9se/1UGZpcTwV42HwP0c61x+5L3wpXii7dXdcJ/C6SsHf1HMiHsfURyAHW3UUzl0RncUggy4LKtpPYJHd6iKnm695DXtPT78rUZwgbgPMOtCROtgve/rZgJAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VT3zVTqs; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-218cf85639eso20106275ad.3
        for <kvm@vger.kernel.org>; Wed, 18 Dec 2024 10:23:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734546230; x=1735151030; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RmkzlEVKsyHe3S3v/tp8qCiCvai6YjJH4HUuQciU4ok=;
        b=VT3zVTqsp6V+pixCx2+Fwq4ZE8IYt5AqHpI3LaiR1HlYWaI8ROG5zVweTrzDov2vEl
         p5Dw2NaePB3vydd99a+fyqd0cdty4wnu2r9WBZATW7MgVqgNHg7ErkTcgfklq6iQPmPW
         Og5JfC3dyf3X0QwCvGXWIGjjCGT2OSuFPnyxxCIYNhonRldsjA908dzBDt3Khu6I6Q/5
         bT2WpSqGcn+zRA+vjc/UQE428/c1x3k4PXZeVI07o2EqutlBrSvY9P8y4jEAmcIihWBL
         b0cKFDQoDfUpqIG2Ys74lyhn4E8wJRrIKdYc1MQcD0+tlLogkLITAtQQSgY/R5jDtiQ4
         6mFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734546230; x=1735151030;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RmkzlEVKsyHe3S3v/tp8qCiCvai6YjJH4HUuQciU4ok=;
        b=Rejg+wzzfpDN8lPZBasH5+WJ3qWxmaB8wYqtrrw2sBQh6OFc/1TSHza2k7AnAnPg15
         fdHVAqUfU6y5hl79clm6y7KMAYaqhu0SaudSQaiQv2fzxUz1aairQZZjmvRF8FxDAyWs
         ttGZArbCBXw+5746MrRxtk8OEVEoKhZkmxTPhozr99HmONTqvx/zdBDgDnrC1x0i0fbN
         SOJq7/a9gZ4ZbQwMhg77M/PEvixr8FGJ+hUYy4ZK+SnBLv4X+hrG+3iCzTfuij/fRPeK
         559+Y4ZQ7YW9MuKcfLjplJamUZceojdnL4qaBnHC41I7taWqB2SLki3Ugq92erN3nfsM
         j0fQ==
X-Forwarded-Encrypted: i=1; AJvYcCUIDlOQdiOw8C4aAJwPT9df15Q1XkbNDJLlYfd7gRFzRfRXrVi6szCsk1WU/3GhbgL9kJg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyCQfMwoW+8+dgNqvGMp8WWOl+8RLNoO/yd9OhZbpntemrZ2ep1
	Xn1T4CqafEICODml3qn5vKRC2Re1vdupjLXzeZPzK49Q+y0iOZRn20Bu9hlRVZ4faZYHPXEN0Zn
	UeQ==
X-Google-Smtp-Source: AGHT+IHZ/azbCeXLSE2Q4wDj7TyAPz+scx9lnjO+Wu2rIQp2gHgfQHL40ooMY9toxGXzQou8xzhloeGtppg=
X-Received: from pgdm11.prod.google.com ([2002:a63:8c0b:0:b0:7fd:3f0e:ce05])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ef4e:b0:216:1357:8df8
 with SMTP id d9443c01a7336-219d96d21d1mr8914495ad.43.1734546230384; Wed, 18
 Dec 2024 10:23:50 -0800 (PST)
Date: Wed, 18 Dec 2024 10:23:49 -0800
In-Reply-To: <20241217181458.68690-3-iorlov@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241217181458.68690-1-iorlov@amazon.com> <20241217181458.68690-3-iorlov@amazon.com>
Message-ID: <Z2MTNcV_MK_myHPh@google.com>
Subject: Re: [PATCH v3 2/7] KVM: x86: Add emulation status for unhandleable vectoring
From: Sean Christopherson <seanjc@google.com>
To: Ivan Orlov <iorlov@amazon.com>
Cc: bp@alien8.de, dave.hansen@linux.intel.com, mingo@redhat.com, 
	pbonzini@redhat.com, shuah@kernel.org, tglx@linutronix.de, hpa@zytor.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, x86@kernel.org, dwmw@amazon.co.uk, 
	pdurrant@amazon.co.uk, jalliste@amazon.co.uk
Content-Type: text/plain; charset="us-ascii"

On Tue, Dec 17, 2024, Ivan Orlov wrote:
> Add emulation status for unhandleable vectoring, i.e. when KVM can't
> emulate an instruction during vectoring. Such a situation can occur
> if guest sets the IDT descriptor base to point to MMIO region, and
> triggers an exception after that.
> 
> Exit to userspace with event delivery error when KVM can't emulate
> an instruction when vectoring an event.
> 
> Signed-off-by: Ivan Orlov <iorlov@amazon.com>
> ---
> V1 -> V2:
> - This patch wasn't included in V1.
> V2 -> V3:
> - Make new X86EMUL_ code more generic to allow using it for any type
> of unhandleable vectoring
> 
>  arch/x86/kvm/kvm_emulate.h | 2 ++
>  arch/x86/kvm/x86.c         | 5 +++++
>  2 files changed, 7 insertions(+)
> 
> diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
> index 10495fffb890..5bcf50ffc3de 100644
> --- a/arch/x86/kvm/kvm_emulate.h
> +++ b/arch/x86/kvm/kvm_emulate.h
> @@ -88,6 +88,8 @@ struct x86_instruction_info {
>  #define X86EMUL_CMPXCHG_FAILED  4 /* cmpxchg did not see expected value */
>  #define X86EMUL_IO_NEEDED       5 /* IO is needed to complete emulation */
>  #define X86EMUL_INTERCEPTED     6 /* Intercepted by nested VMCB/VMCS */
> +/* Vectroing can't be emulated */

Typo.  I think it's also worth elaborating a bit, e.g.

/* Emulation during event vectoring is unsupported */

> +#define X86EMUL_UNHANDLEABLE_VECTORING	7
>  
>  /* x86-specific emulation flags */
>  #define X86EMUL_F_WRITE			BIT(0)
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 7ce9cdb66f19..849a6fc364b3 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9107,6 +9107,11 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>  		if (r == X86EMUL_RETRY_INSTR || r == X86EMUL_PROPAGATE_FAULT)
>  			return 1;
>  
> +		if (r == X86EMUL_UNHANDLEABLE_VECTORING) {
> +			kvm_prepare_event_vectoring_exit(vcpu, cr2_or_gpa);
> +			return 0;
> +		}
> +
>  		WARN_ON_ONCE(r != X86EMUL_UNHANDLEABLE);
>  		return handle_emulation_failure(vcpu, emulation_type);
>  	}
> -- 
> 2.43.0
> 

