Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F5531349BA
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2020 18:48:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729030AbgAHRsA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jan 2020 12:48:00 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:49358 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729003AbgAHRsA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 Jan 2020 12:48:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578505678;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QOnVxVMswYaD0ZumDnZ4gh4bs69+nER6Pzs0IsTXePc=;
        b=JwMAJRxKvQ2qQzg4QusZ47lbiiS4M9kUuYqHrLhZmbdwAbsGk5JeAJHs7a3eJdhEflElVS
        P1wVZW67hQnCg4IMOi4Vl4qXVI3FcNCt3bqJ94KBgq5HjeMhzzbsczWcIDfJB9dk51o/aq
        40vKizvOvbP7lCkVzV4h2+y0CH5i7zo=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-222-IshVmbjhOmaSLRSN_w65jw-1; Wed, 08 Jan 2020 12:47:57 -0500
X-MC-Unique: IshVmbjhOmaSLRSN_w65jw-1
Received: by mail-wr1-f70.google.com with SMTP id b13so1706825wrx.22
        for <kvm@vger.kernel.org>; Wed, 08 Jan 2020 09:47:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QOnVxVMswYaD0ZumDnZ4gh4bs69+nER6Pzs0IsTXePc=;
        b=MuFl0qbg00PIgnsgrs49V8hmxMJ78IGL8AGsg+dR0rcqYmS5ZCgQptzU/6oxgMgshO
         lDuzKFSf1lpuZNB5iX4ZOXp/vog/h96CTwIPlpFoLFQA+K1zwyCB0s75XMSMSObGTCuF
         LfFx81n9XjdaLk0eDxuaeDqXPauaC6SK8M3lo9rpDiEoWjrE4UgJlm3YySTxwtTn59tO
         e3XMP35iMdBNVs2rHpj2UrNLuM0Zi/nZ4ionlH+JJEvq9yArX0GxQRBYfNYJ4sH04JYS
         koKymvbB6FAOgLECSAaQPlzal8eOW8jZVS1II8hqTHGVBVabUZI1TUTuoVKLtk8MKcC9
         RHqw==
X-Gm-Message-State: APjAAAXha59bGfB6L0fTjeVZdbYDh30qrZREOWSGHPbr67sovQk2IkpX
        11Ct4UKmRrpNG/B7saG2un+q6Nu5LRnKSuMHq7vZ2gFBFhnmuBdm544XcfYy23yTfgA/+EwgID6
        pYNmhJNI7INY1
X-Received: by 2002:a5d:410e:: with SMTP id l14mr5740531wrp.238.1578505676513;
        Wed, 08 Jan 2020 09:47:56 -0800 (PST)
X-Google-Smtp-Source: APXvYqytiq8fGB4XJIfgnQFwfq6kd2frSthqbcpCRt1r2qYyVfikdhxnnHrB/7iMcCMqbAMEqp8kuA==
X-Received: by 2002:a5d:410e:: with SMTP id l14mr5740507wrp.238.1578505676165;
        Wed, 08 Jan 2020 09:47:56 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c6d:4079:b74c:e329? ([2001:b07:6468:f312:c6d:4079:b74c:e329])
        by smtp.gmail.com with ESMTPSA id p5sm5121993wrt.79.2020.01.08.09.47.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jan 2020 09:47:55 -0800 (PST)
Subject: Re: [PATCH RESEND v2 07/17] KVM: Move running VCPU from ARM to common
 code
To:     Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20191221014938.58831-1-peterx@redhat.com>
 <20191221014938.58831-8-peterx@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <34a05518-40dd-6b5a-cbb6-b01ba93638c4@redhat.com>
Date:   Wed, 8 Jan 2020 18:47:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191221014938.58831-8-peterx@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/12/19 02:49, Peter Xu wrote:
> From: Paolo Bonzini <pbonzini@redhat.com>
> 
> For ring-based dirty log tracking, it will be more efficient to account
> writes during schedule-out or schedule-in to the currently running VCPU.
> We would like to do it even if the write doesn't use the current VCPU's
> address space, as is the case for cached writes (see commit 4e335d9e7ddb,
> "Revert "KVM: Support vCPU-based gfn->hva cache"", 2017-05-02).
> 
> Therefore, add a mechanism to track the currently-loaded kvm_vcpu struct.
> There is already something similar in KVM/ARM; one important difference
> is that kvm_arch_vcpu_{load,put} have two callers in virt/kvm/kvm_main.c:
> we have to update both the architecture-independent vcpu_{load,put} and
> the preempt notifiers.
> 
> Another change made in the process is to allow using kvm_get_running_vcpu()
> in preemptible code.  This is allowed because preempt notifiers ensure
> that the value does not change even after the VCPU thread is migrated.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>  arch/arm/include/asm/kvm_host.h   |  2 --
>  arch/arm64/include/asm/kvm_host.h |  2 --
>  include/linux/kvm_host.h          |  3 +++
>  virt/kvm/arm/arch_timer.c         |  2 +-
>  virt/kvm/arm/arm.c                | 29 -----------------------------
>  virt/kvm/arm/perf.c               |  6 +++---
>  virt/kvm/arm/vgic/vgic-mmio.c     | 15 +++------------
>  virt/kvm/kvm_main.c               | 25 ++++++++++++++++++++++++-
>  8 files changed, 34 insertions(+), 50 deletions(-)
> 
> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
> index 8a37c8e89777..40eff9cc3744 100644
> --- a/arch/arm/include/asm/kvm_host.h
> +++ b/arch/arm/include/asm/kvm_host.h
> @@ -274,8 +274,6 @@ int kvm_arm_copy_reg_indices(struct kvm_vcpu *vcpu, u64 __user *indices);
>  int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end);
>  int kvm_test_age_hva(struct kvm *kvm, unsigned long hva);
>  
> -struct kvm_vcpu *kvm_arm_get_running_vcpu(void);
> -struct kvm_vcpu __percpu **kvm_get_running_vcpus(void);
>  void kvm_arm_halt_guest(struct kvm *kvm);
>  void kvm_arm_resume_guest(struct kvm *kvm);
>  
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index f656169db8c3..df8d72f7c20e 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -430,8 +430,6 @@ int kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte);
>  int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end);
>  int kvm_test_age_hva(struct kvm *kvm, unsigned long hva);
>  
> -struct kvm_vcpu *kvm_arm_get_running_vcpu(void);
> -struct kvm_vcpu * __percpu *kvm_get_running_vcpus(void);
>  void kvm_arm_halt_guest(struct kvm *kvm);
>  void kvm_arm_resume_guest(struct kvm *kvm);
>  
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 24854c9e3717..b4f7bef38e0d 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1323,6 +1323,9 @@ static inline void kvm_vcpu_set_dy_eligible(struct kvm_vcpu *vcpu, bool val)
>  }
>  #endif /* CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT */
>  
> +struct kvm_vcpu *kvm_get_running_vcpu(void);
> +struct kvm_vcpu __percpu **kvm_get_running_vcpus(void);
> +
>  #ifdef CONFIG_HAVE_KVM_IRQ_BYPASS
>  bool kvm_arch_has_irq_bypass(void);
>  int kvm_arch_irq_bypass_add_producer(struct irq_bypass_consumer *,
> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
> index e2bb5bd60227..085e7fed850c 100644
> --- a/virt/kvm/arm/arch_timer.c
> +++ b/virt/kvm/arm/arch_timer.c
> @@ -1022,7 +1022,7 @@ static bool timer_irqs_are_valid(struct kvm_vcpu *vcpu)
>  
>  bool kvm_arch_timer_get_input_level(int vintid)
>  {
> -	struct kvm_vcpu *vcpu = kvm_arm_get_running_vcpu();
> +	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
>  	struct arch_timer_context *timer;
>  
>  	if (vintid == vcpu_vtimer(vcpu)->irq.irq)
> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> index 86c6aa1cb58e..f7dbb94ec525 100644
> --- a/virt/kvm/arm/arm.c
> +++ b/virt/kvm/arm/arm.c
> @@ -47,9 +47,6 @@ __asm__(".arch_extension	virt");
>  DEFINE_PER_CPU(kvm_host_data_t, kvm_host_data);
>  static DEFINE_PER_CPU(unsigned long, kvm_arm_hyp_stack_page);
>  
> -/* Per-CPU variable containing the currently running vcpu. */
> -static DEFINE_PER_CPU(struct kvm_vcpu *, kvm_arm_running_vcpu);
> -
>  /* The VMID used in the VTTBR */
>  static atomic64_t kvm_vmid_gen = ATOMIC64_INIT(1);
>  static u32 kvm_next_vmid;
> @@ -58,31 +55,8 @@ static DEFINE_SPINLOCK(kvm_vmid_lock);
>  static bool vgic_present;
>  
>  static DEFINE_PER_CPU(unsigned char, kvm_arm_hardware_enabled);
> -
> -static void kvm_arm_set_running_vcpu(struct kvm_vcpu *vcpu)
> -{
> -	__this_cpu_write(kvm_arm_running_vcpu, vcpu);
> -}
> -
>  DEFINE_STATIC_KEY_FALSE(userspace_irqchip_in_use);
>  
> -/**
> - * kvm_arm_get_running_vcpu - get the vcpu running on the current CPU.
> - * Must be called from non-preemptible context
> - */
> -struct kvm_vcpu *kvm_arm_get_running_vcpu(void)
> -{
> -	return __this_cpu_read(kvm_arm_running_vcpu);
> -}
> -
> -/**
> - * kvm_arm_get_running_vcpus - get the per-CPU array of currently running vcpus.
> - */
> -struct kvm_vcpu * __percpu *kvm_get_running_vcpus(void)
> -{
> -	return &kvm_arm_running_vcpu;
> -}
> -
>  int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu)
>  {
>  	return kvm_vcpu_exiting_guest_mode(vcpu) == IN_GUEST_MODE;
> @@ -374,7 +348,6 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>  	vcpu->cpu = cpu;
>  	vcpu->arch.host_cpu_context = &cpu_data->host_ctxt;
>  
> -	kvm_arm_set_running_vcpu(vcpu);
>  	kvm_vgic_load(vcpu);
>  	kvm_timer_vcpu_load(vcpu);
>  	kvm_vcpu_load_sysregs(vcpu);
> @@ -398,8 +371,6 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>  	kvm_vcpu_pmu_restore_host(vcpu);
>  
>  	vcpu->cpu = -1;
> -
> -	kvm_arm_set_running_vcpu(NULL);
>  }
>  
>  static void vcpu_power_off(struct kvm_vcpu *vcpu)
> diff --git a/virt/kvm/arm/perf.c b/virt/kvm/arm/perf.c
> index 918cdc3839ea..d45b8b9a4415 100644
> --- a/virt/kvm/arm/perf.c
> +++ b/virt/kvm/arm/perf.c
> @@ -13,14 +13,14 @@
>  
>  static int kvm_is_in_guest(void)
>  {
> -        return kvm_arm_get_running_vcpu() != NULL;
> +        return kvm_get_running_vcpu() != NULL;
>  }
>  
>  static int kvm_is_user_mode(void)
>  {
>  	struct kvm_vcpu *vcpu;
>  
> -	vcpu = kvm_arm_get_running_vcpu();
> +	vcpu = kvm_get_running_vcpu();
>  
>  	if (vcpu)
>  		return !vcpu_mode_priv(vcpu);
> @@ -32,7 +32,7 @@ static unsigned long kvm_get_guest_ip(void)
>  {
>  	struct kvm_vcpu *vcpu;
>  
> -	vcpu = kvm_arm_get_running_vcpu();
> +	vcpu = kvm_get_running_vcpu();
>  
>  	if (vcpu)
>  		return *vcpu_pc(vcpu);
> diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
> index 0d090482720d..d656ebd5f9d4 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio.c
> +++ b/virt/kvm/arm/vgic/vgic-mmio.c
> @@ -190,15 +190,6 @@ unsigned long vgic_mmio_read_pending(struct kvm_vcpu *vcpu,
>   * value later will give us the same value as we update the per-CPU variable
>   * in the preempt notifier handlers.
>   */
> -static struct kvm_vcpu *vgic_get_mmio_requester_vcpu(void)
> -{
> -	struct kvm_vcpu *vcpu;
> -
> -	preempt_disable();
> -	vcpu = kvm_arm_get_running_vcpu();
> -	preempt_enable();
> -	return vcpu;
> -}
>  
>  /* Must be called with irq->irq_lock held */
>  static void vgic_hw_irq_spending(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
> @@ -221,7 +212,7 @@ void vgic_mmio_write_spending(struct kvm_vcpu *vcpu,
>  			      gpa_t addr, unsigned int len,
>  			      unsigned long val)
>  {
> -	bool is_uaccess = !vgic_get_mmio_requester_vcpu();
> +	bool is_uaccess = !kvm_get_running_vcpu();
>  	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
>  	int i;
>  	unsigned long flags;
> @@ -274,7 +265,7 @@ void vgic_mmio_write_cpending(struct kvm_vcpu *vcpu,
>  			      gpa_t addr, unsigned int len,
>  			      unsigned long val)
>  {
> -	bool is_uaccess = !vgic_get_mmio_requester_vcpu();
> +	bool is_uaccess = !kvm_get_running_vcpu();
>  	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
>  	int i;
>  	unsigned long flags;
> @@ -335,7 +326,7 @@ static void vgic_mmio_change_active(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
>  				    bool active)
>  {
>  	unsigned long flags;
> -	struct kvm_vcpu *requester_vcpu = vgic_get_mmio_requester_vcpu();
> +	struct kvm_vcpu *requester_vcpu = kvm_get_running_vcpu();
>  
>  	raw_spin_lock_irqsave(&irq->irq_lock, flags);
>  
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 17969cf110dd..5c606d158854 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -108,6 +108,7 @@ struct kmem_cache *kvm_vcpu_cache;
>  EXPORT_SYMBOL_GPL(kvm_vcpu_cache);
>  
>  static __read_mostly struct preempt_ops kvm_preempt_ops;
> +static DEFINE_PER_CPU(struct kvm_vcpu *, kvm_running_vcpu);
>  
>  struct dentry *kvm_debugfs_dir;
>  EXPORT_SYMBOL_GPL(kvm_debugfs_dir);
> @@ -199,6 +200,8 @@ bool kvm_is_reserved_pfn(kvm_pfn_t pfn)
>  void vcpu_load(struct kvm_vcpu *vcpu)
>  {
>  	int cpu = get_cpu();
> +
> +	__this_cpu_write(kvm_running_vcpu, vcpu);
>  	preempt_notifier_register(&vcpu->preempt_notifier);
>  	kvm_arch_vcpu_load(vcpu, cpu);
>  	put_cpu();
> @@ -210,6 +213,7 @@ void vcpu_put(struct kvm_vcpu *vcpu)
>  	preempt_disable();
>  	kvm_arch_vcpu_put(vcpu);
>  	preempt_notifier_unregister(&vcpu->preempt_notifier);
> +	__this_cpu_write(kvm_running_vcpu, NULL);
>  	preempt_enable();
>  }
>  EXPORT_SYMBOL_GPL(vcpu_put);
> @@ -4294,8 +4298,8 @@ static void kvm_sched_in(struct preempt_notifier *pn, int cpu)
>  	WRITE_ONCE(vcpu->preempted, false);
>  	WRITE_ONCE(vcpu->ready, false);
>  
> +	__this_cpu_write(kvm_running_vcpu, vcpu);
>  	kvm_arch_sched_in(vcpu, cpu);
> -
>  	kvm_arch_vcpu_load(vcpu, cpu);
>  }
>  
> @@ -4309,6 +4313,25 @@ static void kvm_sched_out(struct preempt_notifier *pn,
>  		WRITE_ONCE(vcpu->ready, true);
>  	}
>  	kvm_arch_vcpu_put(vcpu);
> +	__this_cpu_write(kvm_running_vcpu, NULL);
> +}
> +
> +/**
> + * kvm_get_running_vcpu - get the vcpu running on the current CPU.
> + * Thanks to preempt notifiers, this can also be called from
> + * preemptible context.
> + */
> +struct kvm_vcpu *kvm_get_running_vcpu(void)
> +{
> +        return __this_cpu_read(kvm_running_vcpu);
> +}
> +
> +/**
> + * kvm_get_running_vcpus - get the per-CPU array of currently running vcpus.
> + */
> +struct kvm_vcpu * __percpu *kvm_get_running_vcpus(void)
> +{
> +        return &kvm_running_vcpu;
>  }
>  
>  static void check_processor_compat(void *rtn)
> 

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

