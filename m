Return-Path: <kvm+bounces-49401-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F4A4AD85E6
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 10:46:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 191E53AA1D5
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 08:45:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 713F927280F;
	Fri, 13 Jun 2025 08:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="n7aV4uGV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E16325228E
	for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 08:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749804365; cv=none; b=NYGMjhDfpTulOcppmq3gCHUa8gqDsGatCXipLXu13cec/acfxDNJAUcNlBvi9au+SjmMvhKQhx3nxrWC+euFMqBmhviowx4YUVwQotcui0e0waCVDeOQIAaULQvOTTAgaiFauz3A5PmN7K0MDHC+4VZ5GpdnL3MuRHZOJZwi7JQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749804365; c=relaxed/simple;
	bh=J5oWPXtOJiFBs9dv4I5q0WBvTbd28RX42UsQhqgXnX0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qvCCIEKzKbvoDyLhAq6WKb2FCQjYB7pqWpeJvrOklXuxf3rVKQPPTWSLumz2TR86LM0RyEcRMlaz2hCkrlVg6ObdmX30//EegZQBop51QJy0tSWJVIyvR+EscoKAmca0kfQcTSU1XBuZO3gCD4nr/RWu00IVLgj0ieiYhhleCzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=n7aV4uGV; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-3a4fb9c2436so1133592f8f.1
        for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 01:46:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1749804360; x=1750409160; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pPysXILCfU+u1glPGM8ddsYMEL8PciSkqWZBDbfqi5Q=;
        b=n7aV4uGVkqLwcOk9882qM/HVjYVzL5odjgqlwrhDtBqK+7sUjj9rW9cIeqLAD4bT3w
         /yO8Isl3O4H3iGj+th9w4M30d3M9esoGSEeuHCpFPIcXZwm61RoT3ac1T7dcKQ4dVRwR
         zrxLGZWiEMWzh3Pdj5sA3KmPKibKxd6g6tuwcl8GafsTjfJfCUSXCgeq1Jm633qSwEl+
         JSIvgHwU/uFhGOhhoK5pULk0UDWP8Wu4rvciIsnwAy13MLW8AV61hJT7KwS8vEhtxkD6
         Gyr2bm45t8zP6kpDCGwEjuB3A8dxkh43PjB5jp9hdj+VBzdSOrZMRWR45fzp5peIHukG
         dMJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749804360; x=1750409160;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pPysXILCfU+u1glPGM8ddsYMEL8PciSkqWZBDbfqi5Q=;
        b=TysYtNIM8uxt5B/z9IyB/LFjEc0ZhWxpT21ZhzbvLoZOlWLU02lKYp5GHApbYBG1WZ
         oBKwTrYF1WBfVQ9l64FvUVESj/yBWdLZmrpUF5pzFVBTt1t1TQyxxOm+f8KCG04yNhr5
         kUbS1yelAYZcaNWy2ez/oY4QK2lC+pHeoZufZk59JBcjIpIAFhodc9rT3jQbSINtml8i
         +pLf1s26T9uElWcbzc9E5hZKwOTVithPGYq3ih+I2qlyVMK+sMhbP6L5sDXM10WOjlOu
         V5Q59mGw+sIc6XYr8DfR8GewA9TYw41HPmT/CuZUmJtdjrxcj9dd799u3a+WZkyz8w8F
         gfkw==
X-Forwarded-Encrypted: i=1; AJvYcCXXiYRwOA5TrnfIUtcYkk5+JqR+6UilDz/Y3qcBwY75g2n67MIZfEXIgeKo1yX931r84KE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzdvMvA9eC//ckrd002npltCQHVp0CTlXrKn4fIESNuTMZf8y6J
	qQdgrO5nQOF+OhP5YGwEHOwGxj143ThPWAjvnWJp60hsMsXP8flXVvDyxK4Fb1wQH1EuRFK6C+J
	nXjd+61s=
X-Gm-Gg: ASbGncvOJl1vensjhU9wKPXicdjnd2yUiG1ySLHlRwDmwv1ITOTOP3HmgWKf7Sf9N3v
	8mcQBVSm8+fvo2ssQjYr/82IaEnno7x094VnBCeEuEE/kC1whIvrTW7NSxlgySxeYhE2iSDcLRI
	wWEZQ0rWc73UKAXnmeXofFwfhwjRunhPl0tsghvu05PuqkBbQW4I7Aw5hWg1AA01D9PmWqTdlq6
	BsEpaiEfMN3JkCNiboZIt1Q5PudoyxUUqH1hp6H/HxV92HkJSK8VuoCtMYWHZcT5/Qe3aueuj5F
	/NqA/1hvnqxFSObjSKJOxLRTEs/90Rj9Zc6B5y90pwcnFqo+aA==
X-Google-Smtp-Source: AGHT+IEQkzpf/GCapCoD2b5zMQetkWxlSYPIz9FgJgDLq+nYarNZ+dQ9zrl0ZkcjsNfdKzttk0MElg==
X-Received: by 2002:a05:6000:1785:b0:3a4:f7e6:284b with SMTP id ffacd0b85a97d-3a5686e46e7mr2096211f8f.10.1749804359658;
        Fri, 13 Jun 2025 01:45:59 -0700 (PDT)
Received: from localhost ([2a02:8308:a00c:e200::5485])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4532e25e89fsm44115675e9.33.2025.06.13.01.45.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jun 2025 01:45:59 -0700 (PDT)
Date: Fri, 13 Jun 2025 10:45:58 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: zhouquan@iscas.ac.cn
Cc: anup@brainfault.org, atishp@atishpatra.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, linux-perf-users@vger.kernel.org
Subject: Re: [PATCH] RISC-V: perf/kvm: Add reporting of interrupt events
Message-ID: <20250613-10b9c7df0043617e466a7212@orel>
References: <9693132df4d0f857b8be3a75750c36b40213fcc0.1726211632.git.zhouquan@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9693132df4d0f857b8be3a75750c36b40213fcc0.1726211632.git.zhouquan@iscas.ac.cn>

On Fri, Jun 13, 2025 at 03:53:38PM +0800, zhouquan@iscas.ac.cn wrote:
> From: Quan Zhou <zhouquan@iscas.ac.cn>
> 
> For `perf kvm stat` on the RISC-V, in order to avoid the
> occurrence of `UNKNOWN` event names, interrupts should be
> reported in addition to exceptions.
> 
> testing without patch:
> ---
> Event name                    Samples  Sample%       Time(ns)
> ---------------------------  --------  --------  ------------
> STORE_GUEST_PAGE_FAULT   	  1496461   53.00%    889612544
> UNKNOWN                        887514   31.00%    272857968
> LOAD_GUEST_PAGE_FAULT          305164   10.00%    189186331
> VIRTUAL_INST_FAULT              70625    2.00%    134114260
> SUPERVISOR_SYSCALL              32014    1.00%     58577110
> INST_GUEST_PAGE_FAULT               1    0.00%         2545
> 
> testing with patch:
> ---
> Event name                    Samples  Sample%       Time(ns)
> ---------------------------  --------  --------  ------------
> IRQ_S_TIMER                   211271    58.00%  738298680600
> EXC_STORE_GUEST_PAGE_FAULT    111279    30.00%  130725914800
> EXC_LOAD_GUEST_PAGE_FAULT      22039     6.00%   25441480600
> EXC_VIRTUAL_INST_FAULT          8913     2.00%   21015381600
> IRQ_VS_EXT                      4748     1.00%   10155464300
> IRQ_S_EXT                       2802     0.00%   13288775800
> IRQ_S_SOFT                      1998     0.00%    4254129300
> 
> Signed-off-by: Quan Zhou <zhouquan@iscas.ac.cn>
> ---
>  tools/perf/arch/riscv/util/kvm-stat.c         |  6 +-
>  .../arch/riscv/util/riscv_exception_types.h   | 35 ------------
>  tools/perf/arch/riscv/util/riscv_trap_types.h | 57 +++++++++++++++++++
>  3 files changed, 60 insertions(+), 38 deletions(-)
>  delete mode 100644 tools/perf/arch/riscv/util/riscv_exception_types.h
>  create mode 100644 tools/perf/arch/riscv/util/riscv_trap_types.h
> 
> diff --git a/tools/perf/arch/riscv/util/kvm-stat.c b/tools/perf/arch/riscv/util/kvm-stat.c
> index 491aef449d1a..3ea7acb5e159 100644
> --- a/tools/perf/arch/riscv/util/kvm-stat.c
> +++ b/tools/perf/arch/riscv/util/kvm-stat.c
> @@ -9,10 +9,10 @@
>  #include <memory.h>
>  #include "../../../util/evsel.h"
>  #include "../../../util/kvm-stat.h"
> -#include "riscv_exception_types.h"
> +#include "riscv_trap_types.h"
>  #include "debug.h"
>  
> -define_exit_reasons_table(riscv_exit_reasons, kvm_riscv_exception_class);
> +define_exit_reasons_table(riscv_exit_reasons, kvm_riscv_trap_class);
>  
>  const char *vcpu_id_str = "id";
>  const char *kvm_exit_reason = "scause";
> @@ -30,7 +30,7 @@ static void event_get_key(struct evsel *evsel,
>  			  struct event_key *key)
>  {
>  	key->info = 0;
> -	key->key = evsel__intval(evsel, sample, kvm_exit_reason);
> +	key->key = evsel__intval(evsel, sample, kvm_exit_reason) & ~CAUSE_IRQ_FLAG;
>  	key->exit_reasons = riscv_exit_reasons;
>  }
>  
> diff --git a/tools/perf/arch/riscv/util/riscv_exception_types.h b/tools/perf/arch/riscv/util/riscv_exception_types.h
> deleted file mode 100644
> index c49b8fa5e847..000000000000
> --- a/tools/perf/arch/riscv/util/riscv_exception_types.h
> +++ /dev/null
> @@ -1,35 +0,0 @@
> -// SPDX-License-Identifier: GPL-2.0
> -#ifndef ARCH_PERF_RISCV_EXCEPTION_TYPES_H
> -#define ARCH_PERF_RISCV_EXCEPTION_TYPES_H
> -
> -#define EXC_INST_MISALIGNED 0
> -#define EXC_INST_ACCESS 1
> -#define EXC_INST_ILLEGAL 2
> -#define EXC_BREAKPOINT 3
> -#define EXC_LOAD_MISALIGNED 4
> -#define EXC_LOAD_ACCESS 5
> -#define EXC_STORE_MISALIGNED 6
> -#define EXC_STORE_ACCESS 7
> -#define EXC_SYSCALL 8
> -#define EXC_HYPERVISOR_SYSCALL 9
> -#define EXC_SUPERVISOR_SYSCALL 10
> -#define EXC_INST_PAGE_FAULT 12
> -#define EXC_LOAD_PAGE_FAULT 13
> -#define EXC_STORE_PAGE_FAULT 15
> -#define EXC_INST_GUEST_PAGE_FAULT 20
> -#define EXC_LOAD_GUEST_PAGE_FAULT 21
> -#define EXC_VIRTUAL_INST_FAULT 22
> -#define EXC_STORE_GUEST_PAGE_FAULT 23
> -
> -#define EXC(x) {EXC_##x, #x }
> -
> -#define kvm_riscv_exception_class                                         \
> -	EXC(INST_MISALIGNED), EXC(INST_ACCESS), EXC(INST_ILLEGAL),         \
> -	EXC(BREAKPOINT), EXC(LOAD_MISALIGNED), EXC(LOAD_ACCESS),           \
> -	EXC(STORE_MISALIGNED), EXC(STORE_ACCESS), EXC(SYSCALL),            \
> -	EXC(HYPERVISOR_SYSCALL), EXC(SUPERVISOR_SYSCALL),                  \
> -	EXC(INST_PAGE_FAULT), EXC(LOAD_PAGE_FAULT), EXC(STORE_PAGE_FAULT), \
> -	EXC(INST_GUEST_PAGE_FAULT), EXC(LOAD_GUEST_PAGE_FAULT),            \
> -	EXC(VIRTUAL_INST_FAULT), EXC(STORE_GUEST_PAGE_FAULT)
> -
> -#endif /* ARCH_PERF_RISCV_EXCEPTION_TYPES_H */
> diff --git a/tools/perf/arch/riscv/util/riscv_trap_types.h b/tools/perf/arch/riscv/util/riscv_trap_types.h
> new file mode 100644
> index 000000000000..854e9d95524d
> --- /dev/null
> +++ b/tools/perf/arch/riscv/util/riscv_trap_types.h
> @@ -0,0 +1,57 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#ifndef ARCH_PERF_RISCV_TRAP_TYPES_H
> +#define ARCH_PERF_RISCV_TRAP_TYPES_H
> +
> +/* Exception cause high bit - is an interrupt if set */
> +#define CAUSE_IRQ_FLAG		(_AC(1, UL) << (__riscv_xlen - 1))
> +
> +/* Interrupt causes (minus the high bit) */
> +#define IRQ_S_SOFT 1
> +#define IRQ_VS_SOFT 2
> +#define IRQ_M_SOFT 3
> +#define IRQ_S_TIMER 5
> +#define IRQ_VS_TIMER 6
> +#define IRQ_M_TIMER 7
> +#define IRQ_S_EXT 9
> +#define IRQ_VS_EXT 10
> +#define IRQ_M_EXT 11
> +#define IRQ_S_GEXT 12
> +#define IRQ_PMU_OVF 13
> +
> +/* Exception causes */
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
> +#define TRAP(x) { x, #x }
> +
> +#define kvm_riscv_trap_class \
> +	TRAP(IRQ_S_SOFT), TRAP(IRQ_VS_SOFT), TRAP(IRQ_M_SOFT), \
> +	TRAP(IRQ_S_TIMER), TRAP(IRQ_VS_TIMER), TRAP(IRQ_M_TIMER), \
> +	TRAP(IRQ_S_EXT), TRAP(IRQ_VS_EXT), TRAP(IRQ_M_EXT), \
> +	TRAP(IRQ_S_GEXT), TRAP(IRQ_PMU_OVF), \
> +	TRAP(EXC_INST_MISALIGNED), TRAP(EXC_INST_ACCESS), TRAP(EXC_INST_ILLEGAL), \
> +	TRAP(EXC_BREAKPOINT), TRAP(EXC_LOAD_MISALIGNED), TRAP(EXC_LOAD_ACCESS), \
> +	TRAP(EXC_STORE_MISALIGNED), TRAP(EXC_STORE_ACCESS), TRAP(EXC_SYSCALL), \
> +	TRAP(EXC_HYPERVISOR_SYSCALL), TRAP(EXC_SUPERVISOR_SYSCALL), \
> +	TRAP(EXC_INST_PAGE_FAULT), TRAP(EXC_LOAD_PAGE_FAULT), \
> +	TRAP(EXC_STORE_PAGE_FAULT), TRAP(EXC_INST_GUEST_PAGE_FAULT), \
> +	TRAP(EXC_LOAD_GUEST_PAGE_FAULT), TRAP(EXC_VIRTUAL_INST_FAULT), \
> +	TRAP(EXC_STORE_GUEST_PAGE_FAULT)
> +
> +#endif /* ARCH_PERF_RISCV_TRAP_TYPES_H */
> 
> base-commit: da3ea35007d0af457a0afc87e84fddaebc4e0b63
> -- 
> 2.34.1
>

LGTM

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

