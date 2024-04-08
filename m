Return-Path: <kvm+bounces-13883-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E624389BEA8
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 14:08:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9BFF3283A6F
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 12:08:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BFF66F06E;
	Mon,  8 Apr 2024 12:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="AKIG5uw5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFB816A337
	for <kvm@vger.kernel.org>; Mon,  8 Apr 2024 12:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712578058; cv=none; b=KprQPxlKLv7+v31ODWW4hiqNEE1qvQYC/0QlQGFpOwAPgdLhXk1B96r2sQsDruhBmj28w/GerFsZG6gY+Rn+P6++7mI75Vk3DDZ5vxorAar7Ip1kf58KlG8P7XjfmnbWB2WASPqab544C5iDVv0r2WH0wEi5kQGR7vB9bjHCx9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712578058; c=relaxed/simple;
	bh=ceBSqJ4HrDGpuiUBK8Miv6Kqwd6mxdCXZsrKQfo/3Fo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SxIPEczfyawpkxSIhJ/CF8rqZEWdrtcZbY5hJImd+n5UdSSsHdL98tS67YGebGY/qtwHBwDUlcd9qek9NKhHNLy5YNU1w9JAnzBDm2BpGPK0Tka2eBOd6ATsWANpbB7gyAOpuLptQnwjhIXXNuZ94ScIXELtISdUtUIKd+Y/46g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=AKIG5uw5; arc=none smtp.client-ip=209.85.166.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-36a1140bd21so9835595ab.3
        for <kvm@vger.kernel.org>; Mon, 08 Apr 2024 05:07:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1712578055; x=1713182855; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ysPdkHofn0SsqVjUlorA7HM2PSEU9x+PNO7DRN4CxYo=;
        b=AKIG5uw5rtwhEwoCyvfgGm5l8PoazjC89SKQX84++eIYOjvuYK3WS8+nl1ZaSyzDSt
         oxPZ97fh4LOk/IHS95qfiwFLuUDlEogd09xNhPIgQ3sRWKM/vpFb6apkq8y4Bcf8RF/B
         xDJR5keEwZg7g0IpbYLXwSOys8T2ZA+taRmS+o/wBldvMgp8ydJTiVlq59MqoP7emzrW
         LNfMVi8FDvIVtqtVdJNGPQAlYTePX+yt6PIKTz1aqCzIPei7RuzzdTjX9kVbTzAQs8dr
         zLPLHpj3f+8Gy6j34S1vfsbCXol+RYNVvUKhYwiduDMtvIkDMkPNzl+4YfzTGP2339/+
         D3pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712578055; x=1713182855;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ysPdkHofn0SsqVjUlorA7HM2PSEU9x+PNO7DRN4CxYo=;
        b=DhXRw8Ar2tifIASPwOrGr9PEGJLfULz6CDv3R+bItgx05Gvte5cokjcdedZA2wuT/B
         i+cj6BARgCK+C5vKhLkfrCCOy4E6VEdVsU/lryXVOBuSOsK+Gn7Kk6EDx3yo6DA93DIu
         jg6cyWHGgdlAEh8oJx4ycy3eJZ5KbQ9M703n9mPwdSxTeXvS7Hika/Hb2zZ/cOWXINTB
         ql9y/id8Oe2gnKW3mqKWBDThs8OmaZ2XN2EWPjlVDi30EiFFUV9RAa9NNPvcf5Xr2lwe
         zU+ui2Ujq0u3AijGpF8xE7R3x4pNGOc8dOS1PDxwJMRnhUxSiXeCdpDg+/sPoXbxgUY6
         8vAQ==
X-Forwarded-Encrypted: i=1; AJvYcCUj9XXQHxF0OpZDsAqHxyZYer/RQQLhlDoNrYCnJOIcW5vCnTIgOLMxtDsFfChMTuunyhcpkskS8hsd8OMQ2d8c516G
X-Gm-Message-State: AOJu0Yygj6AvNPCx+qijHKgcZoqPE8H+tZNHD4IhM+tYnWcxhlZssqmH
	+pI0Qx8vZ3503FqjtExB26DZ1Pajr76WNbOJEwK6sWAz2cr698CymzyGL+hwaINeAEQqcmEet7v
	Jmdt2ZlN6HsjNO+qiaRo6Qwqt2feEMitvacfiAw==
X-Google-Smtp-Source: AGHT+IHUq83zNBHTpl7MmDd5GJ1Gg5JdecBzvdbUwm0GbS2BKl2pv80jCI4+BNP4aYrjw+ttNoV+f0bZ5iomvms7YJo=
X-Received: by 2002:a05:6e02:1568:b0:36a:2872:90d4 with SMTP id
 k8-20020a056e02156800b0036a287290d4mr1779608ilu.26.1712578054731; Mon, 08 Apr
 2024 05:07:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240328031220.1287-1-liangshenlin@eswincomputing.com> <20240328031220.1287-2-liangshenlin@eswincomputing.com>
In-Reply-To: <20240328031220.1287-2-liangshenlin@eswincomputing.com>
From: Anup Patel <anup@brainfault.org>
Date: Mon, 8 Apr 2024 17:37:23 +0530
Message-ID: <CAAhSdy0DgW055iV7=_D6iOLr1iVeK9SZmG8hqBG0_hb1z=+07g@mail.gmail.com>
Subject: Re: [PATCH 1/2] RISCV: KVM: add tracepoints for entry and exit events
To: Shenlin Liang <liangshenlin@eswincomputing.com>
Cc: atishp@atishpatra.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	peterz@infradead.org, mingo@redhat.com, acme@kernel.org, namhyung@kernel.org, 
	mark.rutland@arm.com, alexander.shishkin@linux.intel.com, jolsa@kernel.org, 
	irogers@google.com, adrian.hunter@intel.com, linux-perf-users@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 28, 2024 at 8:49=E2=80=AFAM Shenlin Liang
<liangshenlin@eswincomputing.com> wrote:
>
> Like other architectures, RISCV KVM also needs to add these event
> tracepoints to count the number of times kvm guest entry/exit.
>
> Signed-off-by: Shenlin Liang <liangshenlin@eswincomputing.com>
> ---
>  arch/riscv/kvm/trace_riscv.h | 60 ++++++++++++++++++++++++++++++++++++
>  arch/riscv/kvm/vcpu.c        |  7 +++++
>  2 files changed, 67 insertions(+)
>  create mode 100644 arch/riscv/kvm/trace_riscv.h
>
> diff --git a/arch/riscv/kvm/trace_riscv.h b/arch/riscv/kvm/trace_riscv.h
> new file mode 100644
> index 000000000000..5848083c7a5e
> --- /dev/null
> +++ b/arch/riscv/kvm/trace_riscv.h
> @@ -0,0 +1,60 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Tracepoints for RISC-V KVM
> + *
> + * Copyright 2024 Beijing ESWIN Computing Technology Co., Ltd.
> + *
> + */
> +#if !defined(_TRACE_RSICV_KVM_H) || defined(TRACE_HEADER_MULTI_READ)
> +#define _TRACE_RSICV_KVM_H

s/_RSICV_/_RISCV_/

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
> +       TP_printk("PC: 0x%016lx", __entry->pc)
> +);
> +
> +TRACE_EVENT(kvm_exit,
> +       TP_PROTO(struct kvm_vcpu *vcpu, unsigned long exit_reason,
> +                       unsigned long scause),
> +       TP_ARGS(vcpu, exit_reason, scause),
> +
> +       TP_STRUCT__entry(
> +               __field(unsigned long, pc)
> +               __field(unsigned long, exit_reason)
> +               __field(unsigned long, scause)

This is not the right contents describing a KVM exit.

The fields over here should be aligned with "struct kvm_cpu_trap"
so we should have following fields:
    __field(unsigned long, sepc)
    __field(unsigned long, scause)
    __field(unsigned long, stval)
    __field(unsigned long, htval)
    __field(unsigned long, htinst)

> +       ),
> +
> +       TP_fast_assign(
> +               __entry->pc             =3D vcpu->arch.guest_context.sepc=
;
> +               __entry->exit_reason    =3D exit_reason;
> +               __entry->scause         =3D scause;
> +       ),
> +
> +       TP_printk("EXIT_REASON:0x%lx,PC: 0x%016lx,SCAUSE:0x%lx",
> +                       __entry->exit_reason, __entry->pc, __entry->scaus=
e)
> +);
> +
> +#endif /* _TRACE_RSICV_KVM_H */
> +
> +#undef TRACE_INCLUDE_PATH
> +#define TRACE_INCLUDE_PATH .
> +#undef TRACE_INCLUDE_FILE
> +#define TRACE_INCLUDE_FILE trace_riscv
> +
> +/* This part must be outside protection */
> +#include <trace/define_trace.h>
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index b5ca9f2e98ac..ed0932f0d514 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -21,6 +21,9 @@
>  #include <asm/cacheflush.h>
>  #include <asm/kvm_vcpu_vector.h>
>
> +#define CREATE_TRACE_POINTS
> +#include "trace_riscv.h"
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
> +               trace_kvm_exit(vcpu, run->exit_reason, trap.scause);
> +
>                 preempt_enable();
>
>                 kvm_vcpu_srcu_read_lock(vcpu);
> --
> 2.37.2
>

Regards,
Anup

