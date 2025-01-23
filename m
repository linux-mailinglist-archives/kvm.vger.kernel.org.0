Return-Path: <kvm+bounces-36339-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 89F57A1A368
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 12:45:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 57AED18836F7
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 11:45:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 320AC218826;
	Thu, 23 Jan 2025 11:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cqb1DBJf"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7659B218823
	for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 11:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737632393; cv=none; b=t/imbYuU33k/mjHpOzOrhkGZMhrAEMd6pwOijtAIdj4W24LqfGUKA3iw51h6/I23FdxyZ5Uyi1H4Mt0LbuXx2Gw5MUagrrj6b59Dzgo7TiuEGDm8/tp8OF7pqj0tr78JsX54o4iCI3EhnW4CPQxoLthEjA37dC/Aacdx5vlE6Pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737632393; c=relaxed/simple;
	bh=yRmruWwZAlGMnjNKWS6o5Wf6vBBNO7FO6a4CyXrm1wE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BLXk7N0649bbx/5QT3t/FcpwPfIvRLzDHwbEOXEclnwvl+qttr+JChK9ZP2aiyQxr+NuXvBgx2uH3aigGvTrVEPwmTCJAXuu09J1NPZcVozMuDVOJXhXUuR2MG88KQBQIJi6Fd8AIu6txJ8FlL1E3FTNJOLhISustavyfIRiKlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cqb1DBJf; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737632390;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=26sJp6LLr853+l42FCxrIN7KhwPqa68kRd/qGpcZQT8=;
	b=cqb1DBJf3g2IUT+1FGkEqCR9M4xeTg8hImdfR2hTQ0Lfx0c2DFWujqeIP8R5XmOPt5zqAd
	DYsLOAxdc30FGSwoSaZmouMHhiaywb5JWa51rxomwHuJ/O8jusqbHJknXkKY6C9UFIev6+
	Xi4iX9ylVkS6+dTmwiYuSSOiNalLVg0=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-7-NaOt0FfTNne36Yv0ladsVw-1; Thu, 23 Jan 2025 06:39:49 -0500
X-MC-Unique: NaOt0FfTNne36Yv0ladsVw-1
X-Mimecast-MFC-AGG-ID: NaOt0FfTNne36Yv0ladsVw
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-38a684a0971so417727f8f.2
        for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 03:39:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737632388; x=1738237188;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=26sJp6LLr853+l42FCxrIN7KhwPqa68kRd/qGpcZQT8=;
        b=TgBjMbT8jyg139MMa8wz8Ch3siT/R4f2PIM6PvMR2EYaZ/cTsm3BIe2iScl5sMWk0B
         i3esW67vHhSDFAC3M1XbAGhB9dQEz9svygbFCT0vLgQt/UkamnblIBFPUUteDNhpvfdE
         h6ycTVSM2PZ9IYpPoTqNeQqyRiHvccOjtm85gw2Dl6scv6dRM180dhzPOtyiE+0SGeWJ
         uTWtGmrNktn0exUJPXfXh0ci6B/1/GbPfrZTaAN51NouH9hLBhL6QXjOlb0sB6B/JBwa
         FICPpxjzwlt3sQWxfnUkNSQGsJDCsxVqbj8NRucUp4JGkFioL2g1OYOvGeWvHV7r7QRR
         MZnw==
X-Gm-Message-State: AOJu0Yxr+c5f38S/3rahmqDZp77UeCgHjsl5uxrB8BYywqtEMcEaSloV
	mER3viZQGOBAt+M2YfynCVK1Uy8LkoIKF/6KI+Xm4mFeKdMrAyGe4Eq9FpopFMiO0ETOpu5rT3h
	UKyyVu+CcIUD0qDPGrDzVQaaNc1CmpYJQWNRhOxJsdk4LEILQrQ==
X-Gm-Gg: ASbGncvhm74ClPIjqIvwFzgcPzZhd5jNubVTqPHb1tZsJ00QJONmFZq6ABk0umonw2F
	xTJo3uWdrZq/SbA/4AdxTU8XdbHQLwzMxf3z1K6cRy3eqLxrJLTH0FsSdDj/UMxU4AfXB1SFLce
	K0Cq2j0xwibAxA/41MEsWKD+sm9zivx2Xhib8WZhERKuZFouEVPCTFHVizW/m13dGvNp7Xw2uUn
	6PckZqiRkagK5EUinVEmJpxHnYy3PdQtrYCaCmpI7dPnMRnpCAHzD5mjmvf2PRCdx5SA4AIqfyU
	JlaquA3QoJyzwkYKHet3aIuudFw8p920q2iWkiMmaNToWAeTEmpf9yyTorwBBsAJUWgX0lLyMYw
	XH5/QQr8iH0HRjUWuAaADXw==
X-Received: by 2002:a05:6000:186f:b0:38a:8647:3dac with SMTP id ffacd0b85a97d-38bf57a68aemr21941674f8f.34.1737632387818;
        Thu, 23 Jan 2025 03:39:47 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEOdqnws9Ojo4ed6tHwT2TPMkSJHd3gT/xgbU599QXRB2REcnN3KIZ7uuGKPDeYqeZC5/UPlw==
X-Received: by 2002:a05:6000:186f:b0:38a:8647:3dac with SMTP id ffacd0b85a97d-38bf57a68aemr21941653f8f.34.1737632387364;
        Thu, 23 Jan 2025 03:39:47 -0800 (PST)
Received: from ?IPV6:2003:cb:c70b:b400:e20a:6d03:7ac8:f97d? (p200300cbc70bb400e20a6d037ac8f97d.dip0.t-ipconnect.de. [2003:cb:c70b:b400:e20a:6d03:7ac8:f97d])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-438b31d9a39sm58733405e9.31.2025.01.23.03.39.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jan 2025 03:39:46 -0800 (PST)
Message-ID: <82d8d3a3-6f06-4904-9d94-6f92bba89dbc@redhat.com>
Date: Thu, 23 Jan 2025 12:39:43 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v1 2/9] KVM: guest_memfd: Add guest_memfd support to
 kvm_(read|/write)_guest_page()
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org,
 pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
 anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk,
 brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
 xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com,
 jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com,
 yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net,
 vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com,
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
 jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, jthoughton@google.com
References: <20250122152738.1173160-1-tabba@google.com>
 <20250122152738.1173160-3-tabba@google.com>
 <e6ea48d2-959f-4fbb-a170-0beaaf37f867@redhat.com>
 <CA+EHjTxNEoQ3MtZPi603=366vxt=SmBwetS4mFkvTK2r6u=UHw@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzSREYXZpZCBIaWxk
 ZW5icmFuZCA8ZGF2aWRAcmVkaGF0LmNvbT7CwZgEEwEIAEICGwMGCwkIBwMCBhUIAgkKCwQW
 AgMBAh4BAheAAhkBFiEEG9nKrXNcTDpGDfzKTd4Q9wD/g1oFAl8Ox4kFCRKpKXgACgkQTd4Q
 9wD/g1oHcA//a6Tj7SBNjFNM1iNhWUo1lxAja0lpSodSnB2g4FCZ4R61SBR4l/psBL73xktp
 rDHrx4aSpwkRP6Epu6mLvhlfjmkRG4OynJ5HG1gfv7RJJfnUdUM1z5kdS8JBrOhMJS2c/gPf
 wv1TGRq2XdMPnfY2o0CxRqpcLkx4vBODvJGl2mQyJF/gPepdDfcT8/PY9BJ7FL6Hrq1gnAo4
 3Iv9qV0JiT2wmZciNyYQhmA1V6dyTRiQ4YAc31zOo2IM+xisPzeSHgw3ONY/XhYvfZ9r7W1l
 pNQdc2G+o4Di9NPFHQQhDw3YTRR1opJaTlRDzxYxzU6ZnUUBghxt9cwUWTpfCktkMZiPSDGd
 KgQBjnweV2jw9UOTxjb4LXqDjmSNkjDdQUOU69jGMUXgihvo4zhYcMX8F5gWdRtMR7DzW/YE
 BgVcyxNkMIXoY1aYj6npHYiNQesQlqjU6azjbH70/SXKM5tNRplgW8TNprMDuntdvV9wNkFs
 9TyM02V5aWxFfI42+aivc4KEw69SE9KXwC7FSf5wXzuTot97N9Phj/Z3+jx443jo2NR34XgF
 89cct7wJMjOF7bBefo0fPPZQuIma0Zym71cP61OP/i11ahNye6HGKfxGCOcs5wW9kRQEk8P9
 M/k2wt3mt/fCQnuP/mWutNPt95w9wSsUyATLmtNrwccz63XOwU0EVcufkQEQAOfX3n0g0fZz
 Bgm/S2zF/kxQKCEKP8ID+Vz8sy2GpDvveBq4H2Y34XWsT1zLJdvqPI4af4ZSMxuerWjXbVWb
 T6d4odQIG0fKx4F8NccDqbgHeZRNajXeeJ3R7gAzvWvQNLz4piHrO/B4tf8svmRBL0ZB5P5A
 2uhdwLU3NZuK22zpNn4is87BPWF8HhY0L5fafgDMOqnf4guJVJPYNPhUFzXUbPqOKOkL8ojk
 CXxkOFHAbjstSK5Ca3fKquY3rdX3DNo+EL7FvAiw1mUtS+5GeYE+RMnDCsVFm/C7kY8c2d0G
 NWkB9pJM5+mnIoFNxy7YBcldYATVeOHoY4LyaUWNnAvFYWp08dHWfZo9WCiJMuTfgtH9tc75
 7QanMVdPt6fDK8UUXIBLQ2TWr/sQKE9xtFuEmoQGlE1l6bGaDnnMLcYu+Asp3kDT0w4zYGsx
 5r6XQVRH4+5N6eHZiaeYtFOujp5n+pjBaQK7wUUjDilPQ5QMzIuCL4YjVoylWiBNknvQWBXS
 lQCWmavOT9sttGQXdPCC5ynI+1ymZC1ORZKANLnRAb0NH/UCzcsstw2TAkFnMEbo9Zu9w7Kv
 AxBQXWeXhJI9XQssfrf4Gusdqx8nPEpfOqCtbbwJMATbHyqLt7/oz/5deGuwxgb65pWIzufa
 N7eop7uh+6bezi+rugUI+w6DABEBAAHCwXwEGAEIACYCGwwWIQQb2cqtc1xMOkYN/MpN3hD3
 AP+DWgUCXw7HsgUJEqkpoQAKCRBN3hD3AP+DWrrpD/4qS3dyVRxDcDHIlmguXjC1Q5tZTwNB
 boaBTPHSy/Nksu0eY7x6HfQJ3xajVH32Ms6t1trDQmPx2iP5+7iDsb7OKAb5eOS8h+BEBDeq
 3ecsQDv0fFJOA9ag5O3LLNk+3x3q7e0uo06XMaY7UHS341ozXUUI7wC7iKfoUTv03iO9El5f
 XpNMx/YrIMduZ2+nd9Di7o5+KIwlb2mAB9sTNHdMrXesX8eBL6T9b+MZJk+mZuPxKNVfEQMQ
 a5SxUEADIPQTPNvBewdeI80yeOCrN+Zzwy/Mrx9EPeu59Y5vSJOx/z6OUImD/GhX7Xvkt3kq
 Er5KTrJz3++B6SH9pum9PuoE/k+nntJkNMmQpR4MCBaV/J9gIOPGodDKnjdng+mXliF3Ptu6
 3oxc2RCyGzTlxyMwuc2U5Q7KtUNTdDe8T0uE+9b8BLMVQDDfJjqY0VVqSUwImzTDLX9S4g/8
 kC4HRcclk8hpyhY2jKGluZO0awwTIMgVEzmTyBphDg/Gx7dZU1Xf8HFuE+UZ5UDHDTnwgv7E
 th6RC9+WrhDNspZ9fJjKWRbveQgUFCpe1sa77LAw+XFrKmBHXp9ZVIe90RMe2tRL06BGiRZr
 jPrnvUsUUsjRoRNJjKKA/REq+sAnhkNPPZ/NNMjaZ5b8Tovi8C0tmxiCHaQYqj7G2rgnT0kt
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <CA+EHjTxNEoQ3MtZPi603=366vxt=SmBwetS4mFkvTK2r6u=UHw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 23.01.25 10:48, Fuad Tabba wrote:
> On Wed, 22 Jan 2025 at 22:10, David Hildenbrand <david@redhat.com> wrote:
>>
>> On 22.01.25 16:27, Fuad Tabba wrote:
>>> Make kvm_(read|/write)_guest_page() capable of accessing guest
>>> memory for slots that don't have a userspace address, but only if
>>> the memory is mappable, which also indicates that it is
>>> accessible by the host.
>>
>> Interesting. So far my assumption was that, for shared memory, user
>> space would simply mmap() guest_memdd and pass it as userspace address
>> to the same memslot that has this guest_memfd for private memory.
>>
>> Wouldn't that be easier in the first shot? (IOW, not require this patch
>> with the cost of faulting the shared page into the page table on access)
> 

In light of:

https://lkml.kernel.org/r/20250117190938.93793-4-imbrenda@linux.ibm.com

there can, in theory, be memslots that start at address 0 and have a 
"valid" mapping. This case is done from the kernel (and on special s390x 
hardware), though, so it does not apply here at all so far.

In practice, getting address 0 as a valid address is unlikely, because 
the default:

$ sysctl  vm.mmap_min_addr
vm.mmap_min_addr = 65536

usually prohibits it for good reason.

> This has to do more with the ABI I had for pkvm and shared memory
> implementations, in which you don't need to specify the userspace
> address for memory in a guestmem memslot. The issue is there is no
> obvious address to map it to. This would be the case in kvm:arm64 for
> tracking paravirtualized time, which the userspace doesn't necessarily
> need to interact with, but kvm does.

So I understand correctly: userspace wouldn't have to mmap it because it 
is not interested in accessing it, but there is nothing speaking against 
mmaping it, at least in the first shot.

I assume it would not be a private memslot (so far, my understanding is 
that internal memslots never have a guest_memfd attached). 
kvm_gmem_create() is only called via KVM_CREATE_GUEST_MEMFD, to be set 
on user-created memslots.

> 
> That said, we could always have a userspace address dedicated to
> mapping shared locations, and use that address when the necessity
> arises. Or we could always require that memslots have a userspace
> address, even if not used. I don't really have a strong preference.

So, the simpler version where user space would simply mmap guest_memfd 
to provide the address via userspace_addr would at least work for the 
use case of paravirtualized time?

It would get rid of the immediate need for this patch and patch #4 to 
get it flying.


One interesting question is: when would you want shared memory in 
guest_memfd and *not* provide it as part of the same memslot.


One nice thing about the mmap might be that access go via user-space 
page tables: E.g., __kvm_read_guest_page can just access the memory 
without requiring the folio lock and an additional temporary folio 
reference on every access -- it's handled implicitly via the mapcount.

(of course, to map the page we still need that once on the fault path)

-- 
Cheers,

David / dhildenb


