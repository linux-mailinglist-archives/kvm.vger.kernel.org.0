Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CF726FFCE3
	for <lists+kvm@lfdr.de>; Fri, 12 May 2023 00:56:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232437AbjEKW4y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 May 2023 18:56:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239585AbjEKW4t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 May 2023 18:56:49 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC4897698
        for <kvm@vger.kernel.org>; Thu, 11 May 2023 15:56:43 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id 98e67ed59e1d1-24df161f84bso6474836a91.3
        for <kvm@vger.kernel.org>; Thu, 11 May 2023 15:56:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20221208.gappssmtp.com; s=20221208; t=1683845803; x=1686437803;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ohtAJQb6F6cDbIKk8yio8KQrKCUz3Fn39/AMo90V9pM=;
        b=cJ/DbkFWlbEVmDWOjgOvl3TCwwi3YZ7PgmSnrC1UuGtgWKvmAdDDkfi9ssSv2ynlIe
         uHbfQ6vBZ3nkwdX/euHoHXAvKE2vdH8X2Axd+FXrRfhfzYJ1yZCOaAFz5iajRgsFkEVc
         C7J+sw227uYFYcPGPRwU1B1SYXZGot7yH6DdeT7zeZOsFBeQG6KIk2Q/QbGJcfu/65mT
         Q656quNdxa0RA7jQAUxN4jd5uF7/UrNCVVJisoE5UjnP8xT2E57FLGtVxsd1BzFBxfLk
         pDjLHmLLrnquAiZlFYf/QNy0PwM7OnnK95BcZggmVGTJ/KzCrgma6YIEWz9uFQi8vU7m
         2e5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683845803; x=1686437803;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ohtAJQb6F6cDbIKk8yio8KQrKCUz3Fn39/AMo90V9pM=;
        b=SWnDQRqlqhYyi735bdpZgskkAA6+1AceOzUnfXaIfK5qXmE8kBP4TaDUelN81WN5mU
         PjlSi8uwYm0jUjNOS/+Lq6lSLtKlxjK1zUTw2kBJEAxFdP83qBLWTXcaqKvwVFcAtBoh
         vdBTT3bsx3HnAXOu9/aAVS08AKqI4jSNfqa8wRW3iqA3VU3luhTDGbAL+LidBkjEtZ/g
         UbNAdng8H7JQ0iWxAiPazJ4JdtaLpLgDhZjY6cRom0Lk4Vjj7HF2TvGcayC2LS4TGOhT
         J7gMvjU0iNxRvb/AV4Ziq7thsH0PV8YiKUsAhU60L7gHo853d2IScVwYd6k9zA9vhhHc
         T8tg==
X-Gm-Message-State: AC+VfDzslyQ6UbEy5OGPIbY8hKOTYE0qmWspyHPNtZnrJZKbUwKLqJ9w
        UTzp4TgJPMztmhk1Dh/OIkLrhQ==
X-Google-Smtp-Source: ACHHUZ7xlHHqpCZeSbzwJTpV9k1BII5bHnSWaVot6pExw6yywMVKikbhS3QjgV0hjoRV+prNz90bBA==
X-Received: by 2002:a17:90a:9d87:b0:24d:f77c:71e7 with SMTP id k7-20020a17090a9d8700b0024df77c71e7mr22260401pjp.41.1683845803004;
        Thu, 11 May 2023 15:56:43 -0700 (PDT)
Received: from localhost ([50.221.140.188])
        by smtp.gmail.com with ESMTPSA id fs9-20020a17090af28900b002470f179b92sm15748748pjb.43.2023.05.11.15.56.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 May 2023 15:56:42 -0700 (PDT)
Date:   Thu, 11 May 2023 15:56:42 -0700 (PDT)
X-Google-Original-Date: Thu, 11 May 2023 15:53:24 PDT (-0700)
Subject:     Re: [PATCH -next v19 08/24] riscv: Introduce riscv_v_vsize to record size of Vector context
In-Reply-To: <20230509103033.11285-9-andy.chiu@sifive.com>
CC:     linux-riscv@lists.infradead.org, anup@brainfault.org,
        atishp@atishpatra.org, kvm-riscv@lists.infradead.org,
        kvm@vger.kernel.org, Vineet Gupta <vineetg@rivosinc.com>,
        greentime.hu@sifive.com, guoren@linux.alibaba.com,
        vincent.chen@sifive.com, andy.chiu@sifive.com,
        Paul Walmsley <paul.walmsley@sifive.com>,
        aou@eecs.berkeley.edu, heiko.stuebner@vrull.eu, guoren@kernel.org,
        Conor Dooley <conor.dooley@microchip.com>,
        Bjorn Topel <bjorn@rivosinc.com>, jszhang@kernel.org,
        alexghiti@rivosinc.com, lizhengyu3@huawei.com,
        masahiroy@kernel.org, ajones@ventanamicro.com,
        Atish Patra <atishp@rivosinc.com>, apatel@ventanamicro.com,
        leyfoon.tan@starfivetech.com, sunilvl@ventanamicro.com
From:   Palmer Dabbelt <palmer@dabbelt.com>
To:     andy.chiu@sifive.com
Message-ID: <mhng-c386f0f5-8b4b-4a2c-b67e-a1803c2d177c@palmer-ri-x1c9a>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 09 May 2023 03:30:17 PDT (-0700), andy.chiu@sifive.com wrote:
> From: Greentime Hu <greentime.hu@sifive.com>
>
> This patch is used to detect the size of CPU vector registers and use
> riscv_v_vsize to save the size of all the vector registers. It assumes all
> harts has the same capabilities in a SMP system. If a core detects VLENB
> that is different from the boot core, then it warns and turns off V
> support for user space.
>
> Co-developed-by: Guo Ren <guoren@linux.alibaba.com>
> Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
> Co-developed-by: Vincent Chen <vincent.chen@sifive.com>
> Signed-off-by: Vincent Chen <vincent.chen@sifive.com>
> Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
> Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
> Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
> Reviewed-by: Heiko Stuebner <heiko.stuebner@vrull.eu>
> Tested-by: Heiko Stuebner <heiko.stuebner@vrull.eu>
> ---
> Changelog V19:
>  - Fix grammar in WARN() (Conor)
> Changelog V18:
>  - Detect inconsistent VLEN setup on an SMP system (Heiko).
>
>  arch/riscv/include/asm/vector.h |  8 ++++++++
>  arch/riscv/kernel/Makefile      |  1 +
>  arch/riscv/kernel/cpufeature.c  |  2 ++
>  arch/riscv/kernel/smpboot.c     |  7 +++++++
>  arch/riscv/kernel/vector.c      | 36 +++++++++++++++++++++++++++++++++
>  5 files changed, 54 insertions(+)
>  create mode 100644 arch/riscv/kernel/vector.c
>
> diff --git a/arch/riscv/include/asm/vector.h b/arch/riscv/include/asm/vector.h
> index dfe5a321b2b4..68c9fe831a41 100644
> --- a/arch/riscv/include/asm/vector.h
> +++ b/arch/riscv/include/asm/vector.h
> @@ -7,12 +7,16 @@
>  #define __ASM_RISCV_VECTOR_H
>
>  #include <linux/types.h>
> +#include <uapi/asm-generic/errno.h>
>
>  #ifdef CONFIG_RISCV_ISA_V
>
>  #include <asm/hwcap.h>
>  #include <asm/csr.h>
>
> +extern unsigned long riscv_v_vsize;
> +int riscv_v_setup_vsize(void);
> +
>  static __always_inline bool has_vector(void)
>  {
>  	return riscv_has_extension_likely(RISCV_ISA_EXT_v);
> @@ -30,7 +34,11 @@ static __always_inline void riscv_v_disable(void)
>
>  #else /* ! CONFIG_RISCV_ISA_V  */
>
> +struct pt_regs;
> +
> +static inline int riscv_v_setup_vsize(void) { return -EOPNOTSUPP; }
>  static __always_inline bool has_vector(void) { return false; }
> +#define riscv_v_vsize (0)
>
>  #endif /* CONFIG_RISCV_ISA_V */
>
> diff --git a/arch/riscv/kernel/Makefile b/arch/riscv/kernel/Makefile
> index fbdccc21418a..c51f34c2756a 100644
> --- a/arch/riscv/kernel/Makefile
> +++ b/arch/riscv/kernel/Makefile
> @@ -56,6 +56,7 @@ obj-$(CONFIG_MMU) += vdso.o vdso/
>
>  obj-$(CONFIG_RISCV_M_MODE)	+= traps_misaligned.o
>  obj-$(CONFIG_FPU)		+= fpu.o
> +obj-$(CONFIG_RISCV_ISA_V)	+= vector.o
>  obj-$(CONFIG_SMP)		+= smpboot.o
>  obj-$(CONFIG_SMP)		+= smp.o
>  obj-$(CONFIG_SMP)		+= cpu_ops.o
> diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeature.c
> index 7aaf92fff64e..28032b083463 100644
> --- a/arch/riscv/kernel/cpufeature.c
> +++ b/arch/riscv/kernel/cpufeature.c
> @@ -18,6 +18,7 @@
>  #include <asm/hwcap.h>
>  #include <asm/patch.h>
>  #include <asm/processor.h>
> +#include <asm/vector.h>
>
>  #define NUM_ALPHA_EXTS ('z' - 'a' + 1)
>
> @@ -269,6 +270,7 @@ void __init riscv_fill_hwcap(void)
>  	}
>
>  	if (elf_hwcap & COMPAT_HWCAP_ISA_V) {
> +		riscv_v_setup_vsize();
>  		/*
>  		 * ISA string in device tree might have 'v' flag, but
>  		 * CONFIG_RISCV_ISA_V is disabled in kernel.
> diff --git a/arch/riscv/kernel/smpboot.c b/arch/riscv/kernel/smpboot.c
> index 445a4efee267..66011bf2b36e 100644
> --- a/arch/riscv/kernel/smpboot.c
> +++ b/arch/riscv/kernel/smpboot.c
> @@ -31,6 +31,8 @@
>  #include <asm/tlbflush.h>
>  #include <asm/sections.h>
>  #include <asm/smp.h>
> +#include <uapi/asm/hwcap.h>
> +#include <asm/vector.h>
>
>  #include "head.h"
>
> @@ -169,6 +171,11 @@ asmlinkage __visible void smp_callin(void)
>  	set_cpu_online(curr_cpuid, 1);
>  	probe_vendor_features(curr_cpuid);
>
> +	if (has_vector()) {
> +		if (riscv_v_setup_vsize())
> +			elf_hwcap &= ~COMPAT_HWCAP_ISA_V;
> +	}
> +
>  	/*
>  	 * Remote TLB flushes are ignored while the CPU is offline, so emit
>  	 * a local TLB flush right now just in case.
> diff --git a/arch/riscv/kernel/vector.c b/arch/riscv/kernel/vector.c
> new file mode 100644
> index 000000000000..120f1ce9abf9
> --- /dev/null
> +++ b/arch/riscv/kernel/vector.c
> @@ -0,0 +1,36 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + * Copyright (C) 2023 SiFive
> + * Author: Andy Chiu <andy.chiu@sifive.com>
> + */
> +#include <linux/export.h>
> +
> +#include <asm/vector.h>
> +#include <asm/csr.h>
> +#include <asm/elf.h>
> +#include <asm/bug.h>
> +
> +unsigned long riscv_v_vsize __read_mostly;
> +EXPORT_SYMBOL_GPL(riscv_v_vsize);
> +
> +int riscv_v_setup_vsize(void)
> +{
> +	unsigned long this_vsize;
> +
> +	/* There are 32 vector registers with vlenb length. */
> +	riscv_v_enable();
> +	this_vsize = csr_read(CSR_VLENB) * 32;
> +	riscv_v_disable();
> +
> +	if (!riscv_v_vsize) {
> +		riscv_v_vsize = this_vsize;
> +		return 0;
> +	}
> +
> +	if (riscv_v_vsize != this_vsize) {
> +		WARN(1, "RISCV_ISA_V only supports one vlenb on SMP systems");
> +		return -EOPNOTSUPP;
> +	}
> +
> +	return 0;
> +}

Reviewed-by: Palmer Dabbelt <palmer@rivosinc.com>
