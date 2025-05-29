Return-Path: <kvm+bounces-47987-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EB382AC8066
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 17:38:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2A2EA1BC2A02
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 15:38:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56B8722D7A1;
	Thu, 29 May 2025 15:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BATQs01t"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f180.google.com (mail-yb1-f180.google.com [209.85.219.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D16FB193062
	for <kvm@vger.kernel.org>; Thu, 29 May 2025 15:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748533099; cv=none; b=fLtq4iHcIT3Dg+U/OxaZYCxGK0mAwWrZZYsxaym6u8P+UoSyOmGke7DPKsPhG+6WU8vu/66yblkyJuyWX+JbwaQv90PV7OX+w67N/yHq/nXCRUfnmbALRg60vdX0XsXXE6fMSK3NOfErKKCdL17aHY8GgMnz+Nw8l1s4iv+PBlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748533099; c=relaxed/simple;
	bh=9dnD35XOCewsQPQpmkvlOmYPTq8w148rFOH/LXn7szk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DviTrMlLMs8Vh3Xn0VonxYzc4wHauWrFoHfML+jOJN2PkSfNy5SYTb4aCUaahgZyrO5H8ObNgqDkfci0Z8F34SS9S5VgMdiHsH6VXxIbnhXeEfZNU7WRkysKj+kIiwovQpxgxrLHRz2hLc/pONKjHIhRkz7CvRwWpmzA+5b+RHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BATQs01t; arc=none smtp.client-ip=209.85.219.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-yb1-f180.google.com with SMTP id 3f1490d57ef6-e7da171c504so981940276.0
        for <kvm@vger.kernel.org>; Thu, 29 May 2025 08:38:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748533097; x=1749137897; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=59hS0MkzKJXc59NrQgViQhOudUVo0YC4RPrtVcYEmhM=;
        b=BATQs01t9a04cvoObp63MLdBtUV5PZiHCJ/3fWaTBDEXCa2OjuYuswP4V6xdUEMnZ2
         zxTMjeesVbAcXg17VpzoXVd3mqeOu8JHUS9gmCpR8sNj2WYWcM6B9xNPa0vPByb9hn26
         FrdbQcvaC9OwTC/4GuaeK8zDztbyYdVZ2UKbq48TT3mXFPL9i6mIKIdYhz7Az/n9aLwK
         Xx04OVHGTvEBctU8Rlk78X/hb/9h8RxKwZGYtcrXVF7L/2gev/ZAlEt2kXWz3MopTKWf
         qcg/Gb+sGO5GJGeKOBW7fs6j2kTz5YI1UyrLPEVpGtAOa3X2hEurWUnxmiuBCtBBS52W
         KOKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748533097; x=1749137897;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=59hS0MkzKJXc59NrQgViQhOudUVo0YC4RPrtVcYEmhM=;
        b=iiT9DTgFelROaMNXsrj6Z73OpIyyjYq6hwWYBVJhpzHGQs8AEHMbZSfkijJKTu71t4
         vBcV51W1BQXNclif/c8r+HAl38ANfyDkZ4j8K0E4jmGCS7iU2Fcoqf/5c2PGpsOBRtkB
         0H8wU7ySEb2IfEUTN8CzKxWHmkMRI4l1Bxm63Sk2urieB+cbdrp9xk3SNclLLdgdlgpQ
         CGxO2xQ5ZbJ6hBjKybIvXn4FnzHSktt/AXjBbca1RYJ7k8/vlM2XudTjT8qZPFns1j50
         /WP4rw+pU/SEP7erdr7a8st9bry4MSUnkjATVpLQK24BuiMKiT3sg8gT7yUhQaGasy7B
         m8eQ==
X-Forwarded-Encrypted: i=1; AJvYcCUk3fAZcJ1EYJD9zd4FzSsJ+XCO6NSv1dPmxTim+htXZcPmyS6CeQIlPPa7qQH2TVnyLMQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx3JhmJRJ3XSMj1omMDmBLv9xcQnXdx670gD8dCVudwTaYpFw/e
	Ig/DeSZlvd+0VgSQqOqI5ISarm/3oqN/C1R/oMHRmAfXnivDKv+BEd6eipezYP0FkVEUsIrphbI
	tjdJH3BVZEbM9xwAMMTLUlOozcN7HqSbwWzXTMbX5
X-Gm-Gg: ASbGncu8pKafebnYx/pT39COMDiA6bOI3Ly/ITrfCR0Vu7uDuGbSM0NUOFvh/Wee1bZ
	yHg+gM4VIIXoA571H/5CDoh04xp82KGl6Ho/M8wLnC2c1BQhN1CIkfSgN+n4WbaKzmci5QG7+MU
	wZPm2NO3o+VO52cmfiRg+kSeyCgEs1+BunuLecajewGdgWizKia2oSTVtsPlhI3rIO14Wl5prVI
	KrKfw==
X-Google-Smtp-Source: AGHT+IFR1qIxg3DrCDwLoec3/Bow8uX+lKtS4uCaQmLEMzaDiZzqKZfkx5upp36mpzAbpQJS3YxhrYvCs4/T2jiOb1I=
X-Received: by 2002:a05:690c:4c0f:b0:70f:87c5:5270 with SMTP id
 00721157ae682-70f8b54d40dmr38902587b3.19.1748533096510; Thu, 29 May 2025
 08:38:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250109204929.1106563-1-jthoughton@google.com>
 <20250109204929.1106563-6-jthoughton@google.com> <aBqj3s8THH9SFzLO@google.com>
 <aDdwXrbAHmVqu0kA@linux.dev> <aDd-lbrJAX62UQLn@google.com> <aDh1sgc5oAYDfGnF@google.com>
In-Reply-To: <aDh1sgc5oAYDfGnF@google.com>
From: James Houghton <jthoughton@google.com>
Date: Thu, 29 May 2025 11:37:39 -0400
X-Gm-Features: AX0GCFvRkUpRdhgyNhHX3Yph3U7NSJ2ckkL4g5EEunTqQRjiIBENP29k9ut9k84
Message-ID: <CADrL8HWgnuU9pyQfLcm9qpSJicfwgmc9qRzksA38x5_utexaug@mail.gmail.com>
Subject: Re: [PATCH v2 05/13] KVM: x86/mmu: Add support for KVM_MEM_USERFAULT
To: Sean Christopherson <seanjc@google.com>
Cc: Oliver Upton <oliver.upton@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, Yan Zhao <yan.y.zhao@intel.com>, 
	Nikita Kalyazin <kalyazin@amazon.com>, Anish Moorthy <amoorthy@google.com>, 
	Peter Gonda <pgonda@google.com>, Peter Xu <peterx@redhat.com>, 
	David Matlack <dmatlack@google.com>, wei.w.wang@intel.com, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 29, 2025 at 10:56=E2=80=AFAM Sean Christopherson <seanjc@google=
.com> wrote:
>
> On Wed, May 28, 2025, Sean Christopherson wrote:
> > On Wed, May 28, 2025, Oliver Upton wrote:
> > > On Tue, May 06, 2025 at 05:05:50PM -0700, Sean Christopherson wrote:
> > > > > +       if ((old_flags ^ new_flags) & KVM_MEM_USERFAULT &&
> > > > > +           (change =3D=3D KVM_MR_FLAGS_ONLY)) {
> > > > > +               if (old_flags & KVM_MEM_USERFAULT)
> > > > > +                       kvm_mmu_recover_huge_pages(kvm, new);
> > > > > +               else
> > > > > +                       kvm_arch_flush_shadow_memslot(kvm, old);
> > > >
> > > > The call to kvm_arch_flush_shadow_memslot() should definitely go in=
 common code.
> > > > The fancy recovery logic is arch specific, but blasting the memslot=
 when userfault
> > > > is toggled on is not.
> > >
> > > Not like anything in KVM is consistent but sprinkling translation
> > > changes / invalidations between arch and generic code feels
> > > error-prone.
> >
> > Eh, leaving critical operations to arch code isn't exactly error free e=
ither :-)
> >
> > > Especially if there isn't clear ownership of a particular flag, e.g. =
0 -> 1
> > > transitions happen in generic code and 1 -> 0 happens in arch code.
> >
> > The difference I see is that removing access to the memslot on 0=3D>1 i=
s mandatory,
> > whereas any action on 1=3D>0 is not.  So IMO it's not arbitrary sprinkl=
ing of
> > invalidations, it's deliberately putting the common, mandatory logic in=
 generic
> > code, while leaving optional performance tweaks to arch code.
> >
> > > Even in the case of KVM_MEM_USERFAULT, an architecture could potentia=
lly
> > > preserve the stage-2 translations but reap access permissions without
> > > modifying page tables / TLBs.
> >
> > Yes, but that wouldn't be strictly unique to KVM_MEM_USERFAULT.
> >
> > E.g. for NUMA balancing faults (or rather, the PROT_NONE conversions), =
KVM could
> > handle the mmu_notifier invalidations by removing access while keeping =
the PTEs,
> > so that faulting the memory back would be a lighter weight operation.  =
Ditto for
> > reacting to other protection changes that come through mmu_notifiers.
> >
> > If we want to go down that general path, my preference would be to put =
the control
> > logic in generic code, and then call dedicated arch APIs for removing p=
rotections.
> >
> > > I'm happy with arch interfaces that clearly express intent (make this
> > > memslot inaccessible), then the architecture can make an informed
> > > decision about how to best achieve that. Otherwise we're always going=
 to
> > > use the largest possible hammer potentially overinvalidate.
> >
> > Yeah, definitely no argument there given x86's history in this area.  T=
hough if
> > we want to tackle that problem straightaway, I think I'd vote to add th=
e
> > aforementioned dedicated APIs for removing protections, with a generic =
default
> > implementation that simply invokes kvm_arch_flush_shadow_memslot().

I'm happy to add something like kvm_arch_invalidate_shadow_memslot()
which invokes kvm_arch_flush_shadow_memslot() by default (and has a
lockdep assertion for holding the slots lock), with no architectures
currently providing a specialization. Feel free to suggest better
names.

Or we could do kvm_arch_userfault_changed(/* ... */, bool enabled),
and, for the default implementation, if `enabled =3D=3D true`, do
kvm_arch_invalidate_shadow_memslot(), else do nothing. Then x86 can
specialize this. This arguably still leaves the responsibility of
unmapping/invalidating everything to arch code...

Let me know your preferences, Sean and Oliver.

>
> Alternatively, we could punt on this issue entirely by not allowing users=
pace to
> set KVM_MEM_USERFAULT on anything but KVM_MR_CREATE.  I.e. allow a FLAGS_=
ONLY
> update to clear USERFAULT, but not set USERFAULT.
>
> Other than emulating poisoned pages, is there a (potential) use case for =
setting
> KVM_MEM_USERFAULT after a VM has been created?

Today, Google's userspace does not know when creating memslots that we
will need to enable KVM_MEM_USERFAULT. We could delete and re-add the
memslots of course, but overall, for any userspace, I think adding
this restriction (for what seems to be a non-issue :)) isn't worth it.

Thanks!

