Return-Path: <kvm+bounces-19043-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 605F18FF8A8
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2024 02:28:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A89A7B2336F
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2024 00:28:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFD9A4C80;
	Fri,  7 Jun 2024 00:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A+r1MyX3"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA32C4C83;
	Fri,  7 Jun 2024 00:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717720075; cv=none; b=lttYQID9tq9oOIlc1VYcBf79+kX2vu3RK25JYItHQoITQt/P3KGOclB8AtmWpSdxS9vc/jVgcev9nT4XW6zNKzsiNzqc2iKK6rYIzaJJ1IoIBnjQsGuJ89xGXgO/AF6idQnUpYcY10YMLK5RenHPHrPWbTYWWOjofq2VryVGA34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717720075; c=relaxed/simple;
	bh=FQTqwYknv8JIZqJzJar6YMQ0/CLZjse4O5WXBBaPRL0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nLyq69rdJcbKPeqXQwt5aP3A440Ue0uWmue++VUQqusmTWUsDgWQXyoXDlpAySf8p+XdSyxK0MjraT1RZT+giv1fwfLxHaZpgoZU7dbSvwWXH11UTjrH1tgNmp6zE88rHtxSSDdb7BWRCtFVhGJOjK6XF9MYKveOr4qJ5PjCbjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A+r1MyX3; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9061C2BD10;
	Fri,  7 Jun 2024 00:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717720074;
	bh=FQTqwYknv8JIZqJzJar6YMQ0/CLZjse4O5WXBBaPRL0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=A+r1MyX3DI9NOoncuFmLLFlvelMwJ4dRnFUGBcft7113VpTMnbRXrbRugLD+xjLoQ
	 hVlly304fyXaMWlsk+r4AuIvuwNpnGDuB2cWQSLiQL1MvivwUEBKxN9lylgEB8j/U4
	 PQOSnpZN+7+p/EB+SCem3gdr74mPo3NWVYi4/Jj9ooLP7jxdQ8K5sHPfULU41fG3cQ
	 1u5yKMADsLAsBvb/oUdYBWAvsnolCGhhFqenE8o5ewWeTOv9QdbjoLtPv1V5K1jRUS
	 s72yzQemjiN9VlcyrQgWsXRAhEdo8M+G1aHVz+LI1O/Q1l9S8P2KiAuyelH2UMnaTZ
	 yzUr6Z3I7giKg==
Date: Thu, 6 Jun 2024 17:27:52 -0700
From: Namhyung Kim <namhyung@kernel.org>
To: Shenlin Liang <liangshenlin@eswincomputing.com>
Cc: anup@brainfault.org, atishp@atishpatra.org, paul.walmsley@sifive.com,
	palmer@dabbelt.com, aou@eecs.berkeley.edu, kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org, peterz@infradead.org,
	mingo@redhat.com, acme@kernel.org, mark.rutland@arm.com,
	alexander.shishkin@linux.intel.com, jolsa@kernel.org,
	irogers@google.com, adrian.hunter@intel.com,
	linux-perf-users@vger.kernel.org
Subject: Re: [PATCH v3 2/2] perf kvm/riscv: Port perf kvm stat to RISC-V
Message-ID: <ZmJUCJwavWXsesKn@google.com>
References: <20240422080833.8745-1-liangshenlin@eswincomputing.com>
 <20240422080833.8745-3-liangshenlin@eswincomputing.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240422080833.8745-3-liangshenlin@eswincomputing.com>

Hello,

On Mon, Apr 22, 2024 at 08:08:33AM +0000, Shenlin Liang wrote:
> 'perf kvm stat report/record' generates a statistical analysis of KVM
> events and can be used to analyze guest exit reasons.
> 
> "report" reports statistical analysis of guest exit events.
> 
> To record kvm events on the host:
>  # perf kvm stat record -a
> 
> To report kvm VM EXIT events:
>  # perf kvm stat report --event=vmexit
> 
> Signed-off-by: Shenlin Liang <liangshenlin@eswincomputing.com>
> ---
>  tools/perf/arch/riscv/Makefile                |  1 +
>  tools/perf/arch/riscv/util/Build              |  1 +
>  tools/perf/arch/riscv/util/kvm-stat.c         | 79 +++++++++++++++++++
>  .../arch/riscv/util/riscv_exception_types.h   | 35 ++++++++
>  4 files changed, 116 insertions(+)
>  create mode 100644 tools/perf/arch/riscv/util/kvm-stat.c
>  create mode 100644 tools/perf/arch/riscv/util/riscv_exception_types.h
> 
> diff --git a/tools/perf/arch/riscv/Makefile b/tools/perf/arch/riscv/Makefile
> index a8d25d005207..e1e445615536 100644
> --- a/tools/perf/arch/riscv/Makefile
> +++ b/tools/perf/arch/riscv/Makefile
> @@ -3,3 +3,4 @@ PERF_HAVE_DWARF_REGS := 1
>  endif
>  PERF_HAVE_ARCH_REGS_QUERY_REGISTER_OFFSET := 1
>  PERF_HAVE_JITDUMP := 1
> +HAVE_KVM_STAT_SUPPORT := 1
> \ No newline at end of file
> diff --git a/tools/perf/arch/riscv/util/Build b/tools/perf/arch/riscv/util/Build
> index 603dbb5ae4dc..d72b04f8d32b 100644
> --- a/tools/perf/arch/riscv/util/Build
> +++ b/tools/perf/arch/riscv/util/Build
> @@ -1,5 +1,6 @@
>  perf-y += perf_regs.o
>  perf-y += header.o
>  
> +perf-$(CONFIG_LIBTRACEEVENT) += kvm-stat.o
>  perf-$(CONFIG_DWARF) += dwarf-regs.o
>  perf-$(CONFIG_LIBDW_DWARF_UNWIND) += unwind-libdw.o
> diff --git a/tools/perf/arch/riscv/util/kvm-stat.c b/tools/perf/arch/riscv/util/kvm-stat.c
> new file mode 100644
> index 000000000000..58813049fc45
> --- /dev/null
> +++ b/tools/perf/arch/riscv/util/kvm-stat.c
> @@ -0,0 +1,79 @@
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
> +define_exit_reasons_table(riscv_exit_reasons, kvm_riscv_exception_class);
> +
> +const char *vcpu_id_str = "id";
> +const char *kvm_exit_reason = "scause";
> +const char *kvm_entry_trace = "kvm:kvm_entry";
> +const char *kvm_exit_trace = "kvm:kvm_exit";
> +
> +const char *kvm_events_tp[] = {
> +	"kvm:kvm_entry",
> +	"kvm:kvm_exit",
> +	NULL,
> +};
> +
> +static void event_get_key(struct evsel *evsel,
> +			  struct perf_sample *sample,
> +			  struct event_key *key)
> +{
> +	key->info = 0;
> +	key->key = evsel__intval(evsel, sample, kvm_exit_reason);
> +	key->key = (int)key->key;

Looks unnecessary..

Thanks,
Namhyung


> +	key->exit_reasons = riscv_exit_reasons;
> +}
> +
> +static bool event_begin(struct evsel *evsel,
> +			struct perf_sample *sample __maybe_unused,
> +			struct event_key *key __maybe_unused)
> +{
> +	return evsel__name_is(evsel, kvm_entry_trace);
> +}
> +
> +static bool event_end(struct evsel *evsel,
> +		      struct perf_sample *sample,
> +		      struct event_key *key)
> +{
> +	if (evsel__name_is(evsel, kvm_exit_trace)) {
> +		event_get_key(evsel, sample, key);
> +		return true;
> +	}
> +	return false;
> +}
> +
> +static struct kvm_events_ops exit_events = {
> +	.is_begin_event = event_begin,
> +	.is_end_event	= event_end,
> +	.decode_key	= exit_event_decode_key,
> +	.name		= "VM-EXIT"
> +};
> +
> +struct kvm_reg_events_ops kvm_reg_events_ops[] = {
> +	{
> +		.name	= "vmexit",
> +		.ops	= &exit_events,
> +	},
> +	{ NULL, NULL },
> +};
> +
> +const char * const kvm_skip_events[] = {
> +	NULL,
> +};
> +
> +int cpu_isa_init(struct perf_kvm_stat *kvm, const char *cpuid __maybe_unused)
> +{
> +	kvm->exit_reasons_isa = "riscv64";
> +	return 0;
> +}
> diff --git a/tools/perf/arch/riscv/util/riscv_exception_types.h b/tools/perf/arch/riscv/util/riscv_exception_types.h
> new file mode 100644
> index 000000000000..c49b8fa5e847
> --- /dev/null
> +++ b/tools/perf/arch/riscv/util/riscv_exception_types.h
> @@ -0,0 +1,35 @@
> +// SPDX-License-Identifier: GPL-2.0
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
> +#define kvm_riscv_exception_class                                         \
> +	EXC(INST_MISALIGNED), EXC(INST_ACCESS), EXC(INST_ILLEGAL),         \
> +	EXC(BREAKPOINT), EXC(LOAD_MISALIGNED), EXC(LOAD_ACCESS),           \
> +	EXC(STORE_MISALIGNED), EXC(STORE_ACCESS), EXC(SYSCALL),            \
> +	EXC(HYPERVISOR_SYSCALL), EXC(SUPERVISOR_SYSCALL),                  \
> +	EXC(INST_PAGE_FAULT), EXC(LOAD_PAGE_FAULT), EXC(STORE_PAGE_FAULT), \
> +	EXC(INST_GUEST_PAGE_FAULT), EXC(LOAD_GUEST_PAGE_FAULT),            \
> +	EXC(VIRTUAL_INST_FAULT), EXC(STORE_GUEST_PAGE_FAULT)
> +
> +#endif /* ARCH_PERF_RISCV_EXCEPTION_TYPES_H */
> -- 
> 2.37.2
> 

