Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E29FA4C45A4
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 14:14:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230167AbiBYNOl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 08:14:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbiBYNOh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 08:14:37 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 627821F9809
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 05:14:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645794842;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vhdaWsgc8pUfwK/nTPSWJVbbpkwucFw4giQzlRhkFMo=;
        b=PXM9FWFL29QIgdODaV950tqeQfS9VJa45PNIdZ/I4zMJpA3THwqGkfzoLk6gccKrOPKluc
        9NOOwZd4OEfLhvigIbgDX59UQ+onoIAhfuuZZD+lnjjjqOiOllBds7CNvHjJvOHdbutnb+
        PoLb3bUwn0sUv3ZQMfFG3auGnrsPogk=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-335-9HAAokSENy-gHdzAtEkxEw-1; Fri, 25 Feb 2022 08:14:01 -0500
X-MC-Unique: 9HAAokSENy-gHdzAtEkxEw-1
Received: by mail-wr1-f72.google.com with SMTP id y8-20020adfc7c8000000b001e755c08b91so879398wrg.15
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 05:14:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=vhdaWsgc8pUfwK/nTPSWJVbbpkwucFw4giQzlRhkFMo=;
        b=AzOP0Nv4GEQ0PmJl+nCaeh67M6qZhsalO64O814A9DUnOPBWJw5ePL0Xa9Y2Vr5ykv
         SuFguS2vdpu4M+2eBo0aJMB5x2SYQqx1DL6HW/hEk4W6GoT45GEgAtxH6+4OLrWB6+qE
         I7oAgczlYkHX+ZYVywThMWpekUXtqmUhuSpxicA0jNguNlTipbTgAhcJBfn7nHYK4cCw
         a8F2aIj2dan6JKbgETNbZa473IGA4FvVli7W9TzIspiN54YykYS/hep6EIQazs/y92Vc
         CrUCwLPXhRj/+87BhFnUGvfJa8nUjceEIr04T7AaeSmeP0QDD7JM7D2ZeSMZTs5gU4Z9
         W67w==
X-Gm-Message-State: AOAM533Tl+BAPOTTeuGolL+vA/aORktvx838+ty49DGMPqktd+0S2Y8y
        AHO1NQUbt521F3L80KsD0TvjqtOdwTB3nmsZ8oO9Ns7mPZ1LlYYKx4iy+6bY5/c+oQHnAr9AC3F
        +ZRx2Lkb+lotA
X-Received: by 2002:a5d:52c8:0:b0:1ed:e591:be70 with SMTP id r8-20020a5d52c8000000b001ede591be70mr5861907wrv.436.1645794839902;
        Fri, 25 Feb 2022 05:13:59 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyD84loAXJxH22Clm2Yzp/r6WGj0EKjWQlqM3zf3yfaq29n1Q4opKpjCnUwONdMWNH5Ve4tOQ==
X-Received: by 2002:a5d:52c8:0:b0:1ed:e591:be70 with SMTP id r8-20020a5d52c8000000b001ede591be70mr5861892wrv.436.1645794839589;
        Fri, 25 Feb 2022 05:13:59 -0800 (PST)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id k4-20020adfe8c4000000b001e68c92af35sm2295773wrn.30.2022.02.25.05.13.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Feb 2022 05:13:59 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] KVM: x86: hyper-v: XMM fast hypercalls fixes
In-Reply-To: <b466b80c-21d1-f298-b4cd-a4b58988f767@redhat.com>
References: <20220222154642.684285-1-vkuznets@redhat.com>
 <b466b80c-21d1-f298-b4cd-a4b58988f767@redhat.com>
Date:   Fri, 25 Feb 2022 14:13:58 +0100
Message-ID: <871qzrdr6x.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> On 2/22/22 16:46, Vitaly Kuznetsov wrote:
>> While working on some Hyper-V TLB flush improvements and Direct TLB flush
>> feature for Hyper-V on KVM I experienced Windows Server 2019 crashes on
>> boot when XMM fast hypercall input feature is advertised. Turns out,
>> HVCALL_SEND_IPI_EX is also an XMM fast hypercall and returning an error
>> kills the guest. This is fixed in PATCH4. PATCH3 fixes erroneous capping
>> of sparse CPU banks for XMM fast TLB flush hypercalls. The problem should
>> be reproducible with >360 vCPUs.
>> 
>> Vitaly Kuznetsov (4):
>>    KVM: x86: hyper-v: Drop redundant 'ex' parameter from
>>      kvm_hv_send_ipi()
>>    KVM: x86: hyper-v: Drop redundant 'ex' parameter from
>>      kvm_hv_flush_tlb()
>>    KVM: x86: hyper-v: Fix the maximum number of sparse banks for XMM fast
>>      TLB flush hypercalls
>>    KVM: x86: hyper-v: HVCALL_SEND_IPI_EX is an XMM fast hypercall
>> 
>>   arch/x86/kvm/hyperv.c | 84 +++++++++++++++++++++++--------------------
>>   1 file changed, 45 insertions(+), 39 deletions(-)
>> 
>
> Merging this in 5.18 is a bit messy.  Please check that the below
> patch against kvm/next makes sense:

Something is wrong with the diff as it doesn't apply :-(

>
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index 653e08c993c4..98fb998c31ce 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -1770,9 +1770,11 @@ struct kvm_hv_hcall {
>   };
>   
>   static u64 kvm_get_sparse_vp_set(struct kvm *kvm, struct kvm_hv_hcall *hc,
> +				 int consumed_xmm_halves,
>   				 u64 *sparse_banks, gpa_t offset)
>   {
>   	u16 var_cnt;
> +	int i;
>   
>   	if (hc->var_cnt > 64)
>   		return -EINVAL;
> @@ -1780,13 +1782,29 @@ static u64 kvm_get_sparse_vp_set(struct kvm *kvm, struct kvm_hv_hcall *hc,
>   	/* Ignore banks that cannot possibly contain a legal VP index. */
>   	var_cnt = min_t(u16, hc->var_cnt, KVM_HV_MAX_SPARSE_VCPU_SET_BITS);
>   
> +	if (hc->fast) {
> +		/*
> +		 * Each XMM holds two sparse banks, but do not count halves that
> +		 * have already been consumed for hypercall parameters.
> +		 */
> +		if (hc->var_cnt > 2 * HV_HYPERCALL_MAX_XMM_REGISTERS - consumed_xmm_halves)
> +			return HV_STATUS_INVALID_HYPERCALL_INPUT;
> +		for (i = 0; i < var_cnt; i++) {
> +			int j = i + consumed_xmm_halves;
> +			if (j % 2)
> +				sparse_banks[i] = sse128_lo(hc->xmm[j / 2]);
> +			else
> +				sparse_banks[i] = sse128_hi(hc->xmm[j / 2]);

Let's say we have 1 half of XMM0 consumed. Now:

 i = 0;
 j = 1;
 if (1) 
     sparse_banks[0] = sse128_lo(hc->xmm[0]); 

 This doesn't look right as we need to get the upper half of XMM0.

 I guess it should be reversed, 

     if (j % 2)
         sparse_banks[i] = sse128_hi(hc->xmm[j / 2]);
     else
         sparse_banks[i] = sse128_lo(hc->xmm[j / 2]);

> +		}
> +		return 0;
> +	}
> +
>   	return kvm_read_guest(kvm, hc->ingpa + offset, sparse_banks,
>   			      var_cnt * sizeof(*sparse_banks));
>   }
>   
> -static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc, bool ex)
> +static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
>   {
> -	int i;
>   	struct kvm *kvm = vcpu->kvm;
>   	struct hv_tlb_flush_ex flush_ex;
>   	struct hv_tlb_flush flush;
> @@ -1803,7 +1821,8 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc, bool
>   	 */
>   	BUILD_BUG_ON(KVM_HV_MAX_SPARSE_VCPU_SET_BITS > 64);
>   
> -	if (!ex) {
> +	if (hc->code == HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST ||
> +	    hc->code == HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE) {

In case you're trying to come up with a smaller patch for 5.18, we can
certainly drop these 'ex'/'non-ex' changes as these are merely
cosmetic.

>   		if (hc->fast) {
>   			flush.address_space = hc->ingpa;
>   			flush.flags = hc->outgpa;
> @@ -1859,17 +1878,7 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc, bool
>   		if (!hc->var_cnt)
>   			goto ret_success;
>   
> -		if (hc->fast) {
> -			if (hc->var_cnt > HV_HYPERCALL_MAX_XMM_REGISTERS - 1)
> -				return HV_STATUS_INVALID_HYPERCALL_INPUT;
> -			for (i = 0; i < hc->var_cnt; i += 2) {
> -				sparse_banks[i] = sse128_lo(hc->xmm[i / 2 + 1]);
> -				sparse_banks[i + 1] = sse128_hi(hc->xmm[i / 2 + 1]);
> -			}
> -			goto do_flush;
> -		}
> -
> -		if (kvm_get_sparse_vp_set(kvm, hc, sparse_banks,
> +		if (kvm_get_sparse_vp_set(kvm, hc, 2, sparse_banks,
>   					  offsetof(struct hv_tlb_flush_ex,
>   						   hv_vp_set.bank_contents)))

I like your idea to put 'consumed_xmm_halves' into
kvm_get_sparse_vp_set() as kvm_hv_flush_tlb is getting too big.

>   			return HV_STATUS_INVALID_HYPERCALL_INPUT;
> @@ -1913,7 +1922,7 @@ static void kvm_send_ipi_to_many(struct kvm *kvm, u32 vector,
>   	}
>   }
>   
> -static u64 kvm_hv_send_ipi(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc, bool ex)
> +static u64 kvm_hv_send_ipi(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
>   {
>   	struct kvm *kvm = vcpu->kvm;
>   	struct hv_send_ipi_ex send_ipi_ex;
> @@ -1924,7 +1933,7 @@ static u64 kvm_hv_send_ipi(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc, bool
>   	u32 vector;
>   	bool all_cpus;
>   
> -	if (!ex) {
> +	if (hc->code == HVCALL_SEND_IPI) {
>   		if (!hc->fast) {
>   			if (unlikely(kvm_read_guest(kvm, hc->ingpa, &send_ipi,
>   						    sizeof(send_ipi))))
> @@ -1943,9 +1952,15 @@ static u64 kvm_hv_send_ipi(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc, bool
>   
>   		trace_kvm_hv_send_ipi(vector, sparse_banks[0]);
>   	} else {
> -		if (unlikely(kvm_read_guest(kvm, hc->ingpa, &send_ipi_ex,
> -					    sizeof(send_ipi_ex))))
> -			return HV_STATUS_INVALID_HYPERCALL_INPUT;
> +		if (!hc->fast) {
> +			if (unlikely(kvm_read_guest(kvm, hc->ingpa, &send_ipi_ex,
> +						    sizeof(send_ipi_ex))))
> +				return HV_STATUS_INVALID_HYPERCALL_INPUT;
> +		} else {
> +			send_ipi_ex.vector = (u32)hc->ingpa;
> +			send_ipi_ex.vp_set.format = hc->outgpa;
> +			send_ipi_ex.vp_set.valid_bank_mask = sse128_lo(hc->xmm[0]);
> +		}
>   
>   		trace_kvm_hv_send_ipi_ex(send_ipi_ex.vector,
>   					 send_ipi_ex.vp_set.format,
> @@ -1964,7 +1979,7 @@ static u64 kvm_hv_send_ipi(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc, bool
>   		if (!hc->var_cnt)
>   			goto ret_success;
>   
> -		if (kvm_get_sparse_vp_set(kvm, hc, sparse_banks,
> +		if (kvm_get_sparse_vp_set(kvm, hc, 1, sparse_banks,
>   					  offsetof(struct hv_send_ipi_ex,
>   						   vp_set.bank_contents)))
>   			return HV_STATUS_INVALID_HYPERCALL_INPUT;
> @@ -2126,6 +2141,7 @@ static bool is_xmm_fast_hypercall(struct kvm_hv_hcall *hc)
>   	case HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE:
>   	case HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST_EX:
>   	case HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE_EX:
> +	case HVCALL_SEND_IPI_EX:
>   		return true;
>   	}
>   
> @@ -2283,46 +2299,43 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
>   				kvm_hv_hypercall_complete_userspace;
>   		return 0;
>   	case HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST:
> -		if (unlikely(!hc.rep_cnt || hc.rep_idx || hc.var_cnt)) {
> +		if (unlikely(hc.var_cnt)) {
>   			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
>   			break;
>   		}
> -		ret = kvm_hv_flush_tlb(vcpu, &hc, false);
> -		break;
> -	case HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE:
> -		if (unlikely(hc.rep || hc.var_cnt)) {
> -			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
> -			break;
> -		}
> -		ret = kvm_hv_flush_tlb(vcpu, &hc, false);
> -		break;
> +		fallthrough;
>   	case HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST_EX:
>   		if (unlikely(!hc.rep_cnt || hc.rep_idx)) {
>   			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
>   			break;
>   		}
> -		ret = kvm_hv_flush_tlb(vcpu, &hc, true);
> +		ret = kvm_hv_flush_tlb(vcpu, &hc);
>   		break;
> +	case HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE:
> +		if (unlikely(hc.var_cnt)) {
> +			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
> +			break;
> +		}
> +		fallthrough;
>   	case HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE_EX:
>   		if (unlikely(hc.rep)) {
>   			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
>   			break;
>   		}
> -		ret = kvm_hv_flush_tlb(vcpu, &hc, true);
> +		ret = kvm_hv_flush_tlb(vcpu, &hc);
>   		break;
>   	case HVCALL_SEND_IPI:
> -		if (unlikely(hc.rep || hc.var_cnt)) {
> +		if (unlikely(hc.var_cnt)) {
>   			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
>   			break;
>   		}
> -		ret = kvm_hv_send_ipi(vcpu, &hc, false);
> -		break;
> +		fallthrough;
>   	case HVCALL_SEND_IPI_EX:
> -		if (unlikely(hc.fast || hc.rep)) {
> +		if (unlikely(hc.rep)) {
>   			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
>   			break;
>   		}
> -		ret = kvm_hv_send_ipi(vcpu, &hc, true);
> +		ret = kvm_hv_send_ipi(vcpu, &hc);
>   		break;
>   	case HVCALL_POST_DEBUG_DATA:
>   	case HVCALL_RETRIEVE_DEBUG_DATA:

I've smoke tested this (with the change I've mentioned above) and WS2019
booted with 65 vCPUs. This is a good sign)

>
>
> The resulting merge commit is already in kvm/queue shortly (which should
> become the next kvm/next as soon as tests complete).
>

I see, please swap sse128_lo()/sse128_hi() there too :-)

-- 
Vitaly

