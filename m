Return-Path: <kvm+bounces-19002-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 792808FE274
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 11:22:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DD9291F24661
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 09:22:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 569F613F42D;
	Thu,  6 Jun 2024 09:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="ALwb9oLw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f178.google.com (mail-il1-f178.google.com [209.85.166.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC50219D8B5
	for <kvm@vger.kernel.org>; Thu,  6 Jun 2024 09:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717665664; cv=none; b=ArYT4uTue4I0Ut87DGdXiaZ0g3VjoEgmfTSZvw0VGtgwG57F3K5sQDx+nikdRMaMULyTAE+puBo0j+LIfa5/Wev3Bn68t+L/7lXv7xos/6KyHGQbMaZGiOQUl5QvCOjmTKnCYggQZQCJkmfupZLao37T/a1mdDyZTgBV3VxC+2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717665664; c=relaxed/simple;
	bh=WSjcwc3qIu3YfJ++yrfMiL6FsdH4/JsJR+KDt7ie71Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=m5kY4ET8QzbmdZ09V6BSCcWZ0sKaTnTJl7M/na4z++QODYmQ7YMrKIyPh3J8j9cx5hjyl99yy4pzcBRNr5zHhC2Kg78nLUGbP0Qvu9sMsNO5qUyUVFDdSlxwfDYt3ayg8d5og47Qd222SaAfaVONV0nT6G/lu/UKvzcEY8uM1J4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=ALwb9oLw; arc=none smtp.client-ip=209.85.166.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f178.google.com with SMTP id e9e14a558f8ab-3748ca2a251so3124625ab.0
        for <kvm@vger.kernel.org>; Thu, 06 Jun 2024 02:21:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1717665661; x=1718270461; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AdJFT3+u1sx6Ka9DdK4imlo+hWjtAf82CvjoDoTozfE=;
        b=ALwb9oLwUayhyeuHaZ1QdR+xZQcNVjK91coIMe7HNz/8PtxlOdwyTBPQwbkkz61QkX
         SmqVP6YBk5weIFX2GPdrQrLzJLivG1WhQHJvINC+I01u3eWjCDDnoZENx4xdA6R9HOFy
         g1PIy/vQ5a4+NVfvM8QNeLvzrLDojnLOz8UhF8EY0jLT1/obU9EkmmJoK9QSfCS5rEzQ
         77kXUOAzEqoMG3AHNdjuA/YFAi1ZdkHhGp54bh4d2gpSSPy9s0yPrq7OBswCXWzNY7Wu
         iiIgCZvn1/5W734LYT8CEuvDKhnn1/xNn9P+lfu5LSh5G40gwQlr9AOgKh8Iv21/iU2Q
         EzNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717665661; x=1718270461;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AdJFT3+u1sx6Ka9DdK4imlo+hWjtAf82CvjoDoTozfE=;
        b=dMYVG1epxaB9sEunvfAioQtfMsj6T4V0piPgk8TvfiYwSomvMqxa4YKdIpsqAKLamK
         3GwcSvp2X/9PZWqQ5bk+ifZ+ddcLUrb30znDV7qiLBytxFM53rlJzCWsNGXpRQhTwpaL
         2LM3DNzusXivXpGPK5w8Un1VqVF/DRDc4C8ghWSai7mVnYG4a1gQkMa9x6MUEyzLCGGz
         bdRHJBUL+4x+LGvA3w1EDh5j80mpquxton8w8cb50WygVqoDjKDa1nPJ3rxvPbnTFkQ3
         64BNaMaxkWJNtE2H5ZnvTZXI2m3e2qOQrymcnrPZ+DhM439lJQcNkY26wEK7R+sUb+LD
         dtHQ==
X-Forwarded-Encrypted: i=1; AJvYcCXb06V7hjT1hBhn9MEU2Q37KdU/zjX9ApIVzL+7TF4Ysa4Pk6olASrNUKpN8kB5iYkY6W/9Bz39PvyDspnZxBn3XutB
X-Gm-Message-State: AOJu0YwaozPgtKmAwyYCX8R0lroqRU099WZ5mplNwZNv8yyc4kFSzKBK
	x3L5O/cdTEM4pEZYzJZ8r7Erywn+OCoRjzArIjKBemsvuWodq0+wPnIdJwAGZ/GousIPZS6eZ9w
	vMsNjST2dVADZeJzCfrsA6xFtUeUz964bHykocA==
X-Google-Smtp-Source: AGHT+IE8YaOoLCQa7Dozfw5ABFzfn4U30/iv1AHjlqK24vEsauUk0R4EPjGHHwgvhsSuZpl+WSU9M4bDGfvRA8iArzk=
X-Received: by 2002:a05:6e02:1fe6:b0:374:9cdc:7a3a with SMTP id
 e9e14a558f8ab-374b1ef4a7dmr55256965ab.11.1717665660959; Thu, 06 Jun 2024
 02:21:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240422080833.8745-1-liangshenlin@eswincomputing.com>
In-Reply-To: <20240422080833.8745-1-liangshenlin@eswincomputing.com>
From: Anup Patel <anup@brainfault.org>
Date: Thu, 6 Jun 2024 14:50:49 +0530
Message-ID: <CAAhSdy0+174Mgiw=bD8SENFz8+izE9wy=ABM_MiuvH7Wjhqf+A@mail.gmail.com>
Subject: Re: [PATCH v3 0/2] perf kvm: Add kvm stat support on riscv
To: Shenlin Liang <liangshenlin@eswincomputing.com>
Cc: atishp@atishpatra.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	peterz@infradead.org, mingo@redhat.com, acme@kernel.org, namhyung@kernel.org, 
	mark.rutland@arm.com, alexander.shishkin@linux.intel.com, jolsa@kernel.org, 
	irogers@google.com, adrian.hunter@intel.com, linux-perf-users@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 22, 2024 at 1:42=E2=80=AFPM Shenlin Liang
<liangshenlin@eswincomputing.com> wrote:
>
> 'perf kvm stat report/record' generates a statistical analysis of KVM
> events and can be used to analyze guest exit reasons. This patch tries
> to add stat support on riscv.
>
> Map the return value of trace_kvm_exit() to the specific cause of the
> exception, and export it to userspace.
>
> It records on two available KVM tracepoints for riscv: "kvm:kvm_entry"
> and "kvm:kvm_exit", and reports statistical data which includes events
> handles time, samples, and so on.
>
> Cross compiling perf in X86 environment may encounter issues with missing
> libraries and tools. Suggest compiling nativly in RISC-V environment
>
> Simple tests go below:
>
> # ./perf kvm record -e "kvm:kvm_entry" -e "kvm:kvm_exit"
> Lowering default frequency rate from 4000 to 2500.
> Please consider tweaking /proc/sys/kernel/perf_event_max_sample_rate.
> [ perf record: Woken up 18 times to write data ]
> [ perf record: Captured and wrote 5.433 MB perf.data.guest (62519 samples=
)
>
> # ./perf kvm report
> 31K kvm:kvm_entry
> 31K kvm:kvm_exit
>
> # ./perf kvm stat record -a
> [ perf record: Woken up 3 times to write data ]
> [ perf record: Captured and wrote 8.502 MB perf.data.guest (99338 samples=
) ]
>
> # ./perf kvm stat report --event=3Dvmexit
> Event name                Samples   Sample%    Time (ns)     Time%   Max =
Time (ns)   Min Time (ns)  Mean Time (ns)
> STORE_GUEST_PAGE_FAULT     26968     54.00%    2003031800    40.00%     3=
361400         27600          74274
> LOAD_GUEST_PAGE_FAULT      17645     35.00%    1153338100    23.00%     2=
513400         30800          65363
> VIRTUAL_INST_FAULT         1247      2.00%     340820800     6.00%      1=
190800         43300          273312
> INST_GUEST_PAGE_FAULT      1128      2.00%     340645800     6.00%      2=
123200         30200          301990
> SUPERVISOR_SYSCALL         1019      2.00%     245989900     4.00%      1=
851500         29300          241403
> LOAD_ACCESS                986       1.00%     671556200     13.00%     4=
180200         100700         681091
> INST_ACCESS                655       1.00%     170054800     3.00%      1=
808300         54600          259625
> HYPERVISOR_SYSCALL         21        0.00%     4276400       0.00%      7=
16500          116000         203638
>
> Changes from v1->v2:
> - Rebased on Linux 6.9-rc3.
>
> Changes from v2->v3:
> - Add the missing assignment for 'vcpu_id_str' in patch 2.
> - Remove parentheses that cause compilation errors
>
> Shenlin Liang (2):
>   RISCV: KVM: add tracepoints for entry and exit events
>   perf kvm/riscv: Port perf kvm stat to RISC-V
>
>  arch/riscv/kvm/trace.h                        | 67 ++++++++++++++++
>  arch/riscv/kvm/vcpu.c                         |  7 ++
>  tools/perf/arch/riscv/Makefile                |  1 +
>  tools/perf/arch/riscv/util/Build              |  1 +
>  tools/perf/arch/riscv/util/kvm-stat.c         | 79 +++++++++++++++++++
>  .../arch/riscv/util/riscv_exception_types.h   | 35 ++++++++
>  6 files changed, 190 insertions(+)
>  create mode 100644 arch/riscv/kvm/trace.h
>  create mode 100644 tools/perf/arch/riscv/util/kvm-stat.c
>  create mode 100644 tools/perf/arch/riscv/util/riscv_exception_types.h

Queued this series for Linux-6.11

Thanks,
Anup

