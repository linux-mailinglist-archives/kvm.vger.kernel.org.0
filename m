Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22EBA4E885F
	for <lists+kvm@lfdr.de>; Sun, 27 Mar 2022 17:15:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235838AbiC0PRU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 27 Mar 2022 11:17:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235584AbiC0PRS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 27 Mar 2022 11:17:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6AFAA50B1E
        for <kvm@vger.kernel.org>; Sun, 27 Mar 2022 08:15:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648394139;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BKiI+yu8gSQKkV1dOmz11Ez9SJQoOrHsmvHiDvRwtu8=;
        b=WJzNn8WA0RfVijueRXpccPYvIjkr9Fdc45SdJ0cQkoPZIZmWnxbCaJko/h/+fg5sfz7JTS
        KqxWyfBOUQks9ggXGvG5ox3aBlAxIkrf+veLOdXjEUGosQIfatZndrDV6MjatEPeJDPuoT
        OonSqqfYpP8Taqv3ShkTE/k5tICDMrE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-261-Y_Mkx-xjMfCWl5ASS4zJGQ-1; Sun, 27 Mar 2022 11:15:36 -0400
X-MC-Unique: Y_Mkx-xjMfCWl5ASS4zJGQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A038B85A5A8;
        Sun, 27 Mar 2022 15:15:35 +0000 (UTC)
Received: from starship (unknown [10.40.194.231])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 782B42166B25;
        Sun, 27 Mar 2022 15:15:31 +0000 (UTC)
Message-ID: <34459274f8eb734c771e67bdb29371c95a3d807b.camel@redhat.com>
Subject: Re: [PATCH 2/8] KVM: x86: SVM: use vmcb01 in avic_init_vmcb and
 init_vmcb
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        Ingo Molnar <mingo@redhat.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Date:   Sun, 27 Mar 2022 18:15:30 +0300
In-Reply-To: <fa6ea646-6609-af7f-e43c-ecd4cb54e210@redhat.com>
References: <20220322172449.235575-1-mlevitsk@redhat.com>
         <20220322172449.235575-3-mlevitsk@redhat.com>
         <fa6ea646-6609-af7f-e43c-ecd4cb54e210@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-03-24 at 19:12 +0100, Paolo Bonzini wrote:
> On 3/22/22 18:24, Maxim Levitsky wrote:
> >   
> >   void avic_init_vmcb(struct vcpu_svm *svm)
> >   {
> > -	struct vmcb *vmcb = svm->vmcb;
> > +	struct vmcb *vmcb = svm->vmcb01.ptr;
> >   	struct kvm_svm *kvm_svm = to_kvm_svm(svm->vcpu.kvm);
> >   	phys_addr_t bpa = __sme_set(page_to_phys(svm->avic_backing_page));
> >   	phys_addr_t lpa = __sme_set(page_to_phys(kvm_svm->avic_logical_id_table_page));
> 
> Let's do this for consistency with e.g. svm_hv_init_vmcb:
> 
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index b39fe614467a..ab202158137d 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -165,9 +165,8 @@ int avic_vm_init(struct kvm *kvm)
>   	return err;
>   }
>   
> -void avic_init_vmcb(struct vcpu_svm *svm)
> +void avic_init_vmcb(struct vcpu_svm *svm, struct vmcb *vmcb)
>   {
> -	struct vmcb *vmcb = svm->vmcb01.ptr;
>   	struct kvm_svm *kvm_svm = to_kvm_svm(svm->vcpu.kvm);
>   	phys_addr_t bpa = __sme_set(page_to_phys(svm->avic_backing_page));
>   	phys_addr_t lpa = __sme_set(page_to_phys(kvm_svm->avic_logical_id_table_page));
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index cc02506b7a19..ced8edad0c87 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1123,7 +1123,7 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
>   		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SPEC_CTRL, 1, 1);
>   
>   	if (kvm_vcpu_apicv_active(vcpu))
> -		avic_init_vmcb(svm);
> +		avic_init_vmcb(svm, vmcb);
>   
>   	if (vgif) {
>   		svm_clr_intercept(svm, INTERCEPT_STGI);
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index d07a5b88ea96..bbac6c24a8b8 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -591,7 +591,7 @@ extern struct kvm_x86_nested_ops svm_nested_ops;
>   int avic_ga_log_notifier(u32 ga_tag);
>   void avic_vm_destroy(struct kvm *kvm);
>   int avic_vm_init(struct kvm *kvm);
> -void avic_init_vmcb(struct vcpu_svm *svm);
> +void avic_init_vmcb(struct vcpu_svm *svm, struct vmcb *vmcb);
>   int avic_incomplete_ipi_interception(struct kvm_vcpu *vcpu);
>   int avic_unaccelerated_access_interception(struct kvm_vcpu *vcpu);
>   int avic_init_vcpu(struct vcpu_svm *svm);
> 

This is a very good idea, I will do this in the 
next version of the patches.

Best regards,
	Maxim Levitsky

