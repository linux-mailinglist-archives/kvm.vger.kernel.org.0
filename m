Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E16F4C4DC7
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 19:34:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233226AbiBYSef (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 13:34:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231935AbiBYSee (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 13:34:34 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A2C13190B4F
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 10:34:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645814040;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MeVbMsvqeKcfRpUCeZE0zT6P3QtSSS2eFOANTWB92Lg=;
        b=bc24pSb8LIzfiDfrbImqVLPGJckxn9A+TAp5Pik+eZV6DROLB89HSn4HAqX0aXVYGgKjPy
        sg2BGIYovhm6zAb/wnnm/9kxvesa7an8UTmvhQaFixMqbNdI+Cy/7jR6Qk7QhBETnE1NnX
        b03WwxA5HImKFq95CSNatvetLODFxLg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-189-ExnxXd68PXSu9dwL9DMSig-1; Fri, 25 Feb 2022 13:33:57 -0500
X-MC-Unique: ExnxXd68PXSu9dwL9DMSig-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C5B94180FCD9;
        Fri, 25 Feb 2022 18:33:55 +0000 (UTC)
Received: from starship (unknown [10.40.195.190])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 46A7D105C883;
        Fri, 25 Feb 2022 18:33:53 +0000 (UTC)
Message-ID: <6d01c59eab7f31eef1b4249a85869600410336b7.camel@redhat.com>
Subject: Re: [PATCH 4/4] KVM: x86: hyper-v: HVCALL_SEND_IPI_EX is an XMM
 fast hypercall
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-kernel@vger.kernel.org
Date:   Fri, 25 Feb 2022 20:33:52 +0200
In-Reply-To: <20220222154642.684285-5-vkuznets@redhat.com>
References: <20220222154642.684285-1-vkuznets@redhat.com>
         <20220222154642.684285-5-vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-02-22 at 16:46 +0100, Vitaly Kuznetsov wrote:
> It has been proven on practice that at least Windows Server 2019 tries
> using HVCALL_SEND_IPI_EX in 'XMM fast' mode when it has more than 64 vCPUs
> and it needs to send an IPI to a vCPU > 63. Similarly to other XMM Fast
> hypercalls (HVCALL_FLUSH_VIRTUAL_ADDRESS_{LIST,SPACE}{,_EX}), this
> information is missing in TLFS as of 6.0b. Currently, KVM returns an error
> (HV_STATUS_INVALID_HYPERCALL_INPUT) and Windows crashes.
> 
> Note, HVCALL_SEND_IPI is a 'standard' fast hypercall (not 'XMM fast') as
> all its parameters fit into RDX:R8 and this is handled by KVM correctly.
> 
> Fixes: d8f5537a8816 ("KVM: hyper-v: Advertise support for fast XMM hypercalls")
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/kvm/hyperv.c | 52 ++++++++++++++++++++++++++++---------------
>  1 file changed, 34 insertions(+), 18 deletions(-)
> 
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index 6dda93bf98ae..3060057bdfd4 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -1890,6 +1890,7 @@ static u64 kvm_hv_send_ipi(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
>  	int sparse_banks_len;
>  	u32 vector;
>  	bool all_cpus;
> +	int i;
>  
>  	if (hc->code == HVCALL_SEND_IPI) {
>  		if (!hc->fast) {
> @@ -1910,9 +1911,15 @@ static u64 kvm_hv_send_ipi(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
>  
>  		trace_kvm_hv_send_ipi(vector, sparse_banks[0]);
>  	} else {
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
>  		trace_kvm_hv_send_ipi_ex(send_ipi_ex.vector,
>  					 send_ipi_ex.vp_set.format,
> @@ -1920,8 +1927,7 @@ static u64 kvm_hv_send_ipi(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
>  
>  		vector = send_ipi_ex.vector;
>  		valid_bank_mask = send_ipi_ex.vp_set.valid_bank_mask;
> -		sparse_banks_len = bitmap_weight(&valid_bank_mask, 64) *
> -			sizeof(sparse_banks[0]);
> +		sparse_banks_len = bitmap_weight(&valid_bank_mask, 64);
Is this change intentional? 

I haven't fully reviewed this, because kvm/queue seem to have a bit different
version of this, and I didn't fully follow on all of this.

Best regards,
	Maxim Levitsky

>  
>  		all_cpus = send_ipi_ex.vp_set.format == HV_GENERIC_SET_ALL;
>  
> @@ -1931,12 +1937,27 @@ static u64 kvm_hv_send_ipi(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
>  		if (!sparse_banks_len)
>  			goto ret_success;
>  
> -		if (kvm_read_guest(kvm,
> -				   hc->ingpa + offsetof(struct hv_send_ipi_ex,
> -							vp_set.bank_contents),
> -				   sparse_banks,
> -				   sparse_banks_len))
> -			return HV_STATUS_INVALID_HYPERCALL_INPUT;
> +		if (!hc->fast) {
> +			if (kvm_read_guest(kvm,
> +					   hc->ingpa + offsetof(struct hv_send_ipi_ex,
> +								vp_set.bank_contents),
> +					   sparse_banks,
> +					   sparse_banks_len * sizeof(sparse_banks[0])))
> +				return HV_STATUS_INVALID_HYPERCALL_INPUT;
> +		} else {
> +			/*
> +			 * The lower half of XMM0 is already consumed, each XMM holds
> +			 * two sparse banks.
> +			 */
> +			if (sparse_banks_len > (2 * HV_HYPERCALL_MAX_XMM_REGISTERS - 1))
> +				return HV_STATUS_INVALID_HYPERCALL_INPUT;
> +			for (i = 0; i < sparse_banks_len; i++) {
> +				if (i % 2)
> +					sparse_banks[i] = sse128_lo(hc->xmm[(i + 1) / 2]);
> +				else
> +					sparse_banks[i] = sse128_hi(hc->xmm[i / 2]);
> +			}
> +		}
>  	}
>  
>  check_and_send_ipi:
> @@ -2098,6 +2119,7 @@ static bool is_xmm_fast_hypercall(struct kvm_hv_hcall *hc)
>  	case HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE:
>  	case HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST_EX:
>  	case HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE_EX:
> +	case HVCALL_SEND_IPI_EX:
>  		return true;
>  	}
>  
> @@ -2265,14 +2287,8 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
>  		ret = kvm_hv_flush_tlb(vcpu, &hc);
>  		break;
>  	case HVCALL_SEND_IPI:
> -		if (unlikely(hc.rep)) {
> -			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
> -			break;
> -		}
> -		ret = kvm_hv_send_ipi(vcpu, &hc);
> -		break;
>  	case HVCALL_SEND_IPI_EX:
> -		if (unlikely(hc.fast || hc.rep)) {
> +		if (unlikely(hc.rep)) {
>  			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
>  			break;
>  		}


