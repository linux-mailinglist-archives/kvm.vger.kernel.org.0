Return-Path: <kvm+bounces-37078-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 426F0A24CB0
	for <lists+kvm@lfdr.de>; Sun,  2 Feb 2025 07:01:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 124ED3A5B2E
	for <lists+kvm@lfdr.de>; Sun,  2 Feb 2025 06:00:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38F8F1D516B;
	Sun,  2 Feb 2025 06:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NPWwXaJC"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D4C55588B
	for <kvm@vger.kernel.org>; Sun,  2 Feb 2025 06:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738476044; cv=none; b=Xv9Yt4Ch30sTmSMZut6nGgu4iksYRmH/rFT8wp11vV4ukNfGfGFrX3/sA4AzmWIjvg0o8vw+fVXibw5QK4BjBNnpDobhoJ2byc8lSEhN6DOFQyWnh4GDPf7VNsVlHVfrNrxdRrRZokEp2elxRaVmYEnG52XK0TC7xeF2LcdEvXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738476044; c=relaxed/simple;
	bh=t4oY2eeSqSQ09U11mxMs90mVSWWyvFwiP6VcUrlpOsw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QB92Mf38P/Xmq3SSTSpCeQ78vGT43Y9A9pgNS00s3Bvq0oDR8aTh0gTRz7bozJBH6bzuS4ht9tn3Ni+rKYYxVYPi3wAghzUdP7bwH0ADVsDij8Hxxw2wS8hTGDadWcLCh6SmjkThJ9PcwstpPrEXX2F+/HF52gO0ilWm4ZanI94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NPWwXaJC; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738476039;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YjlJ37q+gVBxHg8p/iKgIH4lKOr26qVR6N2QdXuX3CE=;
	b=NPWwXaJCU3N3B+fUQDXUFl+qPXhqY6JAGZxzyc7ydLtlMiPCBBVaEhloWDCcrykTPSj403
	yoAie6ME4nilcGlrrzhP+ruYBDOxtMdJ2MhFcU3hDSbiUi6nvPizrfyKSkfmt5UIylO5gO
	aS5bKbB83ABCSajLgF2T3HQ8mDvc4Gc=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-92-DKLczWn5N-mGieVUlClQmw-1; Sun, 02 Feb 2025 01:00:36 -0500
X-MC-Unique: DKLczWn5N-mGieVUlClQmw-1
X-Mimecast-MFC-AGG-ID: DKLczWn5N-mGieVUlClQmw
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2163a2a1ec2so109327905ad.1
        for <kvm@vger.kernel.org>; Sat, 01 Feb 2025 22:00:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738476035; x=1739080835;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YjlJ37q+gVBxHg8p/iKgIH4lKOr26qVR6N2QdXuX3CE=;
        b=X/xjq/m2jttXbr25/Aqpiwm5ruSYZSyz0mmfCR7ho35HgJaRQEPbhxKJeQ3pBVoKuO
         Kqoz1Shr0ZcJzJvoYhS9HE+BWsqb8MkEfuG2CB5/6ZWs/zP54ZMby6X18M4eJ2fCZm8r
         H1Eig9fl4vEGRvpQqc8Wz1TKK47N9ZEatGhheM5Nk/CPiThHEoXzA/D045gxpkwFRGDz
         NQ+H0FJTz5Sp7IfdplX3UoaG9PgUz+F5etGycLZrXHKfFigfIdgpXvouqtOMNFVQGesY
         ruFtwQJ5dd7hlgvEOrkG+1SeQuHdrlAwPobErL2IGDZyIBwcIyBU/wiiqos561k2RBsa
         1Dpw==
X-Forwarded-Encrypted: i=1; AJvYcCWNDlLGNEDrCfwxdw6tfHsJgWKqiS7NEWB9ElhtNWPK1rIQPeZnuWIepOpbaVmjAj6Inxs=@vger.kernel.org
X-Gm-Message-State: AOJu0YysTUzYOz+lX78rlCLYGWa8lVoQxvuX3Ut9bn/XepzgsiVofcw4
	l+HNic57Rkguw2zIG2fM6wmakQcdl7PA+2gBaBvMjbtUHI29KbAVLh+QnNpk2UNsGSHR491+KQV
	FHK7fMHgc5G/vWDZrZ5xlMV7jtGl29d5z3CTOKcxDfhMRG+kjcw==
X-Gm-Gg: ASbGncvZdFCbs10yTH+elCDvZC7IWriPmJpsm1B29MQnmYxsl3BwL6G6JYb5mSwPMlG
	I6fmOSLnlCcoCYa/9mvDKGcpHMtDn8WJWiYjx9MJiSg06nCBt4NdAclHCkGKMmoWgjKuq6eBIR/
	7LTmqeUytZ7PvVS2U8AE8I9zogAPOpxB93TZ7U5PLvSHFfOcL42hEZTfZQCwAUYRFgcZCD5zj5P
	JSeg4JP7j18Ji5Z3M3WTaNQey5OdbDfCaojl/nVMYbWOUkgF1Bc4x/6mDVpqW5gJOb6cFkTtqO5
	Ip+LrA==
X-Received: by 2002:a17:903:2286:b0:216:2bd7:1c36 with SMTP id d9443c01a7336-21dd7c4c5fdmr262741605ad.1.1738476035656;
        Sat, 01 Feb 2025 22:00:35 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE8sh+1yR6eIL3z2ruF+In49PMNICNRbXw6lt1qSpPO4OvbSNdtKO0P+Pt1zVlA9G23+OiuCw==
X-Received: by 2002:a17:903:2286:b0:216:2bd7:1c36 with SMTP id d9443c01a7336-21dd7c4c5fdmr262741275ad.1.1738476035348;
        Sat, 01 Feb 2025 22:00:35 -0800 (PST)
Received: from [192.168.68.55] ([180.233.125.64])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f8489adf7csm6566390a91.13.2025.02.01.22.00.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 01 Feb 2025 22:00:34 -0800 (PST)
Message-ID: <4cd1b360-6902-4800-93a2-905cfd8ca7f8@redhat.com>
Date: Sun, 2 Feb 2025 16:00:25 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 28/43] arm64: rme: Allow checking SVE on VM instance
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
References: <20241212155610.76522-1-steven.price@arm.com>
 <20241212155610.76522-29-steven.price@arm.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20241212155610.76522-29-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/13/24 1:55 AM, Steven Price wrote:
> From: Suzuki K Poulose <suzuki.poulose@arm.com>
> 
> Given we have different types of VMs supported, check the
> support for SVE for the given instance of the VM to accurately
> report the status.
> 
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>   arch/arm64/include/asm/kvm_rme.h | 2 ++
>   arch/arm64/kvm/arm.c             | 5 ++++-
>   arch/arm64/kvm/rme.c             | 5 +++++
>   3 files changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_rme.h b/arch/arm64/include/asm/kvm_rme.h
> index 90a4537ad38d..0d89ab1645c1 100644
> --- a/arch/arm64/include/asm/kvm_rme.h
> +++ b/arch/arm64/include/asm/kvm_rme.h
> @@ -85,6 +85,8 @@ void kvm_init_rme(void);
>   u32 kvm_realm_ipa_limit(void);
>   u32 kvm_realm_vgic_nr_lr(void);
>   
> +bool kvm_rme_supports_sve(void);
> +
>   int kvm_realm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap);
>   int kvm_init_realm_vm(struct kvm *kvm);
>   void kvm_destroy_realm(struct kvm *kvm);
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 134acb4ee26f..6f7f96ab781d 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -456,7 +456,10 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>   		r = get_kvm_ipa_limit();
>   		break;
>   	case KVM_CAP_ARM_SVE:
> -		r = system_supports_sve();
> +		if (kvm_is_realm(kvm))
> +			r = kvm_rme_supports_sve();
> +		else
> +			r = system_supports_sve();
>   		break;

kvm_vm_ioctl_check_extension() can be called by ioctl(KVM_CHECK_EXTENSION) on the
file descriptor of '/dev/kvm'. kvm is NULL and kvm_is_realm() returns false in
this case.

kvm_dev_ioctl
   kvm_vm_ioctl_check_extension_generic  // kvm is NULL
     kvm_vm_ioctl_check_extension

>   	case KVM_CAP_ARM_PTRAUTH_ADDRESS:
>   	case KVM_CAP_ARM_PTRAUTH_GENERIC:
> diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
> index 5831d379760a..27a479feb907 100644
> --- a/arch/arm64/kvm/rme.c
> +++ b/arch/arm64/kvm/rme.c
> @@ -20,6 +20,11 @@ static bool rme_supports(unsigned long feature)
>   	return !!u64_get_bits(rmm_feat_reg0, feature);
>   }
>   
> +bool kvm_rme_supports_sve(void)
> +{
> +	return rme_supports(RMI_FEATURE_REGISTER_0_SVE_EN);
> +}
> +

If rme_supports() becomes a public helper, it can be directly used. In turn,
kvm_rme_supports_sve() can be dropped. RMI_FEATURE_REGISTER_0_SVE_EN is obvious
to indicate the corresponding feature.

>   static int rmi_check_version(void)
>   {
>   	struct arm_smccc_res res;

Thanks,
Gavin


