Return-Path: <kvm+bounces-4404-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EB8668121A2
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 23:40:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5C37DB20DC5
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 22:40:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E5248183D;
	Wed, 13 Dec 2023 22:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Eg68xvYZ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B806DF5
	for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 14:40:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702507223;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U6q+SujD6T+0deWVz0gmo5g4QASJTJJ5VQOUwvjSYJk=;
	b=Eg68xvYZu6Xkguw5pYNhpv8fuYx63neI8BhJ9D4kdchOYb9pyDrU/X/29mqs74vgNTrK39
	d1a10iSIZSWCfaT19lw/lvYUeTtpWgKfR0Je5kRXevfkH878Sk1hynPRp+dipdmZsTNRKz
	nuaKSshbgD/30aNUqOsW1T3ES/BwxsY=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-567-wzOSKwgZN1apcqmRyc6zMQ-1; Wed, 13 Dec 2023 17:40:22 -0500
X-MC-Unique: wzOSKwgZN1apcqmRyc6zMQ-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-33344663fbcso6211313f8f.2
        for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 14:40:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702507221; x=1703112021;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=U6q+SujD6T+0deWVz0gmo5g4QASJTJJ5VQOUwvjSYJk=;
        b=MrWkhEYdWAwI9pcHfcz+ewzCzT5DqSNodNsV63UpdEZ85aToJDlfxMG8MAkoxx/LuH
         Q6drL+Eqc2PR33npsjhsdVk7qODmsKkenPdCgu/M7/K49LUhScnISOd9G2cN6DBgOrSX
         StdwnCr+5jW70yxWzyv1mjbDF8CyttjvoVAtrS7wmtFTo70RnJ2iEB1erNSzAr/Vx9ie
         bckyFA6WD9b47KGGNGfpeXmE4TKoPU69epww9G8eElTQsMne88Z/+PsuzL1naK9BJxBk
         MQbHwfTgxAf3qDTopRb/9jSP5rM1v7EMJgjWxNB2niAy6HfJEtqNgQj94csXsWHgbsaZ
         cUPw==
X-Gm-Message-State: AOJu0Yxgugx/Mz2Ant2182keRl9i5tzcUQn+zhAs3pf5rnZ7N6NkNWXL
	QpeFAc+mL/zz79uloTj5Db8lOc3QnspVlG9k0b5OOpjftLE1hdxGon83RK8Mzv4GQUIIIQy3XWj
	VZgEbEuhyDW8F
X-Received: by 2002:a05:600c:1649:b0:40c:328f:e0ec with SMTP id o9-20020a05600c164900b0040c328fe0ecmr2082720wmn.310.1702507221203;
        Wed, 13 Dec 2023 14:40:21 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEQCGkL5TGtKZoyg8vvA0GfoknejAmJIQbtGc5w1kZf8ypAOMUXwoxjQJA9XmdBve+KRVtdig==
X-Received: by 2002:a05:600c:1649:b0:40c:328f:e0ec with SMTP id o9-20020a05600c164900b0040c328fe0ecmr2082713wmn.310.1702507220970;
        Wed, 13 Dec 2023 14:40:20 -0800 (PST)
Received: from starship ([77.137.131.62])
        by smtp.gmail.com with ESMTPSA id be9-20020a05600c1e8900b0040596352951sm24529011wmb.5.2023.12.13.14.40.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Dec 2023 14:40:20 -0800 (PST)
Message-ID: <61530aa466a038efb0e648da002432d02a9692a3.camel@redhat.com>
Subject: Re: [PATCH v2 2/3] KVM: X86: Add a capability to configure bus
 frequency for APIC timer
From: Maxim Levitsky <mlevitsk@redhat.com>
To: isaku.yamahata@intel.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>, 
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>, Vishal
 Annapurve <vannapurve@google.com>, Jim Mattson <jmattson@google.com>
Date: Thu, 14 Dec 2023 00:40:18 +0200
In-Reply-To: <88774b9dc566c89141bf75aef341fdf7e238e60b.1699936040.git.isaku.yamahata@intel.com>
References: <cover.1699936040.git.isaku.yamahata@intel.com>
	 <88774b9dc566c89141bf75aef341fdf7e238e60b.1699936040.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Mon, 2023-11-13 at 20:35 -0800, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Add KVM_CAP_X86_BUS_FREQUENCY_CONTROL capability to configure the core
> crystal clock (or processor's bus clock) for APIC timer emulation.  Allow
> KVM_ENABLE_CAPABILITY(KVM_CAP_X86_BUS_FREQUENCY_CONTROL) to set the
> frequency.
> 
> TDX virtualizes CPUID[0x15] for the core crystal clock to be 25MHz.  The
> x86 KVM hardcodes its frequency for APIC timer to be 1GHz.  This mismatch
> causes the vAPIC timer to fire earlier than the guest expects. [1] The KVM
> APIC timer emulation uses hrtimer, whose unit is nanosecond.  Make the
> parameter configurable for conversion from the TMICT value to nanosecond.
> 
> This patch doesn't affect the TSC deadline timer emulation.  The TSC
> deadline emulation path records its expiring TSC value and calculates the
> expiring time in nanoseconds.  The APIC timer emulation path calculates the
> TSC value from the TMICT register value and uses the TSC deadline timer
> path.  This patch touches the APIC timer-specific code but doesn't touch
> common logic.

Nitpick: To be honest IMHO the paragraph about tsc deadline is redundant, because by definition (x86 spec)
the tsc deadline timer doesn't use APIC bus frequency.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

> 
> [1] https://lore.kernel.org/lkml/20231006011255.4163884-1-vannapurve@google.com/
> Reported-by: Vishal Annapurve <vannapurve@google.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
> Changes v2:
> - Add check if vcpu isn't created.
> - Add check if lapic chip is in-kernel emulation.
> - Fix build error for i386
> - Add document to api.rst
> - typo in the commit message
> ---
>  Documentation/virt/kvm/api.rst | 14 ++++++++++++++
>  arch/x86/kvm/x86.c             | 35 ++++++++++++++++++++++++++++++++++
>  include/uapi/linux/kvm.h       |  1 +
>  3 files changed, 50 insertions(+)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 7025b3751027..cc976df2651e 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -7858,6 +7858,20 @@ This capability is aimed to mitigate the threat that malicious VMs can
>  cause CPU stuck (due to event windows don't open up) and make the CPU
>  unavailable to host or other VMs.
>  
> +7.34 KVM_CAP_X86_BUS_FREQUENCY_CONTROL
> +--------------------------------------
> +
> +:Architectures: x86
> +:Target: VM
> +:Parameters: args[0] is the value of apic bus clock frequency
> +:Returns: 0 on success, -EINVAL if args[0] contains invalid value for the
> +          frequency, or -ENXIO if virtual local APIC isn't enabled by
> +          KVM_CREATE_IRQCHIP, or -EBUSY if any vcpu is created.
> +
> +This capability sets the APIC bus clock frequency (or core crystal clock
> +frequency) for kvm to emulate APIC in the kernel.  The default value is 1000000
> +(1GHz).
> +
>  8. Other capabilities.
>  ======================
>  
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index a9f4991b3e2e..a8fb862c4f8e 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4625,6 +4625,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  	case KVM_CAP_ENABLE_CAP:
>  	case KVM_CAP_VM_DISABLE_NX_HUGE_PAGES:
>  	case KVM_CAP_IRQFD_RESAMPLE:
> +	case KVM_CAP_X86_BUS_FREQUENCY_CONTROL:
>  		r = 1;
>  		break;
>  	case KVM_CAP_EXIT_HYPERCALL:
> @@ -6616,6 +6617,40 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>  		}
>  		mutex_unlock(&kvm->lock);
>  		break;
> +	case KVM_CAP_X86_BUS_FREQUENCY_CONTROL: {
> +		u64 bus_frequency = cap->args[0];
> +		u64 bus_cycle_ns;
> +
> +		if (!bus_frequency)
> +			return -EINVAL;
> +		/* CPUID[0x15] only support 32bits.  */
> +		if (bus_frequency != (u32)bus_frequency)
> +			return -EINVAL;
> +
> +		/* Cast to avoid 64bit division on 32bit platform. */
> +		bus_cycle_ns = 1000000000UL / (u32)bus_frequency;
> +		if (!bus_cycle_ns)
> +			return -EINVAL;
> +
> +		r = 0;
> +		mutex_lock(&kvm->lock);
> +		/*
> +		 * Don't allow to change the frequency dynamically during vcpu
> +		 * running to avoid potentially bizarre behavior.
> +		 */
> +		if (kvm->created_vcpus)
> +			r = -EBUSY;
> +		/* This is for in-kernel vAPIC emulation. */
> +		else if (!irqchip_in_kernel(kvm))
> +			r = -ENXIO;
> +
> +		if (!r) {
> +			kvm->arch.apic_bus_cycle_ns = bus_cycle_ns;
> +			kvm->arch.apic_bus_frequency = bus_frequency;
> +		}
> +		mutex_unlock(&kvm->lock);
> +		return r;
> +	}
>  	default:
>  		r = -EINVAL;
>  		break;
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 211b86de35ac..d74a057df173 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1201,6 +1201,7 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE 228
>  #define KVM_CAP_ARM_SUPPORTED_BLOCK_SIZES 229
>  #define KVM_CAP_ARM_SUPPORTED_REG_MASK_RANGES 230
> +#define KVM_CAP_X86_BUS_FREQUENCY_CONTROL 231
>  
>  #ifdef KVM_CAP_IRQ_ROUTING
>  



