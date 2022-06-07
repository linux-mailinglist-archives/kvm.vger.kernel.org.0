Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC0AD53F9F0
	for <lists+kvm@lfdr.de>; Tue,  7 Jun 2022 11:36:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234715AbiFGJgv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jun 2022 05:36:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239788AbiFGJgq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jun 2022 05:36:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CBAFEE64D7
        for <kvm@vger.kernel.org>; Tue,  7 Jun 2022 02:36:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654594604;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TMMeeMzg716+0kOPZ1kJNvGjEZ2CaNLxMnft4GZfeHg=;
        b=LyTGbruzfIMPJ0Wr8bsONkXhgYqIZjKrEOCT6p4+xHn+PvkigTff440SSf4m520DZhQvSX
        PMKLLf8WiVtfcw9WBdK3jHYssCH+4a3eyfk8yzPdFnm6QQFLA+sulvSjq0Wm9eO6TdZpiM
        PNkaZ3eANqi7tcz5OSwW1zncMG0FF/E=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-643-iSqljlPgORCu89ZCC4OgqQ-1; Tue, 07 Jun 2022 05:36:43 -0400
X-MC-Unique: iSqljlPgORCu89ZCC4OgqQ-1
Received: by mail-qk1-f198.google.com with SMTP id s8-20020a05620a0bc800b006a6d42a1a0eso1716133qki.3
        for <kvm@vger.kernel.org>; Tue, 07 Jun 2022 02:36:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=TMMeeMzg716+0kOPZ1kJNvGjEZ2CaNLxMnft4GZfeHg=;
        b=yiBPN8P4ohA70HDkN77KF3eBsW1CaVNWeqRYiiuqc63jliHr2Se1nxtqrFHiFvtIG1
         FAVk2mU9AEBr8HsCtiwkBEWowD0opkb1992NzWPhIJVMt/FpRSESwOFgSmtOtzqqBT/t
         88Hv+OMWOXsTznRQDOUHWVaMZicr8RI8JV0AsMDkE5NRh3xVQ0RsZ77xvDU2cnG1Vs5M
         sKGcLYVGZVAXn6il5Sl5O5Dfp45+z7JtpXCloly7lWpRisE25FVIoWD++fvmdZrcCX3W
         6y7u1IRYfi6qx5TVb/URnfnCgRw5V0+BVrDNhK/toy1cj42mQEw8EE7f/711pvJim2ga
         80dw==
X-Gm-Message-State: AOAM530dUNh95nN2e0auT35kC5PbNpX63M97Nc03ZdwGzqYV5XR5mOXT
        kWgrrUlv7VrSKwYpwL1XoPxoz/9Kcr9p0HrOV9J7AQ6VWDnAfp1mD22MBi9QUjTiUcpAD/5GjUs
        MlJQjLH8YrFk5
X-Received: by 2002:a05:6214:27cc:b0:46b:bc28:7d4f with SMTP id ge12-20020a05621427cc00b0046bbc287d4fmr846707qvb.80.1654594603147;
        Tue, 07 Jun 2022 02:36:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyxCcLZX3ofJobo0dvjnhTkv9nwj9+XltzUdXK0HEeglyTnAe0VqZK4gyQ2MmA2ovb/JOXvEg==
X-Received: by 2002:a05:6214:27cc:b0:46b:bc28:7d4f with SMTP id ge12-20020a05621427cc00b0046bbc287d4fmr846702qvb.80.1654594602958;
        Tue, 07 Jun 2022 02:36:42 -0700 (PDT)
Received: from [10.35.4.238] (bzq-82-81-161-50.red.bezeqint.net. [82.81.161.50])
        by smtp.gmail.com with ESMTPSA id bm13-20020a05620a198d00b006a6d83fc9efsm1031130qkb.21.2022.06.07.02.36.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jun 2022 02:36:42 -0700 (PDT)
Message-ID: <c89186f11fa1eb3563b791ba68cca4a533aa537f.camel@redhat.com>
Subject: Re: [PATCH v6 14/38] KVM: nSVM: Keep track of Hyper-V
 hv_vm_id/hv_vp_id
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
Date:   Tue, 07 Jun 2022 12:36:38 +0300
In-Reply-To: <20220606083655.2014609-15-vkuznets@redhat.com>
References: <20220606083655.2014609-1-vkuznets@redhat.com>
         <20220606083655.2014609-15-vkuznets@redhat.com>
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
> Similar to nSVM, KVM needs to know L2's VM_ID/VP_ID and Partition
> assist page address to handle L2 TLB flush requests.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/kvm/svm/hyperv.h | 16 ++++++++++++++++
>  arch/x86/kvm/svm/nested.c |  2 ++
>  2 files changed, 18 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/hyperv.h b/arch/x86/kvm/svm/hyperv.h
> index 7d6d97968fb9..8cf702fed7e5 100644
> --- a/arch/x86/kvm/svm/hyperv.h
> +++ b/arch/x86/kvm/svm/hyperv.h
> @@ -9,6 +9,7 @@
>  #include <asm/mshyperv.h>
>  
>  #include "../hyperv.h"
> +#include "svm.h"
>  
>  /*
>   * Hyper-V uses the software reserved 32 bytes in VMCB
> @@ -32,4 +33,19 @@ struct hv_enlightenments {
>   */
>  #define VMCB_HV_NESTED_ENLIGHTENMENTS VMCB_SW
>  
> +static inline void nested_svm_hv_update_vm_vp_ids(struct kvm_vcpu *vcpu)
> +{
> +       struct vcpu_svm *svm = to_svm(vcpu);
> +       struct hv_enlightenments *hve =
> +               (struct hv_enlightenments *)svm->nested.ctl.reserved_sw;
> +       struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
> +
> +       if (!hv_vcpu)
> +               return;
> +
> +       hv_vcpu->nested.pa_page_gpa = hve->partition_assist_page;
> +       hv_vcpu->nested.vm_id = hve->hv_vm_id;
> +       hv_vcpu->nested.vp_id = hve->hv_vp_id;
> +}
> +
>  #endif /* __ARCH_X86_KVM_SVM_HYPERV_H__ */
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 88da8edbe1e1..e8908cc56e22 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -811,6 +811,8 @@ int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa,
>         if (kvm_vcpu_apicv_active(vcpu))
>                 kvm_make_request(KVM_REQ_APICV_UPDATE, vcpu);
>  
> +       nested_svm_hv_update_vm_vp_ids(vcpu);
> +
>         return 0;
>  }
>  

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

