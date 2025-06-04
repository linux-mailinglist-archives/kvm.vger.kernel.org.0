Return-Path: <kvm+bounces-48390-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C0A4ACDC88
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 13:30:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 71FA27A61C7
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 11:28:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED1A228EA4C;
	Wed,  4 Jun 2025 11:29:56 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D202328E607
	for <kvm@vger.kernel.org>; Wed,  4 Jun 2025 11:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749036596; cv=none; b=rOvk6kE9tea2WiFHp1Ui6sJPvo4DJnBpUor2rVPwvblkCqbm4dXn1IfJsGpEMfgOnKahMSX9y2da2ix8HGwcMb6AH8zN0jdw3pZmRG4M5+pupEzfGu5X1k7DFkdPX/dOPh7frIliZhUh/1TZoPmL7jIIZcgHcGajEsvX+wJNb4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749036596; c=relaxed/simple;
	bh=ilVaIPffxO5BVnCFX3MSyK7+ZW/d2iK/LKrmznZFOZI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TyilnTH26PKSvXfeyFIGthobN6Dorg2ExspTGhmNdkmSqHWrQxht2GBM27cWQohcD3gv+9l7HSTsDYiyB2gMGUqOn/W3auyWMdo5LA1WxCHM3BCOv/v+nnJnhdflq5KOBY6krxm0EELlOkdfWN63UYUgGbXvWwPG1qdCXHjuXpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-307-S4fOsvR-Of6dYeJpWIdfnw-1; Wed, 04 Jun 2025 07:29:52 -0400
X-MC-Unique: S4fOsvR-Of6dYeJpWIdfnw-1
X-Mimecast-MFC-AGG-ID: S4fOsvR-Of6dYeJpWIdfnw_1749036591
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-450d9f96f61so40969585e9.1
        for <kvm@vger.kernel.org>; Wed, 04 Jun 2025 04:29:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749036591; x=1749641391;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=VcMmxM8BV27BI5GGovm6YWQ95xlppESodfFirxn74hI=;
        b=IgDuiPAFJLFQ6nXAGGoFuTENbw+Tnqs/eWeXj65AxJj0sarmBCPiDTS2NsLL3Fkxyu
         FDjTTuT/m6FL1zYRsqSKbnOsbNADKVtsM4zfPnHQBRJ88J75KEcD2+43UQD/dLqUitxA
         wsuNjQ+P0ZInsTSHL8ayfrK9PcpRB+XPcLhdrYCUW5vH/RBw0KfgzDj8GPXrU8714QoN
         dPrQ2I40zDfAoPw/GGn0fkB+m7GlTaXqLbNOQpOYL0J91XlT5PQOro2zhu+MChAHzhgX
         2DbToKLeD9pa7XyxirCsAi4pLcnGgV/lGnvak13e4YXjGmaWvMs0SYWtk4bAV5HECwj5
         +Lug==
X-Forwarded-Encrypted: i=1; AJvYcCWU06asDVfKRSTnklPpXK4cIwPV/aBgBNbehfJfdKgN1/OtfXQCROVUaREMw2NcEnGfVks=@vger.kernel.org
X-Gm-Message-State: AOJu0YzvQ6Co/BgFw6S4PhfEinyC5KaA+eCboMXvBiHYKauzfif0/8OP
	+B0vO9PNvOCl09nW+SfrzQJ9FDg6IOYDx7MQJefByQPaROuu/qqIYyH7zmvYbNW5xNam/3rVpQ9
	gbMUkBsMfyoMlyZqywsyc25yKHrKIozQ7KHaIj/5z+78rC++ho9pioQ==
X-Gm-Gg: ASbGnctAlyTwL5ofpGZQZZfWg8s1pwI/VsAefMxmC1IgkgFDV4YgsmzgzTHlfdPWzjt
	SdBj2uVtrKPwXzlnYmsuu2lqQxmQTFAQV2FkrRfSQft4etLB8ZpjeEyEkbiPRLMcHyEckMGlqtt
	81aKjnOmPd8nQnuxgbndMBv++cPK7aSQMtIbGxYjlpTYgPyLHYy/MeZzTYtrJGnhNLlkTTdfRiK
	2usdDy5j8pofO504l2Cu7MCHGMJ+RJBpshMTzgnra8Qtt2N3m6WUPCRZjmHZaGeXWLECyPc2URV
	I5Fhpr2cvgdjr6ES/VTRnsL8M74JpVPrSDv9vOGewHc/k1HVWLETMfHl9gFwDZ1nETTjXZ4LZit
	1atxEdZ7sKoi14MajW/LRAbyRUPhYWF8WqOYHSZs=
X-Received: by 2002:a05:600c:4ec6:b0:43c:ec0a:ddfd with SMTP id 5b1f17b1804b1-451f0a64c0amr20239505e9.6.1749036591149;
        Wed, 04 Jun 2025 04:29:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEvuFQF/8b7k7hr3pcERBG9Jeu7Z4bRrBOvojwxfnOLddVfCMXdF9KQx11TSXpijAT+/REwEQ==
X-Received: by 2002:a05:600c:4ec6:b0:43c:ec0a:ddfd with SMTP id 5b1f17b1804b1-451f0a64c0amr20239275e9.6.1749036590708;
        Wed, 04 Jun 2025 04:29:50 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f1b:b800:6fdb:1af2:4fbd:1fdf? (p200300d82f1bb8006fdb1af24fbd1fdf.dip0.t-ipconnect.de. [2003:d8:2f1b:b800:6fdb:1af2:4fbd:1fdf])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-451ef77b467sm28058735e9.36.2025.06.04.04.29.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Jun 2025 04:29:50 -0700 (PDT)
Message-ID: <49a69be3-0368-440c-8263-0f3eeae7313c@redhat.com>
Date: Wed, 4 Jun 2025 13:29:49 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 5/5] physmem: Support coordinated discarding of RAM
 with guest_memfd
To: Chenyi Qiang <chenyi.qiang@intel.com>, Alexey Kardashevskiy
 <aik@amd.com>, Peter Xu <peterx@redhat.com>,
 Gupta Pankaj <pankaj.gupta@amd.com>, Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Michael Roth <michael.roth@amd.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Williams Dan J <dan.j.williams@intel.com>, Zhao Liu <zhao1.liu@intel.com>,
 Baolu Lu <baolu.lu@linux.intel.com>, Gao Chao <chao.gao@intel.com>,
 Xu Yilun <yilun.xu@intel.com>, Li Xiaoyao <xiaoyao.li@intel.com>,
 =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@kaod.org>,
 Alex Williamson <alex.williamson@redhat.com>
References: <20250530083256.105186-1-chenyi.qiang@intel.com>
 <20250530083256.105186-6-chenyi.qiang@intel.com>
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
In-Reply-To: <20250530083256.105186-6-chenyi.qiang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 30.05.25 10:32, Chenyi Qiang wrote:
> A new field, attributes, was introduced in RAMBlock to link to a
> RamBlockAttributes object, which centralizes all guest_memfd related
> information (such as fd and shared bitmap) within a RAMBlock.
> 
> Create and initialize the RamBlockAttributes object upon ram_block_add().
> Meanwhile, register the object in the target RAMBlock's MemoryRegion.
> After that, guest_memfd-backed RAMBlock is associated with the
> RamDiscardManager interface, and the users can execute RamDiscardManager
> specific handling. For example, VFIO will register the
> RamDiscardListener and get notifications when the state_change() helper
> invokes.
> 
> As coordinate discarding of RAM with guest_memfd is now supported, only
> block uncoordinated discard.
> 
> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
> ---
> Changes in v6:
>      - Squash the unblocking of cooridnate discard into this commit.
>      - Remove the checks in migration path.
> 
> Changes in v5:
>      - Revert to use RamDiscardManager interface.
>      - Move the object_new() into the ram_block_attribute_create()
>        helper.
>      - Add some check in migration path.
> 
> Changes in v4:
>      - Remove the replay operations for attribute changes which will be
>        handled in a listener in following patches.
>      - Add some comment in the error path of realize() to remind the
>        future development of the unified error path.
> 
> Changes in v3:
>      - Use ram_discard_manager_reply_populated/discarded() to set the
>        memory attribute and add the undo support if state_change()
>        failed.
>      - Didn't add Reviewed-by from Alexey due to the new changes in this
>        commit.
> ---

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb


