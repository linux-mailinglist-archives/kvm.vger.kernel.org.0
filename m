Return-Path: <kvm+bounces-16674-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 840B48BC7FA
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 09:04:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0FE0D1F21C28
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 07:04:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B66D7128374;
	Mon,  6 May 2024 07:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RpqChsXe"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCFB94F20E;
	Mon,  6 May 2024 07:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714979055; cv=none; b=fAfoWap/q+neOwq0kD/e8XDQMCth3+iSvGnFckilOe7lmG6XLCQogtoLHOr/8Rwm+gxvAfwaKiCwOfhjt7vChegsaClQ0SgLvKo2FA4bI9phXJ1ae7h80E8b6xtmpPzxHmw95bTDKEFZH2YhIjbT+g2NXy4OOpHbfYEPsRMgem8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714979055; c=relaxed/simple;
	bh=or/5BdbPBMnxvZKxawEjMlSiwx/k/InkAl0En5LtRa0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=utUQBXKIlrvWIMhJt6qpi5OnOc+hkEjRI06vLhGR+s1bW2g6SOAiFzgiW8hIw3AhG+UvMuR95FcsZsLKpi0UwoKdw47KSNE/3FABu4gWQJppr7HU+8h2axZo/fGnIaWDaz+sQ+y7z4ZeAAXs+vdNNdTdbGEo397xkSh6taYiL+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RpqChsXe; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62E6AC4AF65;
	Mon,  6 May 2024 07:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714979054;
	bh=or/5BdbPBMnxvZKxawEjMlSiwx/k/InkAl0En5LtRa0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=RpqChsXezl57eWacUldP/6i1Z/ww5fEu880VoelPKaSyq+S+7g6Tk5rqQPWorkFUv
	 CJFq92qj/vZdfa27Cc6snpdvJXQnLSio6mFjCIO0DDAyUg2gc7JkoaZBoSfunI0x7c
	 lwM7NwJQ0mYFfYeF4L29OZMc4YKQ3FDQi6Ow5JjhjMcF2casJmGora+xba/snN1lLL
	 Ls4gEF2SnKchYMwVJdNee3JPVE735JpY9ILP78fCiJwVsMh9fOfpcfBxsw9TOanxyl
	 VKpkxrGGmF4jlQoYnQvsJ5iwE0RqOoFMBBYgYVN2ccdepby3nM3xwlN/9mWAFHRpoy
	 gZJoVy474ZQHg==
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a59b81d087aso256954566b.3;
        Mon, 06 May 2024 00:04:14 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWLFdlr9wEF1Yz1t6APOg0E2B6FYGT5Tkw9kXHYLJlyOVTSW90bWLLrlM74LZGTIiLehWHscVwvGmKM0tPrKkgkKXR00Mo9vuFoDsQ0G8fa6vGPJrJ0ZuB1h2p1sdPmkO5l
X-Gm-Message-State: AOJu0YyviS66YtWTKE9DirnnKdnJugmI1w6PhNfKyJplrfVGsSrtbLBp
	5UZQv0Dk1KJyep50xXRLh9f46WTQBvShb5fJherLsDzQEiIB5dF2+O/O5VFywUD1gQogjjBmtWU
	bBjWkFbG/8USdafJv8F1AE4W48lc=
X-Google-Smtp-Source: AGHT+IHySgSNYR7SRt2or0ozjZ1e+0ewXCicKymuxCCS0hiagDUUnGz2dSv+f3vSRtx4jYJI0+Ct016oHJhVkH2BZ2A=
X-Received: by 2002:a17:906:2dcb:b0:a59:cc9b:d6f8 with SMTP id
 h11-20020a1709062dcb00b00a59cc9bd6f8mr1845020eji.39.1714979052921; Mon, 06
 May 2024 00:04:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240428100518.1642324-1-maobibo@loongson.cn> <20240428100518.1642324-7-maobibo@loongson.cn>
 <CAAhV-H7Z=XWGBtWzv2dkiHqeezTS7URYWHVMPpm5yRu=bQVWmQ@mail.gmail.com> <fa76a04d-e321-ff34-3d94-f528d28c5793@loongson.cn>
In-Reply-To: <fa76a04d-e321-ff34-3d94-f528d28c5793@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Mon, 6 May 2024 15:04:03 +0800
X-Gmail-Original-Message-ID: <CAAhV-H4XSnHBNCitcxPxF7LitCdVHhnVR9DDwaUgEuwbGkqBGA@mail.gmail.com>
Message-ID: <CAAhV-H4XSnHBNCitcxPxF7LitCdVHhnVR9DDwaUgEuwbGkqBGA@mail.gmail.com>
Subject: Re: [PATCH v8 6/6] LoongArch: Add pv ipi support on guest kernel side
To: maobibo <maobibo@loongson.cn>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, Juergen Gross <jgross@suse.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, loongarch@lists.linux.dev, 
	linux-kernel@vger.kernel.org, virtualization@lists.linux.dev, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 6, 2024 at 3:00=E2=80=AFPM maobibo <maobibo@loongson.cn> wrote:
>
>
>
> On 2024/5/6 =E4=B8=8A=E5=8D=889:53, Huacai Chen wrote:
> > Hi, Bibo,
> >
> > On Sun, Apr 28, 2024 at 6:05=E2=80=AFPM Bibo Mao <maobibo@loongson.cn> =
wrote:
> >>
> >> PARAVIRT option and pv ipi is added on guest kernel side, function
> >> pv_ipi_init() is to add ipi sending and ipi receiving hooks. This func=
tion
> >> firstly checks whether system runs on VM mode. If kernel runs on VM mo=
de,
> >> it will call function kvm_para_available() to detect current hypervirs=
or
> >> type. Now only KVM type detection is supported, the paravirt function =
can
> >> work only if current hypervisor type is KVM, since there is only KVM
> >> supported on LoongArch now.
> >>
> >> PV IPI uses virtual IPI sender and virtual IPI receiver function. With
> >> virutal IPI sender, ipi message is stored in DDR memory rather than
> >> emulated HW. IPI multicast is supported, and 128 vcpus can received IP=
Is
> >> at the same time like X86 KVM method. Hypercall method is used for IPI
> >> sending.
> >>
> >> With virtual IPI receiver, HW SW0 is used rather than real IPI HW. Sin=
ce
> >> VCPU has separate HW SW0 like HW timer, there is no trap in IPI interr=
upt
> >> acknowledge. And IPI message is stored in DDR, no trap in get IPI mess=
age.
> >>
> >> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> >> ---
> >>   arch/loongarch/Kconfig                        |   9 ++
> >>   arch/loongarch/include/asm/hardirq.h          |   1 +
> >>   arch/loongarch/include/asm/paravirt.h         |  27 ++++
> >>   .../include/asm/paravirt_api_clock.h          |   1 +
> >>   arch/loongarch/kernel/Makefile                |   1 +
> >>   arch/loongarch/kernel/irq.c                   |   2 +-
> >>   arch/loongarch/kernel/paravirt.c              | 151 ++++++++++++++++=
++
> >>   arch/loongarch/kernel/smp.c                   |   4 +-
> >>   8 files changed, 194 insertions(+), 2 deletions(-)
> >>   create mode 100644 arch/loongarch/include/asm/paravirt.h
> >>   create mode 100644 arch/loongarch/include/asm/paravirt_api_clock.h
> >>   create mode 100644 arch/loongarch/kernel/paravirt.c
> >>
> >> diff --git a/arch/loongarch/Kconfig b/arch/loongarch/Kconfig
> >> index 54ad04dacdee..0a1540a8853e 100644
> >> --- a/arch/loongarch/Kconfig
> >> +++ b/arch/loongarch/Kconfig
> >> @@ -583,6 +583,15 @@ config CPU_HAS_PREFETCH
> >>          bool
> >>          default y
> >>
> >> +config PARAVIRT
> >> +       bool "Enable paravirtualization code"
> >> +       depends on AS_HAS_LVZ_EXTENSION
> >> +       help
> >> +          This changes the kernel so it can modify itself when it is =
run
> >> +         under a hypervisor, potentially improving performance signif=
icantly
> >> +         over full virtualization.  However, when run without a hyper=
visor
> >> +         the kernel is theoretically slower and slightly larger.
> >> +
> >>   config ARCH_SUPPORTS_KEXEC
> >>          def_bool y
> >>
> >> diff --git a/arch/loongarch/include/asm/hardirq.h b/arch/loongarch/inc=
lude/asm/hardirq.h
> >> index 9f0038e19c7f..b26d596a73aa 100644
> >> --- a/arch/loongarch/include/asm/hardirq.h
> >> +++ b/arch/loongarch/include/asm/hardirq.h
> >> @@ -21,6 +21,7 @@ enum ipi_msg_type {
> >>   typedef struct {
> >>          unsigned int ipi_irqs[NR_IPI];
> >>          unsigned int __softirq_pending;
> >> +       atomic_t message ____cacheline_aligned_in_smp;
> >>   } ____cacheline_aligned irq_cpustat_t;
> >>
> >>   DECLARE_PER_CPU_SHARED_ALIGNED(irq_cpustat_t, irq_stat);
> >> diff --git a/arch/loongarch/include/asm/paravirt.h b/arch/loongarch/in=
clude/asm/paravirt.h
> >> new file mode 100644
> >> index 000000000000..58f7b7b89f2c
> >> --- /dev/null
> >> +++ b/arch/loongarch/include/asm/paravirt.h
> >> @@ -0,0 +1,27 @@
> >> +/* SPDX-License-Identifier: GPL-2.0 */
> >> +#ifndef _ASM_LOONGARCH_PARAVIRT_H
> >> +#define _ASM_LOONGARCH_PARAVIRT_H
> >> +
> >> +#ifdef CONFIG_PARAVIRT
> >> +#include <linux/static_call_types.h>
> >> +struct static_key;
> >> +extern struct static_key paravirt_steal_enabled;
> >> +extern struct static_key paravirt_steal_rq_enabled;
> >> +
> >> +u64 dummy_steal_clock(int cpu);
> >> +DECLARE_STATIC_CALL(pv_steal_clock, dummy_steal_clock);
> >> +
> >> +static inline u64 paravirt_steal_clock(int cpu)
> >> +{
> >> +       return static_call(pv_steal_clock)(cpu);
> >> +}
> >> +
> >> +int pv_ipi_init(void);
> >> +#else
> >> +static inline int pv_ipi_init(void)
> >> +{
> >> +       return 0;
> >> +}
> >> +
> >> +#endif // CONFIG_PARAVIRT
> >> +#endif
> >> diff --git a/arch/loongarch/include/asm/paravirt_api_clock.h b/arch/lo=
ongarch/include/asm/paravirt_api_clock.h
> >> new file mode 100644
> >> index 000000000000..65ac7cee0dad
> >> --- /dev/null
> >> +++ b/arch/loongarch/include/asm/paravirt_api_clock.h
> >> @@ -0,0 +1 @@
> >> +#include <asm/paravirt.h>
> >> diff --git a/arch/loongarch/kernel/Makefile b/arch/loongarch/kernel/Ma=
kefile
> >> index 3a7620b66bc6..c9bfeda89e40 100644
> >> --- a/arch/loongarch/kernel/Makefile
> >> +++ b/arch/loongarch/kernel/Makefile
> >> @@ -51,6 +51,7 @@ obj-$(CONFIG_MODULES)         +=3D module.o module-s=
ections.o
> >>   obj-$(CONFIG_STACKTRACE)       +=3D stacktrace.o
> >>
> >>   obj-$(CONFIG_PROC_FS)          +=3D proc.o
> >> +obj-$(CONFIG_PARAVIRT)         +=3D paravirt.o
> >>
> >>   obj-$(CONFIG_SMP)              +=3D smp.o
> >>
> >> diff --git a/arch/loongarch/kernel/irq.c b/arch/loongarch/kernel/irq.c
> >> index ce36897d1e5a..4863e6c1b739 100644
> >> --- a/arch/loongarch/kernel/irq.c
> >> +++ b/arch/loongarch/kernel/irq.c
> >> @@ -113,5 +113,5 @@ void __init init_IRQ(void)
> >>                          per_cpu(irq_stack, i), per_cpu(irq_stack, i) =
+ IRQ_STACK_SIZE);
> >>          }
> >>
> >> -       set_csr_ecfg(ECFGF_IP0 | ECFGF_IP1 | ECFGF_IP2 | ECFGF_IPI | E=
CFGF_PMC);
> >> +       set_csr_ecfg(ECFGF_SIP0 | ECFGF_IP0 | ECFGF_IP1 | ECFGF_IP2 | =
ECFGF_IPI | ECFGF_PMC);
> >>   }
> >> diff --git a/arch/loongarch/kernel/paravirt.c b/arch/loongarch/kernel/=
paravirt.c
> >> new file mode 100644
> >> index 000000000000..9044ed62045c
> >> --- /dev/null
> >> +++ b/arch/loongarch/kernel/paravirt.c
> >> @@ -0,0 +1,151 @@
> >> +// SPDX-License-Identifier: GPL-2.0
> >> +#include <linux/export.h>
> >> +#include <linux/types.h>
> >> +#include <linux/interrupt.h>
> >> +#include <linux/jump_label.h>
> >> +#include <linux/kvm_para.h>
> >> +#include <asm/paravirt.h>
> >> +#include <linux/static_call.h>
> >> +
> >> +struct static_key paravirt_steal_enabled;
> >> +struct static_key paravirt_steal_rq_enabled;
> >> +
> >> +static u64 native_steal_clock(int cpu)
> >> +{
> >> +       return 0;
> >> +}
> >> +
> >> +DEFINE_STATIC_CALL(pv_steal_clock, native_steal_clock);
> >> +
> >> +#ifdef CONFIG_SMP
> >> +static void pv_send_ipi_single(int cpu, unsigned int action)
> >> +{
> >> +       unsigned int min, old;
> >> +       irq_cpustat_t *info =3D &per_cpu(irq_stat, cpu);
> >> +
> >> +       old =3D atomic_fetch_or(BIT(action), &info->message);
> >> +       if (old)
> >> +               return;
> >> +
> >> +       min =3D cpu_logical_map(cpu);
> >> +       kvm_hypercall3(KVM_HCALL_FUNC_PV_IPI, 1, 0, min);
> >> +}
> >> +
> >> +#define KVM_IPI_CLUSTER_SIZE           (2 * BITS_PER_LONG)
> >> +static void pv_send_ipi_mask(const struct cpumask *mask, unsigned int=
 action)
> >> +{
> >> +       unsigned int cpu, i, min =3D 0, max =3D 0, old;
> >> +       __uint128_t bitmap =3D 0;
> >> +       irq_cpustat_t *info;
> >> +
> >> +       if (cpumask_empty(mask))
> >> +               return;
> >> +
> >> +       action =3D BIT(action);
> >> +       for_each_cpu(i, mask) {
> >> +               info =3D &per_cpu(irq_stat, i);
> >> +               old =3D atomic_fetch_or(action, &info->message);
> >> +               if (old)
> >> +                       continue;
> >> +
> >> +               cpu =3D cpu_logical_map(i);
> >> +               if (!bitmap) {
> >> +                       min =3D max =3D cpu;
> >> +               } else if (cpu > min && cpu < min + KVM_IPI_CLUSTER_SI=
ZE) {
> >> +                       max =3D cpu > max ? cpu : max;
> >> +               } else if (cpu < min && (max - cpu) < KVM_IPI_CLUSTER_=
SIZE) {
> >> +                       bitmap <<=3D min - cpu;
> >> +                       min =3D cpu;
> >> +               } else {
> >> +                       /*
> >> +                        * Physical cpuid is sorted in ascending order=
 ascend
> >> +                        * for the next mask calculation, send IPI her=
e
> >> +                        * directly and skip the remainding cpus
> >> +                        */
> >> +                       kvm_hypercall3(KVM_HCALL_FUNC_PV_IPI,
> >> +                               (unsigned long)bitmap,
> >> +                               (unsigned long)(bitmap >> BITS_PER_LON=
G), min);
> >> +                       min =3D max =3D cpu;
> >> +                       bitmap =3D 0;
> >> +               }
> > I have changed the logic and comments when I apply, you can double
> > check whether it is correct.
> There is modification like this:
>                  if (!bitmap) {
>                          min =3D max =3D cpu;
>                  } else if (cpu < min && cpu > (max -
> KVM_IPI_CLUSTER_SIZE)) {
>                         ...
>
> By test there will be problem if value of max is smaller than
> KVM_IPI_CLUSTER_SIZE, since type of cpu/max is "unsigned int".
>
> How about define the variable as int? the patch is like this:
> --- a/arch/loongarch/kernel/paravirt.c
> +++ b/arch/loongarch/kernel/paravirt.c
> @@ -35,7 +35,7 @@ static void pv_send_ipi_single(int cpu, unsigned int
> action)
>
>   static void pv_send_ipi_mask(const struct cpumask *mask, unsigned int
> action)
>   {
> -       unsigned int cpu, i, min =3D 0, max =3D 0, old;
> +       int cpu, i, min =3D 0, max =3D 0, old;
>          __uint128_t bitmap =3D 0;
>          irq_cpustat_t *info;
Make sense, I will update this line.

Huacai

>
>
> Regards
> Bibo Mao
> >
> > Huacai
> >
> >> +               __set_bit(cpu - min, (unsigned long *)&bitmap);
> >> +       }
> >> +
> >> +       if (bitmap)
> >> +               kvm_hypercall3(KVM_HCALL_FUNC_PV_IPI, (unsigned long)b=
itmap,
> >> +                               (unsigned long)(bitmap >> BITS_PER_LON=
G), min);
> >> +}
> >> +
> >> +static irqreturn_t loongson_do_swi(int irq, void *dev)
> >> +{
> >> +       irq_cpustat_t *info;
> >> +       long action;
> >> +
> >> +       /* Clear swi interrupt */
> >> +       clear_csr_estat(1 << INT_SWI0);
> >> +       info =3D this_cpu_ptr(&irq_stat);
> >> +       action =3D atomic_xchg(&info->message, 0);
> >> +       if (action & SMP_CALL_FUNCTION) {
> >> +               generic_smp_call_function_interrupt();
> >> +               info->ipi_irqs[IPI_CALL_FUNCTION]++;
> >> +       }
> >> +
> >> +       if (action & SMP_RESCHEDULE) {
> >> +               scheduler_ipi();
> >> +               info->ipi_irqs[IPI_RESCHEDULE]++;
> >> +       }
> >> +
> >> +       return IRQ_HANDLED;
> >> +}
> >> +
> >> +static void pv_init_ipi(void)
> >> +{
> >> +       int r, swi0;
> >> +
> >> +       swi0 =3D get_percpu_irq(INT_SWI0);
> >> +       if (swi0 < 0)
> >> +               panic("SWI0 IRQ mapping failed\n");
> >> +       irq_set_percpu_devid(swi0);
> >> +       r =3D request_percpu_irq(swi0, loongson_do_swi, "SWI0", &irq_s=
tat);
> >> +       if (r < 0)
> >> +               panic("SWI0 IRQ request failed\n");
> >> +}
> >> +#endif
> >> +
> >> +static bool kvm_para_available(void)
> >> +{
> >> +       static int hypervisor_type;
> >> +       int config;
> >> +
> >> +       if (!hypervisor_type) {
> >> +               config =3D read_cpucfg(CPUCFG_KVM_SIG);
> >> +               if (!memcmp(&config, KVM_SIGNATURE, 4))
> >> +                       hypervisor_type =3D HYPERVISOR_KVM;
> >> +       }
> >> +
> >> +       return hypervisor_type =3D=3D HYPERVISOR_KVM;
> >> +}
> >> +
> >> +int __init pv_ipi_init(void)
> >> +{
> >> +       int feature;
> >> +
> >> +       if (!cpu_has_hypervisor)
> >> +               return 0;
> >> +       if (!kvm_para_available())
> >> +               return 0;
> >> +
> >> +       /*
> >> +        * check whether KVM hypervisor supports pv_ipi or not
> >> +        */
> >> +       feature =3D read_cpucfg(CPUCFG_KVM_FEATURE);
> >> +#ifdef CONFIG_SMP
> >> +       if (feature & KVM_FEATURE_PV_IPI) {
> >> +               smp_ops.init_ipi                =3D pv_init_ipi;
> >> +               smp_ops.send_ipi_single         =3D pv_send_ipi_single=
;
> >> +               smp_ops.send_ipi_mask           =3D pv_send_ipi_mask;
> >> +       }
> >> +#endif
> >> +
> >> +       return 1;
> >> +}
> >> diff --git a/arch/loongarch/kernel/smp.c b/arch/loongarch/kernel/smp.c
> >> index 1fce775be4f6..9eff7aa4c552 100644
> >> --- a/arch/loongarch/kernel/smp.c
> >> +++ b/arch/loongarch/kernel/smp.c
> >> @@ -29,6 +29,7 @@
> >>   #include <asm/loongson.h>
> >>   #include <asm/mmu_context.h>
> >>   #include <asm/numa.h>
> >> +#include <asm/paravirt.h>
> >>   #include <asm/processor.h>
> >>   #include <asm/setup.h>
> >>   #include <asm/time.h>
> >> @@ -309,6 +310,7 @@ void __init loongson_smp_setup(void)
> >>          cpu_data[0].core =3D cpu_logical_map(0) % loongson_sysconf.co=
res_per_package;
> >>          cpu_data[0].package =3D cpu_logical_map(0) / loongson_sysconf=
.cores_per_package;
> >>
> >> +       pv_ipi_init();
> >>          iocsr_write32(0xffffffff, LOONGARCH_IOCSR_IPI_EN);
> >>          pr_info("Detected %i available CPU(s)\n", loongson_sysconf.nr=
_cpus);
> >>   }
> >> @@ -352,7 +354,7 @@ void loongson_boot_secondary(int cpu, struct task_=
struct *idle)
> >>   void loongson_init_secondary(void)
> >>   {
> >>          unsigned int cpu =3D smp_processor_id();
> >> -       unsigned int imask =3D ECFGF_IP0 | ECFGF_IP1 | ECFGF_IP2 |
> >> +       unsigned int imask =3D ECFGF_SIP0 | ECFGF_IP0 | ECFGF_IP1 | EC=
FGF_IP2 |
> >>                               ECFGF_IPI | ECFGF_PMC | ECFGF_TIMER;
> >>
> >>          change_csr_ecfg(ECFG0_IM, imask);
> >> --
> >> 2.39.3
> >>
>
>

