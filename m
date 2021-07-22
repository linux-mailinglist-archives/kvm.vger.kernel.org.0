Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 565183D1F8F
	for <lists+kvm@lfdr.de>; Thu, 22 Jul 2021 10:00:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230474AbhGVHTX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jul 2021 03:19:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42918 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229642AbhGVHTX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 22 Jul 2021 03:19:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626940798;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JdODgHaInlx+kjolaGS3cnFyzZPAsV7csrqKJ2BDt4c=;
        b=EkpCstAgpm53pwwLgH4z2QryW/Pwi0sngEnsV7OmRg75E3xXe/Y7ns2Rt4ty4FnT/S2jBj
        lZ15gONqRuVEd7ZYDpPuhaCAlYPu4+oaMcBhaaYTy+KHFOfmaA8zSeNXBLL1VZQFi40KxQ
        /q0y1q9Nwo14hvsNsMCgcMSbDD53/bM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-123-8KS7vwhcODy3JKnNhuR3mQ-1; Thu, 22 Jul 2021 03:59:56 -0400
X-MC-Unique: 8KS7vwhcODy3JKnNhuR3mQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A7586CC621;
        Thu, 22 Jul 2021 07:59:54 +0000 (UTC)
Received: from starship (unknown [10.40.192.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B9D04610A8;
        Thu, 22 Jul 2021 07:59:50 +0000 (UTC)
Message-ID: <f5b512e85f2010ddf3ef621b75e3fb389e463a2c.camel@redhat.com>
Subject: Re: [PATCH] KVM: nVMX: Dynamically compute max VMCS index for vmcs12
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 22 Jul 2021 10:59:49 +0300
In-Reply-To: <20210618214658.2700765-1-seanjc@google.com>
References: <20210618214658.2700765-1-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2021-06-18 at 14:46 -0700, Sean Christopherson wrote:
> Calculate the max VMCS index for vmcs12 by walking the array to find the
> actual max index.  Hardcoding the index is prone to bitrot, and the
> calculation is only done on KVM bringup (albeit on every CPU, but there
> aren't _that_ many null entries in the array).
> 
> Fixes: 3c0f99366e34 ("KVM: nVMX: Add a TSC multiplier field in VMCS12")
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Could you give me an example on how this fails in the KVM unit tests?
I have a bug report here and it might be related so I want to save some
time triaging it.

Best regards,
	Maxim Levitsky

> ---
> 
> Note, the vmx test in kvm-unit-tests will still fail using stock QEMU,
> as QEMU also hardcodes and overwrites the MSR.  The test passes if I
> hack KVM to ignore userspace (it was easier than rebuilding QEMU).
> 
>  arch/x86/kvm/vmx/nested.c | 37 +++++++++++++++++++++++++++++++++++--
>  arch/x86/kvm/vmx/vmcs.h   |  8 ++++++++
>  arch/x86/kvm/vmx/vmcs12.h |  6 ------
>  3 files changed, 43 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index b531e08a095b..183fd9d62fc5 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -6374,6 +6374,40 @@ void nested_vmx_set_vmcs_shadowing_bitmap(void)
>  	}
>  }
>  
> +/*
> + * Indexing into the vmcs12 uses the VMCS encoding rotated left by 6.  Undo
> + * that madness to get the encoding for comparison.
> + */
> +#define VMCS12_IDX_TO_ENC(idx) ((u16)(((u16)(idx) >> 6) | ((u16)(idx) << 10)))
> +
> +static u64 nested_vmx_calc_vmcs_enum_msr(void)
> +{
> +	/*
> +	 * Note these are the so called "index" of the VMCS field encoding, not
> +	 * the index into vmcs12.
> +	 */
> +	unsigned int max_idx, idx;
> +	int i;
> +
> +	/*
> +	 * For better or worse, KVM allows VMREAD/VMWRITE to all fields in
> +	 * vmcs12, regardless of whether or not the associated feature is
> +	 * exposed to L1.  Simply find the field with the highest index.
> +	 */
> +	max_idx = 0;
> +	for (i = 0; i < nr_vmcs12_fields; i++) {
> +		/* The vmcs12 table is very, very sparsely populated. */
> +		if (!vmcs_field_to_offset_table[i])
> +			continue;
> +
> +		idx = vmcs_field_index(VMCS12_IDX_TO_ENC(i));
> +		if (idx > max_idx)
> +			max_idx = idx;
> +	}
> +
> +	return (u64)max_idx << VMCS_FIELD_INDEX_SHIFT;
> +}
> +
>  /*
>   * nested_vmx_setup_ctls_msrs() sets up variables containing the values to be
>   * returned for the various VMX controls MSRs when nested VMX is enabled.
> @@ -6619,8 +6653,7 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
>  	rdmsrl(MSR_IA32_VMX_CR0_FIXED1, msrs->cr0_fixed1);
>  	rdmsrl(MSR_IA32_VMX_CR4_FIXED1, msrs->cr4_fixed1);
>  
> -	/* highest index: VMX_PREEMPTION_TIMER_VALUE */
> -	msrs->vmcs_enum = VMCS12_MAX_FIELD_INDEX << 1;
> +	msrs->vmcs_enum = nested_vmx_calc_vmcs_enum_msr();
>  }
>  
>  void nested_vmx_hardware_unsetup(void)
> diff --git a/arch/x86/kvm/vmx/vmcs.h b/arch/x86/kvm/vmx/vmcs.h
> index 1472c6c376f7..de3b04d4b587 100644
> --- a/arch/x86/kvm/vmx/vmcs.h
> +++ b/arch/x86/kvm/vmx/vmcs.h
> @@ -164,4 +164,12 @@ static inline int vmcs_field_readonly(unsigned long field)
>  	return (((field >> 10) & 0x3) == 1);
>  }
>  
> +#define VMCS_FIELD_INDEX_SHIFT		(1)
> +#define VMCS_FIELD_INDEX_MASK		GENMASK(9, 1)
> +
> +static inline unsigned int vmcs_field_index(unsigned long field)
> +{
> +	return (field & VMCS_FIELD_INDEX_MASK) >> VMCS_FIELD_INDEX_SHIFT;
> +}
> +
>  #endif /* __KVM_X86_VMX_VMCS_H */
> diff --git a/arch/x86/kvm/vmx/vmcs12.h b/arch/x86/kvm/vmx/vmcs12.h
> index bb81a23afe89..5e0e1b39f495 100644
> --- a/arch/x86/kvm/vmx/vmcs12.h
> +++ b/arch/x86/kvm/vmx/vmcs12.h
> @@ -205,12 +205,6 @@ struct __packed vmcs12 {
>   */
>  #define VMCS12_SIZE		KVM_STATE_NESTED_VMX_VMCS_SIZE
>  
> -/*
> - * VMCS12_MAX_FIELD_INDEX is the highest index value used in any
> - * supported VMCS12 field encoding.
> - */
> -#define VMCS12_MAX_FIELD_INDEX 0x17
> -
>  /*
>   * For save/restore compatibility, the vmcs12 field offsets must not change.
>   */


