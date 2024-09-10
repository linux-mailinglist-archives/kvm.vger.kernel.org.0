Return-Path: <kvm+bounces-26186-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BF81197282C
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 06:19:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 678561F24E9A
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 04:19:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEEA5192B6A;
	Tue, 10 Sep 2024 04:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dqWdq0/S"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5686517E007
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 04:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725941755; cv=none; b=OvtUmvqGLRYBELVFG6sxNw2Jg8uaBsetNqxPV3VqVE2L+Cv4u/5z/mmqghjkUBhLxwwNwl7XlxMmW8MBMN6Gsz6A9C/ySoq4drjlLI522o9lOy40Z90+GqUml1fh4f+81kQdFTbn70teL5MJLJSJpSsVh1DdOMduOM2Nz28I50g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725941755; c=relaxed/simple;
	bh=gkZzcVeOY1zKE6Oa+cxE4jiLx/E16ZR2j2sfe3+e4vI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CQxEAkeEdzSJ2j4Uk8lxUe/2vYea3S3G8K2gaaWfCf+bzl/hyOs77fhlRgdOA19TbIzmFWv2BPuugEJML6Vlltd+LwY0gEuCjHzX1pHyjVayp67uTh5HcDhM0Fy1JOCJXgUXUc9ng/PtFWuFGwz6E7UgBLp/X0zkANA74cKm0mY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dqWdq0/S; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725941752;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=u/+FRQQ8Ru8+M5tm0CToElnSS7luR16tiIP4Dg8B3y8=;
	b=dqWdq0/SMJnTpdZNVVG3YYLM2yKiE4Uujv0Lx7TJsxW/Fj+Gx0FVNPzeKjZ39nGzzRt8WT
	Fr5S/rO9ITSDEzjFAPYaDFTlpMPUfFdw50rP12VtlE79Pocor+PBug2qT1R8IqwQHqye9W
	W5PdGKvODRrTM7YCml59ZwQvg8tl9ug=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-660-YKx98jZ1O0a3U7Ogr1Pb2Q-1; Tue, 10 Sep 2024 00:15:50 -0400
X-MC-Unique: YKx98jZ1O0a3U7Ogr1Pb2Q-1
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2052918b4f4so61705655ad.1
        for <kvm@vger.kernel.org>; Mon, 09 Sep 2024 21:15:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725941749; x=1726546549;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=u/+FRQQ8Ru8+M5tm0CToElnSS7luR16tiIP4Dg8B3y8=;
        b=dWR7qtRq7kM9E9PHc21H0VnNxjnc60NVszcO+NeA5z9QSbUHjNYKEr3jnVbCL93LNS
         D9dnu9txgpcu78MDTSOotK75jvq8hTJvQ+Rkff+m3L7Sp/jPkFUWMEsHgHL8CQZy2vJp
         bojJFWck4n7yWlA2+zz3fGKDMG2BR5jZs7r0Gub6jGHwGAFSbvkF6eU1I5ZC8oJA0j+C
         bBt6UaZja8q5+4VFDjbw0+CXGrqYXI53SXkpO6Qecsggg4FkoyOivab0j1ltbJfLRx6u
         t1pv6gGA+k4UpGgmWjRdKmthVLMF77BPIc9b/H0VR8AToW1bbnMe082GCQZW5Z6azWGq
         Ablg==
X-Forwarded-Encrypted: i=1; AJvYcCV6OhF2mWPBFCLu9HdQWB1MAQpfaq1O2wMHceIf8a45E7s5P9vqHSEVTS2WaUfeeAy/wto=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx1rmcf8RJBfF8IHZTAsYylSSlHLSebUQomeKKrkRc0rCYJh7J3
	c9N66LfiZV11csarP8Qqy70Q2QOGhoh5rAelyUFaQDwYQswKwgdJ2+4I8KqJq2JAOYA5JOjARzn
	PVRCwVlJaQYwLbwbaDakJdt27WQ+d4O0zB5aGZ/545danfUle9g==
X-Received: by 2002:a17:902:f549:b0:202:5af:47fc with SMTP id d9443c01a7336-206f0511f66mr213103785ad.13.1725941749247;
        Mon, 09 Sep 2024 21:15:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IESpzFJPvUaYPPTKHz8T4YHLbc03zqgmBJU6sgzN1/EtRPQmV6cfuytRj9V1iBRvh9wsUVF0g==
X-Received: by 2002:a17:902:f549:b0:202:5af:47fc with SMTP id d9443c01a7336-206f0511f66mr213103255ad.13.1725941748534;
        Mon, 09 Sep 2024 21:15:48 -0700 (PDT)
Received: from [192.168.68.54] ([103.210.27.31])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20710e0efbesm40682855ad.40.2024.09.09.21.15.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Sep 2024 21:15:48 -0700 (PDT)
Message-ID: <29016e56-e632-422d-a4d2-1891fad2c565@redhat.com>
Date: Tue, 10 Sep 2024 14:15:39 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 12/19] efi: arm64: Map Device with Prot Shared
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
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun <alpergun@google.com>
References: <20240819131924.372366-1-steven.price@arm.com>
 <20240819131924.372366-13-steven.price@arm.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20240819131924.372366-13-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/19/24 11:19 PM, Steven Price wrote:
> From: Suzuki K Poulose <suzuki.poulose@arm.com>
> 
> Device mappings need to be emualted by the VMM so must be mapped shared
> with the host.
> 
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v4:
>   * Reworked to use arm64_is_iomem_private() to decide whether the memory
>     needs to be decrypted or not.
> ---
>   arch/arm64/kernel/efi.c | 12 ++++++++++--
>   1 file changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
> index 712718aed5dd..95f8e8bf07f8 100644
> --- a/arch/arm64/kernel/efi.c
> +++ b/arch/arm64/kernel/efi.c
> @@ -34,8 +34,16 @@ static __init pteval_t create_mapping_protection(efi_memory_desc_t *md)
>   	u64 attr = md->attribute;
>   	u32 type = md->type;
>   
> -	if (type == EFI_MEMORY_MAPPED_IO)
> -		return PROT_DEVICE_nGnRE;
> +	if (type == EFI_MEMORY_MAPPED_IO) {
> +		pgprot_t prot = __pgprot(PROT_DEVICE_nGnRE);
> +
> +		if (arm64_is_iomem_private(md->phys_addr,
> +					   md->num_pages << EFI_PAGE_SHIFT))
> +			prot = pgprot_encrypted(prot);
> +		else
> +			prot = pgprot_decrypted(prot);
> +		return pgprot_val(prot);
> +	}
>   

Question: the second parameter (@size) passed to arm64_is_iomem_private() covers the
whole region. In [PATCH v5 10/19] arm64: Override set_fixmap_io, the size has been
truncated to the granule size (4KB). They look inconsistent and I don't understand
the reason.

Thanks,
Gavin


