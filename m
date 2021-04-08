Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD44C358186
	for <lists+kvm@lfdr.de>; Thu,  8 Apr 2021 13:18:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231194AbhDHLS6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Apr 2021 07:18:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44263 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230411AbhDHLS5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 8 Apr 2021 07:18:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617880725;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=e9GB1bc5nTqQLr5FYMM0BQdP1r5V4EAQj9pCagC3gNQ=;
        b=PgjstiXZfnBbU4HfR/jE/WE9fYCGwxh/6d7akB63rVE15gL976JACGPbl4auQR1JFRHymB
        15+SOcucafYpoJ0C2fyQ+BD/1d/4miSbQByNlSxoyBjoIPmWyG9+1HgM5+GwP3VZjjEEM3
        elbz1PWwKFa5FPMr4BrzRkR9A99rDgU=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-187-7nbaGbsCOtGl0dWBd4rR-w-1; Thu, 08 Apr 2021 07:18:44 -0400
X-MC-Unique: 7nbaGbsCOtGl0dWBd4rR-w-1
Received: by mail-ed1-f72.google.com with SMTP id o9so98518edq.16
        for <kvm@vger.kernel.org>; Thu, 08 Apr 2021 04:18:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=e9GB1bc5nTqQLr5FYMM0BQdP1r5V4EAQj9pCagC3gNQ=;
        b=hsNu7fxaPQ1+DksB4718zDh7FDPXeswMIxABUu47nUEb2uYk//Dp4eHqvQ0KMRGGjO
         nYokpRR5NUmpR108WiKVoBwxDQbDQncJhjCIChI3avkuUzECGQBt7KnA2RPBr5iA4YYL
         ur5d3yeFko2yqz747Hb2SFpXp1kLABq2HJ3VyFe8ZyrbEF5x+J1j1Qw2u4Usa/ZI06ee
         s59m5YQ4aVAg+HgqwLnBgdsggNMkyZSR0EtEL7wgP4A8WhL99RONuO4mhf1sxrkCOUVZ
         kjlx64u7cLvo6T4JbjyN1m72MV6S1VwqxMXbRAGBzbUkS6YV+vLALtHRUe2UPBsqq+ww
         oACg==
X-Gm-Message-State: AOAM532TEK7eUnSvqRN5jXaohj/PSw2uPflnX0lDadZ6MTlkqawu9eqM
        ImCwjV6iZ4RKnnggyoaeGOO7fZeQN/h3sO7g5KEWk0frw/DeX/UCMqWp2/7kdejy/sCFFdJPALe
        pbi+5zm8grk4W
X-Received: by 2002:a05:6402:150e:: with SMTP id f14mr10706631edw.63.1617880723072;
        Thu, 08 Apr 2021 04:18:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzsUUZ1nZ1Do8rFMm9JgnlTS5QEF3UTCdI4T3dCkR0kugi4Hpfj+GAHSQ4R4P4ajljpcHw15w==
X-Received: by 2002:a05:6402:150e:: with SMTP id f14mr10706621edw.63.1617880722924;
        Thu, 08 Apr 2021 04:18:42 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id x4sm16717374edd.58.2021.04.08.04.18.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Apr 2021 04:18:42 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Vineeth Pillai <viremana@linux.microsoft.com>,
        Lan Tianyu <Tianyu.Lan@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Wei Liu <wei.liu@kernel.org>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Cc:     Vineeth Pillai <viremana@linux.microsoft.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "K. Y. Srinivasan" <kys@microsoft.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org
Subject: Re: [PATCH 5/7] KVM: SVM: hyper-v: Remote TLB flush for SVM
In-Reply-To: <1c754fe1ad8ae797b4045903dab51ab45dd37755.1617804573.git.viremana@linux.microsoft.com>
References: <cover.1617804573.git.viremana@linux.microsoft.com>
 <1c754fe1ad8ae797b4045903dab51ab45dd37755.1617804573.git.viremana@linux.microsoft.com>
Date:   Thu, 08 Apr 2021 13:18:41 +0200
Message-ID: <87ft01ausu.fsf@vitty.brq.redhat.com>
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
>  arch/x86/kvm/svm/svm.c | 35 +++++++++++++++++++++++++++++++++++
>  1 file changed, 35 insertions(+)
>
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index baee91c1e936..6287cab61f15 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -36,6 +36,7 @@
>  #include <asm/spec-ctrl.h>
>  #include <asm/cpu_device_id.h>
>  #include <asm/traps.h>
> +#include <asm/mshyperv.h>
>  
>  #include <asm/virtext.h>
>  #include "trace.h"
> @@ -43,6 +44,8 @@
>  #include "svm.h"
>  #include "svm_ops.h"
>  
> +#include "hyperv.h"
> +
>  #define __ex(x) __kvm_handle_fault_on_reboot(x)
>  
>  MODULE_AUTHOR("Qumranet");
> @@ -928,6 +931,8 @@ static __init void svm_set_cpu_caps(void)
>  		kvm_cpu_cap_set(X86_FEATURE_VIRT_SSBD);
>  }
>  
> +static struct kvm_x86_ops svm_x86_ops;
> +
>  static __init int svm_hardware_setup(void)
>  {
>  	int cpu;
> @@ -997,6 +1002,16 @@ static __init int svm_hardware_setup(void)
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
> @@ -1112,6 +1127,21 @@ static void svm_check_invpcid(struct vcpu_svm *svm)
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
> @@ -1274,6 +1304,8 @@ static void init_vmcb(struct vcpu_svm *svm)
>  		}
>  	}
>  
> +	hv_init_vmcb(svm->vmcb);
> +
>  	vmcb_mark_all_dirty(svm->vmcb);
>  
>  	enable_gif(svm);
> @@ -3967,6 +3999,9 @@ static void svm_load_mmu_pgd(struct kvm_vcpu *vcpu, unsigned long root,
>  		svm->vmcb->control.nested_cr3 = cr3;
>  		vmcb_mark_dirty(svm->vmcb, VMCB_NPT);
>  
> +		if (kvm_x86_ops.tlb_remote_flush)
> +			kvm_update_arch_tdp_pointer(vcpu->kvm, vcpu, cr3);
> +

VMX has "#if IS_ENABLED(CONFIG_HYPERV)" around this, should we add it
here too?

>  		/* Loading L2's CR3 is handled by enter_svm_guest_mode.  */
>  		if (!test_bit(VCPU_EXREG_CR3, (ulong *)&vcpu->arch.regs_avail))
>  			return;

-- 
Vitaly

