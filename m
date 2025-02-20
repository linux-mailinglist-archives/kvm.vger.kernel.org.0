Return-Path: <kvm+bounces-38669-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D391A3D89B
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 12:29:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 60300179C00
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 11:27:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 175BD1F2C56;
	Thu, 20 Feb 2025 11:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CnSGIgs2"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EE6D1DE2DE
	for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 11:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740050718; cv=none; b=EdfOlbfqkKD/N/MXdHmHGoShrB+zw5rvWQdPRUOwIOV721I1OU9sBXtQRlYd3AUZJclsFTV9WadY9vkDh3LAM269CzsY1wMd8A/NCCN8vgjJuZ++028F5pieZ1xcjIJy9qmA0gab1U2xNOYqdWmrFhLFeQWcw9f8VpieXYvyhuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740050718; c=relaxed/simple;
	bh=4wzQD0GiucwwxOsyDVsosCQ83niF3bWI/86apZnja6g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EqCdOHms4sOTVP0StKGtCgeS80eVkp8u4P4+N2c0zmWGUpkq+2E5SMAkAfhkm3WBVbsoCfwUsuMzx58H8gJRcgAzfQvKYptAG+T1qVL9c6tKVeZ9xE6D8c+kFxMY+wmnP49SH+kUhyfly7e9HpY4c/ENbhN4nazfBTM4F2mZEys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CnSGIgs2; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740050715;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=uGZdi8KdzSg8+lo/DqF/6eIlGkRDEJginLIBdmtE6bA=;
	b=CnSGIgs23EeFKCOu/JqiteujYOJuKHnLIHJkKOvPcXL61oh3fPEPFPOU4oTwQgiaJE7epv
	KBShEiBmL69nR7fmOXH70MZfDa/FRAieNtCwnUXGrNmg5vhs5En2Ym6ObDQTwwYWfmlwsS
	jHezyS/58kD6t0kDH3o8ZeP5A9Lp2ag=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-263-igWaOfxjOgq9HFF7wEck1Q-1; Thu, 20 Feb 2025 06:25:14 -0500
X-MC-Unique: igWaOfxjOgq9HFF7wEck1Q-1
X-Mimecast-MFC-AGG-ID: igWaOfxjOgq9HFF7wEck1Q_1740050713
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-38f3eb82fceso366366f8f.0
        for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 03:25:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740050713; x=1740655513;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=uGZdi8KdzSg8+lo/DqF/6eIlGkRDEJginLIBdmtE6bA=;
        b=ibJ8y4FXn9IZzwKMyx3s7tlu84BqkIVi0cl8yKv3adeakbXChwKWn3TPxOcLhJl1ks
         F40vGBLcSg1yUjHIBUlGOEzrK30CjFuk1EV0cpMjMlhcDZpPc7MaPQZ4GqwqkQpznX55
         lMpJBoXfti6gPhzabt2sSSvezRipJfmq5AYpJFkUQcXpwtFaH5KpVxlzXGvax7z6KcdM
         qJB6Tzx+Yq16JIiFsYWjLg1jVcHDNBamHvCMUW6zIZo6QrxCQEPtd214FxArBsMfbgaM
         R1urCHjpUTJsIcVXN/JPqY4NR2FpLaeSyEahokc8mqcRaK0Kd3PChZ7zmKNk++9NMy9E
         vvTQ==
X-Forwarded-Encrypted: i=1; AJvYcCVOijWLCVTnT21PBFgC3R9XE78X5RWs3R1SZ/E5PcwiOAGvsF2fRi34gJIVSwbUvkqszY8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzm/Sose/umxYtGyXb/c1sROFWXJaGaRYU0APVc82CiqqLaYO5l
	JIx+7mBM8IdJtIbbs7PcYv1IJHGhCcnUA0YBnxuv5035f5FJu59a+rInTmgL6ZnoYqx5TcL40mJ
	FWfdS4WEkw3+6y5TA6/gHHAk7Xt7HR+2cdQaypZ0/3kc1w5EeA+Ot6OwT9HJ9
X-Gm-Gg: ASbGncs9h6GPFvgbt4PxNGDjqsx/ywVvyourfZZESDb95VC3tC6eY2e4nBGfOAmNOzZ
	Yi6a+M0wIl3xf6XSOcHsefZ+zVPJG+45YClmq+1f2qMPYbns/SFkvV9VH9QW/ofE650cFSpS/rd
	WP44PfCN/kiHc6yuGPEqoQfAHMUfudTDQLTbXpGhHW12mpO3ALasjQaKW+61OI0RFlqfVOJYLtp
	UwSxnLW/H1D42BZWpBS3izNl4MUhBHaEON0l+QZWolMMYY2rH5x0mvOA/JzpEMwZeikRKzQUaZa
	TB7CKsQMrEeUTrGT9jV2zeJqjEXez6NcJodihz1CSUSPdW5S+onjj8PLepp6hUmDETXM7fyNx5X
	qJFEmgZlXArpGPkuKIDZDDwrAnGQgBQ==
X-Received: by 2002:a05:6000:402a:b0:38d:e48b:1766 with SMTP id ffacd0b85a97d-38f33f118c8mr19278218f8f.6.1740050712750;
        Thu, 20 Feb 2025 03:25:12 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEEJ7PUkWXlKu7sBILMevxRjNkCya42HjQs3ym31ll8ONidSYI287JTdy7FX2Ozm5zRfKQQPA==
X-Received: by 2002:a05:6000:402a:b0:38d:e48b:1766 with SMTP id ffacd0b85a97d-38f33f118c8mr19278189f8f.6.1740050712364;
        Thu, 20 Feb 2025 03:25:12 -0800 (PST)
Received: from ?IPV6:2003:cb:c706:2000:e44c:bc46:d8d3:be5? (p200300cbc7062000e44cbc46d8d30be5.dip0.t-ipconnect.de. [2003:cb:c706:2000:e44c:bc46:d8d3:be5])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4399bea8577sm40051265e9.0.2025.02.20.03.25.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Feb 2025 03:25:11 -0800 (PST)
Message-ID: <8ddab670-8416-47f2-a5a6-94fb3444f328@redhat.com>
Date: Thu, 20 Feb 2025 12:25:07 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 02/11] KVM: guest_memfd: Handle final folio_put() of
 guest_memfd pages
To: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-mm@kvack.org
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
 anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk,
 brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
 xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com,
 jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com,
 yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net,
 vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com,
 mail@maciej.szmigiero.name, michael.roth@amd.com, wei.w.wang@intel.com,
 liam.merwick@oracle.com, isaku.yamahata@gmail.com,
 kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com,
 steven.price@arm.com, quic_eberman@quicinc.com, quic_mnalajal@quicinc.com,
 quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com,
 quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com,
 quic_pheragu@quicinc.com, catalin.marinas@arm.com, james.morse@arm.com,
 yuzenghui@huawei.com, oliver.upton@linux.dev, maz@kernel.org,
 will@kernel.org, qperret@google.com, keirf@google.com, roypat@amazon.co.uk,
 shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, rientjes@google.com,
 jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, jthoughton@google.com
References: <20250211121128.703390-1-tabba@google.com>
 <20250211121128.703390-3-tabba@google.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20250211121128.703390-3-tabba@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11.02.25 13:11, Fuad Tabba wrote:
> Before transitioning a guest_memfd folio to unshared, thereby
> disallowing access by the host and allowing the hypervisor to
> transition its view of the guest page as private, we need to be
> sure that the host doesn't have any references to the folio.
> 
> This patch introduces a new type for guest_memfd folios, which
> isn't activated in this series but is here as a placeholder and
> to facilitate the code in the next patch. This will be used in
> the future to register a callback that informs the guest_memfd
> subsystem when the last reference is dropped, therefore knowing
> that the host doesn't have any remaining references.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---

[...]

>   static const char *page_type_name(unsigned int page_type)
> diff --git a/mm/swap.c b/mm/swap.c
> index 47bc1bb919cc..241880a46358 100644
> --- a/mm/swap.c
> +++ b/mm/swap.c
> @@ -38,6 +38,10 @@
>   #include <linux/local_lock.h>
>   #include <linux/buffer_head.h>
>   
> +#ifdef CONFIG_KVM_GMEM_SHARED_MEM
> +#include <linux/kvm_host.h>
> +#endif
> +
>   #include "internal.h"
>   
>   #define CREATE_TRACE_POINTS
> @@ -101,6 +105,11 @@ static void free_typed_folio(struct folio *folio)
>   	case PGTY_hugetlb:
>   		free_huge_folio(folio);
>   		return;
> +#endif
> +#ifdef CONFIG_KVM_GMEM_SHARED_MEM
> +	case PGTY_guestmem:
> +		kvm_gmem_handle_folio_put(folio);
> +		return;

Hm, if KVM is built as a module, will that work? Or would we need the 
core-mm guest_memfd shim that would always be compiled into the core and 
decouple KVM from guest_memfd ("library")?

-- 
Cheers,

David / dhildenb


