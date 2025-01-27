Return-Path: <kvm+bounces-36687-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 92FCAA1DD2F
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 21:10:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B55F67A2448
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 20:10:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0DD2194094;
	Mon, 27 Jan 2025 20:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OHOh3AXS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f177.google.com (mail-yb1-f177.google.com [209.85.219.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 620BE53BE
	for <kvm@vger.kernel.org>; Mon, 27 Jan 2025 20:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738008619; cv=none; b=ZgtrstL+BiYf5NDUdciZLX2cjHEQzpJ2UskctnEmXFS2D6rfNSUdgOiDGYspNHTd5y7m0BEgIRkcYyYyVEYXfR40jqUE7YMnCCXn6sLjVdj2yU2D3y6BV1KxVz3zZvMgudFNfHITSFRHkwqt2lxjWlK2slXoylyeNlbMXG40OrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738008619; c=relaxed/simple;
	bh=0JhjcjSVuDZh8wOvaDN+eNJKm6g9ln8YNQDPL8fR1gg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ik7l4q2DTxFQ6pasmUn2c7y2MTAHujRkXoYTRzNXuTip3qnIOdgUoLDw/J/5qqIz7zXTC72KFjIuKd1wcOdTHBT7Bgt+BV6/cuJxTHOy1HrX13JDE2IpiRTD7QRz8Y7PBtz2d/BfFDzxVKn914Za98Fx0/CzHxan63R59Lnk9SA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OHOh3AXS; arc=none smtp.client-ip=209.85.219.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-yb1-f177.google.com with SMTP id 3f1490d57ef6-e549be93d5eso8597251276.1
        for <kvm@vger.kernel.org>; Mon, 27 Jan 2025 12:10:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738008615; x=1738613415; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FQL/8VGPxK03POi0rzd8uZuM6uS0DM31SJcxx6N7d7I=;
        b=OHOh3AXSSGizUzE4vKqTi4PCugunPavr9/fSOj67fOWVQVdQwF9fe4EsCJKlFmPUjx
         YjOsE8ygfb6guQVfiYgJ8pzl9zMvznuSYnxYnY1i2bFJ2wYlxIK9nZXM5kCE4pq0ePr6
         S70cOadwEcl9gX+D3hYfdMFEGD6jpYLcjmtDlnOik2FgfhOXkoEkXLkoD8mhXIppgCIP
         JWMamOOaBArtL+tp7RdrAv84x3e1d8+hxUCbSXuZP6UoALhc/BhEwOXdSo0tvvd4IOzV
         rG9I5QhZPCgkXwruQOmfEtiQdZPBzorxms/fodY6epXjz2vqx/4a1Xd6CkCy2BOmKDSo
         +YeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738008615; x=1738613415;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FQL/8VGPxK03POi0rzd8uZuM6uS0DM31SJcxx6N7d7I=;
        b=GTkfHFXmUvcJr1zWol+/GBXSAesO9d+MOrEJ987nlhzCLnzgQoatfl1XsIvdkjcWDG
         KFSasylEzIUX43SV1j751GHDS7/Ec1/OUcRDIEtDKMGdxlxH6crS1bJoc+iXKS5igW7l
         +oG1IQZLSSm0ZQJpH2YaveV2QT92JF8GTy1QqoBYT8uDoJV2gVWMnz9fmWmoDu563wPX
         ESvLP2+Ynn0tNuXCdJOzIEubxRvXzXu95BEHHNbYS5Ih/E5BS2/XN59XHAkTj4fFIpfo
         XvVguRPZObHJTqipr5gNMWujaNvtUmm6wzRW+G6c0O8F3vSi/I4kgMgk9nXdYB8ptHnc
         TliQ==
X-Forwarded-Encrypted: i=1; AJvYcCUQIhHxVR6tJdAzDmewC3Q9cGwu3peMtYHanpHuu2txe/QACbqKYLVB5uVIP3REtPRhDkU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx/zjOiS7Gm/29P8QQdurEdKzWvzfIoX4cAev9UHp9BKQ9x/DFu
	vlyfe9OB7dsgcFhqiDa8SuPj0+8zCHt1XvNithoBDl423Q7QHOgCX/zv4mWn86ygHA/c4lyAV9I
	3JD4zXlcO8Z57xEPIHKiEMb0UnJEU5bwNtPlC
X-Gm-Gg: ASbGnct7uJiyG4Hf6QCe5IMmqGwv1GnVTD7LfIxvyf/lkC54mXIhN19GrCL4bjNYsfz
	0oukH+QcA+xq+GMFVnpunO0yCCdYZPxWKoJuATBN8Nav8D7zqMWTpQN26L+6s5xBjG8BgK/CaUo
	EdVXGadR7UC69r3nXb
X-Google-Smtp-Source: AGHT+IG9Rtan5pGsbvWg5eROL+ftdpc6tEAKecfIx9+kzlMVu7SYAAtjptsH5P4pKu2bjv4UpbMEBJLxzVH28/5Cs9c=
X-Received: by 2002:a05:690c:3485:b0:6f4:3b8f:8e3f with SMTP id
 00721157ae682-6f6eb9326c9mr218432127b3.38.1738008615168; Mon, 27 Jan 2025
 12:10:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241105184333.2305744-1-jthoughton@google.com>
 <20241105184333.2305744-5-jthoughton@google.com> <CADrL8HV3nNaKXkhX5zC2hN5+44AOZtoCvL83_x8kbkTVB3rHhg@mail.gmail.com>
In-Reply-To: <CADrL8HV3nNaKXkhX5zC2hN5+44AOZtoCvL83_x8kbkTVB3rHhg@mail.gmail.com>
From: James Houghton <jthoughton@google.com>
Date: Mon, 27 Jan 2025 12:09:39 -0800
X-Gm-Features: AWEUYZmWmv37hzOlfxXa8iLgozyxpT9aKBXKTaU_SEQ_b0A_AbwGYBDrF0KXEVQ
Message-ID: <CADrL8HVczq2+3V6sQrNmGpFz_3-BsO5PZUm29Kg9LpvpoWnACw@mail.gmail.com>
Subject: Re: [PATCH v8 04/11] KVM: x86/mmu: Relax locking for kvm_test_age_gfn
 and kvm_age_gfn
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, Wei Xu <weixugc@google.com>, 
	Yu Zhao <yuzhao@google.com>, Axel Rasmussen <axelrasmussen@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Venkatesh Srinivas <venkateshs@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 27, 2025 at 11:57=E2=80=AFAM James Houghton <jthoughton@google.=
com> wrote:
>
> On Tue, Nov 5, 2024 at 10:43=E2=80=AFAM James Houghton <jthoughton@google=
.com> wrote:
> >
> >  static inline u64 kvm_tdp_mmu_write_spte(tdp_ptep_t sptep, u64 old_spt=
e,
> > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > index 4508d868f1cd..f5b4f1060fff 100644
> > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > @@ -178,6 +178,15 @@ static struct kvm_mmu_page *tdp_mmu_next_root(stru=
ct kvm *kvm,
> >                      ((_only_valid) && (_root)->role.invalid))) {      =
         \
> >                 } else
> >
> > +/*
> > + * Iterate over all TDP MMU roots in an RCU read-side critical section=
.
> > + */
> > +#define for_each_valid_tdp_mmu_root_rcu(_kvm, _root, _as_id)          =
         \
> > +       list_for_each_entry_rcu(_root, &_kvm->arch.tdp_mmu_roots, link)=
         \
> > +               if ((_as_id >=3D 0 && kvm_mmu_page_as_id(_root) !=3D _a=
s_id) ||     \
> > +                   (_root)->role.invalid) {                           =
         \
> > +               } else
> > +
>
> Venkatesh noticed that this function is unused in this patch. This was
> a mistake in the latest rebase. The diff should have been applied:
>
> @@ -1192,15 +1206,15 @@ static bool __kvm_tdp_mmu_age_gfn_range(struct kv=
m *kvm,
>         struct tdp_iter iter;
>         bool ret =3D false;
>
> +       guard(rcu)();
> +
>         /*
>          * Don't support rescheduling, none of the MMU notifiers that fun=
nel
>          * into this helper allow blocking; it'd be dead, wasteful code. =
 Note,
>          * this helper must NOT be used to unmap GFNs, as it processes on=
ly
>          * valid roots!
>          */
> -       for_each_valid_tdp_mmu_root(kvm, root, range->slot->as_id) {
> -               guard(rcu)();
> -
> +       for_each_valid_tdp_mmu_root_rcu(kvm, root, range->slot->as_id) {
>                 tdp_root_for_each_leaf_pte(iter, root, range->start,
> range->end) {
>                         if (!is_accessed_spte(iter.old_spte))
>                                 continue;
>
> This bug will show up as a LOCKDEP warning on CONFIG_PROVE_RCU_LIST=3Dy
> kernels, as list_for_each_entry_rcu() is called outside of an RCU
> read-side critical section.

There I go lying again. The LOCKDEP warning that will show up is the
lockdep_assert_held_write(mmu_lock) in
kvm_lockdep_assert_mmu_lock_held().

The RCU lockdep WARN would hit if I had used
for_each_valid_tdp_mmu_root_rcu() without moving the RCU lock
acquisition.

