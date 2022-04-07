Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D72AD4F86BB
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 19:58:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346675AbiDGR77 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Apr 2022 13:59:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346670AbiDGR75 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Apr 2022 13:59:57 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AC4722FDA4
        for <kvm@vger.kernel.org>; Thu,  7 Apr 2022 10:57:57 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id ku13-20020a17090b218d00b001ca8fcd3adeso9580336pjb.2
        for <kvm@vger.kernel.org>; Thu, 07 Apr 2022 10:57:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Zrw2cU/GtraplrRpyw0HC5Ztjhcisc45ECf7qfFu5hw=;
        b=gZKwhG4AbEvuAbeS/YyjUMtMmpXdiDK5czIevURvnBK/LO4IZRlGpkhqVOoqhH7UOl
         /GR5qKZ6Y+lXbPl4PNvClAFOR1FxQw3x2JJKeqEcF47fiw9lfXqlrw01AcTCecEd550A
         DN9AgKR6vZczlVIlJC+uCJS1LW4EQK9T4p27Ym96+OtrC/nCIUJ9Y5x9MbrHkXYLLr+j
         2fAXu68fb+3l/vrvIfVX5Oum27VB9PMB8qKxPo2x5ZZDNO1FCAdCq49PfjNijNCxwtCP
         Is2RVvMlvYcu1En6KlhpRXmYdXlWavPZZ65cRNUbDOJet2RWG1iZlXMjhJUi0H39rJLo
         licQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Zrw2cU/GtraplrRpyw0HC5Ztjhcisc45ECf7qfFu5hw=;
        b=V9KaH8SNrmKfkhkgdbDuF94sUlNA/ykvA632X1C+Dw0LBkoRiFpBo7TneojN7QqNVc
         IdtogcFL6JvEz35Z1VT0Jolhoo+3Wca01dEAfI95gDgK7i2OGFPzuLVsAks7jEBRfNFb
         YsAoihkLmNTQQ3L9puHPKTFijfbJ9jv0qciNd8Y2XevCPmQpHc3yH8Hqx8VwkCwSK5Ws
         IiHrjWM7pp17RwcOa9tgTM4xqkrju1ZsMCtVHXpDTf8RYl4RVk6U5J2a3xPjIQedLwUy
         dJz1GKIpancOsLmCXVCDwNKiqd9UP1Hn05+XQ4VkBQ+bfF0srhYxCAOkmBLaqqz1TlDh
         jiuQ==
X-Gm-Message-State: AOAM532NaR2t/e89Y/AW6V6t0J449OQRGQhwCSbd1SFs/LMFBs3kI0Sm
        Rc4d6bFiYy31Mx5dcroKbPBc6Q==
X-Google-Smtp-Source: ABdhPJzpx8DCg6/7sFzsb5rVN86uadU6Yohzv+JmgkKo35oWR7wDLKJGdYhchW8DRqNO+5l6sW7tZw==
X-Received: by 2002:a17:90a:2a0f:b0:1ca:842a:b82 with SMTP id i15-20020a17090a2a0f00b001ca842a0b82mr17255696pjd.37.1649354276277;
        Thu, 07 Apr 2022 10:57:56 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id 12-20020a17090a08cc00b001cb11ab01ffsm3085840pjn.8.2022.04.07.10.57.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Apr 2022 10:57:55 -0700 (PDT)
Date:   Thu, 7 Apr 2022 17:57:51 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 07/31] KVM: x86: hyper-v: Create a separate ring for
 Direct TLB flush
Message-ID: <Yk8mHwUm9FtmgjzA@google.com>
References: <20220407155645.940890-1-vkuznets@redhat.com>
 <20220407155645.940890-8-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220407155645.940890-8-vkuznets@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 07, 2022, Vitaly Kuznetsov wrote:
> To handle Direct TLB flush requests from L2 KVM needs to use a
> separate ring from regular Hyper-V TLB flush requests: e.g. when a
> request to flush something in L2 is made, the target vCPU can
> transition from L2 to L1, receive a request to flush a GVA for L1 and
> then try to enter L2 back. The first request needs to be processed
> then. Similarly, requests to flush GVAs in L1 must wait until L2
> exits to L1.
> 
> No functional change yet as KVM doesn't handle Direct TLB flush
> requests from L2 yet.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  3 ++-
>  arch/x86/kvm/hyperv.c           |  7 ++++---
>  arch/x86/kvm/hyperv.h           | 17 ++++++++++++++---
>  3 files changed, 20 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 15d798fe280d..b8d7c1422da6 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -617,7 +617,8 @@ struct kvm_vcpu_hv {
>  		u32 syndbg_cap_eax; /* HYPERV_CPUID_SYNDBG_PLATFORM_CAPABILITIES.EAX */
>  	} cpuid_cache;
>  
> -	struct kvm_vcpu_hv_tlbflush_ring tlb_flush_ring;

Probably feedback for a prior patch, but please be consistent in tlbflush vs
tlb_flush.  I prefer the tlb_flush variant.

> +	/* Two rings for regular Hyper-V TLB flush and Direct TLB flush */
> +	struct kvm_vcpu_hv_tlbflush_ring tlb_flush_ring[2];

Use an enum, then the magic numbers go away, e.g.

enum hv_tlb_flush_rings {
	HV_L1_TLB_FLUSH_RING,
	HV_L2_TLB_FLUSH_RING,
	HV_NR_TLB_FLUSH_RINGS,
}

>  };
>  
>  /* Xen HVM per vcpu emulation context */
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index 918642bcdbd0..16cbf41b5b7b 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -956,7 +956,8 @@ static int kvm_hv_vcpu_init(struct kvm_vcpu *vcpu)
>  
>  	hv_vcpu->vp_index = vcpu->vcpu_idx;
>  
> -	spin_lock_init(&hv_vcpu->tlb_flush_ring.write_lock);
> +	spin_lock_init(&hv_vcpu->tlb_flush_ring[0].write_lock);
> +	spin_lock_init(&hv_vcpu->tlb_flush_ring[1].write_lock);

Or

	for (i = 0; i < ARRAY_SIZE(&hv_vcpu->tlb_flush_ring); i++)
		spin_lock_init(&hv_vcpu->tlb_flush_ring[i].write_lock)

or replace ARRAY_SIZE() with HV_NR_TLB_FLUSH_RINGS.

>  
>  	return 0;
>  }
> @@ -1860,7 +1861,7 @@ static void hv_tlb_flush_ring_enqueue(struct kvm_vcpu *vcpu, bool flush_all,
>  	if (!hv_vcpu)
>  		return;
>  
> -	tlb_flush_ring = &hv_vcpu->tlb_flush_ring;
> +	tlb_flush_ring = &hv_vcpu->tlb_flush_ring[0];

The [0] is gross, and it only gets worse in future patches that take @direct,
though this is slightly less gross:

	/* Here's a comment explaining why this is hardcoded to L1's ring. */
	tlb_flush_ring = &hv_vcpu->tlb_flush_ring[HV_L1_TLB_FLUSH_RING];

More thoughts in the patch that adds @direct.

>  	spin_lock_irqsave(&tlb_flush_ring->write_lock, flags);
>  
> @@ -1920,7 +1921,7 @@ void kvm_hv_vcpu_flush_tlb(struct kvm_vcpu *vcpu)
>  		return;
>  	}
>  
> -	tlb_flush_ring = &hv_vcpu->tlb_flush_ring;
> +	tlb_flush_ring = kvm_hv_get_tlb_flush_ring(vcpu);
>  	read_idx = READ_ONCE(tlb_flush_ring->read_idx);
>  	write_idx = READ_ONCE(tlb_flush_ring->write_idx);
>  
> diff --git a/arch/x86/kvm/hyperv.h b/arch/x86/kvm/hyperv.h
> index 6847caeaaf84..448877b478ef 100644
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
> @@ -147,15 +148,25 @@ int kvm_vm_ioctl_hv_eventfd(struct kvm *kvm, struct kvm_hyperv_eventfd *args);
>  int kvm_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
>  		     struct kvm_cpuid_entry2 __user *entries);
>  
> +static inline struct kvm_vcpu_hv_tlbflush_ring *kvm_hv_get_tlb_flush_ring(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
> +
> +	if (!is_guest_mode(vcpu))
> +		return &hv_vcpu->tlb_flush_ring[0];

Maybe this?

	int i = !is_guest_mode(vcpu) ? HV_L1_TLB_FLUSH_RING :
				       HV_L2_TLB_FLUSH_RING;

	return &hv_vcpu->tlb_flush_ring[i];

Though shouldn't this be a WARN condition as of this patch?  I.e. shouldn't it be
impossible to request a flush for L2 at this point?

> +
> +	return &hv_vcpu->tlb_flush_ring[1];
> +}
>  
>  static inline void kvm_hv_vcpu_empty_flush_tlb(struct kvm_vcpu *vcpu)
>  {
> -	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
> +	struct kvm_vcpu_hv_tlbflush_ring *tlb_flush_ring;
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
> -- 
> 2.35.1
> 
