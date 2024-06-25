Return-Path: <kvm+bounces-20439-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DB12F915BEC
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 03:56:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 539CCB21F78
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 01:56:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C3C720309;
	Tue, 25 Jun 2024 01:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aQW4ZNe6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CA571BC2F
	for <kvm@vger.kernel.org>; Tue, 25 Jun 2024 01:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719280580; cv=none; b=ri3wD6sBwpN6xs27Crzxi/IhJXdP+ddaz3IT4XmlBB18fGsyUkYblFHH2faOav1+VNxC+fH7JrzXKmIUlWUWjZu2NrVRQmDmUJRc17ipG7QUka4NbnZaGmwA1gxchry7LPVOxNk800AQUZRn4MVAdWYf1kywa9+14OPzckfCfLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719280580; c=relaxed/simple;
	bh=esq/oSzRwy7/cYJxmdYp5IZKdjJ+2ZYgZSOpvT3tMHg=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=cLuL4ybCQg6BdbWLmGE+54uNvzNs+XOp5vRT98U2/cWLBS9rVuFoSEJ/x/SR4irHAYYkUSUfS3RpKQ3y8fBm2WKjyVk3/nGFZVe6r6ua693bsp8+oWTPBtCljpJC9F+ZC2tAfz30e1RiT0ZPFYiPvtx5DFYPcwMb/5tlEykTLTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aQW4ZNe6; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-7067108f2cdso1817511b3a.1
        for <kvm@vger.kernel.org>; Mon, 24 Jun 2024 18:56:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719280578; x=1719885378; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NYZY7E/hXC2pNdw5CSObSFWNa8KKNDbdi6VPYKf3QG8=;
        b=aQW4ZNe6yBXpY082CEDllBLInAbcqKJMYlqzxsIRl3YDtbs90agiDtPnGXk/UElF+w
         vacmPxkaqRuV4gOlAczyAEwpyvfVYiRaIYoMzRZTVFQxdNenk95PeFyiZcxjxyks1iRY
         s+hqlckzAlraldBSRQrR3YQKQdoYG3PuOtnwbkPN1iU/278NF63gKkswoq8RuDfpr2hM
         O3GX4TTFnxdD8Judt9IHT/xcyD7VhMn62+7UQmFzCWmtiwAJQcUa0q36/yiRNB37JThN
         I3vuXlM+yXDw00UH7w/Xel3xUXYHA+gIYvCB2BCNLDsTXnPl1WaD+X7Vzpni9jBOmzEi
         IAQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719280578; x=1719885378;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=NYZY7E/hXC2pNdw5CSObSFWNa8KKNDbdi6VPYKf3QG8=;
        b=U2T47zIGXyVaYGbKr2DoM6NXceLm9wSDDDp1vakDPLiaXOMpi5Dmw6iO+Ik1JXaa+S
         auUutcWGN0S9QkX5SaA+GFEmVTG7hSdUqbd/IoTPFId2HC5GAUYDkLZQ2czQw9yVpbij
         TvN2YRyKVYSTZGqVEJCACac2IH6mS3Bu5Ux6rL1K6XPIzIVvSTRtCVz+HyDoHaJgC2eA
         ytItM/gGjukLODwJE9AV7yoDvtZknzH9rRWdWNVYSt298FQAkfB2xUZS8UyJdnCPW+qL
         og2loOeKM04/AfVG5Qdg9b9hbrQajuA1ub4HkwKIkjUslo1OwkMW3F4XZZzHSO1rSdq8
         YN7Q==
X-Forwarded-Encrypted: i=1; AJvYcCVtVcts5ahlq9YImKCk2MBylACGUDMvZEOEB2H7c8jjAaByM6oBWBFRlK2SAgNLKeKzFkqR2OxsXxHjJx6TGhSur7WD
X-Gm-Message-State: AOJu0YzYyCVjn3TNqHFwTv/k9aQHbiNmo54XttR7yiI+5mq3ZmA6LfKe
	ZqccsKOFECCBKu5a08yQzI13CCcoAsPeU4SxaNuFa0bKPxdnPq4QZjRd3w==
X-Google-Smtp-Source: AGHT+IE2waZlPGm4HkckDWuZTNRDoL0wrQGRaanKL/AYe6vof56/3DBV9xSAOq7mrPTVi5VkMVf2Jg==
X-Received: by 2002:a05:6a00:2d81:b0:706:6c70:e583 with SMTP id d2e1a72fcca58-70670f19356mr9194230b3a.19.1719280578440;
        Mon, 24 Jun 2024 18:56:18 -0700 (PDT)
Received: from localhost (118-211-5-80.tpgi.com.au. [118.211.5.80])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70651cd4ea3sm7033630b3a.99.2024.06.24.18.56.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Jun 2024 18:56:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 25 Jun 2024 11:56:12 +1000
Message-Id: <D28Q3J98V4EC.1RXWN7UR4A3J7@gmail.com>
Cc: "Laurent Vivier" <lvivier@redhat.com>, "Andrew Jones"
 <andrew.jones@linux.dev>, <linuxppc-dev@lists.ozlabs.org>,
 <kvm@vger.kernel.org>
Subject: Re: [kvm-unit-tests PATCH v10 08/15] powerpc: add pmu tests
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Thomas Huth" <thuth@redhat.com>
X-Mailer: aerc 0.17.0
References: <20240612052322.218726-1-npiggin@gmail.com>
 <20240612052322.218726-9-npiggin@gmail.com>
 <5bfe90ca-96aa-405b-a4b9-86ec4a497366@redhat.com>
In-Reply-To: <5bfe90ca-96aa-405b-a4b9-86ec4a497366@redhat.com>

On Wed Jun 19, 2024 at 4:39 AM AEST, Thomas Huth wrote:
> On 12/06/2024 07.23, Nicholas Piggin wrote:
> > Add some initial PMU testing.
> >=20
> > - PMC5/6 tests
> > - PMAE / PMI test
> > - BHRB basic tests
> >=20
> > Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> > ---
> ...
> > diff --git a/powerpc/pmu.c b/powerpc/pmu.c
> > new file mode 100644
> > index 000000000..bdc45e167
> > --- /dev/null
> > +++ b/powerpc/pmu.c
> > @@ -0,0 +1,562 @@
> ...
> > +static void test_pmc5_with_ldat(void)
> > +{
> > +	unsigned long pmc5_1, pmc5_2;
> > +	register unsigned long r4 asm("r4");
> > +	register unsigned long r5 asm("r5");
> > +	register unsigned long r6 asm("r6");
> > +	uint64_t val;
> > +
> > +	reset_mmcr0();
> > +	mtspr(SPR_PMC5, 0);
> > +	mtspr(SPR_MMCR0, mfspr(SPR_MMCR0) & ~(MMCR0_FC | MMCR0_FC56));
> > +	asm volatile(".rep 20 ; nop ; .endr" ::: "memory");
> > +	mtspr(SPR_MMCR0, mfspr(SPR_MMCR0) | (MMCR0_FC | MMCR0_FC56));
> > +	pmc5_1 =3D mfspr(SPR_PMC5);
> > +
> > +	val =3D 0xdeadbeef;
> > +	r4 =3D 0;
> > +	r5 =3D 0xdeadbeef;
> > +	r6 =3D 100;
> > +	reset_mmcr0();
> > +	mtspr(SPR_PMC5, 0);
> > +	mtspr(SPR_MMCR0, mfspr(SPR_MMCR0) & ~(MMCR0_FC | MMCR0_FC56));
> > +	asm volatile(".rep 10 ; nop ; .endr ; ldat %0,%3,0x10 ; .rep 10 ; nop=
 ; .endr" : "=3Dr"(r4), "+r"(r5), "+r"(r6) : "r"(&val) :"memory");
>
> Looks like older versions of Clang do not like this instruction:
>
>   /tmp/pmu-4fda98.s: Assembler messages:
>   /tmp/pmu-4fda98.s:1685: Error: unrecognized opcode: `ldat'
>   clang-13: error: assembler command failed with exit code 1 (use -v to s=
ee=20
> invocation)
>
> Could you please work-around that issue?

Ah, just catching up with this -- thanks for working it out.

I will fix.

>
> Also, please break the very long line here. Thanks!

Sure.

Thanks,
Nick

>
> > +	mtspr(SPR_MMCR0, mfspr(SPR_MMCR0) | (MMCR0_FC | MMCR0_FC56));
> > +	pmc5_2 =3D mfspr(SPR_PMC5);
> > +	assert(r4 =3D=3D 0xdeadbeef);
> > +	assert(val =3D=3D 0xdeadbeef);
> > +
> > +	/* TCG does not count instructions around syscalls correctly */
> > +	report_kfail(host_is_tcg, pmc5_1 !=3D pmc5_2 + 1,
> > +		     "PMC5 counts instructions with ldat");
> > +}
>
>   Thomas


