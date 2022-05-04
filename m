Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65173519F1E
	for <lists+kvm@lfdr.de>; Wed,  4 May 2022 14:19:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349388AbiEDMXT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 08:23:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349381AbiEDMXO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 08:23:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 26C862FFC7
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 05:19:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651666778;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uBV16vnuxP6wnKOyV7561KKUA2Dkfw/RJaBGuQ2QULQ=;
        b=aruEMM00G9I9sFXSKZyfmEzKjiJyWr+h0BclTH0TzJkY9GxkWmOiC5qQTNkpXU34GM7Efv
        pBO8ko9odUO59NOPratCLzoEc3aKnvyR3qT4zRiHn3jbkI5+VAXBcql1GCAXGqJgIsk9Js
        Xz2swpOd29dLWmHtPnbfU7aaRPc0xgU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-636-GVT-Xq4iM0OAkxtHXuQB2A-1; Wed, 04 May 2022 08:19:34 -0400
X-MC-Unique: GVT-Xq4iM0OAkxtHXuQB2A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CF6D81014A63;
        Wed,  4 May 2022 12:19:33 +0000 (UTC)
Received: from starship (unknown [10.40.192.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9B6EC2026614;
        Wed,  4 May 2022 12:19:31 +0000 (UTC)
Message-ID: <ff67344c0efe06d1422aa84e56738a0812c69bfc.camel@redhat.com>
Subject: Re: [PATCH v3 08/14] KVM: SVM: Update AVIC settings when changing
 APIC mode
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, joro@8bytes.org,
        jon.grimm@amd.com, wei.huang2@amd.com, terry.bowman@amd.com
Date:   Wed, 04 May 2022 15:19:30 +0300
In-Reply-To: <20220504073128.12031-9-suravee.suthikulpanit@amd.com>
References: <20220504073128.12031-1-suravee.suthikulpanit@amd.com>
         <20220504073128.12031-9-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
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
> Update and refresh AVIC settings when guest APIC mode is updated
> (e.g. changing between disabled, xAPIC, or x2APIC).
> 
> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> ---
>  arch/x86/kvm/svm/avic.c | 16 ++++++++++++++++
>  arch/x86/kvm/svm/svm.c  |  1 +
>  2 files changed, 17 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index 3ebeea19b487..d185dd8ddf17 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -691,6 +691,22 @@ void avic_apicv_post_state_restore(struct kvm_vcpu *vcpu)
>  	avic_handle_ldr_update(vcpu);
>  }
>  
> +void avic_set_virtual_apic_mode(struct kvm_vcpu *vcpu)
> +{
> +	struct vcpu_svm *svm = to_svm(vcpu);
> +
> +	if (!lapic_in_kernel(vcpu) || (avic_mode == AVIC_MODE_NONE))
> +		return;
> +
> +	if (kvm_get_apic_mode(vcpu) == LAPIC_MODE_INVALID) {
> +		WARN_ONCE(true, "Invalid local APIC state (vcpu_id=%d)", vcpu->vcpu_id);
> +		return;
> +	}
> +
> +	kvm_vcpu_update_apicv(&svm->vcpu);

Why to have this call? I think that all that is needed is only to call the
avic_refresh_apicv_exec_ctrl.

Best regards,
	Maxim Levitsky


> +	avic_refresh_apicv_exec_ctrl(&svm->vcpu);
> +}
> +
>  static int avic_set_pi_irte_mode(struct kvm_vcpu *vcpu, bool activate)
>  {
>  	int ret = 0;
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 314628b6bff4..9066568fd19d 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4692,6 +4692,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
>  	.enable_nmi_window = svm_enable_nmi_window,
>  	.enable_irq_window = svm_enable_irq_window,
>  	.update_cr8_intercept = svm_update_cr8_intercept,
> +	.set_virtual_apic_mode = avic_set_virtual_apic_mode,
>  	.refresh_apicv_exec_ctrl = avic_refresh_apicv_exec_ctrl,
>  	.check_apicv_inhibit_reasons = avic_check_apicv_inhibit_reasons,
>  	.apicv_post_state_restore = avic_apicv_post_state_restore,


