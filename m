Return-Path: <kvm+bounces-36704-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CDBC6A20026
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 22:53:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 260443A4BA3
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 21:52:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF8311D935C;
	Mon, 27 Jan 2025 21:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="llGaNhq/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f178.google.com (mail-yb1-f178.google.com [209.85.219.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 409131DB125
	for <kvm@vger.kernel.org>; Mon, 27 Jan 2025 21:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738014771; cv=none; b=hWEgEYmc23d1JU1EwZnUYrCgCAvVgfU6d1GmS7zpuM1NxDhivNkW8HXSz+OwdY3FDMLVM4iSCs81lYfEEHUPIhfSTRy+Ahq67WA4B25oW6JSOzuJSSC0+3mVrDb14Jyhe09On/oDyEbP3mkLRi4alfPot49lsEG5K0Ecf86UsrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738014771; c=relaxed/simple;
	bh=oS1fxZDswD1Bk6KlBmXHQOanL6tAtsMDpbKdgwKjS+g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NsfwCrVWfE887q9lX9uxkeA3yMsc8Ly3at2SdjTossM8Un4GTI0rzl9+3QhldOMNcvJ/gcJo+SonBQz2Ftjepe/o1WZhQHAoo38K5AHEIlQQxSTFm3TmJEqZkDpLR31pwwpQqApA2pDAEgqnkn9624tL6RPzVaHhbAVqb6K6Pfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=llGaNhq/; arc=none smtp.client-ip=209.85.219.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-yb1-f178.google.com with SMTP id 3f1490d57ef6-e54d268bc3dso8839473276.1
        for <kvm@vger.kernel.org>; Mon, 27 Jan 2025 13:52:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738014768; x=1738619568; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I897tCuZhvrNIbQHuNTZaYrnkeG6diyqY3ualY4Fnoc=;
        b=llGaNhq/3JoSI26T5ntG1jn2qB/NaQWu3G3W/AUjqZRenkq7B6MNMeCFz3J+/R4hDD
         V3NKITkatcTSn5VOdHLYq7zGpEQrjplqtGB1J1aCQfKgk/MWBe4vrrzwEOY0J0ylIMw8
         0d2iR7PFIWRlhJoJE4pSnZKqGiZNCJ9uDSj+eJzKrfJ4gPtuT+Fnpropwls+70aMxUyM
         E5SJAmntUevu2qruIWgn7OGCsNUaMDJhX5jsGf2lBSYUlVErCDZQlcqBYmu1VQca7ZSL
         F9m2smlU4vDNvuNMp4MHImUr4dsvzPSzmS5uiYPRxQ6QucQ68U6QHcm3tEV7WeCa1QAc
         9dwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738014768; x=1738619568;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I897tCuZhvrNIbQHuNTZaYrnkeG6diyqY3ualY4Fnoc=;
        b=VEYUCdglsJ21svU3fqZ4vNHXgOXV6ca9v2Flpcf6lLTBw2l2TMMsrrdNcqks+yw98E
         THHY5Sencrr41eK83LlwXZ7xO/pgQkVIffkgmek6n9dko0vfg+6fcn/2gG8M7SMLrh0+
         g87Bvu4WF0D9EYhkdbqUOf0Fg+cSsCiRBkFDjLBMKhaYq3dqPyRsYbwkEBO0OWeukDLu
         8+8fzJjxGOGz5we1obMwn8xB9cm9pLzk3YkdtWPThbR5R+Dq0JFbP1GPb3u5do+Akunb
         3vMnJB+N2JDCDfq7+bA5R9XQKVpvQbrBogiscbWwpZWTXxx4vBuZXA0BeMHEIAwTnfvH
         mtdA==
X-Forwarded-Encrypted: i=1; AJvYcCX0c4vcMmBGV2hVQbU3+L+6SGgNr+JS3m78rZaTPdScuGX8FGRz+YBKXODnHdPdiAyytTM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxRWTwkMrg2lDzKHINynVoys7xlhMcKsZibYTWSzygidBwZQcar
	ZGgxfMbZC7NV11/lFzRshln02Vy80DbqeYjkXjBHs6JEQe3Leo+cc/prlk3dNDU487I6apNNXVn
	ZGoxQYjuH7YoB3K3pHBv6CwwniAZpI/Siwl/O
X-Gm-Gg: ASbGnctTddYL7imfWAD/c0J9gJk3F2u3PmGAOO89Wc6/HAlhbzeDJGJVrcH7isAnSkx
	R2tRX06njJJsGapadSHB5tE5eG08PsO92R+oHrB93EWcIUsNMPeAw82eaLWN0knA1bOwRLCEDx9
	2UcOkJFq5MUjN/BE4S
X-Google-Smtp-Source: AGHT+IHAWtax6xf0NMYVOq4PYKdlqN79gycO8FxndAnf4G7Sk8K7FeOqOI/QcEC+ap+u/rKZRD7i6TTHJP6abKZ12hY=
X-Received: by 2002:a05:690c:4090:b0:6ef:a4bc:8bc9 with SMTP id
 00721157ae682-6f6eb6b02ddmr232300537b3.21.1738014767862; Mon, 27 Jan 2025
 13:52:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241105184333.2305744-1-jthoughton@google.com> <20241105184333.2305744-9-jthoughton@google.com>
In-Reply-To: <20241105184333.2305744-9-jthoughton@google.com>
From: James Houghton <jthoughton@google.com>
Date: Mon, 27 Jan 2025 13:52:12 -0800
X-Gm-Features: AWEUYZlKvVPbACfTNGBI84ASzhKTCwpXe_kBlJJgWffU0HcC_69NoII9NlrX4CI
Message-ID: <CADrL8HVvNbNe1o7Db3du_QDTvkMoSuv5gU09TAHxzY45BqpSjA@mail.gmail.com>
Subject: Re: [PATCH v8 08/11] KVM: x86/mmu: Add infrastructure to allow
 walking rmaps outside of mmu_lock
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, Wei Xu <weixugc@google.com>, 
	Yu Zhao <yuzhao@google.com>, Axel Rasmussen <axelrasmussen@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 5, 2024 at 10:43=E2=80=AFAM James Houghton <jthoughton@google.c=
om> wrote:
>
> From: Sean Christopherson <seanjc@google.com>
>
> Steal another bit from rmap entries (which are word aligned pointers, i.e=
.
> have 2 free bits on 32-bit KVM, and 3 free bits on 64-bit KVM), and use
> the bit to implement a *very* rudimentary per-rmap spinlock.  The only
> anticipated usage of the lock outside of mmu_lock is for aging gfns, and
> collisions between aging and other MMU rmap operations are quite rare,
> e.g. unless userspace is being silly and aging a tiny range over and over
> in a tight loop, time between contention when aging an actively running V=
M
> is O(seconds).  In short, a more sophisticated locking scheme shouldn't b=
e
> necessary.
>
> Note, the lock only protects the rmap structure itself, SPTEs that are
> pointed at by a locked rmap can still be modified and zapped by another
> task (KVM drops/zaps SPTEs before deleting the rmap entries)
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Co-developed-by: James Houghton <jthoughton@google.com>
> Signed-off-by: James Houghton <jthoughton@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h |   3 +-
>  arch/x86/kvm/mmu/mmu.c          | 129 +++++++++++++++++++++++++++++---
>  2 files changed, 120 insertions(+), 12 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_h=
ost.h
> index 84ee08078686..378b87ff5b1f 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -26,6 +26,7 @@
>  #include <linux/irqbypass.h>
>  #include <linux/hyperv.h>
>  #include <linux/kfifo.h>
> +#include <linux/atomic.h>
>
>  #include <asm/apic.h>
>  #include <asm/pvclock-abi.h>
> @@ -402,7 +403,7 @@ union kvm_cpu_role {
>  };
>
>  struct kvm_rmap_head {
> -       unsigned long val;
> +       atomic_long_t val;
>  };
>
>  struct kvm_pio_request {
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 145ea180963e..1cdb77df0a4d 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -847,11 +847,117 @@ static struct kvm_memory_slot *gfn_to_memslot_dirt=
y_bitmap(struct kvm_vcpu *vcpu
>   * About rmap_head encoding:
>   *
>   * If the bit zero of rmap_head->val is clear, then it points to the onl=
y spte
> - * in this rmap chain. Otherwise, (rmap_head->val & ~1) points to a stru=
ct
> + * in this rmap chain. Otherwise, (rmap_head->val & ~3) points to a stru=
ct
>   * pte_list_desc containing more mappings.
>   */
>  #define KVM_RMAP_MANY  BIT(0)
>
> +/*
> + * rmaps and PTE lists are mostly protected by mmu_lock (the shadow MMU =
always
> + * operates with mmu_lock held for write), but rmaps can be walked witho=
ut
> + * holding mmu_lock so long as the caller can tolerate SPTEs in the rmap=
 chain
> + * being zapped/dropped _while the rmap is locked_.
> + *
> + * Other than the KVM_RMAP_LOCKED flag, modifications to rmap entries mu=
st be
> + * done while holding mmu_lock for write.  This allows a task walking rm=
aps
> + * without holding mmu_lock to concurrently walk the same entries as a t=
ask
> + * that is holding mmu_lock but _not_ the rmap lock.  Neither task will =
modify
> + * the rmaps, thus the walks are stable.
> + *
> + * As alluded to above, SPTEs in rmaps are _not_ protected by KVM_RMAP_L=
OCKED,
> + * only the rmap chains themselves are protected.  E.g. holding an rmap'=
s lock
> + * ensures all "struct pte_list_desc" fields are stable.
> + */
> +#define KVM_RMAP_LOCKED        BIT(1)
> +
> +static unsigned long kvm_rmap_lock(struct kvm_rmap_head *rmap_head)
> +{
> +       unsigned long old_val, new_val;
> +
> +       /*
> +        * Elide the lock if the rmap is empty, as lockless walkers (read=
-only
> +        * mode) don't need to (and can't) walk an empty rmap, nor can th=
ey add
> +        * entries to the rmap.  I.e. the only paths that process empty r=
maps
> +        * do so while holding mmu_lock for write, and are mutually exclu=
sive.
> +        */
> +       old_val =3D atomic_long_read(&rmap_head->val);
> +       if (!old_val)
> +               return 0;
> +
> +       do {
> +               /*
> +                * If the rmap is locked, wait for it to be unlocked befo=
re
> +                * trying acquire the lock, e.g. to bounce the cache line=
.
> +                */
> +               while (old_val & KVM_RMAP_LOCKED) {
> +                       old_val =3D atomic_long_read(&rmap_head->val);
> +                       cpu_relax();
> +               }
> +
> +               /*
> +                * Recheck for an empty rmap, it may have been purged by =
the
> +                * task that held the lock.
> +                */
> +               if (!old_val)
> +                       return 0;
> +
> +               new_val =3D old_val | KVM_RMAP_LOCKED;
> +       /*
> +        * Use try_cmpxchg_acquire to prevent reads and writes to the rma=
p
> +        * from being reordered outside of the critical section created b=
y
> +        * __kvm_rmap_lock.
> +        *
> +        * Pairs with smp_store_release in kvm_rmap_unlock.
> +        *
> +        * For the !old_val case, no ordering is needed, as there is no r=
map
> +        * to walk.
> +        */
> +       } while (!atomic_long_try_cmpxchg_acquire(&rmap_head->val, &old_v=
al, new_val));
> +
> +       /* Return the old value, i.e. _without_ the LOCKED bit set. */
> +       return old_val;
> +}
> +
> +static void kvm_rmap_unlock(struct kvm_rmap_head *rmap_head,
> +                           unsigned long new_val)
> +{
> +       WARN_ON_ONCE(new_val & KVM_RMAP_LOCKED);
> +       /*
> +        * Ensure that all accesses to the rmap have completed
> +        * before we actually unlock the rmap.
> +        *
> +        * Pairs with the atomic_long_try_cmpxchg_acquire in __kvm_rmap_l=
ock.
> +        */
> +       atomic_long_set_release(&rmap_head->val, new_val);
> +}
> +
> +static unsigned long kvm_rmap_get(struct kvm_rmap_head *rmap_head)
> +{
> +       return atomic_long_read(&rmap_head->val) & ~KVM_RMAP_LOCKED;
> +}
> +
> +/*
> + * If mmu_lock isn't held, rmaps can only locked in read-only mode.  The=
 actual
> + * locking is the same, but the caller is disallowed from modifying the =
rmap,
> + * and so the unlock flow is a nop if the rmap is/was empty.
> + */
> +__maybe_unused
> +static unsigned long kvm_rmap_lock_readonly(struct kvm_rmap_head *rmap_h=
ead)
> +{
> +       return __kvm_rmap_lock(rmap_head);
> +}
> +
> +__maybe_unused
> +static void kvm_rmap_unlock_readonly(struct kvm_rmap_head *rmap_head,
> +                                    unsigned long old_val)
> +{
> +       if (!old_val)
> +               return;
> +
> +       KVM_MMU_WARN_ON(old_val !=3D kvm_rmap_get(rmap_head));
> +       atomic_long_set(&rmap_head->val, old_val);

Trying not to unnecessarily extend the conversion we already had about
memory ordering here[1]....

I'm pretty sure this should actually be atomic_long_set_release(),
just like kvm_rmap_unlock(), as we cannot permit (at least) the
compiler to reorder rmap reads past this atomic store.

I *think* I mistakenly thought it was okay to leave it as
atomic_long_set() because this routine is only reading, but of course,
those reads must stay within the critical section.

Anyway, I've refactored it like this:

static void __kvm_rmap_unlock(struct kvm_rmap_head *rmap_head,
                              unsigned long val)
{
        KVM_MMU_WARN_ON(val & KVM_RMAP_LOCKED);
        /*
         * Ensure that all accesses to the rmap have completed
         * before we actually unlock the rmap.
         *
         * Pairs with the atomic_long_try_cmpxchg_acquire in __kvm_rmap_loc=
k.
         */
        atomic_long_set_release(&rmap_head->val, val);
}

static void kvm_rmap_unlock(struct kvm *kvm,
                            struct kvm_rmap_head *rmap_head,
                            unsigned long new_val)
{
        lockdep_assert_held_write(&kvm->mmu_lock);

        __kvm_rmap_unlock(rmap_head, new_val);
}

static void kvm_rmap_unlock_readonly(struct kvm_rmap_head *rmap_head,
                                     unsigned long old_val)
{
        if (!old_val)
                return;

        KVM_MMU_WARN_ON(old_val !=3D kvm_rmap_get(rmap_head));

        __kvm_rmap_unlock(rmap_head, old_val);
        preempt_enable();
}

It's still true that the !old_val case needs no such ordering, as
!old_val means there is nothing to walk.

[1]: https://lore.kernel.org/all/ZuG4YYzozOddPRCm@google.com/

