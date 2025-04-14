Return-Path: <kvm+bounces-43268-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 77D70A88AB6
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 20:07:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 10ACF7AB543
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 18:06:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6717F28B4E9;
	Mon, 14 Apr 2025 18:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="I3clipVh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E27727A106
	for <kvm@vger.kernel.org>; Mon, 14 Apr 2025 18:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744654058; cv=none; b=K5JeAtZ+P4i9FUCS/G3OyEM74GUY8D5UXlijgpY3CvUbW0aZSqwcj/v0fYpUWpp86TrBqnNjCw/yWQzDnCfD6zfeNUnF1KK9BMXXt+WfE/7U3CHMlcVCzMuxr/ErxGFlQgEWC0Dt4tncRl3oH8h1R24A/wU+lUZHt6Vss5EL/w4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744654058; c=relaxed/simple;
	bh=AjkuyH+WYUVccrSUXLR+U/L+vq3jzNi72jov7x8RAn8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=no/DBguQ89AoJ1ZuhMp72mnVnX1C2p3n8Y/zcUH9SdhmXzpBjBXxUbSrLsbFUuKNsnLG//6+0iORJa3cfW5J09wZ3t9Ww84bb9zlo8JnKPNai6G5OSwwL9Oc/urMT+wmCehWIUZaK2AFFAvsecVfbP/rtEWQF2rxlWdZ0LF7zZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=I3clipVh; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-229668c8659so34353665ad.3
        for <kvm@vger.kernel.org>; Mon, 14 Apr 2025 11:07:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744654056; x=1745258856; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=++SDvb35prT8wUX8KJx52I0lAjlJYxZ6ukgi+YkcMGk=;
        b=I3clipVhvQ+DtCSInKEc/px3Bg3vHJFWCW+SVvTJR2kkvmG95hPE73w3AmFH1jXqSj
         UaepBJmAlgmKOukGYHHZve9OkCT9p1/WPQrIFdp1azPPSkjgyPqxZI6RO7xWLaBjYPOD
         1JFpNGMwppfam359vAbCDpeCfzeUcoYvmMO1PcU0ZGFpAq7gIWkUvEee4edoYWy8sZ+V
         TNYOh06X63SAYkvN0G3Lxqo5F99swvUFPvWlK/MDXcs7cQFzmxCK9bi0sc2oBmv4B2Oi
         /IxLWMBwPmkZvcqV7bLRVyHVAwJ1Q0d0Mr4iN3E+C41W2N4Zfve46VTIqaVcjv0y1Ilx
         TYww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744654056; x=1745258856;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=++SDvb35prT8wUX8KJx52I0lAjlJYxZ6ukgi+YkcMGk=;
        b=WjAPYAZfQyJkMZG24B4jncN31yoRAA8jCBFR2GgZHjQCylljhCab7wp+YWXfOctgeQ
         tqhZRjxE9tOofpjNtobU0NolkpQ2c8LbfA6LyhKS5NiDmtmwU4TTSi79vBe0F0QBa6oF
         FGz6w9PX1uaOqMW+tT1mst9vF2uN29upgNa3NMEKCooFN9s+tlvrwiHQt6ruu1u6zpLQ
         MVVJd8ngdVC29IHcKly2UqzuUKpQPxNtGPd0ex4Njml+shQWsyItYZYHdCCMb1ejK0R9
         5XmlL6MBDJX7i9qrKh+x2KIwsZ0MFGExCD7FMB0NmLQRx9pHeWQ6A8V32bsDGGLC0gCC
         JIvQ==
X-Forwarded-Encrypted: i=1; AJvYcCUFxS9S40KnNfw1afA3fcbxVHaCCzYGz02SgBWwM2Cb2X8SEHfz9w+xzcQanTbigD4cnPY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzZcSjQkK86+e6spUUsll7k9rpUafXuZ+vgBDQZNwXj9VMcSg26
	nV1r9svLlqvtafOtz3gy7iE6S1fyK0VJ27oFc9emjX6GIprCDykqbq4D0aTHM+ivlrhzJVmoQxd
	HlKBktadtYqc5yGPNq2CDAA==
X-Google-Smtp-Source: AGHT+IElXEZob++tmZ5mqeC0IBayeWoM91PrVBaN59KXtCAPwL4Hj1kJtUFwW0h4f+MctTFeOcTA04fqvlejztmSQg==
X-Received: from plbkx4.prod.google.com ([2002:a17:902:f944:b0:223:69a1:46da])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:3c44:b0:224:162:a3e0 with SMTP id d9443c01a7336-22bea50dfb1mr185065455ad.49.1744654056309;
 Mon, 14 Apr 2025 11:07:36 -0700 (PDT)
Date: Mon, 14 Apr 2025 11:07:34 -0700
In-Reply-To: <8ebc66ae-5f37-44c0-884b-564a65467fe4@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250318161823.4005529-1-tabba@google.com> <20250318161823.4005529-5-tabba@google.com>
 <8ebc66ae-5f37-44c0-884b-564a65467fe4@redhat.com>
Message-ID: <diqzplhe4nx5.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [PATCH v7 4/9] KVM: guest_memfd: Handle in-place shared memory as
 guest_memfd backed memory
From: Ackerley Tng <ackerleytng@google.com>
To: David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, linux-mm@kvack.org
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, mail@maciej.szmigiero.name, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com
Content-Type: text/plain; charset="UTF-8"

David Hildenbrand <david@redhat.com> writes:

> On 18.03.25 17:18, Fuad Tabba wrote:
>> For VMs that allow sharing guest_memfd backed memory in-place,
>> handle that memory the same as "private" guest_memfd memory. This
>> means that faulting that memory in the host or in the guest will
>> go through the guest_memfd subsystem.
>> 
>> Note that the word "private" in the name of the function
>> kvm_mem_is_private() doesn't necessarily indicate that the memory
>> isn't shared, but is due to the history and evolution of
>> guest_memfd and the various names it has received. In effect,
>> this function is used to multiplex between the path of a normal
>> page fault and the path of a guest_memfd backed page fault.
>> 
>> Signed-off-by: Fuad Tabba <tabba@google.com>
>> ---
>>   include/linux/kvm_host.h | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>> 
>> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
>> index 601bbcaa5e41..3d5595a71a2a 100644
>> --- a/include/linux/kvm_host.h
>> +++ b/include/linux/kvm_host.h
>> @@ -2521,7 +2521,8 @@ static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
>>   #else
>>   static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
>>   {
>> -	return false;
>> +	return kvm_arch_gmem_supports_shared_mem(kvm) &&
>> +	       kvm_slot_can_be_private(gfn_to_memslot(kvm, gfn));
>>   }
>>   #endif /* CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES */
>>   
>
> I've been thinking long about this, and was wondering if we should instead
> clean up the code to decouple the "private" from gmem handling first.
>

Thank you for making this suggestion more concrete, I like the renaming!

> I know, this was already discussed a couple of times, but faking that
> shared memory is private looks odd.
>
> I played with the code to star cleaning this up. I ended up with the following
> gmem-terminology  cleanup patches (not even compile tested)
>
> KVM: rename CONFIG_KVM_GENERIC_PRIVATE_MEM to CONFIG_KVM_GENERIC_GMEM_POPULATE
> KVM: rename CONFIG_KVM_PRIVATE_MEM to CONFIG_KVM_GMEM
> KVM: rename kvm_arch_has_private_mem() to kvm_arch_supports_gmem()
> KVM: x86: rename kvm->arch.has_private_mem to kvm->arch.supports_gmem
> KVM: rename kvm_slot_can_be_private() to kvm_slot_has_gmem()

Perhaps zooming into this [1] can clarify a lot. In
kvm_mmu_max_mapping_level(), it was

  bool is_private = kvm_slot_has_gmem(slot) && kvm_mem_is_private(kvm, gfn);

and now it is

  bool is_gmem = kvm_slot_has_gmem(slot) && kvm_mem_from_gmem(kvm, gfn);

Is this actually saying that the mapping level is to be fully determined
from lpage_info as long as this memslot has gmem and

A. this specific gfn is backed by gmem, or
B. if the specific gfn is private?

I noticed some other places where kvm_mem_is_private() is left as-is
[2], is that intentional? Are you not just renaming but splitting out
the case two cases A and B?

[1] https://github.com/davidhildenbrand/linux/blob/ac8ae8eb494c3d5a943a4a44c0e9e34b4976895a/arch/x86/kvm/mmu/mmu.c#L3286
[2] https://github.com/davidhildenbrand/linux/blob/ac8ae8eb494c3d5a943a4a44c0e9e34b4976895a/arch/x86/kvm/mmu/mmu.c#L4585

> KVM: x86: generalize private fault lookups to "gmem" fault lookups
>
> https://github.com/davidhildenbrand/linux/tree/gmem_shared_prep
>
> On top of that, I was wondering if we could look into doing something like
> the following. It would also allow for pulling pages out of gmem for
> existing SW-protected VMs once they enable shared memory for GMEM IIUC.
>
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 08eebd24a0e18..6f878cab0f466 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4495,11 +4495,6 @@ static int kvm_mmu_faultin_pfn_gmem(struct kvm_vcpu *vcpu,
>   {
>          int max_order, r;
>   
> -       if (!kvm_slot_has_gmem(fault->slot)) {
> -               kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
> -               return -EFAULT;
> -       }
> -
>          r = kvm_gmem_get_pfn(vcpu->kvm, fault->slot, fault->gfn, &fault->pfn,
>                               &fault->refcounted_page, &max_order);
>          if (r) {
> @@ -4518,8 +4513,19 @@ static int __kvm_mmu_faultin_pfn(struct kvm_vcpu *vcpu,
>                                   struct kvm_page_fault *fault)
>   {
>          unsigned int foll = fault->write ? FOLL_WRITE : 0;
> +       bool use_gmem = false;
> +
> +       if (fault->is_private) {
> +               if (!kvm_slot_has_gmem(fault->slot)) {
> +                       kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
> +                       return -EFAULT;
> +               }
> +               use_gmem = true;
> +       } else if (kvm_slot_has_gmem_with_shared(fault->slot)) {
> +               use_gmem = true;
> +       }
>   
> -       if (fault->is_private)
> +       if (use_gmem)
>                  return kvm_mmu_faultin_pfn_gmem(vcpu, fault);
>   
>          foll |= FOLL_NOWAIT;
>
>
> That is, we'd not claim that things are private when they are not, but instead
> teach the code about shared memory coming from gmem.
>
> There might be some more missing, just throwing it out there if I am completely off.
>
> -- 
> Cheers,
>
> David / dhildenb

