Return-Path: <kvm+bounces-28087-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C51DA993BBC
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2024 02:24:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 074BBB2465C
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2024 00:24:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DE74B660;
	Tue,  8 Oct 2024 00:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VP77yv90"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CBF333F6
	for <kvm@vger.kernel.org>; Tue,  8 Oct 2024 00:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728347059; cv=none; b=aPExr8cTroLYuQER5zWOd8oFF5UYR9wl0Mg7dtIh9odNsv41ShlUKEivHk3PjFoOJuX0lqDV4YqxkVyzBZmsaoiHFwlvgz/CpFvaem1HkY6TALulR5Tn7WcxpfQgLVUlAtnZ7SG/7AVIRfwOl9VA/NWHS0yZ4MkKYP227KEx4Dw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728347059; c=relaxed/simple;
	bh=KvWJnwVwl0NDrPnt2jed9aYpkeaKZIfqaGFr9K23u8k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=L0GFRabYttmzF7VQOnaNAXdFh1GdfqBP6hbAcI94JCsEHbURfox4OLHFkeQ+lg677xT5IgeLBGH5PgaO5KDgj7//kAe8MpD1SdMGQOGQ4Zy5UAhpO7+IaiR6fEWJPISbArN9Ra+3wCwAlwBnflhzTWa9vGdS/pXlgJKmOUYjORM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VP77yv90; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728347057;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0376WQc127XhNG695n+yocxmWIkuvVKsPdxkTLuIqys=;
	b=VP77yv90Es1zjM18RlEazYb6ISk47jdaIyU6d0FYr7ROnWZz2r8t2sCVxUZRLgn1zNtT5i
	pqoHmYEpAZr9Y2OP+jbOdOat04iuUcm8saf5rK2UyYGMbVakZZ22Vx6sGjbA0ix/1SpEZq
	f9UkE2/kafjhixcJM9oG2Nzs3B7a2JY=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-212-tuu3ouEPPJ2wsIwTXm-GSg-1; Mon, 07 Oct 2024 20:24:15 -0400
X-MC-Unique: tuu3ouEPPJ2wsIwTXm-GSg-1
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-207510f3242so65121535ad.0
        for <kvm@vger.kernel.org>; Mon, 07 Oct 2024 17:24:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728347053; x=1728951853;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0376WQc127XhNG695n+yocxmWIkuvVKsPdxkTLuIqys=;
        b=Hpso35p+Z9B3DuVN2Rpj0AvnxKWpQf7T7J9lVUMi3GZOIy6CXD+/E2j8TdVGSw5mdM
         FoPVnwZBUwNTasUAhZjrWrv2rOnEGRBEyWALQD++o6hsc7t0MN9r2TXq2BiUcp4nWfzG
         LCAtXUavXzZJKThuxKYcj6IsmvvpsDDdMfZXbkTHPKGqNxWYrQOAfVyZE6ORXdZi/iN5
         SlQHD6DpzCmmM/0DeUgh049vSaRPFci8vhGQzVIGZc23V/9Cth6nardiq6qo13HJx1YT
         vO7zVHWM6kkqKOLyvbiQNsO5OCQccypmBlnedYS4r+RFGb7lAiZMVOvLXjQ5Aj8H7klS
         5AAg==
X-Forwarded-Encrypted: i=1; AJvYcCWbhIW2QhrAvMbbk6TUf6gEJg5LoG/XKBgSt9B2oOeak6IGQ9IkTXngN6EwxJFFSJtmR6U=@vger.kernel.org
X-Gm-Message-State: AOJu0YwCzVoJwBVhkElvqb4OmbP+qJhqr6DFMozNcz8O8iv/8W2OFvSl
	Qm3EDa1HHKRCEw+mY9xYfKudbAArIrFDlm58Pn35LzYxvESjbOuvlufJx0kx8L4BdaFuiQGjo4c
	JW8O9+YUhgEbbZ2zqtZLdTRLf9Tv3r3ppQemcHVXFltELlynom3p5kuVQ1w==
X-Received: by 2002:a17:902:d504:b0:20b:861a:25d3 with SMTP id d9443c01a7336-20bfdfd9423mr232892275ad.21.1728347053585;
        Mon, 07 Oct 2024 17:24:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGmBrtcwDaxpRIh5M4VJUUsKgMzLr25X0QLxLVSlJzA+dyLr+IP/KpbXFMj9jVG7hvezGVaGA==
X-Received: by 2002:a17:902:d504:b0:20b:861a:25d3 with SMTP id d9443c01a7336-20bfdfd9423mr232891965ad.21.1728347053242;
        Mon, 07 Oct 2024 17:24:13 -0700 (PDT)
Received: from [192.168.68.54] ([103.210.27.132])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20c138afc71sm45326155ad.47.2024.10.07.17.24.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Oct 2024 17:24:12 -0700 (PDT)
Message-ID: <2b161369-b9b3-4103-9cf4-fa316dec0ca1@redhat.com>
Date: Tue, 8 Oct 2024 10:24:03 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 04/11] arm64: rsi: Add support for checking whether an
 MMIO is protected
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
References: <20241004144307.66199-1-steven.price@arm.com>
 <20241004144307.66199-5-steven.price@arm.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20241004144307.66199-5-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/5/24 12:42 AM, Steven Price wrote:
> From: Suzuki K Poulose <suzuki.poulose@arm.com>
> 
> On Arm CCA, with RMM-v1.0, all MMIO regions are shared. However, in
> the future, an Arm CCA-v1.0 compliant guest may be run in a lesser
> privileged partition in the Realm World (with Arm CCA-v1.1 Planes
> feature). In this case, some of the MMIO regions may be emulated
> by a higher privileged component in the Realm world, i.e, protected.
> 
> Thus the guest must decide today, whether a given MMIO region is shared
> vs Protected and create the stage1 mapping accordingly. On Arm CCA, this
> detection is based on the "IPA State" (RIPAS == RIPAS_IO). Provide a
> helper to run this check on a given range of MMIO.
> 
> Also, provide a arm64 helper which may be hooked in by other solutions.
> 
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> New patch for v5
> ---
>   arch/arm64/include/asm/io.h       |  8 ++++++++
>   arch/arm64/include/asm/rsi.h      |  2 ++
>   arch/arm64/include/asm/rsi_cmds.h | 21 +++++++++++++++++++++
>   arch/arm64/kernel/rsi.c           | 26 ++++++++++++++++++++++++++
>   4 files changed, 57 insertions(+)
> 

With the following nitpick addressed:

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/arch/arm64/include/asm/io.h b/arch/arm64/include/asm/io.h
> index 1ada23a6ec19..cce445ff8e3f 100644
> --- a/arch/arm64/include/asm/io.h
> +++ b/arch/arm64/include/asm/io.h
> @@ -17,6 +17,7 @@
>   #include <asm/early_ioremap.h>
>   #include <asm/alternative.h>
>   #include <asm/cpufeature.h>
> +#include <asm/rsi.h>
>   
>   /*
>    * Generic IO read/write.  These perform native-endian accesses.
> @@ -318,4 +319,11 @@ extern bool arch_memremap_can_ram_remap(resource_size_t offset, size_t size,
>   					unsigned long flags);
>   #define arch_memremap_can_ram_remap arch_memremap_can_ram_remap
>   
> +static inline bool arm64_is_mmio_private(phys_addr_t phys_addr, size_t size)
> +{
> +	if (unlikely(is_realm_world()))
> +		return arm64_is_protected_mmio(phys_addr, size);
> +	return false;
> +}
> +

The function names (arm64_is_{mmio_private, protected_mmio} are indicators to the
MMIO region's state or property. arm64_is_mmio_private() indicates the MMIO region
is 'private MMIO' while arm64_is_protected_mmio() indicates the MMIO region is
'protected MMIO'. They are equivalent and it may be worthy to unify the function
names (indicators) as below.

   option#1                         option#2
   --------                         --------
   arm64_is_private_mmio            arm64_is_protected_mmio
   __arm64_is_private_mmio          __arm64_is_protected_mmio


>   #endif	/* __ASM_IO_H */
> diff --git a/arch/arm64/include/asm/rsi.h b/arch/arm64/include/asm/rsi.h
> index acba065eb00e..42ff93c7b0ba 100644
> --- a/arch/arm64/include/asm/rsi.h
> +++ b/arch/arm64/include/asm/rsi.h
> @@ -14,6 +14,8 @@ DECLARE_STATIC_KEY_FALSE(rsi_present);
>   
>   void __init arm64_rsi_init(void);
>   
> +bool arm64_is_protected_mmio(phys_addr_t base, size_t size);
> +
>   static inline bool is_realm_world(void)
>   {
>   	return static_branch_unlikely(&rsi_present);
> diff --git a/arch/arm64/include/asm/rsi_cmds.h b/arch/arm64/include/asm/rsi_cmds.h
> index b661331c9204..fdb47f690307 100644
> --- a/arch/arm64/include/asm/rsi_cmds.h
> +++ b/arch/arm64/include/asm/rsi_cmds.h
> @@ -45,6 +45,27 @@ static inline unsigned long rsi_get_realm_config(struct realm_config *cfg)
>   	return res.a0;
>   }
>   
> +static inline unsigned long rsi_ipa_state_get(phys_addr_t start,
> +					      phys_addr_t end,
> +					      enum ripas *state,
> +					      phys_addr_t *top)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_smc(SMC_RSI_IPA_STATE_GET,
> +		      start, end, 0, 0, 0, 0, 0,
> +		      &res);
> +
> +	if (res.a0 == RSI_SUCCESS) {
> +		if (top)
> +			*top = res.a1;
> +		if (state)
> +			*state = res.a2;
> +	}
> +
> +	return res.a0;
> +}
> +
>   static inline unsigned long rsi_set_addr_range_state(phys_addr_t start,
>   						     phys_addr_t end,
>   						     enum ripas state,
> diff --git a/arch/arm64/kernel/rsi.c b/arch/arm64/kernel/rsi.c
> index a6495a64d9bb..d7bba4cee627 100644
> --- a/arch/arm64/kernel/rsi.c
> +++ b/arch/arm64/kernel/rsi.c
> @@ -66,6 +66,32 @@ static void __init arm64_rsi_setup_memory(void)
>   	}
>   }
>   
> +bool arm64_is_protected_mmio(phys_addr_t base, size_t size)
> +{
> +	enum ripas ripas;
> +	phys_addr_t end, top;
> +
> +	/* Overflow ? */
> +	if (WARN_ON(base + size <= base))
> +		return false;
> +
> +	end = ALIGN(base + size, RSI_GRANULE_SIZE);
> +	base = ALIGN_DOWN(base, RSI_GRANULE_SIZE);
> +
> +	while (base < end) {
> +		if (WARN_ON(rsi_ipa_state_get(base, end, &ripas, &top)))
> +			break;
> +		if (WARN_ON(top <= base))
> +			break;
> +		if (ripas != RSI_RIPAS_DEV)
> +			break;
> +		base = top;
> +	}
> +
> +	return base >= end;
> +}
> +EXPORT_SYMBOL(arm64_is_protected_mmio);
> +

The function may be worthy to be renamed to __arm64_is_private_mmio, as explained
as above.

>   void __init arm64_rsi_init(void)
>   {
>   	if (arm_smccc_1_1_get_conduit() != SMCCC_CONDUIT_SMC)

Thanks,
Gavin


