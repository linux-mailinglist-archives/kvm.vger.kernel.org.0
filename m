Return-Path: <kvm+bounces-36966-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FD9FA23AF3
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2025 10:03:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2068B3A4B5A
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2025 09:03:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB79617B50A;
	Fri, 31 Jan 2025 09:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QQJIaMSE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BE0B158874
	for <kvm@vger.kernel.org>; Fri, 31 Jan 2025 09:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738314212; cv=none; b=J1yVa6cMd1B9sFmy2g0D5wWyJ50zMK3JX0OOi87WhYQDK26VPoIQELq/sO3Ywwkj6D+ircZiqXWxHjXPV6fxu0lAEd2yUk0gQ+UXiModJA+EYtRmRAMZ7WSSV5mgFtto6vpAjr2gQy3Su7iP0fnpaopbvyrr/ilfHgKH9yMYAAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738314212; c=relaxed/simple;
	bh=EoVrHRnXlkW1B1yrCPQwm6dSmRtgl5mWylDtN4dY6aE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=H56sOVoIJfvD1xZ0974LwyqWmyMbxU0BPuK4Y3pr+454PvXMrBaFm666qONjyNr+1FyEz/ippzHCiVcR2qyrOGkP4BGu3iJUMkt46Kifz+ewxGMD2yTxxHBMti2UWRMhUTKy3igl44G0DMXHX1NMbn+tdYjio4ECxIJQnEFSC2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QQJIaMSE; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-467896541e1so190151cf.0
        for <kvm@vger.kernel.org>; Fri, 31 Jan 2025 01:03:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738314208; x=1738919008; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=4Mo+GC6yFA5Ztpsio14NKJ1phuDePDI7QDGE48Y413s=;
        b=QQJIaMSE8OzRURd3NHfonFbusJZu3TjAfmDY4CoR0FZqwTYKJjV0Evv7cCw9iGbXvp
         djNV77UpqsasIdQYywhUUYNJx4PpIiWjniUUmHfjmBd9NjawxXdSQX2AjqEZ8/bdeOrK
         NoIdUMTsH8enOmbIeJQ/Z2tZs0aLzboiJgbqHws4BDwanbl6QB7yEtLoFHuQCIQHwW0J
         xWC2mObJcx/Z+m8PA2M7Lknbw+5sEBHg1JC1V1P+0uwgNmn6KTiRPjSwDbj8Oe3d7fjF
         mgMK/iNc6568x0/uzYJ+3vqEuiS8IBETGg9+lBIbg56LE4lnmnmP+08jeZwk5HsZm6im
         h0Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738314208; x=1738919008;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4Mo+GC6yFA5Ztpsio14NKJ1phuDePDI7QDGE48Y413s=;
        b=mVCnKvuRkRhwUwiPj5lj1CnjmbFK9MLE4d8h5aOFyqMcx3rmV89C9yJwBbsGAvgOfc
         tusElYrFEitWUGzRUqsAKhqf4KmMYdC1x3JVFB/Rf3iZzMzC6Jq3GPimHIRZ0FsfpGbP
         yLJryuf0Wz3RrDv2eWdTcD17z95wtk7Y1iXzU3ySWcVmbGCQdfeUMlGRtSAtSuyOjjKO
         aqHe/1opdO+rpVgcKQS0/E3t6nohCopJDHS/508ZbCk79UBFXrr+Qh5jJghqwwc2Rq1z
         lQhvEffhP0t36dMwzP4odROsA5iOGk4CDdU7jeZb8Jfx8om2m+y1j4xyqTZu1KTVcnEG
         jaPQ==
X-Gm-Message-State: AOJu0YzYOzjkQkXSN5v2jiM0DWfpQcO5Ec+0g1c5Dg60i8/x6YlPnb3o
	GeLfRSfZuWRTbbWo0sSci+1ZEedr9BI48rXzLtO4t8HBjLsZgu2jJgUBaVPngFOAudIseHmSys6
	Un4DGTMOHOIcllP/ckc3HlradQ8ne7lEem+zj
X-Gm-Gg: ASbGncvGaSV9zC+4igNfzCRS5x2pThnURj3Ut9aiHoBDtkCJyxvvG22bOSLwbyt0jYW
	MaDhT4TFXaUc3oQxrrQpC+EGYnExiRG8rt9sic4ezfwtklB8YB07g7vc9WHnvRjRP7FzhJKU=
X-Google-Smtp-Source: AGHT+IF4Dq59qxo2shTk8KrBF3fx/0sCwNmRYQy/EY0ENabK1dLq192kfb/CDGibXmMRQgVHcGeBwEp/yEIpI58g3k8=
X-Received: by 2002:a05:622a:1c12:b0:467:7c30:3446 with SMTP id
 d75a77b69052e-46febf30f42mr1801021cf.25.1738314207981; Fri, 31 Jan 2025
 01:03:27 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250129172320.950523-1-tabba@google.com> <20250129172320.950523-3-tabba@google.com>
 <0ca9f444-b63f-4259-9462-014e0d0f1a74@redhat.com>
In-Reply-To: <0ca9f444-b63f-4259-9462-014e0d0f1a74@redhat.com>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 31 Jan 2025 09:02:51 +0000
X-Gm-Features: AWEUYZkjvahAkrTgFgE9-yfy_FHWS8vY1gGnGfHZezzGJRobh2nD57PjGovCmDU
Message-ID: <CA+EHjTxP-zZNWhvbVjBZRcE9XcgUGjzN6Gikti6FHeY-fjkCFQ@mail.gmail.com>
Subject: Re: [RFC PATCH v2 02/11] KVM: guest_memfd: Handle final folio_put()
 of guest_memfd pages
To: David Hildenbrand <david@redhat.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com, 
	mail@maciej.szmigiero.name, michael.roth@amd.com, wei.w.wang@intel.com, 
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

Hi David,

On Thu, 30 Jan 2025 at 17:16, David Hildenbrand <david@redhat.com> wrote:
>
> On 29.01.25 18:23, Fuad Tabba wrote:
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
> >   include/linux/page-flags.h | 7 +++++++
> >   mm/debug.c                 | 1 +
> >   mm/swap.c                  | 5 +++++
> >   3 files changed, 13 insertions(+)
> >
> > diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> > index 6615f2f59144..bab3cac1f93b 100644
> > --- a/include/linux/page-flags.h
> > +++ b/include/linux/page-flags.h
> > @@ -942,6 +942,7 @@ enum pagetype {
> >       PGTY_slab       = 0xf5,
> >       PGTY_zsmalloc   = 0xf6,
> >       PGTY_unaccepted = 0xf7,
> > +     PGTY_guestmem   = 0xf8,
> >
> >       PGTY_mapcount_underflow = 0xff
> >   };
> > @@ -1091,6 +1092,12 @@ FOLIO_TYPE_OPS(hugetlb, hugetlb)
> >   FOLIO_TEST_FLAG_FALSE(hugetlb)
> >   #endif
> >
>
> Some short doc would be nice, to at least hint that this is related to
> guest_memfd, and that these are otherwise folios.
>
>
> /*
>   * guestmem folios are folios that are used to back VM memory as managed
>   * guest_memfd. Once the last reference is put, instead of freeing these
>   * folios back to the page allocator, they are returned to guest_memfd.
>   *
>   * For now, guestmem will only be set on these folios as long as they
>   * cannot be mapped to user space ("private state"), with the plan of
>   * always setting that type once typed folios can be mapped to user
>   * space cleanly.
>   */

Will add this.

> > +#ifdef CONFIG_KVM_GMEM_MAPPABLE
> > +FOLIO_TYPE_OPS(guestmem, guestmem)
> > +#else
> > +FOLIO_TEST_FLAG_FALSE(guestmem)
> > +#endif
> > +
> >   PAGE_TYPE_OPS(Zsmalloc, zsmalloc, zsmalloc)
> >
> >   /*
> > diff --git a/mm/debug.c b/mm/debug.c
> > index 95b6ab809c0e..db93be385ed9 100644
> > --- a/mm/debug.c
> > +++ b/mm/debug.c
> > @@ -56,6 +56,7 @@ static const char *page_type_names[] = {
> >       DEF_PAGETYPE_NAME(table),
> >       DEF_PAGETYPE_NAME(buddy),
> >       DEF_PAGETYPE_NAME(unaccepted),
> > +     DEF_PAGETYPE_NAME(guestmem),
>  >   };>
> >   static const char *page_type_name(unsigned int page_type)
> > diff --git a/mm/swap.c b/mm/swap.c
> > index 8a66cd9cb9da..73d61c7f8edd 100644
> > --- a/mm/swap.c
> > +++ b/mm/swap.c
> > @@ -37,6 +37,7 @@
> >   #include <linux/page_idle.h>
> >   #include <linux/local_lock.h>
> >   #include <linux/buffer_head.h>
> > +#include <linux/kvm_host.h>
> >
> >   #include "internal.h"
> >
> > @@ -101,6 +102,10 @@ static void free_typed_folio(struct folio *folio)
> >               if (IS_ENABLED(CONFIG_HUGETLBFS))
> >                       free_huge_folio(folio);
> >               return;
> > +     case PGTY_guestmem:
> > +             if (IS_ENABLED(CONFIG_KVM_GMEM_SHARED_MEM))
> > +                     WARN_ONCE(1, "A placeholder that shouldn't trigger.");
>
>
> Does it make sense to directly introduce the callback into guest_memfd
> and handle the WARN_ONCE() in there? Then, we don't have tot ouch this
> core code later again.

Yes. That would simplify things.

Thanks,
/fuad

> --
> Cheers,
>
> David / dhildenb
>

