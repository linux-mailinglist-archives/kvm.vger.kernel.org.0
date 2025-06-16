Return-Path: <kvm+bounces-49573-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EE149ADA8A2
	for <lists+kvm@lfdr.de>; Mon, 16 Jun 2025 08:53:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0BD0D1891D0D
	for <lists+kvm@lfdr.de>; Mon, 16 Jun 2025 06:53:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1FEE1E2834;
	Mon, 16 Jun 2025 06:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Kt0+de6g"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0369D1AC88A
	for <kvm@vger.kernel.org>; Mon, 16 Jun 2025 06:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750056802; cv=none; b=ixE5s0eUuB3nuQQl9gmYuvE0OevU0n3mJzF1JOaMbTPWRETmADd5gp3N7nveLU+CYc08p+0P/I/+LvhNHGsc7K3Ee0LAWB1APp4/tMFeMxOMuGNISDhSpiY5PQMM46mSaJMjN49m5MhLPhSOLLvWxQCNZ19sQK4gsj9HKtcgL0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750056802; c=relaxed/simple;
	bh=ho9O6twFOJCkqdITUQ83uLD4KiqtndrdH4zc780Tgc8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HNCwfEl8jrTYVV1j6zLHp4DP/maM6xSMK4QJ+sZUDDPDLb+ZBjweMRJNEH34qvm0ultVEjXn3Mgz2Jbt+QQK4bSiaoFKgWqs46FoIS6mXTJbcS07azepjCkZeW1HxckUHwW3vvfpuGyfoOd7W+9IevDOjdps3zAmLvAPDXSTsio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Kt0+de6g; arc=none smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-47e9fea29easo450011cf.1
        for <kvm@vger.kernel.org>; Sun, 15 Jun 2025 23:53:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750056800; x=1750661600; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=FVEqVirFg5i6MzjRVG1snzVj/JgYlsQG5VsPw3Lo4N4=;
        b=Kt0+de6ghMsxRklsT79ssUSL5KGAWPYsuHhN7de9dwA8KkoW54kRstxw0Q0kPhTz0A
         iAY6Oji+LVfUgZg3AhODsDFQ/uMkIi1Xqo1AlxfAOiL60lzuDNrkLbFesj6csuKAryfv
         d954rF3VxmWgfAzzKT/r7MlqJ50S0i4g7CT8EL6ka5kFpnnInrGlZLAHGTtzKVpXJ3Q9
         l5X7n8iHHzKO1KUa72V5ysytn9uQDVTeI9gySlNEoO6Qe7ePOaIVsNFFKJs2Oesk4AZD
         qICe618aCeU0mYcljT49mSZCPPNA/GMmCIPc8P5YR/F6Zq5R7YnCXQLSU+U99SAUVzuE
         cQYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750056800; x=1750661600;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FVEqVirFg5i6MzjRVG1snzVj/JgYlsQG5VsPw3Lo4N4=;
        b=HWGuVURdBQWQAOL1i1ZGnsGHavdOrPLvdOCoA5DsL10is+AUmoRohm2rhYn33VPyCw
         Iwzgqk/De1sfQMF5XFeO2PX6R68FoCZg0Pu+2/WguNjxt52b81NQ9NIRr5Gyekco79TQ
         hi6dWwAOjAxNwFKjMyzG+7M3vrRPDOypIivcMSH/kJ1JHtfI2MxC3vaTSYsNlHPDRi3N
         f+5iQAZXGA4WuLRpgzE/Ohtqz9km3+7QyZK0wwREQ1T5fp83gDSUOLj6wucXA7ILcuaY
         5Sy8CbOGHS7290x53nrn8Yd7E/hgnx4B+GclMRjydYXJprkryErFTP/2RAvRzSSlBvaO
         7KlA==
X-Gm-Message-State: AOJu0YyEiiY68r29R09jZp6nUVOSSe0S6eeIxnbcSrWbtJh8T/Uy5pHb
	1fFzX6ifg9qN7fjPXaiYYLrLPU/tkut4E3k1I6MH2Yd55Rj+mZP80CCUnSLOFrcurEEIO3B/QV7
	Nj0cKWi/QTiJ05tXdw2aPkbOybt5/ht1bsL5nIDKDqm+jFRc4zcm3IJgcWC4=
X-Gm-Gg: ASbGncsVI5oP3drNkMhuk1v6b/CsUMP4AYG3EWEGv3JNiFy3bgUwpPcIFJ5T+xPPQzy
	xijK5wHrILIO31sFvuf+BoHNIB2YIoH8HmFbqM3oN2y1K6LXhyz6XSjsHglvRf+9LLamMSoar8K
	Wa2MhYZSTBSpjoiu3+ROdBeYhQFe5qpEY5caQaKNy/Vbw=
X-Google-Smtp-Source: AGHT+IE5hWQwTwh7MP9Du/GPZsQBHV+avpYUx4eqkYI8R99l7WlPl8ufgRsSCv2pUxGqQWRSQb1g5/J6MZjLIVn1B3Q=
X-Received: by 2002:a05:622a:1213:b0:476:f1a6:d8e8 with SMTP id
 d75a77b69052e-4a73f3c4871mr4666031cf.11.1750056799453; Sun, 15 Jun 2025
 23:53:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250611133330.1514028-1-tabba@google.com> <20250611133330.1514028-9-tabba@google.com>
 <aEySD5XoxKbkcuEZ@google.com>
In-Reply-To: <aEySD5XoxKbkcuEZ@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 16 Jun 2025 07:52:43 +0100
X-Gm-Features: AX0GCFvGKRmaMT01Ibh3HhY56fkma50qiBLdK32HOEYHz0uSWpQ07u962UNyKuk
Message-ID: <CA+EHjTyO1tP1uiVkoReZxvV6h2VwfX+1qxBT15JcP3+AXdB8fA@mail.gmail.com>
Subject: Re: [PATCH v12 08/18] KVM: guest_memfd: Allow host to map guest_memfd pages
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org, 
	mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
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

Hi Sean,

On Fri, 13 Jun 2025 at 22:03, Sean Christopherson <seanjc@google.com> wrote:
>
> On Wed, Jun 11, 2025, Fuad Tabba wrote:
> > This patch enables support for shared memory in guest_memfd, including
>
> Please don't lead with with "This patch", simply state what changes are being
> made as a command.

Ack.

> > mapping that memory from host userspace.
>
> > This functionality is gated by the KVM_GMEM_SHARED_MEM Kconfig option,
> > and enabled for a given instance by the GUEST_MEMFD_FLAG_SUPPORT_SHARED
> > flag at creation time.
>
> Why?  I can see that from the patch.

It's in the patch series, not this patch. Would it help if I rephrase
it along the lines of:

This functionality isn't enabled until the introduction of the
KVM_GMEM_SHARED_MEM Kconfig option, and enabled for a given instance
by the GUEST_MEMFD_FLAG_SUPPORT_SHARED flag at creation time. Both of
which are introduced in a subsequent patch.

> This changelog is way, way, waaay too light on details.  Sorry for jumping in at
> the 11th hour, but we've spent what, 2 years working on this?

I'll expand this. Just to make sure that I include the right details,
are you looking for implementation details, motivation, use cases?

> > Reviewed-by: Gavin Shan <gshan@redhat.com>
> > Acked-by: David Hildenbrand <david@redhat.com>
> > Co-developed-by: Ackerley Tng <ackerleytng@google.com>
> > Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> > diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> > index d00b85cb168c..cb19150fd595 100644
> > --- a/include/uapi/linux/kvm.h
> > +++ b/include/uapi/linux/kvm.h
> > @@ -1570,6 +1570,7 @@ struct kvm_memory_attributes {
> >  #define KVM_MEMORY_ATTRIBUTE_PRIVATE           (1ULL << 3)
> >
> >  #define KVM_CREATE_GUEST_MEMFD       _IOWR(KVMIO,  0xd4, struct kvm_create_guest_memfd)
> > +#define GUEST_MEMFD_FLAG_SUPPORT_SHARED      (1ULL << 0)
>
> I find the SUPPORT_SHARED terminology to be super confusing.  I had to dig quite
> deep to undesrtand that "support shared" actually mean "userspace explicitly
> enable sharing on _this_ guest_memfd instance".  E.g. I was surprised to see
>
> IMO, GUEST_MEMFD_FLAG_SHAREABLE would be more appropriate.  But even that is
> weird to me.  For non-CoCo VMs, there is no concept of shared vs. private.  What's
> novel and notable is that the memory is _mappable_.  Yeah, yeah, pKVM's use case
> is to share memory, but that's a _use case_, not the property of guest_memfd that
> is being controlled by userspace.
>
> And kvm_gmem_memslot_supports_shared() is even worse.  It's simply that the
> memslot is bound to a mappable guest_memfd instance, it's that the guest_memfd
> instance is the _only_ entry point to the memslot.
>
> So my vote would be "GUEST_MEMFD_FLAG_MAPPABLE", and then something like
> KVM_MEMSLOT_GUEST_MEMFD_ONLY.  That will make code like this:
>
>         if (kvm_slot_has_gmem(slot) &&
>             (kvm_gmem_memslot_supports_shared(slot) ||
>              kvm_get_memory_attributes(kvm, gfn) & KVM_MEMORY_ATTRIBUTE_PRIVATE)) {
>                 return kvm_gmem_max_mapping_level(slot, gfn, max_level);
>         }
>
> much more intutive:
>
>         if (kvm_is_memslot_gmem_only(slot) ||
>             kvm_get_memory_attributes(kvm, gfn) & KVM_MEMORY_ATTRIBUTE_PRIVATE))
>                 return kvm_gmem_max_mapping_level(slot, gfn, max_level);
>
> And then have kvm_gmem_mapping_order() do:
>
>         WARN_ON_ONCE(!kvm_slot_has_gmem(slot));
>         return 0;

I have no preference really. To me this was intuitive, but I guess I
have been staring at this way too long. If you and all the
stakeholders are happy with your suggested changes, then I am happy
making them :)


> >  struct kvm_create_guest_memfd {
> >       __u64 size;
> > diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
> > index 559c93ad90be..e90884f74404 100644
> > --- a/virt/kvm/Kconfig
> > +++ b/virt/kvm/Kconfig
> > @@ -128,3 +128,7 @@ config HAVE_KVM_ARCH_GMEM_PREPARE
> >  config HAVE_KVM_ARCH_GMEM_INVALIDATE
> >         bool
> >         depends on KVM_GMEM
> > +
> > +config KVM_GMEM_SHARED_MEM
> > +       select KVM_GMEM
> > +       bool
> > diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> > index 6db515833f61..06616b6b493b 100644
> > --- a/virt/kvm/guest_memfd.c
> > +++ b/virt/kvm/guest_memfd.c
> > @@ -312,7 +312,77 @@ static pgoff_t kvm_gmem_get_index(struct kvm_memory_slot *slot, gfn_t gfn)
> >       return gfn - slot->base_gfn + slot->gmem.pgoff;
> >  }
> >
> > +static bool kvm_gmem_supports_shared(struct inode *inode)
> > +{
> > +     const u64 flags = (u64)inode->i_private;
> > +
> > +     if (!IS_ENABLED(CONFIG_KVM_GMEM_SHARED_MEM))
> > +             return false;
> > +
> > +     return flags & GUEST_MEMFD_FLAG_SUPPORT_SHARED;
> > +}
> > +
> > +static vm_fault_t kvm_gmem_fault_shared(struct vm_fault *vmf)
>
> And to my point about "shared", this is also very confusing, because there are
> zero checks in here about shared vs. private.

As you noted in a later email, it was you who suggested this name, but
like I said, I am happy to change it.

> > +{
> > +     struct inode *inode = file_inode(vmf->vma->vm_file);
> > +     struct folio *folio;
> > +     vm_fault_t ret = VM_FAULT_LOCKED;
> > +
> > +     if (((loff_t)vmf->pgoff << PAGE_SHIFT) >= i_size_read(inode))
> > +             return VM_FAULT_SIGBUS;
> > +
> > +     folio = kvm_gmem_get_folio(inode, vmf->pgoff);
> > +     if (IS_ERR(folio)) {
> > +             int err = PTR_ERR(folio);
> > +
> > +             if (err == -EAGAIN)
> > +                     return VM_FAULT_RETRY;
> > +
> > +             return vmf_error(err);
> > +     }
> > +
> > +     if (WARN_ON_ONCE(folio_test_large(folio))) {
> > +             ret = VM_FAULT_SIGBUS;
> > +             goto out_folio;
> > +     }
> > +
> > +     if (!folio_test_uptodate(folio)) {
> > +             clear_highpage(folio_page(folio, 0));
> > +             kvm_gmem_mark_prepared(folio);
> > +     }
> > +
> > +     vmf->page = folio_file_page(folio, vmf->pgoff);
> > +
> > +out_folio:
> > +     if (ret != VM_FAULT_LOCKED) {
> > +             folio_unlock(folio);
> > +             folio_put(folio);
> > +     }
> > +
> > +     return ret;
> > +}
> > +
> > +static const struct vm_operations_struct kvm_gmem_vm_ops = {
> > +     .fault = kvm_gmem_fault_shared,
> > +};
> > +
> > +static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma)
> > +{
> > +     if (!kvm_gmem_supports_shared(file_inode(file)))
> > +             return -ENODEV;
> > +
> > +     if ((vma->vm_flags & (VM_SHARED | VM_MAYSHARE)) !=
> > +         (VM_SHARED | VM_MAYSHARE)) {
>
> And the SHARED terminology gets really confusing here, due to colliding with the
> existing notion of SHARED file mappings.

Ack.

Before I respin, let's make sure we're all on the same page in terms
of terminology. Hopefully David can chime in again now that he's had
the weekend to ponder over the latest exchange :)

Thanks,
/fuad

> > +             return -EINVAL;
> > +     }
> > +
> > +     vma->vm_ops = &kvm_gmem_vm_ops;
> > +
> > +     return 0;
> > +}
> > +
> >  static struct file_operations kvm_gmem_fops = {
> > +     .mmap           = kvm_gmem_mmap,
> >       .open           = generic_file_open,
> >       .release        = kvm_gmem_release,
> >       .fallocate      = kvm_gmem_fallocate,
> > @@ -463,6 +533,9 @@ int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args)
> >       u64 flags = args->flags;
> >       u64 valid_flags = 0;
> >
> > +     if (kvm_arch_supports_gmem_shared_mem(kvm))
> > +             valid_flags |= GUEST_MEMFD_FLAG_SUPPORT_SHARED;
> > +
> >       if (flags & ~valid_flags)
> >               return -EINVAL;
> >
> > --
> > 2.50.0.rc0.642.g800a2b2222-goog
> >

