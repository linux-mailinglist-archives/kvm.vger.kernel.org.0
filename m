Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C5165687C1
	for <lists+kvm@lfdr.de>; Wed,  6 Jul 2022 14:05:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233471AbiGFMFo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jul 2022 08:05:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233465AbiGFMFj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jul 2022 08:05:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 86E9F2A25D
        for <kvm@vger.kernel.org>; Wed,  6 Jul 2022 05:05:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657109124;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e+UeVNoDDIWPJg4xB4qyPAufcsuGQ6KT0GwIgobfcyw=;
        b=gg0o3yX5qTM3STWLCtWwpwNPSFrx2dg50ZbGu4vx6yerlNrP254Njg8qu3ywSVh9pwXfm0
        WN/9Eu16saDhM4BzyImSKthBoJlhYZXfndBwOw4bA3nnkTH9nt4tK25yZtOijRJ20IvrGk
        lF2ZXziEHBj/X7H/eIhIZDq89i656VU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-609-6Zz0fdp-MveGMh3UjMHMVQ-1; Wed, 06 Jul 2022 08:05:21 -0400
X-MC-Unique: 6Zz0fdp-MveGMh3UjMHMVQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AFB7C299E76E;
        Wed,  6 Jul 2022 12:05:20 +0000 (UTC)
Received: from starship (unknown [10.40.194.38])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5EBDB2EF97;
        Wed,  6 Jul 2022 12:05:18 +0000 (UTC)
Message-ID: <c046a4d0d97f1f15dcdcdba1790f7c31edde2c72.camel@redhat.com>
Subject: Re: [PATCH v2 16/21] KVM: x86: Evaluate ability to inject
 SMI/NMI/IRQ after potential VM-Exit
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Date:   Wed, 06 Jul 2022 15:05:17 +0300
In-Reply-To: <20220614204730.3359543-17-seanjc@google.com>
References: <20220614204730.3359543-1-seanjc@google.com>
         <20220614204730.3359543-17-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-06-14 at 20:47 +0000, Sean Christopherson wrote:
> Determine whether or not new events can be injected after checking nested
> events.  If a VM-Exit occurred during nested event handling, any previous
> event that needed re-injection is gone from's KVM perspective; the event
> is captured in the vmc*12 VM-Exit information, but doesn't exist in terms
> of what needs to be done for entry to L1.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/x86.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 930de833aa2b..1a301a1730a5 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9502,7 +9502,7 @@ static void kvm_inject_exception(struct kvm_vcpu *vcpu)
>  
>  static int inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit)
>  {
> -	bool can_inject = !kvm_event_needs_reinjection(vcpu);
> +	bool can_inject;
>  	int r;
>  
>  	/*
> @@ -9567,7 +9567,13 @@ static int inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit)
>  	if (r < 0)
>  		goto out;
>  
> -	/* try to inject new event if pending */
> +	/*
> +	 * New events, other than exceptions, cannot be injected if KVM needs
> +	 * to re-inject a previous event.  See above comments on re-injecting
> +	 * for why pending exceptions get priority.
> +	 */
> +	can_inject = !kvm_event_needs_reinjection(vcpu);
> +
>  	if (vcpu->arch.exception.pending) {
>  		/*
>  		 * Fault-class exceptions, except #DBs, set RF=1 in the RFLAGS

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

