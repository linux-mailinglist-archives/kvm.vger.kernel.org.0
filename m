Return-Path: <kvm+bounces-38673-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B367A3D8F5
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 12:40:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4E70D3BEEF4
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 11:38:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6016E1F3FE2;
	Thu, 20 Feb 2025 11:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="e7jk6Ndj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E82432862BD
	for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 11:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740051531; cv=none; b=Rsh4ObF8lUHHVHzaePuWdrogp0Hzu+OXgMbKZw73pPupzw/5/grF3SnedzrnEsh4wu3JaNyRezIfa2sDJ87iUTdgjT7RSmrYcMc2kyQmLPtf4qWqzx+YedBasaLgPEHWiI9emP45/U6yF0gOyHclRq8brvioyNXTQT8biYllWAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740051531; c=relaxed/simple;
	bh=3EYE/hOFgBKydv3SlXz7sckrhbnZ0WO6CFi6yD/8LPw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PsZ5eRMRFQxrNzFBJChjYzRCpz1ld/kE2iP6ClGNht9Z0tndu0gcyk6BAb0T1K2DsoFvXRXU1lvu9eCIKqDdJoZsMs939S6CNhdJYtXTJaHLLgBLrD1dRT4mkEcnP7UmapV5V8mU0eJJhp4R5GX2jh6OpAZN7y/wsl7mb7ZhgYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=e7jk6Ndj; arc=none smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-471fbfe8b89so332811cf.0
        for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 03:38:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740051529; x=1740656329; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ys6kQVVBL2vynLjpOKVUO3tXzWqL+3hbPNY+S/nc6CQ=;
        b=e7jk6NdjBKnoyoJimeUYx+lxjkerMTgi4Cetxu4HTtbbtiN+hZMfVZa3xYBPlym5HB
         0g3aSZdmjw3tEvtrda4/52FNSFWxn2fmibd9ag6N3zmw3GAfL6o72FdaB4uizJsEsDaX
         MzP5XXXMhEhBTGaIDDtkaTn1i5pSe+CrWdJRQJkJgW35mcr+N5/xrjrCpFm2EF3Jg3tG
         ls4xO7j9pq/e/ikbO1WH4jNTZcBq9BAakNDS7i05sPOTm52b1inuEAHEReKjaDTTNnqI
         PsPi2d+aQlbjNGURydjbefkgKhy46i/D7ZmevwqgL5W/14XcnT83T7DX4IZ1iJeJ/7eg
         hnrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740051529; x=1740656329;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ys6kQVVBL2vynLjpOKVUO3tXzWqL+3hbPNY+S/nc6CQ=;
        b=e/n8FNHOPbtA+7X0RPYhwgMbK28CXK5RcSpLOkP4qDMher0Db3vHtvd+ihkIu6iw8w
         IexdkTjNTa1eRvCTpx6n9x634Od2sScWgo+iWpadE5pwTfbGHZI+KpUC9i5rxUzL/mjv
         QRr8pB6U8k9n6Mjs2un69C7YsKZ7AhVVmjywJiquZekuC02nf9sVxdc2wxHu495zizIu
         z6HWs27kZAn5yp3P8kmssKDfxfazpZbXbMQ/s7ZyTZ8k1vwbpbnRku31wfQ7sHbmPJPz
         YL0JDzyRydp/BJgJu+PwY0b81FmyLOuAxurH1eBSGGlC+X/0yV6dUCM2dY+qmAOG5iLo
         KSRg==
X-Gm-Message-State: AOJu0YxtW3urKQxmzJilqGP8iN57sCqYlU3CbWbx92F6aTW0ObYWs8sh
	jjKm+VA3hosiz7lgO7ZkC7yaNbg8G/w+RhbCAH6LJE4NsSSR/uurjocYiV2JefPM8VNvWksPdYo
	O2kkZ6wkKbJVuBRv21YMCrn7DcxxSNSLKgDx8
X-Gm-Gg: ASbGncsnbrAQlJZnVE7+kYk8PRzHOWbC6U+QeQtNxuccj96yZ9jOen4vfsiojBhKiBV
	DBfqLmv5Ko93OeKX2kTo5qV9W3HU8GH2oH0/vuTpQgQq0UmJtazX/BSpluTCQ5EB9wX31auc=
X-Google-Smtp-Source: AGHT+IFGrJEVf8OtDFsmGDXMAERREShv9ggOdueveSoDnV+wYaLJ0YAgg+IsNh1yN4mxuQ6r+phjq2Q+QorlsTUOxGo=
X-Received: by 2002:a05:622a:1a94:b0:471:b96c:7267 with SMTP id
 d75a77b69052e-47215c982f5mr3131961cf.20.1740051528480; Thu, 20 Feb 2025
 03:38:48 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250211121128.703390-1-tabba@google.com> <20250211121128.703390-3-tabba@google.com>
 <8ddab670-8416-47f2-a5a6-94fb3444f328@redhat.com>
In-Reply-To: <8ddab670-8416-47f2-a5a6-94fb3444f328@redhat.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 20 Feb 2025 11:38:11 +0000
X-Gm-Features: AWEUYZlLBl7dDLqJoCpruqAIeCElYd6ktqwd6C4yBJhwMu65f7HQaGbNsfNEeIU
Message-ID: <CA+EHjTzPoeW2NWDYqJNUD6uLBqEMkRLWVODK0Ko+K5nS05Z47A@mail.gmail.com>
Subject: Re: [PATCH v3 02/11] KVM: guest_memfd: Handle final folio_put() of
 guest_memfd pages
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

On Thu, 20 Feb 2025 at 11:25, David Hildenbrand <david@redhat.com> wrote:
>
> On 11.02.25 13:11, Fuad Tabba wrote:
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
>
> [...]
>
> >   static const char *page_type_name(unsigned int page_type)
> > diff --git a/mm/swap.c b/mm/swap.c
> > index 47bc1bb919cc..241880a46358 100644
> > --- a/mm/swap.c
> > +++ b/mm/swap.c
> > @@ -38,6 +38,10 @@
> >   #include <linux/local_lock.h>
> >   #include <linux/buffer_head.h>
> >
> > +#ifdef CONFIG_KVM_GMEM_SHARED_MEM
> > +#include <linux/kvm_host.h>
> > +#endif
> > +
> >   #include "internal.h"
> >
> >   #define CREATE_TRACE_POINTS
> > @@ -101,6 +105,11 @@ static void free_typed_folio(struct folio *folio)
> >       case PGTY_hugetlb:
> >               free_huge_folio(folio);
> >               return;
> > +#endif
> > +#ifdef CONFIG_KVM_GMEM_SHARED_MEM
> > +     case PGTY_guestmem:
> > +             kvm_gmem_handle_folio_put(folio);
> > +             return;
>
> Hm, if KVM is built as a module, will that work? Or would we need the
> core-mm guest_memfd shim that would always be compiled into the core and
> decouple KVM from guest_memfd ("library")?

I'd assumed that it would work, since the module would have been
loaded before this could trigger, but I guess I was wrong.

Can you point me to an example of a similar shim in the core code, for
me to add on the respin?

Thanks,
/fuad


> --
> Cheers,
>
> David / dhildenb
>

