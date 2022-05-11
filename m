Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C074E523189
	for <lists+kvm@lfdr.de>; Wed, 11 May 2022 13:27:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231130AbiEKLZp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 May 2022 07:25:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241417AbiEKLZD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 May 2022 07:25:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8580E231CAA
        for <kvm@vger.kernel.org>; Wed, 11 May 2022 04:25:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652268301;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pnwRPWX1JWvV38fOJfg+ykm13voR8XolBlGadCIaMpw=;
        b=gv0Pn4TivQ57bI0JEWWjE0YdxOd2SscPRqxq2VBLuqNaMGkm+fwpMe4a0HQLgYUywnUaYi
        3SCWwJtkLk7Hn8RY5s3dPMEOGVntUPVT07mnDMbmP4BzJqWXDLrDRuknP3Xtvok/0hcIqB
        u8RUeX41d7grF7AOReXoza8b8EWUSVc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-616-2-O3s_n8NJmXLAs4IzOHmg-1; Wed, 11 May 2022 07:24:57 -0400
X-MC-Unique: 2-O3s_n8NJmXLAs4IzOHmg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C2874800882;
        Wed, 11 May 2022 11:24:56 +0000 (UTC)
Received: from starship (unknown [10.40.192.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7ED7240CF8EB;
        Wed, 11 May 2022 11:24:54 +0000 (UTC)
Message-ID: <c78f7ffd449dcf4151bfe438e37cd033e3f0e062.camel@redhat.com>
Subject: Re: [PATCH v3 10/34] KVM: x86: hyper-v: Create a separate ring for
 L2 TLB flush
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Wed, 11 May 2022 14:24:53 +0300
In-Reply-To: <20220414132013.1588929-11-vkuznets@redhat.com>
References: <20220414132013.1588929-1-vkuznets@redhat.com>
         <20220414132013.1588929-11-vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-04-14 at 15:19 +0200, Vitaly Kuznetsov wrote:
> To handle L2 TLB flush requests, KVM needs to use a separate ring from
> regular (L1) Hyper-V TLB flush requests: e.g. when a request to flush
> something in L2 is made, the target vCPU can transition from L2 to L1,
> receive a request to flush a GVA for L1 and then try to enter L2 back.
> The first request needs to be processed at this point. Similarly,
> requests to flush GVAs in L1 must wait until L2 exits to L1.
> 
> No functional change as KVM doesn't handle L2 TLB flush requests from
> L2 yet.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  8 +++++++-
>  arch/x86/kvm/hyperv.c           |  8 +++++---
>  arch/x86/kvm/hyperv.h           | 19 ++++++++++++++++---
>  3 files changed, 28 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index b4dd2ff61658..058061621872 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -580,6 +580,12 @@ struct kvm_vcpu_hv_synic {
>  
>  #define KVM_HV_TLB_FLUSH_RING_SIZE (16)
>  
> +enum hv_tlb_flush_rings {
> +	HV_L1_TLB_FLUSH_RING,
> +	HV_L2_TLB_FLUSH_RING,
> +	HV_NR_TLB_FLUSH_RINGS,
> +};
> +
>  struct kvm_vcpu_hv_tlb_flush_entry {
>  	u64 addr;
>  	u64 flush_all:1;
> @@ -612,7 +618,7 @@ struct kvm_vcpu_hv {
>  		u32 syndbg_cap_eax; /* HYPERV_CPUID_SYNDBG_PLATFORM_CAPABILITIES.EAX */
>  	} cpuid_cache;
>  
> -	struct kvm_vcpu_hv_tlb_flush_ring tlb_flush_ring;
> +	struct kvm_vcpu_hv_tlb_flush_ring tlb_flush_ring[HV_NR_TLB_FLUSH_RINGS];
>  };
>  
>  /* Xen HVM per vcpu emulation context */
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index aebbb598ad1d..1cef2b8f7001 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -956,7 +956,8 @@ static int kvm_hv_vcpu_init(struct kvm_vcpu *vcpu)
>  
>  	hv_vcpu->vp_index = vcpu->vcpu_idx;
>  
> -	spin_lock_init(&hv_vcpu->tlb_flush_ring.write_lock);
> +	for (i = 0; i < HV_NR_TLB_FLUSH_RINGS; i++)
> +		spin_lock_init(&hv_vcpu->tlb_flush_ring[i].write_lock);
>  
>  	return 0;
>  }
> @@ -1852,7 +1853,8 @@ static void hv_tlb_flush_ring_enqueue(struct kvm_vcpu *vcpu, u64 *entries, int c
>  	if (!hv_vcpu)
>  		return;
>  
> -	tlb_flush_ring = &hv_vcpu->tlb_flush_ring;
> +	/* kvm_hv_flush_tlb() is not ready to handle requests for L2s yet */
> +	tlb_flush_ring = &hv_vcpu->tlb_flush_ring[HV_L1_TLB_FLUSH_RING];
>  
>  	spin_lock_irqsave(&tlb_flush_ring->write_lock, flags);
>  
> @@ -1921,7 +1923,7 @@ void kvm_hv_vcpu_flush_tlb(struct kvm_vcpu *vcpu)
>  		return;
>  	}
>  
> -	tlb_flush_ring = &hv_vcpu->tlb_flush_ring;
> +	tlb_flush_ring = kvm_hv_get_tlb_flush_ring(vcpu);
>  
>  	/*
>  	 * TLB flush must be performed on the target vCPU so 'read_idx'
> diff --git a/arch/x86/kvm/hyperv.h b/arch/x86/kvm/hyperv.h
> index 6847caeaaf84..d59f96700104 100644
> --- a/arch/x86/kvm/hyperv.h
> +++ b/arch/x86/kvm/hyperv.h
> @@ -22,6 +22,7 @@
>  #define __ARCH_X86_KVM_HYPERV_H__
>  
>  #include <linux/kvm_host.h>
> +#include "x86.h"
>  
>  /*
>   * The #defines related to the synthetic debugger are required by KDNet, but
> @@ -147,15 +148,27 @@ int kvm_vm_ioctl_hv_eventfd(struct kvm *kvm, struct kvm_hyperv_eventfd *args);
>  int kvm_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
>  		     struct kvm_cpuid_entry2 __user *entries);
>  
> +static inline struct kvm_vcpu_hv_tlb_flush_ring *kvm_hv_get_tlb_flush_ring(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
> +	int i = !is_guest_mode(vcpu) ? HV_L1_TLB_FLUSH_RING :
> +		HV_L2_TLB_FLUSH_RING;
> +
> +	/* KVM does not handle L2 TLB flush requests yet */
> +	WARN_ON_ONCE(i != HV_L1_TLB_FLUSH_RING);
> +
> +	return &hv_vcpu->tlb_flush_ring[i];
> +}
>  
>  static inline void kvm_hv_vcpu_empty_flush_tlb(struct kvm_vcpu *vcpu)
>  {
> -	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
> +	struct kvm_vcpu_hv_tlb_flush_ring *tlb_flush_ring;
>  
> -	if (!hv_vcpu)
> +	if (!to_hv_vcpu(vcpu))
>  		return;
>  
> -	hv_vcpu->tlb_flush_ring.read_idx = hv_vcpu->tlb_flush_ring.write_idx;
> +	tlb_flush_ring = kvm_hv_get_tlb_flush_ring(vcpu);
> +	tlb_flush_ring->read_idx = tlb_flush_ring->write_idx;
>  }
>  void kvm_hv_vcpu_flush_tlb(struct kvm_vcpu *vcpu);
>  


Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

