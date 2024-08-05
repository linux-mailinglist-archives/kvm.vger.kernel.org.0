Return-Path: <kvm+bounces-23247-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C0D5E94816B
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 20:10:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7637028DEBA
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 18:10:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4FDB16BE33;
	Mon,  5 Aug 2024 18:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Y0kDcCVV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B62915F3FB
	for <kvm@vger.kernel.org>; Mon,  5 Aug 2024 18:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722881345; cv=none; b=clw1T1OmwGqHg2TkWhqsqSnDueGTvylTH4ZVIguDgfzdkZ40LZ4ibQbMOLeqfHXeSQ+V+4QGQxNbe98GHWDID9DNH3t+h+/qtpaWhD3Vi+cL/3TMpVyOaPPS8HY0Il3RNceei0+JPWHVolqe92NE3qRexopNDRY0lcgVOptYLYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722881345; c=relaxed/simple;
	bh=72W6bt4/ei5jg6RllCYvr2y3ILsBqCWVnML3wPsWijo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LXElb3kMoUCBWREh9FYDsrPzdkAA8cUTwOGnVlGAB4TDfnNDgXihNmxHA0bki3S5f/rzviSuR28aHtZ1hiRkFTJENDGH7rMBUiSb91F6iJLNNCwNPbfdkUPnhhJLjTbBl+mojpQnFyf9i0pQQcbTwCZ5DpyVogdUdSJeiu5wgEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Y0kDcCVV; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-428101fa30aso73850585e9.3
        for <kvm@vger.kernel.org>; Mon, 05 Aug 2024 11:09:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722881341; x=1723486141; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UeW1unF7m5afaM1gpM1M9uUrUWJD1MlWOk+st+pUC2Y=;
        b=Y0kDcCVVIn8hYVBnL2G+tZ/pitBYoj2YCNQMhghgRUWN5RX3/i5erjkNORCWiwSTPT
         zxBoRqiTyl+yAUNHhNZ40oP9e1nkhu30pbU2R9ut3AXs1FyJ36HWrhsUqXj86GsnoWOL
         lPooHveV3R3zLsApYzNhE9wcz1gurE4bwMNRdQWShJ5SykrNmZvOJoI/K3Zwg9qtxh9F
         ZbrbbdsadUyLDqX4ECh+OaNVfv4004Ghd1zfilUqPiGAb5ujijHovFrg/+gmAC03RxtQ
         0eV4l2q3d3kecpXHD4XKN2sTSLeOENu4DIEFCrg/U69iKwBpbfOWpi3qAu2iX5Y3P21Y
         yJhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722881341; x=1723486141;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UeW1unF7m5afaM1gpM1M9uUrUWJD1MlWOk+st+pUC2Y=;
        b=Ivbk2hNtKe5KVwh1WE4O3YQiNcwXp9D5/fGJ5EPGCeskXBEuaBDRoQP6AMht8SlXPe
         48Nl2bFphl+ylIo/P7bs7G9Ohx21SGxGnzHFloi3Z7zjw9gL8kgbdIE1uZ7GOEfr6+Ns
         Qa3/rG7PLbOCcgrXh/W+Lgcf2Oe1RRr4CnO63Hra0LqIUS0VdrI5mbakHxQFQsEtFoER
         ovDlK0lbChhjwzaFZI9/sonQtsVabH18aSK/4sGP1VfuS2AHAyTyFTmtVMBo72cF9yCr
         t7mukzEqyc2WwymVwOPUYVR5DIGS7elpY5EhgjaaF0Bno+ghYLx4PmkyIVgtzBhdePbo
         eacw==
X-Gm-Message-State: AOJu0YwJLCjDOlxYMjsZ4OdCHzvZJZd9yW7zas5UqVXcCWvb9Xeffqxn
	397i5hw2UEknZWsRH63RfjPZtYBMFaJwOoTgVNFn0bm7K2jbhPASn8TMmj7wzCd88vSeRAoh43h
	91PI01nae8AkjAtY4VqVIFR5tPFZ0hxIJd2nBI+gpQM1tjbTESeJAvJ0=
X-Google-Smtp-Source: AGHT+IGlam5R4MrwXgwMUf6lewarSbSF7VWV+YK8sh7hmzc23x2T9ooLmMK9oWF10JLy/SYgoH+dt8vKj+pLM91ec4Y=
X-Received: by 2002:adf:ec03:0:b0:368:714e:5a59 with SMTP id
 ffacd0b85a97d-36bbc0aeba6mr10390684f8f.11.1722881340314; Mon, 05 Aug 2024
 11:09:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240801090117.3841080-3-tabba@google.com> <diqzcymmevsm.fsf@ackerleytng-ctop.c.googlers.com>
In-Reply-To: <diqzcymmevsm.fsf@ackerleytng-ctop.c.googlers.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 5 Aug 2024 19:08:23 +0100
Message-ID: <CA+EHjTxXmSBoK+wk+ax4cg=yH_Gn82bEVEyau07ikv3zSbZG5A@mail.gmail.com>
Subject: Re: [RFC PATCH v2 02/10] KVM: Add restricted support for mapping
 guestmem by the host
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
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Ackerley,

On Mon, 5 Aug 2024 at 18:14, Ackerley Tng <ackerleytng@google.com> wrote:
>
> Fuad Tabba <tabba@google.com> writes:
>
> > Add support for mmap() and fault() for guest_memfd in the host.
> > The ability to fault in a guest page is contingent on that page
> > being shared with the host. To track this, this patch adds a new
> > xarray to each guest_memfd object, which tracks the mappability
> > of guest frames.
> >
> > The guest_memfd PRIVATE memory attribute is not used for two
> > reasons. First because it reflects the userspace expectation for
> > that memory location, and therefore can be toggled by userspace.
>
> Thank you for clarifying why the PRIVATE memory attribute cannot be
> used. I think that having the attributes with guest_memfd is a good
> idea.
>
> Since faultability is a property of the memory contents, shouldn't
> faultability be stored on the inode rather than the file?

I don't have a strong opinion about this, but by not mappable, this
means not having a valid mapping in the host, not that the "mmap"
call in and of itself is not allowed.

>
> > The second is, although each guest_memfd file has a 1:1 binding
> > with a KVM instance, the plan is to allow multiple files per
> > inode, e.g. to allow intra-host migration to a new KVM instance,
> > without destroying guest_memfd.
>
> I think you also alluded to the concept of inodes vs files above.
>
> To store the xarray on the inode, we would probably have to make
> guest_memfd use its own mount so that we can use .evict_inode() from
> struct address_space_operations to clean up the inode neatly, perhaps
> the way it was done in guest_memfd v12 [1].
>
> This RFC to enable intra-host migration [2] was built with the version
> of guest_memfd that used its own mount. IIUC, the gmem struct stored on
> the file is meant to be the binding between struct kvm and the memory
> contents [3], so the gmem struct won't be transferred and a new gmem
> struct will be created.

I thought that the gmem object itself is unique, and that even if
we're transferring it from one inode to another it would still be
there. If not, then you're right and we need to store this data in the
inode.

Thanks for pointing me to the RFC. I'll have a look at it and use it
as a reference when I respin this.

> >
> > This new feature is gated with a new configuration option,
> > CONFIG_KVM_PRIVATE_MEM_MAPPABLE.
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  include/linux/kvm_host.h |  61 ++++++++++++++++++++
> >  virt/kvm/Kconfig         |   4 ++
> >  virt/kvm/guest_memfd.c   | 110 +++++++++++++++++++++++++++++++++++
> >  virt/kvm/kvm_main.c      | 122 +++++++++++++++++++++++++++++++++++++++
> >  4 files changed, 297 insertions(+)
> >
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index 43a157f8171a..ab1344327e57 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -2452,4 +2452,65 @@ static inline int kvm_gmem_get_pfn_locked(struct=
 kvm *kvm,
> >  }
> >  #endif /* CONFIG_KVM_PRIVATE_MEM */
> >
> > +#ifdef CONFIG_KVM_PRIVATE_MEM_MAPPABLE
> > +bool kvm_gmem_is_mappable(struct kvm *kvm, gfn_t gfn, gfn_t end);
> > +bool kvm_gmem_is_mapped(struct kvm *kvm, gfn_t start, gfn_t end);
> > +int kvm_gmem_set_mappable(struct kvm *kvm, gfn_t start, gfn_t end);
>
> How will kvm_gmem_is_mapped() and kvm_gmem_set_mappable() be used?

In this patch series I only use __ kvm_gmem_is_mapped(), you're right.
In later patches (not posted, pkvm specific), I use
kvm_gmem_is_mapped() in the processing of an unshare call from the
guest.

> > +int kvm_gmem_clear_mappable(struct kvm *kvm, gfn_t start, gfn_t end);
> > +int kvm_slot_gmem_toggle_mappable(struct kvm_memory_slot *slot, gfn_t =
start,
> > +                               gfn_t end, bool is_mappable);
> > +int kvm_slot_gmem_set_mappable(struct kvm_memory_slot *slot, gfn_t sta=
rt,
> > +                            gfn_t end);
> > +int kvm_slot_gmem_clear_mappable(struct kvm_memory_slot *slot, gfn_t s=
tart,
> > +                              gfn_t end);
> > +bool kvm_slot_gmem_is_mappable(struct kvm_memory_slot *slot, gfn_t gfn=
);
> > +#else
> > +static inline bool kvm_gmem_is_mappable(struct kvm *kvm, gfn_t gfn, gf=
n_t end)
> > +{
> > +     WARN_ON_ONCE(1);
> > +     return false;
> > +}
> > +static inline bool kvm_gmem_is_mapped(struct kvm *kvm, gfn_t start, gf=
n_t end)
> > +{
> > +     WARN_ON_ONCE(1);
> > +     return false;
> > +}
> > +static inline int kvm_gmem_set_mappable(struct kvm *kvm, gfn_t start, =
gfn_t end)
> > +{
> > +     WARN_ON_ONCE(1);
> > +     return -EINVAL;
> > +}
> > +static inline int kvm_gmem_clear_mappable(struct kvm *kvm, gfn_t start=
,
> > +                                       gfn_t end)
> > +{
> > +     WARN_ON_ONCE(1);
> > +     return -EINVAL;
> > +}
> > +static inline int kvm_slot_gmem_toggle_mappable(struct kvm_memory_slot=
 *slot,
> > +                                             gfn_t start, gfn_t end,
> > +                                             bool is_mappable)
> > +{
> > +     WARN_ON_ONCE(1);
> > +     return -EINVAL;
> > +}
> > +static inline int kvm_slot_gmem_set_mappable(struct kvm_memory_slot *s=
lot,
> > +                                          gfn_t start, gfn_t end)
> > +{
> > +     WARN_ON_ONCE(1);
> > +     return -EINVAL;
> > +}
> > +static inline int kvm_slot_gmem_clear_mappable(struct kvm_memory_slot =
*slot,
> > +                                            gfn_t start, gfn_t end)
> > +{
> > +     WARN_ON_ONCE(1);
> > +     return -EINVAL;
> > +}
> > +static inline bool kvm_slot_gmem_is_mappable(struct kvm_memory_slot *s=
lot,
> > +                                          gfn_t gfn)
> > +{
> > +     WARN_ON_ONCE(1);
> > +     return false;
> > +}
> > +#endif /* CONFIG_KVM_PRIVATE_MEM_MAPPABLE */
> > +
> >  #endif
> > diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
> > index 29b73eedfe74..a3970c5eca7b 100644
> > --- a/virt/kvm/Kconfig
> > +++ b/virt/kvm/Kconfig
> > @@ -109,3 +109,7 @@ config KVM_GENERIC_PRIVATE_MEM
> >         select KVM_GENERIC_MEMORY_ATTRIBUTES
> >         select KVM_PRIVATE_MEM
> >         bool
> > +
> > +config KVM_PRIVATE_MEM_MAPPABLE
> > +       select KVM_PRIVATE_MEM
> > +       bool
> > diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> > index f3f4334a9ccb..0a1f266a16f9 100644
> > --- a/virt/kvm/guest_memfd.c
> > +++ b/virt/kvm/guest_memfd.c
> > @@ -11,6 +11,9 @@ struct kvm_gmem {
> >       struct kvm *kvm;
> >       struct xarray bindings;
> >       struct list_head entry;
> > +#ifdef CONFIG_KVM_PRIVATE_MEM_MAPPABLE
> > +     struct xarray unmappable_gfns;
> > +#endif
> >  };
> >
> >  static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t i=
ndex)
> > @@ -230,6 +233,11 @@ static int kvm_gmem_release(struct inode *inode, s=
truct file *file)
> >       mutex_unlock(&kvm->slots_lock);
> >
> >       xa_destroy(&gmem->bindings);
> > +
> > +#ifdef CONFIG_KVM_PRIVATE_MEM_MAPPABLE
> > +     xa_destroy(&gmem->unmappable_gfns);
> > +#endif
> > +
> >       kfree(gmem);
> >
> >       kvm_put_kvm(kvm);
> > @@ -248,7 +256,105 @@ static inline struct file *kvm_gmem_get_file(stru=
ct kvm_memory_slot *slot)
> >       return get_file_active(&slot->gmem.file);
> >  }
> >
> > +#ifdef CONFIG_KVM_PRIVATE_MEM_MAPPABLE
> > +int kvm_slot_gmem_toggle_mappable(struct kvm_memory_slot *slot, gfn_t =
start,
> > +                               gfn_t end, bool is_mappable)
> > +{
> > +     struct kvm_gmem *gmem =3D slot->gmem.file->private_data;
> > +     void *xval =3D is_mappable ? NULL : xa_mk_value(true);
>
> IIUC storing stuff in the xarray takes memory, so if we want to save
> memory, we should minimize entries in the xarray. For pKVM, do you
> expect more mappable, or more unmappable gfns?
>
> For TDX most of the memory will be private, so we expect fewer mappable
> gfns, and we'd prefer "entry in xarray =3D=3D mappable".

This is similar to a discussion I've had earlier regarding the PRIVATE
attribute [*].

I don't have a strong opinion. It's trivial to reverse the polarity.
But to answer your question, most of the memory in pKVM would be
private for protected guests, but shared for non-protected guests. So,
it's not easy to know which would be the more common use case.

Cheers,
/fuad

[*] https://lore.kernel.org/lkml/20231027182217.3615211-1-seanjc@google.com=
/T/#:~:text=3Dconsistent%20across%20implementations.-,Yeah%2C%20we%20discus=
sed%20this%20in%20v12%5B*%5D.%20%20The%20default%20really%20doesn%27t%20mat=
ter%20for%20memory,-overheads%20or%20performances


> > +     void *r;
> > +
> > +     r =3D xa_store_range(&gmem->unmappable_gfns, start, end - 1, xval=
, GFP_KERNEL);
> > +
> > +     return xa_err(r);
> > +}
> > +
> > +int kvm_slot_gmem_set_mappable(struct kvm_memory_slot *slot, gfn_t sta=
rt, gfn_t end)
> > +{
> > +     return kvm_slot_gmem_toggle_mappable(slot, start, end, true);
> > +}
> > +
> > +int kvm_slot_gmem_clear_mappable(struct kvm_memory_slot *slot, gfn_t s=
tart, gfn_t end)
> > +{
> > +     return kvm_slot_gmem_toggle_mappable(slot, start, end, false);
> > +}
> > +
> > +bool kvm_slot_gmem_is_mappable(struct kvm_memory_slot *slot, gfn_t gfn=
)
> > +{
> > +     struct kvm_gmem *gmem =3D slot->gmem.file->private_data;
> > +     unsigned long _gfn =3D gfn;
> > +
> > +     return !xa_find(&gmem->unmappable_gfns, &_gfn, ULONG_MAX, XA_PRES=
ENT);
> > +}
> > +
> > +static bool kvm_gmem_isfaultable(struct vm_fault *vmf)
> > +{
> > +     struct kvm_gmem *gmem =3D vmf->vma->vm_file->private_data;
> > +     struct inode *inode =3D file_inode(vmf->vma->vm_file);
> > +     pgoff_t pgoff =3D vmf->pgoff;
> > +     struct kvm_memory_slot *slot;
> > +     unsigned long index;
> > +     bool r =3D true;
> > +
> > +     filemap_invalidate_lock(inode->i_mapping);
> > +
> > +     xa_for_each_range(&gmem->bindings, index, slot, pgoff, pgoff) {
> > +             pgoff_t base_gfn =3D slot->base_gfn;
> > +             pgoff_t gfn_pgoff =3D slot->gmem.pgoff;
> > +             pgoff_t gfn =3D base_gfn + max(gfn_pgoff, pgoff) - gfn_pg=
off;
> > +
> > +             if (!kvm_slot_gmem_is_mappable(slot, gfn)) {
> > +                     r =3D false;
> > +                     break;
> > +             }
> > +     }
> > +
> > +     filemap_invalidate_unlock(inode->i_mapping);
> > +
> > +     return r;
> > +}
> > +
> > +static vm_fault_t kvm_gmem_fault(struct vm_fault *vmf)
> > +{
> > +     struct folio *folio;
> > +
> > +     folio =3D kvm_gmem_get_folio(file_inode(vmf->vma->vm_file), vmf->=
pgoff);
> > +     if (!folio)
> > +             return VM_FAULT_SIGBUS;
> > +
> > +     if (!kvm_gmem_isfaultable(vmf)) {
> > +             folio_unlock(folio);
> > +             folio_put(folio);
> > +             return VM_FAULT_SIGBUS;
> > +     }
> > +
> > +     vmf->page =3D folio_file_page(folio, vmf->pgoff);
> > +     return VM_FAULT_LOCKED;
> > +}
> > +
> > +static const struct vm_operations_struct kvm_gmem_vm_ops =3D {
> > +     .fault =3D kvm_gmem_fault,
> > +};
> > +
> > +static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma=
)
> > +{
> > +     if ((vma->vm_flags & (VM_SHARED | VM_MAYSHARE)) !=3D
> > +         (VM_SHARED | VM_MAYSHARE)) {
> > +             return -EINVAL;
> > +     }
> > +
> > +     file_accessed(file);
> > +     vm_flags_set(vma, VM_DONTDUMP);
> > +     vma->vm_ops =3D &kvm_gmem_vm_ops;
> > +
> > +     return 0;
> > +}
> > +#else
> > +#define kvm_gmem_mmap NULL
> > +#endif /* CONFIG_KVM_PRIVATE_MEM_MAPPABLE */
> > +
> >  static struct file_operations kvm_gmem_fops =3D {
> > +     .mmap           =3D kvm_gmem_mmap,
> >       .open           =3D generic_file_open,
> >       .release        =3D kvm_gmem_release,
> >       .fallocate      =3D kvm_gmem_fallocate,
> > @@ -369,6 +475,10 @@ static int __kvm_gmem_create(struct kvm *kvm, loff=
_t size, u64 flags)
> >       xa_init(&gmem->bindings);
> >       list_add(&gmem->entry, &inode->i_mapping->i_private_list);
> >
> > +#ifdef CONFIG_KVM_PRIVATE_MEM_MAPPABLE
> > +     xa_init(&gmem->unmappable_gfns);
> > +#endif
> > +
> >       fd_install(fd, file);
> >       return fd;
> >
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index 1192942aef91..f4b4498d4de6 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -3265,6 +3265,128 @@ static int next_segment(unsigned long len, int =
offset)
> >               return len;
> >  }
> >
> > +#ifdef CONFIG_KVM_PRIVATE_MEM_MAPPABLE
> > +static bool __kvm_gmem_is_mappable(struct kvm *kvm, gfn_t start, gfn_t=
 end)
> > +{
> > +     struct kvm_memslot_iter iter;
> > +
> > +     lockdep_assert_held(&kvm->slots_lock);
> > +
> > +     kvm_for_each_memslot_in_gfn_range(&iter, kvm_memslots(kvm), start=
, end) {
> > +             struct kvm_memory_slot *memslot =3D iter.slot;
> > +             gfn_t gfn_start, gfn_end, i;
> > +
> > +             gfn_start =3D max(start, memslot->base_gfn);
> > +             gfn_end =3D min(end, memslot->base_gfn + memslot->npages)=
;
> > +             if (WARN_ON_ONCE(gfn_start >=3D gfn_end))
> > +                     continue;
> > +
> > +             for (i =3D gfn_start; i < gfn_end; i++) {
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
> > +     r =3D __kvm_gmem_is_mappable(kvm, start, end);
> > +     mutex_unlock(&kvm->slots_lock);
> > +
> > +     return r;
> > +}
> > +
> > +static bool __kvm_gmem_is_mapped(struct kvm *kvm, gfn_t start, gfn_t e=
nd)
> > +{
> > +     struct kvm_memslot_iter iter;
> > +
> > +     lockdep_assert_held(&kvm->slots_lock);
> > +
> > +     kvm_for_each_memslot_in_gfn_range(&iter, kvm_memslots(kvm), start=
, end) {
> > +             struct kvm_memory_slot *memslot =3D iter.slot;
> > +             gfn_t gfn_start, gfn_end, i;
> > +
> > +             gfn_start =3D max(start, memslot->base_gfn);
> > +             gfn_end =3D min(end, memslot->base_gfn + memslot->npages)=
;
> > +             if (WARN_ON_ONCE(gfn_start >=3D gfn_end))
> > +                     continue;
> > +
> > +             for (i =3D gfn_start; i < gfn_end; i++) {
> > +                     struct page *page;
> > +                     bool is_mapped;
> > +                     kvm_pfn_t pfn;
> > +
> > +                     if (WARN_ON_ONCE(kvm_gmem_get_pfn_locked(kvm, mem=
slot, i, &pfn, NULL)))
> > +                             continue;
> > +
> > +                     page =3D pfn_to_page(pfn);
> > +                     is_mapped =3D page_mapped(page) || page_maybe_dma=
_pinned(page);
> > +                     unlock_page(page);
> > +                     put_page(page);
> > +
> > +                     if (is_mapped)
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
> > +     r =3D __kvm_gmem_is_mapped(kvm, start, end);
> > +     mutex_unlock(&kvm->slots_lock);
> > +
> > +     return r;
> > +}
> > +
> > +static int kvm_gmem_toggle_mappable(struct kvm *kvm, gfn_t start, gfn_=
t end,
> > +                                 bool is_mappable)
> > +{
> > +     struct kvm_memslot_iter iter;
> > +     int r =3D 0;
> > +
> > +     mutex_lock(&kvm->slots_lock);
> > +
> > +     kvm_for_each_memslot_in_gfn_range(&iter, kvm_memslots(kvm), start=
, end) {
> > +             struct kvm_memory_slot *memslot =3D iter.slot;
> > +             gfn_t gfn_start, gfn_end;
> > +
> > +             gfn_start =3D max(start, memslot->base_gfn);
> > +             gfn_end =3D min(end, memslot->base_gfn + memslot->npages)=
;
> > +             if (WARN_ON_ONCE(start >=3D end))
> > +                     continue;
> > +
> > +             r =3D kvm_slot_gmem_toggle_mappable(memslot, gfn_start, g=
fn_end, is_mappable);
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
> > +#endif /* CONFIG_KVM_PRIVATE_MEM_MAPPABLE */
> > +
> >  /* Copy @len bytes from guest memory at '(@gfn * PAGE_SIZE) + @offset'=
 to @data */
> >  static int __kvm_read_guest_page(struct kvm_memory_slot *slot, gfn_t g=
fn,
> >                                void *data, int offset, int len)
>
> [1] https://lore.kernel.org/all/20230914015531.1419405-15-seanjc@google.c=
om/
> [2] https://lore.kernel.org/all/cover.1691446946.git.ackerleytng@google.c=
om/T/
> [3] https://lore.kernel.org/all/ZQOmcc969s90DwNz@google.com/

