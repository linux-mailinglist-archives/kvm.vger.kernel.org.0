Return-Path: <kvm+bounces-45182-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B919BAA6779
	for <lists+kvm@lfdr.de>; Fri,  2 May 2025 01:32:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 273267B4969
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 23:30:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A0ED26D4C9;
	Thu,  1 May 2025 23:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CUNTGs3r"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4874266563
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 23:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746142257; cv=none; b=UJsjhDve+POUQnwb3bd75w2k6ma2ERPKsAmV3JE6f4K6undt/ok2uzQP3iL7Gyaxe1DLq9JK3JePGVqsTFytar/zuPvL+xuGvjz35XVJSPY/6penCzHfq/qITBOlc0MZNffIFV54hj0bDEJHAeBxpV2PBvoBCya2nsrOGP4Kja0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746142257; c=relaxed/simple;
	bh=xVGEn53VMIadoPNtpTXYP9w2q/1FWFt4j5ySM3+Il+k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=p/40ihSnYgZR5zFzEbgv8Pn7DkrRrjeyU9RuzM6j5MH4mwZR7SGZc9BCCFWu1Gh0DlGAsin1ophDjm7YhlQD9ogXuhOKhgAdCb7TTdymwULeyH4kICqBU3JvmX9iP1/lQ+ciEaqNqluA7OFhD6tEYJ4CQ3Ih51NWt2sf2+aDS6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CUNTGs3r; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746142254;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=V61xkxPc38oYjgZEUT4lB2Jdszj4oz3OEIRZu6N5HPs=;
	b=CUNTGs3r4VrwR//lImqk2Lgrr+aIoFJduIe8NWCd2Ml1yplw519Ubqu+2Y8Y632c84BsGJ
	ZvK+p3nxNh4f4/sHpOMfjjk5SA2PwVMqILkChy+O83t2IUL3Lr+JRW7xIYyk7e5WtZKmtH
	B70O31qY+YMSdzCdB8t1q8qtmVUvLbE=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-517-dkWYkqFVM7qqbEj5mVIQcg-1; Thu, 01 May 2025 19:30:53 -0400
X-MC-Unique: dkWYkqFVM7qqbEj5mVIQcg-1
X-Mimecast-MFC-AGG-ID: dkWYkqFVM7qqbEj5mVIQcg_1746142252
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-af8d8e0689eso1577729a12.2
        for <kvm@vger.kernel.org>; Thu, 01 May 2025 16:30:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746142252; x=1746747052;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=V61xkxPc38oYjgZEUT4lB2Jdszj4oz3OEIRZu6N5HPs=;
        b=C3nLOvIyzfvGIXA0q4RvbMvgaHmBjK/FOsJR4/vAhCnMRsgKooNX0c3X/DyqxO3QzO
         xEInVgI1rZnubN8HP1SDy4faPH8vzIz6aJBWolnoy3RhnfpI8sM4gEaIGsDu6KntuxWg
         AtWmOoJ/k1M2Sr9SzelhWfAK03Wx0YxiKUtPF/MARO1SGXOpHRYd3teplnUiL9C1kmUx
         vwMJ0djw7qGpMp8BUA6NkHRjXSc0Cqf9rjZCpcOxrbUVmEvh2Tkknf6Dzn7NQ3a7D9fs
         H+x1lBfvj652N8imGUS/v7yJseYbgOumMqDberjP0EgafbaCdqobdoBr0anBRZhswg0O
         u84g==
X-Forwarded-Encrypted: i=1; AJvYcCWlKeQ7jt/EbWSk41MXC1Yq+EfWSccabBK3Hanhr7TwBtKdQTFI8DA7eGPayC6Wz0Iv+0Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YxT5kdR2lH02iyVNiItoeUy48o0BXl++r0TJR1+PZ2FOuuW87aO
	u2CR4xYl0Uq6yznnzwKHoNrCAMroBWKNRLHmC5XZeV3tK8QLkqe5jE3hkI0NKkcxxgxGsjjs+MI
	eIn8NzB2FwgVAxaPkaAKibKNJNJqZo7MeB13hRP1fi0ZVqiLF+Q==
X-Gm-Gg: ASbGnct1Vfp4dGPaZnLbE71iVrU6lmVNGJ007CibcAOh/ap2lXRyjsA4pTB/0bOMyUP
	MJrli7Agk1Xq/ANaFrRib9LfsMZtAPVYhiWzlZvkc1RS5tlySDzlUzFUN9EAkhYk8MfQf4fsGCc
	s5JbCZ6jNoPuPrUPilcJZ+VNU/BHEEBCGZoSmwWZ+tD8gP5x1d+cIXURAYT0d/ZMH9OgmmXZeTy
	FKhaktGjAsvEgIERviCkkBR5oYP90pmwO5LsZJT1IoDgJ+BVZ6zhBRP3HyzndZjtIV25gXKxICj
	CevusgpxVxBH
X-Received: by 2002:a05:6a20:394d:b0:1f3:2c55:8d8a with SMTP id adf61e73a8af0-20cde952da6mr1047590637.12.1746142252567;
        Thu, 01 May 2025 16:30:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF2dZAV7HsuZ8oKI3zYsiz7ja1Xpp36L3rGRrA0ckr87PI6dc2juV/UWU2b7kcpP5iRZnp7dw==
X-Received: by 2002:a05:6a20:394d:b0:1f3:2c55:8d8a with SMTP id adf61e73a8af0-20cde952da6mr1047551637.12.1746142252156;
        Thu, 01 May 2025 16:30:52 -0700 (PDT)
Received: from [192.168.68.51] ([180.233.125.65])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b1fa82422e0sm228551a12.13.2025.05.01.16.30.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 May 2025 16:30:51 -0700 (PDT)
Message-ID: <6799bc5f-cc4a-446e-b47b-1cbabbc0b518@redhat.com>
Date: Fri, 2 May 2025 09:30:42 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 39/43] arm64: RME: Provide register list for
 unfinalized RME RECs
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
 <20250416134208.383984-40-steven.price@arm.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250416134208.383984-40-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/16/25 11:42 PM, Steven Price wrote:
> From: Jean-Philippe Brucker <jean-philippe@linaro.org>
> 
> KVM_GET_REG_LIST should not be called before SVE is finalized. The ioctl
> handler currently returns -EPERM in this case. But because it uses
> kvm_arm_vcpu_is_finalized(), it now also rejects the call for
> unfinalized REC even though finalizing the REC can only be done late,
> after Realm descriptor creation.
> 
> Move the check to copy_sve_reg_indices(). One adverse side effect of
> this change is that a KVM_GET_REG_LIST call that only probes for the
> array size will now succeed even if SVE is not finalized, but that seems
> harmless since the following KVM_GET_REG_LIST with the full array will
> fail.
> 
> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>   arch/arm64/kvm/arm.c   | 4 ----
>   arch/arm64/kvm/guest.c | 9 +++------
>   2 files changed, 3 insertions(+), 10 deletions(-)
> 

With below comment addressed.

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 4780e3af1bb9..eaa60ba6d97b 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -1832,10 +1832,6 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>   		if (unlikely(!kvm_vcpu_initialized(vcpu)))
>   			break;
>   
> -		r = -EPERM;
> -		if (!kvm_arm_vcpu_is_finalized(vcpu))
> -			break;
> -
>   		r = -EFAULT;
>   		if (copy_from_user(&reg_list, user_list, sizeof(reg_list)))
>   			break;
> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> index dd379aba31bb..1288920fc73d 100644
> --- a/arch/arm64/kvm/guest.c
> +++ b/arch/arm64/kvm/guest.c
> @@ -671,12 +671,9 @@ static unsigned long num_sve_regs(const struct kvm_vcpu *vcpu)
>   {
>   	const unsigned int slices = vcpu_sve_slices(vcpu);
>   
> -	if (!vcpu_has_sve(vcpu))
> +	if (!vcpu_has_sve(vcpu) || !kvm_arm_vcpu_sve_finalized(vcpu))
>   		return 0;
>   
> -	/* Policed by KVM_GET_REG_LIST: */
> -	WARN_ON(!kvm_arm_vcpu_sve_finalized(vcpu));
> -
>   	return slices * (SVE_NUM_PREGS + SVE_NUM_ZREGS + 1 /* FFR */)
>   		+ 1; /* KVM_REG_ARM64_SVE_VLS */
>   }

KVM_REG_ARM64_SVE_VLS is exposed even SVE isn't finalized. See set_sve_vls() where
it's required that SVE isn't finalized, or -EPERM is returned. So this would be
something like below:

	if (!vcpu_has_sve(vcpu))
		return 0;

	if (!kvm_arm_vcpu_sve_finalized(vcpu))
		return 1;	/* KVM_REG_ARM64_SVE_VLS */

	return slices * (SVE_NUM_PREGS + SVE_NUM_ZREGS + 1 /* FFR */)
		+ 1; /* KVM_REG_ARM64_SVE_VLS */

> @@ -692,8 +689,8 @@ static int copy_sve_reg_indices(const struct kvm_vcpu *vcpu,
>   	if (!vcpu_has_sve(vcpu))
>   		return 0;
>   
> -	/* Policed by KVM_GET_REG_LIST: */
> -	WARN_ON(!kvm_arm_vcpu_sve_finalized(vcpu));
> +	if (!kvm_arm_vcpu_sve_finalized(vcpu))
> +		return -EPERM;
>   
>   	/*
>   	 * Enumerate this first, so that userspace can save/restore in

Since KVM_REG_ARM64_SVE_VLS can be exposed before the vCPU is finalized, it'd better to
move the check after the followup block where KVM_REG_ARM64_SVE_VLS index is copied
to user space.

	/*
          * Enumerate this first, so that userspace can save/restore in
          * the order reported by KVM_GET_REG_LIST:
          */
         reg = KVM_REG_ARM64_SVE_VLS;
         if (put_user(reg, uindices++))
                 return -EFAULT;
         ++num_regs;

	if (!kvm_arm_vcpu_sve_finalized(vcpu))
		return num_regs;

Thanks,
Gavin
	


