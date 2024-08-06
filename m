Return-Path: <kvm+bounces-23376-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BACE9492A6
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 16:08:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 252A11F21E36
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 14:08:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFA1C18D63B;
	Tue,  6 Aug 2024 14:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="g46kvkU+"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7358318D628
	for <kvm@vger.kernel.org>; Tue,  6 Aug 2024 14:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722953313; cv=none; b=l2okvVKntvTF64wMyNUxNScNT/SMfpb+MjgaYmE+Vs483WI8JiDGOtUJFyToPJ3WX4Irb2TZmHdnTmDPppEEAI9cp2LXT/Re2oQlhy5BeVVbQdilnxLHfivHrU9g/Uf4coDGttw8vb01weMNFtSvtZrQdKh1cU6AQonqFkODyuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722953313; c=relaxed/simple;
	bh=vlGmBOftKIZpdRBPTZhL4vlLvSmtYIuAmQ+hY+0/2Vc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Y/Lj08iWTteHZmX0QDALQ0jx3G4M7JxvcjjHbFGWrR6Jcr4ehEYwpojfpdwe+5x0RPHr70exNnLCCkGMBRoEA3FFWZJ7uAeRONTS/KmAU1LVSwV6/gZhSpiocdA2rBDhuIbi4LhzqYrhMT40JJvOZc+l7SdXP7cJ78brwCooA78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=g46kvkU+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722953310;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=hbna4654uDKbKfBgT+7Y7s0hXv1oN4OUzzUqS0K6H94=;
	b=g46kvkU+Rk8v6s7oXVzIy2FrwHvE5QKrX6je26vJ4GUKRFJZyaSbb5xPVYZIZx3nrZJmqj
	bSrHuIeuSZRj3YyZOJor4/NedpCyIHapu9/0V3heLuo4eSZ2A9JINyYcIrPFs01VpSIjAp
	e2onHp8SbfSW15+550+6+vl6fMN+jMo=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-101-rNZLf6xTNSihhqJ69J5fZg-1; Tue, 06 Aug 2024 10:08:29 -0400
X-MC-Unique: rNZLf6xTNSihhqJ69J5fZg-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-369bf135b49so548126f8f.0
        for <kvm@vger.kernel.org>; Tue, 06 Aug 2024 07:08:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722953308; x=1723558108;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=hbna4654uDKbKfBgT+7Y7s0hXv1oN4OUzzUqS0K6H94=;
        b=D+kV8wQjje2vGWzVRt1Z4e+xMx/NtuZu9Gm9IWPg+JPpxDUHkAWf16FfRS8cWNJ4Zh
         QuJSAV34mcIImV7AeEwS1UZFZC57YLtIKBahyuPSvcRwJ0NjHOSIhJVPg/cYO/m+G+Vy
         pXsjQUT+xd76xieqNWLf+99qONNVIde2FEeCCSU1H2gStgxkQfRnEGTdfUC7PlKwu6MJ
         hQkLKv+cIXhPXTG62h58KpB5Knzh1D0CmrdqaeYSeb/f8pDg7m7qSIQ12q5kart2MrCG
         k9c28gZ/d2topVVUjQXT/TROM54aHc9lZhO4RKpQsDfG7q/c/xkaHIrCfEQA59/ypE95
         qGXw==
X-Forwarded-Encrypted: i=1; AJvYcCXSnx6DI+NPXew/b7bFhGkjRgYspQ7QoUTgQIlxEyCBb/KWqucfrPgJe6Kkfj0lFQ+lOMSKYRfiglWclQGSZZqO7UBD
X-Gm-Message-State: AOJu0Ywvf/8JYNa+TCu4+T6mmvFVcEqzSVHY08mTkK14y8pLm6pWhdA8
	n32DVd9aoJYLErzLjnnmbPT7xIrgLTcCsDstpPp+K6Hc1iTKq3+TY6PvCDwrZ8VnP2PZNLXOd/j
	KLERYvDUzrWhuVRgu2eE2CAPriR/PkBvurGG0zCJqWtVebjaOdw==
X-Received: by 2002:a5d:6892:0:b0:362:23d5:3928 with SMTP id ffacd0b85a97d-36bb35c5ecdmr13692099f8f.17.1722953307889;
        Tue, 06 Aug 2024 07:08:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IExCTsj02K2WYXzGt8u2T0xh3iMsv4w2hInseiESktzMOYaBeImfP7qFcOLNkB4yhVrCXP4fw==
X-Received: by 2002:a5d:6892:0:b0:362:23d5:3928 with SMTP id ffacd0b85a97d-36bb35c5ecdmr13692066f8f.17.1722953307274;
        Tue, 06 Aug 2024 07:08:27 -0700 (PDT)
Received: from [192.168.3.141] (p4ff234d2.dip0.t-ipconnect.de. [79.242.52.210])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4282bb97fbasm245003675e9.41.2024.08.06.07.08.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Aug 2024 07:08:26 -0700 (PDT)
Message-ID: <c55fc93d-270b-4b11-9b38-b54f350ea6c9@redhat.com>
Date: Tue, 6 Aug 2024 16:08:25 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 3/4] mm: guest_memfd: Add option to remove guest
 private memory from direct map
To: Elliot Berman <quic_eberman@quicinc.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
 <seanjc@google.com>, Fuad Tabba <tabba@google.com>,
 Patrick Roy <roypat@amazon.co.uk>, qperret@google.com,
 Ackerley Tng <ackerleytng@google.com>
Cc: linux-coco@lists.linux.dev, linux-arm-msm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org
References: <20240805-guest-memfd-lib-v1-0-e5a29a4ff5d7@quicinc.com>
 <20240805-guest-memfd-lib-v1-3-e5a29a4ff5d7@quicinc.com>
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
In-Reply-To: <20240805-guest-memfd-lib-v1-3-e5a29a4ff5d7@quicinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 05.08.24 20:34, Elliot Berman wrote:
> This patch was reworked from Patrick's patch:
> https://lore.kernel.org/all/20240709132041.3625501-6-roypat@amazon.co.uk/
> 
> While guest_memfd is not available to be mapped by userspace, it is
> still accessible through the kernel's direct map. This means that in
> scenarios where guest-private memory is not hardware protected, it can
> be speculatively read and its contents potentially leaked through
> hardware side-channels. Removing guest-private memory from the direct
> map, thus mitigates a large class of speculative execution issues
> [1, Table 1].

I think you have to point out here that the speculative execution issues 
are primarily only an issue when guest_memfd private memory is used 
without TDX and friends where the memory would be encrypted either way.

Or am I wrong?

> 
> Direct map removal do not reuse the `.prepare` machinery, since
> `prepare` can be called multiple time, and it is the responsibility of
> the preparation routine to not "prepare" the same folio twice [2]. Thus,
> instead explicitly check if `filemap_grab_folio` allocated a new folio,
> and remove the returned folio from the direct map only if this was the
> case.
> 
> The patch uses release_folio instead of free_folio to reinsert pages
> back into the direct map as by the time free_folio is called,
> folio->mapping can already be NULL. This means that a call to
> folio_inode inside free_folio might deference a NULL pointer, leaving no
> way to access the inode which stores the flags that allow determining
> whether the page was removed from the direct map in the first place.
> 
> [1]: https://download.vusec.net/papers/quarantine_raid23.pdf
> 
> Cc: Patrick Roy <roypat@amazon.co.uk>
> Signed-off-by: Elliot Berman <quic_eberman@quicinc.com>
> ---
>   include/linux/guest_memfd.h |  8 ++++++
>   mm/guest_memfd.c            | 65 ++++++++++++++++++++++++++++++++++++++++++++-
>   2 files changed, 72 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/guest_memfd.h b/include/linux/guest_memfd.h
> index be56d9d53067..f9e4a27aed67 100644
> --- a/include/linux/guest_memfd.h
> +++ b/include/linux/guest_memfd.h
> @@ -25,6 +25,14 @@ struct guest_memfd_operations {
>   	int (*release)(struct inode *inode);
>   };
>   
> +/**
> + * @GUEST_MEMFD_FLAG_NO_DIRECT_MAP: When making folios inaccessible by host, also
> + *                                  remove them from the kernel's direct map.
> + */

Should we start introducing the concept of private and shared first, 
such that we can then say that this only applies to private memory?

> +enum {
> +	GUEST_MEMFD_FLAG_NO_DIRECT_MAP		= BIT(0),
> +};
> +
>   /**
>    * @GUEST_MEMFD_GRAB_UPTODATE: Ensure pages are zeroed/up to date.
>    *                             If trusted hyp will do it, can ommit this flag
> diff --git a/mm/guest_memfd.c b/mm/guest_memfd.c
> index 580138b0f9d4..e9d8cab72b28 100644
> --- a/mm/guest_memfd.c
> +++ b/mm/guest_memfd.c
> @@ -7,9 +7,55 @@
>   #include <linux/falloc.h>
>   #include <linux/guest_memfd.h>
>   #include <linux/pagemap.h>
> +#include <linux/set_memory.h>
> +
> +static inline int guest_memfd_folio_private(struct folio *folio)
> +{
> +	unsigned long nr_pages = folio_nr_pages(folio);

guest_memfd only supports small folios, this can be simplified.

> +	unsigned long i;
> +	int r;
> +
> +	for (i = 0; i < nr_pages; i++) {
> +		struct page *page = folio_page(folio, i);
> +
> +		r = set_direct_map_invalid_noflush(page);
> +		if (r < 0)
> +			goto out_remap;
> +	}
> +
> +	folio_set_private(folio);
> +	return 0;
> +out_remap:
> +	for (; i > 0; i--) {
> +		struct page *page = folio_page(folio, i - 1);
> +
> +		BUG_ON(set_direct_map_default_noflush(page));
> +	}
> +	return r;
> +}
> +
> +static inline void guest_memfd_folio_clear_private(struct folio *folio)

Set set/clear private semantics in this context are a bit confusing. I 
assume you mean "make inaccessible" "make accessible" and using the 
PG_private flag is just an implementation detail.

> +{
> +	unsigned long start = (unsigned long)folio_address(folio);
> +	unsigned long nr = folio_nr_pages(folio);
> +	unsigned long i;
> +
> +	if (!folio_test_private(folio))
> +		return;
> +
> +	for (i = 0; i < nr; i++) {
> +		struct page *page = folio_page(folio, i);
> +
> +		BUG_ON(set_direct_map_default_noflush(page));
> +	}
> +	flush_tlb_kernel_range(start, start + folio_size(folio));
> +
> +	folio_clear_private(folio);
> +}
>   
>   struct folio *guest_memfd_grab_folio(struct file *file, pgoff_t index, u32 flags)
>   {
> +	unsigned long gmem_flags = (unsigned long)file->private_data;
>   	struct inode *inode = file_inode(file);
>   	struct guest_memfd_operations *ops = inode->i_private;
>   	struct folio *folio;
> @@ -43,6 +89,12 @@ struct folio *guest_memfd_grab_folio(struct file *file, pgoff_t index, u32 flags
>   			goto out_err;
>   	}
>   
> +	if (gmem_flags & GUEST_MEMFD_FLAG_NO_DIRECT_MAP) {
> +		r = guest_memfd_folio_private(folio);
> +		if (r)
> +			goto out_err;
> +	}
> +
>   	/*
>   	 * Ignore accessed, referenced, and dirty flags.  The memory is
>   	 * unevictable and there is no storage to write back to.
> @@ -213,14 +265,25 @@ static bool gmem_release_folio(struct folio *folio, gfp_t gfp)
>   	if (ops->invalidate_end)
>   		ops->invalidate_end(inode, offset, nr);
>   
> +	guest_memfd_folio_clear_private(folio);
> +
>   	return true;
>   }
>   
> +static void gmem_invalidate_folio(struct folio *folio, size_t offset, size_t len)
> +{
> +	/* not yet supported */
> +	BUG_ON(offset || len != folio_size(folio));
> +
> +	BUG_ON(!gmem_release_folio(folio, 0));

In general, no BUG_ON please. WARN_ON_ONCE() is sufficient.

> +}
> +
>   static const struct address_space_operations gmem_aops = {
>   	.dirty_folio = noop_dirty_folio,
>   	.migrate_folio = gmem_migrate_folio,
>   	.error_remove_folio = gmem_error_folio,
>   	.release_folio = gmem_release_folio,
> +	.invalidate_folio = gmem_invalidate_folio,
>   };
>   
>   static inline bool guest_memfd_check_ops(const struct guest_memfd_operations *ops)
> @@ -241,7 +304,7 @@ struct file *guest_memfd_alloc(const char *name,
>   	if (!guest_memfd_check_ops(ops))
>   		return ERR_PTR(-EINVAL);
>   
> -	if (flags)
> +	if (flags & ~GUEST_MEMFD_FLAG_NO_DIRECT_MAP)
>   		return ERR_PTR(-EINVAL);
>   
>   	/*
> 

-- 
Cheers,

David / dhildenb


