Return-Path: <kvm+bounces-14715-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B94EF8A61C6
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 05:45:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D51C31C2204D
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 03:45:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA0321B5A4;
	Tue, 16 Apr 2024 03:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="Za2WycaK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f169.google.com (mail-il1-f169.google.com [209.85.166.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CCF617999
	for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 03:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713239106; cv=none; b=k9lMsn6w4Cy9h5Q5hS0LUNjnmMJZQtwt1eIWuMYwEFLMab0uzK46LtvmNrWEo7EcMuICtAOLY3Bi9VUsy6uhP2zsuNsSTWsmM1r00nHzU6UaeQrWXIyngAMNqx2P7zOJg3qozBmKEa1X8/GQHbJjZ+B0+0xba5CtorVGF6BMsOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713239106; c=relaxed/simple;
	bh=rtTj0lpweW3pLEkP0wMSlU8QXFMSyiSZmPuuup9Nu7s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=etwCwE921s+3VGNlVwBKr4U7hMfDX55t6TCXVVZ23kqQ6lDa100aDSJHfHbGPMGnGV4/v6iMBVulb4qw8rf5pY4hMv8n7MlRG0UzDn/laxKVUyhyijE7j2IZVp70SB3H/J87rNn9qzp0AVwm3pJ+fWJh+I/RDzbkkz5l+jKf1Nc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=Za2WycaK; arc=none smtp.client-ip=209.85.166.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f169.google.com with SMTP id e9e14a558f8ab-36a260208e4so18636105ab.2
        for <kvm@vger.kernel.org>; Mon, 15 Apr 2024 20:45:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1713239103; x=1713843903; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GjVNvZt22r+EWb4gHg+TxC04BE92vOXLHjn3wNYwKN4=;
        b=Za2WycaK3pBL14/FWKVRfpHN4xYiAKN/3KwT06D/CZEDPB6+o8U0dKOxF2d3s15LqY
         5ieZ6ko6OU5aWQIV6a1m6xa3qbBeLdCdBd2uPQET7TlyV/wIVRIdwtI9Siu8U41bfbbc
         /XdeLN4JojYgIT45wAWUGs4aNbNFY0dnbOEITIQEmY3lPPnjCnj3396o0XhXclauuZQw
         NvQuqxk9xlj/aTRIPAJlq36BuNDDHFFggn1Omg3O0FHenGZrWNDfpe1s0VJLPwoxiCFM
         9uHq52IYx98WztBwH6B+jU3+hFs+SX5/vb6K1DS5ykDwukDNTxW7C0Uw9PO+V5X1qSkf
         U1iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713239103; x=1713843903;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GjVNvZt22r+EWb4gHg+TxC04BE92vOXLHjn3wNYwKN4=;
        b=jdPHDUbuSdXohcqqLXEPMTowsE5/vYJvP4uGFj6bbovgLDWFArG2nGSwpiVD3wmOXv
         WospyzqhavlOM3s7ukRAm6Ju8KdnlG5lvA7AtjdKYM2x7fwDThdUd6ha6ISO8hI44B8a
         +QhYNPi9MwlO/HQb+Ebvgl8ardCmKr8aXy5yNbsF0oM8UrkJt8feKHBTx0nPg4nrlV2J
         bhh9w98G5rvhVjd/95OQ4h5pFFpMB1cL9IXwi5ZST8vvWiq5Et2ZVoI5fmT0qrZACy9M
         S3SlnoLsG4UHhdaMgPQnZI6oNSO49w2i0mzKKLXYYcdPycTJVp7bGLDxDSMY7RqnjOfL
         a/2g==
X-Forwarded-Encrypted: i=1; AJvYcCURpJZ1WwgvbgUURyKhzP7NheSCEMw8xpVaDgAac0s4bkDRZrTn2joGqPtZ8lWXKjH1nwT6q4I0WS42cfA8SnYZzMtc
X-Gm-Message-State: AOJu0Yz21AJeC7E9bDXHYZKjnZYShFKhtPgfTuJOzwapebBi9tw8CWZP
	VHQpUfv0xfXngkLyLZStUDjMu95AJ2ZePiFSTu7cGPHfER3PxD9/Znacb6iWvsnnece0dj2Tb9Q
	zzUYFA/25dcHJBDr5ajGTiN0hIaNrOEvkmbhcg61qNc7ZZfip
X-Google-Smtp-Source: AGHT+IFEdx6IwRBvg4lNdFx2fXV/SWpM2kkTaLW4RM2l5CIWFBgkJACESXjv1JNdZwpHPIEff6N3sNB/wyIhY+32lZw=
X-Received: by 2002:a05:6e02:1a0f:b0:36b:46b:133b with SMTP id
 s15-20020a056e021a0f00b0036b046b133bmr14616355ild.13.1713239103552; Mon, 15
 Apr 2024 20:45:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240415031131.23443-1-liangshenlin@eswincomputing.com> <20240415031131.23443-2-liangshenlin@eswincomputing.com>
In-Reply-To: <20240415031131.23443-2-liangshenlin@eswincomputing.com>
From: Anup Patel <anup@brainfault.org>
Date: Tue, 16 Apr 2024 09:14:51 +0530
Message-ID: <CAAhSdy1D9x4GJVrXJMzzqU-2iYLxduSHeRvxezmeBTQhgcruJQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] RISCV: KVM: add tracepoints for entry and exit events
To: Shenlin Liang <liangshenlin@eswincomputing.com>
Cc: atishp@atishpatra.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	peterz@infradead.org, mingo@redhat.com, acme@kernel.org, namhyung@kernel.org, 
	mark.rutland@arm.com, alexander.shishkin@linux.intel.com, jolsa@kernel.org, 
	irogers@google.com, adrian.hunter@intel.com, linux-perf-users@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 15, 2024 at 8:45=E2=80=AFAM Shenlin Liang
<liangshenlin@eswincomputing.com> wrote:
>
> Like other architectures, RISCV KVM also needs to add these event
> tracepoints to count the number of times kvm guest entry/exit.
>
> Signed-off-by: Shenlin Liang <liangshenlin@eswincomputing.com>

LGTM.

Reviewed-by: Anup Patel <anup@brainfault.org>

Regards,
Anup

> ---
>  arch/riscv/kvm/trace.h | 67 ++++++++++++++++++++++++++++++++++++++++++
>  arch/riscv/kvm/vcpu.c  |  7 +++++
>  2 files changed, 74 insertions(+)
>  create mode 100644 arch/riscv/kvm/trace.h
>
> diff --git a/arch/riscv/kvm/trace.h b/arch/riscv/kvm/trace.h
> new file mode 100644
> index 000000000000..3d54175d805c
> --- /dev/null
> +++ b/arch/riscv/kvm/trace.h
> @@ -0,0 +1,67 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Tracepoints for RISC-V KVM
> + *
> + * Copyright 2024 Beijing ESWIN Computing Technology Co., Ltd.
> + *
> + */
> +#if !defined(_TRACE_KVM_H) || defined(TRACE_HEADER_MULTI_READ)
> +#define _TRACE_KVM_H
> +
> +#include <linux/tracepoint.h>
> +
> +#undef TRACE_SYSTEM
> +#define TRACE_SYSTEM kvm
> +
> +TRACE_EVENT(kvm_entry,
> +       TP_PROTO(struct kvm_vcpu *vcpu),
> +       TP_ARGS(vcpu),
> +
> +       TP_STRUCT__entry(
> +               __field(unsigned long, pc)
> +       ),
> +
> +       TP_fast_assign(
> +               __entry->pc     =3D vcpu->arch.guest_context.sepc;
> +       ),
> +
> +       TP_printk("PC: 0x016%lx", __entry->pc)
> +);
> +
> +TRACE_EVENT(kvm_exit,
> +       TP_PROTO(struct kvm_cpu_trap *trap),
> +       TP_ARGS(trap),
> +
> +       TP_STRUCT__entry(
> +               __field(unsigned long, sepc)
> +               __field(unsigned long, scause)
> +               __field(unsigned long, stval)
> +               __field(unsigned long, htval)
> +               __field(unsigned long, htinst)
> +       ),
> +
> +       TP_fast_assign(
> +               __entry->sepc           =3D trap->sepc;
> +               __entry->scause         =3D trap->scause;
> +               __entry->stval          =3D trap->stval;
> +               __entry->htval          =3D trap->htval;
> +               __entry->htinst         =3D trap->htinst;
> +       ),
> +
> +       TP_printk("SEPC:0x%lx, SCAUSE:0x%lx, STVAL:0x%lx, HTVAL:0x%lx, HT=
INST:0x%lx",
> +               __entry->sepc,
> +               __entry->scause,
> +               __entry->stval,
> +               __entry->htval,
> +               __entry->htinst)
> +);
> +
> +#endif /* _TRACE_RSICV_KVM_H */
> +
> +#undef TRACE_INCLUDE_PATH
> +#define TRACE_INCLUDE_PATH .
> +#undef TRACE_INCLUDE_FILE
> +#define TRACE_INCLUDE_FILE trace
> +
> +/* This part must be outside protection */
> +#include <trace/define_trace.h>
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index b5ca9f2e98ac..f4e27004ceb8 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -21,6 +21,9 @@
>  #include <asm/cacheflush.h>
>  #include <asm/kvm_vcpu_vector.h>
>
> +#define CREATE_TRACE_POINTS
> +#include "trace.h"
> +
>  const struct _kvm_stats_desc kvm_vcpu_stats_desc[] =3D {
>         KVM_GENERIC_VCPU_STATS(),
>         STATS_DESC_COUNTER(VCPU, ecall_exit_stat),
> @@ -782,6 +785,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>                  */
>                 kvm_riscv_local_tlb_sanitize(vcpu);
>
> +               trace_kvm_entry(vcpu);
> +
>                 guest_timing_enter_irqoff();
>
>                 kvm_riscv_vcpu_enter_exit(vcpu);
> @@ -820,6 +825,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>
>                 local_irq_enable();
>
> +               trace_kvm_exit(&trap);
> +
>                 preempt_enable();
>
>                 kvm_vcpu_srcu_read_lock(vcpu);
> --
> 2.37.2
>

