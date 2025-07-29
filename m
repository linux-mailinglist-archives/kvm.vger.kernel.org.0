Return-Path: <kvm+bounces-53661-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 72FD0B152DA
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 20:33:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DA45716B343
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 18:33:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 759F923B629;
	Tue, 29 Jul 2025 18:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qD2NuYn5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E779E1A0B08
	for <kvm@vger.kernel.org>; Tue, 29 Jul 2025 18:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753814017; cv=none; b=l5rRDVoQtwia84Z9rivexIYlU9He8b4O8LxJFLMIJcErSMCkqjTZjV/hUxX3G9xfor93XeIy0ddHHhUpDf7RjrbEeNCE/HmOQM+06BfLolmzJ+TI6g7ZWujm0WEUGZidBqBE5T9p0cAt9rhPAbCFYMdAvKjMnN1yqLWb59cv6b4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753814017; c=relaxed/simple;
	bh=zhhsN1AqU60iSsHthAP5HUoMBvOnju18nFxPG9F76EM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=s6avxPYvTwzFkhMoGqUxZzMwePckldyBA4s136cnWVE7iBMi3mruYm7XWA9bkrnS2gDkuzWg+eDTD28c8qB7NbVMD8by+XtclOghzbC7sNBCJ5Fc3DkrugfVis7EBSXxlS4wfdbBI0GNuw4sCmvDAnRwGkwWgYvztU2ttg5RxvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qD2NuYn5; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4562b2d98bcso7285e9.1
        for <kvm@vger.kernel.org>; Tue, 29 Jul 2025 11:33:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753814014; x=1754418814; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7IB94kLTsbGsiDgptDqLFiCExxMxuJKtjoAOZzmwaM4=;
        b=qD2NuYn5ukpw1lRu+hfpW6YZ1vrrabjONtMt17EZwCHvEv+dx/KrHNrhiSEXWMFVZu
         dXySqlfOsXIfVQBveYbHi6ZkD6MgkmcDX9+IpTTAiq/WcZRe8w88Qb0ojJLPnfVta/f/
         oupNmSJiNajruIxiqYEtjKXu4Y+pypIgWbsWVjyfxabcLJPikWP+mHoZd5JESQg7qaTf
         FT+3+OWCVcRX0EbcMUysN7618Pl0WfMJtzpr2XMr7j0MugZt2cpcsq3V53HDUDcp1OnS
         u1WgTZfn7WZEnULwrLghklsuYLh8OPUMat0RrWtrAmfBQjpF1IxJmpXVxZp1EayjEF7H
         1zEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753814014; x=1754418814;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7IB94kLTsbGsiDgptDqLFiCExxMxuJKtjoAOZzmwaM4=;
        b=WgMnTjPd4rlVc+RT+xE2ID8sz9IgRqZP4HMCuCvog/tGN0EfW1xLOmpzH8uWj37XoF
         PWXs/gDbKNaK47vA3IrS5cYhbTU1AgOoeTc3vr86tn4v6cY7R0AmQ/G0HKPN1m3gxzqo
         vaf5Zllk2xeNnhJoBVggWRFKHqqgfyMLRwKIEIDaEA2HV9ySPwiEZdZSU1CiyloAVCP6
         FmAR8JENJ8VFEPkhy0NsANSM+z4CVJQhFR+ybreHOkIR0duu/YyrE8tazj+E8RWMXjmL
         ttcTAUUl7Khob0sTrKzXWpGBje4Kq4OVEO8XSVeXGRk2VTyX06Ckg1m/RS/S04FT81/j
         yLvQ==
X-Forwarded-Encrypted: i=1; AJvYcCXBoMkWOkQj+HD4Y+k3OG6wf4Ohdb2r/wTwBdjr1CT351aBT9C0NKXqixR7N5j5Clq7ARM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwP3w5vjYW9ODh7MqNhHUb7qPkxPfj2h7PBIaExZO03ziFsoder
	ZagQHZNVmXK4hkoBftXEVG2tFfE08Hm+V0+8ghQAQu44cLLxABz7aDpFN8iGuQaw8+lAFCoV1nV
	Wi0bEmu1Kfue/sfDGqQC8CPdk2OZ6H0QlDSmEdsKkFSIISYexIiWGOOqd
X-Gm-Gg: ASbGncsbzrVdsgaXb9X9DxYqQC7SLu8o3qp+SeDyeCHld9FxrScpaqj6FUlGi79JFnY
	7z/rgROdwK58swI4C1i1vZ6WykYsxZsWQkFRT9zmv8CRJlB2J/ibzJqONvuOIAR9E3idtuWaECa
	JSsiGVKkupt4SUbWpahB9K+7qJHuLOSnpTB9NExRjwokzwOBAOxLxn0UWrkpwph4QSUYYmTXhKm
	yyOz3dzNVSZoD07kZQpQpjzBWaYQCRBMhnDLQ==
X-Google-Smtp-Source: AGHT+IGKAkWetZ1FvQ3c2TR9sQ5wbErOwg/m1YLthxVSeCgARrfvYFD3xx1XvoVEZiCGve6ALl+xhDJWyNwcPNrcTPo=
X-Received: by 2002:a05:600c:859c:b0:453:5ffb:e007 with SMTP id
 5b1f17b1804b1-45893a9b7f3mr63305e9.4.1753814013998; Tue, 29 Jul 2025 11:33:33
 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CACw3F53VTDQeUbj3C75pkjz=iehbFCqbrTjYbUC3ViUbQJAhsg@mail.gmail.com>
 <CACw3F50O9Z=hPFNzeatzr2k+1cKX_nnqdzKJOMEdmjmfy3LoUg@mail.gmail.com> <18df01493fee0547d8b5902b986a2334@misterjones.org>
In-Reply-To: <18df01493fee0547d8b5902b986a2334@misterjones.org>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Tue, 29 Jul 2025 11:33:22 -0700
X-Gm-Features: Ac12FXyam7bjtry9Vixp29M5W0s0neJG-QDbW5LkEpRdu8HEgX8jGbg9nB_4Esc
Message-ID: <CACw3F53j60QSz=D0HozuazCSaKoOWmODZuydC8152rdxT-fRAQ@mail.gmail.com>
Subject: Re: [Bug Report] external_aborts failure related to efa1368ba9f4
 ("KVM: arm64: Commit exceptions from KVM_SET_VCPU_EVENTS immediately")
To: Marc Zyngier <maz@misterjones.org>
Cc: Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

That commit fixed my issue, thanks a lot Marc!

On Sat, Jul 26, 2025 at 2:18=E2=80=AFAM Marc Zyngier <maz@misterjones.org> =
wrote:
>
> On 2025-07-25 23:38, Jiaqi Yan wrote:
> > On Mon, Jul 21, 2025 at 7:00=E2=80=AFAM Jiaqi Yan <jiaqiyan@google.com>=
 wrote:
> >>
> >> Hi Oliver,
> >>
> >> I was doing some SEA injection dev work and found
> >> tools/testing/selftests/kvm/arm64/external_aborts.c is failing at the
> >> head of my locally-tracked kvmarm/next, commit 811ec70dcf9cc ("Merge
> >> branch 'kvm-arm64/config-masks' into kvmarm/next"):
> >>
> >> vobeb33:/export/hda3/tmp/yjq# ./external_aborts
> >> Random seed: 0x6b8b4567
> >> test_mmio_abort <=3D fail
> >> =3D=3D=3D=3D Test Assertion Failure =3D=3D=3D=3D
> >>   arm64/external_aborts.c:19: regs->pc =3D=3D expected_abort_pc
> >>   pid=3D25675 tid=3D25675 errno=3D4 - Interrupted system call
> >>   (stack trace empty)
> >>   0x0 !=3D 0x21ed20 (regs->pc !=3D expected_abort_pc)
> >> vobeb33:/export/hda3/tmp/yjq#
> >> vobeb33:/export/hda3/tmp/yjq#
> >> vobeb33:/export/hda3/tmp/yjq# ./external_aborts
> >> Random seed: 0x6b8b4567
> >> test_mmio_nisv       <=3D pass
> >> test_mmio_nisv_abort <=3Dfail
> >> =3D=3D=3D=3D Test Assertion Failure =3D=3D=3D=3D
> >>   arm64/external_aborts.c:19: regs->pc =3D=3D expected_abort_pc
> >>   pid=3D26153 tid=3D26153 errno=3D4 - Interrupted system call
> >>   (stack trace empty)
> >>   0x0 !=3D 0x21eb18 (regs->pc !=3D expected_abort_pc)
> >>
> >> It looks like the PC in the guest register is lost / polluted. I only
> >> tested test_mmio_abort (fail), test_mmio_nisv (pass), and
> >> test_mmio_nisv_abort (fail), but from reading the code of
> >> test_mmio_nisv vs test_mmio_nisv_abort, I guess test failure is
> >> probably due to some bug in the code kvm injects SEA into guest.
> >>
> >> If I revert a single commit efa1368ba9f4 ("KVM: arm64: Commit
> >> exceptions from KVM_SET_VCPU_EVENTS immediately"), all tests in
> >> tools/testing/selftests/kvm/arm64/external_aborts.c pass. I have not
> >> yet figured out the bug tho. Want to report since you are the author
> >> maybe you can (or already) spot something.
> >
> > Friendly ping ;)
>
> Please check this:
>
> https://web.git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git/com=
mit/?h=3Dnext&id=3Dc6e35dff58d348c1a9489e9b3b62b3721e62631d
>
>          M.
> --
> Who you jivin' with that Cosmik Debris?

