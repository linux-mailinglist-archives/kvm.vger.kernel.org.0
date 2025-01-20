Return-Path: <kvm+bounces-35971-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AC89FA16AED
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 11:39:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3E0F0188972B
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 10:40:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD03B1B6D1D;
	Mon, 20 Jan 2025 10:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CeUpEfUf"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 179931B413E
	for <kvm@vger.kernel.org>; Mon, 20 Jan 2025 10:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737369591; cv=none; b=VHNV438MexEjjtRbNUt8cKK+viqwljdue23DUr5neALABU8GfjzOjhh26dJP05HnimtiGMRbULJfdRqIMwn6k7uA2/v1CStAY1dCx8rmk/2UKzNkcuaEabN1UScfRtMsTHr4cYnn8Muir6UoTmFVYLqGnAJKznTOq/QULZ3Ef64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737369591; c=relaxed/simple;
	bh=JiyoTunX9sfsDXRUrgtu+T47V/36ENz9ggZBhV/WnHk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ivszSnQ8vySz9Cu7wZuLB60k+ht2Fmu/dBYZEeVmfmlvMBbUPzK51/INmQvGJ8YQKmwDGwW5jTRUgNMtDlJi7hYvcyy8qU9a/HDdLIayMECMgBOf77Z/rees/YhIG5q4ejX9VMG/eZTBqTDNmAnq3QgzqNGSZY+JHp6lOZ2M/+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CeUpEfUf; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737369587;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=VNrB+MYFE8yz/6JFZUxImb9XI3I+YQGQ6LNKQMQenfk=;
	b=CeUpEfUfe0tZyd6HyDJNktFhItFsmbOLVRzhNCQorLSfisDG8PZY7K3AP13+5LbbIZJRFc
	Kqmj0Cb5gX1sOZyj/674G4gj31H7Y2oEHvyAjtencLejcwzJdmKjX0zvC9wRFAcYCjMgpE
	eRY8u0W4mJN+wTROMru7j3Jzlquq5pc=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-376-au79zhe6M02WPMs3or8ZoA-1; Mon, 20 Jan 2025 05:39:45 -0500
X-MC-Unique: au79zhe6M02WPMs3or8ZoA-1
X-Mimecast-MFC-AGG-ID: au79zhe6M02WPMs3or8ZoA
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-385e49efd59so1845594f8f.0
        for <kvm@vger.kernel.org>; Mon, 20 Jan 2025 02:39:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737369584; x=1737974384;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=VNrB+MYFE8yz/6JFZUxImb9XI3I+YQGQ6LNKQMQenfk=;
        b=WYfSiBslMIVgyK8dt/s5Jy5CWW3VDe9L48ClHQml4T0GEQRtPI85PSx4VeAYe/BuWS
         2D77CXcIjwOAb9TppNiqmWenKXSSI4kRw4tI0c8Pcp16xObHFsywTUIpLst3g9sn0WVd
         15xV7CmIAw9MHD7zPHPRfToRiU4u5HvEDoEittTsAZoAYeGaNxoe8lWl8Z886oW73Fh+
         wS2hmiQYt14r6Z24DscMyqMNX04ADxoE1PkKfSpPsHNc8L4LkAymPHP3xbzzrBvO+uWM
         QS2AtM7Hm+VW/d3WKZ1olYKVVQVEUog2cO3J+oYzgBIIPb1OHfiYQsBcKJiN14+axx5G
         H4vg==
X-Forwarded-Encrypted: i=1; AJvYcCU3/QmvMDst8c72Ys5qMqg8FgrL/3P0zP91DdEUQqSX0fpVXaEfPKOH7LL7Do76DPxX3Tw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy0GEHycQ1G9eV3QUVn8b2k8dDAXhxTfgoQnWZPmgZ3Uyyh28zu
	mWVMnew1pwXF0WZEdPOwjMGZzvwg1rOjz7sE58ZomBSP4b9Uv6jL5q5FiAlgHIft5XGTAwnqx1g
	f+reyln07MyV5tf43wiJZk0DDNL+eFYT/mEfuZwHQh2MGQGUO/g==
X-Gm-Gg: ASbGnctd27q5d3oLFNvXYOpkhfoA3Uq0uzSkE/zm9WwzCFyHXrJRFYcRrlkqykEsKUi
	ptSDSEkszAA7YlvhY053FcjNsl8NEtwo5F+ER4AfGsB1TUODt/zxkDnckgWvU89cfWt8Eqe6dh5
	1c4JLnx1ghmqey1VSTmnwt3eyqwKJ/icviwZyOACc6Mb1H//v+KYBuVp9JXdTKaSiTIm9+GY85A
	fi5j3cohEChnMTzYwhgv29U9lNPnaV5CGH0f86INL0Vy+JNTL6DZKu9oWaoFSXMZV/UZVk+hr7O
	5HeeaC42CTHoRJIvfbE7TNqu2Ge8aq0pMZdKOxXhayc67d4dbpUdKz5tf5P0dBVZ4MElQ/6Zh7x
	/lGjIbAR2TNcKakeyzJmahQ==
X-Received: by 2002:a05:6000:2ce:b0:38a:a117:3da1 with SMTP id ffacd0b85a97d-38bf566e683mr9785294f8f.5.1737369583961;
        Mon, 20 Jan 2025 02:39:43 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFaUdOENaKv+8RYq4MM/t1CCcwA79j3X6CMyGrqWHIhAkgAc9rpPt82+IkanNndOgoEAKkuhA==
X-Received: by 2002:a05:6000:2ce:b0:38a:a117:3da1 with SMTP id ffacd0b85a97d-38bf566e683mr9785263f8f.5.1737369583536;
        Mon, 20 Jan 2025 02:39:43 -0800 (PST)
Received: from ?IPV6:2003:d8:2f22:1000:d72d:fd5f:4118:c70b? (p200300d82f221000d72dfd5f4118c70b.dip0.t-ipconnect.de. [2003:d8:2f22:1000:d72d:fd5f:4118:c70b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43890367b48sm133942685e9.0.2025.01.20.02.39.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Jan 2025 02:39:43 -0800 (PST)
Message-ID: <0f588655-62c0-46c3-bd15-01016615953f@redhat.com>
Date: Mon, 20 Jan 2025 11:39:39 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v5 01/15] mm: Consolidate freeing of typed folios on
 final folio_put()
To: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-mm@kvack.org
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
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
References: <20250117163001.2326672-1-tabba@google.com>
 <20250117163001.2326672-2-tabba@google.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20250117163001.2326672-2-tabba@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 17.01.25 17:29, Fuad Tabba wrote:
> Some folio types, such as hugetlb, handle freeing their own
> folios. Moreover, guest_memfd will require being notified once a
> folio's reference count reaches 0 to facilitate shared to private
> folio conversion, without the folio actually being freed at that
> point.
> 
> As a first step towards that, this patch consolidates freeing
> folios that have a type. The first user is hugetlb folios. Later
> in this patch series, guest_memfd will become the second user of
> this.
> 
> Suggested-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>   include/linux/page-flags.h | 15 +++++++++++++++
>   mm/swap.c                  | 24 +++++++++++++++++++-----
>   2 files changed, 34 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> index 691506bdf2c5..6615f2f59144 100644
> --- a/include/linux/page-flags.h
> +++ b/include/linux/page-flags.h
> @@ -962,6 +962,21 @@ static inline bool page_has_type(const struct page *page)
>   	return page_mapcount_is_type(data_race(page->page_type));
>   }
>   
> +static inline int page_get_type(const struct page *page)
> +{
> +	return page->page_type >> 24;
> +}
> +
> +static inline bool folio_has_type(const struct folio *folio)
> +{
> +	return page_has_type(&folio->page);
> +}
> +
> +static inline int folio_get_type(const struct folio *folio)
> +{
> +	return page_get_type(&folio->page);
> +}
> +
>   #define FOLIO_TYPE_OPS(lname, fname)					\
>   static __always_inline bool folio_test_##fname(const struct folio *folio) \
>   {									\
> diff --git a/mm/swap.c b/mm/swap.c
> index 10decd9dffa1..6f01b56bce13 100644
> --- a/mm/swap.c
> +++ b/mm/swap.c
> @@ -94,6 +94,20 @@ static void page_cache_release(struct folio *folio)
>   		unlock_page_lruvec_irqrestore(lruvec, flags);
>   }
>   
> +static void free_typed_folio(struct folio *folio)
> +{
> +	switch (folio_get_type(folio)) {
> +	case PGTY_hugetlb:
> +		free_huge_folio(folio);
> +		return;
> +	case PGTY_offline:
> +		/* Nothing to do, it's offline. */
> +		return;

Please drop the PGTY_offline part for now, it was rather to highlight 
what could be done.

But the real goal will be to not make offline pages
use the refcount at all (frozen).

If we really want the temporary PGTY_offline change, it should be 
introduced separately.

Apart from that LGTM!

-- 
Cheers,

David / dhildenb


