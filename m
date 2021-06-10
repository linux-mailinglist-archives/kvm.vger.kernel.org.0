Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38BC13A2A0B
	for <lists+kvm@lfdr.de>; Thu, 10 Jun 2021 13:16:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230201AbhFJLSw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Jun 2021 07:18:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44296 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230113AbhFJLSu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 10 Jun 2021 07:18:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623323814;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xoAW0/d7auIkK4TeNv1Q2PwE7EYv/zd3YhDKUjzuO2c=;
        b=ddarslissU1wpKWV0UTvNbfWLD3VuVsP4f3vr2OJVur3eyERuaSj4GcSZcI/p7PA3hSyH4
        SVSW0s75GybEMNwfbMi4zINLCrEtW0McSHjSkPnabSc3CPdI4ztbFVZb7psN9aoeO6F6W6
        QPSLpj9M5mQR47hKtqBGlvNSAvxkZfQ=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-602-jpygs7D8M9-8HJwYlbZdlA-1; Thu, 10 Jun 2021 07:16:53 -0400
X-MC-Unique: jpygs7D8M9-8HJwYlbZdlA-1
Received: by mail-wm1-f70.google.com with SMTP id f22-20020a1c6a160000b029018f49a7efb7so3730456wmc.1
        for <kvm@vger.kernel.org>; Thu, 10 Jun 2021 04:16:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=xoAW0/d7auIkK4TeNv1Q2PwE7EYv/zd3YhDKUjzuO2c=;
        b=rfSbhoMY8dJO4F8tReGQhXGpI3sAmzmZ/W2sQ2EYLtdDtP1PWvlMTp/nconqDym1xX
         wR8TJmQhYRESyP1K+J6S5yR20ajzsSoiKEp47SpaC1tN6BNti8TWIWBKTsSzY8ir7l59
         0FR36h2cy4tY/q5d7SdfggUYS3iezjr9hXBwETorqxro+SWRHCT2E7WI/FfTq59gvxc/
         04n+FPEUo4emxTel67e8E8Ve9TX/chqGtWj3waYfeUX48A3mUSzoIP8AJg5CL2zHmrlP
         z/iFNftd+E2BOwJD0C3I09CIplJK7jvClBzhmoMf3EH6/5mvR4VWoSM/nJpLEa5aOAjg
         LfDA==
X-Gm-Message-State: AOAM532z8m/S76ifiuOXT7EDDxZwGHwUcAMpvcp63fMrnxVHmpqta8Ys
        iPdjT7UjO/AcQorpjmDLchTmfEy6B9dODoPCP0NpBHMpxSmGE1eJ92FRWyvsj6wEFkdmngz6KMz
        g1xDNB/EQSoyI
X-Received: by 2002:a5d:484b:: with SMTP id n11mr4768581wrs.34.1623323811931;
        Thu, 10 Jun 2021 04:16:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJymbra5LoVMtZtVwJBHnFXCjEyslPJ1aZoOdC724TUml478yIqDMg9VCYQqCry+jKh2Ui01Qw==
X-Received: by 2002:a5d:484b:: with SMTP id n11mr4768536wrs.34.1623323811650;
        Thu, 10 Jun 2021 04:16:51 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id f14sm8108898wmq.10.2021.06.10.04.16.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 04:16:51 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Vineeth Pillai <viremana@linux.microsoft.com>
Cc:     "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "K. Y. Srinivasan" <kys@microsoft.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org,
        Lan Tianyu <Tianyu.Lan@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Wei Liu <wei.liu@kernel.org>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH v5 7/7] KVM: SVM: hyper-v: Direct Virtual Flush support
In-Reply-To: <fc8d24d8eb7017266bb961e39a171b0caf298d7f.1622730232.git.viremana@linux.microsoft.com>
References: <cover.1622730232.git.viremana@linux.microsoft.com>
 <fc8d24d8eb7017266bb961e39a171b0caf298d7f.1622730232.git.viremana@linux.microsoft.com>
Date:   Thu, 10 Jun 2021 13:16:49 +0200
Message-ID: <871r9aynoe.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Vineeth Pillai <viremana@linux.microsoft.com> writes:

> From Hyper-V TLFS:
>  "The hypervisor exposes hypercalls (HvFlushVirtualAddressSpace,
>   HvFlushVirtualAddressSpaceEx, HvFlushVirtualAddressList, and
>   HvFlushVirtualAddressListEx) that allow operating systems to more
>   efficiently manage the virtual TLB. The L1 hypervisor can choose to
>   allow its guest to use those hypercalls and delegate the responsibility
>   to handle them to the L0 hypervisor. This requires the use of a
>   partition assist page."
>
> Add the Direct Virtual Flush support for SVM.
>
> Related VMX changes:
> commit 6f6a657c9998 ("KVM/Hyper-V/VMX: Add direct tlb flush support")
>
> Signed-off-by: Vineeth Pillai <viremana@linux.microsoft.com>
> ---
>  arch/x86/kvm/Makefile           |  4 ++++
>  arch/x86/kvm/svm/svm.c          |  2 ++
>  arch/x86/kvm/svm/svm_onhyperv.c | 41 +++++++++++++++++++++++++++++++++
>  arch/x86/kvm/svm/svm_onhyperv.h | 36 +++++++++++++++++++++++++++++
>  4 files changed, 83 insertions(+)
>  create mode 100644 arch/x86/kvm/svm/svm_onhyperv.c
>
> diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
> index a06745c2fef1..83331376b779 100644
> --- a/arch/x86/kvm/Makefile
> +++ b/arch/x86/kvm/Makefile
> @@ -32,6 +32,10 @@ kvm-intel-$(CONFIG_X86_SGX_KVM)	+= vmx/sgx.o
>  
>  kvm-amd-y		+= svm/svm.o svm/vmenter.o svm/pmu.o svm/nested.o svm/avic.o svm/sev.o
>  
> +ifdef CONFIG_HYPERV
> +kvm-amd-y		+= svm/svm_onhyperv.o
> +endif
> +
>  obj-$(CONFIG_KVM)	+= kvm.o
>  obj-$(CONFIG_KVM_INTEL)	+= kvm-intel.o
>  obj-$(CONFIG_KVM_AMD)	+= kvm-amd.o
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index d2a625411059..5139cb6baadc 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3779,6 +3779,8 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
>  	}
>  	svm->vmcb->save.cr2 = vcpu->arch.cr2;
>  
> +	svm_hv_update_vp_id(svm->vmcb, vcpu);
> +
>  	/*
>  	 * Run with all-zero DR6 unless needed, so that we can get the exact cause
>  	 * of a #DB.
> diff --git a/arch/x86/kvm/svm/svm_onhyperv.c b/arch/x86/kvm/svm/svm_onhyperv.c
> new file mode 100644
> index 000000000000..3281856ebd94
> --- /dev/null
> +++ b/arch/x86/kvm/svm/svm_onhyperv.c
> @@ -0,0 +1,41 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * KVM L1 hypervisor optimizations on Hyper-V for SVM.
> + */
> +
> +#include <linux/kvm_host.h>
> +#include "kvm_cache_regs.h"
> +
> +#include <asm/mshyperv.h>
> +
> +#include "svm.h"
> +#include "svm_ops.h"
> +
> +#include "hyperv.h"
> +#include "kvm_onhyperv.h"
> +#include "svm_onhyperv.h"
> +
> +int hv_enable_direct_tlbflush(struct kvm_vcpu *vcpu)
> +{

I would've avoided re-using 'hv_enable_direct_tlbflush()' name which we
already have in vmx. In fact, in the spirit of this patch, I'd suggest
we create arch/x86/kvm/vmx/vmx_onhyperv.c and move the existing
hv_enable_direct_tlbflush() there. We can then re-name it to e.g.

vmx_enable_hv_direct_tlbflush()

so the one introduced by this patch will be

svm_enable_hv_direct_tlbflush()

> +	struct hv_enlightenments *hve;
> +	struct hv_partition_assist_pg **p_hv_pa_pg =
> +			&to_kvm_hv(vcpu->kvm)->hv_pa_pg;
> +
> +	if (!*p_hv_pa_pg)
> +		*p_hv_pa_pg = kzalloc(PAGE_SIZE, GFP_KERNEL);
> +
> +	if (!*p_hv_pa_pg)
> +		return -ENOMEM;
> +
> +	hve = (struct hv_enlightenments *)to_svm(vcpu)->vmcb->control.reserved_sw;
> +
> +	hve->partition_assist_page = __pa(*p_hv_pa_pg);
> +	hve->hv_vm_id = (unsigned long)vcpu->kvm;
> +	if (!hve->hv_enlightenments_control.nested_flush_hypercall) {
> +		hve->hv_enlightenments_control.nested_flush_hypercall = 1;
> +		vmcb_mark_dirty(to_svm(vcpu)->vmcb, VMCB_HV_NESTED_ENLIGHTENMENTS);
> +	}
> +
> +	return 0;
> +}
> +
> diff --git a/arch/x86/kvm/svm/svm_onhyperv.h b/arch/x86/kvm/svm/svm_onhyperv.h
> index 0f262460b2e6..7487052fcef8 100644
> --- a/arch/x86/kvm/svm/svm_onhyperv.h
> +++ b/arch/x86/kvm/svm/svm_onhyperv.h
> @@ -36,6 +36,8 @@ struct hv_enlightenments {
>   */
>  #define VMCB_HV_NESTED_ENLIGHTENMENTS VMCB_SW
>  
> +int hv_enable_direct_tlbflush(struct kvm_vcpu *vcpu);
> +
>  static inline void svm_hv_init_vmcb(struct vmcb *vmcb)
>  {
>  	struct hv_enlightenments *hve =
> @@ -55,6 +57,23 @@ static inline void svm_hv_hardware_setup(void)
>  		svm_x86_ops.tlb_remote_flush_with_range =
>  				hv_remote_flush_tlb_with_range;
>  	}
> +
> +	if (ms_hyperv.nested_features & HV_X64_NESTED_DIRECT_FLUSH) {
> +		int cpu;
> +
> +		pr_info("kvm: Hyper-V Direct TLB Flush enabled\n");
> +		for_each_online_cpu(cpu) {
> +			struct hv_vp_assist_page *vp_ap =
> +				hv_get_vp_assist_page(cpu);
> +
> +			if (!vp_ap)
> +				continue;
> +
> +			vp_ap->nested_control.features.directhypercall = 1;
> +		}
> +		svm_x86_ops.enable_direct_tlbflush =
> +				hv_enable_direct_tlbflush;
> +	}
>  }
>  
>  static inline void svm_hv_vmcb_dirty_nested_enlightenments(
> @@ -74,6 +93,18 @@ static inline void svm_hv_vmcb_dirty_nested_enlightenments(
>  	    hve->hv_enlightenments_control.msr_bitmap)
>  		vmcb_mark_dirty(vmcb, VMCB_HV_NESTED_ENLIGHTENMENTS);
>  }
> +
> +static inline void svm_hv_update_vp_id(struct vmcb *vmcb,
> +		struct kvm_vcpu *vcpu)
> +{
> +	struct hv_enlightenments *hve =
> +		(struct hv_enlightenments *)vmcb->control.reserved_sw;
> +
> +	if (hve->hv_vp_id != to_hv_vcpu(vcpu)->vp_index) {
> +		hve->hv_vp_id = to_hv_vcpu(vcpu)->vp_index;
> +		vmcb_mark_dirty(vmcb, VMCB_HV_NESTED_ENLIGHTENMENTS);
> +	}
> +}
>  #else
>  
>  static inline void svm_hv_init_vmcb(struct vmcb *vmcb)
> @@ -88,6 +119,11 @@ static inline void svm_hv_vmcb_dirty_nested_enlightenments(
>  		struct kvm_vcpu *vcpu)
>  {
>  }
> +
> +static inline void svm_hv_update_vp_id(struct vmcb *vmcb,
> +		struct kvm_vcpu *vcpu)
> +{
> +}
>  #endif /* CONFIG_HYPERV */
>  
>  #endif /* __ARCH_X86_KVM_SVM_ONHYPERV_H__ */

-- 
Vitaly

