Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD9F4361CEE
	for <lists+kvm@lfdr.de>; Fri, 16 Apr 2021 12:08:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241259AbhDPJFc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Apr 2021 05:05:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40806 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241176AbhDPJF0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 16 Apr 2021 05:05:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618563901;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CXZtb/9V50pvn916phJza4VdieTQX2m9DR3I2BJV+/M=;
        b=LmMmYvjERPCmU4YBoKiP59A0ay9LSyrpsWBL6fjH3SZI0TcDVIAnWb0IRAoEtn6h3KSKWF
        1rO2sddxva5tN6+sLQFJY+h/PbNyerE1G/6Fyei58VXoUeeBfWN0rrAsWDtaz1FRwAID5J
        FRtF//nmjzo6ENGRrP/+ZkyFcb4XSXU=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-486-FHRtLSQmNVaWh7HxBH_zhg-1; Fri, 16 Apr 2021 05:04:59 -0400
X-MC-Unique: FHRtLSQmNVaWh7HxBH_zhg-1
Received: by mail-ed1-f71.google.com with SMTP id v5-20020a0564023485b029037ff13253bcso6633646edc.3
        for <kvm@vger.kernel.org>; Fri, 16 Apr 2021 02:04:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=CXZtb/9V50pvn916phJza4VdieTQX2m9DR3I2BJV+/M=;
        b=E7ygFEnkpeNi2vXGiZ0/h+cdr58sb1e3HcGNOONQJarWgVoBDDWac9rkc+P/PTncQP
         uRkkGbbZkQN7iZRTMFZ47WMaTOQikIR2CBKxzEFbO1fTZNKHZpJyHivoby/mY8CsnBHt
         CMUpLBSfRYEFyT+M1vSnUfqBzeoi9mR6kGIO683foA3i8UVp+GhmJT6ecEHvzIvqJidF
         4o6A7utMApnabXjbRZ7elCQKpmYzoBvJqrbt3qkJkx/HVh5AjdGvV/lirsesOyNirtyX
         z4GikkaHuYgMhrNdtGsJxroQoRAuPdmCFhrdbc+o+Cd8V4rDkrJsSqsqJqSFiOr0irrU
         /8Jg==
X-Gm-Message-State: AOAM531UCskpbivRvP/5jhlnjawfBFLsqUowcA6eWioekEK2u2wN8SZZ
        nofjKyqOGa3Run2gs1wNz3ovFAu2nD47j603zQddrhZBCxiAW1ZBCxUlQYYjoNpefQxT0+TesLU
        CL57ayOxyZFHf
X-Received: by 2002:a50:ee17:: with SMTP id g23mr8859599eds.45.1618563898513;
        Fri, 16 Apr 2021 02:04:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxRNTz62KVaajOAGLyQ67JSzj1vlwK/bkfGBPG4DOXdQmzYcTrZ+IL+vqblDlxIPHl/JcgdpA==
X-Received: by 2002:a50:ee17:: with SMTP id g23mr8859574eds.45.1618563898386;
        Fri, 16 Apr 2021 02:04:58 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id bu8sm644309edb.77.2021.04.16.02.04.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Apr 2021 02:04:57 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Vineeth Pillai <viremana@linux.microsoft.com>
Cc:     Vineeth Pillai <viremana@linux.microsoft.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "K. Y. Srinivasan" <kys@microsoft.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org,
        Lan Tianyu <Tianyu.Lan@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Wei Liu <wei.liu@kernel.org>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH v2 5/7] KVM: SVM: hyper-v: Remote TLB flush for SVM
In-Reply-To: <959f6cc899a17c709a2f5a71f6b2dc8c072ae600.1618492553.git.viremana@linux.microsoft.com>
References: <cover.1618492553.git.viremana@linux.microsoft.com>
 <959f6cc899a17c709a2f5a71f6b2dc8c072ae600.1618492553.git.viremana@linux.microsoft.com>
Date:   Fri, 16 Apr 2021 11:04:56 +0200
Message-ID: <87sg3q7g7b.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Vineeth Pillai <viremana@linux.microsoft.com> writes:

> Enable remote TLB flush for SVM.
>
> Signed-off-by: Vineeth Pillai <viremana@linux.microsoft.com>
> ---
>  arch/x86/kvm/svm/svm.c | 37 +++++++++++++++++++++++++++++++++++++
>  1 file changed, 37 insertions(+)
>
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 2ad1f55c88d0..de141d5ae5fb 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -37,6 +37,7 @@
>  #include <asm/spec-ctrl.h>
>  #include <asm/cpu_device_id.h>
>  #include <asm/traps.h>
> +#include <asm/mshyperv.h>
>  
>  #include <asm/virtext.h>
>  #include "trace.h"
> @@ -44,6 +45,8 @@
>  #include "svm.h"
>  #include "svm_ops.h"
>  
> +#include "hyperv.h"
> +
>  #define __ex(x) __kvm_handle_fault_on_reboot(x)
>  
>  MODULE_AUTHOR("Qumranet");
> @@ -931,6 +934,8 @@ static __init void svm_set_cpu_caps(void)
>  		kvm_cpu_cap_set(X86_FEATURE_VIRT_SSBD);
>  }
>  
> +static struct kvm_x86_ops svm_x86_ops;
> +
>  static __init int svm_hardware_setup(void)
>  {
>  	int cpu;
> @@ -1000,6 +1005,16 @@ static __init int svm_hardware_setup(void)
>  	kvm_configure_mmu(npt_enabled, get_max_npt_level(), PG_LEVEL_1G);
>  	pr_info("kvm: Nested Paging %sabled\n", npt_enabled ? "en" : "dis");
>  
> +#if IS_ENABLED(CONFIG_HYPERV)
> +	if (ms_hyperv.nested_features & HV_X64_NESTED_ENLIGHTENED_TLB
> +	    && npt_enabled) {
> +		pr_info("kvm: Hyper-V enlightened NPT TLB flush enabled\n");
> +		svm_x86_ops.tlb_remote_flush = kvm_hv_remote_flush_tlb;
> +		svm_x86_ops.tlb_remote_flush_with_range =
> +				kvm_hv_remote_flush_tlb_with_range;
> +	}
> +#endif
> +
>  	if (nrips) {
>  		if (!boot_cpu_has(X86_FEATURE_NRIPS))
>  			nrips = false;
> @@ -1120,6 +1135,21 @@ static void svm_check_invpcid(struct vcpu_svm *svm)
>  	}
>  }
>  
> +#if IS_ENABLED(CONFIG_HYPERV)
> +static void hv_init_vmcb(struct vmcb *vmcb)
> +{
> +	struct hv_enlightenments *hve = &vmcb->hv_enlightenments;
> +
> +	if (npt_enabled &&
> +	    ms_hyperv.nested_features & HV_X64_NESTED_ENLIGHTENED_TLB)

Nitpick: we can probably have a 'static inline' for 

 "npt_enabled && ms_hyperv.nested_features & HV_X64_NESTED_ENLIGHTENED_TLB"

e.g. 'hv_svm_enlightened_tlbflush()'

> +		hve->hv_enlightenments_control.enlightened_npt_tlb = 1;
> +}
> +#else
> +static inline void hv_init_vmcb(struct vmcb *vmcb)
> +{
> +}
> +#endif
> +
>  static void init_vmcb(struct vcpu_svm *svm)
>  {
>  	struct vmcb_control_area *control = &svm->vmcb->control;
> @@ -1282,6 +1312,8 @@ static void init_vmcb(struct vcpu_svm *svm)
>  		}
>  	}
>  
> +	hv_init_vmcb(svm->vmcb);
> +
>  	vmcb_mark_all_dirty(svm->vmcb);
>  
>  	enable_gif(svm);
> @@ -3975,6 +4007,11 @@ static void svm_load_mmu_pgd(struct kvm_vcpu *vcpu, unsigned long root,
>  		svm->vmcb->control.nested_cr3 = cr3;
>  		vmcb_mark_dirty(svm->vmcb, VMCB_NPT);
>  
> +#if IS_ENABLED(CONFIG_HYPERV)
> +		if (kvm_x86_ops.tlb_remote_flush)
> +			kvm_update_arch_tdp_pointer(vcpu->kvm, vcpu, cr3);
> +#endif
> +
>  		/* Loading L2's CR3 is handled by enter_svm_guest_mode.  */
>  		if (!test_bit(VCPU_EXREG_CR3, (ulong *)&vcpu->arch.regs_avail))
>  			return;

-- 
Vitaly

