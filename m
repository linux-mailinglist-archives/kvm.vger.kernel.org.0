Return-Path: <kvm+bounces-52271-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A348B0383B
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 09:43:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CC635168A47
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 07:43:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27E852264D4;
	Mon, 14 Jul 2025 07:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="a6n9dcXW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAD003D76
	for <kvm@vger.kernel.org>; Mon, 14 Jul 2025 07:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752479029; cv=none; b=VSOLcxzo+lmhRPJPEAtl0hqol4q44sqJm84SdGj5UFCVSiV/+nzVLnFMa6GdezOIYV8tp83ZiCUIHD8Qycan9pnNxVI0Kn0gGJAKz2Jp9tKK6fnMvbQqUrnvg/qhlKejqrTkPNWb/MK+jeeiiNd93OpYZ4kAUtw0urJB4oe9NmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752479029; c=relaxed/simple;
	bh=72mcn/0aA36J4IDVjbzyIq+5WtdsSwvXzhtQrJVppjU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=e2dIXxYAxQylS/k1c+WYsQrh19GqB+MkwmHPmyDuh7qMxvs1bySmMlcC2HFW8IBAGbgY1kOedOQBb9bTlCJYSQ4x7IPKkei0xWd0WjBNsaMFGohiwibzdNCKU3NwJsIwpP7EzQLEy5V4u3DgkxuuRpOubijSs0BDubN6CbUcSVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=a6n9dcXW; arc=none smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-4ab3855fca3so612721cf.1
        for <kvm@vger.kernel.org>; Mon, 14 Jul 2025 00:43:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752479026; x=1753083826; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=c3n8ur35WlJXxN48wV7a1ksueuqBtEVY/pvsx7vZS2c=;
        b=a6n9dcXWblTgZBt50AgxpNTo/lZ2CjHRMWpCjXqOK2JSFYM7hXJGnBj0QaUCw2YiDe
         UdxJ36bW1cRyCPHZ6ZzpNQdxTkeMOGQjc9rZ7mhvzz1SrJV0yyuLlZagh0Dq1KnJGUPs
         2yIo/CLfR/xZCiT55wEtM6S1zuJm5cpyo1wPcOkPs+5hvvw3GORctBvbqaR6mdmTy+rv
         Nz91dz+bN46Pn6hLVh0PCsRnT6+VsPrvSAJJzqfiiHaR/jbuGMwGut5p46I/gNaEYQL9
         GI/N7lEcyCGrOHng6nCfrWemzab+KYbIEMyQg0W69LREAVJ0rZx8EvhKF7OvdA9SgmwA
         30LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752479026; x=1753083826;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=c3n8ur35WlJXxN48wV7a1ksueuqBtEVY/pvsx7vZS2c=;
        b=igfl9SZWl0gkFNPqrbvo/dBGJcytVkSyxxXQxH/eK93fKoX3AsOuU2aIRUiV3oHsyE
         XBOSj5iMuKo/4h14fMIwIEHfivPJf0AlLR43x7LLo66X8wMcotXIslE8R1C/mgS38Eil
         P8UFIy8g6xMFm/LAZNDfxom7PEPqV88X5EqXchaVcAcpjQRqlwxy1/iF6ltt5icxCUQs
         t5nQ5lwJGxLgAmq2Btg0oNe7yaXkDhtTES3bvJeG4rmMH06db71dzm9IJwfyGeSwo5wf
         NT9b79WmbS6HwwTdmiCcVactVFD/e+gutmIi+RcuSB2jkNbkQxFIi3SHJAbnLHnIoY+l
         kAxQ==
X-Gm-Message-State: AOJu0YzKBdLATVDzZ3zWjLHRHs+erLCT4SQvs/S/JWENHcQCedmPPMu6
	pk95pFaURUO9mPilONjkVER6jzEfjFznq+c6QKUa1mVJ23UxtXliOZt9R/HagaPNuqE31V+Hke5
	TK4T2E85aODj4yJCBUuU5rnDzoabC1XajzfJnDUjD
X-Gm-Gg: ASbGncs8P4oQJGcbuPZCN+Hf1k8T+iZxgNsohj2SagiswcGRcCpRDFUGUO6+0lW4OIW
	jnZlzkJb+9Lm7Ab6joIFv0McYvA6Lq0X2jU0LOZd/3wsMD6UQMlcKeBYjaZWcAmigSYreLz0PbY
	xGXYIkeEbuMDQUjPqCW+GrKXeSmvHOqcWwl/MuN3N3vorTR2QMUbj90GIlNE9akCuW70KckgYFw
	uV07ZM=
X-Google-Smtp-Source: AGHT+IHZIX9RI0TnyvMf+ARf3WYRNyQhLo11e35YR15synL7j0UDgLvWSoCAnl1yZlle4Zkk5jSk1V0g6QRxltnOhdE=
X-Received: by 2002:ac8:7fc6:0:b0:48d:8f6e:ece7 with SMTP id
 d75a77b69052e-4ab544362a6mr4595061cf.3.1752479023731; Mon, 14 Jul 2025
 00:43:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250709105946.4009897-1-tabba@google.com> <20250709105946.4009897-17-tabba@google.com>
 <865xfyadjv.wl-maz@kernel.org>
In-Reply-To: <865xfyadjv.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 14 Jul 2025 08:42:00 +0100
X-Gm-Features: Ac12FXyjoYpzT_P-oaUrzRgkOcTbxS1Ta0rucFG3EteXkZMxtRhRlP_YmBV37o0
Message-ID: <CA+EHjTyJGWJ0Pj-jPjriFjy3JHpVUa0PW0vQz4o8UPdLbMV7pg@mail.gmail.com>
Subject: Re: [PATCH v13 16/20] KVM: arm64: Handle guest_memfd-backed guest
 page faults
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org, 
	mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, seanjc@google.com, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org, 
	akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com, 
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com, 
	dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com, 
	mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	will@kernel.org, qperret@google.com, keirf@google.com, roypat@amazon.co.uk, 
	shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, rientjes@google.com, 
	jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, jthoughton@google.com, 
	peterx@redhat.com, pankaj.gupta@amd.com, ira.weiny@intel.com
Content-Type: text/plain; charset="UTF-8"

Hi Marc,


On Fri, 11 Jul 2025 at 17:38, Marc Zyngier <maz@kernel.org> wrote:
>
> On Wed, 09 Jul 2025 11:59:42 +0100,
> Fuad Tabba <tabba@google.com> wrote:
> >
> > Add arm64 architecture support for handling guest page faults on memory
> > slots backed by guest_memfd.
> >
> > This change introduces a new function, gmem_abort(), which encapsulates
> > the fault handling logic specific to guest_memfd-backed memory. The
> > kvm_handle_guest_abort() entry point is updated to dispatch to
> > gmem_abort() when a fault occurs on a guest_memfd-backed memory slot (as
> > determined by kvm_slot_has_gmem()).
> >
> > Until guest_memfd gains support for huge pages, the fault granule for
> > these memory regions is restricted to PAGE_SIZE.
> >
> > Reviewed-by: Gavin Shan <gshan@redhat.com>
> > Reviewed-by: James Houghton <jthoughton@google.com>
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/arm64/kvm/mmu.c | 82 ++++++++++++++++++++++++++++++++++++++++++--
> >  1 file changed, 79 insertions(+), 3 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index 58662e0ef13e..71f8b53683e7 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -1512,6 +1512,78 @@ static void adjust_nested_fault_perms(struct kvm_s2_trans *nested,
> >       *prot |= kvm_encode_nested_level(nested);
> >  }
> >
> > +#define KVM_PGTABLE_WALK_MEMABORT_FLAGS (KVM_PGTABLE_WALK_HANDLE_FAULT | KVM_PGTABLE_WALK_SHARED)
> > +
> > +static int gmem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> > +                   struct kvm_s2_trans *nested,
> > +                   struct kvm_memory_slot *memslot, bool is_perm)
> > +{
> > +     bool write_fault, exec_fault, writable;
> > +     enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_MEMABORT_FLAGS;
> > +     enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
> > +     struct kvm_pgtable *pgt = vcpu->arch.hw_mmu->pgt;
> > +     struct page *page;
> > +     struct kvm *kvm = vcpu->kvm;
> > +     void *memcache;
> > +     kvm_pfn_t pfn;
> > +     gfn_t gfn;
> > +     int ret;
> > +
> > +     ret = prepare_mmu_memcache(vcpu, true, &memcache);
> > +     if (ret)
> > +             return ret;
> > +
> > +     if (nested)
> > +             gfn = kvm_s2_trans_output(nested) >> PAGE_SHIFT;
> > +     else
> > +             gfn = fault_ipa >> PAGE_SHIFT;
> > +
> > +     write_fault = kvm_is_write_fault(vcpu);
> > +     exec_fault = kvm_vcpu_trap_is_exec_fault(vcpu);
> > +
> > +     if (write_fault && exec_fault) {
> > +             kvm_err("Simultaneous write and execution fault\n");
> > +             return -EFAULT;
> > +     }
>
> I don't think we need to cargo-cult this stuff. This cannot happen
> architecturally (data and instruction aborts are two different
> exceptions, so you can't have both at the same time), and is only
> there because we were young and foolish when we wrote this crap.
>
> Now that we (the royal We) are only foolish, we can save a few bits by
> dropping it. Or turn it into a VM_BUG_ON() if you really want to keep
> it.

Will do, but if you agree, I'll go with a VM_WARN_ON_ONCE() since
VM_BUG_ON is going away [1][2]

[1] https://lore.kernel.org/all/b247be59-c76e-4eb8-8a6a-f0129e330b11@redhat.com/
[2] https://lore.kernel.org/all/20250604140544.688711-1-david@redhat.com/T/#u


> > +
> > +     if (is_perm && !write_fault && !exec_fault) {
> > +             kvm_err("Unexpected L2 read permission error\n");
> > +             return -EFAULT;
> > +     }
>
> Again, this is copying something that was always a bit crap:
>
> - it's not an "error", it's a permission fault
> - it's not "L2", it's "stage-2"
>
> But this should equally be turned into an assertion, ideally in a
> single spot. See below for the usual untested hack.

Will do, but like above, with VM_WARN_ON_ONCE() if you agree.

Thanks!
/fuad

> Thanks,
>
>         M.
>
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index b92ce4d9b4e01..c79dc8fd45d5a 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1540,16 +1540,7 @@ static int gmem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>
>         write_fault = kvm_is_write_fault(vcpu);
>         exec_fault = kvm_vcpu_trap_is_exec_fault(vcpu);
> -
> -       if (write_fault && exec_fault) {
> -               kvm_err("Simultaneous write and execution fault\n");
> -               return -EFAULT;
> -       }
> -
> -       if (is_perm && !write_fault && !exec_fault) {
> -               kvm_err("Unexpected L2 read permission error\n");
> -               return -EFAULT;
> -       }
> +       VM_BUG_ON(write_fault && exec_fault);
>
>         ret = kvm_gmem_get_pfn(kvm, memslot, gfn, &pfn, &page, NULL);
>         if (ret) {
> @@ -1616,11 +1607,6 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>         exec_fault = kvm_vcpu_trap_is_exec_fault(vcpu);
>         VM_BUG_ON(write_fault && exec_fault);
>
> -       if (fault_is_perm && !write_fault && !exec_fault) {
> -               kvm_err("Unexpected L2 read permission error\n");
> -               return -EFAULT;
> -       }
> -
>         /*
>          * Permission faults just need to update the existing leaf entry,
>          * and so normally don't require allocations from the memcache. The
> @@ -2035,6 +2021,9 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
>                 goto out_unlock;
>         }
>
> +       VM_BUG_ON(kvm_vcpu_trap_is_permission_fault(vcpu) &&
> +                 !write_fault && !kvm_vcpu_trap_is_exec_fault(vcpu));
> +
>         if (kvm_slot_has_gmem(memslot))
>                 ret = gmem_abort(vcpu, fault_ipa, nested, memslot,
>                                  esr_fsc_is_permission_fault(esr));
>
> --
> Without deviation from the norm, progress is not possible.

