Return-Path: <kvm+bounces-16221-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BE2E78B6CB7
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2024 10:24:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E1BAA1C2249A
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2024 08:24:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFDFF7FBD3;
	Tue, 30 Apr 2024 08:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sNVu0QQO"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F33EE57302;
	Tue, 30 Apr 2024 08:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714465437; cv=none; b=hZenWd+QKbxc1eL89BOHMJPGAM1EYiZC3PN37PN+qkjzOpsfw7RGZcFX9DEUNBW1khE+xCRKgZw6nbABV9WHQU6DRMoIRtL7AqTod5WQGYfzEXX4ClpeU6cqYCIYlL77+GWX+3GK9DI9xvoUB8VH2PdKX/HnebZY1vIYivFIddo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714465437; c=relaxed/simple;
	bh=VsyOloioIfesdDNLYyvwCXpx/Xt5uokNkCcw7EG/nSY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fbJKMsZ1mJOo3r/RJQPWM11IuM7VguqvaWeVLTvmoQ5ELGoDqE3MK2sUr39qenI8hjXBSJhZny1th0h9eTGS6fWLwlDK1T46R66WLc7F6js3lMFx3jS7VXSJzRXVnH97IdaU2JLgnlTjs+CRA58aEq85MaFWumaCFl2YEW5+4Bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sNVu0QQO; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9611FC4AF1B;
	Tue, 30 Apr 2024 08:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714465436;
	bh=VsyOloioIfesdDNLYyvwCXpx/Xt5uokNkCcw7EG/nSY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=sNVu0QQOKZMI8vbNb/fmhAo8COt9XIKGi4NoeDAF4mthlIlpnhHbiryC0yKzPJrab
	 ZmH0v6rhXRt1k9lftjKA/OlqnfU9LX+Q9uisRRfSrSDxDodYbLYw85mBa8GUrsnxDM
	 BvWzS4VcFFVrIsLNpyYiughM5l41wnqeCrBt8PeFRLgPIHruP+tTWV99uC25WfuOxk
	 p+TFiuLHBBU9GqZjbo/cxUJNpadJdX+TAwcxUgClqyYpEEZ+wWBydBUlQYtVzri+Hq
	 sNg3nuNpH781p71npC7QZUzHS+8uwhE3of0J4Nw/0M5wjGKFamrL9ZiXDrX7q7nhvi
	 +K6UPMbH3WxTw==
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-56e56ee8d5cso6755524a12.2;
        Tue, 30 Apr 2024 01:23:56 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUMwhXI96uLIDnnBIxkdgqKqbCbT419INFULL0hosJ21UI0ups/0UD5smKRjWgm95oVJOTj6Hn49juUuMG3G0t2gxTiestwccR21IGVNc3K0BCvVR3ndExNgAqkqnilY7QF
X-Gm-Message-State: AOJu0YyzWcPXrdZt+nXTie1V8wuRoO5DzO3bqr3MbaSR59De3pkCwi1m
	CsVYsyZC+airoSvz5JI4ccvY64qm/g0T126TH29K+1D+UZGWO9Ci9Fe/Xy623wvsVV8wJXZ8dVe
	PwExPrfxeQENN5LOAiqfRFwaOzrE=
X-Google-Smtp-Source: AGHT+IEw2cZHZLMb8FkqhXvYx5WJlkmaBw01K6YpVQYCne8PPhCZ1Mk6XfNcMI1nStR3UeFDQdJ+EjegwAp1pEddjnA=
X-Received: by 2002:a17:907:9694:b0:a58:bb3e:937b with SMTP id
 hd20-20020a170907969400b00a58bb3e937bmr11731440ejc.63.1714465435014; Tue, 30
 Apr 2024 01:23:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240430014505.2102631-1-maobibo@loongson.cn> <20240430014505.2102631-3-maobibo@loongson.cn>
In-Reply-To: <20240430014505.2102631-3-maobibo@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Tue, 30 Apr 2024 16:23:42 +0800
X-Gmail-Original-Message-ID: <CAAhV-H4xN9rdBkSA4PJafr5MNqEiCbNHTgim_bj89YNaB4PFjw@mail.gmail.com>
Message-ID: <CAAhV-H4xN9rdBkSA4PJafr5MNqEiCbNHTgim_bj89YNaB4PFjw@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] LoongArch: Add steal time support in guest side
To: Bibo Mao <maobibo@loongson.cn>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, Juergen Gross <jgross@suse.com>, kvm@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-kernel@vger.kernel.org, x86@kernel.org, 
	virtualization@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, Bibo,

On Tue, Apr 30, 2024 at 9:45=E2=80=AFAM Bibo Mao <maobibo@loongson.cn> wrot=
e:
>
> Percpu struct kvm_steal_time is added here, its size is 64 bytes and
> also defined as 64 bytes, so that the whole structure is in one physical
> page.
>
> When vcpu is onlined, function pv_enable_steal_time() is called. This
> function will pass guest physical address of struct kvm_steal_time and
> tells hypervisor to enable steal time. When vcpu is offline, physical
> address is set as 0 and tells hypervisor to disable steal time.
>
> Here is output of vmstat on guest when there is workload on both host
> and guest. It includes steal time stat information.
>
> procs -----------memory---------- -----io---- -system-- ------cpu-----
>  r  b   swpd   free  inact active   bi    bo   in   cs us sy id wa st
> 15  1      0 7583616 184112  72208    20    0  162   52 31  6 43  0 20
> 17  0      0 7583616 184704  72192    0     0 6318 6885  5 60  8  5 22
> 16  0      0 7583616 185392  72144    0     0 1766 1081  0 49  0  1 50
> 16  0      0 7583616 184816  72304    0     0 6300 6166  4 62 12  2 20
> 18  0      0 7583632 184480  72240    0     0 2814 1754  2 58  4  1 35
>
> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> ---
>  arch/loongarch/Kconfig                |  11 +++
>  arch/loongarch/include/asm/paravirt.h |   5 +
>  arch/loongarch/kernel/paravirt.c      | 131 ++++++++++++++++++++++++++
>  arch/loongarch/kernel/time.c          |   2 +
>  4 files changed, 149 insertions(+)
>
> diff --git a/arch/loongarch/Kconfig b/arch/loongarch/Kconfig
> index 0a1540a8853e..f3a03c33a052 100644
> --- a/arch/loongarch/Kconfig
> +++ b/arch/loongarch/Kconfig
> @@ -592,6 +592,17 @@ config PARAVIRT
>           over full virtualization.  However, when run without a hypervis=
or
>           the kernel is theoretically slower and slightly larger.
>
> +config PARAVIRT_TIME_ACCOUNTING
> +       bool "Paravirtual steal time accounting"
> +       select PARAVIRT
> +       help
> +         Select this option to enable fine granularity task steal time
> +         accounting. Time spent executing other tasks in parallel with
> +         the current vCPU is discounted from the vCPU power. To account =
for
> +         that, there can be a small performance impact.
> +
> +         If in doubt, say N here.
> +
Can we use a hidden selection manner, which means:

config PARAVIRT_TIME_ACCOUNTING
       def_bool PARAVIRT

Because I think we needn't give too many choices to users (and bring
much more effort to test).

PowerPC even hide all the PARAVIRT config options...
see arch/powerpc/platforms/pseries/Kconfig

Huacai

>  config ARCH_SUPPORTS_KEXEC
>         def_bool y
>
> diff --git a/arch/loongarch/include/asm/paravirt.h b/arch/loongarch/inclu=
de/asm/paravirt.h
> index 58f7b7b89f2c..fe27fb5e82b8 100644
> --- a/arch/loongarch/include/asm/paravirt.h
> +++ b/arch/loongarch/include/asm/paravirt.h
> @@ -17,11 +17,16 @@ static inline u64 paravirt_steal_clock(int cpu)
>  }
>
>  int pv_ipi_init(void);
> +int __init pv_time_init(void);
>  #else
>  static inline int pv_ipi_init(void)
>  {
>         return 0;
>  }
>
> +static inline int pv_time_init(void)
> +{
> +       return 0;
> +}
>  #endif // CONFIG_PARAVIRT
>  #endif
> diff --git a/arch/loongarch/kernel/paravirt.c b/arch/loongarch/kernel/par=
avirt.c
> index 9044ed62045c..3f83afc7e2d2 100644
> --- a/arch/loongarch/kernel/paravirt.c
> +++ b/arch/loongarch/kernel/paravirt.c
> @@ -5,10 +5,13 @@
>  #include <linux/jump_label.h>
>  #include <linux/kvm_para.h>
>  #include <asm/paravirt.h>
> +#include <linux/reboot.h>
>  #include <linux/static_call.h>
>
>  struct static_key paravirt_steal_enabled;
>  struct static_key paravirt_steal_rq_enabled;
> +static DEFINE_PER_CPU(struct kvm_steal_time, steal_time) __aligned(64);
> +static int has_steal_clock;
>
>  static u64 native_steal_clock(int cpu)
>  {
> @@ -17,6 +20,57 @@ static u64 native_steal_clock(int cpu)
>
>  DEFINE_STATIC_CALL(pv_steal_clock, native_steal_clock);
>
> +static bool steal_acc =3D true;
> +static int __init parse_no_stealacc(char *arg)
> +{
> +       steal_acc =3D false;
> +       return 0;
> +}
> +early_param("no-steal-acc", parse_no_stealacc);
> +
> +static u64 para_steal_clock(int cpu)
> +{
> +       u64 steal;
> +       struct kvm_steal_time *src;
> +       int version;
> +
> +       src =3D &per_cpu(steal_time, cpu);
> +       do {
> +
> +               version =3D src->version;
> +               /* Make sure that the version is read before the steal */
> +               virt_rmb();
> +               steal =3D src->steal;
> +               /* Make sure that the steal is read before the next versi=
on */
> +               virt_rmb();
> +
> +       } while ((version & 1) || (version !=3D src->version));
> +       return steal;
> +}
> +
> +static int pv_enable_steal_time(void)
> +{
> +       int cpu =3D smp_processor_id();
> +       struct kvm_steal_time *st;
> +       unsigned long addr;
> +
> +       if (!has_steal_clock)
> +               return -EPERM;
> +
> +       st =3D &per_cpu(steal_time, cpu);
> +       addr =3D per_cpu_ptr_to_phys(st);
> +
> +       /* The whole structure kvm_steal_time should be one page */
> +       if (PFN_DOWN(addr) !=3D PFN_DOWN(addr + sizeof(*st))) {
> +               pr_warn("Illegal PV steal time addr %lx\n", addr);
> +               return -EFAULT;
> +       }
> +
> +       addr |=3D KVM_STEAL_PHYS_VALID;
> +       kvm_hypercall2(KVM_HCALL_FUNC_NOTIFY, KVM_FEATURE_STEAL_TIME, add=
r);
> +       return 0;
> +}
> +
>  #ifdef CONFIG_SMP
>  static void pv_send_ipi_single(int cpu, unsigned int action)
>  {
> @@ -110,6 +164,32 @@ static void pv_init_ipi(void)
>         if (r < 0)
>                 panic("SWI0 IRQ request failed\n");
>  }
> +
> +static void pv_disable_steal_time(void)
> +{
> +       if (has_steal_clock)
> +               kvm_hypercall2(KVM_HCALL_FUNC_NOTIFY, KVM_FEATURE_STEAL_T=
IME, 0);
> +}
> +
> +static int pv_time_cpu_online(unsigned int cpu)
> +{
> +       unsigned long flags;
> +
> +       local_irq_save(flags);
> +       pv_enable_steal_time();
> +       local_irq_restore(flags);
> +       return 0;
> +}
> +
> +static int pv_time_cpu_down_prepare(unsigned int cpu)
> +{
> +       unsigned long flags;
> +
> +       local_irq_save(flags);
> +       pv_disable_steal_time();
> +       local_irq_restore(flags);
> +       return 0;
> +}
>  #endif
>
>  static bool kvm_para_available(void)
> @@ -149,3 +229,54 @@ int __init pv_ipi_init(void)
>
>         return 1;
>  }
> +
> +static void pv_cpu_reboot(void *unused)
> +{
> +       pv_disable_steal_time();
> +}
> +
> +static int pv_reboot_notify(struct notifier_block *nb, unsigned long cod=
e,
> +               void *unused)
> +{
> +       on_each_cpu(pv_cpu_reboot, NULL, 1);
> +       return NOTIFY_DONE;
> +}
> +
> +static struct notifier_block pv_reboot_nb =3D {
> +       .notifier_call  =3D pv_reboot_notify,
> +};
> +
> +int __init pv_time_init(void)
> +{
> +       int feature;
> +
> +       if (!cpu_has_hypervisor)
> +               return 0;
> +       if (!kvm_para_available())
> +               return 0;
> +
> +       feature =3D read_cpucfg(CPUCFG_KVM_FEATURE);
> +       if (!(feature & KVM_FEATURE_STEAL_TIME))
> +               return 0;
> +
> +       has_steal_clock =3D 1;
> +       if (pv_enable_steal_time()) {
> +               has_steal_clock =3D 0;
> +               return 0;
> +       }
> +
> +       register_reboot_notifier(&pv_reboot_nb);
> +       static_call_update(pv_steal_clock, para_steal_clock);
> +       static_key_slow_inc(&paravirt_steal_enabled);
> +       if (steal_acc)
> +               static_key_slow_inc(&paravirt_steal_rq_enabled);
> +
> +#ifdef CONFIG_SMP
> +       if (cpuhp_setup_state_nocalls(CPUHP_AP_ONLINE_DYN,
> +                       "loongarch/pvi_time:online",
> +                       pv_time_cpu_online, pv_time_cpu_down_prepare) < 0=
)
> +               pr_err("Failed to install cpu hotplug callbacks\n");
> +#endif
> +       pr_info("Using stolen time PV\n");
> +       return 0;
> +}
> diff --git a/arch/loongarch/kernel/time.c b/arch/loongarch/kernel/time.c
> index fd5354f9be7c..46d7d40c87e3 100644
> --- a/arch/loongarch/kernel/time.c
> +++ b/arch/loongarch/kernel/time.c
> @@ -15,6 +15,7 @@
>
>  #include <asm/cpu-features.h>
>  #include <asm/loongarch.h>
> +#include <asm/paravirt.h>
>  #include <asm/time.h>
>
>  u64 cpu_clock_freq;
> @@ -214,4 +215,5 @@ void __init time_init(void)
>
>         constant_clockevent_init();
>         constant_clocksource_init();
> +       pv_time_init();
>  }
> --
> 2.39.3
>
>

