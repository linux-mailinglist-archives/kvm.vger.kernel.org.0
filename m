Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31FEB568725
	for <lists+kvm@lfdr.de>; Wed,  6 Jul 2022 13:47:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233443AbiGFLqY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jul 2022 07:46:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233090AbiGFLqM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jul 2022 07:46:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 36447286FC
        for <kvm@vger.kernel.org>; Wed,  6 Jul 2022 04:45:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657107945;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RROrfdIIY329D1ocOTSvuKdK47EBK1sQYB2AEucsQ0s=;
        b=JeEfKmiYKWUGX2rokYBpxUWSGSl9A7OTH8m4MwyBhFTgeENlQJ8L25hqmDJWs+LalQn/af
        gMrpKodpgER5HYc/BMJUSJ3b9MpjBXSGmblACllnTISzROK5ho3AxizJIAs+yhWnvgsP0M
        3IxIv539BSnYXH4x/9tStKyzKBh7c3I=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-49-vPWsJ9miNaSlwYPb-7hXKA-1; Wed, 06 Jul 2022 07:45:42 -0400
X-MC-Unique: vPWsJ9miNaSlwYPb-7hXKA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BDF1C8001EA;
        Wed,  6 Jul 2022 11:45:41 +0000 (UTC)
Received: from starship (unknown [10.40.194.38])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6A38E40CFD0A;
        Wed,  6 Jul 2022 11:45:39 +0000 (UTC)
Message-ID: <f025784c144c63b05266433756070862aef5f6d5.camel@redhat.com>
Subject: Re: [PATCH v2 04/21] KVM: nVMX: Treat General Detect #DB (DR7.GD=1)
 as fault-like
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Date:   Wed, 06 Jul 2022 14:45:38 +0300
In-Reply-To: <20220614204730.3359543-5-seanjc@google.com>
References: <20220614204730.3359543-1-seanjc@google.com>
         <20220614204730.3359543-5-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
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
> Exclude General Detect #DBs, which have fault-like behavior but also have
> a non-zero payload (DR6.BD=1), from nVMX's handling of pending debug
> traps.  Opportunistically rewrite the comment to better document what is
> being checked, i.e. "has a non-zero payload" vs. "has a payload", and to
> call out the many caveats surrounding #DBs that KVM dodges one way or
> another.
> 
> Cc: Oliver Upton <oupton@google.com>
> Cc: Peter Shier <pshier@google.com>
> Fixes: 684c0422da71 ("KVM: nVMX: Handle pending #DB when injecting INIT VM-exit")
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 36 +++++++++++++++++++++++++-----------
>  1 file changed, 25 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 33ffc8bcf9cd..61bc80fc4cfa 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -3857,16 +3857,29 @@ static void nested_vmx_inject_exception_vmexit(struct kvm_vcpu *vcpu,
>  }
>  
>  /*
> - * Returns true if a debug trap is pending delivery.
> + * Returns true if a debug trap is (likely) pending delivery.  Infer the class
> + * of a #DB (trap-like vs. fault-like) from the exception payload (to-be-DR6).
> + * Using the payload is flawed because code breakpoints (fault-like) and data
> + * breakpoints (trap-like) set the same bits in DR6 (breakpoint detected), i.e.
> + * this will return false positives if a to-be-injected code breakpoint #DB is
> + * pending (from KVM's perspective, but not "pending" across an instruction
> + * boundary).  ICEBP, a.k.a. INT1, is also not reflected here even though it
> + * too is trap-like.
>   *
> - * In KVM, debug traps bear an exception payload. As such, the class of a #DB
> - * exception may be inferred from the presence of an exception payload.
> + * KVM "works" despite these flaws as ICEBP isn't currently supported by the
> + * emulator, Monitor Trap Flag is not marked pending on intercepted #DBs (the
> + * #DB has already happened), and MTF isn't marked pending on code breakpoints
> + * from the emulator (because such #DBs are fault-like and thus don't trigger
> + * actions that fire on instruction retire).

Makes sense overall, but I am still not 100% sure to be honest I understand that
new description fully.

The patch itself seems to be correct, so,

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky




>   */
> -static inline bool vmx_pending_dbg_trap(struct kvm_vcpu *vcpu)
> +static inline unsigned long vmx_get_pending_dbg_trap(struct kvm_vcpu *vcpu)
>  {
> -	return vcpu->arch.exception.pending &&
> -			vcpu->arch.exception.nr == DB_VECTOR &&
> -			vcpu->arch.exception.payload;
> +	if (!vcpu->arch.exception.pending ||
> +	    vcpu->arch.exception.nr != DB_VECTOR)
> +		return 0;
> +
> +	/* General Detect #DBs are always fault-like. */
> +	return vcpu->arch.exception.payload & ~DR6_BD;
>  }
>  
>  /*
> @@ -3878,9 +3891,10 @@ static inline bool vmx_pending_dbg_trap(struct kvm_vcpu *vcpu)
>   */
>  static void nested_vmx_update_pending_dbg(struct kvm_vcpu *vcpu)
>  {
> -	if (vmx_pending_dbg_trap(vcpu))
> -		vmcs_writel(GUEST_PENDING_DBG_EXCEPTIONS,
> -			    vcpu->arch.exception.payload);
> +	unsigned long pending_dbg = vmx_get_pending_dbg_trap(vcpu);
> +
> +	if (pending_dbg)
> +		vmcs_writel(GUEST_PENDING_DBG_EXCEPTIONS, pending_dbg);
>  }
>  
>  static bool nested_vmx_preemption_timer_pending(struct kvm_vcpu *vcpu)
> @@ -3937,7 +3951,7 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
>  	 * while delivering the pending exception.
>  	 */
>  
> -	if (vcpu->arch.exception.pending && !vmx_pending_dbg_trap(vcpu)) {
> +	if (vcpu->arch.exception.pending && !vmx_get_pending_dbg_trap(vcpu)) {
>  		if (vmx->nested.nested_run_pending)
>  			return -EBUSY;
>  		if (!nested_vmx_check_exception(vcpu, &exit_qual))







