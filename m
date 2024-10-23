Return-Path: <kvm+bounces-29461-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 745459ABC91
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 06:03:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 008031F22F01
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 04:03:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58B1D13BC0D;
	Wed, 23 Oct 2024 04:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="E35sBhFN"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96EC13A1BA
	for <kvm@vger.kernel.org>; Wed, 23 Oct 2024 04:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729656200; cv=none; b=VdXc5MTODlvsQ49wo1cv9BHvd1NhT8BFq3VcvrpodDnVj8imNJ7ndl+dGH2zSkXX7kq4iFiI3iygMxLbqFbj/iDEtVdhKF7aukzzp72dqIb30OkAbmZsX55wneN06MuNs27abqfWBiSeEgXsHudx3NwwW0pm9HpkZVdP7BxJZPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729656200; c=relaxed/simple;
	bh=60FYQnwEjbn8ia2ijE+rJft1/gH3fGagogxsbRnBaRg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fxDYAWIpOq23FolNNC/cYQe1nJexxjFeUbaLRBv6c66LjLtZKIStBdD7Gby13Br+eFYkuTz7Mzeb27v1JfK8A/anIgdVZfm4Tmdy6t8OheHVKzQzPu0GjdUmr9ToJsBxxwAXtcjKdfFA8a9nm50VhrCIvJmTQ/VRdwqxUf9Ucv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=E35sBhFN; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729656196;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fE9bH6h+Dp9Cy+4YV9E9TS1/FxNq1rWMOHkDfIVYSY8=;
	b=E35sBhFNluHaVqqslSsWGZAelY2X4PvAlSJAL4cobvkWeBfxwQHWEkrucZjlJeLDa7KPuE
	0g7DnLb5qTn1umLEozDDbXHEkYCjCcu2mAPbtz1vY1Hch+JjjaLFQHnUvwElrYmbmYTWh+
	h1rhDGqs2En71mSU5c0ePNll0A2f2tU=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-153-u51EiO38OXmKAeOJmWUnBw-1; Wed, 23 Oct 2024 00:03:13 -0400
X-MC-Unique: u51EiO38OXmKAeOJmWUnBw-1
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-2e3b9fc918fso7647563a91.2
        for <kvm@vger.kernel.org>; Tue, 22 Oct 2024 21:03:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729656193; x=1730260993;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fE9bH6h+Dp9Cy+4YV9E9TS1/FxNq1rWMOHkDfIVYSY8=;
        b=bhOOvGjtBiISTcDydK9nktRkcWOy10sCyORLaPvOLGOdpZY2K+Z6qajD9CrTNakGi1
         Tfm/hU/7tGcXhl+T7jdJAbDvo0oBjqBLw34jegSUSViVqhnWQP6itkxQidxpR1wd6sIG
         pZpCTelJC3WLyJ/NBhb/JPbDHdh+VtMndPf8uxPX21BG5jdr6bIqdtaPdIYv9Wp3xXVY
         W2Sv2wsZgobAM5KYPTOyuY61E0E89exDtS3vNzB0pc9PfTHxUIQPpgkc4xFA518laNVD
         im7mIYTVSjk7v+ifQuc6o3SIznt/CEaNtoDBd0HhKaViLb24Of4hEQ+AhBtYewlINQSD
         69rw==
X-Forwarded-Encrypted: i=1; AJvYcCXLwkE05JOhGSIhUIBd3Jo/Lfj6zSKMvY3gepTBsgfJf63OGHKe3Z/1GtdY10j7mp3woxs=@vger.kernel.org
X-Gm-Message-State: AOJu0YzO1AqVILxHcFPZt+6YNARk0bjqAE4Updf5wUhsGA/8CIgUvfXY
	mlw/86KjdRMV8dQCIaywqj7Ysv1l6zKpl9SRdqeJ6BPPEHlCzbl232+OPXUJkm5WkLra0L2CEMV
	54HWcEEOhxntPoXJ30wzKDk9IMGryypWEimPz97/bPHJLiJfIOQ==
X-Received: by 2002:a17:90b:4c4b:b0:2e2:e148:3d30 with SMTP id 98e67ed59e1d1-2e76b60d401mr1665021a91.23.1729656192756;
        Tue, 22 Oct 2024 21:03:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF7Nzd7b22QkSrSkT2X54oW0FrLiZkrnYmJFDKn3Ga/iSi3gYtHtDYeZYfv+zNxnl5T9y8tvQ==
X-Received: by 2002:a17:90b:4c4b:b0:2e2:e148:3d30 with SMTP id 98e67ed59e1d1-2e76b60d401mr1664999a91.23.1729656192357;
        Tue, 22 Oct 2024 21:03:12 -0700 (PDT)
Received: from [192.168.68.54] ([180.233.125.129])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e76e088f1fsm273930a91.56.2024.10.22.21.03.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Oct 2024 21:03:11 -0700 (PDT)
Message-ID: <032d29e7-b6a3-4493-833b-a9b6d9496a75@redhat.com>
Date: Wed, 23 Oct 2024 14:03:03 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 02/43] kvm: arm64: pgtable: Track the number of pages
 in the entry level
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
References: <20241004152804.72508-1-steven.price@arm.com>
 <20241004152804.72508-3-steven.price@arm.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20241004152804.72508-3-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/5/24 1:27 AM, Steven Price wrote:
> From: Suzuki K Poulose <suzuki.poulose@arm.com>
> 
> Keep track of the number of pages allocated for the top level PGD,
> rather than computing it every time (though we need it only twice now).
> This will be used later by Arm CCA KVM changes.
> 
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>   arch/arm64/include/asm/kvm_pgtable.h | 2 ++
>   arch/arm64/kvm/hyp/pgtable.c         | 5 +++--
>   2 files changed, 5 insertions(+), 2 deletions(-)
> 

If we really want to have the number of pages for the top level PGDs,
the existing helpers kvm_pgtable_stage2_pgd_size() for the same purpose
needs to replaced by (struct kvm_pgtable::pgd_pages << PAGE_SHIFT) and
then removed.

The alternative would be just to use kvm_pgtable_stage2_pgd_size() instead of
introducing struct kvm_pgtable::pgd_pages, which will be used in the slow
paths where realm is created or destroyed.

> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index 03f4c3d7839c..25b512756200 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -404,6 +404,7 @@ static inline bool kvm_pgtable_walk_lock_held(void)
>    * struct kvm_pgtable - KVM page-table.
>    * @ia_bits:		Maximum input address size, in bits.
>    * @start_level:	Level at which the page-table walk starts.
> + * @pgd_pages:		Number of pages in the entry level of the page-table.
>    * @pgd:		Pointer to the first top-level entry of the page-table.
>    * @mm_ops:		Memory management callbacks.
>    * @mmu:		Stage-2 KVM MMU struct. Unused for stage-1 page-tables.
> @@ -414,6 +415,7 @@ static inline bool kvm_pgtable_walk_lock_held(void)
>   struct kvm_pgtable {
>   	u32					ia_bits;
>   	s8					start_level;
> +	u8					pgd_pages;
>   	kvm_pteref_t				pgd;
>   	struct kvm_pgtable_mm_ops		*mm_ops;
>   
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index b11bcebac908..9e1be28c3dc9 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -1534,7 +1534,8 @@ int __kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
>   	u32 sl0 = FIELD_GET(VTCR_EL2_SL0_MASK, vtcr);
>   	s8 start_level = VTCR_EL2_TGRAN_SL0_BASE - sl0;
>   
> -	pgd_sz = kvm_pgd_pages(ia_bits, start_level) * PAGE_SIZE;
> +	pgt->pgd_pages = kvm_pgd_pages(ia_bits, start_level);
> +	pgd_sz = pgt->pgd_pages * PAGE_SIZE;
>   	pgt->pgd = (kvm_pteref_t)mm_ops->zalloc_pages_exact(pgd_sz);
>   	if (!pgt->pgd)
>   		return -ENOMEM;
> @@ -1586,7 +1587,7 @@ void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt)
>   	};
>   
>   	WARN_ON(kvm_pgtable_walk(pgt, 0, BIT(pgt->ia_bits), &walker));
> -	pgd_sz = kvm_pgd_pages(pgt->ia_bits, pgt->start_level) * PAGE_SIZE;
> +	pgd_sz = pgt->pgd_pages * PAGE_SIZE;
>   	pgt->mm_ops->free_pages_exact(kvm_dereference_pteref(&walker, pgt->pgd), pgd_sz);
>   	pgt->pgd = NULL;
>   }

Thanks,
Gavin


