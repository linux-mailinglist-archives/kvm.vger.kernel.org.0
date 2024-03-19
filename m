Return-Path: <kvm+bounces-12117-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BF4987FB53
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 10:58:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 360F31C21B2C
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 09:58:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B42CC7E59D;
	Tue, 19 Mar 2024 09:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LgngeGq0"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58B207E59A
	for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 09:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710842068; cv=none; b=SQPIlbN+WfF5pZFUj0HEkznQoC0R05chXXWk/SGUqQpnuOK6d0wjwJpR7pdoQ6AYScYbgsNnY7LZnDycDamKQdWS4BlvsWNZ2KXrGuuqDhfg3Jl36EYlHdZLIeZbZnkxLZipkHGghWkfH3TAriJrIhjIFqc4jQrgPhzCCDbMNpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710842068; c=relaxed/simple;
	bh=K/4PfF+tYHqStM63SgGuf/2JKa15Uw5JC/Vkgi2ushE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=f/TwT0M0AJBv8FiLoA27rads079TERMtm/Y40TRIWYdjdcaJOGFHPkKHqyxyH3gqmaFwwhm0Mxs4fSHZJluIm1iWqaLerrm0iXn82u2pAvs7STjZ4KDN1XGHmX6PHGTXyo47SaMyNBHmZWbXlk+NF5yZCrdqaO55+xVsOakAnQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LgngeGq0; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710842066;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=h75rJNbjTnf0OcHQw3x/FkbJWebdes8x11NFS4+PgT8=;
	b=LgngeGq0HdBO6fcMPRfFpU/v4Z58V6rBE01zavOU2JRLyqa6r14dgvF7HWMzUzzsGmKBHN
	tUfp9xrReDkTkUF3HJDi0FiM6gBSJ6dxkFq5uxYf0yUA2ZbX6rEd1SCjIVJX+wFV6lbtLO
	bFY4ZpnEihR0bg55ZBjbEy+DjUubXm4=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-689-2T7sJ99ZNHuFh3vS3PFwpQ-1; Tue, 19 Mar 2024 05:54:24 -0400
X-MC-Unique: 2T7sJ99ZNHuFh3vS3PFwpQ-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4140a47f514so14681165e9.0
        for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 02:54:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710842063; x=1711446863;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt:from
         :references:cc:to:content-language:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h75rJNbjTnf0OcHQw3x/FkbJWebdes8x11NFS4+PgT8=;
        b=PLpAub1s7QeoIN98iVBCPKzAnlGqnPuTi2pWU0OHyvHHVsgftoXdVPfrGB0ZY6BCsj
         7IVCcF3qfqJq0PknP/Zg3FNPSA0fr/na3DT6UlTu7gWYRhX6DXfSGtLZmVm6UE0pMkja
         bR2I2gXc/2U69ABHc5xAIcKGUi3nfFlS/UvnFpv7tvM1njPO9pNpmkz15a5b0btCuEUo
         f03vE1rverLv7ckcSNH6bjo3gBa7lX8fG+w+n0X3+t8QJ93W4YlIBnS4R3KVqFLrPUNq
         PCdcF5c7O7uwAXV5npiNAty7gduusxfA3BJ+egYvDKJK6bUwjmiBlF4mwrsFJtDNgk0F
         r03g==
X-Forwarded-Encrypted: i=1; AJvYcCXNZTTgmL981l1ZYTVYSz121c/5QLeKjnqZmEiPqONqV9mpb38JLYv/EEUw/3bXJMCcY6MsKnvjkyza6HQbmZfjKYT4
X-Gm-Message-State: AOJu0Yz/Qm5fBJC3IlWNemqQANyU8NMmeXgVFgw2+xgU+uWALGyw55N5
	10u7ELBp5fFjFht01ffpNrVXZr6HMjM69J4e/l4iWbsBA+tElH4i0ay0Fh408NnC+Kiqv/suK1I
	nyNMNSOcm79biNzLfvKTsQQJliptUGJFGhhLa3r6AZQJl9Flseg==
X-Received: by 2002:a05:600c:1c84:b0:412:e70a:ab8a with SMTP id k4-20020a05600c1c8400b00412e70aab8amr10839500wms.25.1710842063508;
        Tue, 19 Mar 2024 02:54:23 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE5Ggr0h0CsR5zaVuPj0wHJgcPzLTcPmrLF5jw5gTfCMJdgtAjQppU2RxG5vLt59MOXWtZstQ==
X-Received: by 2002:a05:600c:1c84:b0:412:e70a:ab8a with SMTP id k4-20020a05600c1c8400b00412e70aab8amr10839469wms.25.1710842063066;
        Tue, 19 Mar 2024 02:54:23 -0700 (PDT)
Received: from ?IPV6:2003:cb:c741:2200:2adc:9a8d:ae91:2e9f? (p200300cbc74122002adc9a8dae912e9f.dip0.t-ipconnect.de. [2003:cb:c741:2200:2adc:9a8d:ae91:2e9f])
        by smtp.gmail.com with ESMTPSA id e13-20020a05600c218d00b00412cfdc41f7sm439884wme.0.2024.03.19.02.54.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Mar 2024 02:54:22 -0700 (PDT)
Message-ID: <73f5f05b-2826-49ea-a3fd-3f1a5b14a223@redhat.com>
Date: Tue, 19 Mar 2024 10:54:19 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: folio_mmapped
Content-Language: en-US
To: Quentin Perret <qperret@google.com>
Cc: Sean Christopherson <seanjc@google.com>,
 Matthew Wilcox <willy@infradead.org>, Fuad Tabba <tabba@google.com>,
 kvm@vger.kernel.org, kvmarm@lists.linux.dev, pbonzini@redhat.com,
 chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org,
 paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu,
 viro@zeniv.linux.org.uk, brauner@kernel.org, akpm@linux-foundation.org,
 xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com,
 jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com,
 yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net,
 vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com,
 mail@maciej.szmigiero.name, michael.roth@amd.com, wei.w.wang@intel.com,
 liam.merwick@oracle.com, isaku.yamahata@gmail.com,
 kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com,
 steven.price@arm.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com,
 quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com,
 quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com,
 james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev,
 maz@kernel.org, will@kernel.org, keirf@google.com, linux-mm@kvack.org
References: <755911e5-8d4a-4e24-89c7-a087a26ec5f6@redhat.com>
 <Zd8qvwQ05xBDXEkp@google.com>
 <99a94a42-2781-4d48-8b8c-004e95db6bb5@redhat.com>
 <Zd82V1aY-ZDyaG8U@google.com>
 <fc486cb4-0fe3-403f-b5e6-26d2140fcef9@redhat.com>
 <ZeXAOit6O0stdxw3@google.com> <ZeYbUjiIkPevjrRR@google.com>
 <ae187fa6-0bc9-46c8-b81d-6ef9dbd149f7@redhat.com>
 <20240304132732963-0800.eberman@hu-eberman-lv.qualcomm.com>
 <4b0fd46a-cc4f-4cb7-9f6f-ce19a2d3064e@redhat.com>
 <ZflfPDhZFufZdmp0@google.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <ZflfPDhZFufZdmp0@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 19.03.24 10:47, Quentin Perret wrote:
> On Monday 04 Mar 2024 at 22:58:49 (+0100), David Hildenbrand wrote:
>> On 04.03.24 22:43, Elliot Berman wrote:
>>> On Mon, Mar 04, 2024 at 09:17:05PM +0100, David Hildenbrand wrote:
>>>> On 04.03.24 20:04, Sean Christopherson wrote:
>>>>> On Mon, Mar 04, 2024, Quentin Perret wrote:
>>>>>>> As discussed in the sub-thread, that might still be required.
>>>>>>>
>>>>>>> One could think about completely forbidding GUP on these mmap'ed
>>>>>>> guest-memfds. But likely, there might be use cases in the future where you
>>>>>>> want to use GUP on shared memory inside a guest_memfd.
>>>>>>>
>>>>>>> (the iouring example I gave might currently not work because
>>>>>>> FOLL_PIN|FOLL_LONGTERM|FOLL_WRITE only works on shmem+hugetlb, and
>>>>>>> guest_memfd will likely not be detected as shmem; 8ac268436e6d contains some
>>>>>>> details)
>>>>>>
>>>>>> Perhaps it would be wise to start with GUP being forbidden if the
>>>>>> current users do not need it (not sure if that is the case in Android,
>>>>>> I'll check) ? We can always relax this constraint later when/if the
>>>>>> use-cases arise, which is obviously much harder to do the other way
>>>>>> around.
>>>>>
>>>>> +1000.  At least on the KVM side, I would like to be as conservative as possible
>>>>> when it comes to letting anything other than the guest access guest_memfd.
>>>>
>>>> So we'll have to do it similar to any occurrences of "secretmem" in gup.c.
>>>> We'll have to see how to marry KVM guest_memfd with core-mm code similar to
>>>> e.g., folio_is_secretmem().
>>>>
>>>> IIRC, we might not be able to de-reference the actual mapping because it
>>>> could get free concurrently ...
>>>>
>>>> That will then prohibit any kind of GUP access to these pages, including
>>>> reading/writing for ptrace/debugging purposes, for core dumping purposes
>>>> etc. But at least, you know that nobody was able to optain page references
>>>> using GUP that might be used for reading/writing later.
>>>
>>> Do you have any concerns to add to enum mapping_flags, AS_NOGUP, and
>>> replacing folio_is_secretmem() with a test of this bit instead of
>>> comparing the a_ops? I think it scales better.
>>
>> The only concern I have are races, but let's look into the details:
>>
>> In GUP-fast, we can essentially race with unmap of folios, munmap() of VMAs
>> etc.
>>
>> We had a similar discussion recently about possible races. It's documented
>> in folio_fast_pin_allowed() regarding disabled IRQs and RCU grace periods.
>>
>> "inodes and thus their mappings are freed under RCU, which means the mapping
>> cannot be freed beneath us and thus we can safely dereference it."
>>
>> So if we follow the same rules as folio_fast_pin_allowed(), we can
>> de-reference folio->mapping, for example comparing mapping->a_ops.
>>
>> [folio_is_secretmem should better follow the same approach]
> 
> Resurecting this discussion, I had discussions internally and as it
> turns out Android makes extensive use of vhost/vsock when communicating
> with guest VMs, which requires GUP. So, my bad, not supporting GUP for
> the pKVM variant of guest_memfd is a bit of a non-starter, we'll need to
> support it from the start. But again this should be a matter of 'simply'
> having a dedicated KVM exit reason so hopefully it's not too bad.

Likely you should look into ways to teach these interfaces that require 
GUP to consume fd+offset instead.

Yes, there is no such thing as free lunch :P

-- 
Cheers,

David / dhildenb


