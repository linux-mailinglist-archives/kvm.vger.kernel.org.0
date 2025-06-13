Return-Path: <kvm+bounces-49531-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 229C5AD974D
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 23:25:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CCD4316A771
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 21:25:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A839128D8CB;
	Fri, 13 Jun 2025 21:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="I+P/i+yj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4345A28D83F
	for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 21:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749849941; cv=none; b=itnHM8udI5H1XgMNQzFYjTYtsveUUTYExaEMeqW0dg2YwO+2D0Foeu+8rFS0dCCMh54R1uE3dYoK8a/GiBpjvcu9a4XuvDeqap1PtXGlOSZgGM0c8x4XgrM0/7gNsVJs4GEba3N+EP8FMp5pL0CRpcp4wniQHNfQODtUt+krI+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749849941; c=relaxed/simple;
	bh=sHV8yx62yol9Bk56YKbLE0IVF5sfS+vZdmV+r8o63x0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ILUgKQ6XbmLbF/MAS1ZpPTlO9cfKmugpnLQRZgSCDe+3kQHaQCEF40Osb4VyqCe3f25c02ZF9C/tLV6i6HZ3aKkvT/krkWt1x4377cNdXfqjdGyrhVAdUlXWDJRUjUolx0uG3fDHD3PUZ5Do8vKGpVoi+pmoJLfb7ZMfNCm1aiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=I+P/i+yj; arc=none smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-4a5ac8fae12so114081cf.0
        for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 14:25:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749849939; x=1750454739; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TPUzIppHcu65DcXjx+xmQ4p2o7TM+1lbGXLpXn/D90M=;
        b=I+P/i+yjFwiAoPxoTgsLZdfFg8675RXWd3N3Md6glKsbKl4lvRtve5J0ZIuEaau554
         UKda9Hl/lIcu6s6TXwx1TSrSSrz0g6+2Q9Rs6DJ7S8teVdvnfdT9QMjW9CbtMEpHRRbd
         j6g8yktMlwMwLf2fpmUKuIF0ivDJdJtw9WBdJZd6c0ZDo9BvPcrX5fONn3sA3pkO2dXQ
         FXgdpCc1kXmxz5zi5fQYAinoBaY5s1lBxDO7OkrsWCO7jKHWvAljQyFmsI2dQFNLqofn
         G9Xb2I8IhglbdKiaDaJxnWzG6ruENsoJERAej4g/XSf7628bPMJ3BMsqiOSUnksUbFvo
         Wn7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749849939; x=1750454739;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TPUzIppHcu65DcXjx+xmQ4p2o7TM+1lbGXLpXn/D90M=;
        b=PO2NZZv/w7UPk2cFFCfypYJCWqIxl1uLqRFxdJK+9siRQYdES3VaK1H6dO6oRUE5lN
         5wcFsoOaWzQ4C4J0rgdY8B74uqJB6hYkwe3Nq1xdH9wfQj29D64eV9657jQ6dbyFMGoK
         g6u2xDN/tHZjOkpswDrhs+PlNopcMHdVeuRCoXAi1Bx+6bHLGYVOo7vwTMCbZvurtCtj
         +zmoP3ZXaa4euAczyVTP3YNIih6y8l31vbUxmGDUx/JAfCl71xUQ+1zJREKXZsAqM4z6
         pyaPcxn7ihEtJTrrZwAf5b6kPKXczCQEfrr5kn7qhk2gFSl4XuA31FduQIl6LUoL94np
         BuPA==
X-Forwarded-Encrypted: i=1; AJvYcCXoRCddrQEWPN6lKb9S3veJ2C7TDtkRdbfr/ARS5GJchmaM94JAoxVBZyVjO1t5KKNL1sA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz9oVOKc5137/6BE4IKu9XKrkYr+BThI8d8nks0xb7TL/XLr0Oj
	cm2u0KFLHcMrOl3tfS5rVg2TL+KKx8SE+VpEPTK7ojTpHURB5n7KCrKRADMqv4XIWmu2UGmTxwp
	mXNj3ako+M1oJ2WQlge3Z3g74qfz7rKmN48sQkjsWZ+GbujBCdkqJwkkz
X-Gm-Gg: ASbGncumV5qebs5hsMRi/96XONofRUGG43FhgU5aAGuzM5hnpR8uIQuxlWELKHNBwwL
	P8DYLn+0bSmITR4YiTxnacnw+ERikz8KkW717EnI2LqC6GvPkuZ2zMkEgsygEnQR1eu5vLbxEjz
	gH0KfvHdfnWLq17/lgw8WPBg2yitMUJiwvIWVHAO2mxtMMHTM66ZkfXw==
X-Google-Smtp-Source: AGHT+IHRTXKzQVq2KTm0RSt5qVgrnPAP0bkIbd607Uu6/KmOUX6+sJKqoHDdBmms0U0ufq7rNkEH/UqGIKX1Oa8Sr14=
X-Received: by 2002:a05:622a:610d:b0:498:e884:7ca9 with SMTP id
 d75a77b69052e-4a73da5803emr310651cf.13.1749849938737; Fri, 13 Jun 2025
 14:25:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250613155239.2029059-1-rananta@google.com> <aEyPswyvfJ2-oC3l@linux.dev>
In-Reply-To: <aEyPswyvfJ2-oC3l@linux.dev>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Fri, 13 Jun 2025 14:25:26 -0700
X-Gm-Features: AX0GCFvCkuSdtDxaxbaw03np7924c6ya2dvq2vPeL3lenyiqTkrCE5acxgbNPCk
Message-ID: <CAJHc60yacW7-1K3Uw9RT7a8qH9JyTXouiP=6VP3gifqzHgMaQQ@mail.gmail.com>
Subject: Re: [PATCH v3 0/4] KVM: arm64: Add attribute to control GICD_TYPER2.nASSGIcap
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Mingwei Zhang <mizhang@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 13, 2025 at 1:53=E2=80=AFPM Oliver Upton <oliver.upton@linux.de=
v> wrote:
>
> On Fri, Jun 13, 2025 at 03:52:34PM +0000, Raghavendra Rao Ananta wrote:
> > A shortcoming of the GIC architecture is that there's an absolute limit=
 on
> > the number of vPEs that can be tracked by the ITS. It is possible that
> > an operator is running a mix of VMs on a system, only wanting to provid=
e
> > a specific class of VMs with hardware interrupt injection support.
> >
> > The series introduces KVM_DEV_ARM_VGIC_FEATURE_nASSGIcap vGIC attribute=
 to allow
> > the userspace to control GICD_TYPER2.nASSGIcap (GICv4.1) on a per-VM ba=
sis.
> >
> > v1: https://lore.kernel.org/kvmarm/20250514192159.1751538-1-rananta@goo=
gle.com/
> >
> > v1 -> v2: https://lore.kernel.org/all/20250531012545.709887-1-oliver.up=
ton@linux.dev/
> >  - Drop all use of GICv4 in the UAPI and KVM-internal helpers in favor
> >    of nASSGIcap. This changes things around to model a guest feature,
> >    not a host feature.
> >
> >  - Consolidate UAPI into a single attribute and expect userspace to use
> >    to read the attribute for discovery, much like we do with the ID
> >    registers
> >
> >  - Squash documentation together with implementation
> >
> >  - Clean up maintenance IRQ attribute handling, which I ran into as par=
t
> >    of reviewing this series
> >
> > v2 -> v3:
> >  - Update checks in vgic-v3.c and vgic-v4.c to also include nASSGIcap (=
via
> >    vgic_supports_direct_sgis()) that's configured by the userspace. (Ol=
iver)
> >
> > Oliver Upton (2):
> >   KVM: arm64: Disambiguate support for vSGIs v. vLPIs
> >   KVM: arm64: vgic-v3: Consolidate MAINT_IRQ handling
>
> Make sure you run checkpatch next time before sending out, it should've
> warned you about sending patches w/o including your SOB.
>
Hmm, I do run checkpatch before sending, but I don't see any warning as suc=
h.

Example:
$ ./scripts/checkpatch.pl
v3-0001-KVM-arm64-Disambiguate-support-for-vSGIs-v.-vLPIs.patch
total: 0 errors, 0 warnings, 107 lines checked

v3-0001-KVM-arm64-Disambiguate-support-for-vSGIs-v.-vLPIs.patch has no
obvious style problems and is ready for submission.

I do see an option to tell the script to ignore the check:
--no-signoff, so I'm guessing it should check by default? Or is there
any other option?

Thank you.
Raghavendra

