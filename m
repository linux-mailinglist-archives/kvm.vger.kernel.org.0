Return-Path: <kvm+bounces-53011-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DE84B0C917
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 18:48:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E353D3BB1F9
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 16:47:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CEFB2E11C6;
	Mon, 21 Jul 2025 16:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4TYTjS9d"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AE042E03E0
	for <kvm@vger.kernel.org>; Mon, 21 Jul 2025 16:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753116474; cv=none; b=BAJA8dGOZlO17RIjvHE6EsJGHY0SwTFgVDL5fLaJh+48GOboGbDvksMNujYQSbdef8xSYj+fgqrKrgF9tM6HABj7hEEOq2pbBab7fO2HdSP0FFYFZMA3XT2EKarnv+a/Ln6o0dkBrvyGlJFP2Sx4KaQ1V03Qo2DX5JvBeZBHe0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753116474; c=relaxed/simple;
	bh=rIKIFHHt/El8YO58iVx3TTxbNDNCPVdyUdFiG1xzYuI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bjBK9N2lm8YqVSKTBCpzkiSOo4aMONCW3ilxzbIbgQangKkLR8nSiyAqDZDknYcEZp6RPpl9m7lFg/cQttsJjBQYu8OlTdZiDvWOglAnGfzRaGvqiDZ8Vv+YuVUI0CApx3M08doBzxGp4g5fRKpo2HYQ4RWtw+o9k3bLKdYoyuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4TYTjS9d; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-748d96b974cso4246120b3a.2
        for <kvm@vger.kernel.org>; Mon, 21 Jul 2025 09:47:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753116472; x=1753721272; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JeSv3gHvUTPTfLdAm/yvdFeSA2QB26knaAlvT/a7PFE=;
        b=4TYTjS9dKvenmjMnxTVQiHHrYuVIe11J45EOo+g7LOXZRV1GGfJl0u8uYTy1oKMFsr
         Ov+heqERU8xEv838md1quw9Fv6qTyTDIIedjjlUwalhzNKbGFrT9fP7W29qc3N9dm9Y5
         G9sJ1yXqBfzOkRASuMH36nKY29ixkEaRt1ptJhfvLkZvqnnnTPWY5SzEryzpyTFQtdim
         X8CmEkXSTemy10Ht/lD+bciQ0GLGFl83/0Wl/eUvRCloHBU8EUWId2+6Z7bfzFP0mIWR
         aFIFL5PUta/0pZ97OCZPZlClNjGQnkyTBxbYK0Ve98efWzGCFM/JyVznA/Partd0U+Ip
         PHRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753116472; x=1753721272;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JeSv3gHvUTPTfLdAm/yvdFeSA2QB26knaAlvT/a7PFE=;
        b=P/ZgM/xdSsk1YH8XZLdn52B9v1OMBSEkfj4OOKuvw6I/Pvi8qdcFQiG7TYzhR+iUet
         jC1KJcri7xDb4vNepSAelX+j8Rac8HOjmLMZAwbSc9anSFtnVZc6AD1bMzMK1fFpHpbO
         f9xTLNI+lqbkUJf1BZKYpRrBjpCOxKXTtl3m27lNMa6tsCBSozyUf1c6sKTCDEVhLXU7
         72nCew21Xfd8ajgOhRbJGm7Ny/fvePchBASVOA1vXkzkF4Nb7T6Q6Gdp4apqgiBp1Z6L
         Tblhly+abbK3pVZno302ovaG8ePjk4WvKhIqPVwrIwMdSArFT6qoXVb5KAaO4YUx9iLg
         u5lw==
X-Gm-Message-State: AOJu0Yyz4xB5RT42wcpq1D8Ky7NFoYNewbMIemxonS+ajJ3UzEGPq/eV
	DUzFDLx0rZO77JqEi17mbWVoqfyZr7IU6jsyP6TJvqsf/+adEZFE0wb52q5xVOQ67UUvuy+fzcB
	gVRM8/g==
X-Google-Smtp-Source: AGHT+IE/cOKwq4Fz42CXevBf86/8AcgfZ4Shrse64gwOZtr6yxqQauczM06pGk5soclLR2YvbV9vIqjBOj4=
X-Received: from pfbhd13.prod.google.com ([2002:a05:6a00:658d:b0:748:f98a:d97b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:7d9f:b0:232:1be:1e09
 with SMTP id adf61e73a8af0-237d7545cf7mr36104602637.34.1753116472317; Mon, 21
 Jul 2025 09:47:52 -0700 (PDT)
Date: Mon, 21 Jul 2025 09:47:50 -0700
In-Reply-To: <20250717162731.446579-14-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250717162731.446579-1-tabba@google.com> <20250717162731.446579-14-tabba@google.com>
Message-ID: <aH5vNqPrUFgtZCqU@google.com>
Subject: Re: [PATCH v15 13/21] KVM: x86/mmu: Handle guest page faults for
 guest_memfd with shared memory
From: Sean Christopherson <seanjc@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org, 
	mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
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
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com
Content-Type: text/plain; charset="us-ascii"

On Thu, Jul 17, 2025, Fuad Tabba wrote:
> From: Ackerley Tng <ackerleytng@google.com>
> 
> Update the KVM MMU fault handler to service guest page faults
> for memory slots backed by guest_memfd with mmap support. For such
> slots, the MMU must always fault in pages directly from guest_memfd,
> bypassing the host's userspace_addr.
> 
> This ensures that guest_memfd-backed memory is always handled through
> the guest_memfd specific faulting path, regardless of whether it's for
> private or non-private (shared) use cases.
> 
> Additionally, rename kvm_mmu_faultin_pfn_private() to
> kvm_mmu_faultin_pfn_gmem(), as this function is now used to fault in
> pages from guest_memfd for both private and non-private memory,
> accommodating the new use cases.
> 
> Co-developed-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> Co-developed-by: Fuad Tabba <tabba@google.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 94be15cde6da..ad5f337b496c 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4511,8 +4511,8 @@ static void kvm_mmu_finish_page_fault(struct kvm_vcpu *vcpu,
>  				 r == RET_PF_RETRY, fault->map_writable);
>  }
>  
> -static int kvm_mmu_faultin_pfn_private(struct kvm_vcpu *vcpu,
> -				       struct kvm_page_fault *fault)
> +static int kvm_mmu_faultin_pfn_gmem(struct kvm_vcpu *vcpu,
> +				    struct kvm_page_fault *fault)
>  {
>  	int max_order, r;
>  
> @@ -4536,13 +4536,18 @@ static int kvm_mmu_faultin_pfn_private(struct kvm_vcpu *vcpu,
>  	return RET_PF_CONTINUE;
>  }
>  
> +static bool fault_from_gmem(struct kvm_page_fault *fault)

Drop the helper.  It has exactly one caller, and it makes the code *harder* to
read, e.g. raises the question of what "from gmem" even means.  If a separate
series follows and needs/justifies this helper, then it can/should be added then.

> +{
> +	return fault->is_private || kvm_memslot_is_gmem_only(fault->slot);
> +}
> +
>  static int __kvm_mmu_faultin_pfn(struct kvm_vcpu *vcpu,
>  				 struct kvm_page_fault *fault)
>  {
>  	unsigned int foll = fault->write ? FOLL_WRITE : 0;
>  
> -	if (fault->is_private)
> -		return kvm_mmu_faultin_pfn_private(vcpu, fault);
> +	if (fault_from_gmem(fault))
> +		return kvm_mmu_faultin_pfn_gmem(vcpu, fault);
>  
>  	foll |= FOLL_NOWAIT;
>  	fault->pfn = __kvm_faultin_pfn(fault->slot, fault->gfn, foll,
> -- 
> 2.50.0.727.gbf7dc18ff4-goog
> 

