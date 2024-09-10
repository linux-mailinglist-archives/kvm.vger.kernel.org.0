Return-Path: <kvm+bounces-26185-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 164859727B9
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 05:51:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 902961F24BD5
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 03:51:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9EB714F9D4;
	Tue, 10 Sep 2024 03:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="c+5hdPHf"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 532FB39FC6
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 03:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725940287; cv=none; b=OeyQQwRukH9lC4GCx5vIHysEimwHDA7ULp3Owk/j6RulF+hOEgmLjD1KhY+LWcEhocCJ5oWa9pxUVEC3/aqvcuoGuw6PYUwTEP1FgmCIa5Z0OWXr1DG14oBI7VPKz1pqPpiyqPYdQp3SzpNV3NHZyn+Dd18B6fLliAhE0IayZew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725940287; c=relaxed/simple;
	bh=ccnQ8BldDhlgnZ8uiHo0FZ7kW1WSeCWe7cu8HrONIcg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PXUgDcFBm2dmNbGBldQKrAsOw8ZxWY0QmpiNLUzHO4nrEAbAsu/Zx0OgoSmiEYTwdgZx0u8r1NwKuaIhwjMrsOG8Sam/vJzt5mJx/dgk0Yy1JEe+ckfTY+cek0XGOVr6/VWnhNFhB1Vf34Awtqp0qkHH61M/oxintGwJVpx06eM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=c+5hdPHf; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725940285;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/I3+YXY+JwS3qdscq18bmJNKDLcufBeHf8bjRwDJT1w=;
	b=c+5hdPHfRuuBh2r7s7bPcADU06J4M8mQz0s7v5qRGvmItZ55s4OD2fWp6c/W20kV8vEF9p
	ychf1NTz9TYg1CbfkZgcIph93vZk6jYmSOt7aYz2iX7hG719Mu2ryZZSYUsEZ8GM9AqwQ1
	4LVQVc4GaNL3hr3BrJEwNlWg2sW8RYw=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-312-iGeB94w-PNW7cMFbf-BGhw-1; Mon, 09 Sep 2024 23:51:24 -0400
X-MC-Unique: iGeB94w-PNW7cMFbf-BGhw-1
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-7177906db91so5244337b3a.3
        for <kvm@vger.kernel.org>; Mon, 09 Sep 2024 20:51:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725940283; x=1726545083;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/I3+YXY+JwS3qdscq18bmJNKDLcufBeHf8bjRwDJT1w=;
        b=H3pMNL1SAlRlNURMDcwUEVi8IFHDQT78SLkKY82IJyrMIMDX3Q9S0O6ccSswgV3UA/
         1O5Uq2EaOZ2dtxNRDn6yjmnf/Eyx32G2uwaiWQyRxtQoJ8uBGqaq58QvwL/i/cv8FzYE
         4KNK0hOFCUkCe3rsHOaNChvrnOg4y4vEVLr/8oPnxPtpcDS4hjbfXtJE++nXwjdMZA96
         O6M1fJ53fpjqaPO8MiZUNWj6Mpxo55xexbOtEOKgQhS0mVYfUNAOa/Ie5bndCzJw6Lkj
         nM2XDJtjwHrfl2LcPnvdFAZO0myVn2LFwySOVMlmadwWbzw3l92Zai8N9GMusEm8nDwR
         GG3g==
X-Forwarded-Encrypted: i=1; AJvYcCXA2Hw0dpr8Y47Z1OJCpxkv2MoNJpe3951ia6QlhVLYXSD0Q2INCtRzWnTsVRuVPiwb4kc=@vger.kernel.org
X-Gm-Message-State: AOJu0YyQV1tEZDN9ZuA9POS3pygcUzdZQq1ROq/ZWLnhgfgG3zsFMxDu
	Aqcr58gnqDL9gezFAJCt7B5IPD38BPbv5RmoFgHtVZhOKtOsaegdmhN3xR+H93EcIUfoGUnAFL1
	3/b0U7cbuxP8dcmE6vIBLERzjdjmPP7slgNdkbxwnjBUPN3O0lg==
X-Received: by 2002:a05:6a00:17a9:b0:714:20a8:d79f with SMTP id d2e1a72fcca58-718d5e52b97mr16304618b3a.14.1725940282894;
        Mon, 09 Sep 2024 20:51:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE/d19sKSMFsfHliPT47QFiITi7JaTPVoNF1P6pGKw0CeBAi1klKPcTxxhOABv3xB54UTlCPw==
X-Received: by 2002:a05:6a00:17a9:b0:714:20a8:d79f with SMTP id d2e1a72fcca58-718d5e52b97mr16304574b3a.14.1725940282285;
        Mon, 09 Sep 2024 20:51:22 -0700 (PDT)
Received: from [192.168.68.54] ([103.210.27.31])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71908feb36dsm462585b3a.58.2024.09.09.20.51.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Sep 2024 20:51:21 -0700 (PDT)
Message-ID: <a64defd3-d202-4b65-9ebb-46821717cf20@redhat.com>
Date: Tue, 10 Sep 2024 13:51:12 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 07/19] arm64: rsi: Add support for checking whether an
 MMIO is protected
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
 <20240819131924.372366-8-steven.price@arm.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20240819131924.372366-8-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/19/24 11:19 PM, Steven Price wrote:
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
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> New patch for v5
> ---
>   arch/arm64/include/asm/io.h       |  8 ++++++++
>   arch/arm64/include/asm/rsi.h      |  3 +++
>   arch/arm64/include/asm/rsi_cmds.h | 21 +++++++++++++++++++++
>   arch/arm64/kernel/rsi.c           | 26 ++++++++++++++++++++++++++
>   4 files changed, 58 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/io.h b/arch/arm64/include/asm/io.h
> index 1ada23a6ec19..a6c551c5e44e 100644
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
> +static inline bool arm64_is_iomem_private(phys_addr_t phys_addr, size_t size)
> +{
> +	if (unlikely(is_realm_world()))
> +		return arm64_rsi_is_protected_mmio(phys_addr, size);
> +	return false;
> +}
> +

I guess it might be better to unify the function names here. The name of
arm64_is_iomem_private() indicates the IO region is private, while the
name of arm64_rsi_is_protected_mmio() indicates the IO region is protected.
I think it would be nice to rename arm64_is_iomem_private() arm64_is_protected_iomem(),
or rename arm64_rsi_is_protected_mmio() to arm64_rsi_is_private_iomem().

Thanks,
Gavin


