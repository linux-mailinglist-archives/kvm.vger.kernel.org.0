Return-Path: <kvm+bounces-49468-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 68CD2AD940E
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 20:00:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D27953B9F39
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 18:00:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DF3922A4E4;
	Fri, 13 Jun 2025 18:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="H5Ha3C38"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C99313D3B8
	for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 18:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749837621; cv=none; b=G2WePp8wdzejhvIuuPwW2jQnhd0CbSbI71sBGWSV+RZ13wQ7nbrg2niZhiWxazwslsPlLCWoguphFKvRUFK/Jq6jNNSBCBxr3Z8REJ3h/choa9PP9pfpvq3MiopEjf644cP8PExgc5CSXhkCdvsK74nnjZ8Qx/X13+tEVxUyh18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749837621; c=relaxed/simple;
	bh=d/oVTXsnKugsuOGjJtUGceEMllHBI7H44e+eSlRJBrw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PfyBvAEXUBQZqCvgkke6Fc7YmFKRE0KWuU02o61EaGbQ8v4tZGjBGkTo71z7OoYG42xiUkXmQgwQ8MkEkSC+HWw8dFWjylV+1jqgocz3sKL0yerO5P/sf3lrMi5JH1xdviVgNSuejrr2z5kj9bVT2fYlK4vCoxqiSA6lP1aeE2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=H5Ha3C38; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749837618;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=2aIKNMIdIuo1UCAdxylRa1DqGXWwEsMVAaI0AuMZvVs=;
	b=H5Ha3C38ExuvTGw2F7Y/6l1iDvCCgeOwCjS6PH+L5Ys7Y/TGKMTRFGTIAjcQAh+znANLZD
	NbE5hnT+4wASRXv4vUn8WVf8Ixx3n+fC14mn1NnWKQmbwgR/5N4QRWlXyXbtn+/hlKWeh4
	Fvrg1Q9vpVDmXupf3gmCbdu6Ab6ACgk=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-688-PWNn0EDMN4-Dn15EL1Mt9A-1; Fri, 13 Jun 2025 14:00:17 -0400
X-MC-Unique: PWNn0EDMN4-Dn15EL1Mt9A-1
X-Mimecast-MFC-AGG-ID: PWNn0EDMN4-Dn15EL1Mt9A_1749837616
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-450787c8626so18092515e9.1
        for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 11:00:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749837616; x=1750442416;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=2aIKNMIdIuo1UCAdxylRa1DqGXWwEsMVAaI0AuMZvVs=;
        b=U5Wzay8M9SqbfugHg5N3qhvFJIfdGYrKlN9usdUpS+iUUgeCv3uIDKTTjF39NtFG2S
         Ii//9bjpIf1Xr8kUPhBR5aHtn66D/XW+JqOEBJal4RiZ+7h77nI5G8Ue+F6k0V6dhQ4t
         a+n7NqEkxpJSAvCC5x3M6+sWHuDiMpkAijipdxTR59MxzqjE6pUmK/csZCf6BBYrRBnO
         5gzOKIEWMfllSHRTCoKheUEvLIIzFc4xE2hJhoJJRWE7ZSphzKeOvYbRtuJ0291I8Fot
         zBtcyZoOMRl4WrsiHFXyWu39uvUXeQluLhn/0MOITQihav7tAVW5mWDGhye882VYxye1
         ytJA==
X-Forwarded-Encrypted: i=1; AJvYcCVYkgwXYapNSpYRrE9ndu3KrKwDg6D6O7T1s3ucPoshNwyNCztkWapHp9qDJkM9WnhbNiw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwiXGt5R4cq/VTIvM6z2a1bQsyTOzzDktc0lduCLREeZz6Eghv0
	mtGWYm6bPQ0z2b2j0UHJkNhnppNm2RoMdSnpDQkV/p/xuPHjCzWxPSFAGXypwF8GqpE5P2egYqD
	HOILpBqkvktcGQGxSteNiP8hncEv1o4g8U/T7AdRCRorunCDANUV2sA==
X-Gm-Gg: ASbGncsCOsgmWlf0vZMC856kefWZp1Y0TAbIjhr2Sf1NB8mXLnwOCKMJa3aNV4Qw/Oo
	Cn2VUDE5W7AfnupYqcmM3GOQNrkTatBL4YhIW4j+a4nBL7FkjtTQ4UjQP+9ttOa2fGlr9pz34sM
	bchRiX9W1zwF2nB8PU9eWoW8KCXst5H7ByG9QWurZ4iCp9rFLO3owZiwmuJX2If4yzwNTjsru8R
	p4zQF2I5ph5/ifCOKApEwfLLbMUAp794Zyb0TLqBPF5ljqfqP31Z/DBWnynz/vtDM17ybezwuoh
	Lj8vHzuF8x4i4/jN/Sa2lST3Ui3NanInq64ceaaP+TOn6T/0+oMdRv06rbeDsnk1rQvRFh5AtAM
	WODEMwr+dkpc3+1kGoF47T8HOQcpw3X5T6v1mhYGHuNK2w0fTpA==
X-Received: by 2002:a05:600c:3e17:b0:448:e8c0:c778 with SMTP id 5b1f17b1804b1-4533cb4948bmr4746265e9.22.1749837616023;
        Fri, 13 Jun 2025 11:00:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGvbMEemipJF0MHDHTjrDKPJbj60ZNEib57qRrY66hYJiTMjPfY9MiRRAWvY1wgI/IveevRyg==
X-Received: by 2002:a05:600c:3e17:b0:448:e8c0:c778 with SMTP id 5b1f17b1804b1-4533cb4948bmr4745995e9.22.1749837615611;
        Fri, 13 Jun 2025 11:00:15 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f1a:3700:2982:b5f7:a04e:4cb4? (p200300d82f1a37002982b5f7a04e4cb4.dip0.t-ipconnect.de. [2003:d8:2f1a:3700:2982:b5f7:a04e:4cb4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a568a73966sm3051956f8f.34.2025.06.13.11.00.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Jun 2025 11:00:15 -0700 (PDT)
Message-ID: <a3860fb3-bd98-4e7f-b246-c92ecff1181b@redhat.com>
Date: Fri, 13 Jun 2025 20:00:13 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/5] mm: Deduplicate mm_get_unmapped_area()
To: Peter Xu <peterx@redhat.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, kvm@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Alex Williamson <alex.williamson@redhat.com>, Zi Yan <ziy@nvidia.com>,
 Jason Gunthorpe <jgg@nvidia.com>, Alex Mastro <amastro@fb.com>,
 Nico Pache <npache@redhat.com>
References: <20250613134111.469884-1-peterx@redhat.com>
 <20250613134111.469884-2-peterx@redhat.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20250613134111.469884-2-peterx@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 13.06.25 15:41, Peter Xu wrote:
> Essentially it sets vm_flags==0 for mm_get_unmapped_area_vmflags().  Use
> the helper instead to dedup the lines.
> 
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb


