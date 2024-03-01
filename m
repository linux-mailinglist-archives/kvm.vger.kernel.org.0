Return-Path: <kvm+bounces-10682-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 61E8586E997
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 20:30:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 94E2AB24473
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 19:30:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B38ED3AC19;
	Fri,  1 Mar 2024 19:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="JNOHpvvu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A0903A1B0
	for <kvm@vger.kernel.org>; Fri,  1 Mar 2024 19:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709321415; cv=none; b=iEEtsCvZX+bO8pxi0qUyaDSA4qW61fsbFJYqA669hVo4c8+rKBtMKeUrDxob0D/jMwD9W4TGZYIr12Wf8jIYE8NLyGeTwqr25uk/ZmOByA1CqFKQt4k6jmPU5gHzXSfa/96kZOqoGPb65ud1igXCV+i7e3f5nFk2KKuLqw7J9Fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709321415; c=relaxed/simple;
	bh=31x3y21LpH70GlBu1DdA1CFlQph1h/vZyT25oUhjLhU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mpXGr6VsxAUWyDejIrO+Pq2WNpw6BIX6txJhZ5/w7NQhxQD+UMoi9sdixwZf2Lw+aEfgsiFRcYgC3DYSBT5qqM6Fsn0hn5zkFh+T3QTJWM5jx2x+VhvzJzwdwIcpeP7rHD8vjKtQHDA1YLJkuyg7yLvsQWv14+fAgsblXCFl1A8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=JNOHpvvu; arc=none smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-51325c38d10so1932170e87.1
        for <kvm@vger.kernel.org>; Fri, 01 Mar 2024 11:30:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1709321412; x=1709926212; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KsQincBmT/DYFfglWuXNoT+0WIOyDGqPo/zOjnWnfU0=;
        b=JNOHpvvuVdd8tz1ggRk1VcgQZGkzea+5HHurovTcr+/NbP0e6mbA3zocC4M+QFEPMA
         1wP+sDoQycxciBuQxjQltZ0QZQ+QyrXiOMnACURQBh4YdSdlHjC4stayeUDtuUH/0HVY
         W7gAMeD9ByTn4Awrva20M2wOTzRl5W+cgEaN7P5kabLfBJCG7KvfOnjNnhv/GQwV7hRB
         E1Vsp39i+Eq+wtO+xoEvoxHIthHzhZcuJCO/l7PezjHnf4fO01bv6ZSILSB5sbF7qwkK
         y06cZnGmWqDjz16mYyDydLU7h8zN9PLoJ3/aSQJSFr611CSYQdTGeRaTprtk2ZBA2Lbk
         b2sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709321412; x=1709926212;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KsQincBmT/DYFfglWuXNoT+0WIOyDGqPo/zOjnWnfU0=;
        b=TjlCneLA5qEu8gK+gAzYJQ4/6JL16g334pDzohjk+k5EGPV+PV3VsjZuXF7f1QPJB8
         Z3FksdnXAt5T4gKslOO//fw1w7D1eiCL46onSuLYJaJRHiy1tJfXvqkOeGRAbhG55Z2+
         DI5/ufs7mmgGcktNhfC4cYGJ1I87dXlCEaWo62FdtAlmbWPZM490zd5kFYAevPXYK8fx
         uzXwJDwaMFVbiehR1mIbZiOHYqYFIw5U+7YQweS2MxC6SyxUyAhXKK9AVZyFNIY07HbV
         iyc/NQ3Chx44DqZKNTvTId6yaVOxbM/a/UxwuaknCi2K7KlLNV97kdmajM4t1kWgr+jt
         jC0g==
X-Forwarded-Encrypted: i=1; AJvYcCUg1rZVuU5gzUGHjy1ySCh3AfedNFXRCiP+LFh9g+2CTdm89nCQGZdyxQ+GLecPu8piXcrnJdZeqvgNG1HT7BKhsCGA
X-Gm-Message-State: AOJu0YxLZuH4C4O7xOnmZpFfrY4YA/sOMmqU4ksQwskulOrq6is+Gz+P
	zK4v6F4x/NhnB5tGieSEbI9QwO5bdM6DdGiekKghehgFUs70rPritqoX0QzwWZYxUAQ0TUbHeDc
	ecJCk+BLfdm19Fjl/DuGSeGHkFsyr+LqXeGyjzQ==
X-Google-Smtp-Source: AGHT+IE+PvaR/VOgtC2hoRUjS0qfpwNjV/lMNaZfJiJ9vAQn76qy2Szeh6K3tc4T3wCAmpo/ciJWJCZhYz2vHJy2yy8=
X-Received: by 2002:a05:6512:3993:b0:513:3309:d59a with SMTP id
 j19-20020a056512399300b005133309d59amr1701352lfu.34.1709321411711; Fri, 01
 Mar 2024 11:30:11 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240229010130.1380926-1-atishp@rivosinc.com> <20240229010130.1380926-5-atishp@rivosinc.com>
 <20240301-1a1aa2a2c04640c34749cb5f@orel>
In-Reply-To: <20240301-1a1aa2a2c04640c34749cb5f@orel>
From: Atish Kumar Patra <atishp@rivosinc.com>
Date: Fri, 1 Mar 2024 11:30:00 -0800
Message-ID: <CAHBxVyHCB+GJXyn1TjhXKFD=GNhRzMuRUUx1LjJMxV+3W=y7TQ@mail.gmail.com>
Subject: Re: [PATCH v4 04/15] RISC-V: Add SBI PMU snapshot definitions
To: Andrew Jones <ajones@ventanamicro.com>
Cc: linux-kernel@vger.kernel.org, Anup Patel <anup@brainfault.org>, 
	Palmer Dabbelt <palmer@rivosinc.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alexghiti@rivosinc.com>, Atish Patra <atishp@atishpatra.org>, 
	Conor Dooley <conor.dooley@microchip.com>, Guo Ren <guoren@kernel.org>, 
	Icenowy Zheng <uwu@icenowy.me>, kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-riscv@lists.infradead.org, 
	Mark Rutland <mark.rutland@arm.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Shuah Khan <shuah@kernel.org>, Will Deacon <will@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 1, 2024 at 3:14=E2=80=AFAM Andrew Jones <ajones@ventanamicro.co=
m> wrote:
>
> On Wed, Feb 28, 2024 at 05:01:19PM -0800, Atish Patra wrote:
> > SBI PMU Snapshot function optimizes the number of traps to
> > higher privilege mode by leveraging a shared memory between the S/VS-mo=
de
> > and the M/HS mode. Add the definitions for that extension and new error
> > codes.
> >
> > Reviewed-by: Anup Patel <anup@brainfault.org>
> > Acked-by: Palmer Dabbelt <palmer@rivosinc.com>
> > Signed-off-by: Atish Patra <atishp@rivosinc.com>
> > ---
> >  arch/riscv/include/asm/sbi.h | 11 +++++++++++
> >  1 file changed, 11 insertions(+)
> >
> > diff --git a/arch/riscv/include/asm/sbi.h b/arch/riscv/include/asm/sbi.=
h
> > index ef8311dafb91..dfa830f7d54b 100644
> > --- a/arch/riscv/include/asm/sbi.h
> > +++ b/arch/riscv/include/asm/sbi.h
> > @@ -132,6 +132,7 @@ enum sbi_ext_pmu_fid {
> >       SBI_EXT_PMU_COUNTER_STOP,
> >       SBI_EXT_PMU_COUNTER_FW_READ,
> >       SBI_EXT_PMU_COUNTER_FW_READ_HI,
> > +     SBI_EXT_PMU_SNAPSHOT_SET_SHMEM,
> >  };
> >
> >  union sbi_pmu_ctr_info {
> > @@ -148,6 +149,13 @@ union sbi_pmu_ctr_info {
> >       };
> >  };
> >
> > +/* Data structure to contain the pmu snapshot data */
> > +struct riscv_pmu_snapshot_data {
> > +     u64 ctr_overflow_mask;
> > +     u64 ctr_values[64];
> > +     u64 reserved[447];
> > +};
> > +
> >  #define RISCV_PMU_RAW_EVENT_MASK GENMASK_ULL(47, 0)
> >  #define RISCV_PMU_RAW_EVENT_IDX 0x20000
> >
> > @@ -244,9 +252,11 @@ enum sbi_pmu_ctr_type {
> >
> >  /* Flags defined for counter start function */
> >  #define SBI_PMU_START_FLAG_SET_INIT_VALUE (1 << 0)
>
> A patch before this which changes all flags to use BIT() instead of shift=
s
> would be good, since otherwise the new flags are inconsistent.
>

Done.

>
> > +#define SBI_PMU_START_FLAG_INIT_FROM_SNAPSHOT BIT(1)
>
> This is named SBI_PMU_START_FLAG_INIT_SNAPSHOT in the spec.
>

Fixed.

>
> >
> >  /* Flags defined for counter stop function */
> >  #define SBI_PMU_STOP_FLAG_RESET (1 << 0)
> > +#define SBI_PMU_STOP_FLAG_TAKE_SNAPSHOT BIT(1)
> >
> >  enum sbi_ext_dbcn_fid {
> >       SBI_EXT_DBCN_CONSOLE_WRITE =3D 0,
> > @@ -285,6 +295,7 @@ struct sbi_sta_struct {
> >  #define SBI_ERR_ALREADY_AVAILABLE -6
> >  #define SBI_ERR_ALREADY_STARTED -7
> >  #define SBI_ERR_ALREADY_STOPPED -8
> > +#define SBI_ERR_NO_SHMEM     -9
> >
> >  extern unsigned long sbi_spec_version;
> >  struct sbiret {
> > --
> > 2.34.1
> >
>
> Thanks,
> drew

