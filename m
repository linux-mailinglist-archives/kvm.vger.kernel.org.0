Return-Path: <kvm+bounces-40656-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 030E7A597CB
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 15:37:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 31BBB3ABB60
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 14:37:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81B8E22D79A;
	Mon, 10 Mar 2025 14:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dUuDFTUH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BF3322D794
	for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 14:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741617360; cv=none; b=Pp4QApvqLb5auFMWvUtGL8w8LlAjB1NMPmT4ZmWxIOGmu7NwQUpnP5gkf71kuQ45nrELz/3HVnarEIIKu9pz7+jF0T/5yRjGcKGgUH+eAaKtpzSKDxdz8QALOL42eh4a3qtWKPfu8AXRW5hU4Oq8W9kgyb1zwwqv6ofEZQkgcws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741617360; c=relaxed/simple;
	bh=YaZrkZq9SjPm93NH4XlqVy59Y8iTWRLkh3XxggtDex8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EN5AMuBvNUAwfyM+4w87p49zr4wBZqJg4//8HazGi8KhbjI0qZj3VWBruKl/EWwHeWKHaztDIJ586v/RmmdeZZYpit0wxGhd24KNaFA5QJKr4GH6iM7EQot7pfKrWZBW71rU+sYw+IY69Pfk9LZFUru28mJei5D8BY8nvMIcTV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dUuDFTUH; arc=none smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-47681dba807so227081cf.1
        for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 07:35:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741617357; x=1742222157; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=7AKenLNL6X3uS3482+fJgsjvOVmCWlfTmQs/079icwE=;
        b=dUuDFTUHzUTjE9PlnZFUKZ+aMrBtPuHSNab/kmq9zQzoYxTHL251sZDIfgSNNyKuta
         fQ47h6pQGYU44WXd0xAKqKe85q9wp5uxjfpzsRqpFOkTRVCYeX/h2stskrqmGO/HffwZ
         cJEYUUnGxfijCVuMFhnoC+DOLJmxy5jUwNfr2HzyJ8MIF4uN5dsBe218OEl1wvLPKqzT
         20NgV+wb/kJQtPiCXFFe5zJXibNdXe+Pl37jgS+13JbcH7Vi0c5kgEkm601zSvhvmrKr
         1/j8dAKqqP+aszqJwnKTJaypCO2CRhyJwKmgFt4LJHL42HNpDXEN4fZY6vWSgXdWNx4F
         PLig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741617357; x=1742222157;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7AKenLNL6X3uS3482+fJgsjvOVmCWlfTmQs/079icwE=;
        b=ci0jmPvuJrMfh+pHd2vmbClUegOp9Uxa414cHKLiTIkdgtMLObfcTDBOpck2xVyAaN
         OzMOANmreZjza69fe8CzE2MWROfUrxvORpvNxxFJYVCfji7HVrli7jYf08zYO0R/d8xK
         MOoq1GyqGYzjgjKQL7SP6Sy8sDVG5Qk/tXfl5EKCMsyqVdJ5vHY5DnxNaX6x3bXeVWSS
         GYnL4Q7e3/bt68g6b4jPlFPRaq2tjAjc+tkKTP/0BtnXh0OjLt84QNKZxqyrfI9sVPbW
         ncHNZZckKn4Zh18YKysVyltTQMXfylFu9Nz7DZBhxCJPj7hni5C+CT4QmAo4uLXMzFBP
         1Z3Q==
X-Gm-Message-State: AOJu0YxNLWQkMOV3jlnd/CeTDbk/9Gr9wdvsqmSmYio6styIXdSPgogS
	LmZHtZNy3VfI0sn3k4e/8dvmNJvj5VImGlWZpoYov3c/McjZ667R1R0+traE3R7EBsAsvcpXRDn
	/pYuJFJoly+Wruf3drmkvuqpZ2LPybMo0kqS2
X-Gm-Gg: ASbGncvQkp+2zKU7Id53tUsgHTE76szu12adRWOQ2N2SDW/kcOvp2Fg63tUBMd/XA9i
	GiT1u4LEoM9nYVQFQPHOjy6EIZM4jvDcravJa+hCMwUVCJrlTUKY9++4T7uUMnnbAJO3vJMU7BP
	tJP8kO9gF1R0dH8guLgMzfhMjq
X-Google-Smtp-Source: AGHT+IELZMNpcNZxVVAes7Yvp9RPwEJWQwjVaiVupyMZoRqV6OzxPFLq2P3Lxi7fF72RmxV48sWkd2v4B0yhqGQOW8g=
X-Received: by 2002:a05:622a:2a0b:b0:471:eab0:ef21 with SMTP id
 d75a77b69052e-47668a7e96fmr6596751cf.13.1741617357220; Mon, 10 Mar 2025
 07:35:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250303171013.3548775-3-tabba@google.com> <diqzbjucu60l.fsf@ackerleytng-ctop.c.googlers.com>
 <CA+EHjTxhumDswVVosDtvMojk-MJbJT=V8Cxhhnw2GGUDL74Mmw@mail.gmail.com> <diqz4j01t15e.fsf@ackerleytng-ctop.c.googlers.com>
In-Reply-To: <diqz4j01t15e.fsf@ackerleytng-ctop.c.googlers.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 10 Mar 2025 14:35:20 +0000
X-Gm-Features: AQ5f1JpC9TjXQKryWVG5dXX_lw6XajYPTX52e9zXWHfytK3c-PmScHapjuQ9jXI
Message-ID: <CA+EHjTxH7JXpCGsOXA+ve6U8LVnmvY5QB0x00qKWPkpSKAowBg@mail.gmail.com>
Subject: Re: [PATCH v5 2/9] KVM: guest_memfd: Handle final folio_put() of
 guest_memfd pages
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

On Mon, 10 Mar 2025 at 14:23, Ackerley Tng <ackerleytng@google.com> wrote:
>
> Fuad Tabba <tabba@google.com> writes:
>
> > Hi Ackerley,
> >
> > On Fri, 7 Mar 2025 at 17:04, Ackerley Tng <ackerleytng@google.com> wrote:
> >>
> >> Fuad Tabba <tabba@google.com> writes:
> >>
> >> > Before transitioning a guest_memfd folio to unshared, thereby
> >> > disallowing access by the host and allowing the hypervisor to
> >> > transition its view of the guest page as private, we need to be
> >> > sure that the host doesn't have any references to the folio.
> >> >
> >> > This patch introduces a new type for guest_memfd folios, which
> >> > isn't activated in this series but is here as a placeholder and
> >> > to facilitate the code in the subsequent patch series. This will
> >> > be used in the future to register a callback that informs the
> >> > guest_memfd subsystem when the last reference is dropped,
> >> > therefore knowing that the host doesn't have any remaining
> >> > references.
> >> >
> >> > This patch also introduces the configuration option,
> >> > KVM_GMEM_SHARED_MEM, which toggles support for mapping
> >> > guest_memfd shared memory at the host.
> >> >
> >> > Signed-off-by: Fuad Tabba <tabba@google.com>
> >> > Acked-by: Vlastimil Babka <vbabka@suse.cz>
> >> > Acked-by: David Hildenbrand <david@redhat.com>
> >> > ---
> >> >  include/linux/kvm_host.h   |  7 +++++++
> >> >  include/linux/page-flags.h | 16 ++++++++++++++++
> >> >  mm/debug.c                 |  1 +
> >> >  mm/swap.c                  |  9 +++++++++
> >> >  virt/kvm/Kconfig           |  5 +++++
> >> >  5 files changed, 38 insertions(+)
> >> >
> >> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> >> > index f34f4cfaa513..7788e3625f6d 100644
> >> > --- a/include/linux/kvm_host.h
> >> > +++ b/include/linux/kvm_host.h
> >> > @@ -2571,4 +2571,11 @@ long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
> >> >                                   struct kvm_pre_fault_memory *range);
> >> >  #endif
> >> >
> >> > +#ifdef CONFIG_KVM_GMEM_SHARED_MEM
> >> > +static inline void kvm_gmem_handle_folio_put(struct folio *folio)
> >> > +{
> >> > +     WARN_ONCE(1, "A placeholder that shouldn't trigger. Work in progress.");
> >> > +}
> >> > +#endif
> >> > +
> >> >  #endif
> >>
> >> Following up with the discussion at the guest_memfd biweekly call on the
> >> guestmem library, I think this folio_put() handler for guest_memfd could
> >> be the first function that's refactored out into (placeholder name)
> >> mm/guestmem.c.
> >>
> >> This folio_put() handler has to stay in memory even after KVM (as a
> >> module) is unloaded from memory, and so it is a good candidate for the
> >> first function in the guestmem library.
> >>
> >> Along those lines, CONFIG_KVM_GMEM_SHARED_MEM in this patch can be
> >> renamed CONFIG_GUESTMEM, and CONFIG_GUESTMEM will guard the existence of
> >> PGTY_guestmem.
> >>
> >> CONFIG_KVM_GMEM_SHARED_MEM can be introduced in the next patch of this
> >> series, which could, in Kconfig, select CONFIG_GUESTMEM.
> >>
> >> > diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> >> > index 6dc2494bd002..daeee9a38e4c 100644
> >> > --- a/include/linux/page-flags.h
> >> > +++ b/include/linux/page-flags.h
> >> > @@ -933,6 +933,7 @@ enum pagetype {
> >> >       PGTY_slab       = 0xf5,
> >> >       PGTY_zsmalloc   = 0xf6,
> >> >       PGTY_unaccepted = 0xf7,
> >> > +     PGTY_guestmem   = 0xf8,
> >> >
> >> >       PGTY_mapcount_underflow = 0xff
> >> >  };
> >> > @@ -1082,6 +1083,21 @@ FOLIO_TYPE_OPS(hugetlb, hugetlb)
> >> >  FOLIO_TEST_FLAG_FALSE(hugetlb)
> >> >  #endif
> >> >
> >> > +/*
> >> > + * guestmem folios are used to back VM memory as managed by guest_memfd. Once
> >> > + * the last reference is put, instead of freeing these folios back to the page
> >> > + * allocator, they are returned to guest_memfd.
> >> > + *
> >> > + * For now, guestmem will only be set on these folios as long as they  cannot be
> >> > + * mapped to user space ("private state"), with the plan of always setting that
> >> > + * type once typed folios can be mapped to user space cleanly.
> >> > + */
> >> > +#ifdef CONFIG_KVM_GMEM_SHARED_MEM
> >> > +FOLIO_TYPE_OPS(guestmem, guestmem)
> >> > +#else
> >> > +FOLIO_TEST_FLAG_FALSE(guestmem)
> >> > +#endif
> >> > +
> >> >  PAGE_TYPE_OPS(Zsmalloc, zsmalloc, zsmalloc)
> >> >
> >> >  /*
> >> > diff --git a/mm/debug.c b/mm/debug.c
> >> > index 8d2acf432385..08bc42c6cba8 100644
> >> > --- a/mm/debug.c
> >> > +++ b/mm/debug.c
> >> > @@ -56,6 +56,7 @@ static const char *page_type_names[] = {
> >> >       DEF_PAGETYPE_NAME(table),
> >> >       DEF_PAGETYPE_NAME(buddy),
> >> >       DEF_PAGETYPE_NAME(unaccepted),
> >> > +     DEF_PAGETYPE_NAME(guestmem),
> >> >  };
> >> >
> >> >  static const char *page_type_name(unsigned int page_type)
> >> > diff --git a/mm/swap.c b/mm/swap.c
> >> > index 47bc1bb919cc..241880a46358 100644
> >> > --- a/mm/swap.c
> >> > +++ b/mm/swap.c
> >> > @@ -38,6 +38,10 @@
> >> >  #include <linux/local_lock.h>
> >> >  #include <linux/buffer_head.h>
> >> >
> >> > +#ifdef CONFIG_KVM_GMEM_SHARED_MEM
> >> > +#include <linux/kvm_host.h>
> >> > +#endif
> >> > +
> >> >  #include "internal.h"
> >> >
> >> >  #define CREATE_TRACE_POINTS
> >> > @@ -101,6 +105,11 @@ static void free_typed_folio(struct folio *folio)
> >> >       case PGTY_hugetlb:
> >> >               free_huge_folio(folio);
> >> >               return;
> >> > +#endif
> >> > +#ifdef CONFIG_KVM_GMEM_SHARED_MEM
> >> > +     case PGTY_guestmem:
> >> > +             kvm_gmem_handle_folio_put(folio);
> >> > +             return;
> >> >  #endif
> >> >       default:
> >> >               WARN_ON_ONCE(1);
> >> > diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
> >> > index 54e959e7d68f..37f7734cb10f 100644
> >> > --- a/virt/kvm/Kconfig
> >> > +++ b/virt/kvm/Kconfig
> >> > @@ -124,3 +124,8 @@ config HAVE_KVM_ARCH_GMEM_PREPARE
> >> >  config HAVE_KVM_ARCH_GMEM_INVALIDATE
> >> >         bool
> >> >         depends on KVM_PRIVATE_MEM
> >> > +
> >> > +config KVM_GMEM_SHARED_MEM
> >> > +       select KVM_PRIVATE_MEM
> >> > +       depends on !KVM_GENERIC_MEMORY_ATTRIBUTES
> >>
> >> Enforcing that KVM_GENERIC_MEMORY_ATTRIBUTES is not selected should not
> >> be a strict requirement. Fuad explained in an offline chat that this is
> >> just temporary.
> >>
> >> If we have CONFIG_GUESTMEM, then this question is moot, I think
> >> CONFIG_GUESTMEM would just be independent of everything else; other
> >> configs would depend on CONFIG_GUESTMEM.
> >
> > There are two things here. First of all, the unfortunate naming
> > situation where PRIVATE could mean GUESTMEM, or private could mean not
> > shared. I plan to tackle this aspect (i.e., the naming) in a separate
> > patch series, since that will surely generate a lot of debate :)
> >
>
> Oops. By "depend on CONFIG_GUESTMEM" I meant "depend on the introduction
> of the guestmem shim". I think this is a good time to introduce the shim
> because the folio_put() callback needs to be in mm and not just in KVM,
> which is a loadable module and hence can be removed from memory.
>
> If we do introduce the shim, the config flag CONFIG_KVM_GMEM_SHARED_MEM
> will be replaced by CONFIG_GUESTMEM (or other name), and then the
> question on depending on !KVM_GENERIC_MEMORY_ATTRIBUTES will be moot
> since I think an mm config flag wouldn't place a constraint on a module
> config flag?

I see.

> When I wrote this, I thought that config flags are easily renamed since
> they're an interface and are user-facing, but I realized config flag
> renaming seems to be easily renamed based on this search [1].
>
> If we're going with renaming in a separate patch series, some mechanism
> should be introduced here to handle the case where

I'm not talking about renaming the contents of _this_ patch series. I
was referring to existing tems such as, CONFIG_KVM_PRIVATE_MEM, which
really enabled guestmemfd.

> 1. Kernel (and KVM module) is compiled with KVM_GMEM_SHARED_MEM set
> 2. KVM is unloaded
> 3. folio_put() tries to call kvm_gmem_handle_folio_put()
>
> > The other part is that, with shared memory in-place, the memory
> > attributes are an orthogonal matter. The attributes are the userpace's
> > view of what it expects the state of the memory to be, and are used to
> > multiplex whether the memory being accessed is guest_memfd or the
> > regular (i.e., most likely anonymous) memory used normally by KVM.
> >
> > This behavior however would be architecture, or even vm-type specific.
> >
>
> I agree it is orthogonal but I'm calling this out because "depends on
> !KVM_GENERIC_MEMORY_ATTRIBUTES" means if I set
> CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES, I can't use PGTY_guestmem since
> CONFIG_KVM_GMEM_SHARED_MEM would get unset.

I'll remove this dependence in the respin.

Thanks,
/fiad

> I was trying to test this with a KVM_X86_SW_PROTECTED_VM, setting up for
> using the ioctl to convert memory and hit this issue.
>
> > Cheers,
> > /fuad
> >
> >> > +       bool
>
> [1] https://lore.kernel.org/all/?q=s%3Arename+dfn%3AKconfig+merged

