Return-Path: <kvm+bounces-37074-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 449D5A24C6D
	for <lists+kvm@lfdr.de>; Sun,  2 Feb 2025 02:23:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 02AE53A51F5
	for <lists+kvm@lfdr.de>; Sun,  2 Feb 2025 01:23:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 447D812E4A;
	Sun,  2 Feb 2025 01:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FSj11SR+"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC4DCB665
	for <kvm@vger.kernel.org>; Sun,  2 Feb 2025 01:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738459394; cv=none; b=T39woSE7Wl7bqpMwR2dKElH5nEKS8Y3+tYuCX+PEVw868etyp9a1yRzRRYoH0kZF+23aaLfBkBJXCtV6mZbZ1wxhoZn+3VBv+4q3Y5H9NWIXby4OfL3stQPVqFLuRp3kFkDkLEPVbx46T8TUxQDtNT4xTy4Pw5U6Pnd+1hIn/uU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738459394; c=relaxed/simple;
	bh=laaJN879foDpMaPWrRy6D9kpMKcmzC5+VrbzCSXuhpE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=O2FNLZpP+lAChLQFPvJCeSCq9D4js1Mn7vEGej19o2sZ8HAByPtoiP62tLPMIE+vAPGV56HcfGDoAu5jffIRVWk7IrDVtXKEZO7S5cnQZIvk8GlFxgjS83YyAygFvh7ZQ1WzOVxx89ULXEF1+5gBNIXtVn6Y7BHe0hJ7AZXVBa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FSj11SR+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738459391;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YAAI3E0WlUEH8QGHAO5vUmuOkyQG4sKUrRj2kW9NJz0=;
	b=FSj11SR+lGjmnG5VYaPgLqvBnlIhHUQoLJeP2PrwdHxT6z4FBWRLiM7efIQjuEX9AnkByh
	ygFYv9JnE7Pm/Ve9InkqZPJT/TrgatlYVMkN8Qk6p8Aum00q2iZ1mZFTQ/6vGfqfrluQYC
	Cyvs4pZUQS8lvVrE6xJL3dfyCZk097U=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-133-yMkj27wvPpaZ-ad5UrlyCQ-1; Sat, 01 Feb 2025 20:23:10 -0500
X-MC-Unique: yMkj27wvPpaZ-ad5UrlyCQ-1
X-Mimecast-MFC-AGG-ID: yMkj27wvPpaZ-ad5UrlyCQ
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-2ee9f66cb12so6414333a91.1
        for <kvm@vger.kernel.org>; Sat, 01 Feb 2025 17:23:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738459388; x=1739064188;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YAAI3E0WlUEH8QGHAO5vUmuOkyQG4sKUrRj2kW9NJz0=;
        b=kDlalSdFmZTH0H3VCAneK3J2zLui0Fb1vUrX3XvHLtRqZpHiyk+zA6jOWBeD+YvUoH
         MluVLqp6AkDIPtIdKUM43G2WXfY94f0U6bKalp39APZuvDCUW4C1hRKWgQn7KffJDoKy
         2sUq4tMhjvDBGlTBTGBU3uNzAxZlUN7h14DcqpoQkuXqMORfE+e4B4E1Zlegduvl0G4r
         cbfZYJmlk3qr6d8uXStdnSEXVyiS67SRd4S97DEkkK7oSEFb9dZHfv2OHir8/gH6s1+q
         bxKFoiRDSHRhu7l8HaeQ0dMqViBpvA0KQ9G+5VBJOFZopTwRttvCfoadSz84mCHHReHg
         d8BQ==
X-Forwarded-Encrypted: i=1; AJvYcCVyeVjfCduUnCreAswEBb/BxzAiqruOJ7pcq90Bz6A0No6vgHOH8bHIhTfxRs7I01EDJRU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxbMGQQlAznWklwLmH9V3ZNdSzRpY7gYWsMKmaYIMYvmaDlZJwf
	BXzDG1koRQ6ujvwDvzLprEq4dqa1ff5XHdx98rAQVlhzF1bOMACQCm+QS1bnRWioc29yiN3aRT9
	Ma8BM4QIxO0+evqMOl9BvH1jMdvexpnk6tkCYBM+cQgJCxdLOUzRNCUIUAA==
X-Gm-Gg: ASbGncsMrse1M4UKLHXeH06c8xt0VrH9lQRadSxWXkSFR2m0zT3H90XJ0stnoBvH+VT
	Ih2USC/43FnGXYL7BFXgnzbk4hJUX3nGwIpVE4wEsmwhALcdlEWcvr08F7SkW3E1aTrzFI4xE29
	drVmSOLNkJjQH6oS8hAZJ4ki7NZr6bOtmeDekdTvAzxipfaM4QoedjFar9ikaSpDLPFY8Wy8YcA
	+i9JMDrF9Adc8329xDz0spx/+X8Olr4I60eGDPfSIHc39JsWo3I/UBwprGKy2aWEZ4oOvj8lEcv
	2uk5JQ==
X-Received: by 2002:a05:6a00:a84:b0:725:e405:6df7 with SMTP id d2e1a72fcca58-72fd0bf50d0mr22072032b3a.10.1738459388633;
        Sat, 01 Feb 2025 17:23:08 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF+rGTDJTNwVR5Fk0Ockt+Y4TXvcEQynR1IiX2sbu3+KwKdR5uE+ZGwPGUav29lR64slwel7g==
X-Received: by 2002:a05:6a00:a84:b0:725:e405:6df7 with SMTP id d2e1a72fcca58-72fd0bf50d0mr22072011b3a.10.1738459388254;
        Sat, 01 Feb 2025 17:23:08 -0800 (PST)
Received: from [192.168.68.55] ([180.233.125.64])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72fe631be3csm5660892b3a.7.2025.02.01.17.23.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 01 Feb 2025 17:23:07 -0800 (PST)
Message-ID: <09f42dc3-9c43-49ef-b4eb-8aeab387f0fd@redhat.com>
Date: Sun, 2 Feb 2025 11:22:58 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 22/43] KVM: arm64: Validate register access for a Realm
 VM
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
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
 <20241212155610.76522-23-steven.price@arm.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20241212155610.76522-23-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/13/24 1:55 AM, Steven Price wrote:
> The RMM only allows setting the GPRS (x0-x30) and PC for a realm
> guest. Check this in kvm_arm_set_reg() so that the VMM can receive a
> suitable error return if other registers are accessed.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v5:
>   * Upper GPRS can be set as part of a HOST_CALL return, so fix up the
>     test to allow them.
> ---
>   arch/arm64/kvm/guest.c | 43 ++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 43 insertions(+)
> 
> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> index 12dad841f2a5..1ee2fe072f1a 100644
> --- a/arch/arm64/kvm/guest.c
> +++ b/arch/arm64/kvm/guest.c
> @@ -73,6 +73,24 @@ static u64 core_reg_offset_from_id(u64 id)
>   	return id & ~(KVM_REG_ARCH_MASK | KVM_REG_SIZE_MASK | KVM_REG_ARM_CORE);
>   }
>   
> +static bool kvm_realm_validate_core_reg(u64 off)
> +{
> +	/*
> +	 * Note that GPRs can only sometimes be controlled by the VMM.
> +	 * For PSCI only X0-X6 are used, higher registers are ignored (restored
> +	 * from the REC).
> +	 * For HOST_CALL all of X0-X30 are copied to the RsiHostCall structure.
> +	 * For emulated MMIO X0 is always used.
> +	 */
> +	switch (off) {
> +	case KVM_REG_ARM_CORE_REG(regs.regs[0]) ...
> +	     KVM_REG_ARM_CORE_REG(regs.regs[30]):
> +	case KVM_REG_ARM_CORE_REG(regs.pc):
> +		return true;
> +	}
> +	return false;
> +}
> +
>   static int core_reg_size_from_offset(const struct kvm_vcpu *vcpu, u64 off)
>   {
>   	int size;
> @@ -115,6 +133,9 @@ static int core_reg_size_from_offset(const struct kvm_vcpu *vcpu, u64 off)
>   	if (vcpu_has_sve(vcpu) && core_reg_offset_is_vreg(off))
>   		return -EINVAL;
>   
> +	if (kvm_is_realm(vcpu->kvm) && !kvm_realm_validate_core_reg(off))
> +		return -EPERM;
> +
>   	return size;
>   }
>   
> @@ -783,12 +804,34 @@ int kvm_arm_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>   	return kvm_arm_sys_reg_get_reg(vcpu, reg);
>   }
>   
> +/*
> + * The RMI ABI only enables setting some GPRs and PC. The selection of GPRs
> + * that are available depends on the Realm state and the reason for the last
> + * exit.  All other registers are reset to architectural or otherwise defined
> + * reset values by the RMM, except for a few configuration fields that
> + * correspond to Realm parameters.
> + */
> +static bool validate_realm_set_reg(struct kvm_vcpu *vcpu,
> +				   const struct kvm_one_reg *reg)
> +{
> +	if ((reg->id & KVM_REG_ARM_COPROC_MASK) == KVM_REG_ARM_CORE) {
> +		u64 off = core_reg_offset_from_id(reg->id);
> +
> +		return kvm_realm_validate_core_reg(off);
> +	}
> +
> +	return false;
> +}
> +
>   int kvm_arm_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>   {
>   	/* We currently use nothing arch-specific in upper 32 bits */
>   	if ((reg->id & ~KVM_REG_SIZE_MASK) >> 32 != KVM_REG_ARM64 >> 32)
>   		return -EINVAL;
>   
> +	if (kvm_is_realm(vcpu->kvm) && !validate_realm_set_reg(vcpu, reg))
> +		return -EINVAL;
> +
>   	switch (reg->id & KVM_REG_ARM_COPROC_MASK) {
>   	case KVM_REG_ARM_CORE:	return set_core_reg(vcpu, reg);
>   	case KVM_REG_ARM_FW:

It looks the core registers in kvm_arm_set_reg() has been validated for twice.

   ioctl(KVM_SET_ONE_REG)
     kvm_arm_set_reg
       validate_realm_set_reg
         kvm_realm_validate_core_reg        // 1
       set_core_reg
         core_reg_offset_from_id
         core_reg_addr
           core_reg_offset_from_id
           core_reg_size_from_offset
             kvm_realm_validate_core_reg    // 2
         copy_from_user

Besides, there are other types of registers that can be accessed by KVM_{GET, SET}_ONE_REG:
firmware and bitmap registers, SVE registers, timer registers, system registers. Need we
to hide any of them from the user space? As I can understand, the SVE registers are owned
by RMM at least and won't be exposed to user space.

Thanks,
Gavin



