Return-Path: <kvm+bounces-42888-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A0BBA7F51B
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 08:39:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9B4E6172FA4
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 06:39:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A90E25F998;
	Tue,  8 Apr 2025 06:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cAvhgW3N"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBAF31FC0FC
	for <kvm@vger.kernel.org>; Tue,  8 Apr 2025 06:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744094358; cv=none; b=LuFu1PSXdj1IiuIiciNUDMZkxDp/CYdnHRE4W2+sDoP12g0cAhMyRlsJXv3axJwT+bdnDN0G++prKxYBxRk6UjpdqXXRMxuw+Qs/v/9xspZvkFk+92yp6JgmgiEEqRu08oRuHRD+IqHxVcFzA7Nkg7CMmkpq5mnCJTVIQr3JNk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744094358; c=relaxed/simple;
	bh=QImjOwZmHFIglPjEksFrg4C+14Ff/Y7CUPgguEl5tWI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RvXuNkvOjcD6MjA53thRTUBe1+OqOstrU4yQUOs2gUOkLsVySnNNjLc8mAzw3wAzo1qIZrFH6vQZYqCWoCilJWU82vY+Di6EfHuiJ7FtwrBGcexqhM7B0tUeDTP9pE5txkCv/apQnLQpsZQKoVLFhuDDUUF3lKCJy4dCfWMipgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cAvhgW3N; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744094354;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oo+vNBz6jEsiKjb63zXVQ6UhZa9LQg13RIyxKH2Wp2U=;
	b=cAvhgW3NPcK+I51CEnAIUQVzMhXbsaTT1HL5TIZHT3lFcHSdY1Vg5sdpfZ04/CgydnVZRL
	oMTY0dZAT8sJP5BmDhikpCzVlJ0qF2fk0ne3WfFjSQinyrnrYfwEcXwWCdls8wTk4YyQVs
	fye4YUetTUOOIm1ISkygo/MAOKFBL1c=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-36-aWJ5JKBYNzKYuBsIhOMg5g-1; Tue, 08 Apr 2025 02:39:13 -0400
X-MC-Unique: aWJ5JKBYNzKYuBsIhOMg5g-1
X-Mimecast-MFC-AGG-ID: aWJ5JKBYNzKYuBsIhOMg5g_1744094352
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-72f3b4c0305so6459314b3a.0
        for <kvm@vger.kernel.org>; Mon, 07 Apr 2025 23:39:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744094352; x=1744699152;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oo+vNBz6jEsiKjb63zXVQ6UhZa9LQg13RIyxKH2Wp2U=;
        b=XealvqKoDbYCIQk0N8XtPjq3wgMdTNIa3RuGdRaLdrnuo7JGoeU5/SXKkidzZrijq/
         g6bnsprNe+w2xuuyRlRVap33yxXkwoeAZokwYVjOjDUSxgLnqmaamu5oUKuWFP7ecYkS
         M7ZXdVwCrV+wwwtU+Fs09KMYiGcOWfvYvutrNa/H91BkVgT10z34mnZFrTI5Nz0ThVFf
         LXwmKuIMQy/cubj64oz9x2Vlcrr8fYKqBVAEAVTgFkOtabl3YB2R2UbNv58qXxMt4N61
         2lHr6pGil3SaC1t+7SlDYG6SYP9wp6Sl2zvmzzfD0Hcns/lyco+WZyIbzTRSoxjuaGpx
         fRVQ==
X-Forwarded-Encrypted: i=1; AJvYcCUh0/a+z9WKRulD6O1mMOVsHLle4fXRihFt7OhjrHuXzDrrzWgmOg9ibdobwXfwCmR7FY8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx2W3J7TA3DS1UtdlmAT5fMQQ1BdKtgGkkcw0wXz+lEF9JNDHvs
	tWBi5x6Lax+Xe1n5o+2JvTG1FdOOippPBccOLezWGSanDdlVL/qVGXcW9VKimBSnaJXQis6JfEg
	9BLcMMvZ79F9qvIU+2hj+yiLZnPPgj+VcgBmr0OY14wqD8Humwg==
X-Gm-Gg: ASbGncsJ9fVRIgFnQuvKj5mMxiDaN3br7Lzrux6yQ2Ldk4trEG6VFltPnfTItNRGePa
	8y46VW+cxWJBIcI10Vaa1cVDVU8kAOLNMNee4H/k2sJGX2HeCydPJNrS34hJ659X0aRceZxekIy
	zNFNCKP90hgqd8ObpZV1jGyx2HfNjVrALYTLE0xmTfsYDAQZ3GEQT3qruWwu5RkDnvvDKZzDCJH
	SciAL87XstSVC6q/59RtGBh1KPYVEVtjAqJc14x+hxT3zU4q2Hq/aE1fAC33o2VKKN3raRHyS8y
	PqjcnEB3ewet/7z4
X-Received: by 2002:a05:6a00:2393:b0:736:52d7:daca with SMTP id d2e1a72fcca58-73b6b8c3084mr14619991b3a.18.1744094352239;
        Mon, 07 Apr 2025 23:39:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHCluDWzP6aX2PyZk9at9nI1CqMZ/cLW37DfwKCDqyszydjKUwNSMY0//3epUtYWIjDAxF0tw==
X-Received: by 2002:a05:6a00:2393:b0:736:52d7:daca with SMTP id d2e1a72fcca58-73b6b8c3084mr14619954b3a.18.1744094351805;
        Mon, 07 Apr 2025 23:39:11 -0700 (PDT)
Received: from [192.168.68.55] ([180.233.125.65])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-739d9ea15d6sm9712319b3a.89.2025.04.07.23.39.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Apr 2025 23:39:11 -0700 (PDT)
Message-ID: <cda1db80-4b4d-471f-87f0-d978278a4b6c@redhat.com>
Date: Tue, 8 Apr 2025 16:39:02 +1000
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
 <c8af8a7f-5ee4-460b-aec4-959f688db628@redhat.com>
 <adbca476-7d0f-473d-a2a2-0a29a497dbca@arm.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <adbca476-7d0f-473d-a2a2-0a29a497dbca@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 4/8/25 2:35 AM, Steven Price wrote:
> On 04/03/2025 23:45, Gavin Shan wrote:
>> On 2/14/25 2:14 AM, Steven Price wrote:
>>> From: Jean-Philippe Brucker <jean-philippe@linaro.org>
>>>
>>> The RMM describes the maximum number of BPs/WPs available to the guest
>>> in the Feature Register 0. Propagate those numbers into ID_AA64DFR0_EL1,
>>> which is visible to userspace. A VMM needs this information in order to
>>> set up realm parameters.
>>>
>>> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
>>> Signed-off-by: Steven Price <steven.price@arm.com>
>>> ---
>>>    arch/arm64/include/asm/kvm_rme.h |  2 ++
>>>    arch/arm64/kvm/rme.c             | 22 ++++++++++++++++++++++
>>>    arch/arm64/kvm/sys_regs.c        |  2 +-
>>>    3 files changed, 25 insertions(+), 1 deletion(-)
>>>
>>
>> With the following one nitpick addressed:
>>
>> Reviewed-by: Gavin Shan <gshan@redhat.com>
>>
>>> diff --git a/arch/arm64/include/asm/kvm_rme.h b/arch/arm64/include/
>>> asm/kvm_rme.h
>>> index d684b30493f5..67ee38541a82 100644
>>> --- a/arch/arm64/include/asm/kvm_rme.h
>>> +++ b/arch/arm64/include/asm/kvm_rme.h
>>> @@ -85,6 +85,8 @@ void kvm_init_rme(void);
>>>    u32 kvm_realm_ipa_limit(void);
>>>    u32 kvm_realm_vgic_nr_lr(void);
>>>    +u64 kvm_realm_reset_id_aa64dfr0_el1(const struct kvm_vcpu *vcpu,
>>> u64 val);
>>> +
>>>    bool kvm_rme_supports_sve(void);
>>>      int kvm_realm_enable_cap(struct kvm *kvm, struct kvm_enable_cap
>>> *cap);
>>> diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
>>> index f83f34358832..8c426f575728 100644
>>> --- a/arch/arm64/kvm/rme.c
>>> +++ b/arch/arm64/kvm/rme.c
>>> @@ -87,6 +87,28 @@ u32 kvm_realm_vgic_nr_lr(void)
>>>        return u64_get_bits(rmm_feat_reg0,
>>> RMI_FEATURE_REGISTER_0_GICV3_NUM_LRS);
>>>    }
>>>    +u64 kvm_realm_reset_id_aa64dfr0_el1(const struct kvm_vcpu *vcpu,
>>> u64 val)
>>> +{
>>> +    u32 bps = u64_get_bits(rmm_feat_reg0,
>>> RMI_FEATURE_REGISTER_0_NUM_BPS);
>>> +    u32 wps = u64_get_bits(rmm_feat_reg0,
>>> RMI_FEATURE_REGISTER_0_NUM_WPS);
>>> +    u32 ctx_cmps;
>>> +
>>> +    if (!kvm_is_realm(vcpu->kvm))
>>> +        return val;
>>> +
>>> +    /* Ensure CTX_CMPs is still valid */
>>> +    ctx_cmps = FIELD_GET(ID_AA64DFR0_EL1_CTX_CMPs, val);
>>> +    ctx_cmps = min(bps, ctx_cmps);
>>> +
>>> +    val &= ~(ID_AA64DFR0_EL1_BRPs_MASK | ID_AA64DFR0_EL1_WRPs_MASK |
>>> +         ID_AA64DFR0_EL1_CTX_CMPs);
>>> +    val |= FIELD_PREP(ID_AA64DFR0_EL1_BRPs_MASK, bps) |
>>> +           FIELD_PREP(ID_AA64DFR0_EL1_WRPs_MASK, wps) |
>>> +           FIELD_PREP(ID_AA64DFR0_EL1_CTX_CMPs, ctx_cmps);
>>> +
>>> +    return val;
>>> +}
>>> +
>>
>> The chunk of code can be squeezed to
>> sys_reg.c::sanitise_id_aa64dfr0_el1() since
>> sys_reg.c has been plumbed for realm, no reason to keep a separate
>> helper in rme.c
>> because it's only called by sys_reg.c::sanitise_id_aa64dfr0_el1()
> 
> The issue here is the rmm_feat_reg0 variable - it's currently static in
> rme.c - so I can't just shift the code over. I could obviously provide
> helpers to get the necessary information but this seemed cleaner.
> 

Ack.

Thanks,
Gavin

> Thanks,
> Steve
> 
>>>    static int get_start_level(struct realm *realm)
>>>    {
>>>        return 4 - ((realm->ia_bits - 8) / (RMM_PAGE_SHIFT - 3));
>>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>>> index ed881725eb64..5618eff33155 100644
>>> --- a/arch/arm64/kvm/sys_regs.c
>>> +++ b/arch/arm64/kvm/sys_regs.c
>>> @@ -1820,7 +1820,7 @@ static u64 sanitise_id_aa64dfr0_el1(const struct
>>> kvm_vcpu *vcpu, u64 val)
>>>        /* Hide BRBE from guests */
>>>        val &= ~ID_AA64DFR0_EL1_BRBE_MASK;
>>>    -    return val;
>>> +    return kvm_realm_reset_id_aa64dfr0_el1(vcpu, val);
>>>    }
>>>      static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,



