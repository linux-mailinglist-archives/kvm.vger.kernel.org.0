Return-Path: <kvm+bounces-24187-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id ED6F39521D6
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 20:12:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1E4071C22136
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 18:12:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98B121BD4FB;
	Wed, 14 Aug 2024 18:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="X18n4Inb"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5D8D1B32A6
	for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 18:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723659138; cv=none; b=m4FWLotQmGc7eYfbB2TTqZRgv9qGrzxJeC5VW/YsY6+4St6RvFzgCgPWq7C7k6FGj3d6u6VJW+xkLRiM0jRa1JLCi7dxZOD+OhqlLggqbzmmHBi6waFlWqqnLwuAcCC0+4d/nHxu0igjg3sSBS5tOeK+1/nbWTBKPd5MLq2L0j8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723659138; c=relaxed/simple;
	bh=hV66myumtR5cSOOfrPaWxnlBZDRz7vS7E8vqFj3zZIE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IYCc0991YxqTfre1JtMzefW64MpPIQVFD5TSll86vDDJvyCtIvVLorY5wcFK3ZU6nq9e841qY7ICMkSjErsvpwGYAe762ERoVdrpnmDkCjRlmPUAXMUZJ/JbILML0Qc5GsPefDJzusI0BA3BbfMeD2CbVmcvwyYpQ9crmI4SLO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=X18n4Inb; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723659135;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=OStzYQ3CcSqvcPVYW6U3k5VNAvtV6PLOXsyokOlAIHY=;
	b=X18n4InbsvHj+bPrkTRawKsxlTh1aIx0rIRn1bDzQz+gVADzeAF9K70bJfIjNdIZ9bA+Zh
	17SOcXBoVwUGTqT7PWaHXw4GfQpBMSBuEzAmRuDKfTA2qH68owfGoKzxlpdkOFYOiOKEIy
	Lr4NzlqXl2WPKejnxnp+w6wTcYatppo=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-590-unXo3i8NMeq5JHwa5iuUWA-1; Wed, 14 Aug 2024 14:12:12 -0400
X-MC-Unique: unXo3i8NMeq5JHwa5iuUWA-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-42816aacabcso366775e9.1
        for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 11:12:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723659131; x=1724263931;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OStzYQ3CcSqvcPVYW6U3k5VNAvtV6PLOXsyokOlAIHY=;
        b=Y6myQUhvgGVOM+UDwlHUmsgLJO6B7hzRRHCcAEiPrZRsP6s4KkIsX5YbN4dTeOBjTh
         tZ3iGkKqADk3dG4bukYbtCc0edoJSszoRYHEb3DD9xIBRAiI81Divoaw/8k2dmoi1aeG
         8V1EQGpPrGZGKFaeAaM/oOnFsr1ITrZ33U4FWcmmOZ2gEaPbcadTU0dpvXPJCbAxjPBN
         r2JclHpwnBstaTUwsZNrHwhY5otbbSag3Xg40+9zFXTitXUiNcV+szejZXmamZXbj230
         y0D7MNB0qk/DuOkgRaGzu20c2HrJBWtaIY/GfABuK7TqS+qxc87ahEJAecuC6j0pU5jR
         9ZXg==
X-Gm-Message-State: AOJu0Yz4ZTbaPpfSBSxZqfZgSDtjpZ0AJAJmGOy7BJI3bAznMNoDv5GK
	w8FHlSqouVD2tDxQDrIELSlntzEWYnhc4DnI9JRzJQhDbD/jQVFt7eYbpibqoEJh+71OEMJvn1V
	HR0MDP8R8RhJkituxaW2Q8RDPqHIggbDlXP2O73giaHbW8dY2og==
X-Received: by 2002:a05:600c:3b08:b0:428:fcb:95c with SMTP id 5b1f17b1804b1-429dd264deamr26006855e9.23.1723659130861;
        Wed, 14 Aug 2024 11:12:10 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEZCNIW0GlKat0WZVHYQnj4GZLbKXTNxu0xbXl7IAIUsgbwDqgiNRNBynLOfo4fcdH88+1lgQ==
X-Received: by 2002:a05:600c:3b08:b0:428:fcb:95c with SMTP id 5b1f17b1804b1-429dd264deamr26006665e9.23.1723659130251;
        Wed, 14 Aug 2024 11:12:10 -0700 (PDT)
Received: from [192.168.10.47] ([151.95.101.29])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-429ded720fbsm27802005e9.35.2024.08.14.11.12.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Aug 2024 11:12:08 -0700 (PDT)
Message-ID: <76605c6e-37f8-4abc-ade3-3ba381d6c9c4@redhat.com>
Date: Wed, 14 Aug 2024 20:12:07 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/8] KVM: Register cpuhp and syscore callbacks when
 enabling hardware
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Chao Gao <chao.gao@intel.com>, Kai Huang <kai.huang@intel.com>
References: <20240608000639.3295768-1-seanjc@google.com>
 <20240608000639.3295768-3-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20240608000639.3295768-3-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/8/24 02:06, Sean Christopherson wrote:
> Register KVM's cpuhp and syscore callback when enabling virtualization
> in hardware instead of registering the callbacks during initialization,
> and let the CPU up/down framework invoke the inner enable/disable
> functions.  Registering the callbacks during initialization makes things
> more complex than they need to be, as KVM needs to be very careful about
> handling races between enabling CPUs being onlined/offlined and hardware
> being enabled/disabled.
> 
> Intel TDX support will require KVM to enable virtualization during KVM
> initialization, i.e. will add another wrinkle to things, at which point
> sorting out the potential races with kvm_usage_count would become even
> more complex.
> 
> Note, using the cpuhp framework has a subtle behavioral change: enabling
> will be done serially across all CPUs, whereas KVM currently sends an IPI
> to all CPUs in parallel.  While serializing virtualization enabling could
> create undesirable latency, the issue is limited to creation of KVM's
> first VM,

Isn't that "limited to when kvm_usage_count goes from 0 to 1", so every 
time a VM is started if you never run two?

You're fixing this later though, so this is just an issue with the 
commit message.

Paolo

  and even that can be mitigated, e.g. by letting userspace force
> virtualization to be enabled when KVM is initialized.
> 
> Cc: Chao Gao <chao.gao@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   virt/kvm/kvm_main.c | 174 ++++++++++++++++----------------------------
>   1 file changed, 61 insertions(+), 113 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index d9b0579d3eea..f6b114f42433 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -5502,7 +5502,7 @@ static DEFINE_PER_CPU(bool, hardware_enabled);
>   static DEFINE_MUTEX(kvm_usage_lock);
>   static int kvm_usage_count;
>   
> -static int __hardware_enable_nolock(void)
> +static int hardware_enable_nolock(void)
>   {
>   	if (__this_cpu_read(hardware_enabled))
>   		return 0;
> @@ -5517,34 +5517,18 @@ static int __hardware_enable_nolock(void)
>   	return 0;
>   }
>   
> -static void hardware_enable_nolock(void *failed)
> -{
> -	if (__hardware_enable_nolock())
> -		atomic_inc(failed);
> -}
> -
>   static int kvm_online_cpu(unsigned int cpu)
>   {
> -	int ret = 0;
> -
>   	/*
>   	 * Abort the CPU online process if hardware virtualization cannot
>   	 * be enabled. Otherwise running VMs would encounter unrecoverable
>   	 * errors when scheduled to this CPU.
>   	 */
> -	mutex_lock(&kvm_usage_lock);
> -	if (kvm_usage_count)
> -		ret = __hardware_enable_nolock();
> -	mutex_unlock(&kvm_usage_lock);
> -	return ret;
> +	return hardware_enable_nolock();
>   }
>   
>   static void hardware_disable_nolock(void *junk)
>   {
> -	/*
> -	 * Note, hardware_disable_all_nolock() tells all online CPUs to disable
> -	 * hardware, not just CPUs that successfully enabled hardware!
> -	 */
>   	if (!__this_cpu_read(hardware_enabled))
>   		return;
>   
> @@ -5555,78 +5539,10 @@ static void hardware_disable_nolock(void *junk)
>   
>   static int kvm_offline_cpu(unsigned int cpu)
>   {
> -	mutex_lock(&kvm_usage_lock);
> -	if (kvm_usage_count)
> -		hardware_disable_nolock(NULL);
> -	mutex_unlock(&kvm_usage_lock);
> +	hardware_disable_nolock(NULL);
>   	return 0;
>   }
>   
> -static void hardware_disable_all_nolock(void)
> -{
> -	BUG_ON(!kvm_usage_count);
> -
> -	kvm_usage_count--;
> -	if (!kvm_usage_count)
> -		on_each_cpu(hardware_disable_nolock, NULL, 1);
> -}
> -
> -static void hardware_disable_all(void)
> -{
> -	cpus_read_lock();
> -	mutex_lock(&kvm_usage_lock);
> -	hardware_disable_all_nolock();
> -	mutex_unlock(&kvm_usage_lock);
> -	cpus_read_unlock();
> -}
> -
> -static int hardware_enable_all(void)
> -{
> -	atomic_t failed = ATOMIC_INIT(0);
> -	int r;
> -
> -	/*
> -	 * Do not enable hardware virtualization if the system is going down.
> -	 * If userspace initiated a forced reboot, e.g. reboot -f, then it's
> -	 * possible for an in-flight KVM_CREATE_VM to trigger hardware enabling
> -	 * after kvm_reboot() is called.  Note, this relies on system_state
> -	 * being set _before_ kvm_reboot(), which is why KVM uses a syscore ops
> -	 * hook instead of registering a dedicated reboot notifier (the latter
> -	 * runs before system_state is updated).
> -	 */
> -	if (system_state == SYSTEM_HALT || system_state == SYSTEM_POWER_OFF ||
> -	    system_state == SYSTEM_RESTART)
> -		return -EBUSY;
> -
> -	/*
> -	 * When onlining a CPU, cpu_online_mask is set before kvm_online_cpu()
> -	 * is called, and so on_each_cpu() between them includes the CPU that
> -	 * is being onlined.  As a result, hardware_enable_nolock() may get
> -	 * invoked before kvm_online_cpu(), which also enables hardware if the
> -	 * usage count is non-zero.  Disable CPU hotplug to avoid attempting to
> -	 * enable hardware multiple times.
> -	 */
> -	cpus_read_lock();
> -	mutex_lock(&kvm_usage_lock);
> -
> -	r = 0;
> -
> -	kvm_usage_count++;
> -	if (kvm_usage_count == 1) {
> -		on_each_cpu(hardware_enable_nolock, &failed, 1);
> -
> -		if (atomic_read(&failed)) {
> -			hardware_disable_all_nolock();
> -			r = -EBUSY;
> -		}
> -	}
> -
> -	mutex_unlock(&kvm_usage_lock);
> -	cpus_read_unlock();
> -
> -	return r;
> -}
> -
>   static void kvm_shutdown(void)
>   {
>   	/*
> @@ -5658,8 +5574,7 @@ static int kvm_suspend(void)
>   	lockdep_assert_not_held(&kvm_usage_lock);
>   	lockdep_assert_irqs_disabled();
>   
> -	if (kvm_usage_count)
> -		hardware_disable_nolock(NULL);
> +	hardware_disable_nolock(NULL);
>   	return 0;
>   }
>   
> @@ -5668,8 +5583,7 @@ static void kvm_resume(void)
>   	lockdep_assert_not_held(&kvm_usage_lock);
>   	lockdep_assert_irqs_disabled();
>   
> -	if (kvm_usage_count)
> -		WARN_ON_ONCE(__hardware_enable_nolock());
> +	WARN_ON_ONCE(hardware_enable_nolock());
>   }
>   
>   static struct syscore_ops kvm_syscore_ops = {
> @@ -5677,6 +5591,60 @@ static struct syscore_ops kvm_syscore_ops = {
>   	.resume = kvm_resume,
>   	.shutdown = kvm_shutdown,
>   };
> +
> +static int hardware_enable_all(void)
> +{
> +	int r;
> +
> +	guard(mutex)(&kvm_usage_lock);
> +
> +	if (kvm_usage_count++)
> +		return 0;
> +
> +	r = cpuhp_setup_state(CPUHP_AP_KVM_ONLINE, "kvm/cpu:online",
> +			      kvm_online_cpu, kvm_offline_cpu);
> +	if (r)
> +		goto err_cpuhp;
> +
> +	register_syscore_ops(&kvm_syscore_ops);
> +
> +	/*
> +	 * Undo virtualization enabling and bail if the system is going down.
> +	 * If userspace initiated a forced reboot, e.g. reboot -f, then it's
> +	 * possible for an in-flight operation to enable virtualization after
> +	 * syscore_shutdown() is called, i.e. without kvm_shutdown() being
> +	 * invoked.  Note, this relies on system_state being set _before_
> +	 * kvm_shutdown(), e.g. to ensure either kvm_shutdown() is invoked
> +	 * or this CPU observes the impending shutdown.  Which is why KVM uses
> +	 * a syscore ops hook instead of registering a dedicated reboot
> +	 * notifier (the latter runs before system_state is updated).
> +	 */
> +	if (system_state == SYSTEM_HALT || system_state == SYSTEM_POWER_OFF ||
> +	    system_state == SYSTEM_RESTART) {
> +		r = -EBUSY;
> +		goto err_rebooting;
> +	}
> +
> +	return 0;
> +
> +err_rebooting:
> +	unregister_syscore_ops(&kvm_syscore_ops);
> +	cpuhp_remove_state(CPUHP_AP_KVM_ONLINE);
> +err_cpuhp:
> +	--kvm_usage_count;
> +	return r;
> +}
> +
> +static void hardware_disable_all(void)
> +{
> +	guard(mutex)(&kvm_usage_lock);
> +
> +	if (--kvm_usage_count)
> +		return;
> +
> +	unregister_syscore_ops(&kvm_syscore_ops);
> +	cpuhp_remove_state(CPUHP_AP_KVM_ONLINE);
> +}
>   #else /* CONFIG_KVM_GENERIC_HARDWARE_ENABLING */
>   static int hardware_enable_all(void)
>   {
> @@ -6382,15 +6350,6 @@ int kvm_init(unsigned vcpu_size, unsigned vcpu_align, struct module *module)
>   	int r;
>   	int cpu;
>   
> -#ifdef CONFIG_KVM_GENERIC_HARDWARE_ENABLING
> -	r = cpuhp_setup_state_nocalls(CPUHP_AP_KVM_ONLINE, "kvm/cpu:online",
> -				      kvm_online_cpu, kvm_offline_cpu);
> -	if (r)
> -		return r;
> -
> -	register_syscore_ops(&kvm_syscore_ops);
> -#endif
> -
>   	/* A kmem cache lets us meet the alignment requirements of fx_save. */
>   	if (!vcpu_align)
>   		vcpu_align = __alignof__(struct kvm_vcpu);
> @@ -6401,10 +6360,8 @@ int kvm_init(unsigned vcpu_size, unsigned vcpu_align, struct module *module)
>   					   offsetofend(struct kvm_vcpu, stats_id)
>   					   - offsetof(struct kvm_vcpu, arch),
>   					   NULL);
> -	if (!kvm_vcpu_cache) {
> -		r = -ENOMEM;
> -		goto err_vcpu_cache;
> -	}
> +	if (!kvm_vcpu_cache)
> +		return -ENOMEM;
>   
>   	for_each_possible_cpu(cpu) {
>   		if (!alloc_cpumask_var_node(&per_cpu(cpu_kick_mask, cpu),
> @@ -6461,11 +6418,6 @@ int kvm_init(unsigned vcpu_size, unsigned vcpu_align, struct module *module)
>   	for_each_possible_cpu(cpu)
>   		free_cpumask_var(per_cpu(cpu_kick_mask, cpu));
>   	kmem_cache_destroy(kvm_vcpu_cache);
> -err_vcpu_cache:
> -#ifdef CONFIG_KVM_GENERIC_HARDWARE_ENABLING
> -	unregister_syscore_ops(&kvm_syscore_ops);
> -	cpuhp_remove_state_nocalls(CPUHP_AP_KVM_ONLINE);
> -#endif
>   	return r;
>   }
>   EXPORT_SYMBOL_GPL(kvm_init);
> @@ -6487,10 +6439,6 @@ void kvm_exit(void)
>   	kmem_cache_destroy(kvm_vcpu_cache);
>   	kvm_vfio_ops_exit();
>   	kvm_async_pf_deinit();
> -#ifdef CONFIG_KVM_GENERIC_HARDWARE_ENABLING
> -	unregister_syscore_ops(&kvm_syscore_ops);
> -	cpuhp_remove_state_nocalls(CPUHP_AP_KVM_ONLINE);
> -#endif
>   	kvm_irqfd_exit();
>   }
>   EXPORT_SYMBOL_GPL(kvm_exit);


