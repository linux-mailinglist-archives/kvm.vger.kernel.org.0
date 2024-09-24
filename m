Return-Path: <kvm+bounces-27392-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 59533984E2C
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 00:52:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F28411F24E57
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2024 22:52:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9815E178362;
	Tue, 24 Sep 2024 22:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l3hmnn1V"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42CA11459F7
	for <kvm@vger.kernel.org>; Tue, 24 Sep 2024 22:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727218369; cv=none; b=Ps4Dg5bOJ5Jtbel6m46RGiyEAXFgJDR7EuqLimrbDONkCPsLzhYNx3x4lMKYrdaHMk9hpw1hh9ocmsCaztqtVwxqWTRPN9WbG3UVF9EXgnvjwrUC7D7p8bpG3FjK3i6/eSfbsDisj1wbKh0ElhZrkv1uiSf8z9Q8MaLJ5ioL1Lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727218369; c=relaxed/simple;
	bh=DG6xrNPym56aK8LAKmxMfrGHarHScAF79oavhZ2Vtmk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NIF6YjWcuFFEfzmOzgPfn2H7nXYWsSwEXnG21HshbognE8wEksDoCy80x8bVkaBNkJpkW8NOoyLMNFXpt7VtS5KqryAJ4kkACV5e1XytEctzlSyzemrEsJQGWTHFjPcALxRsUzGLNoDppaFKM40mkBdY/eZUiZ+ZwpWTgrXXQfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=l3hmnn1V; arc=none smtp.client-ip=209.85.208.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-2f74e613a10so93114971fa.1
        for <kvm@vger.kernel.org>; Tue, 24 Sep 2024 15:52:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727218366; x=1727823166; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=DG6xrNPym56aK8LAKmxMfrGHarHScAF79oavhZ2Vtmk=;
        b=l3hmnn1Vjb/9svDJ0M4WFyKFccoLProogoJuPvSKCZ8FM2HI6MoX0mgGsFBgagWS0Z
         iV/jeDGISGgiGnGaNy8zVEJsbrRKgOdQpvVG+xKdndcuM6CWzR+Td0n/iQVTB5V0oBR1
         DJh5AwT2jbJ7R+GM4kaXIBvQz/08a0fQktCdhSBt7buWCBmeh/Pxmy61dZmCgULTunws
         3mumqWN9NcKGxuejgBMqjhAvcpviWbioVijOEkwGKBHBiWihfpmwG7eiVHCNuPE74i+z
         +ATrU/SOTPbqBwURVVLXmwb+DAYgycLFoviyOUOHHiCGl/J3sadXcplTqczlSgZXlKFy
         c4rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727218366; x=1727823166;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DG6xrNPym56aK8LAKmxMfrGHarHScAF79oavhZ2Vtmk=;
        b=h3Ou+1b/BXg2tvTukcHtags+Q2c2iocg+1wlQ2Oxhvql0eo7I6yoGDJnV+jgUo10Zu
         WRXMlNeq23aAQs4a7SF02xD5+mX6UWlMleUrc9jvwnV3krNgXZUCfAaflQNZqWuPRcog
         bYHnkB40hCtCHoWQrxZPwcrBtzDopWk0hjLsrIrg1O1Hq759L0cKHndb04LqVwcxVPUY
         Uygogp9+4xcFFxhHc+8qw/wPKMoko88OL70EHPRmGprGhvyuRuysGujXxOaqKBwV4pEM
         hQjrNb+mEyubXy/nlGpBX4G2YKuflIGrVSZyuGFH287C0cwXmfCEPhBGrUYUOzQUbEmJ
         OEKA==
X-Forwarded-Encrypted: i=1; AJvYcCWNasZbnu5bBOA02ey5cLTPPw5NC4lrYDjxv+sYH7J5mgED65Sb5EewOrkjwhgOdpuW0+0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzW01GoKN/SDKl6Q0J7ZY5Fp9bf7swzKBZVMLWAD6T56h5WSrk/
	IokYeaL2AcvZY2hGLXsGj4ve9SZrQoSL/9mm9lvwkHxtnha+n2772XiKRfDKFgvWSvt5TMLoK6T
	FODVZ2HikNWqFllCxlhgng1eT1Yo=
X-Google-Smtp-Source: AGHT+IHehfdQqVpDfskG5qXL6TYOLMF3UxYA7HT7uW2SOYu3NMSBWbS/7HpJB2G+T4wMgezitrxjqDunEmdwKZ7hbkc=
X-Received: by 2002:a2e:4a02:0:b0:2f7:c7f3:1d2e with SMTP id
 38308e7fff4ca-2f915ff7e2cmr5896861fa.19.1727218365822; Tue, 24 Sep 2024
 15:52:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240922124951.1946072-1-zhiw@nvidia.com> <ZvErg51xH32b8iW6@pollux>
 <20240923150140.GB9417@nvidia.com> <ZvHwzzp2F71W8TAs@pollux.localdomain>
 <20240924164151.GJ9417@nvidia.com> <ZvMZisyZFO888N0E@cassiopeiae>
In-Reply-To: <ZvMZisyZFO888N0E@cassiopeiae>
From: Dave Airlie <airlied@gmail.com>
Date: Wed, 25 Sep 2024 08:52:32 +1000
Message-ID: <CAPM=9twKGFV8SA165QufaGUev0tnuHABAi0TMvDQSfa7PJfZaQ@mail.gmail.com>
Subject: Re: [RFC 00/29] Introduce NVIDIA GPU Virtualization (vGPU) Support
To: Danilo Krummrich <dakr@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>, Zhi Wang <zhiw@nvidia.com>, kvm@vger.kernel.org, 
	nouveau@lists.freedesktop.org, alex.williamson@redhat.com, 
	kevin.tian@intel.com, daniel@ffwll.ch, acurrid@nvidia.com, cjia@nvidia.com, 
	smitra@nvidia.com, ankita@nvidia.com, aniketa@nvidia.com, 
	kwankhede@nvidia.com, targupta@nvidia.com, zhiwang@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 25 Sept 2024 at 05:57, Danilo Krummrich <dakr@kernel.org> wrote:
>
> On Tue, Sep 24, 2024 at 01:41:51PM -0300, Jason Gunthorpe wrote:
> > On Tue, Sep 24, 2024 at 12:50:55AM +0200, Danilo Krummrich wrote:
> >
> > > > From the VFIO side I would like to see something like this merged in
> > > > nearish future as it would bring a previously out of tree approach to
> > > > be fully intree using our modern infrastructure. This is a big win for
> > > > the VFIO world.
> > > >
> > > > As a commercial product this will be backported extensively to many
> > > > old kernels and that is harder/impossible if it isn't exclusively in
> > > > C. So, I think nova needs to co-exist in some way.
> > >
> > > We'll surely not support two drivers for the same thing in the long term,
> > > neither does it make sense, nor is it sustainable.
> >
> > What is being done here is the normal correct kernel thing to
> > do. Refactor the shared core code into a module and stick higher level
> > stuff on top of it. Ideally Nova/Nouveau would exist as peers
> > implementing DRM subsystem on this shared core infrastructure. We've
> > done this sort of thing before in other places in the kernel. It has
> > been proven to work well.
>
> So, that's where you have the wrong understanding of what we're working on: You
> seem to think that Nova is just another DRM subsystem layer on top of the NVKM
> parts (what you call the core driver) of Nouveau.
>
> But the whole point of Nova is to replace the NVKM parts of Nouveau, since
> that's where the problems we want to solve reside in.

Just to re-emphasise for Jason who might not be as across this stuff,

NVKM replacement with rust is the main reason for the nova project,
100% the driving force for nova is the unstable NVIDIA firmware API.
The ability to use rust proc-macros to hide the NVIDIA instability
instead of trying to do it in C by either generators or abusing C
macros (which I don't think are sufficient).

The lower level nvkm driver needs to start being in rust before we can
add support for newer stuff.

Now there is possibly some scope about evolving the rust pieces in it
as, rust wrapped in C APIs to make things easier for backports or
avoid some pitfalls, but that is a discussion that we need to have
here.

I think the idea of a nova drm and nova core driver architecture is
acceptable to most of us, but long term trying to main a nouveau based
nvkm is definitely not acceptable due to the unstable firmware APIs.

Dave.

