Return-Path: <kvm+bounces-9011-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A127859CAA
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 08:16:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D47B428399D
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 07:16:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B50B208D4;
	Mon, 19 Feb 2024 07:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DbifTIYz"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6340E20334;
	Mon, 19 Feb 2024 07:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708326986; cv=none; b=l/GAZwqBcpYxHUGlf2XItIRekt85f+w38lK7xYc9BCE/fLprUwmVprNbHOje9fwbzZim5kvmNGVG2rIImP4jK+1lH6ZucXkG7PtZ/LEqyGOoEXC2pdp+Ab6S+ECqxZPanA9//GH3QvCUOyy7SDOVgGR89pqDk8mtz9k+Xleowfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708326986; c=relaxed/simple;
	bh=OIDcdjtctx7V3pWoKE1zXJjTWpv9x5k0QmfqbThP9js=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LgHIeoCDQH7DBRKxNJC8s0rNRXsNzClqwUGlKDlW5MV4PCofLljTd1ELb+mZr4R6IGgA+w9ekmFynsqGeX62OP1uGYbI6BrH7e/A+QeFPKohuWcwxW4VyFOlJZlrCgqzY365JD5niAsKDWVxeztyR+ePYbeWe2W6f7aRX7ANlws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DbifTIYz; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9F4BC43390;
	Mon, 19 Feb 2024 07:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708326986;
	bh=OIDcdjtctx7V3pWoKE1zXJjTWpv9x5k0QmfqbThP9js=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=DbifTIYzsayqE2/yPPyxaGewJ4CRtrwTev003J1I4WMgp7PCn1+gw0Y6b8qyXyjlT
	 2Cr1Ktu/dWoej6XatYxyedwweKStwDCx11M4wXdbaFiAW5N8TgvHpnA/I/hA6xOIIk
	 mRa54TnVRpwABVCB9De0xVDfN/8mpsL+3MLN4ZEVukNhX44QMZxyD+KJBn1S6vlfIC
	 LLHymLtit2+RcGZA96VoD5dowuY+xR90BUZVY2wIPguz5ZGv+ntuOst5KylkFlLVKr
	 ykT1l9ggmnMk/4mpaJ3uBNbk5qVZFmhfUf0qM5xLSrTKo/bA9Kx5Ym7cVpisnvv1sN
	 buBz3AHbOD9JQ==
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-563d32ee33aso3647145a12.2;
        Sun, 18 Feb 2024 23:16:25 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXNb01VY6Mg8G+D3Rl859Zbe0d24Sqoc5Go1duU1FWHAPj9cuiznnQ7g2fsvtwFFuB5wXiuIdiMgF3+yer+cHx0Aa/ND6wINA3GMPiUwOToPLxhEvesYOUgI3PKR+QJ8RdO
X-Gm-Message-State: AOJu0Yzh5qVWMna6ekzgmnH7/2WB48kK5UYZl/AGlp+U2qFg6U1GbnfR
	NPXqcl4gh6a1lfHRy/B1jIJkvZS0msGJAoc2+W0nFsNePrFPX/xA5kDlc7TEqcjqexibmM2vUZk
	PWJfFgsgJvgaoVYu7pzMPHvC64PA=
X-Google-Smtp-Source: AGHT+IGclVKfurnE1QgvEIoNeQjzULHW8U1P+EGsrP5RUEO0W5nxObUn9F2PAM4iXBigJvLmikaTRWINn0L/+Z+3eZM=
X-Received: by 2002:a05:6402:5165:b0:564:7a2c:ea55 with SMTP id
 d5-20020a056402516500b005647a2cea55mr797412ede.42.1708326984234; Sun, 18 Feb
 2024 23:16:24 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240201031950.3225626-1-maobibo@loongson.cn> <20240201031950.3225626-7-maobibo@loongson.cn>
 <CAAhV-H6RTUWF9cUwCGhLxfaeSqAp+a4uw8fy8brGT9LumU5tdA@mail.gmail.com> <a52a9cfe-0c8a-dd10-2d5c-eb2817deb3da@loongson.cn>
In-Reply-To: <a52a9cfe-0c8a-dd10-2d5c-eb2817deb3da@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Mon, 19 Feb 2024 15:16:22 +0800
X-Gmail-Original-Message-ID: <CAAhV-H4gq=dpvkpRGEa--MtQ3-bAXgehvWQxK3jQOwZEU1Gtag@mail.gmail.com>
Message-ID: <CAAhV-H4gq=dpvkpRGEa--MtQ3-bAXgehvWQxK3jQOwZEU1Gtag@mail.gmail.com>
Subject: Re: [PATCH v4 6/6] LoongArch: Add pv ipi support on LoongArch system
To: maobibo <maobibo@loongson.cn>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, Juergen Gross <jgross@suse.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, loongarch@lists.linux.dev, 
	linux-kernel@vger.kernel.org, virtualization@lists.linux.dev, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 19, 2024 at 12:18=E2=80=AFPM maobibo <maobibo@loongson.cn> wrot=
e:
>
>
>
> On 2024/2/19 =E4=B8=8A=E5=8D=8810:45, Huacai Chen wrote:
> > Hi, Bibo,
> >
> > On Thu, Feb 1, 2024 at 11:20=E2=80=AFAM Bibo Mao <maobibo@loongson.cn> =
wrote:
> >>
> >> On LoongArch system, ipi hw uses iocsr registers, there is one iocsr
> >> register access on ipi sending, and two iocsr access on ipi receiving
> >> which is ipi interrupt handler. On VM mode all iocsr registers
> >> accessing will cause VM to trap into hypervisor. So with ipi hw
> >> notification once there will be three times of trap.
> >>
> >> This patch adds pv ipi support for VM, hypercall instruction is used
> >> to ipi sender, and hypervisor will inject SWI on the VM. During SWI
> >> interrupt handler, only estat CSR register is written to clear irq.
> >> Estat CSR register access will not trap into hypervisor. So with pv ip=
i
> >> supported, pv ipi sender will trap into hypervsor one time, pv ipi
> >> revicer will not trap, there is only one time of trap.
> >>
> >> Also this patch adds ipi multicast support, the method is similar with
> >> x86. With ipi multicast support, ipi notification can be sent to at mo=
st
> >> 128 vcpus at one time. It reduces trap times into hypervisor greatly.
> >>
> >> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> >> ---
> >>   arch/loongarch/include/asm/hardirq.h   |   1 +
> >>   arch/loongarch/include/asm/kvm_host.h  |   1 +
> >>   arch/loongarch/include/asm/kvm_para.h  | 124 +++++++++++++++++++++++=
++
> >>   arch/loongarch/include/asm/loongarch.h |   1 +
> >>   arch/loongarch/kernel/irq.c            |   2 +-
> >>   arch/loongarch/kernel/paravirt.c       | 113 ++++++++++++++++++++++
> >>   arch/loongarch/kernel/smp.c            |   2 +-
> >>   arch/loongarch/kvm/exit.c              |  73 ++++++++++++++-
> >>   arch/loongarch/kvm/vcpu.c              |   1 +
> >>   9 files changed, 314 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/arch/loongarch/include/asm/hardirq.h b/arch/loongarch/inc=
lude/asm/hardirq.h
> >> index 9f0038e19c7f..8a611843c1f0 100644
> >> --- a/arch/loongarch/include/asm/hardirq.h
> >> +++ b/arch/loongarch/include/asm/hardirq.h
> >> @@ -21,6 +21,7 @@ enum ipi_msg_type {
> >>   typedef struct {
> >>          unsigned int ipi_irqs[NR_IPI];
> >>          unsigned int __softirq_pending;
> >> +       atomic_t messages ____cacheline_aligned_in_smp;
> > Do we really need atomic_t? A plain "unsigned int" can reduce cost
> > significantly.
> For IPI, there are multiple senders and one receiver, the sender uses
> atomic_fetch_or(action, &info->messages) and the receiver uses
> atomic_xchg(&info->messages, 0) to clear message.
>
> There needs sync mechanism between senders and receiver, atomic is the
> most simple method.
At least from receiver side, the native IPI doesn't need atomic for
read and clear:
static u32 ipi_read_clear(int cpu)
{
        u32 action;

        /* Load the ipi register to figure out what we're supposed to do */
        action =3D iocsr_read32(LOONGARCH_IOCSR_IPI_STATUS);
        /* Clear the ipi register to clear the interrupt */
        iocsr_write32(action, LOONGARCH_IOCSR_IPI_CLEAR);
        wbflush();

        return action;
}

> >
> >>   } ____cacheline_aligned irq_cpustat_t;
> >>
> >>   DECLARE_PER_CPU_SHARED_ALIGNED(irq_cpustat_t, irq_stat);
> >> diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/in=
clude/asm/kvm_host.h
> >> index 57399d7cf8b7..1bf927e2bfac 100644
> >> --- a/arch/loongarch/include/asm/kvm_host.h
> >> +++ b/arch/loongarch/include/asm/kvm_host.h
> >> @@ -43,6 +43,7 @@ struct kvm_vcpu_stat {
> >>          u64 idle_exits;
> >>          u64 cpucfg_exits;
> >>          u64 signal_exits;
> >> +       u64 hvcl_exits;
> > hypercall_exits is better.
> yeap, hypercall_exits is better, will fix in next version.
> >
> >>   };
> >>
> >>   #define KVM_MEM_HUGEPAGE_CAPABLE       (1UL << 0)
> >> diff --git a/arch/loongarch/include/asm/kvm_para.h b/arch/loongarch/in=
clude/asm/kvm_para.h
> >> index 41200e922a82..a25a84e372b9 100644
> >> --- a/arch/loongarch/include/asm/kvm_para.h
> >> +++ b/arch/loongarch/include/asm/kvm_para.h
> >> @@ -9,6 +9,10 @@
> >>   #define HYPERVISOR_VENDOR_SHIFT                8
> >>   #define HYPERCALL_CODE(vendor, code)   ((vendor << HYPERVISOR_VENDOR=
_SHIFT) + code)
> >>
> >> +#define KVM_HC_CODE_SERVICE            0
> >> +#define KVM_HC_SERVICE                 HYPERCALL_CODE(HYPERVISOR_KVM,=
 KVM_HC_CODE_SERVICE)
> >> +#define  KVM_HC_FUNC_IPI               1
> > Change HC to HCALL is better.
> will modify in next version.
> >
> >> +
> >>   /*
> >>    * LoongArch hypcall return code
> >>    */
> >> @@ -16,6 +20,126 @@
> >>   #define KVM_HC_INVALID_CODE            -1UL
> >>   #define KVM_HC_INVALID_PARAMETER       -2UL
> >>
> >> +/*
> >> + * Hypercalls interface for KVM hypervisor
> >> + *
> >> + * a0: function identifier
> >> + * a1-a6: args
> >> + * Return value will be placed in v0.
> >> + * Up to 6 arguments are passed in a1, a2, a3, a4, a5, a6.
> >> + */
> >> +static __always_inline long kvm_hypercall(u64 fid)
> >> +{
> >> +       register long ret asm("v0");
> >> +       register unsigned long fun asm("a0") =3D fid;
> >> +
> >> +       __asm__ __volatile__(
> >> +               "hvcl "__stringify(KVM_HC_SERVICE)
> >> +               : "=3Dr" (ret)
> >> +               : "r" (fun)
> >> +               : "memory"
> >> +               );
> >> +
> >> +       return ret;
> >> +}
> >> +
> >> +static __always_inline long kvm_hypercall1(u64 fid, unsigned long arg=
0)
> >> +{
> >> +       register long ret asm("v0");
> >> +       register unsigned long fun asm("a0") =3D fid;
> >> +       register unsigned long a1  asm("a1") =3D arg0;
> >> +
> >> +       __asm__ __volatile__(
> >> +               "hvcl "__stringify(KVM_HC_SERVICE)
> >> +               : "=3Dr" (ret)
> >> +               : "r" (fun), "r" (a1)
> >> +               : "memory"
> >> +               );
> >> +
> >> +       return ret;
> >> +}
> >> +
> >> +static __always_inline long kvm_hypercall2(u64 fid,
> >> +               unsigned long arg0, unsigned long arg1)
> >> +{
> >> +       register long ret asm("v0");
> >> +       register unsigned long fun asm("a0") =3D fid;
> >> +       register unsigned long a1  asm("a1") =3D arg0;
> >> +       register unsigned long a2  asm("a2") =3D arg1;
> >> +
> >> +       __asm__ __volatile__(
> >> +                       "hvcl "__stringify(KVM_HC_SERVICE)
> >> +                       : "=3Dr" (ret)
> >> +                       : "r" (fun), "r" (a1), "r" (a2)
> >> +                       : "memory"
> >> +                       );
> >> +
> >> +       return ret;
> >> +}
> >> +
> >> +static __always_inline long kvm_hypercall3(u64 fid,
> >> +       unsigned long arg0, unsigned long arg1, unsigned long arg2)
> >> +{
> >> +       register long ret asm("v0");
> >> +       register unsigned long fun asm("a0") =3D fid;
> >> +       register unsigned long a1  asm("a1") =3D arg0;
> >> +       register unsigned long a2  asm("a2") =3D arg1;
> >> +       register unsigned long a3  asm("a3") =3D arg2;
> >> +
> >> +       __asm__ __volatile__(
> >> +               "hvcl "__stringify(KVM_HC_SERVICE)
> >> +               : "=3Dr" (ret)
> >> +               : "r" (fun), "r" (a1), "r" (a2), "r" (a3)
> >> +               : "memory"
> >> +               );
> >> +
> >> +       return ret;
> >> +}
> >> +
> >> +static __always_inline long kvm_hypercall4(u64 fid,
> >> +               unsigned long arg0, unsigned long arg1, unsigned long =
arg2,
> >> +               unsigned long arg3)
> >> +{
> >> +       register long ret asm("v0");
> >> +       register unsigned long fun asm("a0") =3D fid;
> >> +       register unsigned long a1  asm("a1") =3D arg0;
> >> +       register unsigned long a2  asm("a2") =3D arg1;
> >> +       register unsigned long a3  asm("a3") =3D arg2;
> >> +       register unsigned long a4  asm("a4") =3D arg3;
> >> +
> >> +       __asm__ __volatile__(
> >> +               "hvcl "__stringify(KVM_HC_SERVICE)
> >> +               : "=3Dr" (ret)
> >> +               : "r"(fun), "r" (a1), "r" (a2), "r" (a3), "r" (a4)
> >> +               : "memory"
> >> +               );
> >> +
> >> +       return ret;
> >> +}
> >> +
> >> +static __always_inline long kvm_hypercall5(u64 fid,
> >> +               unsigned long arg0, unsigned long arg1, unsigned long =
arg2,
> >> +               unsigned long arg3, unsigned long arg4)
> >> +{
> >> +       register long ret asm("v0");
> >> +       register unsigned long fun asm("a0") =3D fid;
> >> +       register unsigned long a1  asm("a1") =3D arg0;
> >> +       register unsigned long a2  asm("a2") =3D arg1;
> >> +       register unsigned long a3  asm("a3") =3D arg2;
> >> +       register unsigned long a4  asm("a4") =3D arg3;
> >> +       register unsigned long a5  asm("a5") =3D arg4;
> >> +
> >> +       __asm__ __volatile__(
> >> +               "hvcl "__stringify(KVM_HC_SERVICE)
> >> +               : "=3Dr" (ret)
> >> +               : "r"(fun), "r" (a1), "r" (a2), "r" (a3), "r" (a4), "r=
" (a5)
> >> +               : "memory"
> >> +               );
> >> +
> >> +       return ret;
> >> +}
> >> +
> >> +
> >>   static inline unsigned int kvm_arch_para_features(void)
> >>   {
> >>          return 0;
> >> diff --git a/arch/loongarch/include/asm/loongarch.h b/arch/loongarch/i=
nclude/asm/loongarch.h
> >> index a1d22e8b6f94..0ad36704cb4b 100644
> >> --- a/arch/loongarch/include/asm/loongarch.h
> >> +++ b/arch/loongarch/include/asm/loongarch.h
> >> @@ -167,6 +167,7 @@
> >>   #define CPUCFG_KVM_SIG                 CPUCFG_KVM_BASE
> >>   #define  KVM_SIGNATURE                 "KVM\0"
> >>   #define CPUCFG_KVM_FEATURE             (CPUCFG_KVM_BASE + 4)
> >> +#define  KVM_FEATURE_PV_IPI            BIT(1)
> >>
> >>   #ifndef __ASSEMBLY__
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
> >> index 21d01d05791a..7a8319df401c 100644
> >> --- a/arch/loongarch/kernel/paravirt.c
> >> +++ b/arch/loongarch/kernel/paravirt.c
> >> @@ -1,6 +1,7 @@
> >>   // SPDX-License-Identifier: GPL-2.0
> >>   #include <linux/export.h>
> >>   #include <linux/types.h>
> >> +#include <linux/interrupt.h>
> >>   #include <linux/jump_label.h>
> >>   #include <linux/kvm_para.h>
> >>   #include <asm/paravirt.h>
> >> @@ -16,6 +17,104 @@ static u64 native_steal_clock(int cpu)
> >>
> >>   DEFINE_STATIC_CALL(pv_steal_clock, native_steal_clock);
> >>
> >> +#ifdef CONFIG_SMP
> >> +static void pv_send_ipi_single(int cpu, unsigned int action)
> >> +{
> >> +       unsigned int min, old;
> >> +       unsigned long bitmap =3D 0;
> >> +       irq_cpustat_t *info =3D &per_cpu(irq_stat, cpu);
> >> +
> >> +       action =3D BIT(action);
> >> +       old =3D atomic_fetch_or(action, &info->messages);
> >> +       if (old =3D=3D 0) {
> >> +               min =3D cpu_logical_map(cpu);
> >> +               bitmap =3D 1;
> >> +               kvm_hypercall3(KVM_HC_FUNC_IPI, bitmap, 0, min);
> >> +       }
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
> >> +               old =3D atomic_fetch_or(action, &info->messages);
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
> >> +                       kvm_hypercall3(KVM_HC_FUNC_IPI, (unsigned long=
)bitmap,
> >> +                               (unsigned long)(bitmap >> BITS_PER_LON=
G), min);
> >> +                       min =3D max =3D cpu;
> >> +                       bitmap =3D 0;
> >> +               }
> >> +               __set_bit(cpu - min, (unsigned long *)&bitmap);
> >> +       }
> >> +
> >> +       if (bitmap)
> >> +               kvm_hypercall3(KVM_HC_FUNC_IPI, (unsigned long)bitmap,
> >> +                               (unsigned long)(bitmap >> BITS_PER_LON=
G), min);
> >> +}
> >> +
> >> +static irqreturn_t loongson_do_swi(int irq, void *dev)
> >> +{
> >> +       irq_cpustat_t *info;
> >> +       long action;
> >> +
> >> +       clear_csr_estat(1 << INT_SWI0);
> >> +
> >> +       info =3D this_cpu_ptr(&irq_stat);
> >> +       do {
> >> +               action =3D atomic_xchg(&info->messages, 0);
> >> +               if (action & SMP_CALL_FUNCTION) {
> >> +                       generic_smp_call_function_interrupt();
> >> +                       info->ipi_irqs[IPI_CALL_FUNCTION]++;
> >> +               }
> >> +
> >> +               if (action & SMP_RESCHEDULE) {
> >> +                       scheduler_ipi();
> >> +                       info->ipi_irqs[IPI_RESCHEDULE]++;
> >> +               }
> >> +       } while (action);
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
> >>   static bool kvm_para_available(void)
> >>   {
> >>          static int hypervisor_type;
> >> @@ -32,10 +131,24 @@ static bool kvm_para_available(void)
> >>
> >>   int __init pv_guest_init(void)
> >>   {
> >> +       int feature;
> >> +
> >>          if (!cpu_has_hypervisor)
> >>                  return 0;
> >>          if (!kvm_para_available())
> >>                  return 0;
> >>
> >> +       /*
> >> +        * check whether KVM hypervisor supports pv_ipi or not
> >> +        */
> >> +#ifdef CONFIG_SMP
> >> +       feature =3D read_cpucfg(CPUCFG_KVM_FEATURE);
> > This line can be moved out of CONFIG_SMP, especially features will
> > increase in future.
> Good suggestion, will modify in next version.
>
> Regards
> Bibo Mao
> >
> > Huacai
> >
> >> +       if (feature & KVM_FEATURE_PV_IPI) {
> >> +               smp_ops.init_ipi                =3D pv_init_ipi;
> >> +               smp_ops.send_ipi_single         =3D pv_send_ipi_single=
;
> >> +               smp_ops.send_ipi_mask           =3D pv_send_ipi_mask;
> >> +       }
> >> +#endif
> >> +
> >>          return 1;
> >>   }
> >> diff --git a/arch/loongarch/kernel/smp.c b/arch/loongarch/kernel/smp.c
> >> index 3d3ec07d1ec4..d50443879353 100644
> >> --- a/arch/loongarch/kernel/smp.c
> >> +++ b/arch/loongarch/kernel/smp.c
> >> @@ -285,7 +285,7 @@ void loongson_boot_secondary(int cpu, struct task_=
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
> >> diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
> >> index f4e4df05f578..189b70bad825 100644
> >> --- a/arch/loongarch/kvm/exit.c
> >> +++ b/arch/loongarch/kvm/exit.c
> >> @@ -227,6 +227,9 @@ static int kvm_emu_cpucfg(struct kvm_vcpu *vcpu, l=
arch_inst inst)
> >>          case CPUCFG_KVM_SIG:
> >>                  vcpu->arch.gprs[rd] =3D *(unsigned int *)KVM_SIGNATUR=
E;
> >>                  break;
> >> +       case CPUCFG_KVM_FEATURE:
> >> +               vcpu->arch.gprs[rd] =3D KVM_FEATURE_PV_IPI;
> >> +               break;
> >>          default:
> >>                  vcpu->arch.gprs[rd] =3D 0;
> >>                  break;
> >> @@ -699,12 +702,78 @@ static int kvm_handle_lasx_disabled(struct kvm_v=
cpu *vcpu)
> >>          return RESUME_GUEST;
> >>   }
> >>
> >> +static int kvm_pv_send_ipi(struct kvm_vcpu *vcpu)
> >> +{
> >> +       unsigned long ipi_bitmap;
> >> +       unsigned int min, cpu, i;
> >> +       struct kvm_vcpu *dest;
> >> +
> >> +       min =3D vcpu->arch.gprs[LOONGARCH_GPR_A3];
> >> +       for (i =3D 0; i < 2; i++) {
> >> +               ipi_bitmap =3D vcpu->arch.gprs[LOONGARCH_GPR_A1 + i];
> >> +               if (!ipi_bitmap)
> >> +                       continue;
> >> +
> >> +               cpu =3D find_first_bit((void *)&ipi_bitmap, BITS_PER_L=
ONG);
> >> +               while (cpu < BITS_PER_LONG) {
> >> +                       dest =3D kvm_get_vcpu_by_cpuid(vcpu->kvm, cpu =
+ min);
> >> +                       cpu =3D find_next_bit((void *)&ipi_bitmap, BIT=
S_PER_LONG,
> >> +                                               cpu + 1);
> >> +                       if (!dest)
> >> +                               continue;
> >> +
> >> +                       /*
> >> +                        * Send SWI0 to dest vcpu to emulate IPI inter=
rupt
> >> +                        */
> >> +                       kvm_queue_irq(dest, INT_SWI0);
> >> +                       kvm_vcpu_kick(dest);
> >> +               }
> >> +       }
> >> +
> >> +       return 0;
> >> +}
> >> +
> >> +/*
> >> + * hypcall emulation always return to guest, Caller should check retv=
al.
> >> + */
> >> +static void kvm_handle_pv_hcall(struct kvm_vcpu *vcpu)
> > Rename to kvm_handle_hypecall_service() is better.
> >
> >
> > Huacai
> >> +{
> >> +       unsigned long func =3D vcpu->arch.gprs[LOONGARCH_GPR_A0];
> >> +       long ret;
> >> +
> >> +       switch (func) {
> >> +       case KVM_HC_FUNC_IPI:
> >> +               kvm_pv_send_ipi(vcpu);
> >> +               ret =3D KVM_HC_STATUS_SUCCESS;
> >> +               break;
> >> +       default:
> >> +               ret =3D KVM_HC_INVALID_CODE;
> >> +               break;
> >> +       };
> >> +
> >> +       vcpu->arch.gprs[LOONGARCH_GPR_A0] =3D ret;
> >> +}
> >> +
> >>   static int kvm_handle_hypcall(struct kvm_vcpu *vcpu)
> >>   {
> >> +       larch_inst inst;
> >> +       unsigned int code;
> >> +
> >> +       inst.word =3D vcpu->arch.badi;
> >> +       code =3D inst.reg0i15_format.immediate;
> >>          update_pc(&vcpu->arch);
> >>
> >> -       /* Treat it as noop intruction, only set return value */
> >> -       vcpu->arch.gprs[LOONGARCH_GPR_A0] =3D KVM_HC_INVALID_CODE;
> >> +       switch (code) {
> >> +       case KVM_HC_SERVICE:
> >> +               vcpu->stat.hvcl_exits++;
> >> +               kvm_handle_pv_hcall(vcpu);
> >> +               break;
> >> +       default:
> >> +               /* Treat it as noop intruction, only set return value =
*/
> >> +               vcpu->arch.gprs[LOONGARCH_GPR_A0] =3D KVM_HC_INVALID_C=
ODE;
> >> +               break;
> >> +       }
> >> +
> >>          return RESUME_GUEST;
> >>   }
> >>
> >> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
> >> index 97ca9c7160e6..80e05ba9b48d 100644
> >> --- a/arch/loongarch/kvm/vcpu.c
> >> +++ b/arch/loongarch/kvm/vcpu.c
> >> @@ -19,6 +19,7 @@ const struct _kvm_stats_desc kvm_vcpu_stats_desc[] =
=3D {
> >>          STATS_DESC_COUNTER(VCPU, idle_exits),
> >>          STATS_DESC_COUNTER(VCPU, cpucfg_exits),
> >>          STATS_DESC_COUNTER(VCPU, signal_exits),
> >> +       STATS_DESC_COUNTER(VCPU, hvcl_exits)
> >>   };
> >>
> >>   const struct kvm_stats_header kvm_vcpu_stats_header =3D {
> >> --
> >> 2.39.3
> >>
>

