Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4C6F4F40A2
	for <lists+kvm@lfdr.de>; Tue,  5 Apr 2022 23:19:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235275AbiDEOuP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Apr 2022 10:50:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379544AbiDENey (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Apr 2022 09:34:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 56C7A13E15E
        for <kvm@vger.kernel.org>; Tue,  5 Apr 2022 05:42:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649162529;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H0APKANmrEG8YzfakBH1QUxjkhifm2uURbUzbSfC/2c=;
        b=dl95sNI/DYBgflPJJrIdnfY/iVyWoE5gqgDqOEfIAcZwmV9AHcNbMDsnMvaoWHGLg6u1H+
        fYUP65or1QHW2qLIw+84qn5OsE+9r4bcZUDLRMrzAvelf5+Lx3ymx+aCAII21kAUjhoLuW
        Lf68VlDR7j+tFAibFEMAFdkXpxT8y68=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-658-NIJfi-SzP42UKzs_GANHlQ-1; Tue, 05 Apr 2022 08:42:08 -0400
X-MC-Unique: NIJfi-SzP42UKzs_GANHlQ-1
Received: by mail-wr1-f71.google.com with SMTP id z16-20020adff1d0000000b001ef7dc78b23so2430127wro.12
        for <kvm@vger.kernel.org>; Tue, 05 Apr 2022 05:42:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=H0APKANmrEG8YzfakBH1QUxjkhifm2uURbUzbSfC/2c=;
        b=QsyVu1Hw8/ubI9EN8WBhew2hP1GxPbrk0EW1ynHTjA05HX2fFutYy9SwEALNSCMLLz
         P1F2dDVp8iTI2Nq/xXMV/8m0H8nE56m8nmnu9qxbzZMwRXu3iFe9cI2+WZitvn8szn5J
         874KvEg7s/w1L9hcMLeHyrVxNLGwl8SZDIPvnsQmA90QPyrZZugKe8DFnUkkvjuGNTQ8
         T/bVXU11yIDT90aqwHQtQS0Ssn+TSgAYpQDqP2VkbTOKkNUPLZ6JIMpaw+K/9/jKI7jO
         0uHzZE/mfJQaI16ENSQGIPOp6jNCmzDlRYf01xOunluYqe33fcdBXHrYczxphyzBWfXN
         1gtw==
X-Gm-Message-State: AOAM532IndnuXDlKDrDYsqTPATd0AaqNnupqUtvcvpqH3DPCfV0oiplp
        OTbVGVKnaBOiwqPz4UPf4QP01MvJ8k/vsHn1qpcX1OWQxrVjgVFoEm8FY3FGzPTk2ZhAfKBQFRY
        9ohXPiJbGSvQD
X-Received: by 2002:a05:600c:190e:b0:38c:b1ea:f4ac with SMTP id j14-20020a05600c190e00b0038cb1eaf4acmr2938048wmq.70.1649162526868;
        Tue, 05 Apr 2022 05:42:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzE8lOSJsC1vu9YrVZ8kWphJzexS1UEyH2gUdxXfFYpfE6UWb3J1TmoORH/TfcRQQNlqZoBNw==
X-Received: by 2002:a05:600c:190e:b0:38c:b1ea:f4ac with SMTP id j14-20020a05600c190e00b0038cb1eaf4acmr2938035wmq.70.1649162526641;
        Tue, 05 Apr 2022 05:42:06 -0700 (PDT)
Received: from [10.32.181.87] (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.googlemail.com with ESMTPSA id n20-20020a05600c4f9400b0038cbd13e06esm2196316wmq.2.2022.04.05.05.42.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Apr 2022 05:42:05 -0700 (PDT)
Message-ID: <80029ed6-a276-16f6-710e-9d9d642a54fd@redhat.com>
Date:   Tue, 5 Apr 2022 14:42:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH v5 022/104] KVM: Add max_vcpus field in common 'struct
 kvm'
Content-Language: en-US
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Jim Mattson <jmattson@google.com>,
        erdemaktas@google.com, Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <e53234cdee6a92357d06c80c03d77c19cdefb804.1646422845.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <e53234cdee6a92357d06c80c03d77c19cdefb804.1646422845.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/4/22 20:48, isaku.yamahata@intel.com wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> For TDX guests, the maximum number of vcpus needs to be specified when the
> TDX guest VM is initialized (creating the TDX data corresponding to TDX
> guest) before creating vcpu.  It needs to record the maximum number of
> vcpus on VM creation (KVM_CREATE_VM) and return error if the number of
> vcpus exceeds it
> 
> Because there is already max_vcpu member in arm64 struct kvm_arch, move it
> to common struct kvm and initialize it to KVM_MAX_VCPUS before
> kvm_arch_init_vm() instead of adding it to x86 struct kvm_arch.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/arm64/include/asm/kvm_host.h | 3 ---
>   arch/arm64/kvm/arm.c              | 6 +++---
>   arch/arm64/kvm/vgic/vgic-init.c   | 6 +++---
>   include/linux/kvm_host.h          | 1 +
>   virt/kvm/kvm_main.c               | 3 ++-
>   5 files changed, 9 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 5bc01e62c08a..27249d634605 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -107,9 +107,6 @@ struct kvm_arch {
>   	/* VTCR_EL2 value for this VM */
>   	u64    vtcr;
>   
> -	/* The maximum number of vCPUs depends on the used GIC model */
> -	int max_vcpus;
> -
>   	/* Interrupt controller */
>   	struct vgic_dist	vgic;
>   
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index ecc5958e27fe..defec2cd94bd 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -153,7 +153,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>   	kvm_vgic_early_init(kvm);
>   
>   	/* The maximum number of VCPUs is limited by the host's GIC model */
> -	kvm->arch.max_vcpus = kvm_arm_default_max_vcpus();
> +	kvm->max_vcpus = kvm_arm_default_max_vcpus();
>   
>   	set_default_spectre(kvm);
>   
> @@ -229,7 +229,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>   	case KVM_CAP_MAX_VCPUS:
>   	case KVM_CAP_MAX_VCPU_ID:
>   		if (kvm)
> -			r = kvm->arch.max_vcpus;
> +			r = kvm->max_vcpus;
>   		else
>   			r = kvm_arm_default_max_vcpus();
>   		break;
> @@ -305,7 +305,7 @@ int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
>   	if (irqchip_in_kernel(kvm) && vgic_initialized(kvm))
>   		return -EBUSY;
>   
> -	if (id >= kvm->arch.max_vcpus)
> +	if (id >= kvm->max_vcpus)
>   		return -EINVAL;
>   
>   	return 0;
> diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
> index fc00304fe7d8..77feafd5c0e3 100644
> --- a/arch/arm64/kvm/vgic/vgic-init.c
> +++ b/arch/arm64/kvm/vgic/vgic-init.c
> @@ -98,11 +98,11 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
>   	ret = 0;
>   
>   	if (type == KVM_DEV_TYPE_ARM_VGIC_V2)
> -		kvm->arch.max_vcpus = VGIC_V2_MAX_CPUS;
> +		kvm->max_vcpus = VGIC_V2_MAX_CPUS;
>   	else
> -		kvm->arch.max_vcpus = VGIC_V3_MAX_CPUS;
> +		kvm->max_vcpus = VGIC_V3_MAX_CPUS;
>   
> -	if (atomic_read(&kvm->online_vcpus) > kvm->arch.max_vcpus) {
> +	if (atomic_read(&kvm->online_vcpus) > kvm->max_vcpus) {
>   		ret = -E2BIG;
>   		goto out_unlock;
>   	}
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index f11039944c08..a56044a31bc6 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -715,6 +715,7 @@ struct kvm {
>   	 * and is accessed atomically.
>   	 */
>   	atomic_t online_vcpus;
> +	int max_vcpus;
>   	int created_vcpus;
>   	int last_boosted_vcpu;
>   	struct list_head vm_list;
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 52f72a366beb..3adee9c6b370 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1075,6 +1075,7 @@ static struct kvm *kvm_create_vm(unsigned long type)
>   	spin_lock_init(&kvm->gpc_lock);
>   
>   	INIT_LIST_HEAD(&kvm->devices);
> +	kvm->max_vcpus = KVM_MAX_VCPUS;
>   
>   	BUILD_BUG_ON(KVM_MEM_SLOTS_NUM > SHRT_MAX);
>   
> @@ -3718,7 +3719,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
>   		return -EINVAL;
>   
>   	mutex_lock(&kvm->lock);
> -	if (kvm->created_vcpus == KVM_MAX_VCPUS) {
> +	if (kvm->created_vcpus >= kvm->max_vcpus) {
>   		mutex_unlock(&kvm->lock);
>   		return -EINVAL;
>   	}

Queued this one already, thanks.

Paolo

