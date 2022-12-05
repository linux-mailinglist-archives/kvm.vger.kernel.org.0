Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AEB0643665
	for <lists+kvm@lfdr.de>; Mon,  5 Dec 2022 22:06:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232491AbiLEVF3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Dec 2022 16:05:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233854AbiLEVEu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Dec 2022 16:04:50 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2D7625FD;
        Mon,  5 Dec 2022 13:04:32 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id r18so11549589pgr.12;
        Mon, 05 Dec 2022 13:04:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CWvVJvThv0gHUKwPAYQk+SufNWdeMUwtwKNDHUXMgJo=;
        b=OcIx5RVeRcYhCg+P/yyeEn2/AXirrXP0zxi2pf1d/28freUOc/av5SpULT83ZYM8AR
         myc4dnMmPvHE3jr9vcMMddRLLxkacLFeezE+c+0Zlk3o2XgIC/SMH/vIw+KdFzsH+uLv
         WslAdKHSS5vTfioTTvoXFJtUWq6WhztGkGjsEKhAgabT7R5Ieb8WVI6xl33PlPHqcfIi
         5B0Kux04QuiFV9IqZsVC19eU6rs/NgXg47yfzs8oRnuZ1wuvub8h8tAQVBb/ZvGALZMP
         YvJcH+YOzWY8rXNN7G7QDkbWwWbaUwJz7IUH44ZL4cbmG8Jok0SlgS1GSdcQQ517m8Db
         DWkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CWvVJvThv0gHUKwPAYQk+SufNWdeMUwtwKNDHUXMgJo=;
        b=xFHWcvoDXBnMThrBVG2d6bGti0DSV+nSW1RMSEAwaAqTYIRTYHEcfY3xzoVoNCAp3c
         GXhfdRDQnOxGW9azSiEN2ucVPv7uzKNVNnjRoS1YFhpQfpYasxjqJdBjRk6Nzv4Vzge6
         tCwMuwj/lzxK7OznejePIfp5Ee15nnX08jgdtFfUZ6nCpzlQxO9VpCWo4Km+qGY0eAyM
         9PXIFhPklfDl9JXg2G1boQ31r2w4X5qzYR4JmIhRBOj57bSl3D20xZxhiW1PHu+SaWQ6
         a1UZ5S2FJ6gUKnLucMo3SvC1m+eZw9hecutNL0hOdHyGNr36A9iGXe4hdLho10db5jmg
         bRmw==
X-Gm-Message-State: ANoB5pmS/LewMSUQKIHrtlpmZGgy+hQZ54HchYPw8mSGPx/427gbRuud
        Xe2qjW3jjqt27/TNzUD59ho=
X-Google-Smtp-Source: AA0mqf4ROaywPtc8c32MAZXixhdmTVHwrr18hdjaI5ELGretvCHmlK5VCycNuwcuIvkq+nizmYnPRg==
X-Received: by 2002:a05:6a00:4286:b0:56d:3de3:c525 with SMTP id bx6-20020a056a00428600b0056d3de3c525mr63424774pfb.41.1670274271914;
        Mon, 05 Dec 2022 13:04:31 -0800 (PST)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id e4-20020a056a0000c400b0057709fce782sm1860045pfj.54.2022.12.05.13.04.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Dec 2022 13:04:31 -0800 (PST)
Date:   Mon, 5 Dec 2022 13:04:30 -0800
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
Subject: Re: [PATCH v2 39/50] KVM: x86: Move CPU compat checks hook to
 kvm_x86_ops (from kvm_x86_init_ops)
Message-ID: <20221205210430.GB3630770@ls.amr.corp.intel.com>
References: <20221130230934.1014142-1-seanjc@google.com>
 <20221130230934.1014142-40-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221130230934.1014142-40-seanjc@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 30, 2022 at 11:09:23PM +0000,
Sean Christopherson <seanjc@google.com> wrote:

> Move the .check_processor_compatibility() callback from kvm_x86_init_ops
> to kvm_x86_ops to allow a future patch to do compatibility checks during
> CPU hotplug.
> 
> Do kvm_ops_update() before compat checks so that static_call() can be
> used during compat checks.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/include/asm/kvm-x86-ops.h |  1 +
>  arch/x86/include/asm/kvm_host.h    |  3 ++-
>  arch/x86/kvm/svm/svm.c             |  5 +++--
>  arch/x86/kvm/vmx/vmx.c             | 16 +++++++--------
>  arch/x86/kvm/x86.c                 | 31 +++++++++++-------------------
>  5 files changed, 25 insertions(+), 31 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> index abccd51dcfca..dba2909e5ae2 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -14,6 +14,7 @@ BUILD_BUG_ON(1)
>   * to make a definition optional, but in this case the default will
>   * be __static_call_return0.
>   */
> +KVM_X86_OP(check_processor_compatibility)
>  KVM_X86_OP(hardware_enable)
>  KVM_X86_OP(hardware_disable)
>  KVM_X86_OP(hardware_unsetup)
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index d79aedf70908..ba74fea6850b 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1518,6 +1518,8 @@ static inline u16 kvm_lapic_irq_dest_mode(bool dest_mode_logical)
>  struct kvm_x86_ops {
>  	const char *name;
>  
> +	int (*check_processor_compatibility)(void);
> +
>  	int (*hardware_enable)(void);
>  	void (*hardware_disable)(void);
>  	void (*hardware_unsetup)(void);
> @@ -1729,7 +1731,6 @@ struct kvm_x86_nested_ops {
>  };
>  
>  struct kvm_x86_init_ops {
> -	int (*check_processor_compatibility)(void);
>  	int (*hardware_setup)(void);
>  	unsigned int (*handle_intel_pt_intr)(void);
>  
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 9f94efcb9aa6..c2e95c0d9fd8 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -543,7 +543,7 @@ static bool kvm_is_svm_supported(void)
>  	return true;
>  }
>  
> -static int __init svm_check_processor_compat(void)
> +static int svm_check_processor_compat(void)
>  {
>  	if (!kvm_is_svm_supported())
>  		return -EIO;
> @@ -4695,6 +4695,8 @@ static int svm_vm_init(struct kvm *kvm)
>  static struct kvm_x86_ops svm_x86_ops __initdata = {
>  	.name = KBUILD_MODNAME,
>  
> +	.check_processor_compatibility = svm_check_processor_compat,
> +
>  	.hardware_unsetup = svm_hardware_unsetup,
>  	.hardware_enable = svm_hardware_enable,
>  	.hardware_disable = svm_hardware_disable,
> @@ -5079,7 +5081,6 @@ static __init int svm_hardware_setup(void)
>  
>  static struct kvm_x86_init_ops svm_init_ops __initdata = {
>  	.hardware_setup = svm_hardware_setup,
> -	.check_processor_compatibility = svm_check_processor_compat,
>  
>  	.runtime_ops = &svm_x86_ops,
>  	.pmu_ops = &amd_pmu_ops,
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 2a8a6e481c76..6416ed5b7f89 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2520,8 +2520,7 @@ static bool cpu_has_perf_global_ctrl_bug(void)
>  	return false;
>  }
>  
> -static __init int adjust_vmx_controls(u32 ctl_min, u32 ctl_opt,
> -				      u32 msr, u32 *result)
> +static int adjust_vmx_controls(u32 ctl_min, u32 ctl_opt, u32 msr, u32 *result)
>  {
>  	u32 vmx_msr_low, vmx_msr_high;
>  	u32 ctl = ctl_min | ctl_opt;
> @@ -2539,7 +2538,7 @@ static __init int adjust_vmx_controls(u32 ctl_min, u32 ctl_opt,
>  	return 0;
>  }
>  
> -static __init u64 adjust_vmx_controls64(u64 ctl_opt, u32 msr)
> +static u64 adjust_vmx_controls64(u64 ctl_opt, u32 msr)
>  {
>  	u64 allowed;
>  
> @@ -2548,8 +2547,8 @@ static __init u64 adjust_vmx_controls64(u64 ctl_opt, u32 msr)
>  	return  ctl_opt & allowed;
>  }
>  
> -static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
> -				    struct vmx_capability *vmx_cap)
> +static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
> +			     struct vmx_capability *vmx_cap)
>  {
>  	u32 vmx_msr_low, vmx_msr_high;
>  	u32 _pin_based_exec_control = 0;
> @@ -2710,7 +2709,7 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
>  	return 0;
>  }
>  
> -static bool __init kvm_is_vmx_supported(void)
> +static bool kvm_is_vmx_supported(void)
>  {
>  	if (!cpu_has_vmx()) {
>  		pr_err("CPU doesn't support VMX\n");
> @@ -2726,7 +2725,7 @@ static bool __init kvm_is_vmx_supported(void)
>  	return true;
>  }
>  
> -static int __init vmx_check_processor_compat(void)
> +static int vmx_check_processor_compat(void)
>  {
>  	struct vmcs_config vmcs_conf;
>  	struct vmx_capability vmx_cap;
> @@ -8104,6 +8103,8 @@ static void vmx_vm_destroy(struct kvm *kvm)
>  static struct kvm_x86_ops vmx_x86_ops __initdata = {
>  	.name = KBUILD_MODNAME,
>  
> +	.check_processor_compatibility = vmx_check_processor_compat,
> +
>  	.hardware_unsetup = vmx_hardware_unsetup,
>  
>  	.hardware_enable = vmx_hardware_enable,
> @@ -8501,7 +8502,6 @@ static __init int hardware_setup(void)
>  }
>  
>  static struct kvm_x86_init_ops vmx_init_ops __initdata = {
> -	.check_processor_compatibility = vmx_check_processor_compat,
>  	.hardware_setup = hardware_setup,
>  	.handle_intel_pt_intr = NULL,
>  
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 5551f3552f08..ee9af412ffd4 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9279,12 +9279,7 @@ static inline void kvm_ops_update(struct kvm_x86_init_ops *ops)
>  	kvm_pmu_ops_update(ops->pmu_ops);
>  }
>  
> -struct kvm_cpu_compat_check {
> -	struct kvm_x86_init_ops *ops;
> -	int *ret;
> -};
> -
> -static int kvm_x86_check_processor_compatibility(struct kvm_x86_init_ops *ops)
> +static int kvm_x86_check_processor_compatibility(void)
>  {
>  	struct cpuinfo_x86 *c = &cpu_data(smp_processor_id());
>  
> @@ -9294,19 +9289,16 @@ static int kvm_x86_check_processor_compatibility(struct kvm_x86_init_ops *ops)
>  	    __cr4_reserved_bits(cpu_has, &boot_cpu_data))
>  		return -EIO;
>  
> -	return ops->check_processor_compatibility();
> +	return static_call(kvm_x86_check_processor_compatibility)();
>  }
>  
> -static void kvm_x86_check_cpu_compat(void *data)
> +static void kvm_x86_check_cpu_compat(void *ret)
>  {
> -	struct kvm_cpu_compat_check *c = data;
> -
> -	*c->ret = kvm_x86_check_processor_compatibility(c->ops);
> +	*(int *)ret = kvm_x86_check_processor_compatibility();
>  }
>  
>  static int __kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
>  {
> -	struct kvm_cpu_compat_check c;
>  	u64 host_pat;
>  	int r, cpu;
>  
> @@ -9377,12 +9369,12 @@ static int __kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
>  	if (r != 0)
>  		goto out_mmu_exit;
>  
> -	c.ret = &r;
> -	c.ops = ops;
> +	kvm_ops_update(ops);
> +
>  	for_each_online_cpu(cpu) {
> -		smp_call_function_single(cpu, kvm_x86_check_cpu_compat, &c, 1);
> +		smp_call_function_single(cpu, kvm_x86_check_cpu_compat, &r, 1);

Ah, here pointer makes sense. So I scratch the comment on the previous patch.

Thanks,

>  		if (r < 0)
> -			goto out_hardware_unsetup;
> +			goto out_unwind_ops;
>  	}
>  
>  	/*
> @@ -9390,8 +9382,6 @@ static int __kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
>  	 * absolutely necessary, as most operations from this point forward
>  	 * require unwinding.
>  	 */
> -	kvm_ops_update(ops);
> -
>  	kvm_timer_init();
>  
>  	if (pi_inject_timer == -1)
> @@ -9427,8 +9417,9 @@ static int __kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
>  	kvm_init_msr_list();
>  	return 0;
>  
> -out_hardware_unsetup:
> -	ops->runtime_ops->hardware_unsetup();
> +out_unwind_ops:
> +	kvm_x86_ops.hardware_enable = NULL;
> +	static_call(kvm_x86_hardware_unsetup)();
>  out_mmu_exit:
>  	kvm_mmu_vendor_module_exit();
>  out_free_percpu:
> -- 
> 2.38.1.584.g0f3c55d4c2-goog
> 

-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
