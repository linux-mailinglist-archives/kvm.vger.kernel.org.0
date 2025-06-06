Return-Path: <kvm+bounces-48644-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 61506ACFEFB
	for <lists+kvm@lfdr.de>; Fri,  6 Jun 2025 11:14:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A9C593A6FAD
	for <lists+kvm@lfdr.de>; Fri,  6 Jun 2025 09:14:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F3FA286421;
	Fri,  6 Jun 2025 09:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WZfdqshR"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 085C5286410
	for <kvm@vger.kernel.org>; Fri,  6 Jun 2025 09:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749201285; cv=none; b=UY2OY/q+xF/1//DHnAEvjYcQ6bVQG1l+EHmNh6EOQ5TWpgFHa5k2rRVzWsQpJbiYTwV8YZVHwIFvsAyCvxrJouV3pZwMh9zsaskxlxuptHzfRX6/3SP4GaEMzW1s6icAbAqYXJs0cbQtCEwINh4jVbnv3V5i20UTx5rugH6OYUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749201285; c=relaxed/simple;
	bh=B1sHZVub/dqRM9/63GetGGqfhY8L0l8Ko9CARf4d3QQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZokT6DYJ2IAgG7CSUOsXoW7KnehFWIh+UP+QXY93SHCx2T0Apto0aYtS3lyb17xp+ONaGfYHzr/0k0o01JphhgiNWKojNP5Ly/qpoEunFmb/KzhZ+07HpVhCNJ6tZXR5cVhtYP4S5jpPNDdbBTwrarmcBa3n0glzIPtQvOIoXg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WZfdqshR; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749201282;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=oCj6+Sxcxs0auBfeuChSwk33Y3pn/sByOGMCDkMC3UA=;
	b=WZfdqshRGHK7gSQD6f8aCUjKxIJ+PP+NfPOpa4hzTk/OTlmOeSTHnmda6pDsM+Rnwh1kJe
	5op4kK3qnwlYYycwjj3x97HdeCecejrvUZU2onoD/leRTlWj5bjpU8V5B7YSNUh9Uad6Db
	cXFeCj6W0qzvHSHdDMYCHLFqwY7vh+s=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-8-FkT9A9IFOEemd18Cwlm7-A-1; Fri, 06 Jun 2025 05:14:41 -0400
X-MC-Unique: FkT9A9IFOEemd18Cwlm7-A-1
X-Mimecast-MFC-AGG-ID: FkT9A9IFOEemd18Cwlm7-A_1749201280
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-451deff247cso13961645e9.1
        for <kvm@vger.kernel.org>; Fri, 06 Jun 2025 02:14:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749201280; x=1749806080;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=oCj6+Sxcxs0auBfeuChSwk33Y3pn/sByOGMCDkMC3UA=;
        b=KlbP9f7iNV+RBqDCJP6IRHwHRersRMXSYHKn/zxgoDgqqrtIPzqcj3qkGAgFfg+gNS
         CNzPrID4t1bZvCJPx4dxQDyW0WT14nmiw3+nlJ7YXG3bcpwQM8/QPx9d7swIa2OhhhTP
         FKb8yguf3Fpqlvw0hb7eJWOdFuU31rNlJewF+AwMiSBVRAxP6FrjaxjT79u94XOYwzIH
         ZO8o/iBSI4QAam/JDreV2KUebgjhtAAZDiF81EZfGWiyrxrIXxUXhiMSed/fLQoahrQq
         vo+CvV0ozQz8e+ZtvkYjaHKIum8e0KadfmCxYszMAcoAxRjkzomPDbbX/AoLq9mCWRKH
         C1/g==
X-Forwarded-Encrypted: i=1; AJvYcCXR8neu/2RUzJ95dYi48G9yN3kOBKt3w31h0bzH9w1UYxPzSYuG3bqlof++Pc1F+U8gcYg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy0hsHvE51MC8hxe29b1isIg5efYaqQe1Qpu3wWozaf9RQFPjyP
	zbP6/MCbo/h78AsWDxXqtM1xsF8/kyblIUuT3mOcZhV17dJNfU6ks+JmmhF5kQasVA+HVk+WJ0f
	8Le/c1TbtIK8Cyyw4Bs/Z8uY17fcN9nt3lQe3oFu5DGnvIrAwPMPa6A==
X-Gm-Gg: ASbGncvw5lob/5Nrp3NVn9zjOPj0zi5Ftjhdzt2bjRecm4x/Ul1cV4bCVUqNlw3KOob
	O/K4cLJ3FTV8j6+waAkUN+//i35c501X6sk0yF/7fDJIxSmH10i5WrO8Q8bUxwFQavhbJNgDWJR
	7kwc04ahRITbWqnHQKn15/BT26gNPzhLn7/tHX9XWkQlSigcCa3JkO/TDEHYmvwSJTws+WgsgLW
	tl4OM5VJQkH7bE2GiEwFxROLxR7gF8Bo+FSf7q34/c4SSDKvTfqp5YC5RDHC6DdbcYKwAXWnaD4
	BIDkHCVh+kjaG4cIEHpPsbhcLRTVBsRODDE82J3PEaPpnCueKXVdSUokcX5KtzpoMTw/0bN/0IF
	yWRyoUBHCf5Iqi/al+rbEgFlH7VHDpIY=
X-Received: by 2002:a05:600c:3510:b0:43c:f509:2bbf with SMTP id 5b1f17b1804b1-451f88d836amr75147895e9.15.1749201280339;
        Fri, 06 Jun 2025 02:14:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFkpLXinHXWxiSI+4PvEC2BPCocHHNYP7TvdS/sSVKr19ttFoE6Pj4byntHDslgrPmFOZSX+A==
X-Received: by 2002:a05:600c:3510:b0:43c:f509:2bbf with SMTP id 5b1f17b1804b1-451f88d836amr75147145e9.15.1749201279824;
        Fri, 06 Jun 2025 02:14:39 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f19:9c00:568:7df7:e1:293d? (p200300d82f199c0005687df700e1293d.dip0.t-ipconnect.de. [2003:d8:2f19:9c00:568:7df7:e1:293d])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45209ce1afasm17541465e9.10.2025.06.06.02.14.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Jun 2025 02:14:39 -0700 (PDT)
Message-ID: <aa9701b7-a550-46bf-bb2f-b73462671c7d@redhat.com>
Date: Fri, 6 Jun 2025 11:14:36 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 11/18] KVM: x86: Consult guest_memfd when computing
 max_mapping_level
To: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
 anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk,
 brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
 xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com,
 jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com,
 isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz,
 vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name,
 michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com,
 isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com,
 suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com,
 quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com,
 quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com,
 quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com,
 james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev,
 maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com,
 roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com,
 rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com,
 jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com,
 ira.weiny@intel.com
References: <20250605153800.557144-1-tabba@google.com>
 <20250605153800.557144-12-tabba@google.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20250605153800.557144-12-tabba@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 05.06.25 17:37, Fuad Tabba wrote:
> From: Ackerley Tng <ackerleytng@google.com>
> 
> This patch adds kvm_gmem_max_mapping_level(), which always returns
> PG_LEVEL_4K since guest_memfd only supports 4K pages for now.
> 
> When guest_memfd supports shared memory, max_mapping_level (especially
> when recovering huge pages - see call to __kvm_mmu_max_mapping_level()
> from recover_huge_pages_range()) should take input from
> guest_memfd.
> 
> Input from guest_memfd should be taken in these cases:
> 
> + if the memslot supports shared memory (guest_memfd is used for
>    shared memory, or in future both shared and private memory) or
> + if the memslot is only used for private memory and that gfn is
>    private.
> 
> If the memslot doesn't use guest_memfd, figure out the
> max_mapping_level using the host page tables like before.
> 
> This patch also refactors and inlines the other call to
> __kvm_mmu_max_mapping_level().
> 
> In kvm_mmu_hugepage_adjust(), guest_memfd's input is already
> provided (if applicable) in fault->max_level. Hence, there is no need
> to query guest_memfd.
> 
> lpage_info is queried like before, and then if the fault is not from
> guest_memfd, adjust fault->req_level based on input from host page
> tables.
> 
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> Co-developed-by: Fuad Tabba <tabba@google.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---

[...]

>   static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
>   {
>   	return false;
> @@ -2561,6 +2565,7 @@ static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
>   int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
>   		     gfn_t gfn, kvm_pfn_t *pfn, struct page **page,
>   		     int *max_order);
> +int kvm_gmem_mapping_order(const struct kvm_memory_slot *slot, gfn_t gfn);
>   #else
>   static inline int kvm_gmem_get_pfn(struct kvm *kvm,
>   				   struct kvm_memory_slot *slot, gfn_t gfn,
> @@ -2570,6 +2575,12 @@ static inline int kvm_gmem_get_pfn(struct kvm *kvm,
>   	KVM_BUG_ON(1, kvm);
>   	return -EIO;
>   }
> +static inline int kvm_gmem_mapping_order(const struct kvm_memory_slot *slot,
> +					 gfn_t gfn)
> +{
> +	BUG();
> +	return 0;

As raised, no BUG(). If this is unreachable for these configs,

BUILD_BUG() might do.

Apart from that

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb


