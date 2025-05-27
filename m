Return-Path: <kvm+bounces-47830-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9915FAC5D9C
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 01:04:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E68291BC3706
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 23:04:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40815218E9F;
	Tue, 27 May 2025 23:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xINwnb0o"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 826751F4C96
	for <kvm@vger.kernel.org>; Tue, 27 May 2025 23:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748386945; cv=none; b=mg0pc5RBBt0+9TClSQBJ/GS0gOMhNih1oAbo9gCaVAkQOkdxDrVT7U2g8d02pGbPNSuHZB2fqkKgzNuv749ge1Dg0SzXOz/u+Z6SMSC8ODL9/mf35/6i5mT0ZHcxdOW5Vja+ds1BbSdddETgz+/PvolGflh/k2OS0LFopL2WVqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748386945; c=relaxed/simple;
	bh=Ktrjmqe0kZK9gR2DHr9rmuR9K2xr6zjY++GDHnUCEi8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=geg/RhLwzZjIcNwRzmWT9RAYIAF72EihW799ktw/vUFbIsv92aeVQF/81jsSJ5zdJZ3Uth8KxPidudc8GpHymz2zHnLx84Sr0OMXGtM+uR4PW+JYbVox62GI+4gYw1se5zx76Evqor/C3cqg2i9yN0GNxN4EZdvr16keWms/M4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xINwnb0o; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5532a30ac45so362422e87.0
        for <kvm@vger.kernel.org>; Tue, 27 May 2025 16:02:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748386941; x=1748991741; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ndRrzvA0cJVve2DfQbqhh3IUcMrc84cIxRCgKCOajIw=;
        b=xINwnb0ouDiZqsguwO45fshXsXiMr0tWqcRQSi2FTgJp0ZDVSo6RsijTBcILBQsVHK
         0udBH04mnTaD92WAcngMmgBfKuNSFY85Ps1aLuC6OmkoAi5TosbKEnLBXSBeZDS9agcD
         dXc9vBKSH6H1mxqEHOB21oux/cAR/VnCoxhOzP+MInX5WBjhA9PG0iskbKFVr0/VW6dI
         Gxz6PMpXDFpnMUUjrBZlSGNCNeuiBafgyv1HhoVaci6HPS89KmzbtfTtnZ60d/0FeoKY
         q7yTwAAPoLKepagBda8N4BEnn7Zei9Pi8ILFkV7uWDzICVtTvEMISUpXXP9yqZ0GI1EV
         zfkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748386941; x=1748991741;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ndRrzvA0cJVve2DfQbqhh3IUcMrc84cIxRCgKCOajIw=;
        b=gT/MKDGhr7Ip4FU8n9wEJiSgeWG8+EWFVUUokEDX3m5/bYHEgJBUJKXQGSjP4iXgsX
         0OogcLQIgKeccy+jigep9Hdsg267Ou+lc58W9Zq0XHiLW4cuB7ozos1KqgA3nP6th0jI
         EP0JJ8AO1tGGfG2+qKLcYqznSzE4/I0S7ts/Gh9PrxMrn+SfaNmkBV0BQWYTNt2YvGKN
         Ih9MS+bV77gVjCz8OLnOvgdOLmaylMEpi0ay1iomk6cd/vG/ZYH6hyBZvAidLL7w8gE5
         SNnJj7zb2cPTayN4952kDMwOVhhOI7f8BZm7E9UZ8n2NtxoJ7j4vcxSW5VS6nYnprFdP
         iMjA==
X-Forwarded-Encrypted: i=1; AJvYcCU65WS5w0ofcA/JN5K7DElpDMeWZimn5nXxjGw4zjR/Z9eNVDqZONcVhJNeGJxxxlavPaw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz+rWXhWlIbbhL2wzDjefowCQlSC5fiybL+P64JC1VfYZ4qZajh
	5y4VqEccfh0ii9mPm7AtR9XbC5aroDTFaGELZRSxBvhZb7XdjvJCHge/VyAy2Jn6VhLtJ941NA5
	80jY9QXy4CMVhhZcankmcfEHIjL5pVzaRvVsGCiUq
X-Gm-Gg: ASbGnctQ6/NrWEF721gtoXVIw8bH6NzG5tql/Ftr+w96lY+h88kJoU/lMEtGaBulXVv
	gtycQn1zGKcGVlHJtpi/jGh29dx6+c62pywdzcoKw62aJRt/6ammGpjbfHrQ0q3gGyK/yejJmmS
	lglLQlLYWu1QvFYBFQfR/uv/7InaU/2JK9xiUAiEQGzVQ=
X-Google-Smtp-Source: AGHT+IFZbJR6bnHvrhNoyh8iCRRTfjqrj6fR1SBr28UadkyyMst1x0G7ICCyPxsc7YvfWOq6jVmPr80YAazaGWGTsOw=
X-Received: by 2002:a05:6512:33d3:b0:553:2308:1ac5 with SMTP id
 2adb3069b0e04-5532cda8048mr864512e87.4.1748386941294; Tue, 27 May 2025
 16:02:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250523233018.1702151-1-dmatlack@google.com> <20250526170951.GD61950@nvidia.com>
In-Reply-To: <20250526170951.GD61950@nvidia.com>
From: David Matlack <dmatlack@google.com>
Date: Tue, 27 May 2025 16:01:52 -0700
X-Gm-Features: AX0GCFtUn88nkq0q2_rGkcjNf7Yb6vgS7B8tH8IIfb6H9q-PT5LoJrEFuTjSIiI
Message-ID: <CALzav=f_12DE4iJ4XxU+jsaEcP2LZioVfuVwGMnK8a=JJbA0JA@mail.gmail.com>
Subject: Re: [RFC PATCH 00/33] vfio: Introduce selftests for VFIO
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Joel Granados <joel.granados@kernel.org>, Alex Williamson <alex.williamson@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Vinod Koul <vkoul@kernel.org>, 
	Fenghua Yu <fenghua.yu@intel.com>, "Masami Hiramatsu (Google)" <mhiramat@kernel.org>, 
	Adhemerval Zanella <adhemerval.zanella@linaro.org>, Jiri Olsa <jolsa@kernel.org>, 
	Andrii Nakryiko <andrii@kernel.org>, Wei Yang <richard.weiyang@gmail.com>, 
	Bjorn Helgaas <bhelgaas@google.com>, Takashi Iwai <tiwai@suse.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>, 
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>, 
	FUJITA Tomonori <fujita.tomonori@gmail.com>, WangYuli <wangyuli@uniontech.com>, 
	Sean Christopherson <seanjc@google.com>, Andrew Jones <ajones@ventanamicro.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Eric Auger <eric.auger@redhat.com>, 
	Josh Hilke <jrhilke@google.com>, linux-kselftest@vger.kernel.org, kvm@vger.kernel.org, 
	Kevin Tian <kevin.tian@intel.com>, Vipin Sharma <vipinsh@google.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Saeed Mahameed <saeedm@nvidia.com>, 
	Adithya Jayachandran <ajayachandra@nvidia.com>, Parav Pandit <parav@nvidia.com>, 
	Leon Romanovsky <leonro@nvidia.com>, Vinicius Costa Gomes <vinicius.gomes@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 26, 2025 at 10:09=E2=80=AFAM Jason Gunthorpe <jgg@nvidia.com> w=
rote:
>
> On Fri, May 23, 2025 at 11:29:45PM +0000, David Matlack wrote:
> > Drivers must implement the following methods:
> >
> >  - probe():        Check if the driver supports a given device.
> >  - init():         Initialize the driver.
> >  - remove():       Deinitialize the driver and reset the device.
> >  - memcpy_start(): Kick off a series of repeated memcpys (DMA reads and
> >                    DMA writes).
> >  - memcpy_wait():  Wait for a memcpy operation to complete.
> >  - send_msi():     Make the device send an MSI interrupt.
> >
> > memcpy_start/wait() are for generating DMA. We separate the operation
> > into 2 steps so that tests can trigger a long-running DMA operation. We
> > expect to use this to stress test Live Updates by kicking off a
> > long-running mempcy operation and then performing a Live Update. These
> > methods are required to not generate any interrupts.
>
> I like this, it is a smart way to go about building a testing
> framework.
>
> Joel had sent something that looks related:
>
> https://lore.kernel.org/r/5zoh5r6eovbpijic22htkqik6mvyfbma5w7kjzcpz7kgbju=
fd2@yw6ymwy2a54s

Thanks for sharing, I've started to take a look. Joel, please take a
look at this series too and let me know your thoughts.

>
> IMHO it would be very nice to lean into what Joel was thinking of a
> 'libvfn' where the above device stuff is inside a library and it can
> be re-used for other purposes.
>
> We keep running into scenarios where it would be really nice to be
> able to do DMA testing and we just don't have easy ways to build SW to
> do that.
>
> A reusable mini-driver framework that can trigger DMA is a huge leap
> forward.

How broad do you think the reusability should go?

I structured the library (which includes the driver framework and
drivers) so that it is reusable across other selftests (i.e. not just
in tools/testing/selftests/vfio). The last 3 patches in this series
show it being used in KVM selftests for example. IOMMU-focused tests
in tools/testing/selftests/iommu could also use it.

But it's not reusable outside of selftests, or outside of the kernel
source tree. My intuition is the former wouldn't be too hard to
support, but the latter would be challenging.

>
> > Library:
> >
> >  - Driver support for devices that can be used on AMD, ARM, and other
> >    platforms.
>
> I would be very happy to see a mlx5 driver option. mlx5 class HW is
> widely available, cheap on ebay, and it would make this usable by
> pretty much anyone who wants.

I was also thinking of using NVMe for this (cheap, broadly available),
but I'm a little worried someone might accidentally corrupt their boot
disk if they accidentally pass in the wrong BDF :)

Do you think mlx5 HW could support the current driver API?

