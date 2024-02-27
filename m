Return-Path: <kvm+bounces-10028-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 076FB868A05
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 08:40:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2B7321C2263B
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 07:40:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B6AF54F91;
	Tue, 27 Feb 2024 07:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="X0BfVv1v"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C357954BE3
	for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 07:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709019632; cv=none; b=DtwLdE6JpQnQ9Ju3fwQ2CazWhpGj2fJLJqf5Dm/D7yDda0QPW2AGoKW6908AoePfnsJJNukqhfYoWyAQE1S7JTeiJeF/nhA6Lm0pSYAn6grCHpUZBM98+aihT/VHIglcmJesFTeG7+6QEtZj/MJwm45zP+eqZ9+5ePcbymUUJf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709019632; c=relaxed/simple;
	bh=GzzxhdQpnwLwxs8w95eaSA26dcqErhEF/JdmHnbq4GQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hc9pxYIKsZqDrFYfTl3AAZw8T19dOr4jP1R+SSRGJYClSTTKjguPpgRbb2CwDZ7kDgOwnbKMqKDbQW+WUXL2jiQHkxUIe024WiFX3bOM5w/39hwFoQygJ/klZLhxpaDVkR/Gtk93dUzqcpNZ1oxfiLRPvvXw1ZouEKpeVPvNLwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=X0BfVv1v; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709019629;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=488T45k9s4fXxqiaoayV/5rP9Q/Srzb8zs2DRkXpEfQ=;
	b=X0BfVv1vjm4vn/+taPasdySazIWS9tlVM/9LrOkbfidL7tPJd/0LlhWrqXtJXDGYYNwukD
	tuMyTcVIR3aAf6p+I5cOkLVaQnYA5wwHHVJumq/iLImAa6f9I1pYG8wVrwtgn2J46SPfWl
	mu2OhqgQUn9wTpHGm30Px/UWPAEfm7U=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-508-s_nUXHZ9NVuLqXGghRFMzQ-1; Tue, 27 Feb 2024 02:40:27 -0500
X-MC-Unique: s_nUXHZ9NVuLqXGghRFMzQ-1
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-2d23143f4a1so39291031fa.1
        for <kvm@vger.kernel.org>; Mon, 26 Feb 2024 23:40:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709019626; x=1709624426;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt:from
         :references:cc:to:content-language:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=488T45k9s4fXxqiaoayV/5rP9Q/Srzb8zs2DRkXpEfQ=;
        b=A0rNXuSJu5OojhS0GwDUnkbGwtq+G8exaMty/9MIRnNrqQnawIb4q4DBYsHTyLbnji
         8vAosDQKgp+pPci0WBcMO1/5y26B9VtTo+clvwZT6wuJR8e3CScVJiFAINv8sOJE8Jif
         Ar6jgxIuiuMO0Y8q8uOam9bjAfK1ZYdRiGBoIbyFuqYoME2pZ4cxSbIkSP20rt+IR/G4
         GpK5R0spJZNDFYf5+0DYQE6ZvcB1cWlg0yOMcmb/Anz3Iuv/YP1KkleqpfUdSrfuaKIV
         6kqFgbxzg33DyjLHkLHCPFRBqLS3ikgG8f3Fq+/K7ShDBOeVtZZXINCv6GL7F2QK8NdN
         zdZg==
X-Gm-Message-State: AOJu0Ywmo3kRWfxpVZ4AmA6/bli/U3zuulNshQWgr2Oy7RxngnAy7Q05
	qE4Cd3k0uXB/JNdjghLL0mxqOrB/TfNrElgRKoUY/iR6i1S8n7fbQQcB+05zdfEXRLXosMPBDCa
	7mRNlFsgAkvwLc8+r0Zs5/0wQ69Ciwewn8CM19w1TP1IoDqvch6F4NLOu+Q==
X-Received: by 2002:a2e:be07:0:b0:2d2:8767:3175 with SMTP id z7-20020a2ebe07000000b002d287673175mr4780353ljq.24.1709019626129;
        Mon, 26 Feb 2024 23:40:26 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEPcdJfY8t4PrOiGW6VUeQhZm2d69TblXO7A98l8xTnAQSjDW8u3wWQenhACNoHM/TFC9wumg==
X-Received: by 2002:a2e:be07:0:b0:2d2:8767:3175 with SMTP id z7-20020a2ebe07000000b002d287673175mr4780313ljq.24.1709019625657;
        Mon, 26 Feb 2024 23:40:25 -0800 (PST)
Received: from ?IPV6:2003:cb:c707:7600:5c18:5a7d:c5b7:e7a9? (p200300cbc70776005c185a7dc5b7e7a9.dip0.t-ipconnect.de. [2003:cb:c707:7600:5c18:5a7d:c5b7:e7a9])
        by smtp.gmail.com with ESMTPSA id v6-20020a5d59c6000000b0033b47ee01f1sm10751259wry.49.2024.02.26.23.40.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Feb 2024 23:40:25 -0800 (PST)
Message-ID: <4a0fd313-4423-496d-aec1-d25707a89288@redhat.com>
Date: Tue, 27 Feb 2024 08:40:23 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v1 03/26] KVM: Add restricted support for mapping
 guestmem by the host
Content-Language: en-US
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, pbonzini@redhat.com,
 chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org,
 paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu,
 seanjc@google.com, viro@zeniv.linux.org.uk, brauner@kernel.org,
 willy@infradead.org, akpm@linux-foundation.org, xiaoyao.li@intel.com,
 yilun.xu@intel.com, chao.p.peng@linux.intel.com, jarkko@kernel.org,
 amoorthy@google.com, dmatlack@google.com, yu.c.zhang@linux.intel.com,
 isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz,
 vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name,
 michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com,
 isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com,
 suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com,
 quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com,
 quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com,
 quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com,
 james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev,
 maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com
References: <20240222161047.402609-1-tabba@google.com>
 <20240222161047.402609-4-tabba@google.com>
 <86461043-fa5b-405d-bd2e-dc1aba9977c5@redhat.com>
 <CA+EHjTyYQWdc14kFiQs0Ous2Hnep88v9-Us9m68TneLm9Eqvzw@mail.gmail.com>
 <83d6edb8-bfd0-4233-a4cf-b573fa62c8d9@redhat.com>
 <CA+EHjTwtWiCML0X_4Erx5m__DE1Ja4i5BBZtLQRn9dnLWFahPQ@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <CA+EHjTwtWiCML0X_4Erx5m__DE1Ja4i5BBZtLQRn9dnLWFahPQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 26.02.24 18:30, Fuad Tabba wrote:
> Hi David,
> 
> Thank you very much for reviewing this.
> 
> On Mon, Feb 26, 2024 at 9:58 AM David Hildenbrand <david@redhat.com> wrote:
>>
>> On 26.02.24 09:58, Fuad Tabba wrote:
>>> Hi David,
>>>
>>> On Thu, Feb 22, 2024 at 4:28 PM David Hildenbrand <david@redhat.com> wrote:
>>>>
>>>>> +static vm_fault_t kvm_gmem_fault(struct vm_fault *vmf)
>>>>> +{
>>>>> +     struct folio *folio;
>>>>> +
>>>>> +     folio = kvm_gmem_get_folio(file_inode(vmf->vma->vm_file), vmf->pgoff);
>>>>> +     if (!folio)
>>>>> +             return VM_FAULT_SIGBUS;
>>>>> +
>>>>> +     /*
>>>>> +      * Check if the page is allowed to be faulted to the host, with the
>>>>> +      * folio lock held to ensure that the check and incrementing the page
>>>>> +      * count are protected by the same folio lock.
>>>>> +      */
>>>>> +     if (!kvm_gmem_isfaultable(vmf)) {
>>>>> +             folio_unlock(folio);
>>>>> +             return VM_FAULT_SIGBUS;
>>>>> +     }
>>>>> +
>>>>> +     vmf->page = folio_file_page(folio, vmf->pgoff);
>>>>
>>>> We won't currently get hugetlb (or even THP) here. It mimics what shmem
>>>> would do.
>>>
>>> At the moment there isn't hugetlb support in guest_memfd(), and
>>> neither in pKVM. Although we do plan on supporting it.
>>>
>>>> finish_fault->set_pte_range() will call folio_add_file_rmap_ptes(),
>>>> getting the rmap involved.
>>>>
>>>> Do we have some tests in place that make sure that
>>>> fallocate(FALLOC_FL_PUNCH_HOLE|FALLOC_FL_KEEP_SIZE) will properly unmap
>>>> the page again (IOW, that the rmap does indeed work?).
>>>
>>> I'm not sure if you mean kernel tests, or if I've tested it. There are
>>> guest_memfd() tests for
>>> fallocate(FALLOC_FL_PUNCH_HOLE|FALLOC_FL_KEEP_SIZE) , which I have
>>> run. I've also tested it manually with sample programs, and it behaves
>>> as expected.
>>
>> Can you point me at the existing tests? I'm interested in
>> mmap()-specific guest_memfd tests.
>>
>> A test that would make sense to me:
>>
>> 1) Create guest_memfd() and size it to contain at least one page.
>>
>> 2) mmap() it
>>
>> 3) Write some pattern (e.g., all 1's) to the first page using the mmap
>>
>> 4) fallocate(FALLOC_FL_PUNCH_HOLE|FALLOC_FL_KEEP_SIZE) the first page
>>
>> 5) Make sure reading from the first page using the mmap reads all 0's
>>
>> IOW, during 4) we properly unmapped (via rmap) and discarded the page,
>> such that 5) will populate a fresh page in the page cache filled with
>> 0's and map that one.
> 
> The existing tests don't test mmap (or rather, they test the inability
> to mmap). They do test FALLOC_FL_PUNCH_HOLE. [1]
> 
> The tests for mmap() are ones that I wrote myself. I will write a test
> like the one you mentioned, and send it with V2, or earlier if you
> prefer.

Thanks, no need to rush. As long as we have some simple test for that 
scenario at some point, all good!

-- 
Cheers,

David / dhildenb


