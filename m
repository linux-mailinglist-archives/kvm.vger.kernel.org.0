Return-Path: <kvm+bounces-2474-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 23D147F9832
	for <lists+kvm@lfdr.de>; Mon, 27 Nov 2023 05:20:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 44C66B20A1B
	for <lists+kvm@lfdr.de>; Mon, 27 Nov 2023 04:20:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB61953A2;
	Mon, 27 Nov 2023 04:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RQiaBOjy"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03A2612D
	for <kvm@vger.kernel.org>; Sun, 26 Nov 2023 20:20:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701058813;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ks9X9JJQQewYQA3Vvy8V5vKQxKc5V+DXnMwD9d5dJC0=;
	b=RQiaBOjyO/XL8owm+a7hrJbkhrfcbJn7MvzWXi9VsnbxHsWaQDVTlxrs2SaRZwHzk3Rv0I
	gv6d8z4/J9HW8iv2hSHZN3P2HUv2QXCHcu8bNfC6CpTSioNO+A2zq8L1JdWYnkFRpOoCZ1
	z1yR5lXDoUnhaK9OPJ3hIMhdvdiIv3o=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-501-BulHXvi9Mp6LISHjs1U01w-1; Sun, 26 Nov 2023 23:20:12 -0500
X-MC-Unique: BulHXvi9Mp6LISHjs1U01w-1
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-1cfb96854daso21530205ad.2
        for <kvm@vger.kernel.org>; Sun, 26 Nov 2023 20:20:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701058811; x=1701663611;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ks9X9JJQQewYQA3Vvy8V5vKQxKc5V+DXnMwD9d5dJC0=;
        b=hZE+q7ZOeVWKM47L5bZUQnCU2OzEU6LFER+TK5id/UfoPwbmFdqv6wQ28cUYsRe3OX
         KU+wE9AciNF24G0T8onvEkEQjJSD7UzUVJMxfIEymXfCpVwfQVNfOnhJjcWJPgwit2V+
         M1fR+0wiLDcenkyz1LJ+tVfbnGmo/d66XgxP9GWhitdxmBzhbv97VWRS1X3bWCzDu9X/
         kxfwRt9sNJBRO923lM400pVx4ivR9vFZPCHF6qrk5wAzKvVg8PnB+z4QAwBoCKrUcrq4
         +ZSup+Ahzn/Yu1y+kj0+a7O2kCG8KMEoi5qe8k3IkkMBglB0KzLMX1CUs4k/lS2Zy2/F
         K5HA==
X-Gm-Message-State: AOJu0Yxp+oQcg9GkNsdGXCNLIG2iehYnZ4Kry7GuxOJCFQEAanLkczMV
	KqnAs32Jd1NTuZCx9GNFuJcJJUbZEIl7PI06zf2NqpNiSNv2tygfKbjxYIp+7ThZPihtBSjjFBv
	GZr0QhmnxQ96M
X-Received: by 2002:a17:903:1ce:b0:1cf:c518:fa39 with SMTP id e14-20020a17090301ce00b001cfc518fa39mr3234383plh.19.1701058811230;
        Sun, 26 Nov 2023 20:20:11 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE9CSJyki0vMHQ9AIryxgQfnckmlDB/5/8+j7rX1uobM+7KIeXuvXQoSnSXnkPn/B6e4LTxKA==
X-Received: by 2002:a17:903:1ce:b0:1cf:c518:fa39 with SMTP id e14-20020a17090301ce00b001cfc518fa39mr3234375plh.19.1701058810943;
        Sun, 26 Nov 2023 20:20:10 -0800 (PST)
Received: from [192.168.68.51] ([43.252.115.3])
        by smtp.gmail.com with ESMTPSA id 2-20020a170902c14200b001c755810f89sm7146531plj.181.2023.11.26.20.20.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Nov 2023 20:20:10 -0800 (PST)
Message-ID: <802e9dcd-68d2-4c38-95e8-fe99d46b911f@redhat.com>
Date: Mon, 27 Nov 2023 15:20:06 +1100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH-for-9.0 08/16] target/arm/kvm: Have kvm_arm_pmu_init take
 a ARMCPU argument
Content-Language: en-US
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>, qemu-arm@nongnu.org,
 kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
References: <20231123183518.64569-1-philmd@linaro.org>
 <20231123183518.64569-9-philmd@linaro.org>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20231123183518.64569-9-philmd@linaro.org>
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
>   hw/arm/virt.c        | 2 +-
>   target/arm/kvm.c     | 6 +++---
>   3 files changed, 6 insertions(+), 6 deletions(-)
> 

One nit below, but I guess it doesn't matter.

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/target/arm/kvm_arm.h b/target/arm/kvm_arm.h
> index 0e12a008ab..fde1c45609 100644
> --- a/target/arm/kvm_arm.h
> +++ b/target/arm/kvm_arm.h
> @@ -200,8 +200,8 @@ int kvm_arm_get_max_vm_ipa_size(MachineState *ms, bool *fixed_ipa);
>   
>   int kvm_arm_vgic_probe(void);
>   
> +void kvm_arm_pmu_init(ARMCPU *cpu);
>   void kvm_arm_pmu_set_irq(CPUState *cs, int irq);
> -void kvm_arm_pmu_init(CPUState *cs);
>   

Why the order of the declaration is changed? I guess the reason would be
kvm_arm_pmu_init() is called prior to kvm_arm_pmu_set_irq().

>   /**
>    * kvm_arm_pvtime_init:
> @@ -263,7 +263,7 @@ static inline void kvm_arm_pmu_set_irq(CPUState *cs, int irq)
>       g_assert_not_reached();
>   }
>   
> -static inline void kvm_arm_pmu_init(CPUState *cs)
> +static inline void kvm_arm_pmu_init(ARMCPU *cpu)
>   {
>       g_assert_not_reached();
>   }
> diff --git a/hw/arm/virt.c b/hw/arm/virt.c
> index b6efe9da4d..63f3c0b750 100644
> --- a/hw/arm/virt.c
> +++ b/hw/arm/virt.c
> @@ -2000,7 +2000,7 @@ static void virt_cpu_post_init(VirtMachineState *vms, MemoryRegion *sysmem)
>                   if (kvm_irqchip_in_kernel()) {
>                       kvm_arm_pmu_set_irq(cpu, VIRTUAL_PMU_IRQ);
>                   }
> -                kvm_arm_pmu_init(cpu);
> +                kvm_arm_pmu_init(ARM_CPU(cpu));
>               }
>               if (steal_time) {
>                   kvm_arm_pvtime_init(ARM_CPU(cpu), pvtime_reg_base
> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
> index 82c5924ab5..e7cbe1ff05 100644
> --- a/target/arm/kvm.c
> +++ b/target/arm/kvm.c
> @@ -1711,17 +1711,17 @@ static bool kvm_arm_set_device_attr(ARMCPU *cpu, struct kvm_device_attr *attr,
>       return true;
>   }
>   
> -void kvm_arm_pmu_init(CPUState *cs)
> +void kvm_arm_pmu_init(ARMCPU *cpu)
>   {
>       struct kvm_device_attr attr = {
>           .group = KVM_ARM_VCPU_PMU_V3_CTRL,
>           .attr = KVM_ARM_VCPU_PMU_V3_INIT,
>       };
>   
> -    if (!ARM_CPU(cs)->has_pmu) {
> +    if (!cpu->has_pmu) {
>           return;
>       }
> -    if (!kvm_arm_set_device_attr(ARM_CPU(cs), &attr, "PMU")) {
> +    if (!kvm_arm_set_device_attr(cpu, &attr, "PMU")) {
>           error_report("failed to init PMU");
>           abort();
>       }

Thanks,
Gavin


