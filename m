Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4843663DC16
	for <lists+kvm@lfdr.de>; Wed, 30 Nov 2022 18:36:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbiK3Rg3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 12:36:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbiK3Rg0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 12:36:26 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0DA53FBAA
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 09:35:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669829726;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eEzeshxptaTVoixaalRXIxJCQCpqLiinHusiDp7Xb4k=;
        b=fvkDKpFy/+dA2eNBu0d2TSfVuEl7ZdW/bk7xOyledY/VO6cAGfg/jBNN1yFBOaQJk2g3rp
        Ktzll1I4sTCUrBF0f/ZAn5ItqyTASZFTkgoebP58YE1Wo10BGI4erzUmI6geOGXAAKp8uy
        xRY2zNx5/oCiSmRuHWDnF5qVYkSGl7I=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-333-xcf41AieOXughk5dFSU2-g-1; Wed, 30 Nov 2022 12:35:24 -0500
X-MC-Unique: xcf41AieOXughk5dFSU2-g-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 00BBE811E7A;
        Wed, 30 Nov 2022 17:35:24 +0000 (UTC)
Received: from starship (unknown [10.35.206.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0C518492B04;
        Wed, 30 Nov 2022 17:35:18 +0000 (UTC)
Message-ID: <421c98ac2f863703795c8783090f645744673130.camel@redhat.com>
Subject: Re: [PATCH] KVM: x86: fix uninitialized variable use on
 KVM_REQ_TRIPLE_FAULT
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Dan Carpenter <error27@gmail.com>
Date:   Wed, 30 Nov 2022 19:35:18 +0200
In-Reply-To: <20221130161531.891135-1-pbonzini@redhat.com>
References: <20221130161531.891135-1-pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-11-30 at 11:15 -0500, Paolo Bonzini wrote:
> If a triple fault was fixed by kvm_x86_ops.nested_ops->triple_fault (by
> turning it into a vmexit), there is no need to leave vcpu_enter_guest().
> Any vcpu->requests will be caught later before the actual vmentry,
> and in fact vcpu_enter_guest() was not initializing the "r" variable.
> Depending on the compiler's whims, this could cause the
> x86_64/triple_fault_event_test test to fail.
> 
> Cc: Maxim Levitsky <mlevitsk@redhat.com>
> Fixes: 92e7d5c83aff ("KVM: x86: allow L1 to not intercept triple fault")
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/x86.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 246bdc9a9154..7f850dfb4086 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10280,8 +10280,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  				vcpu->run->exit_reason = KVM_EXIT_SHUTDOWN;
>  				vcpu->mmio_needed = 0;
>  				r = 0;
> +				goto out;
>  			}
> -			goto out;
>  		}
>  		if (kvm_check_request(KVM_REQ_APF_HALT, vcpu)) {
>  			/* Page is swapped out. Do synthetic halt */

I had the same patch waiting to be sent, so:

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>


But we need to add the orignal reporter of this bug as well:

Reported-by: Dan Carpenter <error27@gmail.com>

Best regards,
	Maxim Levitsky

