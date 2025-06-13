Return-Path: <kvm+bounces-49470-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 51688AD941B
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 20:03:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F19AA7A4905
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 18:02:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32F9E22A4E4;
	Fri, 13 Jun 2025 18:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AAwFYb5u"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CF6D2E11AE
	for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 18:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749837820; cv=none; b=DwqMWSKyv9GUNXmvcq07paaM47fGGa2DJM5xmWXmg89d2zYZtI01CSPvCYe+/UP0xLW0dcRyp2o1LT1/bcOh8rjWmS8MTr8dq6Dwx0asfg9hbeu6GDPpcK+/FGp6RmK7To4NoOjJlu2MSrwhcO2e67un6P95VrdR8zu+56BBPAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749837820; c=relaxed/simple;
	bh=lUzYWX0lBAeEtAaFZUQ6oIlkXeRiV8SIm+Ni8yl0P0E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EDLSohk3czHVsGQINk9b98lJYPM8zqcy1Hj/1tw9FjUiaVYwqIVCbZ/ULot4pDNUr2RD0nOKVd81SYerbsKzK6QdVFjjM+3t1zPosN2BsCw7brt6E9G/l0WDmNY/rYMzLU1JWRF7iYZSKZFDc6kpG/EpK1hXNdpPaLhtOQ89j78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AAwFYb5u; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749837817;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=79I1KegLonJWLXA6E4oFESSeqtDoq+GzCz9tCBGcgug=;
	b=AAwFYb5ucCgDNlKevRWaK0+zI2nCkK/NMlnOHcClKYBStdTl93M/Ojr91ziQR2cVQSDxCH
	7Q7a0aA2eUXqv9tOSG50GRvTi2NyM0StSBHx5LyHOVzpfvY8FNAf/9zUwnY7sh6VcC9XkK
	UngZNN9EiStxUFzK69URkkDO65rdUpM=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-28-55yK6bMPPdimcVQdybvCKg-1; Fri, 13 Jun 2025 14:03:36 -0400
X-MC-Unique: 55yK6bMPPdimcVQdybvCKg-1
X-Mimecast-MFC-AGG-ID: 55yK6bMPPdimcVQdybvCKg_1749837815
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3a4e6d426b1so2185786f8f.1
        for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 11:03:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749837815; x=1750442615;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=79I1KegLonJWLXA6E4oFESSeqtDoq+GzCz9tCBGcgug=;
        b=L+g9sUbPJRpr5hE4xTUfZTpeZRDhmltEQaj+lRPRB16A+zOkPwCD9TN/xF2Nf+/WNp
         s+PHYxaR///bO+dI/6i8NapQXJXnZtHozajB4p0m8x4HX6C/Cf6zJQ6I8z2KpRy2X436
         8DykF+nElBq7SnnIHMzMIlJiRII56AiRhSCoN/gOdU1Fxx63mIcR38dYvBNcSYeWBNue
         fOVV4Ccd1BMX0oGHP/YaeQ/uZ4zu6mExkwUJB8SBlg22mR168pSVoqh3ylrBZAqNASu/
         2MP7OUa2Sqmpe755CW04HojEKChL5pFx8O6cE9kK05SE4kleeSvjiir6B9lFN6IYluW/
         BRcw==
X-Forwarded-Encrypted: i=1; AJvYcCVN3efh/j8cx2aSd0nXsgxT7E+uCmHBjPayIrHoZhBohTvI3gUkKzTiqIcGxavEd6f50sk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwB53NT31KT4hKVh4+Qd3rq33WQoN34b0L1C7M/yQJD69UrU5pO
	z9bYzGzwp5CaCZIF/wLY2EuVU95MNY5YLpQDUn4p1K4FS/s2iyPauxe9cte60lQA11dEk3Ia1Oe
	TfxOeya2nCHrYdg/bUY+/dBx10g82w+1CrYf2T2x78g5r+TnyixTgiA==
X-Gm-Gg: ASbGncvzHBhSkXRqeVSQ158PmOWvIwfqPlkxtuz5vguFvvMoycml+NJwABtO8j6Tr4K
	bzvZLYvsaCqJoVgCeSVo6qsNOIY9NVxzPOHHoi2nmJ0WtBW/6UlMXC5NCO8stCx02a3vOHJVD0y
	pL9nWE7JA7vPTwjmyziyYPCEbDpXyszViCm05vaoeRfgLOq02KTeY9Q0Zgt0unutNZ2ydy60Nax
	WcPHhhDE88Xg4P4CpAVK9SpA3pzFSu1L6RE0YZJ2J/NNhkuFKRAYXwMI4EzCEMcGf0YQjsSLPeA
	LgpM+s8z7c9VDMbClHGProzoqFk9ADiBo9xzVZM2E4yG9pB2cC36f0ss+5MeTu/tHTDrphPI8f7
	F5d5jwyVVEJjOVmG47w6juSnUx2MrmkG/E8KAetF4oWP1fVSE2w==
X-Received: by 2002:a05:6000:2388:b0:3a4:f722:a46b with SMTP id ffacd0b85a97d-3a56d821c74mr2112092f8f.15.1749837814808;
        Fri, 13 Jun 2025 11:03:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHIHhTBNt9jXJgHdybTrkLcIGOh9GI1Gf9Iq/2M2YgSQjLOHfZjHQiIlPOGen1z+iahVsRtJA==
X-Received: by 2002:a05:6000:2388:b0:3a4:f722:a46b with SMTP id ffacd0b85a97d-3a56d821c74mr2112063f8f.15.1749837814452;
        Fri, 13 Jun 2025 11:03:34 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f1a:3700:2982:b5f7:a04e:4cb4? (p200300d82f1a37002982b5f7a04e4cb4.dip0.t-ipconnect.de. [2003:d8:2f1a:3700:2982:b5f7:a04e:4cb4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a568b09148sm3100825f8f.58.2025.06.13.11.03.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Jun 2025 11:03:33 -0700 (PDT)
Message-ID: <a47f33d3-fe50-4e4e-871b-bddc99a27264@redhat.com>
Date: Fri, 13 Jun 2025 20:03:32 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/5] vfio: Introduce vfio_device_ops.get_unmapped_area
 hook
To: Peter Xu <peterx@redhat.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, kvm@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Alex Williamson <alex.williamson@redhat.com>, Zi Yan <ziy@nvidia.com>,
 Jason Gunthorpe <jgg@nvidia.com>, Alex Mastro <amastro@fb.com>,
 Nico Pache <npache@redhat.com>
References: <20250613134111.469884-1-peterx@redhat.com>
 <20250613134111.469884-5-peterx@redhat.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20250613134111.469884-5-peterx@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 13.06.25 15:41, Peter Xu wrote:
> Add a hook to vfio_device_ops to allow sub-modules provide virtual
> addresses for an mmap() request.
> 
> Note that the fallback will be mm_get_unmapped_area(), which should
> maintain the old behavior of generic VA allocation (__get_unmapped_area).
> It's a bit unfortunate that is needed, as the current get_unmapped_area()
> file ops cannot support a retval which fallbacks to the default.  So that
> is needed both here and whenever sub-module will opt-in with its own.
> 
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb


