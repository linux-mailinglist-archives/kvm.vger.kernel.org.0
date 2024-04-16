Return-Path: <kvm+bounces-14728-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 14C798A6479
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 09:05:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BFA1628162B
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 07:05:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E79F878C68;
	Tue, 16 Apr 2024 07:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fyKjcNKm"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6641638FA1
	for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 07:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713251124; cv=none; b=azo/7kv9mSrc6HMs/pHzApGP+hiTJeXm5VBX1q6WNiv2cTrTOq+2cCNpfHSQY2COxOXeKuv/PyOjIGEsAivOwq6x41s0CCy85aQH1AbnKMomVwNrQhrw+24XEGxdqzu+OjyAWn26NuLQDaft7lJiOV0YnoeaGl4QFCZzaKF3//o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713251124; c=relaxed/simple;
	bh=MqLir6tbjPl4KI0Qo1IvoTUeFmCQzTEfmXPD+OQH28U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=n5pWCPGQBPERNEPAEPRhej5HtTHouqRJUJJj3P5cnuj8tba95XIUUk6drsnoSLjiQIrfUQX+H7cM5n1OROrDdTM8I5p26wrBOceSWWyhN9stS7nTk6Q49i78v/FVh3fMR76w70nOYyQG2Tx0EqQ6ItmI7EVpIJotBYpWIsKR7KA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fyKjcNKm; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713251121;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Tz4KEvhtCmHEGUIA0vxbxLx7rkho8goMm8gMGcPPPuk=;
	b=fyKjcNKmXPbIJbBEicrYrF14MmJIrAzYcDXar8lV9ktuJE26f75f6Z7KQAL5G0euvN+iAQ
	ylkcsvQLxUakpEjkDvt1/qjdQ2DQSSACYCn9mXos0kzHlCs8xoHgmkiAhMN4km3qPo6u8e
	e23oYq1SIrXp/XAl46eoHlV+NZIBxhQ=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-5-NRPN6jHFMw29qy_TV4988w-1; Tue, 16 Apr 2024 03:05:17 -0400
X-MC-Unique: NRPN6jHFMw29qy_TV4988w-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-41663c713b7so24443655e9.0
        for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 00:05:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713251116; x=1713855916;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Tz4KEvhtCmHEGUIA0vxbxLx7rkho8goMm8gMGcPPPuk=;
        b=FsjMrWJaJoKIHBCOOkoYMwVvdro9x47XLgx6TfY03Cskz8yy7hU3swnhml6I/2z57S
         glSlNETR8pKhNGspb+BfSsIrOJ2ut9tmELWcqoXXVYDl9Rm1UhNa67Tf+VzDg9d7jIw+
         mVl+sWZAzuFg7cV9eU5XiwyPJf9X+YWx5B9zsb7OhzOt2+sIgy1/I+ShXR19MDToUSTZ
         sojHPUqD22tRLxAFYm/wiJDFleDIwJXeiAhE+WSFcEvhdTqkIjH9WYU91iBexuBrsule
         VM9rDGqZvY6JKZnmLRu1fhqRppd6hiET1qpAN5Iq49YwIvHBUfdFEysIfiPIdklSh7g3
         6+9A==
X-Forwarded-Encrypted: i=1; AJvYcCWS64s35Gu8qiN7jgjZ+Lg9RcXCmp4nJEPMhHTSGCPaITZPPYs2Oy0rsd86LMUUBsAyqUQFvqxdy1UbCXSVBXr9iH5Z
X-Gm-Message-State: AOJu0YywgZK3TrwxVUBDtaNUA2WhrPWfk2I0FkaC0iCjmUdkVN7VXrqs
	c7ceWGHY/42Cc59iLaP5FsPUVE7NhOt/q3CHDEeFYxDuypY49/vK/jGCJxWuNZPvhwg4/sLheEU
	wCxJ5hlMErUnjAx9XP3452zhTMQ2LEyzbOiIM5s1Md/FRS1kS7A==
X-Received: by 2002:a05:600c:3510:b0:418:2ab6:7123 with SMTP id h16-20020a05600c351000b004182ab67123mr862651wmq.10.1713251116228;
        Tue, 16 Apr 2024 00:05:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHlh160Fkl72qlyyigfVzcARnzqPgQLteoNRsQ7hRBGSoEr70nam9SEPBDYWLmRrwtPfBMQ8g==
X-Received: by 2002:a05:600c:3510:b0:418:2ab6:7123 with SMTP id h16-20020a05600c351000b004182ab67123mr862627wmq.10.1713251115799;
        Tue, 16 Apr 2024 00:05:15 -0700 (PDT)
Received: from [192.168.3.108] (p4ff2389d.dip0.t-ipconnect.de. [79.242.56.157])
        by smtp.gmail.com with ESMTPSA id j12-20020a05600c190c00b004189a5ada3asm728027wmq.19.2024.04.16.00.05.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Apr 2024 00:05:15 -0700 (PDT)
Message-ID: <bf252e6c-ccd8-4ebb-bff4-9b0c74ab2d9a@redhat.com>
Date: Tue, 16 Apr 2024 09:05:12 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] s390/mm: re-enable the shared zeropage for !PV and
 !skeys KVM guests
To: Alexander Gordeev <agordeev@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, Heiko Carstens
 <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>,
 Sven Schnelle <svens@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Andrea Arcangeli <aarcange@redhat.com>, kvm@vger.kernel.org,
 linux-s390@vger.kernel.org
References: <20240411161441.910170-1-david@redhat.com>
 <20240411161441.910170-3-david@redhat.com>
 <Zh1w1QTNSy+rrCH7@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
 <8533cb18-42ff-42bc-b9e5-b0537aa51b21@redhat.com>
 <Zh4cqZkuPR9V1t1o@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <Zh4cqZkuPR9V1t1o@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 16.04.24 08:37, Alexander Gordeev wrote:
> On Mon, Apr 15, 2024 at 09:14:03PM +0200, David Hildenbrand wrote:
>>>> +retry:
>>>> +		rc = walk_page_range_vma(vma, addr, vma->vm_end,
>>>> +					 &find_zeropage_ops, &addr);
>>>> +		if (rc <= 0)
>>>> +			continue;
>>>
>>> So in case an error is returned for the last vma, __s390_unshare_zeropage()
>>> finishes with that error. By contrast, the error for a non-last vma would
>>> be ignored?
>>
>> Right, it looks a bit off. walk_page_range_vma() shouldn't fail
>> unless find_zeropage_pte_entry() would fail -- which would also be
>> very unexpected.
>>
>> To handle it cleanly in case we would ever get a weird zeropage where we
>> don't expect it, we should probably just exit early.
>>
>> Something like the following (not compiled, addressing the comment below):
> 
>> @@ -2618,7 +2618,8 @@ static int __s390_unshare_zeropages(struct mm_struct *mm)
>>   	struct vm_area_struct *vma;
>>   	VMA_ITERATOR(vmi, mm, 0);
>>   	unsigned long addr;
>> -	int rc;
>> +	vm_fault_t rc;
>> +	int zero_page;
> 
> I would use "fault" for mm faults (just like everywhere else handle_mm_fault() is
> called) and leave rc as is:
> 
> 	vm_fault_t fault;
> 	int rc;

Sure, let me know once discussion here stopped whether you want a v4 or 
can fix that up.

-- 
Cheers,

David / dhildenb


