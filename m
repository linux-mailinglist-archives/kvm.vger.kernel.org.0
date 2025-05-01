Return-Path: <kvm+bounces-45083-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A0EDDAA5F09
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 15:13:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 115DE17E33B
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 13:13:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EA23184540;
	Thu,  1 May 2025 13:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="MUSd7zCp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A3D02DC76A
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 13:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746105201; cv=none; b=JoCabxqkDFKBIoV9Rp0TBj3VfTCf6rLmQefW2y5Id7YQSQ1EumiIoJpKX8lBDq8+A46OQE8qK7Jt7nlJrEN0xX3ZKj9Mm7yAfF4Pg75jRTn4oAS7tQmMoRGt1Y2R1pDiHzTuwAkkMwAIsGeU4e+KNyLdkiduVEuUvxySUDjJ2r8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746105201; c=relaxed/simple;
	bh=XvupZH27H5g/HfGLJUrSITBouY7S04F9SNYyBSsUuM0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=g4p3tFfsunMTdBZkPu024NUVYCYMNYu2U5OqW16csFNJWRE0RtZpbQhIKqsSHy9nRwyg/hJuwwMVlN5rCejHokEEXyJ0NOlZ0lv0u7lIHuGgXK8JRwpSb8KOZQB3zXdbBKUM4iFhcLTRtxhwI6wTEJtNhp4StTU1HNt1GV9bJ5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=MUSd7zCp; arc=none smtp.client-ip=209.85.166.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-3d5e43e4725so2382545ab.1
        for <kvm@vger.kernel.org>; Thu, 01 May 2025 06:13:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1746105199; x=1746709999; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i8cnw7gES+2CPKoNFqxe9oNSToGNtvAVlGUfutI0aoo=;
        b=MUSd7zCpuPMvrBBe8i01Z0j1uYudSeHJFLnoLQRVCNXUUreAg9kkOtSFZxbL5CW/i+
         /Axfwzm0qrj+J8JX670FzkTZHC86/TkZ7/x+p/zGrAUbFjaAAyP4ixSu36KblluTDu6+
         e+1KE3Kbf6x9SqmeKnrtUv036aVASYAAkUT1h2eQN5s3WEig2m1XuUaL/HOu2OpIWQV5
         G35FGdsXAjYSqKdtdrf00bqASvt7ed1jXQv9Dmwyh0o/if4Kpyco5qtJnsnRd6XTIDsR
         FEAHWlS3xTpAnuMiIMVw/Z7y2RJKqXVhCpWcPNC7a+oELw35LXHbG1T2FjESLTWjDBu1
         POVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746105199; x=1746709999;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=i8cnw7gES+2CPKoNFqxe9oNSToGNtvAVlGUfutI0aoo=;
        b=ZIOFF3VboKATIKjTYoGfTOA/WADu7K4f1g+wFEnOXeZc88QJOFAAO2qABgSgPI36cz
         mHqwj54QqceyCoR4tVxNc84etKqhywNWBSw/AIPPOKgTjEBUKCq/t5hACQn2lKBK6xjj
         xtshNhAbuC7FTb7NDgMLi16AuRI9gj7+HGEshEccdVUQRTrDAL0QGQqzF3HsAHnQrAK9
         VlLdAJHgofbBp3UQPPiE7UuTgR+SbjSY+ZsJwA8yWpPwxZrN6lFjIbE3VJJ8+3eExMSi
         7/+bQ8zqm/XYfTFKG8X144ocOaC3E3opB1iAEEdLJ7ZUlajrKHKfLc1fHr+TTGCoG0G9
         yQ3A==
X-Forwarded-Encrypted: i=1; AJvYcCV/sJgmsGHuXLShmCs0dWac7YBtX9Lt76SSPNOde+D//UAsToiR8UHKRJeimqWAWIq4K0I=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyx1AgRSt4Zn2D3DM0u0ykb3ARhjG4Cm4MpdeTkmfXXYfesgpOf
	ohJZqg4AVjSjCpFz/DFt9egoyLFKzrytGAGnn4aEke2IOeekio8XqPGsmHPbPlGXfVR491qWn9C
	xMM7oOwpWJjfG8cr47j4ZOVCvzPOzl2z4gbOT8QmsUMfXKpSFohU=
X-Gm-Gg: ASbGncvpRiotkao3o00LivWZnfk8Kp2lMAvu6i2DpBIP/26KOt3CV8C8XqlaysGKCqq
	B5t6gL9fCLX5jzXDWWGPtXRBLKsdoDyc74eB345ABDs0lxi2EIHz0nIMiRuy2OgyfLcbq8uQqmt
	dr3owyXzLO1sZcZA1rWr6GOFs2bo1TgX0Tjg==
X-Google-Smtp-Source: AGHT+IFYH/yz9ETM9NLPFlE2pVkQwoPg56TQHPQR5mOU/5lz7nNUj+hk9/rsWp5zS5jnU2+qLzeLlD75PGhwF7yzJJc=
X-Received: by 2002:a05:6e02:1aaf:b0:3d9:24a7:db0c with SMTP id
 e9e14a558f8ab-3d96f1b20ddmr38261815ab.8.1746105199109; Thu, 01 May 2025
 06:13:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250426110348.338114-1-apatel@ventanamicro.com>
In-Reply-To: <20250426110348.338114-1-apatel@ventanamicro.com>
From: Anup Patel <anup@brainfault.org>
Date: Thu, 1 May 2025 18:43:07 +0530
X-Gm-Features: ATxdqUFKSjteFgCBlQofgGe5rmP86z7GpzG9AH1PpGwKFUlwJL4JNjmeLly_eRQ
Message-ID: <CAAhSdy3VJUyR=9KKQrHLpn_dqnyqpDore4CCC0SGPM4pjZ3opQ@mail.gmail.com>
Subject: Re: [kvmtool PATCH v3 00/10] Add SBI system suspend and cpu-type option
To: Will Deacon <will@kernel.org>
Cc: julien.thierry.kdev@gmail.com, maz@kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Atish Patra <atishp@atishpatra.org>, 
	Andrew Jones <ajones@ventanamicro.com>, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, Anup Patel <apatel@ventanamicro.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Will,

On Sat, Apr 26, 2025 at 4:33=E2=80=AFPM Anup Patel <apatel@ventanamicro.com=
> wrote:
>
> This series does the following improvements:
> 1) Add Svvptc, Zabha, and Ziccrse extension support (PATCH2 to PATCH3)
> 2) Add SBI system suspend support (PATCH5 to PATCH6)
> 3) Add "--cpu-type" command-line option supporting "min" and "max"
>    CPU types where "max" is the default (PATCH8 to PATCH10)
>
> These patches can also be found in the riscv_more_exts_round6_v3 branch
> at: https://github.com/avpatel/kvmtool.git
>
> Changes since v2:
>  - Addressed comments on PATCH10
>
> Changes since v1:
>  - Rebased on latest KVMTOOL commit d410d9a16f91458ae2b912cc088015396f22d=
fad
>  - Addressed comments on PATCH8, PATCH9, and PATCH10
>
> Andrew Jones (3):
>   riscv: Add SBI system suspend support
>   riscv: Make system suspend time configurable
>   riscv: Fix no params with nodefault segfault
>
> Anup Patel (7):
>   Sync-up headers with Linux-6.14 kernel
>   riscv: Add Svvptc extension support
>   riscv: Add Zabha extension support
>   riscv: Add Ziccrse extension support
>   riscv: Include single-letter extensions in isa_info_arr[]
>   riscv: Add cpu-type command-line option
>   riscv: Allow including extensions in the min CPU type using
>     command-line
>
>  arm64/include/asm/kvm.h             |   3 -
>  include/linux/kvm.h                 |   8 +-
>  include/linux/virtio_pci.h          |  14 ++
>  riscv/aia.c                         |   2 +-
>  riscv/fdt.c                         | 240 +++++++++++++++++++---------
>  riscv/include/asm/kvm.h             |   7 +-
>  riscv/include/kvm/kvm-arch.h        |   2 +
>  riscv/include/kvm/kvm-config-arch.h |  26 +++
>  riscv/include/kvm/sbi.h             |   9 ++
>  riscv/kvm-cpu.c                     |  36 +++++
>  x86/include/asm/kvm.h               |   1 +
>  11 files changed, 265 insertions(+), 83 deletions(-)
>
> --
> 2.43.0
>

Friendly ping ?

Regards,
Anup

