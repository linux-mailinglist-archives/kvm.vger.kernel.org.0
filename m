Return-Path: <kvm+bounces-19369-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3AE2C904778
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 01:05:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C873D286C7C
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 23:05:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 886D0155C9F;
	Tue, 11 Jun 2024 23:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Dh07i8Le"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 483CA5BAFC
	for <kvm@vger.kernel.org>; Tue, 11 Jun 2024 23:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718147127; cv=none; b=JqJ/3X99i1TnUTvKdwQen6Bi9QQeVWwpEexNfJhj6SQNPWNd3J1mvBDnc4a/0NDb8bgapIAz+3/XEKgdJzEhry6AI93LWSo3tWCBML5h/3EjawvYYvrTv447OcF65uLBRr5NDTUVEX4mylkbqcqvSe9vexOCFyQI/WX9B8Qg0vU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718147127; c=relaxed/simple;
	bh=BoPidXd0qEL/VN+p66VMqndM+I9E6zuVNAGk0ln/hwA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eYcQi2GNzOSmLbdnR3HZShp69LzmIpNl7URSkn04BBWdW3+5T5wgiYd8gx2ntyaqrfxgBmpf6FP/as0p3jIPHWXibn68gsk38u/5DbEzpYKPGPsVlPjbBaQtQ7Xxa4Vn/Cuot4vQKWJRCelBmiYPD5KW1ZfzjrhP+2J9FT+q6+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Dh07i8Le; arc=none smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-4400cc0dad1so175151cf.0
        for <kvm@vger.kernel.org>; Tue, 11 Jun 2024 16:05:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718147124; x=1718751924; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Pz/3hS9rvEm8ISFTbesB06oUlpFYSPujM05j9EdyaiQ=;
        b=Dh07i8LeMTi1P/XiU8mOuGUnSW7YxOF575760j5BaYylEjPLGK2VdM5i77VxT2OEhK
         qtUauoNk0lWDctYB/6BiO0u4ly9jQ0JD0iX9RKY18q/tQqu3vHsv33PfUmLj+RRqo90a
         +EhSOc2tElTufMtRFxi2aoZKc9ZHzeUwJa1uPakME1Nu9uyFQahnASrFS27O3aSa8sgQ
         yWzIsprMDS1x2BhH/OKalXoMm7V8mBW/JBiLaL2D/GUoVxlFvmLMaqVXgKcIVVKQNyUM
         7WNPT/PyRxoCuGWKx60vTi/qPzFkTFqfKiaq46aaX85wyCY9ZEZb3/GBgttedpIPtsqY
         3gnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718147124; x=1718751924;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Pz/3hS9rvEm8ISFTbesB06oUlpFYSPujM05j9EdyaiQ=;
        b=K7hyKafGt/0l0XSkeKbuf3FCeBxkVSFnwbosM9CA1bd8hkyZeN0fzz5r9GZgck01O5
         eF6rgznjMj5QfeATiXDz+Tu3R5ht5gzJZBo3EPlgrtvwsKdwyyvSPb3UtpeqlBTnSCk2
         NwpoWfQD1+6r9dpLy7TA4PPxEjzOZS0LANO1pVt9s1RZfmBvSw2LxD1rZDzAZgjPXh+e
         hpf+snF8z93v8oPbwLAtRRPb9SqSEpbEIxMDNkDTKtlgC8+seqEmZhJ+zZ5QYWoX5sWL
         8fcnpHtUUtFonIzbfdMN4TaGkQPJMEAsA69FLQqjKOX0cwrG14P7gZoKjrqpHv85WuF8
         otaQ==
X-Forwarded-Encrypted: i=1; AJvYcCW5BfuoijP0lYHJ5ZISZZJVEdj0YvBHDmI36J3o02/fvSmvZ29skqBA7DZOqQ4UIJ1DSncoL/k6WyqT9FXQxC8PB7+a
X-Gm-Message-State: AOJu0YwmXxjDMeypzQ7kUFx/w0ciz5WWTEHpSjNbiwnXRB2/rXX5LRWt
	CyERV7yW3QLrFmjkgzr9TgJPSRW5GP3viVkn7N3NXHJkxyoKCck2KqNVQCmEp4GgxybhWvImd7G
	p0TAwiTQEzGpAGCEvIGSYzBpPSfnwTPRnk2NR
X-Google-Smtp-Source: AGHT+IE52oInjAZCB3WBMhaUU5ZrU3GZGDMx8kQzX/bSZjmjZyyxSH/FDIuluJ0bSVsR8b8JvGhmRRklaeYoppeG6VQ=
X-Received: by 2002:a05:622a:4015:b0:440:331b:59f7 with SMTP id
 d75a77b69052e-44158bbdd7cmr1206381cf.6.1718147123716; Tue, 11 Jun 2024
 16:05:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240611002145.2078921-1-jthoughton@google.com>
 <20240611002145.2078921-5-jthoughton@google.com> <CAOUHufYGqbd45shZkGCpqeTV9wcBDUoo3iw1SKiDeFLmrP0+=w@mail.gmail.com>
 <CADrL8HVHcKSW3hiHzKTit07gzo36jtCZCnM9ZpueyifgNdGggw@mail.gmail.com> <ZmioedgEBptNoz91@google.com>
In-Reply-To: <ZmioedgEBptNoz91@google.com>
From: James Houghton <jthoughton@google.com>
Date: Tue, 11 Jun 2024 16:04:47 -0700
Message-ID: <CADrL8HU_FKHTz_6d=xhVLZFDQ_zQo-zdB2rqdpa2CKusa1uo+A@mail.gmail.com>
Subject: Re: [PATCH v5 4/9] mm: Add test_clear_young_fast_only MMU notifier
To: Sean Christopherson <seanjc@google.com>
Cc: Yu Zhao <yuzhao@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Ankit Agrawal <ankita@nvidia.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	James Morse <james.morse@arm.com>, Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Raghavendra Rao Ananta <rananta@google.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Shaoqin Huang <shahuang@redhat.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Wei Xu <weixugc@google.com>, 
	Will Deacon <will@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 11, 2024 at 12:42=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
>
> On Tue, Jun 11, 2024, James Houghton wrote:
> > On Mon, Jun 10, 2024 at 10:34=E2=80=AFPM Yu Zhao <yuzhao@google.com> wr=
ote:
> > >
> > > On Mon, Jun 10, 2024 at 6:22=E2=80=AFPM James Houghton <jthoughton@go=
ogle.com> wrote:
> > > >
> > > > This new notifier is for multi-gen LRU specifically
> > >
> > > Let me call it out before others do: we can't be this self-serving.
> > >
> > > > as it wants to be
> > > > able to get and clear age information from secondary MMUs only if i=
t can
> > > > be done "fast".
> > > >
> > > > By having this notifier specifically created for MGLRU, what "fast"
> > > > means comes down to what is "fast" enough to improve MGLRU's abilit=
y to
> > > > reclaim most of the time.
> > > >
> > > > Signed-off-by: James Houghton <jthoughton@google.com>
> > >
> > > If we'd like this to pass other MM reviewers, especially the MMU
> > > notifier maintainers, we'd need to design a generic API that can
> > > benefit all the *existing* users: idle page tracking [1], DAMON [2]
> > > and MGLRU.
> > >
> > > Also I personally prefer to extend the existing callbacks by adding
> > > new parameters, and on top of that, I'd try to consolidate the
> > > existing callbacks -- it'd be less of a hard sell if my changes resul=
t
> > > in less code, not more.
> > >
> > > (v2 did all these, btw.)
> >
> > I think consolidating the callbacks is cleanest, like you had it in
> > v2. I really wasn't sure about this change honestly, but it was my
> > attempt to incorporate feedback like this[3] from v4. I'll consolidate
> > the callbacks like you had in v2.
>
> James, wait for others to chime in before committing yourself to a course=
 of
> action, otherwise you're going to get ping-ponged to hell and back.

Ah yeah. I really mean "I'll do it, provided the other feedback is in
line with this".

>
> > Instead of the bitmap like you had, I imagine we'll have some kind of
> > flags argument that has bits like MMU_NOTIFIER_YOUNG_CLEAR,
> > MMU_NOTIFIER_YOUNG_FAST_ONLY, and other ones as they come up. Does
> > that sound ok?
>
> Why do we need a bundle of flags?  If we extend .clear_young() and .test_=
young()
> as Yu suggests, then we only need a single "bool fast_only".

We don't need to. In my head it's a little easier to collapse them
(slightly less code, and at the callsite you have a flag with a name
instead of a true/false). Making it a bool SGTM.

> As for adding a fast_only versus dedicated APIs, I don't have a strong pr=
eference.
> Extending will require a small amount of additional churn, e.g. to pass i=
n false,
> but that doesn't seem problematic on its own.  On the plus side, there wo=
uld be
> less copy+paste in include/linux/mmu_notifier.h (though that could be sol=
ved with
> macros :-) ).

I think having the extra bool is cleaner than the new fast_only
notifier, definitely.

>
> E.g.
>
> --
> diff --git a/mm/mmu_notifier.c b/mm/mmu_notifier.c
> index 7b77ad6cf833..07872ae00fa6 100644
> --- a/mm/mmu_notifier.c
> +++ b/mm/mmu_notifier.c
> @@ -384,7 +384,8 @@ int __mmu_notifier_clear_flush_young(struct mm_struct=
 *mm,
>
>  int __mmu_notifier_clear_young(struct mm_struct *mm,
>                                unsigned long start,
> -                              unsigned long end)
> +                              unsigned long end,
> +                              bool fast_only)
>  {
>         struct mmu_notifier *subscription;
>         int young =3D 0, id;
> @@ -393,9 +394,12 @@ int __mmu_notifier_clear_young(struct mm_struct *mm,
>         hlist_for_each_entry_rcu(subscription,
>                                  &mm->notifier_subscriptions->list, hlist=
,
>                                  srcu_read_lock_held(&srcu)) {
> -               if (subscription->ops->clear_young)
> -                       young |=3D subscription->ops->clear_young(subscri=
ption,
> -                                                               mm, start=
, end);
> +               if (!subscription->ops->clear_young ||
> +                   fast_only && !subscription->ops->has_fast_aging)
> +                       continue;
> +
> +               young |=3D subscription->ops->clear_young(subscription,
> +                                                       mm, start, end);

KVM changing has_fast_aging dynamically would be slow, wouldn't it? I
feel like it's simpler to just pass in fast_only into `clear_young`
itself (and this is how I interpreted what you wrote above anyway).

>         }
>         srcu_read_unlock(&srcu, id);
>
> @@ -403,7 +407,8 @@ int __mmu_notifier_clear_young(struct mm_struct *mm,
>  }
>
>  int __mmu_notifier_test_young(struct mm_struct *mm,
> -                             unsigned long address)
> +                             unsigned long address,
> +                             bool fast_only)
>  {
>         struct mmu_notifier *subscription;
>         int young =3D 0, id;
> @@ -412,12 +417,15 @@ int __mmu_notifier_test_young(struct mm_struct *mm,
>         hlist_for_each_entry_rcu(subscription,
>                                  &mm->notifier_subscriptions->list, hlist=
,
>                                  srcu_read_lock_held(&srcu)) {
> -               if (subscription->ops->test_young) {
> -                       young =3D subscription->ops->test_young(subscript=
ion, mm,
> -                                                             address);
> -                       if (young)
> -                               break;
> -               }
> +               if (!subscription->ops->test_young)
> +                       continue;
> +
> +               if (fast_only && !subscription->ops->has_fast_aging)
> +                       continue;
> +
> +               young =3D subscription->ops->test_young(subscription, mm,=
 address);
> +               if (young)
> +                       break;
>         }
>         srcu_read_unlock(&srcu, id);
> --
>
> It might also require multiplexing the return value to differentiate betw=
een
> "young" and "failed".  Ugh, but the code already does that, just in a bes=
poke way.

Yeah, that is necessary.

> Double ugh.  Peeking ahead at the "failure" code, NAK to adding
> kvm_arch_young_notifier_likely_fast for all the same reasons I objected t=
o
> kvm_arch_has_test_clear_young() in v1.  Please stop trying to do anything=
 like
> that, I will NAK each every attempt to have core mm/ code call directly i=
nto KVM.

Sorry to make you repeat yourself; I'll leave it out of v6. I don't
like it either, but I wasn't sure how important it was to avoid
calling into unnecessary notifiers if the TDP MMU were completely
disabled.

> Anyways, back to this code, before we spin another version, we need to ag=
ree on
> exactly what behavior we want out of secondary MMUs.  Because to me, the =
behavior
> proposed in this version doesn't make any sense.
>
> Signalling failure because KVM _might_ have relevant aging information in=
 SPTEs
> that require taking kvm->mmu_lock is a terrible tradeoff.  And for the te=
st_young
> case, it's flat out wrong, e.g. if a page is marked Accessed in the TDP M=
MU, then
> KVM should return "young", not "failed".

Sorry for this oversight. What about something like:

1. test (and maybe clear) A bits on TDP MMU
2. If accessed && !should_clear: return (fast)
3. if (fast_only): return (fast)
4. If !(must check shadow MMU): return (fast)
5. test (and maybe clear) A bits in shadow MMU
6. return (slow)

Some of this reordering (and maybe a change from
kvm_shadow_root_allocated() to checking indirect_shadow_pages or
something else) can be done in its own patch.

> If KVM is using the TDP MMU, i.e. has_fast_aging=3Dtrue, then there will =
be rmaps
> if and only if L1 ran a nested VM at some point.  But as proposed, KVM do=
esn't
> actually check if there are any shadow TDP entries to process.  That coul=
d be
> fixed by looking at kvm->arch.indirect_shadow_pages, but even then it's n=
ot clear
> that bailing if kvm->arch.indirect_shadow_pages > 0 makes sense.
>
> E.g. if L1 happens to be running an L2, but <10% of the VM's memory is ex=
posed to
> L2, then "failure" is pretty much guaranteed to a false positive.  And ev=
en for
> the pages that are exposed to L2, "failure" will occur if and only if the=
 pages
> are being accessed _only_ by L2.
>
> There most definitely are use cases where the majority of a VM's memory i=
s accessed
> only by L2.  But if those use cases are performing poorly under MGLRU, th=
en IMO
> we should figure out a way to enhance KVM to do a fast harvest of nested =
TDP
> Accessed information, not make MGRLU+KVM suck for a VMs that run nested V=
Ms.

This makes sense. I don't have data today to say that we would get a
huge win from speeding up harvesting Accessed information from the
shadow MMU would be helpful. Getting this information for the TDP MMU
is at least better than no information at all.

>
> Oh, and calling into mmu_notifiers to do the "slow" version if the fast v=
ersion
> fails is suboptimal.

Agreed. I didn't like this when I wrote it. This can be easily fixed
by making mmu_notifier_clear_young() return "fast" and "young or not",
which I will do.

> So rather than failing the fast aging, I think what we want is to know if=
 an
> mmu_notifier found a young SPTE during a fast lookup.  E.g. something lik=
e this
> in KVM, where using kvm_has_shadow_mmu_sptes() instead of kvm_memslots_ha=
ve_rmaps()
> is an optional optimization to avoid taking mmu_lock for write in paths w=
here a
> (very rare) false negative is acceptable.
>
>   static bool kvm_has_shadow_mmu_sptes(struct kvm *kvm)
>   {
>         return !tdp_mmu_enabled || READ_ONCE(kvm->arch.indirect_shadow_pa=
ges);
>   }
>
>   static int __kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range,
>                          bool fast_only)
>   {
>         int young =3D 0;
>
>         if (!fast_only && kvm_has_shadow_mmu_sptes(kvm)) {
>                 write_lock(&kvm->mmu_lock);
>                 young =3D kvm_handle_gfn_range(kvm, range, kvm_age_rmap);
>                 write_unlock(&kvm->mmu_lock);
>         }
>
>         if (tdp_mmu_enabled && kvm_tdp_mmu_age_gfn_range(kvm, range))
>                 young =3D 1 | MMU_NOTIFY_WAS_FAST;

I don't think this line is quite right. We might set
MMU_NOTIFY_WAS_FAST even when we took the mmu_lock. I understand what
you mean though, thanks.

>
>         return (int)young;
>   }
>
> and then in lru_gen_look_around():
>
>         if (spin_is_contended(pvmw->ptl))
>                 return false;
>
>         /* exclude special VMAs containing anon pages from COW */
>         if (vma->vm_flags & VM_SPECIAL)
>                 return false;
>
>         young =3D ptep_clear_young_notify(vma, addr, pte);
>         if (!young)
>                 return false;
>
>         if (!(young & MMU_NOTIFY_WAS_FAST))
>                 return true;
>
>         young =3D 1;
>
> with the lookaround done using ptep_clear_young_notify_fast().
>
> The MMU_NOTIFY_WAS_FAST flag is gross, but AFAICT it would Just Work with=
out
> needing to update all users of ptep_clear_young_notify() and friends.

Sounds good to me.

Thanks for all the feedback!

