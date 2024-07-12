Return-Path: <kvm+bounces-21521-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 15FBC92FD6A
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 17:22:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C4E92286DBD
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 15:22:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA471172BDC;
	Fri, 12 Jul 2024 15:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MTnhrjw7"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6063B171E47
	for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 15:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720797757; cv=none; b=g2ENliiAx8CzR5TeBdBmc9RyeNJCR3tqrX+KWxhIYZAiUtwKHYHl8KjPLeCoNtBOAZF/7bs1344AOMDoXuUZCIfEUhLUUk9Y4K47O4lm8qmT/jZasy7qM/moXI6qWwlbHKI3+2Mzyiz0oFhPuPvq7l/c0x4thjok1cQ1LQb9dII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720797757; c=relaxed/simple;
	bh=ETNnLtEOODBfQi8H3tfRE0vrvS4f585oWdtbY7yixEo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UbA2No6KlT+2rmBEMWnRnn5b/VGHez0BlsOy0dcqqTcLpAHkH8I1WF764Gxnkx0wwbjZNP8N5N+hdfcVJfxaVort0wNPWyF9zkGyoOgclKdjjnyVIiib220dEUs2dl710agYiNczbkVwM49xkQg3jViGg1a1T4mwm9W6eoilcwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MTnhrjw7; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720797754;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5iNEWViGWsJ0HgvGvNf4C7dCvswRTS9KzeI2onLQu7Q=;
	b=MTnhrjw7mdkO0iDxtIhPM5OgSyPQvxxT5KwBrmQY7il1BlIkIKqu1UcfXXMYhSyhFDksfP
	ZtT9A9vXaz1oRvuElQ2Q5sbT16rNBMRWcowGD+Q0n6MenO5sde4p3vnd7JWzBMx39rzw15
	fRNro0+FiUGZ/5ayGmBpC3dRV8zO2EY=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-100-uk-ZJ1-NPoKWF5Tl0i9E4A-1; Fri, 12 Jul 2024 11:22:32 -0400
X-MC-Unique: uk-ZJ1-NPoKWF5Tl0i9E4A-1
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-2ee92048377so23554711fa.2
        for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 08:22:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720797751; x=1721402551;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5iNEWViGWsJ0HgvGvNf4C7dCvswRTS9KzeI2onLQu7Q=;
        b=AojzCvDLV5Fgyp5mMmUigA4qnQYa3SZdLhR8Lj91MbXMGHntzFeYqkPS2VgUOoaFZ1
         Uc+ICbL78UintjPHt4gTwnUY24qC4tQ4tZXjjdE/8+ErWlF1zBnX2gHvqUT+iCmM+p0b
         EYlUXlH0EuuHT2mMeNOxK2axFGwcu6DD18UX6Mkf4tSxshO23SMIDBL/XQADBNKCam4o
         mFhOWav9dW8NmZlJH4q+5NrExIRd0bGicFj5BskF505L+MWvhq1KijSLz8AeoLBgAbam
         E87gZBsWrKwaHDoIUBnmftaw0ceR4QXgjZK6KEPBrgUQ7xCWrzLYtqWSrADQfHrhX4Ra
         L9gg==
X-Forwarded-Encrypted: i=1; AJvYcCUVQkZmO3HNE9bpUD75BVjhKqXPQB7Cz50JhaaKFtAYU9Lw+C1N9reTW/U4THumZqgzVUmByES9y9UNw6ejdL7GusAn
X-Gm-Message-State: AOJu0YxClhY5EEerj2Bqi/YQniK+uEDplXZ/fZWlt5Vs4+wItrfiwIpW
	K0gauv4NjIn14ZMT+v2Tj7Y+Il/8fZdgUrcuiueTvqbqjyq5wLZx46pyXKHTEKh71JUXkT3NSeB
	T7giGDa5BeS0eu9GzkbjFE3GqaSwAymi0xOa40upFb4JAmxP0OylOC4Wlt3tuDPZRzgBznPG7QL
	a+xMtE8YHfXg+SMbqhjm/4EyYj
X-Received: by 2002:a2e:a792:0:b0:2ec:63f:fe91 with SMTP id 38308e7fff4ca-2eeb3181609mr109326921fa.38.1720797751187;
        Fri, 12 Jul 2024 08:22:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE17i70tdv+6mHF9kfzcljP7n2Fvj9afzaPSj88QABadl8SkXkPXm+TirlUDF8NciOpXb1JeKQtL1dVIL8Q2ow=
X-Received: by 2002:a2e:a792:0:b0:2ec:63f:fe91 with SMTP id
 38308e7fff4ca-2eeb3181609mr109326681fa.38.1720797750787; Fri, 12 Jul 2024
 08:22:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAAhSdy0jae8TYcbChockXDJ9qL+HnA1p3YJQi32NHQsLUtCGDA@mail.gmail.com>
In-Reply-To: <CAAhSdy0jae8TYcbChockXDJ9qL+HnA1p3YJQi32NHQsLUtCGDA@mail.gmail.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 12 Jul 2024 17:22:18 +0200
Message-ID: <CABgObfZJJHg41KH8=a9Sw7F8A8vthKTmx+w-hH-JP-+8BU3Wug@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/riscv changes for 6.11
To: Anup Patel <anup@brainfault.org>
Cc: Palmer Dabbelt <palmer@rivosinc.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Atish Patra <atishp@atishpatra.org>, 
	Atish Patra <atishp@rivosinc.com>, KVM General <kvm@vger.kernel.org>, 
	"open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" <kvm-riscv@lists.infradead.org>, 
	linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Pulled, thanks.

Paolo

On Fri, Jul 12, 2024 at 2:11=E2=80=AFPM Anup Patel <anup@brainfault.org> wr=
ote:
>
> Hi Paolo,
>
> We have the following KVM RISC-V changes for 6.11:
> 1) Redirect AMO load/store access fault traps to guest
> 2) Perf kvm stat support for RISC-V
> 3) Use HW IMSIC guest files when available
>
> In addition to above, ONE_REG support for Zimop,
> Zcmop, Zca, Zcf, Zcd, Zcb and Zawrs ISA extensions
> is going through the RISC-V tree.
>
> Please pull.
>
> Regards,
> Anup
>
> The following changes since commit 0fc670d07d5de36a54f061f457743c9cde1d8b=
46:
>
>   KVM: selftests: Fix RISC-V compilation (2024-06-06 15:53:16 +0530)
>
> are available in the Git repository at:
>
>   https://github.com/kvm-riscv/linux.git tags/kvm-riscv-6.11-1
>
> for you to fetch changes up to e325618349cdc1fbbe63574080249730e7cff9ea:
>
>   RISC-V: KVM: Redirect AMO load/store access fault traps to guest
> (2024-06-26 18:37:41 +0530)
>
> ----------------------------------------------------------------
> KVM/riscv changes for 6.11
>
> - Redirect AMO load/store access fault traps to guest
> - Perf kvm stat support for RISC-V
> - Use HW IMSIC guest files when available
>
> ----------------------------------------------------------------
> Anup Patel (2):
>       RISC-V: KVM: Share APLIC and IMSIC defines with irqchip drivers
>       RISC-V: KVM: Use IMSIC guest files when available
>
> Shenlin Liang (2):
>       RISCV: KVM: add tracepoints for entry and exit events
>       perf kvm/riscv: Port perf kvm stat to RISC-V
>
> Yu-Wei Hsu (1):
>       RISC-V: KVM: Redirect AMO load/store access fault traps to guest
>
>  arch/riscv/include/asm/kvm_aia_aplic.h             | 58 ----------------
>  arch/riscv/include/asm/kvm_aia_imsic.h             | 38 -----------
>  arch/riscv/kvm/aia.c                               | 35 ++++++----
>  arch/riscv/kvm/aia_aplic.c                         |  2 +-
>  arch/riscv/kvm/aia_device.c                        |  2 +-
>  arch/riscv/kvm/aia_imsic.c                         |  2 +-
>  arch/riscv/kvm/trace.h                             | 67 ++++++++++++++++=
+++
>  arch/riscv/kvm/vcpu.c                              |  7 ++
>  arch/riscv/kvm/vcpu_exit.c                         |  2 +
>  tools/perf/arch/riscv/Makefile                     |  1 +
>  tools/perf/arch/riscv/util/Build                   |  1 +
>  tools/perf/arch/riscv/util/kvm-stat.c              | 78 ++++++++++++++++=
++++++
>  tools/perf/arch/riscv/util/riscv_exception_types.h | 35 ++++++++++
>  13 files changed, 215 insertions(+), 113 deletions(-)
>  delete mode 100644 arch/riscv/include/asm/kvm_aia_aplic.h
>  delete mode 100644 arch/riscv/include/asm/kvm_aia_imsic.h
>  create mode 100644 arch/riscv/kvm/trace.h
>  create mode 100644 tools/perf/arch/riscv/util/kvm-stat.c
>  create mode 100644 tools/perf/arch/riscv/util/riscv_exception_types.h
>


