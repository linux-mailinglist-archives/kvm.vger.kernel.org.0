Return-Path: <kvm+bounces-25729-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2EDDD969908
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 11:32:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C87DC287D81
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 09:32:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FDE61A0BF0;
	Tue,  3 Sep 2024 09:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KexuQTt2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 763D31A0BC1
	for <kvm@vger.kernel.org>; Tue,  3 Sep 2024 09:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725355770; cv=none; b=q0Uv5o/FvRYKZaIIHT4ZYRYqrypsuzty9S0b+0IJLlKEMKjwJ0NnwUKd84ZYl1t08CWYGvK7Aeh8VZlYtwwj8iH10fEewyjyPUtrO2pNvOS5QzmXqKEvSh/wRHlxWRVXj8gyA4ac8PUP6fXVj6kRARTdxX/Ld0/Cgx36tWOeQLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725355770; c=relaxed/simple;
	bh=XWYLT2Dufy7XIvWDw/r3fBawPBeo2pBCWq6IaM0i44Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qOkfmUrz1fv/Pen7E9MHpIAPLagEm37Oo+UjY/8ipH68cJoNBtG1vmlvHutKgr+P23XMnrGL5CbbEqmUMYVcdy4s5WUDgILZXj5dkjS/T7xxnX7ek8Tjw+0mHjBRi1sJHBPe6j31queEgc4k7IM6AP3gZ5ppkgGtWr46Njq3pnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KexuQTt2; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-5c2460e885dso19834a12.0
        for <kvm@vger.kernel.org>; Tue, 03 Sep 2024 02:29:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725355767; x=1725960567; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=tiMs/vBDb9K1/hIl1GIhz7z7Ghqobx3CJSDcDfwhFw8=;
        b=KexuQTt2joXvsD6PCNnEh/Sg6FlJvgxatdDAamI+9XubOX2/WCwChg1hLaQnpbn6fZ
         3QuNUJ9hvtsuqhE5Yu/kpIrQKJtUKHPe3zUsSaCvEouW88my+Xh0LQO+m8zliMdjLifc
         ehW+b6xxy0XU9m/hj/5hmAUqb8DptJ7lduLLw7mvcGETV9BMpVPxcp55Y+zbmLdZPIrL
         QgqYN3negdZBnvI/J1jPMbm9u1tkgRroUNv4Gwyk4PZ04dj54RxykmSPXgAt422uXh6L
         32pIWEYjiXLvD/fzgwUYcNreiqf09OxF2ASFFUqFNdNKILF7KlprR4A+t5lggFiNeZCy
         8VVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725355767; x=1725960567;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tiMs/vBDb9K1/hIl1GIhz7z7Ghqobx3CJSDcDfwhFw8=;
        b=Z/blMq5aS9/hoMzpsBYrzZG/WotdS6TeiJE/oXIkuVExrXqAdeEhBgFZz5nSxhyFvw
         rkB3CshUI3e9LJaF7+Xp3vKkLr2PMmhNxjcaCADK94pGd8bAeKyP+A3x9hZxPdizz/uB
         UnOF7OX3gba1niyHhX50A8FT9SUAnSqmhUQKi4W7R3w3JpjxsM0FHEtqk6H9fJlmWf+r
         mz6xMtkgeihibesQo9D/j/jeuirW/88SOljCmgVP35WqlS1qtzAceBgg83Gmwf5B8vzg
         8BsoRN5k9r7qGJVLXyr+OP2S+pPaN1CDAbBFUSB367CTmV8b0J1Yh/C2As7ZlGXG4dDu
         rJPA==
X-Gm-Message-State: AOJu0YzPDwrLs51AOjnnV9vATLNwJJc1vSrcy6XJI5YpOpQusD+d4zDA
	6DhfyrBqkKk1GtUdBuMBw6zKi/ZIN5LKlCkaFXC7/j4xELVs4ruqyDaQQUNC9iKQMkgGdc1+1IN
	KEUSJPev/3jxrD2AEbzDp+O16ArP64K+YdXqc
X-Google-Smtp-Source: AGHT+IFsO+OEGRoh1U3HXUZAQouEemrNgzm4ogtvht8jjyYaypuFI4fLS71gurG23zg2ZRqo42Cl/z4FlU9Sa0nKdYs=
X-Received: by 2002:a05:6402:268b:b0:58b:15e4:d786 with SMTP id
 4fb4d7f45d1cf-5c245b7607dmr503262a12.5.1725355766355; Tue, 03 Sep 2024
 02:29:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240801090117.3841080-1-tabba@google.com> <20240801090117.3841080-4-tabba@google.com>
 <Zr-pRIWKOvN5px0P@google.com>
In-Reply-To: <Zr-pRIWKOvN5px0P@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 3 Sep 2024 10:28:49 +0100
Message-ID: <CA+EHjTzRpWxxoxZb74pCAqiWOp=ZR645=iGW1BQWg2z=eNuLZA@mail.gmail.com>
Subject: Re: [RFC PATCH v2 03/10] KVM: Implement kvm_(read|/write)_guest_page
 for private memory slots
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	willy@infradead.org, akpm@linux-foundation.org, xiaoyao.li@intel.com, 
	yilun.xu@intel.com, chao.p.peng@linux.intel.com, jarkko@kernel.org, 
	amoorthy@google.com, dmatlack@google.com, yu.c.zhang@linux.intel.com, 
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
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com
Content-Type: text/plain; charset="UTF-8"

Hi Sean,

On Fri, 16 Aug 2024 at 20:32, Sean Christopherson <seanjc@google.com> wrote:
>
> On Thu, Aug 01, 2024, Fuad Tabba wrote:
> > Make __kvm_read_guest_page/__kvm_write_guest_page capable of
> > accessing guest memory if no userspace address is available.
> > Moreover, check that the memory being accessed is shared with the
> > host before attempting the access.
> >
> > KVM at the host might need to access shared memory that is not
> > mapped in the host userspace but is in fact shared with the host,
> > e.g., when accounting for stolen time. This allows the access
> > without relying on the slot's userspace_addr being set.
>
> Why?  As evidenced by the amount of code below, special casing guest_memfd isn't
> trivial, and taking kvm->slots_lock is likely a complete non-starter.  In the
> happy case, uaccess is about as fast as can be, and has no inherent scaling issues.
>
> > This does not circumvent protection, since the access is only
> > attempted if the memory is mappable by the host, which implies
> > shareability.
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  virt/kvm/kvm_main.c | 127 ++++++++++++++++++++++++++++++++++++++------
> >  1 file changed, 111 insertions(+), 16 deletions(-)
> >
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index f4b4498d4de6..ec6255c7325e 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -3385,20 +3385,108 @@ int kvm_gmem_clear_mappable(struct kvm *kvm, gfn_t start, gfn_t end)
> >       return kvm_gmem_toggle_mappable(kvm, start, end, false);
> >  }
> >
> > +static int __kvm_read_private_guest_page(struct kvm *kvm,
>
> The changelog says this is for accessing memory that is shared, but this says
> "private".

This is bad naming on my part. Instead, I should call this function
something like, read_guestmem_page (and similar for the write one).
Thanks for pointing this out.

Cheers,
/fuad

> > +                                      struct kvm_memory_slot *slot,
> > +                                      gfn_t gfn, void *data, int offset,
> > +                                      int len)

