Return-Path: <kvm+bounces-10835-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 63AFF870FA7
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 22:59:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1AB0B286987
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 21:59:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B419D79DCA;
	Mon,  4 Mar 2024 21:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TuF2qFo7"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4638F46BA0
	for <kvm@vger.kernel.org>; Mon,  4 Mar 2024 21:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709589557; cv=none; b=Nl7wQ5a7/uT7KRJTRnxnm3hn3giMzGPRAUnZR4XZPe266QWwFAz11YX+GNm2y/9ow8yR1nBw6aQTcWityzGNlXYMvJ2GUkCPT/OGfbef+eZvpQvhNtxO6GQd67aeU2htKVbCFvfBbDetoUo4LNC4+hjZxebkIu5XQg5/+TmjR8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709589557; c=relaxed/simple;
	bh=G4SHZ3ech5CixRjNa2561vCbZnAMqnNE+jxSUI77qas=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=G+pl0J772QdFUkVdKKUAs3gIIA/cqkd72IHEIvjPMZ7zZi1fY6n0090gQc6qLu19fl1PShBVTgSxD2ikEPP8RpDBq09+aH6iVZhjMexsoRJjY8p1zBewumUVhkCN12niLwjtP68JEYWsEnDiy+cxLX9jHHApoUTkO964E3ABkpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TuF2qFo7; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709589555;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=c7hzapgUftSzJ0qDTm+HnWc7FvIKdeON3ZcB5/QmFJc=;
	b=TuF2qFo754Bd+A+yQpR0bacdUIDx7sf8idp8bObJrnaulZHgx0SXvfCbzaUKUru/xn5cBY
	GWmAzBWUtXGYN9QuLyqqg1745uU4sISv3Nkg+26awfGsXXB9dwRMVv1r38x1LCe+dx5Epw
	ncNFmlXVgdtzxJh7wgBH/FibqBlsI6s=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-128-QMq5VVl9Nfq_hL4XenCHUw-1; Mon, 04 Mar 2024 16:59:13 -0500
X-MC-Unique: QMq5VVl9Nfq_hL4XenCHUw-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-412e0abdbf1so10743475e9.3
        for <kvm@vger.kernel.org>; Mon, 04 Mar 2024 13:59:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709589533; x=1710194333;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt:from
         :references:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=c7hzapgUftSzJ0qDTm+HnWc7FvIKdeON3ZcB5/QmFJc=;
        b=t7fuiHfG2r9zlGDcbXUhnLRPN/x+5Pmx85kOESTn55ZNBc9ck54MQO8/fRP8MRwbWl
         YtQobeQLj+x2X+NblQdc6eju0k3ncoDZKe/1Y3aLX5EcfqnwutCq8hf7bL7ea+1FIzlw
         Qsl2WIv5aSGAxBDkH9meCijKnM1Nnh4gaFOUHW3cjyD7isaersVoj23hsguF77O9h2gG
         0+u7Cuh8JpG/j4Kv7RpQ7/Uj3jadT+hGk8WZOfkRt8ysqjv+KlOgSfF1Dvvp8++9c8AX
         ZvHEV/c9vaPcdx9ObTyr8mKjBWs9M/9aiDIdKklexEYJNvagkDa6fdCZfriWz5qcuRDH
         umjg==
X-Forwarded-Encrypted: i=1; AJvYcCWiescrCt4mvFObuX2eaRMFxbmV291BmQ9hCzd0TO1UfBszDGPwmKa4K76bSUlfZBjg3Toa3QXYf67OnVDxghu4yhz1
X-Gm-Message-State: AOJu0YyvcSFu7LPkipAVQs6VT8T/zMSqMoA5cgi3YGMwY2hjfgYqsDaf
	ogvW9+DDgZZp/JatR1JoSBwtTUqlLTeLudhINBFcEgjehRtMGgWh68rR7Po0USMxdpHPGTUJEJK
	0vFamNLznCln3NAwQXHsL0QpnYcNu8mMckIFZWG0HSIJV9Ty+TQ==
X-Received: by 2002:a05:600c:458b:b0:412:bd3e:9fee with SMTP id r11-20020a05600c458b00b00412bd3e9feemr7756075wmo.0.1709589532788;
        Mon, 04 Mar 2024 13:58:52 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHeR9iNvn8pXEWlnFCd66j+Wfk1BNaSWBq6GIz+i8Gto5IYxfyk5HuG+1KJY42N/oDLcJpYtQ==
X-Received: by 2002:a05:600c:458b:b0:412:bd3e:9fee with SMTP id r11-20020a05600c458b00b00412bd3e9feemr7756032wmo.0.1709589532340;
        Mon, 04 Mar 2024 13:58:52 -0800 (PST)
Received: from ?IPV6:2003:cb:c733:f100:75e7:a0a4:9ac2:1abb? (p200300cbc733f10075e7a0a49ac21abb.dip0.t-ipconnect.de. [2003:cb:c733:f100:75e7:a0a4:9ac2:1abb])
        by smtp.gmail.com with ESMTPSA id i5-20020a05600c354500b00412e668b0dasm2956081wmq.43.2024.03.04.13.58.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Mar 2024 13:58:51 -0800 (PST)
Message-ID: <4b0fd46a-cc4f-4cb7-9f6f-ce19a2d3064e@redhat.com>
Date: Mon, 4 Mar 2024 22:58:49 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: folio_mmapped
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>,
 Quentin Perret <qperret@google.com>, Matthew Wilcox <willy@infradead.org>,
 Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
 anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk, brauner@kernel.org,
 akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com,
 chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com,
 dmatlack@google.com, yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com,
 mic@digikod.net, vbabka@suse.cz, vannapurve@google.com,
 ackerleytng@google.com, mail@maciej.szmigiero.name, michael.roth@amd.com,
 wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com,
 kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com,
 steven.price@arm.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com,
 quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com,
 quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com,
 james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev,
 maz@kernel.org, will@kernel.org, keirf@google.com, linux-mm@kvack.org
References: <925f8f5d-c356-4c20-a6a5-dd7efde5ee86@redhat.com>
 <Zd8PY504BOwMR4jO@google.com>
 <755911e5-8d4a-4e24-89c7-a087a26ec5f6@redhat.com>
 <Zd8qvwQ05xBDXEkp@google.com>
 <99a94a42-2781-4d48-8b8c-004e95db6bb5@redhat.com>
 <Zd82V1aY-ZDyaG8U@google.com>
 <fc486cb4-0fe3-403f-b5e6-26d2140fcef9@redhat.com>
 <ZeXAOit6O0stdxw3@google.com> <ZeYbUjiIkPevjrRR@google.com>
 <ae187fa6-0bc9-46c8-b81d-6ef9dbd149f7@redhat.com>
 <20240304132732963-0800.eberman@hu-eberman-lv.qualcomm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20240304132732963-0800.eberman@hu-eberman-lv.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 04.03.24 22:43, Elliot Berman wrote:
> On Mon, Mar 04, 2024 at 09:17:05PM +0100, David Hildenbrand wrote:
>> On 04.03.24 20:04, Sean Christopherson wrote:
>>> On Mon, Mar 04, 2024, Quentin Perret wrote:
>>>>> As discussed in the sub-thread, that might still be required.
>>>>>
>>>>> One could think about completely forbidding GUP on these mmap'ed
>>>>> guest-memfds. But likely, there might be use cases in the future where you
>>>>> want to use GUP on shared memory inside a guest_memfd.
>>>>>
>>>>> (the iouring example I gave might currently not work because
>>>>> FOLL_PIN|FOLL_LONGTERM|FOLL_WRITE only works on shmem+hugetlb, and
>>>>> guest_memfd will likely not be detected as shmem; 8ac268436e6d contains some
>>>>> details)
>>>>
>>>> Perhaps it would be wise to start with GUP being forbidden if the
>>>> current users do not need it (not sure if that is the case in Android,
>>>> I'll check) ? We can always relax this constraint later when/if the
>>>> use-cases arise, which is obviously much harder to do the other way
>>>> around.
>>>
>>> +1000.  At least on the KVM side, I would like to be as conservative as possible
>>> when it comes to letting anything other than the guest access guest_memfd.
>>
>> So we'll have to do it similar to any occurrences of "secretmem" in gup.c.
>> We'll have to see how to marry KVM guest_memfd with core-mm code similar to
>> e.g., folio_is_secretmem().
>>
>> IIRC, we might not be able to de-reference the actual mapping because it
>> could get free concurrently ...
>>
>> That will then prohibit any kind of GUP access to these pages, including
>> reading/writing for ptrace/debugging purposes, for core dumping purposes
>> etc. But at least, you know that nobody was able to optain page references
>> using GUP that might be used for reading/writing later.
> 
> Do you have any concerns to add to enum mapping_flags, AS_NOGUP, and
> replacing folio_is_secretmem() with a test of this bit instead of
> comparing the a_ops? I think it scales better.

The only concern I have are races, but let's look into the details:

In GUP-fast, we can essentially race with unmap of folios, munmap() of 
VMAs etc.

We had a similar discussion recently about possible races. It's 
documented in folio_fast_pin_allowed() regarding disabled IRQs and RCU 
grace periods.

"inodes and thus their mappings are freed under RCU, which means the 
mapping cannot be freed beneath us and thus we can safely dereference it."

So if we follow the same rules as folio_fast_pin_allowed(), we can 
de-reference folio->mapping, for example comparing mapping->a_ops.

[folio_is_secretmem should better follow the same approach]

So likely that should just work!

-- 
Cheers,

David / dhildenb


