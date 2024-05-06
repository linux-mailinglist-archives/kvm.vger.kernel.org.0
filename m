Return-Path: <kvm+bounces-16602-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 927938BC59F
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 03:53:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 496B12823F3
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 01:53:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2CC93E49E;
	Mon,  6 May 2024 01:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oNzzAwLG"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E66003C064;
	Mon,  6 May 2024 01:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714960398; cv=none; b=ZJVg6xToapqD59ww76edJXQmIBT6sRI5Foi16JOpxQTT0gS42NemAz7zSyOgiwIGDTt1XoHPq0y0zfvJctboysPPQv0uH0ryeRHCq5HI7wDkPF+q43QLvhqPGTntuSmyXLuzCojPvVgfCPy2iys58VK9b/K+rfzKR+qxi9o3DVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714960398; c=relaxed/simple;
	bh=FjncMrYMvj2zJElw9u1N9a5+m4ZjOM9KrU4Tms11h/g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=b0zIPqco02npZ6QlSS099Nm770mm19Y4S3+G9A4pb8Baou0Y1083xE7q0xZzQQYYc3kzwcIx3R738et266i47Qacn+6aF1DxzZLiSMPVM1R4t72moj0GszVZLpdyOI3h9uZSUbZx8pv/YJ8hpsEV0D+n9UT/UctJRK9B6T91wAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oNzzAwLG; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AFD5C4AF67;
	Mon,  6 May 2024 01:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714960397;
	bh=FjncMrYMvj2zJElw9u1N9a5+m4ZjOM9KrU4Tms11h/g=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=oNzzAwLGL3GQz8K3/y1gXdGIKuxbBC46EGE31J/uCwIgBBJkH0LVp+qEpSKUdwVKr
	 NXOB8nS2k3dC0GmMMmCqkHhfCFlsaW6RBKGAQF6Xl73Ugpcxh8eM45LLG3vWVlby4g
	 SPGWhLUIvDNmgQ2I1//odz1USMIdtECAlj0KRyxpYNwUKGfztgQ0sFDR4b/U/IrI2E
	 TOcz7+RtIj2AFkf0y5AFGnFHfbakwH5Igox1RCvsfxDlL8Ph3CZ8yOmJ7lveSVOuIO
	 3NbkbsZ+YP0PtxCAEy85uJvk9ExmKxcnug8j8vp5PG/Rb55S4BaTV9kzCTXWTphkYE
	 fJiRAbOLiGhJA==
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a59c0a6415fso192459566b.1;
        Sun, 05 May 2024 18:53:17 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCX7Xs6XWCEOpLAerTAsV/aLcXl8n/lrRv1pJHmLxyHuooSvEVrPuT+tVyowulNp9FmCl6lfCpHNUBXafhX9YPd564/3T4ej65U+mJt9YLfg08wN0UtQSvNm7sLEKl8lABlt
X-Gm-Message-State: AOJu0YzuyjSZwm/2WhXhAqsajct1gQEQjgiI62EWV1/xx5MvXjSNUE3F
	mV6Gr+hr7zIGUZdluRFITawbhI1+44utFWQXd0mf98CPV/bYdkmjDi9Fr21j+6uwLgQnPrU55js
	DpGYaU9gTRyDzigOiXWvCLj+nMZ0=
X-Google-Smtp-Source: AGHT+IEXbkzKFoWRT56M3HOHKsx7ECWFhJwqUtuCUay8JLMIVU7GmeecAY9yk7Pmg6SUhNXtQ9ENja4+ETYBlU5N7vw=
X-Received: by 2002:a17:907:d2a:b0:a59:af54:1651 with SMTP id
 gn42-20020a1709070d2a00b00a59af541651mr2532507ejc.57.1714960396095; Sun, 05
 May 2024 18:53:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240428100518.1642324-1-maobibo@loongson.cn> <20240428100518.1642324-7-maobibo@loongson.cn>
In-Reply-To: <20240428100518.1642324-7-maobibo@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Mon, 6 May 2024 09:53:06 +0800
X-Gmail-Original-Message-ID: <CAAhV-H7Z=XWGBtWzv2dkiHqeezTS7URYWHVMPpm5yRu=bQVWmQ@mail.gmail.com>
Message-ID: <CAAhV-H7Z=XWGBtWzv2dkiHqeezTS7URYWHVMPpm5yRu=bQVWmQ@mail.gmail.com>
Subject: Re: [PATCH v8 6/6] LoongArch: Add pv ipi support on guest kernel side
To: Bibo Mao <maobibo@loongson.cn>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, Juergen Gross <jgross@suse.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, loongarch@lists.linux.dev, 
	linux-kernel@vger.kernel.org, virtualization@lists.linux.dev, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, Bibo,

On Sun, Apr 28, 2024 at 6:05=E2=80=AFPM Bibo Mao <maobibo@loongson.cn> wrot=
e:
>
> PARAVIRT option and pv ipi is added on guest kernel side, function
> pv_ipi_init() is to add ipi sending and ipi receiving hooks. This functio=
n
> firstly checks whether system runs on VM mode. If kernel runs on VM mode,
> it will call function kvm_para_available() to detect current hypervirsor
> type. Now only KVM type detection is supported, the paravirt function can
> work only if current hypervisor type is KVM, since there is only KVM
> supported on LoongArch now.
>
> PV IPI uses virtual IPI sender and virtual IPI receiver function. With
> virutal IPI sender, ipi message is stored in DDR memory rather than
> emulated HW. IPI multicast is supported, and 128 vcpus can received IPIs
> at the same time like X86 KVM method. Hypercall method is used for IPI
> sending.
>
> With virtual IPI receiver, HW SW0 is used rather than real IPI HW. Since
> VCPU has separate HW SW0 like HW timer, there is no trap in IPI interrupt
> acknowledge. And IPI message is stored in DDR, no trap in get IPI message=
.
>
> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> ---
>  arch/loongarch/Kconfig                        |   9 ++
>  arch/loongarch/include/asm/hardirq.h          |   1 +
>  arch/loongarch/include/asm/paravirt.h         |  27 ++++
>  .../include/asm/paravirt_api_clock.h          |   1 +
>  arch/loongarch/kernel/Makefile                |   1 +
>  arch/loongarch/kernel/irq.c                   |   2 +-
>  arch/loongarch/kernel/paravirt.c              | 151 ++++++++++++++++++
>  arch/loongarch/kernel/smp.c                   |   4 +-
>  8 files changed, 194 insertions(+), 2 deletions(-)
>  create mode 100644 arch/loongarch/include/asm/paravirt.h
>  create mode 100644 arch/loongarch/include/asm/paravirt_api_clock.h
>  create mode 100644 arch/loongarch/kernel/paravirt.c
>
> diff --git a/arch/loongarch/Kconfig b/arch/loongarch/Kconfig
> index 54ad04dacdee..0a1540a8853e 100644
> --- a/arch/loongarch/Kconfig
> +++ b/arch/loongarch/Kconfig
> @@ -583,6 +583,15 @@ config CPU_HAS_PREFETCH
>         bool
>         default y
>
> +config PARAVIRT
> +       bool "Enable paravirtualization code"
> +       depends on AS_HAS_LVZ_EXTENSION
> +       help
> +          This changes the kernel so it can modify itself when it is run
> +         under a hypervisor, potentially improving performance significa=
ntly
> +         over full virtualization.  However, when run without a hypervis=
or
> +         the kernel is theoretically slower and slightly larger.
> +
>  config ARCH_SUPPORTS_KEXEC
>         def_bool y
>
> diff --git a/arch/loongarch/include/asm/hardirq.h b/arch/loongarch/includ=
e/asm/hardirq.h
> index 9f0038e19c7f..b26d596a73aa 100644
> --- a/arch/loongarch/include/asm/hardirq.h
> +++ b/arch/loongarch/include/asm/hardirq.h
> @@ -21,6 +21,7 @@ enum ipi_msg_type {
>  typedef struct {
>         unsigned int ipi_irqs[NR_IPI];
>         unsigned int __softirq_pending;
> +       atomic_t message ____cacheline_aligned_in_smp;
>  } ____cacheline_aligned irq_cpustat_t;
>
>  DECLARE_PER_CPU_SHARED_ALIGNED(irq_cpustat_t, irq_stat);
> diff --git a/arch/loongarch/include/asm/paravirt.h b/arch/loongarch/inclu=
de/asm/paravirt.h
> new file mode 100644
> index 000000000000..58f7b7b89f2c
> --- /dev/null
> +++ b/arch/loongarch/include/asm/paravirt.h
> @@ -0,0 +1,27 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _ASM_LOONGARCH_PARAVIRT_H
> +#define _ASM_LOONGARCH_PARAVIRT_H
> +
> +#ifdef CONFIG_PARAVIRT
> +#include <linux/static_call_types.h>
> +struct static_key;
> +extern struct static_key paravirt_steal_enabled;
> +extern struct static_key paravirt_steal_rq_enabled;
> +
> +u64 dummy_steal_clock(int cpu);
> +DECLARE_STATIC_CALL(pv_steal_clock, dummy_steal_clock);
> +
> +static inline u64 paravirt_steal_clock(int cpu)
> +{
> +       return static_call(pv_steal_clock)(cpu);
> +}
> +
> +int pv_ipi_init(void);
> +#else
> +static inline int pv_ipi_init(void)
> +{
> +       return 0;
> +}
> +
> +#endif // CONFIG_PARAVIRT
> +#endif
> diff --git a/arch/loongarch/include/asm/paravirt_api_clock.h b/arch/loong=
arch/include/asm/paravirt_api_clock.h
> new file mode 100644
> index 000000000000..65ac7cee0dad
> --- /dev/null
> +++ b/arch/loongarch/include/asm/paravirt_api_clock.h
> @@ -0,0 +1 @@
> +#include <asm/paravirt.h>
> diff --git a/arch/loongarch/kernel/Makefile b/arch/loongarch/kernel/Makef=
ile
> index 3a7620b66bc6..c9bfeda89e40 100644
> --- a/arch/loongarch/kernel/Makefile
> +++ b/arch/loongarch/kernel/Makefile
> @@ -51,6 +51,7 @@ obj-$(CONFIG_MODULES)         +=3D module.o module-sect=
ions.o
>  obj-$(CONFIG_STACKTRACE)       +=3D stacktrace.o
>
>  obj-$(CONFIG_PROC_FS)          +=3D proc.o
> +obj-$(CONFIG_PARAVIRT)         +=3D paravirt.o
>
>  obj-$(CONFIG_SMP)              +=3D smp.o
>
> diff --git a/arch/loongarch/kernel/irq.c b/arch/loongarch/kernel/irq.c
> index ce36897d1e5a..4863e6c1b739 100644
> --- a/arch/loongarch/kernel/irq.c
> +++ b/arch/loongarch/kernel/irq.c
> @@ -113,5 +113,5 @@ void __init init_IRQ(void)
>                         per_cpu(irq_stack, i), per_cpu(irq_stack, i) + IR=
Q_STACK_SIZE);
>         }
>
> -       set_csr_ecfg(ECFGF_IP0 | ECFGF_IP1 | ECFGF_IP2 | ECFGF_IPI | ECFG=
F_PMC);
> +       set_csr_ecfg(ECFGF_SIP0 | ECFGF_IP0 | ECFGF_IP1 | ECFGF_IP2 | ECF=
GF_IPI | ECFGF_PMC);
>  }
> diff --git a/arch/loongarch/kernel/paravirt.c b/arch/loongarch/kernel/par=
avirt.c
> new file mode 100644
> index 000000000000..9044ed62045c
> --- /dev/null
> +++ b/arch/loongarch/kernel/paravirt.c
> @@ -0,0 +1,151 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include <linux/export.h>
> +#include <linux/types.h>
> +#include <linux/interrupt.h>
> +#include <linux/jump_label.h>
> +#include <linux/kvm_para.h>
> +#include <asm/paravirt.h>
> +#include <linux/static_call.h>
> +
> +struct static_key paravirt_steal_enabled;
> +struct static_key paravirt_steal_rq_enabled;
> +
> +static u64 native_steal_clock(int cpu)
> +{
> +       return 0;
> +}
> +
> +DEFINE_STATIC_CALL(pv_steal_clock, native_steal_clock);
> +
> +#ifdef CONFIG_SMP
> +static void pv_send_ipi_single(int cpu, unsigned int action)
> +{
> +       unsigned int min, old;
> +       irq_cpustat_t *info =3D &per_cpu(irq_stat, cpu);
> +
> +       old =3D atomic_fetch_or(BIT(action), &info->message);
> +       if (old)
> +               return;
> +
> +       min =3D cpu_logical_map(cpu);
> +       kvm_hypercall3(KVM_HCALL_FUNC_PV_IPI, 1, 0, min);
> +}
> +
> +#define KVM_IPI_CLUSTER_SIZE           (2 * BITS_PER_LONG)
> +static void pv_send_ipi_mask(const struct cpumask *mask, unsigned int ac=
tion)
> +{
> +       unsigned int cpu, i, min =3D 0, max =3D 0, old;
> +       __uint128_t bitmap =3D 0;
> +       irq_cpustat_t *info;
> +
> +       if (cpumask_empty(mask))
> +               return;
> +
> +       action =3D BIT(action);
> +       for_each_cpu(i, mask) {
> +               info =3D &per_cpu(irq_stat, i);
> +               old =3D atomic_fetch_or(action, &info->message);
> +               if (old)
> +                       continue;
> +
> +               cpu =3D cpu_logical_map(i);
> +               if (!bitmap) {
> +                       min =3D max =3D cpu;
> +               } else if (cpu > min && cpu < min + KVM_IPI_CLUSTER_SIZE)=
 {
> +                       max =3D cpu > max ? cpu : max;
> +               } else if (cpu < min && (max - cpu) < KVM_IPI_CLUSTER_SIZ=
E) {
> +                       bitmap <<=3D min - cpu;
> +                       min =3D cpu;
> +               } else {
> +                       /*
> +                        * Physical cpuid is sorted in ascending order as=
cend
> +                        * for the next mask calculation, send IPI here
> +                        * directly and skip the remainding cpus
> +                        */
> +                       kvm_hypercall3(KVM_HCALL_FUNC_PV_IPI,
> +                               (unsigned long)bitmap,
> +                               (unsigned long)(bitmap >> BITS_PER_LONG),=
 min);
> +                       min =3D max =3D cpu;
> +                       bitmap =3D 0;
> +               }
I have changed the logic and comments when I apply, you can double
check whether it is correct.

Huacai

> +               __set_bit(cpu - min, (unsigned long *)&bitmap);
> +       }
> +
> +       if (bitmap)
> +               kvm_hypercall3(KVM_HCALL_FUNC_PV_IPI, (unsigned long)bitm=
ap,
> +                               (unsigned long)(bitmap >> BITS_PER_LONG),=
 min);
> +}
> +
> +static irqreturn_t loongson_do_swi(int irq, void *dev)
> +{
> +       irq_cpustat_t *info;
> +       long action;
> +
> +       /* Clear swi interrupt */
> +       clear_csr_estat(1 << INT_SWI0);
> +       info =3D this_cpu_ptr(&irq_stat);
> +       action =3D atomic_xchg(&info->message, 0);
> +       if (action & SMP_CALL_FUNCTION) {
> +               generic_smp_call_function_interrupt();
> +               info->ipi_irqs[IPI_CALL_FUNCTION]++;
> +       }
> +
> +       if (action & SMP_RESCHEDULE) {
> +               scheduler_ipi();
> +               info->ipi_irqs[IPI_RESCHEDULE]++;
> +       }
> +
> +       return IRQ_HANDLED;
> +}
> +
> +static void pv_init_ipi(void)
> +{
> +       int r, swi0;
> +
> +       swi0 =3D get_percpu_irq(INT_SWI0);
> +       if (swi0 < 0)
> +               panic("SWI0 IRQ mapping failed\n");
> +       irq_set_percpu_devid(swi0);
> +       r =3D request_percpu_irq(swi0, loongson_do_swi, "SWI0", &irq_stat=
);
> +       if (r < 0)
> +               panic("SWI0 IRQ request failed\n");
> +}
> +#endif
> +
> +static bool kvm_para_available(void)
> +{
> +       static int hypervisor_type;
> +       int config;
> +
> +       if (!hypervisor_type) {
> +               config =3D read_cpucfg(CPUCFG_KVM_SIG);
> +               if (!memcmp(&config, KVM_SIGNATURE, 4))
> +                       hypervisor_type =3D HYPERVISOR_KVM;
> +       }
> +
> +       return hypervisor_type =3D=3D HYPERVISOR_KVM;
> +}
> +
> +int __init pv_ipi_init(void)
> +{
> +       int feature;
> +
> +       if (!cpu_has_hypervisor)
> +               return 0;
> +       if (!kvm_para_available())
> +               return 0;
> +
> +       /*
> +        * check whether KVM hypervisor supports pv_ipi or not
> +        */
> +       feature =3D read_cpucfg(CPUCFG_KVM_FEATURE);
> +#ifdef CONFIG_SMP
> +       if (feature & KVM_FEATURE_PV_IPI) {
> +               smp_ops.init_ipi                =3D pv_init_ipi;
> +               smp_ops.send_ipi_single         =3D pv_send_ipi_single;
> +               smp_ops.send_ipi_mask           =3D pv_send_ipi_mask;
> +       }
> +#endif
> +
> +       return 1;
> +}
> diff --git a/arch/loongarch/kernel/smp.c b/arch/loongarch/kernel/smp.c
> index 1fce775be4f6..9eff7aa4c552 100644
> --- a/arch/loongarch/kernel/smp.c
> +++ b/arch/loongarch/kernel/smp.c
> @@ -29,6 +29,7 @@
>  #include <asm/loongson.h>
>  #include <asm/mmu_context.h>
>  #include <asm/numa.h>
> +#include <asm/paravirt.h>
>  #include <asm/processor.h>
>  #include <asm/setup.h>
>  #include <asm/time.h>
> @@ -309,6 +310,7 @@ void __init loongson_smp_setup(void)
>         cpu_data[0].core =3D cpu_logical_map(0) % loongson_sysconf.cores_=
per_package;
>         cpu_data[0].package =3D cpu_logical_map(0) / loongson_sysconf.cor=
es_per_package;
>
> +       pv_ipi_init();
>         iocsr_write32(0xffffffff, LOONGARCH_IOCSR_IPI_EN);
>         pr_info("Detected %i available CPU(s)\n", loongson_sysconf.nr_cpu=
s);
>  }
> @@ -352,7 +354,7 @@ void loongson_boot_secondary(int cpu, struct task_str=
uct *idle)
>  void loongson_init_secondary(void)
>  {
>         unsigned int cpu =3D smp_processor_id();
> -       unsigned int imask =3D ECFGF_IP0 | ECFGF_IP1 | ECFGF_IP2 |
> +       unsigned int imask =3D ECFGF_SIP0 | ECFGF_IP0 | ECFGF_IP1 | ECFGF=
_IP2 |
>                              ECFGF_IPI | ECFGF_PMC | ECFGF_TIMER;
>
>         change_csr_ecfg(ECFG0_IM, imask);
> --
> 2.39.3
>

