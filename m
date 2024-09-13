Return-Path: <kvm+bounces-26788-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D1523977B94
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 10:48:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 171AC1C25840
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 08:48:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDA8E1D6DAA;
	Fri, 13 Sep 2024 08:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pzYBXrOP"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC5471BB6B3;
	Fri, 13 Sep 2024 08:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726217318; cv=none; b=Sxg4KNqvnj3OIM/cye8TdkSH6/lmPBDAufGk2F5MWAazSx0KvmsW6To0/uLEMY3UTf8kbQ7Btm2w/QX//PrjLhGlrQxl4eSFyLkK2BdzvbcBdQ/G3mkBPxTiME1CUh3+y82y8XNHh4iruCUkc6CvJ6nX0LUslnX2QUnNjRanHt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726217318; c=relaxed/simple;
	bh=RyDvqS2FL5Hm0TH9N1rF42ZS5UKm2nTFiqjSkozNOUM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ghenyOfS2ibzhbINZwLqXhiDOlocfigV2AQnI9HB6iOUW0eAi2MmUQVnMiEjfMefyaMxpSakhWqlEzpBggVIitgJ5c8a8WyopFDi6px0shb6kp5DjGNLAQB7Pu6ozTkVsbWHUGR7lBikqaYDfxp2Eeo9tpgA+Cp1i6bxXTzUsMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pzYBXrOP; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66713C4CECF;
	Fri, 13 Sep 2024 08:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726217317;
	bh=RyDvqS2FL5Hm0TH9N1rF42ZS5UKm2nTFiqjSkozNOUM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=pzYBXrOPE3tm8OeMXF/owUcFqavpGKMiVHzPx2KzNDY+yxJuSRCGq8xE1NHyyPGqE
	 gMXCYzEQriv+HbGivtJts+NXBWHFNkDJRkBS6B8qrm2oPXWWsNclnuoSjheshE/dhf
	 1vS+Kp/xhTNQNSHp8OaPMyRuwggIW8Dyung/rwcwZmopctdcQMKWuvqb0mpiWnj352
	 DG8XyztitSjIRH6FT8ZegJb49mpqEC05As+naogkq+Mo2kFKOuCPmd7FcxzN16Z78e
	 p18lupWLV3dHofKysowO/WUAJ4Sl/tcLFT7tSV6hrtfDaTtKzugqHRIdlM2LA9OZh5
	 wRP7x5ZNbadqA==
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-5c27067b81aso660660a12.0;
        Fri, 13 Sep 2024 01:48:37 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUESpstasWtchvP13DOzq7QXYiXVWpDhDS+A0nQhIJOZT4YdQfYMNOa6B4XPGwpApSbo5WIwewOAX/HGw==@vger.kernel.org, AJvYcCVdf/qk/QlgrStileWfawO57t4iOnw7tcAawVhSK23ncDzQO8ccNLpRFZfAAJ/6n29rhfs=@vger.kernel.org, AJvYcCVuohjuy1n5Rx3JXtnitkX23gpFkDWJ56TjkyRPQ3ldOFalyvsUK/uxCOu49umNVO/UdKBjalSTr8Y=@vger.kernel.org, AJvYcCXdQBKGwIpUuWtzgYoe/KwIwlVcSBKHN5rFHgKQaSWIQImlA1cGGLq22uWr8BE4lsgZ0A/e26VTKtTIHffY@vger.kernel.org
X-Gm-Message-State: AOJu0Ywg3ha48WoCW3KPgF+jNt2RYL3SlnbYW9+EOY1in3xauin0LbZX
	sjTjMRWshVGyZCLMYrR1DSNUgb5Hw/20AQT5XX3jIXOUayy8/27aiNKKL2gl0qxDFPNq0jV4mX2
	3US69wecpdoOb5t3D8nSNBx/f8WU=
X-Google-Smtp-Source: AGHT+IGxaU84H2rJpTKm+AdI3/GYF1ZX56p+WMUPH/a1hpMzs1gVjtnJn7uMkTUBM9lkKw3rEE/fFLQKHJ4EoG1Gffw=
X-Received: by 2002:a05:6402:234f:b0:5c4:136c:ee53 with SMTP id
 4fb4d7f45d1cf-5c41d5bc591mr2038704a12.0.1726217315937; Fri, 13 Sep 2024
 01:48:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240912-iocsr-v2-0-e88f75b37da4@flygoat.com> <20240912-iocsr-v2-2-e88f75b37da4@flygoat.com>
 <4f631f4a-eeb8-4b57-8424-4f5e970f0b69@app.fastmail.com>
In-Reply-To: <4f631f4a-eeb8-4b57-8424-4f5e970f0b69@app.fastmail.com>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Fri, 13 Sep 2024 16:48:23 +0800
X-Gmail-Original-Message-ID: <CAAhV-H5JQSg3PTWBJ862-xjX87q5+fx72Dq0Wk+bsJxiC88wEQ@mail.gmail.com>
Message-ID: <CAAhV-H5JQSg3PTWBJ862-xjX87q5+fx72Dq0Wk+bsJxiC88wEQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] LoongArch: cpu-probe: Move IOCSR probing out of cpu_probe_common
To: Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc: Xuerui Wang <kernel@xen0n.name>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Viresh Kumar <viresh.kumar@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, 
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>, loongarch@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, 
	"linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, Jiaxun,

On Fri, Sep 13, 2024 at 4:59=E2=80=AFAM Jiaxun Yang <jiaxun.yang@flygoat.co=
m> wrote:
>
>
>
> =E5=9C=A82024=E5=B9=B49=E6=9C=8812=E6=97=A5=E4=B9=9D=E6=9C=88 =E4=B8=8B=
=E5=8D=889:55=EF=BC=8CJiaxun Yang=E5=86=99=E9=81=93=EF=BC=9A
> [...]
> > +
> > +     if (c->options & LOONGARCH_CPU_IOCSR)
> > +             return;
> Oops, typo here, there should be a not :-(
>
> Huacai, if the series is ok for you please fix this when applying
> the patch. I only tested against NEMU so didn't catch this :-(
Since the first patch can also be improved, you can improve this one
by yourself. And from my point of view the two patches can be combined
to one.

Huacai

>
> Thanks
> - Jiaxun
>
> > +
> > +     *vendor =3D iocsr_read64(LOONGARCH_IOCSR_VENDOR);
> > +     *cpuname =3D iocsr_read64(LOONGARCH_IOCSR_CPUNAME);
> > +
> > +     if (!__cpu_full_name[cpu])
> > +             __cpu_full_name[cpu] =3D cpu_full_name;
> > +
> > +     config =3D iocsr_read32(LOONGARCH_IOCSR_FEATURES);
> > +     if (config & IOCSRF_CSRIPI)
> > +             c->options |=3D LOONGARCH_CPU_CSRIPI;
> > +     if (config & IOCSRF_EXTIOI)
> > +             c->options |=3D LOONGARCH_CPU_EXTIOI;
> > +     if (config & IOCSRF_FREQSCALE)
> > +             c->options |=3D LOONGARCH_CPU_SCALEFREQ;
> > +     if (config & IOCSRF_FLATMODE)
> > +             c->options |=3D LOONGARCH_CPU_FLATMODE;
> > +     if (config & IOCSRF_EIODECODE)
> > +             c->options |=3D LOONGARCH_CPU_EIODECODE;
> > +     if (config & IOCSRF_AVEC)
> > +             c->options |=3D LOONGARCH_CPU_AVECINT;
> > +     if (config & IOCSRF_VM)
> > +             c->options |=3D LOONGARCH_CPU_HYPERVISOR;
> >  }
> >
> >  #ifdef CONFIG_64BIT
> >
> > --
> > 2.46.0
>
> --
> - Jiaxun

