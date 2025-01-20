Return-Path: <kvm+bounces-36005-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 30097A16C9E
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 13:57:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A7ECB18896D0
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 12:57:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12DAE1E0DB5;
	Mon, 20 Jan 2025 12:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fSattvrZ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B290A1FC8
	for <kvm@vger.kernel.org>; Mon, 20 Jan 2025 12:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737377864; cv=none; b=Gy/4s9Pp4JYQfIknCQcSxORCqkxups52WqLYeE+dR3COMqlNRLLvmgtGGqXlJd89r+QP342lu3ocEAvoBqHDzOehQwQA+9Y0gejgW7T1GwnHtf0nY3nK5h+XScs3/EhJSMxYRY77CHI814gYSMrg/ElNdgdBaT/1a9yFVzVXt88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737377864; c=relaxed/simple;
	bh=OW81Y8gr3eBCJQQBdHJrzKhBykql9njNInjLwFSNtE8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CGjZjURTIpQOGW1yv4zYSM54Fgql6S/nMSYHEk/AJf0j/fcDLmBCdxRywUDyyUHSXsiAGwMBD95C6FmRFMzRWrevFhe3nHQJDAIDioO6VtlZk3YctVQbMqY0dsor5NJBFMYkTbmVrIPKcrAXND3k11qVRT67DOaTFUCnCu9ioHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fSattvrZ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737377861;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=bhtIEjiXM7eM431n4JWfAYhNrIgk6eKvoLYA6yBhI+E=;
	b=fSattvrZkxchuo00OZOMi+Cs0VNIbS7aJNEqPLqSEznEuYpFGzsV09E+aNdzKs0U6yMCdS
	lJsto9qF+4XowvTkSFTwbGryfKZcoNNkQaIn+gC1WNMQ//+QdWaB108EiIz9H+UCyTDTvX
	MVzamufX7JI5gEPe7DDB2IDEjZCDFe0=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-271-m0jYNmUWNA-SSEZtL6La9Q-1; Mon, 20 Jan 2025 07:57:40 -0500
X-MC-Unique: m0jYNmUWNA-SSEZtL6La9Q-1
X-Mimecast-MFC-AGG-ID: m0jYNmUWNA-SSEZtL6La9Q
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-43626224274so24074565e9.0
        for <kvm@vger.kernel.org>; Mon, 20 Jan 2025 04:57:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737377859; x=1737982659;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=bhtIEjiXM7eM431n4JWfAYhNrIgk6eKvoLYA6yBhI+E=;
        b=nn90qpXFNEAL8nOhWNZ+zeNf1RmBRgwG+wSMPNDEgrfnkuB954j/1R3LoDqRR48YOd
         W9YeQ9eJ99doeELh2/qgPpgg8LWHnawuwsbMHlGw3TxQAZYb8L0K5zuBtXSBib5sk0Je
         ODv0SLkVl2DwtA3Ze3Gabr1VyzhVpNAi0jTHjK6QEbg+RHER7sWintrlMkxqxUmM14wI
         QGv2f6rgbI0JWixvdkdcKprBPkM5DMM7t2I3brJq2qkCbx/pPegBJ0sk17A6JpMtE6xy
         cT+4Eq6vlLjuO6gveUfIcfhik+1pk6gE+ct5XxeUx6CCYNLnUUF0mtBdhYoxUKfBPvMm
         0/DQ==
X-Forwarded-Encrypted: i=1; AJvYcCX6YgUbFwVjQBR7PHrvekNkdXDu8r21k/pu8F+7bXXGK7gaM6D+qxZNV9nXz+DePr/OE7M=@vger.kernel.org
X-Gm-Message-State: AOJu0YxMKOlxtcGfWPy0PCkVM9dAXMooNRYbHfw709UWihr4PsuCm4/T
	oaxKyAAnRw56e4gIllAzwaOLz7inZwlWXDNOOsBDB2sAa2M7wIIXh91koD4ID6p9IC8ZvHpKG5Q
	yZHIn8Rwo87VvOsswuZgZEKAEhuMxPCwOjMGY3PralPoQMfVLIw==
X-Gm-Gg: ASbGncsrKYFjwkB8JNBdLb0IC9wfdNytlKSzAY/WdO/AwUxXWP4G+xlt745C5Mt0q7w
	Wqcm2/XXkrCRYDzce6PuGDts8oUmjJwRoiOjgiJE1MXf2ZiXIoFCTERxBZ9Gb3KntUqGpDo3ZJO
	TcpDY7S/NLRleETPDQDzJBWkq0stZNlfcwVlv2/J60k6WFBzmIZPYUB0U/h+PskwzwaUonwb5Uu
	/fDGQWtJFFOzaT/R+dbmxR/v8xf/fF4BM0UR9m4Pk+XLw+fnrM51gJs1ODjrumPX7scxYLgN/uQ
	iwBnrZEga1aZdJQdmF7w0JzChBjCIi99Lkq7GhZ8eQbVP2aHgGCJHTRuSPKIgjUqAgT4Ln4d68m
	JasYx/KVwnvwfCS26GDZyUQ==
X-Received: by 2002:a05:600c:1389:b0:431:52f5:f48d with SMTP id 5b1f17b1804b1-43891460bbemr131850135e9.31.1737377859184;
        Mon, 20 Jan 2025 04:57:39 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGCTvH7pnGlLhs7qtg/SAdYcdsf/0fmbuxmG7uz7LfAw+7zvgJ51Tk0ktHwaQlJJxj39s/Cwg==
X-Received: by 2002:a05:600c:1389:b0:431:52f5:f48d with SMTP id 5b1f17b1804b1-43891460bbemr131849865e9.31.1737377858846;
        Mon, 20 Jan 2025 04:57:38 -0800 (PST)
Received: from ?IPV6:2003:d8:2f22:1000:d72d:fd5f:4118:c70b? (p200300d82f221000d72dfd5f4118c70b.dip0.t-ipconnect.de. [2003:d8:2f22:1000:d72d:fd5f:4118:c70b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4389041f7e9sm141012385e9.23.2025.01.20.04.57.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Jan 2025 04:57:37 -0800 (PST)
Message-ID: <cc3428b1-22b7-432a-9c74-12b7e36b6cc6@redhat.com>
Date: Mon, 20 Jan 2025 13:57:36 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/7] Enable shared device assignment
To: Jason Gunthorpe <jgg@nvidia.com>, Alexey Kardashevskiy <aik@amd.com>
Cc: Chenyi Qiang <chenyi.qiang@intel.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Michael Roth <michael.roth@amd.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org, Williams Dan J <dan.j.williams@intel.com>,
 Peng Chao P <chao.p.peng@intel.com>, Gao Chao <chao.gao@intel.com>,
 Xu Yilun <yilun.xu@intel.com>
References: <8f953ffc-6408-4546-a439-d11354b26665@intel.com>
 <d4b57eb8-03f1-40f3-bc7a-23b24294e3d7@amd.com>
 <57a3869d-f3d1-4125-aaa5-e529fb659421@intel.com>
 <008bfbf2-3ea4-4e6c-ad0d-91655cdfc4e8@amd.com>
 <1361f0b4-ddf8-4a83-ba21-b68321d921da@intel.com>
 <c318c89b-967d-456e-ade1-3a8cacb21bd7@redhat.com>
 <20250110132021.GE5556@nvidia.com>
 <17db435a-8eca-4132-8481-34a6b0e986cb@redhat.com>
 <20250110141401.GG5556@nvidia.com>
 <9d925eaa-ba32-41f4-8845-448d26cef4c7@amd.com>
 <20250115124933.GL5556@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20250115124933.GL5556@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 15.01.25 13:49, Jason Gunthorpe wrote:
> On Wed, Jan 15, 2025 at 02:39:55PM +1100, Alexey Kardashevskiy wrote:
>>> The thread was talking about the built-in support in iommufd to split
>>> mappings.
>>
>> Just to clarify - I am talking about splitting only "iommufd areas", not
>> large pages.
> 
> In generality it is the same thing as you cannot generally guarantee
> that an area split doesn't also cross a large page.
> 
>> If all IOMMU PTEs are 4k and areas are bigger than 4K => the hw
>> support is not needed to allow splitting. The comments above and below seem
>> to confuse large pages with large areas (well, I am consufed, at least).
> 
> Yes, in that special case yes.
> 
>>> That built-in support is only accessible through legacy APIs
>>> and should never be used in new qemu code. To use that built in
>>> support in new code we need to build new APIs.
>>
>> Why would not IOMMU_IOAS_MAP/UNMAP uAPI work? Thanks,
> 
> I don't want to overload those APIs, I prefer to see a new API that is
> just about splitting areas. Splitting is a special operation that can
> fail depending on driver support.

So we'd just always perform a split-before-unmap. If split fails, we're 
in trouble, just like we would be when unmap would fail.

If the split succeeded, the unmap will succeed *and* be atomic.

That sounds reasonable to me and virtio-mem could benefit from that as well.

-- 
Cheers,

David / dhildenb


