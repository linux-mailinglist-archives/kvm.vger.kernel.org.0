Return-Path: <kvm+bounces-47236-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1ADAEABED4C
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 09:49:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 719EE3AC9CD
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 07:48:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 084CE23536A;
	Wed, 21 May 2025 07:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="P8BWr8n/"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A95F22F74F
	for <kvm@vger.kernel.org>; Wed, 21 May 2025 07:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747813731; cv=none; b=I4RU93739aEeiJlLCutpQdb96JdreETppFWrK7UqpfnF6g7wwUWLvKS+KsgQQphFSyhJhReMSfTYtoVNZt+V9MMaiCjXJtCI+xIw7fsiFA7RMnhW3iQDWEbK59pFa9qnhkUzd+jSWF5+OoUPg+KeQM+IzSXkku7C8BVEtG+O27g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747813731; c=relaxed/simple;
	bh=Dpy1obNg3DJawKTfV5amUEt0pWwh1Uj+CHxe44BgZGM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=R3mB0zis8Ty2FWGyHfDxAHNWvB+wA3m87MtBg5klC6pjOCwMOHsu7EYxwPCo7aOAStqKRJPashFpSVLcbujMKuwDkJIf8tDE9FSQzMIQo4Xv50Dlk9lXsk9QYWkmM1DCvVpLqJA6aYHNc78irRygDXvr8m6ZR8OqMzu/4wBTTsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=P8BWr8n/; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747813728;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Ak0FpZpQGUq4r2jLBIWnnDK9APkUfaLBmd+ZS8A7nGU=;
	b=P8BWr8n/Zteu97BGv6pW/LbORIjpOo6crHzpS66b/K6II4nUyanfaYf5YjyUqa4cIVvZF5
	reApzSiUkPfahZm/NT7mxKicrO7NOGkx45K4ArjP4J0WoBTOvrAHrafm8lkpujM7uO15on
	OGRsrSLPo4WbAY6gVbRxXCvq6CvVTrI=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-283-kIvjM5hHOUixiEsjnnVQBg-1; Wed, 21 May 2025 03:48:46 -0400
X-MC-Unique: kIvjM5hHOUixiEsjnnVQBg-1
X-Mimecast-MFC-AGG-ID: kIvjM5hHOUixiEsjnnVQBg_1747813726
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3a3696a0d3aso1521946f8f.2
        for <kvm@vger.kernel.org>; Wed, 21 May 2025 00:48:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747813725; x=1748418525;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Ak0FpZpQGUq4r2jLBIWnnDK9APkUfaLBmd+ZS8A7nGU=;
        b=unQKH1NiLFiyL1JhhJq1lhoGOQ04Rzi6bR2GRIy4CDSHZOBhFDiZzILxmHeuONyPMd
         brUYb0Y/CHFD2glcHfanRjf9BrxjKqkZAekJm/aprNstCbxBsM9h5QT333v+zmcb6udL
         ePkmrChMInFhO2IcMuUi7v7LO6/Xd7HA+F04KHU+XuWnfHl2nhuDVL2gysS7egsz5cSD
         ZG7vR1gpkBeQWqLkEIL/J3K42P0WEOgsU5wM37JqlQlog/x0RjIXrf40LIfWnY5Dz/pD
         HUdBspLB3KHUwof37F1FenwjW0w+pq05QOQcm9JZlLxYBGXjj1bKuc29k9V4QKqXMeoF
         kVSQ==
X-Forwarded-Encrypted: i=1; AJvYcCWfaxeU6DH9rmXK97HjWkYSVv0EZgF0YJiHOzJHMJg/U/5fusQMgP80BxMuOv5W7tfgrRQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwYKBo2VK5TdEO9XZOprjcgYPjgZyMuogBUos8V6olQcnmlJ4nM
	FEKRvSxMGUrgRTzkn/0KYnivi0P2r+qoLPCv3CF0s0zGfE+KDI3CRoilctGqBlj8r9FrHnJEZJQ
	8C2wSWj0LSTyRVffglaf2U6wdafvLHQQjTU1oxrXoOIP3UYn2iloqzCgjBpA79UeB
X-Gm-Gg: ASbGnctrwlixZ68Nf5FG8s776YkpSLl3ft9Ec1NAEI4I3rRBlNKjd32sHWrHpmIwTHN
	S/NkKR3i3CqG3bHkdffG7veyq8M0qCxF697tB9vRDxcuP/nN/PtUKwPKB+B9OCFEe1ZxBXdJ7Yk
	zTPMVioBCDHEhUifFyyhmpSAcLHSiYADN0eM2i+EComJ27DVPzURKEYhnwrudtrZPxpH3vSgezb
	NMlY/3OfaLxncJb8JSMhCFMuE/WXZrjVk6oxJxkziT0Ap6dg1QcwuBX8OFuwcU0Bbc5BGPoeMfX
	FwHJsUstPwGuQW/mzlokJ2T4Jr7tdEYH6+Dqya14T2lp3ND8B8hD/lY65ILNp2OnZSxXIV3gGrf
	k05KpjuguNccEbgcA31BC7d/rbpxBziXvYPBFH48=
X-Received: by 2002:a5d:5846:0:b0:3a3:77d7:b200 with SMTP id ffacd0b85a97d-3a377d7b217mr6057039f8f.17.1747813725519;
        Wed, 21 May 2025 00:48:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEpTN9e/ZWesBOJXUvFSgL0EPyX/uv1m4Z6LW50+xiHAoT/yoWtj3ovu6uQ/k6pLY3iXDGoKQ==
X-Received: by 2002:a5d:5846:0:b0:3a3:77d7:b200 with SMTP id ffacd0b85a97d-3a377d7b217mr6057003f8f.17.1747813725052;
        Wed, 21 May 2025 00:48:45 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f25:9c00:e2c7:6eb5:8a51:1c60? (p200300d82f259c00e2c76eb58a511c60.dip0.t-ipconnect.de. [2003:d8:2f25:9c00:e2c7:6eb5:8a51:1c60])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a35ca88735sm19296243f8f.69.2025.05.21.00.48.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 May 2025 00:48:44 -0700 (PDT)
Message-ID: <fc7d0849-35ab-411a-be23-03520ca4b314@redhat.com>
Date: Wed, 21 May 2025 09:48:41 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 09/17] KVM: x86/mmu: Handle guest page faults for
 guest_memfd with shared memory
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
 jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com,
 ira.weiny@intel.com
References: <20250513163438.3942405-1-tabba@google.com>
 <20250513163438.3942405-10-tabba@google.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20250513163438.3942405-10-tabba@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 13.05.25 18:34, Fuad Tabba wrote:
> From: Ackerley Tng <ackerleytng@google.com>
> 
> For memslots backed by guest_memfd with shared mem support, the KVM MMU
> always faults-in pages from guest_memfd, and not from the userspace_addr.
> Towards this end, this patch also introduces a new guest_memfd flag,
> GUEST_MEMFD_FLAG_SUPPORT_SHARED, which indicates that the guest_memfd
> instance supports in-place shared memory.
> 
> This flag is only supported if the VM creating the guest_memfd instance
> belongs to certain types determined by architecture. Only non-CoCo VMs
> are permitted to use guest_memfd with shared mem, for now.
> 
> Function names have also been updated for accuracy -
> kvm_mem_is_private() returns true only when the current private/shared
> state (in the CoCo sense) of the memory is private, and returns false if
> the current state is shared explicitly or impicitly, e.g., belongs to a
> non-CoCo VM.
> 
> kvm_mmu_faultin_pfn_gmem() is updated to indicate that it can be used
> to fault in not just private memory, but more generally, from
> guest_memfd.
> 
> Co-developed-by: Fuad Tabba <tabba@google.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> Co-developed-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> ---


[...]

> +
>   #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
>   static inline unsigned long kvm_get_memory_attributes(struct kvm *kvm, gfn_t gfn)
>   {
> @@ -2515,10 +2524,30 @@ bool kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
>   bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
>   					 struct kvm_gfn_range *range);
>   
> +/*
> + * Returns true if the given gfn's private/shared status (in the CoCo sense) is
> + * private.
> + *
> + * A return value of false indicates that the gfn is explicitly or implicity

s/implicity/implicitly/

> + * shared (i.e., non-CoCo VMs).
> + */
>   static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
>   {
> -	return IS_ENABLED(CONFIG_KVM_GMEM) &&
> -	       kvm_get_memory_attributes(kvm, gfn) & KVM_MEMORY_ATTRIBUTE_PRIVATE;
> +	struct kvm_memory_slot *slot;
> +
> +	if (!IS_ENABLED(CONFIG_KVM_GMEM))
> +		return false;
> +
> +	slot = gfn_to_memslot(kvm, gfn);
> +	if (kvm_slot_has_gmem(slot) && kvm_gmem_memslot_supports_shared(slot)) {
> +		/*
> +		 * For now, memslots only support in-place shared memory if the
> +		 * host is allowed to mmap memory (i.e., non-Coco VMs).
> +		 */

Not accurate: there is no in-place conversion support in this series, 
because there is no such itnerface. So the reason is that all memory is 
shared for there VM types?

> +		return false;
> +	}
> +
> +	return kvm_get_memory_attributes(kvm, gfn) & KVM_MEMORY_ATTRIBUTE_PRIVATE;
>   }
>   #else
>   static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 2f499021df66..fe0245335c96 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -388,6 +388,23 @@ static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma)
>   
>   	return 0;
>   }
> +
> +bool kvm_gmem_memslot_supports_shared(const struct kvm_memory_slot *slot)
> +{
> +	struct file *file;
> +	bool ret;
> +
> +	file = kvm_gmem_get_file((struct kvm_memory_slot *)slot);
> +	if (!file)
> +		return false;
> +
> +	ret = kvm_gmem_supports_shared(file_inode(file));
> +
> +	fput(file);
> +	return ret;

Would it make sense to cache that information in the memslot, to avoid 
the get/put?

We could simply cache when creating the memslot I guess.

As an alternative ... could we simple get/put when managing the memslot?

-- 
Cheers,

David / dhildenb


