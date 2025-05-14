Return-Path: <kvm+bounces-46545-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 33A96AB777E
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 23:02:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B133F3BCFF4
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 21:01:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C22B32750E3;
	Wed, 14 May 2025 21:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="B/v93FmO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF40B221FA1
	for <kvm@vger.kernel.org>; Wed, 14 May 2025 21:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747256521; cv=none; b=P8qEh7kIQhT1+MZZGLvGcS2TbzqCcscSYWX14ZsqYoPbSXwGta/iHWEEBVJPj1y+zms11OY7eSEliC7r00XWoreDn/I5tjKW26IsXqo54Ds4dgmuu7FtO9QAiZA9y6ZIfRWwHCMJ1QR2kbJJJfRH/yFetiUDkSJuyBZaTw6MfsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747256521; c=relaxed/simple;
	bh=7kRcjXDfm6wDX6rNHVswCUa2HG4onyXmUA2idPVePyY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BoeyeYKpUI4ri6o+EJMC8cxy638dLnY6YJlsKd3wrCCep4HUM/oiPYGCP6/oVHLNyFO0PQthCH/inSuO8nlBdSc1jQ6cxKfqiOeakC9svuJZf/fPIIIyOGdbBkj4/FaBKKFknUko+Hm1xoonPf/4x345Cyv/jadLC00h9qfE060=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=B/v93FmO; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-30c1c4a8224so275608a91.0
        for <kvm@vger.kernel.org>; Wed, 14 May 2025 14:01:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1747256518; x=1747861318; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OqchgTdHTyjs5ScPdT62o65cQnPzkkTwJlrZ4hmq6Bs=;
        b=B/v93FmOZ4UnaCNzaDcbFQ5RnL5kfMIR4raNCX6fpJoN1/4d/Ye7H+9rUabfVIQQVp
         7E+eCb/cLF6HoTiMHzJLoWtk219KpbBBo3LhEAVs1F4P0Ka8PmZcrDXCuVC9b73fN+BO
         9WbhgC8XyKY4ur3jPtOvmyPBf4l5vmQCGHgWqPlpznaf2VqUBp2nldLmUcsnHYrqdUv9
         66hTcV1PWD215Yulzf+UAzxRIjEfiSSBer4+fBAWPuEe0QujukgrzbSldki5FVldizpA
         D9Uc4PsTBFDK/sG0qboYO++v/OteaLJZ5xWrwno9Z8Grji1n1GmcTGkiZ2eN0/1dxzxi
         yDww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747256518; x=1747861318;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OqchgTdHTyjs5ScPdT62o65cQnPzkkTwJlrZ4hmq6Bs=;
        b=qTBJ0xw11/BMKzIxGQW1m7SZwzRGwCrbT8/vK7FcTgZSfc2n1h8l233SE5zhMvjtOX
         gPXA+I2dMoYQ5wFWnP3g0N7Yyqfuvso8dB3cODRqi1nF1qRG+ChDS0oz51Bv9EayPeX9
         cQ5jhMjrOWgwK1OsaMfGhDkQSDDww/rseFAhzzepgydEJwipyshHRM7lqTru/kSagmB/
         KQJRBfl/V6jP0GoVXHwwUzfQ0XxXzgZnnvsdNiNwfNj7jEwCvO7nNTLdKy1BTtymmsZ3
         z1W6//EpUA4TBEFFnrjcwdIWZeQuDKgxd5f6wgNIymuon+/ALj6I2Hy0Zt9TrIsB3R7D
         A2rw==
X-Forwarded-Encrypted: i=1; AJvYcCWBY/EhaGqq3ij8tb4hE7NwrjoBk2Go3ebl9rXyVHg681nCufraPlMpK5TYzuH1FO6JJnM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxFywNhCrZAHuzYRxiT82lxW5hczicOtwRbTKFpUBpOVEBOnw9I
	CK7G98pap2k7UPS6qWIg0aPnfqQTOUtIoxMuvVOr2u3zSv+ue82ML4eelCE24mc1YTECpyRFb67
	J+wrX3KKIIWJ5nLl7EcMrZhOSPAo8RRp3c867Ag==
X-Gm-Gg: ASbGncvPnY6tFUX4ei39rahi0DwRAf/dK8ApzA8aO1kZ3lTlUvU0xLlvpIBqPiOARLa
	BBC+4pDIhG9blusF0APi2JjVHtcdGU/Z0IvEP5ScC/LBB4uHS0TJCmFi5h0nTuUS6CKLHR5AR2L
	Y24Tk4DX8f9PLmbBba9StZXRwWGn7kfLo=
X-Google-Smtp-Source: AGHT+IGYtWvln6Vge4DD/b8/a37hqJvAAC7E46KvEmNXhfMJrQcWms3WMqWIhs4CNOJ5GERxgioGT+LfF4aLuzg8mgI=
X-Received: by 2002:a17:90a:d2d0:b0:2ee:f550:3848 with SMTP id
 98e67ed59e1d1-30e2e583ee6mr7135070a91.5.1747256518169; Wed, 14 May 2025
 14:01:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250513-fix_scounteren_vs-v1-1-c1f52af93c79@rivosinc.com> <CAAhSdy2LbLwRxuFVtMrrcTTD5NCxVCGLy4o=ZUowxT_9DXGqBA@mail.gmail.com>
In-Reply-To: <CAAhSdy2LbLwRxuFVtMrrcTTD5NCxVCGLy4o=ZUowxT_9DXGqBA@mail.gmail.com>
From: Atish Kumar Patra <atishp@rivosinc.com>
Date: Wed, 14 May 2025 14:01:46 -0700
X-Gm-Features: AX0GCFuPU3_CZzMOt6Sp9bohA_uEiLWy733kJmW5xL5q5LKhEWdxzONolY_B8xQ
Message-ID: <CAHBxVyHXJYDWbfY7FAEBB0S0ZG2+ka6KpWpd7+NO9jhApxav5g@mail.gmail.com>
Subject: Re: [PATCH] RISC-V: KVM: Disable instret/cycle for VU mode by default
To: Anup Patel <anup@brainfault.org>
Cc: Atish Patra <atishp@atishpatra.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Alexandre Ghiti <alex@ghiti.fr>, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 14, 2025 at 3:55=E2=80=AFAM Anup Patel <anup@brainfault.org> wr=
ote:
>
> On Wed, May 14, 2025 at 12:13=E2=80=AFPM Atish Patra <atishp@rivosinc.com=
> wrote:
> >
> > The KVM virtualizes PMU in RISC-V and disables all counter access excep=
t
> > TM bit by default vi hstateen CSR. There is no benefit in enabling CY/T=
M
> > bits in scounteren for the guest user space as it can't be run without
> > hcounteren anyways.
> >
> > Allow only TM bit which matches the hcounteren default setting.
> >
> > Signed-off-by: Atish Patra <atishp@rivosinc.com>
> > ---
> >  arch/riscv/kvm/vcpu.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> > index 60d684c76c58..873593bfe610 100644
> > --- a/arch/riscv/kvm/vcpu.c
> > +++ b/arch/riscv/kvm/vcpu.c
> > @@ -146,8 +146,8 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
> >         if (kvm_riscv_vcpu_alloc_vector_context(vcpu, cntx))
> >                 return -ENOMEM;
> >
> > -       /* By default, make CY, TM, and IR counters accessible in VU mo=
de */
> > -       reset_csr->scounteren =3D 0x7;
> > +       /* By default, only TM should be accessible in VU mode */
> > +       reset_csr->scounteren =3D 0x2;
>
> Let's remove this as well because the Linux SBI PMU driver
> does initialize scounteren correctly.
>

But other guests may not. I thought time should be a basic one that
should be allowed by default.

>
> Regards,
> Anup

