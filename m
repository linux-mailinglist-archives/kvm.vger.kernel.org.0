Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE6CB35E0FF
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 16:11:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346268AbhDMOKO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Apr 2021 10:10:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44550 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231313AbhDMOKN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 13 Apr 2021 10:10:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618322993;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=l1tsPKvk9cyMrjFqY00fCJRrMWcEEfacpS/IxrFGbrA=;
        b=LUCBDuY9clNzWIzqpQu7EtiaMSrfPz5G8wDQdwHYDxNHz87NlRyLhvjiAE3haKr0cTPEf8
        rwZ1JwvRQ6aX+9Dk6zriMwZR+G6MLP8bwVGK+TSXgACvg1uBiLeG+w/PjqUXr+VOBXsQZQ
        RHDkIcMude4IRARbef5mPBwdsCcEH+Q=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-545-PIdut2IiOKmzEgCSqL2oMA-1; Tue, 13 Apr 2021 10:09:51 -0400
X-MC-Unique: PIdut2IiOKmzEgCSqL2oMA-1
Received: by mail-ej1-f71.google.com with SMTP id gn30so5094912ejc.3
        for <kvm@vger.kernel.org>; Tue, 13 Apr 2021 07:09:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=l1tsPKvk9cyMrjFqY00fCJRrMWcEEfacpS/IxrFGbrA=;
        b=kfi9u8wqcmmhHvJ7ASJFFc1kx8n6ybrRKFhqZDCA/9erVv7YzdtLjFzThmLfmZrnDH
         0r6QqSlHJjGOehXqfg4OQAAn46/+ZoTOC02hI434slX4lXRDzelFdmSerspfuzLjgf73
         4lfFrm1ob67HbRw5wJ7bveLaxGYZekwLiqb3lFlHhfmCJkeUUkIgw5pZlwcXawWk8YLP
         HxX3UNxU8ldqs8YgevNvx5CmEdO7Lbf7q/EJYoBuui3I2USvtnxKgO7OkXAeQMxyvLba
         tiZTWZx91e3XYPBB8ohRYwFUBsBls+ssOtYZTb6Ehn+zXK0q+10GLKll/DbDbz65h3cY
         6HiQ==
X-Gm-Message-State: AOAM531c7lUxd7FNfMv4X26Ty9xjUg52StCN2URGqZwGz/qK8Vr412kd
        CJIsEPHfC8xLkjbStrQIM2kO/XkfffqQmGJMmXdQYhl+tc7jQlzrKP+IxJC0ClWGAy0etu6+DEX
        pVd/HVp6s+xx0
X-Received: by 2002:a17:906:cb88:: with SMTP id mf8mr13912512ejb.541.1618322990399;
        Tue, 13 Apr 2021 07:09:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzSShJHcNjA5YQ01sjEtgoQm5P14692y1VzemFeZnsv4VJQyxJLgRwTJFH2n7G3ihWQSQm9bw==
X-Received: by 2002:a17:906:cb88:: with SMTP id mf8mr13912466ejb.541.1618322990130;
        Tue, 13 Apr 2021 07:09:50 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id c2sm9618972edr.57.2021.04.13.07.09.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Apr 2021 07:09:49 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Siddharth Chandrasekaran <sidcha@amazon.de>
Cc:     Alexander Graf <graf@amazon.com>,
        Evgeny Iakovlev <eyakovl@amazon.de>,
        Liran Alon <liran@amazon.com>,
        Ioannis Aslanidis <iaslan@amazon.de>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH v2 3/4] KVM: x86: kvm_hv_flush_tlb use inputs from XMM
 registers
In-Reply-To: <da036c786700032b32e68ebece06fd1a6b6bf344.1618244920.git.sidcha@amazon.de>
References: <cover.1618244920.git.sidcha@amazon.de>
 <da036c786700032b32e68ebece06fd1a6b6bf344.1618244920.git.sidcha@amazon.de>
Date:   Tue, 13 Apr 2021 16:09:48 +0200
Message-ID: <87sg3u5l8z.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Siddharth Chandrasekaran <sidcha@amazon.de> writes:

> Hyper-V supports the use of XMM registers to perform fast hypercalls.
> This allows guests to take advantage of the improved performance of the
> fast hypercall interface even though a hypercall may require more than
> (the current maximum of) two input registers.
>
> The XMM fast hypercall interface uses six additional XMM registers (XMM0
> to XMM5) to allow the guest to pass an input parameter block of up to
> 112 bytes. Hyper-V can also return data back to the guest in the
> remaining XMM registers that are not used by the current hypercall.
>
> Add framework to read/write to XMM registers in kvm_hv_hypercall() and
> use the additional hypercall inputs from XMM registers in
> kvm_hv_flush_tlb() when possible.
>
> Cc: Alexander Graf <graf@amazon.com>
> Co-developed-by: Evgeny Iakovlev <eyakovl@amazon.de>
> Signed-off-by: Evgeny Iakovlev <eyakovl@amazon.de>
> Signed-off-by: Siddharth Chandrasekaran <sidcha@amazon.de>
> ---
>  arch/x86/kvm/hyperv.c | 109 ++++++++++++++++++++++++++++++++++--------
>  1 file changed, 90 insertions(+), 19 deletions(-)
>
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index 8f6babd1ea0d..1f9959aba70d 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -36,6 +36,7 @@
>  
>  #include "trace.h"
>  #include "irq.h"
> +#include "fpu.h"
>  
>  /* "Hv#1" signature */
>  #define HYPERV_CPUID_SIGNATURE_EAX 0x31237648
> @@ -1623,6 +1624,8 @@ static __always_inline unsigned long *sparse_set_to_vcpu_mask(
>  	return vcpu_bitmap;
>  }
>  
> +#define KVM_HV_HYPERCALL_MAX_XMM_REGISTERS  6

Nitpick: this is not KVM-specific so could probably go to arch/x86/include/asm/hyperv-tlfs.h

> +
>  struct kvm_hv_hcall {
>  	u64 param;
>  	u64 ingpa;
> @@ -1632,10 +1635,14 @@ struct kvm_hv_hcall {
>  	u16 rep_idx;
>  	bool fast;
>  	bool rep;
> +	sse128_t xmm[KVM_HV_HYPERCALL_MAX_XMM_REGISTERS];
> +	bool xmm_dirty;
>  };
>  
>  static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc, bool ex)
>  {
> +	int i, j;
> +	gpa_t gpa;
>  	struct kvm *kvm = vcpu->kvm;
>  	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
>  	struct hv_tlb_flush_ex flush_ex;
> @@ -1649,8 +1656,15 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc, bool
>  	bool all_cpus;
>  
>  	if (!ex) {
> -		if (unlikely(kvm_read_guest(kvm, hc->ingpa, &flush, sizeof(flush))))
> -			return HV_STATUS_INVALID_HYPERCALL_INPUT;
> +		if (hc->fast) {
> +			flush.address_space = hc->ingpa;
> +			flush.flags = hc->outgpa;
> +			flush.processor_mask = sse128_lo(hc->xmm[0]);
> +		} else {
> +			if (unlikely(kvm_read_guest(kvm, hc->ingpa,
> +						    &flush, sizeof(flush))))
> +				return HV_STATUS_INVALID_HYPERCALL_INPUT;
> +		}
>  
>  		trace_kvm_hv_flush_tlb(flush.processor_mask,
>  				       flush.address_space, flush.flags);
> @@ -1668,9 +1682,16 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc, bool
>  		all_cpus = (flush.flags & HV_FLUSH_ALL_PROCESSORS) ||
>  			flush.processor_mask == 0;
>  	} else {
> -		if (unlikely(kvm_read_guest(kvm, hc->ingpa, &flush_ex,
> -					    sizeof(flush_ex))))
> -			return HV_STATUS_INVALID_HYPERCALL_INPUT;
> +		if (hc->fast) {
> +			flush_ex.address_space = hc->ingpa;
> +			flush_ex.flags = hc->outgpa;
> +			memcpy(&flush_ex.hv_vp_set,
> +			       &hc->xmm[0], sizeof(hc->xmm[0]));
> +		} else {
> +			if (unlikely(kvm_read_guest(kvm, hc->ingpa, &flush_ex,
> +						    sizeof(flush_ex))))
> +				return HV_STATUS_INVALID_HYPERCALL_INPUT;
> +		}
>  
>  		trace_kvm_hv_flush_tlb_ex(flush_ex.hv_vp_set.valid_bank_mask,
>  					  flush_ex.hv_vp_set.format,
> @@ -1681,20 +1702,29 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc, bool
>  		all_cpus = flush_ex.hv_vp_set.format !=
>  			HV_GENERIC_SET_SPARSE_4K;
>  
> -		sparse_banks_len =
> -			bitmap_weight((unsigned long *)&valid_bank_mask, 64) *
> -			sizeof(sparse_banks[0]);
> +		sparse_banks_len = bitmap_weight((unsigned long *)&valid_bank_mask, 64);
>  
>  		if (!sparse_banks_len && !all_cpus)
>  			goto ret_success;
>  
> -		if (!all_cpus &&
> -		    kvm_read_guest(kvm,
> -				   hc->ingpa + offsetof(struct hv_tlb_flush_ex,
> -							hv_vp_set.bank_contents),
> -				   sparse_banks,
> -				   sparse_banks_len))
> -			return HV_STATUS_INVALID_HYPERCALL_INPUT;
> +		if (!all_cpus) {
> +			if (hc->fast) {
> +				if (sparse_banks_len > KVM_HV_HYPERCALL_MAX_XMM_REGISTERS - 1)
> +					return HV_STATUS_INVALID_HYPERCALL_INPUT;
> +				for (i = 0, j = 1; i < sparse_banks_len; i += 2, j++) {

Nitpick: you don't really need 'j' here as 'j == i/2 + 1', right?

> +					sparse_banks[i + 0] = sse128_lo(hc->xmm[j]);

Using ' + 0' for identation is ... unusual :-) I'm not opposed to it
here though.

> +					sparse_banks[i + 1] = sse128_hi(hc->xmm[j]);
> +				}
> +			} else {
> +				gpa = hc->ingpa;
> +				gpa += offsetof(struct hv_tlb_flush_ex,
> +						hv_vp_set.bank_contents);

Nitpick: if splitting these into two lines is only done to fit into 80
chars then I'd the requirement is no more so we can be a bit wider.

 gpa = hc->ingpa + offsetof(...) 

> +				if (unlikely(kvm_read_guest(kvm, gpa, sparse_banks,
> +							    sparse_banks_len *
> +							    sizeof(sparse_banks[0]))))
> +					return HV_STATUS_INVALID_HYPERCALL_INPUT;
> +			}
> +		}
>  	}
>  
>  	cpumask_clear(&hv_vcpu->tlb_flush);
> @@ -1890,6 +1920,41 @@ static u16 kvm_hvcall_signal_event(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *h
>  	return HV_STATUS_SUCCESS;
>  }
>  
> +static bool is_xmm_fast_hypercall(struct kvm_hv_hcall *hc)
> +{
> +	switch (hc->code) {
> +	case HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST:
> +	case HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE:
> +	case HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST_EX:
> +	case HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE_EX:
> +		return true;
> +	}
> +
> +	return false;
> +}
> +
> +static inline void kvm_hv_hypercall_read_xmm(struct kvm_hv_hcall *hc)
> +{
> +	int reg;
> +
> +	kvm_fpu_get();
> +	for (reg = 0; reg < KVM_HV_HYPERCALL_MAX_XMM_REGISTERS; reg++)
> +		_kvm_read_sse_reg(reg, &hc->xmm[reg]);
> +	kvm_fpu_put();
> +	hc->xmm_dirty = false;
> +}
> +
> +static inline void kvm_hv_hypercall_write_xmm(struct kvm_hv_hcall *hc)
> +{
> +	int reg;
> +
> +	kvm_fpu_get();
> +	for (reg = 0; reg < KVM_HV_HYPERCALL_MAX_XMM_REGISTERS; reg++)
> +		_kvm_write_sse_reg(reg, &hc->xmm[reg]);
> +	kvm_fpu_put();
> +	hc->xmm_dirty = false;
> +}
> +
>  int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_hv_hcall hc;
> @@ -1926,6 +1991,9 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
>  	hc.rep_idx = (hc.param >> HV_HYPERCALL_REP_START_OFFSET) & 0xfff;
>  	hc.rep = !!(hc.rep_cnt || hc.rep_idx);
>  
> +	if (hc.fast && is_xmm_fast_hypercall(&hc))
> +		kvm_hv_hypercall_read_xmm(&hc);
> +
>  	trace_kvm_hv_hypercall(hc.code, hc.fast, hc.rep_cnt, hc.rep_idx,
>  			       hc.ingpa, hc.outgpa);
>  
> @@ -1961,28 +2029,28 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
>  				kvm_hv_hypercall_complete_userspace;
>  		return 0;
>  	case HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST:
> -		if (unlikely(hc.fast || !hc.rep_cnt || hc.rep_idx)) {
> +		if (unlikely(!hc.rep_cnt || hc.rep_idx)) {
>  			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
>  			break;
>  		}
>  		ret = kvm_hv_flush_tlb(vcpu, &hc, false);
>  		break;
>  	case HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE:
> -		if (unlikely(hc.fast || hc.rep)) {
> +		if (unlikely(hc.rep)) {
>  			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
>  			break;
>  		}
>  		ret = kvm_hv_flush_tlb(vcpu, &hc, false);
>  		break;
>  	case HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST_EX:
> -		if (unlikely(hc.fast || !hc.rep_cnt || hc.rep_idx)) {
> +		if (unlikely(!hc.rep_cnt || hc.rep_idx)) {
>  			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
>  			break;
>  		}
>  		ret = kvm_hv_flush_tlb(vcpu, &hc, true);
>  		break;
>  	case HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE_EX:
> -		if (unlikely(hc.fast || hc.rep)) {
> +		if (unlikely(hc.rep)) {
>  			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
>  			break;
>  		}
> @@ -2035,6 +2103,9 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
>  		break;
>  	}
>  
> +	if (hc.xmm_dirty)
> +		kvm_hv_hypercall_write_xmm(&hc);
> +

Wei already mention that but as 'xmm_dirty' is not being used in this
patch I'd suggest we move it out too.

>  	return kvm_hv_hypercall_complete(vcpu, ret);
>  }

-- 
Vitaly

