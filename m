Return-Path: <kvm+bounces-29117-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B973B9A3016
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2024 23:54:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 779B1284B52
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2024 21:53:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15D661D63F1;
	Thu, 17 Oct 2024 21:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xrdIsY/D"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA9861D1305
	for <kvm@vger.kernel.org>; Thu, 17 Oct 2024 21:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729202032; cv=none; b=EQh0aEWg6AuLJP8K5Ntki22dN9T+JwdGmNvZk0c1Y2Ia+qExfWTEwi+jxT9w9bZlgXUpBJadDYyC3dsRPBBeffDM1Va7Rv85NzUNH1OQR4QqXPwcXI9F/xLmj5H5HX5sF4kl6xnUERhSCaH5XC8wbNWW6xU4MduIn4/RhilYHBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729202032; c=relaxed/simple;
	bh=Yr141VTOSlzr9Qf++OVWPOb6T5aSNE/JU+fVDOC/p4U=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=tbl1zJAjQD3pr5yOTyLcskyuKtJe9anaWJguVTh2F3p7WTbHTYFsYYWamB4/3VBrBtiHOF5+JRy8FcWzmHjtwP7OwbU+Hq0KH6achEiL6pjEYpDpzV2N05zIf3oU3cEHoQ1CSh+pXmeXVCn/a9H9kEiRiyekgOEDz9mG9iF4gBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xrdIsY/D; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-7ea8baba60dso1459877a12.3
        for <kvm@vger.kernel.org>; Thu, 17 Oct 2024 14:53:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1729202030; x=1729806830; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=JH9th1Lqa6pfzHzGWf6LLQmXCVTNne5Va6Ua71kvm+k=;
        b=xrdIsY/DDTKWvANLjAaSWjYjQMNCh/d2QxC2puhvCbzvBkHs2wupVP6CKzW2Kgv113
         EIpR/Bcccu0sUBrmp+8fl4onaij8w7VX9uWc0VPGR948edAZgXLB/rSVn1IRvs7QBNqM
         +5Tb2T4bSrY2GMOszFFIc8DfXOjYl4LLDSyBvwxyDOj1Qu/Qcu2ACd1ke66Z7kEUmdVs
         SwbJd2/RWlwA6jd1XcLRSQpI/PBkYxlBR2+hPypv9cMMirr8MsT9qLFtcgY/lhPYmrBO
         psHQCprZplEZRkGrurxNjNXdEVHQ769Q3J/GyIPFxhir5by8sT/jF6E8GIyfY/Pbpon4
         0F9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729202030; x=1729806830;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JH9th1Lqa6pfzHzGWf6LLQmXCVTNne5Va6Ua71kvm+k=;
        b=qukMX9CvkBDR6dmhU8YKokoKIBstBFr5yIA7aVqLfVLyOMN3OSCpqoS7D7a4N8zkaH
         X5rzarpA8L0aHzYYrpllGreGVmjrTSWvzrKk+ENxIyN2XOkvhm4WxS4f1OYHjxwuhm8l
         HeaZzjvqaV1gY1NM63IQxmX2qx/Qo7R196DtoSopaBFdl+wI25qFCG1kB4P4ECeKxDYF
         X1Buxshw9qX+iHWukOdo3f81jb0/H0xWFAmNHlHdIalvJeYIsNE9asqKc6RUBT0dCiLY
         6tBhLlqYOdsNYr4kg2LmFxQVhzyd6xbgr+9n17GYbTOVuLtpFgwZbOiOBHM+tUaUFZAq
         Gy5g==
X-Gm-Message-State: AOJu0YzZTPTcfbL8B3otrKcwUKfkovG3aJ3mNC1O1zutjJhjuc9YEt8g
	QdEsOhYVTIoTgi17S6YlvF7QBSViyMSqkwRJlNY4Akj9So1bb1b98tSJ63ydZta47fq+hUbSKp8
	g7aNbTCUgUrm11GNdC7E1eA==
X-Google-Smtp-Source: AGHT+IEtfvKkZLa8O/1tfb6cckR8JiTF44qMCQGS2HKZ5P3Id/ZV1DoHDT6P9VCmzFNbhYTrSRz253FF15kikQpVTA==
X-Received: from ackerleytng-ctop-specialist.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:1612]) (user=ackerleytng job=sendgmr) by
 2002:a63:e505:0:b0:7a1:6633:6a07 with SMTP id 41be03b00d2f7-7eacc6db742mr82a12.2.1729202029676;
 Thu, 17 Oct 2024 14:53:49 -0700 (PDT)
Date: Thu, 17 Oct 2024 21:53:46 +0000
In-Reply-To: <20241010085930.1546800-6-tabba@google.com> (message from Fuad
 Tabba on Thu, 10 Oct 2024 09:59:24 +0100)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-ID: <diqzttdaxuol.fsf@ackerleytng-ctop-specialist.c.googlers.com>
Subject: Re: [PATCH v3 05/11] KVM: guest_memfd: Add guest_memfd support to kvm_(read|/write)_guest_page()
From: Ackerley Tng <ackerleytng@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Fuad Tabba <tabba@google.com> writes:

> Make kvm_(read|/write)_guest_page() capable of accessing guest
> memory for slots that don't have a userspace address, but only if
> the memory is mappable, which also indicates that it is
> accessible by the host.

Fuad explained to me that this patch removes the need for userspace to
mmap a guest_memfd fd just to provide userspace_addr when only a limited
range of shared pages are required, e.g. for kvm_clock.

Questions to anyone who might be more familiar:

1. Should we let userspace save the trouble of providing userspace_addr
   if only KVM (and not userspace) needs to access the shared pages?
2. Other than kvm_{read,write}_guest_page, are there any other parts of
   KVM that may require updates so that guest_memfd can be used directly
   from the kernel?

Patrick, does this help to answer the question of "how does KVM
internally access guest_memfd for non-CoCo VMs" that you brought up in
this other thread [*]?

[*] https://lore.kernel.org/all/6bca3ad4-3eca-4a75-a775-5f8b0467d7a3@amazon.co.uk/

>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  virt/kvm/kvm_main.c | 137 ++++++++++++++++++++++++++++++++++++++------
>  1 file changed, 118 insertions(+), 19 deletions(-)
>
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index aed9cf2f1685..77e6412034b9 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3399,23 +3399,114 @@ int kvm_gmem_clear_mappable(struct kvm *kvm, gfn_t start, gfn_t end)
>  	return kvm_gmem_toggle_mappable(kvm, start, end, false);
>  }
>  
> +static int __kvm_read_guest_memfd_page(struct kvm *kvm,
> +				       struct kvm_memory_slot *slot,
> +				       gfn_t gfn, void *data, int offset,
> +				       int len)
> +{
> +	struct page *page;
> +	u64 pfn;
> +	int r;
> +
> +	/*
> +	 * Holds the folio lock until after checking whether it can be faulted
> +	 * in, to avoid races with paths that change a folio's mappability.
> +	 */
> +	r = kvm_gmem_get_pfn_locked(kvm, slot, gfn, &pfn, NULL);
> +	if (r)
> +		return r;
> +
> +	page = pfn_to_page(pfn);
> +
> +	if (!kvm_gmem_is_mappable(kvm, gfn, gfn + 1)) {
> +		r = -EPERM;
> +		goto unlock;
> +	}
> +	memcpy(data, page_address(page) + offset, len);
> +unlock:
> +	if (r)
> +		put_page(page);
> +	else
> +		kvm_release_pfn_clean(pfn);
> +	unlock_page(page);
> +
> +	return r;
> +}
> +
> +static int __kvm_write_guest_memfd_page(struct kvm *kvm,
> +					struct kvm_memory_slot *slot,
> +					gfn_t gfn, const void *data,
> +					int offset, int len)
> +{
> +	struct page *page;
> +	u64 pfn;
> +	int r;
> +
> +	/*
> +	 * Holds the folio lock until after checking whether it can be faulted
> +	 * in, to avoid races with paths that change a folio's mappability.
> +	 */
> +	r = kvm_gmem_get_pfn_locked(kvm, slot, gfn, &pfn, NULL);
> +	if (r)
> +		return r;
> +
> +	page = pfn_to_page(pfn);
> +
> +	if (!kvm_gmem_is_mappable(kvm, gfn, gfn + 1)) {
> +		r = -EPERM;
> +		goto unlock;
> +	}
> +	memcpy(page_address(page) + offset, data, len);
> +unlock:
> +	if (r)
> +		put_page(page);
> +	else
> +		kvm_release_pfn_dirty(pfn);
> +	unlock_page(page);
> +
> +	return r;
> +}
> +#else
> +static int __kvm_read_guest_memfd_page(struct kvm *kvm,
> +				       struct kvm_memory_slot *slot,
> +				       gfn_t gfn, void *data, int offset,
> +				       int len)
> +{
> +	WARN_ON_ONCE(1);
> +	return -EIO;
> +}
> +
> +static int __kvm_write_guest_memfd_page(struct kvm *kvm,
> +					struct kvm_memory_slot *slot,
> +					gfn_t gfn, const void *data,
> +					int offset, int len)
> +{
> +	WARN_ON_ONCE(1);
> +	return -EIO;
> +}
>  #endif /* CONFIG_KVM_GMEM_MAPPABLE */
>  
>  /* Copy @len bytes from guest memory at '(@gfn * PAGE_SIZE) + @offset' to @data */
> -static int __kvm_read_guest_page(struct kvm_memory_slot *slot, gfn_t gfn,
> -				 void *data, int offset, int len)
> +
> +static int __kvm_read_guest_page(struct kvm *kvm, struct kvm_memory_slot *slot,
> +				 gfn_t gfn, void *data, int offset, int len)
>  {
> -	int r;
>  	unsigned long addr;
>  
>  	if (WARN_ON_ONCE(offset + len > PAGE_SIZE))
>  		return -EFAULT;
>  
> +	if (IS_ENABLED(CONFIG_KVM_GMEM_MAPPABLE) &&
> +	    kvm_slot_can_be_private(slot) &&
> +	    !slot->userspace_addr) {
> +		return __kvm_read_guest_memfd_page(kvm, slot, gfn, data,
> +						   offset, len);
> +	}
> +
>  	addr = gfn_to_hva_memslot_prot(slot, gfn, NULL);
>  	if (kvm_is_error_hva(addr))
>  		return -EFAULT;
> -	r = __copy_from_user(data, (void __user *)addr + offset, len);
> -	if (r)
> +	if (__copy_from_user(data, (void __user *)addr + offset, len))
>  		return -EFAULT;
>  	return 0;
>  }
> @@ -3425,7 +3516,7 @@ int kvm_read_guest_page(struct kvm *kvm, gfn_t gfn, void *data, int offset,
>  {
>  	struct kvm_memory_slot *slot = gfn_to_memslot(kvm, gfn);
>  
> -	return __kvm_read_guest_page(slot, gfn, data, offset, len);
> +	return __kvm_read_guest_page(kvm, slot, gfn, data, offset, len);
>  }
>  EXPORT_SYMBOL_GPL(kvm_read_guest_page);
>  
> @@ -3434,7 +3525,7 @@ int kvm_vcpu_read_guest_page(struct kvm_vcpu *vcpu, gfn_t gfn, void *data,
>  {
>  	struct kvm_memory_slot *slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
>  
> -	return __kvm_read_guest_page(slot, gfn, data, offset, len);
> +	return __kvm_read_guest_page(vcpu->kvm, slot, gfn, data, offset, len);
>  }
>  EXPORT_SYMBOL_GPL(kvm_vcpu_read_guest_page);
>  
> @@ -3511,22 +3602,30 @@ EXPORT_SYMBOL_GPL(kvm_vcpu_read_guest_atomic);
>  
>  /* Copy @len bytes from @data into guest memory at '(@gfn * PAGE_SIZE) + @offset' */
>  static int __kvm_write_guest_page(struct kvm *kvm,
> -				  struct kvm_memory_slot *memslot, gfn_t gfn,
> -			          const void *data, int offset, int len)
> +				  struct kvm_memory_slot *slot, gfn_t gfn,
> +				  const void *data, int offset, int len)
>  {
> -	int r;
> -	unsigned long addr;
> -
>  	if (WARN_ON_ONCE(offset + len > PAGE_SIZE))
>  		return -EFAULT;
>  
> -	addr = gfn_to_hva_memslot(memslot, gfn);
> -	if (kvm_is_error_hva(addr))
> -		return -EFAULT;
> -	r = __copy_to_user((void __user *)addr + offset, data, len);
> -	if (r)
> -		return -EFAULT;
> -	mark_page_dirty_in_slot(kvm, memslot, gfn);
> +	if (IS_ENABLED(CONFIG_KVM_GMEM_MAPPABLE) &&
> +	    kvm_slot_can_be_private(slot) &&
> +	    !slot->userspace_addr) {
> +		int r = __kvm_write_guest_memfd_page(kvm, slot, gfn, data,
> +						     offset, len);
> +
> +		if (r)
> +			return r;
> +	} else {
> +		unsigned long addr = gfn_to_hva_memslot(slot, gfn);
> +
> +		if (kvm_is_error_hva(addr))
> +			return -EFAULT;
> +		if (__copy_to_user((void __user *)addr + offset, data, len))
> +			return -EFAULT;
> +	}
> +
> +	mark_page_dirty_in_slot(kvm, slot, gfn);
>  	return 0;
>  }

