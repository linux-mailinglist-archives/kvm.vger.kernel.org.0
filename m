Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D8D8A0E4D
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2019 01:39:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727171AbfH1Xjh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Aug 2019 19:39:37 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:43785 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726926AbfH1Xjg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Aug 2019 19:39:36 -0400
Received: by mail-oi1-f193.google.com with SMTP id y8so1105136oih.10;
        Wed, 28 Aug 2019 16:39:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PKOOEDeU92y+0iSa7impzejPm6WlaT2B+UMpIRPhzco=;
        b=lz+U0sp7q612XYEhoMz7ofk4POq9xhQizNvGKF9KfA6aocv0TXZ7xTteQcHUNnvjCj
         Y+xn47ALWeb2xtMHdhtPgtvIAjLk8gfp5L2ScJe/0oJwlYKePDDsgovOS4nYiVwOwvl/
         HVfwV2KT8/KnY7Eufe1dDyRNZcB/wFXCvd/+2qdGDJtrpfAjOfhRp6+xJTzL8+3plmYh
         SWHcOr/7Rx/PiM8Qe1Tv0USnF6TwCyE/Kx5iVNcJ31n0BHQk2R4Qja47BT00hOjkTP9k
         k9r8NDwACSI51Dx/kpA1wXjFuIBbtVjSN9yVMIGUJKKmZ3LfgYhZzE5FEjUuficewWQu
         DtbA==
X-Gm-Message-State: APjAAAVcY34puRVJQyU1Yu3JNHLoAmgGmM3bBoxbjxT9w1sUDDQn2R67
        EcRK66FT/q4OflJXL6pSPT3nryKpLWwCDRRR7jwGsQ==
X-Google-Smtp-Source: APXvYqyV0aVPxEJSi1pCuxgzvJqctjmeNgzDPWDh/UeVn441IgCiQykIpHgv/ZEDkhabEALJqRLLuH/n91dgIUjbtio=
X-Received: by 2002:aca:d586:: with SMTP id m128mr4813386oig.110.1567035575766;
 Wed, 28 Aug 2019 16:39:35 -0700 (PDT)
MIME-Version: 1.0
References: <20190828185650.16923-1-joao.m.martins@oracle.com>
In-Reply-To: <20190828185650.16923-1-joao.m.martins@oracle.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Thu, 29 Aug 2019 01:39:23 +0200
Message-ID: <CAJZ5v0hBgMBSES541FBdZDbZWHOOhuy5JuY+UamOPrCYzNCPmA@mail.gmail.com>
Subject: Re: [PATCH v1] cpuidle-haltpoll: vcpu hotplug support
To:     Joao Martins <joao.m.martins@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm-devel <kvm@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Linux PM <linux-pm@vger.kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 28, 2019 at 8:58 PM Joao Martins <joao.m.martins@oracle.com> wrote:
>
> When cpus != maxcpus cpuidle-haltpoll will fail to register all vcpus
> past the online ones and thus fail to register the idle driver.
> This is because cpuidle_add_sysfs() will return with -ENODEV as a
> consequence from get_cpu_device() return no device for a non-existing
> CPU.
>
> Instead switch to cpuidle_register_driver() and manually register each
> of the present cpus through cpuhp_setup_state() and future ones that
> get onlined. This mimics similar logic as intel_idle.
>
> Fixes: fa86ee90eb11 ("add cpuidle-haltpoll driver")
> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>

Paolo, what do you think?

> ---
>  arch/x86/include/asm/cpuidle_haltpoll.h |  4 +-
>  arch/x86/kernel/kvm.c                   | 18 +++----
>  drivers/cpuidle/cpuidle-haltpoll.c      | 65 +++++++++++++++++++++++--
>  include/linux/cpuidle_haltpoll.h        |  4 +-
>  4 files changed, 70 insertions(+), 21 deletions(-)
>
> diff --git a/arch/x86/include/asm/cpuidle_haltpoll.h b/arch/x86/include/asm/cpuidle_haltpoll.h
> index ff8607d81526..c8b39c6716ff 100644
> --- a/arch/x86/include/asm/cpuidle_haltpoll.h
> +++ b/arch/x86/include/asm/cpuidle_haltpoll.h
> @@ -2,7 +2,7 @@
>  #ifndef _ARCH_HALTPOLL_H
>  #define _ARCH_HALTPOLL_H
>
> -void arch_haltpoll_enable(void);
> -void arch_haltpoll_disable(void);
> +void arch_haltpoll_enable(unsigned int cpu);
> +void arch_haltpoll_disable(unsigned int cpu);
>
>  #endif
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index 8d150e3732d9..a9b6c4e2446d 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -880,32 +880,26 @@ static void kvm_enable_host_haltpoll(void *i)
>         wrmsrl(MSR_KVM_POLL_CONTROL, 1);
>  }
>
> -void arch_haltpoll_enable(void)
> +void arch_haltpoll_enable(unsigned int cpu)
>  {
>         if (!kvm_para_has_feature(KVM_FEATURE_POLL_CONTROL)) {
> -               printk(KERN_ERR "kvm: host does not support poll control\n");
> -               printk(KERN_ERR "kvm: host upgrade recommended\n");
> +               pr_err_once("kvm: host does not support poll control\n");
> +               pr_err_once("kvm: host upgrade recommended\n");
>                 return;
>         }
>
> -       preempt_disable();
>         /* Enable guest halt poll disables host halt poll */
> -       kvm_disable_host_haltpoll(NULL);
> -       smp_call_function(kvm_disable_host_haltpoll, NULL, 1);
> -       preempt_enable();
> +       smp_call_function_single(cpu, kvm_disable_host_haltpoll, NULL, 1);
>  }
>  EXPORT_SYMBOL_GPL(arch_haltpoll_enable);
>
> -void arch_haltpoll_disable(void)
> +void arch_haltpoll_disable(unsigned int cpu)
>  {
>         if (!kvm_para_has_feature(KVM_FEATURE_POLL_CONTROL))
>                 return;
>
> -       preempt_disable();
>         /* Enable guest halt poll disables host halt poll */
> -       kvm_enable_host_haltpoll(NULL);
> -       smp_call_function(kvm_enable_host_haltpoll, NULL, 1);
> -       preempt_enable();
> +       smp_call_function_single(cpu, kvm_enable_host_haltpoll, NULL, 1);
>  }
>  EXPORT_SYMBOL_GPL(arch_haltpoll_disable);
>  #endif
> diff --git a/drivers/cpuidle/cpuidle-haltpoll.c b/drivers/cpuidle/cpuidle-haltpoll.c
> index 9ac093dcbb01..0d1853a7185e 100644
> --- a/drivers/cpuidle/cpuidle-haltpoll.c
> +++ b/drivers/cpuidle/cpuidle-haltpoll.c
> @@ -11,12 +11,15 @@
>   */
>
>  #include <linux/init.h>
> +#include <linux/cpu.h>
>  #include <linux/cpuidle.h>
>  #include <linux/module.h>
>  #include <linux/sched/idle.h>
>  #include <linux/kvm_para.h>
>  #include <linux/cpuidle_haltpoll.h>
>
> +static struct cpuidle_device __percpu *haltpoll_cpuidle_devices;
> +
>  static int default_enter_idle(struct cpuidle_device *dev,
>                               struct cpuidle_driver *drv, int index)
>  {
> @@ -46,6 +49,48 @@ static struct cpuidle_driver haltpoll_driver = {
>         .state_count = 2,
>  };
>
> +static int haltpoll_cpu_online(unsigned int cpu)
> +{
> +       struct cpuidle_device *dev;
> +
> +       dev = per_cpu_ptr(haltpoll_cpuidle_devices, cpu);
> +       if (!dev->registered) {
> +               dev->cpu = cpu;
> +               if (cpuidle_register_device(dev)) {
> +                       pr_notice("cpuidle_register_device %d failed!\n", cpu);
> +                       return -EIO;
> +               }
> +               arch_haltpoll_enable(cpu);
> +       }
> +
> +       return 0;
> +}
> +
> +static void haltpoll_uninit(void)
> +{
> +       unsigned int cpu;
> +
> +       cpus_read_lock();
> +
> +       for_each_online_cpu(cpu) {
> +               struct cpuidle_device *dev =
> +                       per_cpu_ptr(haltpoll_cpuidle_devices, cpu);
> +
> +               if (!dev->registered)
> +                       continue;
> +
> +               arch_haltpoll_disable(cpu);
> +               cpuidle_unregister_device(dev);
> +       }
> +
> +       cpuidle_unregister(&haltpoll_driver);
> +
> +       free_percpu(haltpoll_cpuidle_devices);
> +       haltpoll_cpuidle_devices = NULL;
> +
> +       cpus_read_unlock();
> +}
> +
>  static int __init haltpoll_init(void)
>  {
>         int ret;
> @@ -56,17 +101,27 @@ static int __init haltpoll_init(void)
>         if (!kvm_para_available())
>                 return 0;
>
> -       ret = cpuidle_register(&haltpoll_driver, NULL);
> -       if (ret == 0)
> -               arch_haltpoll_enable();
> +       ret = cpuidle_register_driver(drv);
> +       if (ret < 0)
> +               return ret;
> +
> +       haltpoll_cpuidle_devices = alloc_percpu(struct cpuidle_device);
> +       if (haltpoll_cpuidle_devices == NULL) {
> +               cpuidle_unregister_driver(drv);
> +               return -ENOMEM;
> +       }
> +
> +       ret = cpuhp_setup_state(CPUHP_AP_ONLINE_DYN, "idle/haltpoll:online",
> +                               haltpoll_cpu_online, NULL);
> +       if (ret < 0)
> +               haltpoll_uninit();
>
>         return ret;
>  }
>
>  static void __exit haltpoll_exit(void)
>  {
> -       arch_haltpoll_disable();
> -       cpuidle_unregister(&haltpoll_driver);
> +       haltpoll_uninit();
>  }
>
>  module_init(haltpoll_init);
> diff --git a/include/linux/cpuidle_haltpoll.h b/include/linux/cpuidle_haltpoll.h
> index fe5954c2409e..d50c1e0411a2 100644
> --- a/include/linux/cpuidle_haltpoll.h
> +++ b/include/linux/cpuidle_haltpoll.h
> @@ -5,11 +5,11 @@
>  #ifdef CONFIG_ARCH_CPUIDLE_HALTPOLL
>  #include <asm/cpuidle_haltpoll.h>
>  #else
> -static inline void arch_haltpoll_enable(void)
> +static inline void arch_haltpoll_enable(unsigned int cpu)
>  {
>  }
>
> -static inline void arch_haltpoll_disable(void)
> +static inline void arch_haltpoll_disable(unsigned int cpu)
>  {
>  }
>  #endif
> --
> 2.17.1
>
