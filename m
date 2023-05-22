Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07E6470B82C
	for <lists+kvm@lfdr.de>; Mon, 22 May 2023 10:57:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232671AbjEVI5z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 May 2023 04:57:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232662AbjEVI50 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 May 2023 04:57:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C760AF
        for <kvm@vger.kernel.org>; Mon, 22 May 2023 01:56:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1684745771;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=v4/mES/i+aWv5NPMCuzU07vDqmm6ywd8X/SsDFXQTQU=;
        b=Gr2b8p9TY3nXinpqK8whWKU+Lgg6GoQqTkHm60SBsV2urGc/hVV+SCT8R957af8mTbVXTD
        LaPSjmQtgtCoBQEtTBfNJMb7FpNOs+rWUU9RCAZ/Lk2bm4EnSxub/QNrqWtaeU6GIjTpPL
        NslAo1EcO8BxOLLCsqefhRUp8d1Ooxg=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-647-HBXaRMfTNrWQKqO-bmGPEw-1; Mon, 22 May 2023 04:56:10 -0400
X-MC-Unique: HBXaRMfTNrWQKqO-bmGPEw-1
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-6237c937691so20607376d6.0
        for <kvm@vger.kernel.org>; Mon, 22 May 2023 01:56:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684745769; x=1687337769;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=v4/mES/i+aWv5NPMCuzU07vDqmm6ywd8X/SsDFXQTQU=;
        b=SB86+i2BT6iT7GMrb8z2+IvJOQgp2RR5czZflfcqwhKgsk3DRrD4N+xVMzPbEREnzC
         5buI3rWXGX7qFD3OVKQARrGMle00sjq/Rj9G2vPVYjAWnUD5KcicKXZ8+K5mE+a5NkL3
         eGbqrf1yICqlaKB2aptiAMQSLD5VjsR7ZUF/FZZnCdGMMwwChFQ83euS8mgCwfz6sDjI
         vOJTyKDUKMTwNYPKwhYybRVxIj7fqnR/P/KLSXwHij1Fled30xdJy13sevP4SZXqZ39V
         VWKipxdprnooLnhJIiFVVzic+O7qJnRzVrPDvLosE2qjBBbbCCkSApwQx5MY1tjJVGNR
         Zkpg==
X-Gm-Message-State: AC+VfDytqt26Uk8C/0MXsR/BhZEYCRI43Ztbe9WAajgYI9GdJI9bUiVK
        ll0jamXC+FJ5mQ1omPI4EnbESQqyHHETLcUvAoJiQV1YKdo03pV0wxXp398ukH+B3qEOaAhohzg
        Js+cMXxPD6gnEMl39Aae6F8YAaNWfKWh9IRywEq6rjYDOp1eX+yFNvFy9t1z1RZiCNxOaR64P
X-Received: by 2002:ad4:574f:0:b0:61b:58ec:24c8 with SMTP id q15-20020ad4574f000000b0061b58ec24c8mr19041582qvx.10.1684745769663;
        Mon, 22 May 2023 01:56:09 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6uniPtYnrTfdnta4PkKXkaaURbeQlrK+ltmlFW9A16ZWTL6u653yf9McI3kMPgTvMlDD4Mow==
X-Received: by 2002:ad4:574f:0:b0:61b:58ec:24c8 with SMTP id q15-20020ad4574f000000b0061b58ec24c8mr19041550qvx.10.1684745769306;
        Mon, 22 May 2023 01:56:09 -0700 (PDT)
Received: from fedora (g2.ign.cz. [91.219.240.8])
        by smtp.gmail.com with ESMTPSA id f28-20020ad4559c000000b0061f7cf8207asm1810803qvx.133.2023.05.22.01.56.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 May 2023 01:56:08 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Michael Kelley <mikelley@microsoft.com>
Cc:     mikelley@microsoft.com, kys@microsoft.com, haiyangz@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, catalin.marinas@arm.com,
        will@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, x86@kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH 1/2] x86/hyperv: Fix hyperv_pcpu_input_arg handling when
 CPUs go online/offline
In-Reply-To: <1684506832-41392-1-git-send-email-mikelley@microsoft.com>
References: <1684506832-41392-1-git-send-email-mikelley@microsoft.com>
Date:   Mon, 22 May 2023 10:56:05 +0200
Message-ID: <87o7mczqvu.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Michael Kelley <mikelley@microsoft.com> writes:

> These commits
>
> a494aef23dfc ("PCI: hv: Replace retarget_msi_interrupt_params with hyperv_pcpu_input_arg")
> 2c6ba4216844 ("PCI: hv: Enable PCI pass-thru devices in Confidential VMs")
>
> update the Hyper-V virtual PCI driver to use the hyperv_pcpu_input_arg
> because that memory will be correctly marked as decrypted or encrypted
> for all VM types (CoCo or normal). But problems ensue when CPUs in the
> VM go online or offline after virtual PCI devices have been configured.
>
> When a CPU is brought online, the hyperv_pcpu_input_arg for that CPU is
> initialized by hv_cpu_init() running under state CPUHP_AP_ONLINE_DYN.
> But this state occurs after state CPUHP_AP_IRQ_AFFINITY_ONLINE, which
> may call the virtual PCI driver and fault trying to use the as yet
> uninitialized hyperv_pcpu_input_arg. A similar problem occurs in a CoCo
> VM if the MMIO read and write hypercalls are used from state
> CPUHP_AP_IRQ_AFFINITY_ONLINE.
>
> When a CPU is taken offline, IRQs may be reassigned in state
> CPUHP_TEARDOWN_CPU. Again, the virtual PCI driver may fault trying to
> use the hyperv_pcpu_input_arg that has already been freed by a
> higher state.
>
> Fix the onlining problem by adding state CPUHP_AP_HYPERV_ONLINE
> immediately after CPUHP_AP_ONLINE_IDLE (similar to CPUHP_AP_KVM_ONLINE)
> and before CPUHP_AP_IRQ_AFFINITY_ONLINE. Use this new state for
> Hyper-V initialization so that hyperv_pcpu_input_arg is allocated
> early enough.
>
> Fix the offlining problem by not freeing hyperv_pcpu_input_arg when
> a CPU goes offline. Retain the allocated memory, and reuse it if
> the CPU comes back online later.
>
> Signed-off-by: Michael Kelley <mikelley@microsoft.com>
> ---
>  arch/x86/hyperv/hv_init.c  |  2 +-
>  drivers/hv/hv_common.c     | 48 +++++++++++++++++++++++-----------------------
>  include/linux/cpuhotplug.h |  1 +
>  3 files changed, 26 insertions(+), 25 deletions(-)
>
> diff --git a/arch/x86/hyperv/hv_init.c b/arch/x86/hyperv/hv_init.c
> index a5f9474..6c04b52 100644
> --- a/arch/x86/hyperv/hv_init.c
> +++ b/arch/x86/hyperv/hv_init.c
> @@ -416,7 +416,7 @@ void __init hyperv_init(void)
>  			goto free_vp_assist_page;
>  	}
>  
> -	cpuhp = cpuhp_setup_state(CPUHP_AP_ONLINE_DYN, "x86/hyperv_init:online",
> +	cpuhp = cpuhp_setup_state(CPUHP_AP_HYPERV_ONLINE, "x86/hyperv_init:online",
>  				  hv_cpu_init, hv_cpu_die);
>  	if (cpuhp < 0)
>  		goto free_ghcb_page;
> diff --git a/drivers/hv/hv_common.c b/drivers/hv/hv_common.c
> index 64f9cec..4c5cee4 100644
> --- a/drivers/hv/hv_common.c
> +++ b/drivers/hv/hv_common.c
> @@ -364,13 +364,20 @@ int hv_common_cpu_init(unsigned int cpu)
>  	flags = irqs_disabled() ? GFP_ATOMIC : GFP_KERNEL;
>  
>  	inputarg = (void **)this_cpu_ptr(hyperv_pcpu_input_arg);
> -	*inputarg = kmalloc(pgcount * HV_HYP_PAGE_SIZE, flags);
> -	if (!(*inputarg))
> -		return -ENOMEM;
>  
> -	if (hv_root_partition) {
> -		outputarg = (void **)this_cpu_ptr(hyperv_pcpu_output_arg);
> -		*outputarg = (char *)(*inputarg) + HV_HYP_PAGE_SIZE;
> +	/*
> +	 * hyperv_pcpu_input_arg and hyperv_pcpu_output_arg memory is already
> +	 * allocated if this CPU was previously online and then taken offline
> +	 */
> +	if (!*inputarg) {
> +		*inputarg = kmalloc(pgcount * HV_HYP_PAGE_SIZE, flags);
> +		if (!(*inputarg))
> +			return -ENOMEM;
> +
> +		if (hv_root_partition) {
> +			outputarg = (void **)this_cpu_ptr(hyperv_pcpu_output_arg);
> +			*outputarg = (char *)(*inputarg) + HV_HYP_PAGE_SIZE;
> +		}
>  	}
>  
>  	msr_vp_index = hv_get_register(HV_REGISTER_VP_INDEX);
> @@ -385,24 +392,17 @@ int hv_common_cpu_init(unsigned int cpu)
>  
>  int hv_common_cpu_die(unsigned int cpu)
>  {
> -	unsigned long flags;
> -	void **inputarg, **outputarg;
> -	void *mem;
> -
> -	local_irq_save(flags);
> -
> -	inputarg = (void **)this_cpu_ptr(hyperv_pcpu_input_arg);
> -	mem = *inputarg;
> -	*inputarg = NULL;
> -
> -	if (hv_root_partition) {
> -		outputarg = (void **)this_cpu_ptr(hyperv_pcpu_output_arg);
> -		*outputarg = NULL;
> -	}
> -
> -	local_irq_restore(flags);
> -
> -	kfree(mem);
> +	/*
> +	 * The hyperv_pcpu_input_arg and hyperv_pcpu_output_arg memory
> +	 * is not freed when the CPU goes offline as the hyperv_pcpu_input_arg
> +	 * may be used by the Hyper-V vPCI driver in reassigning interrupts
> +	 * as part of the offlining process.  The interrupt reassignment
> +	 * happens *after* the CPUHP_AP_HYPERV_ONLINE state has run and
> +	 * called this function.
> +	 *
> +	 * If a previously offlined CPU is brought back online again, the
> +	 * originally allocated memory is reused in hv_common_cpu_init().
> +	 */
>  
>  	return 0;
>  }
> diff --git a/include/linux/cpuhotplug.h b/include/linux/cpuhotplug.h
> index 0f1001d..696004a 100644
> --- a/include/linux/cpuhotplug.h
> +++ b/include/linux/cpuhotplug.h
> @@ -201,6 +201,7 @@ enum cpuhp_state {
>  	/* Online section invoked on the hotplugged CPU from the hotplug thread */
>  	CPUHP_AP_ONLINE_IDLE,
>  	CPUHP_AP_KVM_ONLINE,
> +	CPUHP_AP_HYPERV_ONLINE,

(Cc: KVM)

I would very much prefer we swap the order with KVM here: hv_cpu_init()
allocates and sets vCPU's VP assist page which is used by KVM on
CPUHP_AP_KVM_ONLINE:

kvm_online_cpu() -> __hardware_enable_nolock() ->
kvm_arch_hardware_enable() -> vmx_hardware_enable():

        /*
         * This can happen if we hot-added a CPU but failed to allocate
         * VP assist page for it.
         */
	if (kvm_is_using_evmcs() && !hv_get_vp_assist_page(cpu))
		return -EFAULT;

With the change, this is likely broken.

FWIF, KVM also needs current vCPU's VP index (also set by hv_cpu_init())
through __kvm_x86_vendor_init() -> set_hv_tscchange_cb() call chain but
this happens upon KVM module load so CPU hotplug ordering should not
matter as this always happens on a CPU which is already online.

Generally, as 'KVM on Hyper-V' is a supported scenario, doing Hyper-V
init before KVM's (and vice versa on teardown) makes sense.

>  	CPUHP_AP_SCHED_WAIT_EMPTY,
>  	CPUHP_AP_SMPBOOT_THREADS,
>  	CPUHP_AP_X86_VDSO_VMA_ONLINE,

-- 
Vitaly

