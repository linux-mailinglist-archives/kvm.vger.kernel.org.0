Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACBF4A1970
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2019 13:58:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727257AbfH2L6f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Aug 2019 07:58:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47754 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726739AbfH2L6e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Aug 2019 07:58:34 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 352E28553A;
        Thu, 29 Aug 2019 11:58:34 +0000 (UTC)
Received: from amt.cnet (ovpn-112-4.gru2.redhat.com [10.97.112.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7B5FC5D9C9;
        Thu, 29 Aug 2019 11:58:33 +0000 (UTC)
Received: from amt.cnet (localhost [127.0.0.1])
        by amt.cnet (Postfix) with ESMTP id A518310513F;
        Thu, 29 Aug 2019 08:56:37 -0300 (BRT)
Received: (from marcelo@localhost)
        by amt.cnet (8.14.7/8.14.7/Submit) id x7TBuZvW009438;
        Thu, 29 Aug 2019 08:56:35 -0300
Date:   Thu, 29 Aug 2019 08:56:34 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-pm@vger.kernel.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: Re: [PATCH v1] cpuidle-haltpoll: vcpu hotplug support
Message-ID: <20190829115634.GA4949@amt.cnet>
References: <20190828185650.16923-1-joao.m.martins@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190828185650.16923-1-joao.m.martins@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Thu, 29 Aug 2019 11:58:34 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Joao,

On Wed, Aug 28, 2019 at 07:56:50PM +0100, Joao Martins wrote:
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
>  	wrmsrl(MSR_KVM_POLL_CONTROL, 1);
>  }
>  
> -void arch_haltpoll_enable(void)
> +void arch_haltpoll_enable(unsigned int cpu)
>  {
>  	if (!kvm_para_has_feature(KVM_FEATURE_POLL_CONTROL)) {
> -		printk(KERN_ERR "kvm: host does not support poll control\n");
> -		printk(KERN_ERR "kvm: host upgrade recommended\n");
> +		pr_err_once("kvm: host does not support poll control\n");
> +		pr_err_once("kvm: host upgrade recommended\n");
>  		return;
>  	}
>  
> -	preempt_disable();
>  	/* Enable guest halt poll disables host halt poll */
> -	kvm_disable_host_haltpoll(NULL);
> -	smp_call_function(kvm_disable_host_haltpoll, NULL, 1);
> -	preempt_enable();
> +	smp_call_function_single(cpu, kvm_disable_host_haltpoll, NULL, 1);
>  }
>  EXPORT_SYMBOL_GPL(arch_haltpoll_enable);
>  
> -void arch_haltpoll_disable(void)
> +void arch_haltpoll_disable(unsigned int cpu)
>  {
>  	if (!kvm_para_has_feature(KVM_FEATURE_POLL_CONTROL))
>  		return;
>  
> -	preempt_disable();
>  	/* Enable guest halt poll disables host halt poll */
> -	kvm_enable_host_haltpoll(NULL);
> -	smp_call_function(kvm_enable_host_haltpoll, NULL, 1);
> -	preempt_enable();
> +	smp_call_function_single(cpu, kvm_enable_host_haltpoll, NULL, 1);
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
>  			      struct cpuidle_driver *drv, int index)
>  {
> @@ -46,6 +49,48 @@ static struct cpuidle_driver haltpoll_driver = {
>  	.state_count = 2,
>  };
>  
> +static int haltpoll_cpu_online(unsigned int cpu)
> +{
> +	struct cpuidle_device *dev;
> +
> +	dev = per_cpu_ptr(haltpoll_cpuidle_devices, cpu);
> +	if (!dev->registered) {
> +		dev->cpu = cpu;
> +		if (cpuidle_register_device(dev)) {
> +			pr_notice("cpuidle_register_device %d failed!\n", cpu);
> +			return -EIO;
> +		}
> +		arch_haltpoll_enable(cpu);
> +	}
> +
> +	return 0;
> +}
> +
> +static void haltpoll_uninit(void)
> +{
> +	unsigned int cpu;
> +
> +	cpus_read_lock();
> +
> +	for_each_online_cpu(cpu) {
> +		struct cpuidle_device *dev =
> +			per_cpu_ptr(haltpoll_cpuidle_devices, cpu);
> +
> +		if (!dev->registered)
> +			continue;
> +
> +		arch_haltpoll_disable(cpu);
> +		cpuidle_unregister_device(dev);
> +	}

1)

> +
> +	cpuidle_unregister(&haltpoll_driver);

cpuidle_unregister_driver.

> +	free_percpu(haltpoll_cpuidle_devices);
> +	haltpoll_cpuidle_devices = NULL;
> +
> +	cpus_read_unlock();

Any reason you can't cpus_read_unlock() at 1) ?

Looks good otherwise.

Thanks!

