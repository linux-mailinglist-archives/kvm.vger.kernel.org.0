Return-Path: <kvm+bounces-21073-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 70CDC92979B
	for <lists+kvm@lfdr.de>; Sun,  7 Jul 2024 13:25:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CA448B21052
	for <lists+kvm@lfdr.de>; Sun,  7 Jul 2024 11:25:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A3AF1C683;
	Sun,  7 Jul 2024 11:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="co3r3NGJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF699139B
	for <kvm@vger.kernel.org>; Sun,  7 Jul 2024 11:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720351518; cv=none; b=bf40cp8mpXYTSv7ytYYYwYavZUepYKZPSY0vsJXekuA+kA+9CqzOg2xawHY0o94U3/xHud9ju3jGc5OCchYBC9sa71Zk7Bikwf9liBiJYpnEoJFvrSpsbSDBinFTpeTbydP3mi8NCNlQM35FuoN4gQHRDxrBAv7rc9a/BwOOrYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720351518; c=relaxed/simple;
	bh=U4kSY09uXzdy0DdFNzq2ThlNgfJ7hGq+CNnKPHP4fy8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mWFUGqz2I9qbvTfoYT072kdUgP3f+yKE3IILfmvMG4CElmQIa72h1cyIJ1B5OnRvb4HtFSRaYV1du4Ezs3oXIj6Hf6i+nF37e3uu2zzZNgZ8dj0BeGi4wz1CDEfHGb7yHwT1G7vmqMU5mfdsC70QAgrR0vUKHJJXE5UaBBp2nMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=co3r3NGJ; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-58bac81f419so4041974a12.0
        for <kvm@vger.kernel.org>; Sun, 07 Jul 2024 04:25:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720351515; x=1720956315; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k/BbuMis3Oztjer9ryHdhJl9hC2n08QbCqUSuVprZSY=;
        b=co3r3NGJfw1W0gIvfyly/AjGZgQ8bUS1FkCqKppaIGILBsfiI1jnXZEeOvNCu8Wf34
         RYZRc2jfS7gBJj3mKrLqCbxgKo0qVWauqd2dFEvD0c1pv1dDrvOAwwYVa43au7rvDxcR
         z4EdKe/C10mb8Qw17a1dt5HdRDu6hN99ilzqH7NyGA3HlPd1ugPmENMJJP0E0ASeCpLL
         RjJPoGjXDh/4Y6cKD50qcL2RMTrwsYrN9+2G1mPVfZ5kvxymEZZj4IcqFDR7LcTJqB/z
         NEf3m/6dLtK/ftrs9GQJsWZ48zLNFnujsupKgkDg9J7SSCIDIeAiXRjj3Aj1uOtONrih
         tkMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720351515; x=1720956315;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k/BbuMis3Oztjer9ryHdhJl9hC2n08QbCqUSuVprZSY=;
        b=t2hjpx2timvcsK0pT2GootsgBUWyXqNLceMd8mGKOv5jlqEYFwsHjwfoemApvsRPb5
         MN6XpaQg9PvUKmwa8pSw1UawMhIsM6mIVlWi4MlOtgHc2OSGAfzVlTHrscWPtwRJx5rP
         0iamuRTJd43w2sladnSi9swHRGhbJcUZEkD41G6ULzAKybMcDyQ5D17jRoJLnl406nwQ
         XrFkRCbNelpDZUjPlLxfl4K50G7KueJroXyrJafdinl0gryBq+exMZewA8hN60jbQT9j
         3/x5NzrWNXwTSKItC/J3833bx+/+Vk8yPAf3/SOSh8Ox6JMrHl/bksKnuxvuWZENXeE9
         GMQA==
X-Gm-Message-State: AOJu0YxytI3pGcBc9SN4EN8f0iAq9Z8+I2SAPVOVlXHswG50T1EQTmKU
	24Hyvm9xfQK/sYumNu3wvjZVEm2d+AZmyWGG+p1swqXFEz0l4yRh+y3xE3tWsGPD5N4sN3Sf1lT
	k5JmjBcvLjT85BNEP5bp1UySLxet+PPMB9cc=
X-Google-Smtp-Source: AGHT+IH6wQwfrtECK8z+9OjGFVrXWwrT55xcq57Z7y0ndYM/92xP2g203gf7TCX9pZ4B2nM0oDnx/aGu4i/gMYvxRGU=
X-Received: by 2002:a05:6402:4301:b0:58f:4420:8167 with SMTP id
 4fb4d7f45d1cf-58f44208399mr4922598a12.14.1720351514326; Sun, 07 Jul 2024
 04:25:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240707101053.74386-1-jamestiotio@gmail.com> <20240707101053.74386-4-jamestiotio@gmail.com>
In-Reply-To: <20240707101053.74386-4-jamestiotio@gmail.com>
From: James R T <jamestiotio@gmail.com>
Date: Sun, 7 Jul 2024 19:24:36 +0800
Message-ID: <CAA_Li+vEZhHpuGNqJ9MF96iqcubrUgHw4Hmnv3UpHf4EkkJ8HQ@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v2 3/3] riscv: sbi: Add test for timer extension
To: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Cc: andrew.jones@linux.dev, atishp@rivosinc.com, cade.richard@berkeley.edu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jul 7, 2024 at 6:11=E2=80=AFPM James Raphael Tiovalen
<jamestiotio@gmail.com> wrote:
>
> Add a test for the set_timer function of the time extension. The test
> checks that:
> - The time extension is available
> - The time counter monotonically increases
> - The installed timer interrupt handler is called
> - The timer interrupt is received within a reasonable time interval
> - The timer interrupt pending bit is cleared after the set_timer SBI
>   call is made
> - The timer interrupt can be cleared either by requesting a timer
>   interrupt infinitely far into the future or by masking the timer
>   interrupt
>
> The timer interrupt delay can be set using the TIMER_DELAY environment
> variable in microseconds. The default delay value is 1 second. Since the
> interrupt can arrive a little later than the specified delay, allow some
> margin of error. This margin of error can be specified via the
> TIMER_MARGIN environment variable in microseconds. The default margin of
> error is 1 second.
>
> This test has been verified on RV32 and RV64 with OpenSBI using QEMU.
>
> Signed-off-by: James Raphael Tiovalen <jamestiotio@gmail.com>
> ---
>  lib/riscv/asm/csr.h   |   7 +++
>  lib/riscv/asm/sbi.h   |   5 ++
>  lib/riscv/asm/setup.h |   1 +
>  lib/riscv/asm/timer.h |  30 ++++++++++++
>  lib/riscv/processor.c |   6 +++
>  lib/riscv/setup.c     |  24 ++++++++++
>  riscv/sbi.c           | 108 ++++++++++++++++++++++++++++++++++++++++++
>  7 files changed, 181 insertions(+)
>  create mode 100644 lib/riscv/asm/timer.h
>
> diff --git a/lib/riscv/asm/csr.h b/lib/riscv/asm/csr.h
> index b3c48e8e..dc05bfc9 100644
> --- a/lib/riscv/asm/csr.h
> +++ b/lib/riscv/asm/csr.h
> @@ -4,12 +4,15 @@
>  #include <linux/const.h>
>
>  #define CSR_SSTATUS            0x100
> +#define CSR_SIE                        0x104
>  #define CSR_STVEC              0x105
>  #define CSR_SSCRATCH           0x140
>  #define CSR_SEPC               0x141
>  #define CSR_SCAUSE             0x142
>  #define CSR_STVAL              0x143
> +#define CSR_SIP                        0x144
>  #define CSR_SATP               0x180
> +#define CSR_TIME               0xc01
>
>  #define SR_SIE                 _AC(0x00000002, UL)
>
> @@ -50,6 +53,10 @@
>  #define IRQ_S_GEXT             12
>  #define IRQ_PMU_OVF            13
>
> +#define IE_TIE                 (_AC(0x1, UL) << IRQ_S_TIMER)
> +
> +#define IP_TIP                 IE_TIE
> +
>  #ifndef __ASSEMBLY__
>
>  #define csr_swap(csr, val)                                     \
> diff --git a/lib/riscv/asm/sbi.h b/lib/riscv/asm/sbi.h
> index d82a384d..84ce1bff 100644
> --- a/lib/riscv/asm/sbi.h
> +++ b/lib/riscv/asm/sbi.h
> @@ -16,6 +16,7 @@
>
>  enum sbi_ext_id {
>         SBI_EXT_BASE =3D 0x10,
> +       SBI_EXT_TIME =3D 0x54494d45,
>         SBI_EXT_HSM =3D 0x48534d,
>         SBI_EXT_SRST =3D 0x53525354,
>  };
> @@ -37,6 +38,10 @@ enum sbi_ext_hsm_fid {
>         SBI_EXT_HSM_HART_SUSPEND,
>  };
>
> +enum sbi_ext_time_fid {
> +       SBI_EXT_TIME_SET_TIMER =3D 0,
> +};
> +
>  struct sbiret {
>         long error;
>         long value;
> diff --git a/lib/riscv/asm/setup.h b/lib/riscv/asm/setup.h
> index 7f81a705..5be252df 100644
> --- a/lib/riscv/asm/setup.h
> +++ b/lib/riscv/asm/setup.h
> @@ -7,6 +7,7 @@
>  #define NR_CPUS 16
>  extern struct thread_info cpus[NR_CPUS];
>  extern int nr_cpus;
> +extern uint64_t tb_hz;
>  int hartid_to_cpu(unsigned long hartid);
>
>  void io_init(void);
> diff --git a/lib/riscv/asm/timer.h b/lib/riscv/asm/timer.h
> new file mode 100644
> index 00000000..3eeb8344
> --- /dev/null
> +++ b/lib/riscv/asm/timer.h
> @@ -0,0 +1,30 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +#ifndef _ASMRISCV_TIMER_H_
> +#define _ASMRISCV_TIMER_H_
> +
> +#include <asm/csr.h>
> +#include <asm/processor.h>
> +
> +extern uint64_t usec_to_cycles(uint64_t usec);
> +
> +static inline void timer_irq_enable(void)
> +{
> +       csr_set(CSR_SIE, IE_TIE);
> +}
> +
> +static inline void timer_irq_disable(void)
> +{
> +       csr_clear(CSR_SIE, IE_TIE);
> +}
> +
> +static inline uint64_t timer_get_cycles(void)
> +{
> +       return csr_read(CSR_TIME);
> +}
> +
> +static inline bool timer_irq_pending(void)
> +{
> +       return csr_read(CSR_SIP) & IP_TIP;
> +}
> +
> +#endif /* _ASMRISCV_TIMER_H_ */
> diff --git a/lib/riscv/processor.c b/lib/riscv/processor.c
> index 0dffadc7..082b9d80 100644
> --- a/lib/riscv/processor.c
> +++ b/lib/riscv/processor.c
> @@ -7,6 +7,7 @@
>  #include <asm/isa.h>
>  #include <asm/processor.h>
>  #include <asm/setup.h>
> +#include <asm/timer.h>
>
>  extern unsigned long ImageBase;
>
> @@ -82,3 +83,8 @@ void thread_info_init(void)
>         isa_init(&cpus[cpu]);
>         csr_write(CSR_SSCRATCH, &cpus[cpu]);
>  }
> +
> +uint64_t usec_to_cycles(uint64_t usec)
> +{
> +       return (tb_hz * usec) / 1000000;
> +}
> diff --git a/lib/riscv/setup.c b/lib/riscv/setup.c
> index 50ffb0d0..b659c14e 100644
> --- a/lib/riscv/setup.c
> +++ b/lib/riscv/setup.c
> @@ -20,6 +20,7 @@
>  #include <asm/page.h>
>  #include <asm/processor.h>
>  #include <asm/setup.h>
> +#include <asm/timer.h>
>
>  #define VA_BASE                        ((phys_addr_t)3 * SZ_1G)
>  #if __riscv_xlen =3D=3D 64
> @@ -38,6 +39,7 @@ u32 initrd_size;
>
>  struct thread_info cpus[NR_CPUS];
>  int nr_cpus;
> +uint64_t tb_hz;
>
>  static struct mem_region riscv_mem_regions[NR_MEM_REGIONS + 1];
>
> @@ -67,6 +69,26 @@ static void cpu_init_acpi(void)
>         assert_msg(false, "ACPI not available");
>  }
>
> +static int cpu_init_timer(const void *fdt)
> +{
> +       const struct fdt_property *prop;
> +       u32 *data;
> +       int cpus;
> +
> +       cpus =3D fdt_path_offset(fdt, "/cpus");
> +       if (cpus < 0)
> +               return cpus;
> +
> +       prop =3D fdt_get_property(fdt, cpus, "timebase-frequency", NULL);
> +       if (prop =3D=3D NULL)
> +               return -1;
> +
> +       data =3D (u32 *)prop->data;
> +       tb_hz =3D fdt32_to_cpu(*data);
> +
> +       return 0;
> +}
> +
>  static void cpu_init(void)
>  {
>         int ret;
> @@ -75,6 +97,8 @@ static void cpu_init(void)
>         if (dt_available()) {
>                 ret =3D dt_for_each_cpu_node(cpu_set_fdt, NULL);
>                 assert(ret =3D=3D 0);
> +               ret =3D cpu_init_timer(dt_fdt());
> +               assert(ret =3D=3D 0);
>         } else {
>                 cpu_init_acpi();
>         }
> diff --git a/riscv/sbi.c b/riscv/sbi.c
> index 762e9711..a1a9ce84 100644
> --- a/riscv/sbi.c
> +++ b/riscv/sbi.c
> @@ -6,7 +6,14 @@
>   */
>  #include <libcflat.h>
>  #include <stdlib.h>
> +#include <asm/barrier.h>
> +#include <asm/csr.h>
> +#include <asm/processor.h>
>  #include <asm/sbi.h>
> +#include <asm/timer.h>
> +
> +static bool timer_works;
> +static bool mask_timer_irq;
>
>  static void help(void)
>  {
> @@ -19,6 +26,27 @@ static struct sbiret __base_sbi_ecall(int fid, unsigne=
d long arg0)
>         return sbi_ecall(SBI_EXT_BASE, fid, arg0, 0, 0, 0, 0, 0);
>  }
>
> +static struct sbiret __time_sbi_ecall(unsigned long stime_value)
> +{
> +       return sbi_ecall(SBI_EXT_TIME, SBI_EXT_TIME_SET_TIMER, stime_valu=
e, 0, 0, 0, 0, 0);
> +}
> +
> +static void timer_irq_handler(struct pt_regs *regs)
> +{
> +       if (timer_works)
> +               report_abort("timer interrupt received multiple times");
> +
> +       timer_works =3D true;
> +       report(timer_irq_pending(), "pending timer interrupt bit set");
> +
> +       if (mask_timer_irq)
> +               timer_irq_disable();
> +       else {
> +               __time_sbi_ecall(-1);
> +               report(!timer_irq_pending(), "pending timer interrupt bit=
 cleared");
> +       }
> +}
> +
>  static bool env_or_skip(const char *env)
>  {
>         if (!getenv(env)) {
> @@ -112,6 +140,85 @@ static void check_base(void)
>         report_prefix_pop();
>  }
>
> +static void check_time(void)
> +{
> +       struct sbiret ret;
> +       unsigned long begin, end, duration;
> +       unsigned long delay =3D getenv("TIMER_DELAY")
> +                                                       ? strtol(getenv("=
TIMER_DELAY"), NULL, 0)
> +                                                       : 1000000;
> +       unsigned long margin =3D getenv("TIMER_MARGIN")
> +                                                       ? strtol(getenv("=
TIMER_MARGIN"), NULL, 0)
> +                                                       : 1000000;

Whoops, it looks like my editor settings showed tabs as 4 characters
instead of 8. I will fix this spacing and manually validate it in the
next patch version.

> +
> +       delay =3D usec_to_cycles(delay);
> +       margin =3D usec_to_cycles(margin);
> +
> +       report_prefix_push("time");
> +
> +       ret =3D __base_sbi_ecall(SBI_EXT_BASE_PROBE_EXT, SBI_EXT_TIME);
> +
> +       if (ret.error) {
> +               report_fail("probing for time extension failed");
> +               report_prefix_pop();
> +               return;
> +       }
> +
> +       if (!ret.value) {
> +               report_skip("time extension not available");
> +               report_prefix_pop();
> +               return;
> +       }
> +
> +       begin =3D timer_get_cycles();
> +       while ((end =3D timer_get_cycles()) <=3D begin)
> +               cpu_relax();
> +       assert(begin < end);
> +
> +       report_prefix_push("set_timer");
> +
> +       install_irq_handler(IRQ_S_TIMER, timer_irq_handler);
> +       local_irq_enable();
> +       timer_irq_enable();
> +
> +       begin =3D timer_get_cycles();
> +       ret =3D __time_sbi_ecall(begin + delay);
> +
> +       if (ret.error)
> +               report_fail("setting timer failed");
> +
> +       report(!timer_irq_pending(), "pending timer interrupt bit cleared=
");
> +
> +       while ((end =3D timer_get_cycles()) <=3D (begin + delay + margin)=
 && !timer_works)
> +               cpu_relax();
> +
> +       report(timer_works, "timer interrupt received");
> +
> +       if (timer_works) {
> +               duration =3D end - begin;
> +               report(duration >=3D delay && duration <=3D (delay + marg=
in), "timer delay honored");
> +       }
> +
> +       timer_works =3D false;
> +       mask_timer_irq =3D true;
> +       begin =3D timer_get_cycles();
> +       ret =3D __time_sbi_ecall(begin + delay);
> +
> +       if (ret.error)
> +               report_fail("setting timer failed");
> +
> +       while ((end =3D timer_get_cycles()) <=3D (begin + delay + margin)=
 && !timer_works)
> +               cpu_relax();
> +
> +       report(timer_works, "timer interrupt received");
> +
> +       local_irq_disable();
> +       install_irq_handler(IRQ_S_TIMER, NULL);
> +
> +       report_prefix_pop();
> +       report_prefix_pop();
> +}
> +
>  int main(int argc, char **argv)
>  {
>
> @@ -122,6 +229,7 @@ int main(int argc, char **argv)
>
>         report_prefix_push("sbi");
>         check_base();
> +       check_time();
>
>         return report_summary();
>  }
> --
> 2.43.0
>

Best regards,
James Raphael Tiovalen

