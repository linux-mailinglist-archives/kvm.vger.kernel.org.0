Return-Path: <kvm+bounces-38353-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D2D0A37F96
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 11:14:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9F02E7A32D1
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 10:12:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7808321660F;
	Mon, 17 Feb 2025 10:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pu2P/1WY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 063EF19994F
	for <kvm@vger.kernel.org>; Mon, 17 Feb 2025 10:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739787179; cv=none; b=JAijAJ3aFi4oXJiZcTVO0M2T2B8XIaBK+EFlm8aGt66c0kme20IAexR+8GJMbfH0VduUUkjWPYE9NK6NCNx1IVsxc/s78R1+lt3JwejYj7296Ve6++U86fK/qIrGC3hbvrMTLgjKEBC6lrwLPYQend27v40ThCz6QU+9jE3gsQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739787179; c=relaxed/simple;
	bh=WVxCOhWZGD/ptOjl/WOx16aD8EEAF52M6nYUtx2JbSc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gUbc7j3Ibc5CjWF8LHFQdGr1cOb82rc05LfA3BNObe99DKGWtaFUn2xXedhK4eLrbkm8wkm6AAJQQ6RcAdWXy56BNe4kXn+mDrgpwT9vxbz7HB0IPXUK791t1+OqOVXM0SZv7SNT/+xaI3WrMMPGWAcsyDpKTvju0Lg6mwQAA34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pu2P/1WY; arc=none smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-471f1dd5b80so147381cf.1
        for <kvm@vger.kernel.org>; Mon, 17 Feb 2025 02:12:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739787177; x=1740391977; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=nlKhym8zl9LGwKUmtUYv9YGT5GjDeZYP6xFQFUouwy4=;
        b=pu2P/1WYpLahQMj5z/sPMN5v9bPRzkGMU4ygvMVw41B1Uav2yTFsvJQMM2+QSnYece
         sK0zVSKcKT6bAans5HSU4EeMcl+1p85GLn8oJXd6+ikVkUHQPmwukbn0ySwFwWhXz3GR
         uQxZgMY48GeWtplBUVu0+rWtIMP9ut2RV1kkUrPJJrMYMiHlMgMNHka8CHKq+6GZDXrA
         fukbHKFfv2eF/WYWW/tP+9CrBgMIW4wT6SCUvFYQfBai7M2pdGoj6MkpFRuRumscRorP
         zf00KnTYxvGezcZC1Tzara8TnxZEfMHEGJZm8xiIk1vfUpQGN7uywb9g0LmJFOv9UqW1
         5ODg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739787177; x=1740391977;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nlKhym8zl9LGwKUmtUYv9YGT5GjDeZYP6xFQFUouwy4=;
        b=LJhFcNeejhAY8FO8/em8hTopA+sgZTLVsZzW/2pm7TA9xtR5OXedBkluMUv6cF25Qh
         VmbeB81LB8w4bl4PkKQU0koiK+QqKbNi9ESWvJVLaUd86Dl5xMEAbj4EyQm+bsTfiBIt
         jecgh2FnHgflOk6SUutmRsBplQ0TSUpyWESM9dzUm6hIFf3rZzTkqkaRAx0ilMDRJ+AC
         yGib7PAcT3sbU0fkyxqSj/QF0XZ9HT8S0xMoguxfFq2wXCEuUD/PIqmPdRoei/mdnwsp
         5VyD7vXTCgKGuZhYM9JFt3FX5YrXDmLDGmBLycGY651h77fnURl6a+2u6VrlOWSZSxCi
         Ywag==
X-Gm-Message-State: AOJu0YzTdTkXcXIhA3Xyyt5/f9Ql+9asynzU35RCreYKrxxu05DunSp3
	NqqMLEAFlaNgmla1q5khILpy6kDN6XbbJqqdMnZEhTruC7Ps7t4CNkmgCYFnhSXcrvIqbVFeLWd
	zcIzDjTj/Fbynk8L+BFD1xEYxfA6hEJ/SSnu4
X-Gm-Gg: ASbGncvL9kzWN/OUYidJtqgH0U0iSF8AReKzJvuDNo8ciO3mg/90VfqfxUo61ee1uJ7
	uKBSdi7IWgLBnEeKNAEOfiVPY0UB6ZAdd3qptc1kxf+3Dfb1dqVZZlGUfaREEug9e0yZYDc0=
X-Google-Smtp-Source: AGHT+IGVLbRb2Tt68lERDKYQOH+x23qhLGTcRpfU/KEsvdcIcS3tMurxSoV6UshE+HSt+vvSMY+LmrnRvG808PQzWGs=
X-Received: by 2002:ac8:7f12:0:b0:46c:7cf2:d7b2 with SMTP id
 d75a77b69052e-471dc8efeadmr5803591cf.18.1739787176573; Mon, 17 Feb 2025
 02:12:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250211121128.703390-1-tabba@google.com> <20250211121128.703390-3-tabba@google.com>
 <4311493d-c709-485a-a36d-456e5c57c593@suse.cz>
In-Reply-To: <4311493d-c709-485a-a36d-456e5c57c593@suse.cz>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 17 Feb 2025 10:12:20 +0000
X-Gm-Features: AWEUYZnhQhBRvgy6eE-Fs5AKJxSeCgZAX5UjioT0ujGOI4-boR97-G0BW1BoAKM
Message-ID: <CA+EHjTxOmSQA90joVqR90cJ_eTrdvNfmAgtUmopP_ZdcaCPcjQ@mail.gmail.com>
Subject: Re: [PATCH v3 02/11] KVM: guest_memfd: Handle final folio_put() of
 guest_memfd pages
To: Vlastimil Babka <vbabka@suse.cz>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net, 
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
	jthoughton@google.com
Content-Type: text/plain; charset="UTF-8"

Hi Vlastimil,

On Mon, 17 Feb 2025 at 09:49, Vlastimil Babka <vbabka@suse.cz> wrote:
>
> On 2/11/25 13:11, Fuad Tabba wrote:
> > Before transitioning a guest_memfd folio to unshared, thereby
> > disallowing access by the host and allowing the hypervisor to
> > transition its view of the guest page as private, we need to be
> > sure that the host doesn't have any references to the folio.
> >
> > This patch introduces a new type for guest_memfd folios, which
> > isn't activated in this series but is here as a placeholder and
> > to facilitate the code in the next patch. This will be used in
>
> It's not clear to me how the code in the next page is facilitated as it
> doesn't use any of this?

I'm sorry about that, I'm missing the word "series". i.e.,

> > This patch introduces a new type for guest_memfd folios, which
> > isn't activated in this series but is here as a placeholder and
> > to facilitate the code in the next patch *series*.

I'm referring to this series:
https://lore.kernel.org/all/20250117163001.2326672-1-tabba@google.com/

> > the future to register a callback that informs the guest_memfd
> > subsystem when the last reference is dropped, therefore knowing
> > that the host doesn't have any remaining references.
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  include/linux/kvm_host.h   |  9 +++++++++
> >  include/linux/page-flags.h | 17 +++++++++++++++++
> >  mm/debug.c                 |  1 +
> >  mm/swap.c                  |  9 +++++++++
> >  virt/kvm/guest_memfd.c     |  7 +++++++
> >  5 files changed, 43 insertions(+)
> >
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index f34f4cfaa513..8b5f28f6efff 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -2571,4 +2571,13 @@ long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
> >                                   struct kvm_pre_fault_memory *range);
> >  #endif
> >
> > +#ifdef CONFIG_KVM_GMEM_SHARED_MEM
> > +void kvm_gmem_handle_folio_put(struct folio *folio);
> > +#else
> > +static inline void kvm_gmem_handle_folio_put(struct folio *folio)
> > +{
> > +     WARN_ON_ONCE(1);
> > +}
>
> Since the caller is guarded by CONFIG_KVM_GMEM_SHARED_MEM, do we need the
> CONFIG_KVM_GMEM_SHARED_MEM=n variant at all?

No. I'll remove it.

> > +#endif
> > +
> >  #endif
> > diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> > index 6dc2494bd002..734afda268ab 100644
> > --- a/include/linux/page-flags.h
> > +++ b/include/linux/page-flags.h
> > @@ -933,6 +933,17 @@ enum pagetype {
> >       PGTY_slab       = 0xf5,
> >       PGTY_zsmalloc   = 0xf6,
> >       PGTY_unaccepted = 0xf7,
> > +     /*
> > +      * guestmem folios are used to back VM memory as managed by guest_memfd.
> > +      * Once the last reference is put, instead of freeing these folios back
> > +      * to the page allocator, they are returned to guest_memfd.
> > +      *
> > +      * For now, guestmem will only be set on these folios as long as they
> > +      * cannot be mapped to user space ("private state"), with the plan of
>
> Might be a bit misleading as I don't think it's set yet as of this series.
> But I guess we can keep it to avoid another update later.

You're right, it's not in this series. But as you said, the idea is to
have the least amount of churn in the core mm code.

> > +      * always setting that type once typed folios can be mapped to user
> > +      * space cleanly.
> > +      */
> > +     PGTY_guestmem   = 0xf8,
> >
> >       PGTY_mapcount_underflow = 0xff
> >  };
> > @@ -1082,6 +1093,12 @@ FOLIO_TYPE_OPS(hugetlb, hugetlb)
> >  FOLIO_TEST_FLAG_FALSE(hugetlb)
> >  #endif
> >
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
>
> Do we need to guard the include?

Yes, otherwise allnoconfig complains due to many of the x86 things it
drags along if included but KVM isn't configured. I could put it in a
different header that doesn't have this problem, but I couldn't think
of a better header for this.

Thank you,
/fuad

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
> > diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> > index b2aa6bf24d3a..c6f6792bec2a 100644
> > --- a/virt/kvm/guest_memfd.c
> > +++ b/virt/kvm/guest_memfd.c
> > @@ -312,6 +312,13 @@ static pgoff_t kvm_gmem_get_index(struct kvm_memory_slot *slot, gfn_t gfn)
> >       return gfn - slot->base_gfn + slot->gmem.pgoff;
> >  }
> >
> > +#ifdef CONFIG_KVM_GMEM_SHARED_MEM
> > +void kvm_gmem_handle_folio_put(struct folio *folio)
> > +{
> > +     WARN_ONCE(1, "A placeholder that shouldn't trigger. Work in progress.");
> > +}
> > +#endif /* CONFIG_KVM_GMEM_SHARED_MEM */
> > +
> >  static struct file_operations kvm_gmem_fops = {
> >       .open           = generic_file_open,
> >       .release        = kvm_gmem_release,
>

