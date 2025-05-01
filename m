Return-Path: <kvm+bounces-45022-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F2C9AA59FD
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 05:36:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AFFB79C1F58
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 03:36:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5867230BE9;
	Thu,  1 May 2025 03:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hh3NSZWe"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 870C71C07D9
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 03:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746070600; cv=none; b=hVYNR9+Emt1HR4N0OrEypG4gGr5KV85XdJvSbyYZwme6rxQa8eo17qHQx0lfAc/C2jn1hjKUZLf4BEDquHpoYKFoepBAh3mmse1TAR5DdKHeTYSqCfwDBR04AKX6Q84S1QMe8tp4J83NwykkxjeUNt4y1nQCDvV7xhjldPheD6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746070600; c=relaxed/simple;
	bh=jOUm0TGjHvVgOeTlX7WUSROohi02FDP2MJVQZDEyK9I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PFvOSoDRO3E5vjHpTuAuA81EuNiYoYkzUuol8Kct9gbV7IlajECw8UFVRI+rago7JJ7JDtfPEaj6/bOto5a53rdkmiyend1yv0CeSMliTC32f2vW2qHIwpnO7m5xOfUssqhODpy1DD6EcX2+LFQCFAnMdHqhnwJH5vHDx20B4YI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hh3NSZWe; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746070597;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WTFtgQvUStCLWm58c+Cl1OhMJYhsO+XdoCxoo3JcEgE=;
	b=hh3NSZWeqgNkRu/iigMceL4jlCztPgdd+M//tJf5YO/f2rL0o0EtZz9EY7rGqf1m7sPTvx
	CZn99X3FPggXflEpKxi5cHvN01q8QbMHS4DAzFAuC53UDdIJe5DhATntRmJGIa3PIrSjmG
	wdVCZ1lJkp9VowHiFBlXjanLCdoq44Y=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-326-ZLdzNc1NMMaG7HDtH052tw-1; Wed, 30 Apr 2025 23:36:35 -0400
X-MC-Unique: ZLdzNc1NMMaG7HDtH052tw-1
X-Mimecast-MFC-AGG-ID: ZLdzNc1NMMaG7HDtH052tw_1746070594
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-b00ce246e38so557920a12.2
        for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 20:36:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746070594; x=1746675394;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WTFtgQvUStCLWm58c+Cl1OhMJYhsO+XdoCxoo3JcEgE=;
        b=scVXqZxI2+nTHyPr1MSVP19GJpw+DQQZkgPOvAB7Ev3TCEMvsj/rwbHxbrLDTc27zc
         +yagJwGJYvHVU8aTpgIjRkpW+TIDllwGu95XSOm2ghh5ynvYnNTvsH1Ftcen6rYvfYeP
         Mww2plhqy3NczJkQNttC0v2WZRb2j4ZeOKVcK776kCLJzldjGkqiMvkuPTn/OAFK6SS5
         VIzY+sgu9ZBVktxcwm7J+Ql7PJIljN52fGP9LZm/2hJ8rn2RklJAdwbVPOzF+JSI7BwN
         ykFdKAjzng73cwJSZAoiKPcZkIm3S4aPY3KBO/mNmiGlULkamTvd2/dmY8mDFHZZLwrd
         /aaQ==
X-Forwarded-Encrypted: i=1; AJvYcCWbFsmIyyormJRaa5M5dGWVNltXQu/hSbmXeWebQF609SzOqkAmQM4n1Ltol6vc6cQJ5Z8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxBINFjZxj95Feofx8S4fTYLb/Z2GJgwzlodMTffi2CacO3Dsk8
	lqyjVpa3cDqYcGVMrnzIdrRMv7ea62nZr0v2dsCioKck3DHwmQxyvCSB0c5G7VO3u0RpswQmWvv
	W1N+9n+8sZz2uksMlE1g49k+xfw8VvgoY9xnCKm9r8JJeqoZ5Ig==
X-Gm-Gg: ASbGncuM6kERdz8a5780qqcmp/FQQA0oQexQy1JBGFC/bDJDllQTm2c+rjh7UbNbLm0
	5mkt1HM6oxvEvDxEZ/rVX/4x30Xgw36OY8nhP6vaIypaobb4+TUM58hGtcqKxyBlfF+lh6wRhku
	ehW5pnCrcRdQ7F9qsXrNc2tywe0L3dqVlpX9qOeTPecHzeojtM+EWiR/FEzoR3NLMrQKMInUw9f
	YuHfNqQvLqonxlXU3chnuzk3vk8wGqzwapvSStj4V8yWu8wQHHS/ujnpxX9tLVXnRleEtb7dt58
	X+WWRpaGVBEI
X-Received: by 2002:a17:902:f689:b0:21f:564:80a4 with SMTP id d9443c01a7336-22df5821f58mr76534775ad.33.1746070594067;
        Wed, 30 Apr 2025 20:36:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHRVQ709s9NlHNG/57ZQ0bX3xBINvQEcZ7cw6X19Wk71uY6m4FTQDBhudqbvsTzqwNROwGOtQ==
X-Received: by 2002:a17:902:f689:b0:21f:564:80a4 with SMTP id d9443c01a7336-22df5821f58mr76534535ad.33.1746070593712;
        Wed, 30 Apr 2025 20:36:33 -0700 (PDT)
Received: from [192.168.68.51] ([180.233.125.65])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22db5101636sm130469695ad.180.2025.04.30.20.36.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Apr 2025 20:36:33 -0700 (PDT)
Message-ID: <19ec5533-ee10-4670-a9fd-da1345a6946a@redhat.com>
Date: Thu, 1 May 2025 13:36:24 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 34/43] arm64: RME: Propagate number of breakpoints and
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
References: <20250416134208.383984-1-steven.price@arm.com>
 <20250416134208.383984-35-steven.price@arm.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250416134208.383984-35-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/16/25 11:41 PM, Steven Price wrote:
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

If I don't miss anything, it's not enough to apply the filter on reading and
resetting path where sanitise_id_aa64dfr0_el1() is called. id_aa64dfr0_el1
is writable and it's possible that QEMU modifies its value. Afterwards, the
register is read from guest kernel, which will be trapped to host and the
modified value is returned, without this filter applied. So I think the same
filter need to be applied to the write path originated from QEMU.

Thanks,
Gavin

> diff --git a/arch/arm64/include/asm/kvm_rme.h b/arch/arm64/include/asm/kvm_rme.h
> index f786fd978cf6..09cbb61816f3 100644
> --- a/arch/arm64/include/asm/kvm_rme.h
> +++ b/arch/arm64/include/asm/kvm_rme.h
> @@ -94,6 +94,8 @@ void kvm_init_rme(void);
>   u32 kvm_realm_ipa_limit(void);
>   u32 kvm_realm_vgic_nr_lr(void);
>   
> +u64 kvm_realm_reset_id_aa64dfr0_el1(const struct kvm_vcpu *vcpu, u64 val);
> +
>   bool kvm_rme_supports_sve(void);
>   
>   int kvm_realm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap);
> diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
> index 297b13ef1729..0c358ce0a7a1 100644
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
>   static int get_start_level(struct realm *realm)
>   {
>   	return 4 - ((realm->ia_bits - 8) / (RMM_PAGE_SHIFT - 3));
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index de7fe024dbff..36e22ed84e7e 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1844,7 +1844,7 @@ static u64 sanitise_id_aa64dfr0_el1(const struct kvm_vcpu *vcpu, u64 val)
>   	/* Hide BRBE from guests */
>   	val &= ~ID_AA64DFR0_EL1_BRBE_MASK;
>   
> -	return val;
> +	return kvm_realm_reset_id_aa64dfr0_el1(vcpu, val);
>   }
>   
>   static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,


