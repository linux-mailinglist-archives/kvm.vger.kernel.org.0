Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8469031437E
	for <lists+kvm@lfdr.de>; Tue,  9 Feb 2021 00:08:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230127AbhBHXIU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Feb 2021 18:08:20 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:23628 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229684AbhBHXIR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Feb 2021 18:08:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612825610;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Tn1HyfWWr3G2js/2FnIdOhh1z1w4eH6lqFAEdutG0ts=;
        b=HbMDLRaPqLb+3wqOByPyLNEgHcEURxOzZ3H+5eigzn3w6+6Ad3/h4Hbnkyh1cAo66GA65W
        ULyDpqSN2sESKvv2w869PXXTboZ+PMtkQV+3Q96j+WD6VojvZQrS64PECSxAN5GqYmQO7r
        5c6HPGWCTs0jU2NPir/rAImPBX+mwG8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-484-HDHslAowPLmzSTWS71ttKA-1; Mon, 08 Feb 2021 18:06:49 -0500
X-MC-Unique: HDHslAowPLmzSTWS71ttKA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DB4F3801962;
        Mon,  8 Feb 2021 23:06:47 +0000 (UTC)
Received: from starship (unknown [10.35.206.191])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 318405D6A8;
        Mon,  8 Feb 2021 23:06:44 +0000 (UTC)
Message-ID: <53c5fc3d29ed35ca3252cd5f6547dcb113ab21b9.camel@redhat.com>
Subject: Re: [PATCH v2 10/15] KVM: x86: hyper-v: Always use to_hv_vcpu()
 accessor to get to 'struct kvm_vcpu_hv'
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Date:   Tue, 09 Feb 2021 01:06:44 +0200
In-Reply-To: <20210126134816.1880136-11-vkuznets@redhat.com>
References: <20210126134816.1880136-1-vkuznets@redhat.com>
         <20210126134816.1880136-11-vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2021-01-26 at 14:48 +0100, Vitaly Kuznetsov wrote:


...
> _vcpu_mask(
>  static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, u64 ingpa, u16 rep_cnt, bool ex)
>  {
>  	struct kvm *kvm = vcpu->kvm;
> -	struct kvm_vcpu_hv *hv_vcpu = &vcpu->arch.hyperv;
> +	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(current_vcpu);
You probably mean vcpu here instead of current_vcpu. Today I smoke tested the kvm/nested-svm branch,
and had this fail on me while testing windows guests.


Other than that HyperV seems to work and even survive nested migration (I had one
windows reboot but I suspect windows update did it.)
I'll leave my test overnight (now with updates disabled) to see if it is stable.

Best regards,
	Maxim Levitsky


>  	struct hv_tlb_flush_ex flush_ex;
>  	struct hv_tlb_flush flush;
>  	u64 vp_bitmap[KVM_HV_MAX_SPARSE_VCPU_SET_BITS];
> diff --git a/arch/x86/kvm/hyperv.h b/arch/x86/kvm/hyperv.h
> index fdb321ba9c3f..be1e3f5d1df6 100644
> --- a/arch/x86/kvm/hyperv.h
> +++ b/arch/x86/kvm/hyperv.h
> @@ -119,7 +119,9 @@ static inline struct kvm_vcpu *hv_stimer_to_vcpu(struct kvm_vcpu_hv_stimer *stim
>  
>  static inline bool kvm_hv_has_stimer_pending(struct kvm_vcpu *vcpu)
>  {
> -	return !bitmap_empty(vcpu->arch.hyperv.stimer_pending_bitmap,
> +	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
> +
> +	return !bitmap_empty(hv_vcpu->stimer_pending_bitmap,
>  			     HV_SYNIC_STIMER_COUNT);
>  }
>  
> diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
> index 4de7579e206c..4ad2fbbd962a 100644
> --- a/arch/x86/kvm/lapic.h
> +++ b/arch/x86/kvm/lapic.h
> @@ -6,6 +6,8 @@
>  
>  #include <linux/kvm_host.h>
>  
> +#include "hyperv.h"
> +
>  #define KVM_APIC_INIT		0
>  #define KVM_APIC_SIPI		1
>  #define KVM_APIC_LVT_NUM	6
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 9db84508aa0b..443878dd775c 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6733,12 +6733,14 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
>  	x86_spec_ctrl_restore_host(vmx->spec_ctrl, 0);
>  
>  	/* All fields are clean at this point */
> -	if (static_branch_unlikely(&enable_evmcs))
> +	if (static_branch_unlikely(&enable_evmcs)) {
> +		struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
> +
>  		current_evmcs->hv_clean_fields |=
>  			HV_VMX_ENLIGHTENED_CLEAN_FIELD_ALL;
>  
> -	if (static_branch_unlikely(&enable_evmcs))
> -		current_evmcs->hv_vp_id = vcpu->arch.hyperv.vp_index;
> +		current_evmcs->hv_vp_id = hv_vcpu->vp_index;
> +	}
>  
>  	/* MSR_IA32_DEBUGCTLMSR is zeroed on vmexit. Restore it if needed */
>  	if (vmx->host_debugctlmsr)
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 868d2bf8fb95..4c2b1f4260c6 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -8894,8 +8894,10 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  			goto out;
>  		}
>  		if (kvm_check_request(KVM_REQ_HV_EXIT, vcpu)) {
> +			struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
> +
>  			vcpu->run->exit_reason = KVM_EXIT_HYPERV;
> -			vcpu->run->hyperv = vcpu->arch.hyperv.exit;
> +			vcpu->run->hyperv = hv_vcpu->exit;
>  			r = 0;
>  			goto out;
>  		}


