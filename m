Return-Path: <kvm+bounces-23731-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2ACA694D4BD
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 18:33:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 618E0B213A3
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 16:33:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A90A22EE3;
	Fri,  9 Aug 2024 16:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VZrPl5Iz"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EEDC1CAAC
	for <kvm@vger.kernel.org>; Fri,  9 Aug 2024 16:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723221172; cv=none; b=EeLqN4570d7aPRg2RjgyJi9y7vdBKnlPJ+E+u6/+pXAC9BmXf8ixa7fCgctKicRe1LXH7CYWvWkK5zeZz/ivdfpjhVRnteYhSC8Jk9rEqKZBHk0u8V5A1GN3nteVZW0T0zmZsE10delSo3P6YEPSAL6SWMMbP7obT68iRfittQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723221172; c=relaxed/simple;
	bh=vjvsfUnjsIhx7IUnN7Dd1CZDmeqX9h+3NJyzpxeVQV8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LSFBFQ4VeNxFHiZDIDT+gUk2gzOJBBEA8cudwnWE6eyFzg6jz7QWOjoxAPlH22s2+2tzYLtHevUIru/ohqi4OLRLmwGcOBWWMlj/xB+SIH10EWhz9VBNDd3UXVFK+lE/7Xj4uRD4Aq2TB3XSLR0E3TtkthfK48e5nv8mWaTBGl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VZrPl5Iz; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723221169;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=bK+Xr49cXd8swczor/eh9sQ26QqtTpeLaJrkqjusW/4=;
	b=VZrPl5IzAsd00vGcWUcdC4dt+0poGmKdTIQWyR2irIefqOysVsEMyHFOZY0aLUmTf6WlZc
	OXA/bbf6KhvB3j4sqxQvoy8Up3H8zFX/50tnavvfWP9h5AeD5mqX3KunMCaEB8KYEjLUj4
	z4o/U2cYrCU9gp0ctTSdnvW9y3+oDe8=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-166-d6K7kn7zOt2cJDBAsTSXsA-1; Fri, 09 Aug 2024 12:32:48 -0400
X-MC-Unique: d6K7kn7zOt2cJDBAsTSXsA-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4281b7196bbso17252025e9.0
        for <kvm@vger.kernel.org>; Fri, 09 Aug 2024 09:32:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723221167; x=1723825967;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=bK+Xr49cXd8swczor/eh9sQ26QqtTpeLaJrkqjusW/4=;
        b=D4n+8jjAeK7v2mOiUOSj12D2wFUWVmjvZBSgIXnY1OwlboeR3D/jRaUAurYd7BzyUY
         wBX965+Wi1j2N/pKefbf/Co99gU06uvmd0ylRU05eLQucqNYtaGD9u6NqWYamIOBkZPJ
         vL0uoExP8P+jmN0Ss1ValXzTx/YnnH8tGctYyq4Qzt7fywyfQGI1tzbwN08lAcg5wfjn
         3LP0jSzC3EKCEKGyQ0yM27Az21KZqUm0ttNh+g3FjHETv79J785IBMVr6+nBNnX/q3dJ
         zUIw8SuYKR1le/PkpUZIONSf8UnC41WCWaSG4EVvy68A6tBEIRWB1BYb1oIVREqKV8IM
         DNnA==
X-Forwarded-Encrypted: i=1; AJvYcCXtL9W1XI9yClzf19IMWovMdXDMGd2CNOkdZagCc4UH8XVFcA4R2I/++WzXZunaazM/IGQn0PO/TNK2W1czoWIVyV6+
X-Gm-Message-State: AOJu0YyCkCgcmRPBzRjgx70qV3Uj6pmlGpT/FyqcZ1x+e+D2sNyeDsSy
	+N9pLrReLIDsMqng2HfRSDD+8N3VBRCkeE/I+nQiEO+nklWPXUn+4k3J388cUgKoevADLQb4FZs
	cybQgcgeXAotmF9SPbiySZR3izdlv2cwKTeCz0KcP1QmYkRGIQw==
X-Received: by 2002:a05:600c:5021:b0:427:9dad:e6ac with SMTP id 5b1f17b1804b1-429c3a56a5bmr15279975e9.34.1723221167468;
        Fri, 09 Aug 2024 09:32:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEDPoHMlDuTu1+qt6uPaOVEQnwg/1Il3GOa+4ekoO8nXGxI5KxFdFLdXsV2shJcGeMxkm6x4g==
X-Received: by 2002:a05:600c:5021:b0:427:9dad:e6ac with SMTP id 5b1f17b1804b1-429c3a56a5bmr15279825e9.34.1723221166950;
        Fri, 09 Aug 2024 09:32:46 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f09:3f00:d228:bd67:7baa:d604? (p200300d82f093f00d228bd677baad604.dip0.t-ipconnect.de. [2003:d8:2f09:3f00:d228:bd67:7baa:d604])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-429059d040fsm125413585e9.46.2024.08.09.09.32.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Aug 2024 09:32:45 -0700 (PDT)
Message-ID: <d7fcec73-16f6-4d54-b334-6450a29e0a1d@redhat.com>
Date: Fri, 9 Aug 2024 18:32:44 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/19] mm/fork: Accept huge pfnmap entries
To: Peter Xu <peterx@redhat.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>,
 Oscar Salvador <osalvador@suse.de>, Jason Gunthorpe <jgg@nvidia.com>,
 Axel Rasmussen <axelrasmussen@google.com>,
 linux-arm-kernel@lists.infradead.org, x86@kernel.org,
 Will Deacon <will@kernel.org>, Gavin Shan <gshan@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Zi Yan <ziy@nvidia.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Ingo Molnar <mingo@redhat.com>,
 Alistair Popple <apopple@nvidia.com>, Borislav Petkov <bp@alien8.de>,
 Thomas Gleixner <tglx@linutronix.de>, kvm@vger.kernel.org,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Alex Williamson <alex.williamson@redhat.com>, Yan Zhao <yan.y.zhao@intel.com>
References: <20240809160909.1023470-1-peterx@redhat.com>
 <20240809160909.1023470-8-peterx@redhat.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20240809160909.1023470-8-peterx@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 09.08.24 18:08, Peter Xu wrote:
> Teach the fork code to properly copy pfnmaps for pmd/pud levels.  Pud is
> much easier, the write bit needs to be persisted though for writable and
> shared pud mappings like PFNMAP ones, otherwise a follow up write in either
> parent or child process will trigger a write fault.
> 
> Do the same for pmd level.
> 
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>   mm/huge_memory.c | 27 ++++++++++++++++++++++++---
>   1 file changed, 24 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 6568586b21ab..015c9468eed5 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -1375,6 +1375,22 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
>   	pgtable_t pgtable = NULL;
>   	int ret = -ENOMEM;
>   
> +	pmd = pmdp_get_lockless(src_pmd);
> +	if (unlikely(pmd_special(pmd))) {
> +		dst_ptl = pmd_lock(dst_mm, dst_pmd);
> +		src_ptl = pmd_lockptr(src_mm, src_pmd);
> +		spin_lock_nested(src_ptl, SINGLE_DEPTH_NESTING);
> +		/*
> +		 * No need to recheck the pmd, it can't change with write
> +		 * mmap lock held here.
> +		 */
> +		if (is_cow_mapping(src_vma->vm_flags) && pmd_write(pmd)) {
> +			pmdp_set_wrprotect(src_mm, addr, src_pmd);
> +			pmd = pmd_wrprotect(pmd);
> +		}
> +		goto set_pmd;
> +	}
> +

I strongly assume we should be using using vm_normal_page_pmd() instead 
of pmd_page() further below. pmd_special() should be mostly limited to 
GUP-fast and vm_normal_page_pmd().

Again, we should be doing this similar to how we handle PTEs.

I'm a bit confused about the "unlikely(!pmd_trans_huge(pmd)" check, 
below: what else should we have here if it's not a migration entry but a 
present entry?

Likely this function needs a bit of rework.

-- 
Cheers,

David / dhildenb


