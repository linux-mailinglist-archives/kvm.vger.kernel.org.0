Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3387C56877B
	for <lists+kvm@lfdr.de>; Wed,  6 Jul 2022 13:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233344AbiGFL5w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jul 2022 07:57:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbiGFL5r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jul 2022 07:57:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 518752872D
        for <kvm@vger.kernel.org>; Wed,  6 Jul 2022 04:57:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657108665;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WAo9GYuIhcJZzsSVZdCnRCWgE9wNAJi2c7UqzRAk9fo=;
        b=jARAXnmvXzCOKX50rfWYGNaE3Iw6tlm5s94rtQrqdErkRN99ImVM4mSV5t26WjJROSpq75
        NMMd1JoeL9WiEWZ6C02WRMkWi2BU70AQUcmLwdYyJbFf5hiijEyRhHv0kg1E591fmy3x92
        uOLeSLM8LD7rJnHl5wIQ8aZnLlRmP9k=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-562-aR6uzQfFM12HDy-IUuvHBg-1; Wed, 06 Jul 2022 07:57:35 -0400
X-MC-Unique: aR6uzQfFM12HDy-IUuvHBg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2297489C8B3;
        Wed,  6 Jul 2022 11:57:35 +0000 (UTC)
Received: from starship (unknown [10.40.194.38])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C6F4840CF8E7;
        Wed,  6 Jul 2022 11:57:32 +0000 (UTC)
Message-ID: <1521442faa5abeb4449209550015040f2b2db849.camel@redhat.com>
Subject: Re: [PATCH v2 05/21] KVM: nVMX: Prioritize TSS T-flag #DBs over
 Monitor Trap Flag
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Date:   Wed, 06 Jul 2022 14:57:31 +0300
In-Reply-To: <20220614204730.3359543-6-seanjc@google.com>
References: <20220614204730.3359543-1-seanjc@google.com>
         <20220614204730.3359543-6-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-06-14 at 20:47 +0000, Sean Christopherson wrote:
> Service TSS T-flag #DBs prior to pending MTFs, as such #DBs are higher
> priority than MTF. 
>  KVM itself doesn't emulate TSS #DBs, and any such
> exceptions injected from L1 will be handled by hardware (or morphed to
> a fault-like exception if injection fails), but theoretically userspace
> could pend a TSS T-flag #DB in conjunction with a pending MTF.


After reading the Jim's table 6-2, this makes sense, however note that
*check_nested_events is a bit different in the regard that CPU checks
the events when the previous instruction fully done committing it state,
and all it is left of it is maybe pending trap like events,

but in the KVM, the *check_nested_events, happens when we still didn't deliver
the fault like exception from the previous instruction, and thus,
a fault like exception appears to have higher priority than a pending MTF.

Assuming that my analysis is right:

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky


> 
> Note, there's no known use case this fixes, it's purely to be technically
> correct with respect to Intel's SDM.
> 
> Cc: Oliver Upton <oupton@google.com>
> Cc: Peter Shier <pshier@google.com>
> Fixes: 5ef8acbdd687 ("KVM: nVMX: Emulate MTF when performing instruction emulation")
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 61bc80fc4cfa..e794791a6bdd 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -3943,15 +3943,17 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
>  	}
>  
>  	/*
> -	 * Process any exceptions that are not debug traps before MTF.
> +	 * Process exceptions that are higher priority than Monitor Trap Flag:
> +	 * fault-like exceptions, TSS T flag #DB (not emulated by KVM, but
> +	 * could theoretically come in from userspace), and ICEBP (INT1).
>  	 *
>  	 * Note that only a pending nested run can block a pending exception.
>  	 * Otherwise an injected NMI/interrupt should either be
>  	 * lost or delivered to the nested hypervisor in the IDT_VECTORING_INFO,
>  	 * while delivering the pending exception.
>  	 */
> -
> -	if (vcpu->arch.exception.pending && !vmx_get_pending_dbg_trap(vcpu)) {
> +	if (vcpu->arch.exception.pending &&
> +	    !(vmx_get_pending_dbg_trap(vcpu) & ~DR6_BT)) {
>  		if (vmx->nested.nested_run_pending)
>  			return -EBUSY;
>  		if (!nested_vmx_check_exception(vcpu, &exit_qual))




