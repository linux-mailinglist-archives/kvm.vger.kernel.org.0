Return-Path: <kvm+bounces-63695-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id F32C8C6E0AC
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 11:46:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id C2AA94E9107
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 10:38:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C4A334D924;
	Wed, 19 Nov 2025 10:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SYoy/uJG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA223347FFA
	for <kvm@vger.kernel.org>; Wed, 19 Nov 2025 10:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763548699; cv=none; b=lRE4abD6IzmrcFFnNjUN4XvMnkjA+b8dfrLr0NmcDEjeNQqhIAELB4PWs9GDNV2lrynhSwQh/NUciAq19jpgREEOqrt8pM1bcnLCR0LeJnTtk212n9qg7/RMReLc4+KlP9VdQkVyhoPm+/ktt2nZYj/DBf5paMnBQoPso4CYWVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763548699; c=relaxed/simple;
	bh=qWJmc0Xb6IbyOw8w8OA9A8sY8tyZ294+v84mJLscPjU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BiboorSPvo4qxlInrsZ10oRwdc0A2cnjD+IRJIgfWh6krynurkIl0Z716eLi+9RGxo7j1VPFM1yOP9hnm4jSRirkXpA4JCSfFxyQ89BZsTHD3sWVjWISaDfFpxfv/kEo4n9X4BnThhqSTliRT+Ay2ub01ENAXc67KQJ6LKBD/sM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SYoy/uJG; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4edb8d6e98aso318721cf.0
        for <kvm@vger.kernel.org>; Wed, 19 Nov 2025 02:38:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763548697; x=1764153497; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ajPJXKSb6EvakAv/OuhuRvH8YRFIbHznazB/0gEJ+2M=;
        b=SYoy/uJGNFg97q//gi107l7bEebyW+GxrjNsAtH50NjBo3JlJVTOQV4T6n8Zg9MGrS
         z3qAlc1N5pNd76AC+Q76C+dBQRxmFnUiEy2FPHr1aHz5bINIoHQIj/i9XiEBERqnhgYa
         GZC/4xddHIekpKFagJ5aVn9uqIV66UhPw/FcP8tB/3EYCno8QWV/W95Qn5rZTeDMz+Oy
         +SKoy8s+00J0xpWW80bRF4IVibqSx65gtxS8a4rosKoABOGIzeOLMhx8FQnTLFwhb8Z1
         oPqSluHy4IlyDaCXdCDNwZ3IHblvvSGJFGbGpFSfBfEkUdlmOOrgNDpZ+UHoN7SeBPMp
         rpkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763548697; x=1764153497;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ajPJXKSb6EvakAv/OuhuRvH8YRFIbHznazB/0gEJ+2M=;
        b=cgDhdOef5J4Q8AT/Q469u0mn1QKMoQl0Wj66QjE/wjOfqJoR92W3o2gSf1jGBdKm9F
         LdFNhPsBvKBZEVtdEmMhUjvHj3QtmDc24ysHwTCvhtm8z5kamJc4rcl1o8g4uVKLI5x1
         yhugemjnJHwpflE1eAIciAehBB/II0BDhc/kVNwOzNoIvK6DldyjJwTM+rlhXb3Jh/Tk
         cuU61UqTQiKmPlv7/dn+NRnQFmUO9fBmPUfuCqM/jzLfJU5JkNuwhbUZ1aE3Yg0KWqT/
         FQNOgn+p1+NEaK5JrYGE2LTAVo2oSaNnAPTeEu9JrAny35NUvxJfFFmnIsIl5gwihskf
         4sCQ==
X-Forwarded-Encrypted: i=1; AJvYcCUTFFmWoR7C4gSxIC6lBvomkayqL78LfZE40NgJY2Aw7+Q2GSSMWGyXUJwTgwBi1CS5paI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyNLGaLRaz0ThN3JpK5b6tWckBLD4ZxCMMIdJz4sB7W0E3eyek2
	jT4+TvGtZx4TsdfUmSZ1AFCsap9Di8bkMpSIqnr+u7gbaGeldW5rQcBeG1VMGxI3kIN9nHoKfjG
	v6nZj9cImqTb1s8IprSH26VQCaoge+Iq/0GT846ke
X-Gm-Gg: ASbGncsaRxug3tXG7jSy5yGflV1H95akEKXE3qXz46xR4YP+cX4imXWLezV+RuWxnZd
	/xwqG/c97Ie06XkHct1abhP76aD6v0VZam8Cw+pkqxeYDVq8OFGQziDa3+4tnWq7+0P0TKYDuc0
	4v+vCGJknL1LGoKeOWX0chHv3nZ6DuXCJLAk0A+BLWwBX709Ah6SsRM1azebt1TyoGBZVDAcRF+
	yPbdjdvwJu4hJgXvlZt6DXYz1OP/4gvUFPgVnjRK3AjHd+lJLBTOqKXKYBRAInG8vog4OH4Gp6M
	cbIcB/hL8kVlaSM5v1v2UtYiSlOSg078ClA=
X-Google-Smtp-Source: AGHT+IHyZj1mHlRoqcMVEK+Ke9v+QKN/GTCdvCboTV8ytrHFav/L7x1i8RWg43NziKnKMj+gWGYsCAB6fcyxt7vblr4=
X-Received: by 2002:a05:622a:1b88:b0:4ed:18ef:4060 with SMTP id
 d75a77b69052e-4ee3ec3080cmr5005131cf.8.1763548696534; Wed, 19 Nov 2025
 02:38:16 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251117091527.1119213-1-maz@kernel.org> <aRweUM4O71ecPvVr@kernel.org>
 <CA+EHjTzJQOTTSUoXVKpGdWO8vz9Vc-2AL3zRyzG4DkUPz+wBBQ@mail.gmail.com> <86ms4jrwhr.wl-maz@kernel.org>
In-Reply-To: <86ms4jrwhr.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 19 Nov 2025 10:37:39 +0000
X-Gm-Features: AWmQ_bnZDu_VkCPXAw-nz27IkT05jj1DSam5-p8uzswdO8xX2NqMq69pMVBt_H4
Message-ID: <CA+EHjTyiM+BNP+iRTYP7968np=y0+Vn38GtAfiTtg=JcUzjPpQ@mail.gmail.com>
Subject: Re: [PATCH v3 0/5] KVM: arm64: Add LR overflow infrastructure (the
 dregs, the bad and the ugly)
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Christoffer Dall <christoffer.dall@arm.com>, 
	Mark Brown <broonie@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

On Tue, 18 Nov 2025 at 19:06, Marc Zyngier <maz@kernel.org> wrote:
>
> Hi Fuad,
>
> On Tue, 18 Nov 2025 13:59:14 +0000,
> Fuad Tabba <tabba@google.com> wrote:
> >
> > On Tue, 18 Nov 2025 at 07:20, Oliver Upton <oupton@kernel.org> wrote:
> > >
> > > On Mon, Nov 17, 2025 at 09:15:22AM +0000, Marc Zyngier wrote:
> > > > This is a follow-up to the original series [1] (and fixes [2][3])
> > > > with a bunch of bug-fixes and improvements. At least one patch has
> > > > already been posted, but I thought I might repost it as part of a
> > > > series, since I accumulated more stuff:
> > > >
> > > > - The first patch addresses Mark's observation that the no-vgic-v3
> > > >   test has been broken once more. At some point, we'll have to retire
> > > >   that functionality, because even if we keep fixing the SR handling,
> > > >   nobody tests the actual interrupt state exposure to userspace, which
> > > >   I'm pretty sure has badly been broken for at least 5 years.
> > > >
> > > > - The second one addresses a report from Fuad that on QEMU,
> > > >   ICH_HCR_EL2.TDIR traps ICC_DIR_EL1 on top of ICV_DIR_EL1, leading to
> > > >   the host exploding on deactivating an interrupt. This behaviour is
> > > >   allowed by the spec, so make sure we clear all trap bits
> > > >
> > > > - Running vgic_irq in an L1 guest (the test being an L2) results in a
> > > >   MI storm on the host, as the state synchronisation is done at the
> > > >   wrong place, much like it was on the non-NV path before it was
> > > >   reworked. Apply the same methods to the NV code, and enjoy much
> > > >   better MI emulation, now tested all the way into an L3.
> > > >
> > > > - Nuke a small leftover from previous rework.
> > > >
> > > > - Force a read-back of ICH_MISR_EL2 when disabling the vgic, so that
> > > >   the trap prevents too many spurious MIs in an L1 guest, as the write
> > > >   to ICH_HCR_EL2 does exactly nothing on its own when running under
> > > >   FEAT_NV2.
> > > >
> > > > Oliver: this is starting to be a large series of fixes on top of the
> > > > existing series, plus the two patches you have already added. I'd be
> > > > happy to respin a full v4 with the fixes squashed into their original
> > > > patches. On the other hand, if you want to see the history in its full
> > > > glory, that also works for me.
> > >
> > > I'll pick up these patches in a moment but at this point I'd prefer a
> > > clean history. Plan is to send out the 6.19 pull sometime next week so
> > > any time before then would be great for v4.
> >
> > I'm happy to take that for another spin Marc before you send it, if
> > it's different from the ToT I tested. In that case, just send me a
> > pointer to the branch.
>
> I've just pushed out a full branch at [1]. Please make sure to merge
> kvmarm-fixes-6.18-3 in, as it fixes a couple of nasties (small
> conflict expected, but the resolution should be obvious).

For this branch [1]:
Tested-by: Fuad Tabba <tabba@google.com>

On QEMU, nVHE, hVHE protected mode (non-protected VMs with and without
the Android pKVM patches), and protected VMs (with the Android pKVM
patches).

Cheers,
/fuad



> For my own testing, I added -rc6 on top.
>
> Note that I didn't take your Tested-by: tags, as you are about to
> retest the whole thing anyway. If all goes well (fingers crossed),
> Oliver will be able to apply any further tag once I post these
> patches.
>
> Thanks,
>
>         M.
>
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=kvm-arm64/vgic-lr-overflow
>
> --
> Without deviation from the norm, progress is not possible.

