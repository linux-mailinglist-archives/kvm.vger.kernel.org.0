Return-Path: <kvm+bounces-30601-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E7429BC400
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 04:44:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 72C0D1C21077
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 03:44:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5FDC188714;
	Tue,  5 Nov 2024 03:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GHucp5W1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EC0524B29
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 03:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730778236; cv=none; b=UMUWULC4pGAezsTVKrpkqLYNi7QcZg6TuSYbaXaokIFMipZNXkuzQ3aL9QKRuSf1LGUA9S24r4sUzqHfL7S3pw4nxywjHQmTl8dDReZas149nUCzwMtTgVfeY6zFs5K7LoW76yDrBdF5TRHCtvIhZW2DWTnetx4eIDLUxh1j2gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730778236; c=relaxed/simple;
	bh=Q4bP60HMOUubd5FtS15MOfgaJ0cgmiqcBFbJE+oWJdQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VTef0qQsP2/VLO3u7YSP037IOHjU5hn9YcvQbTo0F8jzV1x9AiCp5CNqSod9Pq3aKcLtO6EGH8FyJAnXCxkLcjFIizmn7eBCBfglhpFB4G7zGstsDCOVw/N9B3vnHVUSjxspA/MveT1kiGGrzOSz5mttkMXL6iTTmcH0qGQ7slg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GHucp5W1; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-7edd6662154so4445633a12.0
        for <kvm@vger.kernel.org>; Mon, 04 Nov 2024 19:43:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730778234; x=1731383034; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UnVKs0osASzkouG8eBoK3DKaxhriO4YY5mBFJ/kJW1o=;
        b=GHucp5W1jqYzeVYLhGnnOOhlGaqo9QNVApTidkbwIk0KeNKIKURJWvfSk/4TqH++KT
         mUFCHQn9vbjBmowuPfSTV+60izcXarM5JTvN+Ga4mKm0zZG7pXxDdONbZjo+sHq7Xm4g
         w7d9IMC9t99LzU2MbzaEJhswV0PBYEU/c0iq/hjbf1oyCq+ghbil7GrC/WPBhdELt6FG
         1Bs3hoS3lN8HTPN0Di2ZvqVx3n5iy/T+4erWpiTQUJSaBNk/2dYLYZPteygTl6Z42x66
         m13dbouTD1RpQlj2lL9ezucS+kg0QGsSTxMCkbwLdV1zffG/EXkkKxPLJb35rwPTNqqw
         5Z+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730778234; x=1731383034;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=UnVKs0osASzkouG8eBoK3DKaxhriO4YY5mBFJ/kJW1o=;
        b=l/X7J2xyEzFPsi6v/kDlAaU5v72pboNZ0DfKhxIJBNR7db1b7pBrW0hAy8Io652ZiN
         Ts/eHgVfmNbvtyI9vddENL4D5pyapd6rn1rGW4MCGeqRnFDh5f6csmdnO7lZOfq0y5EO
         ZH6PXVgYrjUq3NQ4CNuljWW0XlnsiOUidhDH5MOG7HOCv+udscjPVCyEGhHxrLR+zlwO
         GdWXqgRIOfkT4h0V4oceP+B7oYrS3hs/qh5/x0NacBRUXOnNDpgg7zh+V7MXpSZ6eqEY
         MHCDGZC84pJZXQRRbfLc/Fdil7rWwrn+rr52ZHrDrbN2rGW0b+yTP6Evs5jf1/3ojuoZ
         FP5g==
X-Forwarded-Encrypted: i=1; AJvYcCUDx0+Hd5+EBW0wHEVn8Ulhy7y/bmLdJsZxLVLE8R+FqFQP3rSnmUIpUgtgG+p0CqCln4M=@vger.kernel.org
X-Gm-Message-State: AOJu0YxZ3rfZdmtDNRddK9URE5/0mfF4HL65PUS0iIgg78eivy+X0F8n
	AB2gR504oiuISChoKfK49QwBotKzcX4nA9C9OdAKvvrl1nnddhk5hz7J+bqmK4yUlxVVTRwWJdA
	gqg==
X-Google-Smtp-Source: AGHT+IFocQz+imkZhpKg1tLjXX2+FNWMIhufYbEV0uhMIV+xRwIm53f+H8VvwfazbMYkrRO4gX3yEhs3IVs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a63:1c46:0:b0:7ea:94aa:c649 with SMTP id
 41be03b00d2f7-7ee4107aa76mr52462a12.2.1730778233522; Mon, 04 Nov 2024
 19:43:53 -0800 (PST)
Date: Mon, 4 Nov 2024 19:43:52 -0800
In-Reply-To: <CAHVum0eZ1z4NfmQEmr2T34LFY9EEhM0rdkEEx_yxF-zijhmLYA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241101201437.1604321-1-vipinsh@google.com> <20241101201437.1604321-2-vipinsh@google.com>
 <CAHVum0eZ1z4NfmQEmr2T34LFY9EEhM0rdkEEx_yxF-zijhmLYA@mail.gmail.com>
Message-ID: <ZymUeC3WiIRH_Jqs@google.com>
Subject: Re: [PATCH v3 1/1] KVM: x86/mmu: Remove KVM mmu shrinker
From: Sean Christopherson <seanjc@google.com>
To: Vipin Sharma <vipinsh@google.com>
Cc: pbonzini@redhat.com, dmatlack@google.com, zhi.wang.linux@gmail.com, 
	weijiang.yang@intel.com, mizhang@google.com, liangchen.linux@gmail.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 01, 2024, Vipin Sharma wrote:
> On Fri, Nov 1, 2024 at 1:14=E2=80=AFPM Vipin Sharma <vipinsh@google.com> =
wrote:
> >
> > Remove KVM MMU shrinker and all its related code. Remove global
> > kvm_total_used_mmu_pages and page zapping flow from MMU shrinker.

Don't provide a play-by-play of the code changes.  Simply stating "all its
related code" is sufficient.  From that, readers know the *intent* of the p=
atch,
and that allows reviewers to double check that all code is indeed removed.
Stating what the patch literally does verbatim adds a lot of noise and very=
 little
value.

> > Remove zapped_obsolete_pages list from struct kvm_arch{} and use local
> > list in kvm_zap_obsolete_pages() since MMU shrinker is not using it
> > anymore.
> >
> > Current flow of KVM MMU shrinker is very disruptive to VMs.

Please use full sentences.

> > It picks the first VM in the vm_list, zaps the oldest page which is mos=
t
> > likely an upper level SPTEs and most like to be reused. Prior to TDP MM=
U,
> > this is even more disruptive in nested VMs case, considering L1 SPTEs w=
ill
> > be the oldest even though most of the entries are for L2 SPTEs.

This flaw isn't limited to the shrinker though, it's inherent to all of KVM=
's
force page table reclamation.

> > As discussed in [1] shrinker logic has not be very useful in actually
> > keeping VMs performant

I don't think anyone has ever claimed that the shrinker would be useful in
providing performance for VMs.  AFAICT, it's always been about memory usage=
, and
nothing more.

> > and reducing memory usage.

This one I definitely agree on :-)

> > There was an alternative suggested [2] to repurpose shrinker for
> > shrinking vCPU caches. But considering that in all of the KVM MMU
> > shrinker history it hasn't been used/needed/complained, and there has
> > not been any conversation regarding KVM using lots of page tables, it
> > might be better to just not have shrinker.

A complaint about KVM's page table usage would be an argument for keeping (=
and
improving) the current shrinker implementation, not for dropping the per-vC=
PU
caches.  And _that_ to me leads to the the real argument for not wiring up =
the
shrinker to the per-vCPU caches: it doesn't scale.  E.g. a VM with 4 vCPUs =
and
4 TiB of memory will, at most, reclaim a laugable 640KiB (4*40*4KiB) of mem=
ory.
That's obviously more than a bit contrived, but IMO it really shows that ta=
rgeting
the per-vCPU caches is unlikely to be useful in practice.  At best, it woul=
d be
a premature memory optimization.

> > If the need arise [2] can be revisited.

Everything can be revisited, I think what's important here is to state why =
forcing
future developers to (re)start from scratch is a non-issue.

> >
> > [1] https://lore.kernel.org/lkml/Y45dldZnI6OIf+a5@google.com/
> > [2] https://lore.kernel.org/kvm/20241004195540.210396-3-vipinsh@google.=
com/
> >
> > Suggested-by: Sean Christopherson <seanjc@google.com>
> > Suggested-by: David Matlack <dmatlack@google.com>
> > Reviewed-by: David Matlack <dmatlack@google.com>
>=20
> FYI, I carried forward David's Reviewed-by from the previous versions.
> Extra change from the previous version is removing registration of KVM
> MMU shrinker in kvm_mmu_vendor_module_init() and mmu_shrinker object
> along with its callback functions.

Heh, I'm going to drop David's review, because I am going to split this int=
o two
patches when applying.  One to yank out the shrinker, and one to use a loca=
l list
in kvm_zap_obsolete_pages() and drop zapped_obsolete_pages.

Somewhat subtly, the only reason dropping zapped_obsolete_pages doesn't int=
roduce
a functional change is because kvm_zap_obsolete_pages() is called under slo=
ts_lock,
and doesn't drop said lock when yielding.  I.e. there can't be multiple wri=
ters
(or readers) of zapped_obsolete_pages, and so the list is guaranteed to be =
empty
on entry and exit.  That's worth a changelog and bisection point of its own=
.

With the patch split in two, this is what I ended up with for the main chan=
gelog.

Please speak up if you want to change anything!

    KVM: x86/mmu: Remove KVM's MMU shrinker
   =20
    Remove KVM's MMU shrinker and (almost) all of its related code, as the
    current implementation is very disruptive to VMs (if it ever runs),
    without providing any meaningful benefit[1].
   =20
    Alternatively, KVM could repurpose its shrinker, e.g. to reclaim pages
    from the per-vCPU caches[2], but given that no one has complained about
    lack of TDP MMU support for the shrinker in the 3+ years since the TDP =
MMU
    was enabled by default, it's safe to say that there is likely no real u=
se
    case for initiating reclaim of KVM's page tables from the shrinker.
   =20
    And while clever/cute, reclaiming the per-vCPU caches doesn't scale the
    same way that reclaiming in-use page table pages does.  E.g. the amount=
 of
    memory being used by a VM doesn't always directly correlate with the
    number vCPUs, and even when it does, reclaiming a few pages from per-vC=
PU
    caches likely won't make much of a dent in the VM's total memory usage,
    especially for VMs with huge amounts of memory.
   =20
    Lastly, if it turns out that there is a strong use case for dropping th=
e
    per-vCPU caches, re-introducing the shrinker registration is trivial
    compared to the complexity of actually reclaiming pages from the caches=
.
   =20
    [1] https://lore.kernel.org/lkml/Y45dldZnI6OIf+a5@google.com
    [2] https://lore.kernel.org/kvm/20241004195540.210396-3-vipinsh@google.=
com

