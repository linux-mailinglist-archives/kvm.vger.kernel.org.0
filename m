Return-Path: <kvm+bounces-45902-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CE58AAFDA0
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 16:47:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E6FBF4C699C
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 14:47:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66619279785;
	Thu,  8 May 2025 14:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ftc0d1+C"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE842278173
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 14:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746715623; cv=none; b=oDPtcSnCvcRrMaUavmTArP29YxpMc9I9djUYgWAu/k0FpP2vN1EldFRbgZH6E38+jWF9YZX6rq1rbjQMNrJ9cyaoWoj1EOUBS2ttVcvYyzJvFpNAox7IwWQq0yq0OWnZwzJXyThDrLfxDH+3SerVaYtyYFwnpAWagT+YcJG7YL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746715623; c=relaxed/simple;
	bh=M2kEowmn7ArZMjCEWfGm0wGjyjYahsrAwRWui+KQh/0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IUDeSPDdiGr72LqPrLAK+y20h3VggXV22zv7cdFmLLw3c71hSso+M5OigLYKmSQo/zWDXYEFRYM0mIqRd1mmfpToI6UEdzI2XqNjacm/uioQFKgG7IMZGhK3h0j0+yi7/XiW3xLXd7V+DWs+wg6OL0VEVx452/VfEztD126Jkfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ftc0d1+C; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746715620;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=3WfBLYQC3hmzGXkm7havEwwHluNTlzt6k0jnmYRuEz8=;
	b=Ftc0d1+C+SSdf0EsfK3QRjo/r5YVZYlQWk/QZZlLgIK55rrH1/9k4aGxZlrSt38JnBJn3x
	xEawOSJheRbCCz2lrRFimvDCiRW/G+lS0EmpQv67vzZ8rFCiee6Jrv8CEM6fKdrhEzNbuO
	cdCSm043jT3MPAU1/2Qx+Pj5BzSJWBw=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-614-5lE_UpN_PFuxTqfdTpj6LQ-1; Thu, 08 May 2025 10:46:59 -0400
X-MC-Unique: 5lE_UpN_PFuxTqfdTpj6LQ-1
X-Mimecast-MFC-AGG-ID: 5lE_UpN_PFuxTqfdTpj6LQ_1746715618
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-442d472cf84so2285215e9.2
        for <kvm@vger.kernel.org>; Thu, 08 May 2025 07:46:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746715618; x=1747320418;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=3WfBLYQC3hmzGXkm7havEwwHluNTlzt6k0jnmYRuEz8=;
        b=gqmzqbE2f2OLMS0HMPCv6ixa8MW+qM5gg8b7LBc0KYGKKhRMr+3Rp5WBuhlqehiP41
         vGGUJ2h64kKJnbIWHYHfio7n2/PuNyUIvk2FMLHTAbBnpbGhW7oncFPQASOMLFnrfhOU
         7tSMYbrsO/c6Hf+2xfVy1UlJrnkjLRz37Q0DcdVbC5m2RRZ1tQeTbZ0gM6/6h1QCYrzJ
         64B9Z4dQllrt6QDS2yUS3Pqd0pN1BLBFZF5q9FY2vyH+WkUxr6rO6FpizeXObeP/L9kc
         DH4VKbJohNDIpYUKmtQ1gTG+7JufkW76pB7rhkkpWp6tV7dqhoaeADqrgYUpfUvYcGqz
         R/mg==
X-Forwarded-Encrypted: i=1; AJvYcCVEIlMJ0MtU/nU6iw0vqOcDGzxPmJacbQ67Kwk1WSt+LQW17yaZFjF08CQZjUh2+Pk03/E=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz0bUZC9anVkfxTmMp9FwjWZtn0fMiBy3nI3MJ7jIoukvR4tTSu
	eAnZ60ejRClhnMJDF67oRroW2s/jlnER+xWL2CZKbioP9HgwRFAt6emBgFznCfH6lsjIV3Qq1sx
	J6dO9RNlWoeI2K299pIxvlQxs6Ue71zq+KV0Exa/JoC876xZ3WA==
X-Gm-Gg: ASbGncuX0/M5iai7IOUtOawuPpNg4agIr1OHoAusXBVRsbIOAnElG02Y2iv0I2z0UdJ
	VWKLOmULNqD+vDqfw2RKSLRmBxo/igZfxasKtfX8WkVbjx+UXGRPccOyLyviVzbQIEUmjTrUikB
	aoYH9xEre5vjsvOq2lWK/gD+HIqJm15mAezkgwLC6WSEU46OK5GBmWj7fEdyVaTnQKw1MaQkJFu
	a7XuJrg1QplJc4U9PZ6R5hPqs2I6e/hsKcfkKHUIqxd74ytWaWfMubKY0Pi7oqnUVg50jqGrbfL
	MEOpa5U1uRCYXLuQy2T+DF8aOiaHEWNG5ooo3ULWgISx/KazKhBqEA42ji4Y3AcmduO9WrtuOvi
	5eZ2yx6sfpz4mkidQEOo+tmaIpXj4mwWv4SsV6Bw=
X-Received: by 2002:a05:600c:198d:b0:43d:160:cd97 with SMTP id 5b1f17b1804b1-442d034ad66mr27923515e9.25.1746715618269;
        Thu, 08 May 2025 07:46:58 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEMazOFBQxOkJsC7u+4627X9ECffOM+ndlKzepZRCW/CDop3JsCzx/Dr+2gqQj4Jw/B8gOF7A==
X-Received: by 2002:a05:600c:198d:b0:43d:160:cd97 with SMTP id 5b1f17b1804b1-442d034ad66mr27923245e9.25.1746715617803;
        Thu, 08 May 2025 07:46:57 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f3e:5900:27aa:5f4a:b65c:3d3c? (p200300d82f3e590027aa5f4ab65c3d3c.dip0.t-ipconnect.de. [2003:d8:2f3e:5900:27aa:5f4a:b65c:3d3c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a1f5a4c804sm157216f8f.95.2025.05.08.07.46.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 May 2025 07:46:57 -0700 (PDT)
Message-ID: <8b197d87-e2a6-4f35-8f25-4d32b6e34202@redhat.com>
Date: Thu, 8 May 2025 16:46:53 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 06/13] KVM: x86: Generalize private fault lookups to
 guest_memfd fault lookups
To: Ackerley Tng <ackerleytng@google.com>,
 Sean Christopherson <seanjc@google.com>,
 Vishal Annapurve <vannapurve@google.com>
Cc: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, pbonzini@redhat.com,
 chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org,
 paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu,
 viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org,
 akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com,
 chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com,
 dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net,
 vbabka@suse.cz, mail@maciej.szmigiero.name, michael.roth@amd.com,
 wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com,
 kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com,
 steven.price@arm.com, quic_eberman@quicinc.com, quic_mnalajal@quicinc.com,
 quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com,
 quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com,
 quic_pheragu@quicinc.com, catalin.marinas@arm.com, james.morse@arm.com,
 yuzenghui@huawei.com, oliver.upton@linux.dev, maz@kernel.org,
 will@kernel.org, qperret@google.com, keirf@google.com, roypat@amazon.co.uk,
 shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, rientjes@google.com,
 jhubbard@nvidia.com, fvdl@google.com, hughd@google.com,
 jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com
References: <diqz7c31xyqs.fsf@ackerleytng-ctop.c.googlers.com>
 <386c1169-8292-43d1-846b-c50cbdc1bc65@redhat.com>
 <aBTxJvew1GvSczKY@google.com>
 <diqzjz6ypt9y.fsf@ackerleytng-ctop.c.googlers.com>
 <7e32aabe-c170-4cfc-99aa-f257d2a69364@redhat.com>
 <aBlCSGB86cp3B3zn@google.com>
 <CAGtprH8DW-hqxbFdyo+Mg7MddsOAnN+rpLZUOHT-msD+OwCv=Q@mail.gmail.com>
 <CAGtprH9AVUiFsSELhmt4p24fssN2x7sXnUqn39r31GbA0h39Sw@mail.gmail.com>
 <aBoVbJZEcQ2OeXhG@google.com>
 <39ea3946-6683-462e-af5d-fe7d28ab7d00@redhat.com>
 <diqzh61xqxfh.fsf@ackerleytng-ctop.c.googlers.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <diqzh61xqxfh.fsf@ackerleytng-ctop.c.googlers.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

>>
>> Yeah, I ignored that fact as well. So essentially, this patch should be
>> mostly good for now.
>>
> 
>  From here [1], these changes will make it to v9
> 
> + kvm_max_private_mapping_level renaming to kvm_max_gmem_mapping_level
> + kvm_mmu_faultin_pfn_private renaming to kvm_mmu_faultin_pfn_gmem
> 
>> Only kvm_mmu_hugepage_adjust() must be taught to not rely on
>> fault->is_private.
>>
> 
> I think fault->is_private should contribute to determining the max
> mapping level.
> 
> By the time kvm_mmu_hugepage_adjust() is called,
> 
> * For Coco VMs using guest_memfd only for private memory,
>    * fault->is_private would have been checked to align with
>      kvm->mem_attr_array, so
> * For Coco VMs using guest_memfd for both private/shared memory,
>    * fault->is_private would have been checked to align with
>      guest_memfd's shareability
> * For non-Coco VMs using guest_memfd
>    * fault->is_private would be false

But as Sean said, looking at the code might be easier.

Maybe just send the resulting diff of the patch here real quick?

> 
> Hence fault->is_private can be relied on when calling
> kvm_mmu_hugepage_adjust().
> 
> If fault->is_private, there will be no host userspace mapping to check,
> hence in __kvm_mmu_max_mapping_level(), we should skip querying host
> page tables.
> 
> If !fault->is_private, for shared memory ranges, if the VM uses
> guest_memfd only for shared memory, we should query host page tables.
> 
> If !fault->is_private, for shared memory ranges, if the VM uses
> guest_memfd for both shared/private memory, we should not query host
> page tables.
 > > If !fault->is_private, for non-Coco VMs, we should not query host page
> tables.
 > > I propose to rename the parameter is_private to skip_host_page_tables,
> so
> 
> - if (is_private)
> + if (skip_host_page_tables)
> 	return max_level;
> 
> and pass
> 
> skip_host_page_tables = fault->is_private ||
> 			kvm_gmem_memslot_supports_shared(fault->slot);
> 

How is that better than calling it "is_gmem" / "from_gmem" etc? :) 
Anyhow, no strong opinion, spelling out that something is from gmem 
implies that we don't care about page tables.

> where kvm_gmem_memslot_supports_shared() checks the inode in the memslot
> for GUEST_MEMFD_FLAG_SUPPORT_SHARED.

Makes sense.

-- 
Cheers,

David / dhildenb


