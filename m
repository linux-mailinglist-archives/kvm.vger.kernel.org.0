Return-Path: <kvm+bounces-25789-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 63EC896A889
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 22:39:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 88B1A1C215EE
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 20:39:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2155A1DB92B;
	Tue,  3 Sep 2024 20:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qART0V1b"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f182.google.com (mail-yb1-f182.google.com [209.85.219.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CCAA1D9D63
	for <kvm@vger.kernel.org>; Tue,  3 Sep 2024 20:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725395838; cv=none; b=gUvDlRojDayi70PthY5cNu08klEvX8E5z3uZlyehDlKQdX/rbvlMZIua3UhZofMaguzbEXVQU2nREPU7umpLHHWzhT1p49tB+/cyR1HmGLfbF5gyoGHIz08dyxknYlH+BUVwn2s38hTod/QG5TCoCNJJEtuLmZHLZCY5iB7PXAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725395838; c=relaxed/simple;
	bh=54d38Gq9zzcYweSeXshL3fbZLH12rhU8y5SG/E5ISmo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=a51HiHt1A8msMCv74bbSa8LPe8xh4crkC+yxTEkwqJpaqX3eFNMN+RIGvPzVLUBdMdiuJriCugGb1KSKkSeXdSKjp8lqmMMxroqqYkZbTQYrsSgbWDO+kqUWbeYTbnDed1NCFR8bwbMoFkwiNya3TDfHNlI/fLjhigH+M6Dfp9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qART0V1b; arc=none smtp.client-ip=209.85.219.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-yb1-f182.google.com with SMTP id 3f1490d57ef6-dff1ccdc17bso124380276.0
        for <kvm@vger.kernel.org>; Tue, 03 Sep 2024 13:37:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725395835; x=1726000635; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=db5Z2XZPdBaOWfpKK8JWR/fZ4O4O0Xk528CvHx6CpX0=;
        b=qART0V1beU/s7hrFU6TrApEYxK7a/ZdelCY8dwbHy31zk/aC4eodrdnGwATN0kNlr1
         ATDgqgHs528LPv5aL5OS04eCCamMYTB8VIrpi9CpOx4ezPHKMCzWWcxUGV2nCm8YQnhG
         Duy5K0sKD+NHdzNeJdE6MCKj4Xr7MqpzuQfEBNOPus4KSfdSmFiC5cWAv+4Hf45+aU5g
         HEvouiWQuzGNdKHIMtbYpSAyIl8mFNxr5mjmQrYZv/h2IyKhQ+4ldRdN9CGJoWt2mMux
         Fb3SRiQGi3br5x2wby0H7GWYXskmvFMThQJScU9uHS8yHSRX704f4AmWwlyt3CtVpJLw
         pmbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725395835; x=1726000635;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=db5Z2XZPdBaOWfpKK8JWR/fZ4O4O0Xk528CvHx6CpX0=;
        b=CMMWyPjXZhlTFRQ88nTLFcs9MXONrQgPRTcm3N08gGoAs5KOokhbxvbFxcSvMSQkqX
         INSDOAPvf/Oo2eHzGN9dsgU3wM0PHZNvp1/tzDugQ4uPkQk7jb/4OyYHgOUCW2xJkwhy
         /zkNaLaPjdtY/3VNBrK/QVmSbhaekMNKBgsXUctGckFCr9DvG083cyHX6kqBu6Ra+kBu
         QFGPsoCFbPURfR/SaLLqYfnYkyjLLUtbXJ5z2uWugL7V1vbe+BPTHVwa8IxhEZ49ooSU
         zU2V9nZjnF6EwxtUoPmQVJG9z3k6q/5bRw3S5VL8jLFEGYBFZzDop8GRemheo6eKgZLo
         uOqw==
X-Forwarded-Encrypted: i=1; AJvYcCU09b5eQWiHyyNuafx2JjA5QkUL/5pDZ19MopiYKRHcQ8L2Sp0oZgSlTogGR04XEECSrQQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw9DOaMsE5kFQ6/58qq0JJTml7ZayxvT8KRj1NUizxF+l32KHtx
	rRjtHUMmgsd/y6nUhtGLEvnXSV1g2fArQv7mpXJgpANc/P6SapgKSnqXj4cB/SBmHFNrA546yE3
	mPzcIPOjeVJB/tlIhFzEYUO8Vurt2HWcnuFpu
X-Google-Smtp-Source: AGHT+IHDkWaXEsBsTA5Am17C6H1uqtSUl2bsG9A74dW+9rrsH9dO4I47TR+uCpRlEzrin+9ZreZDu8hqYulSxXs3suY=
X-Received: by 2002:a05:6902:e09:b0:e16:4a59:c3a7 with SMTP id
 3f1490d57ef6-e1d0e795849mr196531276.32.1725395835486; Tue, 03 Sep 2024
 13:37:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240809194335.1726916-1-seanjc@google.com> <20240809194335.1726916-22-seanjc@google.com>
In-Reply-To: <20240809194335.1726916-22-seanjc@google.com>
From: James Houghton <jthoughton@google.com>
Date: Tue, 3 Sep 2024 13:36:39 -0700
Message-ID: <CADrL8HWizVVmTvbxpFbVN9M7YhRpJYpVnhK_O7XKYMdy1=DBHw@mail.gmail.com>
Subject: Re: [PATCH 21/22] KVM: x86/mmu: Support rmap walks without holding
 mmu_lock when aging gfns
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, Peter Xu <peterx@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 9, 2024 at 12:44=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> DO NOT MERGE, yet...
>
> Cc: James Houghton <jthoughton@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 63 +++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 59 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 48e8608c2738..9df6b465de06 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -995,13 +995,11 @@ static void kvm_rmap_unlock(struct kvm_rmap_head *r=
map_head,
>   * locking is the same, but the caller is disallowed from modifying the =
rmap,
>   * and so the unlock flow is a nop if the rmap is/was empty.
>   */
> -__maybe_unused
>  static unsigned long kvm_rmap_lock_readonly(struct kvm_rmap_head *rmap_h=
ead)
>  {
>         return __kvm_rmap_lock(rmap_head);
>  }
>
> -__maybe_unused
>  static void kvm_rmap_unlock_readonly(struct kvm_rmap_head *rmap_head,
>                                      unsigned long old_val)
>  {
> @@ -1743,8 +1741,53 @@ static void rmap_add(struct kvm_vcpu *vcpu, const =
struct kvm_memory_slot *slot,
>         __rmap_add(vcpu->kvm, cache, slot, spte, gfn, access);
>  }
>
> -static bool kvm_rmap_age_gfn_range(struct kvm *kvm,
> -                                  struct kvm_gfn_range *range, bool test=
_only)
> +static bool kvm_rmap_age_gfn_range_lockless(struct kvm *kvm,
> +                                           struct kvm_gfn_range *range,
> +                                           bool test_only)
> +{
> +       struct kvm_rmap_head *rmap_head;
> +       struct rmap_iterator iter;
> +       unsigned long rmap_val;
> +       bool young =3D false;
> +       u64 *sptep;
> +       gfn_t gfn;
> +       int level;
> +       u64 spte;
> +
> +       for (level =3D PG_LEVEL_4K; level <=3D KVM_MAX_HUGEPAGE_LEVEL; le=
vel++) {
> +               for (gfn =3D range->start; gfn < range->end;
> +                    gfn +=3D KVM_PAGES_PER_HPAGE(level)) {
> +                       rmap_head =3D gfn_to_rmap(gfn, level, range->slot=
);
> +                       rmap_val =3D kvm_rmap_lock_readonly(rmap_head);
> +
> +                       for_each_rmap_spte_lockless(rmap_head, &iter, spt=
ep, spte) {
> +                               if (!is_accessed_spte(spte))
> +                                       continue;
> +
> +                               if (test_only) {
> +                                       kvm_rmap_unlock_readonly(rmap_hea=
d, rmap_val);
> +                                       return true;
> +                               }
> +
> +                               /*
> +                                * Marking SPTEs for access tracking outs=
ide of
> +                                * mmu_lock is unsupported.  Report the p=
age as
> +                                * young, but otherwise leave it as-is.

Just for my own understanding, what's the main reason why it's unsafe
to mark PTEs for access tracking outside the mmu_lock?

> +                                */
> +                               if (spte_ad_enabled(spte))
> +                                       clear_bit((ffs(shadow_accessed_ma=
sk) - 1),
> +                                                 (unsigned long *)sptep)=
;

I feel like it'd be kinda nice to de-duplicate this clear_bit() piece
with the one in kvm_rmap_age_gfn_range().

> +                               young =3D true;
> +                       }
> +
> +                       kvm_rmap_unlock_readonly(rmap_head, rmap_val);
> +               }
> +       }
> +       return young;
> +}
> +
> +static bool __kvm_rmap_age_gfn_range(struct kvm *kvm,
> +                                    struct kvm_gfn_range *range, bool te=
st_only)
>  {
>         struct slot_rmap_walk_iterator iterator;
>         struct rmap_iterator iter;
> @@ -1783,6 +1826,18 @@ static bool kvm_rmap_age_gfn_range(struct kvm *kvm=
,
>         return young;
>  }
>
> +
> +static bool kvm_rmap_age_gfn_range(struct kvm *kvm,
> +                                  struct kvm_gfn_range *range, bool test=
_only)
> +{
> +       /* FIXME: This also needs to be guarded with something like range=
->fast_only. */
> +       if (kvm_ad_enabled())

I expect this to be something like `if (kvm_ad_enabled() ||
range->fast_only)`. With MGLRU, that means the pages will always be
the last candidates for eviction, though it is still possible for them
to be evicted (though I think this would basically never happen). I
think this is fine.

I think the only other possible choice is to record/return 'not
young'/false instead of 'young'/true if the spte is young but
!spte_ad_enabled(). That doesn't seem to be obviously better, though
we *will* get correct age information at eviction time, when
!range->fast_only, at which point the page will not be evicted, and
Accessed will be cleared.


> +               return kvm_rmap_age_gfn_range_lockless(kvm, range, test_o=
nly);
> +
> +       lockdep_assert_held_write(&kvm->mmu_lock);
> +       return __kvm_rmap_age_gfn_range(kvm, range, test_only);
> +}
> +
>  bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
>  {
>         bool young =3D false;
> --
> 2.46.0.76.ge559c4bf1a-goog
>

