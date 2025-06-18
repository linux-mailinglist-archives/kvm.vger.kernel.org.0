Return-Path: <kvm+bounces-49876-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 83933ADED97
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 15:16:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1DE221709F1
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 13:16:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D96D72E88BF;
	Wed, 18 Jun 2025 13:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cdotbtSy"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F1A62BD5AF
	for <kvm@vger.kernel.org>; Wed, 18 Jun 2025 13:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750252592; cv=none; b=YKguXxzIwEx0v2uYvt/c6WM8ly9lT+QGz9/U25k3+v9QoNH2pQAdv1pyawCBYVoqAETCQvKm/CY0V2OS7SHPNStuPJ9FcmUrt1V1fY+wDaUR6swaNC8nd8eFdrrv8RK3bKx0IpqabJ5l1TvTmgto2M4EplXwaYl4A1wxTIHi7so=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750252592; c=relaxed/simple;
	bh=8J9KAhlWf5co3iUUu4FPJNVpTzmF1Oipo85JzD2iQw8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dN2sZLYtEOJq1jR6EBwdvQdiiDtwCTnBE7tC811kdAT282bHQyEGCYJkpiArCeGoQRQAjGYPz6Mlcw3P38R2S9vzEbjErF1/U5JCWdfm5xyry3K4IB7PhLqCCU+h7lhRhoIJn5+ZDN7ck7wK760AK79OqbYbCkvPf3qg6/338WA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cdotbtSy; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750252589;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=HF/h5iERcRiAWZcVo6GzXQXrMZ2C+pgVCc623GzbLyU=;
	b=cdotbtSyO8aogRabZEKoae7mp46hReLCyoXxoKQinwdkkPM+/bKPLPT45mXDwZexj97mK0
	z+ePm5xVldHdESgQCQ1j5MSFK2Iiyd7zIkvKcHRdiyVXQqGY2VxtvndO6VcSM4R2lPBCpD
	nZ5rncpoK0BOU/PuxJnhmoQ+kZb2kKI=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-673-zuhh5ywRPPeVIFgMEKMncg-1; Wed, 18 Jun 2025 09:16:27 -0400
X-MC-Unique: zuhh5ywRPPeVIFgMEKMncg-1
X-Mimecast-MFC-AGG-ID: zuhh5ywRPPeVIFgMEKMncg_1750252587
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45311704cdbso36115925e9.1
        for <kvm@vger.kernel.org>; Wed, 18 Jun 2025 06:16:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750252587; x=1750857387;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=HF/h5iERcRiAWZcVo6GzXQXrMZ2C+pgVCc623GzbLyU=;
        b=W4fkJ60dcouUWmybqWdncfFervPrn2Ve+80sDqQXvfBUxyGIwUkj9Y1rdS8fhtG662
         pWJsjuy5gbva+dsmqq8lqupQycbEVmsBE+V+gRdXkBQNDEt7deMulwZPfpSQicP3BqF1
         cIEo8eB6p/KHJZw5InkdQANOG9zBC91MNakGYlEvA7JE1H4PpZvFZx66jZRxBD7VaIUD
         6owU4xhvT5PfZ7btBVodyj5r2sHNqHmjPWRB0upQmZ0IPs/pwK+06GMNa0TTxoUmw48U
         96Qa8udHwmmo5rldlMq8DDVYSzc2qVbGz66+hdNEWJW2pTjhVSLy0nmBNJhd7YXqmi9x
         O24Q==
X-Forwarded-Encrypted: i=1; AJvYcCULB0p44Z6rr/hHNzkxxH/uRWvTpb8kmbWZUko7KkD0VLkve8GksHwT7tnSyIK7/n31+FA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyJY2iVbDe0qlFIYeFT5LoJhBfczDkIPtpXGPuruFBdqHWgycB7
	q/1VZy8XtGwCmAq6oGKcf7SJ8BMIMMc0E+SVxczy6ZaGUNB0EnzZVCqRtkyNEqkSrelCleNzDDy
	rOm0xM/YmkLabAhTsjUpvonHxYUGlp/qVnCCbeYm4Hgo+AmB3SLV6fw==
X-Gm-Gg: ASbGnctZNLFYHNVQvAzRVIWka6G8Q4Q6R/txb1ePyoK1nRoh7dLsfqYP+/tpa3F/DRa
	nHj0cfVhTSUmnf6dF28OUu7eiUm2GPAUlp+JNO4zr1mPJrE2lgXX1Bqvpz0sbqHo+Y7U08zzYUp
	sr3SzY1by0VCzW+mCyvkfcwNt37tH5v3MLAVuR1H3BJcQdhRW1pISTjpRYXqLZBFKHCJnBPEHlD
	y2zJbr19tA7bofSPfhn+/qVQPR+sFEL+YPJ/5bfFGBFtLPWe6GUTLTTxCSWDvg6wIVl1pq275Hv
	vfTc+Un6S9VhOLLJIH5CPgAxDLVfA7WcXXmfqhVKcxUNZkG5f4McX+B+paCvrkHDw7ZNWKj73e7
	tXdBSdoPDliLCErGBSC5GcQCQQYYFoo72vJ+nWC0S6i0butg=
X-Received: by 2002:a05:600c:4e02:b0:43d:ac5:11e8 with SMTP id 5b1f17b1804b1-4533caaeb57mr146639165e9.21.1750252586516;
        Wed, 18 Jun 2025 06:16:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFjSUUqdc83WhSU0K6mVnps9+N/GTCXXKIMqt/yKtrTCHClblot/wii0/9onwg7tf1gxoVdxA==
X-Received: by 2002:a05:600c:4e02:b0:43d:ac5:11e8 with SMTP id 5b1f17b1804b1-4533caaeb57mr146638745e9.21.1750252586082;
        Wed, 18 Jun 2025 06:16:26 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f2d:2400:4052:3b5:fff9:4ed0? (p200300d82f2d2400405203b5fff94ed0.dip0.t-ipconnect.de. [2003:d8:2f2d:2400:4052:3b5:fff9:4ed0])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4532e232219sm204383145e9.9.2025.06.18.06.16.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Jun 2025 06:16:25 -0700 (PDT)
Message-ID: <80cb9936-416f-42c4-96c2-416304bd9262@redhat.com>
Date: Wed, 18 Jun 2025 15:16:22 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 08/18] KVM: guest_memfd: Allow host to map guest_memfd
 pages
To: Xiaoyao Li <xiaoyao.li@intel.com>, Sean Christopherson <seanjc@google.com>
Cc: Fuad Tabba <tabba@google.com>, Ira Weiny <ira.weiny@intel.com>,
 kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org,
 kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org,
 mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com,
 palmer@dabbelt.com, aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk,
 brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
 yilun.xu@intel.com, chao.p.peng@linux.intel.com, jarkko@kernel.org,
 amoorthy@google.com, dmatlack@google.com, isaku.yamahata@intel.com,
 mic@digikod.net, vbabka@suse.cz, vannapurve@google.com,
 ackerleytng@google.com, mail@maciej.szmigiero.name, michael.roth@amd.com,
 wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com,
 kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com,
 steven.price@arm.com, quic_eberman@quicinc.com, quic_mnalajal@quicinc.com,
 quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com,
 quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com,
 quic_pheragu@quicinc.com, catalin.marinas@arm.com, james.morse@arm.com,
 yuzenghui@huawei.com, oliver.upton@linux.dev, maz@kernel.org,
 will@kernel.org, qperret@google.com, keirf@google.com, roypat@amazon.co.uk,
 shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, rientjes@google.com,
 jhubbard@nvidia.com, fvdl@google.com, hughd@google.com,
 jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com
References: <20250611133330.1514028-1-tabba@google.com>
 <20250611133330.1514028-9-tabba@google.com> <aEySD5XoxKbkcuEZ@google.com>
 <68501fa5dce32_2376af294d1@iweiny-mobl.notmuch>
 <bbc213c3-bc3d-4f57-b357-a79a9e9290c5@redhat.com>
 <CA+EHjTxvqDr1tavpx7d9OyC2VfUqAko864zH9Qn5+B0UQiM93g@mail.gmail.com>
 <701c8716-dd69-4bf6-9d36-4f8847f96e18@redhat.com>
 <aFIK9l6H7qOG0HYB@google.com>
 <3fb0e82b-f4ef-402d-a33c-0b12e8aa990c@redhat.com>
 <5ee9bbb8-d100-408c-ac07-ea9c5b603545@intel.com>
 <5a55d95e-5e32-4239-a445-be13228ea80b@redhat.com>
 <45af2c0d-a416-49bc-8011-4ec57a56d6f5@intel.com>
 <40a5903b-f747-4eab-8959-06ddd6e88f82@redhat.com>
 <fa3cea2a-d005-44fd-8a2f-2bcea1dc9042@intel.com>
 <38101158-4475-4885-83e7-654045ca0f9b@redhat.com>
 <3031b949-c42a-49bc-be0c-f95a62c792e2@intel.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <3031b949-c42a-49bc-be0c-f95a62c792e2@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 18.06.25 14:17, Xiaoyao Li wrote:
> On 6/18/2025 7:14 PM, David Hildenbrand wrote:
>> On 18.06.25 12:42, Xiaoyao Li wrote:
>>> On 6/18/2025 5:59 PM, David Hildenbrand wrote:
>>>> On 18.06.25 11:44, Xiaoyao Li wrote:
>>>>> On 6/18/2025 5:27 PM, David Hildenbrand wrote:
>>>>>> On 18.06.25 11:20, Xiaoyao Li wrote:
>>>>>>> On 6/18/2025 4:15 PM, David Hildenbrand wrote:
>>>>>>>>> If we are really dead set on having SHARED in the name, it could be
>>>>>>>>> GUEST_MEMFD_FLAG_USER_MAPPABLE_SHARED or
>>>>>>>>> GUEST_MEMFD_FLAG_USER_MAP_SHARED?  But
>>>>>>>>> to me that's _too_ specific and again somewhat confusing given the
>>>>>>>>> unfortunate
>>>>>>>>> private vs. shared usage in CoCo-land.  And just playing the odds,
>>>>>>>>> I'm
>>>>>>>>> fine taking
>>>>>>>>> a risk of ending up with GUEST_MEMFD_FLAG_USER_MAPPABLE_PRIVATE or
>>>>>>>>> whatever,
>>>>>>>>> because I think that is comically unlikely to happen.
>>>>>>>>
>>>>>>>> I think in addition to GUEST_MEMFD_FLAG_MMAP we want something to
>>>>>>>> express "this is not your old guest_memfd that only supports private
>>>>>>>> memory". And that's what I am struggling with.
>>>>>>>
>>>>>>> Sorry for chiming in.
>>>>>>>
>>>>>>> Per my understanding, (old) guest memfd only means it's the memory
>>>>>>> that
>>>>>>> cannot be accessed by userspace. There should be no shared/private
>>>>>>> concept on it.
>>>>>>>
>>>>>>> And "private" is the concept of KVM. Guest memfd can serve as private
>>>>>>> memory, is just due to the character of it cannot be accessed from
>>>>>>> userspace.
>>>>>>>
>>>>>>> So if the guest memfd can be mmap'ed, then it become userspace
>>>>>>> accessable and cannot serve as private memory.
>>>>>>>
>>>>>>>> Now, if you argue "support for mmap() implies support for non-
>>>>>>>> private
>>>>>>>> memory", I'm probably okay for that.
>>>>>>>
>>>>>>> I would say, support for mmap() implies cannot be used as private
>>>>>>> memory.
>>>>>>
>>>>>> That's not where we're heading with in-place conversion support: you
>>>>>> will have private (ianccessible) and non-private (accessible)
>>>>>> parts, and
>>>>>> while guest_memfd will support mmap() only the accessible parts can
>>>>>> actually be accessed (faulted in etc).
>>>>>
>>>>> That's OK. The guestmemfd can be fine-grained, i.e., different
>>>>> range/part of it can have different access property. But one rule never
>>>>> change: only the sub-range is not accessible by userspace can it be
>>>>> serve as private memory.
>>>>
>>>> I'm sorry, I don't understand what you are getting at.
>>>>
>>>> You said "So if the guest memfd can be mmap'ed, then it become userspace
>>>> accessable and cannot serve as private memory." and I say, with in-place
>>>> conversion support you are wrong.
>>>>
>>>> The whole file can be mmaped(), that does not tell us anything about
>>>> which parts can be private or not.
>>>
>>> So there is nothing prevent userspace from accessing it after a range is
>>> converted to private via KVM_GMEM_CONVERT_PRIVATE since the whole file
>>> can be mmaped()?
>>>
>>> If so, then for TDX case, userspace can change the TD-owner bit of the
>>> private part by accessing it and later guest access will poison it and
>>> trigger #MC. If the #MC is only delivered to the PCPU that triggers it,
>>> it just leads to the TD guest being killed. If the #MC is broadcasted,
>>> it affects other in the system.
>>>
>>> I just give it a try on real TDX system with in-place conversion. The TD
>>> is killed due to SIGBUS (host kernel handles the #MC and sends the
>>> SIGBUS). It seems OK if only the TD guest being affected due to
>>> userspace accesses the private memory. But I'm not sure if there is any
>>> corner case that will affect the host.
>>
>> I suggest you go ahead and read all about in-place conversion support,
>> and how it all relates to the #MC problem you mention here.
>>
>> Long story short: SIGBUS is triggered by the fault handler, not by the
>> #MC, because private pages cannot be faulted in and accessed.
>>
> 
> Sorry for the wrong information and thanks for your patience!

No problem. As raised, it would all be clearer if we started out with 
guest_memfd behaving just like memfd (mmap() support etc) and then added 
support for "private" memory on top.

But that's not how it happened :)

-- 
Cheers,

David / dhildenb


