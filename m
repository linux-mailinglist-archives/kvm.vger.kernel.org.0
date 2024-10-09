Return-Path: <kvm+bounces-28293-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 02755997339
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 19:36:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ACDE61F243FF
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 17:36:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 263EF1E1A17;
	Wed,  9 Oct 2024 17:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QlQibIal"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 883541E04B5
	for <kvm@vger.kernel.org>; Wed,  9 Oct 2024 17:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728495355; cv=none; b=Sg1F8lOtY9DT9nfqwomCrQW7fTpdChYmDbzFIj3MD22gZ36dS9y/lwnlliZ/gWTr65ecog6iY2j8G3QiKA9goj7tueC3OFznf2e9EZEpOvM2PVZNdhZIgaknykmjgitjCtkrfsw/sy3LDB4VHjUezY5cvBfWv1uDcpe5dZ6tZAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728495355; c=relaxed/simple;
	bh=0VVDZ0vML/cwnzRWvR7tAuXOd6Ux6Be9EEp/cVAggvE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oSA5K+SvyuScQOYsrg6J7hSTCbRyMytRk4WkC8PFSdAzw3xg9QesudlwRIT+MrdT0uD1SO+YMv8i6gKMrYbqDpRGamV4oZ4oXGwxauE3caKjEoxGykd8+qMx/T5EREFyDvBJp1Jk8NGpKoh+Y7g5EnCbGM2kSQHnFG3JZFq9Js8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QlQibIal; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e24b43799e9so6844691276.2
        for <kvm@vger.kernel.org>; Wed, 09 Oct 2024 10:35:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728495352; x=1729100152; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aqOjgvevcAv3hX3hikB02/exSt2JY/69iUtM/kwES2g=;
        b=QlQibIalnaO7/HFSVIwF+IeYGT9abzATSR2iwX/XQEmxx1lVvFYS7LXZzHAsZ/fqDj
         7Un6+NRhTml1+xXIYE4x21vhA0z28IfHDDEGxcMNKAUxTqBfgoNNFXYa92p2Q3tsXHAU
         kv8UYwktl1J+BdL/zhcL5z0rAsHbt/9q9Kmkwod8bUZ1iMeWCGkNcKiEz/JirPGEv5nZ
         jl1xH2fH44Qhciqjo7iOU3IdxUrwe5kJCuKd1ChaGn60EG85Q6WTnkPwl9H77qSMmTVS
         rrCWd7wgxre6QzzyOUPKivFUN40q92mtwJWqzcD6ImUrKWYH6ePu9aosdzgMpNvn9Ir0
         V6rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728495352; x=1729100152;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=aqOjgvevcAv3hX3hikB02/exSt2JY/69iUtM/kwES2g=;
        b=vCEvmuWFXEGU2sOkQsFj12xtsV5+/7dlcM7NCoYcuXQqYRJOApEf0pSDfVfM8ZIKxZ
         on0UYT9a8qO+cu1WPxKoeTweYmn735OGThjo+utlCwYZmgbOOYoL5eOjadRZxsVeRfhA
         WXRUVva+VInHP5rT5OzV43LC9eb9S+Gfkg3RJWcbNDZdNp6S41Kzyihmd037Tp6eXX/a
         NhNSjYBXfWLbPb1hNxuq88iqZQVICfMgUy6ogNC3XiUIwJSCKvPfMDhICdnO7SSPaIW3
         FQX4aLANscOiH9Q63ABxdoEBnSTBs+ddqnE+Se2R2/l5KCXzJV0Q+AeXS2gAVkw8481K
         M/vA==
X-Forwarded-Encrypted: i=1; AJvYcCXpv+yDqafAVRzzYjFIkPhRfkgUCXmpa/PbTSQVxPMl97+30hRJ3ZcN9z2HNSqjKndsCoc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwHqmQNyNP7sICkGWJN7mrsDrglJtib8NPTNkE7WyGWdInuBtTP
	aMxj+ZFMIEHoOvYt87BS4GfF7VqQd0VAWQJz8dgpcsyML7rHb0UCeilPmQkH/t3V6AnMz0uXQ8q
	4DA==
X-Google-Smtp-Source: AGHT+IHRdw0FQpkXhN6WjBpz+Eg87K5XZP7cO3KdguEdcDeYyo+EeMVNvxIYcnQs8exp25Ewm/bc8LBmt0A=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a25:8681:0:b0:e25:6656:c144 with SMTP id
 3f1490d57ef6-e28fe41ee21mr24076276.9.1728495352442; Wed, 09 Oct 2024 10:35:52
 -0700 (PDT)
Date: Wed, 9 Oct 2024 10:35:50 -0700
In-Reply-To: <CAHVum0ffQFnu2-uGYCsxQJt4HxmC+dTKP=StzRJgHxajJ7tYoA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240823235648.3236880-1-dmatlack@google.com> <20240823235648.3236880-5-dmatlack@google.com>
 <CAHVum0ffQFnu2-uGYCsxQJt4HxmC+dTKP=StzRJgHxajJ7tYoA@mail.gmail.com>
Message-ID: <Zwa-9mItmmiKeVsd@google.com>
Subject: Re: [PATCH v2 4/6] KVM: x86/mmu: Recover TDP MMU huge page mappings
 in-place instead of zapping
From: Sean Christopherson <seanjc@google.com>
To: Vipin Sharma <vipinsh@google.com>
Cc: David Matlack <dmatlack@google.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 09, 2024, Vipin Sharma wrote:
> On Fri, Aug 23, 2024 at 4:57=E2=80=AFPM David Matlack <dmatlack@google.co=
m> wrote:
> > +static u64 modify_spte_protections(u64 spte, u64 set, u64 clear)
> >  {
> >         bool is_access_track =3D is_access_track_spte(spte);
> >
> >         if (is_access_track)
> >                 spte =3D restore_acc_track_spte(spte);
> >
> > -       spte &=3D ~shadow_nx_mask;
> > -       spte |=3D shadow_x_mask;
> > +       spte =3D (spte | set) & ~clear;
>=20
> We should add a check here WARN_ON_ONCE(set & clear) because if both
> have a common bit set to 1 then the result  will be different between:
> 1. spte =3D (spt | set) & ~clear
> 2. spte =3D (spt | ~clear) & set
>=20
> In the current form, 'clear' has more authority in the final value of spt=
e.

KVM_MMU_WARN_ON(), overlapping @set and @clear is definitely something that=
 should
be caught during development, i.e. we don't need to carry the WARN_ON_ONCE(=
) in
production kernels

> > +u64 make_huge_spte(struct kvm *kvm, u64 small_spte, int level)
> > +{
> > +       u64 huge_spte;
> > +
> > +       if (KVM_BUG_ON(!is_shadow_present_pte(small_spte), kvm))
> > +               return SHADOW_NONPRESENT_VALUE;
> > +
> > +       if (KVM_BUG_ON(level =3D=3D PG_LEVEL_4K, kvm))
> > +               return SHADOW_NONPRESENT_VALUE;
> > +
>=20
> KVM_BUG_ON() is very aggressive. We should replace it with WARN_ON_ONCE()

I'm tempted to say KVM_MMU_WARN_ON() here too.

