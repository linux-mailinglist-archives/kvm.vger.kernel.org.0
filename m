Return-Path: <kvm+bounces-39392-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2100DA46BE5
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 21:06:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8930318858C2
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 20:06:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64962236A74;
	Wed, 26 Feb 2025 20:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cgr0cl4J"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E615921CC79
	for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 20:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740600366; cv=none; b=bIIDllt/+Mp+vp+Teif5F+hHrpM6tKnHFer8faMyDlnbD2RUdVZd6459/guxZf+eAmPm+JPb/MJRZNfUmDNGKd+mkfhhvpH+FbEWqmWsdOxcOZDpyPiN4U1O7Lt0Xx4DmC5ip7OCLVsQZ8RK3gDkrMQSGfm2KD0YcItJMyZDNws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740600366; c=relaxed/simple;
	bh=yfQM1CqTfquiWJhwLZj9JaiA7Bh+UIirxNzXo464XAU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RAezyzUpYj10cqSIs67ZQ796KOQ41pNk4h9XHYnGc366E7Bxe4R+ZDtBE0sOBHfRstTP2Iqj3WJsJSTnCN4ceU2JFSrBW8tUok52JeztbydgyNyywbjA60lC32LXrT1MI+RS3O4wbRCFu5QEoMwsy7XKzt8gcKo9W9/MqIGim1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cgr0cl4J; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740600363;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=VkP4TuFVcedC8r8X6iUSdW1moEur4w/J0xKrd7lJWeA=;
	b=cgr0cl4JyGILmdMqaia6RBFIkBiU6Wyqu1kQuzIHHUcH7SdKABEQjYt9lxnB+Fpt/Y5e17
	meJaea0+343TeiNPBQUt9lxuarF6PwcIxfvh3DNYtbJ7eQ7Cerp7wnecxxSteni7yNgl9s
	T5XHwiF4cRzUdKXNODgRVPUVg9UH6sI=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-413-L9VU3pIjNPSJ8zCt010V_A-1; Wed, 26 Feb 2025 15:06:02 -0500
X-MC-Unique: L9VU3pIjNPSJ8zCt010V_A-1
X-Mimecast-MFC-AGG-ID: L9VU3pIjNPSJ8zCt010V_A_1740600361
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-43947979ce8so832435e9.0
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 12:06:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740600361; x=1741205161;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=VkP4TuFVcedC8r8X6iUSdW1moEur4w/J0xKrd7lJWeA=;
        b=b42yMVMUsN3pirUesp/GqXbjaX8FjSUBG6UVM9WGqo06nDtsnYnPs8PwGAN6KnYFVJ
         iVKED7erUlvoqththrbYx/YrfkNo8UaCkdDIdZ8qRsrpgZfhwr1TcQRPuDUTSaRUS4Hu
         Npc9n7ZaP1WbdChgvGnsVBJgiQJrTxMqdK3QWqfmoP06vDqScGYr6/kvDo2Voz+0iJd3
         ONnWDNcchcNtbJqWBbxXXDXS6FId8Zo4f6YQqDsrcnUBR4X/mvz2bj5ub7scQuA3njkG
         UrbUOLOtN1LnwHb1kX6o7SuWcrj34EvRAF1B/NCV31tEoEiP3UkCObsDJ/v/4a8QnaoD
         /54Q==
X-Gm-Message-State: AOJu0YyEv9dEWnGo/e+JMs71DHqdXZNh6gAqFDrGaGVG7G3tf4OdJ6x7
	6NIPXg3nmzmu/BtXcVqFtDCpj8vbNTmJ0IFxu/d3w5vQGaCLCoaKWMwkAYPL/c6lTSs8Bp2az28
	LaZU6g1ykEz74ADh2/iitpJWizsqriFtvzH4Wm3BLxwndpoV+ig==
X-Gm-Gg: ASbGncs053YrNIyMnpAADppTCIrcYCz1lWu9GpjnzD8WfBgwmVrXRBqadrPMpJVl9mS
	ohbjuxsyExjLEfkyPCpD2EQbBmmEzzrROZOuhATiCcyi4z2wIDzMICptjPCiiKq/taXyQfhVCWv
	z5LbZ3vS+a9aa6X3tWfyAoF6OSZ6hVmoFbFeWE+PjjXBgnu588gYK/P0LPAN5IgCDsCI2oh+vjc
	orf0ngQ94UzLzRT4f5zeZwFg0w3o4l2ZLSE9gJWQKhiIMleL9FT+dDhNSy1KxP4fWoUh4x6RLFF
	JnUNt9Kbqh3yiUFy0WH8Tk5OWJxb2Vmw2QVMpnW6/LIE
X-Received: by 2002:a05:600c:4ed1:b0:439:a155:549d with SMTP id 5b1f17b1804b1-439ae1eacfdmr199361655e9.12.1740600361055;
        Wed, 26 Feb 2025 12:06:01 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGSLrbCY8KNtNI+AO0sxh7vDOX9ToRLiD06mZNoQeMc6k2mNBytgFCMdXePpXFhkuvOF0ZMYA==
X-Received: by 2002:a05:600c:4ed1:b0:439:a155:549d with SMTP id 5b1f17b1804b1-439ae1eacfdmr199361515e9.12.1740600360655;
        Wed, 26 Feb 2025 12:06:00 -0800 (PST)
Received: from [192.168.3.141] (p5b0c6611.dip0.t-ipconnect.de. [91.12.102.17])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43aba5711dfsm32306775e9.27.2025.02.26.12.05.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Feb 2025 12:06:00 -0800 (PST)
Message-ID: <2be79033-187f-4dff-af2b-d97a52a450a8@redhat.com>
Date: Wed, 26 Feb 2025 21:05:59 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/6] mm: Provide address mask in struct
 follow_pfnmap_args
To: Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, peterx@redhat.com,
 mitchell.augustin@canonical.com, clg@redhat.com, jgg@nvidia.com,
 akpm@linux-foundation.org, linux-mm@kvack.org
References: <20250218222209.1382449-1-alex.williamson@redhat.com>
 <20250218222209.1382449-6-alex.williamson@redhat.com>
 <3d1315ab-ba94-46c2-8dbf-ef26454f7007@redhat.com>
 <20250226125435.72bbb00a.alex.williamson@redhat.com>
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
In-Reply-To: <20250226125435.72bbb00a.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 26.02.25 20:54, Alex Williamson wrote:
> On Wed, 19 Feb 2025 09:31:48 +0100
> David Hildenbrand <david@redhat.com> wrote:
> 
>> On 18.02.25 23:22, Alex Williamson wrote:
>>> follow_pfnmap_start() walks the page table for a given address and
>>> fills out the struct follow_pfnmap_args in pfnmap_args_setup().
>>> The address mask of the page table level is already provided to this
>>> latter function for calculating the pfn.  This address mask can also
>>> be useful for the caller to determine the extent of the contiguous
>>> mapping.
>>>
>>> For example, vfio-pci now supports huge_fault for pfnmaps and is able
>>> to insert pud and pmd mappings.  When we DMA map these pfnmaps, ex.
>>> PCI MMIO BARs, we iterate follow_pfnmap_start() to get each pfn to test
>>> for a contiguous pfn range.  Providing the mapping address mask allows
>>> us to skip the extent of the mapping level.  Assuming a 1GB pud level
>>> and 4KB page size, iterations are reduced by a factor of 256K.  In wall
>>> clock time, mapping a 32GB PCI BAR is reduced from ~1s to <1ms.
>>>
>>> Cc: Andrew Morton <akpm@linux-foundation.org>
>>> Cc: David Hildenbrand <david@redhat.com>
>>> Cc: linux-mm@kvack.org
>>> Reviewed-by: Peter Xu <peterx@redhat.com>
>>> Reviewed-by: "Mitchell Augustin" <mitchell.augustin@canonical.com>
>>> Tested-by: "Mitchell Augustin" <mitchell.augustin@canonical.com>
>>> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
>>> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
>>> ---
>>
>> Acked-by: David Hildenbrand <david@redhat.com>
> 
> Thanks, David!
> 
> Is there any objection from mm folks to bring this in through the vfio
> tree?

I assume it's fine. Andrew is on CC, so he should be aware of it. I'm 
not aware of possible clashes.

-- 
Cheers,

David / dhildenb


