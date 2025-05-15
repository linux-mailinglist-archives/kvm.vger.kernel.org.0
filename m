Return-Path: <kvm+bounces-46647-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D87AAB7EBF
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 09:26:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C0E287A9E33
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 07:25:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE9AB201268;
	Thu, 15 May 2025 07:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="T6MQCOl7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D5111DC998
	for <kvm@vger.kernel.org>; Thu, 15 May 2025 07:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747293979; cv=none; b=GKB0ex4Vu2OLYcIu8mckXmkRwDcoFnkBhgGqiNup2sLIZL+30DqvL+hTF9dRMKdaixc5x8J7COVHNRAwx+QrwVdCRu3OF701Uh6lIWAPqXh0aubWKoXYOswOBo2u4ETcp2n4wUTQwWx/F6cf/0Eo7P7Mhy0dGYR4wIDEetIl1uU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747293979; c=relaxed/simple;
	bh=+MKTITXOSrT08G9Eu5488XtkD2q98TkP2wjjU3OAtrE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HIiRmvZ2SOr+tZfmSG1kdIJbjyEsW34Qpoaug4ETDgR6tAys/O6sKME/w1Nqhe8xoVlhP5GCjkvJ0KjIjBN/o9N0aGF0oNx0W+OJRBfFR0enNGMSeHo1xqxMRBjNGHu3Gi0UoR78OLr2VFmQhuBeeQW+H8ObSacoSGf2CTqjRfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=T6MQCOl7; arc=none smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-47e9fea29easo199481cf.1
        for <kvm@vger.kernel.org>; Thu, 15 May 2025 00:26:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747293974; x=1747898774; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vo4SLO3uNh2IdiJIh3hAoz8Rud5NcgG3L58yxFzW/g0=;
        b=T6MQCOl7pK8NiVfhxemhgozr5kBRzPqi+9CFfR/R5j2SymtF1jB7WlpiRtx/xavmhi
         F04q47jFEmXmKP8RYlaJdiv86/rhwZEMFGk8TpwRMm45i2/Heyw4RXIOlqg2PWfRfNnP
         fTCLs/nrjpBOrWVH+egEdGMevjQIPBkMB+cHgyY6Pnl5BYu2iwSbEIY6xBPOHmc5TBqU
         A/WxnymiSLRDtAtRYx0t/BIWiptM/77x4CcxoOSrX9+H/arnokoJTZo8mO5k6LdOUsLu
         tDRHdQtYnQMX4q5dz/ITQOmFLdw6eVLeNYJe/+JZSsu2r7D3geBAN20CJKMPkR10IZFB
         h48w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747293974; x=1747898774;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vo4SLO3uNh2IdiJIh3hAoz8Rud5NcgG3L58yxFzW/g0=;
        b=OmiRJKF0gTxWXfR/65MQrrin/JSmSVbxwTgCuoyg47FiS0ga55Wc+GObpTPWl70MW7
         5Ia4Ej3aOPRSpt7Bji3131GCxWWlzE4P/Ddhn4NjgOWTed88TyQWQwe9XhSQkktpivrs
         rJCT5QfEVZ2jruWnEFugEeBk0FYhrvwuIiN3X9n2tctt5Nw7YM5+rep2vGl75CnSROTB
         9g7nYlltSJ0Xo2SxTlIybL3gFFg3qwDWQdnRgYMCUiqfkEzTt7JzpA4g4K9ux5NQ63cI
         jo48TZwEIkm8MAnadvAd0gkg4BG2799BX/SjFY3QhHKpl6Yy5q892pbrs/LzKxUc9XAM
         EyJQ==
X-Gm-Message-State: AOJu0Yyl3miHsn6mXhcfi/RQNzZs1mCD5LJmBX3/H9NqKvsp9cP4rsxm
	1xcNtK+xsXIUC8MwO3yZPUaYWXlx2i/SGx62aWgnmHxI+kkQdRa9o2Dr4ZVOPbD8obT8V2T09dE
	Np0sZ/DXhXrCVQrfRkc6h5ZGHSkJn0q9CJEWLuVk/
X-Gm-Gg: ASbGncsamlncv6VB5WUFRSwvyKQvWtjwgj8nw6j3Zo5J9m75KRftd/GIQFOcOS+RhlV
	+dL3lltOi0U22Xv17Tt6/bYzyWZPBFsNL9VvKu9sy3J6EH7ihah7AqGX9m6x+W7LvfpdVi2spCJ
	1UBNHXRtZj06RI7+xyGCMpPjgqpLLpyf0UIHvHwugIlOGOFnez1rS/DHrxJDwq
X-Google-Smtp-Source: AGHT+IFI1q9T3RwZ6xR6YNcpKz27g0JYxyAEh0LrBO/Vj7UzKniC4Jf6LCjYBgSMVRYUsZxEm5bMo4KBwsYAMt3sch0=
X-Received: by 2002:a05:622a:11c5:b0:480:dde:aa4c with SMTP id
 d75a77b69052e-494a1cfecdemr2833071cf.4.1747293973589; Thu, 15 May 2025
 00:26:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250513163438.3942405-1-tabba@google.com> <20250513163438.3942405-8-tabba@google.com>
 <CADrL8HW+Rv4k-VX2s96n7m8OZ9R_NsHOCvtpAKUiwybiyJ63Pg@mail.gmail.com>
In-Reply-To: <CADrL8HW+Rv4k-VX2s96n7m8OZ9R_NsHOCvtpAKUiwybiyJ63Pg@mail.gmail.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 15 May 2025 09:25:36 +0200
X-Gm-Features: AX0GCFvCwY0hIEs4lzYRNAmALk_G43FJxm8AY9gAHiT2goR59wcIyYi271jWWsE
Message-ID: <CA+EHjTzxQn00Kj1s8+hfCg_1TXnurCiS3fJAFXy+NLfhuRXV5A@mail.gmail.com>
Subject: Re: [PATCH v9 07/17] KVM: guest_memfd: Allow host to map
 guest_memfd() pages
To: James Houghton <jthoughton@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
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
	peterx@redhat.com, pankaj.gupta@amd.com, ira.weiny@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 14 May 2025 at 22:40, James Houghton <jthoughton@google.com> wrote:
>
> ,
>
> On Tue, May 13, 2025 at 9:34=E2=80=AFAM Fuad Tabba <tabba@google.com> wro=
te:
> >
> > This patch enables support for shared memory in guest_memfd, including
> > mapping that memory at the host userspace. This support is gated by the
> > configuration option KVM_GMEM_SHARED_MEM, and toggled by the guest_memf=
d
> > flag GUEST_MEMFD_FLAG_SUPPORT_SHARED, which can be set when creating a
> > guest_memfd instance.
> >
> > Co-developed-by: Ackerley Tng <ackerleytng@google.com>
> > Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/x86/include/asm/kvm_host.h | 10 ++++
> >  include/linux/kvm_host.h        | 13 +++++
> >  include/uapi/linux/kvm.h        |  1 +
> >  virt/kvm/Kconfig                |  5 ++
> >  virt/kvm/guest_memfd.c          | 88 +++++++++++++++++++++++++++++++++
> >  5 files changed, 117 insertions(+)
> >
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm=
_host.h
> > index 709cc2a7ba66..f72722949cae 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -2255,8 +2255,18 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_=
forced_root_level,
> >
> >  #ifdef CONFIG_KVM_GMEM
> >  #define kvm_arch_supports_gmem(kvm) ((kvm)->arch.supports_gmem)
> > +
> > +/*
> > + * CoCo VMs with hardware support that use guest_memfd only for backin=
g private
> > + * memory, e.g., TDX, cannot use guest_memfd with userspace mapping en=
abled.
> > + */
> > +#define kvm_arch_vm_supports_gmem_shared_mem(kvm)                     =
 \
> > +       (IS_ENABLED(CONFIG_KVM_GMEM_SHARED_MEM) &&                     =
 \
> > +        ((kvm)->arch.vm_type =3D=3D KVM_X86_SW_PROTECTED_VM ||        =
     \
> > +         (kvm)->arch.vm_type =3D=3D KVM_X86_DEFAULT_VM))
> >  #else
> >  #define kvm_arch_supports_gmem(kvm) false
> > +#define kvm_arch_vm_supports_gmem_shared_mem(kvm) false
> >  #endif
> >
> >  #define kvm_arch_has_readonly_mem(kvm) (!(kvm)->arch.has_protected_sta=
te)
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index ae70e4e19700..2ec89c214978 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -729,6 +729,19 @@ static inline bool kvm_arch_supports_gmem(struct k=
vm *kvm)
> >  }
> >  #endif
> >
> > +/*
> > + * Returns true if this VM supports shared mem in guest_memfd.
> > + *
> > + * Arch code must define kvm_arch_vm_supports_gmem_shared_mem if suppo=
rt for
> > + * guest_memfd is enabled.
> > + */
> > +#if !defined(kvm_arch_vm_supports_gmem_shared_mem) && !IS_ENABLED(CONF=
IG_KVM_GMEM)
> > +static inline bool kvm_arch_vm_supports_gmem_shared_mem(struct kvm *kv=
m)
> > +{
> > +       return false;
> > +}
> > +#endif
> > +
> >  #ifndef kvm_arch_has_readonly_mem
> >  static inline bool kvm_arch_has_readonly_mem(struct kvm *kvm)
> >  {
> > diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> > index b6ae8ad8934b..9857022a0f0c 100644
> > --- a/include/uapi/linux/kvm.h
> > +++ b/include/uapi/linux/kvm.h
> > @@ -1566,6 +1566,7 @@ struct kvm_memory_attributes {
> >  #define KVM_MEMORY_ATTRIBUTE_PRIVATE           (1ULL << 3)
> >
> >  #define KVM_CREATE_GUEST_MEMFD _IOWR(KVMIO,  0xd4, struct kvm_create_g=
uest_memfd)
> > +#define GUEST_MEMFD_FLAG_SUPPORT_SHARED        (1UL << 0)
> >
> >  struct kvm_create_guest_memfd {
> >         __u64 size;
> > diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
> > index 559c93ad90be..f4e469a62a60 100644
> > --- a/virt/kvm/Kconfig
> > +++ b/virt/kvm/Kconfig
> > @@ -128,3 +128,8 @@ config HAVE_KVM_ARCH_GMEM_PREPARE
> >  config HAVE_KVM_ARCH_GMEM_INVALIDATE
> >         bool
> >         depends on KVM_GMEM
> > +
> > +config KVM_GMEM_SHARED_MEM
> > +       select KVM_GMEM
> > +       bool
> > +       prompt "Enables in-place shared memory for guest_memfd"
> > diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> > index 6db515833f61..8e6d1866b55e 100644
> > --- a/virt/kvm/guest_memfd.c
> > +++ b/virt/kvm/guest_memfd.c
> > @@ -312,7 +312,88 @@ static pgoff_t kvm_gmem_get_index(struct kvm_memor=
y_slot *slot, gfn_t gfn)
> >         return gfn - slot->base_gfn + slot->gmem.pgoff;
> >  }
> >
> > +#ifdef CONFIG_KVM_GMEM_SHARED_MEM
> > +
> > +static bool kvm_gmem_supports_shared(struct inode *inode)
> > +{
> > +       uint64_t flags =3D (uint64_t)inode->i_private;
> > +
> > +       return flags & GUEST_MEMFD_FLAG_SUPPORT_SHARED;
> > +}
> > +
> > +static vm_fault_t kvm_gmem_fault_shared(struct vm_fault *vmf)
> > +{
> > +       struct inode *inode =3D file_inode(vmf->vma->vm_file);
> > +       struct folio *folio;
> > +       vm_fault_t ret =3D VM_FAULT_LOCKED;
> > +
> > +       filemap_invalidate_lock_shared(inode->i_mapping);
> > +
> > +       folio =3D kvm_gmem_get_folio(inode, vmf->pgoff);
> > +       if (IS_ERR(folio)) {
> > +               int err =3D PTR_ERR(folio);
> > +
> > +               if (err =3D=3D -EAGAIN)
> > +                       ret =3D VM_FAULT_RETRY;
> > +               else
> > +                       ret =3D vmf_error(err);
> > +
> > +               goto out_filemap;
> > +       }
> > +
> > +       if (folio_test_hwpoison(folio)) {
> > +               ret =3D VM_FAULT_HWPOISON;
> > +               goto out_folio;
> > +       }
> > +
> > +       if (WARN_ON_ONCE(folio_test_large(folio))) {
> > +               ret =3D VM_FAULT_SIGBUS;
> > +               goto out_folio;
> > +       }
> > +
> > +       if (!folio_test_uptodate(folio)) {
> > +               clear_highpage(folio_page(folio, 0));
> > +               kvm_gmem_mark_prepared(folio);
> > +       }
> > +
> > +       vmf->page =3D folio_file_page(folio, vmf->pgoff);
> > +
> > +out_folio:
> > +       if (ret !=3D VM_FAULT_LOCKED) {
> > +               folio_unlock(folio);
> > +               folio_put(folio);
> > +       }
> > +
> > +out_filemap:
> > +       filemap_invalidate_unlock_shared(inode->i_mapping);
> > +
> > +       return ret;
> > +}
> > +
> > +static const struct vm_operations_struct kvm_gmem_vm_ops =3D {
> > +       .fault =3D kvm_gmem_fault_shared,
> > +};
> > +
> > +static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma=
)
> > +{
> > +       if (!kvm_gmem_supports_shared(file_inode(file)))
> > +               return -ENODEV;
> > +
> > +       if ((vma->vm_flags & (VM_SHARED | VM_MAYSHARE)) !=3D
> > +           (VM_SHARED | VM_MAYSHARE)) {
> > +               return -EINVAL;
> > +       }
> > +
> > +       vma->vm_ops =3D &kvm_gmem_vm_ops;
> > +
> > +       return 0;
> > +}
> > +#else
> > +#define kvm_gmem_mmap NULL
> > +#endif /* CONFIG_KVM_GMEM_SHARED_MEM */
> > +
> >  static struct file_operations kvm_gmem_fops =3D {
> > +       .mmap           =3D kvm_gmem_mmap,
> >         .open           =3D generic_file_open,
> >         .release        =3D kvm_gmem_release,
> >         .fallocate      =3D kvm_gmem_fallocate,
> > @@ -463,6 +544,9 @@ int kvm_gmem_create(struct kvm *kvm, struct kvm_cre=
ate_guest_memfd *args)
> >         u64 flags =3D args->flags;
> >         u64 valid_flags =3D 0;
> >
> > +       if (kvm_arch_vm_supports_gmem_shared_mem(kvm))
> > +               valid_flags |=3D GUEST_MEMFD_FLAG_SUPPORT_SHARED;
> > +
> >         if (flags & ~valid_flags)
> >                 return -EINVAL;
> >
> > @@ -501,6 +585,10 @@ int kvm_gmem_bind(struct kvm *kvm, struct kvm_memo=
ry_slot *slot,
> >             offset + size > i_size_read(inode))
> >                 goto err;
> >
> > +       if (kvm_gmem_supports_shared(inode) &&
>
> When building without CONFIG_KVM_GMEM_SHARED_MEM, my compiler
> complains that kvm_gmem_supports_shared() is not defined.

Thanks for pointing that out. I'll fix this.
/fuad
>
> > +           !kvm_arch_vm_supports_gmem_shared_mem(kvm))
> > +               goto err;
> > +
> >         filemap_invalidate_lock(inode->i_mapping);
> >
> >         start =3D offset >> PAGE_SHIFT;
> > --
> > 2.49.0.1045.g170613ef41-goog
> >

