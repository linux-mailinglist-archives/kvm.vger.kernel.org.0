Return-Path: <kvm+bounces-16185-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B28F8B60DE
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2024 20:05:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 15B9C1C2109A
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2024 18:05:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D65BC127E30;
	Mon, 29 Apr 2024 18:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="szpLWeio"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B19EC127B40
	for <kvm@vger.kernel.org>; Mon, 29 Apr 2024 18:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714413913; cv=none; b=WT0/YgTmOskXjZpPoVOIJNvkLr1uq6P4OPW1/IYTk3XW1ECSG9wAso7gOPTz774UNLIj5bEgtcHDHFkacVt12FsmqSweOXWTjDHEm9Wk0EhR7tnRLZlEnt1hf+WfTzqR9z95MAZjroVcj6QxQFo0P+J9HCYuvGzob9LhDryCPXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714413913; c=relaxed/simple;
	bh=+IPVA2SNQ/ipxJ26rxmJpyrnWh1IRB9DXkWy2/dv+ZU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MhGfhsyi0pNqiWFkI65WyspSBfJNolO7jQDV0G4shM7aKnYbYG2Nf98tTGees9NWWUpSAn3P+Y3xRDbpCNiJMS4qCvsipHm1CH0n8zPz8vdqGaIn0pXEIUBg+tyahCPkyrv1zOhGRPQrfuOSGG9K6JdzJFBZlbTO0OOvaRxolwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=szpLWeio; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1eb6744767cso24291765ad.3
        for <kvm@vger.kernel.org>; Mon, 29 Apr 2024 11:05:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714413911; x=1715018711; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=q+rxDFhq7ooCY3FbHaPBnz6b0eh+xEJQNgP6hx8lZCw=;
        b=szpLWeiolnZ+U3wjOuLXQBWQ1DTNP1ddIEsinXvFxVjXET9IYCOn3J5VkpoQ2qf19y
         EYajcT8gVWGqwk1sA7ifADDzITvhgkKB6HodpOr6FydwnBnUF2YwU1OJwhiTKMOdXLuB
         Vn1RcTy1aUkB+GqkHkwWwqU6ZUi3MpT5iQYCf43SeSEXkoOqzzI8mBtsvx3lTo1dCs8l
         CumbIePrCCOrXi8a5rqETJ64uXRDipc/dZRw38fCL+FocXsl5ZoPLxlclswqEb1acl/X
         e5SvuITtHYuljF0sA24C9HkXDYZ1wKDc1MvqK8PD0f/1Nth7wfuChlA/GiJrNEHZqMja
         zJrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714413911; x=1715018711;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=q+rxDFhq7ooCY3FbHaPBnz6b0eh+xEJQNgP6hx8lZCw=;
        b=fWJxvddIfRDV1aHAmKa3GPMH243Ac8ZxoXOrB8Ii3o/J/PobbSSZqZY+4j6hyZmd31
         It7ybjuqxxEfKh0whDeADVcAj/GfGdvNUc6+tkfdsdVSCQBvp4nIZEEqAy+gXGl+tXyo
         dfBd26x3axLIC1UaLix7h9AvWEHt9X2X9pXTzIlxri9Rkekm7cO8mNqpgdAaemIyu3l2
         dCL3OkOgah4L4Jo08CSl9QQ42xUtZjIOnVbS9/2YTPrDmYYEVw7cdRmp5yv1mqAg7JLL
         SnIcepkjrWJkGEto0Q9/e9SGW2IW33rprdH1AQyDgAYbtsBHInYzrtQweXX7m/ZUkFVS
         9w0A==
X-Forwarded-Encrypted: i=1; AJvYcCVLZfv5nA3JoBH3XIpJiN509E2cJ4XkAaeVMyjOvtEYkOHAZ+hMWp3Q7X9Ka/iCKYtuHfqNypYixYmOcUafzojp6VG0
X-Gm-Message-State: AOJu0Yx0V7/Jjh/KxWosGaNLjo9WWK9JMwaQM4xgOk9FMtJVxq/vh4YW
	j6MonFg+m5/avqDc1NVt2RJrmWVt9j1MVBVfT90QdHCXs4Vp+j0PQCoZhA7xZikqpat2jTEAmKI
	+Ew==
X-Google-Smtp-Source: AGHT+IHHyIzU4Bhd1mvMLJcHJO2yrT80IxPyrkhYFi3YYHjmsBZC9nPYlsR7gNYj3MnU9p1Q+xwsdqpVIWo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:e5ce:b0:1e7:b7b7:81c1 with SMTP id
 u14-20020a170902e5ce00b001e7b7b781c1mr211844plf.4.1714413910929; Mon, 29 Apr
 2024 11:05:10 -0700 (PDT)
Date: Mon, 29 Apr 2024 11:05:09 -0700
In-Reply-To: <CALzav=dyeNtDKW5-s=vGhWASbbxtBY4gkHKv_eqPnqavPfoa+g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240307163541.92138-1-dmatlack@google.com> <ZiwWG4iHQYREwFP2@google.com>
 <CALzav=dyeNtDKW5-s=vGhWASbbxtBY4gkHKv_eqPnqavPfoa+g@mail.gmail.com>
Message-ID: <Zi_hVeBVhEODwP4x@google.com>
Subject: Re: [PATCH v2] KVM: Mark a vCPU as preempted/ready iff it's scheduled
 out while running
From: Sean Christopherson <seanjc@google.com>
To: David Matlack <dmatlack@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 29, 2024, David Matlack wrote:
> On Fri, Apr 26, 2024 at 2:01=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> > On Thu, Mar 07, 2024, David Matlack wrote:
> > >
> > > -     if (current->on_rq) {
> > > +     if (current->on_rq && vcpu->wants_to_run) {
> > >               WRITE_ONCE(vcpu->preempted, true);
> > >               WRITE_ONCE(vcpu->ready, true);
> > >       }
> >
> > Long story short, I was playing around with wants_to_run for a few hair=
brained
> > ideas, and realized that there's a TOCTOU bug here.  Userspace can togg=
le
> > run->immediate_exit at will, e.g. can clear it after the kernel loads i=
t to
> > compute vcpu->wants_to_run.
> >
> > That's not fatal for this use case, since userspace would only be shoot=
ing itself
> > in the foot, but it leaves a very dangerous landmine, e.g. if something=
 else in
> > KVM keys off of vcpu->wants_to_run to detect that KVM is in its run loo=
p, i.e.
> > relies on wants_to_run being set if KVM is in its core run loop.
> >
> > To address that, I think we should have all architectures check wants_t=
o_run, not
> > immediate_exit.
>=20
> Rephrasing to make sure I understand you correctly: It's possible for
> KVM to see conflicting values of wants_to_run and immediate_exit,
> since userspace can change immediate_exit at any point. e.g. It's
> possible for KVM to see wants_to_run=3Dtrue and immediate_exit=3Dtrue,
> which wouldn't make sense. This wouldn't cause any bugs today, but
> could result in buggy behavior down the road so we might as well clean
> it up now.

Yep.

> > Hmm, and we should probably go a step further and actively prevent usin=
g
> > immediate_exit from the kernel, e.g. rename it to something scary like:
> >
> > diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> > index 2190adbe3002..9c5fe1dae744 100644
> > --- a/include/uapi/linux/kvm.h
> > +++ b/include/uapi/linux/kvm.h
> > @@ -196,7 +196,11 @@ struct kvm_xen_exit {
> >  struct kvm_run {
> >         /* in */
> >         __u8 request_interrupt_window;
> > +#ifndef __KERNEL__
> >         __u8 immediate_exit;
> > +#else
> > +       __u8 hidden_do_not_touch;
> > +#endif
>=20
> This would result in:
>=20
>   vcpu->wants_to_run =3D !READ_ONCE(vcpu->run->hidden_do_not_touch);
>=20
> :)
>=20
> Of course we could pick a better name...

Heh, yeah, for demonstration purposes only.

> but isn't every field in kvm_run open to TOCTOU issues?

Yep, and we've had bugs, e.g. see commit 0d033770d43a ("KVM: x86: Fix
KVM_CAP_SYNC_REGS's sync_regs() TOCTOU issues").

> (Is immediate_exit really special enough to need this protection?)

I think so.

It's not that immediate_exit is more prone to TOCTOU bugs than other fields=
 in
kvm_run (though I do think immediate_exit does have higher potential for fu=
ture
bugs), or even that the severity of bugs that could occur with immediate_ex=
it is
high (which I again think is the case), it's that it's actually feasible to
effectively prevent TOCTOU bugs with minimal cost (including ongoing mainte=
nance
cost).  At the cost of a small-ish one-time change, we can protect *all* KV=
M code
against improer usage of immediate_exit.

Doing the same for other kvm_run fields is less feasiable, as the relevant =
logic
is much more architecture specific.  E.g. x86 now does a full copy of sregs=
 and
events in kvm_sync_regs, but not regs because the input for regs is never c=
hecked.
And blindly creating an in-kernel copy of all state would be extremely wast=
eful
for s390, which IIUC uses kvm_run.s.regs as _the_ buffer for guest register
state.

