Return-Path: <kvm+bounces-56506-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E91D9B3EB51
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 17:48:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B27463BAAAB
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 15:41:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 569222E6CA8;
	Mon,  1 Sep 2025 15:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YAb3SL66"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1901B2DF154
	for <kvm@vger.kernel.org>; Mon,  1 Sep 2025 15:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756741102; cv=none; b=b7wxchAJnOnCOqzhkz4izUXrMUrezxCOZC8MQPTfinIujQap4hFw5qjLBlLPoD4Y/SlBwHCe4DahjSyKv9fml9PiQIHnJDqLTgL7D5jJsIeJpBP+MI2HEETnfsHjMMe/7p50iiiYPlsJopqTkUBHQ/J9sckVJjh7CaRDf+GPmNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756741102; c=relaxed/simple;
	bh=HU+u6rCc4+dTZV2XYX4vLi6FWhSZa571guzbsh0B/YM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=R0R/GOXUzXC02IqJHlrBabeqnAW+pm3EAUnDUwwqDCf8zm8tJxFGOhAr8WFZWKpCWRc2JInkKZ03GdwVgEUQ1GilQm8Sp4kJ2GnI2qiaC+Jk6NzgNZw9lyYEWAKShvITdvhN58bkOWS+HPiWqzKPsQt3I0kCR0rXKyQ0fEQa/So=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YAb3SL66; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756741100;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=I7cj2vIHnbubjYL/Cp344/cfYy9VAiIPlFQJLIPEBxU=;
	b=YAb3SL666kBy+dgTO6q9UkBiUNYXT5btIpZ0LLQ9qUHlXZoIaYjAQ5u5+VNwSFJyrQXbpG
	M3FDHIWv3iE9qKIew7SUOyyWs5Y+LRkzR8U1de8Q0XoAhNNWGCWEEVpy3lXzgDDYWWn64z
	YVI0CBjtxrmRIu9fcSbGzFSp793taq0=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-216-7VlIG9DXP86HU3lhiJQMvw-1; Mon, 01 Sep 2025 11:38:17 -0400
X-MC-Unique: 7VlIG9DXP86HU3lhiJQMvw-1
X-Mimecast-MFC-AGG-ID: 7VlIG9DXP86HU3lhiJQMvw_1756741097
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45b869d3572so6114835e9.1
        for <kvm@vger.kernel.org>; Mon, 01 Sep 2025 08:38:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756741096; x=1757345896;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=I7cj2vIHnbubjYL/Cp344/cfYy9VAiIPlFQJLIPEBxU=;
        b=tfFyQcMK8FjOkJxLqlCr5gst1Gn5hVFxuPULIWPVCxKAaCfpjFm9IfMHuw9f6DM9M6
         MkR2lmHhN8n89Qc1MW+T6e4PW/3VnTtB93c32wLibHWAttb+xFN1Kakr58BcsNTJU2na
         Q6Lra2rKKkg5ptcsjHTHirTYYuGm7o2o7qkQDhTAlxOKXuhHBAl3eTqHG98vM00fLiSM
         1LEiSreQsbXb3kWp3RAtay6nB7MgR6byQhj5RHclNity1yrPAImVdAqvhnxEsKLL7zhK
         qkED7JaqrOcEILDUsr5xp1sSliqJCNflJkkhayG7nsiRQ13BgerE7O3hltv7pVzjxD3J
         3cFA==
X-Gm-Message-State: AOJu0Yw8v4pencsSqcWDgjfMZjkrlABxXaMmEVEWSgy7zCIvHr20RI3H
	UgCld4XwfL9lchMJ1JyyqsnThjzSoeycIyAnCl84gY9Q8jUPZxFmh78/0DnQNxwgtAWuXLf3goB
	Ahm4xebHJ4k7yPgftdWM4m7oerkji3iBs6fOL7EsSwjOSLL2E55laFQ==
X-Gm-Gg: ASbGncuMHzxE4EfEL0mMEJ5J1Z9WIfAjPXuininK5CdnjAUl7MRc2GuAsDJmcbuJYb2
	VgR9ZWEPt/eGYr7LFlkdCCSq7VHun5AtQ2V7RLC+QOF9vKZaaUAMQRsN1T1gUJQmn7oFhi2+tD5
	DSCZQvPefHQs8wBDdeAfO3jhjfUHg7/keUJNPaW//rD046eoRgOlKl5I9v8iuBpFDOW+93v5Z/j
	I/p8a4vExtTgYERJ7MWmoPGS9lwoAdctgK13+kZfPalA9Kf5YcNUg/YPABX2Y+frhuw4HNAP75k
	//qfYPlkLZquD9RFtQCzt56HEW+e46gvrH/+AG5IeXIw5ecPjHT6rtFPgnxgqvWuQl7ZGGkZHSO
	GCglg74ZrrqoKMKf9j8cURJlYB4sYBDNYD7ofNy6CI1faKZ3snq7hYi6AEeiMVfdpCSc=
X-Received: by 2002:a05:600c:c1c8:10b0:456:1156:e5f5 with SMTP id 5b1f17b1804b1-45b85e42eebmr49820965e9.31.1756741096519;
        Mon, 01 Sep 2025 08:38:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEyIE34iHGg8JZTdn73LFUNDC/XxlDdMwjWOyHyPPhHGcw6jZOXG7uo0+M6reKP/o7fOKUIZg==
X-Received: by 2002:a05:600c:c1c8:10b0:456:1156:e5f5 with SMTP id 5b1f17b1804b1-45b85e42eebmr49820755e9.31.1756741096109;
        Mon, 01 Sep 2025 08:38:16 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f37:2b00:948c:dd9f:29c8:73f4? (p200300d82f372b00948cdd9f29c873f4.dip0.t-ipconnect.de. [2003:d8:2f37:2b00:948c:dd9f:29c8:73f4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b6f0c6dc1sm243589115e9.1.2025.09.01.08.38.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Sep 2025 08:38:15 -0700 (PDT)
Message-ID: <22ab15f6-b1b9-4bb2-80b5-9e5bf4a3b7f5@redhat.com>
Date: Mon, 1 Sep 2025 17:38:13 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/2] KVM: guest_memfd: add generic population via write
To: kalyazin@amazon.com, "Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "shuah@kernel.org" <shuah@kernel.org>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "jthoughton@google.com" <jthoughton@google.com>,
 "Roy, Patrick" <roypat@amazon.co.uk>, "Thomson, Jack"
 <jackabt@amazon.co.uk>, "Manwaring, Derek" <derekmn@amazon.com>,
 "Cali, Marco" <xmarcalx@amazon.co.uk>
References: <20250828153049.3922-1-kalyazin@amazon.com>
 <20250828153049.3922-2-kalyazin@amazon.com>
 <d58425d4-8e4f-4b70-915f-322658e9878e@redhat.com>
 <bb929cd5-7ac1-4159-8614-553e84176968@amazon.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <bb929cd5-7ac1-4159-8614-553e84176968@amazon.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 01.09.25 16:29, Nikita Kalyazin wrote:
> 
> 
> On 28/08/2025 21:01, David Hildenbrand wrote:
>> On 28.08.25 17:31, Kalyazin, Nikita wrote:
>>> write syscall populates guest_memfd with user-supplied data in a generic
>>> way, ie no vendor-specific preparation is performed.  This is supposed
>>> to be used in non-CoCo setups where guest memory is not
>>> hardware-encrypted.
>>>
>>> The following behaviour is implemented:
>>>    - only page-aligned count and offset are allowed
>>>    - if the memory is already allocated, the call will successfully
>>>      populate it
>>>    - if the memory is not allocated, the call will both allocate and
>>>      populate
>>>    - if the memory is already populated, the call will not repopulate it
>>>
>>> Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>
>>> ---
>>
>> Just nothing that checkpatch complains about
>>
>> a) Usage of "unsigned" instead of "unsigned int"
> 
> Hi David,
> 
> 
> I copied the prototypes straight from the fs.h...  In any case, will fix
> in the next version.

Yes, realized that after I sent it. :)

> 
>>
>> b) The From doesn't completely match the SOB: "Kalyazin, Nikita" vs
>> "Nikita Kalyazin"
> 
> It's about .com vs .co.uk, I think.  Will have to use "From:" apparently.

Yes, discussed that with Patrick on the other thread: sending from .com 
is apparently fine.

-- 
Cheers

David / dhildenb


