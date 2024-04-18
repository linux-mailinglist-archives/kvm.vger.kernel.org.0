Return-Path: <kvm+bounces-15125-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 73D898AA24D
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 20:51:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CDB1BB22013
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 18:51:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BE3F17AD6E;
	Thu, 18 Apr 2024 18:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4e9jd3pL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80D6125778
	for <kvm@vger.kernel.org>; Thu, 18 Apr 2024 18:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713466279; cv=none; b=SzYfOvuS8q/7WX1nBa32j2LSPZO0LQGX9omtt9V4sPdHyVo6CY+iLAll41zQeEUsQpAIBWDLgTGzKXQfXVhpbynyU7qNa3YcK6+4Xh195gb8rtVSaU/N5f5YMPfp1ZhrSlk0zdNaOFMdkL3QuDCQSiOv3LHmI39koPG584R8DRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713466279; c=relaxed/simple;
	bh=4y3a+fwJf6FIoWIotPqgiH5/mADtzJ5ka4Lh7Uq2K2k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lR3o6tzwGIhFKYSslnHYD9d7F+CpyGgKRRpkUKdVHtoTO9hwzoL2jSaZUNG8ABCobkJDZ18y/enLe7g0v5ZFvndj6B4xO4Q7xXekGCKd/jT/sE7SxDOWGbdcGXgcv+n/7f9MhGzKNnZJ1ifNFH/N9PUbjgHxasTic7cjXCZIK/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4e9jd3pL; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-343c7fae6e4so1023587f8f.1
        for <kvm@vger.kernel.org>; Thu, 18 Apr 2024 11:51:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713466276; x=1714071076; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yHdwEs7I4JqT8n0T8aw5cMSzQ7vN7E+el4XFD1cwHRA=;
        b=4e9jd3pLU/wpmO3dm7u+Z2gUxahohm2UA+6bww6xQSbzyjYsX9CcQpwAi5KuxJBZdL
         2931dpmPJb8GAWVsydBMaFCDTWerUZOFu7+T9JcohscSM9sYsCzz7Yl0A20nau5u4x+O
         M9ybBXHMcjxB0d7Lrttxvtz3tvhmgdEB7UsW2QyHD6UGPic1xsPPmPbVDz0hoQWaZAFG
         ohd719/FGOwBjeRwhNqp8Vh+D5iGiwyG0uvcoJuPZ6G7JlVERa64b9uG2adlXAyd+Mwi
         v0ih4gxMU9eY2P61aDZ8dkar2xb55ddFq3K5Oqmn8oX58j0S7UU21ZfeA9T2jOqcFJqT
         jWbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713466276; x=1714071076;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yHdwEs7I4JqT8n0T8aw5cMSzQ7vN7E+el4XFD1cwHRA=;
        b=nVyMbDCfhDg+mZXKfNROK2MS1UK6+V8TGsBGto7JFH/qQf75rp+Qm+s3qh3QmCnh4P
         xN5Aa/3JQG+oqmuBuEKkRq4uP/1AjsO4Ty54HJwsuuRiNKTTGvBDesQTbiewEc4gv/cE
         MgZMf5O21YfbnHpK+eUsBGoMvBZmpadXvXbakKaVjalgpHKhKkqWITbfsg4DTwEHILlJ
         VxkT527XzKu+BvPyEF6Kun1PDVrBTWrb5on0hNbJvxmY0G7WTwnC0u6mjFvy8DRLv5lf
         3wEUd6qEL83Bo9Cr7+DxHHc6RcdHfHDCg5/vbc5v2vNb7uVTjvMQVLdygMQ4uznvn3pD
         GUBg==
X-Forwarded-Encrypted: i=1; AJvYcCXWPXNJsU5ZYFHp5BCakPzuZi+sndc01YZyZ+3Y+aTTBLmJp3xE0sXKVcPz68KOv+uFL9wdY3UQvKCHR0AMYolaBMjQ
X-Gm-Message-State: AOJu0YzouQgX6mytrfab4YOdIVtML4zbPh35gYQuSv1Km1pMwU7LdlZc
	JDuWxJYbXgtAQ4FwSXJ2KqIDrkjF5xj8B/Ovmjq6rwapgzXRs/ahj146TX3TlONSXTCUIQB1HdC
	nXbvaWM+Z1vee0CWznRlS/aKeBg6+lpoL6U1DLuL3FQG1X+Do3MFf
X-Google-Smtp-Source: AGHT+IEqUGsGnbRrvl3pNnrxWrXAHYkIt3WUBO1cmR9vg19QSMQQST0ClRZ7D68wBC/01zezSt8cKyr0QzyR/IIQx6k=
X-Received: by 2002:a5d:6d8c:0:b0:346:251a:396d with SMTP id
 l12-20020a5d6d8c000000b00346251a396dmr2943561wrs.51.1713466275568; Thu, 18
 Apr 2024 11:51:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240402213656.3068504-1-dmatlack@google.com> <cb793d79-f476-3134-23b7-dc43801b133e@loongson.cn>
 <CALzav=c_qP2kLVS6R4VQRyS6aMvj0381WKCE=5JpqRUrdEYPyg@mail.gmail.com>
 <Zg7fAr7uYMiw_pc3@google.com> <CALzav=cF+tq-snKbdP76FpodUdd7Fhu9Pf3jTK5c5=vb-MY9cQ@mail.gmail.com>
 <Zg7utCRWGDvxdQ6a@google.com> <CALzav=coESqsXnLbX2emiO_P12WrPZh9WutxF6JWWqwX-6RFDg@mail.gmail.com>
 <Zh1h4gfOpImWHQsC@google.com> <Zh2HWPFvWAxQSRVM@google.com>
In-Reply-To: <Zh2HWPFvWAxQSRVM@google.com>
From: David Matlack <dmatlack@google.com>
Date: Thu, 18 Apr 2024 11:50:46 -0700
Message-ID: <CALzav=cYOy-gUu9vsKOx6wU2c4Jaz+mOutvAFJ3-KJ7Z0mhV5Q@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: Aggressively drop and reacquire mmu_lock during CLEAR_DIRTY_LOG
To: Sean Christopherson <seanjc@google.com>
Cc: maobibo <maobibo@loongson.cn>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 15, 2024 at 1:00=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Mon, Apr 15, 2024, David Matlack wrote:
>
> > If this is all true, then a better / more targeted fix for this issue w=
ould be
> > to drop mmu_lock in the TDP MMU eager page splitting path. For example,=
 we
> > could limit the "allocate under lock" behavior to only when the read-lo=
ck is
> > held, e.g.
> >
> > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > index 7dfdc49a6ade..ea34f8232d97 100644
> > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > @@ -1472,9 +1472,11 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp_for=
_split(struct kvm *kvm,
> >          * If this allocation fails we drop the lock and retry with rec=
laim
> >          * allowed.
> >          */
> > -       sp =3D __tdp_mmu_alloc_sp_for_split(GFP_NOWAIT | __GFP_ACCOUNT,=
 nid);
> > -       if (sp)
> > -               return sp;
> > +       if (shared) {
> > +               sp =3D __tdp_mmu_alloc_sp_for_split(GFP_NOWAIT | __GFP_=
ACCOUNT, nid);
> > +               if (sp)
> > +                       return sp;
> > +       }
> >
> >         rcu_read_unlock();
> >
> > I checked the KVM/arm64 eager page splitting code, and it drops the mmu=
_lock to
> > allocate page tables. So I suspect no fix is needed there and this is, =
in fact,
> > purely and x86-specific issue.
>
> Hmm, it'd be nice if we didn't have to rely on random arch flows to coinc=
identally
> do the optimal thing for eager page splitting.  Not sure how best to docu=
ment the
> "best known practice" though.

We discussed upstreaming Google's mmu_lock timing stats yesterday.
Once that's in place, KVM could WARN_ON_ONCE() if the mmu_lock is held
for an excessive amount of time to help flag these kinds of issues.
That might trigger false positives though, as holding mmu_lock for a
long time is no big deal if there's no contention.

>
> As for the TDP MMU code, unless the cost of dropping and reacquiring mmu_=
lock for
> read is measurable, I would prefer to unconditionally drop mmu_lock, and =
delete
> the GFP_NOWAIT allocation.  There can be lock contention when mmu_lock is=
 held
> for read, it's just less common.

SGTM. I'll do some testing. Unfortunately, the original MySQL workload
that led to this patch has bitrotted so I'm having some trouble
reproducing the original results and confirming the TDP MMU fix. Sigh.

>
> On a related topic, I think we should take a hard look at the rwlock_need=
break()
> usage in tdp_mmu_iter_cond_resched().  Because dropping when allocating i=
s really
> just speculatively dropping mmu_lock because it _might_ be contended, but=
 doing
> so at a batch size that provides a good balance between doing enough work=
 under
> mmu_lock and providing low latency for vCPUs.  I.e. in theory, we should =
be able
> to handle this fully in tdp_mmu_iter_cond_resched(), but that code is now=
here
> near smart enough and it's currently only for preemptible kernels (or at =
least,
> it's supposed to be only for preemptible kernels).

Dropping the lock for allocating is also to drop GFP_NOWAIT, i.e. to
allow direct reclaim and other blocking operations. This is valuable
for "cry-for-help" type migrations where the host is under intense
memory pressure. I'd rather do the reclaim on the eager page splitting
thread than a vCPU.

But I agree that the rwlock_needbreak() checks are pretty much
untested and likely super nonoptimal.

>
> Simply yielding on contention is not at all optimal, as evidenced by the =
whole
> dynamic preemption debacle[1][2].  The immediate issue was "fixed" by hav=
ing vCPUs
> avoid taking mmu_lock, but KVM really shouldn't get into a situation wher=
e KVM is
> pathologically dropping mmu_lock to the point where a non-vCPU action gri=
nds to
> a halt.
>
> The contention logic fails to take into account many things:
>
>  (1) Is the other task higher priority?
>
>  (2) Is the other task a vCPU, or something else?
>
>  (3) Will yielding actually allow the other task to make forward progress=
?
>
>  (4) What is the cost of dropping mmu_lock, e.g. is a remote TLB flush ne=
eded?
>
>  (5) What is the expected duration this task is expected to hold mmu_lock=
?
>
>  (6) Has this task made enough progress for yielding to be a decent choic=
e?
>
> and probably many more than that.
>
> As we discussed off-list, I think there are two viable approaches:
>
>  (a) We drop the preemption dependency from tdp_mmu_iter_cond_resched()'s=
 lock
>      contention logic, and improve the logic (especially the forward prog=
ress
>      guarantees) so that tdp_mmu_iter_cond_resched() provides solid perfo=
rmance
>      in all cases.

The only way I can think of to universally measure forward progress
would be by wall time. Again that becomes more possible with the
mmu_lock timing stats. But we'll have to hand-pick some thresholds and
that feels wrong...

>
>  (b) We completely remove the rwlock_needbreak() checks from
>      tdp_mmu_iter_cond_resched(), and instead rely on unconditionally dro=
pping
>      mmu_lock in flows where doing so provides the best overall balance, =
e.g. as
>      in the eager page split case.
>
> I don't have a strong preference between (a) and (b), though I think I'd =
lean
> towards (b), because it's simpler.  My guess is that we can achieve simil=
ar
> performance results with both.  E.g. odds are decent that the "best" batc=
h size
> (see #6) is large enough that the cost of dropping and reacquiring mmu_lo=
ck is
> in the noise when it's not contented.
>
> The main argument I see for (b) is that it's simpler, as only code that a=
ctually
> has a justified need to drop mmu_lock does so.  The advantage I see with =
(a) is
> that it would provide structure and documentation for choosing when to dr=
op
> mmu_lock (or not).

I need to think it through more but I'm leaning toward (b) and use the
mmu_lock stats to flag potential flows that are holding the lock too
long. With (b) we can make each flow incrementally better and don't
have to pick any magic numbers.

>
> E.g. dropping in the eager page split path makes sense because KVM does s=
o at a
> large batch size, odds are good that the contending task is a vCPU, there=
's no
> TLB flush required, the total hold time of mmu_lock is high, and we know =
that
> dropping mmu_lock will allow vCPUs to make forward progress.  (a) would d=
o a much
> better job of capturing all that in code, albeit with quite a bit more co=
mplexity.
>
> Regardless of which option we choose, I think we should drop the preempti=
ble kernel
> dependency from the lock contention logic in tdp_mmu_iter_cond_resched(),=
 i.e.
> manually check if mmu_lock is contented instead of bouncing through rwloc=
k_needbreak().

+1

>
> The current approach essentially means that there's zero testing of the p=
erformance
> of the yield-on-contention logic.  E.g. the complaints about the TDP MMU =
yielding
> too aggressively only popped up when commit c597bfddc9e9 ("sched: Provide=
 Kconfig
> support for default dynamic preempt mode") unintentionally enabled
> rwlock_needbreak() by default.
>
> That's definitely easier said then done though, as I suspect that if we s=
witched
> to rwlock_is_contended(), i.e. dropped the preemptible requirement, witho=
ut also
> enhancing tdp_mmu_iter_cond_resched() to make it smarter as above, we'd s=
ee a lot
> of performance regressions.
>
> [1] https://lore.kernel.org/all/20240312193911.1796717-3-seanjc@google.co=
m
> [2] https://lore.kernel.org/all/20240222012640.2820927-1-seanjc@google.co=
m

