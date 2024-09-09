Return-Path: <kvm+bounces-26148-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D7001972240
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 21:01:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 96A5C2857E8
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 19:01:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F14A1189B95;
	Mon,  9 Sep 2024 19:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IJR1LrNI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74DE11F942
	for <kvm@vger.kernel.org>; Mon,  9 Sep 2024 19:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725908455; cv=none; b=FYK54y5Gw7kttU4KUtA2AYkk2/f5+HkHpJE/whqcmc/B6MEfN3zq82Tvrr05QxKJFNZKA4Yl7oVXPfnJebXg5UGDBfLDJQ7ai24sPfKzAdWDsFZURjyHOFyl4FTKSgeqM2aUn12k0r2cGtIOJKIHPykNXMeN/gstI0xrDdVxR5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725908455; c=relaxed/simple;
	bh=j/numQIZWtWkd6EtYn4iL3OE7HPVQg+q+JXn6cioXTU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=N7Vf4qfpy2WZGRzpdanAhguvKGcl5mkUZ7wKplX1b5+sMfvB0RErIGXdKeCytzx41RV2n71Yev+QKbeIiFUmut90SRKVnTC9tf/MK0AvE1d04mL/gg0WOUsmsW0XY9joJfZLJ7TnLwZ900+dj5Acq69ypLFWhT6HSacmMiCqn/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IJR1LrNI; arc=none smtp.client-ip=209.85.128.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-6cdae28014dso35205917b3.1
        for <kvm@vger.kernel.org>; Mon, 09 Sep 2024 12:00:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725908451; x=1726513251; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A72L+GUjbQDFBk2MUwlGfe11O4m077FKuGtcJSgBRQQ=;
        b=IJR1LrNIAIBVgtkHXuaVN9HDOrRcbydlX8cTKaXZT3ANXZq7yNHc6cT5MLlgpAhvPb
         Fz85SRrLcKkFgaYqiQ91IchbIXyKl3RAoC6ZaEcHM0mZruQyVJERy4sRnso3eYyqytw2
         adkYF7UvExT0CJy5aWrqutJrI0nzerA0E469hHEQyYSepEJmSzoQ2gSI8od4qxARo1bt
         X9eZni/S18UBIwrcTYpzWZq6PBHw5WSQGZvdvP/AJdTOIeIRPaNO1onbTW+M5jFRPf6m
         PcZp2ICn1HkBhZpGOr/eX84ACeev34ldi2NIrWxnFdwR11GLLgamwrCOk0pTsWGZxHZL
         /yDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725908451; x=1726513251;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=A72L+GUjbQDFBk2MUwlGfe11O4m077FKuGtcJSgBRQQ=;
        b=J8Z8R+5PfzCD7ufkYCzijQ7F/zDgWhBuZhjYCJNF7aUix2HyvAWIQu1pSvhcykK41T
         urLR8lIp8u7KpKgzXXyvoef5XNE3epYSuOxwSJTmt4CDWSI5xWoMaxGvrQnrscMKBQTq
         feA6rXAmhG/GwW9mZMCoqOGO8P7fUjNtpwr7lWBrmI/goMj20t4Ee6kKhlka1DevGlgm
         KmEWnpZN94X3ATAb6Ch0TG/nHQ46C7ysyczmHUVH8LF0vjtVlMPBOwb5KY1OjGVxpQmY
         cVo51ODrdhhsN4kEjOlJjEd7MvvjZglrqA/5LkOPtMewPXgH2jW0t6RXoi8ra+rtjBwv
         ws5A==
X-Forwarded-Encrypted: i=1; AJvYcCWBeWH6/kk9VdMsi18vFsq+lRL2FB2vDlJ6TC2dnHB6pMPEZ8W2bCL3DN296nc46rwHUjo=@vger.kernel.org
X-Gm-Message-State: AOJu0YzXVqFBhTWwQVK8cmYuze/CCF8v3UtwRI/J/GEQcJCFNIePf1HL
	wgHgQhLN2NX9hOhk+UyXudbotMknxAAB+6Kw7Z/t/FbeYUdjhM1RkNKSgn8UV8Agf94dC4wUTcf
	agrLghXFPGrNCjGWtl/x41xMXhtYQWqOYNWnS
X-Google-Smtp-Source: AGHT+IFR6zulDZKlUD4bAN1hPEwMA1FY+4vRNJHse0GHukSpBMl4XHH4SgwprP02hwRSXpE0fsxpg+6qvu7h46yJxCs=
X-Received: by 2002:a05:690c:4b0e:b0:6d4:72b7:177e with SMTP id
 00721157ae682-6db95312363mr6193027b3.5.1725908451204; Mon, 09 Sep 2024
 12:00:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240809194335.1726916-1-seanjc@google.com> <20240809194335.1726916-20-seanjc@google.com>
In-Reply-To: <20240809194335.1726916-20-seanjc@google.com>
From: James Houghton <jthoughton@google.com>
Date: Mon, 9 Sep 2024 12:00:14 -0700
Message-ID: <CADrL8HWACwbzraG=MbDoORJ8ramDxb-h9yb0p4nx9-wq4o3c6A@mail.gmail.com>
Subject: Re: [PATCH 19/22] KVM: x86/mmu: Add infrastructure to allow walking
 rmaps outside of mmu_lock
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, Peter Xu <peterx@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 9, 2024 at 12:44=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
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
> ---
>  arch/x86/kvm/mmu/mmu.c | 80 +++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 71 insertions(+), 9 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 8ca7f51c2da3..a683b5fc4026 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -909,11 +909,73 @@ static struct kvm_memory_slot *gfn_to_memslot_dirty=
_bitmap(struct kvm_vcpu *vcpu
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

This last sentence makes me think we need to be careful about memory orderi=
ng.

> + */
> +#define KVM_RMAP_LOCKED        BIT(1)
> +
> +static unsigned long kvm_rmap_lock(struct kvm_rmap_head *rmap_head)
> +{
> +       unsigned long old_val, new_val;
> +
> +       old_val =3D READ_ONCE(rmap_head->val);
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
> +                       old_val =3D READ_ONCE(rmap_head->val);
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
> +       } while (!try_cmpxchg(&rmap_head->val, &old_val, new_val));

I think we (technically) need an smp_rmb() here. I think cmpxchg
implicitly has that on x86 (and this code is x86-only), but should we
nonetheless document that we need smp_rmb() (if it indeed required)?
Perhaps we could/should condition the smp_rmb() on `if (old_val)`.

kvm_rmap_lock_readonly() should have an smb_rmb(), but it seems like
adding it here will do the right thing for the read-only lock side.

> +
> +       /* Return the old value, i.e. _without_ the LOCKED bit set. */
> +       return old_val;
> +}
> +
> +static void kvm_rmap_unlock(struct kvm_rmap_head *rmap_head,
> +                           unsigned long new_val)
> +{
> +       WARN_ON_ONCE(new_val & KVM_RMAP_LOCKED);

Same goes with having an smp_wmb() here. Is it necessary? If so,
should it at least be documented?

And this is *not* necessary for kvm_rmap_unlock_readonly(), IIUC.

> +       WRITE_ONCE(rmap_head->val, new_val);
> +}

