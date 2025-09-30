Return-Path: <kvm+bounces-59136-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A8DABAC6D2
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 12:13:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 661B67A718E
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 10:11:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FAA42F7ADE;
	Tue, 30 Sep 2025 10:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="z3gbmpXB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f66.google.com (mail-wm1-f66.google.com [209.85.128.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9739C2F656A
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 10:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759227194; cv=none; b=sCqpvlQOGjHqFkMNb4FSp7zU5XpvXK3PutEb9rcBV2frjwmOz3TDA/i7mR4LD1b9APGyI4d9ITQeHu2humIOhGxf1aPMk1bLqXcNoG7tDPeYrmE73SLTS8xdRXfi+IC4u63X27WQaxzYPfTXht/cMSplE4RperqlulxtpeS0OOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759227194; c=relaxed/simple;
	bh=QGWFxWRBbhtuW57I+mv8hunmmJuL6vIUgYyxVEl57TM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DvFOhCOGiLU67oQjsv8GhLDC+CASJi5WTShVVKyocPdUcH91T8yw8qTdaGmpg2yZn2JpSss7J1gL3udzPS5zOGu0RwCEGpWPX55XK5w0wHX1o/lEtBRv2D4tjh1RPOQfwIDfaMeZV4OlQSWqpL3/W2XP9kl9s4m2BVXtkDvJujw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=z3gbmpXB; arc=none smtp.client-ip=209.85.128.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f66.google.com with SMTP id 5b1f17b1804b1-46e3af7889fso32659225e9.2
        for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 03:13:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759227191; x=1759831991; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5Fmj4kPweqGagopkTjTJLhrAbweIQr5nzSW5aUdudZo=;
        b=z3gbmpXBC6u3tP83h9NqTsF9CYDZtTuFtU/L7Nt1KQDkX5OfuR21bp6Qtz3VUnJgAP
         FMOxLhfQq61jb9cFRBlddbly0EgBCDr6Ly377ecCX0dVODyZEB6hG3jSkeQB0yxJBEKb
         QeCsHV3k+FIR9TnXuoag7mYmpDpp0Zvow7tSk9Wvjv8fGktetmGWPW1rhnu+stxTlm0b
         K8ltH+SuYNEvnh266XNyo9Q8UyI80f6jwNNm+DF+Genluexda4c+3vt/vQvpQsB3D4pM
         PvXVkoEUuFfLqvNkNg+hcc1ehpaYEIYepA5V7OhvuRZxskEvfIh0aUm1HpOHZrWzRSlB
         qhrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759227191; x=1759831991;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5Fmj4kPweqGagopkTjTJLhrAbweIQr5nzSW5aUdudZo=;
        b=L5783iHvAFQq2IdN09Gd2Q0AoT9e9r/dB2wgaiH6TXbDI36EmLrdYLdHutVMDdXwUp
         3TRQ53+oOeCfovMECPWvbvuYr2WDi7uHwRCsaK9z+3NmK4S1TuNqrHhPhRL3lRJUk/Q7
         hUkrPoZ1OgnvUpc8E8XE6ADjwUSTXfsnbz1tpGyFmBZ69t8K9GEH7jhkttRdxnliJ00i
         KpLofnnbW5FvSVFhYS2m38+AgN2kQliurVmE2l87KZFGqVwhB5hMnbU6EFHnrPcsrGKd
         KsnNs4tqgVdR8nxXmQkHVVoVnsVUliQTBzgA+Dgmk3BFfDYTKBP3yTCxDFgRLjkn5+XS
         tHHA==
X-Forwarded-Encrypted: i=1; AJvYcCXAeEQz+OV+ZXpVfo3Y/OKkgnFOOzMqFd40prJ4zr8JDknnVLcjNtCzUR98ch2xcIdRj9Y=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywm1PUC3/z6doieK15xnwVHXMSGIDng73wXFeYoNRgKQgO/eM3F
	WgseSOoQi7+aR+JP4DEbtqiYxZHyE1lIDnD3sBJfdg+eyENW2mfvD7MDAMbOPIcmtndbt+ZfVC0
	EVX8qS0CsgNKr
X-Gm-Gg: ASbGncscv4YiE97cMCNNwvvmTMg/ix1/jMLXrwy4uLSX8s8+8UQrrZ0m1hfmUtcGxxU
	vI2oyO+KMuS09SHFPFB1uWYHOTjxSORTnxJDnLpDH9FZrELK23lznnSuEd6x1zHSKhOG/KB/05Q
	3xE6BKbsG9C7oNhE8eouxzWap3G2w1ME8PpL511txrRwiJWsEZGIc3jpDAt3TkggzcrFICFKicj
	T0JMVdMVSTAY108fgXonsLDGajnKHj0/ylBlZobrZDIO1wZQo69+uK6e4my7MiQJv98o7o1Wc1t
	f7ZHgvIsqz5Nux44g8KjAsWX9up4GMTRZtVGml/a9t6EYMaJsrxUkRysTSBaGxguVvgEOjAM1Wk
	LcgitHda/vsVEVaYcFVQnqrhP45ZPakIRwctTFYeACpdZp1eq2MAwnLBavqbuSMs8E16igMC6Q6
	kGfQspl01n5b8byw2yTOgNKULw
X-Google-Smtp-Source: AGHT+IF+rnMcicNbR48yOpulUbrNdTkYdf+ObbjrIr9iaYQ/1taKuu6ICTWxB4B00uV+sYRmcLDB+g==
X-Received: by 2002:a05:600c:444e:b0:46e:1a5e:211 with SMTP id 5b1f17b1804b1-46e329f66f1mr159958645e9.21.1759227190642;
        Tue, 30 Sep 2025 03:13:10 -0700 (PDT)
Received: from [192.168.69.221] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fc5603365sm22687164f8f.37.2025.09.30.03.13.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Sep 2025 03:13:10 -0700 (PDT)
Message-ID: <75cc454b-94d2-45e1-a766-71e6b2d62ac9@linaro.org>
Date: Tue, 30 Sep 2025 12:13:08 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 02/18] system/memory: Better describe @plen argument of
 flatview_translate()
Content-Language: en-US
To: Thomas Huth <thuth@redhat.com>, qemu-devel@nongnu.org,
 Peter Maydell <peter.maydell@linaro.org>, Peter Xu <peterx@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>,
 Ilya Leoshkevich <iii@linux.ibm.com>, Reinoud Zandijk <reinoud@netbsd.org>,
 Zhao Liu <zhao1.liu@intel.com>, David Hildenbrand <david@redhat.com>,
 Halil Pasic <pasic@linux.ibm.com>, kvm@vger.kernel.org,
 "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
 xen-devel@lists.xenproject.org, Stefano Garzarella <sgarzare@redhat.com>,
 David Woodhouse <dwmw2@infradead.org>,
 Sunil Muthuswamy <sunilmut@microsoft.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Matthew Rosato <mjrosato@linux.ibm.com>, qemu-s390x@nongnu.org,
 Paul Durrant <paul@xen.org>, "Michael S. Tsirkin" <mst@redhat.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Anthony PERARD <anthony@xenproject.org>, Jason Herne
 <jjherne@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Eric Farman <farman@linux.ibm.com>
References: <20250930082126.28618-1-philmd@linaro.org>
 <20250930082126.28618-3-philmd@linaro.org>
 <525dd07f-ae64-4ba7-b3ec-b9fcd86aa8a5@redhat.com>
 <ededf937-5424-4cf7-8ea1-e07709db27f1@linaro.org>
 <9993b187-7b44-4f9b-801d-fdfa6b309362@redhat.com>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <9993b187-7b44-4f9b-801d-fdfa6b309362@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 30/9/25 11:18, Thomas Huth wrote:
> On 30/09/2025 10.31, Philippe Mathieu-Daudé wrote:
>> Hi Thomas,
>>
>> On 30/9/25 10:24, Thomas Huth wrote:
>>> On 30/09/2025 10.21, Philippe Mathieu-Daudé wrote:
>>>> flatview_translate()'s @plen argument is output-only and can be NULL.
>>>>
>>>> When Xen is enabled, only update @plen_out when non-NULL.
>>>>
>>>> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
>>>> ---
>>>>   include/system/memory.h | 5 +++--
>>>>   system/physmem.c        | 9 +++++----
>>>>   2 files changed, 8 insertions(+), 6 deletions(-)
>>>>
>>>> diff --git a/include/system/memory.h b/include/system/memory.h
>>>> index aa85fc27a10..3e5bf3ef05e 100644
>>>> --- a/include/system/memory.h
>>>> +++ b/include/system/memory.h
>>>> @@ -2992,13 +2992,14 @@ IOMMUTLBEntry 
>>>> address_space_get_iotlb_entry(AddressSpace *as, hwaddr addr,
>>>>    * @addr: address within that address space
>>>>    * @xlat: pointer to address within the returned memory region 
>>>> section's
>>>>    * #MemoryRegion.
>>>> - * @len: pointer to length
>>>> + * @plen_out: pointer to valid read/write length of the translated 
>>>> address.
>>>> + *            It can be @NULL when we don't care about it.
>>>>    * @is_write: indicates the transfer direction
>>>>    * @attrs: memory attributes
>>>>    */
>>>>   MemoryRegion *flatview_translate(FlatView *fv,
>>>>                                    hwaddr addr, hwaddr *xlat,
>>>> -                                 hwaddr *len, bool is_write,
>>>> +                                 hwaddr *plen_out, bool is_write,
>>>>                                    MemTxAttrs attrs);
>>>>   static inline MemoryRegion *address_space_translate(AddressSpace *as,
>>>> diff --git a/system/physmem.c b/system/physmem.c
>>>> index 8a8be3a80e2..86422f294e2 100644
>>>> --- a/system/physmem.c
>>>> +++ b/system/physmem.c
>>>> @@ -566,7 +566,7 @@ iotlb_fail:
>>>>   /* Called from RCU critical section */
>>>>   MemoryRegion *flatview_translate(FlatView *fv, hwaddr addr, hwaddr 
>>>> *xlat,
>>>> -                                 hwaddr *plen, bool is_write,
>>>> +                                 hwaddr *plen_out, bool is_write,
>>>>                                    MemTxAttrs attrs)
>>>>   {
>>>>       MemoryRegion *mr;
>>>> @@ -574,13 +574,14 @@ MemoryRegion *flatview_translate(FlatView *fv, 
>>>> hwaddr addr, hwaddr *xlat,
>>>>       AddressSpace *as = NULL;
>>>>       /* This can be MMIO, so setup MMIO bit. */
>>>> -    section = flatview_do_translate(fv, addr, xlat, plen, NULL,
>>>> +    section = flatview_do_translate(fv, addr, xlat, plen_out, NULL,
>>>>                                       is_write, true, &as, attrs);
>>>>       mr = section.mr;
>>>> -    if (xen_enabled() && memory_access_is_direct(mr, is_write, 
>>>> attrs)) {
>>>> +    if (xen_enabled() && plen_out && memory_access_is_direct(mr, 
>>>> is_write,
>>>> +                                                             attrs)) {
>>>>           hwaddr page = ((addr & TARGET_PAGE_MASK) + 
>>>> TARGET_PAGE_SIZE) - addr;
>>>> -        *plen = MIN(page, *plen);
>>>> +        *plen_out = MIN(page, *plen_out);
>>>>       }
>>>
>>> My question from the previous version is still unanswered:
>>>
>>> https://lore.kernel.org/qemu- 
>>> devel/22ff756a-51a2-43f4-8fe1-05f17ff4a371@redhat.com/
>>
>> This patches
>> - checks for plen not being NULL
>> - describes it as
>>    "When Xen is enabled, only update @plen_out when non-NULL."
>> - mention that in the updated flatview_translate() documentation
>>    "It can be @NULL when we don't care about it." as documented for
>>    the flatview_do_translate() callee in commit d5e5fafd11b ("exec:
>>    add page_mask for flatview_do_translate")
>>
>> before:
>>
>>    it was not clear whether we can pass plen=NULL without having
>>    to look at the code.
>>
>> after:
>>
>>    no change when plen is not NULL, we can pass plen=NULL safely
>>    (it is documented).
>>
>> I shouldn't be understanding your original question, do you mind
>> rewording it?
> 
> Ah, you've updated the patch in v3 to include a check for plen_out in 
> the if-statement! It was not there in v2. Ok, this should be fine now:
> 
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> 
> I just re-complained since you did not respond to my mail in v2, and 
> when I looked at the changelog in your v3 cover letter, you did not 
> mention the modification here, so I blindly assumed that this patch was 
> unchanged.

Ah I see... OK I'll try to be more explicit in my respins.

Thanks for your review!

Phil.

