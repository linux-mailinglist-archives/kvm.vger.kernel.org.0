Return-Path: <kvm+bounces-40616-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E0941A591F6
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 11:55:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D2C0E16D316
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 10:54:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 406BE227563;
	Mon, 10 Mar 2025 10:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HSGQICjU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 924FD226D1E
	for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 10:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741603877; cv=none; b=B2fMwnYSIXmcEWXADzTV1jZagFbD1PX6xum/wEbgnY5QxWUqi+yXu7xFCmaIEqkJgTQsmeDBvhWJvcQX0cycfA08zI96WPcPPkzKlhqKnQ7KR4dT/eFl9NT1JRA+UKWEq9z1TzLSbri+bAhxrVTHqcLzvEU9d5EE0HzXis9H4CM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741603877; c=relaxed/simple;
	bh=5s3rawUIjr3yWblxOqJ18a21f4XARGwxCKHF/ItDOwk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aHGFOFO9DqMNpGAUkYJI6scHqLmOsCjReU1D3Fb05e9SJfEpldyEn8MpChQ4k99Yl3c3Sjau5uT87D2DHF+ODF9A7vfvQt3Eb3oeID3peF0pizJVi2gEaXgRh59EFjpKsfifMhYiIibLJ/WgjDFKVBQy2ec486Ix9V0JdZ9a3rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HSGQICjU; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-47681dba807so185411cf.1
        for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 03:51:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741603874; x=1742208674; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=GsgHhJNmkDq1O/YozvCptEjFHuaUcIYXqJY3xYqe+UM=;
        b=HSGQICjUVDQbm+8s9ps/aMKdw1s9i5H0291WxJz87RXBwaskSVQfJV1ngcXjKwMYwy
         tKJ6C9G+ibsMRvG7eNYSt644TRK4v7a31QXQpRwpxzwXARfv+pZrmGb2iIW3OdavQj+N
         txgJqlAZDYW3OOwwp79/k+mBHhheLfFLjcnWGaV1VL1zj2MFu08vQ4gFWI7vpLs5VbgR
         ADpoJMiLCa1/y5eHP2Yanc9h3pA+IawdMqIqlh1ICIhilaChyKqBZqytdSyTvlUQ7pLI
         B2D6ImBeFCGZp8Y57rwmGTgMVMSzldJ06rEo2dAx+KCyAL8FHFZBlyWOoRR02rurWN3O
         8AoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741603874; x=1742208674;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GsgHhJNmkDq1O/YozvCptEjFHuaUcIYXqJY3xYqe+UM=;
        b=OXbltLF0CixH5k46haS9HAYx2OZMZ8Wo9+KzW9Wj/FrtN4SBn6wNck0ial9eB7Ali0
         Zx/TXUO3ma2H9gV/dc11/DiZi8ZM/foz9HIGd+Az63PO73dFyxw55TCYntZAnmhBjnA6
         NYUloweGLLJJOvupLandMvI63xWDbBz4bs6J57IdK/3y2u8eeHClGh+9UTT9r39hbrE0
         2NotfICT726RraEpOlXiFqR7E6RYYP0LGyD3nleI1RjuIOrep9PS1KSPHYPCkik204D2
         2bleNdldWsInFFe9ka1oBjLyXbYQPyuRKGrXPECApihIa2M5GVtg2wthMfwGrJO4puNr
         MP/Q==
X-Gm-Message-State: AOJu0Yw6YccWigkqhs2oOYUccjJ6ONX+xhIW//DIU2sk7TWteC48lwQG
	CuTNotIFfsqVzbtHg6h730hu0wQTu3tbbp34PsZNm1ys0VqE1rknKTXu4bSjpRHSTpQ9jx6vt7c
	apr/q+zCxrzWvdvfFLeDClo+2OmVv/V++k63i
X-Gm-Gg: ASbGncvGf6YeMYhfkpZnmoKtueba7etPXTCM4WBDfHxBT/3FnGogn7upTyV1LsEtHxm
	JZLenVZal0ZckhPhL5BR+kH3itS31bxGMLpwqjWosOZlUG1HGp615Xm5CBqhjfvGRZEjtzSJHoM
	ZYag0BHDmXutjegqUrgyX14D67T7kUUn96DzM=
X-Google-Smtp-Source: AGHT+IFjx4d1g1257vPbEG4Ss+rawxH74R9/yXbl+GoTTbybUHaqCakPJfsdpLytVxhx4SVCnvjiKG47fh4ne3E9FtY=
X-Received: by 2002:a05:622a:2a0b:b0:471:eab0:ef21 with SMTP id
 d75a77b69052e-47668a7e96fmr5778091cf.13.1741603874136; Mon, 10 Mar 2025
 03:51:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250303171013.3548775-3-tabba@google.com> <diqzbjucu60l.fsf@ackerleytng-ctop.c.googlers.com>
In-Reply-To: <diqzbjucu60l.fsf@ackerleytng-ctop.c.googlers.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 10 Mar 2025 10:50:37 +0000
X-Gm-Features: AQ5f1Jrapxy-udzYyByq6fwLBA7bWnEYimb6j8q79RDN3N0_PrJEhUvOrrSfYks
Message-ID: <CA+EHjTxhumDswVVosDtvMojk-MJbJT=V8Cxhhnw2GGUDL74Mmw@mail.gmail.com>
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

On Fri, 7 Mar 2025 at 17:04, Ackerley Tng <ackerleytng@google.com> wrote:
>
> Fuad Tabba <tabba@google.com> writes:
>
> > Before transitioning a guest_memfd folio to unshared, thereby
> > disallowing access by the host and allowing the hypervisor to
> > transition its view of the guest page as private, we need to be
> > sure that the host doesn't have any references to the folio.
> >
> > This patch introduces a new type for guest_memfd folios, which
> > isn't activated in this series but is here as a placeholder and
> > to facilitate the code in the subsequent patch series. This will
> > be used in the future to register a callback that informs the
> > guest_memfd subsystem when the last reference is dropped,
> > therefore knowing that the host doesn't have any remaining
> > references.
> >
> > This patch also introduces the configuration option,
> > KVM_GMEM_SHARED_MEM, which toggles support for mapping
> > guest_memfd shared memory at the host.
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > Acked-by: Vlastimil Babka <vbabka@suse.cz>
> > Acked-by: David Hildenbrand <david@redhat.com>
> > ---
> >  include/linux/kvm_host.h   |  7 +++++++
> >  include/linux/page-flags.h | 16 ++++++++++++++++
> >  mm/debug.c                 |  1 +
> >  mm/swap.c                  |  9 +++++++++
> >  virt/kvm/Kconfig           |  5 +++++
> >  5 files changed, 38 insertions(+)
> >
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index f34f4cfaa513..7788e3625f6d 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -2571,4 +2571,11 @@ long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
> >                                   struct kvm_pre_fault_memory *range);
> >  #endif
> >
> > +#ifdef CONFIG_KVM_GMEM_SHARED_MEM
> > +static inline void kvm_gmem_handle_folio_put(struct folio *folio)
> > +{
> > +     WARN_ONCE(1, "A placeholder that shouldn't trigger. Work in progress.");
> > +}
> > +#endif
> > +
> >  #endif
>
> Following up with the discussion at the guest_memfd biweekly call on the
> guestmem library, I think this folio_put() handler for guest_memfd could
> be the first function that's refactored out into (placeholder name)
> mm/guestmem.c.
>
> This folio_put() handler has to stay in memory even after KVM (as a
> module) is unloaded from memory, and so it is a good candidate for the
> first function in the guestmem library.
>
> Along those lines, CONFIG_KVM_GMEM_SHARED_MEM in this patch can be
> renamed CONFIG_GUESTMEM, and CONFIG_GUESTMEM will guard the existence of
> PGTY_guestmem.
>
> CONFIG_KVM_GMEM_SHARED_MEM can be introduced in the next patch of this
> series, which could, in Kconfig, select CONFIG_GUESTMEM.
>
> > diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> > index 6dc2494bd002..daeee9a38e4c 100644
> > --- a/include/linux/page-flags.h
> > +++ b/include/linux/page-flags.h
> > @@ -933,6 +933,7 @@ enum pagetype {
> >       PGTY_slab       = 0xf5,
> >       PGTY_zsmalloc   = 0xf6,
> >       PGTY_unaccepted = 0xf7,
> > +     PGTY_guestmem   = 0xf8,
> >
> >       PGTY_mapcount_underflow = 0xff
> >  };
> > @@ -1082,6 +1083,21 @@ FOLIO_TYPE_OPS(hugetlb, hugetlb)
> >  FOLIO_TEST_FLAG_FALSE(hugetlb)
> >  #endif
> >
> > +/*
> > + * guestmem folios are used to back VM memory as managed by guest_memfd. Once
> > + * the last reference is put, instead of freeing these folios back to the page
> > + * allocator, they are returned to guest_memfd.
> > + *
> > + * For now, guestmem will only be set on these folios as long as they  cannot be
> > + * mapped to user space ("private state"), with the plan of always setting that
> > + * type once typed folios can be mapped to user space cleanly.
> > + */
> > +#ifdef CONFIG_KVM_GMEM_SHARED_MEM
> > +FOLIO_TYPE_OPS(guestmem, guestmem)
> > +#else
> > +FOLIO_TEST_FLAG_FALSE(guestmem)
> > +#endif
> > +
> >  PAGE_TYPE_OPS(Zsmalloc, zsmalloc, zsmalloc)
> >
> >  /*
> > diff --git a/mm/debug.c b/mm/debug.c
> > index 8d2acf432385..08bc42c6cba8 100644
> > --- a/mm/debug.c
> > +++ b/mm/debug.c
> > @@ -56,6 +56,7 @@ static const char *page_type_names[] = {
> >       DEF_PAGETYPE_NAME(table),
> >       DEF_PAGETYPE_NAME(buddy),
> >       DEF_PAGETYPE_NAME(unaccepted),
> > +     DEF_PAGETYPE_NAME(guestmem),
> >  };
> >
> >  static const char *page_type_name(unsigned int page_type)
> > diff --git a/mm/swap.c b/mm/swap.c
> > index 47bc1bb919cc..241880a46358 100644
> > --- a/mm/swap.c
> > +++ b/mm/swap.c
> > @@ -38,6 +38,10 @@
> >  #include <linux/local_lock.h>
> >  #include <linux/buffer_head.h>
> >
> > +#ifdef CONFIG_KVM_GMEM_SHARED_MEM
> > +#include <linux/kvm_host.h>
> > +#endif
> > +
> >  #include "internal.h"
> >
> >  #define CREATE_TRACE_POINTS
> > @@ -101,6 +105,11 @@ static void free_typed_folio(struct folio *folio)
> >       case PGTY_hugetlb:
> >               free_huge_folio(folio);
> >               return;
> > +#endif
> > +#ifdef CONFIG_KVM_GMEM_SHARED_MEM
> > +     case PGTY_guestmem:
> > +             kvm_gmem_handle_folio_put(folio);
> > +             return;
> >  #endif
> >       default:
> >               WARN_ON_ONCE(1);
> > diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
> > index 54e959e7d68f..37f7734cb10f 100644
> > --- a/virt/kvm/Kconfig
> > +++ b/virt/kvm/Kconfig
> > @@ -124,3 +124,8 @@ config HAVE_KVM_ARCH_GMEM_PREPARE
> >  config HAVE_KVM_ARCH_GMEM_INVALIDATE
> >         bool
> >         depends on KVM_PRIVATE_MEM
> > +
> > +config KVM_GMEM_SHARED_MEM
> > +       select KVM_PRIVATE_MEM
> > +       depends on !KVM_GENERIC_MEMORY_ATTRIBUTES
>
> Enforcing that KVM_GENERIC_MEMORY_ATTRIBUTES is not selected should not
> be a strict requirement. Fuad explained in an offline chat that this is
> just temporary.
>
> If we have CONFIG_GUESTMEM, then this question is moot, I think
> CONFIG_GUESTMEM would just be independent of everything else; other
> configs would depend on CONFIG_GUESTMEM.

There are two things here. First of all, the unfortunate naming
situation where PRIVATE could mean GUESTMEM, or private could mean not
shared. I plan to tackle this aspect (i.e., the naming) in a separate
patch series, since that will surely generate a lot of debate :)

The other part is that, with shared memory in-place, the memory
attributes are an orthogonal matter. The attributes are the userpace's
view of what it expects the state of the memory to be, and are used to
multiplex whether the memory being accessed is guest_memfd or the
regular (i.e., most likely anonymous) memory used normally by KVM.

This behavior however would be architecture, or even vm-type specific.

Cheers,
/fuad

> > +       bool

