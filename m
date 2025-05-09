Return-Path: <kvm+bounces-46027-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 533A1AB0D02
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 10:21:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BBF5617ED3D
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 08:21:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EA162741CD;
	Fri,  9 May 2025 08:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cJFFCymX"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2B0C22A4FD
	for <kvm@vger.kernel.org>; Fri,  9 May 2025 08:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746778850; cv=none; b=LWExIPIPmtP1/DtsbwcBfG0NMw+xnt3XBSPSrILb8abYq75/Gsr4M6HLI/mhNInvam2MbQItOLF1vdjsBDaws/bqxSBXDj/cr29JmXjL/x9U5AX27zkVwa2bLvcidF3RiVFqtzoN2aq7Go8tRzkYPwpCpKXjgKF3/QE5aRukF+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746778850; c=relaxed/simple;
	bh=1ccNR3t2x8CWuSwtbGVxMqe9nfMcIvVSVfrumMt0p6U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iQB1hA4A7Hc59g/Uopxkd7U4D9dsw3cw4NTMNncylie6CQsFwIRUKvulIJE33wkSDbFXmzvWxMKXjdMsLNl7jCXAzdll/U33f3bK76czWBhzNBZ8ZJOfvWYek59KsMczE4l72ykzO1vZNvH0TkBu0vQrlGko8Mp7R6VL1H5meAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cJFFCymX; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746778847;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=HWS8+mZdzL4jlk/OZD2nUTjtbWJ4mc2U2ewq3SV89ns=;
	b=cJFFCymXhYxHrWdP3ShNHK8dDb3uG+dmdXLpsqeKPBEbsIdYqPtu/j8/A3TLmQTwdPsmDE
	hqU+7/KJuhUdtkleayzTEnPCBscuLR10IzN6hsAsOXmwfvOtGFk6FYtzTyG3Q8k7b2S7t0
	nxLjeCKy3fFvrMitz5JPcdqqu5koOVk=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-613-_d0E9LEJOzWH1XLLnoxiQg-1; Fri, 09 May 2025 04:20:46 -0400
X-MC-Unique: _d0E9LEJOzWH1XLLnoxiQg-1
X-Mimecast-MFC-AGG-ID: _d0E9LEJOzWH1XLLnoxiQg_1746778845
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-442d472cf84so5808525e9.2
        for <kvm@vger.kernel.org>; Fri, 09 May 2025 01:20:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746778845; x=1747383645;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=HWS8+mZdzL4jlk/OZD2nUTjtbWJ4mc2U2ewq3SV89ns=;
        b=leAszdy+0QtyQew/LEum4qFZi8DrkUiHdjOf7lyVGl11Jk9+Kkkr5HN3KIn42TfQXx
         iD4250u3UHSbYJYvu8ReJX2iwZC5L/LQ3BzLSTgYXT/P9hMoE+t79qmLINORGaNF1Hvb
         VVl9exEU2jARIRl3XyCKJJkgvduzr1BHVuXl/nAumQ1s0qEJeKVuwM/fVBABIZs+ZTX1
         Zu1VL37GM3hppDsq3yGGtMWPlCxNMdOOIywTFGGs0SrC62roH9VwTyvuN0JZRQMXR5BD
         Sbf3vhaWiSCvQiv6DZw+w+aXIEKSAiSJ6pAD9pe2ljtqUzqw2OWVoreIfQv3r2SFDZ3e
         dB7A==
X-Forwarded-Encrypted: i=1; AJvYcCWxlTGniL8IcZFjbbzQrwoQ0bedYI/lCgBDJaAXx+qp1qxTJ2t+CMKd0Q5Coie8Vu8ZT78=@vger.kernel.org
X-Gm-Message-State: AOJu0YyMubhAZT3f8wbanYcFixuS+9erPD8lxDX3X03hsKxA+Nzcy3AT
	wxZH+s5Y6C+nhzSsHytNNOWpu4SXrD9GQ3ntOlKfM5yETeHltcx8Ul2S99Ln23FaYqI9QE8ZJz5
	TrCplHuKqUO9Aju/7tbFBo/mQbuH2Lf0lRIu/rWrP7fKk8RYrRA==
X-Gm-Gg: ASbGncvXGooOVho562MQwuHC0U8Tu/LPdhzKCzfHGrh7zS6H7QSGDpTh5te0MqfGz5o
	3V2mth/+rcQtZXLV1/9+PKkumMAky+87rmkFoX7Ptru59tatUnsKgMzAqjEB/mpEoysoKP/1uZj
	6Ri5ed27fUe6vX84+fW6O3ohLCQz4GOdcM0OY+r4vWEZS7+E20bqXooVALduHl87XYoGL4JaCTZ
	ANoR6le8P5leO7icY0uNK/8ZFOo9UdQf8iJe3cUyyERN6t6hRjiSgqnsFQXvUU9DAGBeeN/1+Gq
	znZUXzEANajIaZTWmmkTUFnOe5VsVuxVSV8tvtfqXi5PQwqT4SelBWgRVFErEaCA7mdHCcoOwJt
	fYlG5iQdhtXTySTMr8ish7OrG0evPvk9pkv4E9fY=
X-Received: by 2002:a05:600c:8208:b0:43c:eec7:eabb with SMTP id 5b1f17b1804b1-442d6d3e163mr19216675e9.8.1746778844823;
        Fri, 09 May 2025 01:20:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG2e9pCUasla3fGuPSa5UWW5g1pyHN0N3zjoZK55joCOri0I1sx1WIaAdFDQ1xcuyTS3CCdGQ==
X-Received: by 2002:a05:600c:8208:b0:43c:eec7:eabb with SMTP id 5b1f17b1804b1-442d6d3e163mr19216475e9.8.1746778844486;
        Fri, 09 May 2025 01:20:44 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f45:5500:8267:647f:4209:dedd? (p200300d82f4555008267647f4209dedd.dip0.t-ipconnect.de. [2003:d8:2f45:5500:8267:647f:4209:dedd])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a1f5a2cf0esm2488518f8f.79.2025.05.09.01.20.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 May 2025 01:20:44 -0700 (PDT)
Message-ID: <79730f95-6684-42fa-a6a4-630e3e346174@redhat.com>
Date: Fri, 9 May 2025 10:20:42 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 10/13] memory: Change NotifyStateClear() definition to
 return the result
To: Chao Gao <chao.gao@intel.com>, Chenyi Qiang <chenyi.qiang@intel.com>
Cc: Alexey Kardashevskiy <aik@amd.com>, Peter Xu <peterx@redhat.com>,
 Gupta Pankaj <pankaj.gupta@amd.com>, Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Michael Roth <michael.roth@amd.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org, Williams Dan J <dan.j.williams@intel.com>,
 Peng Chao P <chao.p.peng@intel.com>, Xu Yilun <yilun.xu@intel.com>,
 Li Xiaoyao <xiaoyao.li@intel.com>
References: <20250407074939.18657-1-chenyi.qiang@intel.com>
 <20250407074939.18657-11-chenyi.qiang@intel.com>
 <c7ee2562-5f66-44ed-b31f-db06916d3d7b@intel.com> <aB1qqUGEayKbkL+2@intel.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzSREYXZpZCBIaWxk
 ZW5icmFuZCA8ZGF2aWRAcmVkaGF0LmNvbT7CwZgEEwEIAEICGwMGCwkIBwMCBhUIAgkKCwQW
 AgMBAh4BAheAAhkBFiEEG9nKrXNcTDpGDfzKTd4Q9wD/g1oFAl8Ox4kFCRKpKXgACgkQTd4Q
 9wD/g1oHcA//a6Tj7SBNjFNM1iNhWUo1lxAja0lpSodSnB2g4FCZ4R61SBR4l/psBL73xktp
 rDHrx4aSpwkRP6Epu6mLvhlfjmkRG4OynJ5HG1gfv7RJJfnUdUM1z5kdS8JBrOhMJS2c/gPf
 wv1TGRq2XdMPnfY2o0CxRqpcLkx4vBODvJGl2mQyJF/gPepdDfcT8/PY9BJ7FL6Hrq1gnAo4
 3Iv9qV0JiT2wmZciNyYQhmA1V6dyTRiQ4YAc31zOo2IM+xisPzeSHgw3ONY/XhYvfZ9r7W1l
 pNQdc2G+o4Di9NPFHQQhDw3YTRR1opJaTlRDzxYxzU6ZnUUBghxt9cwUWTpfCktkMZiPSDGd
 KgQBjnweV2jw9UOTxjb4LXqDjmSNkjDdQUOU69jGMUXgihvo4zhYcMX8F5gWdRtMR7DzW/YE
 BgVcyxNkMIXoY1aYj6npHYiNQesQlqjU6azjbH70/SXKM5tNRplgW8TNprMDuntdvV9wNkFs
 9TyM02V5aWxFfI42+aivc4KEw69SE9KXwC7FSf5wXzuTot97N9Phj/Z3+jx443jo2NR34XgF
 89cct7wJMjOF7bBefo0fPPZQuIma0Zym71cP61OP/i11ahNye6HGKfxGCOcs5wW9kRQEk8P9
 M/k2wt3mt/fCQnuP/mWutNPt95w9wSsUyATLmtNrwccz63XOwU0EVcufkQEQAOfX3n0g0fZz
 Bgm/S2zF/kxQKCEKP8ID+Vz8sy2GpDvveBq4H2Y34XWsT1zLJdvqPI4af4ZSMxuerWjXbVWb
 T6d4odQIG0fKx4F8NccDqbgHeZRNajXeeJ3R7gAzvWvQNLz4piHrO/B4tf8svmRBL0ZB5P5A
 2uhdwLU3NZuK22zpNn4is87BPWF8HhY0L5fafgDMOqnf4guJVJPYNPhUFzXUbPqOKOkL8ojk
 CXxkOFHAbjstSK5Ca3fKquY3rdX3DNo+EL7FvAiw1mUtS+5GeYE+RMnDCsVFm/C7kY8c2d0G
 NWkB9pJM5+mnIoFNxy7YBcldYATVeOHoY4LyaUWNnAvFYWp08dHWfZo9WCiJMuTfgtH9tc75
 7QanMVdPt6fDK8UUXIBLQ2TWr/sQKE9xtFuEmoQGlE1l6bGaDnnMLcYu+Asp3kDT0w4zYGsx
 5r6XQVRH4+5N6eHZiaeYtFOujp5n+pjBaQK7wUUjDilPQ5QMzIuCL4YjVoylWiBNknvQWBXS
 lQCWmavOT9sttGQXdPCC5ynI+1ymZC1ORZKANLnRAb0NH/UCzcsstw2TAkFnMEbo9Zu9w7Kv
 AxBQXWeXhJI9XQssfrf4Gusdqx8nPEpfOqCtbbwJMATbHyqLt7/oz/5deGuwxgb65pWIzufa
 N7eop7uh+6bezi+rugUI+w6DABEBAAHCwXwEGAEIACYCGwwWIQQb2cqtc1xMOkYN/MpN3hD3
 AP+DWgUCXw7HsgUJEqkpoQAKCRBN3hD3AP+DWrrpD/4qS3dyVRxDcDHIlmguXjC1Q5tZTwNB
 boaBTPHSy/Nksu0eY7x6HfQJ3xajVH32Ms6t1trDQmPx2iP5+7iDsb7OKAb5eOS8h+BEBDeq
 3ecsQDv0fFJOA9ag5O3LLNk+3x3q7e0uo06XMaY7UHS341ozXUUI7wC7iKfoUTv03iO9El5f
 XpNMx/YrIMduZ2+nd9Di7o5+KIwlb2mAB9sTNHdMrXesX8eBL6T9b+MZJk+mZuPxKNVfEQMQ
 a5SxUEADIPQTPNvBewdeI80yeOCrN+Zzwy/Mrx9EPeu59Y5vSJOx/z6OUImD/GhX7Xvkt3kq
 Er5KTrJz3++B6SH9pum9PuoE/k+nntJkNMmQpR4MCBaV/J9gIOPGodDKnjdng+mXliF3Ptu6
 3oxc2RCyGzTlxyMwuc2U5Q7KtUNTdDe8T0uE+9b8BLMVQDDfJjqY0VVqSUwImzTDLX9S4g/8
 kC4HRcclk8hpyhY2jKGluZO0awwTIMgVEzmTyBphDg/Gx7dZU1Xf8HFuE+UZ5UDHDTnwgv7E
 th6RC9+WrhDNspZ9fJjKWRbveQgUFCpe1sa77LAw+XFrKmBHXp9ZVIe90RMe2tRL06BGiRZr
 jPrnvUsUUsjRoRNJjKKA/REq+sAnhkNPPZ/NNMjaZ5b8Tovi8C0tmxiCHaQYqj7G2rgnT0kt
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <aB1qqUGEayKbkL+2@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 09.05.25 04:38, Chao Gao wrote:
> On Sun, Apr 27, 2025 at 10:26:52AM +0800, Chenyi Qiang wrote:
>> Hi David,
>>
>> Any thought on patch 10-12, which is to move the change attribute into a
>> priority listener. A problem is how to handle the error handling of
>> private_to_shared failure. Previously, we thought it would never be able
>> to fail, but right now, it is possible in corner cases (e.g. -ENOMEM) in
>> set_attribute_private(). At present, I simply raise an assert instead of
>> adding any rollback work (see patch 11).
> 
> I took a look at patches 10-12, and here are my thoughts:
> 
> Moving the change attribute into a priority listener seems sensible. It can
> ensure the correct order between setting memory attributes and VFIO's DMA
> map/unmap operations, and it can also simplify rollbacks. Since
> MemoryListener already uses a priority-based list, it should be a good fit
> for page conversion listeners.
> 
> Regarding error handling, -ENOMEM won't occur during page conversion
> because the attribute xarray on the KVM side is populated earlier when QEMU
> calls kvm_set_phys_mem() -> kvm_set_memory_attributes_private(). 

I'll note that, with guest_memfd supporting in-place conversion in the 
future, this conversion path will likely change, and we might more 
likely in getting more errors on some conversion paths. (e.g., shared -> 
private could fail).

But I agree, we should keep complex error handling out of the picture 
for now if not required.

-- 
Cheers,

David / dhildenb


