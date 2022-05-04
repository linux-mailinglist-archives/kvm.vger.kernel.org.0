Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCC3B519F97
	for <lists+kvm@lfdr.de>; Wed,  4 May 2022 14:33:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349767AbiEDMhN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 08:37:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349653AbiEDMg7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 08:36:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 82A963915E
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 05:33:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651667597;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aHYlr9CGl7IpjK8h/sO0XqVINbN1X58lTAyHvT3Wo+k=;
        b=aUeNWbo2kq+D2aX4salkLMAq7q6bV424njzXw7y/zTpxXZhVS2+NtbDvQgPtWRKOyqLz48
        1AsGPj0Pd7YmtbmLM1/QErtQdpwszh2goxDazn4mGPsHnd6pTLQckXuUrCtoXgqM2arobQ
        LVcVtDsX9kx/xRv7RoP0IMFdvS3NO7w=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-433-rCP5UuC3PeigN2ECxTmcVA-1; Wed, 04 May 2022 08:33:01 -0400
X-MC-Unique: rCP5UuC3PeigN2ECxTmcVA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DF108811E7A;
        Wed,  4 May 2022 12:33:00 +0000 (UTC)
Received: from starship (unknown [10.40.192.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C5EA01CBB5;
        Wed,  4 May 2022 12:32:58 +0000 (UTC)
Message-ID: <fe7cd5012445a941cf55ea82871ea51157490aaa.camel@redhat.com>
Subject: Re: [PATCH v3 11/14] KVM: SVM: Introduce hybrid-AVIC mode
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, joro@8bytes.org,
        jon.grimm@amd.com, wei.huang2@amd.com, terry.bowman@amd.com
Date:   Wed, 04 May 2022 15:32:57 +0300
In-Reply-To: <20220504073128.12031-12-suravee.suthikulpanit@amd.com>
References: <20220504073128.12031-1-suravee.suthikulpanit@amd.com>
         <20220504073128.12031-12-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-05-04 at 02:31 -0500, Suravee Suthikulpanit wrote:
> Currently, AVIC is inhibited when booting a VM w/ x2APIC support.
> because AVIC cannot virtualize x2APIC MSR register accesses.
> However, the AVIC doorbell can be used to accelerate interrupt
> injection into a running vCPU, while all guest accesses to x2APIC MSRs
> will be intercepted and emulated by KVM.
> 
> With hybrid-AVIC support, the APICV_INHIBIT_REASON_X2APIC is
> no longer enforced.
> 
> Suggested-by: Maxim Levitsky <mlevitsk@redhat.com>
> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> ---
>  arch/x86/kvm/svm/avic.c | 10 +++++++++-
>  arch/x86/kvm/svm/svm.c  |  9 ---------
>  2 files changed, 9 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index d07c58f06bed..3b6a96043633 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -92,12 +92,20 @@ static void avic_activate_vmcb(struct vcpu_svm *svm)
>  	vmcb->control.avic_physical_id &= ~AVIC_PHYSICAL_MAX_INDEX_MASK;
>  
>  	vmcb->control.int_ctl |= AVIC_ENABLE_MASK;
> -	if (apic_x2apic_mode(svm->vcpu.arch.apic)) {
> +
> +	/* Note:
> +	 * KVM can support hybrid-x2AVIC mode, where KVM emulates x2APIC
> +	 * MSR accesses, while interrupt injection to a running vCPU
> +	 * can be achieve using AVIC doorbell.
> +	 */
> +	if (apic_x2apic_mode(svm->vcpu.arch.apic) &&
> +	    (avic_mode == AVIC_MODE_X2)) {
>  		vmcb->control.int_ctl |= X2APIC_MODE_MASK;
>  		vmcb->control.avic_physical_id |= X2AVIC_MAX_PHYSICAL_ID;
>  		/* Disabling MSR intercept for x2APIC registers */
>  		avic_set_x2apic_msr_interception(svm, false);
>  	} else {
> +		/* For xAVIC and hybrid-x2AVIC modes */
>  		vmcb->control.avic_physical_id |= AVIC_MAX_PHYSICAL_ID;
>  		/* Enabling MSR intercept for x2APIC registers */
>  		avic_set_x2apic_msr_interception(svm, true);
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 96a1fc1a1d1b..c0a3d4a1f3dc 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4041,7 +4041,6 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  	struct kvm_cpuid_entry2 *best;
> -	struct kvm *kvm = vcpu->kvm;
>  
>  	vcpu->arch.xsaves_enabled = guest_cpuid_has(vcpu, X86_FEATURE_XSAVE) &&
>  				    boot_cpu_has(X86_FEATURE_XSAVE) &&
> @@ -4073,14 +4072,6 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>  			vcpu->arch.reserved_gpa_bits &= ~(1UL << (best->ebx & 0x3f));
>  	}
>  
> -	if (kvm_vcpu_apicv_active(vcpu)) {
> -		/*
> -		 * AVIC does not work with an x2APIC mode guest. If the X2APIC feature
> -		 * is exposed to the guest, disable AVIC.
> -		 */
> -		if (guest_cpuid_has(vcpu, X86_FEATURE_X2APIC))
> -			kvm_set_apicv_inhibit(kvm, APICV_INHIBIT_REASON_X2APIC);
> -	}
>  	init_vmcb_after_set_cpuid(vcpu);
>  }
>  


Well strictly speaking, another thing that has to be done, other that removing the inhibit,
is to 'hide' the AVIC's private memslot if one of vCPUs is in x2apic mode, 
although not doing this doesn't cause any harm as the guest is not supposed to poke at xAPIC
mmio even when uses x2apic, and if it does it will get the normal AVIC acceleration,
so probably it is better to not add any more complexity and leave it like that.

Besides that my only note on this is that you forgot the most satisfying part of this,
removing the APICV_INHIBIT_REASON_X2APIC value ;-)

So besides the removal of the APICV_INHIBIT_REASON_X2APIC:

Reviewed-by: Maxim Levitsky <mlevisk@redhat.com>


BTW, hardware wise, does 'X2APIC_MODE' keeps the emulation of the AVIC mmio, or
not?

Best regards,
	Maxim Levitsky

