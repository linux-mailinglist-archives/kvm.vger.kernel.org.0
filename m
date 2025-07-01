Return-Path: <kvm+bounces-51198-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B0F09AEFCE4
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 16:44:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 128D34E110D
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 14:44:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2199277CAA;
	Tue,  1 Jul 2025 14:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NMjUH1Pc"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 111F21D07BA
	for <kvm@vger.kernel.org>; Tue,  1 Jul 2025 14:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751381071; cv=none; b=O38dyq5pHf389cQW2pm01Wza9BDrwCWBNawxTgSZqbtqcFhV+o4HiKEjpxsz7EBxz9E3+aKPg5ixsikAM+yfunoJ4hdDUams3jfMuQ1FWW4517KCw8D8mOlF9LNPrtm3rUkBb5u7p0Iw3RgfU7MU8oBL9GhP4CY5qShV7r7KbLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751381071; c=relaxed/simple;
	bh=bR+FI6Za2/zIbjtOtb8TI450N4jEdH7JboPdnny+88A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gKQQdOia21TkKSZNLQTOCO38/kl7ARs+NXlrBoGokSy/SRO1U+kCbZEngVAUiLVlqquFv3mM4uuXZwiV5ODzDVkkbuVaW7c2mYuFfh5pTd7ur3SRp1/1CL7Sxi4QXW/O+4ru7X21nOsvnNlczwv/PVeckvPAM/dB1r46tuQnOeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NMjUH1Pc; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751381069;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=efTfetSQvXDnyHYs6dTLcgxq7ccfUWuGzNDdGLySXso=;
	b=NMjUH1PcXku2YfPHFNxQ62+wNnGSS7URkMFVndflR14aE/f97cASIFeQxISZk6Vb+J0R9i
	jQ2CXhBx05JDv6jrGF44/4H79haJjB6LOoyk740WpBnFbirgqL6LqaJQ36gxK71XXx74eQ
	kF/MDG2wKTaBXXLRjSS+9lBYp8tSr24=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-57-rzxezHynO--TmXsr5jwFFQ-1; Tue, 01 Jul 2025 10:44:28 -0400
X-MC-Unique: rzxezHynO--TmXsr5jwFFQ-1
X-Mimecast-MFC-AGG-ID: rzxezHynO--TmXsr5jwFFQ_1751381067
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3af3c860ed7so537854f8f.1
        for <kvm@vger.kernel.org>; Tue, 01 Jul 2025 07:44:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751381067; x=1751985867;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=efTfetSQvXDnyHYs6dTLcgxq7ccfUWuGzNDdGLySXso=;
        b=oWbISTcaMpjcxFcYxeQo1O/xVG90zOlqaCTeAY46czKC33J2Td3yCiZ8FTfB/A2VzU
         P95bDBRMtHPkl5ljShXB88iZVBw+g5qTxekQB9O2iDoyPt1cM7NXHLsi/8lw9FIpRZqk
         mTqzwqUqNkanmDZilwDIdX6HvXhJZAeQurobFANuLdoiN91tc5vn2w66h8lfVv8quTBJ
         zAwxVaoD/OqINH57kZlUEH9tzLZOkZLfQ+338BECPZvQsU+2QqZdAzxrspEov1QmSmF6
         ti2B0twR/JF9DzovX69guxXmJJbN6NbfFiTwrKWleAMOu8XZu9BoZZ1N5d4g7bP3dPP1
         0vmw==
X-Forwarded-Encrypted: i=1; AJvYcCWeECJOw70pHtK+2Pz5+rWP7+o/rl5oFrupMhuD8sv6hWcxLc1pGON7FQ7Jg+MC/THGEPs=@vger.kernel.org
X-Gm-Message-State: AOJu0YyZrI4K1IicsIunIjDH7gMeMVw/i5pmaNq+mZRwOWnW3bfI4Tg6
	WySltGE45b9JbWAj0RyxklowUe8+XU7+uDQRak6teuf3EDMM/ON7ymGRPvDPyV/XdBmWxSnjAwo
	l6aW6+y19gxE6M+X31xsnciot754EdUS7fykB4YdBrOf33yYOIw8Jog==
X-Gm-Gg: ASbGnctj+W4rynyTkNv6Lxd6UAMposhEiBBNigF56e+T+VfioqCYOv1wHLGmf4KiMCA
	ccj3A9BgW20YNuiqxSewCkBGkC3+xANMFugPErPtToIvQJsDGE0CZOU8nj5x8Z78aTD22Jj3V8K
	HTWsp+5DoCmkPZ1eUrqgchkTzjm99A9Q0j7fowCUGgdKjI1byCsHt8KPsdUWj18kdVHdt945rpP
	ZbDuzt4Km/62lP4ljEg32N3ZbrwaQJ4VpZAu+f69b0hJVtBRPrOZ4K+bhKXINitvplR/TZWaZYg
	EYpzLXEPsjXKs0OFtYhSUw9b9LzkB9i6a31BMTHu4Rwb3N2csGW0uNI2uCcSnXjSQsQusATh9zg
	8cZgnD/TuwmfT+ADE7rww65+F3GPLuT8WdyRn5yEoszWCY074Ww==
X-Received: by 2002:a05:6000:23c8:b0:3a4:eef9:818a with SMTP id ffacd0b85a97d-3a8ff51fb85mr10746951f8f.27.1751381066467;
        Tue, 01 Jul 2025 07:44:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH8EffOdFk4TDMeDcgi45o1n1fl4XlGJHCw57SfIvSFRekAhPXJ1smdIyNo6k5GXpdljvAMQw==
X-Received: by 2002:a05:6000:23c8:b0:3a4:eef9:818a with SMTP id ffacd0b85a97d-3a8ff51fb85mr10746912f8f.27.1751381065847;
        Tue, 01 Jul 2025 07:44:25 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f18:7500:202e:b0f1:76d6:f9af? (p200300d82f187500202eb0f176d6f9af.dip0.t-ipconnect.de. [2003:d8:2f18:7500:202e:b0f1:76d6:f9af])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a88c7fb20esm13693987f8f.36.2025.07.01.07.44.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Jul 2025 07:44:25 -0700 (PDT)
Message-ID: <0cdc7890-aade-4fa5-ad72-24cde6c7bce9@redhat.com>
Date: Tue, 1 Jul 2025 16:44:22 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 10/18] KVM: x86/mmu: Handle guest page faults for
 guest_memfd with shared memory
To: Ackerley Tng <ackerleytng@google.com>, Shivank Garg <shivankg@amd.com>,
 Fuad Tabba <tabba@google.com>
Cc: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev,
 pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
 anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk, brauner@kernel.org,
 willy@infradead.org, akpm@linux-foundation.org, xiaoyao.li@intel.com,
 yilun.xu@intel.com, chao.p.peng@linux.intel.com, jarkko@kernel.org,
 amoorthy@google.com, dmatlack@google.com, isaku.yamahata@intel.com,
 mic@digikod.net, vbabka@suse.cz, vannapurve@google.com,
 mail@maciej.szmigiero.name, michael.roth@amd.com, wei.w.wang@intel.com,
 liam.merwick@oracle.com, isaku.yamahata@gmail.com,
 kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com,
 steven.price@arm.com, quic_eberman@quicinc.com, quic_mnalajal@quicinc.com,
 quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com,
 quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com,
 quic_pheragu@quicinc.com, catalin.marinas@arm.com, james.morse@arm.com,
 yuzenghui@huawei.com, oliver.upton@linux.dev, maz@kernel.org,
 will@kernel.org, qperret@google.com, keirf@google.com, roypat@amazon.co.uk,
 shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, rientjes@google.com,
 jhubbard@nvidia.com, fvdl@google.com, hughd@google.com,
 jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com,
 ira.weiny@intel.com
References: <20250611133330.1514028-1-tabba@google.com>
 <20250611133330.1514028-11-tabba@google.com> <aEyhHgwQXW4zbx-k@google.com>
 <diqz1pr8lndp.fsf@ackerleytng-ctop.c.googlers.com>
 <diqza55tjkk1.fsf@ackerleytng-ctop.c.googlers.com>
 <CA+EHjTxECJ3=ywbAPvpdA1-pm=stXWqU75mgG1epWaXiUr0raw@mail.gmail.com>
 <diqzv7odjnln.fsf@ackerleytng-ctop.c.googlers.com>
 <CA+EHjTwqOwO2zVd4zTYF7w7reTWMNjmCV6XnKux2JtPwYCAoZQ@mail.gmail.com>
 <434ab5a3-fedb-4c9e-8034-8f616b7e5e52@amd.com>
 <923b1c02-407a-4689-a047-dd94e885b103@redhat.com>
 <diqz34bg575i.fsf@ackerleytng-ctop.c.googlers.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <diqz34bg575i.fsf@ackerleytng-ctop.c.googlers.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

>>> I support this approach.
>>
>> Agreed. Let's get this in with the changes requested by Sean applied.
>>
>> How to use GUEST_MEMFD_FLAG_MMAP in combination with a CoCo VM with
>> legacy mem attributes (-> all memory in guest_memfd private) could be
>> added later on top, once really required.
>>
>> As discussed, CoCo VMs that want to support GUEST_MEMFD_FLAG_MMAP will
>> have to disable legacy mem attributes using a new capability in stage-2.
>>
> 
> I rewatched the guest_memfd meeting on 2025-06-12.  We do want to
> support the use case where userspace wants to have mmap (e.g. to set
> mempolicy) but does not want to allow faulting into the host.
> 
> On 2025-06-12, the conclusion was that the problem will be solved once
> guest_memfd supports shareability, and that's because userspace can set
> shareability to GUEST, so the memory can't be faulted into the host.
> 
> On 2025-06-26, Sean said we want to let userspace have an extra layer of
> protection so that memory cannot be faulted in to the host, ever. IOW,
> we want to let userspace say that even if there is a stray
> private-to-shared conversion, *don't* allow faulting memory into the
> host.
> 
> The difference is the "extra layer of protection", which should remain
> in effect even if there are (stray/unexpected) private-to-shared
> conversions to guest_memfd or to KVM. Here's a direct link to the point
> in the video where Sean brought this up [1]. I'm really hoping I didn't
> misinterpret this!
> 
> Let me look ahead a little, since this involves use cases already
> brought up though I'm not sure how real they are. I just want to make
> sure that in a few patch series' time, we don't end up needing userspace
> to use a complex bunch of CAPs and FLAGs.
> 
> In this series (mmap support, V12, patch 10/18) [2], to allow
> KVM_X86_DEFAULT_VMs to use guest_memfd, I added a `fault_from_gmem()`
> helper, which is defined as follows (before the renaming Sean requested):
> 
> +static inline bool fault_from_gmem(struct kvm_page_fault *fault)
> +{
> +	return fault->is_private || kvm_gmem_memslot_supports_shared(fault->slot);
> +}
> 
> The above is changeable, of course :). The intention is that if the
> fault is private, fault from guest_memfd. If GUEST_MEMFD_FLAG_MMAP is
> set (KVM_MEMSLOT_GMEM_ONLY will be set on the memslot), fault from
> guest_memfd.
> 
> If we defer handling GUEST_MEMFD_FLAG_MMAP in combination with a CoCo VM
> with legacy mem attributes to the future, this helper will probably
> become
> 
> -static inline bool fault_from_gmem(struct kvm_page_fault *fault)
> +static inline bool fault_from_gmem(struct kvm *kvm, struct kvm_page_fault *fault)
> +{
> -	return fault->is_private || kvm_gmem_memslot_supports_shared(fault->slot);
> +	return fault->is_private || (kvm_gmem_memslot_supports_shared(fault->slot) &&
> +	                             !kvm_arch_disable_legacy_private_tracking(kvm));
> +}
> 
> And on memslot binding we check
> 
> if kvm_arch_disable_legacy_private_tracking(kvm) and not GUEST_MEMFD_FLAG_MMAP
> 	return -EINVAL;
> 
> 1. Is that what yall meant?

My understanding:

CoCo VMs will initially (stage-1) only support !GUEST_MEMFD_FLAG_MMAP.

With stage-2, CoCo VMs will support GUEST_MEMFD_FLAG_MMAP only with 
kvm_arch_disable_legacy_private_tracking().

Non-CoCo VMs will only support GUEST_MEMFD_FLAG_MMAP. (no concept of 
private)

> 
> 2. Does this kind of not satisfy the "extra layer of protection"
>     requirement (if it is a requirement)?
> 
>     A legacy CoCo VM using guest_memfd only for private memory (shared
>     memory from say, shmem) and needing to set mempolicy would
>     
>     * Set GUEST_MEMFD_FLAG_MMAP
>     * Leave KVM_CAP_DISABLE_LEGACY_PRIVATE_TRACKING defaulted to false
>     
>     but still be able to send conversion ioctls directly to guest_memfd,
>     and then be able to fault guest_memfd memory into the host.

In that configuration, I would expect that all memory in guest_memfd is 
private and remains private.

guest_memfd without memory attributes cannot support in-place conversion.

How to achieve that might be interesting: the capability will affect 
guest_memfd behavior?

> 
> 3. Now for a use case I've heard of (feel free to tell me this will
>     never be supported or "we'll deal with it if it comes"): On a
>     non-CoCo VM, we want to use guest_memfd but not use mmap (and the
>     initial VM image will be written using write() syscall or something
>     else).
> 
>     * Set GUEST_MEMFD_FLAG_MMAP to false
>     * Leave KVM_CAP_DISABLE_LEGACY_PRIVATE_TRACKING defaulted to false
>       (it's a non-CoCo VM, weird to do anything to do with private
>       tracking)
> 
>     And now we're stuck because fault_from_gmem() will return false all
>     the time and we can't use memory from guest_memfd.

I think I discussed that with Sean: we would have GUEST_MEMFD_FLAG_WRITE 
that will imply everything that GUEST_MEMFD_FLAG_MMAP would imply, 
except the actual mmap() support.

-- 
Cheers,

David / dhildenb


