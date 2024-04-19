Return-Path: <kvm+bounces-15269-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DB0068AAEE6
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 14:59:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9196B283B62
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 12:58:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2151B126F1C;
	Fri, 19 Apr 2024 12:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Fp1ku6qu"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1E9B8624B
	for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 12:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713531531; cv=none; b=JjRcZxImIiWnenegvIH/UmnH5pM9GFACNnBWSH15vzFm7Ikf8+7WQf2Zmvz1RvqhWCqDzr6jmdSzb2mFTSSYv1LAxpeWl6fXi73ZA0y1bD7Rh/DyciOLHn2Qpf0TrERfjuD3d79V7l54yL/bnhaP/0LtLofbm8FxNS+Jbh5XTfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713531531; c=relaxed/simple;
	bh=6Zi4dffDXqoSeWakmnxczB43BLdpL7HhEoJrIZmU3LA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=s3LzJw9oxYGI8NBdZhbqiCz9uGN8dUPwm+YPLSPhF+P6RrZr7sdmHDAzhasatCiclAETcjgEACE2fDTJJ/AjPI2g7gS/irCj4xh5ez401Z/EJJSkgt8QKgIsduik4/iLYfqo/sytoBveMONRfWipoRTrTE6YUWpMQC778I0XdRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Fp1ku6qu; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713531528;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Z2d3iqx05Gqxh4rph9K0FnqpHu231qlz9mgP4t0RVZk=;
	b=Fp1ku6quEJi9PR1lCeC0Ov9rh8l4aiqwaAKUaoI7ClYGQvW3c+X+kMH8Kwbg+bDy6g03M2
	wX6sjTc9JxeemQBluWpPh+tDaEJ9u9dZvgYbcyBURC3pOEiHXnNiENjjp3UPVSXbVWMSkZ
	GPHIwTgECrXOGTopAObLft+ESZDr0Ug=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-50-YTPe-WrFOhSOJarlzVYy4g-1; Fri, 19 Apr 2024 08:58:47 -0400
X-MC-Unique: YTPe-WrFOhSOJarlzVYy4g-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4183d08093bso11641415e9.1
        for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 05:58:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713531526; x=1714136326;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Z2d3iqx05Gqxh4rph9K0FnqpHu231qlz9mgP4t0RVZk=;
        b=HK7tzTQDB68iLcuu4QCFCd6iWWPFNn81l+l4Bu2xVAh8DqZUpd/VaON3gtYf/I9OVg
         bC7sj8pkW8I/72jEgAjSSPA048Cs6/4JPemvccqKLjmoWPmIn/eQgLuE5IsN4gspKasr
         eB8t7jgceja2wF27BmsPJkzJ7hlMJov9mVjDQUUvwlDVEDe88z5tUI0H9fqj8dHSEueX
         jdPBYv51Qx71kpyYVyRUpkzL2w2dm1gOdA0UGEVO1hzxyGc1BiAEcfyvElRDMpx7O8Es
         YdFYF9TPfBzWqMSCSDP2SLdvuF4lfUOWYWclDX9duHy5Ty+Vudy9PMmKTib5o4R2zLlx
         pxHA==
X-Forwarded-Encrypted: i=1; AJvYcCURPJz20Acs3NZ/mkf7nhtiiQpiwvsjlWxX7NerLLCFrxprQXvm85CMQpqXNcjrftacKg+hQFjpBasNeAvtDX8PsDUs
X-Gm-Message-State: AOJu0Yz5510Sdgrp8oR+dACMM0Pi9YwXqY50qPkrvGX0lIBr+K8NFEXr
	S0d46NXD807IEUSW4ac7TWL70PY2WaOtm30hUZ7PhTObVoDDATOn5bqW7gtj+e7aMU7SC4Wnfx9
	0kvkvQ302jNRKYtQKc+WnD6b0g4XpPf2C70WN3+GLd/4+4I+w2w==
X-Received: by 2002:a5d:6a46:0:b0:346:b581:ff57 with SMTP id t6-20020a5d6a46000000b00346b581ff57mr1650292wrw.68.1713531526313;
        Fri, 19 Apr 2024 05:58:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH7m8NTVqsbUldIBxMAx8E1NGImyAQjyh5UpwPAdGx0OoeBVIRTXxysKxRh8PdQ61Jjn+Ewpg==
X-Received: by 2002:a5d:6a46:0:b0:346:b581:ff57 with SMTP id t6-20020a5d6a46000000b00346b581ff57mr1650273wrw.68.1713531525824;
        Fri, 19 Apr 2024 05:58:45 -0700 (PDT)
Received: from ?IPV6:2003:cb:c716:f300:c9f0:f643:6aa2:16? (p200300cbc716f300c9f0f6436aa20016.dip0.t-ipconnect.de. [2003:cb:c716:f300:c9f0:f643:6aa2:16])
        by smtp.gmail.com with ESMTPSA id w15-20020a5d544f000000b00349c63eb484sm4363099wrv.23.2024.04.19.05.58.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Apr 2024 05:58:45 -0700 (PDT)
Message-ID: <a6086ba5-6137-44a0-9e51-ce4df5eb6ce4@redhat.com>
Date: Fri, 19 Apr 2024 14:58:43 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 04/26] KVM: guest_memfd: Fix PTR_ERR() handling in
 __kvm_gmem_get_pfn()
To: Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org
Cc: linux-coco@lists.linux.dev, linux-mm@kvack.org,
 linux-crypto@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
 tglx@linutronix.de, mingo@redhat.com, jroedel@suse.de,
 thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org,
 pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
 jmattson@google.com, luto@kernel.org, dave.hansen@linux.intel.com,
 slp@redhat.com, pgonda@google.com, peterz@infradead.org,
 srinivas.pandruvada@linux.intel.com, rientjes@google.com,
 dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de, vbabka@suse.cz,
 kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com,
 sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
 jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com,
 pankaj.gupta@amd.com, liam.merwick@oracle.com
References: <20240418194133.1452059-1-michael.roth@amd.com>
 <20240418194133.1452059-5-michael.roth@amd.com>
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
In-Reply-To: <20240418194133.1452059-5-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 18.04.24 21:41, Michael Roth wrote:
> kvm_gmem_get_folio() may return a PTR_ERR() rather than just NULL. In
> particular, for cases where EEXISTS is returned when FGP_CREAT_ONLY
> flag is used. Handle this properly in __kvm_gmem_get_pfn().
> 
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>   virt/kvm/guest_memfd.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index ccf22e44f387..9d7c6a70c547 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -580,8 +580,8 @@ static int __kvm_gmem_get_pfn(struct file *file, struct kvm_memory_slot *slot,
>   	}
>   
>   	folio = kvm_gmem_get_folio(file_inode(file), index, prepare);
> -	if (!folio)
> -		return -ENOMEM;
> +	if (IS_ERR_OR_NULL(folio))
> +		return folio ? PTR_ERR(folio) : -ENOMEM;

Will it even return NULL?  Staring at other filemap_grab_folio() users, 
they all check for IS_ERR().

>   
>   	if (folio_test_hwpoison(folio)) {
>   		r = -EHWPOISON;

Do we have a Fixes: tag?

-- 
Cheers,

David / dhildenb


