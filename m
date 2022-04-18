Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CE30504F46
	for <lists+kvm@lfdr.de>; Mon, 18 Apr 2022 13:09:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbiDRLMB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Apr 2022 07:12:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiDRLMA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Apr 2022 07:12:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 41E181A072
        for <kvm@vger.kernel.org>; Mon, 18 Apr 2022 04:09:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650280159;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gQ5I1K+ZmaJUXOQE28CgU+0HLTQ8wWEKYgkOaeYQd00=;
        b=jMXa//wCpNt7HjAOtT77f2w5qsvnZQ6aioG31V1n85pbqVbO6tF5EI9+ETt6rUoXJueZB0
        33v6vbYiZyt8rWtW9peJfOJxTQQGUZr2SYhH0i1yERSqm6+En1IIJP8CZmlYwXMWkM/Vrs
        SzS0Xkp/KQb91OMbUgWr42xBE5bDG04=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-639-a6NjJP4lNR-26d2T0ycYVA-1; Mon, 18 Apr 2022 07:09:16 -0400
X-MC-Unique: a6NjJP4lNR-26d2T0ycYVA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A425F80159B;
        Mon, 18 Apr 2022 11:09:15 +0000 (UTC)
Received: from starship (unknown [10.40.194.231])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8AE2AC5097F;
        Mon, 18 Apr 2022 11:09:13 +0000 (UTC)
Message-ID: <26b02f98e88b1097ce5823007a7bc06b25678252.camel@redhat.com>
Subject: Re: [PATCH v2 06/12] KVM: SVM: Do not support updating APIC ID when
 in x2APIC mode
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, joro@8bytes.org,
        jon.grimm@amd.com, wei.huang2@amd.com, terry.bowman@amd.com
Date:   Mon, 18 Apr 2022 14:09:12 +0300
In-Reply-To: <20220412115822.14351-7-suravee.suthikulpanit@amd.com>
References: <20220412115822.14351-1-suravee.suthikulpanit@amd.com>
         <20220412115822.14351-7-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-04-12 at 06:58 -0500, Suravee Suthikulpanit wrote:
> In X2APIC mode, the Logical Destination Register is read-only,
> which provides a fixed mapping between the logical and physical
> APIC IDs. Therefore, there is no Logical APIC ID table in X2AVIC
> and the processor uses the X2APIC ID in the backing page to create
> a vCPU’s logical ID.
> 
> In addition, KVM does not support updating APIC ID in x2APIC mode,
> which means AVIC does not need to handle this case.
> 
> Therefore, check x2APIC mode when handling physical and logical
> APIC ID update, and when invalidating logical APIC ID table.
> 
> Suggested-by: Maxim Levitsky <mlevitsk@redhat.com>
> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> ---
>  arch/x86/kvm/svm/avic.c | 19 ++++++++++++++++++-
>  1 file changed, 18 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index 609dcbe52a86..22ee1098e2a5 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -424,8 +424,13 @@ static void avic_invalidate_logical_id_entry(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  	bool flat = svm->dfr_reg == APIC_DFR_FLAT;
> -	u32 *entry = avic_get_logical_id_entry(vcpu, svm->ldr_reg, flat);
> +	u32 *entry;
>  
> +	/* Note: x2AVIC does not use logical APIC ID table */
> +	if (apic_x2apic_mode(vcpu->arch.apic))
> +		return;
> +
> +	entry = avic_get_logical_id_entry(vcpu, svm->ldr_reg, flat);
>  	if (entry)
>  		clear_bit(AVIC_LOGICAL_ID_ENTRY_VALID_BIT, (unsigned long *)entry);
>  }
> @@ -437,6 +442,10 @@ static int avic_handle_ldr_update(struct kvm_vcpu *vcpu)
>  	u32 ldr = kvm_lapic_get_reg(vcpu->arch.apic, APIC_LDR);
>  	u32 id = kvm_xapic_id(vcpu->arch.apic);
>  
> +	/* AVIC does not support LDR update for x2APIC */
> +	if (apic_x2apic_mode(vcpu->arch.apic))
> +		return 0;
> +
>  	if (ldr == svm->ldr_reg)
>  		return 0;
>  
> @@ -457,6 +466,14 @@ static int avic_handle_apic_id_update(struct kvm_vcpu *vcpu)
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  	u32 id = kvm_xapic_id(vcpu->arch.apic);
>  
> +	/*
> +	 * KVM does not support apic ID update for x2APIC.
> +	 * Also, need to check if the APIC ID exceed 254.
> +	 */
> +	if (apic_x2apic_mode(vcpu->arch.apic) ||
> +	    (vcpu->vcpu_id >= APIC_BROADCAST))
> +		return 0;
> +
>  	if (vcpu->vcpu_id == id)
>  		return 0;
>  

Honestly I won't even bother with this - avic_handle_apic_id_update
zeros the initial apic id entry, after it moves it contents to new location.

If it is called again (and it will be called next time there is avic inhibition),
it will just fail as the initial entry will be zero, or copy wrong entry
if something else was written there meanwhile.

That code just needs to be removed, and AVIC be conditional on read-only apic id.

But overall this patch doesn't make things worse, so

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

