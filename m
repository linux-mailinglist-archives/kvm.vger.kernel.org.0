Return-Path: <kvm+bounces-21344-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B421B92DA99
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 23:14:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6A110282B98
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 21:14:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3B3F12BEBB;
	Wed, 10 Jul 2024 21:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TuxM9/LV"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF78D2B9DD
	for <kvm@vger.kernel.org>; Wed, 10 Jul 2024 21:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720646051; cv=none; b=bj7wrSbDPlV8fxaexTYAEjjBlfvQXKApvzA3paG9Yv999ayg01hKJTitr04HNgSg7a2YBKxRMw1KgMB0hhlizgtLUUE9sxcGPKWDIEnJpo/1oa9Hvu1OyISGcxQkDL5RT0O1ELSCdEtKGFjuT02TfWaI0QGl6IJv2EjxTcWobq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720646051; c=relaxed/simple;
	bh=LxJp3MpjlW3XhQhZ/broXQZIzle4N+yhALuMK83M/+U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MeAtqIf2TT8FdlBtO/CNV1LB062Y+P5ykvM/KCxwO20Nqcpz+f3tZD8Ila+mDHs4f7Z1DcsRwVFpo/jYl0OU6FXEaYrS7Qfkhvkpf/t3y0E9v9SsPwKM95EXQu1LdVGXle0jmXtTXyX7E063r8RewKkiAOsyYj5zcPTqG7woODM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TuxM9/LV; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720646049;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=UelbpIUr40UAVvqSX5FfP2oj9LzgIV56BaNyb4HIROM=;
	b=TuxM9/LV4TmYAEylcR2JdsPepJX7e3T3A9HwbbgVsCAKsXcNC5lpO3BzL9TIONnTz00vJs
	YG+aMWJsSX9CI+PFqGet73yOoAIWiViaPelh8DA4kHH0F744hBXIZijtcX8jHH5PIAVX1q
	UNWyegrA0DyRGOy9ryRoLne54Mn6k8Y=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-328-7EQIavpEPY2e-lib6ytxBQ-1; Wed, 10 Jul 2024 17:14:07 -0400
X-MC-Unique: 7EQIavpEPY2e-lib6ytxBQ-1
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-70b59d7b5e9so235552b3a.1
        for <kvm@vger.kernel.org>; Wed, 10 Jul 2024 14:14:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720646047; x=1721250847;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=UelbpIUr40UAVvqSX5FfP2oj9LzgIV56BaNyb4HIROM=;
        b=S/6JInGcc4Cvn4FCOj5Z19wULl3t9kfkqYMeTVgpfq5O7vV9xPhzuA120WsgVxvTZj
         y5iU+/+HUZbSHL/V6A6vk5tokcFLwaxLlI+35w9bPebF7Q4iTpqE//RCrMbs4TTpcC2G
         tKKm0SiXMnSmHIr55cUW9eazxzQiNIp7k7FvjDEAPOZg1fDitp9cvDFIj0yryZXITlBR
         TMQrV2WYNK/U7Qz/kWVezcnJqy1VJ0kx1BNj66v9ZVXV3xcUllc2E79o4hQzhFuZ4BZQ
         RizEAOTAQMuO9d9rK29dHfQASCzivdPk6xjFJDpVQjiw6MXF8MzFHl3tejlg2lfqSqYB
         kKmA==
X-Forwarded-Encrypted: i=1; AJvYcCVq1VkdsdyhzwGkxPKkq7awR5EkjBH5A6zoUgJ9IM/jEQXfBLVc6plrOeJw9pKGdOc6oBCdZf9bnTMxbYKTqw5sfAlr
X-Gm-Message-State: AOJu0YyZwT7RDsyDaWOWquNihDixzM15hZSrE2OoqfYWoYW5iLcSG8R3
	tr0S8w/sToNN1zYwUveta7Oeeleuz4WhYfr7iDkVmo7M3hSnw6vPfeN0dIKRMpa468kRupLazIJ
	iGJ9YZv12EeGXJ3gwYpoCVJ3UCLlsblRR/JoWpDksDZgbCy2dqA==
X-Received: by 2002:a05:6a00:1d83:b0:70b:17a9:e98a with SMTP id d2e1a72fcca58-70b43626d6amr7509465b3a.33.1720646046748;
        Wed, 10 Jul 2024 14:14:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGIL5NZakoeWxrceiZO5dPOGtHYUbvR+7u663g+7/eUG7NXVlKeuTVAdylslhMzFr1TdO1NJw==
X-Received: by 2002:a05:6a00:1d83:b0:70b:17a9:e98a with SMTP id d2e1a72fcca58-70b43626d6amr7509431b3a.33.1720646046328;
        Wed, 10 Jul 2024 14:14:06 -0700 (PDT)
Received: from [10.35.209.243] ([208.115.86.71])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70b4397c02fsm4390228b3a.143.2024.07.10.14.14.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Jul 2024 14:14:06 -0700 (PDT)
Message-ID: <c87a4ba0-b9c4-4044-b0c3-c1112601494f@redhat.com>
Date: Wed, 10 Jul 2024 23:14:04 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 7/8] mm: secretmem: use AS_INACCESSIBLE to prohibit
 GUP
To: Patrick Roy <roypat@amazon.co.uk>, Mike Rapoport <rppt@kernel.org>
Cc: seanjc@google.com, pbonzini@redhat.com, akpm@linux-foundation.org,
 dwmw@amazon.co.uk, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 willy@infradead.org, graf@amazon.com, derekmn@amazon.com,
 kalyazin@amazon.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, dmatlack@google.com, tabba@google.com,
 chao.p.peng@linux.intel.com, xmarcalx@amazon.co.uk,
 James Gowans <jgowans@amazon.com>
References: <20240709132041.3625501-1-roypat@amazon.co.uk>
 <20240709132041.3625501-8-roypat@amazon.co.uk>
 <0dc45181-de7e-4d97-9178-573c6f683f55@redhat.com>
 <Zo45CQGe_UDUnXXu@kernel.org>
 <258b3b76-cf87-4dfc-bcfa-b2af94aba811@amazon.co.uk>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <258b3b76-cf87-4dfc-bcfa-b2af94aba811@amazon.co.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10.07.24 11:50, Patrick Roy wrote:
> 
> 
> On 7/10/24 08:32, Mike Rapoport wrote:
>> CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
>>
>>
>>
>> On Tue, Jul 09, 2024 at 11:09:29PM +0200, David Hildenbrand wrote:
>>> On 09.07.24 15:20, Patrick Roy wrote:
>>>> Inside of vma_is_secretmem and secretmem_mapping, instead of checking
>>>> whether a vm_area_struct/address_space has the secretmem ops structure
>>>> attached to it, check whether the address_space has the AS_INACCESSIBLE
>>>> bit set. Then set the AS_INACCESSIBLE flag for secretmem's
>>>> address_space.
>>>>
>>>> This means that get_user_pages and friends are disables for all
>>>> adress_spaces that set AS_INACCESIBLE. The AS_INACCESSIBLE flag was
>>>> introduced in commit c72ceafbd12c ("mm: Introduce AS_INACCESSIBLE for
>>>> encrypted/confidential memory") specifically for guest_memfd to indicate
>>>> that no reads and writes should ever be done to guest_memfd
>>>> address_spaces. Disallowing gup seems like a reasonable semantic
>>>> extension, and means that potential future mmaps of guest_memfd cannot
>>>> be GUP'd.
>>>>
>>>> Signed-off-by: Patrick Roy <roypat@amazon.co.uk>
>>>> ---
>>>>    include/linux/secretmem.h | 13 +++++++++++--
>>>>    mm/secretmem.c            |  6 +-----
>>>>    2 files changed, 12 insertions(+), 7 deletions(-)
>>>>
>>>> diff --git a/include/linux/secretmem.h b/include/linux/secretmem.h
>>>> index e918f96881f5..886c8f7eb63e 100644
>>>> --- a/include/linux/secretmem.h
>>>> +++ b/include/linux/secretmem.h
>>>> @@ -8,10 +8,19 @@ extern const struct address_space_operations secretmem_aops;
>>>>    static inline bool secretmem_mapping(struct address_space *mapping)
>>>>    {
>>>> -   return mapping->a_ops == &secretmem_aops;
>>>> +   return mapping->flags & AS_INACCESSIBLE;
>>>> +}
>>>> +
>>>> +static inline bool vma_is_secretmem(struct vm_area_struct *vma)
>>>> +{
>>>> +   struct file *file = vma->vm_file;
>>>> +
>>>> +   if (!file)
>>>> +           return false;
>>>> +
>>>> +   return secretmem_mapping(file->f_inode->i_mapping);
>>>>    }
>>>
>>> That sounds wrong. You should leave *secretmem alone and instead have
>>> something like inaccessible_mapping that is used where appropriate.
>>>
>>> vma_is_secretmem() should not suddenly succeed on something that is not
>>> mm/secretmem.c
>>
>> I'm with David here.
>>
> 
> Right, that makes sense. My thinking here was that if memfd_secret and
> potential mappings of guest_memfd have the same behavior wrt GUP, then
> it makes sense to just have them rely on the same checks. But I guess I
> didn't follow that thought to its logical conclusion of renaming the
> "secretmem" checks into "inaccessible" checks and moving them out of
> secretmem.h.
> 
> Or do you mean to just leave secretmem untouched and add separate
> "inaccessible" checks? But then we'd have two different ways of
> disabling GUP for specific VMAs that both rely on checks in exactly the
> same places :/

You can just replace the vma_is_secretmem in relevant places by checks 
if inaccessible address spaces. No need for the additional 
vma_is_secretmem check then.

BUT, as raised in my other reply, I wonder if adding support for 
secretmem in KVM (I assume) would be simpler+cleaner.

> 
>>> --
>>> Cheers,
>>>
>>> David / dhildenb
>>>
>>
>> --
>> Sincerely yours,
>> Mike.
> 

-- 
Cheers,

David / dhildenb


