Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A18BE68BBEE
	for <lists+kvm@lfdr.de>; Mon,  6 Feb 2023 12:45:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229776AbjBFLpl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Feb 2023 06:45:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbjBFLpj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Feb 2023 06:45:39 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B29CE30E9
        for <kvm@vger.kernel.org>; Mon,  6 Feb 2023 03:45:38 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id q8so8446426wmo.5
        for <kvm@vger.kernel.org>; Mon, 06 Feb 2023 03:45:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=io5TxYTm89uOwis4jMUJKqqOWIjw0glfkZGNfVGgNSU=;
        b=FC/5NK6QDrqhjg2/7Lbh1v+jYhc9NoQTA2S3rwBO63DuoHzCrgRZPagVpiwP13HI8I
         /13pK6x9yQZKlJgkbmqGK2LH386NzvRHkSit7V1Gt8mNpNv1fTRU4XQdTfbQSAvIT4ns
         CIMiDpUPoyN+bsc6XcuwER/UT+0DbNtIufyt0ZcBL81XwxAWfF+kF0Yxa0eOZKmKT0RX
         uA2J1hiW6bGCas01BvPdb66EpPgBKpjYc4sfrKW6Dj3eMOgMCRkraOA/gBvHd+xSpegh
         66iZK8XO4d20O2wQ07fZa3lySHEo5xkUBlwW3+v1JeVWdK9HidWic/aQTVphdYWpstL8
         jHdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=io5TxYTm89uOwis4jMUJKqqOWIjw0glfkZGNfVGgNSU=;
        b=BllT0WocAvnr5pRogsZprDNnB3hcMu2NmgBLbg1pbWt+SyQ/khvrZDeds9gePVy27a
         T9RsRui+VVbDePkpAia4pjJZ2lUZyHq+lc+eMq0SLl9odLa02vQAkD9kYmTDnvL1iaf8
         mmFTYRfjKf1gNPFAlHrSZ11WJd/LndFTmmNfWjPLHSY+seKAkcy6rDbwPVgIrxXlSrLD
         Cz9wHH6guvwYJXivmtpdDT8Cc71HNGPWovUN5wFhFr9k86wniRq18aN+lJmaI5STPvpq
         qdPyBahy5wxOF2OXrEgV4NvVly+7JbHvqAJXxHpXudkc4Olbhchz3zZ2I2bMhbQN/eO5
         oS5A==
X-Gm-Message-State: AO0yUKXNLYr3cesm3v2q7IdUATZofP1mRqzYauAM2VVegjW/D7ISCpCw
        dACf4FZoT7XvGFyV30OZd/3oAw==
X-Google-Smtp-Source: AK7set+woglDIefyaTuMiIQ1NVBVkbBZ/GTk5hK+CMxKO2V7IQS7B/4hgjgn1NR9cp4Bk4s/bz/mTg==
X-Received: by 2002:a05:600c:538b:b0:3df:a04a:1a7 with SMTP id hg11-20020a05600c538b00b003dfa04a01a7mr15145742wmb.22.1675683937343;
        Mon, 06 Feb 2023 03:45:37 -0800 (PST)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id c13-20020a056000104d00b002bfebe2d67esm8816271wrx.9.2023.02.06.03.45.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Feb 2023 03:45:37 -0800 (PST)
Date:   Mon, 6 Feb 2023 12:45:36 +0100
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Atish Patra <atishp@rivosinc.com>
Cc:     linux-kernel@vger.kernel.org, Anup Patel <anup@brainfault.org>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Atish Patra <atishp@atishpatra.org>,
        Guo Ren <guoren@kernel.org>, Heiko Stuebner <heiko@sntech.de>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-riscv@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Will Deacon <will@kernel.org>
Subject: Re: [PATCH v5 07/14] RISC-V: KVM: Add skeleton support for perf
Message-ID: <20230206114536.oif5huw4jqhsdtic@orel>
References: <20230205011515.1284674-1-atishp@rivosinc.com>
 <20230205011515.1284674-8-atishp@rivosinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230205011515.1284674-8-atishp@rivosinc.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Feb 04, 2023 at 05:15:08PM -0800, Atish Patra wrote:
> This patch only adds barebone structure of perf implementation. Most of
> the function returns zero at this point and will be implemented
> fully in the future.
> 
> Reviewed-by: Anup Patel <anup@brainfault.org>
> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> ---
>  arch/riscv/include/asm/kvm_host.h     |   4 +
>  arch/riscv/include/asm/kvm_vcpu_pmu.h |  78 +++++++++++++++
>  arch/riscv/kvm/Makefile               |   1 +
>  arch/riscv/kvm/vcpu.c                 |   7 ++
>  arch/riscv/kvm/vcpu_pmu.c             | 135 ++++++++++++++++++++++++++
>  5 files changed, 225 insertions(+)
>  create mode 100644 arch/riscv/include/asm/kvm_vcpu_pmu.h
>  create mode 100644 arch/riscv/kvm/vcpu_pmu.c
> 
> diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
> index 93f43a3..b90be9a 100644
> --- a/arch/riscv/include/asm/kvm_host.h
> +++ b/arch/riscv/include/asm/kvm_host.h
> @@ -18,6 +18,7 @@
>  #include <asm/kvm_vcpu_insn.h>
>  #include <asm/kvm_vcpu_sbi.h>
>  #include <asm/kvm_vcpu_timer.h>
> +#include <asm/kvm_vcpu_pmu.h>
>  
>  #define KVM_MAX_VCPUS			1024
>  
> @@ -228,6 +229,9 @@ struct kvm_vcpu_arch {
>  
>  	/* Don't run the VCPU (blocked) */
>  	bool pause;
> +
> +	/* Performance monitoring context */
> +	struct kvm_pmu pmu_context;
>  };
>  
>  static inline void kvm_arch_hardware_unsetup(void) {}
> diff --git a/arch/riscv/include/asm/kvm_vcpu_pmu.h b/arch/riscv/include/asm/kvm_vcpu_pmu.h
> new file mode 100644
> index 0000000..40905db
> --- /dev/null
> +++ b/arch/riscv/include/asm/kvm_vcpu_pmu.h
> @@ -0,0 +1,78 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Copyright (c) 2023 Rivos Inc
> + *
> + * Authors:
> + *     Atish Patra <atishp@rivosinc.com>
> + */
> +
> +#ifndef __KVM_VCPU_RISCV_PMU_H
> +#define __KVM_VCPU_RISCV_PMU_H
> +
> +#include <linux/perf/riscv_pmu.h>
> +#include <asm/kvm_vcpu_sbi.h>
> +#include <asm/sbi.h>
> +
> +#ifdef CONFIG_RISCV_PMU_SBI
> +#define RISCV_KVM_MAX_FW_CTRS	32
> +
> +#if RISCV_KVM_MAX_FW_CTRS > 32
> +#error "Maximum firmware counter can not exceed 32 without increasing the RISCV_MAX_COUNTERS"
                                    ^cannot                              ^ no the

> +#endif
> +
> +#define RISCV_MAX_COUNTERS 64

I'm still not sure about the above. I wrote more in the v4 thread
about it.

Otherwise,

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

Thanks,
drew
