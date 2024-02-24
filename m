Return-Path: <kvm+bounces-9597-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 57B6A8623D2
	for <lists+kvm@lfdr.de>; Sat, 24 Feb 2024 10:19:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D82D61F237B9
	for <lists+kvm@lfdr.de>; Sat, 24 Feb 2024 09:19:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B72141AADF;
	Sat, 24 Feb 2024 09:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TNyprN2b"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D678517580;
	Sat, 24 Feb 2024 09:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708766354; cv=none; b=dcSFB1wfwcDKWPJGLEwNHxJwoDxJBVwo2ndz8F2tsB+sOPptjRYR/mi5n5hZyKqcrGJDgwKbC6XaI8khLGOCLn0ElfkhcEDmYsJ38DQDWlViI5QpMfggoCWeLdxUhF6YY1SbJEoeq/iV0i/papIGzwS78QNAhQeez4LcI+kaflU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708766354; c=relaxed/simple;
	bh=PVkN5ihTHpX2rj9EpKGYP7oFbf3s6iVMohBnjWpwP+4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XGcx6FNCV4TgEuzZqJ9icuIzl7Fpaa3fzytMVxIEYnnlBXESiXk+SIUsxeRjp9rnJ4Q9avEHgC9JpX8N1NMKeVJ+k9+1l5NUyQmrob7CjGys+Tc3eTtChpyp1y8XW8j9E3OkTKfOv/1hrObtdm8Pjy+sScCRC2nb3rrfUH1Bfkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TNyprN2b; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5969CC43399;
	Sat, 24 Feb 2024 09:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708766354;
	bh=PVkN5ihTHpX2rj9EpKGYP7oFbf3s6iVMohBnjWpwP+4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=TNyprN2bEBTkAyGDWHSk2Z/XTbtBjLUf6Gdu3+APJFVLjW9LRS/OU1KDUqoqWv5nP
	 knB2vaWpMudJTChBx8JI9h3XhcB/QyPN+Z8hBd6YkHOOtN5fOaA4NIGGClMFQh75Eg
	 ArCJ1yptiAFWJKz+/TXA2Ge9AhrPDpCgJRZi31CR45zmbXEslQ877pkHJLcZnz8l+0
	 RyVmJMrk4QKWBmlSiGkEg7kyAJmYgCYviPco4GrS2Ghab2pWVIkUuRFdpSGOVDtrQ+
	 jU4dVlqv2hgMrBaET5wQEMr7t8xIiqef9Yh45sEgdTy8EvDsFA5LlWwy5rdVGPEdw6
	 kaqshm4d+JOaA==
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-a3e552eff09so178926966b.3;
        Sat, 24 Feb 2024 01:19:14 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXcVXdXUqS6sI/PHt0X7Ekx9/9eZQtu5hFiB+Y6Hw1KTdRFpDD5bkM6Z2RpWvhRScUgFUcQZiuS8bSDO15t1Pu8zExTp4UyPhuN/wTv6hrGEayTibD53vwgHrdgp3EJXvqs
X-Gm-Message-State: AOJu0YzA6RH/0KuvMLM7I4nZ22pSl78pTTB0a6e0N5KtwIxda4SXu7yy
	7/JuNZxezw5i9XzVCg5bn8UYfkOMlUxJ+CuHyDEwXt29wZyDSWMgdY/Qyke33rpZDUmWH23UfQg
	odEhmJxU2SR9zavPEP9FsWYziIt8=
X-Google-Smtp-Source: AGHT+IEZtYZ09B2Xlv/GZ0eTFIVi5QkT3Hx6PC3tDb7ndg2NYWD85iETjRQsOGjPwB83KgBZRYebUrn1jIWzXf+EpS0=
X-Received: by 2002:a17:906:4c53:b0:a3f:a6c6:25b5 with SMTP id
 d19-20020a1709064c5300b00a3fa6c625b5mr1340604ejw.69.1708766352553; Sat, 24
 Feb 2024 01:19:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240222032803.2177856-1-maobibo@loongson.cn> <20240222032803.2177856-7-maobibo@loongson.cn>
In-Reply-To: <20240222032803.2177856-7-maobibo@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Sat, 24 Feb 2024 17:19:00 +0800
X-Gmail-Original-Message-ID: <CAAhV-H5oZvqbZOOTgkRXqS_TAq0QWbxGtz_YBzHhTGyuhMG2iQ@mail.gmail.com>
Message-ID: <CAAhV-H5oZvqbZOOTgkRXqS_TAq0QWbxGtz_YBzHhTGyuhMG2iQ@mail.gmail.com>
Subject: Re: [PATCH v5 6/6] LoongArch: Add pv ipi support on LoongArch system
To: Bibo Mao <maobibo@loongson.cn>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, Juergen Gross <jgross@suse.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, loongarch@lists.linux.dev, 
	linux-kernel@vger.kernel.org, virtualization@lists.linux.dev, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, Bibo,

On Thu, Feb 22, 2024 at 11:28=E2=80=AFAM Bibo Mao <maobibo@loongson.cn> wro=
te:
>
> On LoongArch system, ipi hw uses iocsr registers, there is one iocsr
> register access on ipi sending, and two iocsr access on ipi receiving
> which is ipi interrupt handler. On VM mode all iocsr accessing will
> cause VM to trap into hypervisor. So with one ipi hw notification
> there will be three times of trap.
>
> PV ipi is added for VM, hypercall instruction is used for ipi sender,
> and hypervisor will inject SWI to destination vcpu. During SWI interrupt
> handler, only estat CSR register is written to clear irq. Estat CSR
> register access will not trap into hypervisor. So with pv ipi supported,
> there is one trap with pv ipi sender, and no trap with ipi receiver,
> there is only one trap with ipi notification.
>
> Also this patch adds ipi multicast support, the method is similar with
> x86. With ipi multicast support, ipi notification can be sent to at most
> 128 vcpus at one time. It reduces trap times into hypervisor greatly.
>
> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> ---
>  arch/loongarch/include/asm/hardirq.h   |   1 +
>  arch/loongarch/include/asm/kvm_host.h  |   1 +
>  arch/loongarch/include/asm/kvm_para.h  | 123 +++++++++++++++++++++++++
>  arch/loongarch/include/asm/loongarch.h |   1 +
>  arch/loongarch/kernel/irq.c            |   2 +-
>  arch/loongarch/kernel/paravirt.c       | 112 ++++++++++++++++++++++
>  arch/loongarch/kernel/setup.c          |   1 +
>  arch/loongarch/kernel/smp.c            |   2 +-
>  arch/loongarch/kvm/exit.c              |  73 ++++++++++++++-
>  arch/loongarch/kvm/vcpu.c              |   1 +
>  10 files changed, 313 insertions(+), 4 deletions(-)
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
> diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/inclu=
de/asm/kvm_host.h
> index 3ba16ef1fe69..0b96c6303cf7 100644
> --- a/arch/loongarch/include/asm/kvm_host.h
> +++ b/arch/loongarch/include/asm/kvm_host.h
> @@ -43,6 +43,7 @@ struct kvm_vcpu_stat {
>         u64 idle_exits;
>         u64 cpucfg_exits;
>         u64 signal_exits;
> +       u64 hypercall_exits;
>  };
>
>  #define KVM_MEM_HUGEPAGE_CAPABLE       (1UL << 0)
> diff --git a/arch/loongarch/include/asm/kvm_para.h b/arch/loongarch/inclu=
de/asm/kvm_para.h
> index af5d677a9052..a82bffbbf8a1 100644
> --- a/arch/loongarch/include/asm/kvm_para.h
> +++ b/arch/loongarch/include/asm/kvm_para.h
> @@ -8,6 +8,9 @@
>  #define HYPERVISOR_KVM                 1
>  #define HYPERVISOR_VENDOR_SHIFT                8
>  #define HYPERCALL_CODE(vendor, code)   ((vendor << HYPERVISOR_VENDOR_SHI=
FT) + code)
> +#define KVM_HCALL_CODE_PV_SERVICE      0
> +#define KVM_HCALL_PV_SERVICE           HYPERCALL_CODE(HYPERVISOR_KVM, KV=
M_HCALL_CODE_PV_SERVICE)
> +#define  KVM_HCALL_FUNC_PV_IPI         1
>
>  /*
>   * LoongArch hypercall return code
> @@ -16,6 +19,126 @@
>  #define KVM_HCALL_INVALID_CODE         -1UL
>  #define KVM_HCALL_INVALID_PARAMETER    -2UL
>
> +/*
> + * Hypercall interface for KVM hypervisor
> + *
> + * a0: function identifier
> + * a1-a6: args
> + * Return value will be placed in v0.
> + * Up to 6 arguments are passed in a1, a2, a3, a4, a5, a6.
> + */
> +static __always_inline long kvm_hypercall(u64 fid)
> +{
> +       register long ret asm("v0");
> +       register unsigned long fun asm("a0") =3D fid;
> +
> +       __asm__ __volatile__(
> +               "hvcl "__stringify(KVM_HCALL_PV_SERVICE)
> +               : "=3Dr" (ret)
> +               : "r" (fun)
> +               : "memory"
> +               );
> +
> +       return ret;
> +}
> +
> +static __always_inline long kvm_hypercall1(u64 fid, unsigned long arg0)
> +{
> +       register long ret asm("v0");
> +       register unsigned long fun asm("a0") =3D fid;
> +       register unsigned long a1  asm("a1") =3D arg0;
> +
> +       __asm__ __volatile__(
> +               "hvcl "__stringify(KVM_HCALL_PV_SERVICE)
> +               : "=3Dr" (ret)
> +               : "r" (fun), "r" (a1)
> +               : "memory"
> +               );
> +
> +       return ret;
> +}
> +
> +static __always_inline long kvm_hypercall2(u64 fid,
> +               unsigned long arg0, unsigned long arg1)
> +{
> +       register long ret asm("v0");
> +       register unsigned long fun asm("a0") =3D fid;
> +       register unsigned long a1  asm("a1") =3D arg0;
> +       register unsigned long a2  asm("a2") =3D arg1;
> +
> +       __asm__ __volatile__(
> +                       "hvcl "__stringify(KVM_HCALL_PV_SERVICE)
> +                       : "=3Dr" (ret)
> +                       : "r" (fun), "r" (a1), "r" (a2)
> +                       : "memory"
> +                       );
> +
> +       return ret;
> +}
> +
> +static __always_inline long kvm_hypercall3(u64 fid,
> +       unsigned long arg0, unsigned long arg1, unsigned long arg2)
> +{
> +       register long ret asm("v0");
> +       register unsigned long fun asm("a0") =3D fid;
> +       register unsigned long a1  asm("a1") =3D arg0;
> +       register unsigned long a2  asm("a2") =3D arg1;
> +       register unsigned long a3  asm("a3") =3D arg2;
> +
> +       __asm__ __volatile__(
> +               "hvcl "__stringify(KVM_HCALL_PV_SERVICE)
> +               : "=3Dr" (ret)
> +               : "r" (fun), "r" (a1), "r" (a2), "r" (a3)
> +               : "memory"
> +               );
> +
> +       return ret;
> +}
> +
> +static __always_inline long kvm_hypercall4(u64 fid,
> +               unsigned long arg0, unsigned long arg1, unsigned long arg=
2,
> +               unsigned long arg3)
> +{
> +       register long ret asm("v0");
> +       register unsigned long fun asm("a0") =3D fid;
> +       register unsigned long a1  asm("a1") =3D arg0;
> +       register unsigned long a2  asm("a2") =3D arg1;
> +       register unsigned long a3  asm("a3") =3D arg2;
> +       register unsigned long a4  asm("a4") =3D arg3;
> +
> +       __asm__ __volatile__(
> +               "hvcl "__stringify(KVM_HCALL_PV_SERVICE)
> +               : "=3Dr" (ret)
> +               : "r"(fun), "r" (a1), "r" (a2), "r" (a3), "r" (a4)
> +               : "memory"
> +               );
> +
> +       return ret;
> +}
> +
> +static __always_inline long kvm_hypercall5(u64 fid,
> +               unsigned long arg0, unsigned long arg1, unsigned long arg=
2,
> +               unsigned long arg3, unsigned long arg4)
> +{
> +       register long ret asm("v0");
> +       register unsigned long fun asm("a0") =3D fid;
> +       register unsigned long a1  asm("a1") =3D arg0;
> +       register unsigned long a2  asm("a2") =3D arg1;
> +       register unsigned long a3  asm("a3") =3D arg2;
> +       register unsigned long a4  asm("a4") =3D arg3;
> +       register unsigned long a5  asm("a5") =3D arg4;
> +
> +       __asm__ __volatile__(
> +               "hvcl "__stringify(KVM_HCALL_PV_SERVICE)
> +               : "=3Dr" (ret)
> +               : "r"(fun), "r" (a1), "r" (a2), "r" (a3), "r" (a4), "r" (=
a5)
> +               : "memory"
> +               );
> +
> +       return ret;
> +}
> +
> +
>  static inline unsigned int kvm_arch_para_features(void)
>  {
>         return 0;
> diff --git a/arch/loongarch/include/asm/loongarch.h b/arch/loongarch/incl=
ude/asm/loongarch.h
> index a1d22e8b6f94..0ad36704cb4b 100644
> --- a/arch/loongarch/include/asm/loongarch.h
> +++ b/arch/loongarch/include/asm/loongarch.h
> @@ -167,6 +167,7 @@
>  #define CPUCFG_KVM_SIG                 CPUCFG_KVM_BASE
>  #define  KVM_SIGNATURE                 "KVM\0"
>  #define CPUCFG_KVM_FEATURE             (CPUCFG_KVM_BASE + 4)
> +#define  KVM_FEATURE_PV_IPI            BIT(1)
>
>  #ifndef __ASSEMBLY__
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
> index 5cf794e8490f..4c30e1c73c72 100644
> --- a/arch/loongarch/kernel/paravirt.c
> +++ b/arch/loongarch/kernel/paravirt.c
> @@ -1,6 +1,7 @@
>  // SPDX-License-Identifier: GPL-2.0
>  #include <linux/export.h>
>  #include <linux/types.h>
> +#include <linux/interrupt.h>
>  #include <linux/jump_label.h>
>  #include <linux/kvm_para.h>
>  #include <asm/paravirt.h>
> @@ -16,6 +17,103 @@ static u64 native_steal_clock(int cpu)
>
>  DEFINE_STATIC_CALL(pv_steal_clock, native_steal_clock);
>
> +#ifdef CONFIG_SMP
> +static void pv_send_ipi_single(int cpu, unsigned int action)
> +{
> +       unsigned int min, old;
> +       unsigned long bitmap =3D 0;
> +       irq_cpustat_t *info =3D &per_cpu(irq_stat, cpu);
> +
> +       action =3D BIT(action);
> +       old =3D atomic_fetch_or(action, &info->message);
> +       if (old =3D=3D 0) {
> +               min =3D cpu_logical_map(cpu);
> +               bitmap =3D 1;
> +               kvm_hypercall3(KVM_HCALL_FUNC_PV_IPI, bitmap, 0, min);
> +       }
Early return style can make it a little easy, which means:

if (old)
   return;

min =3D ......

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
>  static bool kvm_para_available(void)
>  {
>         static int hypervisor_type;
> @@ -32,10 +130,24 @@ static bool kvm_para_available(void)
>
>  int __init pv_ipi_init(void)
>  {
> +       int feature;
> +
>         if (!cpu_has_hypervisor)
>                 return 0;
>         if (!kvm_para_available())
>                 return 0;
>
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
>         return 1;
>  }
> diff --git a/arch/loongarch/kernel/setup.c b/arch/loongarch/kernel/setup.=
c
> index b79a1244b56f..c95ed3224b7d 100644
> --- a/arch/loongarch/kernel/setup.c
> +++ b/arch/loongarch/kernel/setup.c
> @@ -368,6 +368,7 @@ void __init platform_init(void)
>         pr_info("The BIOS Version: %s\n", b_info.bios_version);
>
>         efi_runtime_init();
> +       pv_ipi_init();
Move the callsite to loongson_smp_setup() is better.

Huacai

>  }
>
>  static void __init check_kernel_sections_mem(void)
> diff --git a/arch/loongarch/kernel/smp.c b/arch/loongarch/kernel/smp.c
> index 2182e7cc2ed6..9e9fda1fe18a 100644
> --- a/arch/loongarch/kernel/smp.c
> +++ b/arch/loongarch/kernel/smp.c
> @@ -285,7 +285,7 @@ void loongson_boot_secondary(int cpu, struct task_str=
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
> diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
> index 6a38fd59d86d..46940e97975b 100644
> --- a/arch/loongarch/kvm/exit.c
> +++ b/arch/loongarch/kvm/exit.c
> @@ -227,6 +227,9 @@ static int kvm_emu_cpucfg(struct kvm_vcpu *vcpu, larc=
h_inst inst)
>         case CPUCFG_KVM_SIG:
>                 vcpu->arch.gprs[rd] =3D *(unsigned int *)KVM_SIGNATURE;
>                 break;
> +       case CPUCFG_KVM_FEATURE:
> +               vcpu->arch.gprs[rd] =3D KVM_FEATURE_PV_IPI;
> +               break;
>         default:
>                 vcpu->arch.gprs[rd] =3D 0;
>                 break;
> @@ -699,12 +702,78 @@ static int kvm_handle_lasx_disabled(struct kvm_vcpu=
 *vcpu)
>         return RESUME_GUEST;
>  }
>
> +static int kvm_pv_send_ipi(struct kvm_vcpu *vcpu)
> +{
> +       unsigned long ipi_bitmap;
> +       unsigned int min, cpu, i;
> +       struct kvm_vcpu *dest;
> +
> +       min =3D vcpu->arch.gprs[LOONGARCH_GPR_A3];
> +       for (i =3D 0; i < 2; i++) {
> +               ipi_bitmap =3D vcpu->arch.gprs[LOONGARCH_GPR_A1 + i];
> +               if (!ipi_bitmap)
> +                       continue;
> +
> +               cpu =3D find_first_bit((void *)&ipi_bitmap, BITS_PER_LONG=
);
> +               while (cpu < BITS_PER_LONG) {
> +                       dest =3D kvm_get_vcpu_by_cpuid(vcpu->kvm, cpu + m=
in);
> +                       cpu =3D find_next_bit((void *)&ipi_bitmap, BITS_P=
ER_LONG,
> +                                       cpu + 1);
> +                       if (!dest)
> +                               continue;
> +
> +                       /*
> +                        * Send SWI0 to dest vcpu to emulate IPI interrup=
t
> +                        */
> +                       kvm_queue_irq(dest, INT_SWI0);
> +                       kvm_vcpu_kick(dest);
> +               }
> +       }
> +
> +       return 0;
> +}
> +
> +/*
> + * hypercall emulation always return to guest, Caller should check retva=
l.
> + */
> +static void kvm_handle_pv_service(struct kvm_vcpu *vcpu)
> +{
> +       unsigned long func =3D vcpu->arch.gprs[LOONGARCH_GPR_A0];
> +       long ret;
> +
> +       switch (func) {
> +       case KVM_HCALL_FUNC_PV_IPI:
> +               kvm_pv_send_ipi(vcpu);
> +               ret =3D KVM_HCALL_STATUS_SUCCESS;
> +               break;
> +       default:
> +               ret =3D KVM_HCALL_INVALID_CODE;
> +               break;
> +       };
> +
> +       vcpu->arch.gprs[LOONGARCH_GPR_A0] =3D ret;
> +}
> +
>  static int kvm_handle_hypercall(struct kvm_vcpu *vcpu)
>  {
> +       larch_inst inst;
> +       unsigned int code;
> +
> +       inst.word =3D vcpu->arch.badi;
> +       code =3D inst.reg0i15_format.immediate;
>         update_pc(&vcpu->arch);
>
> -       /* Treat it as noop intruction, only set return value */
> -       vcpu->arch.gprs[LOONGARCH_GPR_A0] =3D KVM_HCALL_INVALID_CODE;
> +       switch (code) {
> +       case KVM_HCALL_PV_SERVICE:
> +               vcpu->stat.hypercall_exits++;
> +               kvm_handle_pv_service(vcpu);
> +               break;
> +       default:
> +               /* Treat it as noop intruction, only set return value */
> +               vcpu->arch.gprs[LOONGARCH_GPR_A0] =3D KVM_HCALL_INVALID_C=
ODE;
> +               break;
> +       }
> +
>         return RESUME_GUEST;
>  }
>
> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
> index 40296d8ef297..24fd5e4647f3 100644
> --- a/arch/loongarch/kvm/vcpu.c
> +++ b/arch/loongarch/kvm/vcpu.c
> @@ -19,6 +19,7 @@ const struct _kvm_stats_desc kvm_vcpu_stats_desc[] =3D =
{
>         STATS_DESC_COUNTER(VCPU, idle_exits),
>         STATS_DESC_COUNTER(VCPU, cpucfg_exits),
>         STATS_DESC_COUNTER(VCPU, signal_exits),
> +       STATS_DESC_COUNTER(VCPU, hypercall_exits)
>  };
>
>  const struct kvm_stats_header kvm_vcpu_stats_header =3D {
> --
> 2.39.3
>
>

