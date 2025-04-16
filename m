Return-Path: <kvm+bounces-43422-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F68FA8B99E
	for <lists+kvm@lfdr.de>; Wed, 16 Apr 2025 14:53:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A367F1900DE4
	for <lists+kvm@lfdr.de>; Wed, 16 Apr 2025 12:54:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC55013777E;
	Wed, 16 Apr 2025 12:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EVLiwrm/"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C1E529B0
	for <kvm@vger.kernel.org>; Wed, 16 Apr 2025 12:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744808024; cv=none; b=MDrGIZZufXxSWEezpE5unpzLgqcQuwaZkWQpITB44INZiafQxReeIQQ4EAYyhUBadkvytP48vfo/o8XKTeL9E0nLByWpO1noHDwqHlKqFVP70YcKmvvMHIesLDkR9RH3HNFSYSu0prhYmFEKgfB5Y3+VJWxET8CL5hrCgwEtO44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744808024; c=relaxed/simple;
	bh=nB1Wp7a+KfUicRf4Fnbr4uTP9NBJvWr9+r8uNK1nsaU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Wut7KMNfna2NzsONC+Jw2QztPL6BsWJutQlB4VTmilzLYqmm5ho6F2tJPek4XP/UqWRqanvOu4fLxRAvbK/C4+88IHubdVwCRy6MlTT3aiWuexZhs09NlxziRs+mzU9JEzJbWuLA11cnIYuLDQrU60Y0eWjDsGBpv0d4ApfUXl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EVLiwrm/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744808020;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=SX5cp1sy8OIJWEPpF8wF9aWC/NYtuOCcnbHvBboOO0Q=;
	b=EVLiwrm/wd3XuBc1+xnBlMZnO/Keh22c69z6iGOng0k3BCH0JndUEBZw6hkWwhUGg3sJh8
	JgeHhZ8UmC5PGe7L86hi/WZzh4qxEP/sjw9av2B66bi4b46O1CUx9SKEUO4n16TTpNe+hB
	sWo+uWUiBaSLlgZvntf+1WDGRJa6XWM=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-364-NzvKhZiJN8CmUDAy04bMnA-1; Wed, 16 Apr 2025 08:53:39 -0400
X-MC-Unique: NzvKhZiJN8CmUDAy04bMnA-1
X-Mimecast-MFC-AGG-ID: NzvKhZiJN8CmUDAy04bMnA_1744808018
Received: by mail-lj1-f199.google.com with SMTP id 38308e7fff4ca-30c2d4271c7so27076331fa.0
        for <kvm@vger.kernel.org>; Wed, 16 Apr 2025 05:53:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744808017; x=1745412817;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=SX5cp1sy8OIJWEPpF8wF9aWC/NYtuOCcnbHvBboOO0Q=;
        b=pbfQ24yX4H6ugF1OAnIGOUIJTQy5yiRgQYLMujAucMnCDUHfgJAk9VV/vPS4wk6VV6
         LsgP4YavwYaTAXwaJn16zLzjGmxxmMMgrwDf5pSgMopU1ZcY2yrXYtoBafvM0a7nsxiO
         Ow0LuGNVmH+lZPoTVjwK/kUc8ezuIl0hzROH4YlRb9dvshR5UtiUY64znlu1h488dmdR
         XZ2OABdCfdOAmjXMJbnCoJVe5oyhBXD38D1JElCG+SkiTtLWhloy3Ab4AuxFmT0j2pa8
         T1krJUtWvERWgZQ1DIiFZWjgftr1MyS8rjRfXrNcZHlBoj+7/Hn7OJuVKrmSFyNU1GA/
         CJww==
X-Forwarded-Encrypted: i=1; AJvYcCVgAZINl2nkODQ3eWqI0OVDIPthYQP7QCqglWijUgokDf25w0fEwjVL1ItfDAV4mQ+VH8c=@vger.kernel.org
X-Gm-Message-State: AOJu0YwCV9KVwBswQVDtZaBZJ1EKHB4PepKHqi0ExczPxKvFqyHpPxBO
	Bn02h1vDyRKc9ctUDtcxihJDe15TlP1hhXw9x4vN/XsDtrlJLHKuPjtpdhKIqK6mNP+5+6vA+pb
	dinvyiWQXHJQHL0ZjzrXGCW6lEYjUwpB4LTZXN7be7ddseo+MPA==
X-Gm-Gg: ASbGncsc/cSpMxOA9g4gFEisxLC8tR9PpTYwRDpbouUdhh8nHxtODvFUqMjaLGDo4ZK
	GI3LgvlfWB2Q3d4cs4TGqS1KDFCsruiVMBNpYAZsab4opJqsi1GC4TIeT96NtjZEZ1GTTnb2Ups
	um9nOEAhSUn4J3YAynttSSs3yAbEipBbYVymb6vJrtQbk/y5rtY6d7W+NL/PvA/HL5uSKgfxJiU
	/8npy6UNnBGrv1fdKrs6+srD25svmOwU8b7FKpLcgcx3cEyy+SGeWi9tRjd+fIIOOAgnncYPtH9
	NiK7BQMAADzkbxjU8zvd/uLb35tHAtSzxvnb9F6nja9zXW/8aMCinP/3VlA9QLKE5C0Dzh2d1M8
	MfVsuIrwhZG1gKGJQeiFPnP8B8sN7+QRiArSSEg==
X-Received: by 2002:a5d:6da5:0:b0:399:6dc0:f15b with SMTP id ffacd0b85a97d-39ee5bad621mr1829044f8f.48.1744808006860;
        Wed, 16 Apr 2025 05:53:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE+vkj7MIwX/vflBwkqkVaJ5xeip9iQgj+nkSM7MvwPAOp/gpWZFT31bzyC8O8qgOVsk+LgYg==
X-Received: by 2002:a5d:6da5:0:b0:399:6dc0:f15b with SMTP id ffacd0b85a97d-39ee5bad621mr1828966f8f.48.1744808004935;
        Wed, 16 Apr 2025 05:53:24 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f02:2900:f54f:bad7:c5f4:9404? (p200300d82f022900f54fbad7c5f49404.dip0.t-ipconnect.de. [2003:d8:2f02:2900:f54f:bad7:c5f4:9404])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4404352a536sm38056165e9.1.2025.04.16.05.53.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Apr 2025 05:53:24 -0700 (PDT)
Message-ID: <91c2f8ec-ca03-4368-a220-bac639a18938@redhat.com>
Date: Wed, 16 Apr 2025 14:53:21 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 4/9] KVM: guest_memfd: Handle in-place shared memory as
 guest_memfd backed memory
To: Ackerley Tng <ackerleytng@google.com>, Fuad Tabba <tabba@google.com>,
 kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
 anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk,
 brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
 xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com,
 jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com,
 isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz,
 vannapurve@google.com, mail@maciej.szmigiero.name, michael.roth@amd.com,
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
 jthoughton@google.com, peterx@redhat.com
References: <20250318161823.4005529-1-tabba@google.com>
 <20250318161823.4005529-5-tabba@google.com>
 <8ebc66ae-5f37-44c0-884b-564a65467fe4@redhat.com>
 <diqzplhe4nx5.fsf@ackerleytng-ctop.c.googlers.com>
 <6121b93b-6390-49e9-82db-4ed3a6797898@redhat.com>
 <diqzzfghyu0l.fsf@ackerleytng-ctop.c.googlers.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <diqzzfghyu0l.fsf@ackerleytng-ctop.c.googlers.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

>>
> 
> I looked a little deeper and got help from James Houghton on
> understanding this too.

Great :)

> 
> Specifically for the usage of kvm_mem_is_private() in
> kvm_mmu_max_mapping_level(), the intention there is probably to skip
> querying userspace page tables in __kvm_mmu_max_mapping_level() since
> private memory will never be faulted into userspace, hence no need to
> check.
> 
> Hence kvm_mem_is_private() there is really meant to query the
> private-ness of the gfn rather than just whether kvm_mem_from_gmem().
> 
> But then again, if kvm_mem_from_gmem(), guest_memfd should be queried
> for max_mapping_level. guest_memfd would know, for both private and
> shared memory, what page size the page was split to, and what level
> it was faulted as. (Exception: if/when guest_memfd supports THP,
> depending on how that is done, querying userspace page tables might be
> necessary to determine the max_mapping_level)

Okay, so I assume my intuition was right: if we know we can go via the 
guest_memfd also for !private memory, then probably no need to consult 
the page tables.

Let's discuss that tomorrow in the meeting.

> 
>>>
>>> A. this specific gfn is backed by gmem, or
>>> B. if the specific gfn is private?
>>>
>>> I noticed some other places where kvm_mem_is_private() is left as-is
>>> [2], is that intentional? Are you not just renaming but splitting out
>>> the case two cases A and B?
>>
>> That was the idea, yes.
>>
>> If we get a private fault and !kvm_mem_is_private(), or a shared fault and
>> kvm_mem_is_private(), then we should handle it like today.
>>
>> That is the kvm_mmu_faultin_pfn() case, where we
>>
>> if (fault->is_private != kvm_mem_is_private(kvm, fault->gfn)) {
>> 	kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
>> 	return -EFAULT;
>> }
>>
>> which can be reached by arch/x86/kvm/svm/svm.c:npf_interception()
>>
>> if (sev_snp_guest(vcpu->kvm) && (error_code & PFERR_GUEST_ENC_MASK))
>> 	error_code |= PFERR_PRIVATE_ACCESS;
>>
>> In summary: the memory attribute mismatch will be handled as is, but not how
>> we obtain the gfn.
>>
>> At least that was the idea (-issues in the commit).
>>
>> What are your thoughts about that direction?
> 
> I still like the renaming. :)
> 
> I looked into kvm_mem_is_private() and I believe it has the following
> uses:
> 
> 1. Determining max_mapping_level (kvm_mmu_max_mapping_level() and
>     friends)
> 2. Querying the kernel's record of private/shared state, which is used
>     to handle (a) mismatch between fault->private and kernel's record
>     (handling implicit conversions) (b) how to prefaulting pages (c)
>     determining how to fault in KVM_X86_SW_PROTECTED_VMs
> 
> So perhaps we could leave kvm_mem_is_private() as not renamed, but as
> part of the series introducing mmap and conversions
> (CONFIG_KVM_GMEM_SHARED_MEM), we should also have kvm_mem_is_private()
> query guest_memfd for shareability status, and perhaps
> kvm_mmu_max_mapping_level() could query guest_memfd for page size (after
> splitting, etc).
> 

Right, that's why I opted to leave kvm_mem_is_private() here and really 
only indicate if memory is *actually* private.

> IIUC the maximum mapping level is determined by these factors:
> 
> 1. Attribute granularity (lpage_info)
> 2. Page size (guest_memfd for guest_memfd backed memory)
> 3. Size of mapping in host page table (for non-guest_memfd backed
>     memory, and important for THP if/when/depending on how guest_memfd
>     supports THP)

Right, once private+shared will come from guest_memfd, then likely 3
does not apply anymore.

See my reply to Patrick regarding that.

Thanks!

-- 
Cheers,

David / dhildenb


