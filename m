Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A981B56878C
	for <lists+kvm@lfdr.de>; Wed,  6 Jul 2022 13:59:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233081AbiGFL7j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jul 2022 07:59:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232619AbiGFL7f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jul 2022 07:59:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5823363F9
        for <kvm@vger.kernel.org>; Wed,  6 Jul 2022 04:59:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657108772;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nq047LTJjjezjeR0TTQNMgByF8ZMseI1JAaxvfIaXFc=;
        b=PmEmdmveknhavRKKFj2OBRDOBVX/pqZDzol14qOkGs8dXD9LWEBc7vwjOp/9Jb8ENl63fz
        SZK2zLz7W7VEiWBudyeIbbm+r0N5cf7120hgEpLG0z1Cz0t+YCDuG66n7T0NQ9SQj+ljrP
        +hjFeN3RLch4RZRkAsCPP0U6TR0G3dE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-481-Ep_Jc_RTNNWvg9An53C2Ww-1; Wed, 06 Jul 2022 07:59:28 -0400
X-MC-Unique: Ep_Jc_RTNNWvg9An53C2Ww-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3794329AB3F1;
        Wed,  6 Jul 2022 11:59:28 +0000 (UTC)
Received: from starship (unknown [10.40.194.38])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DA0C6C28129;
        Wed,  6 Jul 2022 11:59:25 +0000 (UTC)
Message-ID: <f437b74d90c0da2763ea9a96690050146f6382dc.camel@redhat.com>
Subject: Re: [PATCH v2 08/21] KVM: nVMX: Ignore SIPI that arrives in L2 when
 vCPU is not in WFS
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Date:   Wed, 06 Jul 2022 14:59:24 +0300
In-Reply-To: <20220614204730.3359543-9-seanjc@google.com>
References: <20220614204730.3359543-1-seanjc@google.com>
         <20220614204730.3359543-9-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-06-14 at 20:47 +0000, Sean Christopherson wrote:
> Fall through to handling other pending exception/events for L2 if SIPI
> is pending while the CPU is not in Wait-for-SIPI.  KVM correctly ignores
> the event, but incorrectly returns immediately, e.g. a SIPI coincident
> with another event could lead to KVM incorrectly routing the event to L1
> instead of L2.
> 
> Fixes: bf0cd88ce363 ("KVM: x86: emulate wait-for-SIPI and SIPI-VMExit")
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index e794791a6bdd..d080bfca16ef 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -3936,10 +3936,12 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
>  			return -EBUSY;
>  
>  		clear_bit(KVM_APIC_SIPI, &apic->pending_events);
> -		if (vcpu->arch.mp_state == KVM_MP_STATE_INIT_RECEIVED)
> +		if (vcpu->arch.mp_state == KVM_MP_STATE_INIT_RECEIVED) {
>  			nested_vmx_vmexit(vcpu, EXIT_REASON_SIPI_SIGNAL, 0,
>  						apic->sipi_vector & 0xFFUL);
> -		return 0;
> +			return 0;
> +		}
> +		/* Fallthrough, the SIPI is completely ignored. */
>  	}
>  
>  	/*



Makes sense.

Note that svm_check_nested_events lacks the code to check for SIPI at all,
but SVM lacks SIPI intercept, thus this is likely correct, 
the place which delivers SIPI to L1 is I think kvm_apic_accept_events,
and it will ignore it unless the CPU is in INIT state, in which
it will not be in nested mode.


Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

