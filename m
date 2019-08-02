Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C3A67F50A
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2019 12:30:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391599AbfHBKa6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Aug 2019 06:30:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34354 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730143AbfHBKa6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Aug 2019 06:30:58 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7AFC212E5;
        Fri,  2 Aug 2019 10:30:57 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C91D75C205;
        Fri,  2 Aug 2019 10:30:55 +0000 (UTC)
Date:   Fri, 2 Aug 2019 12:30:53 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Alexandru Elisei <Alexandru.Elisei@arm.com>
Cc:     Marc Zyngier <Marc.Zyngier@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Andre Przywara <Andre.Przywara@arm.com>,
        Dave P Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH 00/59] KVM: arm64: ARMv8.3 Nested Virtualization support
Message-ID: <20190802103053.7fvvp32ewlpnnyix@kamzik.brq.redhat.com>
References: <20190621093843.220980-1-marc.zyngier@arm.com>
 <69cf1fe7-912c-1767-ff1b-dfcc7f549e44@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <69cf1fe7-912c-1767-ff1b-dfcc7f549e44@arm.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Fri, 02 Aug 2019 10:30:57 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 02, 2019 at 10:11:38AM +0000, Alexandru Elisei wrote:
> These are the changes that I made to kvm-unit-tests (the diff can be applied on
> top of upstream master, 2130fd4154ad ("tscdeadline_latency: Check condition
> first before loop")):

It's great to hear that you're doing this. You may find these bit-rotted
commits useful too

https://github.com/rhdrjones/kvm-unit-tests/commits/arm64/hyp-mode

Thanks,
drew

> 
> diff --git a/arm/cstart64.S b/arm/cstart64.S
> index b0e8baa1a23a..a7631b5a1801 100644
> --- a/arm/cstart64.S
> +++ b/arm/cstart64.S
> @@ -51,6 +51,17 @@ start:
>         b       1b
> 
>  1:
> +       mrs     x4, CurrentEL
> +       cmp     x4, CurrentEL_EL2
> +       b.ne    1f
> +       mrs     x4, mpidr_el1
> +       msr     vmpidr_el2, x4
> +       mrs     x4, midr_el1
> +       msr     vpidr_el2, x4
> +       ldr     x4, =(HCR_EL2_TGE | HCR_EL2_E2H)
> +       msr     hcr_el2, x4
> +       isb
> +1:
>         /* set up stack */
>         mov     x4, #1
>         msr     spsel, x4
> @@ -101,6 +112,17 @@ get_mmu_off:
> 
>  .globl secondary_entry
>  secondary_entry:
> +       mrs     x0, CurrentEL
> +       cmp     x0, CurrentEL_EL2
> +       b.ne    1f
> +       mrs     x0, mpidr_el1
> +       msr     vmpidr_el2, x0
> +       mrs     x0, midr_el1
> +       msr     vpidr_el2, x0
> +       ldr     x0, =(HCR_EL2_TGE | HCR_EL2_E2H)
> +       msr     hcr_el2, x0
> +       isb
> +1:
>         /* Enable FP/ASIMD */
>         mov     x0, #(3 << 20)
>         msr     cpacr_el1, x0
> diff --git a/lib/arm/asm/psci.h b/lib/arm/asm/psci.h
> index 7b956bf5987d..07297a27e0ce 100644
> --- a/lib/arm/asm/psci.h
> +++ b/lib/arm/asm/psci.h
> @@ -3,6 +3,15 @@
>  #include <libcflat.h>
>  #include <linux/psci.h>
> 
> +enum psci_conduit {
> +       PSCI_CONDUIT_HVC,
> +       PSCI_CONDUIT_SMC,
> +};
> +
> +extern void psci_init(void);
> +extern void psci_set_conduit(enum psci_conduit conduit);
> +extern enum psci_conduit psci_get_conduit(void);
> +
>  extern int psci_invoke(unsigned long function_id, unsigned long arg0,
>                        unsigned long arg1, unsigned long arg2);
>  extern int psci_cpu_on(unsigned long cpuid, unsigned long entry_point);
> diff --git a/lib/arm/psci.c b/lib/arm/psci.c
> index c3d399064ae3..20ad4b944738 100644
> --- a/lib/arm/psci.c
> +++ b/lib/arm/psci.c
> @@ -6,13 +6,14 @@
>   *
>   * This work is licensed under the terms of the GNU LGPL, version 2.
>   */
> +#include <devicetree.h>
> +#include <string.h>
>  #include <asm/psci.h>
>  #include <asm/setup.h>
>  #include <asm/page.h>
>  #include <asm/smp.h>
> 
> -__attribute__((noinline))
> -int psci_invoke(unsigned long function_id, unsigned long arg0,
> +static int psci_invoke_hvc(unsigned long function_id, unsigned long arg0,
>                 unsigned long arg1, unsigned long arg2)
>  {
>         asm volatile(
> @@ -22,6 +23,63 @@ int psci_invoke(unsigned long function_id, unsigned long arg0,
>         return function_id;
>  }
> 
> +static int psci_invoke_smc(unsigned long function_id, unsigned long arg0,
> +               unsigned long arg1, unsigned long arg2)
> +{
> +       asm volatile(
> +               "smc #0"
> +       : "+r" (function_id)
> +       : "r" (arg0), "r" (arg1), "r" (arg2));
> +       return function_id;
> +}
> +
> +/*
> + * Initialize to something sensible, so the exit fallback psci_system_off still
> + * works before calling psci_init when booted at EL1.
> + */
> +static enum psci_conduit psci_conduit = PSCI_CONDUIT_HVC;
> +static int (*psci_fn)(unsigned long, unsigned long, unsigned long,
> +               unsigned long) = &psci_invoke_hvc;
> +
> +void psci_set_conduit(enum psci_conduit conduit)
> +{
> +       psci_conduit = conduit;
> +       if (conduit == PSCI_CONDUIT_HVC)
> +               psci_fn = &psci_invoke_hvc;
> +       else
> +               psci_fn = &psci_invoke_smc;
> +}
> +
> +enum psci_conduit psci_get_conduit(void)
> +{
> +       return psci_conduit;
> +}
> +
> +int psci_invoke(unsigned long function_id, unsigned long arg0,
> +               unsigned long arg1, unsigned long arg2)
> +{
> +       return psci_fn(function_id, arg0, arg1, arg2);
> +}
> +
> +void psci_init(void)
> +{
> +       const char *conduit;
> +       int ret;
> +
> +       ret = dt_get_psci_conduit(&conduit);
> +       assert(ret == 0 || ret == -FDT_ERR_NOTFOUND);
> +
> +       if (ret == -FDT_ERR_NOTFOUND)
> +               conduit = "hvc";
> +
> +       assert(strcmp(conduit, "hvc") == 0 || strcmp(conduit, "smc") == 0);
> +
> +       if (strcmp(conduit, "hvc") == 0)
> +               psci_set_conduit(PSCI_CONDUIT_HVC);
> +       else
> +               psci_set_conduit(PSCI_CONDUIT_SMC);
> +}
> +
>  int psci_cpu_on(unsigned long cpuid, unsigned long entry_point)
>  {
>  #ifdef __arm__
> diff --git a/lib/arm/setup.c b/lib/arm/setup.c
> index 4f02fca85607..e0dc9e4801b0 100644
> --- a/lib/arm/setup.c
> +++ b/lib/arm/setup.c
> @@ -21,6 +21,7 @@
>  #include <asm/setup.h>
>  #include <asm/page.h>
>  #include <asm/smp.h>
> +#include <asm/psci.h>
> 
>  #include "io.h"
> 
> @@ -164,7 +165,11 @@ void setup(const void *fdt)
>                 freemem += initrd_size;
>         }
> 
> -       /* call init functions */
> +       /*
> +        * call init functions. psci_init goes first so psci_system_off fallback
> +        * works in case of an assert failure
> +        */
> +       psci_init();
>         mem_init(PAGE_ALIGN((unsigned long)freemem));
>         cpu_init();
> 
> diff --git a/lib/arm64/asm/processor.h b/lib/arm64/asm/processor.h
> index 1d9223f728a5..18c5d29ddd1f 100644
> --- a/lib/arm64/asm/processor.h
> +++ b/lib/arm64/asm/processor.h
> @@ -16,6 +16,9 @@
>  #define SCTLR_EL1_A    (1 << 1)
>  #define SCTLR_EL1_M    (1 << 0)
> 
> +#define HCR_EL2_TGE    (1 << 27)
> +#define HCR_EL2_E2H    (1 << 34)
> +
>  #ifndef __ASSEMBLY__
>  #include <asm/ptrace.h>
>  #include <asm/esr.h>
> diff --git a/lib/devicetree.c b/lib/devicetree.c
> index 2b89178a109b..4e684c7100b2 100644
> --- a/lib/devicetree.c
> +++ b/lib/devicetree.c
> @@ -263,6 +263,27 @@ int dt_get_bootargs(const char **bootargs)
>         return 0;
>  }
> 
> +int dt_get_psci_conduit(const char **conduit)
> +{
> +       const struct fdt_property *prop;
> +       int node, len;
> +
> +       *conduit = NULL;
> +
> +       node = fdt_node_offset_by_compatible(fdt, -1, "arm,psci-0.2");
> +       if (node < 0)
> +               return node;
> +
> +       prop = fdt_get_property(fdt, node, "method", &len);
> +       if (!prop)
> +               return len;
> +       if (len < 4)
> +               return -FDT_ERR_NOTFOUND;
> +
> +       *conduit = prop->data;
> +       return 0;
> +}
> +
>  int dt_get_default_console_node(void)
>  {
>         const struct fdt_property *prop;
> diff --git a/lib/devicetree.h b/lib/devicetree.h
> index 93c7ebc63bd8..236035eb777d 100644
> --- a/lib/devicetree.h
> +++ b/lib/devicetree.h
> @@ -211,6 +211,15 @@ extern int dt_get_reg(int fdtnode, int regidx, struct
> dt_reg *reg);
>  extern int dt_get_bootargs(const char **bootargs);
> 
>  /*
> + * dt_get_psci_conduit gets the conduit for PSCI function invocations from
> + * /psci/method
> + * returns
> + *   - zero on success
> + *   - a negative FDT_ERR_* value on failure, and @conduit will be set to null
> + */
> +extern int dt_get_psci_conduit(const char **conduit);
> +
> +/*
>   * dt_get_default_console_node gets the node of the path stored in
>   * /chosen/stdout-path (or the deprecated /chosen/linux,stdout-path)
>   * returns
> 
> IMPORTANT NOTICE: The contents of this email and any attachments are confidential and may also be privileged. If you are not the intended recipient, please notify the sender immediately and do not disclose the contents to any other person, use it for any purpose, or store or copy the information in any medium. Thank you.
