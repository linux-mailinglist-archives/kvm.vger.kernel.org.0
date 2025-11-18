Return-Path: <kvm+bounces-63545-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C831C69D3B
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 15:09:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id E53294F75AC
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 14:03:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E91DF36402D;
	Tue, 18 Nov 2025 13:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="n46aGFuP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DB76363C54
	for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 13:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763474395; cv=none; b=ECgs5SJ6iBh+QJKQSQLyNViHMCjo8JWYAXMRkKBXXIV2TyaUpY3bbJ+Y+2N18CNQMWTp31YUCTjqWjsm9/rp2YNmkndXx5PJN0+Kw9+8aTG1Sn92Yy2JRg56ZxQ+hSDY4ozHUlpWla7S5OAZ/1eA0vxkfNfv1GRz5btn0/o8ns4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763474395; c=relaxed/simple;
	bh=a4l6UmF6YkipJmQfu6Xj5itRRy/apLU9qhpssM5sf3Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UX0KQ0QZnBm8OrWUGSM/0KpkHSMKGVqyqSNzPPj15jQ1rhCRKZ5F+pBGMwnhk78JZhg+nZ8687oqhvnGTk37ySXNpvhPbEd6QBA5aB9/pddZwYx5Kkw5ph3TYad7HeUrf5jlfjL1K2anta67++njr0oQ2UnvPDOvbwn4WQbbdXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=n46aGFuP; arc=none smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-4ee147baf7bso291581cf.1
        for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 05:59:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763474392; x=1764079192; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=R2GwSQ++DitICmTZEwHDVEkQZZItGNz+IuoJwTCHLm0=;
        b=n46aGFuPqhooEC+9uOJWaLFu9tbQQN1luwefvxdWPikzNCxvHX+B0LYYJYHwfz1Smo
         Z5N4GDOxIXa/wR5Bv/8VhgongTHMIGlUQkQ2YA5K8vlMM253a/fnpzgJDGo4DuwNWeXu
         Q837S7Q/B+BCVgtwintm+zCkYo+hV0T3RCG1DI/5ShxKi+pwC2L2hi6WWhdHLEwSw1qR
         jykzTkFuMcnInEoXhzHtjii131K1k/Ct/EQ763elQjkvo0Y5Q8CU6fLe8eu6UosND64I
         9edse6Uo4+krqL4zM0xIok3ayiQhEp9YL4TlQGTLudc4XvC6SHU7fBPTf/QYfdTDbJHG
         296Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763474392; x=1764079192;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R2GwSQ++DitICmTZEwHDVEkQZZItGNz+IuoJwTCHLm0=;
        b=k/v/b7xgBqsPWj8Z9+kFov2jiuSHMvl/BzF4s7SGo5EP0hh6TfBG1XqT8caP6fnrUf
         YoNyaouQszzA1J9XiCzzChKfJBUv51iuqM6aqi/UXdBiHjpo6RM55z7YjcnXnX8ZzJmS
         gY3DYfdrh/Jj72qv/OfnVm375LQ6nwy5PLyY/8HBhi7vfR1w6QvySCqQsxOc/3hYasZU
         vewFnlfVee6E4G5HRtQWgIi8Ug7PmX59bJDOnqD+MWOP4cNzG1og7g3kIzPXQxyIbOXn
         ud2aQqlSsCfOj8Q7/Pxnt7kO+WhEFd+SyrLJ7Aa3JL2a2wHuKhDkGxQmTcfShcIMCyJ/
         NDVA==
X-Forwarded-Encrypted: i=1; AJvYcCXTOXW4kYv811WZBk65kJEZAAPCq3b1hcE49EBumLvRIeQKYfUXyrH/Asahnoab9eWl4WI=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywi2fM7quwCMdeiRcGvA64cbFUPTh+dAG6Pz2oPHD39OE+Bj4mL
	m07ItDJQhsnrbVUkadb7FHM9porQvoDFA4SnTKWhUFDRw4b5YP1rcXq4Shf1F1P9elNBk60b8Ti
	1o3nC4bmtIqceTMvr45gKcVDwG+L2OGhEgi+zUuy9gtmTx7BBEV/44m9u
X-Gm-Gg: ASbGnctmoFVzCDiDhIo2NKCcjUbuft7ip2vv395yDTcbbC+2EkflLJKpWeVMAwOzhmi
	SCwMBOaDA+cKZqWqW2vIR3yuTEeffiNAVLTdkXVdiGYLDG8RHIHSf6D7RSP2B0qBbl6RD6Szg7D
	tu/mUO6beXREop7LpYS6VsNO0IRC2Pdfyo+olw9of2sLYWpHAcxEHCM/TR72deD1JsQgWWFXqZO
	A0of3zlPYgQF6EM5Sl8nx/QtsAZdDLuVGJ7mvcySbFVGyzYDoBGJIloN/TT5C5aLioCHyhyyv3W
	1i83jFnCir/tKOfc9HaoAJsh
X-Google-Smtp-Source: AGHT+IHCyANdQgsaiOtaga2HnBxQXXGPzcCZ4Ohf00BEMrBIOJ7VpUX3rg5vryaN2JUlMoGY94TIkE6SWzKp36uqz+s=
X-Received: by 2002:a05:622a:1455:b0:4b2:ecb6:e6dd with SMTP id
 d75a77b69052e-4ee37321ee7mr2670321cf.1.1763474391448; Tue, 18 Nov 2025
 05:59:51 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251117091527.1119213-1-maz@kernel.org> <aRweUM4O71ecPvVr@kernel.org>
In-Reply-To: <aRweUM4O71ecPvVr@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 18 Nov 2025 13:59:14 +0000
X-Gm-Features: AWmQ_bkF-6pn3IYOEpn92xj1HYWHcPhO6SZ_J8WYU-pS4TiyeHoHMyN4vCkYXBs
Message-ID: <CA+EHjTzJQOTTSUoXVKpGdWO8vz9Vc-2AL3zRyzG4DkUPz+wBBQ@mail.gmail.com>
Subject: Re: [PATCH v3 0/5] KVM: arm64: Add LR overflow infrastructure (the
 dregs, the bad and the ugly)
To: Oliver Upton <oupton@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Christoffer Dall <christoffer.dall@arm.com>, 
	Mark Brown <broonie@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, 18 Nov 2025 at 07:20, Oliver Upton <oupton@kernel.org> wrote:
>
> On Mon, Nov 17, 2025 at 09:15:22AM +0000, Marc Zyngier wrote:
> > This is a follow-up to the original series [1] (and fixes [2][3])
> > with a bunch of bug-fixes and improvements. At least one patch has
> > already been posted, but I thought I might repost it as part of a
> > series, since I accumulated more stuff:
> >
> > - The first patch addresses Mark's observation that the no-vgic-v3
> >   test has been broken once more. At some point, we'll have to retire
> >   that functionality, because even if we keep fixing the SR handling,
> >   nobody tests the actual interrupt state exposure to userspace, which
> >   I'm pretty sure has badly been broken for at least 5 years.
> >
> > - The second one addresses a report from Fuad that on QEMU,
> >   ICH_HCR_EL2.TDIR traps ICC_DIR_EL1 on top of ICV_DIR_EL1, leading to
> >   the host exploding on deactivating an interrupt. This behaviour is
> >   allowed by the spec, so make sure we clear all trap bits
> >
> > - Running vgic_irq in an L1 guest (the test being an L2) results in a
> >   MI storm on the host, as the state synchronisation is done at the
> >   wrong place, much like it was on the non-NV path before it was
> >   reworked. Apply the same methods to the NV code, and enjoy much
> >   better MI emulation, now tested all the way into an L3.
> >
> > - Nuke a small leftover from previous rework.
> >
> > - Force a read-back of ICH_MISR_EL2 when disabling the vgic, so that
> >   the trap prevents too many spurious MIs in an L1 guest, as the write
> >   to ICH_HCR_EL2 does exactly nothing on its own when running under
> >   FEAT_NV2.
> >
> > Oliver: this is starting to be a large series of fixes on top of the
> > existing series, plus the two patches you have already added. I'd be
> > happy to respin a full v4 with the fixes squashed into their original
> > patches. On the other hand, if you want to see the history in its full
> > glory, that also works for me.
>
> I'll pick up these patches in a moment but at this point I'd prefer a
> clean history. Plan is to send out the 6.19 pull sometime next week so
> any time before then would be great for v4.

I'm happy to take that for another spin Marc before you send it, if
it's different from the ToT I tested. In that case, just send me a
pointer to the branch.

Cheers,
/fuad

> Thanks for ironing out all the quirks :)
>
> Best,
> Oliver

