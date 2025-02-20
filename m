Return-Path: <kvm+bounces-38683-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DAD28A3D94E
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 12:59:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2E67A3B6789
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 11:58:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E7601F460E;
	Thu, 20 Feb 2025 11:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JhJ50tEV"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F41151F3BBE
	for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 11:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740052710; cv=none; b=LPJGGMXn4vh9ts63pbb3y/aAH8HBAhDYrjuSkX/tyL4cReZeY6uiQ1Xx4M0/cqQOfyWOIBVOZ71ZPnnrRbplp0OwOTOOtqjvLRNYqy2Q4rmDGAjpVnt7Hzwd23KXmwEjg9+YUaMjpMmmLGAFRHuQo6JSTNt3q+xW8DRgyXDdgyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740052710; c=relaxed/simple;
	bh=yfv3F9pnV0YDIvqXa8dhAoAswhpLtDW9bzzy89rNN1Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DfNybXzJEWe3SBiRXW0uTAwqAh6cFq983puePAPhrI5kCd2Hw/tZ5kzakycyBlSvuhVhonUuTuBoEA8dpoTnCxC4ve5qxHKBruY1Yt8yWuIRcJ988oj34up3KV2g8DYfP8vTQlyO7dRpK1zAGrwOLieWtIa01f695gwh+lrWrf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JhJ50tEV; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740052707;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ChTPBy8eMOaAQYN+xSwJ0JGUBOJ/6/tYrgg1c9NkG+M=;
	b=JhJ50tEVMfmN4nIbjI/S+jKKHxlKZA5mzMSGa2EzSpKGRWdrWspnwsaQ0CMqiAaFpTglVc
	k4eRSCXPBR5O/YsHVenX1Nd63SAHEqPEfgEhAoTFgIyag75ef74pShoADoBd/RPOJVLEbm
	myf2apC5raTCoFM54vEgqmww23GO/Iw=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-464-qXv6yy0yOWuSAXkiNWMMLg-1; Thu, 20 Feb 2025 06:58:26 -0500
X-MC-Unique: qXv6yy0yOWuSAXkiNWMMLg-1
X-Mimecast-MFC-AGG-ID: qXv6yy0yOWuSAXkiNWMMLg_1740052705
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-38f34b3f9f1so616179f8f.0
        for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 03:58:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740052705; x=1740657505;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ChTPBy8eMOaAQYN+xSwJ0JGUBOJ/6/tYrgg1c9NkG+M=;
        b=X5WCNWdEEnxOHnwjbWX0ewTzXXWSw9/4wJHSzSNknmAPK0wMkM0ysxrpA/7nepRB72
         vorR2/xFgd6OHfq8oC2ZGWxC2zn+x7Ph4o3CtanpWO2etWdOJJKBmDVVOJ3qth3z2E+8
         K6IeUOhebNqiYj6QWvXCkO/VmoqNn0642DiQy8ewGpqJvlmdVAgz4OBaQsfLKbqfKOuG
         OKejz4IK78MEYmNldUGvzMCCSnOev7xAxiDDyYoM3RVtgclz2zdfsJLIWc1qG4hO6JrU
         jj5BSzJEqOATO9El9nBiXfgDmcZj5UaWzKaQmTbmrHr92+px8lfWqVj5VQtWz2wNhJ9C
         XI7Q==
X-Forwarded-Encrypted: i=1; AJvYcCVseRQvNoBDfA4cDeGvPNP1iNfNPu9nUuyj5y+gPOMaoIWGbTgCR5oqRk5zVL282u7J/b0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyHlkzJMBVDr99tFf8MdksIwevtHrV+RjOoeXk9fSKSXwTQisgB
	YXcOSMmhxQd9MeHl5sLa/IrG9zTE9vPbOXdZHWxrI2je7lNEvG98V9Id4BkAJ09G3TVAaJujVHA
	9m/WvqPgh8eWlNSn7hAODE8nbd1H08ZZxrcir0GkraTYzYDDLJw==
X-Gm-Gg: ASbGncuqFn9iAonlPEeueM5uLnyKnibX5ofp041UVFkP4cqjDMHSMnrGssAO54cEQzv
	Bag0zkZLT7Qjzwmht8mXwTYmnw+wopTqD31YYD2dIAaX4NEIbTMlzPWjcosK3EVOesyzYS/5/q0
	dHyOA0eeuLbBmrRTGIrbKzUPdhoLrjQmdvIzN1vj8Doc7zOR9OiNluQ634CBd5Yj0GpuPLS9C8Q
	BQwK/sw1v7mvqPM6Zx5KYVvdUri7xfQbBM5gglWTOpTwIomBlWCNajS7QJl02h37FKtOvqO23It
	i1cUKX0OJlEhp2fzdYA62oOEf56U3857aU7ZzvAjAm31zkQfloWoOjNDAAjh04a/C559zyVT3Pn
	RzNZjT/tdM8BMHwuieBsM8/98kVXCPg==
X-Received: by 2002:a5d:6911:0:b0:38c:5cd0:ecd5 with SMTP id ffacd0b85a97d-38f587ca6aemr5426561f8f.38.1740052705181;
        Thu, 20 Feb 2025 03:58:25 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGfrC4AzDMY6jq/M+etgB2APRc/+SNG9GYHcPm4Xm3x4ed/XwE26HMx8TXBImXaH2qQnvfBrA==
X-Received: by 2002:a5d:6911:0:b0:38c:5cd0:ecd5 with SMTP id ffacd0b85a97d-38f587ca6aemr5426515f8f.38.1740052704750;
        Thu, 20 Feb 2025 03:58:24 -0800 (PST)
Received: from ?IPV6:2003:cb:c706:2000:e44c:bc46:d8d3:be5? (p200300cbc7062000e44cbc46d8d30be5.dip0.t-ipconnect.de. [2003:cb:c706:2000:e44c:bc46:d8d3:be5])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43986320899sm109955095e9.38.2025.02.20.03.58.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Feb 2025 03:58:24 -0800 (PST)
Message-ID: <2cdc5414-a280-4c47-86d5-4261a12deab6@redhat.com>
Date: Thu, 20 Feb 2025 12:58:20 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 03/10] KVM: guest_memfd: Allow host to map
 guest_memfd() pages
To: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-mm@kvack.org
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
 jthoughton@google.com
References: <20250218172500.807733-1-tabba@google.com>
 <20250218172500.807733-4-tabba@google.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20250218172500.807733-4-tabba@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 18.02.25 18:24, Fuad Tabba wrote:
> Add support for mmap() and fault() for guest_memfd backed memory
> in the host for VMs that support in-place conversion between
> shared and private. To that end, this patch adds the ability to
> check whether the VM type supports in-place conversion, and only
> allows mapping its memory if that's the case.
> 
> This behavior is also gated by the configuration option
> KVM_GMEM_SHARED_MEM.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>   include/linux/kvm_host.h |  11 +++++
>   virt/kvm/guest_memfd.c   | 103 +++++++++++++++++++++++++++++++++++++++
>   2 files changed, 114 insertions(+)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 3ad0719bfc4f..f9e8b10a4b09 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -728,6 +728,17 @@ static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
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
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index c6f6792bec2a..30b47ff0e6d2 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -317,9 +317,112 @@ void kvm_gmem_handle_folio_put(struct folio *folio)
>   {
>   	WARN_ONCE(1, "A placeholder that shouldn't trigger. Work in progress.");
>   }
> +
> +static bool kvm_gmem_offset_is_shared(struct file *file, pgoff_t index)
> +{
> +	struct kvm_gmem *gmem = file->private_data;
> +
> +	/* For now, VMs that support shared memory share all their memory. */
> +	return kvm_arch_gmem_supports_shared_mem(gmem->kvm);
> +}
> +
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
> +		switch (PTR_ERR(folio)) {
> +		case -EAGAIN:
> +			ret = VM_FAULT_RETRY;
> +			break;
> +		case -ENOMEM:
> +			ret = VM_FAULT_OOM;
> +			break;
> +		default:
> +			ret = VM_FAULT_SIGBUS;
> +			break;
> +		}
> +		goto out_filemap;
> +	}
> +
> +	if (folio_test_hwpoison(folio)) {
> +		ret = VM_FAULT_HWPOISON;
> +		goto out_folio;
> +	}
> +
> +	/* Must be called with folio lock held, i.e., after kvm_gmem_get_folio() */
> +	if (!kvm_gmem_offset_is_shared(vmf->vma->vm_file, vmf->pgoff)) {
> +		ret = VM_FAULT_SIGBUS;
> +		goto out_folio;
> +	}
> +
> +	/*
> +	 * Only private folios are marked as "guestmem" so far, and we never
> +	 * expect private folios at this point.
> +	 */
> +	if (WARN_ON_ONCE(folio_test_guestmem(folio)))  {
> +		ret = VM_FAULT_SIGBUS;
> +		goto out_folio;
> +	}
> +
> +	/* No support for huge pages. */
> +	if (WARN_ON_ONCE(folio_test_large(folio))) {
> +		ret = VM_FAULT_SIGBUS;
> +		goto out_folio;
> +	}
> +
> +	if (!folio_test_uptodate(folio)) {
> +		clear_highpage(folio_page(folio, 0));
> +		kvm_gmem_mark_prepared(folio);
> +	}

kvm_gmem_get_pfn()->__kvm_gmem_get_pfn() seems to call 
kvm_gmem_prepare_folio() instead.

Could we do the same here?

-- 
Cheers,

David / dhildenb


