Return-Path: <kvm+bounces-40096-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B70C1A4F1BC
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 00:46:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D711816DDC9
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 23:46:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED1E8277021;
	Tue,  4 Mar 2025 23:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="D3lO9AcS"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E0CB1F3FC6
	for <kvm@vger.kernel.org>; Tue,  4 Mar 2025 23:45:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741131961; cv=none; b=RbUh5tL6BV4XdgmPG/lWZ5cR3xe6Yc7YpxG9RPTPkZY5Ik24G26W9cpDzE9NU9BCqvSHK9sAyrPDRVStRdp/OSSSmeTnVq5+Fp3AnoWQaIoK9Rm1VJ5i0GWW4tBmA1btDIasjqxqJ12P3VcYrI9U4cDVwzg3cZQII6ONKa7OlAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741131961; c=relaxed/simple;
	bh=Lef0MQKtiaqOzXYjRH2Nm9Cp4sRXRppVWKK2dDGvm/k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=R/32+3YAsb6nxbeuU1DcLD21f/eUvHni/ZwNGI101KTITgNAhQEPhpeQqX5K0SYKU11ul/LM2s1T9xDN4qKMJkBX+FF1XPkl4W5a3XlFengJwLmj5noUsLbOCq7/iGY5VPkYBuYlgBIQVo33U5dDUUsOKHDw7u7ji9o6jzkidJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=D3lO9AcS; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741131958;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OP9ovaiE8W931ELBVF5NuIIs9fylqFyNkVXudwtC3tg=;
	b=D3lO9AcShb87PGEn5D2HW5BRoGt6qeLURM8PqffIy9Yw92JFA6FFKLgSf30Kua0x1yCdqm
	ZlXzCCKsMbNiygrDvAfcZv03KxEWSSEMzcYhR1SAHUMA1idB8xIYzVEfKieuj5EYEfDJO7
	O5qpIsgjOdHRoSlDWs+b77mqR/r0xuQ=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-658-yAZKeG6tNTiRnHLaGeJYfw-1; Tue, 04 Mar 2025 18:45:52 -0500
X-MC-Unique: yAZKeG6tNTiRnHLaGeJYfw-1
X-Mimecast-MFC-AGG-ID: yAZKeG6tNTiRnHLaGeJYfw_1741131951
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-2feda472a6eso6648833a91.0
        for <kvm@vger.kernel.org>; Tue, 04 Mar 2025 15:45:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741131950; x=1741736750;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OP9ovaiE8W931ELBVF5NuIIs9fylqFyNkVXudwtC3tg=;
        b=NJNipIKjC9lNI1OBBUheAYJMUvOyDbgv27P41J0o44DkEZP+g3CHQKWL26DUT+pdkr
         MoP7F7gxbFlwzn8mm4ZUXGpn6HPKYa2T2oXghOwutPRAg6qktVeOFAHSUcwznKSBZlQK
         u++cyCd6Tphi/25VIleUg4OIerhmvg3EIw1GvaPtM+ESK7LlWa7ViLuRQ+zE9sP5jG+o
         ZXFzbFkfql4kCHG7kYP5Xlyx+JC2X19OFW5FOo9aoxBORWcgCJveHEkkZa8cgMUPcNPL
         /qMYrmojTG3dyEOfzwXe328oVG7wyWJHuSomnmCr/eXhTQsHML6ZB1kqYuqLUVJKBMNg
         lHcA==
X-Forwarded-Encrypted: i=1; AJvYcCUUicElQ5ZmFRJR0m1Zdwq/Oby4lbix51LLDZxxyvRq1gi34ZTi7NPM34zQIThU6gv0Fd8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw3r3jGNKREfGmMRwU/h3q3y4hy4eGS66ycR8E8zFtYdRfbVHZX
	P+olfQOAo4280sEabG5aQEhPjU8GkHc8ZjeQhzFGuHYK98LSdZ/rh14j/7ZloyDlI/2ehhmnAwW
	tz7Q+7+i3sdGoWHl1zhGOioQk44czJjCHDUojcp6XLZe7nNZqKIBT81cFaQ==
X-Gm-Gg: ASbGnctxnhKKD9nbPDX+80bPFLMns2VKs1936iXpFOTSW+0gomE+gjN9e3zrMB7OpHk
	+ejqepi1p6YbTYetP/lSUgLB9BHwXzYIhvfCLy8ukPBS5vNlj3JXVI4qj19RJ8VhP+/Skj5UUaD
	OPdlYieY0nkufS/C9kkIBmQ7BsLhb4Yze748P+ffDn6JU09IAWFUNwYW/owdq+2cdprgdEQ+GGm
	0KMxFbh2IZbi1k6VvYl5iVwYH1NngCN5/AFaJes1n0eEh0o6LxRFwJXmK+g/kqR70gW3QvQG8sf
	gapS8VLhitt8Av4=
X-Received: by 2002:a05:6a20:7345:b0:1ee:d6a7:e341 with SMTP id adf61e73a8af0-1f34952e7f5mr2027007637.30.1741131950427;
        Tue, 04 Mar 2025 15:45:50 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG6SHWUDr/wxtrgl8ODJO2LORkYE1xgQa8DpVJblqhw13356llhbnfpOxuEBTenhhAi0XuOnQ==
X-Received: by 2002:a05:6a20:7345:b0:1ee:d6a7:e341 with SMTP id adf61e73a8af0-1f34952e7f5mr2026963637.30.1741131950083;
        Tue, 04 Mar 2025 15:45:50 -0800 (PST)
Received: from [192.168.68.55] ([180.233.125.1])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-aee7de37fedsm9080597a12.42.2025.03.04.15.45.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Mar 2025 15:45:49 -0800 (PST)
Message-ID: <c8af8a7f-5ee4-460b-aec4-959f688db628@redhat.com>
Date: Wed, 5 Mar 2025 09:45:41 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 35/45] arm64: RME: Propagate number of breakpoints and
 watchpoints to userspace
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
References: <20250213161426.102987-1-steven.price@arm.com>
 <20250213161426.102987-36-steven.price@arm.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250213161426.102987-36-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/14/25 2:14 AM, Steven Price wrote:
> From: Jean-Philippe Brucker <jean-philippe@linaro.org>
> 
> The RMM describes the maximum number of BPs/WPs available to the guest
> in the Feature Register 0. Propagate those numbers into ID_AA64DFR0_EL1,
> which is visible to userspace. A VMM needs this information in order to
> set up realm parameters.
> 
> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>   arch/arm64/include/asm/kvm_rme.h |  2 ++
>   arch/arm64/kvm/rme.c             | 22 ++++++++++++++++++++++
>   arch/arm64/kvm/sys_regs.c        |  2 +-
>   3 files changed, 25 insertions(+), 1 deletion(-)
> 

With the following one nitpick addressed:

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/arch/arm64/include/asm/kvm_rme.h b/arch/arm64/include/asm/kvm_rme.h
> index d684b30493f5..67ee38541a82 100644
> --- a/arch/arm64/include/asm/kvm_rme.h
> +++ b/arch/arm64/include/asm/kvm_rme.h
> @@ -85,6 +85,8 @@ void kvm_init_rme(void);
>   u32 kvm_realm_ipa_limit(void);
>   u32 kvm_realm_vgic_nr_lr(void);
>   
> +u64 kvm_realm_reset_id_aa64dfr0_el1(const struct kvm_vcpu *vcpu, u64 val);
> +
>   bool kvm_rme_supports_sve(void);
>   
>   int kvm_realm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap);
> diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
> index f83f34358832..8c426f575728 100644
> --- a/arch/arm64/kvm/rme.c
> +++ b/arch/arm64/kvm/rme.c
> @@ -87,6 +87,28 @@ u32 kvm_realm_vgic_nr_lr(void)
>   	return u64_get_bits(rmm_feat_reg0, RMI_FEATURE_REGISTER_0_GICV3_NUM_LRS);
>   }
>   
> +u64 kvm_realm_reset_id_aa64dfr0_el1(const struct kvm_vcpu *vcpu, u64 val)
> +{
> +	u32 bps = u64_get_bits(rmm_feat_reg0, RMI_FEATURE_REGISTER_0_NUM_BPS);
> +	u32 wps = u64_get_bits(rmm_feat_reg0, RMI_FEATURE_REGISTER_0_NUM_WPS);
> +	u32 ctx_cmps;
> +
> +	if (!kvm_is_realm(vcpu->kvm))
> +		return val;
> +
> +	/* Ensure CTX_CMPs is still valid */
> +	ctx_cmps = FIELD_GET(ID_AA64DFR0_EL1_CTX_CMPs, val);
> +	ctx_cmps = min(bps, ctx_cmps);
> +
> +	val &= ~(ID_AA64DFR0_EL1_BRPs_MASK | ID_AA64DFR0_EL1_WRPs_MASK |
> +		 ID_AA64DFR0_EL1_CTX_CMPs);
> +	val |= FIELD_PREP(ID_AA64DFR0_EL1_BRPs_MASK, bps) |
> +	       FIELD_PREP(ID_AA64DFR0_EL1_WRPs_MASK, wps) |
> +	       FIELD_PREP(ID_AA64DFR0_EL1_CTX_CMPs, ctx_cmps);
> +
> +	return val;
> +}
> +

The chunk of code can be squeezed to sys_reg.c::sanitise_id_aa64dfr0_el1() since
sys_reg.c has been plumbed for realm, no reason to keep a separate helper in rme.c
because it's only called by sys_reg.c::sanitise_id_aa64dfr0_el1()

>   static int get_start_level(struct realm *realm)
>   {
>   	return 4 - ((realm->ia_bits - 8) / (RMM_PAGE_SHIFT - 3));
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index ed881725eb64..5618eff33155 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1820,7 +1820,7 @@ static u64 sanitise_id_aa64dfr0_el1(const struct kvm_vcpu *vcpu, u64 val)
>   	/* Hide BRBE from guests */
>   	val &= ~ID_AA64DFR0_EL1_BRBE_MASK;
>   
> -	return val;
> +	return kvm_realm_reset_id_aa64dfr0_el1(vcpu, val);
>   }
>   
>   static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,

Thanks,
Gavin


