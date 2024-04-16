Return-Path: <kvm+bounces-14718-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 41A7D8A6253
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 06:18:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BAF631F2123B
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 04:18:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D689B37160;
	Tue, 16 Apr 2024 04:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="eNzKnc7/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE1CE23767
	for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 04:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713241083; cv=none; b=TrWwmNEjOHZEMNWyZa5/y3VC7AlfxEOLoRWsISkBJYrsRjTgDJePoxf8aKsyiCJNuw0l6CbWCpDTR09Vp5TtabtIj3oWlh5P1RQP3pOpMNiRGtFRHZe518CADArqcYi0psKUTEZAdUF6CInPR3TVhkMNnVpkDHWumV/KURyDLKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713241083; c=relaxed/simple;
	bh=nqZc/zqeI8mE/EuLZR8yNvRozNBYcUlzSgf/sfXXHoM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QIq98Z/Kk6QAN+kEARO3Ny+sTqOR7sdXg/0nAI6412OfrM6Nh0vF/FsqkqEoZX5dPYDsGwVsAM3qNRxyTqSAFl3N1W3rx6AixcxrhH3U+60opdyDyldYxPdjx0QnrMzcgjlq/x4VLd/RPZac48VyKEwbaqv/4iOVGseTsoF7eUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=eNzKnc7/; arc=none smtp.client-ip=209.85.166.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-36b04b101b0so16589905ab.1
        for <kvm@vger.kernel.org>; Mon, 15 Apr 2024 21:18:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1713241080; x=1713845880; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gAuDnQkBePCCRBA4gBXUbNdcJ4A8ZQKpcK9ZYMj4ixU=;
        b=eNzKnc7/UWTurTtAqwf0KDDuoIJgTADNgTrOYfshk0HO6gKjh/vrfLSguBapMjCfiR
         HoW6qz/4a1hiwk4EHoJkRp4NJxTeAFN0hPQ2eq2x2oQOm0cu8OkE6dYmjaUfrQ7uc3iC
         oC26iH7ZtNfjhIoV+xMa0qTL9mQwIIolX4c1F84IwzarnkjOlSXT9DxN/e2abBWIpHsl
         b5e8G+lfM6pwc0UEfGwUZlbqZdW+MTp/cHqXLfthy+iUyYeYzQkT/qth22RyIdBiRlWT
         krmgayDeL5VrOX3CEsWvqZTpn570MeweItgyFIppquyTPeROsUBBmTfyFcD1YxcRAanG
         Rq9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713241080; x=1713845880;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gAuDnQkBePCCRBA4gBXUbNdcJ4A8ZQKpcK9ZYMj4ixU=;
        b=FfJkTpsUT5wGoRCWLjUubAon0nZ6thT7bnEYcTzSeyDcj/ssotoDQIiGI3dr+vIK0O
         cjognzjjzs5hxm6vw9zMu5L9IxlR7+dWCx9gXenJ6GzzqGamOQ/EssnrQpG+gBCbdtAE
         684EGiZL8a8eabddmYRs2vqGxE/WwMkkJJI4pOMCZRM24uIreTj5SBPX14P3AZRpv0yI
         E4ORyVQCUPyNMBhggZA3NvmANb5fFJrePeWE2zeczTfNGsgtjYLBhywexlFQ1DDvmgF4
         Vo9BiSFHton+E6yn709zn2sJ39lQ3wLdINm0iKuzNkBnR/IxuLHrflNJKRbFl0TmpnxQ
         9ChA==
X-Forwarded-Encrypted: i=1; AJvYcCW7+V8BljQSaoJybhYoWXbDd3d4WrBROmo7fh8h8UeF8urKZ6j/zgXGZQgXWsPDPF5fYb54YLbo1Ph9QeqJpbPxMHp5
X-Gm-Message-State: AOJu0YxHnB/+a/CCxzbESMZ80DNq1+qCZlx5YlmHmz4gTASmOgtGqLJj
	080hOJq8s73je8TK806/+syKUa6rpc0U9VGhswFF1rOwvQCHxfFlz2YowpMkOzedKJrmyAiVQRN
	IUP+vpEjnmighV6thQmC9TZoznA5L9ANIEZbVVw==
X-Google-Smtp-Source: AGHT+IFWpllJyARxELteXeEA6GOzuq9CBW5v25j+rCyBIdCoAZC4nyDKJEv30B3yEb59er4ybvWD/POKnoWTKcvkxbE=
X-Received: by 2002:a05:6e02:12cc:b0:36b:16:9b5e with SMTP id
 i12-20020a056e0212cc00b0036b00169b5emr15916805ilm.29.1713241079929; Mon, 15
 Apr 2024 21:17:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240415031131.23443-1-liangshenlin@eswincomputing.com> <20240415031131.23443-3-liangshenlin@eswincomputing.com>
In-Reply-To: <20240415031131.23443-3-liangshenlin@eswincomputing.com>
From: Anup Patel <anup@brainfault.org>
Date: Tue, 16 Apr 2024 09:47:48 +0530
Message-ID: <CAAhSdy2Lu_qdF+FqJGxZYqDHgNQCt7vkWtrV0bUOzzmKixALRw@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] perf kvm/riscv: Port perf kvm stat to RISC-V
To: peterz@infradead.org
Cc: atishp@atishpatra.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	mingo@redhat.com, acme@kernel.org, namhyung@kernel.org, mark.rutland@arm.com, 
	alexander.shishkin@linux.intel.com, jolsa@kernel.org, irogers@google.com, 
	adrian.hunter@intel.com, linux-perf-users@vger.kernel.org, 
	Shenlin Liang <liangshenlin@eswincomputing.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 15, 2024 at 8:45=E2=80=AFAM Shenlin Liang
<liangshenlin@eswincomputing.com> wrote:
>
> 'perf kvm stat report/record' generates a statistical analysis of KVM
> events and can be used to analyze guest exit reasons.
>
> "report" reports statistical analysis of guest exit events.
>
> To record kvm events on the host:
>  # perf kvm stat record -a
>
> To report kvm VM EXIT events:
>  # perf kvm stat report --event=3Dvmexit
>
> Signed-off-by: Shenlin Liang <liangshenlin@eswincomputing.com>

LGTM.

Reviewed-by: Anup Patel <anup@brainfault.org>

@Peter Zijlstra, is it okay to take this through the KVM RISC-V tree ?

Regards,
Anup

> ---
>  tools/perf/arch/riscv/Makefile                |  1 +
>  tools/perf/arch/riscv/util/Build              |  1 +
>  tools/perf/arch/riscv/util/kvm-stat.c         | 78 +++++++++++++++++++
>  .../arch/riscv/util/riscv_exception_types.h   | 41 ++++++++++
>  4 files changed, 121 insertions(+)
>  create mode 100644 tools/perf/arch/riscv/util/kvm-stat.c
>  create mode 100644 tools/perf/arch/riscv/util/riscv_exception_types.h
>
> diff --git a/tools/perf/arch/riscv/Makefile b/tools/perf/arch/riscv/Makef=
ile
> index a8d25d005207..e1e445615536 100644
> --- a/tools/perf/arch/riscv/Makefile
> +++ b/tools/perf/arch/riscv/Makefile
> @@ -3,3 +3,4 @@ PERF_HAVE_DWARF_REGS :=3D 1
>  endif
>  PERF_HAVE_ARCH_REGS_QUERY_REGISTER_OFFSET :=3D 1
>  PERF_HAVE_JITDUMP :=3D 1
> +HAVE_KVM_STAT_SUPPORT :=3D 1
> \ No newline at end of file
> diff --git a/tools/perf/arch/riscv/util/Build b/tools/perf/arch/riscv/uti=
l/Build
> index 603dbb5ae4dc..d72b04f8d32b 100644
> --- a/tools/perf/arch/riscv/util/Build
> +++ b/tools/perf/arch/riscv/util/Build
> @@ -1,5 +1,6 @@
>  perf-y +=3D perf_regs.o
>  perf-y +=3D header.o
>
> +perf-$(CONFIG_LIBTRACEEVENT) +=3D kvm-stat.o
>  perf-$(CONFIG_DWARF) +=3D dwarf-regs.o
>  perf-$(CONFIG_LIBDW_DWARF_UNWIND) +=3D unwind-libdw.o
> diff --git a/tools/perf/arch/riscv/util/kvm-stat.c b/tools/perf/arch/risc=
v/util/kvm-stat.c
> new file mode 100644
> index 000000000000..db7183e0f09f
> --- /dev/null
> +++ b/tools/perf/arch/riscv/util/kvm-stat.c
> @@ -0,0 +1,78 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Arch specific functions for perf kvm stat.
> + *
> + * Copyright 2024 Beijing ESWIN Computing Technology Co., Ltd.
> + *
> + */
> +#include <errno.h>
> +#include <memory.h>
> +#include "../../../util/evsel.h"
> +#include "../../../util/kvm-stat.h"
> +#include "riscv_exception_types.h"
> +#include "debug.h"
> +
> +define_exit_reasons_table(riscv_exit_reasons, kvm_riscv_exception_class)=
;
> +
> +const char *kvm_exit_reason =3D "scause";
> +const char *kvm_entry_trace =3D "kvm:kvm_entry";
> +const char *kvm_exit_trace =3D "kvm:kvm_exit";
> +
> +const char *kvm_events_tp[] =3D {
> +       "kvm:kvm_entry",
> +       "kvm:kvm_exit",
> +       NULL,
> +};
> +
> +static void event_get_key(struct evsel *evsel,
> +                         struct perf_sample *sample,
> +                         struct event_key *key)
> +{
> +       key->info =3D 0;
> +       key->key =3D evsel__intval(evsel, sample, kvm_exit_reason);
> +       key->key =3D (int)key->key;
> +       key->exit_reasons =3D riscv_exit_reasons;
> +}
> +
> +static bool event_begin(struct evsel *evsel,
> +                       struct perf_sample *sample __maybe_unused,
> +                       struct event_key *key __maybe_unused)
> +{
> +       return evsel__name_is(evsel, kvm_entry_trace);
> +}
> +
> +static bool event_end(struct evsel *evsel,
> +                     struct perf_sample *sample,
> +                     struct event_key *key)
> +{
> +       if (evsel__name_is(evsel, kvm_exit_trace)) {
> +               event_get_key(evsel, sample, key);
> +               return true;
> +       }
> +       return false;
> +}
> +
> +static struct kvm_events_ops exit_events =3D {
> +       .is_begin_event =3D event_begin,
> +       .is_end_event   =3D event_end,
> +       .decode_key     =3D exit_event_decode_key,
> +       .name           =3D "VM-EXIT"
> +};
> +
> +struct kvm_reg_events_ops kvm_reg_events_ops[] =3D {
> +       {
> +               .name   =3D "vmexit",
> +               .ops    =3D &exit_events,
> +       },
> +       { NULL, NULL },
> +};
> +
> +const char * const kvm_skip_events[] =3D {
> +       NULL,
> +};
> +
> +int cpu_isa_init(struct perf_kvm_stat *kvm, const char *cpuid __maybe_un=
used)
> +{
> +       kvm->exit_reasons_isa =3D "riscv64";
> +       return 0;
> +}
> diff --git a/tools/perf/arch/riscv/util/riscv_exception_types.h b/tools/p=
erf/arch/riscv/util/riscv_exception_types.h
> new file mode 100644
> index 000000000000..2e42150f72b2
> --- /dev/null
> +++ b/tools/perf/arch/riscv/util/riscv_exception_types.h
> @@ -0,0 +1,41 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * RISCV exception types
> + *
> + * Copyright 2024 Beijing ESWIN Computing Technology Co., Ltd.
> + *
> + */
> +#ifndef ARCH_PERF_RISCV_EXCEPTION_TYPES_H
> +#define ARCH_PERF_RISCV_EXCEPTION_TYPES_H
> +
> +#define EXC_INST_MISALIGNED 0
> +#define EXC_INST_ACCESS 1
> +#define EXC_INST_ILLEGAL 2
> +#define EXC_BREAKPOINT 3
> +#define EXC_LOAD_MISALIGNED 4
> +#define EXC_LOAD_ACCESS 5
> +#define EXC_STORE_MISALIGNED 6
> +#define EXC_STORE_ACCESS 7
> +#define EXC_SYSCALL 8
> +#define EXC_HYPERVISOR_SYSCALL 9
> +#define EXC_SUPERVISOR_SYSCALL 10
> +#define EXC_INST_PAGE_FAULT 12
> +#define EXC_LOAD_PAGE_FAULT 13
> +#define EXC_STORE_PAGE_FAULT 15
> +#define EXC_INST_GUEST_PAGE_FAULT 20
> +#define EXC_LOAD_GUEST_PAGE_FAULT 21
> +#define EXC_VIRTUAL_INST_FAULT 22
> +#define EXC_STORE_GUEST_PAGE_FAULT 23
> +
> +#define EXC(x) {EXC_##x, #x }
> +
> +#define kvm_riscv_exception_class                                       =
    \
> +       (EXC(INST_MISALIGNED), EXC(INST_ACCESS), EXC(INST_ILLEGAL),      =
   \
> +        EXC(BREAKPOINT), EXC(LOAD_MISALIGNED), EXC(LOAD_ACCESS),        =
   \
> +        EXC(STORE_MISALIGNED), EXC(STORE_ACCESS), EXC(SYSCALL),         =
   \
> +        EXC(HYPERVISOR_SYSCALL), EXC(SUPERVISOR_SYSCALL),               =
   \
> +        EXC(INST_PAGE_FAULT), EXC(LOAD_PAGE_FAULT), EXC(STORE_PAGE_FAULT=
), \
> +        EXC(INST_GUEST_PAGE_FAULT), EXC(LOAD_GUEST_PAGE_FAULT),         =
   \
> +        EXC(VIRTUAL_INST_FAULT), EXC(STORE_GUEST_PAGE_FAULT))
> +
> +#endif /* ARCH_PERF_RISCV_EXCEPTION_TYPES_H */
> --
> 2.37.2
>

