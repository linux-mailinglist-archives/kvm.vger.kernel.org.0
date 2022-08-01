Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86CB0586E33
	for <lists+kvm@lfdr.de>; Mon,  1 Aug 2022 18:00:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231726AbiHAQA3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Aug 2022 12:00:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231923AbiHAQAZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Aug 2022 12:00:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 34A8410FE9
        for <kvm@vger.kernel.org>; Mon,  1 Aug 2022 09:00:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659369623;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=425mAoRHv7Eq4Ioj1UBZU+35qRscrZA6m4TfZAimPVo=;
        b=Io3wJHJ7nQn1yg2xAveVsoyVs+N4uJFFDIrrc4ENl+/485OxOMi6stWS8cMlxB9IbxmiRr
        AITXIncmQL7DBmhuSFIgkaIKYktbGNk7akaEcfHU91AvYfE0q0KqO0fW3viLcTpd8FjLz+
        O67tUQvrn9I/Q5We10rCfxZbx+bNYPo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-124-Mhtw9F8KN9yFnZi3tuWQbw-1; Mon, 01 Aug 2022 12:00:21 -0400
X-MC-Unique: Mhtw9F8KN9yFnZi3tuWQbw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 640A12813D28;
        Mon,  1 Aug 2022 16:00:21 +0000 (UTC)
Received: from starship (unknown [10.40.194.242])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8FC9740C1288;
        Mon,  1 Aug 2022 16:00:19 +0000 (UTC)
Message-ID: <29713b12503aa705fe857f6b61678053d0330db3.camel@redhat.com>
Subject: Re: [PATCH v4 02/24] KVM: VMX: Drop bits 31:16 when shoving
 exception error code into VMCS
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jim Mattson <jmattson@google.com>,
        Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Date:   Mon, 01 Aug 2022 19:00:18 +0300
In-Reply-To: <20220723005137.1649592-3-seanjc@google.com>
References: <20220723005137.1649592-1-seanjc@google.com>
         <20220723005137.1649592-3-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 2022-07-23 at 00:51 +0000, Sean Christopherson wrote:
> Deliberately truncate the exception error code when shoving it into the
> VMCS (VM-Entry field for vmcs01 and vmcs02, VM-Exit field for vmcs12).
> Intel CPUs are incapable of handling 32-bit error codes and will never
> generate an error code with bits 31:16, but userspace can provide an
> arbitrary error code via KVM_SET_VCPU_EVENTS.  Failure to drop the bits
> on exception injection results in failed VM-Entry, as VMX disallows
> setting bits 31:16.  Setting the bits on VM-Exit would at best confuse
> L1, and at worse induce a nested VM-Entry failure, e.g. if L1 decided to
> reinject the exception back into L2.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Reviewed-by: Jim Mattson <jmattson@google.com>
> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 11 ++++++++++-
>  arch/x86/kvm/vmx/vmx.c    | 12 +++++++++++-
>  2 files changed, 21 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index a980d9cbee60..c6f9fe0b6b33 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -3827,7 +3827,16 @@ static void nested_vmx_inject_exception_vmexit(struct kvm_vcpu *vcpu,
>  	u32 intr_info = nr | INTR_INFO_VALID_MASK;
>  
>  	if (vcpu->arch.exception.has_error_code) {
> -		vmcs12->vm_exit_intr_error_code = vcpu->arch.exception.error_code;
> +		/*
> +		 * Intel CPUs do not generate error codes with bits 31:16 set,
> +		 * and more importantly VMX disallows setting bits 31:16 in the
> +		 * injected error code for VM-Entry.  Drop the bits to mimic
> +		 * hardware and avoid inducing failure on nested VM-Entry if L1
> +		 * chooses to inject the exception back to L2.  AMD CPUs _do_
> +		 * generate "full" 32-bit error codes, so KVM allows userspace
> +		 * to inject exception error codes with bits 31:16 set.
> +		 */
> +		vmcs12->vm_exit_intr_error_code = (u16)vcpu->arch.exception.error_code;
>  		intr_info |= INTR_INFO_DELIVER_CODE_MASK;
>  	}
>  
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 4fd25e1d6ec9..1c72cde600d0 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1621,7 +1621,17 @@ static void vmx_queue_exception(struct kvm_vcpu *vcpu)
>  	kvm_deliver_exception_payload(vcpu);
>  
>  	if (has_error_code) {
> -		vmcs_write32(VM_ENTRY_EXCEPTION_ERROR_CODE, error_code);
> +		/*
> +		 * Despite the error code being architecturally defined as 32
> +		 * bits, and the VMCS field being 32 bits, Intel CPUs and thus
> +		 * VMX don't actually supporting setting bits 31:16.  Hardware
> +		 * will (should) never provide a bogus error code, but AMD CPUs
> +		 * do generate error codes with bits 31:16 set, and so KVM's
> +		 * ABI lets userspace shove in arbitrary 32-bit values.  Drop
> +		 * the upper bits to avoid VM-Fail, losing information that
> +		 * does't really exist is preferable to killing the VM.
> +		 */
> +		vmcs_write32(VM_ENTRY_EXCEPTION_ERROR_CODE, (u16)error_code);
>  		intr_info |= INTR_INFO_DELIVER_CODE_MASK;
>  	}
>  


Thanks!

Best regards,
	Maxim Levitsky

