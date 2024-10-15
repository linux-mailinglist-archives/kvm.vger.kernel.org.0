Return-Path: <kvm+bounces-28871-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A179099E3D6
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 12:28:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1FDEA1F23341
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 10:28:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19BF61E3DD1;
	Tue, 15 Oct 2024 10:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uPdWe/go"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21AF81D5AC9
	for <kvm@vger.kernel.org>; Tue, 15 Oct 2024 10:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728988110; cv=none; b=AjWUWTiaJ/XX+goD3vKm0ZDmvAYk1F8b5Yh0ymKvmrrojt6TFKgT2oV5SOcoECPrpsTYj47W4rvj+y8roJbgboTALXTynbo9lsA26DJ/+HvjbmN66Dtbq+/9H4fojPZvvbSX6SOGE5QbdvSL76gDxYNh4QyI9zaUZr/iFdzZs00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728988110; c=relaxed/simple;
	bh=Aq5ZQpkeR2upvMr9Pupr5X4SUAmz6Izqg0UefCY6s7o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ai4aPKvzOCGh+jlYppH+a8+uSMe5yf7th2Llc/FRnJqs6X+6wfi8+1ZzVD0F8fxKQYYCsBmk5qaEGVUJXZIBx+r/pVAqokzIoMy3p0Wejq71l10gEtbM/JoZnrSrSjI3fE/T4Iw2EmJ3oQdRDfzlrAyEjU0mj3rtJVo/JUSWTfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uPdWe/go; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-5c93e9e701fso38987a12.1
        for <kvm@vger.kernel.org>; Tue, 15 Oct 2024 03:28:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728988106; x=1729592906; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=RSTtzbmx1EuT92ep7OYTLC8fP/gGDl2rPFFVcdlePDo=;
        b=uPdWe/goYapXGUaqaIOlX26MuAR6lvVAEsPD+4VI86Uw2S7uKrCCmB4bTW5RgOJ9LY
         cSUwswKKj2YN2+D498RTi6fNJ+7aM5XIpXBpNbwMcvk12Up2+7IxhDSItgRIirS+nsIR
         qwuCkFUamUIRYHIykV+ANUBBjYqpmZC19KgaJoSQEzKn1rwWH3FBSAdw3z0NoPYhhOme
         v1eP/bEfggKjVT2DfBkIA84m7/I4gpeLx3h2tBm9lZUPEv178tSQYtoDHLj10HU1iGTS
         9RN1nIzFq/K7/eT4vkCLl4cR1aBEGuOXv5rmpfcDTz8XjkvDeN8heOALDCnBqVzVf9Jv
         r+qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728988106; x=1729592906;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RSTtzbmx1EuT92ep7OYTLC8fP/gGDl2rPFFVcdlePDo=;
        b=hsj9Q+h26n8YeW/ydULIzpXkIr70wkspXoKlH1l9Wxo0KVUi9L5a8biqAV3U4YAhkK
         kOy66ZFTnD/QFJ5X24CIQXjdGFP5RmcfE1Tfo6YAnoBBiem2R2SwwDhvk01Afl2rxciZ
         tSbNmpj7ZQms+uhi6zDeylDLNPD7n2+GHxScztmKpgEDjmA+U/wuGJVGGjKHfhpFa/tE
         EM7NUMlrdxD+rnChODRg84WAuoEezmj7aEqIHf+LSPQm4bNgZAdOGwrlWnool/a/5RRm
         5pAMrUvr/eMOdK2A0Y2rhtXvlYcHHpbDesHI0Uj+YoJhIBECY7otJNN8hEhVPvnGVHm+
         bFMg==
X-Gm-Message-State: AOJu0YzVy5T6+4EDKEk5eEM64AdbAoFF7/HIeCdX3+uskwcvdiSGT2Ja
	5IlMZvEFeztOtkD5UWY4lMHgaT//oGCnlniLwjmmvSCxjt4c0FLEd/gqziXxvMkQFfpgTXEDGPU
	hzD5ahH2LEt+fFn2zjyBUQlT/fvOUjrhf3Ir2
X-Google-Smtp-Source: AGHT+IHKqOIJnbk+AfNxn/S0niZ5Lw7/6fa3hE6OhHpYtKLObsvZB+OHC0HlZcl6gO8D+mQTsBl4PFyDsCDec2OIPyk=
X-Received: by 2002:a05:6402:5251:b0:5c8:aefb:746d with SMTP id
 4fb4d7f45d1cf-5c95c5ee259mr591403a12.5.1728988105987; Tue, 15 Oct 2024
 03:28:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241010085930.1546800-1-tabba@google.com> <20241010085930.1546800-5-tabba@google.com>
 <20241011102208348-0700.eberman@hu-eberman-lv.qualcomm.com>
In-Reply-To: <20241011102208348-0700.eberman@hu-eberman-lv.qualcomm.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 15 Oct 2024 11:27:48 +0100
Message-ID: <CA+EHjTw2=A4TCV3x-x3+Kbo9im_DVe5uGSJb6eKBQH0CYbnQcw@mail.gmail.com>
Subject: Re: [PATCH v3 04/11] KVM: guest_memfd: Allow host to mmap
 guest_memfd() pages when shared
To: Elliot Berman <quic_eberman@quicinc.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com, 
	mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com, 
	quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, 
	catalin.marinas@arm.com, james.morse@arm.com, yuzenghui@huawei.com, 
	oliver.upton@linux.dev, maz@kernel.org, will@kernel.org, qperret@google.com, 
	keirf@google.com, roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, 
	jgg@nvidia.com, rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, 
	hughd@google.com, jthoughton@google.com
Content-Type: text/plain; charset="UTF-8"

Hi Elliot,

On Mon, 14 Oct 2024 at 17:53, Elliot Berman <quic_eberman@quicinc.com> wrote:
>
> On Thu, Oct 10, 2024 at 09:59:23AM +0100, Fuad Tabba wrote:
> > Add support for mmap() and fault() for guest_memfd in the host.
> > The ability to fault in a guest page is contingent on that page
> > being shared with the host.
> >
> > The guest_memfd PRIVATE memory attribute is not used for two
> > reasons. First because it reflects the userspace expectation for
> > that memory location, and therefore can be toggled by userspace.
> > The second is, although each guest_memfd file has a 1:1 binding
> > with a KVM instance, the plan is to allow multiple files per
> > inode, e.g. to allow intra-host migration to a new KVM instance,
> > without destroying guest_memfd.
> >
> > The mapping is restricted to only memory explicitly shared with
> > the host. KVM checks that the host doesn't have any mappings for
> > private memory via the folio's refcount. To avoid races between
> > paths that check mappability and paths that check whether the
> > host has any mappings (via the refcount), the folio lock is held
> > in while either check is being performed.
> >
> > This new feature is gated with a new configuration option,
> > CONFIG_KVM_GMEM_MAPPABLE.
> >
> > Co-developed-by: Ackerley Tng <ackerleytng@google.com>
> > Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> > Co-developed-by: Elliot Berman <quic_eberman@quicinc.com>
> > Signed-off-by: Elliot Berman <quic_eberman@quicinc.com>
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> >
> > ---
> >
> > Note that the functions kvm_gmem_is_mapped(),
> > kvm_gmem_set_mappable(), and int kvm_gmem_clear_mappable() are
> > not used in this patch series. They are intended to be used in
> > future patches [*], which check and toggle mapability when the
> > guest shares/unshares pages with the host.
> >
> > [*] https://android-kvm.googlesource.com/linux/+/refs/heads/tabba/guestmem-6.12-v3-pkvm
> >
> > ---
> >  include/linux/kvm_host.h |  52 +++++++++++
> >  virt/kvm/Kconfig         |   4 +
> >  virt/kvm/guest_memfd.c   | 185 +++++++++++++++++++++++++++++++++++++++
> >  virt/kvm/kvm_main.c      | 138 +++++++++++++++++++++++++++++
> >  4 files changed, 379 insertions(+)
> >
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index acf85995b582..bda7fda9945e 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -2527,4 +2527,56 @@ long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
> >                                   struct kvm_pre_fault_memory *range);
> >  #endif
> >
> > +#ifdef CONFIG_KVM_GMEM_MAPPABLE
> > +bool kvm_gmem_is_mappable(struct kvm *kvm, gfn_t gfn, gfn_t end);
> > +bool kvm_gmem_is_mapped(struct kvm *kvm, gfn_t start, gfn_t end);
> > +int kvm_gmem_set_mappable(struct kvm *kvm, gfn_t start, gfn_t end);
> > +int kvm_gmem_clear_mappable(struct kvm *kvm, gfn_t start, gfn_t end);
> > +int kvm_slot_gmem_set_mappable(struct kvm_memory_slot *slot, gfn_t start,
> > +                            gfn_t end);
> > +int kvm_slot_gmem_clear_mappable(struct kvm_memory_slot *slot, gfn_t start,
> > +                              gfn_t end);
> > +bool kvm_slot_gmem_is_mappable(struct kvm_memory_slot *slot, gfn_t gfn);
> > +#else
> > +static inline bool kvm_gmem_is_mappable(struct kvm *kvm, gfn_t gfn, gfn_t end)
> > +{
> > +     WARN_ON_ONCE(1);
> > +     return false;
> > +}
> > +static inline bool kvm_gmem_is_mapped(struct kvm *kvm, gfn_t start, gfn_t end)
> > +{
> > +     WARN_ON_ONCE(1);
> > +     return false;
> > +}
> > +static inline int kvm_gmem_set_mappable(struct kvm *kvm, gfn_t start, gfn_t end)
> > +{
> > +     WARN_ON_ONCE(1);
> > +     return -EINVAL;
> > +}
> > +static inline int kvm_gmem_clear_mappable(struct kvm *kvm, gfn_t start,
> > +                                       gfn_t end)
> > +{
> > +     WARN_ON_ONCE(1);
> > +     return -EINVAL;
> > +}
> > +static inline int kvm_slot_gmem_set_mappable(struct kvm_memory_slot *slot,
> > +                                          gfn_t start, gfn_t end)
> > +{
> > +     WARN_ON_ONCE(1);
> > +     return -EINVAL;
> > +}
> > +static inline int kvm_slot_gmem_clear_mappable(struct kvm_memory_slot *slot,
> > +                                            gfn_t start, gfn_t end)
> > +{
> > +     WARN_ON_ONCE(1);
> > +     return -EINVAL;
> > +}
> > +static inline bool kvm_slot_gmem_is_mappable(struct kvm_memory_slot *slot,
> > +                                          gfn_t gfn)
> > +{
> > +     WARN_ON_ONCE(1);
> > +     return false;
> > +}
> > +#endif /* CONFIG_KVM_GMEM_MAPPABLE */
> > +
> >  #endif
> > diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
> > index fd6a3010afa8..2cfcb0848e37 100644
> > --- a/virt/kvm/Kconfig
> > +++ b/virt/kvm/Kconfig
> > @@ -120,3 +120,7 @@ config HAVE_KVM_ARCH_GMEM_PREPARE
> >  config HAVE_KVM_ARCH_GMEM_INVALIDATE
> >         bool
> >         depends on KVM_PRIVATE_MEM
> > +
> > +config KVM_GMEM_MAPPABLE
> > +       select KVM_PRIVATE_MEM
> > +       bool
> > diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> > index f414646c475b..df3a6f05a16e 100644
> > --- a/virt/kvm/guest_memfd.c
> > +++ b/virt/kvm/guest_memfd.c
> > @@ -370,7 +370,184 @@ static void kvm_gmem_init_mount(void)
> >       kvm_gmem_mnt->mnt_flags |= MNT_NOEXEC;
> >  }
> >
> > +#ifdef CONFIG_KVM_GMEM_MAPPABLE
> > +static struct folio *
> > +__kvm_gmem_get_pfn(struct file *file, struct kvm_memory_slot *slot,
> > +                gfn_t gfn, kvm_pfn_t *pfn, bool *is_prepared,
> > +                int *max_order);
> > +
> > +static int gmem_set_mappable(struct inode *inode, pgoff_t start, pgoff_t end)
> > +{
> > +     struct xarray *mappable_offsets = &kvm_gmem_private(inode)->mappable_offsets;
> > +     void *xval = xa_mk_value(true);
> > +     pgoff_t i;
> > +     bool r;
> > +
> > +     filemap_invalidate_lock(inode->i_mapping);
> > +     for (i = start; i < end; i++) {
> > +             r = xa_err(xa_store(mappable_offsets, i, xval, GFP_KERNEL));
>
> I think it might not be strictly necessary,

Sorry, but I don't quite get what isn't strictly necessary. Is it the
checking for an error?

> > +             if (r)
> > +                     break;
> > +     }
> > +     filemap_invalidate_unlock(inode->i_mapping);
> > +
> > +     return r;
> > +}
> > +
> > +static int gmem_clear_mappable(struct inode *inode, pgoff_t start, pgoff_t end)
> > +{
> > +     struct xarray *mappable_offsets = &kvm_gmem_private(inode)->mappable_offsets;
> > +     pgoff_t i;
> > +     int r = 0;
> > +
> > +     filemap_invalidate_lock(inode->i_mapping);
> > +     for (i = start; i < end; i++) {
> > +             struct folio *folio;
> > +
> > +             /*
> > +              * Holds the folio lock until after checking its refcount,
> > +              * to avoid races with paths that fault in the folio.
> > +              */
> > +             folio = kvm_gmem_get_folio(inode, i);
>
> We don't need to allocate the folio here. I think we can use
>
>                 folio = filemap_lock_folio(inode, i);
>                 if (!folio || WARN_ON_ONCE(IS_ERR(folio)))
>                         continue;

Good point (it takes an inode->i_mapping though).

>                 folio = filemap_lock_folio(inode->i_mapping, i);


> > +             if (WARN_ON_ONCE(IS_ERR(folio)))
> > +                     continue;
> > +
> > +             /*
> > +              * Check that the host doesn't have any mappings on clearing
> > +              * the mappable flag, because clearing the flag implies that the
> > +              * memory will be unshared from the host. Therefore, to maintain
> > +              * the invariant that the host cannot access private memory, we
> > +              * need to check that it doesn't have any mappings to that
> > +              * memory before making it private.
> > +              *
> > +              * Two references are expected because of kvm_gmem_get_folio().
> > +              */
> > +             if (folio_ref_count(folio) > 2)
>
> If we'd like to be prepared for large folios, it should be
> folio_nr_pages(folio) + 1.

Will do that.

Thanks!
/fuad



> > +                     r = -EPERM;
> > +             else
> > +                     xa_erase(mappable_offsets, i);
> > +
> > +             folio_put(folio);
> > +             folio_unlock(folio);
> > +
> > +             if (r)
> > +                     break;
> > +     }
> > +     filemap_invalidate_unlock(inode->i_mapping);
> > +
> > +     return r;
> > +}
> > +
> > +static bool gmem_is_mappable(struct inode *inode, pgoff_t pgoff)
> > +{
> > +     struct xarray *mappable_offsets = &kvm_gmem_private(inode)->mappable_offsets;
> > +     bool r;
> > +
> > +     filemap_invalidate_lock_shared(inode->i_mapping);
> > +     r = xa_find(mappable_offsets, &pgoff, pgoff, XA_PRESENT);
> > +     filemap_invalidate_unlock_shared(inode->i_mapping);
> > +
> > +     return r;
> > +}
> > +
> > +int kvm_slot_gmem_set_mappable(struct kvm_memory_slot *slot, gfn_t start, gfn_t end)
> > +{
> > +     struct inode *inode = file_inode(slot->gmem.file);
> > +     pgoff_t start_off = slot->gmem.pgoff + start - slot->base_gfn;
> > +     pgoff_t end_off = start_off + end - start;
> > +
> > +     return gmem_set_mappable(inode, start_off, end_off);
> > +}
> > +
> > +int kvm_slot_gmem_clear_mappable(struct kvm_memory_slot *slot, gfn_t start, gfn_t end)
> > +{
> > +     struct inode *inode = file_inode(slot->gmem.file);
> > +     pgoff_t start_off = slot->gmem.pgoff + start - slot->base_gfn;
> > +     pgoff_t end_off = start_off + end - start;
> > +
> > +     return gmem_clear_mappable(inode, start_off, end_off);
> > +}
> > +
> > +bool kvm_slot_gmem_is_mappable(struct kvm_memory_slot *slot, gfn_t gfn)
> > +{
> > +     struct inode *inode = file_inode(slot->gmem.file);
> > +     unsigned long pgoff = slot->gmem.pgoff + gfn - slot->base_gfn;
> > +
> > +     return gmem_is_mappable(inode, pgoff);
> > +}
> > +
> > +static vm_fault_t kvm_gmem_fault(struct vm_fault *vmf)
> > +{
> > +     struct inode *inode = file_inode(vmf->vma->vm_file);
> > +     struct folio *folio;
> > +     vm_fault_t ret = VM_FAULT_LOCKED;
> > +
> > +     /*
> > +      * Holds the folio lock until after checking whether it can be faulted
> > +      * in, to avoid races with paths that change a folio's mappability.
> > +      */
> > +     folio = kvm_gmem_get_folio(inode, vmf->pgoff);
> > +     if (!folio)
> > +             return VM_FAULT_SIGBUS;
> > +
> > +     if (folio_test_hwpoison(folio)) {
> > +             ret = VM_FAULT_HWPOISON;
> > +             goto out;
> > +     }
> > +
> > +     if (!gmem_is_mappable(inode, vmf->pgoff)) {
> > +             ret = VM_FAULT_SIGBUS;
> > +             goto out;
> > +     }
> > +
> > +     if (!folio_test_uptodate(folio)) {
> > +             unsigned long nr_pages = folio_nr_pages(folio);
> > +             unsigned long i;
> > +
> > +             for (i = 0; i < nr_pages; i++)
> > +                     clear_highpage(folio_page(folio, i));
> > +
> > +             folio_mark_uptodate(folio);
> > +     }
> > +
> > +     vmf->page = folio_file_page(folio, vmf->pgoff);
> > +out:
> > +     if (ret != VM_FAULT_LOCKED) {
> > +             folio_put(folio);
> > +             folio_unlock(folio);
> > +     }
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
> > +static int gmem_set_mappable(struct inode *inode, pgoff_t start, pgoff_t end)
> > +{
> > +     WARN_ON_ONCE(1);
> > +     return -EINVAL;
> > +}
> > +#define kvm_gmem_mmap NULL
> > +#endif /* CONFIG_KVM_GMEM_MAPPABLE */
> > +
> >  static struct file_operations kvm_gmem_fops = {
> > +     .mmap           = kvm_gmem_mmap,
> >       .open           = generic_file_open,
> >       .release        = kvm_gmem_release,
> >       .fallocate      = kvm_gmem_fallocate,
> > @@ -557,6 +734,14 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
> >               goto err_gmem;
> >       }
> >
> > +     if (IS_ENABLED(CONFIG_KVM_GMEM_MAPPABLE)) {
> > +             err = gmem_set_mappable(file_inode(file), 0, size >> PAGE_SHIFT);
> > +             if (err) {
> > +                     fput(file);
> > +                     goto err_gmem;
> > +             }
> > +     }
> > +
> >       kvm_get_kvm(kvm);
> >       gmem->kvm = kvm;
> >       xa_init(&gmem->bindings);
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index 05cbb2548d99..aed9cf2f1685 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -3263,6 +3263,144 @@ static int next_segment(unsigned long len, int offset)
> >               return len;
> >  }
> >
> > +#ifdef CONFIG_KVM_GMEM_MAPPABLE
> > +static bool __kvm_gmem_is_mappable(struct kvm *kvm, gfn_t start, gfn_t end)
> > +{
> > +     struct kvm_memslot_iter iter;
> > +
> > +     lockdep_assert_held(&kvm->slots_lock);
> > +
> > +     kvm_for_each_memslot_in_gfn_range(&iter, kvm_memslots(kvm), start, end) {
> > +             struct kvm_memory_slot *memslot = iter.slot;
> > +             gfn_t gfn_start, gfn_end, i;
> > +
> > +             gfn_start = max(start, memslot->base_gfn);
> > +             gfn_end = min(end, memslot->base_gfn + memslot->npages);
> > +             if (WARN_ON_ONCE(gfn_start >= gfn_end))
> > +                     continue;
> > +
> > +             for (i = gfn_start; i < gfn_end; i++) {
> > +                     if (!kvm_slot_gmem_is_mappable(memslot, i))
> > +                             return false;
> > +             }
> > +     }
> > +
> > +     return true;
> > +}
> > +
> > +bool kvm_gmem_is_mappable(struct kvm *kvm, gfn_t start, gfn_t end)
> > +{
> > +     bool r;
> > +
> > +     mutex_lock(&kvm->slots_lock);
> > +     r = __kvm_gmem_is_mappable(kvm, start, end);
> > +     mutex_unlock(&kvm->slots_lock);
> > +
> > +     return r;
> > +}
> > +
> > +static bool kvm_gmem_is_pfn_mapped(struct kvm *kvm, struct kvm_memory_slot *memslot, gfn_t gfn_idx)
> > +{
> > +     struct page *page;
> > +     bool is_mapped;
> > +     kvm_pfn_t pfn;
> > +
> > +     /*
> > +      * Holds the folio lock until after checking its refcount,
> > +      * to avoid races with paths that fault in the folio.
> > +      */
> > +     if (WARN_ON_ONCE(kvm_gmem_get_pfn_locked(kvm, memslot, gfn_idx, &pfn, NULL)))
> > +             return false;
> > +
> > +     page = pfn_to_page(pfn);
> > +
> > +     /* Two references are expected because of kvm_gmem_get_pfn_locked(). */
> > +     is_mapped = page_ref_count(page) > 2;
> > +
> > +     put_page(page);
> > +     unlock_page(page);
> > +
> > +     return is_mapped;
> > +}
> > +
> > +static bool __kvm_gmem_is_mapped(struct kvm *kvm, gfn_t start, gfn_t end)
> > +{
> > +     struct kvm_memslot_iter iter;
> > +
> > +     lockdep_assert_held(&kvm->slots_lock);
> > +
> > +     kvm_for_each_memslot_in_gfn_range(&iter, kvm_memslots(kvm), start, end) {
> > +             struct kvm_memory_slot *memslot = iter.slot;
> > +             gfn_t gfn_start, gfn_end, i;
> > +
> > +             gfn_start = max(start, memslot->base_gfn);
> > +             gfn_end = min(end, memslot->base_gfn + memslot->npages);
> > +             if (WARN_ON_ONCE(gfn_start >= gfn_end))
> > +                     continue;
> > +
> > +             for (i = gfn_start; i < gfn_end; i++) {
> > +                     if (kvm_gmem_is_pfn_mapped(kvm, memslot, i))
> > +                             return true;
> > +             }
> > +     }
> > +
> > +     return false;
> > +}
> > +
> > +bool kvm_gmem_is_mapped(struct kvm *kvm, gfn_t start, gfn_t end)
> > +{
> > +     bool r;
> > +
> > +     mutex_lock(&kvm->slots_lock);
> > +     r = __kvm_gmem_is_mapped(kvm, start, end);
> > +     mutex_unlock(&kvm->slots_lock);
> > +
> > +     return r;
> > +}
> > +
> > +static int kvm_gmem_toggle_mappable(struct kvm *kvm, gfn_t start, gfn_t end,
> > +                                 bool is_mappable)
> > +{
> > +     struct kvm_memslot_iter iter;
> > +     int r = 0;
> > +
> > +     mutex_lock(&kvm->slots_lock);
> > +
> > +     kvm_for_each_memslot_in_gfn_range(&iter, kvm_memslots(kvm), start, end) {
> > +             struct kvm_memory_slot *memslot = iter.slot;
> > +             gfn_t gfn_start, gfn_end;
> > +
> > +             gfn_start = max(start, memslot->base_gfn);
> > +             gfn_end = min(end, memslot->base_gfn + memslot->npages);
> > +             if (WARN_ON_ONCE(start >= end))
> > +                     continue;
> > +
> > +             if (is_mappable)
> > +                     r = kvm_slot_gmem_set_mappable(memslot, gfn_start, gfn_end);
> > +             else
> > +                     r = kvm_slot_gmem_clear_mappable(memslot, gfn_start, gfn_end);
> > +
> > +             if (WARN_ON_ONCE(r))
> > +                     break;
> > +     }
> > +
> > +     mutex_unlock(&kvm->slots_lock);
> > +
> > +     return r;
> > +}
> > +
> > +int kvm_gmem_set_mappable(struct kvm *kvm, gfn_t start, gfn_t end)
> > +{
> > +     return kvm_gmem_toggle_mappable(kvm, start, end, true);
> > +}
> > +
> > +int kvm_gmem_clear_mappable(struct kvm *kvm, gfn_t start, gfn_t end)
> > +{
> > +     return kvm_gmem_toggle_mappable(kvm, start, end, false);
> > +}
> > +
> > +#endif /* CONFIG_KVM_GMEM_MAPPABLE */
> > +
> >  /* Copy @len bytes from guest memory at '(@gfn * PAGE_SIZE) + @offset' to @data */
> >  static int __kvm_read_guest_page(struct kvm_memory_slot *slot, gfn_t gfn,
> >                                void *data, int offset, int len)
> > --
> > 2.47.0.rc0.187.ge670bccf7e-goog
> >

