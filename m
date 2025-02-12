Return-Path: <kvm+bounces-37957-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 52C67A321F5
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2025 10:22:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9705F7A1F2F
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2025 09:21:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05781205E2B;
	Wed, 12 Feb 2025 09:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="K2p23CMf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 601F2204C03
	for <kvm@vger.kernel.org>; Wed, 12 Feb 2025 09:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739352127; cv=none; b=XbWtDK419U3tyh0WTwlj+cRR2z2OP3H0LiuqwvR9BS2RvpBz5/OUNGnIdVJvUXizEDXq9CMsODZHhvE6og+3Q9cftsOcU65txJxBDdNxhI9j54amB+7nSSTvMKj1dZWw65j+wsh1fobvWlDoG3errOXUqMR0SYDw1TJWBL+Za8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739352127; c=relaxed/simple;
	bh=+PjDjQJHqTJaKq8gcJWoVss+6j4pPeODuopvXSr4CZ4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=phLgWYklGFd6AJfbcea14vLtG0WmDwJxsprKC/Fo9mLjp3aq6kh3zu3wRuJqR4F5Gpg1HC7Woi2+z8f1lT4bK5adDtNsagy0Wi3DpDgEUh6PsXYvCbVv5PG4CbctkdF2LT/MgVQQMQqQFD2Sqmr5Yv1FMKt/sxauTqOJfr+8MBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=K2p23CMf; arc=none smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-4718aea0718so251981cf.0
        for <kvm@vger.kernel.org>; Wed, 12 Feb 2025 01:22:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739352124; x=1739956924; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=dKYEyxBuKcUxq/NwCgSZb1M5YkMm6GBK5DoOiz1mWzs=;
        b=K2p23CMfB3loht8nGj1I4/lWeIx3Bp6BpNxZj+nnv5BF0nQ+vfWGi0qiDxsVZU5YsA
         DogW6VOgdrgKlsragJSVJg2T8sOVv9cVcpwyYxIOMxFDK/pczR0wG1Ch8E+2PG6fF1IK
         QFoys5YeRQrYxqwMUL+aY6vX8JQOka+q3eCdHYxl9Fo3MsMc8ACTX/tzKSFk3bSLmEut
         7ArE6LTtciMZOxN5XZWMgFJ8ET1grOTwh3W/WcjV9e0cY+Mmdea04yH15kqHN3oJXdg6
         oyfIDfQ/P6Ctfu7wjaWMQtPxPCBr7JY4+tbHj3Y+DqgQL0VPm+Rf/giQp6ou4ZLB7PUl
         JDRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739352124; x=1739956924;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dKYEyxBuKcUxq/NwCgSZb1M5YkMm6GBK5DoOiz1mWzs=;
        b=LQlVr2WiTU7VnM7Gj/K+trijzPYVknHgUileQQolDjam8OjiDXOrGlD1CCspNvsRHV
         y0DuUaxXXgLzLoUKdvAD5Nf7eXaMoN+yBMq0VtTA5cxdHeJHph78poWB5u0bddTiI/yn
         1T5rpbur2jLhMCarLdy1VD4nFGTD827ywb09+AdrmqROSQEf3qacMTKcL33yzdBFI7LN
         T4ViTB8zttsaw+UnTfe2/h0UfB1WjHLe/Z0EXuEv4smiHjEwdZeO50ubXMN0FtQhi7Sj
         lywwGnuFxMrQ+/VCL7oR9soQwKlbfOQ+w3Pcyfw5xZPSFrKf34c25lyk2GGYMNYNCZv8
         +O6A==
X-Gm-Message-State: AOJu0YwKHQWhS0aXutO2qUtWzv6RuE2zHYW7ASWAO8SimibUJ8K5OAfR
	I83ER9oZCKqLmSgLcrstUQqOI0EiHUgX3Ufi92TCwEzU6LKAN5lW/WYaOZSNre6EbD67MPS6rIw
	9k8SmNvgrMGZfnGkrU2+ZNipslb/jedAso7Mk
X-Gm-Gg: ASbGnctDyYNk5ozPBRLtMsoj5l7Yddn2j9zUne/dAFzrG1UkwlLoEIHWylItvU2Tu8X
	2SXRaHLQB482JCTrNaY3Mrs8v3t35pgm7xe9y4tcdljswH/cQnwCowu99fGEsAUJxandIF4WAQq
	MnHTDyoOrOIM38p7dbcBzD/nUIwA==
X-Google-Smtp-Source: AGHT+IGSFFm16+c+j2RVCupUZzDXJ7KybX7ZtoH3oU2TdEZ+Vv4L4tzWJV3CaxlZx/ZvjoHgFKOm3DHyO3nyJv/aqkQ=
X-Received: by 2002:a05:622a:5192:b0:466:8f39:fc93 with SMTP id
 d75a77b69052e-471b1c0136emr2039141cf.3.1739352123901; Wed, 12 Feb 2025
 01:22:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250211121128.703390-4-tabba@google.com> <diqzed0392dz.fsf@ackerleytng-ctop.c.googlers.com>
In-Reply-To: <diqzed0392dz.fsf@ackerleytng-ctop.c.googlers.com>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 12 Feb 2025 09:21:27 +0000
X-Gm-Features: AWEUYZmPf_xLnwm4A9iaW62B0o_6QVplSidwJVSQ9a3e8sP5ZkCQV2ZPhlG2MAg
Message-ID: <CA+EHjTyN66o_UJjimzEbcx6Q+QAH0SVDOfr+vZDvaHHYFKpErg@mail.gmail.com>
Subject: Re: [PATCH v3 03/11] KVM: guest_memfd: Allow host to map
 guest_memfd() pages
To: Ackerley Tng <ackerleytng@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, mail@maciej.szmigiero.name, 
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
	jthoughton@google.com
Content-Type: text/plain; charset="UTF-8"

Hi Ackerley,

On Wed, 12 Feb 2025 at 05:07, Ackerley Tng <ackerleytng@google.com> wrote:
>
> Fuad Tabba <tabba@google.com> writes:
>
> > Add support for mmap() and fault() for guest_memfd backed memory
> > in the host for VMs that support in-place conversion between
> > shared and private (shared memory). To that end, this patch adds
> > the ability to check whether the VM type has that support, and
> > only allows mapping its memory if that's the case.
> >
> > Additionally, this behavior is gated with a new configuration
> > option, CONFIG_KVM_GMEM_SHARED_MEM.
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> >
> > ---
> >
> > This patch series will allow shared memory support for software
> > VMs in x86. It will also introduce a similar VM type for arm64
> > and allow shared memory support for that. In the future, pKVM
> > will also support shared memory.
>
> Thanks, I agree that introducing mmap this way could help in having it
> merged earlier, independently of conversion support, to support testing.
>
> I'll adopt this patch in the next revision of 1G page support for
> guest_memfd.
>
> > ---
> >  include/linux/kvm_host.h | 11 +++++
> >  virt/kvm/Kconfig         |  4 ++
> >  virt/kvm/guest_memfd.c   | 93 ++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 108 insertions(+)
> >
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index 8b5f28f6efff..438aa3df3175 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -728,6 +728,17 @@ static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
> >  }
> >  #endif
> >
> > +/*
> > + * Arch code must define kvm_arch_gmem_supports_shared_mem if support for
> > + * private memory is enabled and it supports in-place shared/private conversion.
> > + */
> > +#if !defined(kvm_arch_gmem_supports_shared_mem) && !IS_ENABLED(CONFIG_KVM_PRIVATE_MEM)
> > +static inline bool kvm_arch_gmem_supports_shared_mem(struct kvm *kvm)
> > +{
> > +     return false;
> > +}
> > +#endif
>
> Perhaps this could be declared in the #ifdef CONFIG_KVM_PRIVATE_MEM
> block?
>
> Could this be defined as a __weak symbol for architectures to override?
> Or perhaps that can be done once guest_memfd gets refactored separately
> since now the entire guest_memfd.c isn't even compiled if
> CONFIG_KVM_PRIVATE_MEM is not set.

I don't have a strong opinion about this. I did it this way because
that's what the existing code for kvm_arch_has_private_mem() is like.
It seemed logical to follow that pattern.

> > +
> >  #ifndef kvm_arch_has_readonly_mem
> >  static inline bool kvm_arch_has_readonly_mem(struct kvm *kvm)
> >  {
> > diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
> > index 54e959e7d68f..4e759e8020c5 100644
> > --- a/virt/kvm/Kconfig
> > +++ b/virt/kvm/Kconfig
> > @@ -124,3 +124,7 @@ config HAVE_KVM_ARCH_GMEM_PREPARE
> >  config HAVE_KVM_ARCH_GMEM_INVALIDATE
> >         bool
> >         depends on KVM_PRIVATE_MEM
> > +
> > +config KVM_GMEM_SHARED_MEM
> > +       select KVM_PRIVATE_MEM
> > +       bool
> > diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> > index c6f6792bec2a..85467a3ef8ea 100644
> > --- a/virt/kvm/guest_memfd.c
> > +++ b/virt/kvm/guest_memfd.c
> > @@ -317,9 +317,102 @@ void kvm_gmem_handle_folio_put(struct folio *folio)
> >  {
> >       WARN_ONCE(1, "A placeholder that shouldn't trigger. Work in progress.");
> >  }
> > +
> > +static bool kvm_gmem_offset_is_shared(struct file *file, pgoff_t index)
> > +{
> > +     struct kvm_gmem *gmem = file->private_data;
> > +
> > +     /* For now, VMs that support shared memory share all their memory. */
> > +     return kvm_arch_gmem_supports_shared_mem(gmem->kvm);
> > +}
> > +
> > +static vm_fault_t kvm_gmem_fault(struct vm_fault *vmf)
> > +{
> > +     struct inode *inode = file_inode(vmf->vma->vm_file);
> > +     struct folio *folio;
> > +     vm_fault_t ret = VM_FAULT_LOCKED;
> > +
> > +     filemap_invalidate_lock_shared(inode->i_mapping);
> > +
> > +     folio = kvm_gmem_get_folio(inode, vmf->pgoff);
> > +     if (IS_ERR(folio)) {
> > +             ret = VM_FAULT_SIGBUS;
>
> Will it always be a SIGBUS if there is some error getting a folio?

I could try to expand it, and map more of the VM_FAULT_* to the
potential return values from __filemap_get_folio(), i.e.,

-EAGAIN -> VM_FAULT_RETRY
-ENOMEM -> VM_FAULT_OOM

but some don't really map 1:1 if you read the description. For example
is it correct to map
-ENOENT -> VM_FAULT_NOPAGE /* fault installed the pte, not return page */

That said, it might be useful to map at least EAGAIN and ENOMEM.

> > +             goto out_filemap;
> > +     }
> > +
> > +     if (folio_test_hwpoison(folio)) {
> > +             ret = VM_FAULT_HWPOISON;
> > +             goto out_folio;
> > +     }
> > +
> > +     /* Must be called with folio lock held, i.e., after kvm_gmem_get_folio() */
> > +     if (!kvm_gmem_offset_is_shared(vmf->vma->vm_file, vmf->pgoff)) {
> > +             ret = VM_FAULT_SIGBUS;
> > +             goto out_folio;
> > +     }
> > +
> > +     /*
> > +      * Only private folios are marked as "guestmem" so far, and we never
> > +      * expect private folios at this point.
> > +      */
>
> Proposal - rephrase this comment as: before typed folios can be mapped,
> PGTY_guestmem is only tagged on folios so that guest_memfd will receive
> the kvm_gmem_handle_folio_put() callback. The tag is definitely not
> expected when a folio is about to be faulted in.
>
> I propose the above because I think technically when mappability is NONE
> the folio isn't private? Not sure if others see this differently.

A folio whose mappability is NONE is private as far as the host is
concerned. That said, I can rephrase this for clarity.


> > +     if (WARN_ON_ONCE(folio_test_guestmem(folio)))  {
> > +             ret = VM_FAULT_SIGBUS;
> > +             goto out_folio;
> > +     }
> > +
> > +     /* No support for huge pages. */
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
> > +out_filemap:
> > +     filemap_invalidate_unlock_shared(inode->i_mapping);
> > +
> > +     return ret;
> > +}
> > +
> > +static const struct vm_operations_struct kvm_gmem_vm_ops = {
> > +     .fault = kvm_gmem_fault,
> > +};
> > +
> > +static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma)
> > +{
> > +     struct kvm_gmem *gmem = file->private_data;
> > +
> > +     if (!kvm_arch_gmem_supports_shared_mem(gmem->kvm))
> > +             return -ENODEV;
> > +
> > +     if ((vma->vm_flags & (VM_SHARED | VM_MAYSHARE)) !=
> > +         (VM_SHARED | VM_MAYSHARE)) {
> > +             return -EINVAL;
> > +     }
> > +
> > +     file_accessed(file);
> > +     vm_flags_set(vma, VM_DONTDUMP);
> > +     vma->vm_ops = &kvm_gmem_vm_ops;
> > +
> > +     return 0;
> > +}
> > +#else
> > +#define kvm_gmem_mmap NULL
> >  #endif /* CONFIG_KVM_GMEM_SHARED_MEM */
> >
> >  static struct file_operations kvm_gmem_fops = {
> > +     .mmap           = kvm_gmem_mmap,
>
> I think it's better to surround this with #ifdef
> CONFIG_KVM_GMEM_SHARED_MEM so that when more code gets inserted between
> the struct declaration and the definition of kvm_gmem_mmap() it is more
> obvious that .mmap is only overridden when CONFIG_KVM_GMEM_SHARED_MEM is
> set.

This is a question of style, but I prefer this because it avoids
having more ifdefs. I think that I've seen this pattern elsewhere in
the kernel. That said, if others disagree, I'm happy to change this.

Thank you,
/fuad
>
> >       .open           = generic_file_open,
> >       .release        = kvm_gmem_release,
> >       .fallocate      = kvm_gmem_fallocate,

