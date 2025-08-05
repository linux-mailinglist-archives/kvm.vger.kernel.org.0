Return-Path: <kvm+bounces-54053-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C6E2B1BB44
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 22:03:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A88AC6250C9
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 20:03:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E6D0293C6C;
	Tue,  5 Aug 2025 20:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="u9SO/eEx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02DF127057C
	for <kvm@vger.kernel.org>; Tue,  5 Aug 2025 20:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754424208; cv=none; b=TwMK41UxJMJBsWqzC4b0N99zIcaP/ewXU3RRZYigq7kvDXbE2DD+jl3SUiGQ7qPN7Ltn/TsXb2p6bRJIBcgVxLJ4gNnrzr9LhfNJrpfgFF9Py9ppA/otrgG7caVNQ/EudvODZL53TgDa2Ch8jmo7ojPEPWStiodcNcWSpSviC7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754424208; c=relaxed/simple;
	bh=t9lubqvRCDdJL2Q5MAv1WTxdnwNzuw++gqnncEDqxVo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jo5z0WFuhkVpsGUCqYEK6YSgkwcMNLOxDXnnyifu2NsJhX0TKmDDXD0QtYFQrZR/AgGuEKoJvV3ky0SfRuAgQF/M1aLn4ONqQ3JGah+4v47z56/KQeLcCVXpma1JcY5PICzY6AtcF3cI8MB84RPMQf04Lo7pH6M8Zs8HBkDANpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=u9SO/eEx; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3211b736a11so6397384a91.0
        for <kvm@vger.kernel.org>; Tue, 05 Aug 2025 13:03:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754424206; x=1755029006; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=D7jx0tyaD6Vdr2mi5iOvTnUZua+/EXN2bh91czkw13Y=;
        b=u9SO/eExe4/qFDt3CP74QxfCiayXyNFkAw/1zbrGlykfBwXxeLIio6uiRG49zNrx4J
         q1V45+wjTiKoei2U2rFGRJoq3jEfuyNFj88NEG/kT70LBouqpeDtFe28PvM5+QT7Iwt9
         Ll1oh4OjjD5YX8KoXUIIcXm3TBLW4wW/3fzYBAAPNh4r2PTStL++lGMYFx7d8v/Mx1Rm
         vC0iz+sPIgrHbnsfY41XiJopZtEBueHVlMzTBxNQB6YzitV5giIOE9OpmNgL+wIH0EaL
         1JyCktVIG+hYt4QjiR1Pvw4xeUxtL4hkK34mivTtFZ4b5+a5PXa0MSjk3+8xyJy630vA
         fJ+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754424206; x=1755029006;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=D7jx0tyaD6Vdr2mi5iOvTnUZua+/EXN2bh91czkw13Y=;
        b=J3Ioq2cMj2AvFU0yPYEnoYRQp38CL9XMis+NFO1zE77dP1z2Zt/5EQ1dhpecp2Bnhl
         paDURG+NEVZYNsJ1Beq+AO8qQpJynqMIFSOg6JHDIEFoH6ZOWQHZoUEtB5Pe7JdKcpMv
         v1NpQ46oV1m2peNE2mUyvpm2kgQQ1e1yrZX+2YVyUmD85vj677iE91nSNEJ46pM9TInK
         ROpcN+MDaUBS9vSBYTWU05u7JaLuv9e9bvZ70c07hkP0smvCrnZqnarvLxfYJAfvgk1x
         HGynXR5Hr/yIzhu4IkVQXpR4uxy9sGtzx1/v/jBrCkSqihfKqUKfDblyfrg9tDyCsh5l
         /r4A==
X-Forwarded-Encrypted: i=1; AJvYcCWiWeYz2xReyNA5zBqtGQlF7a1HLoRwFKCkPuC4GdquvcfwICAiJctmWGPaMsRAHLTOja8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyZE+bSh/Yy/BWGnOeDa1UAavtL8bC1qbL15c++C2k/uRM5e8Ml
	BDc/oDInBjGt7Vedf1cL1VJADU/AU2AYQ31LT11bqskr6YMjjlWE2swl/TgYLH1aqhz28imE+gB
	fKOCESA==
X-Google-Smtp-Source: AGHT+IHXM5RKSK3RkH1I+IVyqHTEUf2Pwm4ahMDemm23iR9RIleCaNhbJIQKnDeHprrnQWWugxW0b18JKQY=
X-Received: from pjqq16.prod.google.com ([2002:a17:90b:5850:b0:31c:2fe4:33bd])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2e50:b0:321:1680:d52a
 with SMTP id 98e67ed59e1d1-32166cfc926mr105241a91.34.1754424206346; Tue, 05
 Aug 2025 13:03:26 -0700 (PDT)
Date: Tue, 5 Aug 2025 13:03:24 -0700
In-Reply-To: <20250802001520.3142577-3-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250802001520.3142577-1-xin@zytor.com> <20250802001520.3142577-3-xin@zytor.com>
Message-ID: <aJJjjGWFL-Ju2Efw@google.com>
Subject: Re: [PATCH v2 2/4] KVM: VMX: Handle the immediate form of MSR instructions
From: Sean Christopherson <seanjc@google.com>
To: "Xin Li (Intel)" <xin@zytor.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, pbonzini@redhat.com, 
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	chao.gao@intel.com
Content-Type: text/plain; charset="us-ascii"

On Fri, Aug 01, 2025, Xin Li (Intel) wrote:
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index f19a76d3ca0e..c5d0082cf0a5 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -978,6 +978,7 @@ struct kvm_vcpu_arch {
>  	unsigned long guest_debug_dr7;
>  	u64 msr_platform_info;
>  	u64 msr_misc_features_enables;
> +	u32 cui_rdmsr_imm_reg;

This should be an "int", mostly because that's how KVM tracks it throughout the
various accessors, but also because it'd let us use "-1" for an "invalid" value,
e.g. if we ever want to add sanity checks to the completion callback (I don't
think that's worth doing).

> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index aa157fe5b7b3..c112595dfff9 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6003,6 +6003,23 @@ static int handle_notify(struct kvm_vcpu *vcpu)
>  	return 1;
>  }
>  
> +static int vmx_get_msr_imm_reg(void)

It's a bit silly, but I think it's worth passing in the @vcpu here.  E.g. if we
ever want to support caching the vmcs.VMX_INSTRUCTION_INFO.  And because it costs
literally nothing (barring a truly stupid compiler).

> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index a1c49bc681c4..fe12aae7089c 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1968,6 +1968,13 @@ static void complete_userspace_rdmsr(struct kvm_vcpu *vcpu)
>  	}
>  }
>  
> +static void complete_userspace_rdmsr_imm(struct kvm_vcpu *vcpu)

No need for this helper, the few lines can be open coded in complete_fast_rdmsr_imm().

> +{
> +	if (!vcpu->run->msr.error)
> +		kvm_register_write(vcpu, vcpu->arch.cui_rdmsr_imm_reg,
> +				   vcpu->run->msr.data);
> +}
> +

