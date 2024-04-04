Return-Path: <kvm+bounces-13617-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E8C208990F4
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 00:03:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6D184B25C4F
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 22:03:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6ED4113C3D2;
	Thu,  4 Apr 2024 22:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VaHPnctX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D85013C3F0
	for <kvm@vger.kernel.org>; Thu,  4 Apr 2024 22:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712268174; cv=none; b=eyhKCIUq2NjwwE0cB9pUsFf22+C+teUXnrlyvbd9TFg8RVs2+OLWVt/QbmZe4+oFXNiTBzg2+9W4e0GB4p1o00HQ4shnhyX0/hHFouLZZKvC/W9of0jWAxOJibKL2HU9lcDqloRHDqVrfJzI3XsKygKjAQESGg1ggqQ6gwqg+5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712268174; c=relaxed/simple;
	bh=gCXKx584ihLrRGLv1AW+QX7Fe19+djW1Hf4uwf3WwHA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jvFp6ACfafHsBohB5ia6a3sE8fY+H7KozfKNjXuJ5IMGf3y5r2rmj0O9BYHe5a9/BomBWqSAU0imLCYFxdrX8SvD8aIvnA758NEFL3sgOv6934WFFcxf0Lwgyjkc8l236Ne6GWZL5MCH6kElutR5YxgOHPDr/5xdj7ckTT8Dm68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VaHPnctX; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dc74ac7d015so2039124276.0
        for <kvm@vger.kernel.org>; Thu, 04 Apr 2024 15:02:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712268172; x=1712872972; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9ZNQ0U5unaFTxk2zzDkpqLdaGLsgSJwRkFdrhcIu1eQ=;
        b=VaHPnctXrCXyHSegUpa5TBFCy9Zl8TuNvFuAdlc5bd4kumNzD0X5D6xV2fcexJAMut
         Jiu4RiOWcsqXBVEQZxatOzn/Z2xpo2iYSBQ3msK8KRG45Ur2LZTMCNVbSo9kSppQaMJn
         V1+G8wq0mXC9bQcM2JdaqKbn2rIZsvQTds3VNQZ/EslCnoqUX7BDKomJj5eYsJk2EaqA
         6eBrgK7kqd1Hcv0UkDt3aQAC4VaEk0nGE3LUXfinu77y00q37uat8v3+bETbpNxcol9x
         VXEeKK9mUKjdSqitNfY2bFjn5OIjM/CA0pjnt33Dt9DrOzM0Z49FFxzy3ajJEmcMyCLl
         wSBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712268172; x=1712872972;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9ZNQ0U5unaFTxk2zzDkpqLdaGLsgSJwRkFdrhcIu1eQ=;
        b=nIB5vGUfWstQSl7us2/sz6Hd8CLcm/WQjcYqTYJ6YXNSMyze+gqJx+iL4NcKTFMlZe
         /D8NaSmzO/1lOcw8xW9X9HE+HzNHZ4QrC2ILvIBeFfwFZKfWvVs6J33O7br3FyuHnEWa
         TMrxU0aSR5UwF948t/PiJiN4b5DwFPFEqR/EGNQOEoGzAysfxiqB+QRjus/mqdrfq63X
         wwTkmxljqLBfa8mPB/IocNpo/yBjen7TwH82q9xrspZtzgltuAsAOqtSGVAoQJX6gB4t
         Syej2hdcHNYiwlEXvM3g1qlNm2d6seEnSxY78lNail2mdkAfMboSdtRQ5aUqwaqyILhP
         tjng==
X-Forwarded-Encrypted: i=1; AJvYcCVgES/8HEGUfbPgNwjc3XrcrxAutH6JIdeBzi+hkoNDckP9FyvjnTmYD3PFlE3AnJznoV+Fd20u7QDtcL9HLfoANWWC
X-Gm-Message-State: AOJu0YzvxbKimDEDN0MXtZjCUo1v8eCD3h9oeTlZp9OrK/yAvjahlhXA
	+Ns/ApctmUSsmvCrHqVL2Co+vZU6I3VsZ+8JDxHFwxq1TGUIlJ2b2HZendCdQtavzwIO56QOqYO
	09Q==
X-Google-Smtp-Source: AGHT+IE05QOun/pkmautFCPsP8G2K7XExWfyaZrvizqHD63veiC++eGMl5R2p4BQj9L26q3oiaqe1CURGNM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:6b4b:0:b0:dc2:26f6:fbc8 with SMTP id
 o11-20020a256b4b000000b00dc226f6fbc8mr91119ybm.7.1712268172238; Thu, 04 Apr
 2024 15:02:52 -0700 (PDT)
Date: Thu, 4 Apr 2024 15:02:50 -0700
In-Reply-To: <b3ea925f-bd47-4f54-bede-3f0d7471e3d7@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240320005024.3216282-1-seanjc@google.com> <4d04b010-98f3-4eae-b320-a7dd6104b0bf@redhat.com>
 <CALzav=eLH+V_5Y6ZWsRkmnbEb6fxPa55B7xyWxP3o6qsrs_nHA@mail.gmail.com>
 <a2fff462-dfe6-4979-a7b2-131c6e0b5017@redhat.com> <ZgygGmaEuddZGKyX@google.com>
 <ca1f320b-dc06-48e0-b4f5-ce860a72f0e2@redhat.com> <Zg3V-M3iospVUEDU@google.com>
 <42dbf562-5eab-4f82-ad77-5ee5b8c79285@redhat.com> <Zg7j2D6WFqcPaXFB@google.com>
 <b3ea925f-bd47-4f54-bede-3f0d7471e3d7@redhat.com>
Message-ID: <Zg8jip0QIBbOCgpz@google.com>
Subject: Re: [RFC PATCH 0/4] KVM: x86/mmu: Rework marking folios dirty/accessed
From: Sean Christopherson <seanjc@google.com>
To: David Hildenbrand <david@redhat.com>
Cc: David Matlack <dmatlack@google.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, David Stevens <stevensd@chromium.org>, 
	Matthew Wilcox <willy@infradead.org>
Content-Type: text/plain; charset="us-ascii"

On Thu, Apr 04, 2024, David Hildenbrand wrote:
> On 04.04.24 19:31, Sean Christopherson wrote:
> > On Thu, Apr 04, 2024, David Hildenbrand wrote:
> > > On 04.04.24 00:19, Sean Christopherson wrote:
> > > > Hmm, we essentially already have an mmu_notifier today, since secondary MMUs need
> > > > to be invalidated before consuming dirty status.  Isn't the end result essentially
> > > > a sane FOLL_TOUCH?
> > > 
> > > Likely. As stated in my first mail, FOLL_TOUCH is a bit of a mess right now.
> > > 
> > > Having something that makes sure the writable PTE/PMD is dirty (or
> > > alternatively sets it dirty), paired with MMU notifiers notifying on any
> > > mkclean would be one option that would leave handling how to handle dirtying
> > > of folios completely to the core. It would behave just like a CPU writing to
> > > the page table, which would set the pte dirty.
> > > 
> > > Of course, if frequent clearing of the dirty PTE/PMD bit would be a problem
> > > (like we discussed for the accessed bit), that would not be an option. But
> > > from what I recall, only clearing the PTE/PMD dirty bit is rather rare.
> > 
> > And AFAICT, all cases already invalidate secondary MMUs anyways, so if anything
> > it would probably be a net positive, e.g. the notification could more precisely
> > say that SPTEs need to be read-only, not blasted away completely.
> 
> As discussed, I think at least madvise_free_pte_range() wouldn't do that.

I'm getting a bit turned around.  Are you talking about what madvise_free_pte_range()
would do in this future world, or what madvise_free_pte_range() does today?  Because
today, unless I'm really misreading the code, secondary MMUs are invalidated before
the dirty bit is cleared.

	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm,
				range.start, range.end);

	lru_add_drain();
	tlb_gather_mmu(&tlb, mm);
	update_hiwater_rss(mm);

	mmu_notifier_invalidate_range_start(&range);
	tlb_start_vma(&tlb, vma);
	walk_page_range(vma->vm_mm, range.start, range.end,
			&madvise_free_walk_ops, &tlb);
	tlb_end_vma(&tlb, vma);
	mmu_notifier_invalidate_range_end(&range);

KVM (or any other secondary MMU) can re-establish mapping with W=1,D=0 in the
PTE, but the costly invalidation (zap+flush+fault) still happens.

> Notifiers would only get called later when actually zapping the folio.

And in case we're talking about a hypothetical future, I was thinking the above
could do MMU_NOTIFY_WRITE_PROTECT instead of MMU_NOTIFY_CLEAR.

> So at least for some time, you would have the PTE not dirty, but the SPTE
> writable or even dirty. So you'd have to set the page dirty when zapping the
> SPTE ...  and IMHO that is what we should maybe try to avoid :)

