Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 924803D139D
	for <lists+kvm@lfdr.de>; Wed, 21 Jul 2021 18:16:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231756AbhGUPgB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jul 2021 11:36:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41021 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230336AbhGUPgB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 21 Jul 2021 11:36:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626884197;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IcSV6p3DsGPg3q7H9uG8rdf3PK9RYtHNWHXgMTJFgSw=;
        b=NMUKOohnIJCthc4CkZnP9I08yNYMSMWd9mvOpv8lkKKpil9x3PJuAs22Pwui+O5DyT3PVa
        fhSSmhUH/g9zXAKaav3cZn5yCR5gfRCSl5FeE1Q3Xt0cDC5xrZDln9BsizuNWR7lOzH8yJ
        cMBcj7yi5CHtZdDYzYQSGNBL6chQmFE=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-264-bany-qnsPGuOTxXgxNKe9A-1; Wed, 21 Jul 2021 12:16:35 -0400
X-MC-Unique: bany-qnsPGuOTxXgxNKe9A-1
Received: by mail-io1-f71.google.com with SMTP id l15-20020a5e820f0000b02904bd1794d00eso1921101iom.7
        for <kvm@vger.kernel.org>; Wed, 21 Jul 2021 09:16:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IcSV6p3DsGPg3q7H9uG8rdf3PK9RYtHNWHXgMTJFgSw=;
        b=hvIAULJRqlPWkGpcWEOwmgBK9FF+1QfMBBTNoXSaBYmspPtz01uWEGbpEYH/es7bOT
         ROpJ+JpjtQI6YPlcQ1i1ePjv7TnCavu9UCMAIY/NhMx0A2gb5kEH5Ac7jX9trI44Jf7V
         N3MF20PWF9utGBJ99LttcRNBD5wV04o9ii/FRR/dG1r0rMJxT6fc+aO3OYYSn2Ed7OM8
         heQ4rRW+Xjdm+se3soJd8PTdtjs3yW5UU2QPqotCXIJyC6DNJu0GhcPaYHi0P1N0soGN
         o9fTWloWrlylKCjaSWUgM5EkbGRelxzNeCI30TV0x3UbU4u43LB8g2S4lj2ksHzZEtZ+
         GKeQ==
X-Gm-Message-State: AOAM531Yu/mNcfxE4HFnQGE4wt04g/s+El0T5f/up1oXCOL7yjBVuOhE
        V8en7UZtnfgqFUWLrVGfs4aGbEIepWFS5ely4d+i9w5B7irt69OUtgkMYvFSpQ9LXHzwb+FdLdH
        uC16Kx0FidOpP
X-Received: by 2002:a05:6e02:ea9:: with SMTP id u9mr24497384ilj.174.1626884194626;
        Wed, 21 Jul 2021 09:16:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy/IBOod66B4GglMJLgXKr35GBUPC3amMbq6Jd0LtCJ6mFrJw0uOyg05WtQr7pLrGObTD7EEQ==
X-Received: by 2002:a05:6e02:ea9:: with SMTP id u9mr24497370ilj.174.1626884194383;
        Wed, 21 Jul 2021 09:16:34 -0700 (PDT)
Received: from gator ([140.82.166.162])
        by smtp.gmail.com with ESMTPSA id w14sm10296889ilj.76.2021.07.21.09.16.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jul 2021 09:16:33 -0700 (PDT)
Date:   Wed, 21 Jul 2021 18:16:31 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Oliver Upton <oupton@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Marc Zyngier <maz@kernel.org>,
        Raghavendra Rao Anata <rananta@google.com>,
        Peter Shier <pshier@google.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-arm-kernel@lists.infradead.org,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH v3 08/12] KVM: arm64: Allow userspace to configure a
 vCPU's virtual offset
Message-ID: <20210721161631.mrfiuusc5zou4we5@gator>
References: <20210719184949.1385910-1-oupton@google.com>
 <20210719184949.1385910-9-oupton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210719184949.1385910-9-oupton@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 19, 2021 at 06:49:45PM +0000, Oliver Upton wrote:
> Add a new vCPU attribute that allows userspace to directly manipulate
> the virtual counter-timer offset. Exposing such an interface allows for
> the precise migration of guest virtual counter-timers, as it is an
> indepotent interface.
> 
> Uphold the existing behavior of writes to CNTVOFF_EL2 for this new
> interface, wherein a write to a single vCPU is broadcasted to all vCPUs
> within a VM.
> 
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  Documentation/virt/kvm/devices/vcpu.rst | 22 ++++++++
>  arch/arm64/include/uapi/asm/kvm.h       |  1 +
>  arch/arm64/kvm/arch_timer.c             | 68 ++++++++++++++++++++++++-
>  3 files changed, 89 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/devices/vcpu.rst b/Documentation/virt/kvm/devices/vcpu.rst
> index b46d5f742e69..7b57cba3416a 100644
> --- a/Documentation/virt/kvm/devices/vcpu.rst
> +++ b/Documentation/virt/kvm/devices/vcpu.rst
> @@ -139,6 +139,28 @@ configured values on other VCPUs.  Userspace should configure the interrupt
>  numbers on at least one VCPU after creating all VCPUs and before running any
>  VCPUs.
>  
> +2.2. ATTRIBUTE: KVM_ARM_VCPU_TIMER_OFFSET_VTIMER
> +------------------------------------------------
> +
> +:Parameters: Pointer to a 64-bit unsigned counter-timer offset.
> +
> +Returns:
> +
> +	 ======= ======================================
> +	 -EFAULT Error reading/writing the provided
> +	 	 parameter address
> +	 -ENXIO  Attribute not supported
> +	 ======= ======================================
> +
> +Specifies the guest's virtual counter-timer offset from the host's
> +virtual counter. The guest's virtual counter is then derived by
> +the following equation:
> +
> +  guest_cntvct = host_cntvct - KVM_ARM_VCPU_TIMER_OFFSET_VTIMER
> +
> +KVM does not allow the use of varying offset values for different vCPUs;
> +the last written offset value will be broadcasted to all vCPUs in a VM.
> +
>  3. GROUP: KVM_ARM_VCPU_PVTIME_CTRL
>  ==================================
>  
> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> index b3edde68bc3e..008d0518d2b1 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -365,6 +365,7 @@ struct kvm_arm_copy_mte_tags {
>  #define KVM_ARM_VCPU_TIMER_CTRL		1
>  #define   KVM_ARM_VCPU_TIMER_IRQ_VTIMER		0
>  #define   KVM_ARM_VCPU_TIMER_IRQ_PTIMER		1
> +#define   KVM_ARM_VCPU_TIMER_OFFSET_VTIMER	2
>  #define KVM_ARM_VCPU_PVTIME_CTRL	2
>  #define   KVM_ARM_VCPU_PVTIME_IPA	0
>  
> diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
> index 3df67c127489..d2b1b13af658 100644
> --- a/arch/arm64/kvm/arch_timer.c
> +++ b/arch/arm64/kvm/arch_timer.c
> @@ -1305,7 +1305,7 @@ static void set_timer_irqs(struct kvm *kvm, int vtimer_irq, int ptimer_irq)
>  	}
>  }
>  
> -int kvm_arm_timer_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
> +int kvm_arm_timer_set_attr_irq(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
>  {
>  	int __user *uaddr = (int __user *)(long)attr->addr;
>  	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
> @@ -1338,7 +1338,39 @@ int kvm_arm_timer_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
>  	return 0;
>  }
>  
> -int kvm_arm_timer_get_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
> +int kvm_arm_timer_set_attr_offset(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
> +{
> +	u64 __user *uaddr = (u64 __user *)(long)attr->addr;
> +	u64 offset;
> +
> +	if (get_user(offset, uaddr))
> +		return -EFAULT;
> +
> +	switch (attr->attr) {
> +	case KVM_ARM_VCPU_TIMER_OFFSET_VTIMER:
> +		update_vtimer_cntvoff(vcpu, offset);
> +		break;
> +	default:
> +		return -ENXIO;
> +	}
> +
> +	return 0;
> +}
> +
> +int kvm_arm_timer_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
> +{
> +	switch (attr->attr) {
> +	case KVM_ARM_VCPU_TIMER_IRQ_VTIMER:
> +	case KVM_ARM_VCPU_TIMER_IRQ_PTIMER:
> +		return kvm_arm_timer_set_attr_irq(vcpu, attr);
> +	case KVM_ARM_VCPU_TIMER_OFFSET_VTIMER:
> +		return kvm_arm_timer_set_attr_offset(vcpu, attr);
> +	}
> +
> +	return -ENXIO;
> +}
> +
> +int kvm_arm_timer_get_attr_irq(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
>  {
>  	int __user *uaddr = (int __user *)(long)attr->addr;
>  	struct arch_timer_context *timer;
> @@ -1359,11 +1391,43 @@ int kvm_arm_timer_get_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
>  	return put_user(irq, uaddr);
>  }
>  
> +int kvm_arm_timer_get_attr_offset(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
> +{
> +	u64 __user *uaddr = (u64 __user *)(long)attr->addr;
> +	struct arch_timer_context *timer;
> +	u64 offset;
> +
> +	switch (attr->attr) {
> +	case KVM_ARM_VCPU_TIMER_OFFSET_VTIMER:
> +		timer = vcpu_vtimer(vcpu);
> +		break;
> +	default:
> +		return -ENXIO;
> +	}
> +
> +	offset = timer_get_offset(timer);
> +	return put_user(offset, uaddr);
> +}
> +
> +int kvm_arm_timer_get_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
> +{
> +	switch (attr->attr) {
> +	case KVM_ARM_VCPU_TIMER_IRQ_VTIMER:
> +	case KVM_ARM_VCPU_TIMER_IRQ_PTIMER:
> +		return kvm_arm_timer_get_attr_irq(vcpu, attr);
> +	case KVM_ARM_VCPU_TIMER_OFFSET_VTIMER:
> +		return kvm_arm_timer_get_attr_offset(vcpu, attr);
> +	}
> +
> +	return -ENXIO;
> +}
> +
>  int kvm_arm_timer_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
>  {
>  	switch (attr->attr) {
>  	case KVM_ARM_VCPU_TIMER_IRQ_VTIMER:
>  	case KVM_ARM_VCPU_TIMER_IRQ_PTIMER:
> +	case KVM_ARM_VCPU_TIMER_OFFSET_VTIMER:
>  		return 0;
>  	}
>  
> -- 
> 2.32.0.402.g57bb445576-goog
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
>

 
Reviewed-by: Andrew Jones <drjones@redhat.com>

