Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A588472CAD
	for <lists+kvm@lfdr.de>; Mon, 13 Dec 2021 13:59:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236474AbhLMM7P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Dec 2021 07:59:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234631AbhLMM7P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Dec 2021 07:59:15 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BF03C061574;
        Mon, 13 Dec 2021 04:59:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E91BDCE0FF7;
        Mon, 13 Dec 2021 12:59:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BD64C34601;
        Mon, 13 Dec 2021 12:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639400351;
        bh=qJhlNMK+UWhRz8sIHd9S207y7AHw4ZcsrcX5mlUBMLA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qP0UhRn3T8klszkTd3zr5EgUei4SajRGBoBjGn536TIsb4qsBbNLWJWEEgj5g01tO
         ONnA+QbgrJFuRKkCmZqgsW9Qq71n4YY5JZ/Wi3nxOOLrAO5ud1Xah7fsF4Nx5bgGsH
         4tDFQVfdvVRrtmPKefEDrsnoqXd+LUpZCVnnzMImWeZMDEefSfpvrew7maBdq2b1d3
         RKZVMUVTXz+3M+IS7SNXvZ68sw2dyofHD6KouG0Q4WsMtuB+XywqEh5uSYwjIKpvC3
         Br8x9DDJoGODAe/r7/IhBIDJAoHdehvgIWIgbw7dxGrZ2RVLYv3ySYaqXxChyJj2TQ
         38Nvy6L7H1vBg==
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1mwkv7-00Bnbl-4B; Mon, 13 Dec 2021 12:59:09 +0000
MIME-Version: 1.0
Date:   Mon, 13 Dec 2021 12:59:09 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Atish Patra <atishp@atishpatra.org>
Cc:     linux-kernel@vger.kernel.org, Atish Patra <atishp@rivosinc.com>,
        Alexandre Ghiti <alex@ghiti.fr>,
        Anup Patel <anup.patel@wdc.com>,
        Greentime Hu <greentime.hu@sifive.com>,
        Guo Ren <guoren@linux.alibaba.com>,
        Heinrich Schuchardt <xypron.glpk@gmx.de>,
        Ingo Molnar <mingo@kernel.org>,
        Jisheng Zhang <jszhang@kernel.org>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-riscv@lists.infradead.org,
        Nanyong Sun <sunnanyong@huawei.com>,
        Nick Kossifidis <mick@ics.forth.gr>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Pekka Enberg <penberg@kernel.org>,
        Vincent Chen <vincent.chen@sifive.com>,
        Vitaly Wool <vitaly.wool@konsulko.com>
Subject: Re: [RFC 3/6] RISC-V: Use __cpu_up_stack/task_pointer only for
 spinwait method
In-Reply-To: <20211204002038.113653-4-atishp@atishpatra.org>
References: <20211204002038.113653-1-atishp@atishpatra.org>
 <20211204002038.113653-4-atishp@atishpatra.org>
User-Agent: Roundcube Webmail/1.4.12
Message-ID: <48012a35c4f66340547ff50525792a29@kernel.org>
X-Sender: maz@kernel.org
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: atishp@atishpatra.org, linux-kernel@vger.kernel.org, atishp@rivosinc.com, alex@ghiti.fr, anup.patel@wdc.com, greentime.hu@sifive.com, guoren@linux.alibaba.com, xypron.glpk@gmx.de, mingo@kernel.org, jszhang@kernel.org, kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, linux-riscv@lists.infradead.org, sunnanyong@huawei.com, mick@ics.forth.gr, palmer@dabbelt.com, paul.walmsley@sifive.com, penberg@kernel.org, vincent.chen@sifive.com, vitaly.wool@konsulko.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021-12-04 00:20, Atish Patra wrote:
> From: Atish Patra <atishp@rivosinc.com>
> 
> The __cpu_up_stack/task_pointer array is only used for spinwait method
> now. The per cpu array based lookup is also fragile for platforms with
> discontiguous/sparse hartids. The spinwait method is only used for
> M-mode Linux or older firmwares without SBI HSM extension. For general
> Linux systems, ordered booting method is preferred anyways to support
> cpu hotplug and kexec.
> 
> Make sure that __cpu_up_stack/task_pointer is only used for spinwait
> method. Take this opportunity to rename it to
> __cpu_spinwait_stack/task_pointer to emphasize the purpose as well.
> 
> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> ---
>  arch/riscv/include/asm/cpu_ops.h     |  2 --
>  arch/riscv/kernel/cpu_ops.c          | 16 ----------------
>  arch/riscv/kernel/cpu_ops_spinwait.c | 27 ++++++++++++++++++++++++++-
>  arch/riscv/kernel/head.S             |  4 ++--
>  arch/riscv/kernel/head.h             |  4 ++--
>  5 files changed, 30 insertions(+), 23 deletions(-)
> 
> diff --git a/arch/riscv/include/asm/cpu_ops.h 
> b/arch/riscv/include/asm/cpu_ops.h
> index a8ec3c5c1bd2..134590f1b843 100644
> --- a/arch/riscv/include/asm/cpu_ops.h
> +++ b/arch/riscv/include/asm/cpu_ops.h
> @@ -40,7 +40,5 @@ struct cpu_operations {
> 
>  extern const struct cpu_operations *cpu_ops[NR_CPUS];
>  void __init cpu_set_ops(int cpu);
> -void cpu_update_secondary_bootdata(unsigned int cpuid,
> -				   struct task_struct *tidle);
> 
>  #endif /* ifndef __ASM_CPU_OPS_H */
> diff --git a/arch/riscv/kernel/cpu_ops.c b/arch/riscv/kernel/cpu_ops.c
> index 3f5a38b03044..c1e30f403c3b 100644
> --- a/arch/riscv/kernel/cpu_ops.c
> +++ b/arch/riscv/kernel/cpu_ops.c
> @@ -8,31 +8,15 @@
>  #include <linux/of.h>
>  #include <linux/string.h>
>  #include <linux/sched.h>
> -#include <linux/sched/task_stack.h>
>  #include <asm/cpu_ops.h>
>  #include <asm/sbi.h>
>  #include <asm/smp.h>
> 
>  const struct cpu_operations *cpu_ops[NR_CPUS] __ro_after_init;
> 
> -void *__cpu_up_stack_pointer[NR_CPUS] __section(".data");
> -void *__cpu_up_task_pointer[NR_CPUS] __section(".data");
> -
>  extern const struct cpu_operations cpu_ops_sbi;
>  extern const struct cpu_operations cpu_ops_spinwait;
> 
> -void cpu_update_secondary_bootdata(unsigned int cpuid,
> -				   struct task_struct *tidle)
> -{
> -	int hartid = cpuid_to_hartid_map(cpuid);
> -
> -	/* Make sure tidle is updated */
> -	smp_mb();
> -	WRITE_ONCE(__cpu_up_stack_pointer[hartid],
> -		   task_stack_page(tidle) + THREAD_SIZE);
> -	WRITE_ONCE(__cpu_up_task_pointer[hartid], tidle);
> -}
> -
>  void __init cpu_set_ops(int cpuid)
>  {
>  #if IS_ENABLED(CONFIG_RISCV_SBI)
> diff --git a/arch/riscv/kernel/cpu_ops_spinwait.c
> b/arch/riscv/kernel/cpu_ops_spinwait.c
> index b2c957bb68c1..9f398eb94f7a 100644
> --- a/arch/riscv/kernel/cpu_ops_spinwait.c
> +++ b/arch/riscv/kernel/cpu_ops_spinwait.c
> @@ -6,11 +6,36 @@
>  #include <linux/errno.h>
>  #include <linux/of.h>
>  #include <linux/string.h>
> +#include <linux/sched/task_stack.h>
>  #include <asm/cpu_ops.h>
>  #include <asm/sbi.h>
>  #include <asm/smp.h>
> 
>  const struct cpu_operations cpu_ops_spinwait;
> +void *__cpu_spinwait_stack_pointer[NR_CPUS] __section(".data");
> +void *__cpu_spinwait_task_pointer[NR_CPUS] __section(".data");
> +
> +static void cpu_update_secondary_bootdata(unsigned int cpuid,
> +				   struct task_struct *tidle)
> +{
> +	int hartid = cpuid_to_hartid_map(cpuid);
> +
> +	/*
> +	 * The hartid must be less than NR_CPUS to avoid out-of-bound access
> +	 * errors for __cpu_spinwait_stack/task_pointer. That is not always 
> possible
> +	 * for platforms with discontiguous hartid numbering scheme. That's 
> why
> +	 * spinwait booting is not the recommended approach for any platforms
> +	 * and will be removed in future.

How can you do that? Yes, spinning schemes are terrible.
However, once you started supporting them, you are stuck.

Best case, you can have an allow-list and only allow some
older platforms to use them. You can also make some features
dependent on non-spin schemes (kexec being one).

But dropping support isn't a valid option, I'm afraid.

Thanks,

          M.
-- 
Jazz is not dead. It just smells funny...
