Return-Path: <kvm+bounces-35009-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F47EA08ACB
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 09:58:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 78108167EB1
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 08:58:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3515209F25;
	Fri, 10 Jan 2025 08:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Sovhem/Y"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A9C316DEA9
	for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 08:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736499490; cv=none; b=RX5yKDiVOTNX3n0HODuisH76Xt5JpWi8JFKJXh1UjWaw+CCzQh5O/UJAu0Kice+gI3YT00iTMCyhrgP+z3+aGnZJr92OHgMR8xneSNaSW5bk2tb0LlqqoFrsHeUfvKonKyBC9Q4rSRZqLdJtZ25WrcF9ciVVMpxZauiqh9nkt0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736499490; c=relaxed/simple;
	bh=U7jz4KxA5gt2QNJKhlvA5m2hc2lQH1v6gdiTcrgU8LA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MOBy31FqWeVxd0UoeKYtGYKdkS9hpq3tJ1JQPuP2nRYH+2uEygvhJWHN8x5BaJCvEN3iGkKdBm0wHDvrg9YWR21Dxtr3bZlqKyc95S0nWl5MxAU033hURAaSk/bf4SUqHwlBkk+0BxV4qIAC5RGWfrhKMKMLV886Dqbsvf7xmZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Sovhem/Y; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736499487;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=itH5PX1MRFx5oyXoc7xn5S7Q0UviLfckuwzvFCXBKO8=;
	b=Sovhem/Ytbqqsit2vpUveR8nfgFhG3f3Z61pZcZIB3dTpNx7QYoUQmFuxjfFdBa2ezSWcW
	0XW2wwLS67lyoYtZn+ADzXV+6R1twqboeM4YRpbequ2nZuffmwn4MJPuPVkMfu5r/KM+4/
	FcXr5pWBcnIYkZ65/vuPP/koKMr4n0Q=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-139-P1Ez4QblM4qa0LGttb3xzQ-1; Fri, 10 Jan 2025 03:58:06 -0500
X-MC-Unique: P1Ez4QblM4qa0LGttb3xzQ-1
X-Mimecast-MFC-AGG-ID: P1Ez4QblM4qa0LGttb3xzQ
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-38a2140a400so1272485f8f.0
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 00:58:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736499485; x=1737104285;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=itH5PX1MRFx5oyXoc7xn5S7Q0UviLfckuwzvFCXBKO8=;
        b=ljas6k3qBbGrMNNadt8JgET9oJZAQvxvKOLrnwWKdeI1Oa9t4qyQQ5s9xt6UsS+HEP
         DiojFeYxfGxj1U4zAqN8lh7qfbWwumCQAzvXwj7bltlZw43mqGrANF6Exi33UgL+FteK
         YNuotdtRIQgYhfMsZFl7XpT7LjlYh+1CJ7FSF3CejRU9xcWaMdNS+GF5CpkGXGUfPqFa
         cnoesRdjXNF6uDKSta6AvYfAYcBo9UQigwvKuoT/3DuZTCLrnoJq5gZrRXYzhnOIG+HZ
         gktBrb0Krl2YmJNEyAooU1ml5D52wD/kxzG8wYyj1GFV5aRPF1VpL2IlXoco4L5tiIin
         lqMA==
X-Gm-Message-State: AOJu0YzAwKQ8T8LYI2UOmFos1DjGZ0MgM+2/0AvTjEBTkHxfxff4HXgk
	dmZDC5RlYSZqH++Zt9kuGUM5Zj1wBZ/VaC8kE+mhrwQEOynSWvvdsQCElkSx6b9pq/N7B/piAsW
	MatwCAQIQ9hYsFc+SFlZ9g1W+T+b1FOZLboOBePh2YF67dZbGaA==
X-Gm-Gg: ASbGncsgGillglHjHmCFkxwCV5ZcjTQRgKx8CYpxZODFGZUb2lUlOU0wjKw7yKcBI5p
	KzpbhH81FistpNgMBcxjayOZ5BdIbx1+lyEekGVqyU74J4B/cz3ToOUX0+1a+MS03uafRbdKJ2V
	cgjlTjIeHkzgnaXAOUw4n8PYyWc/NR2xm+zs+mILL+EIElyFMzAt39j75B4aU6PtI4zc2XBQG/p
	MHoPwqSwVkw4Hckt8vCQQPpT1SKrs9zz16aAO5gLAx+S098mv1P0EBnEY+6c6OA+pDHEkdFOydb
	NjNPt37hot13EluG5nZyH8xgPBYUNliaaMl0wYtvhuRYTeA2/zL0xETiiJyzJqmH/Fs7BKQMPDA
	sU0qIZtb8
X-Received: by 2002:adf:a782:0:b0:38a:88f8:aac8 with SMTP id ffacd0b85a97d-38a88f8ace6mr5657406f8f.54.1736499485070;
        Fri, 10 Jan 2025 00:58:05 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHwEerrFF8LogzmjI2ypD4Xkk5Y2gfs765o32r0UoWGsa6S9elnvd9YbCadPOPTKcc/nKA3dQ==
X-Received: by 2002:adf:a782:0:b0:38a:88f8:aac8 with SMTP id ffacd0b85a97d-38a88f8ace6mr5657387f8f.54.1736499484687;
        Fri, 10 Jan 2025 00:58:04 -0800 (PST)
Received: from ?IPV6:2003:cb:c708:e100:4f41:ff29:a59f:8c7a? (p200300cbc708e1004f41ff29a59f8c7a.dip0.t-ipconnect.de. [2003:cb:c708:e100:4f41:ff29:a59f:8c7a])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38a8e383882sm3988661f8f.34.2025.01.10.00.58.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Jan 2025 00:58:03 -0800 (PST)
Message-ID: <26fe43db-b122-40e0-a05a-81b11b89ef46@redhat.com>
Date: Fri, 10 Jan 2025 09:58:02 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: SEV: Pin SEV guest memory out of CMA area
To: yangge1116@126.com, pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, michael.roth@amd.com,
 21cnbao@gmail.com, baolin.wang@linux.alibaba.com, liuzixing@hygon.cn
References: <1736498887-28180-1-git-send-email-yangge1116@126.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <1736498887-28180-1-git-send-email-yangge1116@126.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10.01.25 09:48, yangge1116@126.com wrote:
> From: yangge <yangge1116@126.com>

I would suggest the title to be something like

"KVM: SEV: fix wrong pinning of pages"

Then you can describe that without FOLL_LONGTERM, the pages will not get 
migrated out of MIGRATE_CMA/ZONE_MOVABLE, violating these mechanisms to 
avoid fragmentation with unmovable pages, for example making CMA 
allocations fail.

(CMA allocations failing is only one symptom of the missed usage of 
FOLL_LONGTERM)

> 
> When pin_user_pages_fast() pins SEV guest memory without the
> FOLL_LONGTERM flag, the pinned pages may inadvertently end up in the
> CMA (Contiguous Memory Allocator) area. This can subsequently cause
> cma_alloc() to fail in allocating these pages, due to the fact that
> the pinned pages are not migratable.
> 
> To address the aforementioned problem, we propose adding the
> FOLL_LONGTERM flag to the pin_user_pages_fast() function. By doing
> so, we ensure that the pages allocated will not occupy space within
> the CMA area, thereby preventing potential allocation failures.
> 
> Signed-off-by: yangge <yangge1116@126.com>
> ---
>   arch/x86/kvm/svm/sev.c | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 943bd07..35d0714 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -630,6 +630,7 @@ static struct page **sev_pin_memory(struct kvm *kvm, unsigned long uaddr,
>   	unsigned long locked, lock_limit;
>   	struct page **pages;
>   	unsigned long first, last;
> +	unsigned int flags = 0;

Why not set

unsigned int flags = FOLL_LONGTERM;

>   	int ret;
>   
>   	lockdep_assert_held(&kvm->lock);
> @@ -662,8 +663,10 @@ static struct page **sev_pin_memory(struct kvm *kvm, unsigned long uaddr,
>   	if (!pages)
>   		return ERR_PTR(-ENOMEM);
>   
> +	flags = write ? FOLL_WRITE : 0;


and here do

flags |= write ? FOLL_WRITE : 0;

> +
>   	/* Pin the user virtual address. */
> -	npinned = pin_user_pages_fast(uaddr, npages, write ? FOLL_WRITE : 0, pages);
> +	npinned = pin_user_pages_fast(uaddr, npages, flags | FOLL_LONGTERM, pages);
>   	if (npinned != npages) {
>   		pr_err("SEV: Failure locking %lu pages.\n", npages);
>   		ret = -ENOMEM;


-- 
Cheers,

David / dhildenb


