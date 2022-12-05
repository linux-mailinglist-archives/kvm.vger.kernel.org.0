Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9956A64361B
	for <lists+kvm@lfdr.de>; Mon,  5 Dec 2022 21:52:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232831AbiLEUww (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Dec 2022 15:52:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232516AbiLEUwv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Dec 2022 15:52:51 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82760B1FD;
        Mon,  5 Dec 2022 12:52:49 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id g1so4543092pfk.2;
        Mon, 05 Dec 2022 12:52:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=N16dq1CjYHOw+jv6Di6rohy5xmWMqcOUPt5c96rryYM=;
        b=YfFvmGBbFyecNX7HuYSwK+aGIglSOKNXdG/GyCa5qUzLMOe/bS3LGfF0q9vWX+ZfHt
         3Z92dtbJE772PsZ/NJy5FRdBdPEPZm5rcU7jdu4sFmCGP/7IKFYS0/CsqrcgEPVmen5V
         y6ej8cIOWvXwaBIve/M5ONQiyIWsJPUuFBVbweXevgwwGb/E9u9wEIP6iF6QJbkluoas
         PAiChapsuF6enaxC+tqdFRIctA1WbhgM/AjJeBOJlUlozWnDnw8Sd2pTj6YzSHsPtsBl
         J/2/tufxjQZdaKhz5ClxSt9r4yMQhCI1VtASfuD1Pfedea9GvzKUkPwh7azEivUucBcM
         puDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N16dq1CjYHOw+jv6Di6rohy5xmWMqcOUPt5c96rryYM=;
        b=AnCXOHGZg3yVONehfxPsFq78G4U5wkuLHE1fkuG890QT2bDBB889jV9ifdTJQQobn5
         jLczRYoQcbqnigJy5QV2ODs7n3AlqxCkWre2i4LK9Uppu32NjRd9PXdqhpLJj2S1JA5i
         x6mCoILwWBuSUuHOFw+oszkI2PToYoQZ1xNfjLkFOf692dhw7VsxQ6+UrF+P94ZV4qSs
         9vty0B6edBRjFk+CNOl5/WmqBEO3I7J5IOfi8q5dwLWCqfvDutJGfWkaqeckajrmN1R1
         aPykmfoolFcJvXtJxKsGM5gjvmOpwFZOibbs6hlROGuC37oorL10j8aW0LrFq+UB/hZ4
         nvEA==
X-Gm-Message-State: ANoB5pk1U104SMWUZlf30dOcuMJknrTvnJMJv2DgjXbX/rW34krpKe/A
        JSw4E7JyVzY70Jmr2yCsuCY=
X-Google-Smtp-Source: AA0mqf4HpL3/0El3PrCiEsjkXuyAuKLQ7k5vbcFuFyn7/o3SL661WsLVyVHRUVAGEIBg3Ob2/Ax1ug==
X-Received: by 2002:a05:6a00:4097:b0:576:cadf:16cc with SMTP id bw23-20020a056a00409700b00576cadf16ccmr9458181pfb.55.1670273568627;
        Mon, 05 Dec 2022 12:52:48 -0800 (PST)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id f3-20020a170902ce8300b001780e4e6b65sm11105896plg.114.2022.12.05.12.52.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Dec 2022 12:52:47 -0800 (PST)
Date:   Mon, 5 Dec 2022 12:52:46 -0800
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Paul Durrant <paul@xen.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Atish Patra <atishp@atishpatra.org>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yuan Yao <yuan.yao@intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, isaku.yamahata@gmail.com
Subject: Re: [PATCH v2 31/50] KVM: x86: Do CPU compatibility checks in x86
 code
Message-ID: <20221205205246.GA3630770@ls.amr.corp.intel.com>
References: <20221130230934.1014142-1-seanjc@google.com>
 <20221130230934.1014142-32-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221130230934.1014142-32-seanjc@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 30, 2022 at 11:09:15PM +0000,
Sean Christopherson <seanjc@google.com> wrote:

> Move the CPU compatibility checks to pure x86 code, i.e. drop x86's use
> of the common kvm_x86_check_cpu_compat() arch hook.  x86 is the only
> architecture that "needs" to do per-CPU compatibility checks, moving
> the logic to x86 will allow dropping the common code, and will also
> give x86 more control over when/how the compatibility checks are
> performed, e.g. TDX will need to enable hardware (do VMXON) in order to
> perform compatibility checks.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/svm/svm.c |  2 +-
>  arch/x86/kvm/vmx/vmx.c |  2 +-
>  arch/x86/kvm/x86.c     | 49 ++++++++++++++++++++++++++++++++----------
>  3 files changed, 40 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 19e81a99c58f..d7ea1c1175c2 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -5103,7 +5103,7 @@ static int __init svm_init(void)
>  	 * Common KVM initialization _must_ come last, after this, /dev/kvm is
>  	 * exposed to userspace!
>  	 */
> -	r = kvm_init(&svm_init_ops, sizeof(struct vcpu_svm),
> +	r = kvm_init(NULL, sizeof(struct vcpu_svm),
>  		     __alignof__(struct vcpu_svm), THIS_MODULE);
>  	if (r)
>  		goto err_kvm_init;
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 654d81f781da..8deb1bd60c10 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -8592,7 +8592,7 @@ static int __init vmx_init(void)
>  	 * Common KVM initialization _must_ come last, after this, /dev/kvm is
>  	 * exposed to userspace!
>  	 */
> -	r = kvm_init(&vmx_init_ops, sizeof(struct vcpu_vmx),
> +	r = kvm_init(NULL, sizeof(struct vcpu_vmx),
>  		     __alignof__(struct vcpu_vmx), THIS_MODULE);
>  	if (r)
>  		goto err_kvm_init;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 66f16458aa97..3571bc968cf8 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9277,10 +9277,36 @@ static inline void kvm_ops_update(struct kvm_x86_init_ops *ops)
>  	kvm_pmu_ops_update(ops->pmu_ops);
>  }
>  
> +struct kvm_cpu_compat_check {
> +	struct kvm_x86_init_ops *ops;
> +	int *ret;

minor nitpick: just int ret. I don't see the necessity of the pointer.
Anyway overall it looks good to me.

Reviewed-by: Isaku Yamahata <isaku.yamahata@intel.com>

> +};
> +
> +static int kvm_x86_check_processor_compatibility(struct kvm_x86_init_ops *ops)
> +{
> +	struct cpuinfo_x86 *c = &cpu_data(smp_processor_id());
> +
> +	WARN_ON(!irqs_disabled());
> +
> +	if (__cr4_reserved_bits(cpu_has, c) !=
> +	    __cr4_reserved_bits(cpu_has, &boot_cpu_data))
> +		return -EIO;
> +
> +	return ops->check_processor_compatibility();
> +}
> +
> +static void kvm_x86_check_cpu_compat(void *data)
> +{
> +	struct kvm_cpu_compat_check *c = data;
> +
> +	*c->ret = kvm_x86_check_processor_compatibility(c->ops);
> +}
> +
>  static int __kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
>  {
> +	struct kvm_cpu_compat_check c;
>  	u64 host_pat;
> -	int r;
> +	int r, cpu;
>  
>  	if (kvm_x86_ops.hardware_enable) {
>  		pr_err("kvm: already loaded vendor module '%s'\n", kvm_x86_ops.name);
> @@ -9360,6 +9386,14 @@ static int __kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
>  	if (r != 0)
>  		goto out_mmu_exit;
>  
> +	c.ret = &r;
> +	c.ops = ops;
> +	for_each_online_cpu(cpu) {
> +		smp_call_function_single(cpu, kvm_x86_check_cpu_compat, &c, 1);
> +		if (r < 0)

Here it can be "c.ret < 0".

> +			goto out_hardware_unsetup;
> +	}
> +
>  	/*
>  	 * Point of no return!  DO NOT add error paths below this point unless
>  	 * absolutely necessary, as most operations from this point forward
> @@ -9402,6 +9436,8 @@ static int __kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
>  	kvm_init_msr_list();
>  	return 0;
>  
> +out_hardware_unsetup:
> +	ops->runtime_ops->hardware_unsetup();
>  out_mmu_exit:
>  	kvm_mmu_vendor_module_exit();
>  out_free_percpu:
> @@ -12037,16 +12073,7 @@ void kvm_arch_hardware_disable(void)
>  
>  int kvm_arch_check_processor_compat(void *opaque)
>  {
> -	struct cpuinfo_x86 *c = &cpu_data(smp_processor_id());
> -	struct kvm_x86_init_ops *ops = opaque;
> -
> -	WARN_ON(!irqs_disabled());
> -
> -	if (__cr4_reserved_bits(cpu_has, c) !=
> -	    __cr4_reserved_bits(cpu_has, &boot_cpu_data))
> -		return -EIO;
> -
> -	return ops->check_processor_compatibility();
> +	return 0;
>  }
>  
>  bool kvm_vcpu_is_reset_bsp(struct kvm_vcpu *vcpu)
> -- 
> 2.38.1.584.g0f3c55d4c2-goog
> 

-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
