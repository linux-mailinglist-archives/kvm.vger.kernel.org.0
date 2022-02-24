Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AAA54C3617
	for <lists+kvm@lfdr.de>; Thu, 24 Feb 2022 20:46:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233995AbiBXTrH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Feb 2022 14:47:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233076AbiBXTrG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Feb 2022 14:47:06 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6EF2923BD7
        for <kvm@vger.kernel.org>; Thu, 24 Feb 2022 11:46:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645731994;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8kWJStgI26fJzHahRd8G5nMqVgDcx3iTiiJFmPiN1rg=;
        b=AcrHOigRDmgbc2QN4djY2343PX+yGbXpOI082eq+RnkzWIL11E4z5Ng8Pv3+wpB7i4SVZ1
        87Pwrp5EMzxlaHS77KFcGV98V53o74/TPLQkK5+3RybNIahQibEEyRw/LPwmlYuIdRDe40
        8rHtqpGopkBYvfL5FQue6gQaYidUzqM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-601-tfovFoayPWWggN-T_l88EA-1; Thu, 24 Feb 2022 14:46:30 -0500
X-MC-Unique: tfovFoayPWWggN-T_l88EA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0E98C1091DA0;
        Thu, 24 Feb 2022 19:46:29 +0000 (UTC)
Received: from starship (unknown [10.40.195.190])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 562A619711;
        Thu, 24 Feb 2022 19:46:23 +0000 (UTC)
Message-ID: <59208dd7a83e1369851a2d0c2fe08e3e7639fa59.camel@redhat.com>
Subject: Re: [RFC PATCH 09/13] KVM: SVM: Introduce helper function
 avic_get_apic_id
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, joro@8bytes.org,
        jon.grimm@amd.com, wei.huang2@amd.com, terry.bowman@amd.com
Date:   Thu, 24 Feb 2022 21:46:22 +0200
In-Reply-To: <20220221021922.733373-10-suravee.suthikulpanit@amd.com>
References: <20220221021922.733373-1-suravee.suthikulpanit@amd.com>
         <20220221021922.733373-10-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
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
> This function returns the currently programmed guest physical
> APIC ID of a vCPU in both xAPIC and x2APIC modes.
> In case of invalid APIC ID based on the current mode,
> the function returns X2APIC_BROADCAST.
> 
> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> ---
>  arch/x86/kvm/svm/avic.c | 29 ++++++++++++++++++++++++++---
>  1 file changed, 26 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index 55b3b703b93b..3543b7a4514a 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -450,16 +450,35 @@ static void avic_invalidate_logical_id_entry(struct kvm_vcpu *vcpu)
>  		clear_bit(AVIC_LOGICAL_ID_ENTRY_VALID_BIT, (unsigned long *)entry);
>  }
>  
> +static inline u32 avic_get_apic_id(struct kvm_vcpu *vcpu)
> +{
> +	u32 apic_id = kvm_lapic_get_reg(vcpu->arch.apic, APIC_ID);
> +
> +	if (!apic_x2apic_mode(vcpu->arch.apic)) {
> +		/*
> +		 * In case of xAPIC, we do not support
> +		 * APIC ID larger than 254.
> +		 */
> +		if (vcpu->vcpu_id >= APIC_BROADCAST)
> +			return X2APIC_BROADCAST;
This is not a good way to return a error value like that IMHO.

> +		return apic_id >> 24;
> +	} else
> +		return apic_id;
> +}

I don't fully like this to be honest - this should be at least function in lapic.c
and use kvm_xapic_id and kvm_x2apic_id.

And hopefully if I manage to make apic id always read only then we be able
to never use APIC_ID register and always use vcpu->vcpu_id.

Best regards,
	Maxim Levitsky

> +
>  static int avic_handle_ldr_update(struct kvm_vcpu *vcpu)
>  {
>  	int ret = 0;
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  	u32 ldr = kvm_lapic_get_reg(vcpu->arch.apic, APIC_LDR);
> -	u32 id = kvm_xapic_id(vcpu->arch.apic);
> +	u32 id = avic_get_apic_id(vcpu);
>  
>  	if (ldr == svm->ldr_reg)
>  		return 0;
>  
> +	if (id == X2APIC_BROADCAST)
> +		return -EINVAL;
> +
This is what I mean. It is better to check here that we 
vcpu->vcpu_id >= APIC_BROADCAST and fail.



>  	avic_invalidate_logical_id_entry(vcpu);
>  
>  	if (ldr)
> @@ -475,7 +494,10 @@ static int avic_handle_apic_id_update(struct kvm_vcpu *vcpu)
>  {
>  	u64 *old, *new;
>  	struct vcpu_svm *svm = to_svm(vcpu);
> -	u32 id = kvm_xapic_id(vcpu->arch.apic);
> +	u32 id = avic_get_apic_id(vcpu);
> +
> +	if (id == X2APIC_BROADCAST)
> +		return 1;

Same here.
>  
>  	if (vcpu->vcpu_id == id)
>  		return 0;
> @@ -497,7 +519,8 @@ static int avic_handle_apic_id_update(struct kvm_vcpu *vcpu)
>  	 * APIC ID table entry if already setup the LDR.
>  	 */
>  	if (svm->ldr_reg)
> -		avic_handle_ldr_update(vcpu);
> +		if (avic_handle_ldr_update(vcpu))
> +			return 1;
>  
>  	return 0;


Best regards,
	Maxim Levitsky

>  }


