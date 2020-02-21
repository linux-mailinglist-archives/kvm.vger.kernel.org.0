Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B5621681B3
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2020 16:33:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729108AbgBUPdB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Feb 2020 10:33:01 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:49588 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729062AbgBUPdB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 21 Feb 2020 10:33:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582299179;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PsBV6/KbvwCxicQByPJEUo2GVyBDVRqp1i+UcpJa+e0=;
        b=NEud9/7FsuO5oPYQS8Fii7kYLdA77SKqKkVn2f5oS8BnZZc4AS17yNbM8kU7Q4s9nhyQ67
        LZt2cowYZR9QdxzQtWz0e++ZvxZIFZytVPc8IPTmfncptR5PdlvNAesHAFOgdxeD13mHZB
        S0qyCtbsKl1HDPTXTSYwC8ZO1Yn0J3w=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-102-ySNwxNUPNuSfgWj7Ggic4Q-1; Fri, 21 Feb 2020 10:32:58 -0500
X-MC-Unique: ySNwxNUPNuSfgWj7Ggic4Q-1
Received: by mail-wr1-f70.google.com with SMTP id p8so1179081wrw.5
        for <kvm@vger.kernel.org>; Fri, 21 Feb 2020 07:32:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=PsBV6/KbvwCxicQByPJEUo2GVyBDVRqp1i+UcpJa+e0=;
        b=HZxsl99ZqHhxu+JqWiCmgue6Xo3BX3rk6/gYX0xefwratuZEISWCHHGBG3MWD2ODEF
         bXeyV+xRMnduRNAX9RlCOunzGxXDTvbSkGk96tL4gP8eoPSTLgPfTdqJ0noxQAO079J8
         lnmLGqoCAQfCPY5am+6IIeuR7sLxtjh1AZ/Vkt4zpYzcy/Vd1t7ZV7vIc28eG3zO0kiL
         r9FqgVVygcWzgwHBGpfEGvyQQpn3gpQXp0v7eUn5c008kW3tX5H1SLKq/w0pe3mV4PC7
         w2vuaLPNC+7pAaD0Za4FkzJrNK1zVuOBhYTfpHLajwRmeRj229mnrYZ8ILA8E3zmZMW0
         VXJg==
X-Gm-Message-State: APjAAAXZlxMhOLX5QR5JOEtIa9YRwomC2N0bBJQA4UVmeAh6XYBM6zNR
        rs8YRg8YL1VChgSFSzG+gF2zYfP7pS3QoV5lBtHF4PtoVngd8JA96j9EyDohtFzHACHdomIrbPU
        rwyGU/nfUg5vu
X-Received: by 2002:adf:f44a:: with SMTP id f10mr51287326wrp.16.1582299176722;
        Fri, 21 Feb 2020 07:32:56 -0800 (PST)
X-Google-Smtp-Source: APXvYqzn1MYAtU3Eno+cnYlGWFX4Wfkgii6olk3cU22QAmG/lqfnIfAuKi/wJjXZQBAiVU/X/bklNA==
X-Received: by 2002:adf:f44a:: with SMTP id f10mr51287299wrp.16.1582299176461;
        Fri, 21 Feb 2020 07:32:56 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id o2sm4019446wmh.46.2020.02.21.07.32.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Feb 2020 07:32:55 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 21/61] KVM: x86: Use supported_xcr0 to detect MPX support
In-Reply-To: <20200201185218.24473-22-sean.j.christopherson@intel.com>
References: <20200201185218.24473-1-sean.j.christopherson@intel.com> <20200201185218.24473-22-sean.j.christopherson@intel.com>
Date:   Fri, 21 Feb 2020 16:32:55 +0100
Message-ID: <87k14gq7ko.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Query supported_xcr0 when checking for MPX support instead of invoking
> ->mpx_supported() and drop ->mpx_supported() as kvm_mpx_supported() was
> its last user.  Rename vmx_mpx_supported() to cpu_has_vmx_mpx() to
> better align with VMX/VMCS nomenclature.
>
> Modify VMX's adjustment of xcr0 to call cpus_has_vmx_mpx() (renamed from
> vmx_mpx_supported()) directly to avoid reading supported_xcr0 before
> it's fully configured.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 2 +-
>  arch/x86/kvm/cpuid.c            | 3 +--
>  arch/x86/kvm/svm.c              | 6 ------
>  arch/x86/kvm/vmx/capabilities.h | 2 +-
>  arch/x86/kvm/vmx/vmx.c          | 3 +--
>  5 files changed, 4 insertions(+), 12 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 77d206a93658..85f0d96cfeb2 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1163,7 +1163,7 @@ struct kvm_x86_ops {
>  			       enum x86_intercept_stage stage);
>  	void (*handle_exit_irqoff)(struct kvm_vcpu *vcpu,
>  		enum exit_fastpath_completion *exit_fastpath);
> -	bool (*mpx_supported)(void);
> +
>  	bool (*xsaves_supported)(void);
>  	bool (*umip_emulated)(void);
>  	bool (*pt_supported)(void);
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index b9763eb711cb..84006cc4007c 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -47,8 +47,7 @@ static u32 xstate_required_size(u64 xstate_bv, bool compacted)
>  
>  bool kvm_mpx_supported(void)
>  {
> -	return ((host_xcr0 & (XFEATURE_MASK_BNDREGS | XFEATURE_MASK_BNDCSR))
> -		 && kvm_x86_ops->mpx_supported());
> +	return supported_xcr0 & (XFEATURE_MASK_BNDREGS | XFEATURE_MASK_BNDCSR);
>  }
>  EXPORT_SYMBOL_GPL(kvm_mpx_supported);
>  
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index af096c4f9c5f..3c7ddaff405d 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -6082,11 +6082,6 @@ static bool svm_invpcid_supported(void)
>  	return false;
>  }
>  
> -static bool svm_mpx_supported(void)
> -{
> -	return false;
> -}
> -
>  static bool svm_xsaves_supported(void)
>  {
>  	return boot_cpu_has(X86_FEATURE_XSAVES);
> @@ -7468,7 +7463,6 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
>  
>  	.rdtscp_supported = svm_rdtscp_supported,
>  	.invpcid_supported = svm_invpcid_supported,
> -	.mpx_supported = svm_mpx_supported,
>  	.xsaves_supported = svm_xsaves_supported,
>  	.umip_emulated = svm_umip_emulated,
>  	.pt_supported = svm_pt_supported,
> diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
> index 1a6a99382e94..0a0b1494a934 100644
> --- a/arch/x86/kvm/vmx/capabilities.h
> +++ b/arch/x86/kvm/vmx/capabilities.h
> @@ -100,7 +100,7 @@ static inline bool cpu_has_load_perf_global_ctrl(void)
>  	       (vmcs_config.vmexit_ctrl & VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL);
>  }
>  
> -static inline bool vmx_mpx_supported(void)
> +static inline bool cpu_has_vmx_mpx(void)
>  {
>  	return (vmcs_config.vmexit_ctrl & VM_EXIT_CLEAR_BNDCFGS) &&
>  		(vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_BNDCFGS);
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 32a84ec15064..98fd651f7f7e 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7590,7 +7590,7 @@ static __init int hardware_setup(void)
>  		WARN_ONCE(host_bndcfgs, "KVM: BNDCFGS in host will be lost");
>  	}
>  
> -	if (!kvm_mpx_supported())
> +	if (!cpu_has_vmx_mpx())
>  		supported_xcr0 &= ~(XFEATURE_MASK_BNDREGS |
>  				    XFEATURE_MASK_BNDCSR);
>  
> @@ -7857,7 +7857,6 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
>  
>  	.check_intercept = vmx_check_intercept,
>  	.handle_exit_irqoff = vmx_handle_exit_irqoff,
> -	.mpx_supported = vmx_mpx_supported,
>  	.xsaves_supported = vmx_xsaves_supported,
>  	.umip_emulated = vmx_umip_emulated,
>  	.pt_supported = vmx_pt_supported,

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

