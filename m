Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A98454AFDEB
	for <lists+kvm@lfdr.de>; Wed,  9 Feb 2022 21:01:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230407AbiBIUA3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Feb 2022 15:00:29 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:53570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231204AbiBIUAZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Feb 2022 15:00:25 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92E96E04A469
        for <kvm@vger.kernel.org>; Wed,  9 Feb 2022 11:59:54 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id a11-20020a17090a740b00b001b8b506c42fso6291689pjg.0
        for <kvm@vger.kernel.org>; Wed, 09 Feb 2022 11:59:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=cjptAnlZYygl4lxjpVmbPNPsCEUjtA+ad8MBXgT+dJo=;
        b=Ifi2wu/1FtHXssE4kcRj//oDncZILC7PzGUiqnHrHRAqFVFkcb9gFGWkhx26PgUk3q
         eugbxcva7D4kt4Cm8ZlupaDsTwIDqF2hihri2OV0piFl9aJAPTz6QQVeLvex+K5zpXnA
         NStWCETDx1FWyCMyaL21+6EQqEV9xllmBB2Hw7SYlwp/WnadYJ4OZnZi46n+FX41YlT3
         1NstAAyCLllNIpknNnxzNw47LMmnGHrmJ2+2cwtDsNgPmX3s/ntoGiUXqKRjes1OjaE3
         7t+3PyQU2DdOJz/Q3nk7dyLka57D5FcnqJZC08T26RDEuWS4PRC2+tscGs6KU/TEplxN
         gSHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=cjptAnlZYygl4lxjpVmbPNPsCEUjtA+ad8MBXgT+dJo=;
        b=f86CYnLvd4HSf5iQhM4JnpINUF1FI8I4Pvl6ck6S9uyqrxGViPvaGZCXh5hjd+lRup
         ELfLSINhCYaD4iG44LXnONwtzKjNtaujMmYYxFOXfcdV8bgb95FPQWcAvdnHJ8R1uDIB
         +b+DmBiyaksVtiyR3e5VHg+bvu0yzWTW8xXfwlhFYZbI0MKAP4NJJ01HnBpoFCXNAo4X
         nRm85QpmYSR3hNKOw/CFJRZpkVLLkR6CHelugujiZPAU33vZvfLzYILRVLsXUSJPQ/pj
         ZIN2Cb4BYcUYkHjuO+7ZruVcwk1yRseu4AtqoWtKaAo4wXCsKiqOIdsGremkMlIQcmV+
         vjdg==
X-Gm-Message-State: AOAM533Xzns3B7PDtPLjBRwxl6UC9rzPVgrfwLr9HOHWQ+nVajcSL5Kq
        1r2RhGvOlxXHdSJisNdKdJwBPQ==
X-Google-Smtp-Source: ABdhPJzU9z2aGv82IRf25hkz/sdrDBetLK2oD9jbj8fk3999DMyFmbtlBV6K/T5olCqCnSPxWSMb8Q==
X-Received: by 2002:a17:902:6b06:: with SMTP id o6mr3787140plk.162.1644436789489;
        Wed, 09 Feb 2022 11:59:49 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id nu15sm7304632pjb.5.2022.02.09.11.59.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Feb 2022 11:59:48 -0800 (PST)
Date:   Wed, 9 Feb 2022 19:59:45 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Chao Gao <chao.gao@intel.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, kevin.tian@intel.com,
        tglx@linutronix.de, John Garry <john.garry@huawei.com>,
        Will Deacon <will@kernel.org>, Qi Liu <liuqi115@huawei.com>,
        Thomas Richter <tmricht@linux.ibm.com>,
        Shaokun Zhang <zhangshaokun@hisilicon.com>,
        Hector Martin <marcan@marcan.st>,
        Huang Ying <ying.huang@intel.com>,
        linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v3 4/5] KVM: Rename and move CPUHP_AP_KVM_STARTING to
 ONLINE section
Message-ID: <YgQdMRug21MJ926L@google.com>
References: <20220209074109.453116-1-chao.gao@intel.com>
 <20220209074109.453116-5-chao.gao@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220209074109.453116-5-chao.gao@intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

+Marc

On Wed, Feb 09, 2022, Chao Gao wrote:
> The CPU STARTING section doesn't allow callbacks to fail. Move KVM's
> hotplug callback to ONLINE section so that it can abort onlining a CPU in
> certain cases to avoid potentially breaking VMs running on existing CPUs.
> For example, when kvm fails to enable hardware virtualization on the
> hotplugged CPU.
> 
> Place KVM's hotplug state before CPUHP_AP_SCHED_WAIT_EMPTY as it ensures
> when offlining a CPU, all user tasks and non-pinned kernel tasks have left
> the CPU, i.e. there cannot be a vCPU task around. So, it is safe for KVM's
> CPU offline callback to disable hardware virtualization at that point.
> Likewise, KVM's online callback can enable hardware virtualization before
> any vCPU task gets a chance to run on hotplugged CPUs.
> 
> KVM's CPU hotplug callbacks are renamed as well.
> 
> Suggested-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> ---
>  include/linux/cpuhotplug.h |  2 +-
>  virt/kvm/kvm_main.c        | 30 ++++++++++++++++++++++--------
>  2 files changed, 23 insertions(+), 9 deletions(-)
> 
> diff --git a/include/linux/cpuhotplug.h b/include/linux/cpuhotplug.h
> index 773c83730906..14d354c8ce35 100644
> --- a/include/linux/cpuhotplug.h
> +++ b/include/linux/cpuhotplug.h
> @@ -182,7 +182,6 @@ enum cpuhp_state {
>  	CPUHP_AP_CSKY_TIMER_STARTING,
>  	CPUHP_AP_TI_GP_TIMER_STARTING,
>  	CPUHP_AP_HYPERV_TIMER_STARTING,
> -	CPUHP_AP_KVM_STARTING,
>  	CPUHP_AP_KVM_ARM_VGIC_INIT_STARTING,
>  	CPUHP_AP_KVM_ARM_VGIC_STARTING,
>  	CPUHP_AP_KVM_ARM_TIMER_STARTING,

This probably needs an ack from Marc.  IIUC, it changes the ordering between generic
KVM enabling hardware and KVM ARM doing its vGIC and timer stuff.

> @@ -200,6 +199,7 @@ enum cpuhp_state {
>  
>  	/* Online section invoked on the hotplugged CPU from the hotplug thread */
>  	CPUHP_AP_ONLINE_IDLE,
> +	CPUHP_AP_KVM_ONLINE,
>  	CPUHP_AP_SCHED_WAIT_EMPTY,
>  	CPUHP_AP_SMPBOOT_THREADS,
>  	CPUHP_AP_X86_VDSO_VMA_ONLINE,
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 23481fd746aa..f60724736cb1 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -4853,13 +4853,27 @@ static void hardware_enable_nolock(void *caller_name)
>  	}
>  }
>  
> -static int kvm_starting_cpu(unsigned int cpu)
> +static int kvm_online_cpu(unsigned int cpu)
>  {
> +	int ret = 0;
> +
>  	raw_spin_lock(&kvm_count_lock);
> -	if (kvm_usage_count)
> +	/*
> +	 * Abort the CPU online process if hardware virtualization cannot
> +	 * be enabled. Otherwise running VMs would encounter unrecoverable
> +	 * errors when scheduled to this CPU.
> +	 */
> +	if (kvm_usage_count) {
> +		WARN_ON_ONCE(atomic_read(&hardware_enable_failed));
> +
>  		hardware_enable_nolock((void *)__func__);
> +		if (atomic_read(&hardware_enable_failed)) {
> +			atomic_set(&hardware_enable_failed, 0);
> +			ret = -EIO;
> +		}
> +	}
>  	raw_spin_unlock(&kvm_count_lock);
> -	return 0;
> +	return ret;
>  }
>  
>  static void hardware_disable_nolock(void *junk)
> @@ -4872,7 +4886,7 @@ static void hardware_disable_nolock(void *junk)
>  	kvm_arch_hardware_disable();
>  }
>  
> -static int kvm_dying_cpu(unsigned int cpu)
> +static int kvm_offline_cpu(unsigned int cpu)
>  {
>  	raw_spin_lock(&kvm_count_lock);
>  	if (kvm_usage_count)
> @@ -5641,8 +5655,8 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
>  			goto out_free_2;
>  	}
>  
> -	r = cpuhp_setup_state_nocalls(CPUHP_AP_KVM_STARTING, "kvm/cpu:starting",
> -				      kvm_starting_cpu, kvm_dying_cpu);
> +	r = cpuhp_setup_state_nocalls(CPUHP_AP_KVM_ONLINE, "kvm/cpu:online",
> +				      kvm_online_cpu, kvm_offline_cpu);
>  	if (r)
>  		goto out_free_2;
>  	register_reboot_notifier(&kvm_reboot_notifier);
> @@ -5705,7 +5719,7 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
>  	kmem_cache_destroy(kvm_vcpu_cache);
>  out_free_3:
>  	unregister_reboot_notifier(&kvm_reboot_notifier);
> -	cpuhp_remove_state_nocalls(CPUHP_AP_KVM_STARTING);
> +	cpuhp_remove_state_nocalls(CPUHP_AP_KVM_ONLINE);
>  out_free_2:
>  	kvm_arch_hardware_unsetup();
>  out_free_1:
> @@ -5731,7 +5745,7 @@ void kvm_exit(void)
>  	kvm_async_pf_deinit();
>  	unregister_syscore_ops(&kvm_syscore_ops);
>  	unregister_reboot_notifier(&kvm_reboot_notifier);
> -	cpuhp_remove_state_nocalls(CPUHP_AP_KVM_STARTING);
> +	cpuhp_remove_state_nocalls(CPUHP_AP_KVM_ONLINE);
>  	on_each_cpu(hardware_disable_nolock, NULL, 1);
>  	kvm_arch_hardware_unsetup();
>  	kvm_arch_exit();
> -- 
> 2.25.1
> 
