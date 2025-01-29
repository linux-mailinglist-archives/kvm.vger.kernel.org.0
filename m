Return-Path: <kvm+bounces-36817-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E60A2A21702
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2025 05:08:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3CF311638AF
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2025 04:08:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63B6C18FC80;
	Wed, 29 Jan 2025 04:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cDq+KGmu"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D089D18BB8E
	for <kvm@vger.kernel.org>; Wed, 29 Jan 2025 04:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738123685; cv=none; b=FwH194oNxHSzjeueizU3g8n44JU8xYYJoqmbrijgmWLYDUGeOLDq/ztd5T2zRIZgPWqfL7Tm9vq7kGalEE+84hPKWN6Gy38ztPZN6fD2S2zkLn2+w5T2W59lU+BJJRGa4GLB0QiXFn1ZVvmahu2J5scuXUewb2PYsCLXMbernzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738123685; c=relaxed/simple;
	bh=CsAeFJeoQweV080X+SOo03x6K4oJXpfbYalIrjSAXhw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CV+sNVDrHJ9bvF6DVc5ekcmHW0dVIX0twSHTk0Kjq+2l0D9LOL6yLgg6qw9P3nfy+pMwla8pTsh8Xsj9zRjlufp2gOQM0alVqS73CfSGqbwAyIKYQTqlqB14NXlORLF18r/MPJBCMzZz/RkF2xRfgTyNWNT+RILz9n3UnD3V+vY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cDq+KGmu; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738123682;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=++vP7Pzm+0U/vbuzpGurQDME6fn3ZbIwZpBgDGBaFV0=;
	b=cDq+KGmuqLNeAHcmuQKXgmemTzj6i7s9oaokuT4PqzJaaZA0Tb7i69sbIZNyQTtkVnPCmF
	DUnxitFsma+f9WBOoRDLXJSOZcOWIOX8UHNARw9hGfFdCRGqNdS+yytys9ecMgMDGJjgom
	Hsvfm3JLFf98Q1Ojq7d9aZFGHcOs0Tg=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-441-6W02oVr7OHyaW4UOSgEH0g-1; Tue, 28 Jan 2025 23:08:01 -0500
X-MC-Unique: 6W02oVr7OHyaW4UOSgEH0g-1
X-Mimecast-MFC-AGG-ID: 6W02oVr7OHyaW4UOSgEH0g
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2162259a5dcso200628825ad.3
        for <kvm@vger.kernel.org>; Tue, 28 Jan 2025 20:08:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738123680; x=1738728480;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=++vP7Pzm+0U/vbuzpGurQDME6fn3ZbIwZpBgDGBaFV0=;
        b=wLtdp9gb2VTQe1JspexwGKCK0kG72Gs9Rixu+hjLq8IAhicRBA2rzcqy5i5xEf1qje
         7y8FJI39yZKIYqzK4+qukOvQxDcVXou8falwzCd6UCk57jIXQq2tVxnk/8KOWeZA0cud
         69ZlQPjIQ/IQ3G4I5qNT9pzWU6Lrd/+xT9ruQFLZcDzspJUYxUWsyCr/ab5H7Z4Xto5G
         rUG76rqbY9dL7rUIgufvwWj0lmtUx3nS2DIz45+5/AJWQ6AufuvUaNJPp4QkoQX8U3AP
         IujsCCaVodbmkhRSfjlRXTmVaugOv3dxj0J/P1ESnTpVKRyo7/OidZUBP6SA5yc3dqE2
         yOvQ==
X-Forwarded-Encrypted: i=1; AJvYcCUDBxRfcekMWCZKwMVfNW3laAOXYlXA+oVmrZknPXrrWwDalrGa8iMzinnskV2FuWe0kdE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy7Gcw4ITu6uBC7avPEY3RKrjq/dhb/HmiZrxrGtk1/rSk4HUUP
	ZHlZdPiJ0Og5bZkFSsDSeYaBcxA7Bj4+KIF2B/lcReerljEYzaEv1MCS0QEF6xfro2K+3LzhdyF
	ELJnK0lm/6bhS2lyhRaQPhQPihSWJTN4Arc5SGIQNgRD1rAfdyQ==
X-Gm-Gg: ASbGnctkhC0SjOfmKiuI/aJvzhtSesw3IhISIfSduYa6dsHuF8VqYSToNy1ZjRkc2WM
	0b7qd0eCtcKsS/ndRGKWYR9mYnvW+/zfhhX4b2cC9VDG3l2bg0IxqRPqnjm1sF9A1Q2kqSWO3k3
	BIeblE6H2RsZg5N7B4iOpC5IQGXV3tEhCMIRsCDHZvnj/w7W8SYOGEIDTTWDWKkOJR57VgojcjI
	2sLnCSG3E7S//bcSEfQ76bSxtDAt9UMk+jDBd0eYgXkDf4NL1NKoj/XZYTVuL9aY+S9QN+y/wUP
	5484Zg==
X-Received: by 2002:a17:902:ce01:b0:215:3a42:dc17 with SMTP id d9443c01a7336-21dd7c4c298mr26327545ad.7.1738123680332;
        Tue, 28 Jan 2025 20:08:00 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHQIoq8D2QaYFpzEq5kL3xdCHIiITAzdgGLjBLAtD4+BnGQNR/G88wzSm8jyqJiShrpZVo+NA==
X-Received: by 2002:a17:902:ce01:b0:215:3a42:dc17 with SMTP id d9443c01a7336-21dd7c4c298mr26327115ad.7.1738123680051;
        Tue, 28 Jan 2025 20:08:00 -0800 (PST)
Received: from [192.168.68.55] ([180.233.125.64])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21da41415e9sm90098135ad.116.2025.01.28.20.07.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jan 2025 20:07:59 -0800 (PST)
Message-ID: <a580d287-2fb0-4e9d-adbb-57e4dbf25765@redhat.com>
Date: Wed, 29 Jan 2025 14:07:51 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 10/43] arm64: kvm: Allow passing machine type in KVM
 creation
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
 <20241212155610.76522-11-steven.price@arm.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20241212155610.76522-11-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/13/24 1:55 AM, Steven Price wrote:
> Previously machine type was used purely for specifying the physical
> address size of the guest. Reserve the higher bits to specify an ARM
> specific machine type and declare a new type 'KVM_VM_TYPE_ARM_REALM'
> used to create a realm guest.
> 
> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>   arch/arm64/kvm/arm.c     | 17 +++++++++++++++++
>   arch/arm64/kvm/mmu.c     |  3 ---
>   include/uapi/linux/kvm.h | 19 +++++++++++++++----
>   3 files changed, 32 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index c505ec61180a..73016e1e0067 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -207,6 +207,23 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>   	mutex_unlock(&kvm->lock);
>   #endif
>   
> +	if (type & ~(KVM_VM_TYPE_ARM_MASK | KVM_VM_TYPE_ARM_IPA_SIZE_MASK))
> +		return -EINVAL;
> +
> +	switch (type & KVM_VM_TYPE_ARM_MASK) {
> +	case KVM_VM_TYPE_ARM_NORMAL:
> +		break;
> +	case KVM_VM_TYPE_ARM_REALM:
> +		kvm->arch.is_realm = true;
> +		if (!kvm_is_realm(kvm)) {
> +			/* Realm support unavailable */
> +			return -EINVAL;
> +		}
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
>   	kvm_init_nested(kvm);
>   
>   	ret = kvm_share_hyp(kvm, kvm + 1);

Corresponding to comments for PATCH[6], the block of the code can be modified
to avoid using kvm_is_realm() here. In this way, kvm_is_realm() can be simplifed
as I commented for PATCH[6].

	case KVM_VM_TYPE_ARM_REALM:
		if (static_branch_unlikely(&kvm_rme_is_available))
			return -EPERM;	/* -EPERM may be more suitable than -EINVAL */

		kvm->arch.is_realm = true;
		break;

Thanks,
Gavin


