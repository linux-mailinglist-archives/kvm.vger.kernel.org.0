Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CDA84C3688
	for <lists+kvm@lfdr.de>; Thu, 24 Feb 2022 21:07:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234199AbiBXUHP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Feb 2022 15:07:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233578AbiBXUHN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Feb 2022 15:07:13 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 372BF42EF6
        for <kvm@vger.kernel.org>; Thu, 24 Feb 2022 12:06:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645733201;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g0B+WO5LiFSrbCtPwzNlhDkRjWZYlmhLiJlV8EM915Y=;
        b=DBADlEyAhYfGTR1kUgij/RqJcRExuZkHgb1kIL4FBttlaJyYTuiHyoFrerhjYQEW7xnDyd
        Z+fuS3Yu+76lTNMNxdnDB5h3zA8DPSfkROCIMEXqi3QimgFh8N+/qz2uHRivrEPa2sWV2m
        1Buy35ED4lPL7zkfaol2irL0leWDAeU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-634-GPMiioRsN1epimur1G8LOA-1; Thu, 24 Feb 2022 15:06:40 -0500
X-MC-Unique: GPMiioRsN1epimur1G8LOA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AF2201854E21;
        Thu, 24 Feb 2022 20:06:38 +0000 (UTC)
Received: from starship (unknown [10.40.195.190])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 77C9B2D1F7;
        Thu, 24 Feb 2022 20:06:35 +0000 (UTC)
Message-ID: <e18ed786f77e4abec112cafef69608883099e19f.camel@redhat.com>
Subject: Re: [RFC PATCH 12/13] KVM: SVM: Remove APICv inhibit reasone due to
 x2APIC
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, joro@8bytes.org,
        jon.grimm@amd.com, wei.huang2@amd.com, terry.bowman@amd.com
Date:   Thu, 24 Feb 2022 22:06:34 +0200
In-Reply-To: <20220221021922.733373-13-suravee.suthikulpanit@amd.com>
References: <20220221021922.733373-1-suravee.suthikulpanit@amd.com>
         <20220221021922.733373-13-suravee.suthikulpanit@amd.com>
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
> Currently, AVIC is inactive when booting a VM w/ x2APIC support.
> With x2AVIC support, the APICV_INHIBIT_REASON_X2APIC can be removed.
The commit title is a bit misleading - the inhibit reason is not removed,
but rather AVIC is not inhibited when x2avic is present.

> 
> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> ---
>  arch/x86/kvm/svm/avic.c | 21 +++++++++++++++++++++
>  arch/x86/kvm/svm/svm.c  | 18 ++----------------
>  arch/x86/kvm/svm/svm.h  |  1 +
>  3 files changed, 24 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index 3306b74f1d8b..874c89f8fd47 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -21,6 +21,7 @@
>  
>  #include <asm/irq_remapping.h>
>  
> +#include "cpuid.h"
>  #include "trace.h"
>  #include "lapic.h"
>  #include "x86.h"
> @@ -176,6 +177,26 @@ void avic_vm_destroy(struct kvm *kvm)
>  	spin_unlock_irqrestore(&svm_vm_data_hash_lock, flags);
>  }
>  
> +void avic_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu, int nested)
> +{
> +	/*
> +	 * If the X2APIC feature is exposed to the guest,
> +	 * disable AVIC unless X2AVIC mode is enabled.
> +	 */
> +	if (avic_mode == AVIC_MODE_X1 &&
> +	    guest_cpuid_has(vcpu, X86_FEATURE_X2APIC))
> +		kvm_request_apicv_update(vcpu->kvm, false,
> +					 APICV_INHIBIT_REASON_X2APIC);
> +
> +	/*
> +	 * Currently, AVIC does not work with nested virtualization.
> +	 * So, we disable AVIC when cpuid for SVM is set in the L1 guest.
> +	 */
> +	if (nested && guest_cpuid_has(vcpu, X86_FEATURE_SVM))
> +		kvm_request_apicv_update(vcpu->kvm, false,
> +					 APICV_INHIBIT_REASON_NESTED);

BTW, now that I am thinking about it, it would be nice to be able to force
the AVIC_MODE_X1 even if x2avic is present, for debug purposes from a module
param. Just a suggestion.

> +}
> +
>  int avic_vm_init(struct kvm *kvm)
>  {
>  	unsigned long flags;
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index afca26aa1f40..b7bc6cd74aba 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3992,23 +3992,9 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>  			vcpu->arch.reserved_gpa_bits &= ~(1UL << (best->ebx & 0x3f));
>  	}
>  
> -	if (kvm_vcpu_apicv_active(vcpu)) {
> -		/*
> -		 * AVIC does not work with an x2APIC mode guest. If the X2APIC feature
> -		 * is exposed to the guest, disable AVIC.
> -		 */
> -		if (guest_cpuid_has(vcpu, X86_FEATURE_X2APIC))
> -			kvm_request_apicv_update(vcpu->kvm, false,
> -						 APICV_INHIBIT_REASON_X2APIC);
> +	if (kvm_vcpu_apicv_active(vcpu))
> +		avic_vcpu_after_set_cpuid(vcpu, nested);
>  
> -		/*
> -		 * Currently, AVIC does not work with nested virtualization.
> -		 * So, we disable AVIC when cpuid for SVM is set in the L1 guest.
> -		 */
> -		if (nested && guest_cpuid_has(vcpu, X86_FEATURE_SVM))
> -			kvm_request_apicv_update(vcpu->kvm, false,
> -						 APICV_INHIBIT_REASON_NESTED);
> -	}
>  	init_vmcb_after_set_cpuid(vcpu);
>  }
>  
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 41514df5107e..aea80abe9186 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -578,6 +578,7 @@ void avic_update_vapic_bar(struct vcpu_svm *svm, u64 data);
>  void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
>  void avic_vcpu_put(struct kvm_vcpu *vcpu);
>  void avic_post_state_restore(struct kvm_vcpu *vcpu);
> +void avic_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu, int nested);
>  void svm_set_virtual_apic_mode(struct kvm_vcpu *vcpu);
>  void svm_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu);
>  bool svm_check_apicv_inhibit_reasons(ulong bit);

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

