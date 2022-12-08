Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27499647832
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 22:48:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbiLHVsK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 16:48:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiLHVsI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 16:48:08 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B71E78BBC
        for <kvm@vger.kernel.org>; Thu,  8 Dec 2022 13:47:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670536031;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IlCKc99cFpdm8E1COJJ/fCt6u0thpaENNsxRHeyQUzE=;
        b=IVvAnQjBlKNyQLXzo+/b0QEgXDF+OmbIgJgP+6qyJWItcj3I+4DUdot85RBJPzFcVkhueF
        hI+AHhzFxzhXGsMM7pIr2IvitOQ6EGmIGAe0uN6CfnNYAIUs8YjunHkILDQ9nBbXnHSF36
        KnOn//9lqmiax+50TdoqgsjYCnxZI8k=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-653-q95tK7haMXKtEB8UQsoZ7g-1; Thu, 08 Dec 2022 16:47:08 -0500
X-MC-Unique: q95tK7haMXKtEB8UQsoZ7g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8743D101A52A;
        Thu,  8 Dec 2022 21:47:07 +0000 (UTC)
Received: from starship (unknown [10.35.206.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C95B81121331;
        Thu,  8 Dec 2022 21:47:05 +0000 (UTC)
Message-ID: <d2cd803a75dc4d7114fc0d45018b7f517a83a867.camel@redhat.com>
Subject: Re: [PATCH v4 01/32] KVM: x86: Blindly get current x2APIC reg value
 on "nodecode write" traps
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Li RongQing <lirongqing@baidu.com>
Date:   Thu, 08 Dec 2022 23:47:04 +0200
In-Reply-To: <20221001005915.2041642-2-seanjc@google.com>
References: <20221001005915.2041642-1-seanjc@google.com>
         <20221001005915.2041642-2-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 2022-10-01 at 00:58 +0000, Sean Christopherson wrote:
> When emulating a x2APIC write in response to an APICv/AVIC trap, get the
> the written value from the vAPIC page without checking that reads are
> allowed for the target register.  AVIC can generate trap-like VM-Exits on
> writes to EOI, and so KVM needs to get the written value from the backing
> page without running afoul of EOI's write-only behavior.
> 
> Alternatively, EOI could be special cased to always write '0', e.g. so
> that the sanity check could be preserved, but x2APIC on AMD is actually
> supposed to disallow non-zero writes (not emulated by KVM), and the
> sanity check was a byproduct of how the KVM code was written, i.e. wasn't
> added to guard against anything in particular.
> 
> Fixes: 70c8327c11c6 ("KVM: x86: Bug the VM if an accelerated x2APIC trap occurs on a "bad" reg")
> Fixes: 1bd9dfec9fd4 ("KVM: x86: Do not block APIC write for non ICR registers")
> Reported-by: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/lapic.c | 9 ++-------
>  1 file changed, 2 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index d7639d126e6c..05d079fc2c66 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -2284,23 +2284,18 @@ void kvm_apic_write_nodecode(struct kvm_vcpu *vcpu, u32 offset)
>  	struct kvm_lapic *apic = vcpu->arch.apic;
>  	u64 val;
>  
> -	if (apic_x2apic_mode(apic)) {
> -		if (KVM_BUG_ON(kvm_lapic_msr_read(apic, offset, &val), vcpu->kvm))
> -			return;
> -	} else {
> -		val = kvm_lapic_get_reg(apic, offset);
> -	}
> -
>  	/*
>  	 * ICR is a single 64-bit register when x2APIC is enabled.  For legacy
>  	 * xAPIC, ICR writes need to go down the common (slightly slower) path
>  	 * to get the upper half from ICR2.
>  	 */
>  	if (apic_x2apic_mode(apic) && offset == APIC_ICR) {
> +		val = kvm_lapic_get_reg64(apic, APIC_ICR);
>  		kvm_apic_send_ipi(apic, (u32)val, (u32)(val >> 32));
>  		trace_kvm_apic_write(APIC_ICR, val);
>  	} else {
>  		/* TODO: optimize to just emulate side effect w/o one more write */
> +		val = kvm_lapic_get_reg(apic, offset);
>  		kvm_lapic_reg_write(apic, offset, (u32)val);
>  	}
>  }

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

