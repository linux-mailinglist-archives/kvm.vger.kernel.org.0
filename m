Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D34504E64C8
	for <lists+kvm@lfdr.de>; Thu, 24 Mar 2022 15:14:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350770AbiCXOPt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Mar 2022 10:15:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350758AbiCXOPs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Mar 2022 10:15:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9C9BB21278
        for <kvm@vger.kernel.org>; Thu, 24 Mar 2022 07:14:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648131255;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9K9Yy9yZx3tAaoGmVOKU8onhx2UuVtR4bpakSmFeAFc=;
        b=NqrbWMdkqYBMAVYUbO5uJDUFf4pnyq/yq8eugHXuktOKrxjNCLBPoiKpKzGDtwKCUalvYg
        2wKzSHiDyVxUFnqUHOVOF5RuTzcO+edVo752IhbBnh9/f2HqV31iw2ZRj2styparwv0tR0
        V+q+4s21wq2JqrscKf7JFt+ItyD+gGg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-531-1QrawlMzM56eWvE5l3QO5g-1; Thu, 24 Mar 2022 10:14:13 -0400
X-MC-Unique: 1QrawlMzM56eWvE5l3QO5g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C699D299E759;
        Thu, 24 Mar 2022 14:14:12 +0000 (UTC)
Received: from starship (unknown [10.40.194.231])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AA1992024CD0;
        Thu, 24 Mar 2022 14:14:10 +0000 (UTC)
Message-ID: <d990c42a3ab5e8b1cbfa7775eef37ad4957147f6.camel@redhat.com>
Subject: Re: [RFCv2 PATCH 07/12] KVM: SVM: Introduce helper function
 kvm_get_apic_id
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, joro@8bytes.org,
        jon.grimm@amd.com, wei.huang2@amd.com, terry.bowman@amd.com
Date:   Thu, 24 Mar 2022 16:14:09 +0200
In-Reply-To: <20220308163926.563994-8-suravee.suthikulpanit@amd.com>
References: <20220308163926.563994-1-suravee.suthikulpanit@amd.com>
         <20220308163926.563994-8-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-03-08 at 10:39 -0600, Suravee Suthikulpanit wrote:
> This function returns the currently programmed guest physical
> APIC ID of a vCPU in both xAPIC and x2APIC modes.
> 
> Suggested-by: Maxim Levitsky <mlevitsk@redhat.com>
> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> ---
>  arch/x86/kvm/lapic.c    | 23 +++++++++++++++++++++++
>  arch/x86/kvm/lapic.h    |  5 +----
>  arch/x86/kvm/svm/avic.c | 21 +++++++++++++++++----
>  3 files changed, 41 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 03d1b6325eb8..73a1e650a294 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -106,11 +106,34 @@ static inline int apic_enabled(struct kvm_lapic *apic)
>  	(LVT_MASK | APIC_MODE_MASK | APIC_INPUT_POLARITY | \
>  	 APIC_LVT_REMOTE_IRR | APIC_LVT_LEVEL_TRIGGER)
>  
> +static inline u8 kvm_xapic_id(struct kvm_lapic *apic)
> +{
> +	return kvm_lapic_get_reg(apic, APIC_ID) >> 24;
> +}
> +
>  static inline u32 kvm_x2apic_id(struct kvm_lapic *apic)
>  {
>  	return apic->vcpu->vcpu_id;
>  }
>  
> +int kvm_get_apic_id(struct kvm_vcpu *vcpu, u32 *id)
> +{
> +	if (!id)
> +		return -EINVAL;
> +
> +	if (!apic_x2apic_mode(vcpu->arch.apic)) {
> +		/* For xAPIC, APIC ID cannot be larger than 254. */
> +		if (vcpu->vcpu_id >= APIC_BROADCAST)
> +			return -EINVAL;
> +
> +		*id = kvm_xapic_id(vcpu->arch.apic);
> +	} else {
> +		*id = kvm_x2apic_id(vcpu->arch.apic);
> +	}
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(kvm_get_apic_id);
> +
>  static bool kvm_can_post_timer_interrupt(struct kvm_vcpu *vcpu)
>  {
>  	return pi_inject_timer && kvm_vcpu_apicv_active(vcpu);
> diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
> index 2b44e533fc8d..2b9463da1528 100644
> --- a/arch/x86/kvm/lapic.h
> +++ b/arch/x86/kvm/lapic.h
> @@ -254,9 +254,6 @@ static inline enum lapic_mode kvm_apic_mode(u64 apic_base)
>  	return apic_base & (MSR_IA32_APICBASE_ENABLE | X2APIC_ENABLE);
>  }
>  
> -static inline u8 kvm_xapic_id(struct kvm_lapic *apic)
> -{
> -	return kvm_lapic_get_reg(apic, APIC_ID) >> 24;
> -}
> +int kvm_get_apic_id(struct kvm_vcpu *vcpu, u32 *id);
>  
>  #endif
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index 4d7a8743196e..7e5a39a8e698 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -441,14 +441,21 @@ static void avic_invalidate_logical_id_entry(struct kvm_vcpu *vcpu)
>  
>  static int avic_handle_ldr_update(struct kvm_vcpu *vcpu)
>  {
> -	int ret = 0;
> +	int ret;
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  	u32 ldr = kvm_lapic_get_reg(vcpu->arch.apic, APIC_LDR);
> -	u32 id = kvm_xapic_id(vcpu->arch.apic);
> +	u32 id;
> +
> +	ret = kvm_get_apic_id(vcpu, &id);
> +	if (ret)
> +		return ret;
What about apic_id == 0?

>  
>  	if (ldr == svm->ldr_reg)
>  		return 0;
>  
> +	if (id == X2APIC_BROADCAST)
> +		return -EINVAL;
> +

Why this is needed? avic_handle_ldr_update is called either
when guest writes to APIC_LDR (should not reach here),
or if LDR got changed while AVIC was inhibited (also
thankfully KVM doesn't allow it to be changed in x2APIC	mode,
and it does reset it when enabling x2apic).



>  	avic_invalidate_logical_id_entry(vcpu);
>  
>  	if (ldr)
> @@ -464,7 +471,12 @@ static int avic_handle_apic_id_update(struct kvm_vcpu *vcpu)
>  {
>  	u64 *old, *new;
>  	struct vcpu_svm *svm = to_svm(vcpu);
> -	u32 id = kvm_xapic_id(vcpu->arch.apic);
> +	u32 id;
> +	int ret;
> +
> +	ret = kvm_get_apic_id(vcpu, &id);
> +	if (ret)
> +		return 1;

Well this function is totally broken anyway and I woudn't even bother touching it,
maximum, just stick 'return 0' in the very start of this function if the apic is
in x2apic mode now.

Oh well...

>  
>  	if (vcpu->vcpu_id == id)
>  		return 0;
> @@ -484,7 +496,8 @@ static int avic_handle_apic_id_update(struct kvm_vcpu *vcpu)
>  	 * APIC ID table entry if already setup the LDR.
>  	 */
>  	if (svm->ldr_reg)
> -		avic_handle_ldr_update(vcpu);
> +		if (avic_handle_ldr_update(vcpu))
> +			return 1;
>  
>  	return 0;
>  }


Best regards,
	Maxim Levitsky

