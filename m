Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51E9218F41B
	for <lists+kvm@lfdr.de>; Mon, 23 Mar 2020 13:10:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727417AbgCWMKr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Mar 2020 08:10:47 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:23313 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727351AbgCWMKr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 23 Mar 2020 08:10:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584965446;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rHQRdviv+oNnM+wOvy7j9QWQo0zwjiFN+uLtW4Mvpq0=;
        b=e6HzwObd5VmQ/zLiFfyo2IME5xSkuxBVbWuhSmky7vXcJLBVysvzqxA+qMlra5n8/vUrOc
        9/+8dePyeNnnM3NmisMlLq08e2OxgoL8+qjlPUTmKhyE7nx+pcIEGKGcOAtTgEpMhxS396
        amyyD97S5NEi1Dp0tF9mMpQdOQZwSlc=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-239-hiGeZ_m3NlKO2Z8rbhCeRg-1; Mon, 23 Mar 2020 08:10:45 -0400
X-MC-Unique: hiGeZ_m3NlKO2Z8rbhCeRg-1
Received: by mail-wm1-f72.google.com with SMTP id f9so3919720wme.7
        for <kvm@vger.kernel.org>; Mon, 23 Mar 2020 05:10:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=rHQRdviv+oNnM+wOvy7j9QWQo0zwjiFN+uLtW4Mvpq0=;
        b=qOkV/URcSEh3mA+hmvyuu47bUjYD4jan6HnmeybNxvCA+/c0dOCqOhujTqk4OiZ4R9
         GWMoTwzhLKlXjc/LsZ3t8aB21Po3sbLe/bNw4VgedZHLCcbl1AE8Gpal1OOztmN2mWFD
         sKW7FVCN84NGB37i8HihiKExbM0mW4UvBuS66mk4YIvAgZntoLJVLLr2nBtHJ/EgXVb6
         TLF8vtnhmJgcGA34QmS0ogYfyEm5dvIH/5whWBHXzgQ73N2IY8d/rHh255g1V1O9pyTI
         spD/QJ2Dk4Bnn2TA0fEfh3hffwxcpvqcDUHJHYNDky9nrxqP7BgcpOg8OMjT7O0dHjZ8
         yRQw==
X-Gm-Message-State: ANhLgQ3gJySe7iX4N8chSFTC+qwtsLVYZ30iLRY/9amN0TTh0dWmqU/N
        2iQP21ADat3CdrpjIUb98uFHIcDmnLSvBG6Gb57wXi5xd8/TODQNbtmXXghDRnyJJ6fqVM7odIx
        2cYGchClO9KfB
X-Received: by 2002:adf:f7ce:: with SMTP id a14mr30662462wrq.180.1584965443485;
        Mon, 23 Mar 2020 05:10:43 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vsLu0mWmhCib7a9L9Z4UgbCUMlvtjWeM7CpEh6ia2EdDdwqHhRYkq8ynpPTFBq7OzYIQ6wpBQ==
X-Received: by 2002:adf:f7ce:: with SMTP id a14mr30662429wrq.180.1584965443217;
        Mon, 23 Mar 2020 05:10:43 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id m7sm957131wro.41.2020.03.23.05.10.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2020 05:10:42 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/9] KVM: x86: Move init-only kvm_x86_ops to separate struct
In-Reply-To: <20200321202603.19355-3-sean.j.christopherson@intel.com>
References: <20200321202603.19355-1-sean.j.christopherson@intel.com> <20200321202603.19355-3-sean.j.christopherson@intel.com>
Date:   Mon, 23 Mar 2020 13:10:40 +0100
Message-ID: <87lfnr9sqn.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Move the kvm_x86_ops functions that are used only within the scope of
> kvm_init() into a separate struct, kvm_x86_init_ops.  In addition to
> identifying the init-only functions without restorting to code comments,
> this also sets the stage for waiting until after ->hardware_setup() to
> set kvm_x86_ops.  Setting kvm_x86_ops after ->hardware_setup() is
> desirable as many of the hooks are not usable until ->hardware_setup()
> completes.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 13 +++++++++----
>  arch/x86/kvm/svm.c              | 15 ++++++++++-----
>  arch/x86/kvm/vmx/vmx.c          | 16 +++++++++++-----
>  arch/x86/kvm/x86.c              | 10 ++++++----
>  4 files changed, 36 insertions(+), 18 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 9a183e9d4cb1..f4c5b49299ff 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1054,12 +1054,8 @@ static inline u16 kvm_lapic_irq_dest_mode(bool dest_mode_logical)
>  }
>  
>  struct kvm_x86_ops {
> -	int (*cpu_has_kvm_support)(void);          /* __init */
> -	int (*disabled_by_bios)(void);             /* __init */
>  	int (*hardware_enable)(void);
>  	void (*hardware_disable)(void);
> -	int (*check_processor_compatibility)(void);/* __init */
> -	int (*hardware_setup)(void);               /* __init */
>  	void (*hardware_unsetup)(void);            /* __exit */
>  	bool (*cpu_has_accelerated_tpr)(void);
>  	bool (*has_emulated_msr)(int index);
> @@ -1260,6 +1256,15 @@ struct kvm_x86_ops {
>  	int (*enable_direct_tlbflush)(struct kvm_vcpu *vcpu);
>  };
>  
> +struct kvm_x86_init_ops {
> +	int (*cpu_has_kvm_support)(void);
> +	int (*disabled_by_bios)(void);
> +	int (*check_processor_compatibility)(void);
> +	int (*hardware_setup)(void);
> +
> +	struct kvm_x86_ops *runtime_ops;
> +};
> +
>  struct kvm_arch_async_pf {
>  	u32 token;
>  	gfn_t gfn;
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 2125c6ae5951..33e67c3389c2 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -7351,11 +7351,7 @@ static void svm_pre_update_apicv_exec_ctrl(struct kvm *kvm, bool activate)
>  }
>  
>  static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
> -	.cpu_has_kvm_support = has_svm,
> -	.disabled_by_bios = is_disabled,
> -	.hardware_setup = svm_hardware_setup,
>  	.hardware_unsetup = svm_hardware_teardown,
> -	.check_processor_compatibility = svm_check_processor_compat,
>  	.hardware_enable = svm_hardware_enable,
>  	.hardware_disable = svm_hardware_disable,
>  	.cpu_has_accelerated_tpr = svm_cpu_has_accelerated_tpr,
> @@ -7480,9 +7476,18 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
>  	.check_nested_events = svm_check_nested_events,
>  };
>  
> +static struct kvm_x86_init_ops svm_init_ops __initdata = {
> +	.cpu_has_kvm_support = has_svm,
> +	.disabled_by_bios = is_disabled,
> +	.hardware_setup = svm_hardware_setup,
> +	.check_processor_compatibility = svm_check_processor_compat,
> +
> +	.runtime_ops = &svm_x86_ops,
> +};

Unrelated to your patch but I think we can make the naming of some of
these functions more consistend on SVM/VMX, in particular I'd suggest 

has_svm() -> cpu_has_svm_support()
is_disabled -> svm_disabled_by_bios()
...
(see below for VMX)

> +
>  static int __init svm_init(void)
>  {
> -	return kvm_init(&svm_x86_ops, sizeof(struct vcpu_svm),
> +	return kvm_init(&svm_init_ops, sizeof(struct vcpu_svm),
>  			__alignof__(struct vcpu_svm), THIS_MODULE);
>  }
>  
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 07299a957d4a..ffcdcc86f5b7 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7842,11 +7842,8 @@ static bool vmx_check_apicv_inhibit_reasons(ulong bit)
>  }
>  
>  static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
> -	.cpu_has_kvm_support = cpu_has_kvm_support,
> -	.disabled_by_bios = vmx_disabled_by_bios,
> -	.hardware_setup = hardware_setup,
>  	.hardware_unsetup = hardware_unsetup,
> -	.check_processor_compatibility = vmx_check_processor_compat,
> +
>  	.hardware_enable = hardware_enable,
>  	.hardware_disable = hardware_disable,
>  	.cpu_has_accelerated_tpr = report_flexpriority,
> @@ -7981,6 +7978,15 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
>  	.apic_init_signal_blocked = vmx_apic_init_signal_blocked,
>  };
>  
> +static struct kvm_x86_init_ops vmx_init_ops __initdata = {
> +	.cpu_has_kvm_support = cpu_has_kvm_support,
> +	.disabled_by_bios = vmx_disabled_by_bios,
> +	.check_processor_compatibility = vmx_check_processor_compat,
> +	.hardware_setup = hardware_setup,

cpu_has_kvm_support() -> cpu_has_vmx_support()
hardware_setup() -> vmx_hardware_setup()

> +
> +	.runtime_ops = &vmx_x86_ops,
> +};
> +
>  static void vmx_cleanup_l1d_flush(void)
>  {
>  	if (vmx_l1d_flush_pages) {
> @@ -8065,7 +8071,7 @@ static int __init vmx_init(void)
>  	}
>  #endif
>  
> -	r = kvm_init(&vmx_x86_ops, sizeof(struct vcpu_vmx),
> +	r = kvm_init(&vmx_init_ops, sizeof(struct vcpu_vmx),
>  		     __alignof__(struct vcpu_vmx), THIS_MODULE);
>  	if (r)
>  		return r;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 0f08e1b4e762..20f989d1bba8 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -7298,8 +7298,8 @@ static struct notifier_block pvclock_gtod_notifier = {
>  
>  int kvm_arch_init(void *opaque)
>  {
> +	struct kvm_x86_init_ops *ops = opaque;
>  	int r;
> -	struct kvm_x86_ops *ops = opaque;
>  
>  	if (kvm_x86_ops) {
>  		printk(KERN_ERR "kvm: already loaded the other module\n");
> @@ -7354,7 +7354,7 @@ int kvm_arch_init(void *opaque)
>  	if (r)
>  		goto out_free_percpu;
>  
> -	kvm_x86_ops = ops;
> +	kvm_x86_ops = ops->runtime_ops;
>  
>  	kvm_mmu_set_mask_ptes(PT_USER_MASK, PT_ACCESSED_MASK,
>  			PT_DIRTY_MASK, PT64_NX_MASK, 0,
> @@ -9623,6 +9623,7 @@ void kvm_arch_hardware_disable(void)
>  
>  int kvm_arch_hardware_setup(void *opaque)
>  {
> +	struct kvm_x86_init_ops *ops = opaque;
>  	int r;
>  
>  	rdmsrl_safe(MSR_EFER, &host_efer);
> @@ -9630,7 +9631,7 @@ int kvm_arch_hardware_setup(void *opaque)
>  	if (boot_cpu_has(X86_FEATURE_XSAVES))
>  		rdmsrl(MSR_IA32_XSS, host_xss);
>  
> -	r = kvm_x86_ops->hardware_setup();
> +	r = ops->hardware_setup();
>  	if (r != 0)
>  		return r;
>  
> @@ -9665,13 +9666,14 @@ void kvm_arch_hardware_unsetup(void)
>  int kvm_arch_check_processor_compat(void *opaque)
>  {
>  	struct cpuinfo_x86 *c = &cpu_data(smp_processor_id());
> +	struct kvm_x86_init_ops *ops = opaque;
>  
>  	WARN_ON(!irqs_disabled());
>  
>  	if (kvm_host_cr4_reserved_bits(c) != cr4_reserved_bits)
>  		return -EIO;
>  
> -	return kvm_x86_ops->check_processor_compatibility();
> +	return ops->check_processor_compatibility();
>  }
>  
>  bool kvm_vcpu_is_reset_bsp(struct kvm_vcpu *vcpu)

The patch itself looks good,

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

