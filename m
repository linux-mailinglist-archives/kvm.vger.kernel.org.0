Return-Path: <kvm+bounces-39982-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8994DA4D3CD
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 07:24:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AD10C173AC1
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 06:24:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1426B1F5615;
	Tue,  4 Mar 2025 06:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="M2uVnHFT"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2B451F4734
	for <kvm@vger.kernel.org>; Tue,  4 Mar 2025 06:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741069453; cv=none; b=phUeD/SeDIDp9Xl43HQIUEzJJC/cXiYQY1/ImdGR3piOxZsqe4452rETHC6E9yGSyCmhX7pUkDhiu5o6Erj/duGsN/s5uiI4SPCGkVv+czLmJwPfGrPJUchgfbRxULXfnDqLvFP73s3vZwyQeqdPDa3tE4CgfyAN0UdmwBwCuJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741069453; c=relaxed/simple;
	bh=0EYT/5igMmD/qVvWdRKvGmdh6E8JzSaWldlA7WO1ROk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TO+/1zdbTmwfA3hwKKKPZ+yLtydRzEVMWGMctZR9YHBELjc76enO/DO1D1+MSQdAfJxvQa5dsACJsWzLMAxF2M4sMlYxrO9fy/Q2gHI7JCh6YDXN3A4gC38FtSTVgmAJG4p7wmyyilBW08laT8QHFjE7pBLv1IHpTGHq++qjMsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=M2uVnHFT; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741069448;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UUEeo/X+MxYcAZNwznFspnaWG5EWN4eG0J5QKgSy/vw=;
	b=M2uVnHFTvF1aXR97Yaqm02RV14jXxWlvZYFUbVL8kZRTzSvAKRHDEu0pmlz402lt8kbbJB
	Qkyn4kF0tKU4+9eelQw72nYE7X6hTkpQyMf9/hkILdnuDO90T8DjtY9EsOQjLAZ+8qwf5w
	c/KQiEgvRo0AX3qdSKh9X7cfaQHhv+I=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-211-84DDaKFlPnK8P_CrpZXxCQ-1; Tue, 04 Mar 2025 01:24:02 -0500
X-MC-Unique: 84DDaKFlPnK8P_CrpZXxCQ-1
X-Mimecast-MFC-AGG-ID: 84DDaKFlPnK8P_CrpZXxCQ_1741069442
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2235a1f8aadso81096385ad.2
        for <kvm@vger.kernel.org>; Mon, 03 Mar 2025 22:24:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741069441; x=1741674241;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UUEeo/X+MxYcAZNwznFspnaWG5EWN4eG0J5QKgSy/vw=;
        b=JFnOw5KVuXfDk7MD3Iv+nRWYdMZhXHjLVpC/d6qrXwulMmCpWVcZcULaC+/iyse2qV
         GX8BF3Aarr0No/2S8WILSYUo0FAIgSd+GajjlSK1YfgkQ1IQOUfuqrk+VfDebtn4GBbo
         vNZEEZp8Zfn0T5y12erWJXGdn+TeIV/C41ezvb3uOOs0ZKS9KLrsJ4ZmZWCgo9PNXpz2
         /93pOKacBTb622mrVZUrsmRpAUR5VLoqnyMsL8u1KBoOxnpZlYiPO46cEH/pzXBpMbxm
         i2V3kq2qWbxt03fW9xbPCfaFq66bkMvlWokCQgF5akfVoOoaDtjvmzZ8r36tHboRlD2I
         irrQ==
X-Forwarded-Encrypted: i=1; AJvYcCW24qu76B9fpRPttyUDe1rgUFXazLEECFKbyAiCnEtMDnj5R3tH/a7vHV5deuSdCGq7woo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwDHxDY8mvhri6s1UCimSw8B+KPXgoMnatsNEfPNRwdqqI2P6rv
	GPjypZa13vt3Z6A6y5CrglnHOs7f3jziGtCxB3LdLAQ1k0NjiIRzx7TG9yhHmgauqbp1odvVYfp
	ZmTNEMzsOGyvnHn+GI1E2KiVFQjOx7TrxCMfjdDedXlxF1m++QY+PM+tNxQ==
X-Gm-Gg: ASbGncslbvG/BDa6/Q6XqAzt1oPweMPK+6V5cco3+Dj9gDk2A6uvuXRrimKgTZMMs0P
	UQXSeate0dq0RIA+VEoGtRedPh/VgAsbKq0edvz0j/rjSak8LiVB7Oq7mHRbepdGAuFVfuK0mvA
	3A6YPslp8RgKAVjpRVh1GB8bYZkK163PnE5/qRQ+R/NT/AkvgpqsVoKsxKp35galLrkD/NgfCUW
	k0UdkkUz9z1nSAvVA1U1yKJmY/guifX2rbrqwqMvMJA+/gg8XwOf0HPfbNbYn3O2MXE8/Dz0Kvv
	m6z1J3RqUp5YFyI4Kg==
X-Received: by 2002:a17:902:ec92:b0:21f:6ce6:7243 with SMTP id d9443c01a7336-2236922454fmr215973775ad.51.1741069441084;
        Mon, 03 Mar 2025 22:24:01 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGeWcLcszVzswCV3IlHec2C4u9Iv8biEcHW4AvArM9d+exFu3qcTvk3+Js7kBLoNIjChH7Sog==
X-Received: by 2002:a17:902:ec92:b0:21f:6ce6:7243 with SMTP id d9443c01a7336-2236922454fmr215973585ad.51.1741069440784;
        Mon, 03 Mar 2025 22:24:00 -0800 (PST)
Received: from [192.168.68.55] ([180.233.125.164])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-223501d323bsm87972535ad.3.2025.03.03.22.23.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Mar 2025 22:24:00 -0800 (PST)
Message-ID: <9d32bfed-31f2-49ad-ae43-87e60957ad74@redhat.com>
Date: Tue, 4 Mar 2025 16:23:52 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 30/45] arm64: RME: Always use 4k pages for realms
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
References: <20250213161426.102987-1-steven.price@arm.com>
 <20250213161426.102987-31-steven.price@arm.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250213161426.102987-31-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/14/25 2:14 AM, Steven Price wrote:
> Always split up huge pages to avoid problems managing huge pages. There
> are two issues currently:
> 
> 1. The uABI for the VMM allows populating memory on 4k boundaries even
>     if the underlying allocator (e.g. hugetlbfs) is using a larger page
>     size. Using a memfd for private allocations will push this issue onto
>     the VMM as it will need to respect the granularity of the allocator.
> 
> 2. The guest is able to request arbitrary ranges to be remapped as
>     shared. Again with a memfd approach it will be up to the VMM to deal
>     with the complexity and either overmap (need the huge mapping and add
>     an additional 'overlapping' shared mapping) or reject the request as
>     invalid due to the use of a huge page allocator.
> 
> For now just break everything down to 4k pages in the RMM controlled
> stage 2.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>   arch/arm64/kvm/mmu.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 

The change log looks confusing to me. Currently, there are 3 classes of stage2 faults,
handled by their corresponding handlers like below.

stage2 fault in the private space: private_memslot_fault()
stage2 fault in the MMIO space:    io_mem_abort()
stage2 fault in the shared space:  user_mem_abort()

Only the stage2 fault in the private space needs to allocate a 4KB page from guest-memfd.
This patch is changing user_mem_abort(), which is all about the stage2 fault in the shared
space, where a guest-memfd isn't involved. The only intersection between the private/shared
space is the stage2 page table. I'm guessing we want to have enforced 4KB page is due to
the shared stage2 page table by the private/shared space, or I'm wrong.

What I'm understanding from the change log: it's something to be improved in future due to
only 4KB pages can be supported by guest-memfd. Please correct me if I'm wrong.

> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 994e71cfb358..8c656a0ef4e9 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1641,6 +1641,10 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>   	if (logging_active || is_protected_kvm_enabled()) {
>   		force_pte = true;
>   		vma_shift = PAGE_SHIFT;
> +	} else if (vcpu_is_rec(vcpu)) {
> +		// Force PTE level mappings for realms
> +		force_pte = true;
> +		vma_shift = PAGE_SHIFT;
>   	} else {
>   		vma_shift = get_vma_page_shift(vma, hva);
>   	}

Thanks,
Gavin


