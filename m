Return-Path: <kvm+bounces-49711-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1464EADCECB
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 16:08:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B6A063AE00D
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 14:04:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3672B224B0E;
	Tue, 17 Jun 2025 14:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="chMDOGdA"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5755156C40
	for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 14:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750169074; cv=none; b=vGUD62RisaEOLzdjAZpYOtzM4gJcg9tNaCliwofGAc909TzYnebA7JP2TJLKdwZxK6QOO7YCTLxS7CQggAwZudUmddbE4LsGDMaT4UmoLxgrchikQxfC4usiP19h9QpP/Q0jQRK3EbqlPHbCx1lXTmZ/yP4l3jfLM3lsAx6ECuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750169074; c=relaxed/simple;
	bh=DacUEIOZ4Wmu05in4HxTw8e4vA4fnDEd6CJhgdYfE6I=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=GoJiRZfzZucVHdgyf+HzdokJzqvPR7jqqNicMXQztaO0/lkBkH0cvZEXmgiJ2RuhO97cMM0iSftkeqdMHb89ctzjClrHB/zAk9xmPZP471qnOHz6I4VFYMAQM84d6x3ECZbDX3UuO90W+T4u9ssRlScaA4lQMjVAWqa/Bxvf+W0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=chMDOGdA; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750169071;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=mvDC1nx99PBAn05PNx0i2guL0ZWIOt26UDKBU6S0cf8=;
	b=chMDOGdApC0AI3xXa7RGA1NUjds7WByt5dpq4PrY5MXI61eLGteYzrOW/ntYFXUNn/WqK9
	+0kuIxB3cR28gLfz3F+nUe+o47Ht0/+JaFhQJpN2mQOnZlXcyMe+TbcyoTiqI7iyHQVmwi
	ln+M7Xfgcm/sLBtgdDuUNP1wLMI2550=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-561-qgKzAgqvOOi34A3lQ5fRRw-1; Tue, 17 Jun 2025 10:04:29 -0400
X-MC-Unique: qgKzAgqvOOi34A3lQ5fRRw-1
X-Mimecast-MFC-AGG-ID: qgKzAgqvOOi34A3lQ5fRRw_1750169068
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-450eaae2934so47457015e9.2
        for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 07:04:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750169068; x=1750773868;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:references:cc:to:from:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=mvDC1nx99PBAn05PNx0i2guL0ZWIOt26UDKBU6S0cf8=;
        b=JXQZleJCPOUsZt5Sk9EFhAF+EqEEGCrUHucQQM26qu5TENlUnZDyt7p4q4zEzUOG4f
         DwrYl52uEmT9Aayvtlyxnab5piuF+jJApzX0vZ3syax1iMYgTNuN5Ds79fgVPD9vAqRO
         9uWj+5RWtf6sn3HtCk6aJUHrMG7MGgkBPfta+vtURrZmKDA3148GcGG5Fr6VU1oGONLz
         qoBcCETDE7NmUYYAdFoipigiW0hLVVtlUrb1eLABTSVy6FfllReqqwCDDgtcU53zF5V/
         YWOytIVTHoaBOJY6DuFVQ48rYHf/rQNF/ZwMcMWCjrDFmhI1BaWiE1iRQ3qX8VfGQpaK
         xs1g==
X-Forwarded-Encrypted: i=1; AJvYcCUaYAO2sQSCrOf9IJyMkB/EiPwhxHM8bWPZ0PxEuTblrdYNqupE7SuXElCSEUHFICXpovk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzf3KeaTMxkeJY8LOehMCN386Ki1APHJMMtQ/zG5Ymvoovv3OMf
	/vtYWYNxi1+A9WN/bGW5Y8dkDm+t2VEZE1o8v6/pUZ0fZ5ywDmIvn1T3DftrC94inTzdWbEIFG5
	6nbf8H5hnxSM3wUI+cgwH71rUO5Ec/QIpVGvzKo+1etjOfkEcAFGn5Q==
X-Gm-Gg: ASbGncvzZbDHxoF4+CakEBn0Ga4CV7ElJaI5Wb/crr3cvSmS3bJ9MppsCxtz4httcrM
	bcMxBQ8ssZsnNqp5eXnGcNfYGOd8f0tgAKmyOx2E71eDQV6PFtj6ygIBlq1uI+6jtHtoYRai3E0
	EOIPahK4sjeXQFY+aZekp5DZ8YQg4mB+BB44nNTB0TWJ9C3oeYQLrTj3eRDscIbK1BQ4mnK6tvE
	1VBHUTumlLgtx58oAn4GvA8aezEwxMwb5hvb/lEPEFl5yNyMXqGe9VwPZ+KdH2LiDywMCyF/vBO
	Z8X7Dqjt4toe/HxKffEP0KlFOcOwaulDCduqfQQ4SJQyz1HEETQ2Vvgl+KmXMbhR1FSzK7CJA9S
	JBAXH/y8yN4ORPUIedW390JY0p4g/fNLpLuWsMv5pgeI70o8=
X-Received: by 2002:a05:600c:4f95:b0:450:d01f:de6f with SMTP id 5b1f17b1804b1-4533ca84626mr152306165e9.15.1750169068055;
        Tue, 17 Jun 2025 07:04:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGWvx+VbLkHVGiv9bP6lMEQVN/ySPOrPeOw2lBtXxzJFFJl30SyEGfTKNbFaHIi3jpkOPlwSw==
X-Received: by 2002:a05:600c:4f95:b0:450:d01f:de6f with SMTP id 5b1f17b1804b1-4533ca84626mr152305495e9.15.1750169067621;
        Tue, 17 Jun 2025 07:04:27 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f31:700:3851:c66a:b6b9:3490? (p200300d82f3107003851c66ab6b93490.dip0.t-ipconnect.de. [2003:d8:2f31:700:3851:c66a:b6b9:3490])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a568b08dfesm14318806f8f.60.2025.06.17.07.04.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Jun 2025 07:04:27 -0700 (PDT)
Message-ID: <ccabb051-e645-4a6c-8357-64a2640289c1@redhat.com>
Date: Tue, 17 Jun 2025 16:04:26 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/3] gup: introduce unpin_user_folio_dirty_locked()
From: David Hildenbrand <david@redhat.com>
To: Jason Gunthorpe <jgg@ziepe.ca>, lizhe.67@bytedance.com
Cc: alex.williamson@redhat.com, akpm@linux-foundation.org, peterx@redhat.com,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20250617041821.85555-1-lizhe.67@bytedance.com>
 <20250617041821.85555-3-lizhe.67@bytedance.com>
 <20250617134251.GA1376515@ziepe.ca>
 <460e16a0-c8d9-493a-b54f-2c793c969eb1@redhat.com>
 <21958961-259f-4520-ae60-e234383945d7@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <21958961-259f-4520-ae60-e234383945d7@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 17.06.25 15:58, David Hildenbrand wrote:
> On 17.06.25 15:45, David Hildenbrand wrote:
>> On 17.06.25 15:42, Jason Gunthorpe wrote:
>>> On Tue, Jun 17, 2025 at 12:18:20PM +0800, lizhe.67@bytedance.com wrote:
>>>
>>>> @@ -360,12 +360,7 @@ void unpin_user_page_range_dirty_lock(struct page *page, unsigned long npages,
>>>>     
>>>>     	for (i = 0; i < npages; i += nr) {
>>>>     		folio = gup_folio_range_next(page, npages, i, &nr);
>>>> -		if (make_dirty && !folio_test_dirty(folio)) {
>>>> -			folio_lock(folio);
>>>> -			folio_mark_dirty(folio);
>>>> -			folio_unlock(folio);
>>>> -		}
>>>> -		gup_put_folio(folio, nr, FOLL_PIN);
>>>> +		unpin_user_folio_dirty_locked(folio, nr, make_dirty);
>>>>     	}
>>>
>>> I don't think we should call an exported function here - this is a
>>> fast path for rdma and iommfd, I don't want to see it degrade to save
>>> three duplicated lines :\
>>
>> Any way to quantify? In theory, the compiler could still optimize this
>> within the same file, no?
> 
> Looking at the compiler output, I think the compile is doing exactly that.
> 
> Unless my obdjump -D -S analysis skills are seriously degraded :)

FWIW, while already looking at this, even before this change, the 
compiler does not inline gup_put_folio() into this function, which is a 
bit unexpected.

-- 
Cheers,

David / dhildenb


