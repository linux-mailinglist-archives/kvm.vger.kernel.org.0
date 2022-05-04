Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 831E7519FA0
	for <lists+kvm@lfdr.de>; Wed,  4 May 2022 14:34:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349799AbiEDMhw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 08:37:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349778AbiEDMh2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 08:37:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A21BC3153B
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 05:33:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651667631;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KtPEDLKRL8wH1P8IKIjc8oaZj0ZhJhxzB+wJ1j/1ViU=;
        b=B/OTgHphHb0LVA0RhJkjTKGpNQ+95pwM9r6312XqfuAYJxK5TDvxTuIqZZL5gUmJ4APiv0
        UAWYLAERW+Qtnuf/sv4aDZI8ORdUUcq1QFBQincJa3o2wufM0AnrvrLD0GCoFt14vWFqSo
        BMOYP0YF0Gjwci/npeFiNRyiUenyz+8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-426-JA6x8T_5Pj2c6GW5M0_mIg-1; Wed, 04 May 2022 08:33:46 -0400
X-MC-Unique: JA6x8T_5Pj2c6GW5M0_mIg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DA2C5811E75;
        Wed,  4 May 2022 12:33:40 +0000 (UTC)
Received: from starship (unknown [10.40.192.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C2ECF40CF8F8;
        Wed,  4 May 2022 12:33:38 +0000 (UTC)
Message-ID: <36aed569ad306d10f999f001cf1b170496e3ba6f.camel@redhat.com>
Subject: Re: [PATCH v3 12/14] kvm/x86: Warning APICv inconsistency only when
 vcpu APIC mode is valid
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, joro@8bytes.org,
        jon.grimm@amd.com, wei.huang2@amd.com, terry.bowman@amd.com
Date:   Wed, 04 May 2022 15:33:37 +0300
In-Reply-To: <20220504073128.12031-13-suravee.suthikulpanit@amd.com>
References: <20220504073128.12031-1-suravee.suthikulpanit@amd.com>
         <20220504073128.12031-13-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-05-04 at 02:31 -0500, Suravee Suthikulpanit wrote:
> When launching a VM with x2APIC and specify more than 255 vCPUs,
> the guest kernel can disable x2APIC (e.g. specify nox2apic kernel option).
> The VM fallbacks to xAPIC mode, and disable the vCPU ID 255 and greater.
> 
> In this case, APICV should be deactivated for the disabled vCPUs.
> However, the current APICv consistency warning does not account for
> this case, which results in a warning.
> 
> Therefore, modify warning logic to report only when vCPU APIC mode
> is valid.
> 
> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> ---
>  arch/x86/kvm/x86.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 8ee8c91fa762..b14e02ea0ff6 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9838,6 +9838,10 @@ void kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
>  
>  	activate = kvm_vcpu_apicv_activated(vcpu);
>  
> +	/* Do not activate AVIC when APIC is disabled */
> +	if (kvm_get_apic_mode(vcpu) == LAPIC_MODE_DISABLED)
> +		activate = false;
> +
>  	if (vcpu->arch.apicv_active == activate)
>  		goto out;
>  
> @@ -10240,7 +10244,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  		 * per-VM state, and responsing vCPUs must wait for the update
>  		 * to complete before servicing KVM_REQ_APICV_UPDATE.
>  		 */
> -		WARN_ON_ONCE(kvm_vcpu_apicv_activated(vcpu) != kvm_vcpu_apicv_active(vcpu));
> +		if (kvm_vcpu_apicv_activated(vcpu) != kvm_vcpu_apicv_active(vcpu))
> +			WARN_ON_ONCE(kvm_get_apic_mode(vcpu) != LAPIC_MODE_DISABLED);
>  
>  		exit_fastpath = static_call(kvm_x86_vcpu_run)(vcpu);
>  		if (likely(exit_fastpath != EXIT_FASTPATH_REENTER_GUEST))

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

