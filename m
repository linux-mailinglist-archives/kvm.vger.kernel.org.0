Return-Path: <kvm+bounces-46399-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 32289AB5F4D
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 00:27:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 69C633BE5C1
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 22:27:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FB8020F060;
	Tue, 13 May 2025 22:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Zv1MHfN/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f171.google.com (mail-yb1-f171.google.com [209.85.219.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4333071747
	for <kvm@vger.kernel.org>; Tue, 13 May 2025 22:27:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747175268; cv=none; b=HUJ/SckwOZU9CUKq7p9ftyshB5uGhZe6acR6r0y95Th5uysNrVofD9f6mlt8DopVAOAcgdaUOQtkhgnvGsq8l26O7plUGWDZX4bMg7zxMEBlhhBdptJMM94Gw9AXImILtO+ZT/uGk7FmoEQQmVPQxoxylZRq6YiDvRsTX7dgRXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747175268; c=relaxed/simple;
	bh=hV9dEfGvRpT7A/K+vjfSEDzaamdRUI6QA3Ijvf5dz+4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pS97blg2yGrMvzCVdMWyltWS3334ZaPZQyo/dFRrnz3MCIa0fZcpUxRlbvdfI4lFLM9HejSeD2EfBka7eoT0of8mLMu/ZyGhKNF8zOWNDJKf8UHEABcRuCro+go20+4+UkNbTvxdDk+rJOcAgoK8y91u9yLvNQ7nCRq45V0burI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Zv1MHfN/; arc=none smtp.client-ip=209.85.219.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-yb1-f171.google.com with SMTP id 3f1490d57ef6-e7b2c28f67eso1635034276.1
        for <kvm@vger.kernel.org>; Tue, 13 May 2025 15:27:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747175266; x=1747780066; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d4BxEI90f+LuMJhBx2vC+R7qBMnsPOdwtq/dnJCZ35o=;
        b=Zv1MHfN/DbT3TYiB3YWLab97P+mSGj3wVGE0vldMvxqCGSeqVaBbS0YF0BMvT+pVdl
         YUUBDMffxf4RvynVxnokXW/n+46YfOrRIGdElDF6RQB78Ty4t2oxGWFXv5BkIDVPfyi5
         ewOimruKVuN92vIyBwFwD4OwpjSgETpaUtCrbhLMjlbBBo3YaywGdsZNSSu8R/ltwgOu
         7NBVm+qgnlP9AaV8DrlPf0aWZijCFh0UZxLb7Q9YbbmdovJ0ql4opzaEMTOu7uXN4ndo
         vfEQyXw6A4y3PeOJD0yMNrlqy+hXn2BqlU25e6kbYaTalGnBRZGmYKinFeH39JIVbQid
         hUmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747175266; x=1747780066;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d4BxEI90f+LuMJhBx2vC+R7qBMnsPOdwtq/dnJCZ35o=;
        b=TVEXbnBJyNIdwvZsRRd+xL9rT37BYGXiJ5YXHSc3N3+bG8cjqiKcCTxQfJZUHdVnnE
         KV2YAz9QSJI0MkrAlukqs+t9Bwo5eiYg7TxxNW19nKrccprlNoYtJAMl/Phq/GVA+fZN
         42bzV4OKtkFvb2P4DaMmPm1kFk62wIKbNjiS0jqPJBQmXyz4dLBgM3wEEvKltPLH0C0x
         Mxj9lfH2sVFciPRYAgX71gB77y40NCvQKt0Sc5Lmcy+WGs8Y/HN091hatqciuCYUhi8G
         vdsFf+pzv0NQxhqpGf7+/hQONWsZC/32EFuQbklx311wAJafC5Xo5IuCX7Z5mteOoKAT
         tHBQ==
X-Forwarded-Encrypted: i=1; AJvYcCV6s+TBCJOeQg6/hadzIl3SqrTzjC5HjPPOMzxv9OHC07xkQPMAYuFw1mjRk1BPcBG7IM0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxiedYhYrs2aR49awHbkeVrl6/Btt7CcMVHIEoDIUK2UGbLBvB8
	29IkJE+2xLLN3Kd+lAJfOCuw/zZxh/cG03t60wplGJLFO0i4yI89VJMV8XWdUuQp0Ki+NDerCne
	AGAV46HWM5wQpYH6+uhT7ttwBNY7rJbxHHVn84hmZwBY3AHAGojVm2zA=
X-Gm-Gg: ASbGncvnPGdIKqbHuoIPleIH9x82HLfR80Ic2iEFuIp2GcgFaeQCPqaXozarSHycIjI
	KoY05tszzVVrCPaYJSoibgaYamc3pG/gzqdIEfWd2S/Awbz8q4pTrnCqmIGj0198/Ba8m0cFe8n
	zZWFIQ0rz9txZNqjXug0IGKKi6Yx9pSHn/FXW/Q7nKi+GAPrRe07GtrSDNrB6rnBI=
X-Google-Smtp-Source: AGHT+IHGGVAQ9j1MIS0WEDIVdUN3GUhfjFMvl4Az4pKzorsoWzipPARxrRCPUSiC/QTtB57wEmS/FD54NGpHgV2JQIk=
X-Received: by 2002:a05:6902:218b:b0:e72:d449:72ed with SMTP id
 3f1490d57ef6-e7b3d50495fmr1563601276.24.1747175265982; Tue, 13 May 2025
 15:27:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250508141012.1411952-1-seanjc@google.com> <20250508141012.1411952-4-seanjc@google.com>
 <CADrL8HURpnXgN0ux4sUk0nVze=A6d488i_ztiZTwGZUdDMoTvg@mail.gmail.com> <aCNTnXf5qZ1MMSNi@google.com>
In-Reply-To: <aCNTnXf5qZ1MMSNi@google.com>
From: James Houghton <jthoughton@google.com>
Date: Tue, 13 May 2025 15:27:09 -0700
X-Gm-Features: AX0GCFsDGXmj7RlobLqWuUuE1IVN7eJdtvf1EE2cZW_PZqhmBNgwx1moW1K1BG0
Message-ID: <CADrL8HUaofWTcV7X5b1AXEud03bC+gfZiecyFpux9m1tC25hOg@mail.gmail.com>
Subject: Re: [PATCH v2 3/5] KVM: Conditionally reschedule when resetting the
 dirty ring
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Peter Xu <peterx@redhat.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 13, 2025 at 7:13=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Mon, May 12, 2025, James Houghton wrote:
> > On Thu, May 8, 2025 at 7:11=E2=80=AFAM Sean Christopherson <seanjc@goog=
le.com> wrote:
> > > ---
> > >  virt/kvm/dirty_ring.c | 10 ++++++++++
> > >  1 file changed, 10 insertions(+)
> > >
> > > diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
> > > index e844e869e8c7..97cca0c02fd1 100644
> > > --- a/virt/kvm/dirty_ring.c
> > > +++ b/virt/kvm/dirty_ring.c
> > > @@ -134,6 +134,16 @@ int kvm_dirty_ring_reset(struct kvm *kvm, struct=
 kvm_dirty_ring *ring,
> > >
> > >                 ring->reset_index++;
> > >                 (*nr_entries_reset)++;
> > > +
> > > +               /*
> > > +                * While the size of each ring is fixed, it's possibl=
e for the
> > > +                * ring to be constantly re-dirtied/harvested while t=
he reset
> > > +                * is in-progress (the hard limit exists only to guar=
d against
> > > +                * wrapping the count into negative space).
> > > +                */
> > > +               if (!first_round)
> > > +                       cond_resched();
> >
> > Should we be dropping slots_lock here?
>
> Could we?  Yes.  Should we?  Eh.  I don't see any value in doing so, beca=
use in
> practice, it's extremely unlikely anything will be waiting on slots_lock.
>
> kvm_vm_ioctl_reset_dirty_pages() operates on all vCPUs, i.e. there won't =
be
> competing calls to reset other rings.  A well-behaved userspace won't be =
modifying
> memslots or dirty logs, and won't be toggling nx_huge_pages.
>
> That leaves kvm_vm_ioctl_set_mem_attributes(), kvm_inhibit_apic_access_pa=
ge(),
> kvm_assign_ioeventfd(), snp_launch_update(), and coalesced IO/MMIO (un)re=
gistration.
> Except for snp_launch_update(), those are all brutally slow paths, e.g. r=
equire
> SRCU synchronization and/or zapping of SPTEs.  And snp_launch_update() is=
 probably
> fairly slow too.

Okay, that makes sense.

> And dropping slots_lock only makes any sense for non-preemptible kernels,=
 because
> preemptible kernels include an equivalent check in KVM_MMU_UNLOCK().

I'm not really sure what "equivalent check" you mean, sorry. For
preemptible kernels, we could reschedule at any time, so dropping the
slots_lock on a cond_resched() wouldn't do much, yeah. Hopefully
that's partially what you mean.

> It's also possible that dropping slots_lock in this case could be a net n=
egative.
> I don't think it's likely, but I don't think it's any more or less likely=
 that
> droppings slots_lock is a net positive.  Without performance data to guid=
e us,
> it'd be little more than a guess, and I really, really don't want to set =
a
> precedence of dropping a mutex on cond_resched() without a very strong re=
ason
> for doing so.

Fair enough.

Also, while we're at it, could you add a
`lockdep_assert_held(&kvm->slots_lock)` to this function? :) Not
necessarily in this patch.

