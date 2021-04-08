Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F84235829D
	for <lists+kvm@lfdr.de>; Thu,  8 Apr 2021 14:01:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231342AbhDHMBb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Apr 2021 08:01:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26662 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230434AbhDHMB2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 8 Apr 2021 08:01:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617883277;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vNug/8lWcscFDRAAJ94dUdldY7ZTZuugHf7cy9Hmh9U=;
        b=H/qFze13tfRK6BS22oD1bHTNZa2Zu8d42LsEu9uQQOZZcLWQrKAzWgr53TbMDFA9GodEL6
        0WQpdVVv05jZUhSFg43xOicAMYGwOc8lmtrqI2duy2UKVdkRTHgb4Glx0JHwyMmj7JcXAo
        1dsFpiGL4mG7UHbSLliShqEEF6CD3Lw=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-466-KY6mfh5_MriMJkoyXzQEqQ-1; Thu, 08 Apr 2021 08:01:14 -0400
X-MC-Unique: KY6mfh5_MriMJkoyXzQEqQ-1
Received: by mail-ed1-f69.google.com with SMTP id w16so900342edc.22
        for <kvm@vger.kernel.org>; Thu, 08 Apr 2021 05:01:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=vNug/8lWcscFDRAAJ94dUdldY7ZTZuugHf7cy9Hmh9U=;
        b=DRNqdeGt3YsLmMLH1pgLveTTV22erajnBr94jq5+xm7q4nEssgFQgnn5lWCxZPL5bt
         zpr+svTnTg8iYq9mYGc23164roJpEJtjTX5TXiFm3nRRKO+eGkJGhHzSmwup+WC5ptBN
         VnF9XG2iecdSQ6qdoQuhm6HSDMV8Lh/Tb7C64s/z7l2LLzyiNC3Mn53wLN0VQXSanN+g
         J/VcqlZ7r3p3PLBVIHQT2WlttptNQgHYx98rkeUfBcUd9gXwAYhCcgW7YOOYYZsgbXEv
         mpG0NNRy6/0qf8cdiogo46UleVh/gNqCmaydzAZh+DS/I+1Q9BqQh/3raarqAUh+KdPY
         /jaQ==
X-Gm-Message-State: AOAM531yDz2pO0MZFHblQZdtXIPst+kYDP0Bkcxv3UYux8tjHudcIGsE
        iRXVF71tMftzgVrgDc13i3wrwN7bkpgL3NuQlqIkS6Ls/yWy01538kNmpOmRspglbdu9bIe9/XQ
        CJkaG6iX2wKZ8
X-Received: by 2002:a17:906:4801:: with SMTP id w1mr9843109ejq.475.1617883273717;
        Thu, 08 Apr 2021 05:01:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxWBV0cx0oQORGYlfHwfHdhgtZ4L23OeOn1kqkC0HGevjPr3VLXckKBOFbYZnZi7smfIP9c/Q==
X-Received: by 2002:a17:906:4801:: with SMTP id w1mr9843088ejq.475.1617883273512;
        Thu, 08 Apr 2021 05:01:13 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id t12sm8963436ejb.76.2021.04.08.05.01.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Apr 2021 05:01:12 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Siddharth Chandrasekaran <sidcha@amazon.de>
Cc:     Alexander Graf <graf@amazon.com>,
        Evgeny Iakovlev <eyakovl@amazon.de>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 3/4] KVM: x86: kvm_hv_flush_tlb use inputs from XMM
 registers
In-Reply-To: <20210407211954.32755-4-sidcha@amazon.de>
References: <20210407211954.32755-1-sidcha@amazon.de>
 <20210407211954.32755-4-sidcha@amazon.de>
Date:   Thu, 08 Apr 2021 14:01:11 +0200
Message-ID: <87eefl7zp4.fsf@vitty.brq.redhat.com>
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
> index 8f6babd1ea0d..bf2f86f263f1 100644
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
> +					sparse_banks[i + 0] = sse128_lo(hc->xmm[j]);
> +					sparse_banks[i + 1] = sse128_hi(hc->xmm[j]);
> +				}
> +			} else {
> +				gpa = hc->ingpa;
> +				gpa += offsetof(struct hv_tlb_flush_ex,
> +						hv_vp_set.bank_contents);
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
> +	if (is_xmm_fast_hypercall(&hc))
> +		kvm_hv_hypercall_read_xmm(&hc);

is_xmm_fast_hypercall() check should probably be complemented with " &&
hc.fast" as there's no point in reading this regs when the hypercall is
not 'fast'.

Also, we can probably defer kvm_hv_hypercall_read_xmm() until we know
how many regs we actually need to not read them all (we will always
need xmm[0] I guess so we can as well read it here).

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
>  	return kvm_hv_hypercall_complete(vcpu, ret);
>  }

-- 
Vitaly

