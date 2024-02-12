Return-Path: <kvm+bounces-8555-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D6A6851528
	for <lists+kvm@lfdr.de>; Mon, 12 Feb 2024 14:31:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DA5B1287A6D
	for <lists+kvm@lfdr.de>; Mon, 12 Feb 2024 13:31:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C775C3D0DF;
	Mon, 12 Feb 2024 13:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ax2qBP3W"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CD073D0BC
	for <kvm@vger.kernel.org>; Mon, 12 Feb 2024 13:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707743800; cv=none; b=PFDb2kYxoCeCEazMzYmz0pbqV+lz9D6LTsAkR94KTCSY+c9o3YW8wMjgfp/7UpliNuVGkAzGovGN/CdbbuhKsqsgzVIyUCD6Ov0waCumVEdSyOlHeXM+b6ABGWEk85RFdj2yumZqm1Dx8HuY30qPvwxZd1yrZXymzuEN8O6boMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707743800; c=relaxed/simple;
	bh=mOmu6bKnnbQ/T3Bsy4O7zqo47TuFJtZ6E9Rx8rVgL9c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ygrgh5fS+HX0rG3mK7M2WzoggQgxVURSWpgTSclxWMUPtSjuojMXzKJ7/HlC7JyAC/3XjyH4tNNmFq5ysfjBZ+J445zIgMPGizCqsqg12ic3FFnLDETmfiG6toBlT9bCMp3nPFD0JByAd+Yz8s+mS2rRe3Q3Uxt3NrYp8jx8fsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ax2qBP3W; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707743797;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=VzDYwK2iuJ4LmgQXwNgJ7Lf6QDDAqXO/glvGyId4yYE=;
	b=Ax2qBP3WdKGjfsZ6fflYDcJHTkEnrLiWEjihqQo0dRIHqKvvZUxVdz/6u0mwhPNsCxhlP1
	KFQPh09+m8pRMdD+3PYB8pLB9g1JsRRM0Y91icVf+xwCTNic0JStlHPvoqgNnVjeuTN9N2
	KxmZwRNsUmLn37/xfjacXJfg20X41XE=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-61-2k0yKSF-OVKjT9df7Z4jgA-1; Mon, 12 Feb 2024 08:16:34 -0500
X-MC-Unique: 2k0yKSF-OVKjT9df7Z4jgA-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-33b14a51861so1589108f8f.0
        for <kvm@vger.kernel.org>; Mon, 12 Feb 2024 05:16:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707743793; x=1708348593;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt:from
         :references:cc:to:content-language:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VzDYwK2iuJ4LmgQXwNgJ7Lf6QDDAqXO/glvGyId4yYE=;
        b=fHOmWjc3ntZ6aaeUuTzleVJ/nNN0n9mvsuIgNoUgpBM9he0+1OSzmYcdFuAB1JaalT
         evD/yn3+PyWPIwAnbPNvo+1Z+q/tb9JYN71HG/MRwTnTqUs8CmZJVyucj+xuM2bhR9ah
         FfgsO3IM6IphjpIMgPT5cKYYkcbvU5piqVaMlvpZByT15VjQ+sKVi7c5lTCpvsFaime4
         74uyjqoBEe2nDZ9806Enj1jjIdI+NcKk1lWxcyYkkyraLXBDlnRxpemeSBEANz4ip7vf
         t2NfHlaTlTedjAXSXoMVUugopesnLGhMjYakO1xGbJqHZsRkOISLH30vo0r1wCBNn7P3
         u3Pg==
X-Gm-Message-State: AOJu0YzDi7dbk+UXqA3j+mB3KxaNYaLLLuDI9hyIe1QSs2qu8a+BUV8H
	pjJaljivSAzpvY8+fqQzLa5fMmcMnDfKkV7nqXjIK8UWdwqAZqbnSYG6BKm+j/eJdQgueNej6tA
	fumsEJ5xCvf6cl/TfY48ElJqQzJ52tdmVeX7oTSZDbQpI51IRpg==
X-Received: by 2002:adf:fe08:0:b0:33b:2fba:1ea8 with SMTP id n8-20020adffe08000000b0033b2fba1ea8mr4200513wrr.52.1707743792996;
        Mon, 12 Feb 2024 05:16:32 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGxpBipBT3X0Dit4wAxSwyYUFXLETqTvvtgvVK9OQyhNeu7c1D+fK2Uy2PwFi2KixZcbrQThg==
X-Received: by 2002:adf:fe08:0:b0:33b:2fba:1ea8 with SMTP id n8-20020adffe08000000b0033b2fba1ea8mr4200490wrr.52.1707743792624;
        Mon, 12 Feb 2024 05:16:32 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWLYLeSLEG7e3LWjbCRQeUUwwjKwOp0UA0H5bXRyDYDGlbn5p9Uzq/h7qHON2mF8M/oLhRd6z2G0n/bh/DbNl4QHZ/TEV1YtjoDYtQloVAo0QXoy60jnrZa8ra4rQM4oruWjJfL4edsfAY8tYKQy192HX7aB+26OVmJ5I6wkDf3xiJBt0xQ4jnAgnXfOtqKwWbwYDs5JmiFiztMSeGa8XhRf3PQ2yByDazK81OLSw58jLsNr3/ixiE3v9Q4+t8sayNY7MHQYo9arpcYuji68swhVQ/+H2PIy+ZxcpILhiHiJD2eyCGToGaBydOhBXiwiw/1FpYMKW/VVNjZ3ee9mmUeOutHsce/p5xqucuPFeIib99cSjlhYGdCutX3NfOo9Hj/+mQ3lzivRBxKlkBkeGm2kBXuX4GkTd1aFBKgHXmFJADSmOm8mR+0E1UBAbYjlHZLNpySMPLeusSsJPWY45sAFpjNNd0qFJnDY46Gi1OT/6H+9PVuyB1gmnjaN8sJtXBmPzCNwxhKaa7e1CflLA46ZBUsYkv9PFsgyCnGqjSVbWFVHL2M8PFBl8SA708aufoKeJ4d0S4lr399pNrGCW69qgUIrbxER9VXU+ur+qXc+yvzSzOcGWxHdoLGk6o0Pqg4GnV3OwelOCZB1VLsAydUr1RVD1uYlLiv0R+F2w+fI6ZCwq9/eHRQHUxEdAxSKHiUcTUtZHALfa55bYUvnp8C6TAYOFNZ+JoNHiXDhs23K4sA48CV+hPGTRLdAGuVr6OxgxOdkOeN9/FkYdiRFBqDzs7FcnWyOvhRdJZAULWJ5tCNeltJqP02f6qNke+jDDyfV5J4v9aQSKzyKX1W7SH5cqLnMdW8d7+Ks1hEe5bUS6S29MFO61JQl0702IGBrVx4oZfbS4zb8iIjxhAQjLT0xj8NERSWMzUM02pVIyip0CcrGt8K1JgXSqkwpT1NviU0ts
 d7CotME1W6l8UzjPo6PRP0ag1qOZqO8+yu5qTI1Lq9KZNzVCvIWjmBHoy/rmIYjCrYdjoePY8WfthaU+r1YmmQKbWrQWEAJ8Rwn0FuPn/Iyj59quAE4HcNeXI/m52PP86nY4tfP9ZiBIuBgTrrC5I0IUd0qrTHMni5BZgN3GYBebK7jPMU/LevwcFebUWCC9Ojg3fDArD85Ac/nGAmwtMpGx3ZzbcBvKEiL4qtiU4aJA71DQjEc2lxKRZpU3b/MwNe9Y7BZbJ0HKUko4MJkQCYRhKUqm19tENATR8lFC+L3XvnaY9wKW+CrBf+D37PZhXUR/9TCyItDNLR
Received: from ?IPV6:2003:cb:c730:2200:7229:83b1:524e:283a? (p200300cbc7302200722983b1524e283a.dip0.t-ipconnect.de. [2003:cb:c730:2200:7229:83b1:524e:283a])
        by smtp.gmail.com with ESMTPSA id en8-20020a056000420800b0033b7d9c14desm3956966wrb.5.2024.02.12.05.16.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Feb 2024 05:16:32 -0800 (PST)
Message-ID: <6ab142f0-bf66-4611-915d-938d58a277d3@redhat.com>
Date: Mon, 12 Feb 2024 14:16:30 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 4/4] vfio: convey kvm that the vfio-pci device is wc
 safe
Content-Language: en-US
To: ankita@nvidia.com, jgg@nvidia.com, maz@kernel.org,
 oliver.upton@linux.dev, james.morse@arm.com, suzuki.poulose@arm.com,
 yuzenghui@huawei.com, reinette.chatre@intel.com, surenb@google.com,
 stefanha@redhat.com, brauner@kernel.org, catalin.marinas@arm.com,
 will@kernel.org, mark.rutland@arm.com, alex.williamson@redhat.com,
 kevin.tian@intel.com, yi.l.liu@intel.com, ardb@kernel.org,
 akpm@linux-foundation.org, andreyknvl@gmail.com, wangjinchao@xfusion.com,
 gshan@redhat.com, shahuang@redhat.com, ricarkol@google.com,
 linux-mm@kvack.org, lpieralisi@kernel.org, rananta@google.com,
 ryan.roberts@arm.com, linus.walleij@linaro.org, bhe@redhat.com
Cc: aniketa@nvidia.com, cjia@nvidia.com, kwankhede@nvidia.com,
 targupta@nvidia.com, vsethi@nvidia.com, acurrid@nvidia.com,
 apopple@nvidia.com, jhubbard@nvidia.com, danw@nvidia.com,
 kvmarm@lists.linux.dev, mochs@nvidia.com, zhiw@nvidia.com,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
References: <20240211174705.31992-1-ankita@nvidia.com>
 <20240211174705.31992-5-ankita@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20240211174705.31992-5-ankita@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11.02.24 18:47, ankita@nvidia.com wrote:
> From: Ankit Agrawal <ankita@nvidia.com>
> 
> The code to map the MMIO in S2 as NormalNC is enabled when conveyed
> that the device is WC safe using a new flag VM_ALLOW_ANY_UNCACHED.
> 
> Make vfio-pci set the VM_ALLOW_ANY_UNCACHED flag.
> 
> This could be extended to other devices in the future once that
> is deemed safe.

Maybe add some more details how one could make a decision whether it 
would be safe (either here or in patch #2).

> 
> Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
> Acked-by: Jason Gunthorpe <jgg@nvidia.com>
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> ---
>   drivers/vfio/pci/vfio_pci_core.c | 6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index 1cbc990d42e0..eba2146202f9 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -1862,8 +1862,12 @@ int vfio_pci_core_mmap(struct vfio_device *core_vdev, struct vm_area_struct *vma
>   	/*
>   	 * See remap_pfn_range(), called from vfio_pci_fault() but we can't
>   	 * change vm_flags within the fault handler.  Set them now.
> +	 *
> +	 * Set an additional flag VM_ALLOW_ANY_UNCACHED to convey kvm that
> +	 * the device is wc safe.
>   	 */
> -	vm_flags_set(vma, VM_IO | VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP);
> +	vm_flags_set(vma, VM_ALLOW_ANY_UNCACHED | VM_IO | VM_PFNMAP |
> +			VM_DONTEXPAND | VM_DONTDUMP);
>   	vma->vm_ops = &vfio_pci_mmap_ops;
>   
>   	return 0;

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb


