Return-Path: <kvm+bounces-37087-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B20F3A250C7
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 00:17:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 282871884F05
	for <lists+kvm@lfdr.de>; Sun,  2 Feb 2025 23:17:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12A8A214810;
	Sun,  2 Feb 2025 23:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="C4uZZKNS"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A0A91DDC1B
	for <kvm@vger.kernel.org>; Sun,  2 Feb 2025 23:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738538249; cv=none; b=P4ZA1Pm36YBlQ3f7U0pn+pWBKfRxgFBjpQM+SVCEe7E77ehX0+4nqBia4VRth6WT2ezP3nIEu3tdDlKejgN5wMP+H3mdIOOpHEB+U5bvAFHvQu044PwL4tLxV9JIxdvYfwRLUDu1fz4XMjsyxTw/ZdeYcJYQyetXWmvESgIwEGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738538249; c=relaxed/simple;
	bh=oWut+e6BjlnQ1t1a7UfTOn69NfRO8clBIxfqu43+0pQ=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=c6B1BSmXUkBw8i8DaKZunujDDx/Pk1UqdbHb2TlsS7p6UcCaBjgs6D6kOascx75KCwnIPHXdw8KGK+oN3+Nji5EXjI4UJOSNXrpeqBNvM/mdZv+EeAqTp63QUynjVEuxwwVtbE4DBLh3bUkeO/bx5KrPZQifHaUDKQjKmxsf7W0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=C4uZZKNS; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738538246;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hRA7lWgwDKj6UV5o7i7BX8BX6gq8Cn4M7Ftrg8fkVDM=;
	b=C4uZZKNSeBejYRD/NyKeKVNbNtjhgoiMyolvr2MtGoRtCLbB42/kAwepygO5P9pGOy8mON
	VjAg5v6+Yvl2hwZuW+c44PuRvE++3IYqTy6MB4IQbpS2AdRZRxhVqQqGH2mmBeEkEKT3nu
	FsGapwtGqBI3xavzT8N82491HaoC7Uc=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-22-ld-b1CTSMhWx5sAhXRpaMQ-1; Sun, 02 Feb 2025 18:17:25 -0500
X-MC-Unique: ld-b1CTSMhWx5sAhXRpaMQ-1
X-Mimecast-MFC-AGG-ID: ld-b1CTSMhWx5sAhXRpaMQ
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-2efa0eb9dacso7171896a91.1
        for <kvm@vger.kernel.org>; Sun, 02 Feb 2025 15:17:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738538244; x=1739143044;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hRA7lWgwDKj6UV5o7i7BX8BX6gq8Cn4M7Ftrg8fkVDM=;
        b=rYLnpZDraAe3YezXdxwOvvQOEOv+xcJl2k62v4SCupiXmnBHfUUMNIh922X2qPLDm3
         F9hof+MyYM2kHiHJVjR4F1yQYnePbLl9ZRjP9xJXXa+bCKdVloN9CyobYclkO9lIa0PI
         CKNHjt3pc24MUTKd2fxWPUSAYci0sHTil6EMrKnYtfc+p/LyKisspivJvLt7QErB4HJO
         znjsmOHZ9x1Qt72ax1J0GxmtgH99tduTBzPBCW/BEGZYAeuUfwJ4Ao1RYMKSaHJKwp1I
         52ExlBpK/i5tgA9x4wefyLAQi/8hBht9rprbqIWhn/FCKO8MWJqj1pFN6Qf/YJebVPaA
         dA8A==
X-Forwarded-Encrypted: i=1; AJvYcCX0n5LnJW5rVVx+6TtnmLE3y3bMealZ/WzXqKd9Um8AvrMjYDndRanGZz6XWWfODE6CUpk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwXiQxTkPYRE/hGp4jCT+MmGJ0LLqwsKdffP1DYD2U4GjN5q14p
	eDg8EDq/camx7ugJItFA/YhleiQP7ccRDfe9rM2cQY7rIlzSY7/VMqoRVVw0YcxJC9k703Gsy8Z
	QN1vUZH3w/1xw6AUph2UH3MGD2e1OaUhIocX8QXny4ciyiW1hNQ==
X-Gm-Gg: ASbGnctZOnICfMW0z59jAHTjpDxfXrU0G35y8ueOHHO2oCVPhF0Y1I67my+CEXdTGJ1
	0q3NOTb4Goo6nki10RJu1ZVpJ3Q5R80IAP+EzUb0VfOXpTle9gGG0WQrGRDqqegr1w6/30kVpU1
	k9TPVZPzY76cLVLWKSPyk7HtvCVeUyws5oUCMQqF9C4Iwn5DCeRG6giuelXHsPRoOJ5jOxLcbRu
	QHhZPxsXubOdTn7mX29716LgmkmoUp1YxHX4jsRuVGkh4YfTzQXMv6Qqz1MaXIxYbIILwlYYL1l
	9Cl76A==
X-Received: by 2002:a05:6a00:80a:b0:727:d55e:4be3 with SMTP id d2e1a72fcca58-72fd0beabb1mr27783708b3a.7.1738538244190;
        Sun, 02 Feb 2025 15:17:24 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEDd7NX+s9VmJsk4Gu/C5cdF+xO9wYV1JktzYhBU9uRWjBep69A7UQIF0gV3XEciNO6G3kkpg==
X-Received: by 2002:a05:6a00:80a:b0:727:d55e:4be3 with SMTP id d2e1a72fcca58-72fd0beabb1mr27783675b3a.7.1738538243767;
        Sun, 02 Feb 2025 15:17:23 -0800 (PST)
Received: from [192.168.68.55] ([180.233.125.64])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72fe6429a98sm7393173b3a.67.2025.02.02.15.17.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Feb 2025 15:17:23 -0800 (PST)
Message-ID: <e76aaa8f-b2cb-4b89-ab9c-6ca4cac8af9a@redhat.com>
Date: Mon, 3 Feb 2025 09:17:15 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 34/43] arm64: RME: Propagate number of breakpoints and
 watchpoints to userspace
From: Gavin Shan <gshan@redhat.com>
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
References: <20241212155610.76522-1-steven.price@arm.com>
 <20241212155610.76522-35-steven.price@arm.com>
 <34990c4f-b65e-4af2-8348-87ea078afc16@redhat.com>
Content-Language: en-US
In-Reply-To: <34990c4f-b65e-4af2-8348-87ea078afc16@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2/3/25 9:15 AM, Gavin Shan wrote:
> On 12/13/24 1:55 AM, Steven Price wrote:
>> From: Jean-Philippe Brucker <jean-philippe@linaro.org>
>>
>> The RMM describes the maximum number of BPs/WPs available to the guest
>> in the Feature Register 0. Propagate those numbers into ID_AA64DFR0_EL1,
>> which is visible to userspace. A VMM needs this information in order to
>> set up realm parameters.
>>
>> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>>   arch/arm64/include/asm/kvm_rme.h |  2 ++
>>   arch/arm64/kvm/rme.c             | 22 ++++++++++++++++++++++
>>   arch/arm64/kvm/sys_regs.c        |  2 +-
>>   3 files changed, 25 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm64/include/asm/kvm_rme.h b/arch/arm64/include/asm/kvm_rme.h
>> index 0d89ab1645c1..f8e37907e2d5 100644
>> --- a/arch/arm64/include/asm/kvm_rme.h
>> +++ b/arch/arm64/include/asm/kvm_rme.h
>> @@ -85,6 +85,8 @@ void kvm_init_rme(void);
>>   u32 kvm_realm_ipa_limit(void);
>>   u32 kvm_realm_vgic_nr_lr(void);
>> +u64 kvm_realm_reset_id_aa64dfr0_el1(const struct kvm_vcpu *vcpu, u64 val);
>> +
>>   bool kvm_rme_supports_sve(void);
>>   int kvm_realm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap);
>> diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
>> index e562e77c1f94..d21042d5ec9a 100644
>> --- a/arch/arm64/kvm/rme.c
>> +++ b/arch/arm64/kvm/rme.c
>> @@ -63,6 +63,28 @@ u32 kvm_realm_vgic_nr_lr(void)
>>       return u64_get_bits(rmm_feat_reg0, RMI_FEATURE_REGISTER_0_GICV3_NUM_LRS);
>>   }
>> +u64 kvm_realm_reset_id_aa64dfr0_el1(const struct kvm_vcpu *vcpu, u64 val)
>> +{
>> +    u32 bps = u64_get_bits(rmm_feat_reg0, RMI_FEATURE_REGISTER_0_NUM_BPS);
>> +    u32 wps = u64_get_bits(rmm_feat_reg0, RMI_FEATURE_REGISTER_0_NUM_WPS);
>> +    u32 ctx_cmps;
>> +
>> +    if (!kvm_is_realm(vcpu->kvm))
>> +        return val;
>> +
>> +    /* Ensure CTX_CMPs is still valid */
>> +    ctx_cmps = FIELD_GET(ID_AA64DFR0_EL1_CTX_CMPs, val);
>> +    ctx_cmps = min(bps, ctx_cmps);
>> +
>> +    val &= ~(ID_AA64DFR0_EL1_BRPs_MASK | ID_AA64DFR0_EL1_WRPs_MASK |
>> +         ID_AA64DFR0_EL1_CTX_CMPs);
>> +    val |= FIELD_PREP(ID_AA64DFR0_EL1_BRPs_MASK, bps) |
>> +           FIELD_PREP(ID_AA64DFR0_EL1_WRPs_MASK, wps) |
>> +           FIELD_PREP(ID_AA64DFR0_EL1_CTX_CMPs, ctx_cmps);
>> +
>> +    return val;
>> +}
>> +
> 
> The the filed ID_AA64DFR0_EL1_WRPs_MASK of the system register ID_AA64DFR0_EL1 is
> writtable, as declared in sys_reg.c. We need to consolidate the field when the
> system register is written.
> 
>          ID_FILTERED(ID_AA64DFR0_EL1, id_aa64dfr0_el1,
>                      ID_AA64DFR0_EL1_DoubleLock_MASK |
>                      ID_AA64DFR0_EL1_WRPs_MASK |
>                      ID_AA64DFR0_EL1_PMUVer_MASK |
>                      ID_AA64DFR0_EL1_DebugVer_MASK),
> 

Please ignore this comment. The consolidation when the system register is
written has been covered by PATCH[35/43].

>>   static int get_start_level(struct realm *realm)
>>   {
>>       return 4 - stage2_pgtable_levels(realm->ia_bits);
>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>> index a4713609e230..55cde43b36b9 100644
>> --- a/arch/arm64/kvm/sys_regs.c
>> +++ b/arch/arm64/kvm/sys_regs.c
>> @@ -1806,7 +1806,7 @@ static u64 sanitise_id_aa64dfr0_el1(const struct kvm_vcpu *vcpu, u64 val)
>>       /* Hide SPE from guests */
>>       val &= ~ID_AA64DFR0_EL1_PMSVer_MASK;
>> -    return val;
>> +    return kvm_realm_reset_id_aa64dfr0_el1(vcpu, val);
>>   }
>>   static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,

Thanks,
Gavin


