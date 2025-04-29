Return-Path: <kvm+bounces-44684-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D764AA0223
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 07:55:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0181B16EE6A
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 05:55:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9BA6270ECD;
	Tue, 29 Apr 2025 05:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="O6C4ba0w"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2998A26F469
	for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 05:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745906149; cv=none; b=c9V2R940vgyofaNIpTaEGyK7CZsrXBYsUEGe9ZJ4vcGUI3QgHpFRVjfbp6zzKGNdgWaeDsPbcAP7yUNc2CrRuCmr+03MC1FcTXFxMyKJXzwOPuBf6ib4yhM8vFu6v78E5fMA2DQM6IQb8KFvA54gwFaAlAV96VnqZEnu1+7i2Ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745906149; c=relaxed/simple;
	bh=1kDrlm/fhAKr9mj0zuBg0xIvCaUDFqvgW/xklUwgSOc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gcJWsk/V9yAP0xFLwtADb45RhSEB/4fn8HPC3K4tzUv1Z/3Bpp0S7bGyQN7PdlCWhXqMCgaH4GgFxISOMqjdNimvrQqVOCTzgRi+qBWzr46pnM3vOKsuJ6mYSvNCTSHmFfnCqEy3UxBOLG2+T40NPrCwF28PMlBH/mjOZz77jYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=O6C4ba0w; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-54afb5fcebaso6786124e87.3
        for <kvm@vger.kernel.org>; Mon, 28 Apr 2025 22:55:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1745906146; x=1746510946; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d8eFfmotZuLjE/iIngsJ3KVYn6Hy+g0+LpOOBN4vUMQ=;
        b=O6C4ba0wjnoZwXtiuE7xcR4ETzqGDW+kywyqywRKpHJqqRzJXl1xBnjpTASwj/DkEy
         Ash4Z7qH+3dn7cGXHdRoLYNLDR3d58uloQ/BjyIifWCTJ+JUrOnDlvP5OcMJTHbEKXsb
         WaZzzHvnOmy7h4/G8XuoIX+I43pqADRvrB9b33bEnnWLmn545EkLeU2t9Hqh+ww2CAhW
         d6KRwHM/RLM4ROQ+iEVU89QIjw1xJbi/on+snY1cS/wpqpmlGI205jGvv8F4SumOt3pr
         RoEHQczBBOzYdtXQJjxjOZTSCA0wYp2TE/0fO9C5KhkshDBECP0tN1GQWHRZEdvhOWIr
         pM2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745906146; x=1746510946;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d8eFfmotZuLjE/iIngsJ3KVYn6Hy+g0+LpOOBN4vUMQ=;
        b=gz+0WmmJtm0cWjbj++qYVWw+cNlBysKA7rkHejM+tgYrPKpbwYm26NFY1Vf+GpBIwm
         fim+oEKi1/gKt7wAuy4xo9bz2pdtv4FOT2+afLkVL8PA8ZGJoUFnsnSYzP7ipDw/ZVYf
         3cgR4Md13XyD7EEOceE235TlEQVe0vViBKfDbiAk6MeKV2LNXrrq6VWzeLRJ7+luMKfn
         y31txg5D2jCd6UyYrgtKaszbYKE/blsmTKE68ysSvPgxYXOnQPWE8MkVPfByktuzjnrW
         odopbqKUPVgOVYZY3saTY/lyQM5uK4B3S2KhGzvq+IxY+fF4j88pgpIqRGQlBjZAiI9s
         ogtg==
X-Forwarded-Encrypted: i=1; AJvYcCUdIkp5AcGnD6LxOH30ZH2twuY+pSoa6UsGsURgGocrgKq5rlhC4TuS6e7dn5GKA70cXDo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwVLAPG00lSmvH+dFIW3euFkKV23jLY5SP0h+ML2Rhe5D/UR5m8
	Iy000Gu+Xb97dtzYoDHUikE02SHNNN5OdrE1+hhXrJWzXwLDRMAR6NHE0VeY18+A/42tHeYCB2z
	umFWMMI/AaZm8d5HsxvKIiipYtWmTMfz+4GskxA==
X-Gm-Gg: ASbGncvB9ZdAAnJuIY2NDG2SR+/R/JjSMEPgMMYdCeTu02oyt6RTMFIUBNdResFYOFW
	57Ol1iCs91wjMlMLugx+GbICgrh2BETdYZLZb/hAdNL8UJVzJ/vWT03tLeJlSdZl6jyblwMPGYo
	QTI7diuDpievlpzNwN2PwS/rg=
X-Google-Smtp-Source: AGHT+IFYS//nAhdr5sQ4EKB26kjYn20qv5wR0iA6FrAr+cMy0GIfWIfPM3YUDHi8RlYpm+FL+B8w4CHY3E8C/pwtOoc=
X-Received: by 2002:a05:6512:6d1:b0:549:9044:94ac with SMTP id
 2adb3069b0e04-54e9e53e33cmr325134e87.23.1745906146173; Mon, 28 Apr 2025
 22:55:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250403112522.1566629-3-rkrcmar@ventanamicro.com>
 <20250403112522.1566629-7-rkrcmar@ventanamicro.com> <CAAhSdy0e3HVN6pX-hcX2N+kpwsupsCf6BqrYq=bvtwtFOuEVhA@mail.gmail.com>
 <D9IGJR9DGFAM.1PVHVOOTVRFZW@ventanamicro.com>
In-Reply-To: <D9IGJR9DGFAM.1PVHVOOTVRFZW@ventanamicro.com>
From: Anup Patel <apatel@ventanamicro.com>
Date: Tue, 29 Apr 2025 11:25:35 +0530
X-Gm-Features: ATxdqUEiQjMeNUujcFSuwa_LrU9ri9FCJKZ6XmhF2QYcnvi_LFsWj1huKA1q38o
Message-ID: <CAK9=C2Woc5MtrJeqNtaVkMXWEsGeZPsmUgtFQET=OKLHLwRbPA@mail.gmail.com>
Subject: Re: [PATCH 4/5] KVM: RISC-V: reset VCPU state when becoming runnable
To: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@ventanamicro.com>
Cc: Anup Patel <anup@brainfault.org>, kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Atish Patra <atishp@atishpatra.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, Andrew Jones <ajones@ventanamicro.com>, 
	Mayuresh Chitale <mchitale@ventanamicro.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 28, 2025 at 11:15=E2=80=AFPM Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcm=
ar@ventanamicro.com> wrote:
>
> 2025-04-28T17:52:25+05:30, Anup Patel <anup@brainfault.org>:
> > On Thu, Apr 3, 2025 at 5:02=E2=80=AFPM Radim Kr=C4=8Dm=C3=A1=C5=99 <rkr=
cmar@ventanamicro.com> wrote:
> >> For a cleaner solution, we should add interfaces to perform the KVM-SB=
I
> >> reset request on userspace demand.  I think it would also be much bett=
er
> >> if userspace was in control of the post-reset state.
> >
> > Apart from breaking KVM user-space, this patch is incorrect and
> > does not align with the:
> > 1) SBI spec
> > 2) OS boot protocol.
> >
> > The SBI spec only defines the entry state of certain CPU registers
> > (namely, PC, A0, and A1) when CPU enters S-mode:
> > 1) Upon SBI HSM start call from some other CPU
> > 2) Upon resuming from non-retentive SBI HSM suspend or
> >     SBI system suspend
> >
> > The S-mode entry state of the boot CPU is defined by the
> > OS boot protocol and not by the SBI spec. Due to this, reason
> > KVM RISC-V expects user-space to set up the S-mode entry
> > state of the boot CPU upon system reset.
>
> We can handle the initial state consistency in other patches.
> What needs addressing is a way to trigger the KVM reset from userspace,
> even if only to clear the internal KVM state.
>
> I think mp_state is currently the best signalization that KVM should
> reset, so I added it there.
>
> What would be your preferred interface for that?
>

Instead of creating a new interface, I would prefer that VCPU
which initiates SBI System Reset should be resetted immediately
in-kernel space before forwarding the system reset request to
user space. This way we also force KVM user-space to explicitly
set the PC, A0, and A1 before running the VCPU again after
system reset.

Regards,
Anup

