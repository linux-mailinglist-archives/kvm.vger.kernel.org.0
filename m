Return-Path: <kvm+bounces-46993-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BAEA3ABC333
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 17:53:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B6D207A375A
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 15:52:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 875F1286D72;
	Mon, 19 May 2025 15:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="f1v4XVvR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 422882868B6
	for <kvm@vger.kernel.org>; Mon, 19 May 2025 15:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747669923; cv=none; b=I6I/aeRBsw5X3jqA88zVLvHrb6FimA36pqiWxPkBsNQHzCHTPCdNWt+LwAHXAKmT9X/BQt/R12mK6sKvf6sruWFIG4+pXJtfPx2nfSN+StIWiYr5I7LXBwDoNYgfO+HtTrWI1FReT0Yzpot4tblbXlLGQ2gHiLlalgLLPW9Ppy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747669923; c=relaxed/simple;
	bh=0oRtEEKpaGZJrjUXHqfqhMXKmvD1V2R1hKflW1YLNsg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Lpw0ipxJmbE3hTIKZsrG2t3GZNb35JFGA4XtbiEdbTmpgH2EMX771RtnMR6wlvtuRhrZkNl3yRUUJmTFO283Gwafj8hoMynTxjmuFnaaMWocmlFNvhnFkBA6t5oseMfcjGbGed7XPiHugPm/VGf9WwAbkVYyvfLVcnnJAdDfJRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=f1v4XVvR; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-30e896e116fso2490348a91.2
        for <kvm@vger.kernel.org>; Mon, 19 May 2025 08:52:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747669921; x=1748274721; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=W1pNYA+vaA5AQd1uT+jo/aeGZ76h30XtHsWTyrjQFDk=;
        b=f1v4XVvRuNIWhgXWpbXBX6tpq9wH48aaMhLc0mNQRDKJJUnmjOzah1iBmNzIbDHGoL
         pV1VQVam3v118ATthO89FbJycVm40cpMKQuc/Pzbilb1nRaxGGKu4Hy7j3JSAgbE5coB
         tyMlkcFaedcYdwlSYDQCs5isZzjUdlaGahLQyx+UE0njxKoLlbpu+DtmLMnHMCPwwexg
         PD0G/YhNaiM6izMrZvYHUaQXZrj8nOWfArEyIK1O0xrYzh48UALOWg4LnjZfykolPqak
         dp3tP74wJv7/3Gr4pVT1W9b0juLH08UQ506Sv5/8jdQ5jxNeYvdP1iyLZazLv78Yy3Ig
         Huhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747669921; x=1748274721;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=W1pNYA+vaA5AQd1uT+jo/aeGZ76h30XtHsWTyrjQFDk=;
        b=ZOjnw/Z8H2bzWkvPZxowmWFiaGGLi30JValgqt4wNHkvBcQqvW9yKzDyAmqiXUrOj7
         wwHpgHCTZ7bDhZCNG5TTxdz3cMdukrWAEHiLY9GDgNjmdLVb3l30Lv846gV3rJMePDo/
         5+ZYRPsm0UoqMi5mXYMzcK5dXbgfLApPZvmwlCFbLy/Q/KlosJEb88aIt1kEJ8rQuSmN
         kHr7zIS6zX6eoWQQ7rEplTft76QDZmEyQWsWys+tfWK42fPsFUZ3454bLmFUgwCNHCAp
         V+8NzQ4jRByOeqwfFyeb5mCj1v6MBE18QzWjavgN5cVuX8c3hjZOgtu2IkJFm91FF8Yn
         XVmg==
X-Forwarded-Encrypted: i=1; AJvYcCVK4hfTp9mR3vmcigTr+tNW+obehP9ss7SO/4d8EzvWE9Ek5tUUbzlKi5Cq2nTq+ud8J58=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxjg7OHc3/TwMdb587JmRLHIVGNAXZVRYnrq1DTZFQ+KrZWQKZI
	FiW0qVCDR/lkc63VnahYKwKAY83c1l7x3W91KvhlHtL1YUcDhJqNfvn+/gbnqCwBIvhV/8dH60+
	JxVstaQ==
X-Google-Smtp-Source: AGHT+IH99fhnWHuQYmbVCUO52sWNgyRkEizD7mm0PbZwFP1ignDjkarwDBN+LpbMdTULVDj01yr0WgoOgQE=
X-Received: from pjvb11.prod.google.com ([2002:a17:90a:d88b:b0:2ef:95f4:4619])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1c03:b0:30e:9b56:e401
 with SMTP id 98e67ed59e1d1-30e9b56e45bmr16913574a91.2.1747669921490; Mon, 19
 May 2025 08:52:01 -0700 (PDT)
Date: Mon, 19 May 2025 08:51:59 -0700
In-Reply-To: <CADrL8HXSde+EeLD2UsDNkxAxdmKomEA1XqdDuF4iFaksiZUHLw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250516215422.2550669-1-seanjc@google.com> <20250516215422.2550669-4-seanjc@google.com>
 <fb0580d9-103f-4aa1-94ae-c67938460d71@redhat.com> <aCsz_wF7g1gku3GU@google.com>
 <CADrL8HXSde+EeLD2UsDNkxAxdmKomEA1XqdDuF4iFaksiZUHLw@mail.gmail.com>
Message-ID: <aCtTn-zzrxbIl6W1@google.com>
Subject: Re: [PATCH v3 3/3] KVM: x86/mmu: Defer allocation of shadow MMU's
 hashed page list
From: Sean Christopherson <seanjc@google.com>
To: James Houghton <jthoughton@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 19, 2025, James Houghton wrote:
> On Mon, May 19, 2025 at 9:37=E2=80=AFAM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> > On Sat, May 17, 2025, Paolo Bonzini wrote:
> > > On 5/16/25 23:54, Sean Christopherson wrote:
> > > > +   /*
> > > > +    * Write mmu_page_hash exactly once as there may be concurrent =
readers,
> > > > +    * e.g. to check for shadowed PTEs in mmu_try_to_unsync_pages()=
.  Note,
> > > > +    * mmu_lock must be held for write to add (or remove) shadow pa=
ges, and
> > > > +    * so readers are guaranteed to see an empty list for their cur=
rent
> > > > +    * mmu_lock critical section.
> > > > +    */
> > > > +   WRITE_ONCE(kvm->arch.mmu_page_hash, h);
> > >
> > > Use smp_store_release here (unlike READ_ONCE(), it's technically inco=
rrect
> > > to use WRITE_ONCE() here!),
> >
> > Can you elaborate why?  Due to my x86-centric life, my memory ordering =
knowledge
> > is woefully inadequate.
>=20
> The compiler must be prohibited from reordering stores preceding this
> WRITE_ONCE() to after it.
>=20
> In reality, the only stores that matter will be from within
> kvcalloc(), and the important bits of it will not be inlined, so it's
> unlikely that the compiler would actually do such reordering. But it's
> nonetheless allowed. :) barrier() is precisely what is needed to
> prohibit this; smp_store_release() on x86 is merely barrier() +
> WRITE_ONCE().
>=20
> Semantically, smp_store_release() is what you mean to write, as Paolo
> said. We're not really *only* preventing torn accesses, we also need
> to ensure that any threads that read kvm->arch.mmu_page_hash can
> actually use that result (i.e., that all the stores from the
> kvcalloc() are visible).=20

Ah, that's what I was missing.  It's not KVM's stores that are theoreticall=
y
problematic, it's the zeroing of kvm->arch.mmu_page_hash that needs protect=
ion.

Thanks!

> This sounds a little bit weird for x86 code, but compiler reordering is s=
till
> a possibility.
>=20
> And I also agree with what Paolo said about smp_load_acquire(). :)
>=20
> Thanks Paolo. Please correct me if I'm wrong above.
>=20
> > > with a remark that it pairs with kvm_get_mmu_page_hash().  That's bot=
h more
> > > accurate and leads to a better comment than "write exactly once".
> >

