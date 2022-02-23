Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E8594C151B
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 15:07:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241390AbiBWOII (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 09:08:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241416AbiBWOHy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 09:07:54 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 548A412629
        for <kvm@vger.kernel.org>; Wed, 23 Feb 2022 06:07:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645625245;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4k1PzZK1Kax3nbhknai2MMEy80MJCvgpY9X9cvLB3sE=;
        b=fmr681ha/kryzQNBuo0B79W7EwdKBatSiBkqdecIo7ySphvWLggo+0o+2dTD0Odk1khpSa
        t5vRk2gc8dX2d/Y3uN7PCoA8eVhA/3YcrXaQio/vTw9L55NcTPj9z6OMK3wm0A7jrRkhyp
        4oSzG/sCRpTTR5Wwu6unhVU1WOc4xXQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-517-APKG05gpPSSfCuA75QqXiw-1; Wed, 23 Feb 2022 09:07:22 -0500
X-MC-Unique: APKG05gpPSSfCuA75QqXiw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 307311091DA4;
        Wed, 23 Feb 2022 14:07:21 +0000 (UTC)
Received: from starship (unknown [10.40.195.190])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CBE387DE37;
        Wed, 23 Feb 2022 14:07:19 +0000 (UTC)
Message-ID: <7d0787b44a484941964c2e5d4e85c1a60c73602c.camel@redhat.com>
Subject: Re: [PATCH v2 02/18] KVM: x86: do not deliver asynchronous page
 faults if CR0.PG=0
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     seanjc@google.com
Date:   Wed, 23 Feb 2022 16:07:18 +0200
In-Reply-To: <20220217210340.312449-3-pbonzini@redhat.com>
References: <20220217210340.312449-1-pbonzini@redhat.com>
         <20220217210340.312449-3-pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-02-17 at 16:03 -0500, Paolo Bonzini wrote:
> Enabling async page faults is nonsensical if paging is disabled, but
> it is allowed because CR0.PG=0 does not clear the async page fault
> MSR.  Just ignore them and only use the artificial halt state,
> similar to what happens in guest mode if async #PF vmexits are disabled.

Well in theory someone could use KVM for emulating DOS programs, and
use async #PF for on demand paging. I would question sanity of author
of such hypervisor though...


The only thing I would add is to add a mention of the CR0.PG=1 restriction in 
Documentation/virt/kvm/msr.rst.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

> 
> Given the increasingly complex logic, and the nicer code if the new
> "if" is placed last, opportunistically change the "||" into a chain
> of "if (...) return false" statements.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/x86.c | 22 ++++++++++++++++++----
>  1 file changed, 18 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 99a58c25f5c2..b912eef5dc1a 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -12270,14 +12270,28 @@ static inline bool apf_pageready_slot_free(struct kvm_vcpu *vcpu)
>  
>  static bool kvm_can_deliver_async_pf(struct kvm_vcpu *vcpu)
>  {
> -	if (!vcpu->arch.apf.delivery_as_pf_vmexit && is_guest_mode(vcpu))
> +
> +	if (!kvm_pv_async_pf_enabled(vcpu))
>  		return false;
>  
> -	if (!kvm_pv_async_pf_enabled(vcpu) ||
> -	    (vcpu->arch.apf.send_user_only && static_call(kvm_x86_get_cpl)(vcpu) == 0))
> +	if (vcpu->arch.apf.send_user_only &&
> +	    static_call(kvm_x86_get_cpl)(vcpu) == 0)
>  		return false;
>  
> -	return true;
> +	if (is_guest_mode(vcpu)) {
> +		/*
> +		 * L1 needs to opt into the special #PF vmexits that are
> +		 * used to deliver async page faults.
> +		 */
> +		return vcpu->arch.apf.delivery_as_pf_vmexit;
> +	} else {
> +		/*
> +		 * Play it safe in case the guest does a quick real mode
> +		 * foray.  The real mode IDT is unlikely to have a #PF
> +		 * exception setup.
> +		 */
> +		return is_paging(vcpu);
> +	}
>  }
>  
>  bool kvm_can_do_async_pf(struct kvm_vcpu *vcpu)


