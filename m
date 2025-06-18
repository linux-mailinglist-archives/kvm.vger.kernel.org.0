Return-Path: <kvm+bounces-49837-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E739AADE9AE
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 13:14:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 31CB2189764D
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 11:14:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3002B293C5C;
	Wed, 18 Jun 2025 11:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gswJqYsE"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF06B293C47
	for <kvm@vger.kernel.org>; Wed, 18 Jun 2025 11:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750245273; cv=none; b=qXBtPsepW9wXd3Y00lPYiU6enI2HRimS9tXuDdZMtgzAur/5hdbJwsISkX7xUC9+VPjUEHR7yMAMpBo5axc09nn4YO1nRyULEMSsqOBGh4p2QjbLnGqA/kb6h2ckdu9rLetPiTDxXR3+wzHqUK1bEnb5yH9VP7xfWvEWImI/PQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750245273; c=relaxed/simple;
	bh=6qtGSE1w0CNxAzAkMNZK1X6JsbLwpfpX2U+jmskmM8c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UDAnGAfwt27kBtwSeT/7YFqgd3mcMIiHwAeqv1PqtoulWKxmP3nXM8BXEA/6/SIsxLvhoJVjjEgFSQcQcJUwZ2f/nD+ovejGpa7KaZ7v0/g0MeLfBDFHdTCP9qT8tnjOaVRaWQqQXZ/pntQl6Tltg0P73eikD/kQpa3utxlCLmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gswJqYsE; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750245270;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=NZ4Sh2TNEB6jFhc5CnrJMcbULxoLhOfWt9tRQvr4UwY=;
	b=gswJqYsEzO56btDLsMA9FLXK1OTUq5YqaaMN6NXZwSljnf3agME8m2/n0Xi20Kb3hFL+3K
	/g/k8IQ15f+7DE38kPkwQJ7Fy2jdNfakrv+ifdt4J/4cAlEPVwbfxVvtTfpblU3aslGCcZ
	SW2XCB//gQsEInM/rIvS5wB46cK8r7s=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-424-hKH0ulHtORSIc2KqlWfa8w-1; Wed, 18 Jun 2025 07:14:29 -0400
X-MC-Unique: hKH0ulHtORSIc2KqlWfa8w-1
X-Mimecast-MFC-AGG-ID: hKH0ulHtORSIc2KqlWfa8w_1750245268
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-451d5600a54so57359395e9.2
        for <kvm@vger.kernel.org>; Wed, 18 Jun 2025 04:14:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750245268; x=1750850068;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=NZ4Sh2TNEB6jFhc5CnrJMcbULxoLhOfWt9tRQvr4UwY=;
        b=u5JugfbgVsZvaTqsRrJnhony7sz6BtVV7c/8/adnToLgZwFEFxPj4W46mLCZR8CoTt
         6sdvEILIi2J6BitdhV6/bm6b6GmCiQfu4I+JCQuDk2nBpMYPBBNFMLrn2Fb9rDuP/kqo
         OWTzdWIHHrdG4C3CxwldztWlMVbwBhkkScmxVVZsc/OiXmPe7jZ1rAdNFHXhV7jTNgyF
         x/xiTcQ1vG/vGP7FyQ47MTxMA/c9vKKqZxDYQ8HAzp+aC8d6BCVA4xS8/AP5QLPm9RR+
         xRCOIZklNlsHRMLH1gy23amrHN8COc+fBtiHmkTuEKrZ/x33sCSk3kyjNgfh201XzfiM
         9MZQ==
X-Forwarded-Encrypted: i=1; AJvYcCWPkuH+KsJHGyHM/ZgJodNJ/KvgBLD7vG+qFkxSwUzoxB30kHt4Ag8SDnfPfdEMvl27wW0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxun6gWIusFE0S9Kp6jz5DZ/R2bN9tf5KQgxPwRixAiyq96JAkj
	kPdCIFKXy9IfSpQGXp15NUpLU7uFSwVmSobXLyWJIFVp+z28UVsMqBIbOORbWgW6eqhoO3EeaBm
	fS62zt7+3wP60vg5aTnjLnfR4yk4DJsS7UTMejJ9hqq9qyZWzoelLfA==
X-Gm-Gg: ASbGnctn9AxyWfj0o9aCdbzyKVpDgTp7Sqd8M98KD6nS+DHb9Aatrg/1ksbFInpBKiu
	W1po+OqQdjPA+s+gnGK3aNQJyp0yO4eiGDF+Raw33a3CjEl6uF1TIBeAlbILUD1A/q0c0gzqSyS
	fRnqnZ96KHc4DjZTwyhaio7pnWm8a98A8HkriGNOm4nuNuIw7Na4DbMsgWQ5l3gCmJnJxrAtQRC
	cuXbg+7W5QcumJVI7mW8wPUbboDuIg8Q9ZYt2AkozwPyV95JOrLwhy0nuF4Vdi8FeDh1at3EIlp
	sxJvfUNrvpqgzZuqeh3kzkEFPFdVx15a/4ldry4DwiyhsVbwAPzQ3BD7u9ODMxza/p1Ui/+i+zy
	oh9/MCVAeKqKn68YNJ5GI6vrlRp7ogghiXTns788a1R61tIU=
X-Received: by 2002:a05:600c:1d0d:b0:441:b00d:e9d1 with SMTP id 5b1f17b1804b1-4533ca4658amr167112835e9.2.1750245268146;
        Wed, 18 Jun 2025 04:14:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGIKgSyzRN5QJMO30mR8Px4DrceP8hUa5jeon2IxaAbEK897ArWZXgkN44/7tkWZQBfXkjm4g==
X-Received: by 2002:a05:600c:1d0d:b0:441:b00d:e9d1 with SMTP id 5b1f17b1804b1-4533ca4658amr167112155e9.2.1750245267648;
        Wed, 18 Jun 2025 04:14:27 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f2d:2400:4052:3b5:fff9:4ed0? (p200300d82f2d2400405203b5fff94ed0.dip0.t-ipconnect.de. [2003:d8:2f2d:2400:4052:3b5:fff9:4ed0])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a568b61071sm16688257f8f.90.2025.06.18.04.14.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Jun 2025 04:14:27 -0700 (PDT)
Message-ID: <38101158-4475-4885-83e7-654045ca0f9b@redhat.com>
Date: Wed, 18 Jun 2025 13:14:24 +0200
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
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <fa3cea2a-d005-44fd-8a2f-2bcea1dc9042@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 18.06.25 12:42, Xiaoyao Li wrote:
> On 6/18/2025 5:59 PM, David Hildenbrand wrote:
>> On 18.06.25 11:44, Xiaoyao Li wrote:
>>> On 6/18/2025 5:27 PM, David Hildenbrand wrote:
>>>> On 18.06.25 11:20, Xiaoyao Li wrote:
>>>>> On 6/18/2025 4:15 PM, David Hildenbrand wrote:
>>>>>>> If we are really dead set on having SHARED in the name, it could be
>>>>>>> GUEST_MEMFD_FLAG_USER_MAPPABLE_SHARED or
>>>>>>> GUEST_MEMFD_FLAG_USER_MAP_SHARED?  But
>>>>>>> to me that's _too_ specific and again somewhat confusing given the
>>>>>>> unfortunate
>>>>>>> private vs. shared usage in CoCo-land.  And just playing the odds,
>>>>>>> I'm
>>>>>>> fine taking
>>>>>>> a risk of ending up with GUEST_MEMFD_FLAG_USER_MAPPABLE_PRIVATE or
>>>>>>> whatever,
>>>>>>> because I think that is comically unlikely to happen.
>>>>>>
>>>>>> I think in addition to GUEST_MEMFD_FLAG_MMAP we want something to
>>>>>> express "this is not your old guest_memfd that only supports private
>>>>>> memory". And that's what I am struggling with.
>>>>>
>>>>> Sorry for chiming in.
>>>>>
>>>>> Per my understanding, (old) guest memfd only means it's the memory that
>>>>> cannot be accessed by userspace. There should be no shared/private
>>>>> concept on it.
>>>>>
>>>>> And "private" is the concept of KVM. Guest memfd can serve as private
>>>>> memory, is just due to the character of it cannot be accessed from
>>>>> userspace.
>>>>>
>>>>> So if the guest memfd can be mmap'ed, then it become userspace
>>>>> accessable and cannot serve as private memory.
>>>>>
>>>>>> Now, if you argue "support for mmap() implies support for non-private
>>>>>> memory", I'm probably okay for that.
>>>>>
>>>>> I would say, support for mmap() implies cannot be used as private
>>>>> memory.
>>>>
>>>> That's not where we're heading with in-place conversion support: you
>>>> will have private (ianccessible) and non-private (accessible) parts, and
>>>> while guest_memfd will support mmap() only the accessible parts can
>>>> actually be accessed (faulted in etc).
>>>
>>> That's OK. The guestmemfd can be fine-grained, i.e., different
>>> range/part of it can have different access property. But one rule never
>>> change: only the sub-range is not accessible by userspace can it be
>>> serve as private memory.
>>
>> I'm sorry, I don't understand what you are getting at.
>>
>> You said "So if the guest memfd can be mmap'ed, then it become userspace
>> accessable and cannot serve as private memory." and I say, with in-place
>> conversion support you are wrong.
>>
>> The whole file can be mmaped(), that does not tell us anything about
>> which parts can be private or not.
> 
> So there is nothing prevent userspace from accessing it after a range is
> converted to private via KVM_GMEM_CONVERT_PRIVATE since the whole file
> can be mmaped()?
> 
> If so, then for TDX case, userspace can change the TD-owner bit of the
> private part by accessing it and later guest access will poison it and
> trigger #MC. If the #MC is only delivered to the PCPU that triggers it,
> it just leads to the TD guest being killed. If the #MC is broadcasted,
> it affects other in the system.
> 
> I just give it a try on real TDX system with in-place conversion. The TD
> is killed due to SIGBUS (host kernel handles the #MC and sends the
> SIGBUS). It seems OK if only the TD guest being affected due to
> userspace accesses the private memory. But I'm not sure if there is any
> corner case that will affect the host.

I suggest you go ahead and read all about in-place conversion support, 
and how it all relates to the #MC problem you mention here.

Long story short: SIGBUS is triggered by the fault handler, not by the 
#MC, because private pages cannot be faulted in and accessed.

-- 
Cheers,

David / dhildenb


