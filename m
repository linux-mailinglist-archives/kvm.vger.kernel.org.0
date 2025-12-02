Return-Path: <kvm+bounces-65088-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 251ABC9AB5C
	for <lists+kvm@lfdr.de>; Tue, 02 Dec 2025 09:37:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id A8E3B4E3075
	for <lists+kvm@lfdr.de>; Tue,  2 Dec 2025 08:36:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CE3A305E37;
	Tue,  2 Dec 2025 08:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TBf7kZ3S"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC45A2580F2
	for <kvm@vger.kernel.org>; Tue,  2 Dec 2025 08:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764664596; cv=none; b=mXyJWFICEkVUYxfAxDk/Vzmvw5vHD1ZYPx76Q1ILFzXiI2GrJchaMogjX335NQ//zpM6gmwQZtOwafhxxZwfzT/gYzQKg9QzVvXnDciqmZhH1OCXzZNKTmpnk2XBTtYaZWI9WEdntAZp2NjVx4svgsaXZdO6BYykztoWgY4BE+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764664596; c=relaxed/simple;
	bh=Gz7vApITgIqPY132Zxq49IpiscM7OmK0CHhCAthSdJg=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=lyVGr6iZvNqy7oSRju2JhFWyAiCnFpW3nAQrJuARt+opSgLXJIw9lzkfy46ELqeeHJnLYrzJxf9B68CQ0ziyjVdqVwZ3YdscclSu67nGMGIaUX47wrMJXz4eDcYDw3IucGDHmPz2e873cTzziwXANGGuEliehAKZt2SRWw55Wao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TBf7kZ3S; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764664593;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GvfVo/tXrBwyrxovjX+VTgd/Lnc9aoy4HSw1ILNP5rA=;
	b=TBf7kZ3Spc4bgp6ovaLfAYdOqnedSp0o4jaXfSKILftDv/gbbSxIu0RkSnTvruzRuF6qDi
	ej8aSx3VfA4sdRmIlpDIpcnJ6v+veMqcSoOUAhA6kx1CzdZUgaublOaFcS6di6i++bW5jY
	s4FbxCjQNFOIT1eXAmWJy3UfMjw3fdM=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-384-Nqmbes8hMzSbJVzuPTnBFg-1; Tue, 02 Dec 2025 03:36:31 -0500
X-MC-Unique: Nqmbes8hMzSbJVzuPTnBFg-1
X-Mimecast-MFC-AGG-ID: Nqmbes8hMzSbJVzuPTnBFg_1764664591
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-4ed69f9ce96so162925321cf.3
        for <kvm@vger.kernel.org>; Tue, 02 Dec 2025 00:36:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764664591; x=1765269391;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:reply-to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GvfVo/tXrBwyrxovjX+VTgd/Lnc9aoy4HSw1ILNP5rA=;
        b=q7z9Yqlw21+bdZUluiQKm4gFs8EEzv552t4x4c4DYke/QzucMG8B3Thdw7d8LEqRNc
         DHoJjE7SgjJIIXKv0M0Buije4uSZOUhJ56HRp6VX03Ij7sXu+spPwlTZH7k68wDgjqIF
         mPgwItOmc+0og6VzTOuVn1VK2/dfKv2+uFJ0UzNjQXFNbp2E1InYJ72oIngZLXULzIU8
         s0aAhybJo1uHzi44Dd+HWNROI3Rs7GDqfRKkF3ialggK2kEu5BePU3CRuugSRQYY3pCr
         4xnpp0dzm5rZe57J0JGv9OkkGkXnPTYwaO3iCVLJ/FO1jKopeYNMT6lKaM8ptLtl0tJp
         OhWA==
X-Forwarded-Encrypted: i=1; AJvYcCVnjDxXNDZBAMjxwIUiMvmzsPYLCfmXFo0iSu8ra2gDwIYS4PbMpeiuGDCDLIbZ18nIYG0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxqKUI8KR3U5aJOT2sdzkFFv/9V2XYRO5+CRcF9u/T6tZ8z9rmx
	Y+TCMSKvE4wT1mJblyW0yYtik2spl5b8r02nzHsfZ2nvgm+E7eq+gRKAhCvIklPtrR+W4wU8dPF
	oF/NZLfFNq17Kubbs0y3b0BTDB4bcDtoKb1vtsn3FX+AVtxa3oHN0XTrciqFu0g==
X-Gm-Gg: ASbGncvwzPZdjv3IykvXOKH68DZ++nYDoCY9qflpS790nCVviZiU4JkLC113oYh8AAt
	iysB7wPbJ2XGtvGbd9HvP59Aq03WfNr8UL36r8lZ5bO76zieH0m/IuYEoWMX+8hArN+BA211K+L
	8RC0Kh8/2CWlhstYjdturgn2IeVyuw8xaC1H+GGn+g1WgqfWDOeBgrdsm4iuyp5w4PGJWcZ4+va
	8vdGddjdy4UlSFiNb4uCjlHGylnogamIe1I4g7Rf12KIAI8X0exDwyWg4VpDKd+K8+V2vPOQPXB
	JL0yntrswoRjSuBUcxDX29YksT7/NS8CBdVOjj6pi99VZg1sulMfoB7Ew+N1vKGJExq2gPm4t+1
	17PtK6rEhxnOs/XPOq5aD7TqugG+zTXl/Fj1mpFuK/Sa8Obhelv4gEdjdvw==
X-Received: by 2002:a05:622a:514:b0:4e8:a941:4b81 with SMTP id d75a77b69052e-4ee58a6c025mr625414181cf.32.1764664590776;
        Tue, 02 Dec 2025 00:36:30 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHIAnpUoT7sntSpUQUvxEen/nsZKDfNbEIvOfP9YAHn3QHjRKe70K7BiDefDj8DHnqBjrSyDw==
X-Received: by 2002:a05:622a:514:b0:4e8:a941:4b81 with SMTP id d75a77b69052e-4ee58a6c025mr625413971cf.32.1764664590357;
        Tue, 02 Dec 2025 00:36:30 -0800 (PST)
Received: from ?IPV6:2a01:e0a:fa3:e4b0:95dc:ab11:92db:6f9e? ([2a01:e0a:fa3:e4b0:95dc:ab11:92db:6f9e])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4efd345c34fsm90330451cf.35.2025.12.02.00.36.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Dec 2025 00:36:29 -0800 (PST)
Message-ID: <02742e7b-7f29-4960-b44c-51909a0e8c60@redhat.com>
Date: Tue, 2 Dec 2025 09:36:27 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Eric Auger <eric.auger@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v3 04/10] arm64: timer: use hypervisor
 timers when at EL2
Reply-To: eric.auger@redhat.com
To: Joey Gouly <joey.gouly@arm.com>, kvm@vger.kernel.org
Cc: alexandru.elisei@arm.com, andrew.jones@linux.dev, kvmarm@lists.linux.dev,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>
References: <20250925141958.468311-1-joey.gouly@arm.com>
 <20250925141958.468311-5-joey.gouly@arm.com>
Content-Language: en-US
In-Reply-To: <20250925141958.468311-5-joey.gouly@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 9/25/25 4:19 PM, Joey Gouly wrote:
> At EL2, with VHE:
>   CNT{P,V}_{TVAL,CTL}_EL0 is forwarded to CNTH{P,V}_{CVAL,TVAL,CTL}_EL0.
>
> Save the hypervisor physical and virtual timer IRQ numbers from the DT/ACPI.
>
> Signed-off-by: Joey Gouly <joey.gouly@arm.com>
> Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  arm/timer.c         | 10 ++++++++--
>  lib/acpi.h          |  2 ++
>  lib/arm/asm/timer.h | 11 +++++++++++
>  lib/arm/timer.c     | 19 +++++++++++++++++--
>  4 files changed, 38 insertions(+), 4 deletions(-)
>
> diff --git a/arm/timer.c b/arm/timer.c
> index 2cb80518..c6287ca7 100644
> --- a/arm/timer.c
> +++ b/arm/timer.c
> @@ -347,8 +347,14 @@ static void test_ptimer(void)
>  static void test_init(void)
>  {
>  	assert(TIMER_PTIMER_IRQ != -1 && TIMER_VTIMER_IRQ != -1);
nit: move above assert to 

if (current_level() == CurrentEL_EL1) block?

> -	ptimer_info.irq = TIMER_PTIMER_IRQ;
> -	vtimer_info.irq = TIMER_VTIMER_IRQ;
> +	if (current_level() == CurrentEL_EL1) {
> +		ptimer_info.irq = TIMER_PTIMER_IRQ;
> +		vtimer_info.irq = TIMER_VTIMER_IRQ;
> +	} else {
> +		assert(TIMER_HPTIMER_IRQ != -1 && TIMER_HVTIMER_IRQ != -1);
> +		ptimer_info.irq = TIMER_HPTIMER_IRQ;
> +		vtimer_info.irq = TIMER_HVTIMER_IRQ;
> +	}
>  
>  	install_exception_handler(EL1H_SYNC, ESR_EL1_EC_UNKNOWN, ptimer_unsupported_handler);
>  	ptimer_info.read_ctl();
> diff --git a/lib/acpi.h b/lib/acpi.h
> index c330c877..66e3062d 100644
> --- a/lib/acpi.h
> +++ b/lib/acpi.h
> @@ -290,6 +290,8 @@ struct acpi_table_gtdt {
>  	u64 counter_read_block_address;
>  	u32 platform_timer_count;
>  	u32 platform_timer_offset;
> +	u32 virtual_el2_timer_interrupt;
> +	u32 virtual_el2_timer_flags;
>  };
>  
>  /* Reset to default packing */
> diff --git a/lib/arm/asm/timer.h b/lib/arm/asm/timer.h
> index fd8f7796..0dcebc1c 100644
> --- a/lib/arm/asm/timer.h
> +++ b/lib/arm/asm/timer.h
> @@ -21,12 +21,23 @@ struct timer_state {
>  		u32 irq;
>  		u32 irq_flags;
>  	} vtimer;
> +	struct {
> +		u32 irq;
> +		u32 irq_flags;
> +	} hptimer;
> +	struct {
> +		u32 irq;
> +		u32 irq_flags;
> +	} hvtimer;
>  };
>  extern struct timer_state __timer_state;
>  
>  #define TIMER_PTIMER_IRQ (__timer_state.ptimer.irq)
>  #define TIMER_VTIMER_IRQ (__timer_state.vtimer.irq)
>  
> +#define TIMER_HPTIMER_IRQ (__timer_state.hptimer.irq)
> +#define TIMER_HVTIMER_IRQ (__timer_state.hvtimer.irq)
> +
>  void timer_save_state(void);
>  
>  #endif /* !__ASSEMBLER__ */
> diff --git a/lib/arm/timer.c b/lib/arm/timer.c
> index ae702e41..57f504e2 100644
> --- a/lib/arm/timer.c
> +++ b/lib/arm/timer.c
> @@ -38,10 +38,11 @@ static void timer_save_state_fdt(void)
>  	 *      secure timer irq
>  	 *      non-secure timer irq            (ptimer)
>  	 *      virtual timer irq               (vtimer)
> -	 *      hypervisor timer irq
> +	 *      hypervisor timer irq            (hptimer)
> +	 *      hypervisor virtual timer irq    (hvtimer)
>  	 */
>  	prop = fdt_get_property(fdt, node, "interrupts", &len);
> -	assert(prop && len == (4 * 3 * sizeof(u32)));
> +	assert(prop && len >= (4 * 3 * sizeof(u32)));
>  
>  	data = (u32 *) prop->data;
>  	assert(fdt32_to_cpu(data[3]) == 1 /* PPI */ );
> @@ -50,6 +51,14 @@ static void timer_save_state_fdt(void)
>  	assert(fdt32_to_cpu(data[6]) == 1 /* PPI */ );
>  	__timer_state.vtimer.irq = PPI(fdt32_to_cpu(data[7]));
>  	__timer_state.vtimer.irq_flags = fdt32_to_cpu(data[8]);
> +	if (len == (5 * 3 * sizeof(u32))) {
> +		assert(fdt32_to_cpu(data[9]) == 1 /* PPI */ );
> +		__timer_state.hptimer.irq = PPI(fdt32_to_cpu(data[10]));
> +		__timer_state.hptimer.irq_flags = fdt32_to_cpu(data[11]);
> +		assert(fdt32_to_cpu(data[12]) == 1 /* PPI */ );
> +		__timer_state.hvtimer.irq = PPI(fdt32_to_cpu(data[13]));
> +		__timer_state.hvtimer.irq_flags = fdt32_to_cpu(data[14]);
> +	}
>  }
>  
>  #ifdef CONFIG_EFI
> @@ -72,6 +81,12 @@ static void timer_save_state_acpi(void)
>  
>  	__timer_state.vtimer.irq = gtdt->virtual_timer_interrupt;
>  	__timer_state.vtimer.irq_flags = gtdt->virtual_timer_flags;
> +
> +	__timer_state.hptimer.irq = gtdt->non_secure_el2_interrupt;
> +	__timer_state.hptimer.irq_flags = gtdt->non_secure_el2_flags;
> +
> +	__timer_state.hvtimer.irq = gtdt->virtual_el2_timer_interrupt;
> +	__timer_state.hvtimer.irq_flags = gtdt->virtual_el2_timer_flags;
>  }
>  
>  #else
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric


