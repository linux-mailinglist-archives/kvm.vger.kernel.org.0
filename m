Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2807E539382
	for <lists+kvm@lfdr.de>; Tue, 31 May 2022 17:02:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344487AbiEaPCI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 May 2022 11:02:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345444AbiEaPCH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 May 2022 11:02:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 362EE6C552
        for <kvm@vger.kernel.org>; Tue, 31 May 2022 08:02:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654009322;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XzbU7ELZz1DevdyaqWCyXvdPZSvnXVBgYNGI/O7/oDA=;
        b=YASTgrycP1ezOmvFUOUDbVOusXfVx9+NBbeK/nZ+DbLCcSxvk/bD317+XC03WbLK7HRpSV
        QxPHR0xRV5g+TulvnvP8y4aXDC7f5FvfLF/9y7wmLhd+ZsBul85RFh5spQG4jKfF2vguyR
        XvTU182CpEf8tvqUl8U61j4fG6W3NUo=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-182-j4SvJZdbNEuMKMbnrQP6Ng-1; Tue, 31 May 2022 11:02:01 -0400
X-MC-Unique: j4SvJZdbNEuMKMbnrQP6Ng-1
Received: by mail-ed1-f70.google.com with SMTP id f9-20020a056402354900b0042ded146259so765959edd.20
        for <kvm@vger.kernel.org>; Tue, 31 May 2022 08:02:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=XzbU7ELZz1DevdyaqWCyXvdPZSvnXVBgYNGI/O7/oDA=;
        b=fe2zSL5r5xNa7D3dTSZ7FCHwhcsVOTWzhLQMBCr3RNTQxmSnTTmrxGaKDtfuyoQGzK
         ArolRanzul0Rdk4OtrDGHds9lu1md9FQhTucxxkvfCvNQTFhHMdGjaFh8XFtIKLdCAFU
         Eh4iwF0BmDSrcdW/ZneG5VgYqXMLu5K6k7zE+s5QPZvY25w3ZdsGtpeUhB+T19cCLUEM
         tcH7nEF4m0lQJRGlx754X7DMOGZkSsUWKpyazmAdKEMVHOSTtEvLymM6LyPkLEsJQzzJ
         2xVYUsyUjKozqKzPp8OjHQjHDzukeMxDckbiGGMIm6XTKVHcSYqkvF+JIIeleUXqBruN
         M89g==
X-Gm-Message-State: AOAM533DT59DpV9uC2+UZ2mmTevPglfddHo64QgDWREmU1q9nJTWPWtx
        /PmLUgsatyE/qEwkq4aLZZF666AStDJEyuv/TDZgG3U3TezTe9V6bb6ctxzR53H8/J2jkoIYMg0
        TSyS0AiR2HSrl
X-Received: by 2002:a17:906:7954:b0:6fe:d9af:feb0 with SMTP id l20-20020a170906795400b006fed9affeb0mr38471311ejo.361.1654009314248;
        Tue, 31 May 2022 08:01:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwy32kSgQfcq9zj0CzflX76ppVk5rFcSqvYggQDREzzCFYr5AsPYwPoePhcHG2cNnUNcdRy1w==
X-Received: by 2002:a17:906:7954:b0:6fe:d9af:feb0 with SMTP id l20-20020a170906795400b006fed9affeb0mr38471270ejo.361.1654009313938;
        Tue, 31 May 2022 08:01:53 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id g3-20020a1709063b0300b006feb3d65330sm5046484ejf.109.2022.05.31.08.01.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 May 2022 08:01:53 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Jack Allister <jalliste@amazon.com>
Cc:     diapop@amazon.co.uk, metikaya@amazon.co.uk,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: VMX: CPU frequency scaling for intel x86_64 KVM
 guests
In-Reply-To: <20220531105925.27676-1-jalliste@amazon.com>
References: <20220531105925.27676-1-jalliste@amazon.com>
Date:   Tue, 31 May 2022 17:01:52 +0200
Message-ID: <871qw9pwyn.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Jack Allister <jalliste@amazon.com> writes:

> A VMM can control a vCPU's CPU frequency by interfacing with KVM via
> the vCPU file descriptor to enable/set CPU frequency scaling for a
> guest. Instead of creating a separate IOCTL to this this, KVM capabil-
> ities are extended to include a capability called
> KVM_CAP_CPU_FREQ_SCALING.
>
> A generic set_cpu_freq interface is added to kvm_x86_ops
> to allow for architecture (AMD/Intel) independent CPU frequency
> scaling setting.
>
> For Intel platforms, Hardware-Controlled Performance States (HWP) are
> used to implement CPU scaling within the guest. Further information on
> this mechanism can be seen in Intel SDM Vol 3B (section 14.4). The CPU
> frequency is set as soon as this function is called and is kept running
> until explicitly reset or set again.
>
> Currently the AMD frequency setting interface is left unimplemented.
>
> Please note that CPU frequency scaling will have an effect on host
> processing in it's current form. To change back to full performance
> when running in host context an IOCTL with a frequency value of 0
> is needed to run back at uncapped speed.

I may have missed something but it looks like it will also have an
effect on other guests running on the same CPU. Also, nothing guarantees
that the guest vCPU will not get migrated to another CPU. This looks
like a very hard to use interface.

What if you introduce a per-vCPU setting for the desired frequency and
set it every time the vCPU is loaded on a pCPU and then restore back the
original frequency when it is unloaded (and assuming nobody else touched
it while the vCPU was running)?

>
> Signed-off-by: Jack Allister <jalliste@amazon.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  2 +
>  arch/x86/kvm/vmx/vmx.c          | 91 +++++++++++++++++++++++++++++++++
>  arch/x86/kvm/x86.c              | 16 ++++++
>  include/uapi/linux/kvm.h        |  1 +
>  4 files changed, 110 insertions(+)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index ae220f88f00d..d2efc2ce624f 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1169,6 +1169,8 @@ struct kvm_x86_ops {
>  	bool (*rdtscp_supported)(void);
>  	bool (*invpcid_supported)(void);
>  
> +	int (*set_cpu_freq_scaling)(struct kvm_vcpu *vcpu, u8 freq_100mhz);
> +
>  	void (*set_tdp_cr3)(struct kvm_vcpu *vcpu, unsigned long cr3);
>  
>  	void (*set_supported_cpuid)(u32 func, struct kvm_cpuid_entry2 *entry);
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 6499f371de58..beee39b57b13 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1699,6 +1699,95 @@ static bool vmx_invpcid_supported(void)
>  	return cpu_has_vmx_invpcid();
>  }
>  
> +static int vmx_query_cpu_freq_valid_freq(u8 freq)
> +{
> +#define MASK_PERF 0xFF
> +#define CAP_HIGHEST_SHIFT 0
> +#define CAP_LOWEST_SHIFT 24
> +#define CAP_HIGHEST_MASK (MASK_PERF << CAP_HIGHEST_SHIFT)
> +#define CAP_LOWEST_MASK (MASK_PERF << CAP_LOWEST_SHIFT)
> +	u64 cap_msr;
> +	u8 highest, lowest;
> +
> +	/* Query highest and lowest supported scaling. */
> +	rdmsrl(MSR_HWP_CAPABILITIES, cap_msr);
> +	highest = (u8)(cap_msr & CAP_HIGHEST_MASK);
> +	lowest = (u8)((cap_msr & CAP_LOWEST_MASK) >> CAP_LOWEST_SHIFT);
> +
> +	if (freq < lowest || freq > highest)
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
> +static void vmx_set_cpu_freq_uncapped(void)
> +{
> +#define SHIFT_DESIRED_PERF 16
> +#define SHIFT_MAX_PERF 8
> +#define SHIFT_MIN_PERF 0
> +
> +	u64 cap_msr, req_msr;
> +	u8 highest, lowest;
> +
> +	/* Query the capabilities. */
> +	rdmsrl(MSR_HWP_CAPABILITIES, cap_msr);
> +	highest = (u8)(cap_msr & CAP_HIGHEST_MASK);
> +	lowest = (u8)((cap_msr & CAP_LOWEST_MASK) >> CAP_LOWEST_SHIFT);
> +
> +	/* Set the desired to highest performance. */
> +	req_msr = ((highest & MASK_PERF) << SHIFT_DESIRED_PERF) |
> +		((highest & MASK_PERF) << SHIFT_MAX_PERF) |
> +		((lowest & MASK_PERF) << SHIFT_MIN_PERF);
> +	wrmsrl(MSR_HWP_REQUEST, req_msr);
> +}
> +
> +static void vmx_set_cpu_freq_capped(u8 freq_100mhz)
> +{
> +	u64 req_msr;
> +
> +	/* Populate the variable used for setting the HWP request. */
> +	req_msr = ((freq_100mhz & MASK_PERF) << SHIFT_DESIRED_PERF) |
> +		((freq_100mhz & MASK_PERF) << SHIFT_MAX_PERF) |
> +		((freq_100mhz & MASK_PERF) << SHIFT_MIN_PERF);
> +
> +	wrmsrl(MSR_HWP_REQUEST, req_msr);
> +}
> +
> +static int vmx_set_cpu_freq_scaling(struct kvm_vcpu *vcpu, u8 freq_100mhz)
> +{
> +	struct kvm *kvm = vcpu->kvm;
> +	u64 pm_before, req_msr;
> +	int rc;
> +
> +	/* Is HWP scaling supported? */
> +	if (!this_cpu_has(X86_FEATURE_HWP))
> +		return -ENODEV;
> +
> +	/*
> +	 * HWP needs to be enabled to query & use capabilities.
> +	 * This bit is W1Once so cannot be cleared after.
> +	 */
> +	rdmsrl(MSR_PM_ENABLE, pm_before);
> +	if ((pm_before & 1) == 0)
> +		wrmsrl(MSR_PM_ENABLE, pm_before | 1);
> +
> +	/*
> +	 * Check if setting to a specific value, if being set
> +	 * to zero this means return to uncapped frequency.
> +	 */
> +	if (freq_100mhz) {
> +		rc = vmx_query_cpu_freq_valid_freq(freq_100mhz);
> +
> +		if (rc)
> +			return rc;
> +
> +		vmx_set_cpu_freq_capped(freq_100mhz);
> +	} else
> +		vmx_set_cpu_freq_uncapped();
> +
> +	return 0;
> +}
> +
>  /*
>   * Swap MSR entry in host/guest MSR entry array.
>   */
> @@ -8124,6 +8213,8 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
>  	.rdtscp_supported = vmx_rdtscp_supported,
>  	.invpcid_supported = vmx_invpcid_supported,
>  
> +	.set_cpu_freq_scaling = vmx_set_cpu_freq_scaling,
> +
>  	.set_supported_cpuid = vmx_set_supported_cpuid,
>  
>  	.has_wbinvd_exit = cpu_has_vmx_wbinvd_exit,
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index c33423a1a13d..9ae2ab102e01 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3669,6 +3669,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  	case KVM_CAP_SET_VAR_MTRR_COUNT:
>  	case KVM_CAP_X86_USER_SPACE_MSR:
>  	case KVM_CAP_X86_MSR_FILTER:
> +	case KVM_CAP_CPU_FREQ_SCALING:
>  		r = 1;
>  		break;
>  #ifdef CONFIG_KVM_XEN
> @@ -4499,6 +4500,19 @@ static int kvm_vcpu_ioctl_x86_set_xcrs(struct kvm_vcpu *vcpu,
>  	return r;
>  }
>  
> +static int kvm_cap_set_cpu_freq(struct kvm_vcpu *vcpu,
> +				       struct kvm_enable_cap *cap)
> +{
> +	u8 freq = (u8)cap->args[0];
> +
> +	/* Query whether this platform (Intel or AMD) support setting. */
> +	if (!kvm_x86_ops.set_cpu_freq_scaling)
> +		return -ENODEV;
> +
> +	/* Attempt to set to the frequency specified. */
> +	return kvm_x86_ops.set_cpu_freq_scaling(vcpu, freq);
> +}
> +
>  /*
>   * kvm_set_guest_paused() indicates to the guest kernel that it has been
>   * stopped by the hypervisor.  This function will be called from the host only.
> @@ -4553,6 +4567,8 @@ static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
>  		return kvm_x86_ops.enable_direct_tlbflush(vcpu);
>  	case KVM_CAP_SET_VAR_MTRR_COUNT:
>  		return kvm_mtrr_set_var_mtrr_count(vcpu, cap->args[0]);
> +	case KVM_CAP_CPU_FREQ_SCALING:
> +		return kvm_cap_set_cpu_freq(vcpu, cap);
>  
>  	default:
>  		return -EINVAL;
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 831be0d2d5e4..273a3ab5590e 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -874,6 +874,7 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_CAP_NO_POLL_ON_HLT 100003
>  #define KVM_CAP_MMU_USE_VMA_CAPMEM 100004
>  #define KVM_CAP_MMU_SUPPORT_DYNAMIC_CAPMEM 100005
> +#define KVM_CAP_CPU_FREQ_SCALING 100006
>  
>  #define KVM_CAP_IRQCHIP	  0
>  #define KVM_CAP_HLT	  1

-- 
Vitaly

