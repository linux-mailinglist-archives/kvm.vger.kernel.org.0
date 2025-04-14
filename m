Return-Path: <kvm+bounces-43229-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C7BCA87FBA
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 13:52:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7B2343A9171
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 11:51:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CFD829C344;
	Mon, 14 Apr 2025 11:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PZQ/NNRh"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9027D29C33C
	for <kvm@vger.kernel.org>; Mon, 14 Apr 2025 11:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744631510; cv=none; b=kWfoTX03mfNFr/omkRi8pcZPE+AWfBYgN0RDpjt6AESPux2BUnBaGonIcHF/w26cUTsNnbFAQK186tRCJzxNwFjyzSsJvxWHtdHCigJUge+dsBm+2jR1MM8xERBnpXqclmEhLDLIJtVgPLo9SPF+Oi8H7ni79q3j+yFIowRA2G4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744631510; c=relaxed/simple;
	bh=nBwxyUUUjh3R1dI6hZOAFHc8WVK8CRskr5xG0K+B3/I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PMHn/Q46Qr6tJDxIXlJSuhFpumOaMm+4MRgwGfz/hOvA+TnssDLGS/1HSG81BusBw2SbkzLzJn1JPrKvx1gQiGveOXAEqGASF7uZfIf8K67JbG9Y7JXATtXoxDLxxpTD02tt5taqDrZYUIxcS11vN17jOCE++7SsQgIk9C+jQak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PZQ/NNRh; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744631507;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=kHA1N27VNOms9KsRfrgUlLYoDthJbm89ZkT6uJjDZEA=;
	b=PZQ/NNRh2ou7z8zlRK/ZUtbmaUZgckEwosYXQpTGCO4Q9tBL6GZzcPKvDnt9t1x2vo0b/p
	QAylqje2AcDKo8/27WrkBZ8dScehGggjDW+d4Gi0WnwxoiHRDAra5GGS2KpHjQDqDLsms9
	SuUXsiXpV3oQOTDJwyAmHTic8lIjgKk=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-311-q_yYFRv4PPy7lATr9hUkTw-1; Mon, 14 Apr 2025 07:51:46 -0400
X-MC-Unique: q_yYFRv4PPy7lATr9hUkTw-1
X-Mimecast-MFC-AGG-ID: q_yYFRv4PPy7lATr9hUkTw_1744631505
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-43cfda30a3cso23521795e9.3
        for <kvm@vger.kernel.org>; Mon, 14 Apr 2025 04:51:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744631505; x=1745236305;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=kHA1N27VNOms9KsRfrgUlLYoDthJbm89ZkT6uJjDZEA=;
        b=NoKNyl5aCLI9m1uv7qoDCJwFvaVFZNLuaAiHmx/dgjQ0JbP0D/OdcaPvI1dK9nZCv5
         QL1qMT11A1uxtagyo/Y/+jgY1xRf876mguf7LU6oik5XkXxku4l8zp0U5UQaBcV2FbxH
         y6KL08TyIqJ0aeulwdqo0NlvwtWRoB1Uj9Ac6zYmYHpx96T3b1Fe0v0iCe6XypbJ16OX
         qzvJl0Vy7XSa5cZHuFdBPftPk5Pbke4KqCzAJW0PU14eINXTirvr4rvqQOPXwX1KI+CJ
         UEeFbsxXp02AYp18l436uLEMGqI7WtAq0fN7+5JPJlwJDYd6h1oW4T7ehmLfMwcIHxDj
         8Ozw==
X-Forwarded-Encrypted: i=1; AJvYcCU7+KZOR6U4AKPIqdILp5bvHUkQLVyB6pczVnF4KtAOvcd9aV7E3nvbzfY4R1gm55yhd8U=@vger.kernel.org
X-Gm-Message-State: AOJu0YzkrriOm9kcfKfn2zmKA7kwKQkUfh6hjLqIIKhXQCEfrrI09lps
	AF5g6RewPNH/KG4b40hihxTnFKXTNXWqTZ1eOZ/7vHZMJK/rPI7SIOIBrU8JoFKuSAmBI2aCG76
	9KrG3CrsAWiEHm1/RvwoLLWXyvec4f/k6ajS8VEoG8EkG5/L3qw==
X-Gm-Gg: ASbGncugouimb0SMpepUwLa4IBqOFWiaQjPkEm9u49QDPH2KNv486maQ9n4TUeiKTNj
	uQu3Wzo40F1O9VjCq8rl8HbvE6y1AUMWmu7ylKZfM1/TGZI8BP29GwuHKf3iE+nyZx9u2/cFxum
	utR3Xt5lTbImlXh/kYssNCwQLyPKTDDfiPNngRZRwvpzVeANSDWZ0+QI+PjnLzq40OeoNsF+KUL
	BSRr5Hf8MIXHetnRTBQ45z181+a+9zW4NLPv9OMu9TXWgm0Gn+/Yk4wqfh+/In1vW7LI3a9xauj
	hcyAUVeSCnpKXD8RT/YZw0BbRX4d9vf3IQ/jlDgLNbqKedB0gc1H40nA2NkDnOmUzjQnxZSWjhP
	h2Pg7bkzKpa0MvK0hkZL0m6jI72UAVMuA8lYHxA==
X-Received: by 2002:a05:600c:4f90:b0:43c:f689:dd with SMTP id 5b1f17b1804b1-43f3a95aeb3mr65284835e9.19.1744631504842;
        Mon, 14 Apr 2025 04:51:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEKBVGZgpM8vnsnFr0HQCZu+ZmskykyBAeZIUQ3Gs4SMDXAxsp762XPhTYY8Jz4Y5/fTr+Wdg==
X-Received: by 2002:a05:600c:4f90:b0:43c:f689:dd with SMTP id 5b1f17b1804b1-43f3a95aeb3mr65284475e9.19.1744631504295;
        Mon, 14 Apr 2025 04:51:44 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f02:2900:f54f:bad7:c5f4:9404? (p200300d82f022900f54fbad7c5f49404.dip0.t-ipconnect.de. [2003:d8:2f02:2900:f54f:bad7:c5f4:9404])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43f235a5e90sm173840875e9.38.2025.04.14.04.51.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Apr 2025 04:51:43 -0700 (PDT)
Message-ID: <8ebc66ae-5f37-44c0-884b-564a65467fe4@redhat.com>
Date: Mon, 14 Apr 2025 13:51:41 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 4/9] KVM: guest_memfd: Handle in-place shared memory as
 guest_memfd backed memory
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
 jthoughton@google.com, peterx@redhat.com
References: <20250318161823.4005529-1-tabba@google.com>
 <20250318161823.4005529-5-tabba@google.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20250318161823.4005529-5-tabba@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 18.03.25 17:18, Fuad Tabba wrote:
> For VMs that allow sharing guest_memfd backed memory in-place,
> handle that memory the same as "private" guest_memfd memory. This
> means that faulting that memory in the host or in the guest will
> go through the guest_memfd subsystem.
> 
> Note that the word "private" in the name of the function
> kvm_mem_is_private() doesn't necessarily indicate that the memory
> isn't shared, but is due to the history and evolution of
> guest_memfd and the various names it has received. In effect,
> this function is used to multiplex between the path of a normal
> page fault and the path of a guest_memfd backed page fault.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>   include/linux/kvm_host.h | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 601bbcaa5e41..3d5595a71a2a 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -2521,7 +2521,8 @@ static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
>   #else
>   static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
>   {
> -	return false;
> +	return kvm_arch_gmem_supports_shared_mem(kvm) &&
> +	       kvm_slot_can_be_private(gfn_to_memslot(kvm, gfn));
>   }
>   #endif /* CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES */
>   

I've been thinking long about this, and was wondering if we should instead
clean up the code to decouple the "private" from gmem handling first.

I know, this was already discussed a couple of times, but faking that
shared memory is private looks odd.

I played with the code to star cleaning this up. I ended up with the following
gmem-terminology  cleanup patches (not even compile tested)

KVM: rename CONFIG_KVM_GENERIC_PRIVATE_MEM to CONFIG_KVM_GENERIC_GMEM_POPULATE
KVM: rename CONFIG_KVM_PRIVATE_MEM to CONFIG_KVM_GMEM
KVM: rename kvm_arch_has_private_mem() to kvm_arch_supports_gmem()
KVM: x86: rename kvm->arch.has_private_mem to kvm->arch.supports_gmem
KVM: rename kvm_slot_can_be_private() to kvm_slot_has_gmem()
KVM: x86: generalize private fault lookups to "gmem" fault lookups

https://github.com/davidhildenbrand/linux/tree/gmem_shared_prep

On top of that, I was wondering if we could look into doing something like
the following. It would also allow for pulling pages out of gmem for
existing SW-protected VMs once they enable shared memory for GMEM IIUC.


diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 08eebd24a0e18..6f878cab0f466 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4495,11 +4495,6 @@ static int kvm_mmu_faultin_pfn_gmem(struct kvm_vcpu *vcpu,
  {
         int max_order, r;
  
-       if (!kvm_slot_has_gmem(fault->slot)) {
-               kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
-               return -EFAULT;
-       }
-
         r = kvm_gmem_get_pfn(vcpu->kvm, fault->slot, fault->gfn, &fault->pfn,
                              &fault->refcounted_page, &max_order);
         if (r) {
@@ -4518,8 +4513,19 @@ static int __kvm_mmu_faultin_pfn(struct kvm_vcpu *vcpu,
                                  struct kvm_page_fault *fault)
  {
         unsigned int foll = fault->write ? FOLL_WRITE : 0;
+       bool use_gmem = false;
+
+       if (fault->is_private) {
+               if (!kvm_slot_has_gmem(fault->slot)) {
+                       kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
+                       return -EFAULT;
+               }
+               use_gmem = true;
+       } else if (kvm_slot_has_gmem_with_shared(fault->slot)) {
+               use_gmem = true;
+       }
  
-       if (fault->is_private)
+       if (use_gmem)
                 return kvm_mmu_faultin_pfn_gmem(vcpu, fault);
  
         foll |= FOLL_NOWAIT;


That is, we'd not claim that things are private when they are not, but instead
teach the code about shared memory coming from gmem.

There might be some more missing, just throwing it out there if I am completely off.

-- 
Cheers,

David / dhildenb


