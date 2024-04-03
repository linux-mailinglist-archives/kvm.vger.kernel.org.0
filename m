Return-Path: <kvm+bounces-13453-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E430B896DF9
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 13:20:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 145931C25F17
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 11:20:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0C731419BF;
	Wed,  3 Apr 2024 11:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="QF/S7pGC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67DD773506
	for <kvm@vger.kernel.org>; Wed,  3 Apr 2024 11:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712143241; cv=none; b=I6Oh9dXtQwn2qoC/2GevmMTgW+pEQgSQd9uWloI4777QQ0z/71GQZutgIGVjbdH16z/Em4W30vR/kNGa5edrFnnhhDIcJmMgqGk+4CxaYTwy2U75ajDZOe9u3SB/U/nT2nYaGt+s/BQRRdoRj2kDegdFpk9Qn1CIvqPOz/riz3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712143241; c=relaxed/simple;
	bh=JmcP5KCbjWleqe2tAQ/36s1a67tLhIXC4EMy5JPRCzk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jPlJW5/qxxGHKRIQfX3emjKFN+9Yfo0aO0MsbKtSgpFX1Gn+0np/h+kKQSfrpYEtRB01R3NrrApMvD9mI5NL/zORtA7CgG2pVgpDoJs9yoQzBSsAbu7AVn3gFhvsA11hcitgJr1Zdhn5BvEXd/NnpffdR9deHoGbriFhHWGpK/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=QF/S7pGC; arc=none smtp.client-ip=209.85.208.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-2d48d75ab70so92597391fa.0
        for <kvm@vger.kernel.org>; Wed, 03 Apr 2024 04:20:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1712143237; x=1712748037; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m5ianbndfVDluucOyWxxqJsyOqJJ72CFLcdbcasuT1Y=;
        b=QF/S7pGCriXlOv48Wxj9ew3IGHzQ18/T5mfbnUc2XkHeC8CnXyQesum5JDQ/q18oHh
         s6rcdQsuteQ431MLzQLvzMvZGADo+GyiOzpvStVaZ0WC47OOAWDnagAvN2xN9yn/E/Td
         0m9szp7ZNCRG6d99OayDm7bCjaWdH+aVP51NElnDCgUsfkZwtw5m+r9cbLFXEh8yPMTl
         +6vHCTdSdCUTKRa9P8Ud5jik+GR3vpRYUgh+70MptvVyhZuu52SMAJn1TcfkaQ1W/XVY
         qXtKtCfVgNK/WsyIPTCYIvCEvYOcMmxoZyW4h8q0biC+6Qw55CmF9yQ87Gs2TO4OI7GG
         69LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712143237; x=1712748037;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=m5ianbndfVDluucOyWxxqJsyOqJJ72CFLcdbcasuT1Y=;
        b=rva1MGcNmizD4pQcLwjjHYLwONHF76Vlr8zft1+oRmgEkA67rcbFXT0EbdN2/qqH9G
         DrWAoMuLSLGK0OihjdNuZYnXHs9Jj1M5tSX6aQCUyjMw8YMB2o4lPWT8foCuviEUB0A0
         FpM2ONdK4BhdhkbrIQJ9n77AaR6vSfPIPO2xs4X4f3FThnKpXqgQxwoKEb7kTZX/TMxs
         zXjgQqi5iA8TPLhkfsT3nLsVCfBWFX7cdXOG1r3v0GV1B8kebDLRIBuNP6ccveis3TNo
         WyG3TBRERkOje+OW2S9nTC6Ssjo8eaM4odoSV6pdPRWjVTdAJDdtuLAc93y0fBMBrNMM
         oDxA==
X-Forwarded-Encrypted: i=1; AJvYcCX8sIddLQoIWBKCJvOG8sjV2Pb2Dz1wSwvY2GBTgK9ympPTLi6A4HHluf/VgTjFafDPF2cDeRlCwlJyk4wBTcDmGbyw
X-Gm-Message-State: AOJu0Ywuf8ey0kU2gJUvGjg6YtRf8EQUhVysHm1+DL4euZSxUjsOsbMy
	5hhVW774vkpT/7w2mc7xL5O8dL8og5Y35i8/z3HEJxgXLutDkdg6yiJqAd8R+DGaZkWzYTuTKd4
	gYwr+1+QtMkZYZC24pA6ZpeXu2yWg+OVTdmOdGg==
X-Google-Smtp-Source: AGHT+IFONMYqMgjXPCop8dd+xIuQKUMQlSvfU4v03LmFg36aM+QJZXyCtig+Ae4Zn35rNX6tqzxi8MDptBrrKCOdT6g=
X-Received: by 2002:a2e:a794:0:b0:2d6:c94d:94a2 with SMTP id
 c20-20020a2ea794000000b002d6c94d94a2mr1964438ljf.1.1712143237480; Wed, 03 Apr
 2024 04:20:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240325153141.6816-1-apatel@ventanamicro.com>
In-Reply-To: <20240325153141.6816-1-apatel@ventanamicro.com>
From: Anup Patel <apatel@ventanamicro.com>
Date: Wed, 3 Apr 2024 16:50:25 +0530
Message-ID: <CAK9=C2UMLO+ft-j=qfmuv+Xc16z6JbDKcQf9+jJftwR5FdGYAA@mail.gmail.com>
Subject: Re: [kvmtool PATCH v2 00/10] More ISA extensions
To: Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com, maz@kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Atish Patra <atishp@atishpatra.org>, 
	Andrew Jones <ajones@ventanamicro.com>, Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Will,

On Mon, Mar 25, 2024 at 9:01=E2=80=AFPM Anup Patel <apatel@ventanamicro.com=
> wrote:
>
> This series adds support more ISA extensions namely: Zbc, scalar crypto,
> vector crypto, Zfh[min], Zihintntl, Zvfh[min], and Zfa. The series also
> adds a command-line option to disable SBI STA extension for Guest/VM.
>
> These patches can also be found in the riscv_more_exts_v2 branch at:
> https://github.com/avpatel/kvmtool.git
>
> Changes since v1:
>  - Rebased on commit 4d2c017f41533b0e51e00f689050c26190a15318
>  - Addressed Drew's comments on PATCH4
>
> Anup Patel (10):
>   Sync-up headers with Linux-6.8 for KVM RISC-V
>   kvmtool: Fix absence of __packed definition
>   riscv: Add Zbc extension support
>   riscv: Add scalar crypto extensions support
>   riscv: Add vector crypto extensions support
>   riscv: Add Zfh[min] extensions support
>   riscv: Add Zihintntl extension support
>   riscv: Add Zvfh[min] extensions support
>   riscv: Add Zfa extensiona support
>   riscv: Allow disabling SBI STA extension for Guest

Friendly ping ?

>
>  include/kvm/compiler.h              |   2 +
>  include/linux/kvm.h                 | 140 ++++++++++------------------
>  include/linux/virtio_config.h       |   8 +-
>  include/linux/virtio_pci.h          |  68 ++++++++++++++
>  riscv/fdt.c                         |  27 ++++++
>  riscv/include/asm/kvm.h             |  40 ++++++++
>  riscv/include/kvm/csr.h             |  16 ++++
>  riscv/include/kvm/kvm-config-arch.h |  86 ++++++++++++++++-
>  riscv/kvm-cpu.c                     |  32 +++++++
>  x86/include/asm/kvm.h               |   3 +
>  10 files changed, 330 insertions(+), 92 deletions(-)
>  create mode 100644 riscv/include/kvm/csr.h
>
> --
> 2.34.1
>

Regards,
Anup

