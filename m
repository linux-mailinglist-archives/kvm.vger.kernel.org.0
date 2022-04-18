Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 648605055FF
	for <lists+kvm@lfdr.de>; Mon, 18 Apr 2022 15:29:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241697AbiDRNbd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Apr 2022 09:31:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244833AbiDRNa5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Apr 2022 09:30:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4ACEB1EC50
        for <kvm@vger.kernel.org>; Mon, 18 Apr 2022 05:55:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650286541;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qFJ3DlKb+eUPu+S4bA6qaKNO41i7hF7RhsehUeP4a78=;
        b=CiS/5yCWSHLu1WZRmQgbP0geShkAJ7ACi1icWDoonTQ+hUl7b/MH6SJqKRBDRSottghp4b
        Wkd9P/zZAZ5xm79nHEjMWNKoGCAU2HvZv3xcV3ABnz4LhhGkS5S3YXGL7lFb29WreJgSE9
        8NxqvucOWDGQXvqB8ZFUvy3f5j4WyfQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-655-ZAkUvhHMMkGL2Y6gwUNtQQ-1; Mon, 18 Apr 2022 08:55:38 -0400
X-MC-Unique: ZAkUvhHMMkGL2Y6gwUNtQQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C309438149A3;
        Mon, 18 Apr 2022 12:55:37 +0000 (UTC)
Received: from starship (unknown [10.40.194.231])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A995340FD371;
        Mon, 18 Apr 2022 12:55:35 +0000 (UTC)
Message-ID: <dff229a39e30f84dcf8cc8caffc41f83bd5ece73.camel@redhat.com>
Subject: Re: [PATCH v2 12/12] kvm/x86: Remove APICV activate mode
 inconsistency check
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, joro@8bytes.org,
        jon.grimm@amd.com, wei.huang2@amd.com, terry.bowman@amd.com
Date:   Mon, 18 Apr 2022 15:55:34 +0300
In-Reply-To: <20220412115822.14351-13-suravee.suthikulpanit@amd.com>
References: <20220412115822.14351-1-suravee.suthikulpanit@amd.com>
         <20220412115822.14351-13-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
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
> When launching a VM with x2APIC and specify more than 255 vCPUs,
> the guest kernel can disable x2APIC (e.g. specify nox2apic kernel option).
> The VM fallbacks to xAPIC mode, and disable the vCPU ID 255.
> 
> In this case, APICV should be disabled for the vCPU ID 255.
> Therefore, the APICV mode consisency check is no longer valid.
> 
> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> ---
>  arch/x86/kvm/x86.c | 13 +++++--------
>  1 file changed, 5 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 0c0ca599a353..d0fac57e9996 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9765,6 +9765,11 @@ void kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
>  	down_read(&vcpu->kvm->arch.apicv_update_lock);
>  
>  	activate = kvm_apicv_activated(vcpu->kvm);
> +
> +	/* Do not activate AVIC when APIC is disabled */
> +	if (kvm_get_apic_mode(vcpu) == LAPIC_MODE_DISABLED)
> +		activate = false;
> +
>  	if (vcpu->arch.apicv_active == activate)
>  		goto out;
>  
> @@ -10159,14 +10164,6 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  	guest_timing_enter_irqoff();
>  
>  	for (;;) {
> -		/*
> -		 * Assert that vCPU vs. VM APICv state is consistent.  An APICv
> -		 * update must kick and wait for all vCPUs before toggling the
> -		 * per-VM state, and responsing vCPUs must wait for the update
> -		 * to complete before servicing KVM_REQ_APICV_UPDATE.
> -		 */
> -		WARN_ON_ONCE(kvm_apicv_activated(vcpu->kvm) != kvm_vcpu_apicv_active(vcpu));
> -
>  		exit_fastpath = static_call(kvm_x86_vcpu_run)(vcpu);
>  		if (likely(exit_fastpath != EXIT_FASTPATH_REENTER_GUEST))
>  			break;

That warning catches bugs, please don't remove it.

It can be made conditional on this vCPU having APIC enabled instead.

Best regards,
	Maxim Levitsky

