Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D60852BD6A
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 16:18:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237461AbiERMr3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 08:47:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237794AbiERMqc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 08:46:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BD4771A3595
        for <kvm@vger.kernel.org>; Wed, 18 May 2022 05:43:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652877790;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8sp1AZTsVwKlhQc+YaMhxHvmVTkY1Ldp+tQJ/IC5G3M=;
        b=iZ5QASfTGD5gt+sBfljrNgRJNtJzkIyRMG0bZaYnirEK6k9abbu6QsW2z+9zLJFYuhiaKN
        eoyG/bkjcWGDaLsQ5j10C7dPw7PIhTD37sMpUIYPCQlAzNnp79OEBEwb5ARmKL+2tXTR96
        E++zzvGH9sUvhzOjzahtvDfwc+Kupiw=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-110-P3jI9QJhNNq-M-dGg5YOpg-1; Wed, 18 May 2022 08:43:09 -0400
X-MC-Unique: P3jI9QJhNNq-M-dGg5YOpg-1
Received: by mail-wr1-f70.google.com with SMTP id w20-20020adfd1b4000000b0020cbb4347e6so552806wrc.17
        for <kvm@vger.kernel.org>; Wed, 18 May 2022 05:43:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=8sp1AZTsVwKlhQc+YaMhxHvmVTkY1Ldp+tQJ/IC5G3M=;
        b=dL813PbjRsUGBRItIbZGjz/FhW1NoFSy2M5cz4lgLsKb4ed1hdCuA5YYQbf/T/aVSM
         pWSzWBhalCtaeB1Vlfp4ObyEkPXQJPhdVVFsimpkKaK3whCRtDj/F/p4y67T3/qVk2xb
         LpoqqxhNkbIyEJMCsCwwuv2+lWk0J8RCpFwEczHLNaa/kIOtMv5Km6MbYNiFCSl1TjBQ
         Dz1+xZA9isQAbGvi61fwxmVYFcTl5aiqGe33lbasCBKRAUAr7qCTkUSY3IP6yh/ani7U
         3VAT6SKhcPls0biC+dkmm1g68v7xF6zPmPyVZ2BObm01FI6Uu24t1CJ5jhp0j6sa1qr+
         mTmA==
X-Gm-Message-State: AOAM530RURf1epsnkeMchujN/6iBbOoDx1Ft7lw6aE2188G7HVz1odMB
        +X5uDAtehtJTUodflp86pDEFXP/CRUQsnt3XNGQEA705KIKUX8oNLOR5Bp0HgJ72q5QiE8WLZ1z
        LCkCJQWZc7i10
X-Received: by 2002:a05:600c:4f15:b0:394:8ea0:bb45 with SMTP id l21-20020a05600c4f1500b003948ea0bb45mr25964709wmq.206.1652877788573;
        Wed, 18 May 2022 05:43:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyhEfV7UD7ccFso+2Cr2aFdjNKyFXmOetoImfKzVeTI8YIwgYAJmh/GUkPIje9ETqc0ZXPaMw==
X-Received: by 2002:a05:600c:4f15:b0:394:8ea0:bb45 with SMTP id l21-20020a05600c4f1500b003948ea0bb45mr25964676wmq.206.1652877788335;
        Wed, 18 May 2022 05:43:08 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id f1-20020a5d64c1000000b0020c5253d927sm1990018wri.115.2022.05.18.05.43.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 May 2022 05:43:07 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v3 14/34] KVM: x86: Introduce .post_hv_l2_tlb_flush()
 nested hook
In-Reply-To: <deae695da02d7f22dcfa4635eec53ab61baf9026.camel@redhat.com>
References: <20220414132013.1588929-1-vkuznets@redhat.com>
 <20220414132013.1588929-15-vkuznets@redhat.com>
 <deae695da02d7f22dcfa4635eec53ab61baf9026.camel@redhat.com>
Date:   Wed, 18 May 2022 14:43:07 +0200
Message-ID: <871qwrui3o.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Maxim Levitsky <mlevitsk@redhat.com> writes:

> On Thu, 2022-04-14 at 15:19 +0200, Vitaly Kuznetsov wrote:
>> Hyper-V supports injecting synthetic L2->L1 exit after performing
>> L2 TLB flush operation but the procedure is vendor specific.
>> Introduce .post_hv_l2_tlb_flush() nested hook for it.
>> 
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> ---
>>  arch/x86/include/asm/kvm_host.h |  1 +
>>  arch/x86/kvm/Makefile           |  3 ++-
>>  arch/x86/kvm/svm/hyperv.c       | 11 +++++++++++
>>  arch/x86/kvm/svm/hyperv.h       |  2 ++
>>  arch/x86/kvm/svm/nested.c       |  1 +
>>  arch/x86/kvm/vmx/evmcs.c        |  4 ++++
>>  arch/x86/kvm/vmx/evmcs.h        |  1 +
>>  arch/x86/kvm/vmx/nested.c       |  1 +
>>  8 files changed, 23 insertions(+), 1 deletion(-)
>>  create mode 100644 arch/x86/kvm/svm/hyperv.c
>> 
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> index 8b2a52bf26c0..ce62fde5f4ff 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -1558,6 +1558,7 @@ struct kvm_x86_nested_ops {
>>  	int (*enable_evmcs)(struct kvm_vcpu *vcpu,
>>  			    uint16_t *vmcs_version);
>>  	uint16_t (*get_evmcs_version)(struct kvm_vcpu *vcpu);
>> +	void (*post_hv_l2_tlb_flush)(struct kvm_vcpu *vcpu);
>>  };
>>  
>>  struct kvm_x86_init_ops {
>> diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
>> index 30f244b64523..b6d53b045692 100644
>> --- a/arch/x86/kvm/Makefile
>> +++ b/arch/x86/kvm/Makefile
>> @@ -25,7 +25,8 @@ kvm-intel-y		+= vmx/vmx.o vmx/vmenter.o vmx/pmu_intel.o vmx/vmcs12.o \
>>  			   vmx/evmcs.o vmx/nested.o vmx/posted_intr.o
>>  kvm-intel-$(CONFIG_X86_SGX_KVM)	+= vmx/sgx.o
>>  
>> -kvm-amd-y		+= svm/svm.o svm/vmenter.o svm/pmu.o svm/nested.o svm/avic.o svm/sev.o
>> +kvm-amd-y		+= svm/svm.o svm/vmenter.o svm/pmu.o svm/nested.o svm/avic.o \
>> +			   svm/sev.o svm/hyperv.o
>>  
>>  ifdef CONFIG_HYPERV
>>  kvm-amd-y		+= svm/svm_onhyperv.o
>> diff --git a/arch/x86/kvm/svm/hyperv.c b/arch/x86/kvm/svm/hyperv.c
>> new file mode 100644
>> index 000000000000..c0749fc282fe
>> --- /dev/null
>> +++ b/arch/x86/kvm/svm/hyperv.c
>> @@ -0,0 +1,11 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/*
>> + * AMD SVM specific code for Hyper-V on KVM.
>> + *
>> + * Copyright 2022 Red Hat, Inc. and/or its affiliates.
>> + */
>> +#include "hyperv.h"
>> +
>> +void svm_post_hv_l2_tlb_flush(struct kvm_vcpu *vcpu)
>> +{
>> +}
>> diff --git a/arch/x86/kvm/svm/hyperv.h b/arch/x86/kvm/svm/hyperv.h
>> index 8cf702fed7e5..a2b0d7580b0d 100644
>> --- a/arch/x86/kvm/svm/hyperv.h
>> +++ b/arch/x86/kvm/svm/hyperv.h
>> @@ -48,4 +48,6 @@ static inline void nested_svm_hv_update_vm_vp_ids(struct kvm_vcpu *vcpu)
>>  	hv_vcpu->nested.vp_id = hve->hv_vp_id;
>>  }
>>  
>> +void svm_post_hv_l2_tlb_flush(struct kvm_vcpu *vcpu);
>> +
>>  #endif /* __ARCH_X86_KVM_SVM_HYPERV_H__ */
>> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
>> index 2d1a76343404..de3f27301b5c 100644
>> --- a/arch/x86/kvm/svm/nested.c
>> +++ b/arch/x86/kvm/svm/nested.c
>> @@ -1665,4 +1665,5 @@ struct kvm_x86_nested_ops svm_nested_ops = {
>>  	.get_nested_state_pages = svm_get_nested_state_pages,
>>  	.get_state = svm_get_nested_state,
>>  	.set_state = svm_set_nested_state,
>> +	.post_hv_l2_tlb_flush = svm_post_hv_l2_tlb_flush,
>>  };
>> diff --git a/arch/x86/kvm/vmx/evmcs.c b/arch/x86/kvm/vmx/evmcs.c
>> index 87e3dc10edf4..e390e67496df 100644
>> --- a/arch/x86/kvm/vmx/evmcs.c
>> +++ b/arch/x86/kvm/vmx/evmcs.c
>> @@ -437,3 +437,7 @@ int nested_enable_evmcs(struct kvm_vcpu *vcpu,
>>  
>>  	return 0;
>>  }
>> +
>> +void vmx_post_hv_l2_tlb_flush(struct kvm_vcpu *vcpu)
>> +{
>> +}
>> diff --git a/arch/x86/kvm/vmx/evmcs.h b/arch/x86/kvm/vmx/evmcs.h
>> index 8d70f9aea94b..b120b0ead4f3 100644
>> --- a/arch/x86/kvm/vmx/evmcs.h
>> +++ b/arch/x86/kvm/vmx/evmcs.h
>> @@ -244,5 +244,6 @@ int nested_enable_evmcs(struct kvm_vcpu *vcpu,
>>  			uint16_t *vmcs_version);
>>  void nested_evmcs_filter_control_msr(u32 msr_index, u64 *pdata);
>>  int nested_evmcs_check_controls(struct vmcs12 *vmcs12);
>> +void vmx_post_hv_l2_tlb_flush(struct kvm_vcpu *vcpu);
>>  
>>  #endif /* __KVM_X86_VMX_EVMCS_H */
>> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
>> index ee88921c6156..cc6c944b5815 100644
>> --- a/arch/x86/kvm/vmx/nested.c
>> +++ b/arch/x86/kvm/vmx/nested.c
>> @@ -6850,4 +6850,5 @@ struct kvm_x86_nested_ops vmx_nested_ops = {
>>  	.write_log_dirty = nested_vmx_write_pml_buffer,
>>  	.enable_evmcs = nested_enable_evmcs,
>>  	.get_evmcs_version = nested_get_evmcs_version,
>> +	.post_hv_l2_tlb_flush = vmx_post_hv_l2_tlb_flush,
>>  };
>
>
> I think that the name of the function is misleading, since it is not called
> after each L2 HV tlb flush, but only after a flush which needs to inject
> that synthetic VM exit.
>
> I think something like 'inject_synthetic_l2_hv_tlb_flush_vmexit' 
> (not a good name IMHO, but you get the idea) would be better.
>

Naming is hard indeed,

hv_inject_synthetic_vmexit_post_tlb_flush()

seems to be accurate.

-- 
Vitaly

