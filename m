Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 717EA523150
	for <lists+kvm@lfdr.de>; Wed, 11 May 2022 13:18:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229869AbiEKLSk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 May 2022 07:18:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbiEKLSi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 May 2022 07:18:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A795F6CAAB
        for <kvm@vger.kernel.org>; Wed, 11 May 2022 04:18:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652267916;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5SpU8h+anLAEDK5AFg9jxxiakjWHWP4XsmDh4/r5tkU=;
        b=GteR/kGNaxO7XPaXwoCkyIh3F0nZc6J65XyNCwtJiEP1zJfEVubjyKZgVuSd3V9dns6ReF
        gYllF8tTQohb9E6uDBPftrZJixKvfmS5nEk8QZ4Uc8iZ62FdrjeiixlvrrkfLMMI4YCRGG
        SavMjmqhZqqo1ZwZunGS1v222ixNqQE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-88-zzSF0wJaMC-uBoYMme6tvg-1; Wed, 11 May 2022 07:18:35 -0400
X-MC-Unique: zzSF0wJaMC-uBoYMme6tvg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A162B2932490;
        Wed, 11 May 2022 11:18:34 +0000 (UTC)
Received: from starship (unknown [10.40.192.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 467B1400DFBB;
        Wed, 11 May 2022 11:18:32 +0000 (UTC)
Message-ID: <6594a8d2b28426f5f3a34d9b71f007de4cd19b69.camel@redhat.com>
Subject: Re: [PATCH v3 01/34] KVM: x86: hyper-v: Resurrect dedicated
 KVM_REQ_HV_TLB_FLUSH flag
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Wed, 11 May 2022 14:18:31 +0300
In-Reply-To: <20220414132013.1588929-2-vkuznets@redhat.com>
References: <20220414132013.1588929-1-vkuznets@redhat.com>
         <20220414132013.1588929-2-vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
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
> In preparation to implementing fine-grained Hyper-V TLB flush and
> L2 TLB flush, resurrect dedicated KVM_REQ_HV_TLB_FLUSH request bit. As
> KVM_REQ_TLB_FLUSH_GUEST is a stronger operation, clear KVM_REQ_HV_TLB_FLUSH
> request in kvm_service_local_tlb_flush_requests() when
> KVM_REQ_TLB_FLUSH_GUEST was also requested.
> 
> No functional change intended.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 2 ++
>  arch/x86/kvm/hyperv.c           | 4 ++--
>  arch/x86/kvm/x86.c              | 6 +++++-
>  3 files changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 2c20f715f009..1de3ad9308d8 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -105,6 +105,8 @@
>  	KVM_ARCH_REQ_FLAGS(30, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
>  #define KVM_REQ_MMU_FREE_OBSOLETE_ROOTS \
>  	KVM_ARCH_REQ_FLAGS(31, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
> +#define KVM_REQ_HV_TLB_FLUSH \
> +	KVM_ARCH_REQ_FLAGS(32, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
>  
>  #define CR0_RESERVED_BITS                                               \
>  	(~(unsigned long)(X86_CR0_PE | X86_CR0_MP | X86_CR0_EM | X86_CR0_TS \
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index 46f9dfb60469..b402ad059eb9 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -1876,11 +1876,11 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
>  	 * analyze it here, flush TLB regardless of the specified address space.
>  	 */
>  	if (all_cpus) {
> -		kvm_make_all_cpus_request(kvm, KVM_REQ_TLB_FLUSH_GUEST);
> +		kvm_make_all_cpus_request(kvm, KVM_REQ_HV_TLB_FLUSH);
>  	} else {
>  		sparse_set_to_vcpu_mask(kvm, sparse_banks, valid_bank_mask, vcpu_mask);
>  
> -		kvm_make_vcpus_request_mask(kvm, KVM_REQ_TLB_FLUSH_GUEST, vcpu_mask);
> +		kvm_make_vcpus_request_mask(kvm, KVM_REQ_HV_TLB_FLUSH, vcpu_mask);
>  	}
>  
>  ret_success:
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index ab336f7c82e4..f633cff8cd7f 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3360,8 +3360,12 @@ void kvm_service_local_tlb_flush_requests(struct kvm_vcpu *vcpu)
>  	if (kvm_check_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu))
>  		kvm_vcpu_flush_tlb_current(vcpu);
>  
> -	if (kvm_check_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu))
> +	if (kvm_check_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu)) {
>  		kvm_vcpu_flush_tlb_guest(vcpu);
> +		kvm_clear_request(KVM_REQ_HV_TLB_FLUSH, vcpu);
> +	} else if (kvm_check_request(KVM_REQ_HV_TLB_FLUSH, vcpu)) {
> +		kvm_vcpu_flush_tlb_guest(vcpu);
> +	}
>  }
>  EXPORT_SYMBOL_GPL(kvm_service_local_tlb_flush_requests);
>  

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

