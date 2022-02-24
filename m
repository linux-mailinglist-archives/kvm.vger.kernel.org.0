Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23FFC4C33D1
	for <lists+kvm@lfdr.de>; Thu, 24 Feb 2022 18:36:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232112AbiBXRgH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Feb 2022 12:36:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232101AbiBXRgF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Feb 2022 12:36:05 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5833424FB91
        for <kvm@vger.kernel.org>; Thu, 24 Feb 2022 09:35:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645724134;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=x/F7srBitu8PN7/5u6mz9NTWf2eVU1iBa3r9aEXu5DI=;
        b=TCPKffmCSG49yrdyoFsU/nTiQ/SJwfZfhr54McX3yvIBzJsYXkQayv4id5Dh36+43Xy9KY
        HvBgzUuwZRizQ2o8tK/MAXX6RgT0KyEgIrfEnGKVWwEWQwdU2ESDy/HbTFmxSAKmalxr8y
        DidelGXJW3a328D4Vgvl9+77+SZYQOM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-103-paPT5z4rN5CZrv3pOdX5hQ-1; Thu, 24 Feb 2022 12:35:31 -0500
X-MC-Unique: paPT5z4rN5CZrv3pOdX5hQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BA77C51D5;
        Thu, 24 Feb 2022 17:35:29 +0000 (UTC)
Received: from starship (unknown [10.40.195.190])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 45806832B3;
        Thu, 24 Feb 2022 17:35:27 +0000 (UTC)
Message-ID: <977ff8b8801a99aaaaa15c9f2f0ffa2e360984a9.camel@redhat.com>
Subject: Re: [RFC PATCH 07/13] KVM: SVM: Update avic_kick_target_vcpus to
 support 32-bit APIC ID
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, joro@8bytes.org,
        jon.grimm@amd.com, wei.huang2@amd.com, terry.bowman@amd.com
Date:   Thu, 24 Feb 2022 19:35:26 +0200
In-Reply-To: <20220221021922.733373-8-suravee.suthikulpanit@amd.com>
References: <20220221021922.733373-1-suravee.suthikulpanit@amd.com>
         <20220221021922.733373-8-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 2022-02-20 at 20:19 -0600, Suravee Suthikulpanit wrote:
> In x2APIC mode, ICRH contains 32-bit destination APIC ID.
> So, update the avic_kick_target_vcpus() accordingly.
> 
> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> ---
>  arch/x86/kvm/svm/avic.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index 60f30e48d816..215d8a7dbc1d 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -307,10 +307,16 @@ void avic_ring_doorbell(struct kvm_vcpu *vcpu)
>  }
>  
>  static void avic_kick_target_vcpus(struct kvm *kvm, struct kvm_lapic *source,
> -				   u32 icrl, u32 icrh)
> +				   u32 icrl, u32 icrh, bool x2apic_enabled)
>  {
>  	struct kvm_vcpu *vcpu;
>  	unsigned long i;
> +	u32 dest;
> +
> +	if (x2apic_enabled)
> +		dest = icrh;
> +	else
> +		dest = GET_APIC_DEST_FIELD(icrh);


Just use 'apic_x2apic_mode(apic)', no need for x2apic_enabled parameter
as I said in patch 6.

Also maybe rename GET_APIC_DEST_FIELD to GET_XAPIC_DEST_FIELD or something as it is
wrong for x2apic.

Best regards,
	Maxim Levitsky

>  
>  	/*
>  	 * Wake any target vCPUs that are blocking, i.e. waiting for a wake
> @@ -320,8 +326,7 @@ static void avic_kick_target_vcpus(struct kvm *kvm, struct kvm_lapic *source,
>  	 */
>  	kvm_for_each_vcpu(i, vcpu, kvm) {
>  		if (kvm_apic_match_dest(vcpu, source, icrl & APIC_SHORT_MASK,
> -					GET_APIC_DEST_FIELD(icrh),
> -					icrl & APIC_DEST_MASK)) {
> +					dest, icrl & APIC_DEST_MASK)) {
>  			vcpu->arch.apic->irr_pending = true;
>  			svm_complete_interrupt_delivery(vcpu,
>  							icrl & APIC_MODE_MASK,
> @@ -364,7 +369,7 @@ int avic_incomplete_ipi_interception(struct kvm_vcpu *vcpu)
>  		 * set the appropriate IRR bits on the valid target
>  		 * vcpus. So, we just need to kick the appropriate vcpu.
>  		 */
> -		avic_kick_target_vcpus(vcpu->kvm, apic, icrl, icrh);
> +		avic_kick_target_vcpus(vcpu->kvm, apic, icrl, icrh, svm->x2apic_enabled);
>  		break;
>  	case AVIC_IPI_FAILURE_INVALID_TARGET:
>  		break;


