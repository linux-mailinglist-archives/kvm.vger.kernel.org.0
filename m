Return-Path: <kvm+bounces-24186-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CADAA9521D1
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 20:07:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7F681284000
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 18:07:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE5461BD50A;
	Wed, 14 Aug 2024 18:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="O3GE4smK"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04CF01BC098
	for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 18:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723658816; cv=none; b=cKUYeYvFh6AhWpR5Tvy6Vl3aDz/CsYvI+olMSJFtQ9LZCXVhMO2svbQNf3Rh8Kq+7fpAkJZdPj0vFZt5bDnhx6axrNg/QSUVkBe+N79iirXIG6oOeAtI73QCMi9CP7QC5we1AbC6tpR7QQDkBecSoC9yPw/Ol1/xaKxzVdBvWVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723658816; c=relaxed/simple;
	bh=XSOtEmrYSLyyRWl8pUeOUa3O6s2CAIrbuGOH9EAMys0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=O4N2R7kI7yIPGyPoXOXJ+DZqMcwslOYVTRWpeVCgGNvnQp8USn3Eve7c9dTk2hNTLmlaWNbtz4Ui7OTHBBORmZ1th0BGAGZOkT3fhmdH5XYOJEq67d+flyKmaDvkmH6NjIrlyL+X7byMXPcD0+P28Q0F/4+ib6Lj7NVSw8f/wvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=O3GE4smK; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723658812;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=U1oQRzyeH+g+JZ7/Qmqk7+SpUg+Ra6EgWcYIXJN7MqI=;
	b=O3GE4smKKf4qiEqLFAH/JpJj68m1h0EXJOO+LOtGI/jgAdx+Mv2Be3lWVYyk//YA8t/Umf
	bXJuGLJyoWfM8Qio+3FLzdRkzokJDTNEMiU0SUPPpozMeCBoRxQfEmdI1BvKRc/chaX/pz
	DOpWUx+qfmSU61jdGnAVnvvliYDvg0Y=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-148-l89CCPjPMPCiuK5-jhFZbg-1; Wed, 14 Aug 2024 14:06:49 -0400
X-MC-Unique: l89CCPjPMPCiuK5-jhFZbg-1
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-52ebdbf8a7cso90196e87.2
        for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 11:06:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723658808; x=1724263608;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=U1oQRzyeH+g+JZ7/Qmqk7+SpUg+Ra6EgWcYIXJN7MqI=;
        b=URhbcyn/pfsk+KSY7N1FVNQBn9fz91Iii8YSFAVbrNZlQsGKcTUI7fIgOoEoZd845f
         cy+kkUBEkc/TVJimuIloQuUsCf69yX83zCqUqS7Hd8bQ+udx38OqSZa/9XW3FosgxcPr
         hm/XbVFlWA0Z1UqaUMMeTgPICL4BfQS/eZlnuT/k3UxUmN5IUgWvzjgscCiGk90rIGUt
         BrdbrXPc6vFfakxiSpyRNaHxnTPyigRdSD96e4eYaXeEC6xxrd+zBrYrjhLdXtsMEF33
         pn2oOveVw6phiIdfvQnVKgw03QCaqkwKbJ8e4GZKdjiRi6ISucCVmV3CsoPeU50Bfs/2
         MWwQ==
X-Gm-Message-State: AOJu0YxYWjMHaj8BrzLWMtDHiX7OMzgL/oHmxWo6Zt3ek58eRGGGA62e
	U8P5He+3ydHr+VyG/DscCnkxKFgGAXM1I8+9LYjQNsXm2gZxaz0oxDiaJzlh5ijz0vTUswmCj23
	dPwmVoH9VzrjIqJO+GUQ2o35PDjiiD7uoCoHQ+LBWVUt1kJQ3eQ==
X-Received: by 2002:a05:6512:3b1f:b0:530:da96:a98e with SMTP id 2adb3069b0e04-532eda5e9f6mr2392125e87.2.1723658807777;
        Wed, 14 Aug 2024 11:06:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEQSiWnANUf5WmUBEasupoIOTxTYGjSv15nNIevrp2Z8B/7kMkKy6nyEGxs6of1skm9gmboTA==
X-Received: by 2002:a05:6512:3b1f:b0:530:da96:a98e with SMTP id 2adb3069b0e04-532eda5e9f6mr2392092e87.2.1723658807173;
        Wed, 14 Aug 2024 11:06:47 -0700 (PDT)
Received: from [192.168.10.47] ([151.95.101.29])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-429ded71ee3sm26790535e9.29.2024.08.14.11.06.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Aug 2024 11:06:44 -0700 (PDT)
Message-ID: <efb9af41-21ed-4b97-8c67-40d6cda10484@redhat.com>
Date: Wed, 14 Aug 2024 20:06:32 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/8] KVM: Use dedicated mutex to protect
 kvm_usage_count to avoid deadlock
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Chao Gao <chao.gao@intel.com>, Kai Huang <kai.huang@intel.com>
References: <20240608000639.3295768-1-seanjc@google.com>
 <20240608000639.3295768-2-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20240608000639.3295768-2-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/8/24 02:06, Sean Christopherson wrote:
> Use a dedicated mutex to guard kvm_usage_count to fix a potential deadlock
> on x86 due to a chain of locks and SRCU synchronizations.  Translating the
> below lockdep splat, CPU1 #6 will wait on CPU0 #1, CPU0 #8 will wait on
> CPU2 #3, and CPU2 #7 will wait on CPU1 #4 (if there's a writer, due to the
> fairness of r/w semaphores).
> 
>      CPU0                     CPU1                     CPU2
> 1   lock(&kvm->slots_lock);
> 2                                                     lock(&vcpu->mutex);
> 3                                                     lock(&kvm->srcu);
> 4                            lock(cpu_hotplug_lock);
> 5                            lock(kvm_lock);
> 6                            lock(&kvm->slots_lock);
> 7                                                     lock(cpu_hotplug_lock);
> 8   sync(&kvm->srcu);
> 
> Note, there are likely more potential deadlocks in KVM x86, e.g. the same
> pattern of taking cpu_hotplug_lock outside of kvm_lock likely exists with
> __kvmclock_cpufreq_notifier()

Offhand I couldn't see any places where {,__}cpufreq_driver_target() is 
called within cpus_read_lock().  I didn't look too closely though.

> +``kvm_usage_count``
> +^^^^^^^^^^^^^^^^^^^

``kvm_usage_lock``

Paolo

> +
> +:Type:		mutex
> +:Arch:		any
> +:Protects:	- kvm_usage_count
>   		- hardware virtualization enable/disable
>   :Comment:	KVM also disables CPU hotplug via cpus_read_lock() during
>   		enable/disable.
> @@ -290,11 +296,12 @@ time it will be set using the Dirty tracking mechanism described above.
>   		wakeup.
>   
>   ``vendor_module_lock``
> -^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> +^^^^^^^^^^^^^^^^^^^^^^
>   :Type:		mutex
>   :Arch:		x86
>   :Protects:	loading a vendor module (kvm_amd or kvm_intel)
> -:Comment:	Exists because using kvm_lock leads to deadlock.  cpu_hotplug_lock is
> -    taken outside of kvm_lock, e.g. in KVM's CPU online/offline callbacks, and
> -    many operations need to take cpu_hotplug_lock when loading a vendor module,
> -    e.g. updating static calls.
> +:Comment:	Exists because using kvm_lock leads to deadlock.  kvm_lock is taken
> +    in notifiers, e.g. __kvmclock_cpufreq_notifier(), that may be invoked while
> +    cpu_hotplug_lock is held, e.g. from cpufreq_boost_trigger_state(), and many
> +    operations need to take cpu_hotplug_lock when loading a vendor module, e.g.
> +    updating static calls.
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 4965196cad58..d9b0579d3eea 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -5499,6 +5499,7 @@ __visible bool kvm_rebooting;
>   EXPORT_SYMBOL_GPL(kvm_rebooting);
>   
>   static DEFINE_PER_CPU(bool, hardware_enabled);
> +static DEFINE_MUTEX(kvm_usage_lock);
>   static int kvm_usage_count;
>   
>   static int __hardware_enable_nolock(void)
> @@ -5531,10 +5532,10 @@ static int kvm_online_cpu(unsigned int cpu)
>   	 * be enabled. Otherwise running VMs would encounter unrecoverable
>   	 * errors when scheduled to this CPU.
>   	 */
> -	mutex_lock(&kvm_lock);
> +	mutex_lock(&kvm_usage_lock);
>   	if (kvm_usage_count)
>   		ret = __hardware_enable_nolock();
> -	mutex_unlock(&kvm_lock);
> +	mutex_unlock(&kvm_usage_lock);
>   	return ret;
>   }
>   
> @@ -5554,10 +5555,10 @@ static void hardware_disable_nolock(void *junk)
>   
>   static int kvm_offline_cpu(unsigned int cpu)
>   {
> -	mutex_lock(&kvm_lock);
> +	mutex_lock(&kvm_usage_lock);
>   	if (kvm_usage_count)
>   		hardware_disable_nolock(NULL);
> -	mutex_unlock(&kvm_lock);
> +	mutex_unlock(&kvm_usage_lock);
>   	return 0;
>   }
>   
> @@ -5573,9 +5574,9 @@ static void hardware_disable_all_nolock(void)
>   static void hardware_disable_all(void)
>   {
>   	cpus_read_lock();
> -	mutex_lock(&kvm_lock);
> +	mutex_lock(&kvm_usage_lock);
>   	hardware_disable_all_nolock();
> -	mutex_unlock(&kvm_lock);
> +	mutex_unlock(&kvm_usage_lock);
>   	cpus_read_unlock();
>   }
>   
> @@ -5606,7 +5607,7 @@ static int hardware_enable_all(void)
>   	 * enable hardware multiple times.
>   	 */
>   	cpus_read_lock();
> -	mutex_lock(&kvm_lock);
> +	mutex_lock(&kvm_usage_lock);
>   
>   	r = 0;
>   
> @@ -5620,7 +5621,7 @@ static int hardware_enable_all(void)
>   		}
>   	}
>   
> -	mutex_unlock(&kvm_lock);
> +	mutex_unlock(&kvm_usage_lock);
>   	cpus_read_unlock();
>   
>   	return r;
> @@ -5648,13 +5649,13 @@ static int kvm_suspend(void)
>   {
>   	/*
>   	 * Secondary CPUs and CPU hotplug are disabled across the suspend/resume
> -	 * callbacks, i.e. no need to acquire kvm_lock to ensure the usage count
> -	 * is stable.  Assert that kvm_lock is not held to ensure the system
> -	 * isn't suspended while KVM is enabling hardware.  Hardware enabling
> -	 * can be preempted, but the task cannot be frozen until it has dropped
> -	 * all locks (userspace tasks are frozen via a fake signal).
> +	 * callbacks, i.e. no need to acquire kvm_usage_lock to ensure the usage
> +	 * count is stable.  Assert that kvm_usage_lock is not held to ensure
> +	 * the system isn't suspended while KVM is enabling hardware.  Hardware
> +	 * enabling can be preempted, but the task cannot be frozen until it has
> +	 * dropped all locks (userspace tasks are frozen via a fake signal).
>   	 */
> -	lockdep_assert_not_held(&kvm_lock);
> +	lockdep_assert_not_held(&kvm_usage_lock);
>   	lockdep_assert_irqs_disabled();
>   
>   	if (kvm_usage_count)
> @@ -5664,7 +5665,7 @@ static int kvm_suspend(void)
>   
>   static void kvm_resume(void)
>   {
> -	lockdep_assert_not_held(&kvm_lock);
> +	lockdep_assert_not_held(&kvm_usage_lock);
>   	lockdep_assert_irqs_disabled();
>   
>   	if (kvm_usage_count)


