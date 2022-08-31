Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD7B85A79F5
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 11:18:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231745AbiHaJSx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 05:18:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231805AbiHaJSr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 05:18:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A971CAC52
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 02:18:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661937510;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9cQt3pxF6Qh1j2XuZ2tK/O7qOpRt4e1IiA4w4g1N6yI=;
        b=iLt+JcyYmtpTt4n8yDFo8cAs9pNk+57F0xl4mHyyqEf5vy/Ue7IPcEt1N6qp0/iD665TSw
        FM/nrhqwCrG79CnbRzYwWwUHxj4uoKsrzIRSAMJs5daxQi1euFNtReqXg8VstnufOH19FA
        LfKAIKImVZYHOR/PWpdapKbD9Hs5fbU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-170-rICtwDEzOyaMTGug4y3oEA-1; Wed, 31 Aug 2022 05:18:26 -0400
X-MC-Unique: rICtwDEzOyaMTGug4y3oEA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 69383101A54E;
        Wed, 31 Aug 2022 09:18:26 +0000 (UTC)
Received: from starship (unknown [10.40.194.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8CBA1492C3B;
        Wed, 31 Aug 2022 09:18:24 +0000 (UTC)
Message-ID: <50d7443ffc97931a6a0ab37f11b71b9618923daf.camel@redhat.com>
Subject: Re: [PATCH 01/19] KVM: SVM: Process ICR on AVIC IPI delivery
 failure due to invalid target
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Li RongQing <lirongqing@baidu.com>
Date:   Wed, 31 Aug 2022 12:18:23 +0300
In-Reply-To: <20220831003506.4117148-2-seanjc@google.com>
References: <20220831003506.4117148-1-seanjc@google.com>
         <20220831003506.4117148-2-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-08-31 at 00:34 +0000, Sean Christopherson wrote:
> Emulate ICR writes on AVIC IPI failures due to invalid targets using the
> same logic as failures due to invalid types.  AVIC acceleration fails if
> _any_ of the targets are invalid
> , and crucially VM-Exits before sending
> IPIs to targets that _are_ valid.  In logical mode, the destination is a
> bitmap, i.e. a single IPI can target multiple logical IDs.  Doing nothing
> causes KVM to drop IPIs if at least one target is valid and at least one
> target is invalid.


This is a corner case, but it does makes sense to fix it.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

> 
> Fixes: 18f40c53e10f ("svm: Add VMEXIT handlers for AVIC")
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/svm/avic.c | 16 +++++++++-------
>  1 file changed, 9 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index 6919dee69f18..b1ade555e8d0 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -496,14 +496,18 @@ int avic_incomplete_ipi_interception(struct kvm_vcpu *vcpu)
>  	trace_kvm_avic_incomplete_ipi(vcpu->vcpu_id, icrh, icrl, id, index);
>  
>  	switch (id) {
> +	case AVIC_IPI_FAILURE_INVALID_TARGET:
>  	case AVIC_IPI_FAILURE_INVALID_INT_TYPE:
>  		/*
>  		 * Emulate IPIs that are not handled by AVIC hardware, which
> -		 * only virtualizes Fixed, Edge-Triggered INTRs.  The exit is
> -		 * a trap, e.g. ICR holds the correct value and RIP has been
> -		 * advanced, KVM is responsible only for emulating the IPI.
> -		 * Sadly, hardware may sometimes leave the BUSY flag set, in
> -		 * which case KVM needs to emulate the ICR write as well in
> +		 * only virtualizes Fixed, Edge-Triggered INTRs, and falls over
> +		 * if _any_ targets are invalid, e.g. if the logical mode mask
> +		 * is a superset of running vCPUs.
> +		 *
> +		 * The exit is a trap, e.g. ICR holds the correct value and RIP
> +		 * has been advanced, KVM is responsible only for emulating the
> +		 * IPI.  Sadly, hardware may sometimes leave the BUSY flag set,
> +		 * in which case KVM needs to emulate the ICR write as well in
>  		 * order to clear the BUSY flag.
>  		 */
>  		if (icrl & APIC_ICR_BUSY)
> @@ -519,8 +523,6 @@ int avic_incomplete_ipi_interception(struct kvm_vcpu *vcpu)
>  		 */
>  		avic_kick_target_vcpus(vcpu->kvm, apic, icrl, icrh, index);
>  		break;
> -	case AVIC_IPI_FAILURE_INVALID_TARGET:
> -		break;
>  	case AVIC_IPI_FAILURE_INVALID_BACKING_PAGE:
>  		WARN_ONCE(1, "Invalid backing page\n");
>  		break;


