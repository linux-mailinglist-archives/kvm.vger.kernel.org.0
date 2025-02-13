Return-Path: <kvm+bounces-38012-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E083A339F8
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2025 09:30:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F26C816637F
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2025 08:30:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA8A920C012;
	Thu, 13 Feb 2025 08:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zwZvRTMl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45FCE1F7092
	for <kvm@vger.kernel.org>; Thu, 13 Feb 2025 08:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739435400; cv=none; b=K+NsXOeNjYF5E6mOdfQssMXzoEyN/o0/iFsCcpJdfw3w9edYZzoqxLtXzE+lI9id09jX5MY8/k14cFCg/pox7QH6Os5qSTZI6F86VaPqlmVySc88o2itq2oyTo10XA6wJ+mGGBP27ykUS4mL0DlVPfVAQ6G996KeF6XPCXl9g7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739435400; c=relaxed/simple;
	bh=w2PaYZQhxKg8zPkhEMACugQXCZ9uJ9CNfpnkS1Z8850=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bD8v7AMpwft74kPw/wQoA8GXYXR+ZcFvQJ6J8leig3AjpJaf9n7yDtCkXeRC5Ef1oTLKsWI7p6qNRQCbUspwqAiKsOoMVkgTQarDRwcY5PklezcBisY2ai8E3oVn+NRL2qDYIxduNeZgifkeegNBM66ajX7gDa0PE4tuIBe8uQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zwZvRTMl; arc=none smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-471c9947bb5so9201cf.1
        for <kvm@vger.kernel.org>; Thu, 13 Feb 2025 00:29:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739435397; x=1740040197; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=c8rc+eSLaASsL8fL1WESUdpU7jFTDlqjkIgb+1SucNc=;
        b=zwZvRTMl5+ONVUgt7allpU8AYr++GuXUEX7DcKL7Bdh7/UH7yxTMLj9cP1gorX7bPK
         MOa+pXeQLDYiztfDtz2es0kn6xOvhrpiESM4fpgLi7grO3pZzcst5ileNP/4meQEbx7K
         0YrZ566ssw6W480ak+YWoY9RbOZoGPv9IuM95OyzftNOUBopmESpFUkNBs25AecmfHla
         UxaBYaHJiaLgcRzPP/Qy9f8T4YIcUjVmGK65m1tCGrUxCiCa/ELmWd1LdbV1a095lAgo
         FHoEXkDEx5y36u51WbANphFYz7W1JRXr4gu88j4BZufsLgMPMJPBbH6JiLo/AiMFu4WG
         pCow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739435397; x=1740040197;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=c8rc+eSLaASsL8fL1WESUdpU7jFTDlqjkIgb+1SucNc=;
        b=M7CEBBLOpCwpL4n6qYRNPWCiD+kvsih8OLS1+q8/bwNhYOcNfgLAcpjTWrp3pE5yGH
         RMjwbvRW9kaXre6EKQ4zG16WhV6AbdXECl5qktjSfhWQ6psXnTtijqypCnX1aO9tEPIi
         QPiVyZDL82vmeUtHq9kJlvGBrGRpozs4p05hHQoQwrKqMT2UfoIbSemuicitznGkQEBE
         h2Jb/ZyVqsozjZYjYX1sNzQeZhFxzc69F96hLPwbxw24ToXbu7CKbpLjdsHB7FSuBrMk
         Ce8rWdJnoI0DZy+mle/DZDHCXdBKM1ASZVWSxZ1nb/M9ybWJLzlPCrqsRxmsGzgZ4M06
         2EyQ==
X-Gm-Message-State: AOJu0YxRFZv9FEVHCEn7Fn/dxeWS9ntJ+yua/Dapr7Yziri04b4wPdFB
	hEdoqko7vblkE21DHnsZHLx//r2YrGv1s0CZr9cvpTKOWddQUCb4hBSuE5fHCWdeXBWTQ8uyprN
	qmQvaEP/LyUogiEnPG6vpkaRKXqnKC0MWS/8m
X-Gm-Gg: ASbGncsHq8QrjfhMnWRsa979/uNFfeB1joJY46354C/uGXIdsqbfZ9IdX53p1fnF9++
	CbfmYC2s3q9Khu1KUTTCtPPBrDQaTUMIGEW5NQGEnMm6pTunParEwNQsTbWOePOX56E6y5Bw=
X-Google-Smtp-Source: AGHT+IFsf1LqrhAqThDkdlzjRpdFWXlMNBndbl2/UG8PnTSAsROmdqRusrs9lXPALGBNxc/+lw2WAbpz/r3EtXijSuw=
X-Received: by 2002:a05:622a:1a8b:b0:46e:1311:5920 with SMTP id
 d75a77b69052e-471bfff7a0fmr2462921cf.0.1739435396819; Thu, 13 Feb 2025
 00:29:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250211121128.703390-1-tabba@google.com> <20250211121128.703390-3-tabba@google.com>
 <Z6zmOQLrAjhhM1Pn@x1.local>
In-Reply-To: <Z6zmOQLrAjhhM1Pn@x1.local>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 13 Feb 2025 08:29:20 +0000
X-Gm-Features: AWEUYZliaZUBkqWCmEwfTO5kaA5s4qzUgPc9AubPU2YL7pSedrAov_-FXME_4Is
Message-ID: <CA+EHjTw4CeX8uCEL0F1SsRdGQzC7L85A1JnDcOcxHc8oRiNZng@mail.gmail.com>
Subject: Re: [PATCH v3 02/11] KVM: guest_memfd: Handle final folio_put() of
 guest_memfd pages
To: Peter Xu <peterx@redhat.com>
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
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com
Content-Type: text/plain; charset="UTF-8"

Hi Peter,

On Wed, 12 Feb 2025 at 18:19, Peter Xu <peterx@redhat.com> wrote:
>
> On Tue, Feb 11, 2025 at 12:11:18PM +0000, Fuad Tabba wrote:
> > Before transitioning a guest_memfd folio to unshared, thereby
> > disallowing access by the host and allowing the hypervisor to
> > transition its view of the guest page as private, we need to be
> > sure that the host doesn't have any references to the folio.
> >
> > This patch introduces a new type for guest_memfd folios, which
> > isn't activated in this series but is here as a placeholder and
> > to facilitate the code in the next patch. This will be used in
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
> > +      * always setting that type once typed folios can be mapped to user
> > +      * space cleanly.
>
> Does it imply that gmem folios can be mapped to userspace at some point?
> It'll be great if you can share more about it, since as of now it looks
> like anything has a page type cannot use the per-page mapcount.

This is the goal of this series. By the end of this series, you can
map gmem folios, as long as they belong to a VM type that allows it.
My other series, which will be rebased on this one, adds the
distinction of memory shared with the host vs memory private to the
guest:

https://lore.kernel.org/all/20250117163001.2326672-1-tabba@google.com/

That series deals with the mapcount issue, by only applying the type
once the mapcount is 0. We talked about this in the guest_memfd mm
sync, David Hildenbrand mentioned ongoing work to remove the
overlaying of the type with the memcount. That should solve the
problem completely.


> When looking at this, I also found that __folio_rmap_sanity_checks() has
> some folio_test_hugetlb() tests, not sure whether they're prone to be
> changed too e.g. to cover all pages that have a type, so as to cover gmem.
>
> For the longer term, it'll be definitely nice if gmem folios can be
> mapcounted just like normal file folios.  It can enable gmem as a backstore
> just like what normal memfd would do, with gmem managing the folios.

That's the plan, I agree.

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
>
> This seems to only be defined in follow up patches.. so may need some
> adjustments.

It's a configuration option. If you like, I could bring forward the
patch that adds it to the kconfig file.

Thank you,
/fuad

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
> > --
> > 2.48.1.502.g6dc24dfdaf-goog
> >
> >
>
> --
> Peter Xu
>

