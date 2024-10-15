Return-Path: <kvm+bounces-28957-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A9E4E99FBA9
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 00:48:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0F432B2269A
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 22:48:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AAFB1D63ED;
	Tue, 15 Oct 2024 22:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="f6AO1YyS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vs1-f43.google.com (mail-vs1-f43.google.com [209.85.217.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19B621B0F31
	for <kvm@vger.kernel.org>; Tue, 15 Oct 2024 22:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729032501; cv=none; b=RYMzTtZBFOpLezSi1GYIstPf04VrjwmbQxEJltdabn3suFuGHJtEUB9e8iKYjfPZ8Ej25LUTy8ChRV+oWpOcTwnZYzLRjc4vdlrl8wo4IeUvacZUQ+ryWvwjR5BCXwA/v01nLkF5uihp3O4Yaj/NgbRVgvU2zqQSTb3XfzTMP4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729032501; c=relaxed/simple;
	bh=y4wTt1hMw46Ajv3cIQeHDlR0RDHcUdA5/yND53W4oTs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IIJEz35O+iYAYlC0MiACvJQNxHwX11vSrC7UCUcyku0IUb1niepJ0YdkSSpUsr1vVFluIUNgG7edB49rcdMfgjicIOGOfgN1j3Sq02GuqNeP2VDi8UbcllKRxI5De7afiCE7rRoXpfpspngRDXbOwrpsxC5gBL1MUhhyxEw4IlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=f6AO1YyS; arc=none smtp.client-ip=209.85.217.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-vs1-f43.google.com with SMTP id ada2fe7eead31-4a48477b25eso197353137.0
        for <kvm@vger.kernel.org>; Tue, 15 Oct 2024 15:48:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1729032498; x=1729637298; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=thjVFZ9JHy+XHx/P+OmRUKAu97VTsEznVTTuyaP0ILg=;
        b=f6AO1YySgd60836QBSGee0wmssdZufNGSHq2M6w8crI+FrFnI5A215R9UJr7H8iwGq
         dhJjk+Nv9z14pZG8q0H0URq9Y+4z9CNRVzlDr/5/rN23xKtMkcsaA/0Sh97JLT5i54Jk
         kyLCVcycucs698Y83gNcXcvSkHRKrsP6ANG9+oNMKFgrh2KhUccmNs9cOmSRrhiTsl0i
         o9k9o82RR5GQKSXLJYN/spm8AL35nOPMjg8I2OjS2py38zja4Kf3iNpT+4u1ce+PnSFG
         oXJsufnrj8JIQF9GnsD4oJV3nGOn85VqCiS/vHeblde4rqDT4t/fNvN/OUxoM8BA5YPI
         lYEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729032498; x=1729637298;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=thjVFZ9JHy+XHx/P+OmRUKAu97VTsEznVTTuyaP0ILg=;
        b=KbdiNk8poISV2g1TECkUYjAZffY4qCTLziXgAxr46APyFh5DPW5dJZkYC2hOHALsqp
         EHzCzm8/zdFFZh+Jsg9ti6s3smmrv6eEPKZygWf3O/zpY2479E9AIovku6jvTlUFoA2s
         IUUV28PKbT7mLwy5TjTu6Nc0EbsOBL1luRbRYh+ZSzEdxpMa1LJZ+Jq0u3M2sAik121V
         glqBpaUyNfM/+nPASGrHL2BW0wBOfIwbOzEJxMJjJwZdeyvxHlA6AQprhA+Y38ElMhc/
         xPG33ZACIpYpt9ld26UB2Zem9uh+8BLs6nukCPT3+eoSaGYTZMGnO8ESbPEKaCLOlWYu
         JgEA==
X-Forwarded-Encrypted: i=1; AJvYcCW3a4/4pvbymlSvxobu/sK5NrjIY/EsqFwx2nJnMHoMBzNQ4NOUC3Zn7awrOHw2CbpfcRc=@vger.kernel.org
X-Gm-Message-State: AOJu0YyDorHa15U7OsrVsdx48cfCY10UcoQi5MN2yMRjL3mMb/z/XEtD
	1ZJit6B2DkzBktHNYvrvMJ4JiFsyszez7at2YrRtlv3KefrD2+7G68u0/6INfQ4M3Gu6OnCBPRh
	ZZMcsEucgV8oodkTbJSAcx/RLcLoxzKQJpeeK
X-Google-Smtp-Source: AGHT+IHnaSy0q/kDCz0vAJot6g5xsnJ0ihADeJJee62qYBERkh1eaBoELa9F+6Vz1W9f+tMrfIXWvAwFDhmw3bKOIJ8=
X-Received: by 2002:a05:6102:b04:b0:4a4:72f0:7937 with SMTP id
 ada2fe7eead31-4a5b4cf873bmr2033136137.8.1729032497513; Tue, 15 Oct 2024
 15:48:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240926013506.860253-1-jthoughton@google.com>
 <Zw2no4OGDVK7m8QR@google.com> <CADrL8HUP1=eXE5QpVrKjgQGpusr_Raejr1sY2LLW1uSigpptOw@mail.gmail.com>
In-Reply-To: <CADrL8HUP1=eXE5QpVrKjgQGpusr_Raejr1sY2LLW1uSigpptOw@mail.gmail.com>
From: Yu Zhao <yuzhao@google.com>
Date: Tue, 15 Oct 2024 16:47:39 -0600
Message-ID: <CAOUHufZU8C-48H0n2v02D52PoC8b0mYUJJS=C-dz+bruruOfdg@mail.gmail.com>
Subject: Re: [PATCH v7 00/18] mm: multi-gen LRU: Walk secondary MMU page
 tables while aging
To: James Houghton <jthoughton@google.com>
Cc: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Matlack <dmatlack@google.com>, 
	David Rientjes <rientjes@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, Wei Xu <weixugc@google.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	David Stevens <stevensd@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 14, 2024 at 6:07=E2=80=AFPM James Houghton <jthoughton@google.c=
om> wrote:
>
> On Mon, Oct 14, 2024 at 4:22=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> > On Thu, Sep 26, 2024, James Houghton wrote:
> > > This patchset makes it possible for MGLRU to consult secondary MMUs
> > > while doing aging, not just during eviction. This allows for more
> > > accurate reclaim decisions, which is especially important for proacti=
ve
> > > reclaim.
> >
> > ...
> >
> > > James Houghton (14):
> > >   KVM: Remove kvm_handle_hva_range helper functions
> > >   KVM: Add lockless memslot walk to KVM
> > >   KVM: x86/mmu: Factor out spte atomic bit clearing routine
> > >   KVM: x86/mmu: Relax locking for kvm_test_age_gfn and kvm_age_gfn
> > >   KVM: x86/mmu: Rearrange kvm_{test_,}age_gfn
> > >   KVM: x86/mmu: Only check gfn age in shadow MMU if
> > >     indirect_shadow_pages > 0
> > >   mm: Add missing mmu_notifier_clear_young for !MMU_NOTIFIER
> > >   mm: Add has_fast_aging to struct mmu_notifier
> > >   mm: Add fast_only bool to test_young and clear_young MMU notifiers
> >
> > Per offline discussions, there's a non-zero chance that fast_only won't=
 be needed,
> > because it may be preferable to incorporate secondary MMUs into MGLRU, =
even if
> > they don't support "fast" aging.
> >
> > What's the status on that front?  Even if the status is "TBD", it'd be =
very helpful
> > to let others know, so that they don't spend time reviewing code that m=
ight be
> > completely thrown away.
>
> The fast_only MMU notifier changes will probably be removed in v8.
>
> ChromeOS folks found that the way MGLRU *currently* interacts with KVM
> is problematic. That is, today, with the MM_WALK MGLRU capability
> enabled, normal PTEs have their Accessed bits cleared via a page table
> scan and then during an rmap walk upon attempted eviction, whereas,
> KVM SPTEs only have their Accessed bits cleared via the rmap walk at
> eviction time. So KVM SPTEs have their Accessed bits cleared less
> frequently than normal PTEs, and therefore they appear younger than
> they should.
>
> It turns out that this causes tab open latency regressions on ChromeOS
> where a significant amount of memory is being used by a VM. IIUC, the
> fix for this is to have MGLRU age SPTEs as often as it ages normal
> PTEs; i.e., it should call the correct MMU notifiers each time it
> clears A bits on PTEs. The final patch in this series sort of does
> this, but instead of calling the new fast_only notifier, we need to
> call the normal test/clear_young() notifiers regardless of how fast
> they are.
>
> This also means that the MGLRU changes no longer depend on the KVM
> optimizations, as they can motivated independently.
>
> Yu, have I gotten anything wrong here? Do you have any more details to sh=
are?

Yes, that's precisely the problem. My original justification [1] for
not scanning KVM MMU when lockless is not supported turned out to be
harmful to some workloads too.

On one hand, scanning KVM MMU when not lockless can cause the KVM MMU
lock contention; on the other hand, not scanning KVM MMU can skew
anon/file LRU aging and thrash page cache. Given the lock contention
is being tackled, the latter seems to be the lesser of two evils.

[1] https://lore.kernel.org/linux-mm/CAOUHufYFHKLwt1PWp2uS6g174GZYRZURWJAmd=
UWs5eaKmhEeyQ@mail.gmail.com/

