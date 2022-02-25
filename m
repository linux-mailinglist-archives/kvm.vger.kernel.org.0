Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E7234C4D9F
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 19:23:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233037AbiBYSYJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 13:24:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232992AbiBYSYB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 13:24:01 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BBB0A1D305D
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 10:23:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645813398;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=S1NmdYyRDaBXoSCp03484hlz5eKqc7q4f9y/0Zo2bME=;
        b=OFTj3j+Qc4ZUrbjX2q0URrmv9A5l3JQI7OA4lJ1XrfxOtulIbXolwv4lB78FxTtbNP8HiQ
        XdRhW6+ZvP68GhI/vLe9OtZ9l6Rm6lW9J4LqeCDPaOStveTPIzbP/QNWl8PGyb3mhUy96i
        +v+MKdhEfL2m9JWh6waekCk+BMTFLWg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-515-5VQhx3J0PUGYCSKJ_C8OoQ-1; Fri, 25 Feb 2022 13:23:16 -0500
X-MC-Unique: 5VQhx3J0PUGYCSKJ_C8OoQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 39CC0FC80;
        Fri, 25 Feb 2022 18:23:15 +0000 (UTC)
Received: from starship (unknown [10.40.195.190])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4021786C33;
        Fri, 25 Feb 2022 18:22:53 +0000 (UTC)
Message-ID: <f38c3bc0fab811220621b849592ca8e1fdfc6651.camel@redhat.com>
Subject: Re: [PATCH 2/4] KVM: x86: hyper-v: Drop redundant 'ex' parameter
 from kvm_hv_flush_tlb()
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-kernel@vger.kernel.org
Date:   Fri, 25 Feb 2022 20:22:52 +0200
In-Reply-To: <20220222154642.684285-3-vkuznets@redhat.com>
References: <20220222154642.684285-1-vkuznets@redhat.com>
         <20220222154642.684285-3-vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
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
> 'struct kvm_hv_hcall' has all the required information already,
> there's no need to pass 'ex' additionally.
> 
> No functional change intended.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/kvm/hyperv.c | 23 ++++++-----------------
>  1 file changed, 6 insertions(+), 17 deletions(-)
> 
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index 15b6a7bd2346..714af3b94f31 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -1750,7 +1750,7 @@ struct kvm_hv_hcall {
>  	sse128_t xmm[HV_HYPERCALL_MAX_XMM_REGISTERS];
>  };
>  
> -static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc, bool ex)
> +static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
>  {
>  	int i;
>  	gpa_t gpa;
> @@ -1765,7 +1765,8 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc, bool
>  	int sparse_banks_len;
>  	bool all_cpus;
>  
> -	if (!ex) {
> +	if (hc->code == HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST ||
> +	    hc->code == HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE) {
>  		if (hc->fast) {
>  			flush.address_space = hc->ingpa;
>  			flush.flags = hc->outgpa;
> @@ -2247,32 +2248,20 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
>  				kvm_hv_hypercall_complete_userspace;
>  		return 0;
>  	case HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST:
> -		if (unlikely(!hc.rep_cnt || hc.rep_idx)) {
> -			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
> -			break;
> -		}
> -		ret = kvm_hv_flush_tlb(vcpu, &hc, false);
> -		break;
> -	case HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE:
> -		if (unlikely(hc.rep)) {
> -			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
> -			break;
> -		}
> -		ret = kvm_hv_flush_tlb(vcpu, &hc, false);
> -		break;
>  	case HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST_EX:
>  		if (unlikely(!hc.rep_cnt || hc.rep_idx)) {
>  			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
>  			break;
>  		}
> -		ret = kvm_hv_flush_tlb(vcpu, &hc, true);
> +		ret = kvm_hv_flush_tlb(vcpu, &hc);
>  		break;
> +	case HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE:
>  	case HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE_EX:
>  		if (unlikely(hc.rep)) {
>  			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
>  			break;
>  		}
> -		ret = kvm_hv_flush_tlb(vcpu, &hc, true);
> +		ret = kvm_hv_flush_tlb(vcpu, &hc);
>  		break;
>  	case HVCALL_SEND_IPI:
>  		if (unlikely(hc.rep)) {


Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

