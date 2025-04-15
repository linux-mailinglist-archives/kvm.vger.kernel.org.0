Return-Path: <kvm+bounces-43367-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9707EA8AA76
	for <lists+kvm@lfdr.de>; Tue, 15 Apr 2025 23:50:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 35A727ADE62
	for <lists+kvm@lfdr.de>; Tue, 15 Apr 2025 21:49:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9371269AFB;
	Tue, 15 Apr 2025 21:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="thDW0M7u"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75DA42571BA
	for <kvm@vger.kernel.org>; Tue, 15 Apr 2025 21:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744753806; cv=none; b=ijIKGTwoyAZHHH9rhaCIHCyKDgbtE8DXBKkIdXgOK3DbQnav0Ppfk1b+rB5mpQzWb6Zf+KZVXxH9xRDk9ToiY2Pzf4D5jzGeAWBDVbD9RBOiU8oheSgnEi737tHulmwJvvwK2mHE+Gmqmkm1W8HOCwW20gjHsdlaI2QBqtCJo+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744753806; c=relaxed/simple;
	bh=5/NWhJGTR111gR3ytAZ3IaSWhrRMyR/w27LAtp5Qaps=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ubpGzgEcqj0fFIX+Rx3HBgw7sx7PZQl6ZIUYAHx6+QAl/YGmYS/ECPk4PcmVI6Z8eBhwt6CtNVQnWu6n3J9/Ri6cOooILA5rMujU9tHBZlaCD/3PFMzlscoRlPCJSdNl5Ox+CXj+/qEJmO6lpWPZQng8+LDfuMttrbVI4wevkHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=thDW0M7u; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ff53a4754aso8211193a91.2
        for <kvm@vger.kernel.org>; Tue, 15 Apr 2025 14:50:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744753803; x=1745358603; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=uTx3IQmw1d/s//2U0IFS0RT4+t8nXB6h4o3D1NalSH0=;
        b=thDW0M7uFg9MMlgcE7ncfN8BxS0nbSc5u92IviQ4MLfCvBAanFaaNTCtIRh4Kn8HWA
         hvwQ0SrQZZdO8Gv2BL9K6AuKHLJr6Cyafdahw67R2z0aBE6sy5cbX1sqCIXggwjMlZPC
         6ZTSPYMMPC2dpiEBwHDwuKuncqNnN3MTvOaLquPtIHOtuB5WVNN4CzjTTpGAafuGf8hi
         pBmLBBy6BtL1uFZCddohjKs1dCP4ozD8PlOF0fsyzkjMjV9R4buu5MI7yMoY6WdV/NdD
         Xfrkj6mKt42RhNLFVAs7YUK4EXmByNaPAVNaB697HMKSBLcUwm0P/YdApXGtwZasvVYW
         k/kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744753803; x=1745358603;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uTx3IQmw1d/s//2U0IFS0RT4+t8nXB6h4o3D1NalSH0=;
        b=d47XZYSOHRi+4XeUmcDGPYwmpOKYvDAjhVlktmttdyJzuSYoIIM4A83kuUKYs3j2uP
         ogCiN7uiN8Rr9V//ynfQiu24/l0q0fZT36i4wlBcHdoM6qSSchVYxxzp20Fr00RpHD/L
         cXXDz1OYy5LSGZbUjTk2WWO8omwdcNPTaSE9ssVHa/vBokfBV1hm8QMLHtu3Qi5GHORR
         lAvncaAYFWQK2dKZG9LHJUIbAIvFXhvh1dCyH/N8l9HR3jdGqyubmypolWZHZH3za3wl
         mLAMcz9yy5utBMO6FgRWKKzkhLefEb7NiLwaZnW4RwRfiGA/uQXDHvg11PrcA39MHnbe
         g8nQ==
X-Forwarded-Encrypted: i=1; AJvYcCXQ8CzMAPFItRx7MwbPbRgfqWuaJkp42il/BAreFrdRRe9XDTv5tub5LoxihJYE0YlJhxo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxA8O8c9x0IBUEYQ8wwnVfSNjFAU2XqcHzC/MRLR3yl5znoCcMA
	gzbpfWFc3+it9qNLQJEru2JjOt5UmmEljmx2iHwNgzUHRBSifN4GqUC6c9RyHjKm2kivjCrftIY
	RO6M2Mia5qTYGaopDFxfK5A==
X-Google-Smtp-Source: AGHT+IHbcuCKr7+TaUUDUKsgkWd0/H6le+d7oLdGfE5j/tZhHFTkUYtt0TfO8zWEQliBZKo1bdAr6qqVJB/Do3zRBA==
X-Received: from pjbse6.prod.google.com ([2002:a17:90b:5186:b0:2ff:6e58:89f7])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:4d0f:b0:2ff:592d:23bc with SMTP id 98e67ed59e1d1-3085ee7fd32mr993910a91.4.1744753803659;
 Tue, 15 Apr 2025 14:50:03 -0700 (PDT)
Date: Tue, 15 Apr 2025 14:50:02 -0700
In-Reply-To: <6121b93b-6390-49e9-82db-4ed3a6797898@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250318161823.4005529-1-tabba@google.com> <20250318161823.4005529-5-tabba@google.com>
 <8ebc66ae-5f37-44c0-884b-564a65467fe4@redhat.com> <diqzplhe4nx5.fsf@ackerleytng-ctop.c.googlers.com>
 <6121b93b-6390-49e9-82db-4ed3a6797898@redhat.com>
Message-ID: <diqzzfghyu0l.fsf@ackerleytng-ctop.c.googlers.com>
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

>>> I've been thinking long about this, and was wondering if we should instead
>>> clean up the code to decouple the "private" from gmem handling first.
>>>
>> 
>> Thank you for making this suggestion more concrete, I like the renaming!
>> 
>
> Thanks for the fast feedback!
>
>>> I know, this was already discussed a couple of times, but faking that
>>> shared memory is private looks odd.
>>>
>>> I played with the code to star cleaning this up. I ended up with the following
>>> gmem-terminology  cleanup patches (not even compile tested)
>>>
>>> KVM: rename CONFIG_KVM_GENERIC_PRIVATE_MEM to CONFIG_KVM_GENERIC_GMEM_POPULATE
>>> KVM: rename CONFIG_KVM_PRIVATE_MEM to CONFIG_KVM_GMEM
>>> KVM: rename kvm_arch_has_private_mem() to kvm_arch_supports_gmem()
>>> KVM: x86: rename kvm->arch.has_private_mem to kvm->arch.supports_gmem
>>> KVM: rename kvm_slot_can_be_private() to kvm_slot_has_gmem()
>> 
>> Perhaps zooming into this [1] can clarify a lot. In
>> kvm_mmu_max_mapping_level(), it was
>> 
>>    bool is_private = kvm_slot_has_gmem(slot) && kvm_mem_is_private(kvm, gfn);
>> 
>> and now it is
>> 
>>    bool is_gmem = kvm_slot_has_gmem(slot) && kvm_mem_from_gmem(kvm, gfn);
>> 
>> Is this actually saying that the mapping level is to be fully determined
>> from lpage_info as long as this memslot has gmem and
>
> With this change in particular I was not quite sure what to do, maybe it should
> stay specific to private memory only? But yeah the ideas was that
> kvm_mem_from_gmem() would express:
>
> (a) if guest_memfd only supports private memory, it would translate to
> kvm_mem_is_private() -> no change.
>
> (b) with guest_memfd having support for shared memory (+ support being enabled!),
> it would only rely on the slot, not gfn information. Because it will all be
> consumed from guest_memfd.
>
> This hunk was missing
>
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index d9616ee6acc70..cdcd7ac091b5c 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -2514,6 +2514,12 @@ static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
>   }
>   #endif /* CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES */
>   
> +static inline bool kvm_mem_from_gmem(struct kvm *kvm, gfn_t gfn)
> +{
> +       /* For now, only private memory gets consumed from guest_memfd. */
> +       return kvm_mem_is_private(kvm, gfn);
> +}
> +
>
>

I looked a little deeper and got help from James Houghton on
understanding this too.

Specifically for the usage of kvm_mem_is_private() in
kvm_mmu_max_mapping_level(), the intention there is probably to skip
querying userspace page tables in __kvm_mmu_max_mapping_level() since
private memory will never be faulted into userspace, hence no need to
check.

Hence kvm_mem_is_private() there is really meant to query the
private-ness of the gfn rather than just whether kvm_mem_from_gmem().

But then again, if kvm_mem_from_gmem(), guest_memfd should be queried
for max_mapping_level. guest_memfd would know, for both private and
shared memory, what page size the page was split to, and what level
it was faulted as. (Exception: if/when guest_memfd supports THP,
depending on how that is done, querying userspace page tables might be
necessary to determine the max_mapping_level)

>> 
>> A. this specific gfn is backed by gmem, or
>> B. if the specific gfn is private?
>> 
>> I noticed some other places where kvm_mem_is_private() is left as-is
>> [2], is that intentional? Are you not just renaming but splitting out
>> the case two cases A and B?
>
> That was the idea, yes.
>
> If we get a private fault and !kvm_mem_is_private(), or a shared fault and
> kvm_mem_is_private(), then we should handle it like today.
>
> That is the kvm_mmu_faultin_pfn() case, where we
>
> if (fault->is_private != kvm_mem_is_private(kvm, fault->gfn)) {
> 	kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
> 	return -EFAULT;
> }
>
> which can be reached by arch/x86/kvm/svm/svm.c:npf_interception()
>
> if (sev_snp_guest(vcpu->kvm) && (error_code & PFERR_GUEST_ENC_MASK))
> 	error_code |= PFERR_PRIVATE_ACCESS;
>
> In summary: the memory attribute mismatch will be handled as is, but not how
> we obtain the gfn.
>
> At least that was the idea (-issues in the commit).
>
> What are your thoughts about that direction?

I still like the renaming. :)

I looked into kvm_mem_is_private() and I believe it has the following
uses:

1. Determining max_mapping_level (kvm_mmu_max_mapping_level() and
   friends)
2. Querying the kernel's record of private/shared state, which is used
   to handle (a) mismatch between fault->private and kernel's record
   (handling implicit conversions) (b) how to prefaulting pages (c)
   determining how to fault in KVM_X86_SW_PROTECTED_VMs

So perhaps we could leave kvm_mem_is_private() as not renamed, but as
part of the series introducing mmap and conversions
(CONFIG_KVM_GMEM_SHARED_MEM), we should also have kvm_mem_is_private()
query guest_memfd for shareability status, and perhaps
kvm_mmu_max_mapping_level() could query guest_memfd for page size (after
splitting, etc).

IIUC the maximum mapping level is determined by these factors:

1. Attribute granularity (lpage_info)
2. Page size (guest_memfd for guest_memfd backed memory)
3. Size of mapping in host page table (for non-guest_memfd backed
   memory, and important for THP if/when/depending on how guest_memfd
   supports THP)

>
> -- 
> Cheers,
>
> David / dhildenb

