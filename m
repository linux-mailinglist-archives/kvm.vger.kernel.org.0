Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4D865A7617
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 07:59:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbiHaF72 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 01:59:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbiHaF71 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 01:59:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99D75BB913
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 22:59:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661925564;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IxcjaUqp+5ClMxUcwECOmWU+q5iSWtAQsNsREE6Alcs=;
        b=Pbg2527dQDZXzGeeSryIAaav0unytEWZyLYX3XBHfkn7GZL9vnm5D+DoUj61aE8kbwVpfb
        uBQvNFVwb7A8rwW/hkhIr3Yf3bDnplQHYJZ7eZaGX00PSg5m2XAFvq7QFDxgoJ4cIx9Vr9
        xDVkPk53kh1qX5iy2ZYrkUCOFt3Tbzg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-449-DxuGihFiMdK9HhGh_43AcA-1; Wed, 31 Aug 2022 01:59:21 -0400
X-MC-Unique: DxuGihFiMdK9HhGh_43AcA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C8A33101A54E;
        Wed, 31 Aug 2022 05:59:20 +0000 (UTC)
Received: from starship (unknown [10.40.194.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E27CF2026D4C;
        Wed, 31 Aug 2022 05:59:17 +0000 (UTC)
Message-ID: <17e776dccf01e03bce1356beb8db0741e2a13d9a.camel@redhat.com>
Subject: Re: [PATCH 03/19] Revert "KVM: SVM: Introduce hybrid-AVIC mode"
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Li RongQing <lirongqing@baidu.com>
Date:   Wed, 31 Aug 2022 08:59:16 +0300
In-Reply-To: <20220831003506.4117148-4-seanjc@google.com>
References: <20220831003506.4117148-1-seanjc@google.com>
         <20220831003506.4117148-4-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-08-31 at 00:34 +0000, Sean Christopherson wrote:
> Remove SVM's so called "hybrid-AVIC mode" and reinstate the restriction
> where AVIC is disabled if x2APIC is enabled.  The argument that the
> "guest is not supposed to access xAPIC mmio when uses x2APIC" is flat out
> wrong.  Activating x2APIC completely disables the xAPIC MMIO region,
> there is nothing that says the guest must not access that address.
> 
> Concretely, KVM-Unit-Test's existing "apic" test fails the subtests that
> expect accesses to the APIC base region to not be emulated when x2APIC is
> enabled.
> 
> Furthermore, allowing the guest to trigger MMIO emulation in a mode where
> KVM doesn't expect such emulation to occur is all kinds of dangerous.
> 
> Tweak the restriction so that it only inhibits AVIC if x2APIC is actually
> enabled instead of inhibiting AVIC is x2APIC is exposed to the guest.
> 
> This reverts commit 0e311d33bfbef86da130674e8528cc23e6acfe16.

I don't agree with this patch.

When reviewing this code I did note that MMIO is left enabled which is kind of errata on KVM
side, and nobody objected to this.

Keeping AVIC enabled allows to have performance benefits with guests that have to use x2apic
(e.g after migration, or OS requirements) - aside from emulated msr access they get all the
AVIC benefits like doorbell, IOMMU posted interrupts, etc.

What we should do, and I even suggested doing it 
(and what I somewhat assumed that you will ask when the patch was in review),
is to disable the AVIC mmio hole when one of the guest vCPUs is in x2apic mode
which can be done by disabling our APIC private memslot.

Best regards,
	Maxim Levitsky

> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  6 ++++++
>  arch/x86/kvm/svm/avic.c         | 21 ++++++++++-----------
>  2 files changed, 16 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 2c96c43c313a..1f51411f3112 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1128,6 +1128,12 @@ enum kvm_apicv_inhibit {
>  	 */
>  	APICV_INHIBIT_REASON_PIT_REINJ,
>  
> +	/*
> +	 * AVIC is inhibited because the vCPU has x2apic enabled and x2AVIC is
> +	 * not supported.
> +	 */
> +	APICV_INHIBIT_REASON_X2APIC,
> +
>  	/*
>  	 * AVIC is disabled because SEV doesn't support it.
>  	 */
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index f3a74c8284cb..1d516d658f9a 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -71,22 +71,12 @@ static void avic_activate_vmcb(struct vcpu_svm *svm)
>  	vmcb->control.avic_physical_id &= ~AVIC_PHYSICAL_MAX_INDEX_MASK;
>  
>  	vmcb->control.int_ctl |= AVIC_ENABLE_MASK;
> -
> -	/* Note:
> -	 * KVM can support hybrid-AVIC mode, where KVM emulates x2APIC
> -	 * MSR accesses, while interrupt injection to a running vCPU
> -	 * can be achieved using AVIC doorbell. The AVIC hardware still
> -	 * accelerate MMIO accesses, but this does not cause any harm
> -	 * as the guest is not supposed to access xAPIC mmio when uses x2APIC.
> -	 */
> -	if (apic_x2apic_mode(svm->vcpu.arch.apic) &&
> -	    avic_mode == AVIC_MODE_X2) {
> +	if (apic_x2apic_mode(svm->vcpu.arch.apic)) {
>  		vmcb->control.int_ctl |= X2APIC_MODE_MASK;
>  		vmcb->control.avic_physical_id |= X2AVIC_MAX_PHYSICAL_ID;
>  		/* Disabling MSR intercept for x2APIC registers */
>  		svm_set_x2apic_msr_interception(svm, false);
>  	} else {
> -		/* For xAVIC and hybrid-xAVIC modes */
>  		vmcb->control.avic_physical_id |= AVIC_MAX_PHYSICAL_ID;
>  		/* Enabling MSR intercept for x2APIC registers */
>  		svm_set_x2apic_msr_interception(svm, true);
> @@ -537,6 +527,14 @@ unsigned long avic_vcpu_get_apicv_inhibit_reasons(struct kvm_vcpu *vcpu)
>  {
>  	if (is_guest_mode(vcpu))
>  		return APICV_INHIBIT_REASON_NESTED;
> +
> +	/*
> +	 * AVIC must be disabled if x2AVIC isn't supported and the guest has
> +	 * x2APIC enabled.
> +	 */
> +	if (avic_mode != AVIC_MODE_X2 && apic_x2apic_mode(vcpu->arch.apic))
> +		return APICV_INHIBIT_REASON_X2APIC;
> +
>  	return 0;
>  }
>  
> @@ -993,6 +991,7 @@ bool avic_check_apicv_inhibit_reasons(enum kvm_apicv_inhibit reason)
>  			  BIT(APICV_INHIBIT_REASON_NESTED) |
>  			  BIT(APICV_INHIBIT_REASON_IRQWIN) |
>  			  BIT(APICV_INHIBIT_REASON_PIT_REINJ) |
> +			  BIT(APICV_INHIBIT_REASON_X2APIC) |
>  			  BIT(APICV_INHIBIT_REASON_BLOCKIRQ) |
>  			  BIT(APICV_INHIBIT_REASON_SEV)      |
>  			  BIT(APICV_INHIBIT_REASON_APIC_ID_MODIFIED) |


