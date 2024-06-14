Return-Path: <kvm+bounces-19640-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DD3490803E
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 02:46:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C7502B224FD
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 00:46:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 697AF4A1E;
	Fri, 14 Jun 2024 00:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VSQ0vAHr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDC632107
	for <kvm@vger.kernel.org>; Fri, 14 Jun 2024 00:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718325979; cv=none; b=O41sb7+n2rEiDKBxn04rJb6+OVCjJ9IuPqJmgmocqH1s5I1L7ko69iF/U7iGinHlOjtontcqXCZaQrub9TS+HAQobFjqYh9ICxEQcHxy/YVlAepngTInb1aGenzZql1pcSKziVBOTAnvFSshbbAc5wKKW+1jPZ4CNpbN5K5A8bQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718325979; c=relaxed/simple;
	bh=FaJMwA7FZEfroEEokBWOVEECEfwQ7UZ4ZpeRN/2/PiE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LIaOTPJv/GTzG2iLojCorq3bYnjg19VwWdvi2zSdL6c4S9Ffe8uGaug5kvEb1xrkOD4z1NAgoQQ7ZwRTqL22KLpehxOMt83Khci9qfPTQ1XvkkleeJlu7+5UVUOaQcXYkxPWf2wixWzDH6FFxY9WWZbr84do2Ma+NxE0VMKof7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VSQ0vAHr; arc=none smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-4400cc0dad1so208921cf.0
        for <kvm@vger.kernel.org>; Thu, 13 Jun 2024 17:46:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718325977; x=1718930777; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Asxs/kZeDuFqFuPWDIAMNDEd8GKDcr8694xjcmYE3Ms=;
        b=VSQ0vAHrheJsxMtMCSFrSWSabzeitxXTG6H2q2uUZEeVxl0fzWpK3Z6E9bjo4nltFm
         Q4FDA33LurGHzLO6xLqzSYdi2wzny0WSB/+7CrIGf+OVtDG5vTDKCoXRSNzBEqBb5zPF
         gVQmFWGqFVCBWntMYE1z7b7JRyC0orLx/eaE/ernv59uWb+rOIDMGTwe0ZsFiZeQ71XL
         Yl6W/yfTb1u8izV7VLonH2oMUc6ZZS3D0iNTlZNZsVo3el6Bc4fUU/xFrb5JvXbmgGu4
         5BtK2mLd8w1mXNXdTv7gfL+SQEC5uEtyFE3qJur4Vt6rp1CGqB2OlfrZNofs4eNrTtUl
         OmxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718325977; x=1718930777;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Asxs/kZeDuFqFuPWDIAMNDEd8GKDcr8694xjcmYE3Ms=;
        b=lAkLbHAcZU3Y30onWKedrTgxiOm9ZOm6Man34ZsfGCUsAOnkxskaqdGIY6WPOnLHMq
         b1cD3QE5ZFJxXfVvUrEmIJe2oVovcbmvpoPh34fZj1I4i3fTYXdHv8ef9QwO8CVNqVwF
         7+ti/ahVnloa2Xlbnw7blLuCtpxTM/sLFJdbKi7JJF6BPWZVONGzaAGqu4OL2BoAC7Zz
         I7qmF8vgtr0UoIGKJfhonQZ11WYLQQK8iRDKdoXsjO8clfw6+8iziA7MhCOxiMUh4Qmv
         tl3LCVjp7TAvKkrYmQqNs/ChOVrEiU+wG2h/ZyvDvln0ElOo6oEjYjSRqS6uO/NUFZgJ
         CGgQ==
X-Forwarded-Encrypted: i=1; AJvYcCUeWPYgVhv0ge+LGnDU1v8Rm4BUByhOjn8TFKYKJ9xTQwYunCnOKaqMfalFAkLXphMWbiLjL2orr6//Tleugn9d08Dq
X-Gm-Message-State: AOJu0YxYRlRA/Fw/DVE/BVTATJ+ml3knwxD/qFsKILYLFNoHYLcGh6S1
	sNZZGgu8lwNBqOzJXwQUHqWN+ZL+5ap21HuZyDxeUTGyMgHLZiE1fLngGPnl8BB+K5MLrBo6VP9
	KRUN5BmHTITcjHBSivCZVEjb7yZDwj/C0nqxi
X-Google-Smtp-Source: AGHT+IGjUg3mQVuhJvrtmUiftlzpv301WqnhGdatSbuJnCPMxvufnzhovj6pU+cNzvr99mLC1f9iMBM88+tv9TVf1h4=
X-Received: by 2002:a05:622a:1b07:b0:441:2a51:70e8 with SMTP id
 d75a77b69052e-442176085a5mr1619601cf.4.1718325976582; Thu, 13 Jun 2024
 17:46:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240611002145.2078921-1-jthoughton@google.com>
 <20240611002145.2078921-5-jthoughton@google.com> <CAOUHufYGqbd45shZkGCpqeTV9wcBDUoo3iw1SKiDeFLmrP0+=w@mail.gmail.com>
 <CADrL8HVHcKSW3hiHzKTit07gzo36jtCZCnM9ZpueyifgNdGggw@mail.gmail.com>
 <ZmioedgEBptNoz91@google.com> <CADrL8HU_FKHTz_6d=xhVLZFDQ_zQo-zdB2rqdpa2CKusa1uo+A@mail.gmail.com>
 <ZmjtEBH42u7NUWRc@google.com>
In-Reply-To: <ZmjtEBH42u7NUWRc@google.com>
From: James Houghton <jthoughton@google.com>
Date: Thu, 13 Jun 2024 17:45:40 -0700
Message-ID: <CADrL8HUW2q79F0FsEjhGW0ujij6+FfCqas5UpQp27Epfjc94Nw@mail.gmail.com>
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

On Tue, Jun 11, 2024 at 5:34=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Tue, Jun 11, 2024, James Houghton wrote:
> > On Tue, Jun 11, 2024 at 12:42=E2=80=AFPM Sean Christopherson <seanjc@go=
ogle.com> wrote:
> > > --
> > > diff --git a/mm/mmu_notifier.c b/mm/mmu_notifier.c
> > > index 7b77ad6cf833..07872ae00fa6 100644
> > > --- a/mm/mmu_notifier.c
> > > +++ b/mm/mmu_notifier.c
> > > @@ -384,7 +384,8 @@ int __mmu_notifier_clear_flush_young(struct mm_st=
ruct *mm,
> > >
> > >  int __mmu_notifier_clear_young(struct mm_struct *mm,
> > >                                unsigned long start,
> > > -                              unsigned long end)
> > > +                              unsigned long end,
> > > +                              bool fast_only)
> > >  {
> > >         struct mmu_notifier *subscription;
> > >         int young =3D 0, id;
> > > @@ -393,9 +394,12 @@ int __mmu_notifier_clear_young(struct mm_struct =
*mm,
> > >         hlist_for_each_entry_rcu(subscription,
> > >                                  &mm->notifier_subscriptions->list, h=
list,
> > >                                  srcu_read_lock_held(&srcu)) {
> > > -               if (subscription->ops->clear_young)
> > > -                       young |=3D subscription->ops->clear_young(sub=
scription,
> > > -                                                               mm, s=
tart, end);
> > > +               if (!subscription->ops->clear_young ||
> > > +                   fast_only && !subscription->ops->has_fast_aging)
> > > +                       continue;
> > > +
> > > +               young |=3D subscription->ops->clear_young(subscriptio=
n,
> > > +                                                       mm, start, en=
d);
> >
> > KVM changing has_fast_aging dynamically would be slow, wouldn't it?
>
> No, it could/would be done quite quickly.  But, I'm not suggesting has_fa=
st_aging
> be dynamic, i.e. it's not an "all aging is guaranteed to be fast", it's a=
 "this
> MMU _can_ do fast aging".  It's a bit fuzzy/weird mostly because KVM can =
essentially
> have multiple secondary MMUs wired up to the same mmu_notifier.
>
> > I feel like it's simpler to just pass in fast_only into `clear_young` i=
tself
> > (and this is how I interpreted what you wrote above anyway).
>
> Eh, maybe?  A "has_fast_aging" flag is more robust in the sense that it r=
equires
> secondary MMUs to opt-in, i.e. all secondary MMUs will be considered "slo=
w" by
> default.
>
> It's somewhat of a moot point because KVM is the only secondary MMU that =
implements
> .clear_young() and .test_young() (which I keep forgetting), and that seem=
s unlikely
> to change.
>
> A flag would also avoid an indirect call and thus a RETPOLINE when CONFIG=
_RETPOLINE=3Dy,
> i.e. would be a minor optimization when KVM doesn't suppport fast aging. =
 But that's
> probably a pretty unlikely combination, so it's probably not a valid argu=
ment.
>
> So, I guess I don't have a strong opinion?

(Sorry for the somewhat delayed response... spent some time actually
writing what this would look like.)

I see what you mean, thanks! So has_fast_aging might be set by KVM if
the architecture sets a Kconfig saying that it understands the concept
of fast aging, basically what the presence of this v5's
test_clear_young_fast_only() indicates.

>
> > > Double ugh.  Peeking ahead at the "failure" code, NAK to adding
> > > kvm_arch_young_notifier_likely_fast for all the same reasons I object=
ed to
> > > kvm_arch_has_test_clear_young() in v1.  Please stop trying to do anyt=
hing like
> > > that, I will NAK each every attempt to have core mm/ code call direct=
ly into KVM.
> >
> > Sorry to make you repeat yourself; I'll leave it out of v6. I don't
> > like it either, but I wasn't sure how important it was to avoid
> > calling into unnecessary notifiers if the TDP MMU were completely
> > disabled.
>
> If it's important, e.g. for performance, then the mmu_notifier should hav=
e a flag
> so that the behavior doesn't assume a KVM backend.   Hence my has_fast_ag=
ing
> suggestion.

Thanks! That makes sense.

> > > Anyways, back to this code, before we spin another version, we need t=
o agree on
> > > exactly what behavior we want out of secondary MMUs.  Because to me, =
the behavior
> > > proposed in this version doesn't make any sense.
> > >
> > > Signalling failure because KVM _might_ have relevant aging informatio=
n in SPTEs
> > > that require taking kvm->mmu_lock is a terrible tradeoff.  And for th=
e test_young
> > > case, it's flat out wrong, e.g. if a page is marked Accessed in the T=
DP MMU, then
> > > KVM should return "young", not "failed".
> >
> > Sorry for this oversight. What about something like:
> >
> > 1. test (and maybe clear) A bits on TDP MMU
> > 2. If accessed && !should_clear: return (fast)
> > 3. if (fast_only): return (fast)
> > 4. If !(must check shadow MMU): return (fast)
> > 5. test (and maybe clear) A bits in shadow MMU
> > 6. return (slow)
>
> I don't understand where the "must check shadow MMU" in #4 comes from.  I=
 also
> don't think it's necessary; see below.

I just meant `kvm_has_shadow_mmu_sptes()` or
`kvm_memslots_have_rmaps()`. I like the logic you suggest below. :)

> > Some of this reordering (and maybe a change from
> > kvm_shadow_root_allocated() to checking indirect_shadow_pages or
> > something else) can be done in its own patch.

So just to be clear, for test_young(), I intend to have a patch in v6
to elide the shadow MMU check if the TDP MMU indicates Accessed. Seems
like a pure win; no reason not to include it if we're making logic
changes here anyway.

> >
> > > So rather than failing the fast aging, I think what we want is to kno=
w if an
> > > mmu_notifier found a young SPTE during a fast lookup.  E.g. something=
 like this
> > > in KVM, where using kvm_has_shadow_mmu_sptes() instead of kvm_memslot=
s_have_rmaps()
> > > is an optional optimization to avoid taking mmu_lock for write in pat=
hs where a
> > > (very rare) false negative is acceptable.
> > >
> > >   static bool kvm_has_shadow_mmu_sptes(struct kvm *kvm)
> > >   {
> > >         return !tdp_mmu_enabled || READ_ONCE(kvm->arch.indirect_shado=
w_pages);
> > >   }
> > >
> > >   static int __kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *ran=
ge,
> > >                          bool fast_only)
> > >   {
> > >         int young =3D 0;
> > >
> > >         if (!fast_only && kvm_has_shadow_mmu_sptes(kvm)) {
> > >                 write_lock(&kvm->mmu_lock);
> > >                 young =3D kvm_handle_gfn_range(kvm, range, kvm_age_rm=
ap);
> > >                 write_unlock(&kvm->mmu_lock);
> > >         }
> > >
> > >         if (tdp_mmu_enabled && kvm_tdp_mmu_age_gfn_range(kvm, range))
> > >                 young =3D 1 | MMU_NOTIFY_WAS_FAST;

The most straightforward way (IMHO) to return something like `1 |
MMU_NOTIFY_WAS_FAST` up to the MMU notifier itself is to make
gfn_handler_t return int instead of bool.

In this v5, I worked around this need by using `bool *failed` in patch
5[1]. I think the way this is going to look now in v6 would be cleaner
by actually changing gfn_handler_t to return int, and then we can
write something like what you wrote here. What do you think?

[1]: https://lore.kernel.org/linux-mm/20240611002145.2078921-6-jthoughton@g=
oogle.com/

> > I don't think this line is quite right. We might set
> > MMU_NOTIFY_WAS_FAST even when we took the mmu_lock. I understand what
> > you mean though, thanks.
>
> The name sucks, but I believe the logic is correct.  As posted here in v5=
, the
> MGRLU code wants to age both fast _and_ slow MMUs.  AIUI, the intent is t=
o always
> get aging information, but only look around at other PTEs if it can be do=
ne fast.
>
>         if (should_walk_secondary_mmu()) {
>                 notifier_result =3D
>                         mmu_notifier_test_clear_young_fast_only(
>                                         vma->vm_mm, addr, addr + PAGE_SIZ=
E,
>                                         /*clear=3D*/true);
>         }
>
>         if (notifier_result & MMU_NOTIFIER_FAST_FAILED)
>                 secondary_young =3D mmu_notifier_clear_young(vma->vm_mm, =
addr,
>                                                            addr + PAGE_SI=
ZE);
>         else {
>                 secondary_young =3D notifier_result & MMU_NOTIFIER_FAST_Y=
OUNG;
>                 notifier_was_fast =3D true;
>         }
>
> The change, relative to v5, that I am proposing is that MGLRU looks aroun=
d if
> the page was young in _a_ "fast" secondary MMU, whereas v5 looks around i=
f and
> only if _all_ secondary MMUs are fast.
>
> In other words, if a fast MMU had a young SPTE, look around _that_ MMU, v=
ia the
> fast_only flag.

Oh, yeah, that's a lot more intelligent than what I had. I think I
fully understand your suggestion; I guess we'll see in v6. :)

I wonder if this still makes sense if whether or not an MMU is "fast"
is determined by how contended some lock(s) are at the time. I think
it does, but I guess we can discuss more if it turns out that having
an architecture participate like this is actually something we want to
do (i.e., that performance results say it's a good idea).

Thanks Sean!

