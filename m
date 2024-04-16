Return-Path: <kvm+bounces-14908-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A08F8A7881
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 01:17:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F2FA41F22086
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 23:17:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8532413A890;
	Tue, 16 Apr 2024 23:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="H7YFFHmc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E34D113A3EF
	for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 23:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713309436; cv=none; b=BGWWJoNMPiWANi6qFnZItl9MudZ9LWfzi/Oa6zANy4xNMrOpXq+DRD54HtKZhJjvYUhb6bg1l6zzs7hzotbnH9kqsJYBA26T1rbf3Vfjr7u+Pzs1FVCfD1arLKMohII0mDcoIe3E+p8TFbQ1VEKB91tRTljeNNdT9Sms+t0rxS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713309436; c=relaxed/simple;
	bh=Q0XMbJFBVMCnlF4miLF84NAlOU5Vi7ZAToMbckKuqFc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=svU2jHLkedc8MeV4xWSyuAEdNUWpcyaaefEAB/FEVqpasapEQDNGQUlrUb3g1WywggAxe6QZs7l17rJ4JRkTyk409XocTHSQxDNWpg8jjxejShHH0GZWCUEAGBvQhKvRlZthvHO3oFeqKZiaZKr4e4k4Aham9frgJPN8wrl8t8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=H7YFFHmc; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-5d8bdadc79cso4582474a12.2
        for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 16:17:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713309434; x=1713914234; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NJZOibadvs2OEsulzI9JxEoFHhlL05LvXGfr+CJAFIQ=;
        b=H7YFFHmcKUuPAG+g2jRRLm/H1fV3zeqHG7sG+dUaiZdQK7AxxnoQUY17jFlhHk+SYo
         vSekPHvCB5FLGsETCOtRv9pIvo0leUwukxnoMw9kAyVpwySWUtFLWxMBvOeaW909qds7
         ANqyFS8nqZ6LrFOHAyQxv42mbYd713QY9yy9aHuXtvEpMe67o+XbNFMCacjS1gVS0RcB
         7Bafwj/5qFPJfgAFcaANe5dJmmmL3duvdYZf1Kd9anAV42rkz0uZSmADTW86fkWaEAXG
         bsNW6F5QsHWrGmo9JyEsh3Plc5/1POog5+T7c1SN2Tcv0Blj++5iYM3+MU1dhsMhcfKg
         Y0Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713309434; x=1713914234;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=NJZOibadvs2OEsulzI9JxEoFHhlL05LvXGfr+CJAFIQ=;
        b=pUDKhSgDKg5Sh1M8Q5MC3+eT+F8AOwuNbE2ndGcuCqRgmpVYxn1awUaB2PNgRipoWu
         QiXeg4WfWNu36gD/SbTSjqllYhl4fB+txFk0o2+Xb0MffkkBZVcp++sBWxVJCcoaedtU
         EGb47wO3Xx9H/uGp3auX4iHS51eOViCZWYVXvNUPbJwzvwHXg1LiZumlzhGQJbzM53Qp
         tbJnC6tbxp61MfREef2SrJwp1i29UIvns6AFmWrmxE8Yp7kcewQxTa8421QUcCyFWG8f
         cELk/Xo/i9zGp/BsoxHS8uB7+qBTcWqAIVTuCySeT1zvT3ATweEWPxcA6VfZe6qB9rvR
         K5yw==
X-Forwarded-Encrypted: i=1; AJvYcCUXaKiyWWBYhHAjFWqdLXF19HsQivszv0kV/AZGZnn4dFkLDQfz66gWHa67unZC/9IhviVla9oK2f02k91gL2Jd+ITR
X-Gm-Message-State: AOJu0YwCuLyU3byPnGeezPWwiBREAdtuMTsWrkUQouayeUICVoYPYluH
	mRQyIrKwBB3t1bni5HHLCPLLqtWhb2zhlRp6PnPKTQcN+rfDCWtn5I3HP+sLcDJgMuYC0gzVkWf
	YSw==
X-Google-Smtp-Source: AGHT+IHp7pejVqg3i6rgLYLU9z+/Hf66ejRkZz5HE3B3RCJ18ekc8L0jK7Sw+7RLg/ZBxvezt11WmCUs+3Q=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:62c2:0:b0:5f7:536a:234b with SMTP id
 m2-20020a6562c2000000b005f7536a234bmr28060pgv.4.1713309434222; Tue, 16 Apr
 2024 16:17:14 -0700 (PDT)
Date: Tue, 16 Apr 2024 16:17:12 -0700
In-Reply-To: <77fe7722-cbe9-4880-8096-e2c197c5b757@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240416204729.2541743-1-boris.ostrovsky@oracle.com>
 <c7091688-8af5-4e70-b2d7-6d0a7134dbbe@redhat.com> <66cc2113-3417-42d0-bf47-d707816cbb53@oracle.com>
 <CABgObfZ-dFnWK46pyvuaO8TKEKC5pntqa1nXm-7Cwr0rpg5a3w@mail.gmail.com> <77fe7722-cbe9-4880-8096-e2c197c5b757@oracle.com>
Message-ID: <Zh8G-AKzu0lvW2xb@google.com>
Subject: Re: [PATCH] KVM/x86: Do not clear SIPI while in SMM
From: Sean Christopherson <seanjc@google.com>
To: boris.ostrovsky@oracle.com
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 16, 2024, boris.ostrovsky@oracle.com wrote:
> (Sorry, need to resend)
>=20
> On 4/16/24 6:03 PM, Paolo Bonzini wrote:
> > On Tue, Apr 16, 2024 at 10:57=E2=80=AFPM <boris.ostrovsky@oracle.com> w=
rote:
> > > On 4/16/24 4:53 PM, Paolo Bonzini wrote:
> > > > On 4/16/24 22:47, Boris Ostrovsky wrote:
> > > > > Keeping the SIPI pending avoids this scenario.
> > > >=20
> > > > This is incorrect - it's yet another ugly legacy facet of x86, but =
we
> > > > have to live with it.  SIPI is discarded because the code is suppos=
ed
> > > > to retry it if needed ("INIT-SIPI-SIPI").
> > >=20
> > > I couldn't find in the SDM/APM a definitive statement about whether S=
IPI
> > > is supposed to be dropped.
> >=20
> > I think the manual is pretty consistent that SIPIs are never latched,
> > they're only ever used in wait-for-SIPI state.
> >=20
> > > > The sender should set a flag as early as possible in the SIPI code =
so
> > > > that it's clear that it was not received; and an extra SIPI is not =
a
> > > > problem, it will be ignored anyway and will not cause trouble if
> > > > there's a race.
> > > >=20
> > > > What is the reproducer for this?
> > >=20
> > > Hotplugging/unplugging cpus in a loop, especially if you oversubscrib=
e
> > > the guest, will get you there in 10-15 minutes.
> > >=20
> > > Typically (although I think not always) this is happening when OVMF i=
f
> > > trying to rendezvous and a processor is missing and is sent an extra =
SMI.
> >=20
> > Can you go into more detail? I wasn't even aware that OVMF's SMM
> > supported hotplug - on real hardware I think there's extra work from
> > the BMC to coordinate all SMIs across both existing and hotplugged
> > packages(*)
>=20
>=20
> It's been supported by OVMF for a couple of years (in fact, IIRC you were
> part of at least initial conversations about this, at least for the unplu=
g
> part).
>=20
> During hotplug QEMU gathers all cpus in OVMF from (I think)
> ich9_apm_ctrl_changed() and they are all waited for in
> SmmCpuRendezvous()->SmmWaitForApArrival(). Occasionally it may so happen
> that the SMI from QEMU is not delivered to a processor that was *just*
> successfully hotplugged and so it is pinged again (https://github.com/tia=
nocore/edk2/blob/fcfdbe29874320e9f876baa7afebc3fca8f4a7df/UefiCpuPkg/PiSmmC=
puDxeSmm/MpService.c#L304).
>=20
>=20
> At the same time this processor is now being brought up by kernel and is
> being sent INIT-SIPI-SIPI. If these (or at least the SIPIs) arrive after =
the
> SMI reaches the processor then that processor is not going to have a good
> day.

It's specifically SIPI that's problematic.  INIT is blocked by SMM, but lat=
ched,
and SMIs are blocked by WFS, but latched.  And AFAICT, KVM emulates all of =
those
combinations correctly.

Why is the SMI from QEMU not delivered?  That seems like the smoking gun.

