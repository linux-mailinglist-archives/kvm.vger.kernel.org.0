Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADFF73A6578
	for <lists+kvm@lfdr.de>; Mon, 14 Jun 2021 13:43:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236277AbhFNLiz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Jun 2021 07:38:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30640 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236150AbhFNLgz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 14 Jun 2021 07:36:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623670493;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8q5ZmtL4FGXBJGoTjTr3bMJxCuZ/3iyvIGyzxvuV6lE=;
        b=OS726IPvoDfp3L2Fap4GUzOTbBWzwVoqrxoi9rr+5h7EhmnkVJvsfy4jZkgHWBiogKV88H
        Kk6gA+8ZEU20E3sfdamyDk4j5stt1ignzdkeLl7vFSKIjRmM6/No00Um4wfKNciPzq5jcb
        lqfZ3McLyzumrfEvISruc4FR0v0xgMo=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-503-jX1Or1hHOgK8dJY-9hierw-1; Mon, 14 Jun 2021 07:34:51 -0400
X-MC-Unique: jX1Or1hHOgK8dJY-9hierw-1
Received: by mail-ej1-f69.google.com with SMTP id e11-20020a170906080bb02903f9c27ad9f5so2928522ejd.6
        for <kvm@vger.kernel.org>; Mon, 14 Jun 2021 04:34:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=8q5ZmtL4FGXBJGoTjTr3bMJxCuZ/3iyvIGyzxvuV6lE=;
        b=L5JQvqbzTHNu+ENnZW+r004jeAvGghEaYr3Ges4jTHBTFgRwTNDLZ0L5Hf7zBlZu/G
         HDRXHhVm6WlcfOFmt+V8nUhRvZfN1JJVeRo5gY8ivxC1mRZKIcKonjoNyC72ewZLOgEz
         lgzopF+Vc4S2UwKwmpB2j2zgl/6/zdrGoyxWHatkeGi49pzEpFI371uTsRxlzUSUbJKv
         ESep6PRkXoj7L9uNuQzXEhipXYuM4R5Rd3v5evBWKeRUwIDxDmqhT2aSZBMT4KOB1eWD
         /H2joQ7SBEtfFmRDfzf/VgSWPzSYlJ3bqoi7jD9axktir7VHeg2jxzyk3kgcvUZ00I1c
         XfCg==
X-Gm-Message-State: AOAM5331bcqKkZwJxKZhQoB/fxufoXtbYfYJctIWggmjRsRXb0cT7yVs
        Vtiy/mJXmMJbPvoI/7lBNvMoRItwT8DeNOSC4aXzQgMS8SAPUFfWfABPykuSD+QSMEHCQ+w2ZwT
        tpOXi3NCYDyPJ
X-Received: by 2002:a05:6402:1801:: with SMTP id g1mr16657891edy.305.1623670490650;
        Mon, 14 Jun 2021 04:34:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyYNkeGj+gBOZePdoPz/G/vTOzt9nkC5wrc8ZbGHuUmXztT4ZFhURW4dq5irzG7sqVGHaJt7w==
X-Received: by 2002:a05:6402:1801:: with SMTP id g1mr16657859edy.305.1623670490422;
        Mon, 14 Jun 2021 04:34:50 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id y20sm3639341ejm.44.2021.06.14.04.34.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 04:34:49 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Vineeth Pillai <viremana@linux.microsoft.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "K. Y. Srinivasan" <kys@microsoft.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org,
        Lan Tianyu <Tianyu.Lan@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Sean Christopherson <seanjc@google.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Wei Liu <wei.liu@kernel.org>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: Re: [PATCH v5 7/7] KVM: SVM: hyper-v: Direct Virtual Flush support
In-Reply-To: <fc8d24d8eb7017266bb961e39a171b0caf298d7f.1622730232.git.viremana@linux.microsoft.com>
References: <cover.1622730232.git.viremana@linux.microsoft.com>
 <fc8d24d8eb7017266bb961e39a171b0caf298d7f.1622730232.git.viremana@linux.microsoft.com>
Date:   Mon, 14 Jun 2021 13:34:48 +0200
Message-ID: <878s3c65nr.fsf@vitty.brq.redhat.com>
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

This blows up in testing when no Hyper-V context was created on a vCPU,
e.g. when running KVM selftests (to_hv_vcpu(vcpu) is NULL when no
Hyper-V emulation features were requested on a vCPU but
svm_hv_update_vp_id() is called unconditionally by svm_vcpu_run()).

I'll be sending a patch to fix the immediate issue but I was wondering
why we need to call svm_hv_update_vp_id() from svm_vcpu_run() as VP
index is unlikely to change; we can probably just call it from
kvm_hv_set_msr() instead.


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

