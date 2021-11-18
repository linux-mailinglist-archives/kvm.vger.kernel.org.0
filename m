Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7175455FF0
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 16:52:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232742AbhKRPze (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 10:55:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58920 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232392AbhKRPza (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Nov 2021 10:55:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637250749;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RVRccCHrHSJUs8Dx0UtuzvJdQI+OvJyg4mtalesCP0s=;
        b=aHvMQrWvljnTyvVtJWKEtmQvC+tA+D9lDCnW4VzNPSY/v6hwubJvnY2wg6nAWPdsaJfYjg
        KQ3KqN/LZkaIo1fJVKtFOz7wJklNDns2vwxvW/v2r1e9oPkRvBC36gvut3/SoUQPmXsf/2
        ubvf30o0POqfCzvLUJDZ5c5ISBVrWjk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-34-dXgO5v_fMX-m-4G0OxE5oQ-1; Thu, 18 Nov 2021 10:52:24 -0500
X-MC-Unique: dXgO5v_fMX-m-4G0OxE5oQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E33A887D543;
        Thu, 18 Nov 2021 15:52:22 +0000 (UTC)
Received: from [10.39.192.245] (unknown [10.39.192.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BE4051B5B7;
        Thu, 18 Nov 2021 15:52:10 +0000 (UTC)
Message-ID: <24fa6ee7-a8d1-6737-7bb8-8412ac1f630d@redhat.com>
Date:   Thu, 18 Nov 2021 16:52:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 15/15] KVM: nVMX: Always write vmcs.GUEST_CR3 during
 nested VM-Exit
Content-Language: en-US
To:     Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Lai Jiangshan <laijs@linux.alibaba.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
References: <20211108124407.12187-1-jiangshanlai@gmail.com>
 <20211108124407.12187-16-jiangshanlai@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211108124407.12187-16-jiangshanlai@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/8/21 13:44, Lai Jiangshan wrote:
> From: Lai Jiangshan <laijs@linux.alibaba.com>
> 
> For VM-Enter, vmcs.GUEST_CR3 and vcpu->arch.cr3 are synced and it is
> better to mark VCPU_EXREG_CR3 available rather than dirty to reduce a
> redundant vmwrite(GUEST_CR3) in vmx_load_mmu_pgd().
> 
> But nested_vmx_load_cr3() is also served for VM-Exit which doesn't
> set vmcs.GUEST_CR3.
> 
> This patch moves writing to vmcs.GUEST_CR3 into nested_vmx_load_cr3()
> for both nested VM-Eneter/Exit and use kvm_register_mark_available().
> 
> This patch doesn't cause any extra writing to vmcs.GUEST_CR3 and if
> userspace is modifying CR3 with KVM_SET_SREGS later, the dirty info
> for VCPU_EXREG_CR3 would be set for next writing to vmcs.GUEST_CR3
> and no update will be lost.
> 
> Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
> ---
>   arch/x86/kvm/vmx/nested.c | 32 +++++++++++++++++++++-----------
>   1 file changed, 21 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index ee5a68c2ea3a..4ddd4b1b0503 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -1133,8 +1133,28 @@ static int nested_vmx_load_cr3(struct kvm_vcpu *vcpu, unsigned long cr3,
>   	if (!nested_ept)
>   		kvm_mmu_new_pgd(vcpu, cr3);
>   
> +	/*
> +	 * Immediately write vmcs.GUEST_CR3 when changing vcpu->arch.cr3.
> +	 *
> +	 * VCPU_EXREG_CR3 is marked available rather than dirty because
> +	 * vcpu->arch.cr3 and vmcs.GUEST_CR3 are synced when enable_ept and
> +	 * vmcs.GUEST_CR3 is irrelevant to vcpu->arch.cr3 when !enable_ept.
> +	 *
> +	 * For VM-Enter case, it will be propagated to vmcs12 on nested
> +	 * VM-Exit, which can occur without actually running L2 and thus
> +	 * without hitting vmx_load_mmu_pgd(), e.g. if L1 is entering L2 with
> +	 * vmcs12.GUEST_ACTIVITYSTATE=HLT, in which case KVM will intercept
> +	 * the transition to HLT instead of running L2.
> +	 *
> +	 * For VM-Exit case, it is likely that vmcs.GUEST_CR3 == cr3 here, but
> +	 * L1 may set HOST_CR3 to a value other than its CR3 before VM-Entry,
> +	 * so we just update it unconditionally.
> +	 */
> +	if (enable_ept)
> +		vmcs_writel(GUEST_CR3, cr3);
> +
>   	vcpu->arch.cr3 = cr3;
> -	kvm_register_mark_dirty(vcpu, VCPU_EXREG_CR3);
> +	kvm_register_mark_available(vcpu, VCPU_EXREG_CR3);
>   
>   	/* Re-initialize the MMU, e.g. to pick up CR4 MMU role changes. */
>   	kvm_init_mmu(vcpu);
> @@ -2600,16 +2620,6 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
>   				from_vmentry, entry_failure_code))
>   		return -EINVAL;
>   
> -	/*
> -	 * Immediately write vmcs02.GUEST_CR3.  It will be propagated to vmcs12
> -	 * on nested VM-Exit, which can occur without actually running L2 and
> -	 * thus without hitting vmx_load_mmu_pgd(), e.g. if L1 is entering L2 with
> -	 * vmcs12.GUEST_ACTIVITYSTATE=HLT, in which case KVM will intercept the
> -	 * transition to HLT instead of running L2.
> -	 */
> -	if (enable_ept)
> -		vmcs_writel(GUEST_CR3, vmcs12->guest_cr3);
> -
>   	/* Late preparation of GUEST_PDPTRs now that EFER and CRs are set. */
>   	if (load_guest_pdptrs_vmcs12 && nested_cpu_has_ept(vmcs12) &&
>   	    is_pae_paging(vcpu)) {
> 

I have to think more about this one and patch 17.  I queued the rest.

Paolo

