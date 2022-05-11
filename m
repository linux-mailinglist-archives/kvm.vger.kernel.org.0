Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 419D8523191
	for <lists+kvm@lfdr.de>; Wed, 11 May 2022 13:28:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243114AbiEKL0o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 May 2022 07:26:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241821AbiEKL0I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 May 2022 07:26:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 78FDA2E3
        for <kvm@vger.kernel.org>; Wed, 11 May 2022 04:25:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652268338;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L7bgnpWqcdqNvHxNU2KzEbI653lACbzFb1RAD6XEVCk=;
        b=GcWf3LRBduzgoOsqY5PVwiMivTxvAb/FdQlSJOUuBryVVL0ZlYdu7jiKPamqLj7WoiAh8k
        XrAJD9bBzC31RRbope8NtVdXcc2j84u78Hzg3BNOrGmL4/6KNPFAMhsSLjdPLMVcnfDn3T
        4sMSeNaJ01LIPaovs4L/WeICocsFq+8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-648-DEKCNhICP1a9sy5jruSrWA-1; Wed, 11 May 2022 07:25:37 -0400
X-MC-Unique: DEKCNhICP1a9sy5jruSrWA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D9D4D18E6C40;
        Wed, 11 May 2022 11:25:36 +0000 (UTC)
Received: from starship (unknown [10.40.192.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 96F58438BCE;
        Wed, 11 May 2022 11:25:34 +0000 (UTC)
Message-ID: <40adabce40dcf3f965538815bfb740023be06cdb.camel@redhat.com>
Subject: Re: [PATCH v3 15/34] KVM: x86: hyper-v: Introduce
 kvm_hv_is_tlb_flush_hcall()
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Wed, 11 May 2022 14:25:33 +0300
In-Reply-To: <20220414132013.1588929-16-vkuznets@redhat.com>
References: <20220414132013.1588929-1-vkuznets@redhat.com>
         <20220414132013.1588929-16-vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-04-14 at 15:19 +0200, Vitaly Kuznetsov wrote:
> The newly introduced helper checks whether vCPU is performing a
> Hyper-V TLB flush hypercall. This is required to filter out L2 TLB
> flush hypercalls for processing.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/kvm/hyperv.h | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> diff --git a/arch/x86/kvm/hyperv.h b/arch/x86/kvm/hyperv.h
> index d59f96700104..ca67c18cef2c 100644
> --- a/arch/x86/kvm/hyperv.h
> +++ b/arch/x86/kvm/hyperv.h
> @@ -170,6 +170,24 @@ static inline void kvm_hv_vcpu_empty_flush_tlb(struct kvm_vcpu *vcpu)
>  	tlb_flush_ring = kvm_hv_get_tlb_flush_ring(vcpu);
>  	tlb_flush_ring->read_idx = tlb_flush_ring->write_idx;
>  }
> +
> +static inline bool kvm_hv_is_tlb_flush_hcall(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
> +	u16 code;
> +
> +	if (!hv_vcpu)
> +		return false;
> +
> +	code = is_64_bit_hypercall(vcpu) ? kvm_rcx_read(vcpu) :
> +		kvm_rax_read(vcpu);
> +
> +	return (code == HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE ||
> +		code == HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST ||
> +		code == HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE_EX ||
> +		code == HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST_EX);
> +}
> +
>  void kvm_hv_vcpu_flush_tlb(struct kvm_vcpu *vcpu);
>  
>  

Looks Ok, but my knowelege of HV spec is limited so I might have missed something.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

