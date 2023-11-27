Return-Path: <kvm+bounces-2468-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CA8417F9819
	for <lists+kvm@lfdr.de>; Mon, 27 Nov 2023 05:05:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C57B31C2083D
	for <lists+kvm@lfdr.de>; Mon, 27 Nov 2023 04:05:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E50C1525E;
	Mon, 27 Nov 2023 04:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AyrfaEgN"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D646312D
	for <kvm@vger.kernel.org>; Sun, 26 Nov 2023 20:05:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701057917;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hsPrLRr4JtnyZHwPvSCPAzP5Lsw6mGAeuHQscrepkcM=;
	b=AyrfaEgNzrjJbx2N6k7UWO3ozst3HbdUzJ5ZBWd4NNARN+47AvXMMrL2B/rfgWD0XQrJcl
	PXBPrW1Qz5tdudp5WBm1uoYdMfIVP5LPS/A3JBhcTV6bbzNcRcZh6iSnpYBrnviroTmSRi
	QljG2CVj0kTLewNMUoLGMmdXffqyw2o=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-205-5l2wIYIJPJKg8rXQRfKTTA-1; Sun, 26 Nov 2023 23:05:15 -0500
X-MC-Unique: 5l2wIYIJPJKg8rXQRfKTTA-1
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-1cfc2a7e382so13243785ad.0
        for <kvm@vger.kernel.org>; Sun, 26 Nov 2023 20:05:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701057914; x=1701662714;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hsPrLRr4JtnyZHwPvSCPAzP5Lsw6mGAeuHQscrepkcM=;
        b=NEtVvce4mXg+ANygoUGJp002DG6LolPX3iFrcG3FJ45/Opm5XIv7yQYh87dYABGiTp
         unU9TWOLNK7+1p/ecwF/o8nZCrMLdpFOYfgsoYqVDeM6Cs08fdaK6V2fKiBMfdGFxY0G
         jmcxe0gFsuwcHGk7Y8d2JA/Z9zVJ7AT6wOgp+30FPDMk/IgDZXX7z4BZZZ5siACdMwJw
         L+8kOpa12red+laSNAsuLHydV53OvqYjBaB06E/AeP8bLuyBW2LLCWVqjOFD5Dt9wWg3
         qsgYWvnTbYRwLY+NQfAeai4P2NMIyY+Z3LqRW8vAs9D9OgdejZGAqwxMC6hWl20kIbPf
         NMVA==
X-Gm-Message-State: AOJu0YzNzaPpN1TJ954pYqPwWiWPCp45UV+HyRmGZYkl3SBfds0c+cDl
	fo9LwlooluzWLBDSqo1/qq7+bM1atmyIS4cZQET98dHoWLL3Ugh5dXyLGGwXzF/UurYspohCeg3
	DweJ/GE8k/D/E
X-Received: by 2002:a17:902:c40d:b0:1cf:59ad:9637 with SMTP id k13-20020a170902c40d00b001cf59ad9637mr20268648plk.22.1701057914668;
        Sun, 26 Nov 2023 20:05:14 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHE7fQJkDMi7BdyUV6ds2GyN5xdLkRIecybDLxFrZYXlc1bSaJ0J5/yXn6LKfFnuQCG1vx95Q==
X-Received: by 2002:a17:902:c40d:b0:1cf:59ad:9637 with SMTP id k13-20020a170902c40d00b001cf59ad9637mr20268627plk.22.1701057914327;
        Sun, 26 Nov 2023 20:05:14 -0800 (PST)
Received: from [192.168.68.51] ([43.252.115.3])
        by smtp.gmail.com with ESMTPSA id c1-20020a170902d48100b001c9c8d761a3sm7102998plg.131.2023.11.26.20.05.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Nov 2023 20:05:14 -0800 (PST)
Message-ID: <52cf8040-b134-4dc6-b6ce-1d51a3dc13ef@redhat.com>
Date: Mon, 27 Nov 2023 15:05:09 +1100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH-for-9.0 03/16] target/arm/kvm: Have
 kvm_arm_add_vcpu_properties take a ARMCPU argument
Content-Language: en-US
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>, qemu-arm@nongnu.org,
 kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
References: <20231123183518.64569-1-philmd@linaro.org>
 <20231123183518.64569-4-philmd@linaro.org>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20231123183518.64569-4-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Phil,

On 11/24/23 05:35, Philippe Mathieu-Daudé wrote:
> Unify the "kvm_arm.h" API: All functions related to ARM vCPUs
> take a ARMCPU* argument. Use the CPU() QOM cast macro When
> calling the generic vCPU API from "sysemu/kvm.h".
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>   target/arm/kvm_arm.h | 4 ++--
>   target/arm/cpu.c     | 2 +-
>   target/arm/kvm.c     | 4 ++--
>   3 files changed, 5 insertions(+), 5 deletions(-)
> 

With the following comments resolved:

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/target/arm/kvm_arm.h b/target/arm/kvm_arm.h
> index 50967f4ae9..6fb8a5f67e 100644
> --- a/target/arm/kvm_arm.h
> +++ b/target/arm/kvm_arm.h
> @@ -153,7 +153,7 @@ void kvm_arm_set_cpu_features_from_host(ARMCPU *cpu);
>    * Add all KVM specific CPU properties to the CPU object. These
>    * are the CPU properties with "kvm-" prefixed names.
>    */
> -void kvm_arm_add_vcpu_properties(Object *obj);
> +void kvm_arm_add_vcpu_properties(ARMCPU *cpu);
>   

The function's description needs to be modified since @obj has been
renamed to @cpu?

   /**
    * kvm_arm_add_vcpu_properties:
    * @obj: The CPU object to add the properties to
    *
    */

>   /**
>    * kvm_arm_steal_time_finalize:
> @@ -243,7 +243,7 @@ static inline void kvm_arm_set_cpu_features_from_host(ARMCPU *cpu)
>       g_assert_not_reached();
>   }
>   
> -static inline void kvm_arm_add_vcpu_properties(Object *obj)
> +static inline void kvm_arm_add_vcpu_properties(ARMCPU *cpu)
>   {
>       g_assert_not_reached();
>   }
> diff --git a/target/arm/cpu.c b/target/arm/cpu.c
> index 25e9d2ae7b..97081e0c70 100644
> --- a/target/arm/cpu.c
> +++ b/target/arm/cpu.c
> @@ -1686,7 +1686,7 @@ void arm_cpu_post_init(Object *obj)
>       }
>   
>       if (kvm_enabled()) {
> -        kvm_arm_add_vcpu_properties(obj);
> +        kvm_arm_add_vcpu_properties(cpu);
>       }
>   
>   #ifndef CONFIG_USER_ONLY
> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
> index 6e3fea1879..03195f5627 100644
> --- a/target/arm/kvm.c
> +++ b/target/arm/kvm.c
> @@ -495,10 +495,10 @@ static void kvm_steal_time_set(Object *obj, bool value, Error **errp)
>   }
>   
>   /* KVM VCPU properties should be prefixed with "kvm-". */
> -void kvm_arm_add_vcpu_properties(Object *obj)
> +void kvm_arm_add_vcpu_properties(ARMCPU *cpu)
>   {
> -    ARMCPU *cpu = ARM_CPU(obj);
>       CPUARMState *env = &cpu->env;
> +    Object *obj = OBJECT(cpu);
>   
>       if (arm_feature(env, ARM_FEATURE_GENERIC_TIMER)) {
>           cpu->kvm_adjvtime = true;

Thanks,
Gavin


