Return-Path: <kvm+bounces-36099-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B4933A17B9C
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 11:28:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BDC8D3AB682
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 10:27:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DC4E1F03CA;
	Tue, 21 Jan 2025 10:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iJzTrzN3"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3ACF139B
	for <kvm@vger.kernel.org>; Tue, 21 Jan 2025 10:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737455197; cv=none; b=r7AJT4rKMDpnF1qAEE4gKzFF9/3Mw8r35FivuylNWGaWiqNFt1euApwkhKFWL66fU0W8UuSGXWEHnx/SygQI7U4UB18lhAdmJ+ZJc4U9LOI1u2HNiGuS7nQHkiPlMJlmwaLsQQV6RZz0O/j6nG7AjN6/UlsZpM/BQhxodcankq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737455197; c=relaxed/simple;
	bh=RtY6UNgWuU9g/74wHFW2lDt8MKyXbcTTuUV/b6q5EEU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OwXkTuAWU9zQh/4gV/fnF5TqwCKMDzM00Z4tqCLaSfSRy4aGdMWqIM/pTNm6RxNRj5tQifuvLuRH7XddYHlpISmbwCrTdGIPilh6zMQVWVX8Geeo2iAYec9KMLi/pdYNfXbGQewouYloiHxjaX3QMpft0S2snxjSOhdWNcaDmkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iJzTrzN3; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737455194;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=6xJ9kEU3MPWkLyphBzZ+W2LGIP9lFuhL+8NmC+5HSPY=;
	b=iJzTrzN39B1Xxq6XvZstI3fxcAvCvjR4pxZL/qWpYfaxjHWjgvspwZoiSSKMWzYjC2Y0aw
	5dHRJXnMuHf/LXkjo62YwIh9W6tQQaTd74X0FjuYsn7H/0eKRcNX6urvnE8ldJt8AhWpkM
	qVkGnowUA5F/LPmw1sH01UhTHzHar1g=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-318-Lj_NmFlENdqOW3MzUXZMRQ-1; Tue, 21 Jan 2025 05:26:33 -0500
X-MC-Unique: Lj_NmFlENdqOW3MzUXZMRQ-1
X-Mimecast-MFC-AGG-ID: Lj_NmFlENdqOW3MzUXZMRQ
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-38bee05f396so2831383f8f.0
        for <kvm@vger.kernel.org>; Tue, 21 Jan 2025 02:26:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737455192; x=1738059992;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=6xJ9kEU3MPWkLyphBzZ+W2LGIP9lFuhL+8NmC+5HSPY=;
        b=v08OvnhFBTvwBAdD2berXOZsLi7nAmYDkyj8N5o+IxLT5dzhDw4CsVjX1FIgZQEsSj
         Cd/JKbtTNkUFbWx6/A3BT5bjtHqifPTXQzdKBsvI+6kR2AMalogEJsiyzWxWkT1ZSmrB
         DVlPiMniCFSGpzS1cw01doVXvI+4AqRf6OB/2SqrqNjTN9eqcVXWF7klzncvMTqFwt54
         iInuRTcymCV14/7ttfjM69E0r6v1TFMj+UvJkPQxe6L6SOPkt01xJiWt7adhgOEZXtX6
         MnE1X5v+OHiNrKYTKhIyB9nLIb7Ze9YGvore2+2A34OgPnfAXlcNZ5U0E73vRpGlWlYj
         kUlQ==
X-Forwarded-Encrypted: i=1; AJvYcCXtVtqm2cStbAHQ2jjtqxBYTixOSks5rDCY/YsWlTuomVOcqj4nW3vafxZ+aG1hUdEBveM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwwWYp8Vr6aIMHKWkYXWomc1S4FtV6wyhDN1pRJyoDR92SDS92M
	wc8zJeYXIw1A6Y2+1zzMej7lK0sxplJfy3CfvXuLdcHUOuFu7vJjr1OxUfMG9yVK2WjYTPMO6bl
	T2QqgWcBkNQqWc3s1yQNsV95DZ57SSQWvVMBtD+bU78584K9/nA==
X-Gm-Gg: ASbGncvGgEl82njHqahmN9f2tfZz+UdmAYMNx7hx5nFgnoID9eRqqNMk82KP56jvoLV
	i2FxFZhlFUOS5f1AWRGLxZa1+kFQqI7EpzjzkdSRZFmqS4Nk001Di3/z9ILUyYnVsGCi0vt6AKc
	WVHZvw+/OQan1PCcNy+7E3nOEAOrnvi+Kl72FI37tBRVni8aHXQrK+HEt8PwmZw7FERpnGwADH6
	5O3GHB1+1JIeTbX9YsF25s6SyA7TSwfNlEWnSNEkp+uMILy8rF/TI9on2u29pl0yBu7KUsaS1KG
	A1JJfgqXbsI+8iEfK1ygatMVR56yZWG4hoMfCQxBlUi3ZEURUCRKyf9gLC1CeC9ukjD/4gbLXVr
	4I+SmnwlJiemBrVEI9PuCJw==
X-Received: by 2002:a5d:64c2:0:b0:38b:ee18:dd46 with SMTP id ffacd0b85a97d-38bf5b02b1cmr12636976f8f.20.1737455191798;
        Tue, 21 Jan 2025 02:26:31 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHU59H4MFhxDmwV6/Ktn24cevXsA1bPIIWOdQ7SXJ03vgXv5/Vqv+b8nTQLquELtO/TaJPv3Q==
X-Received: by 2002:a5d:64c2:0:b0:38b:ee18:dd46 with SMTP id ffacd0b85a97d-38bf5b02b1cmr12636953f8f.20.1737455191476;
        Tue, 21 Jan 2025 02:26:31 -0800 (PST)
Received: from ?IPV6:2003:cb:c709:6200:16ba:af70:999d:6a1a? (p200300cbc709620016baaf70999d6a1a.dip0.t-ipconnect.de. [2003:cb:c709:6200:16ba:af70:999d:6a1a])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38bf3275501sm13234385f8f.65.2025.01.21.02.26.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jan 2025 02:26:30 -0800 (PST)
Message-ID: <065250d4-84f1-4dfa-a938-98a61082a666@redhat.com>
Date: Tue, 21 Jan 2025 11:26:29 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/7] guest_memfd: Introduce an object to manage the
 guest-memfd with RamDiscardManager
To: Chenyi Qiang <chenyi.qiang@intel.com>, Peter Xu <peterx@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Michael Roth <michael.roth@amd.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org, Williams Dan J <dan.j.williams@intel.com>,
 Peng Chao P <chao.p.peng@intel.com>, Gao Chao <chao.gao@intel.com>,
 Xu Yilun <yilun.xu@intel.com>
References: <20241213070852.106092-1-chenyi.qiang@intel.com>
 <20241213070852.106092-3-chenyi.qiang@intel.com> <Z46RT__q02nhz3dc@x1n>
 <a55048ec-c02d-4845-8595-cc79b7a5e340@intel.com>
 <7176db79-cd04-4968-a61a-a753e3668564@redhat.com>
 <5515f87d-63a5-4c70-b421-616e706324a5@intel.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <5515f87d-63a5-4c70-b421-616e706324a5@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 21.01.25 11:16, Chenyi Qiang wrote:
> 
> 
> On 1/21/2025 5:26 PM, David Hildenbrand wrote:
>> On 21.01.25 10:00, Chenyi Qiang wrote:
>>> Thanks Peter for your review!
>>>
>>> On 1/21/2025 2:09 AM, Peter Xu wrote:
>>>> Two trivial comments I spot:
>>>>
>>>> On Fri, Dec 13, 2024 at 03:08:44PM +0800, Chenyi Qiang wrote:
>>>>> +struct GuestMemfdManager {
>>>>> +    Object parent;
>>>>> +
>>>>> +    /* Managed memory region. */
>>>>> +    MemoryRegion *mr;
>>>>> +
>>>>> +    /*
>>>>> +     * 1-setting of the bit represents the memory is populated
>>>>> (shared).
>>>>> +     */
>>>>> +    int32_t bitmap_size;
>>>>> +    unsigned long *bitmap;
>>>>
>>>> Might be clearer to name the bitmap directly as what it represents.
>>>> E.g.,
>>>> shared_bitmap?
>>>
>>> Make sense.
>>>
>>
>> BTW, I was wondering if this information should be stored/linked from
>> the RAMBlock, where we already store the guest_memdfd "int guest_memfd;".
>>
>> For example, having a "struct guest_memfd_state", and either embedding
>> it in the RAMBlock or dynamically allocating and linking it.
>>
>> Alternatively, it would be such an object that we would simply link from
>> the RAMBlock. (depending on which object will implement the manager
>> interface)
>>
>> In any case, having all guest_memfd state that belongs to a RAMBlock at
>> a single location might be cleanest.
> 
> Good suggestion. Follow the design of this series, we can add link to
> the guest_memfd_manager object in RAMBlock.

Or we'll move / link that to the RAM memory region, because that's what 
the object actually controls.

It starts getting a bit blury what should be part of the RAMBlock and 
what should be part of the "owning" RAM memory region :(

-- 
Cheers,

David / dhildenb


