Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B80953F9DF
	for <lists+kvm@lfdr.de>; Tue,  7 Jun 2022 11:33:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239655AbiFGJdu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jun 2022 05:33:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234297AbiFGJdr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jun 2022 05:33:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9EF2218E0D
        for <kvm@vger.kernel.org>; Tue,  7 Jun 2022 02:33:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654594424;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dtAAFPAK9nZ0pTcwBhR9/Qp8U0Xo4Qyrs4+xY7EZesg=;
        b=gx4JRsBMCzNfv3wQOMRgxro3V3+hrEalteCi6dMR6KTEXUbkX8aFj+SRCt6AISMfnExTFU
        TJV/4wGS5f0tSmubaA7KDTEEG0SZnSBI/RoXs9AO1SlFWoKEzM4/jTOxiMNynCpNH46qxt
        yDsOTNVNUuatgoKs1ZzyM5dogATqlQM=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-257-Ntb5CaRJO8S7ARVmmhzOUA-1; Tue, 07 Jun 2022 05:33:37 -0400
X-MC-Unique: Ntb5CaRJO8S7ARVmmhzOUA-1
Received: by mail-qk1-f198.google.com with SMTP id bk10-20020a05620a1a0a00b006a6b1d676ebso5777503qkb.0
        for <kvm@vger.kernel.org>; Tue, 07 Jun 2022 02:33:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=dtAAFPAK9nZ0pTcwBhR9/Qp8U0Xo4Qyrs4+xY7EZesg=;
        b=cfw7vDUBPKlIn9VmlNh4a7wwQ/OLkKNdADccwR8kPiZw14b/hLgs7xZMYoOANibQjg
         o7OqkZzBEec53vNxAi5dLWdM6i850z0g3age8eNdiI7Yv4Q08+ZY2H2NBqNTsHRP15A9
         JVJmMMTFIl4dn0XHWgHNKrh6or0oLmJB0rh87vkDKJZhN/1P+GZDmRCL1XNI7ZeQZ0s1
         wgOYnbtain869XtM0CV1w+fapU68f/CnMa30f0kiiWa7X4UIz5Y3hMYC3LMKc/oee8Qy
         K89kvZqsludHr7CUCgdvZ+7Yqi3prk1he0fwZNe33yAzx/R+LpL2ARr2Oqpnu4UapL0e
         IjDg==
X-Gm-Message-State: AOAM533cih/hLHopMVPMDFjeofNdGnUaVf9ctjuWRTHxzQxqLvmgv56J
        rlB2+d3nWXTinSnK7cklL8vUoYCG3KlmW+jR6Btjk0Rm4p7q9E6LZpsqhVaTSq12S3rpRWfjC+B
        qznSPfMIS99pg
X-Received: by 2002:ae9:efd4:0:b0:6a6:accc:3923 with SMTP id d203-20020ae9efd4000000b006a6accc3923mr10260018qkg.572.1654594417418;
        Tue, 07 Jun 2022 02:33:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz/A2h0NZXFe/wsfI+gsODxz+WxMmGWQmDh9AIx5IPvHDDRGrmKtpAyqY9up+jjHIBr8QYVFw==
X-Received: by 2002:ae9:efd4:0:b0:6a6:accc:3923 with SMTP id d203-20020ae9efd4000000b006a6accc3923mr10260002qkg.572.1654594417172;
        Tue, 07 Jun 2022 02:33:37 -0700 (PDT)
Received: from [10.35.4.238] (bzq-82-81-161-50.red.bezeqint.net. [82.81.161.50])
        by smtp.gmail.com with ESMTPSA id g20-20020a05620a40d400b006a5d8d96681sm5490218qko.100.2022.06.07.02.33.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jun 2022 02:33:36 -0700 (PDT)
Message-ID: <72303d13380dedcfa273d471b8fc7ebf89fb403f.camel@redhat.com>
Subject: Re: [PATCH v6 11/38] KVM: x86: hyper-v: Create a separate fifo for
 L2 TLB flush
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Tue, 07 Jun 2022 12:33:33 +0300
In-Reply-To: <20220606083655.2014609-12-vkuznets@redhat.com>
References: <20220606083655.2014609-1-vkuznets@redhat.com>
         <20220606083655.2014609-12-vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-2.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2022-06-06 at 10:36 +0200, Vitaly Kuznetsov wrote:
> To handle L2 TLB flush requests, KVM needs to use a separate fifo from
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
>  arch/x86/include/asm/kvm_host.h |  8 +++++++-
>  arch/x86/kvm/hyperv.c           | 11 +++++++----
>  arch/x86/kvm/hyperv.h           | 17 ++++++++++++++---
>  3 files changed, 28 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index cf3748be236d..0e58ab00dff0 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -613,6 +613,12 @@ struct kvm_vcpu_hv_synic {
>   */
>  #define KVM_HV_TLB_FLUSHALL_ENTRY  ((u64)-1)
>  
> +enum hv_tlb_flush_fifos {
> +       HV_L1_TLB_FLUSH_FIFO,
> +       HV_L2_TLB_FLUSH_FIFO,
> +       HV_NR_TLB_FLUSH_FIFOS,
> +};
> +
>  struct kvm_vcpu_hv_tlb_flush_fifo {
>         spinlock_t write_lock;
>         DECLARE_KFIFO(entries, u64, KVM_HV_TLB_FLUSH_FIFO_SIZE);
> @@ -638,7 +644,7 @@ struct kvm_vcpu_hv {
>                 u32 syndbg_cap_eax; /* HYPERV_CPUID_SYNDBG_PLATFORM_CAPABILITIES.EAX */
>         } cpuid_cache;
>  
> -       struct kvm_vcpu_hv_tlb_flush_fifo tlb_flush_fifo;
> +       struct kvm_vcpu_hv_tlb_flush_fifo tlb_flush_fifo[HV_NR_TLB_FLUSH_FIFOS];
>  };
>  
>  /* Xen HVM per vcpu emulation context */
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index b347971b3924..32f223bbea6b 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -956,8 +956,10 @@ static int kvm_hv_vcpu_init(struct kvm_vcpu *vcpu)
>  
>         hv_vcpu->vp_index = vcpu->vcpu_idx;
>  
> -       INIT_KFIFO(hv_vcpu->tlb_flush_fifo.entries);
> -       spin_lock_init(&hv_vcpu->tlb_flush_fifo.write_lock);
> +       for (i = 0; i < HV_NR_TLB_FLUSH_FIFOS; i++) {
> +               INIT_KFIFO(hv_vcpu->tlb_flush_fifo[i].entries);
> +               spin_lock_init(&hv_vcpu->tlb_flush_fifo[i].write_lock);
> +       }
>  
>         return 0;
>  }
> @@ -1843,7 +1845,8 @@ static void hv_tlb_flush_enqueue(struct kvm_vcpu *vcpu, u64 *entries, int count)
>         if (!hv_vcpu)
>                 return;
>  
> -       tlb_flush_fifo = &hv_vcpu->tlb_flush_fifo;
> +       /* kvm_hv_flush_tlb() is not ready to handle requests for L2s yet */
> +       tlb_flush_fifo = &hv_vcpu->tlb_flush_fifo[HV_L1_TLB_FLUSH_FIFO];
Yes, as expected here the local var starts to make sense.
>  
>         spin_lock_irqsave(&tlb_flush_fifo->write_lock, flags);
>  
> @@ -1880,7 +1883,7 @@ void kvm_hv_vcpu_flush_tlb(struct kvm_vcpu *vcpu)
>                 return;
>         }
>  
> -       tlb_flush_fifo = &hv_vcpu->tlb_flush_fifo;
> +       tlb_flush_fifo = kvm_hv_get_tlb_flush_fifo(vcpu);
>  
>         count = kfifo_out(&tlb_flush_fifo->entries, entries, KVM_HV_TLB_FLUSH_FIFO_SIZE);
>  
> diff --git a/arch/x86/kvm/hyperv.h b/arch/x86/kvm/hyperv.h
> index e5b32266ff7d..207d24efdc5a 100644
> --- a/arch/x86/kvm/hyperv.h
> +++ b/arch/x86/kvm/hyperv.h
> @@ -22,6 +22,7 @@
>  #define __ARCH_X86_KVM_HYPERV_H__
>  
>  #include <linux/kvm_host.h>
> +#include "x86.h"
>  
>  /*
>   * The #defines related to the synthetic debugger are required by KDNet, but
> @@ -147,16 +148,26 @@ int kvm_vm_ioctl_hv_eventfd(struct kvm *kvm, struct kvm_hyperv_eventfd *args);
>  int kvm_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
>                      struct kvm_cpuid_entry2 __user *entries);
>  
> +static inline struct kvm_vcpu_hv_tlb_flush_fifo *kvm_hv_get_tlb_flush_fifo(struct kvm_vcpu *vcpu)
> +{
> +       struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
> +       int i = !is_guest_mode(vcpu) ? HV_L1_TLB_FLUSH_FIFO :
> +                                      HV_L2_TLB_FLUSH_FIFO;
> +
> +       /* KVM does not handle L2 TLB flush requests yet */
> +       WARN_ON_ONCE(i != HV_L1_TLB_FLUSH_FIFO);
> +
> +       return &hv_vcpu->tlb_flush_fifo[i];
> +}
>  
>  static inline void kvm_hv_vcpu_empty_flush_tlb(struct kvm_vcpu *vcpu)
>  {
>         struct kvm_vcpu_hv_tlb_flush_fifo *tlb_flush_fifo;
> -       struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
>  
> -       if (!hv_vcpu || !kvm_check_request(KVM_REQ_HV_TLB_FLUSH, vcpu))
> +       if (!to_hv_vcpu(vcpu) || !kvm_check_request(KVM_REQ_HV_TLB_FLUSH, vcpu))
>                 return;
>  
> -       tlb_flush_fifo = &hv_vcpu->tlb_flush_fifo;
> +       tlb_flush_fifo = kvm_hv_get_tlb_flush_fifo(vcpu);
>  
>         kfifo_reset_out(&tlb_flush_fifo->entries);
>  }


Looks great,

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

