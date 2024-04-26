Return-Path: <kvm+bounces-16021-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 18CCB8B2FCB
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 07:42:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AD2991F227E5
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 05:42:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E167613A3F7;
	Fri, 26 Apr 2024 05:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KHiJhpUQ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60ABEEBE
	for <kvm@vger.kernel.org>; Fri, 26 Apr 2024 05:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714110120; cv=none; b=iQzCnRKq1ea2Luxsb/jbCoYc3IewBu1LK3/BiEYBhV8f81PNECF/T+nOq9es/rwI/kL9A9yxBC0K7ZMgp5Vf2ZPjtm4g8dW+EGFKoRoscdf2/dS1zpuwusO7BaFFbcg+yt9kj6+hFRkkDoMyN59DmEEuQWTnYrgdV1B1Ymf4g6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714110120; c=relaxed/simple;
	bh=/gZZY4I/cg5zoFsdRttZGXKzRfhZ+C59J72YZ3qTXWo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WbMLHg8U+0yMoMtRYciDmJ3mZUqfQGgQzageZV+KCaD2bLqulctE0ep3LXwjlJvFjD+BjaK9JiKxH/2iH+6keviFmM9hOv+8a615p3rOwySt9thbBqFTDQDUF+yy2429ibgxPqlvXM/NGAT6i3KPLGX7ykfsYzByvG5qEbscYy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KHiJhpUQ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714110117;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vyfGtTjL0/4BOGlGkObqvS2M4nitmPhPC2paKUGfC20=;
	b=KHiJhpUQAkEbFtkF3F2ddHLthl+2mA3a9w/KRs/43VOEaS/LesYdopdYo63TtVrX3UQysM
	5JcOqyPL6PyhHLsqkQfzJZkEbpQ9RNnr2VYftttk+9lUcqYdDIfgt8lcap+wD9f1o7dmeS
	wGh1pHw3X5jiSeoXjNf2SorBxLMhVIw=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-68-8Hms6SQCNh2J3VSO0jGuoA-1; Fri, 26 Apr 2024 01:41:54 -0400
X-MC-Unique: 8Hms6SQCNh2J3VSO0jGuoA-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-34a4ded7d49so1696406f8f.1
        for <kvm@vger.kernel.org>; Thu, 25 Apr 2024 22:41:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714110114; x=1714714914;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vyfGtTjL0/4BOGlGkObqvS2M4nitmPhPC2paKUGfC20=;
        b=u3ydzJ4Pszkwh8dYIejkRD3SH2Mmvs6LzsMmHagb6ZvleWAy4rNf3ctPhkBFNbfD09
         hcPUa7fvERopLp2idHwOmvk9Dg0X4QR+Ix2JdSAwIHe1cug9Bs6I++uTfIK4BwBRrZyj
         oAT52VWk0eEt5SI74/xmodBj8af3prSKGeZBjVj5YG+vs3V/hwmO37vLmJpRASU/I0ay
         nKPAqJ2lbhHbxbs3JH/FpEVELUDUWlFerTt1wlCSU8dUi37H6Dg9CjHzXw/Z5iZs8tF0
         Ft32r9Xb8D6222Dq7Ho5Cl8XJsk5n63VWw3089JKy21KWmS891gCMHQcm+rNXbV2wJvW
         vZog==
X-Forwarded-Encrypted: i=1; AJvYcCU1CaYfFOkJ8dylewto5tgGdnqyRn4726Dfc88vmF9ke92Alrgxy+g95wCEuzXHGj8PbFFqYVDx/IBK7sc2IABULUxJ
X-Gm-Message-State: AOJu0YzCqLcoqeRBAN4HVZKKD9qC9kCjl6SdUzxaksUSF15EAIJEKVyf
	1aKVh1t1hC/p8s3d+Gn6kqZTyTLwl3XJmG484PdItfRaBjOcOrgC3B8rjESY0q/mgfV14BHTcbf
	5TTGmqoXiH9ZtVBuyr10q9HcLxg8rfd/r2Ud9XKc88q1I9WcueYdLDeuoBh2wokv32ig/7v+4hM
	47B9HlNq290yaZGa8i/jkoulbN
X-Received: by 2002:a5d:59a8:0:b0:343:f2e0:d507 with SMTP id p8-20020a5d59a8000000b00343f2e0d507mr1239526wrr.41.1714110113853;
        Thu, 25 Apr 2024 22:41:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHBIXyOHDQf5t1J7hEF66tvZIMi3zbHy9WKGQ4R/jeeL+FyjVcaBJV1zMFGs9QljcxrM29xfti0U+Sza+E6tq4=
X-Received: by 2002:a5d:59a8:0:b0:343:f2e0:d507 with SMTP id
 p8-20020a5d59a8000000b00343f2e0d507mr1239519wrr.41.1714110113499; Thu, 25 Apr
 2024 22:41:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240404185034.3184582-1-pbonzini@redhat.com> <20240404185034.3184582-10-pbonzini@redhat.com>
 <20240423235013.GO3596705@ls.amr.corp.intel.com> <ZimGulY6qyxt6ylO@google.com>
 <20240425011248.GP3596705@ls.amr.corp.intel.com> <CABgObfY2TOb6cJnFkpxWjkAmbYSRGkXGx=+-241tRx=OG-yAZQ@mail.gmail.com>
 <Zip-JsAB5TIRDJVl@google.com>
In-Reply-To: <Zip-JsAB5TIRDJVl@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 26 Apr 2024 07:41:42 +0200
Message-ID: <CABgObfaxAd_J5ufr+rOcND=-NWrOzVsvavoaXuFw_cwDd+e9aA@mail.gmail.com>
Subject: Re: [PATCH 09/11] KVM: guest_memfd: Add interface for populating gmem
 pages with user data
To: Sean Christopherson <seanjc@google.com>
Cc: Isaku Yamahata <isaku.yamahata@intel.com>, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, michael.roth@amd.com, isaku.yamahata@linux.intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 25, 2024 at 6:00=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Thu, Apr 25, 2024, Paolo Bonzini wrote:
> > On Thu, Apr 25, 2024 at 3:12=E2=80=AFAM Isaku Yamahata <isaku.yamahata@=
intel.com> wrote:
> > > > >   get_user_pages_fast(source addr)
> > > > >   read_lock(mmu_lock)
> > > > >   kvm_tdp_mmu_get_walk_private_pfn(vcpu, gpa, &pfn);
> > > > >   if the page table doesn't map gpa, error.
> > > > >   TDH.MEM.PAGE.ADD()
> > > > >   TDH.MR.EXTEND()
> > > > >   read_unlock(mmu_lock)
> > > > >   put_page()
> > > >
> > > > Hmm, KVM doesn't _need_ to use invalidate_lock to protect against g=
uest_memfd
> > > > invalidation, but I also don't see why it would cause problems.
> >
> > The invalidate_lock is only needed to operate on the guest_memfd, but
> > it's a rwsem so there are no risks of lock inversion.
> >
> > > > I.e. why not
> > > > take mmu_lock() in TDX's post_populate() implementation?
> > >
> > > We can take the lock.  Because we have already populated the GFN of g=
uest_memfd,
> > > we need to make kvm_gmem_populate() not pass FGP_CREAT_ONLY.  Otherwi=
se we'll
> > > get -EEXIST.
> >
> > I don't understand why TDH.MEM.PAGE.ADD() cannot be called from the
> > post-populate hook. Can the code for TDH.MEM.PAGE.ADD be shared
> > between the memory initialization ioctl and the page fault hook in
> > kvm_x86_ops?
>
> Ah, because TDX is required to pre-fault the memory to establish the S-EP=
T walk,
> and pre-faulting means guest_memfd()
>
> Requiring that guest_memfd not have a page when initializing the guest im=
age
> seems wrong, i.e. I don't think we want FGP_CREAT_ONLY.  And not just bec=
ause I
> am a fan of pre-faulting, I think the semantics are bad.

Ok, fair enough. I wanted to do the once-only test in common code but
since SEV code checks for the RMP I can remove that. One less
headache.

Paolo


