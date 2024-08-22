Return-Path: <kvm+bounces-24851-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DCC3295BF72
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2024 22:12:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0B2961C217CB
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2024 20:12:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A15F51D0498;
	Thu, 22 Aug 2024 20:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4BpnjIaV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6459B16B3B7
	for <kvm@vger.kernel.org>; Thu, 22 Aug 2024 20:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724357512; cv=none; b=Q/I9/+xAPZrW5hKXXxN4zqrWoBMF0d4nwCHV9epvUQnVVLU+QnxZeIZXB1pM7J3mT1w7k9WImoVV7XoCcfNSsVPzX7PSE/ztsLjm/3csl20Suw97qoOSFjGPmGYnT///gObqAjCayDBNpPWhoCbeAxAjp6vPXsM/yec7575Sy+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724357512; c=relaxed/simple;
	bh=OueZnS5YARqrlBL9StFfdBa5tBCaLBzjuW0/YqUT9+s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GKnbXOr3aRWQFjJ586ku6SujWRL21M2t2kYXK7LPs5HlO5VkP8/lySJ1TazPTp+/UoRPZF60agVs5H+IOW84Sw8kXCnwgB08i5iSv9jBmVpymWyygtbZhE994zxbTZSwTH/bIyujU/1SN6VVrm6WD1zntNpZXko1rjdf5c3Zh08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4BpnjIaV; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7125fb17a83so1041465b3a.3
        for <kvm@vger.kernel.org>; Thu, 22 Aug 2024 13:11:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724357511; x=1724962311; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DQEyiyVWwKC5yJKTYyz1rAHBwUajOCFPIq1Kvl1ggcI=;
        b=4BpnjIaVlRbaq10SRUpdxXoEXM33D75rKKbbQtwcrSB2dqYngpB+jfnfoT5S4XWtLA
         hUg/98fkjI9D+LLSbXGWrfEzsUV9YrIIANTb3h4jmLuxXmpkRwEtb02CEW7X0+6e7Iu+
         P77Bg5JHJ84hWDJE+Bh05/C5hm+UltZAVvPJ+bsTs23VncaQBU6tABpIH0wBmrGS7rsR
         N/fiGbme2VrbTulfIOm16zhpecz7UEjHK+SB6tIj/L3mwizNp2Vkx3BeH5fSq9ABNzC5
         yFQHFIY56oFVTDRunzeSIaoM9pd1Ne9kkGNFQLxnOCMUHLGRYM2haHzTK96Jhou7zB7/
         YTvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724357511; x=1724962311;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=DQEyiyVWwKC5yJKTYyz1rAHBwUajOCFPIq1Kvl1ggcI=;
        b=tyG0JCNVXAfCAcpT/WCDyC+AXGDhg6ojZVU1gLtPx4NQ3xuguO2wX32+NjM4+AcUvb
         6xtF+3/THpPsSkaRC+kVaIrBQ2rBrQu72M80kIwMGMOoxSD8B5yfsHWyb3pbMGpitSjj
         fGbIrSMnOUCEcnQx2MRFZIMtcWN0f0yW3ZkVVT+yLyhBkuJ3OC77kcKUv02x8lWJaqe7
         RAFROlTLRiVESk5jhEGZGsr0M8STBYtixE4bAb0NOAq4kTHdjTFDZIP14OnmNkfYZWe3
         VWm3RNyUo8bW1H6G5d7R35tERpGZkYQ0oxfTnRLGeTSqQxVO1XJqkLTPmk+Npm5A5roa
         CaLg==
X-Forwarded-Encrypted: i=1; AJvYcCWdyCDL2RKTnL7R2+B/Eqg0IMMJ/W5qV7MIXKLV8oC9jZU25FDzvwBjoM+8IX9lnR9zn4Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YwNSCKCG5zcqsdlxq1KOJBlUe2hMoRT31JCFbvJ/ge2x2BxvSGx
	NuiqVMYdAERaLleE3dwxdOzzKplp0dmEQbIQYJ5dGVXYEkNKUIgKkW9PuKMc7cBqkqB9U20OHVb
	D8Q==
X-Google-Smtp-Source: AGHT+IGk/5UlnwAT4VHBg6wIo6e2HfW+hQmBUjfrQ2LH9s+0m1j9zBpW4zd5ELZTqJOOOktafavJ5QLP1f8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:9186:b0:714:209c:437c with SMTP id
 d2e1a72fcca58-71445407184mr324b3a.0.1724357510424; Thu, 22 Aug 2024 13:11:50
 -0700 (PDT)
Date: Thu, 22 Aug 2024 13:11:48 -0700
In-Reply-To: <CALzav=d18V=T=QVbOtiLG1Y7rmG-8B31gdjnbrfGkzC2k3FPVQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240805233114.4060019-1-dmatlack@google.com> <20240805233114.4060019-8-dmatlack@google.com>
 <ZsdsOpWnZY47J5sU@google.com> <CALzav=d18V=T=QVbOtiLG1Y7rmG-8B31gdjnbrfGkzC2k3FPVQ@mail.gmail.com>
Message-ID: <ZsebhCLozcv1yyZ8@google.com>
Subject: Re: [PATCH 7/7] KVM: x86/mmu: Recheck SPTE points to a PT during huge
 page recovery
From: Sean Christopherson <seanjc@google.com>
To: David Matlack <dmatlack@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 22, 2024, David Matlack wrote:
> On Thu, Aug 22, 2024 at 9:50=E2=80=AFAM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> > On Mon, Aug 05, 2024, David Matlack wrote:
> > > Recheck the iter.old_spte still points to a page table when recoverin=
g
> > > huge pages. Since mmu_lock is held for read and tdp_iter_step_up()
> > > re-reads iter.sptep, it's possible the SPTE was zapped or recovered b=
y
> > > another CPU in between stepping down and back up.
> > >
> > > This could avoids a useless cmpxchg (and possibly a remote TLB flush)=
 if
> > > another CPU is recovering huge SPTEs in parallel (e.g. the NX huge pa=
ge
> > > recovery worker, or vCPUs taking faults on the huge page region).
> > >
> > > This also makes it clear that tdp_iter_step_up() re-reads the SPTE an=
d
> > > thus can see a different value, which is not immediately obvious when
> > > reading the code.
> > >
> > > Signed-off-by: David Matlack <dmatlack@google.com>
> > > ---
> > >  arch/x86/kvm/mmu/tdp_mmu.c | 11 +++++++++++
> > >  1 file changed, 11 insertions(+)
> > >
> > > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > > index 07d5363c9db7..bdc7fd476721 100644
> > > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > > @@ -1619,6 +1619,17 @@ static void recover_huge_pages_range(struct kv=
m *kvm,
> > >               while (max_mapping_level > iter.level)
> > >                       tdp_iter_step_up(&iter);
> > >
> > > +             /*
> > > +              * Re-check that iter.old_spte still points to a page t=
able.
> > > +              * Since mmu_lock is held for read and tdp_iter_step_up=
()
> > > +              * re-reads iter.sptep, it's possible the SPTE was zapp=
ed or
> > > +              * recovered by another CPU in between stepping down an=
d
> > > +              * stepping back up.
> > > +              */
> > > +             if (!is_shadow_present_pte(iter.old_spte) ||
> > > +                 is_last_spte(iter.old_spte, iter.level))
> > > +                     continue;
> >
> > This is the part of the step-up logic that I do not like.  Even this ch=
eck doesn't
> > guarantee that the SPTE that is being replaced is the same non-leaf SPT=
E that was
> > used to reach the leaf SPTE.  E.g. in an absurdly theoretical situation=
, the SPTE
> > could be zapped and then re-set with another non-leaf SPTE.  Which is f=
ine, but
> > only because of several very subtle mechanisms.
>=20
> I'm not sure why that matters. The only thing that matters is that the
> GFN->PFN and permissions cannot change, and that is guaranteed by
> holding mmu_lock for read.

Because it introduces possible edge cases, that while benign, require the r=
eader
to think about and reason through.  E.g. if _this_ task is trying to replac=
e a
4KiB page with a 1GiB page, what happens if some other task replaces the pa=
rent
2MiB page?  It's not immediately obvious that looping on tdp_iter_step_up()=
 will
happily blaze past a !PRESENT SPTE, which might not even be the actual SPTE=
 in
the tree at this point.

> At the end of the day, we never actually care about the value of the
> SPTE we are replacing. We only care that it's a non-leaf SPTE.
>
> > kvm_mmu_max_mapping_level() ensures that there are no write-tracked gfn=
s anywhere
> > in the huge range, so it's safe to propagate any and all WRITABLE bits.=
  This
> > requires knowing/remembering that KVM disallows huge pages when a gfn i=
s write-
> > tracked, and relies on that never changing (which is a fairly safe bet,=
 but the
> > behavior isn't fully set in stone).
> > not set.
> >
> > And the presence of a shadow-present leaf SPTE ensures there are no in-=
flight
> > mmu_notifier invalidations, as kvm_mmu_notifier_invalidate_range_start(=
) won't
> > return until all relevant leaf SPTEs have been zapped.
>=20
> As you point out in the next paragraph there could be an inflight invalid=
ate
> that yielded, no?

Yeah, ignore this, I forgot to amend it after remembering that invalidation=
 can
yield.

