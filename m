Return-Path: <kvm+bounces-46762-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 16502AB95CF
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 08:09:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 976A34E4A01
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 06:09:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC1302222D7;
	Fri, 16 May 2025 06:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JbdE3s+U"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 582CE13790B
	for <kvm@vger.kernel.org>; Fri, 16 May 2025 06:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747375767; cv=none; b=rrgEk+Yxc82zoPpxKHWyiVQgCs3vLYJ3qGzqK4sGvHyPFmgNxMbxIGTdPxxkoidq5EC/diNQs4PCL8QXctqLAGaTCvLowCEb7oEFfBN2+x6DbYg7APMkF+u5FA766UXAJuKFaIuqHKY6tpM+oOq4eV8f2ubLs8A7narFYpZe1IY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747375767; c=relaxed/simple;
	bh=EkONSVFSNf6RbN/OEtrBrRqcdGVQNNZthV9GRn3rF54=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JFnP95NwRaVsm8YJr8i+sEkSaW8qctzzcBy97hmCzWIgVRXbqtIFC0pFj6syie09Bqhnkk3GvFWIQpIJ/h9TImyEZYe9aeV8VM+f+hJoove+DqGU53PBxFzy3lHoZLp3ZY8GVHE5MBA/w6EIRCIZWKAVX1vKrhHF9y5IukqWnYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JbdE3s+U; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747375764;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oPcG3FsFOiRXpv1XjAvU2NgERd/jyk19PD8+swcCIJ4=;
	b=JbdE3s+UTokjoqMXw02pgY8Cs0Ejaa3FWJgsEZk0GdEdfDFZEmxzExM49R8KciNd0NaAtf
	ixbBKcXVYFvXgShTxFr93fqsl5CD/jeX2ZcrZ73ErFLcTLvDd89OzcBMROP9tqOD4I/Rad
	KzDl/LnqlPEWMWoR9N/4C+cLtXleeWE=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-262--jhIDR9cPZa__oe3tK3flg-1; Fri, 16 May 2025 02:09:22 -0400
X-MC-Unique: -jhIDR9cPZa__oe3tK3flg-1
X-Mimecast-MFC-AGG-ID: -jhIDR9cPZa__oe3tK3flg_1747375762
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-30ab4d56096so2141207a91.0
        for <kvm@vger.kernel.org>; Thu, 15 May 2025 23:09:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747375762; x=1747980562;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oPcG3FsFOiRXpv1XjAvU2NgERd/jyk19PD8+swcCIJ4=;
        b=r1ZoCBljfM0O9YFyUmaYkGcHckR+Vdlhq3P1+0vdSVg7YltrtjIbO/fZ3v9JcmkrHh
         SrsPgpfL/WI3sd/G1Ei9Sm1k8n8kcRCo5/wEVb8hMK3KsOjY4oU3TE2Ra1oqjn+AImnB
         50NXsU+0VGVd/6EX21qSTWykRw9HCaqXGdEMeXL2cLwikd42kprgvUK/LQpC8h/N/F+3
         nTVfrqYSK5tFT0ecXU0WAPORUzuv7fKoJiPaAt7HJ0exe88csGM71wHnBa1wLMHZ4m6b
         9oqR3ULxg1b8lxLjCcJlXqzyJCWJdAvaSREUel35p2G2N9RV1euHQ+a+VqNXz/exTvNv
         smOg==
X-Forwarded-Encrypted: i=1; AJvYcCU2m4V8FYZMZcgaSiVKNX2h+sb10E+XWGBotiR5wrj1FNOwhwByk1mFr9WW5WmJnpHM3gY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx3EcrqxqdX6PWgGzCt98IgD8Y/B2ZcbRYg3yhthpLD+lwISvnG
	0w4mtKjAIE+LQyfbxRFFTsZz9ygK10gQxP+DYZ82wbkSZ0r8Feqgivq6bSF6QvTxIwCvYsALCoJ
	ekDx7D60EyfKsamtJyQ41JgrXLvd0glYSnW7ahST+ITb5am05gWFf7g==
X-Gm-Gg: ASbGncuzZZRyIm4l17A6wE1W/gp5XrFoZkIkcXPaOuOURdRo4G8R7lOdqYZBhC5OQAH
	nDo6p9F3QOk0PmQiivazjB+0HBj/diTzmOq+wmUgZBlqip+BNVoI5hBBcCx/CfAC3yzMaMxmyWE
	lbvRtR8D09SnM2dLeQnmYs0mS4xPJDl/tCGOzC23Qg441IxjGqUOYypy/oVowCfRwK0kBV+k0Cv
	kYFZDlxNoZYuKT+Xz+zK9bIFKuf1tNaQ2dydVvSIN/EW0JU1OJdANJ2uFE5hKsZR0/9XaZ/4O2Y
	+LVp8v2xafFo
X-Received: by 2002:a17:90b:33c2:b0:2fe:afa7:eaf8 with SMTP id 98e67ed59e1d1-30e7d50b040mr2667259a91.13.1747375761703;
        Thu, 15 May 2025 23:09:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEH5a8qqAjTmy08j8thqP+B00LVXrWtv611P5leiCrTuccrUC6wK6bUstDZ0smUsTwppAcRCA==
X-Received: by 2002:a17:90b:33c2:b0:2fe:afa7:eaf8 with SMTP id 98e67ed59e1d1-30e7d50b040mr2667176a91.13.1747375761099;
        Thu, 15 May 2025 23:09:21 -0700 (PDT)
Received: from [192.168.68.51] ([180.233.125.65])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30e7d4892c3sm825602a91.12.2025.05.15.23.09.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 May 2025 23:09:20 -0700 (PDT)
Message-ID: <c48843fb-c492-44d4-8000-705413aa9f08@redhat.com>
Date: Fri, 16 May 2025 16:08:59 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 07/17] KVM: guest_memfd: Allow host to map
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
References: <20250513163438.3942405-1-tabba@google.com>
 <20250513163438.3942405-8-tabba@google.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250513163438.3942405-8-tabba@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Fuad,

On 5/14/25 2:34 AM, Fuad Tabba wrote:
> This patch enables support for shared memory in guest_memfd, including
> mapping that memory at the host userspace. This support is gated by the
> configuration option KVM_GMEM_SHARED_MEM, and toggled by the guest_memfd
> flag GUEST_MEMFD_FLAG_SUPPORT_SHARED, which can be set when creating a
> guest_memfd instance.
> 
> Co-developed-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>   arch/x86/include/asm/kvm_host.h | 10 ++++
>   include/linux/kvm_host.h        | 13 +++++
>   include/uapi/linux/kvm.h        |  1 +
>   virt/kvm/Kconfig                |  5 ++
>   virt/kvm/guest_memfd.c          | 88 +++++++++++++++++++++++++++++++++
>   5 files changed, 117 insertions(+)
> 

[...]

> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 6db515833f61..8e6d1866b55e 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -312,7 +312,88 @@ static pgoff_t kvm_gmem_get_index(struct kvm_memory_slot *slot, gfn_t gfn)
>   	return gfn - slot->base_gfn + slot->gmem.pgoff;
>   }
>   
> +#ifdef CONFIG_KVM_GMEM_SHARED_MEM
> +
> +static bool kvm_gmem_supports_shared(struct inode *inode)
> +{
> +	uint64_t flags = (uint64_t)inode->i_private;
> +
> +	return flags & GUEST_MEMFD_FLAG_SUPPORT_SHARED;
> +}
> +
> +static vm_fault_t kvm_gmem_fault_shared(struct vm_fault *vmf)
> +{
> +	struct inode *inode = file_inode(vmf->vma->vm_file);
> +	struct folio *folio;
> +	vm_fault_t ret = VM_FAULT_LOCKED;
> +
> +	filemap_invalidate_lock_shared(inode->i_mapping);
> +
> +	folio = kvm_gmem_get_folio(inode, vmf->pgoff);
> +	if (IS_ERR(folio)) {
> +		int err = PTR_ERR(folio);
> +
> +		if (err == -EAGAIN)
> +			ret = VM_FAULT_RETRY;
> +		else
> +			ret = vmf_error(err);
> +
> +		goto out_filemap;
> +	}
> +
> +	if (folio_test_hwpoison(folio)) {
> +		ret = VM_FAULT_HWPOISON;
> +		goto out_folio;
> +	}
> +
> +	if (WARN_ON_ONCE(folio_test_large(folio))) {
> +		ret = VM_FAULT_SIGBUS;
> +		goto out_folio;
> +	}
> +

I don't think there is a large folio involved since the max/min folio order
(stored in struct address_space::flags) should have been set to 0, meaning
only order-0 is possible when the folio (page) is allocated and added to the
page-cache. More details can be referred to AS_FOLIO_ORDER_MASK. It's unnecessary
check but not harmful. Maybe a comment is needed to mention large folio isn't
around yet, but double confirm.


> +	if (!folio_test_uptodate(folio)) {
> +		clear_highpage(folio_page(folio, 0));
> +		kvm_gmem_mark_prepared(folio);
> +	}
> +

I must be missing some thing here. This chunk of code is out of sync to kvm_gmem_get_pfn(),
where kvm_gmem_prepare_folio() and kvm_arch_gmem_prepare() are executed, and then
PG_uptodate is set after that. In the latest ARM CCA series, kvm_arch_gmem_prepare()
isn't used, but it would delegate the folio (page) with the prerequisite that
the folio belongs to the private address space.

I guess that kvm_arch_gmem_prepare() is skipped here because we have the assumption that
the folio belongs to the shared address space? However, this assumption isn't always
true. We probably need to ensure the folio range is really belonging to the shared
address space by poking kvm->mem_attr_array, which can be modified by VMM through
ioctl KVM_SET_MEMORY_ATTRIBUTES.

> +	vmf->page = folio_file_page(folio, vmf->pgoff);
> +
> +out_folio:
> +	if (ret != VM_FAULT_LOCKED) {
> +		folio_unlock(folio);
> +		folio_put(folio);
> +	}
> +
> +out_filemap:
> +	filemap_invalidate_unlock_shared(inode->i_mapping);
> +
> +	return ret;
> +}
> +

Thanks,
Gavin


