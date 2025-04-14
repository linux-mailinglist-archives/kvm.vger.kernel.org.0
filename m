Return-Path: <kvm+bounces-43251-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D5A1EA887EF
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 18:04:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B4D0A1898356
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 16:04:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 116E82749EE;
	Mon, 14 Apr 2025 16:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="O1jAWWta"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FDD53FC2
	for <kvm@vger.kernel.org>; Mon, 14 Apr 2025 16:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744646636; cv=none; b=uz/xwS9823rq0FVqzVFJBAbI8A+PG2SyQJnOzEe91y9596xMnMGfUbVUmAH/SlELGMixpUybvakEZ/ZKimJeJtSXoF7E9ksEn79NJN3NynkTPyfxxV+hlCox8BoHa5S6v9Bminpsb06JrZYywuKB3XhQVvmssPPEkPfkSzfGIfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744646636; c=relaxed/simple;
	bh=gaI2o+IcMMRpu9zga35PMrGvI2/8TmKmZh7u0FxdbQo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AsqO+y/1/B2Wvp4HgMyy51QR/dTTg8QiV9+DdERLoAAjVt25ZIYHZFLlJa49RdboQJViXuT3zfeSL5hJ0fJ7LAivrlnKvxD1re+wXm3r+3ZjyEUqd0NffXuaMcwRoszotCDeNylz7UGEiInnxvO0VIaIjSTgsxoMuXoSIc8LsOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=O1jAWWta; arc=none smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-4769e30af66so730151cf.1
        for <kvm@vger.kernel.org>; Mon, 14 Apr 2025 09:03:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744646633; x=1745251433; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=VzyFZIEP6M1ohDkNBbb+oGqFZk64nQZeVuUKR+ZBZTs=;
        b=O1jAWWtaUdQ1+yEvvr+EIw78yiYTBRcEcv7E0jIuE1w5gLtVPIkCmbKMdTVi3Kvfcj
         9odHQqWejBvXffjsYDMzsdi8LiEag3DwpJIJH6a8X+wLHUop+LHNxxmSI1m4uuMjvY9q
         w79VsAzLYmug5Ht3rw/yOQXi1/7wrRp4oPJJnWEKOrHmackqZBThMd9Y7HEL9d3yPL5v
         +rF/kSKcg36X/+HBphNfgl2rxkNFdt+XU0fMrfJSIvcCaUCP2UIzBLQqCcd1I/w1IN46
         D21yJ8XD1hMjb5z5sBlPUIeBTcv2AXDGWuzn9hBgrwYj+TBW7PxDQ3in0gfdhONZqd7I
         0vsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744646633; x=1745251433;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VzyFZIEP6M1ohDkNBbb+oGqFZk64nQZeVuUKR+ZBZTs=;
        b=rT2rT3MSztezAN88bKfn43MYmHMy6L5yAjpYPwWyU7denHPLQzF7top7ujVPASy4OR
         ofMIDQGy1TBxncbYjrmVVVTzTxg2skVrAhfFXMubmxZiJt3GbSNsYrfyV7N9hPCHjv4w
         WVQewcoE/8/+s8krFUa24JJ07Xp624QLtn5zM33ZYJ/Xr087t0mB1//h9dV6m82xIlJJ
         FJHYbpdMJx2ibo1FG8DSKWwWLdV/So6WFz3IMoH30qhnffg8EwliaaxxR9i3u2Yte+w8
         nz+C795pIUQsfdFQO1EquBhQUjQ9ADebI3tknaC7QmmVLnDb3HLQtVJs0Zyb5GUYD2RG
         dklA==
X-Gm-Message-State: AOJu0YxhsjXeLlm+qiCw9Sa3F4PVoM1beLKnM8doFzCs41j+YSlAZS9S
	7Jrg2hju2I5G4GeuL43l37S0L17JuRJ7QwgFto/o71BM+b6hpYcxDj6DMAJB0VgH49idF1Tzosf
	s2kQd6jdkiszZ+1ts8+dhTBgmF5fHm0f4kYCY
X-Gm-Gg: ASbGncuCm6tVAYWyhKbfwrKvax5u5waoNeaJKSVtWl7llFKFfmupUhMHZE6oCmEy51F
	HgobojaSiiUZAIIaQxcp/cdGu5K8cE/Te2cx6RUA1mfnCs8zNCOzdoWQIlfcEbe6irk4z2kO+qr
	lhn8ccSz37YwHYrbldE0q59w==
X-Google-Smtp-Source: AGHT+IFJg8GPXWq1lSCl703rekQ9oedGzVrCfZbbes1E5yG1RkGoWHSg6Y0BmhLSzHoUCX0vCwJ/tUA/5BAi0+XC2Rk=
X-Received: by 2002:a05:622a:1a22:b0:477:2c1e:d252 with SMTP id
 d75a77b69052e-479815f5b60mr8970641cf.20.1744646632877; Mon, 14 Apr 2025
 09:03:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250318161823.4005529-1-tabba@google.com> <20250318161823.4005529-5-tabba@google.com>
 <8ebc66ae-5f37-44c0-884b-564a65467fe4@redhat.com>
In-Reply-To: <8ebc66ae-5f37-44c0-884b-564a65467fe4@redhat.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 14 Apr 2025 17:03:15 +0100
X-Gm-Features: ATxdqUGPHkmIlJ3xSXP2tJdh8AVRtpSMsm_dfz2QSKTlfggMkikmgGbgteWcNbQ
Message-ID: <CA+EHjTwjShH8vw-YsSmPk0yNY3akLFT3R9COtWLVgLozT_G7nA@mail.gmail.com>
Subject: Re: [PATCH v7 4/9] KVM: guest_memfd: Handle in-place shared memory as
 guest_memfd backed memory
To: David Hildenbrand <david@redhat.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
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
	quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com, 
	quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, 
	catalin.marinas@arm.com, james.morse@arm.com, yuzenghui@huawei.com, 
	oliver.upton@linux.dev, maz@kernel.org, will@kernel.org, qperret@google.com, 
	keirf@google.com, roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, 
	jgg@nvidia.com, rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, 
	hughd@google.com, jthoughton@google.com, peterx@redhat.com
Content-Type: text/plain; charset="UTF-8"

Hi David,

On Mon, 14 Apr 2025 at 12:51, David Hildenbrand <david@redhat.com> wrote:
>
> On 18.03.25 17:18, Fuad Tabba wrote:
> > For VMs that allow sharing guest_memfd backed memory in-place,
> > handle that memory the same as "private" guest_memfd memory. This
> > means that faulting that memory in the host or in the guest will
> > go through the guest_memfd subsystem.
> >
> > Note that the word "private" in the name of the function
> > kvm_mem_is_private() doesn't necessarily indicate that the memory
> > isn't shared, but is due to the history and evolution of
> > guest_memfd and the various names it has received. In effect,
> > this function is used to multiplex between the path of a normal
> > page fault and the path of a guest_memfd backed page fault.
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >   include/linux/kvm_host.h | 3 ++-
> >   1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index 601bbcaa5e41..3d5595a71a2a 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -2521,7 +2521,8 @@ static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
> >   #else
> >   static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
> >   {
> > -     return false;
> > +     return kvm_arch_gmem_supports_shared_mem(kvm) &&
> > +            kvm_slot_can_be_private(gfn_to_memslot(kvm, gfn));
> >   }
> >   #endif /* CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES */
> >
>
> I've been thinking long about this, and was wondering if we should instead
> clean up the code to decouple the "private" from gmem handling first.
>
> I know, this was already discussed a couple of times, but faking that
> shared memory is private looks odd.

I agree. I've been wanting to do that as part of a separate series,
since renaming discussions sometimes tend to take a disproportionate
amount of time. But the confusion the current naming (and overloading
of terms) is causing is probably worse.

>
> I played with the code to star cleaning this up. I ended up with the following
> gmem-terminology  cleanup patches (not even compile tested)
>
> KVM: rename CONFIG_KVM_GENERIC_PRIVATE_MEM to CONFIG_KVM_GENERIC_GMEM_POPULATE
> KVM: rename CONFIG_KVM_PRIVATE_MEM to CONFIG_KVM_GMEM
> KVM: rename kvm_arch_has_private_mem() to kvm_arch_supports_gmem()
> KVM: x86: rename kvm->arch.has_private_mem to kvm->arch.supports_gmem
> KVM: rename kvm_slot_can_be_private() to kvm_slot_has_gmem()
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

For me these changes seem to be reasonable all in all. I might want to
suggest a couple of modifications, but I guess the bigger question is
what the KVM maintainers and guest_memfd's main contributors think.

Also, how do you suggest we go about this? Send out a separate series
first, before continuing with the mapping series? Or have it all as
one big series? It could be something to add to the agenda for
Thursday.

Thanks,
/fuad
> --
> Cheers,
>
> David / dhildenb
>

