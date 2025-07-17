Return-Path: <kvm+bounces-52699-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D5A63B084AC
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 08:12:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 23A3A1A669C4
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 06:13:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3A0C211489;
	Thu, 17 Jul 2025 06:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="POSIvSUp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85F0A1FCD1F
	for <kvm@vger.kernel.org>; Thu, 17 Jul 2025 06:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752732750; cv=none; b=a0YB2fTqypRhUOvQe0i3FxgJY6i0tso8bOoRmZFrFYWdVEpMPGvK7qCGRcmvO8irhc/WpKay5r8AqJapEcGPFq6LyRIkCSQq8llMCkl+Er+l3pcexmeXa9CM9CwqGrA9QL5p7uN6MHXyA5xInj1HxUdfb2rxSDEmc5WR1nDQYPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752732750; c=relaxed/simple;
	bh=YIN35DRD/aoz21n489sIa+7GtdG3TmvZGAd7pBytAGw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dqMk7S/Tsh1ERswY7ylVgVsLaQxCbzMuuf16pWfc+5Cwd2/OTOr7zlj355Yxmg3AlNk16FYtv7wlNJQra13/4mLqQCNFOt9QYa+zgKDY31PsWF2ni4k16/o558S3CpF97DqQtDI1aoTAO2or7quUTicCU2FMp2M+UGvTLT8so74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=POSIvSUp; arc=none smtp.client-ip=209.85.166.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-86cdb330b48so52125739f.0
        for <kvm@vger.kernel.org>; Wed, 16 Jul 2025 23:12:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1752732748; x=1753337548; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uee3oli5059CdqjZMZ5JHaAC2Fn9BWMJg270zgvkJfM=;
        b=POSIvSUp3l5h4Leq2yJJJTgh97mR+l74y8VWWbBefPwRQ6fxAEUs2DXqBflxE/Orup
         VliZjA5vPauaDf+nBHP+YCMaRvuCiFJkk4m4bnfdgpu4YO7Ik1JsJfdOsC5uC3c04RDM
         OpoTqNTHrY6Edu4pGpi2L8Oz7G7sAW5RmmZH/Abps18K+QloRhPh0SWwjZQFQor6tj2l
         m2VybY6sHd6JINUQkFHRhdjBZ3w8BYk/xtfGaDP7WUs+PFAIdu296tcEoKj24Fb+5FeA
         s9kz0fLkicEVkXr/PTH4cnME0iY/ly+WvGsMz6cH4Q2WwO02YGkuhx5MgPYy9WhdnC1s
         X1Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752732748; x=1753337548;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uee3oli5059CdqjZMZ5JHaAC2Fn9BWMJg270zgvkJfM=;
        b=U3NfTu32oV75Dnh4LWEqQyoZrYZTILpOlcEopYpWi5QI4m6TaaUVw2aoP4/nwipwBb
         v8+pTEbx+uOkNOfUeSjZ4Qe+4VappzIC3EXGu4v5aTrCvwYbVxvr8dnrBkIcegogdNFJ
         BVK9oBIBpqy+es9/YHyHrz6sg6v73x4J12dPE0vLSJzUw1tXtH2g1RQBUyabxnmARe0n
         G6RmdP95ls7IX/r6QM+exD71yQl55azEBPYLPdDu16oUQK4keQd5fKMuRjgHKIYp3/gN
         X9HCdFNlzdyLQ59v/Tdvfe8IL82t4LnymyfO/6xO9Szf8V5n7zGde2JhdVhK39Ezai1P
         8K+w==
X-Forwarded-Encrypted: i=1; AJvYcCXLR3u5HH1aUUo8B87uB2q1rvUwYp+HZXMA81IpvffZAEqju9BqPRvNEBjN6zUlVLnkiuA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyAxshgZK4A5RqHducTv3CY8AMTyIdqQ6Ti0NOELAuA95dJK6H6
	MiVODqGyc062VSPIVsgWepljJGQ9sBqXXBY7d4DFSPqIlvdzawWHFq6GVUEP2m29SzDeMNrjkB+
	6pSAqUK1OgydyWHfjFsoCNm7w3PocqccXJfXog6Do0A==
X-Gm-Gg: ASbGncv6JvcHjAwKs2Gg+CoRjwes0rj09OoSSnKhKLOo1UnptqTNjC/jCcuzSEPsXdO
	L1HZL1wdWdjfIRbWK11tif/Fu3sAxtpKfPOoGENwzFTlej+QzeUh+ey3jr64d1snbDb9PQOSE0j
	YRFSG6sX2omkYs1ynYZzSdOqta7WASCQELhWJC8J1oY88gyxXQBnhAVPrNv0ONAUiq1DSPHf9Uc
	IQ2UQ==
X-Google-Smtp-Source: AGHT+IH8xcNIaMtG75XYnMN8W4vb5d0fFUQvseJHaY/XTWiJuHa1nEHEzpAjdB6OHrz4d8cQ5sLqYX8b9sjCFjfim50=
X-Received: by 2002:a05:6602:2d95:b0:875:b7b6:ae55 with SMTP id
 ca18e2360f4ac-879c08a1821mr619706139f.5.1752732747574; Wed, 16 Jul 2025
 23:12:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1749810735.git.zhouquan@iscas.ac.cn> <7e8f1272337e8d03851fd3bb7f6fc739e604309e.1749810736.git.zhouquan@iscas.ac.cn>
In-Reply-To: <7e8f1272337e8d03851fd3bb7f6fc739e604309e.1749810736.git.zhouquan@iscas.ac.cn>
From: Anup Patel <anup@brainfault.org>
Date: Thu, 17 Jul 2025 11:42:16 +0530
X-Gm-Features: Ac12FXxFyh1m_BsXZWN_jEHg_S_aVC3xq_tjAkTkzVkv4CVtzyvdpf1MklQXrzM
Message-ID: <CAAhSdy3aj_x02cpgxZDfn7tNu5HRfKA8VSZHpE1xJpY_2fABUw@mail.gmail.com>
Subject: Re: [PATCH 2/2] KVM: riscv: selftests: Add common supported test cases
To: zhouquan@iscas.ac.cn
Cc: ajones@ventanamicro.com, atishp@atishpatra.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, linux-kernel@vger.kernel.org, 
	linux-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 13, 2025 at 5:08=E2=80=AFPM <zhouquan@iscas.ac.cn> wrote:
>
> From: Quan Zhou <zhouquan@iscas.ac.cn>
>
> Some common KVM test cases are supported on riscv now as following:
>
>     access_tracking_perf_test
>     demand_paging_test
>     dirty_log_perf_test
>     dirty_log_test
>     guest_print_test
>     kvm_binary_stats_test
>     kvm_create_max_vcpus
>     kvm_page_table_test
>     memslot_modification_stress_test
>     memslot_perf_test
>     rseq_test
>     set_memory_region_test
>
> Add missing headers for tests and fix RISCV_FENCE redefinition
> in `rseq-riscv.h` by using the existing macro from <asm/fence.h>.
>
> Signed-off-by: Quan Zhou <zhouquan@iscas.ac.cn>

Please address Drew's comments and send v2 of only this patch.
The first patch of this series is already queued.

Regards,
Anup

> ---
>  tools/testing/selftests/kvm/Makefile.kvm             | 12 ++++++++++++
>  .../testing/selftests/kvm/include/riscv/processor.h  |  2 ++
>  tools/testing/selftests/rseq/rseq-riscv.h            |  3 +--
>  3 files changed, 15 insertions(+), 2 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/sel=
ftests/kvm/Makefile.kvm
> index 38b95998e1e6..565e191e99c8 100644
> --- a/tools/testing/selftests/kvm/Makefile.kvm
> +++ b/tools/testing/selftests/kvm/Makefile.kvm
> @@ -197,6 +197,18 @@ TEST_GEN_PROGS_riscv +=3D arch_timer
>  TEST_GEN_PROGS_riscv +=3D coalesced_io_test
>  TEST_GEN_PROGS_riscv +=3D get-reg-list
>  TEST_GEN_PROGS_riscv +=3D steal_time
> +TEST_GEN_PROGS_riscv +=3D access_tracking_perf_test
> +TEST_GEN_PROGS_riscv +=3D demand_paging_test
> +TEST_GEN_PROGS_riscv +=3D dirty_log_perf_test
> +TEST_GEN_PROGS_riscv +=3D dirty_log_test
> +TEST_GEN_PROGS_riscv +=3D guest_print_test
> +TEST_GEN_PROGS_riscv +=3D kvm_binary_stats_test
> +TEST_GEN_PROGS_riscv +=3D kvm_create_max_vcpus
> +TEST_GEN_PROGS_riscv +=3D kvm_page_table_test
> +TEST_GEN_PROGS_riscv +=3D memslot_modification_stress_test
> +TEST_GEN_PROGS_riscv +=3D memslot_perf_test
> +TEST_GEN_PROGS_riscv +=3D rseq_test
> +TEST_GEN_PROGS_riscv +=3D set_memory_region_test
>
>  TEST_GEN_PROGS_loongarch +=3D coalesced_io_test
>  TEST_GEN_PROGS_loongarch +=3D demand_paging_test
> diff --git a/tools/testing/selftests/kvm/include/riscv/processor.h b/tool=
s/testing/selftests/kvm/include/riscv/processor.h
> index 162f303d9daa..4cf5ae11760f 100644
> --- a/tools/testing/selftests/kvm/include/riscv/processor.h
> +++ b/tools/testing/selftests/kvm/include/riscv/processor.h
> @@ -9,7 +9,9 @@
>
>  #include <linux/stringify.h>
>  #include <asm/csr.h>
> +#include <asm/vdso/processor.h>
>  #include "kvm_util.h"
> +#include "ucall_common.h"
>
>  #define INSN_OPCODE_MASK       0x007c
>  #define INSN_OPCODE_SHIFT      2
> diff --git a/tools/testing/selftests/rseq/rseq-riscv.h b/tools/testing/se=
lftests/rseq/rseq-riscv.h
> index 67d544aaa9a3..06c840e81c8b 100644
> --- a/tools/testing/selftests/rseq/rseq-riscv.h
> +++ b/tools/testing/selftests/rseq/rseq-riscv.h
> @@ -8,6 +8,7 @@
>   * exception when executed in all modes.
>   */
>  #include <endian.h>
> +#include <asm/fence.h>
>
>  #if defined(__BYTE_ORDER) ? (__BYTE_ORDER =3D=3D __LITTLE_ENDIAN) : defi=
ned(__LITTLE_ENDIAN)
>  #define RSEQ_SIG   0xf1401073  /* csrr mhartid, x0 */
> @@ -24,8 +25,6 @@
>  #define REG_L  __REG_SEL("ld ", "lw ")
>  #define REG_S  __REG_SEL("sd ", "sw ")
>
> -#define RISCV_FENCE(p, s) \
> -       __asm__ __volatile__ ("fence " #p "," #s : : : "memory")
>  #define rseq_smp_mb()  RISCV_FENCE(rw, rw)
>  #define rseq_smp_rmb() RISCV_FENCE(r, r)
>  #define rseq_smp_wmb() RISCV_FENCE(w, w)
> --
> 2.34.1
>

