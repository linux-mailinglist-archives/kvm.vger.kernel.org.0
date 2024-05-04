Return-Path: <kvm+bounces-16557-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BB6838BB8B0
	for <lists+kvm@lfdr.de>; Sat,  4 May 2024 02:25:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 732992859E4
	for <lists+kvm@lfdr.de>; Sat,  4 May 2024 00:25:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B21D06AB9;
	Sat,  4 May 2024 00:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="MBAiGv1C"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 336B4816
	for <kvm@vger.kernel.org>; Sat,  4 May 2024 00:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714782324; cv=none; b=CQN2Yg2O+AmFEv1634BhFIAIWXa9Jv6OpFqChJzLGVpkNar6FHuoZxro29cCwDkBkJxc8IVbrZRuNQHQYC5i93uMMpmQFjOMRuThJVYnUrVDTtvn9GCoEQGIyi/gv4eJ0hXboWZDCp0r/iLiLTfE3njbqs+67wGOGVUsqc8I+jA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714782324; c=relaxed/simple;
	bh=ik9ixoec2pD/xrYpFHiGKUQlC8TluSlJgnXtkO2J3dU=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=RiSvwA/zCngzE6j6X/xsobPraHDIOp4hWMQD4kmp8pRpEL7GYzRixH0/LWD3YzOLPZaMl0UbJAM61XQKr6s4gtrl9BROc8DMk8B4hUfUb3NmhAvCS5ZdneAXl80PZ/EYUSgjmK8RrMC+Hu1JuGqMqqnE9P+rrupXxR37e6dVXTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=MBAiGv1C; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1ec4dc64c6cso1751625ad.0
        for <kvm@vger.kernel.org>; Fri, 03 May 2024 17:25:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1714782321; x=1715387121; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jNUgL2JIPtjHS0zU6FMK7+7DqPWIOUfewm5xxpb/qS8=;
        b=MBAiGv1CjzplPQiaLDgsltufVUKHeKb/earvf27FoEBJzVoLL2ngLWePP4MFCNs+1A
         hcJHl86XTFcUeU7yQ7xTOjpLGvAr9zdvWFHy+19/BZlZ6enFjhyJNNrsZ/QFkxJJ0RGK
         wyRlkyNM2SFbCpJF4fNFdx7Vmw7HfPB7bbsmNSUZEpYNqSJjHjHlzcHQlUuSx6OX/iZq
         265E7ngLqV3JH67Czynfzqy14CSijspqPGJxXo6gfMz8W6TkNa4o4556WZAUEAmAhDkp
         MqSJ25XEJ+UjynjEoS4JDU+a9US7q+Gmztwce8eQCF1U9zYx2NSZ6JwXAPQAWVNjSRvI
         b9JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714782321; x=1715387121;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jNUgL2JIPtjHS0zU6FMK7+7DqPWIOUfewm5xxpb/qS8=;
        b=kGEkVMq4y7SlvRNKcX3XFIbtW6nuVtOXJuaym9nNk0AkK5Dtu2/5PQhDwBgV1BGh5n
         2OxwCGGErxqpfo2Qn+eCrMhaVih12gBftunEtw+HB0Jauh6WpwViBW/UFIMZ1iiI376B
         Q4ViHg8t9i1+ViyW6cUFbLPyq+vdpl8FIRug2mekqi4O2riO7XT0KGKk3ZL6neqdcnTt
         UjpCtYVgFWUqJhT1uhjwM3Oj096KuSunzRDEN1PHkwYamPgREwnqAP+bz6bY/bOjSdr2
         59+rHFbfhoEsD8OjcgXBFDt2nR6VsQa9rnwgNpoMC3eoONNoDz9akplUQOzWHhmHoCVI
         RGMg==
X-Forwarded-Encrypted: i=1; AJvYcCV22sdeS5ZFN2Ivjt7F6II+Wx+Nu/9i5iRZDz+CovcVLkPJhomMR0iYh+9TihhtbbWk1HBENLZ2vagsWE9FnxDlnGsp
X-Gm-Message-State: AOJu0Yyd7b5fhBHkzcHmXn5KbwGgkdnJZlqtwTkL5vX+YT3XiiVhpf5H
	hilsKAaL19d314m0NLSKNfioZKlCpoV2usNDIGxYfQ+cuIZ7CBmWCYIR5qCO0Mw=
X-Google-Smtp-Source: AGHT+IGh4V5FPTFI69/PZua5IgLwb84yNbPsAUwBRhqzoGZaQ1fIxi3CqnFLXXpBX5NraTbXqAyf6Q==
X-Received: by 2002:a17:902:d353:b0:1eb:3d68:fc2d with SMTP id l19-20020a170902d35300b001eb3d68fc2dmr3537235plk.34.1714782321529;
        Fri, 03 May 2024 17:25:21 -0700 (PDT)
Received: from [172.16.0.22] (c-67-188-2-18.hsd1.ca.comcast.net. [67.188.2.18])
        by smtp.gmail.com with ESMTPSA id la8-20020a170902fa0800b001e421f98ebdsm3849598plb.280.2024.05.03.17.25.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 May 2024 17:25:21 -0700 (PDT)
Message-ID: <e4c61017-6667-4773-8f09-497002cbc6a9@rivosinc.com>
Date: Fri, 3 May 2024 17:25:18 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] perf kvm/riscv: Port perf kvm stat to RISC-V
Content-Language: en-US
To: Shenlin Liang <liangshenlin@eswincomputing.com>, anup@brainfault.org,
 atishp@atishpatra.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
 peterz@infradead.org, mingo@redhat.com, acme@kernel.org,
 namhyung@kernel.org, mark.rutland@arm.com,
 alexander.shishkin@linux.intel.com, jolsa@kernel.org, irogers@google.com,
 adrian.hunter@intel.com, linux-perf-users@vger.kernel.org
References: <20240422080833.8745-1-liangshenlin@eswincomputing.com>
 <20240422080833.8745-3-liangshenlin@eswincomputing.com>
From: Atish Patra <atishp@rivosinc.com>
In-Reply-To: <20240422080833.8745-3-liangshenlin@eswincomputing.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/22/24 01:08, Shenlin Liang wrote:
> 'perf kvm stat report/record' generates a statistical analysis of KVM
> events and can be used to analyze guest exit reasons.
> 
> "report" reports statistical analysis of guest exit events.
> 
> To record kvm events on the host:
>   # perf kvm stat record -a
> 
> To report kvm VM EXIT events:
>   # perf kvm stat report --event=vmexit
> 
> Signed-off-by: Shenlin Liang <liangshenlin@eswincomputing.com>
> ---
>   tools/perf/arch/riscv/Makefile                |  1 +
>   tools/perf/arch/riscv/util/Build              |  1 +
>   tools/perf/arch/riscv/util/kvm-stat.c         | 79 +++++++++++++++++++
>   .../arch/riscv/util/riscv_exception_types.h   | 35 ++++++++
>   4 files changed, 116 insertions(+)
>   create mode 100644 tools/perf/arch/riscv/util/kvm-stat.c
>   create mode 100644 tools/perf/arch/riscv/util/riscv_exception_types.h
> 
> diff --git a/tools/perf/arch/riscv/Makefile b/tools/perf/arch/riscv/Makefile
> index a8d25d005207..e1e445615536 100644
> --- a/tools/perf/arch/riscv/Makefile
> +++ b/tools/perf/arch/riscv/Makefile
> @@ -3,3 +3,4 @@ PERF_HAVE_DWARF_REGS := 1
>   endif
>   PERF_HAVE_ARCH_REGS_QUERY_REGISTER_OFFSET := 1
>   PERF_HAVE_JITDUMP := 1
> +HAVE_KVM_STAT_SUPPORT := 1
> \ No newline at end of file
> diff --git a/tools/perf/arch/riscv/util/Build b/tools/perf/arch/riscv/util/Build
> index 603dbb5ae4dc..d72b04f8d32b 100644
> --- a/tools/perf/arch/riscv/util/Build
> +++ b/tools/perf/arch/riscv/util/Build
> @@ -1,5 +1,6 @@
>   perf-y += perf_regs.o
>   perf-y += header.o
>   
> +perf-$(CONFIG_LIBTRACEEVENT) += kvm-stat.o
>   perf-$(CONFIG_DWARF) += dwarf-regs.o
>   perf-$(CONFIG_LIBDW_DWARF_UNWIND) += unwind-libdw.o
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

For some reason my previous RB email doesn't show up in lore. So here it 
goes agian. Sorry for the spam it gets delivered twice.

Reviewed-by: Atish Patra <atishp@rivosinc.com>



