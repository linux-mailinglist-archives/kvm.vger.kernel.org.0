Return-Path: <kvm+bounces-29707-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 246E79B03DC
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2024 15:21:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D61372853EE
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2024 13:21:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A5FD52F76;
	Fri, 25 Oct 2024 13:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Xi8t5k/H"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E7D2212164
	for <kvm@vger.kernel.org>; Fri, 25 Oct 2024 13:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729862485; cv=none; b=ceQFyG9Ilbny7zDQppe/oRD7ifpO/EGFFbFdcm1zRsXvDtJfaOikhm+hYdavrsrNzQ08wCc9JGfXFIoT/lLoymRfGmKcTiM2pgoTmuUW8SWufUsuqM8Dkty5R/0ZX3we5zyuwENSGwEhGrVWaKHCkZS7cYn65BYcyOfeRmDETuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729862485; c=relaxed/simple;
	bh=/32HmL7YwBkjAVKTXfU1mVprjlPb8B1ISFkFhMOu8aM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TP2tj2PWa5lt35iYTSItYlFcc8r9yH0OMMTmaC3Niz1LDyJedWpUBfp+4X5AjRFT/GRVDHJ8zYURFP7ruIsOAZg46BX7Ciok5tM2nb5q7bITadWZXPmL5ha93/UoflptHrjTn9/H4LLKyJgtlBIlxHXV8MmUBzfmJockpOMVx7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Xi8t5k/H; arc=none smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-460969c49f2so260621cf.0
        for <kvm@vger.kernel.org>; Fri, 25 Oct 2024 06:21:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1729862482; x=1730467282; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=7bTA5XEv/pSAM+W1H3oIEVE2GosaAWU3ljRxi1KlB14=;
        b=Xi8t5k/Hl+VtKA0i5CAqPvqw+2zTRtgIBL0xwgj1wpRmZqmGMAeDYQoQA2FSjRyjhH
         DaF2DOZ+hLlzFnwP2G1FP772uAiJYzgf0Pw7YGfVBNrSb1H309LF86ECRvKiJWUfncGp
         e3WK/6QueuHla+qqVyKec8uFidYLc9ULu9LrC5RIJolNFr1XQqU1nmyK6HHvfD/09emp
         n+OD0cVyzwTb5Q3GS8pyo5OiIH7rQmWnD/aFVaI2N+Y70thYv9JShrii1fyzlSjo4cXZ
         O3JoF5qdohsNGYp+w9grnYL8Q1tftV89UYUeGyWbXqlnjiIH5++YycSv6OwT7mg90iBS
         ujeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729862482; x=1730467282;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7bTA5XEv/pSAM+W1H3oIEVE2GosaAWU3ljRxi1KlB14=;
        b=UKW1zBxlJRSKrHUOIq9qNOtDo6/DYuuRt9upwXNAr9naapDWPrAgefa38Aq5TX4/oc
         Q0Uqvs3FpNVoO15bl9ripBenKRD63bdwXE68LX0qCQvt8uiBw0JFLHmw7gOyIUvEJP1q
         mHqeeHarJFbx/AAibGxQEPV81Kk2fY+uIZrpYA/qoHTLP4esHMqz1krWs7wnIGuoO1d0
         qCPMcGwcZoJjAvzraluLoUSTArTLpQ+kI/wnTvRrZcG3IWLyBytu9cX5qZrM619cWrzK
         zDYSnf3qfpu0ZXT5ZWr/Ky9h5KzmXPDSuZC0p03JkZHLvl8zWWRI5GXoeeNlmdS/oQUF
         v88g==
X-Forwarded-Encrypted: i=1; AJvYcCW4AN4qFqceDaWLg/WQiW6+9JNW1Ut0hApi+mTbNw9jWpVWT1hPo1sPa8V19MBC+HJ5hVU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxQK7kH4eI8JLZUNckKfed6qKUiuOlj+Ao5swKhbjG8YDhQRSmL
	hDiTkfMfyV2oWyjz23BiKlFinqvdpWDk+/I7nZ6CRtl9gZ5OZemdJsPkoyGFkoeoj7KhZOCAlmj
	xlVICfBsxSqK/wzgVSrasn/gXKzqmAWfcnmKY
X-Google-Smtp-Source: AGHT+IFLcF2W2NrORj/Xb8SC12qeyC5KVAM9B79QtrQcqFpidlzCS6ayGMpyXO+mm8gBR/NQWaXXOnPJfjuALjSAZEE=
X-Received: by 2002:a05:622a:152:b0:460:4638:78c0 with SMTP id
 d75a77b69052e-4612eb81fbfmr3022001cf.14.1729862482147; Fri, 25 Oct 2024
 06:21:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240712-asi-rfc-24-v1-0-144b319a40d8@google.com>
 <20240712-asi-rfc-24-v1-1-144b319a40d8@google.com> <20241025113455.GMZxuCX2Tzu8ulwN3o@fat_crate.local>
In-Reply-To: <20241025113455.GMZxuCX2Tzu8ulwN3o@fat_crate.local>
From: Brendan Jackman <jackmanb@google.com>
Date: Fri, 25 Oct 2024 15:21:11 +0200
Message-ID: <CA+i-1C3SZ4FEPJyvbrDfE-0nQtB_8L_H_i67dQb5yQ2t8KJF9Q@mail.gmail.com>
Subject: Re: [PATCH 01/26] mm: asi: Make some utility functions noinstr compatible
To: Borislav Petkov <bp@alien8.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Alexandre Chartre <alexandre.chartre@oracle.com>, Liran Alon <liran.alon@oracle.com>, 
	Jan Setje-Eilers <jan.setjeeilers@oracle.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>, 
	Lorenzo Stoakes <lstoakes@gmail.com>, David Hildenbrand <david@redhat.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Michal Hocko <mhocko@kernel.org>, Khalid Aziz <khalid.aziz@oracle.com>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Valentin Schneider <vschneid@redhat.com>, Paul Turner <pjt@google.com>, Reiji Watanabe <reijiw@google.com>, 
	Junaid Shahid <junaids@google.com>, Ofir Weisse <oweisse@google.com>, 
	Yosry Ahmed <yosryahmed@google.com>, Patrick Bellasi <derkling@google.com>, 
	KP Singh <kpsingh@google.com>, Alexandra Sandulescu <aesa@google.com>, 
	Matteo Rizzo <matteorizzo@google.com>, Jann Horn <jannh@google.com>, x86@kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hey Boris,

On Fri, 25 Oct 2024 at 13:41, Borislav Petkov <bp@alien8.de> wrote:
>
> On Fri, Jul 12, 2024 at 05:00:19PM +0000, Brendan Jackman wrote:
> > +/*
> > + * Can be used for functions which themselves are not strictly noinstr, but
> > + * may be called from noinstr code.
> > + */
> > +#define inline_or_noinstr                                            \
>
> Hmm, this is confusing. So is it noinstr or is it getting inlined?

We don't care if it's getting inlined, which is kinda the point. This
annotation means "you may call this function from noinstr code". My
current understanding is that the normal noinstr annotation means
"this function fundamentally mustn't be instrumented".

So with inline_or_noinstr you get:

1. "Documentation" that the function itself doesn't have any problem
with getting traced etc.
2. Freedom for the compiler to inline or not.

> I'd expect you either always inline the small functions - as you do for some
> aleady - or mark the others noinstr. But not something in between.
>
> Why this?

Overall it's pretty likely I'm wrong about the subtlety of noinstr's
meaning. And the benefits I listed above are pretty minor. I should
have looked into this as it would have been an opportunity to reduce
the patch count of this RFC!

Maybe I'm also forgetting something more important, perhaps Junaid
will weigh in...

