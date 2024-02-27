Return-Path: <kvm+bounces-10095-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A37D8699B2
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 16:03:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8D57B1C209FB
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 15:02:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2886514A4C1;
	Tue, 27 Feb 2024 14:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YyR4kj/P"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5A2D145B01
	for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 14:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709045986; cv=none; b=NaVHc44us6l1WqEZRohE6Ijlgc0a0rhqEG8Nscp6d5B6iu4mgefMyPNgl+z+Ynx8gbJdFHwMpb++vlm/7LCaTKGpZfbUE1mFHAV73WjK0Orn8Knuid5u4dC1NeuTs6NnuTU/GsjxDgzTpc46Ft+n99cWNGKxciwIvMIMiZU4nmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709045986; c=relaxed/simple;
	bh=YP9S7kvmU/nh26fiuSz9bkhYDQFui1ONdmOPAkRXuFM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Hhixfecs1AYYWmz4wYwrH6QKk+KS1urScm0yEZ4k6l6Kk/3H4wxeZ8iAZdwFFGF10S1FMhuAoP0CkGVSPb8us2/YzVr1XLZqQJyfLw668LjGWFRbkkt3UIq5k1BU2yRtFT6xpPnZFDwhb5eFe7N23hEHFIIQb+RFJanqoPsPJiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YyR4kj/P; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709045983;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=0mkEdjfzddad8xEkEZypdVNSiWCr+WxVca8Ei5UPo9o=;
	b=YyR4kj/P9lgkAQZj6hLUNLbA/5/I2afCZyw/wQHfr1Tc/O/cYalJIQnqT2gK73y3tvraW4
	bXgQi/wkiOPxNt2EVuFKf3hWTARKb3cXZ2/apbd7rt7tzap9a102G06J4/XZe9mmix8HjJ
	V6btNKl8zpD81wIvN0/RZ8VstzfWzv8=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-647-Za2boPZ3PVi9lYKyadz7KA-1; Tue, 27 Feb 2024 09:59:42 -0500
X-MC-Unique: Za2boPZ3PVi9lYKyadz7KA-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-33d0d313b81so2399622f8f.3
        for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 06:59:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709045981; x=1709650781;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt:from
         :references:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0mkEdjfzddad8xEkEZypdVNSiWCr+WxVca8Ei5UPo9o=;
        b=msKa8fV7bZxdpCGDyTuJDXnqi2GgzgZf8Xjwr/9be5i8CniJyhbEL/ktxEAr6xs4Wt
         ZxT/F81ODpKV1xeAYSr6X4QjGWXYxqb1X8/j7zOGHTBe1fHnesA/pmBMcmxIVqUMLeRR
         UioHUPWMgkv40lQV+LzuFboC4XYpZAQ8rpMSb8ugytgm1yAxCr+/XAjW36JjEQAmOy6K
         5vgRlbzr0i1K4ByPpnK1hqSFKBpYNO9rSj0DGUwhXXmgNiUr6ppcGDHODOI2UYzD117A
         bem6XAijgXWrjS7DFL8H/pQJMBX4VvLaI5K53SVZOsPkNJ62q96raPxa67oBVb3AOqY1
         5PyQ==
X-Forwarded-Encrypted: i=1; AJvYcCXNttGmPxZ9dHAp4ilhLDlB/Nohojy0ihCWxSm53y5OgqIbFMmHiLAplF3Ke3Ak78ixFB448JP+d2PLJVHEuNtNhPO5
X-Gm-Message-State: AOJu0YwofrB6GQHe0kqkRPe3FAIAgSNroLfzIsZtmZHQohjzi59S7QcL
	inFor1ZN0twJnzPaRXY5xtsAZANnLmL4lUx3ISvRRUehlpyOS0LneX2p3hnkY8OU+0Dyr0RnGBy
	7qISfqyrAmggMBhLHHWye6XaIKQ9QLdvhQTW2fgg7DF5t1/pMmA==
X-Received: by 2002:a5d:6d85:0:b0:33d:e174:2232 with SMTP id l5-20020a5d6d85000000b0033de1742232mr4239800wrs.6.1709045980640;
        Tue, 27 Feb 2024 06:59:40 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHXKt/iu5/JyDE8hOZDKGMdvaigiSh38DTgHejbtH23fqlG5C9NB56kpO/tenntxgkUP7MHXQ==
X-Received: by 2002:a5d:6d85:0:b0:33d:e174:2232 with SMTP id l5-20020a5d6d85000000b0033de1742232mr4239741wrs.6.1709045980202;
        Tue, 27 Feb 2024 06:59:40 -0800 (PST)
Received: from ?IPV6:2003:cb:c707:7600:5c18:5a7d:c5b7:e7a9? (p200300cbc70776005c185a7dc5b7e7a9.dip0.t-ipconnect.de. [2003:cb:c707:7600:5c18:5a7d:c5b7:e7a9])
        by smtp.gmail.com with ESMTPSA id ck12-20020a5d5e8c000000b0033d9f0dcb35sm11920501wrb.87.2024.02.27.06.59.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Feb 2024 06:59:39 -0800 (PST)
Message-ID: <925f8f5d-c356-4c20-a6a5-dd7efde5ee86@redhat.com>
Date: Tue, 27 Feb 2024 15:59:37 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: folio_mmapped
Content-Language: en-US
To: Matthew Wilcox <willy@infradead.org>, Fuad Tabba <tabba@google.com>,
 kvm@vger.kernel.org, kvmarm@lists.linux.dev, pbonzini@redhat.com,
 chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org,
 paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu,
 seanjc@google.com, viro@zeniv.linux.org.uk, brauner@kernel.org,
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
 maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com,
 linux-mm@kvack.org
References: <20240222161047.402609-1-tabba@google.com>
 <20240222141602976-0800.eberman@hu-eberman-lv.qualcomm.com>
 <ZdfoR3nCEP3HTtm1@casper.infradead.org>
 <40a8fb34-868f-4e19-9f98-7516948fc740@redhat.com>
 <20240226105258596-0800.eberman@hu-eberman-lv.qualcomm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20240226105258596-0800.eberman@hu-eberman-lv.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

> 
> Ah, this was something I hadn't thought about. I think both Fuad and I
> need to update our series to check the refcount rather than mapcount
> (kvm_is_gmem_mapped for Fuad, gunyah_folio_lend_safe for me).

An alternative might be !folio_mapped() && !folio_maybe_dma_pinned(). 
But checking for any unexpected references might be better (there are 
still some GUP users that don't use FOLL_PIN).

At least concurrent migration/swapout (that temporarily unmaps a folio 
and can give you folio_mapped() "false negatives", which both take a 
temporary folio reference and hold the page lock) should not be a 
concern because guest_memfd doesn't support that yet.

> 
>>
>> Now, regarding the original question (disallow mapping the page), I see the
>> following approaches:
>>
>> 1) SIGBUS during page fault. There are other cases that can trigger
>>     SIGBUS during page faults: hugetlb when we are out of free hugetlb
>>     pages, userfaultfd with UFFD_FEATURE_SIGBUS.
>>
>> -> Simple and should get the job done.
>>
>> 2) folio_mmapped() + preventing new mmaps covering that folio
>>
>> -> More complicated, requires an rmap walk on every conversion.
>>
>> 3) Disallow any mmaps of the file while any page is private
>>
>> -> Likely not what you want.
>>
>>
>> Why was 1) abandoned? I looks a lot easier and harder to mess up. Why are
>> you trying to avoid page faults? What's the use case?
>>
> 
> We were chatting whether we could do better than the SIGBUS approach.
> SIGBUS/FAULT usually crashes userspace, so I was brainstorming ways to
> return errors early. One difference between hugetlb and this usecase is
> that running out of free hugetlb pages isn't something we could detect

With hugetlb reservation one can try detecting it at mmap() time. But as 
reservations are not NUMA aware, it's not reliable.

> at mmap time. In guest_memfd usecase, we should be able to detect when
> SIGBUS becomes possible due to memory being lent to guest.
> 
> I can't think of a reason why userspace would want/be able to resume
> operation after trying to access a page that it shouldn't be allowed, so
> SIGBUS is functional. The advantage of trying to avoid SIGBUS was
> better/easier reporting to userspace.

To me, it sounds conceptually easier and less error-prone to

1) Converting a page to private only if there are no unexpected
    references (no mappings, GUP pins, ...)
2) Disallowing mapping private pages and failing the page fault.
3) Handling that small race window only (page lock?)

Instead of

1) Converting a page to private only if there are no unexpected
    references (no mappings, GUP pins, ...) and no VMAs covering it where
    we could fault it in later
2) Disallowing mmap when the range would contain any private page
3) Handling races between mmap and page conversion

-- 
Cheers,

David / dhildenb


