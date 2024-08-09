Return-Path: <kvm+bounces-23733-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 31F1E94D4C9
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 18:35:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A93461F21895
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 16:35:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABFFC20328;
	Fri,  9 Aug 2024 16:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AVq1c0sZ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CCF41BC3C
	for <kvm@vger.kernel.org>; Fri,  9 Aug 2024 16:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723221307; cv=none; b=fdVb4oIufa2Nxn9FP3GxbUBUTpY/XK++wL34uZWIaXI+Y62GdOM4r7IP81SYe4dFRkmHzcEXFslVAKjgC6jYvcyYTy9Rbnd+Y/hrsMGBoG+FhZq5ebbbYDWkBReXRaeS+glCqCWKuU5LREyLKK6EB2ZMoDoUwfVwBCGdRmamx4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723221307; c=relaxed/simple;
	bh=CahP0HVW+6P+siKyiXRrLdWO2oPpLLJeFf+XO5gRLHw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=o5q9H+Lk9LzmehRcVM758B4whKaajanZS37WgNxp1m6BHo02MPcsWY8C9dbe/RsM5CJINfpNDrF37H6s2dJI29CV6uT2yY/kUhda884IzzvNiMosxxX5zzKqp3/3fPlMRKP8Vs1PSTLbrzf3o3h+6ZABdpf16qonNwlAg/NOiLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AVq1c0sZ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723221305;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=FYhELWK2NszWgjvOtZarLiZNjUr2Rqg7Aan/+nzPXhQ=;
	b=AVq1c0sZEVVEN8Q/PluNPIlIj7z3yaGW7NEg7wkv0QZsMeM9ff8TiJNTeV+4rnCHEWaGHm
	BCusaI/NL3EOom48sSkHhD5AG9heOMBcq1JolAHs3I5geoZkrzhNUNG30rik/xmU3GSC8W
	vhjnnhD37wRPCUGoknJfd2IPy/dkaUs=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-319-Wwbh_-KtOm68m9kZt4Kb6Q-1; Fri, 09 Aug 2024 12:35:00 -0400
X-MC-Unique: Wwbh_-KtOm68m9kZt4Kb6Q-1
Received: by mail-lj1-f199.google.com with SMTP id 38308e7fff4ca-2ef2018bb2dso23398881fa.0
        for <kvm@vger.kernel.org>; Fri, 09 Aug 2024 09:34:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723221298; x=1723826098;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=FYhELWK2NszWgjvOtZarLiZNjUr2Rqg7Aan/+nzPXhQ=;
        b=AViu1v7UphaprXtv2CoYANy0ltvWt3kFyOjLRyHGgdA0dwxME8Ajrw090bzdQ44peZ
         Hpw2a0JLNRnsiLiL/tnOtCPdpN9u0UCgV2LxF6ddv+pdfKWW4Fux7CaIC1wbae6NJucj
         Vf2A1gTwvU0gHFZDfPzvVbjZPp3oT0GkIcVAE9uAuMWhMR8FSzBNvsd1TDMWQHOPRsBg
         82zaBqdf0viuUmhQLAoUmZvablvfi6U+9ZNcdr2mTlp/CNyhy6nMEDBDksJN07epoyK3
         NUgZtIlVW1iOCJAtDDxzgVFihOWHmVMc54i1itLOu24CkCg9GhTbUlUcO2nSpvEwX3j3
         PreA==
X-Forwarded-Encrypted: i=1; AJvYcCXtQdsS29VSrkQsJlMEX+4iKzUvaT587wQLgM0ELS1blf50p/QA017ON4eNVBQHXIdcO+UOc1d/xWKButvYsWGcnpuN
X-Gm-Message-State: AOJu0YyWjicv/yWE5fiZWUWuqIVRMqDKzid6RDjkOU2s1lojNPhx0DWY
	nlUHKd+jo+0S7jaHjCReazBn3IvbCi41uxGpWcSyJ9YIMB6YQDXaRbHyvgW+iD+G1fGQxoeQjxd
	JnMpX/HvbfrUqn1iYZwWSKNSdTZppoQjQB1Cm/oXbot3DZUEYgA==
X-Received: by 2002:a05:651c:543:b0:2ef:22ef:a24e with SMTP id 38308e7fff4ca-2f1a6d021acmr19154271fa.10.1723221298371;
        Fri, 09 Aug 2024 09:34:58 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHXWH42bCHjyK57IZI2qpxoxwMfVNosteypxQpvfsXkae1B7hvkEnyUY+Oo/OAtp5Bz9ZbtBg==
X-Received: by 2002:a05:651c:543:b0:2ef:22ef:a24e with SMTP id 38308e7fff4ca-2f1a6d021acmr19154031fa.10.1723221297806;
        Fri, 09 Aug 2024 09:34:57 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f09:3f00:d228:bd67:7baa:d604? (p200300d82f093f00d228bd677baad604.dip0.t-ipconnect.de. [2003:d8:2f09:3f00:d228:bd67:7baa:d604])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-36d2716caadsm5733049f8f.39.2024.08.09.09.34.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Aug 2024 09:34:56 -0700 (PDT)
Message-ID: <b7aa9bbc-d8df-43fb-9920-160835713c24@redhat.com>
Date: Fri, 9 Aug 2024 18:34:55 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/19] mm: Drop is_huge_zero_pud()
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
 Alex Williamson <alex.williamson@redhat.com>, Yan Zhao
 <yan.y.zhao@intel.com>, Matthew Wilcox <willy@infradead.org>,
 "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>
References: <20240809160909.1023470-1-peterx@redhat.com>
 <20240809160909.1023470-3-peterx@redhat.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20240809160909.1023470-3-peterx@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 09.08.24 18:08, Peter Xu wrote:
> It constantly returns false since 2017.  One assertion is added in 2019 but
> it should never have triggered, IOW it means what is checked should be
> asserted instead.
> 
> If it didn't exist for 7 years maybe it's good idea to remove it and only
> add it when it comes.
> 
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---

Out with it

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb


