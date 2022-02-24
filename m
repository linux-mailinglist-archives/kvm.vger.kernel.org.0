Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BDE74C36AC
	for <lists+kvm@lfdr.de>; Thu, 24 Feb 2022 21:12:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234290AbiBXUNC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Feb 2022 15:13:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233715AbiBXUM7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Feb 2022 15:12:59 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F352F15E6EA
        for <kvm@vger.kernel.org>; Thu, 24 Feb 2022 12:12:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645733547;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3w+xrQ/brXhB3EAKYqVGuwFhQ8i6mior/cxHqxMPHcs=;
        b=E0fREdK2MUxAGEfttGYtn5eZFfY+KPeQKiWhOCTauqnDyldrVP6wQCpWxE/J8akfoEHdHl
        A6en0i4Saw72BwmiKHxDRtaYr3Ozqg2LCMhHEgXNbnNnfaJL4e0FhfBLJY1aMRH1LrwCuI
        V7f3o30gHHcLxOcjSiqUanHBayxWe18=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-85-d5JrptdOMUex4Z5gzh0LFg-1; Thu, 24 Feb 2022 15:12:23 -0500
X-MC-Unique: d5JrptdOMUex4Z5gzh0LFg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 24380801AAD;
        Thu, 24 Feb 2022 20:12:22 +0000 (UTC)
Received: from starship (unknown [10.40.195.190])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 910472CD52;
        Thu, 24 Feb 2022 20:12:19 +0000 (UTC)
Message-ID: <34f52fb38a54e22ede0f2e28c6a0ecb49bf01a68.camel@redhat.com>
Subject: Re: [RFC PATCH 13/13] KVM: SVM: Use fastpath x2apic IPI emulation
 when #vmexit with x2AVIC
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, joro@8bytes.org,
        jon.grimm@amd.com, wei.huang2@amd.com, terry.bowman@amd.com
Date:   Thu, 24 Feb 2022 22:12:18 +0200
In-Reply-To: <20220221021922.733373-14-suravee.suthikulpanit@amd.com>
References: <20220221021922.733373-1-suravee.suthikulpanit@amd.com>
         <20220221021922.733373-14-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 2022-02-20 at 20:19 -0600, Suravee Suthikulpanit wrote:
> When sends IPI to a halting vCPU, the hardware generates
> avic_incomplete_ipi #vmexit with the
> AVIC_IPI_FAILURE_TARGET_NOT_RUNNING reason.
> 
> For x2AVIC, enable fastpath emulation.
> 
> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> ---
>  arch/x86/kvm/svm/avic.c | 2 ++
>  arch/x86/kvm/x86.c      | 3 ++-
>  arch/x86/kvm/x86.h      | 1 +
>  3 files changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index 874c89f8fd47..758a79ee7f99 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -428,6 +428,8 @@ int avic_incomplete_ipi_interception(struct kvm_vcpu *vcpu)
>  		kvm_lapic_reg_write(apic, APIC_ICR, icrl);
>  		break;
>  	case AVIC_IPI_FAILURE_TARGET_NOT_RUNNING:
> +		handle_fastpath_set_x2apic_icr_irqoff(vcpu, svm->vmcb->control.exit_info_1);

This just doesn't seem right - it sends IPI to the target, while we just need to wake it up.
avic_kick_target_vcpus already does all of this, and it really should be optimized to avoid
going over all vcpus as it does currently.

Best regards,
	Maxim Levitsky



> +
>  		/*
>  		 * At this point, we expect that the AVIC HW has already
>  		 * set the appropriate IRR bits on the valid target
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 641044db415d..c293027c7c10 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2008,7 +2008,7 @@ static inline bool kvm_vcpu_exit_request(struct kvm_vcpu *vcpu)
>   * from guest to host, e.g. reacquiring KVM's SRCU lock. In contrast to the
>   * other cases which must be called after interrupts are enabled on the host.
>   */
> -static int handle_fastpath_set_x2apic_icr_irqoff(struct kvm_vcpu *vcpu, u64 data)
> +int handle_fastpath_set_x2apic_icr_irqoff(struct kvm_vcpu *vcpu, u64 data)
>  {
>  	if (!lapic_in_kernel(vcpu) || !apic_x2apic_mode(vcpu->arch.apic))
>  		return 1;
> @@ -2028,6 +2028,7 @@ static int handle_fastpath_set_x2apic_icr_irqoff(struct kvm_vcpu *vcpu, u64 data
>  
>  	return 1;
>  }
> +EXPORT_SYMBOL_GPL(handle_fastpath_set_x2apic_icr_irqoff);
>  
>  static int handle_fastpath_set_tscdeadline(struct kvm_vcpu *vcpu, u64 data)
>  {
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 767ec7f99516..035d20f83ca6 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -286,6 +286,7 @@ int x86_decode_emulated_instruction(struct kvm_vcpu *vcpu, int emulation_type,
>  int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>  			    int emulation_type, void *insn, int insn_len);
>  fastpath_t handle_fastpath_set_msr_irqoff(struct kvm_vcpu *vcpu);
> +int handle_fastpath_set_x2apic_icr_irqoff(struct kvm_vcpu *vcpu, u64 data);
>  
>  extern u64 host_xcr0;
>  extern u64 supported_xcr0;


