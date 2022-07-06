Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CD455686FC
	for <lists+kvm@lfdr.de>; Wed,  6 Jul 2022 13:44:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232655AbiGFLnQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jul 2022 07:43:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbiGFLnO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jul 2022 07:43:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AD7EA27CD8
        for <kvm@vger.kernel.org>; Wed,  6 Jul 2022 04:43:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657107792;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RG6ddZS0ZUevI491C3hXszWOwMlAIAahGi08ot1UyoQ=;
        b=I9jCf6M4BFfgwFO0hXdyB1sgqEsg9gMunj1nDJrLG8ItARRaIFqyIoY0J/PpUKCHixHdov
        bMCCEUuaNwSSg03dX1Lr5BR+z/DPVPlTtMRroh/CsMHdij47WLyVC+mtnyIiy/e5r//hFD
        Si2FCC1AtBZsaClcSP1V7TItraBVt0M=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-329-GNmOByy2MDSnXrZ5vZD9yA-1; Wed, 06 Jul 2022 07:43:09 -0400
X-MC-Unique: GNmOByy2MDSnXrZ5vZD9yA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4C71B299E74E;
        Wed,  6 Jul 2022 11:43:09 +0000 (UTC)
Received: from starship (unknown [10.40.194.38])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EF2B540315A;
        Wed,  6 Jul 2022 11:43:06 +0000 (UTC)
Message-ID: <df72cfcdda55b594d6bbbd9b5b0e2b229dc6c718.camel@redhat.com>
Subject: Re: [PATCH v2 02/21] KVM: VMX: Drop bits 31:16 when shoving
 exception error code into VMCS
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Date:   Wed, 06 Jul 2022 14:43:05 +0300
In-Reply-To: <20220614204730.3359543-3-seanjc@google.com>
References: <20220614204730.3359543-1-seanjc@google.com>
         <20220614204730.3359543-3-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
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
> Deliberately truncate the exception error code when shoving it into the
> VMCS (VM-Entry field for vmcs01 and vmcs02, VM-Exit field for vmcs12).
> Intel CPUs are incapable of handling 32-bit error codes and will never
> generate an error code with bits 31:16, but userspace can provide an
> arbitrary error code via KVM_SET_VCPU_EVENTS.  Failure to drop the bits
> on exception injection results in failed VM-Entry, as VMX disallows
> setting bits 31:16.  Setting the bits on VM-Exit would at best confuse
> L1, and at worse induce a nested VM-Entry failure, e.g. if L1 decided to
> reinject the exception back into L2.

Wouldn't it be better to fail KVM_SET_VCPU_EVENTS instead if it tries
to set error code with uppper 16 bits set?

Or if that is considered ABI breakage, then KVM_SET_VCPU_EVENTS code
can truncate the user given value to 16 bit.

Best regards,
	Maxim Levitsky


> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/vmx/nested.c |  9 ++++++++-
>  arch/x86/kvm/vmx/vmx.c    | 11 ++++++++++-
>  2 files changed, 18 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index ee6f27dffdba..33ffc8bcf9cd 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -3833,7 +3833,14 @@ static void nested_vmx_inject_exception_vmexit(struct kvm_vcpu *vcpu,
>  	u32 intr_info = nr | INTR_INFO_VALID_MASK;
>  
>  	if (vcpu->arch.exception.has_error_code) {
> -		vmcs12->vm_exit_intr_error_code = vcpu->arch.exception.error_code;
> +		/*
> +		 * Intel CPUs will never generate an error code with bits 31:16
> +		 * set, and more importantly VMX disallows setting bits 31:16
> +		 * in the injected error code for VM-Entry.  Drop the bits to
> +		 * mimic hardware and avoid inducing failure on nested VM-Entry
> +		 * if L1 chooses to inject the exception back to L2.
> +		 */
> +		vmcs12->vm_exit_intr_error_code = (u16)vcpu->arch.exception.error_code;
>  		intr_info |= INTR_INFO_DELIVER_CODE_MASK;
>  	}
>  
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 5e14e4c40007..ec98992024e2 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1621,7 +1621,16 @@ static void vmx_queue_exception(struct kvm_vcpu *vcpu)
>  	kvm_deliver_exception_payload(vcpu);
>  
>  	if (has_error_code) {
> -		vmcs_write32(VM_ENTRY_EXCEPTION_ERROR_CODE, error_code);
> +		/*
> +		 * Despite the error code being architecturally defined as 32
> +		 * bits, and the VMCS field being 32 bits, Intel CPUs and thus
> +		 * VMX don't actually supporting setting bits 31:16.  Hardware
> +		 * will (should) never provide a bogus error code, but KVM's
> +		 * ABI lets userspace shove in arbitrary 32-bit values.  Drop
> +		 * the upper bits to avoid VM-Fail, losing information that
> +		 * does't really exist is preferable to killing the VM.
> +		 */
> +		vmcs_write32(VM_ENTRY_EXCEPTION_ERROR_CODE, (u16)error_code);
>  		intr_info |= INTR_INFO_DELIVER_CODE_MASK;
>  	}
>  


