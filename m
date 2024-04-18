Return-Path: <kvm+bounces-15131-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B3648AA2F7
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 21:39:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5E7A61C218AF
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 19:39:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8BB41802C9;
	Thu, 18 Apr 2024 19:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iN23bsov"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B610179204
	for <kvm@vger.kernel.org>; Thu, 18 Apr 2024 19:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713469185; cv=none; b=p8NnEpjl+9ff8xK040W0XLwQyxCgEQt84z01QDnD5Vo3d8N9dz4Vp+/WEYEqQGI1avDj16UkIiAaNdJPs7hgy9xmHkzcxlsx2Q33LLeaNScZ7QN+o5fHoDoaLXT1EgXvAZP+MATMAWWHMLGraQO1wsf+uzLMnyCrX7b79Fhu4Uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713469185; c=relaxed/simple;
	bh=rnFVLQqc/mw4sypAHw9zV7jXx+BMP8kqD67pnNnKmcA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=R80/CLJMQZ87nxw4LLll/h1N8yj4gOCRe7UHrKi2YqJDogSuRQispL/gcwBfdbnASd1avrU+r30GO/YFZleqRTWnFn+Ji51tY4fJWtTEEYn9RpPNY9X3M0AP2gNCNCgGlM8u4voiaRYQHk+D+HNj6Vw9FT8HtY813vuVafeID/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iN23bsov; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dc6b26783b4so2146001276.0
        for <kvm@vger.kernel.org>; Thu, 18 Apr 2024 12:39:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713469182; x=1714073982; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/walaANZcwrAULlBFksouFTo0jOoJE4MLym2DFNleCo=;
        b=iN23bsovqhe/sXyU1uxbbKBtO51Mthxs+PrQ1o+b9ZNd6JiN9WKN/ut1W6+UIaCKHk
         rDo4+AzcMt/1DETC39K9djr1oFzhykgbKEsFafL0R+oSSyTCDzVoL4aYro/sGmVhRceL
         kpXSSUGp3BmRbACuGnhez5o3B1zhub1j6JDpC+BHBmOuEKcLMlHYKl57wvO+xglBpCI1
         GguO9ErCutDi55pKUXjzWDyU3Lj6aiAm1Ef7otK6j+xUDqlARxQHN2JWsIzXEMrvAGuN
         jhG3FZEa16OA4pAo60qiNPwuiwfmKLDnqPrzrnejoCYeP6koJ19Oj0iUZfuZcKb0rmIW
         iGew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713469182; x=1714073982;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=/walaANZcwrAULlBFksouFTo0jOoJE4MLym2DFNleCo=;
        b=TLzCaTjng8JBpJDU343FNCs6YTqGN3LnWylncyiFsWVR75n2gItm4Bim4uMaQpTReO
         QB3te+o/rHfeqKA3Wj8XNeTgtUg/ziEFZ2J0cW+WaJ8YRTYTDb9rwNToXM0SO6beigkO
         8Yv7rAj6XzQT+0jxmJJoGZb91XnwYEw19d/V3sn8QobYP53mTSBVpiPsEAOtI8qZcUvb
         mLWMWuXqo0SGIak1pIjSADZ6re5dBHwXIt6zcqY/h6ilLi1i1nXJkLM96qH7RbIapYoK
         rsRfk+VXI23v1Li2okkAnRTt+5Gkc8CmIBt2xQG3UUIk4KlJzHsUk17TMA4IzVRVyK3q
         9NCg==
X-Forwarded-Encrypted: i=1; AJvYcCXhqaU0CiAQwSabsRphHT2gjYINL2YhBPm6NZIbuG/f9/w3fKTC5/WY1s/LgbYdmJqq9MH1Lm+mUOPDQNRL0aYjRxp7
X-Gm-Message-State: AOJu0Yyi0mVbNFNQX8fYfKV/3tmwFTMA3/WtHnrygeliQkTJS+E5m6kA
	p9AelPQlN4cKATGv5L1nDmAxU+rQBmtGqXVtkMzqj5Xj1CmBH7LfXzGIdtcCQSNtttIsdkm1wk/
	Etw==
X-Google-Smtp-Source: AGHT+IF3W4S5GJKa3JYyzshurOyaFwZgFatkgc0lbxhIPo0+cIPNOTiMRb5I3UXl94geOjY6Fa7ntbG5n6U=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:70e:b0:dbe:30cd:8fcb with SMTP id
 k14-20020a056902070e00b00dbe30cd8fcbmr327384ybt.0.1713469182538; Thu, 18 Apr
 2024 12:39:42 -0700 (PDT)
Date: Thu, 18 Apr 2024 12:39:40 -0700
In-Reply-To: <CALzav=cYOy-gUu9vsKOx6wU2c4Jaz+mOutvAFJ3-KJ7Z0mhV5Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240402213656.3068504-1-dmatlack@google.com> <cb793d79-f476-3134-23b7-dc43801b133e@loongson.cn>
 <CALzav=c_qP2kLVS6R4VQRyS6aMvj0381WKCE=5JpqRUrdEYPyg@mail.gmail.com>
 <Zg7fAr7uYMiw_pc3@google.com> <CALzav=cF+tq-snKbdP76FpodUdd7Fhu9Pf3jTK5c5=vb-MY9cQ@mail.gmail.com>
 <Zg7utCRWGDvxdQ6a@google.com> <CALzav=coESqsXnLbX2emiO_P12WrPZh9WutxF6JWWqwX-6RFDg@mail.gmail.com>
 <Zh1h4gfOpImWHQsC@google.com> <Zh2HWPFvWAxQSRVM@google.com> <CALzav=cYOy-gUu9vsKOx6wU2c4Jaz+mOutvAFJ3-KJ7Z0mhV5Q@mail.gmail.com>
Message-ID: <ZiF2_A4UAI35lCbt@google.com>
Subject: Re: [PATCH v2] KVM: Aggressively drop and reacquire mmu_lock during CLEAR_DIRTY_LOG
From: Sean Christopherson <seanjc@google.com>
To: David Matlack <dmatlack@google.com>
Cc: maobibo <maobibo@loongson.cn>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 18, 2024, David Matlack wrote:
> On Mon, Apr 15, 2024 at 1:00=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> > On a related topic, I think we should take a hard look at the rwlock_ne=
edbreak()
> > usage in tdp_mmu_iter_cond_resched().  Because dropping when allocating=
 is really
> > just speculatively dropping mmu_lock because it _might_ be contended, b=
ut doing
> > so at a batch size that provides a good balance between doing enough wo=
rk under
> > mmu_lock and providing low latency for vCPUs.  I.e. in theory, we shoul=
d be able
> > to handle this fully in tdp_mmu_iter_cond_resched(), but that code is n=
owhere
> > near smart enough and it's currently only for preemptible kernels (or a=
t least,
> > it's supposed to be only for preemptible kernels).
>=20
> Dropping the lock for allocating is also to drop GFP_NOWAIT, i.e. to
> allow direct reclaim and other blocking operations. This is valuable
> for "cry-for-help" type migrations where the host is under intense
> memory pressure. I'd rather do the reclaim on the eager page splitting
> thread than a vCPU.

...

> >  (a) We drop the preemption dependency from tdp_mmu_iter_cond_resched()=
's lock
> >      contention logic, and improve the logic (especially the forward pr=
ogress
> >      guarantees) so that tdp_mmu_iter_cond_resched() provides solid per=
formance
> >      in all cases.
>=20
> The only way I can think of to universally measure forward progress
> would be by wall time. Again that becomes more possible with the
> mmu_lock timing stats. But we'll have to hand-pick some thresholds and
> that feels wrong...

Yeah, hard pass on anything based on arbitrary time thresholds.  And I thin=
k we
should have the mmu_lock stats be buried behind a Kconfig, i.e. we shouldn'=
t use
them in KVM to guide behavior in any way.

> >  (b) We completely remove the rwlock_needbreak() checks from
> >      tdp_mmu_iter_cond_resched(), and instead rely on unconditionally d=
ropping
> >      mmu_lock in flows where doing so provides the best overall balance=
, e.g. as
> >      in the eager page split case.
> >
> > I don't have a strong preference between (a) and (b), though I think I'=
d lean
> > towards (b), because it's simpler.  My guess is that we can achieve sim=
ilar
> > performance results with both.  E.g. odds are decent that the "best" ba=
tch size
> > (see #6) is large enough that the cost of dropping and reacquiring mmu_=
lock is
> > in the noise when it's not contented.
> >
> > The main argument I see for (b) is that it's simpler, as only code that=
 actually
> > has a justified need to drop mmu_lock does so.  The advantage I see wit=
h (a) is
> > that it would provide structure and documentation for choosing when to =
drop
> > mmu_lock (or not).
>=20
> I need to think it through more but I'm leaning toward (b) and use the
> mmu_lock stats to flag potential flows that are holding the lock too
> long. With (b) we can make each flow incrementally better and don't
> have to pick any magic numbers.

I'm fully in the (b) boat given the GFP_NOWAIT =3D> direct reclaim piece of=
 the
puzzle.

  1. TDP MMU now frees and allocates roots with mmu_lock held for read
  2. The "zap everything" MTRR trainwreck likely on its way out the door[1]
  3. The change_pte() mmu_notifier is gone[2]
  4. We're working on aging GFNs with mmu_lock held for read, or not at all=
[3]

As a result, the the only paths that take mmu_lock for write are "zap all",
mmu_notifier invalidations events, and APICv inhibit toggling, which does
kvm_zap_gfn_range() on a single page, i.e. won't ever need to yield.

The "slow" zap all is mutually exclusive with anything interesting because =
it
only runs when the process is exiting.

The "fast" zap all should never yield when it holds mmu_lock for write, bec=
ause
the part that runs with mmu_lock held for write is <drum roll> fast.  Maaay=
be
the slow part that runs with mmu_lock held for read could drop mmu_lock on
contention.

That just leaves mmu_notifier invalidations, and the mess with dynamic pree=
mption
that resulted in KVM bouncing mmu_lock between invalidations and vCPUs is p=
retty
strong evidence that yielding on mmu_lock contention when zapping SPTEs is =
a
terrible idea.

And yielding from most flows that hold mmu_lock for read is also a net nega=
tive,
as (a) *all* readers need to go aways, (b) the majority of such flows are
short-lived and operate in vCPU context, and (c) the remaining flows that t=
ake
mmu_lock are either slow paths (zap all, mmu_notifier invalidations), or ra=
re
(APICv toggling).

In short, I highly doubt we'll ever have more than a few flows where yieldi=
ng
because mmu_lock is contended is actually desirable.  As a result, odds are=
 good
that the reasons for dropping mmu_lock in the middle of a sequence are goin=
g to
be unique each and every time.

E.g. eager page splitting wants to drop it in order to do direct reclaim, a=
nd
because it can be super long running, *and* doesn't need to flush TLBs when=
 yielding.

kvm_tdp_mmu_zap_invalidated_roots() is the only flow I can think of where d=
ropping
mmu_lock on contention might make sense, e.g. to allow an mmu_notifier inva=
lidation
to go through.  Again, that's a very long-running flow that doesn't need to=
 flush
TLBs, is (hopefully) not being done from vCPU context, and could put KVM in=
to a
scenario where it blocks an mmu_notifiers, which in turn blocks vCPUs that =
are
trying to rebuild SPTEs.

[1] https://lore.kernel.org/all/20240309010929.1403984-1-seanjc@google.com
[2] https://lore.kernel.org/all/20240405115815.3226315-1-pbonzini@redhat.co=
m
[3] https://lore.kernel.org/all/20240401232946.1837665-1-jthoughton@google.=
com

