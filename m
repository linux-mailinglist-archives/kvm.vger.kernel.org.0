Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBBA0512408
	for <lists+kvm@lfdr.de>; Wed, 27 Apr 2022 22:43:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235923AbiD0UqN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Apr 2022 16:46:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbiD0UqK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Apr 2022 16:46:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 29BDA6459
        for <kvm@vger.kernel.org>; Wed, 27 Apr 2022 13:42:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651092177;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zJmjZ87fPrZOkM1Htcs8yFb8d1wAfXTp9xbOKbFh9NY=;
        b=gngKL4olwT1uYrMnlHix4sB/BWi6l2Ub+xQt68H396mLg1pa3cxq+LtiaLotIsKIaO1yGF
        8L9ggOjtJWS/5EeuTclfLZAgTxNpmRZGLPN1unlMlk+pa5hXqmkusHJI9WjRIBmAyAPm1q
        fzquhNfBzfCk5hscV5i4fN1ocQBNx44=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-586-ZUZr-R13PFObJtKRkLJUAA-1; Wed, 27 Apr 2022 16:42:54 -0400
X-MC-Unique: ZUZr-R13PFObJtKRkLJUAA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9CF20808799;
        Wed, 27 Apr 2022 20:42:53 +0000 (UTC)
Received: from starship (unknown [10.40.192.41])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5989D2024CB6;
        Wed, 27 Apr 2022 20:42:52 +0000 (UTC)
Message-ID: <6ad7ecdd82cd85adff008e5ae967516f00c3bf73.camel@redhat.com>
Subject: Re: [PATCH 3/3] KVM: x86: never write to memory from
 kvm_vcpu_check_block
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     seanjc@google.com, stable@vger.kernel.org
Date:   Wed, 27 Apr 2022 23:42:51 +0300
In-Reply-To: <20220427173758.517087-4-pbonzini@redhat.com>
References: <20220427173758.517087-1-pbonzini@redhat.com>
         <20220427173758.517087-4-pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-04-27 at 13:37 -0400, Paolo Bonzini wrote:
> kvm_vcpu_check_block is called while not in TASK_RUNNING, and therefore
> cannot sleep.  Writing to guest memory is therefore forbidden, but it
> can happen if kvm_check_nested_events causes a vmexit.
> 
> Fortunately, all events that are caught by kvm_check_nested_events are
> also handled by kvm_vcpu_has_events through vendor callbacks such as
> kvm_x86_interrupt_allowed or kvm_x86_ops.nested_ops->has_events, so
> remove the call.
> 
> Cc: stable@vger.kernel.org
> Reported-by: Maxim Levitsky <mlevitsk@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/x86.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index d563812ca229..90b4f50b9a84 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10341,9 +10341,6 @@ static inline int vcpu_block(struct kvm_vcpu *vcpu)
>  
>  static inline bool kvm_vcpu_running(struct kvm_vcpu *vcpu)
>  {
> -	if (is_guest_mode(vcpu))
> -		kvm_check_nested_events(vcpu);
> -
>  	return (vcpu->arch.mp_state == KVM_MP_STATE_RUNNABLE &&
>  		!vcpu->arch.apf.halted);
>  }

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

I tested this on AMD, and it seems to work fine, and my nested AVIC test
works as good as was before.

Note that I forgot to mention, that I had to apply most of the patches
manually, they don't apply to kvm/queue.

Best regards,
	Maxim Levitsky

