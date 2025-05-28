Return-Path: <kvm+bounces-47889-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 55BA7AC6CC9
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 17:26:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8F5173B94DD
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 15:25:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16BE728C03D;
	Wed, 28 May 2025 15:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hCLCoJuf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8DAB28BAAB
	for <kvm@vger.kernel.org>; Wed, 28 May 2025 15:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748445957; cv=none; b=ZKPSt3gXdOEQbvV39otgZOEtgw2GaTWbEQ/C0hhfW4hQsp8LNARjAkeT+xGNavGn8EFAVibR66K4cyJ4XX1Pi6YeGIAh3CaqpgOJsZlrtTK/0RN6iEGqqhNu+eU0Uaw6K39MtKZzP8hzHXlENNhCKXLmfKwdZHx+q703agJ4FUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748445957; c=relaxed/simple;
	bh=JB4V1mXB50dIS2i0RJuuug4gKKlxLvXfYIwuNLk4WtQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XQLp76F+ngZjNrXU585HgagdEDfdTyEVJLtWDhn1xAzorpAQSRQ0hPnt1e21E/Ba11rkS0qHFfnD+H6ZUfFHYiqkIVH8EyykxOKSxSU0TVqDzvFT0J28K7O5sHS9pFbE44eUJXeqIjo5uJn2NWcHuFZoy/wu6drOBwFSwuPmW8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hCLCoJuf; arc=none smtp.client-ip=209.85.128.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-70e102eada9so40016547b3.2
        for <kvm@vger.kernel.org>; Wed, 28 May 2025 08:25:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748445954; x=1749050754; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZZ+8fLpUTUE00SwjTXDSYLrDkmSnBdYHcuMZzbgG8cE=;
        b=hCLCoJufd+CxSup/iMXxYzr9QUpe+XxDa3pPVHo9PrSg7djIXlvjxUjlwkTFQP55qh
         978yKz96uNyJMBdeBuX9g8rUWPHd5VO3nHb0eADFxttvgcBEE+14opb6enmH6zC16ioa
         EjAKhdfc4V2y3W/4S2HiN2McG/THvOpiD6w0tv7xGEIuRoNN1Xp5Oi0a7+B+uGiPYwL/
         2r+EkJn9tQhTnC1oXKahnAopHF/Gz7Wu03Z2URzCer7D5s5GD6Y28+bQ6hFv7rqx+E9q
         Oy1WXmADNc2bSRTKftASUm/jp7gR3gHRJR3CWxmOOZ+7HKjaBNFrJAJ9ulPUfkoPQdjF
         xekw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748445954; x=1749050754;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZZ+8fLpUTUE00SwjTXDSYLrDkmSnBdYHcuMZzbgG8cE=;
        b=DvucskuBqNYJDqS1ToBKh5lBVE7U40SFcJ56VcJg7g4Pu82y8jjSBs+qqc7jG/1fv5
         CCFCLXJuWBczvfETnrC65B8nKGwfnX+gc2NxbzM0RLAutswhaF9ruyheAM29XvbvYtYR
         +rdxiMlVmIaBQ7uVV4sFcw/x8eD5jfFf9+Rk/5yONhLEn4W4h1r0i7MiFoicEH8MsfG5
         qfSSbADXuQeXgV/253K9Bi9kTbQ7Pcb4EhtcvrPC2QTQ++C+0erf2lyrXTxkbsGCagLq
         e0VJggSBoDha5PKkuNUi7bM4URItTLifY3X9+rkVCEltdlAbFICmeUiVZ5X+b1jRBpqG
         dAbw==
X-Forwarded-Encrypted: i=1; AJvYcCUDhU56cz7HcwRkMprqCwJiAU00aPngNa6xfu4NQ29icrxT6AqOU7vZPlrBC7jYi2Bf6Fw=@vger.kernel.org
X-Gm-Message-State: AOJu0YyAEKOQrBAY4kci8U76tzLWr/9Hd9Q54iP2BqvVrsknZLpcEw8d
	+Nm8+fxS99TSmfZ/x2vAR5qyAVTcxJ21NcqmjQaTdPLT5Fo9PEfk3bSCyllKZq5iPPTMfI4W9u8
	8ehkO1qlxkVo6ZC2OoyFZezjITtEnhQOVQaMC4YZb
X-Gm-Gg: ASbGncsn7vqhZqFYvrd7CAeYbIGfVQe3K2KQuiqutOzOZmuugb0BdAfXBWtuUB2+/CY
	EEOHvbx2/O0V+whLF/6SSSR3YvYxUcegfcN4MPrbN0k7HiuwVIe8XbKf0xEmFBoVP2qyOwaXpac
	819xO6ou1msmbxKyLU4og1ijL8aYSJuOLx9aX5od+amkZurDUc9c4xfdPu3+7I89Vd/2uK+UmHm
	osTkA==
X-Google-Smtp-Source: AGHT+IHHTjFjHU0PvV1+djItsz78YttpGm4E3LPln4uNDhF+ecRDSLHAHEgplJviovwSCSuAsvDL2RN+PvRS8fF8nxk=
X-Received: by 2002:a05:690c:6382:b0:6fb:a696:b23b with SMTP id
 00721157ae682-70e2daa40e4mr229796257b3.33.1748445954277; Wed, 28 May 2025
 08:25:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250109204929.1106563-1-jthoughton@google.com>
 <20250109204929.1106563-7-jthoughton@google.com> <aBqkINKO9PUAzZeS@google.com>
 <CADrL8HXDDRC6Ey5HYWvtzQzjcM2RNX7c7ngGyjUsD3WiBF3VYA@mail.gmail.com>
In-Reply-To: <CADrL8HXDDRC6Ey5HYWvtzQzjcM2RNX7c7ngGyjUsD3WiBF3VYA@mail.gmail.com>
From: James Houghton <jthoughton@google.com>
Date: Wed, 28 May 2025 11:25:18 -0400
X-Gm-Features: AX0GCFsuA5ETDJCRPXwcAF_CgwvMWNwjHd-w8eEw30VBFRDQPn6RHYkUrDT3M_g
Message-ID: <CADrL8HXS7zvJZjOxTxPKH0dAGoMXnFrrxCW7J7CXRtaeV6izjQ@mail.gmail.com>
Subject: Re: [PATCH v2 06/13] KVM: arm64: Add support for KVM_MEM_USERFAULT
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Yan Zhao <yan.y.zhao@intel.com>, 
	Nikita Kalyazin <kalyazin@amazon.com>, Anish Moorthy <amoorthy@google.com>, 
	Peter Gonda <pgonda@google.com>, Peter Xu <peterx@redhat.com>, 
	David Matlack <dmatlack@google.com>, wei.w.wang@intel.com, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 28, 2025 at 11:09=E2=80=AFAM James Houghton <jthoughton@google.=
com> wrote:
>
> On Tue, May 6, 2025 at 8:06=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
> >
> > On Thu, Jan 09, 2025, James Houghton wrote:
> > > @@ -2073,6 +2080,23 @@ void kvm_arch_commit_memory_region(struct kvm =
*kvm,
> > >                                  enum kvm_mr_change change)
> > >  {
> > >       bool log_dirty_pages =3D new && new->flags & KVM_MEM_LOG_DIRTY_=
PAGES;
> > > +     u32 new_flags =3D new ? new->flags : 0;
> > > +     u32 changed_flags =3D (new_flags) ^ (old ? old->flags : 0);
> >
> > This is a bit hard to read, and there's only one use of log_dirty_pages=
.  With
> > zapping handled in common KVM, just do:
>
> Thanks, Sean. Yeah what you have below looks a lot better, thanks for
> applying it for me. I'll post a new version soon. One note below.
>
> >
> > @@ -2127,14 +2131,19 @@ void kvm_arch_commit_memory_region(struct kvm *=
kvm,
> >                                    const struct kvm_memory_slot *new,
> >                                    enum kvm_mr_change change)
> >  {
> > -       bool log_dirty_pages =3D new && new->flags & KVM_MEM_LOG_DIRTY_=
PAGES;
> > +       u32 old_flags =3D old ? old->flags : 0;
> > +       u32 new_flags =3D new ? new->flags : 0;
> > +
> > +       /* Nothing to do if not toggling dirty logging. */
> > +       if (!((old_flags ^ new_flags) & KVM_MEM_LOG_DIRTY_PAGES))
> > +               return;
>
> This is my bug, not yours, but I think this condition must also check
> that `change =3D=3D KVM_MR_FLAGS_ONLY` for it to be correct. This, for
> example, will break the case where we are deleting a memslot that
> still has KVM_MEM_LOG_DIRTY_PAGES enabled. Will fix in the next
> version.

Ah it wouldn't break that example, as `new` would be NULL. But I think
it would break the case where we are moving a memslot that keeps
`KVM_MEM_LOG_DIRTY_PAGES`.

>
> >
> >         /*
> >          * At this point memslot has been committed and there is an
> >          * allocated dirty_bitmap[], dirty pages will be tracked while =
the
> >          * memory slot is write protected.
> >          */
> > -       if (log_dirty_pages) {
> > +       if (new_flags & KVM_MEM_LOG_DIRTY_PAGES) {
> >
> >                 if (change =3D=3D KVM_MR_DELETE)
> >                         return;

