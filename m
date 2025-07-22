Return-Path: <kvm+bounces-53102-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 42C9FB0D4E2
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 10:45:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7F01D547B39
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 08:44:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E5282D8DA0;
	Tue, 22 Jul 2025 08:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YkUBD3Iu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20CD72D46A3
	for <kvm@vger.kernel.org>; Tue, 22 Jul 2025 08:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753173876; cv=none; b=rEYmcrWHZd6SjniC4w3XAj7/muY+NJ7hTSxxq7wE0lpv1EabCAlw37/cwQ9/RDRV6VVcB3ZJsdCrlqqI13gxoa5AsvIbN5YivHo/CbNpV6JBhOxPJRw2GIHr7IzA51RRBGInlawjgb/Ughz4y3Jg/FiPqZBW1vyG91AbdaYpQ9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753173876; c=relaxed/simple;
	bh=oG+uGXiayq3wi+MQ+WXlyYFLXj87LJort2kb/5ueY80=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QQRoClmmjiF1PwVpdGX3kqz2XsHIHQWP9MPfyzcbUSBtbYmwvBru+iCwxgEDjIl3PEnlzt5z8h8MRoBaO6rdMpXEafv/GUrHq5WJIfCI8aJAl4QImUrHOF4b/3rm+niwzKW4huutlDNOfiERxo6JqvkdyzTKPbqotbNafio6Irc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YkUBD3Iu; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4ab3855fca3so185521cf.1
        for <kvm@vger.kernel.org>; Tue, 22 Jul 2025 01:44:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753173874; x=1753778674; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=dPBkvCcfAeL2dNZt7wG4lYGcQyDWbM6vpCIRnJhXb7E=;
        b=YkUBD3IuiLqdEIpnIC0UDpZTxYwx63bVCcQYJlaUJaw5STnK8JsfD8gOYlMGSTTjKX
         xnO6RFsOmJ87kyYj8Y9eu896s2O7bqe4w62EL+ac0CPOTAtjkGgZ2qacXL4dm4pKRSpr
         PCUMwm8u3moKBKEr7QGaEmQJlKpMh0mCEseXF7I11XTqaJbiGFSPKJESfMmZodu2i/oR
         QYPqmRpBaZLHkN20bhpxBG+/+Rq5KxXF0Q01AjgtpNMsgdi1YUBU1YzDCsLV1ar+U9cl
         syRAU3zym8gVBhGwJjtPPEPFJxN2lZ/HWuTwPtQe0MsVZJdo5TYgkHsh6MKr4Y9P7sit
         CF7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753173874; x=1753778674;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dPBkvCcfAeL2dNZt7wG4lYGcQyDWbM6vpCIRnJhXb7E=;
        b=YJDoYXOIu9BwKTwjrI/JYN4TUwYr06rmPZ/uJd0+jAn3k//awa/bklHsM1eNCYilQK
         INK8v5KAA6cA0RcSLaPm/WYwW4n4rmdb/E1fnndq8jznqK0ojYl/vu4hgDbaTmkxT6L1
         rSWn/eqhY2KcGTaHvPQlCT8wHnQ5sYGv/2FnfawtZJQRllHaKLaMV3IG/Ca0i4OZgSMz
         ReHHdfpnQ4CQ7EwFj+WIAOYjJl6qmLSPGyafj/xJi/plRCZ1+rQg2NYAq5T8Y+LVXe5s
         zjAe0+lTJsFJ/C5m2o1GxLeUSNLoUSF7ZM54KNdzBDwVegTKFpm3XVKxmenVr2rT/v2U
         7QIA==
X-Forwarded-Encrypted: i=1; AJvYcCWR81uCWkYm3EeKNNFByoXWhO7R9DlvROaHsGKFUmh/YmhZ1ZmrXn8lyZHKd4xZYqKO17w=@vger.kernel.org
X-Gm-Message-State: AOJu0YxAdotvYRpCq5airrypiNMqw1S2MnV365/kUCD3gutlSAeIRsxh
	hJTrALgg3VXxXNCzVKdxYelboyyj6V1Xx3dJU/8VwbnqGyZPpBJTl55EMQxLfWoihSShI6oAvqu
	9AlZnYPsF/3av/jUgJDv0TKZo9T3CHt7V1TiNnngw
X-Gm-Gg: ASbGncvrKtCXmmHYxw7AfC13b1hUMKjRPXB3j1jS77yUgpskkpSTS7bXNvS7Xz6sIc0
	7aEkuoqNZq272Jf96cXPFPT3UBPcNxj4vGDN/DaP3YLkzgIvsccE4qg8lxuWd2tX/4qkcLJFKNo
	JOFqRILUWiKhxC/0PJ/nhj9ny6Lxwuq9Sn35m/SUiJTwErO6AJen4uA5DdgbuloLZVh4OQKJrXj
	QF9ZCW9/HJtjTMXaU6g0dLkE6KksTyv/hTM
X-Google-Smtp-Source: AGHT+IHY1bLajV8cSDSr07UxvUVPof2BdmEX/z7/v1iwlDELsaBXQa7JYlT3T+HwWsQDpoA/9fVIqN/RA0gQKf3OZbM=
X-Received: by 2002:a05:622a:a916:b0:4aa:cba2:2e67 with SMTP id
 d75a77b69052e-4ae5f1c81b8mr2062111cf.21.1753173873334; Tue, 22 Jul 2025
 01:44:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250717162731.446579-1-tabba@google.com> <20250717162731.446579-14-tabba@google.com>
 <aH5vNqPrUFgtZCqU@google.com> <27ac6ed0-f58a-4926-a069-8d9d7d61a41c@intel.com>
In-Reply-To: <27ac6ed0-f58a-4926-a069-8d9d7d61a41c@intel.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 22 Jul 2025 09:43:56 +0100
X-Gm-Features: Ac12FXwo4G2roOXpkeQ9Jh58vNuaACeOHbQjO2y_a9aub1RVWWMkoayleVat1V8
Message-ID: <CA+EHjTzUr4K8SsvwANTkg7yd5mFZLbY1aSUB85zvd7wooizf_A@mail.gmail.com>
Subject: Re: [PATCH v15 13/21] KVM: x86/mmu: Handle guest page faults for
 guest_memfd with shared memory
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-mm@kvack.org, kvmarm@lists.linux.dev, pbonzini@redhat.com, 
	chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org, 
	akpm@linux-foundation.org, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
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
Content-Type: text/plain; charset="UTF-8"

On Tue, 22 Jul 2025 at 06:41, Xiaoyao Li <xiaoyao.li@intel.com> wrote:
>
> On 7/22/2025 12:47 AM, Sean Christopherson wrote:
> > On Thu, Jul 17, 2025, Fuad Tabba wrote:
> >> From: Ackerley Tng <ackerleytng@google.com>
> >>
> >> Update the KVM MMU fault handler to service guest page faults
> >> for memory slots backed by guest_memfd with mmap support. For such
> >> slots, the MMU must always fault in pages directly from guest_memfd,
> >> bypassing the host's userspace_addr.
> >>
> >> This ensures that guest_memfd-backed memory is always handled through
> >> the guest_memfd specific faulting path, regardless of whether it's for
> >> private or non-private (shared) use cases.
> >>
> >> Additionally, rename kvm_mmu_faultin_pfn_private() to
> >> kvm_mmu_faultin_pfn_gmem(), as this function is now used to fault in
> >> pages from guest_memfd for both private and non-private memory,
> >> accommodating the new use cases.
> >>
> >> Co-developed-by: David Hildenbrand <david@redhat.com>
> >> Signed-off-by: David Hildenbrand <david@redhat.com>
> >> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> >> Co-developed-by: Fuad Tabba <tabba@google.com>
> >> Signed-off-by: Fuad Tabba <tabba@google.com>
> >> ---
> >>   arch/x86/kvm/mmu/mmu.c | 13 +++++++++----
> >>   1 file changed, 9 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> >> index 94be15cde6da..ad5f337b496c 100644
> >> --- a/arch/x86/kvm/mmu/mmu.c
> >> +++ b/arch/x86/kvm/mmu/mmu.c
> >> @@ -4511,8 +4511,8 @@ static void kvm_mmu_finish_page_fault(struct kvm_vcpu *vcpu,
> >>                               r == RET_PF_RETRY, fault->map_writable);
> >>   }
> >>
> >> -static int kvm_mmu_faultin_pfn_private(struct kvm_vcpu *vcpu,
> >> -                                   struct kvm_page_fault *fault)
> >> +static int kvm_mmu_faultin_pfn_gmem(struct kvm_vcpu *vcpu,
> >> +                                struct kvm_page_fault *fault)
> >>   {
> >>      int max_order, r;
> >>
> >> @@ -4536,13 +4536,18 @@ static int kvm_mmu_faultin_pfn_private(struct kvm_vcpu *vcpu,
> >>      return RET_PF_CONTINUE;
> >>   }
> >>
> >> +static bool fault_from_gmem(struct kvm_page_fault *fault)
> >
> > Drop the helper.  It has exactly one caller, and it makes the code *harder* to
> > read, e.g. raises the question of what "from gmem" even means.  If a separate
> > series follows and needs/justifies this helper, then it can/should be added then.
>
> there is another place requires the same check introduced by your
> "KVM: x86/mmu: Extend guest_memfd's max mapping level to shared
> mappings" provided in [*]
>
> [*] https://lore.kernel.org/kvm/aH7KghhsjaiIL3En@google.com/

I guess this is meant for the patch [*], which as far as I could tell,
isn't in the latest (-rc7) yet.

Thanks,
/fuad

> ---
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 1ff7582d5fae..2d1894ed1623 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
>
> @@ -3335,8 +3336,9 @@ int kvm_mmu_max_mapping_level(struct kvm *kvm,
> struct kvm_page_fault *fault,
>          if (max_level == PG_LEVEL_4K)
>                  return PG_LEVEL_4K;
>
> -       if (is_private)
> -               host_level = kvm_max_private_mapping_level(kvm, fault,
> slot, gfn);
> +       if (is_private || kvm_memslot_is_gmem_only(slot))
> +               host_level = kvm_gmem_max_mapping_level(kvm, fault,
> slot, gfn,
> +                                                       is_private);
>          else
>                  host_level = host_pfn_mapping_level(kvm, gfn, slot);
>          return min(host_level, max_level);
>
> >> +{
> >> +    return fault->is_private || kvm_memslot_is_gmem_only(fault->slot);
> >> +}
> >> +
> >>   static int __kvm_mmu_faultin_pfn(struct kvm_vcpu *vcpu,
> >>                               struct kvm_page_fault *fault)
> >>   {
> >>      unsigned int foll = fault->write ? FOLL_WRITE : 0;
> >>
> >> -    if (fault->is_private)
> >> -            return kvm_mmu_faultin_pfn_private(vcpu, fault);
> >> +    if (fault_from_gmem(fault))
> >> +            return kvm_mmu_faultin_pfn_gmem(vcpu, fault);
> >>
> >>      foll |= FOLL_NOWAIT;
> >>      fault->pfn = __kvm_faultin_pfn(fault->slot, fault->gfn, foll,
> >> --
> >> 2.50.0.727.gbf7dc18ff4-goog
> >>
>
>

