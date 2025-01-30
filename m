Return-Path: <kvm+bounces-36940-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 33BC6A232B6
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2025 18:20:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2FCCC3A285F
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2025 17:20:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A7B11EE7DF;
	Thu, 30 Jan 2025 17:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DhWzmD1E"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB4941E9B39
	for <kvm@vger.kernel.org>; Thu, 30 Jan 2025 17:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738257637; cv=none; b=b6FYM3056jHc4gypgMwCuWjYz0JP8fOnuIJSaG8dLxz5kM/EL75ug769TPjQSXYKCWlffPBn27Iw+nJ/AmiknwHcZT1TdmWqmQvmirc0CJeId/gSroav+up5B068Xc7aBfTdpMvNCqzGr5ZdRxdFwvINzN9LfM7wCa3djKeCfk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738257637; c=relaxed/simple;
	bh=STC+FcdC3aLwf+SmHCddCu856GoIU3wZ1PBxMxnUYNk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PZFgTmnbtwcWf3E4rvClSlOhNGZHL9rvc8z5uGWs8+yvZLMVJ5djUziS37h+TTMfZ+8gjguRfCS0aHcjFCzD8nYt/Gybh7ZuBkjfpgKZ+9KdkWS8roPR65hBW51wSyVctk+KWF0xuOTMp1jR8H10GSqj1t3ASEtNiBccixNTadk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DhWzmD1E; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738257634;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=j+0hU6aGaVNMgdWgWLg+jYofzZgMCy/WzGJFeEw3w34=;
	b=DhWzmD1Eni5ATLzY+fr6E0c+B0Eu98l+SXUyOohrqgRWS2mR3nt1SHzhcrK1YMnps33uva
	bck7U5fD0V3xy8eIgIjA7PoacJUdy0nAal3EE3ERmNOp53MT9FS4xXMk5QdYtzU47lToYV
	nqr0iR2cJscURgjAw4THARiBfTvor+g=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-68-WElZFg9GNr6cuGWB6Cilug-1; Thu, 30 Jan 2025 12:20:32 -0500
X-MC-Unique: WElZFg9GNr6cuGWB6Cilug-1
X-Mimecast-MFC-AGG-ID: WElZFg9GNr6cuGWB6Cilug
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-38c5dcb33a5so477805f8f.2
        for <kvm@vger.kernel.org>; Thu, 30 Jan 2025 09:20:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738257631; x=1738862431;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=j+0hU6aGaVNMgdWgWLg+jYofzZgMCy/WzGJFeEw3w34=;
        b=n+Nye21ldwOcldLw+9TjaP+D+V2419l91EId+saY0kusnxkoboFeMcAaVa2wbbTqHy
         Lr9Twno1lI3Vwm1J1hzKmZPrMV/yia5c84qdZzPTK5OfovkmHQ2JDuj7/ahX4rxdLWc7
         r8633m6WGs0xJlCrm1Dk3Vx7hEQvVPoGeFUwrmPxExx6BXfPZJe7iwKDZ3mtizg/8aSs
         /mydpW9QAtqQU42Z7XrQFuwMzL+aQniOwlUH02hPyQvclv/u55G+xzKUC/RbRo2hv2yQ
         31/kc+Z0IgqwLWko2S9bgXrXP4sabyJrPvVPeZbg8FoeWz6Y11X7lDXMLjN4clOXO+9x
         mGeQ==
X-Forwarded-Encrypted: i=1; AJvYcCVOR3+xENTHkZGampVj0aWQxqer/xT6bb1p2fU08WHmHYnt2dA5szWKmjQn8l6GOJ/xPhM=@vger.kernel.org
X-Gm-Message-State: AOJu0YyG46CRdewtLSrTuVyZJJfVi0CNCobn+91Btt0KSKF+nrk2PUxP
	TF5wGBBdPg33pIs2aTxqOXEZIUzId7FzsAwSqgjMuAGPfxlpMkl0Um3SkLXfAQvOO4QMgFiKlMK
	L45+08OPDTHMhhaQJAbHAvPdnzEwyVXfwwTsvlXZwcPjRs6dlcQ==
X-Gm-Gg: ASbGncuTdDVtx68IRKAV+gpRYjTDqFp7yy3cN64c/EJjTM+cBEqyw49v+JcuTvrcApP
	3DnxHLU1wv4B5cCAXY4NX8NilpocZOvOj3b22x7kCj+1/m2ca3Oww+TO0efIvruVXgR14RsUgxt
	ZR9pibCe42oNfS5cijQsJi+1sNC9WYBS/KjqOq0r9VGKJ5ae2DY793AxV7lLSnTwgK41Hv9dQwS
	OhzY+4kMr8xVZNwCtN+w4iuI0+QdH7lh2ANj63WJ8uKoijXJ5CQ4OSCvBOyCJiJ4ZwQ5o6J6lLT
	a+F6Cnb5Snl5lTH0AkebyHEsURHl3Oj57GHZA/x4FfMaabxYKdjsD24ruLf9tnC5YDQFpAs5FiX
	eaytB+i/oJY6ziZXabsONZ9eouQJx76Db
X-Received: by 2002:a05:6000:1f8b:b0:386:407c:40b9 with SMTP id ffacd0b85a97d-38c5195dd35mr7383644f8f.28.1738257630657;
        Thu, 30 Jan 2025 09:20:30 -0800 (PST)
X-Google-Smtp-Source: AGHT+IElz9J51dJ6GnRKwHHqY+OIuTxTqpGAXizcfIsTIe8uGU5ma3oADpw0TiHvPwNwIWUgGYkswA==
X-Received: by 2002:a05:6000:1f8b:b0:386:407c:40b9 with SMTP id ffacd0b85a97d-38c5195dd35mr7383601f8f.28.1738257630190;
        Thu, 30 Jan 2025 09:20:30 -0800 (PST)
Received: from ?IPV6:2003:cb:c713:3b00:16ce:8f1c:dd50:90fb? (p200300cbc7133b0016ce8f1cdd5090fb.dip0.t-ipconnect.de. [2003:cb:c713:3b00:16ce:8f1c:dd50:90fb])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-438e244eb0dsm30102555e9.27.2025.01.30.09.20.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jan 2025 09:20:28 -0800 (PST)
Message-ID: <07e7e09a-997e-444e-92bf-8f2359a36cbd@redhat.com>
Date: Thu, 30 Jan 2025 18:20:26 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 03/11] KVM: guest_memfd: Allow host to map
 guest_memfd() pages
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
References: <20250129172320.950523-1-tabba@google.com>
 <20250129172320.950523-4-tabba@google.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20250129172320.950523-4-tabba@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 29.01.25 18:23, Fuad Tabba wrote:
> Add support for mmap() and fault() for guest_memfd backed memory
> in the host for VMs that support in-place conversion between
> shared and private (shared memory). To that end, this patch adds
> the ability to check whether the VM type has that support, and
> only allows mapping its memory if that's the case.
> 
> Additionally, this behavior is gated with a new configuration
> option, CONFIG_KVM_GMEM_SHARED_MEM.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> 
> ---
> 
> This patch series will allow shared memory support for software
> VMs in x86. It will also introduce a similar VM type for arm64
> and allow shared memory support for that. In the future, pKVM
> will also support shared memory.
> ---
>   include/linux/kvm_host.h | 11 ++++++
>   virt/kvm/Kconfig         |  4 +++
>   virt/kvm/guest_memfd.c   | 77 ++++++++++++++++++++++++++++++++++++++++
>   3 files changed, 92 insertions(+)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 401439bb21e3..408429f13bf4 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -717,6 +717,17 @@ static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
>   }
>   #endif
>   
> +/*
> + * Arch code must define kvm_arch_gmem_supports_shared_mem if support for
> + * private memory is enabled and it supports in-place shared/private conversion.
> + */
> +#if !defined(kvm_arch_gmem_supports_shared_mem) && !IS_ENABLED(CONFIG_KVM_PRIVATE_MEM)
> +static inline bool kvm_arch_gmem_supports_shared_mem(struct kvm *kvm)
> +{
> +	return false;
> +}
> +#endif
> +
>   #ifndef kvm_arch_has_readonly_mem
>   static inline bool kvm_arch_has_readonly_mem(struct kvm *kvm)
>   {
> diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
> index 54e959e7d68f..4e759e8020c5 100644
> --- a/virt/kvm/Kconfig
> +++ b/virt/kvm/Kconfig
> @@ -124,3 +124,7 @@ config HAVE_KVM_ARCH_GMEM_PREPARE
>   config HAVE_KVM_ARCH_GMEM_INVALIDATE
>          bool
>          depends on KVM_PRIVATE_MEM
> +
> +config KVM_GMEM_SHARED_MEM
> +       select KVM_PRIVATE_MEM
> +       bool
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 47a9f68f7b24..86441581c9ae 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -307,7 +307,84 @@ static pgoff_t kvm_gmem_get_index(struct kvm_memory_slot *slot, gfn_t gfn)
>   	return gfn - slot->base_gfn + slot->gmem.pgoff;
>   }
>   
> +#ifdef CONFIG_KVM_GMEM_SHARED_MEM
> +static vm_fault_t kvm_gmem_fault(struct vm_fault *vmf)
> +{
> +	struct inode *inode = file_inode(vmf->vma->vm_file);
> +	struct folio *folio;
> +	vm_fault_t ret = VM_FAULT_LOCKED;
> +
> +	filemap_invalidate_lock_shared(inode->i_mapping);
> +
> +	folio = kvm_gmem_get_folio(inode, vmf->pgoff);
> +	if (IS_ERR(folio)) {
> +		ret = VM_FAULT_SIGBUS;
> +		goto out_filemap;
> +	}
> +
> +	if (folio_test_hwpoison(folio)) {
> +		ret = VM_FAULT_HWPOISON;
> +		goto out_folio;
> +	}
> +

Worth adding a comment, something like

/*
  * Only private folios are marked as "guestmem" so far, and we never
  * expect private folios at this point.
  */
> +	if (WARN_ON_ONCE(folio_test_guestmem(folio)))  {
> +		ret = VM_FAULT_SIGBUS;
> +		goto out_folio;
> +	}
> +
> +	/* No support for huge pages. */
> +	if (WARN_ON_ONCE(folio_nr_pages(folio) > 1)) {
> +		ret = VM_FAULT_SIGBUS;
> +		goto out_folio;
> +	}
> +

/* We only support mmap of small folios. */
VM_WARN_ON_ONCE(folio_test_large(folio));

> +	if (!folio_test_uptodate(folio)) {
> +		clear_highpage(folio_page(folio, 0));
> +		folio_mark_uptodate(folio);
> +	}
> +
> +	vmf->page = folio_file_page(folio, vmf->pgoff);
> +

Apart from that LGTM.

-- 
Cheers,

David / dhildenb


