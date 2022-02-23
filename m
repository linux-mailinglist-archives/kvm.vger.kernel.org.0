Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA9004C140B
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 14:22:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240883AbiBWNWP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 08:22:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240878AbiBWNWO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 08:22:14 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 92CC950063
        for <kvm@vger.kernel.org>; Wed, 23 Feb 2022 05:21:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645622505;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Stmc0lrGFCY4geeBIR1uVPmRd61BM5nghyjbFykuTZQ=;
        b=f/FzaFRF/k+4tceQDwq8E7lssHz8dXpaan9lTXSEjQY90gGNdxS8cxNz/35xo0SOCsdv8V
        Cay+3wtWnRAc8ofKu2uG3iJJQ+Nehz7AG0HR/zx/Gigj6+tUdR6Us/vT7hF0bDBJCIN5xt
        4Te+w1/98Re0YZXINr8C8S+2gIG3QRQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-264-1XMBF8T6PfuJyRb8FD59tg-1; Wed, 23 Feb 2022 08:21:42 -0500
X-MC-Unique: 1XMBF8T6PfuJyRb8FD59tg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 86EAC800496;
        Wed, 23 Feb 2022 13:21:41 +0000 (UTC)
Received: from starship (unknown [10.40.195.190])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2C1768329C;
        Wed, 23 Feb 2022 13:21:39 +0000 (UTC)
Message-ID: <9bc07e61053b5724b0d0730943f40039fb8d4727.camel@redhat.com>
Subject: Re: [PATCH v3 1/6] KVM: x86: return 1 unconditionally for
 availability of KVM_CAP_VAPIC
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     seanjc@google.com
Date:   Wed, 23 Feb 2022 15:21:38 +0200
In-Reply-To: <20220217180831.288210-2-pbonzini@redhat.com>
References: <20220217180831.288210-1-pbonzini@redhat.com>
         <20220217180831.288210-2-pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-02-17 at 13:08 -0500, Paolo Bonzini wrote:
> The two ioctl used to implement userspace-accelerated TPR,
> KVM_TPR_ACCESS_REPORTING and KVM_SET_VAPIC_ADDR, are available
> even if hardware-accelerated TPR can be used.  So there is
> no reason not to report KVM_CAP_VAPIC.

Just my 0.2 cents - some time ago I did some archeological digging on 
this feature:

with AVIC, read/writes to TPR register will not #VMEXIT, thus KVM_TPR_ACCESS_REPORTING
won't work.

On SVM, CR8 writes when intercepted don't go through kvm_lapic_reg_write thus won't
be reported as well, which might even be intentional since guest which uses CR8,
is not supposed to use the MMIO.

In fact AMD's manual suggests that even 32 bit guests should use CR8 to access TPR,
and provides a special optcode to do so.
I assume that is because SVM lacks the TPR threshold feature.


On VMX side of things, I also think that TPR writes are not trapped when APICv is enabled,
and when APICv is not enabled, TPR access can be trapped conditionally using the TPR
threshold feature.

Another thing to note is that the feature needs an optional rom in the guest
and it seems not to be loaded on uefi bios.

Nothing against this patch though - in fact looks like qemu doesn't check the
KVM_CAP_VAPIC at all.

Best regards,
	Maxim Levitsky

> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/include/asm/kvm-x86-ops.h | 1 -
>  arch/x86/include/asm/kvm_host.h    | 1 -
>  arch/x86/kvm/svm/svm.c             | 6 ------
>  arch/x86/kvm/vmx/vmx.c             | 6 ------
>  arch/x86/kvm/x86.c                 | 4 +---
>  5 files changed, 1 insertion(+), 17 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> index 9e37dc3d8863..695ed7feef7e 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -15,7 +15,6 @@ BUILD_BUG_ON(1)
>  KVM_X86_OP_NULL(hardware_enable)
>  KVM_X86_OP_NULL(hardware_disable)
>  KVM_X86_OP_NULL(hardware_unsetup)
> -KVM_X86_OP_NULL(cpu_has_accelerated_tpr)
>  KVM_X86_OP(has_emulated_msr)
>  KVM_X86_OP(vcpu_after_set_cpuid)
>  KVM_X86_OP(vm_init)
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 10815b672a26..e0d2cdfe54ab 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1318,7 +1318,6 @@ struct kvm_x86_ops {
>  	int (*hardware_enable)(void);
>  	void (*hardware_disable)(void);
>  	void (*hardware_unsetup)(void);
> -	bool (*cpu_has_accelerated_tpr)(void);
>  	bool (*has_emulated_msr)(struct kvm *kvm, u32 index);
>  	void (*vcpu_after_set_cpuid)(struct kvm_vcpu *vcpu);
>  
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 4243bb355db0..abced3fe2013 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3912,11 +3912,6 @@ static int __init svm_check_processor_compat(void)
>  	return 0;
>  }
>  
> -static bool svm_cpu_has_accelerated_tpr(void)
> -{
> -	return false;
> -}
> -
>  /*
>   * The kvm parameter can be NULL (module initialization, or invocation before
>   * VM creation). Be sure to check the kvm parameter before using it.
> @@ -4529,7 +4524,6 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
>  	.hardware_unsetup = svm_hardware_unsetup,
>  	.hardware_enable = svm_hardware_enable,
>  	.hardware_disable = svm_hardware_disable,
> -	.cpu_has_accelerated_tpr = svm_cpu_has_accelerated_tpr,
>  	.has_emulated_msr = svm_has_emulated_msr,
>  
>  	.vcpu_create = svm_vcpu_create,
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 70e7f00362bc..d8547144d3b7 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -541,11 +541,6 @@ static inline bool cpu_need_virtualize_apic_accesses(struct kvm_vcpu *vcpu)
>  	return flexpriority_enabled && lapic_in_kernel(vcpu);
>  }
>  
> -static inline bool vmx_cpu_has_accelerated_tpr(void)
> -{
> -	return flexpriority_enabled;
> -}
> -
>  static int possible_passthrough_msr_slot(u32 msr)
>  {
>  	u32 i;
> @@ -7714,7 +7709,6 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
>  
>  	.hardware_enable = vmx_hardware_enable,
>  	.hardware_disable = vmx_hardware_disable,
> -	.cpu_has_accelerated_tpr = vmx_cpu_has_accelerated_tpr,
>  	.has_emulated_msr = vmx_has_emulated_msr,
>  
>  	.vm_size = sizeof(struct kvm_vmx),
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index eaa3b5b89c5e..746f72ae2c95 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4234,6 +4234,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  	case KVM_CAP_EXIT_ON_EMULATION_FAILURE:
>  	case KVM_CAP_VCPU_ATTRIBUTES:
>  	case KVM_CAP_SYS_ATTRIBUTES:
> +	case KVM_CAP_VAPIC:
>  		r = 1;
>  		break;
>  	case KVM_CAP_EXIT_HYPERCALL:
> @@ -4274,9 +4275,6 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  		 */
>  		r = static_call(kvm_x86_has_emulated_msr)(kvm, MSR_IA32_SMBASE);
>  		break;
> -	case KVM_CAP_VAPIC:
> -		r = !static_call(kvm_x86_cpu_has_accelerated_tpr)();
> -		break;
>  	case KVM_CAP_NR_VCPUS:
>  		r = min_t(unsigned int, num_online_cpus(), KVM_MAX_VCPUS);
>  		break;


