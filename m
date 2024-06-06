Return-Path: <kvm+bounces-19006-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 91BDC8FE426
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 12:21:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A80091C24756
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 10:21:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D435194AF6;
	Thu,  6 Jun 2024 10:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="Y8y5TP/Q"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE234158848
	for <kvm@vger.kernel.org>; Thu,  6 Jun 2024 10:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717669269; cv=none; b=bOaypH5t5BsrBHwuO42F9tQvi/q3NvFQlJmQePt1nUJjD43jRgtEqnL5NvkTUNhdSCORUQvhX5oE+2VQpchcYRIAs0QGAKTdrbCzvFNLb+abgpq/FfgvJYk4OjX1pMmr5qHVdjUkbU43xZA9xHe5QbPLRwIEBSkljbGinskivMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717669269; c=relaxed/simple;
	bh=p2IVETulrKaznPy7pbOScnV6dGnLy8b4ZFB4Qqa0Wgs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FyLEYEWG4YBEQav4WxRp1ZfaXNo2EAawja3Sh7f7UfxiMirsYrsixQPeoBt99X/FghvPWZVYpSU4HVnIzgfkkYEvwyR5ATYDKbYT1GpyX3aEwJQKrGksPzJpjHmt+4hp49Xkv3OBLKQqfFV/Sgoc3VuAK+pBCGRNmHNBUSaXjmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=Y8y5TP/Q; arc=none smtp.client-ip=209.85.166.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-3737b412ad6so3015925ab.2
        for <kvm@vger.kernel.org>; Thu, 06 Jun 2024 03:21:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1717669265; x=1718274065; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C8gbPU6bAov2g/Fl0UKW6M0lcVcpv1MNbTGWdztG2QQ=;
        b=Y8y5TP/QFLWjiJR2hdFNzYJu+sX3J1kXg8FxuhUK4M5zH2JrzHUrOcpFSU0Mk66R62
         59oCZwQv8xvXh/ZN7+wNddDGY7b6hbfMjH/RIQVro2wOKFXh5OYGgb5sXalvG0wlsuxW
         xeqzXohK7SPHsTtkVnyxMm7SsF13If3a4AWH8+y9GwxHA0uVpl0NuDOaE27NI80mKfWC
         WwHxfMnxP473a9znc2ch5Q9LbAiYVBqidaR7dIiAJmsp8fWOa92/i3KYg/yo3bOSFyLV
         WgU/jtSOhBWLSAu95uctDaMx6HuvEBD6ZyayDmITT1PMR+6S1wqODTVKks99z1QawLry
         SdCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717669265; x=1718274065;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C8gbPU6bAov2g/Fl0UKW6M0lcVcpv1MNbTGWdztG2QQ=;
        b=T3mvq9s+rwHCcOar3rif7Wr4bx9IDkmS/XJltlHtuHgoqEWio1eZDKboizjlN+T07s
         nPnRRX8PYgmW+XZRY1Ew11E1PNnvgEfFxUfmJR244FIFN6NLze7tr3ehd/DwBds/UqB5
         KPXMpE1ZxmnJptuPaCLUXdNodXF7Ty0zFoiPyFU/nNHFtvEQ83LE2jEeogtDl0DI7ACO
         GuBEjJY534WCgAtuVBUcuk+MBvm9SsyAOVqLVrkx27j3uZb53au4FbfZK/KMoxf7rLPX
         /2d3DWgJFQvYTGJVdfQa8/9MsbZdT4nlrtG4BH1MkLdp49AZts2jAu4X2grXqQMsBnQ6
         6EOQ==
X-Gm-Message-State: AOJu0Ywl2+atHhixZcMsxptPkoCgDFNidYUdrZ6hkKdMomKlIZAO/xcp
	l7z1M1heBRu1m22nHTDHNrZsFfT86bNfgJoleHMpFlgGMDYvFeh8G42uqQtzx4E3IOBNF9eBx1Y
	33JtnDtDa/8NNybYD/lOX3so58y5BtEP6Np/ETRQMJrxQzKZO
X-Google-Smtp-Source: AGHT+IEG1degqP38IihTcozUW0b/xD6FkCMpNvO7LYx8r4K2WTkSSecXIlgHzrzJk9SuEQ8P9qatHD20tVem/vS3qt0=
X-Received: by 2002:a05:6e02:1a29:b0:374:70ed:d765 with SMTP id
 e9e14a558f8ab-374b1ee7b71mr51783965ab.3.1717669264807; Thu, 06 Jun 2024
 03:21:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240603122045.323064-2-ajones@ventanamicro.com>
In-Reply-To: <20240603122045.323064-2-ajones@ventanamicro.com>
From: Anup Patel <anup@brainfault.org>
Date: Thu, 6 Jun 2024 15:50:53 +0530
Message-ID: <CAAhSdy28AojFu7jF1imz9P1JYbn0vKJNnrOA-hN4WoaVHjtPtw@mail.gmail.com>
Subject: Re: [PATCH] KVM: selftests: Fix RISC-V compilation
To: Andrew Jones <ajones@ventanamicro.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, pbonzini@redhat.com, 
	seanjc@google.com, atishp@atishpatra.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 3, 2024 at 5:50=E2=80=AFPM Andrew Jones <ajones@ventanamicro.co=
m> wrote:
>
> Due to commit 2b7deea3ec7c ("Revert "kvm: selftests: move base
> kvm_util.h declarations to kvm_util_base.h"") kvm selftests now
> requires implicitly including ucall_common.h when needed. The commit
> added the directives everywhere they were needed at the time, but, by
> merge time, new places had been merged for RISC-V. Add those now to
> fix RISC-V's compilation.
>
> Fixes: dee7ea42a1eb ("Merge tag 'kvm-x86-selftests_utils-6.10' of https:/=
/github.com/kvm-x86/linux into HEAD")
> Signed-off-by: Andrew Jones <ajones@ventanamicro.com>

Queued this for Linux-6.10-rcX fixes.

Thanks,
Anup

> ---
>  tools/testing/selftests/kvm/lib/riscv/ucall.c    | 1 +
>  tools/testing/selftests/kvm/riscv/ebreak_test.c  | 1 +
>  tools/testing/selftests/kvm/riscv/sbi_pmu_test.c | 1 +
>  3 files changed, 3 insertions(+)
>
> diff --git a/tools/testing/selftests/kvm/lib/riscv/ucall.c b/tools/testin=
g/selftests/kvm/lib/riscv/ucall.c
> index 14ee17151a59..b5035c63d516 100644
> --- a/tools/testing/selftests/kvm/lib/riscv/ucall.c
> +++ b/tools/testing/selftests/kvm/lib/riscv/ucall.c
> @@ -9,6 +9,7 @@
>
>  #include "kvm_util.h"
>  #include "processor.h"
> +#include "sbi.h"
>
>  void *ucall_arch_get_ucall(struct kvm_vcpu *vcpu)
>  {
> diff --git a/tools/testing/selftests/kvm/riscv/ebreak_test.c b/tools/test=
ing/selftests/kvm/riscv/ebreak_test.c
> index 823c132069b4..0e0712854953 100644
> --- a/tools/testing/selftests/kvm/riscv/ebreak_test.c
> +++ b/tools/testing/selftests/kvm/riscv/ebreak_test.c
> @@ -6,6 +6,7 @@
>   *
>   */
>  #include "kvm_util.h"
> +#include "ucall_common.h"
>
>  #define LABEL_ADDRESS(v) ((uint64_t)&(v))
>
> diff --git a/tools/testing/selftests/kvm/riscv/sbi_pmu_test.c b/tools/tes=
ting/selftests/kvm/riscv/sbi_pmu_test.c
> index 69bb94e6b227..f299cbfd23ca 100644
> --- a/tools/testing/selftests/kvm/riscv/sbi_pmu_test.c
> +++ b/tools/testing/selftests/kvm/riscv/sbi_pmu_test.c
> @@ -15,6 +15,7 @@
>  #include "processor.h"
>  #include "sbi.h"
>  #include "arch_timer.h"
> +#include "ucall_common.h"
>
>  /* Maximum counters(firmware + hardware) */
>  #define RISCV_MAX_PMU_COUNTERS 64
> --
> 2.45.1
>

