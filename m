Return-Path: <kvm+bounces-48713-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C032FAD179F
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 06:09:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AB8333A8232
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 04:08:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A36C527FB2A;
	Mon,  9 Jun 2025 04:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AlZUOT1z"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB7AC1714C0
	for <kvm@vger.kernel.org>; Mon,  9 Jun 2025 04:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749442138; cv=none; b=To1Gp1VFIl731tdvG+elMlyivZ/zUT4PQ0gejPBlZLFdo5N7p8vTnrKIjPcpghlOlFOeSKkJh6ZhuARqTdXE8o6t800IQZk02O4Gin/9k+nYYlWGyEsjbiVIZrbqfrPloDzQtCcQcB1Bw80bdfyRglcJqaxmR7JvUdX7H+77s5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749442138; c=relaxed/simple;
	bh=iqnb+ZB/2oTCUBhWTrXa/vqr3Uz8tsvhBI9pDkDNIrw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dnV19hh4A25blqp2KzGeBLvxGRQaKLfEPZewdGqTy8k+y+07bzFyinGEAZU6bG2LN8iBfxpNJF1aVXv7MYWlxVCN2ZqQKaw1xU3VJMGm9nNlQV7s/Nkjtbj9KX2BA0auCo20ZgllRSYN3+Wb0sDzNHffratLGipi0bFexh8sS0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AlZUOT1z; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749442136;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=znSV+kVarM376WETpFG5vxmhQ7lGKQs0oHqrXu/evqo=;
	b=AlZUOT1zoGSisCVwbRu2tXpg2/JLawFilxQy7yNNhi5kn0GCd3y5EbkuSjcea4D06VlsHH
	w21lVjUMiglCxlRxQhZVHXj926QrHLHj1PTyZerPydZXFIuM0eGxkcdrHooq53iunvRPcm
	VRcWtMWbf8N0kOJP2ArW/LsqKbEsbhg=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-176-7wPttcpxMYeGw7XtE-Uyvg-1; Mon, 09 Jun 2025 00:08:54 -0400
X-MC-Unique: 7wPttcpxMYeGw7XtE-Uyvg-1
X-Mimecast-MFC-AGG-ID: 7wPttcpxMYeGw7XtE-Uyvg_1749442133
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-74858256d38so31466b3a.2
        for <kvm@vger.kernel.org>; Sun, 08 Jun 2025 21:08:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749442133; x=1750046933;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=znSV+kVarM376WETpFG5vxmhQ7lGKQs0oHqrXu/evqo=;
        b=kWHTJgB4+BNA69Uiy38DZ/B/QoZzivWd+FfvP7sVYv3Ez4l5mh6xECkEgWMZq0qRn8
         CO9rh1c2Frhlaeiy2/338xaY2oAX643GlnQyMKgQr7mV6v8vFXy/Emy5sMomv1GHwm8O
         LoG7npeAK7jcRI6VoZAEsZ/MAIdlioz/4OiAewhczoSTM+4mc1l1Wr2zxXAT95BNK71o
         8xx15lpTgrsZZqKStFLDEU0T5bAlIL3b5syKkfKcHpDj5Y/KTiDyvItDN6VWqM0qgnAH
         yuVQfB4GlIpn4os9QofgcXLXTFJsOY8WXGOkxd7p9mkHlR0CLqltRWFO26RmIBSKc4Bn
         tOlg==
X-Forwarded-Encrypted: i=1; AJvYcCVSsZbg4PI/mDYrphzRR6ciLoJskj5iWRlT5IJDV3zF4gghLfcB1okVWNstNwuxZrAv8cE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwOPXp9oTcPBiboLRdL1Nd+gI+Nij/erP0zkYH1qk4P40rsSkgo
	mNgCDbWNigWSLtE+Bmiq3oF6Kaot1tNtcRtUqCIzX2doxL6Vsvopepis+QUILvOslfRaGxhmJkc
	U1LJp5MaGtQkK+M35WmtSaaOfXGvUaidcGz2tVkTp344nkYqJx70JyA==
X-Gm-Gg: ASbGnculAaldjSQIxZl5MDmK/CPSlO4qMjfNfYP5uYbt4ltE4/bXIz9UgWWNLMVJEkz
	dsVFxU1DVx1utalilxuFl/nVxCzPZQCzGL1DhXxSpS+OJBUOJSx9iYtrpH4s7bL2J5ikJPqJZ71
	P4gxXx+PDFRhgnyO5sS2tuAIo9qaV4otwvf4rdDzseoLObtZKNaYUpXh3wQME3w9v1LesGdhl9a
	wZ432h64VkXqivxpm9m9amHjbq1APXdhJc/9G3iEtGsLXqUYxnbHddisphQRSlY8b/mbH7SDtsJ
	XQncvvwF65fta6tyHf+xqGRAztrhJFN9lnCrzBUAtfBR1jlXWNg=
X-Received: by 2002:a05:6a00:1caa:b0:740:596b:4a7f with SMTP id d2e1a72fcca58-74827f10b78mr13424922b3a.16.1749442133121;
        Sun, 08 Jun 2025 21:08:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH7m/zTCGkEamABNbzON01NHA2JLBsIZ9H30Axsha6qHcMH8sLupDXiKBcrqXD+K67xykgA3w==
X-Received: by 2002:a05:6a00:1caa:b0:740:596b:4a7f with SMTP id d2e1a72fcca58-74827f10b78mr13424895b3a.16.1749442132715;
        Sun, 08 Jun 2025 21:08:52 -0700 (PDT)
Received: from [192.168.68.51] (n175-34-62-5.mrk21.qld.optusnet.com.au. [175.34.62.5])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7482af382fcsm4806740b3a.28.2025.06.08.21.08.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Jun 2025 21:08:52 -0700 (PDT)
Message-ID: <3d9a15ff-fbb2-4e9a-b97b-c0e40eb23043@redhat.com>
Date: Mon, 9 Jun 2025 14:08:30 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 14/18] KVM: arm64: Handle guest_memfd-backed guest
 page faults
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
 david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com,
 liam.merwick@oracle.com, isaku.yamahata@gmail.com,
 kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com,
 steven.price@arm.com, quic_eberman@quicinc.com, quic_mnalajal@quicinc.com,
 quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com,
 quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com,
 quic_pheragu@quicinc.com, catalin.marinas@arm.com, james.morse@arm.com,
 yuzenghui@huawei.com, oliver.upton@linux.dev, maz@kernel.org,
 will@kernel.org, qperret@google.com, keirf@google.com, roypat@amazon.co.uk,
 shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, rientjes@google.com,
 jhubbard@nvidia.com, fvdl@google.com, hughd@google.com,
 jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com,
 ira.weiny@intel.com
References: <20250605153800.557144-1-tabba@google.com>
 <20250605153800.557144-15-tabba@google.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250605153800.557144-15-tabba@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Fuad,

On 6/6/25 1:37 AM, Fuad Tabba wrote:
> Add arm64 support for handling guest page faults on guest_memfd backed
> memslots. Until guest_memfd supports huge pages, the fault granule is
> restricted to PAGE_SIZE.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>   arch/arm64/kvm/mmu.c | 93 ++++++++++++++++++++++++++++++++++++++++++--
>   1 file changed, 90 insertions(+), 3 deletions(-)
> 

One comment below. Otherwise, it looks good to me.

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index ce80be116a30..f14925fe6144 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1508,6 +1508,89 @@ static void adjust_nested_fault_perms(struct kvm_s2_trans *nested,
>   	*prot |= kvm_encode_nested_level(nested);
>   }
>   
> +#define KVM_PGTABLE_WALK_MEMABORT_FLAGS (KVM_PGTABLE_WALK_HANDLE_FAULT | KVM_PGTABLE_WALK_SHARED)
> +
> +static int gmem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> +		      struct kvm_s2_trans *nested,
> +		      struct kvm_memory_slot *memslot, bool is_perm)
> +{
> +	bool logging, write_fault, exec_fault, writable;
> +	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_MEMABORT_FLAGS;
> +	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
> +	struct kvm_pgtable *pgt = vcpu->arch.hw_mmu->pgt;
> +	struct page *page;
> +	struct kvm *kvm = vcpu->kvm;
> +	void *memcache;
> +	kvm_pfn_t pfn;
> +	gfn_t gfn;
> +	int ret;
> +
> +	ret = prepare_mmu_memcache(vcpu, !is_perm, &memcache);
> +	if (ret)
> +		return ret;
> +
> +	if (nested)
> +		gfn = kvm_s2_trans_output(nested) >> PAGE_SHIFT;
> +	else
> +		gfn = fault_ipa >> PAGE_SHIFT;
> +
> +	logging = memslot_is_logging(memslot);
> +	write_fault = kvm_is_write_fault(vcpu);
> +	exec_fault = kvm_vcpu_trap_is_exec_fault(vcpu);
> +
> +	if (write_fault && exec_fault) {
> +		kvm_err("Simultaneous write and execution fault\n");
> +		return -EFAULT;
> +	}
> +
> +	if (is_perm && !write_fault && !exec_fault) {
> +		kvm_err("Unexpected L2 read permission error\n");
> +		return -EFAULT;
> +	}
> +
> +	ret = kvm_gmem_get_pfn(kvm, memslot, gfn, &pfn, &page, NULL);
> +	if (ret) {
> +		kvm_prepare_memory_fault_exit(vcpu, fault_ipa, PAGE_SIZE,
> +					      write_fault, exec_fault, false);
> +		return ret;
> +	}
> +

-EFAULT or -EHWPOISON shall be returned, as documented in virt/kvm/api.rst. Besides,
kvm_send_hwpoison_signal() should be executed when -EHWPOISON is returned from
kvm_gmem_get_pfn()? :-)

Thanks,
Gavin

> +	writable = !(memslot->flags & KVM_MEM_READONLY) &&
> +		   (!logging || write_fault);
> +
> +	if (nested)
> +		adjust_nested_fault_perms(nested, &prot, &writable);
> +
> +	if (writable)
> +		prot |= KVM_PGTABLE_PROT_W;
> +
> +	if (exec_fault ||
> +	    (cpus_have_final_cap(ARM64_HAS_CACHE_DIC) &&
> +	     (!nested || kvm_s2_trans_executable(nested))))
> +		prot |= KVM_PGTABLE_PROT_X;
> +
> +	kvm_fault_lock(kvm);
> +	if (is_perm) {
> +		/*
> +		 * Drop the SW bits in favour of those stored in the
> +		 * PTE, which will be preserved.
> +		 */
> +		prot &= ~KVM_NV_GUEST_MAP_SZ;
> +		ret = KVM_PGT_FN(kvm_pgtable_stage2_relax_perms)(pgt, fault_ipa, prot, flags);
> +	} else {
> +		ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, fault_ipa, PAGE_SIZE,
> +					     __pfn_to_phys(pfn), prot,
> +					     memcache, flags);
> +	}
> +	kvm_release_faultin_page(kvm, page, !!ret, writable);
> +	kvm_fault_unlock(kvm);
> +
> +	if (writable && !ret)
> +		mark_page_dirty_in_slot(kvm, memslot, gfn);
> +
> +	return ret != -EAGAIN ? ret : 0;
> +}
> +
>   static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>   			  struct kvm_s2_trans *nested,
>   			  struct kvm_memory_slot *memslot, unsigned long hva,
> @@ -1532,7 +1615,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>   	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
>   	struct kvm_pgtable *pgt;
>   	struct page *page;
> -	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_HANDLE_FAULT | KVM_PGTABLE_WALK_SHARED;
> +	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_MEMABORT_FLAGS;
>   
>   	if (fault_is_perm)
>   		fault_granule = kvm_vcpu_trap_get_perm_fault_granule(vcpu);
> @@ -1959,8 +2042,12 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
>   		goto out_unlock;
>   	}
>   
> -	ret = user_mem_abort(vcpu, fault_ipa, nested, memslot, hva,
> -			     esr_fsc_is_permission_fault(esr));
> +	if (kvm_slot_has_gmem(memslot))
> +		ret = gmem_abort(vcpu, fault_ipa, nested, memslot,
> +				 esr_fsc_is_permission_fault(esr));
> +	else
> +		ret = user_mem_abort(vcpu, fault_ipa, nested, memslot, hva,
> +				     esr_fsc_is_permission_fault(esr));
>   	if (ret == 0)
>   		ret = 1;
>   out:


