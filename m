Return-Path: <kvm+bounces-41205-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 64408A64ABF
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 11:49:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B0A7B3B0D8E
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 10:44:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EAE4233704;
	Mon, 17 Mar 2025 10:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XKrmPzL4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0498A157A48
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 10:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742208215; cv=none; b=R2+2AbWk3mFpsaS/R9vAC5v8p3/jSh5o5ZDh2VW7xRaoivD+ZimBxPuxVWRwThlAzWsTI7O9vwmFLP9A4QU9Vsv1z5kkxRwYapLYeIt53E9NkcBbT0+X0Y5+FFtVRj6+v+HcgbzbIAU+6mZYtawbP6MOooxBswMoVC9zPdBI7TI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742208215; c=relaxed/simple;
	bh=cJU8xVaXixTy6H2IvwOVaVI1NmLXCSQZ1WlcAizNK24=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HqOEkR5Q7snsWRbbqBhgbxDQI39NUA0d9LU0RsBci3p1gQWUyeRGgJFOBakzAJtSnHSxOVic9YhFiwIZWKX9SvCv+cYyf1X8rHtklBnNPXsmtN5BU3MXBSVu7OqTNcyAYt5eu7XtdaB16qVd+EoeoOMv5L8chM23Di1VZMRoAzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XKrmPzL4; arc=none smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-47666573242so725621cf.0
        for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 03:43:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1742208213; x=1742813013; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=XXsl8Znc7YaVQPIO4zvfdKc88bAEyrTJ9gyCn16OGIs=;
        b=XKrmPzL4rhAgtRgGiyz0b1jS3wGfGhuZavWP/76BSNpthAt80Sa9OmVdoVyiQP9RS3
         8PAV2n3k/juRggJVK0xr73uwqFQM8+neIUMGXFEM0byNju3eceEJPojgf/zM7Odn5dxF
         75UZq6X731bNNkT3+DoG/T5h5FQi14q1tNu5XraogYkq/06BGcppen7BE+sY2RxYE228
         AWPGCV4EQ8b4kAGbJT55lwdzIPCef5sSJD1k94bbuQd/1w8831u2q46CioYffTLoqIrK
         Ehwk8j8g5jOKjnZLucGcb04rhijYxtTTYg+Hsrn611iqb71OuwmuZy+1sy1FyzeZnSpO
         CDAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742208213; x=1742813013;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XXsl8Znc7YaVQPIO4zvfdKc88bAEyrTJ9gyCn16OGIs=;
        b=iA5ckhUyIOgU76tHScvUOrHvAaHqN09sc9Mp6phMgcFMRxW7QBu++2slw5HMlPvZXW
         r31GMPw8HkRnPCk+asTRsBUhJlgCMGAY2HxGYyzkZkhhOAiwKMLLsB7WUJZWADOVoFL2
         nxECor2GH1ejPctzoAtVbV4Fx5t/haiqOU0brpQAhTvTNRp7gH77ue0nlJZ7+xF7tfOC
         VzFY37wCOynn28mrqJ0KAUERI+1br2+5pkp0Okyl/5iTqKeeiKs5ULcaEvI+6bAOT+bv
         aMyjDOjszEBqGq1RTfT3NemK2UN07WzWZHYlu5XF8yzc4aYXEI6GM6tBFD5bO92apTSU
         kPEw==
X-Gm-Message-State: AOJu0YwUQqOLn3/aGqBoo/LQtwM3gdFeFF0uvnGuj6spDm2D/l/X+1lR
	JK7nvfTvn8UVsJrI4jHvIqFgP1htewfcAQZn7GIZeiF7DtLqJG7slpMB6ywAJQm2XzjS2vBMlTF
	Y48wRuaJqISrLg4dqcya86fDIKvjTztmC1XKO
X-Gm-Gg: ASbGncuIIYeiM6t5IKtOUBkHSbEF6zO1sApNkFwAQYv5eUn4sfobXqnxlUR5NZsPiT6
	vuz8oI7EMJ8agt/OekYeRUPJudSjXpwVmsxE9FqwUQhkg1nEIvouUiWU9pSsDwcKdKwLR6ZVBm9
	U4jERA2utx3ahfTVSQ6hc+pwpt
X-Google-Smtp-Source: AGHT+IHJWq4Z//LDwfjcMzRXJgvfWvJ21XafXzviEczNJmUZGmueSmOp0XmbGkMwiDZ+TVIlZfTRWPSJzm3KJGuGEkk=
X-Received: by 2002:a05:622a:17c7:b0:466:8887:6751 with SMTP id
 d75a77b69052e-476d6493834mr5972421cf.23.1742208212553; Mon, 17 Mar 2025
 03:43:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250312175824.1809636-5-tabba@google.com> <diqzplijjvq5.fsf@ackerleytng-ctop.c.googlers.com>
In-Reply-To: <diqzplijjvq5.fsf@ackerleytng-ctop.c.googlers.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 17 Mar 2025 10:42:55 +0000
X-Gm-Features: AQ5f1Jq1rpMwHhCDA119Gya4MZ8zuCCVrvyeSrpEUukqLiAAzVcSDt7WV5aF5cE
Message-ID: <CA+EHjTwWM3Wkp6qEF=H2q0BEa1uoWmjY+vgchQsLjH8t9E2auQ@mail.gmail.com>
Subject: Re: [PATCH v6 04/10] KVM: guest_memfd: Allow host to map
 guest_memfd() pages
To: Ackerley Tng <ackerleytng@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, mail@maciej.szmigiero.name, david@redhat.com, 
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

Hi Ackerley,

On Fri, 14 Mar 2025 at 18:47, Ackerley Tng <ackerleytng@google.com> wrote:
>
> Fuad Tabba <tabba@google.com> writes:
>
> > Add support for mmap() and fault() for guest_memfd backed memory
> > in the host for VMs that support in-place conversion between
> > shared and private. To that end, this patch adds the ability to
> > check whether the VM type supports in-place conversion, and only
> > allows mapping its memory if that's the case.
> >
> > Also add the KVM capability KVM_CAP_GMEM_SHARED_MEM, which
> > indicates that the VM supports shared memory in guest_memfd, or
> > that the host can create VMs that support shared memory.
> > Supporting shared memory implies that memory can be mapped when
> > shared with the host.
> >
> > This is controlled by the KVM_GMEM_SHARED_MEM configuration
> > option.
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  include/linux/kvm_host.h |  11 +++++
> >  include/uapi/linux/kvm.h |   1 +
> >  virt/kvm/guest_memfd.c   | 102 +++++++++++++++++++++++++++++++++++++++
> >  virt/kvm/kvm_main.c      |   4 ++
> >  4 files changed, 118 insertions(+)
> >
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index 3ad0719bfc4f..601bbcaa5e41 100644
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
> > +#if !defined(kvm_arch_gmem_supports_shared_mem) && !IS_ENABLED(CONFIG_KVM_GMEM_SHARED_MEM)
> > +static inline bool kvm_arch_gmem_supports_shared_mem(struct kvm *kvm)
> > +{
> > +     return false;
> > +}
> > +#endif
> > +
> >  #ifndef kvm_arch_has_readonly_mem
> >  static inline bool kvm_arch_has_readonly_mem(struct kvm *kvm)
> >  {
> > diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> > index 45e6d8fca9b9..117937a895da 100644
> > --- a/include/uapi/linux/kvm.h
> > +++ b/include/uapi/linux/kvm.h
> > @@ -929,6 +929,7 @@ struct kvm_enable_cap {
> >  #define KVM_CAP_PRE_FAULT_MEMORY 236
> >  #define KVM_CAP_X86_APIC_BUS_CYCLES_NS 237
> >  #define KVM_CAP_X86_GUEST_MODE 238
> > +#define KVM_CAP_GMEM_SHARED_MEM 239
> >
> >  struct kvm_irq_routing_irqchip {
> >       __u32 irqchip;
> > diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> > index 5fc414becae5..eea44e003ed1 100644
> > --- a/virt/kvm/guest_memfd.c
> > +++ b/virt/kvm/guest_memfd.c
> > @@ -320,7 +320,109 @@ static pgoff_t kvm_gmem_get_index(struct kvm_memory_slot *slot, gfn_t gfn)
> >       return gfn - slot->base_gfn + slot->gmem.pgoff;
> >  }
> >
> > +#ifdef CONFIG_KVM_GMEM_SHARED_MEM
> > +static bool folio_offset_is_shared(const struct folio *folio, struct file *file, pgoff_t index)
> > +{
> > +     struct kvm_gmem *gmem = file->private_data;
> > +
> > +     VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
>
> I should've commented on this in the last series, but why must folio
> lock be held to check if this offset is shared?
>
> I was thinking to use the filemap's lock (filemap_invalidate_lock()) to
> guard mappability races. Does that work too?

I was thinking the same thing as I am preparing the sharing state
patch series to be sent. I (wrongly) thought before that it wasn't
possible to protect all cases with the invalidate_lock, but they
already are.

I will fix it in the respin of both. Thanks!


/fuad

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
> > +             int err = PTR_ERR(folio);
> > +
> > +             if (err == -EAGAIN)
> > +                     ret = VM_FAULT_RETRY;
> > +             else
> > +                     ret = vmf_error(err);
> > +
> > +             goto out_filemap;
> > +     }
> > +
> > +     if (folio_test_hwpoison(folio)) {
> > +             ret = VM_FAULT_HWPOISON;
> > +             goto out_folio;
> > +     }
> > +
> > +     if (!folio_offset_is_shared(folio, vmf->vma->vm_file, vmf->pgoff)) {
> > +             ret = VM_FAULT_SIGBUS;
> > +             goto out_folio;
> > +     }
> > +
> > +     /*
> > +      * Shared folios would not be marked as "guestmem" so far, and we only
> > +      * expect shared folios at this point.
> > +      */
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
> > <snip>

