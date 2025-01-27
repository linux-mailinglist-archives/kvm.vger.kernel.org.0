Return-Path: <kvm+bounces-36685-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FD64A1DD0B
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 20:59:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 12AED1883FC3
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 19:59:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF65E1917D6;
	Mon, 27 Jan 2025 19:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OGVHUbfx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f177.google.com (mail-yb1-f177.google.com [209.85.219.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74C36196C7C
	for <kvm@vger.kernel.org>; Mon, 27 Jan 2025 19:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738007947; cv=none; b=s2RbQUVFn4Myq6K3bcksW34SxF7scQ7cUdv6V+Vj5rFYDBu22LFHaqCyXQlOmYGYPyjOA7orEZF0evBrqIvDcLe7fHZutuuzTo6PZI2DWbFmEXbiySnGsFrXanXhHJnoxf1VXD/1S/MpPmWHV8iSFmzM1kmNRZxQ5BDfF3ouk6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738007947; c=relaxed/simple;
	bh=Agp2XVYe4jTgYWFWMVE1J+h+qcWZcyiGJ5hW695JHas=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZDpiLlVgA4YlN+9xfueEDT/Skb47QzceO2e5HjQErYZxR3QQHqAh9YgemzXjF+7c0pbHJMxbGFxcFfB3dhlxVaedT2xCGcQtcVX/HzU/T1vRqi7bSMrn/Lnmgno52v3dVAtG35FUnqPCam65weyoBZuxJO3e86Y5qWfkzPAHGJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OGVHUbfx; arc=none smtp.client-ip=209.85.219.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-yb1-f177.google.com with SMTP id 3f1490d57ef6-e5372a2fbddso7351398276.3
        for <kvm@vger.kernel.org>; Mon, 27 Jan 2025 11:59:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738007944; x=1738612744; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uAJ7s58mmvTD0xN1fTZ35Ahl0x7+BAfjqXSASdmf/8o=;
        b=OGVHUbfxZPFXg/0+gMAmskjJpGj3aHGgzMQAJyiBfXSY8HT6tPQxfU982B59zQ2i0I
         feDUrORzVdcEThFv6jSfVFyzx3u1v52tWJ8Sgy5kf6P8iSIEGYHWU1IHmEisr+nEFfXU
         OoT9B/CP8qQIghYjQ8+HDeLvnQOU9quVMnwyouxSfWuG6qx6xA6MVLTzS+X8jm1lkDKc
         gSdvcAKyUIuoFLr+D1VKaKbCh96+kz+BynxyKMi5KG3lKB5bmVy1mKMfgpGAi/JPdy1k
         1vUGpxpbWmQg740ZwSrqEWRgAI6jYM+7RV4rudYGBQg58H0bovfLWjZz8w81RqVtwM5v
         ry2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738007944; x=1738612744;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uAJ7s58mmvTD0xN1fTZ35Ahl0x7+BAfjqXSASdmf/8o=;
        b=n03Z0SU//MISIyl7adgvKango87Ps21wD9MGfvhdSF/mLKqeUtQ/l62ctewiqSOk5o
         dyc72Jk2cC0VVB5BzGGDHPTV1tQ/0CfpbI0WEUQuC16uA1sbTJHuNmZNXU2Q0ud7aMfl
         MRHXjFUGxe7mi2viHtE4JeBE7w0Y6WiiJfxoiL9GKvCUvBWlVxnrolk+rDCTC+vW8xkf
         ln6O62RP9BCHL7J97Bub2zQC8vllSb5fjNGKjYykYJRf88dBsvCL6Qip22PROBVxjMSQ
         o7tgo9PqhO8LSa7CjbIhtycgk3AiP+FmvJFOd0LO8rAMG8fVvIwuwGFZz5UcQQHDW8gr
         m34A==
X-Forwarded-Encrypted: i=1; AJvYcCXgcAKjSBf8ftlcs3t6L5KrFF5y+OifbIwi2kUbhbLtIYjIPEb3pb3xXjAFqbE5cEVHjWQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yygwd3Lcy501TmiMsQIFCkhDP904jiG8vISM43hgMsb53VWG8HJ
	ODob6t/hc6vLX+xRAeYpAgvCDhfekBNxk8VKk91oiq5lN2LtcGDuhLwa9QNQAsA2vvEmbFg9yHj
	mPVw7Fz6l364c/+CYobFybPRRm3bXcBbnrnZe
X-Gm-Gg: ASbGncs8rugt06Tgvhx68hz/gnI0PDN7w4RVR8ySGKHvRf7NEgqyU7rJaUsEfFYkL7l
	36XrXY/P6jaIQmigVs7+qrhgVv2k8D112UCjg7sNZwmNfRP3PFwQlAUZTPB8OZ+G3YVVihXYjK2
	uL21o1ye6V/GGBaA4l
X-Google-Smtp-Source: AGHT+IEts+xJYGYilzQw1c40jRiyqeB+bq/RDGW2koB4PuZForMFVxCpr6mNIif+Ed5mF0HbRvefxkGoXcclVkDvdgc=
X-Received: by 2002:a05:690c:6982:b0:6ef:c24e:5f8 with SMTP id
 00721157ae682-6f6eb68b2b4mr340242467b3.19.1738007944219; Mon, 27 Jan 2025
 11:59:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241105184333.2305744-1-jthoughton@google.com>
 <20241105184333.2305744-7-jthoughton@google.com> <Z4GnvHqZqxW7sRjs@google.com>
In-Reply-To: <Z4GnvHqZqxW7sRjs@google.com>
From: James Houghton <jthoughton@google.com>
Date: Mon, 27 Jan 2025 11:58:27 -0800
X-Gm-Features: AWEUYZk-ZF4qWC18D3gXB9o4acaMFY6fiJ_zEvkzq90WUaX8q5FabImHJlby83E
Message-ID: <CADrL8HVtogbCnS=K8-Jm22rkTfNKh4uFieXCbuknfpYJWg=pfQ@mail.gmail.com>
Subject: Re: [PATCH v8 06/11] KVM: x86/mmu: Only check gfn age in shadow MMU
 if indirect_shadow_pages > 0
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, David Matlack <dmatlack@google.com>, 
	David Rientjes <rientjes@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Wei Xu <weixugc@google.com>, Yu Zhao <yuzhao@google.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 10, 2025 at 3:05=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Tue, Nov 05, 2024, James Houghton wrote:
> > Optimize both kvm_age_gfn and kvm_test_age_gfn's interaction with the
> > shadow MMU by, rather than checking if our memslot has rmaps, check if
>
> No "our" (pronouns bad).
>
> > there are any indirect_shadow_pages at all.
>
> Again, use wording that is more conversational.  I also think it's worthw=
hile to
> call out when this optimization is helpful.  E.g.
>
> When aging SPTEs and the TDP MMU is enabled, process the shadow MMU if an=
d
> only if the VM has at least one shadow page, as opposed to checking if th=
e
> VM has rmaps.  Checking for rmaps will effectively yield a false positive
> if the VM ran nested TDP VMs in the past, but is not currently doing so.

Applied verbatim. Thanks.

> > Signed-off-by: James Houghton <jthoughton@google.com>
> > ---
> >  arch/x86/kvm/mmu/mmu.c | 9 +++++++--
> >  1 file changed, 7 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 793565a3a573..125d4c3ccceb 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -1582,6 +1582,11 @@ static bool kvm_rmap_age_gfn_range(struct kvm *k=
vm,
> >       return young;
> >  }
> >
> > +static bool kvm_has_shadow_mmu_sptes(struct kvm *kvm)
>
> I think this should be kvm_may_have_shadow_mmu_sptes(), or something alon=
g those
> lines that makes it clear the check is imprecise.  E.g. to avoid someone =
thinking
> that KVM is guaranteed to have shadow MMU SPTEs if it returns true.

Sounds good to me. Renamed.

