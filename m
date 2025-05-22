Return-Path: <kvm+bounces-47326-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EC39EAC0172
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 02:40:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 177971BA28D9
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 00:40:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E136B27442;
	Thu, 22 May 2025 00:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MTiAtvRC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87C7B80B
	for <kvm@vger.kernel.org>; Thu, 22 May 2025 00:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747874418; cv=none; b=Jf0tMfT3l53sEitCaPqGWDEDyZISq8Av1vkGO68R9NcOYCjeUos22Tm+A6PjRSFVxXq72i0SeLspEP0ONuU7aMcRy1jBo11J+GwxBtTOqyk5QFkLyA9kmL5nvCgaDzyXzKQfw4ypBPY6O+sCa10ftMpfLp0RUOnuq0gCheQNcXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747874418; c=relaxed/simple;
	bh=eoKy91FJzgAgKPDv/iqNOdfZn/IcTe02GjaNqToa6S0=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=t7x6gCMAYZ0B0R/OekDfLy7JSCqq0mbeDIFeADHdHds2X95MBwYkqo8kDrDUvB5Ff4r1OvxTM8Gg8GteDoAJS4+NUoOvDlOTHbvUSybvdOT0KKRmlebVVBQ5mMg3toGhe11v8KMXXY1F9/Q2o3xx1vOD2cZtzNHHkheBwNWzT6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MTiAtvRC; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-742c03c0272so6001117b3a.1
        for <kvm@vger.kernel.org>; Wed, 21 May 2025 17:40:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747874416; x=1748479216; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=AKb7exaOpTslJM3RgwHKvEMlMgIHhiGGsRV2RCQWlUI=;
        b=MTiAtvRCdDbNhkb+bAciXzY4lh1SvmG1sEBmk2Ju9J3syJX2lPr7gQLUW/G/UCskyv
         WpOlGHeMlsGz+jKFqhYmC6wVmjcn+XT5FWCEbZNBTL/7Pz+kDWX1p/5vOK+MZnjhQJ3J
         mr9oeDuy2NFOOj+OQeZoOenB4iZMbY+P4J7cd0Ed27WQfqnIyqwbAiAvfB4uaSTGleky
         BjC/+6CZy9JOunSowe7fETcT0kqc1N1tYxUEbFHmMYr5PYBOAfKjJVhbZ85vWoW5rRym
         1nbKVywR7NAJoair7B5f4lOboS7/sbZgqXDDqwxa4jhrHx6cYzUpzhhGREWqZf7PSKtI
         V5Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747874416; x=1748479216;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AKb7exaOpTslJM3RgwHKvEMlMgIHhiGGsRV2RCQWlUI=;
        b=P6zc2rLDu5lA3CUW/1/u6BIOriXWB4cngGXzMu0Z0p7tLkXkXalbFwfFEkGPfYryHT
         +2H2uhfCUEYyhY4LM2RAcI6ix93Gza6MMnYdxLf0/WhVXWu/hADI6RH+Pt0/GSu+Azo1
         H6T+eiEEKMFU1dx6IzhZ4jBNUqGNFgFuV4m8qL0jy8n/3EjR0cPwk2VuohEbJcTgopZh
         B8WT5EwQNNDdInWhHoFIBBigeqOCqvTNzBGy2o3JAaGdSiKr9b/c6k6d6wkpZcOpb9zS
         BXhCQHOLw3NbNbHAqyxYk2ThuEC8eYtbp4GURY1MiyKKJDsO1nSVJtWqOq7kn8Gb+6kk
         WSjA==
X-Forwarded-Encrypted: i=1; AJvYcCXXVHhjogi7eTCY1BA4GQAnd1Tic9CHyKG7M9e/kj0xsWPySTKVZJqXNCUr36v91wWTfoo=@vger.kernel.org
X-Gm-Message-State: AOJu0YyfLG7Npobn9h8adyOjDhinuD9rIKAzAN+yX0l7Cf4wO3dgZpzq
	5vfHN8vikUu9JNUCI5e0xOTUmU4I65T/cc7RDLK47WFzLOmpMjSuKJnfLEMOzdLjuMDjdhJHtYD
	utJuJbQ0HEzWxOWeeH4Yedy++RQ==
X-Google-Smtp-Source: AGHT+IGWdo01nKOBlYwmJrYcInX0d8KeSKo4N/PiVIliZLQS8wTxPrBl3O0gvGLSKbDZOe4bjzxYPT8mb5rPvN+X+A==
X-Received: from pfbfb17.prod.google.com ([2002:a05:6a00:2d91:b0:736:b19c:1478])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:6f57:b0:73d:b1ff:c758 with SMTP id d2e1a72fcca58-742a98abbecmr31372473b3a.18.1747874415752;
 Wed, 21 May 2025 17:40:15 -0700 (PDT)
Date: Wed, 21 May 2025 17:40:14 -0700
In-Reply-To: <fc7d0849-35ab-411a-be23-03520ca4b314@redhat.com> (message from
 David Hildenbrand on Wed, 21 May 2025 09:48:41 +0200)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-ID: <diqzfrgx8olt.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [PATCH v9 09/17] KVM: x86/mmu: Handle guest page faults for
 guest_memfd with shared memory
From: Ackerley Tng <ackerleytng@google.com>
To: David Hildenbrand <david@redhat.com>
Cc: tabba@google.com, kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-mm@kvack.org, pbonzini@redhat.com, chenhuacai@kernel.org, 
	mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, seanjc@google.com, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org, 
	akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com, 
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com, 
	dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, mail@maciej.szmigiero.name, 
	michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com, 
	isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com, 
	suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com, 
	quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com, 
	quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, 
	catalin.marinas@arm.com, james.morse@arm.com, yuzenghui@huawei.com, 
	oliver.upton@linux.dev, maz@kernel.org, will@kernel.org, qperret@google.com, 
	keirf@google.com, roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, 
	jgg@nvidia.com, rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, 
	hughd@google.com, jthoughton@google.com, peterx@redhat.com, 
	pankaj.gupta@amd.com, ira.weiny@intel.com
Content-Type: text/plain; charset="UTF-8"

David Hildenbrand <david@redhat.com> writes:

> On 13.05.25 18:34, Fuad Tabba wrote:
>> From: Ackerley Tng <ackerleytng@google.com>
>>
>> For memslots backed by guest_memfd with shared mem support, the KVM MMU
>> always faults-in pages from guest_memfd, and not from the userspace_addr.
>> Towards this end, this patch also introduces a new guest_memfd flag,
>> GUEST_MEMFD_FLAG_SUPPORT_SHARED, which indicates that the guest_memfd
>> instance supports in-place shared memory.
>>
>> This flag is only supported if the VM creating the guest_memfd instance
>> belongs to certain types determined by architecture. Only non-CoCo VMs
>> are permitted to use guest_memfd with shared mem, for now.
>>
>> Function names have also been updated for accuracy -
>> kvm_mem_is_private() returns true only when the current private/shared
>> state (in the CoCo sense) of the memory is private, and returns false if
>> the current state is shared explicitly or impicitly, e.g., belongs to a
>> non-CoCo VM.
>>
>> kvm_mmu_faultin_pfn_gmem() is updated to indicate that it can be used
>> to fault in not just private memory, but more generally, from
>> guest_memfd.
>>
>> Co-developed-by: Fuad Tabba <tabba@google.com>
>> Signed-off-by: Fuad Tabba <tabba@google.com>
>> Co-developed-by: David Hildenbrand <david@redhat.com>
>> Signed-off-by: David Hildenbrand <david@redhat.com>
>> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
>> ---
>
>
> [...]
>
>> +
>>   #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
>>   static inline unsigned long kvm_get_memory_attributes(struct kvm *kvm, gfn_t gfn)
>>   {
>> @@ -2515,10 +2524,30 @@ bool kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
>>   bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
>>   					 struct kvm_gfn_range *range);
>>
>> +/*
>> + * Returns true if the given gfn's private/shared status (in the CoCo sense) is
>> + * private.
>> + *
>> + * A return value of false indicates that the gfn is explicitly or implicity
>
> s/implicity/implicitly/
>

Thanks!

>> + * shared (i.e., non-CoCo VMs).
>> + */
>>   static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
>>   {
>> -	return IS_ENABLED(CONFIG_KVM_GMEM) &&
>> -	       kvm_get_memory_attributes(kvm, gfn) & KVM_MEMORY_ATTRIBUTE_PRIVATE;
>> +	struct kvm_memory_slot *slot;
>> +
>> +	if (!IS_ENABLED(CONFIG_KVM_GMEM))
>> +		return false;
>> +
>> +	slot = gfn_to_memslot(kvm, gfn);
>> +	if (kvm_slot_has_gmem(slot) && kvm_gmem_memslot_supports_shared(slot)) {
>> +		/*
>> +		 * For now, memslots only support in-place shared memory if the
>> +		 * host is allowed to mmap memory (i.e., non-Coco VMs).
>> +		 */
>
> Not accurate: there is no in-place conversion support in this series,
> because there is no such itnerface. So the reason is that all memory is
> shared for there VM types?
>

True that there's no in-place conversion yet.

In this patch series, guest_memfd memslots support shared memory only
for specific VM types (on x86, that would be KVM_X86_DEFAULT_VM and
KVM_X86_SW_PROTECTED_VMs).

How about this wording:

Without conversion support, if the guest_memfd memslot supports shared
memory, all memory must be used as not private (implicitly shared).

>> +		return false;
>> +	}
>> +
>> +	return kvm_get_memory_attributes(kvm, gfn) & KVM_MEMORY_ATTRIBUTE_PRIVATE;
>>   }
>>   #else
>>   static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
>> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
>> index 2f499021df66..fe0245335c96 100644
>> --- a/virt/kvm/guest_memfd.c
>> +++ b/virt/kvm/guest_memfd.c
>> @@ -388,6 +388,23 @@ static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma)
>>
>>   	return 0;
>>   }
>> +
>> +bool kvm_gmem_memslot_supports_shared(const struct kvm_memory_slot *slot)
>> +{
>> +	struct file *file;
>> +	bool ret;
>> +
>> +	file = kvm_gmem_get_file((struct kvm_memory_slot *)slot);
>> +	if (!file)
>> +		return false;
>> +
>> +	ret = kvm_gmem_supports_shared(file_inode(file));
>> +
>> +	fput(file);
>> +	return ret;
>
> Would it make sense to cache that information in the memslot, to avoid
> the get/put?
>
> We could simply cache when creating the memslot I guess.
>

When I wrote it I was assuming that to ensure correctness we should
check with guest memfd, like what if someone closed the gmem file in the
middle of the fault path?

But I guess after the discussion at the last call, since the faulting
process is long and racy, if this check passed and we go to guest memfd
and the file was closed, it would just fail so I guess caching is fine.

> As an alternative ... could we simple get/put when managing the memslot?

What does a simple get/put mean here?

