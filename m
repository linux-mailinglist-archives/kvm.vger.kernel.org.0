Return-Path: <kvm+bounces-11350-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C8BE875D7C
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 06:19:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F3AED1F22C86
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 05:19:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 734D632C8E;
	Fri,  8 Mar 2024 05:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="tO1BVjHK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f171.google.com (mail-il1-f171.google.com [209.85.166.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FD9B2E821
	for <kvm@vger.kernel.org>; Fri,  8 Mar 2024 05:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709875163; cv=none; b=Nh7atmeq38eHzweYOfsV19Y8dMgjdZWWVfgQB5hSXy1MfP5l4kYVySfrEzvnCEi2k1mIkAQNfohe7jrD93zTJZt3rR4+pB1NiwVdiJpnJMiADEGHCQLukxm8ISm13wRnOga/LG2P7cIvhmtpkO/EgDwM7F9I1/L2ueBMrZVc0Cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709875163; c=relaxed/simple;
	bh=M1OaeS8r7UTARn6ojib+isEL+VXsqpPbSLcJZ2CZr/U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pNkdIbPf7GAPMtooxLv/6R0+HvS6oxixuORxxpAlrwCWD8tRPNwVIfQDqqW+yx6FKNMcmyg+Q9U3JsJrx7x+E79dbfI9N05ZGi/gYhWzhmtXf6XaaUBE+5qn68uNax06JiMSoQBMNV2XUQYP0vE9cLGtZ4FTXO56r07uigqNcd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=tO1BVjHK; arc=none smtp.client-ip=209.85.166.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f171.google.com with SMTP id e9e14a558f8ab-36576b35951so8306555ab.3
        for <kvm@vger.kernel.org>; Thu, 07 Mar 2024 21:19:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1709875161; x=1710479961; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1Q1pOxUwOp5itp+TMEHjsIEi+PFZvIZX6/sMKOzN+aM=;
        b=tO1BVjHKb6Z9vpEVLsk7Y9Eas0x+2Hg1MQ0iJpRDqjew4pevzGaFZU2rZOzAiSVoZ+
         P+RJJ03Yi+8zbFMDN8tLNPAw6nEUf806LpMx/iI5PaGSG5PNABmpslcLbuj7K2ljvdcA
         C07vn37phkHfExiaiaYybp5RQQEnYX3YZ43/8UaETxaXvCOGhfU6Bg/jyXgdyAurtHFz
         gdLwy8CXWp2+fAeS4D+BWF+BnyEqfGhhlPbx0/KIGofLh/JqN7Uxkd2p3I+x1GtkEB3o
         /OCKwMl7QtFZyyGXzoIqgfodc49lGz/kI6nGhFjpWOMdirPZY9GfuP8FAlQqV24sTjBd
         oZlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709875161; x=1710479961;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1Q1pOxUwOp5itp+TMEHjsIEi+PFZvIZX6/sMKOzN+aM=;
        b=IrXyPe4wwbCQKLZrb/LdlYW3RRdQEWjAZBLxUURspqQC3swGLSGw0scnCWg1r8b5AW
         4cNRJtZTFMU1zjPN1QU2ngLwVv2PyTvZmRNf6yWsWHTcImrFjLy+5M2/hdhMuxvGPSMO
         QSt6+VrlqBP9qCnXXF/DOugXWhK+YuoEtmWpUoa+v28jQf6W4etMNPiYx+MKs+lBJuqt
         giKdWKqvcEckW0td6DnH/rCFAjBA+0fKEaW7sokPYuNuzo6M6Lc6KQJim2BEV9xEo2od
         JQFpzK/B7g4lu4EC84IdGNjDAtZzlTpHgiLNBzqbAXu60kKUs0x9sUx8A54OkYlanKhL
         997g==
X-Forwarded-Encrypted: i=1; AJvYcCV1c9oMTBa1FtR9dfgmNJqZF6vla1yIjESdO27UsxsO+Mmss6biwMT4Ix7ZV/+fJGZ0tQyJM8Y7jZjL31P8TwH4MMhi
X-Gm-Message-State: AOJu0YynoGR4HKaKZOUS6c/7rd9GNWQ4fAs+Qzqnh/y5WgyRLkIudOuk
	Fm+osfBHblIBf734NLWD05YVGWWnDBkx1ZJ1h/HWo02oSrghyU7ZDCJg2pYkUTLAMoqOJ0ajVOX
	7Q6XLyeUUMfFiRI0ys4DGc11uzlnHwbQWmO0tYg==
X-Google-Smtp-Source: AGHT+IGGNpCpXwkQjWIuGNKUjBb878ACq22fLX85aTMVIeV0LGFHGYH4vpYBvsarm+l3VNkirWWt6u0qF+Xk02D/r0A=
X-Received: by 2002:a05:6e02:1807:b0:365:69a:86b2 with SMTP id
 a7-20020a056e02180700b00365069a86b2mr27431076ilv.17.1709875161075; Thu, 07
 Mar 2024 21:19:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240307081951.1954830-1-colin.i.king@gmail.com> <Zeo8_ulDb4wYI_rO@linux.dev>
In-Reply-To: <Zeo8_ulDb4wYI_rO@linux.dev>
From: Anup Patel <anup@brainfault.org>
Date: Fri, 8 Mar 2024 10:49:09 +0530
Message-ID: <CAAhSdy0YHP4xWNz3W2tVE=-Wwtxe6r+-YKd+ytWreKEn7euGxA@mail.gmail.com>
Subject: Re: [PATCH][next] KVM: selftests: Fix spelling mistake "trigged" -> "triggered"
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Colin Ian King <colin.i.king@gmail.com>, Marc Zyngier <maz@kernel.org>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Atish Patra <atishp@atishpatra.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 8, 2024 at 3:47=E2=80=AFAM Oliver Upton <oliver.upton@linux.dev=
> wrote:
>
> Thanks for the fix Colin. Paolo/Anup, up to you how you want to play it,
> I see the 6.9 PR is already out for riscv.
>
> Acked-by: Oliver Upton <oliver.upton@linux.dev>

I can take this as a Linux-6.9-rcX fix if everyone is okay with it.

Regards,
Anup

>
> On Thu, Mar 07, 2024 at 08:19:51AM +0000, Colin Ian King wrote:
> > There are spelling mistakes in __GUEST_ASSERT messages. Fix them.
> >
> > Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> > ---
> >  tools/testing/selftests/kvm/aarch64/arch_timer.c | 2 +-
> >  tools/testing/selftests/kvm/riscv/arch_timer.c   | 2 +-
> >  2 files changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/tools/testing/selftests/kvm/aarch64/arch_timer.c b/tools/t=
esting/selftests/kvm/aarch64/arch_timer.c
> > index ddba2c2fb5de..16ac74d07d68 100644
> > --- a/tools/testing/selftests/kvm/aarch64/arch_timer.c
> > +++ b/tools/testing/selftests/kvm/aarch64/arch_timer.c
> > @@ -136,7 +136,7 @@ static void guest_run_stage(struct test_vcpu_shared=
_data *shared_data,
> >               irq_iter =3D READ_ONCE(shared_data->nr_iter);
> >               __GUEST_ASSERT(config_iter + 1 =3D=3D irq_iter,
> >                               "config_iter + 1 =3D 0x%lx, irq_iter =3D =
0x%lx.\n"
> > -                             "  Guest timer interrupt was not trigged =
within the specified\n"
> > +                             "  Guest timer interrupt was not triggere=
d within the specified\n"
> >                               "  interval, try to increase the error ma=
rgin by [-e] option.\n",
> >                               config_iter + 1, irq_iter);
> >       }
> > diff --git a/tools/testing/selftests/kvm/riscv/arch_timer.c b/tools/tes=
ting/selftests/kvm/riscv/arch_timer.c
> > index e22848f747c0..0f9cabd99fd4 100644
> > --- a/tools/testing/selftests/kvm/riscv/arch_timer.c
> > +++ b/tools/testing/selftests/kvm/riscv/arch_timer.c
> > @@ -60,7 +60,7 @@ static void guest_run(struct test_vcpu_shared_data *s=
hared_data)
> >               irq_iter =3D READ_ONCE(shared_data->nr_iter);
> >               __GUEST_ASSERT(config_iter + 1 =3D=3D irq_iter,
> >                               "config_iter + 1 =3D 0x%x, irq_iter =3D 0=
x%x.\n"
> > -                             "  Guest timer interrupt was not trigged =
within the specified\n"
> > +                             "  Guest timer interrupt was not triggere=
d within the specified\n"
> >                               "  interval, try to increase the error ma=
rgin by [-e] option.\n",
> >                               config_iter + 1, irq_iter);
> >       }
> > --
> > 2.39.2
> >
>
> --
> Thanks,
> Oliver

