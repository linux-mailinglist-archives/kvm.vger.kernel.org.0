Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4B5F513032
	for <lists+kvm@lfdr.de>; Thu, 28 Apr 2022 11:48:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232025AbiD1JuV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 05:50:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348041AbiD1JgX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 05:36:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 727269548A
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 02:33:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651138388;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0+QeEjdlvvlc38nZdjYzYRw08aWXPNggIaDYFBip0UI=;
        b=GbZMQN+QCuXBIQ47uqo22w2L3Da6tCYYZjQ7Psw/bfgatc/LPfj0T/jFckdb4GMch9+6Sq
        mBdggjx50RUnTbp2sLiPN+weeulMOaGMcaIYTwaW26ONHESWN2Whif70PPgkZ1xuFUdATL
        vNlCDUbbRdEGscNia70Thq+C7idtHBQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-8-CxnbmQaLOQ2X8oyhlHbL6g-1; Thu, 28 Apr 2022 05:33:05 -0400
X-MC-Unique: CxnbmQaLOQ2X8oyhlHbL6g-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AD22F185A79C;
        Thu, 28 Apr 2022 09:33:04 +0000 (UTC)
Received: from starship (unknown [10.40.192.41])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4FE24463EC5;
        Thu, 28 Apr 2022 09:33:02 +0000 (UTC)
Message-ID: <1532f2bb21aa68ad4a629e179112fcac2c1bfbf7.camel@redhat.com>
Subject: Re: [PATCH v2 01/11] KVM: nSVM: Sync next_rip field from vmcb12 to
 vmcb02
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>
Date:   Thu, 28 Apr 2022 12:33:01 +0300
In-Reply-To: <20220423021411.784383-2-seanjc@google.com>
References: <20220423021411.784383-1-seanjc@google.com>
         <20220423021411.784383-2-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 2022-04-23 at 02:14 +0000, Sean Christopherson wrote:
> From: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
> 
> The next_rip field of a VMCB is *not* an output-only field for a VMRUN.
> This field value (instead of the saved guest RIP) in used by the CPU for
> the return address pushed on stack when injecting a software interrupt or
> INT3 or INTO exception.
> 
> Make sure this field gets synced from vmcb12 to vmcb02 when entering L2 or
> loading a nested state and NRIPS is exposed to L1.  If NRIPS is supported
> in hardware but not exposed to L1 (nrips=0 or hidden by userspace), stuff
> vmcb02's next_rip from the new L2 RIP to emulate a !NRIPS CPU (which
> saves RIP on the stack as-is).
> 
> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
> Co-developed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/svm/nested.c | 22 +++++++++++++++++++---
>  arch/x86/kvm/svm/svm.h    |  1 +
>  2 files changed, 20 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index bed5e1692cef..461c5f247801 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -371,6 +371,7 @@ void __nested_copy_vmcb_control_to_cache(struct kvm_vcpu *vcpu,
>  	to->nested_ctl          = from->nested_ctl;
>  	to->event_inj           = from->event_inj;
>  	to->event_inj_err       = from->event_inj_err;
> +	to->next_rip            = from->next_rip;
>  	to->nested_cr3          = from->nested_cr3;
>  	to->virt_ext            = from->virt_ext;
>  	to->pause_filter_count  = from->pause_filter_count;
> @@ -608,7 +609,8 @@ static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12
>  	}
>  }
>  
> -static void nested_vmcb02_prepare_control(struct vcpu_svm *svm)
> +static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
> +					  unsigned long vmcb12_rip)

I know that I already reviewed this, but why do we need to pass an extra
parameter to nested_vmcb02_prepare_control.
Lets just put that value in the cache to be consistent with the rest?

Best regards,
	Maxim Levitsky


>  {
>  	u32 int_ctl_vmcb01_bits = V_INTR_MASKING_MASK;
>  	u32 int_ctl_vmcb12_bits = V_TPR_MASK | V_IRQ_INJECTION_BITS_MASK;
> @@ -662,6 +664,19 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm)
>  	vmcb02->control.event_inj           = svm->nested.ctl.event_inj;
>  	vmcb02->control.event_inj_err       = svm->nested.ctl.event_inj_err;
>  
> +	/*
> +	 * next_rip is consumed on VMRUN as the return address pushed on the
> +	 * stack for injected soft exceptions/interrupts.  If nrips is exposed
> +	 * to L1, take it verbatim from vmcb12.  If nrips is supported in
> +	 * hardware but not exposed to L1, stuff the actual L2 RIP to emulate
> +	 * what a nrips=0 CPU would do (L1 is responsible for advancing RIP
> +	 * prior to injecting the event).
> +	 */
> +	if (svm->nrips_enabled)
> +		vmcb02->control.next_rip    = svm->nested.ctl.next_rip;
> +	else if (boot_cpu_has(X86_FEATURE_NRIPS))
> +		vmcb02->control.next_rip    = vmcb12_rip;
> +
>  	vmcb02->control.virt_ext            = vmcb01->control.virt_ext &
>  					      LBR_CTL_ENABLE_MASK;
>  	if (svm->lbrv_enabled)
> @@ -745,7 +760,7 @@ int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa,
>  	nested_svm_copy_common_state(svm->vmcb01.ptr, svm->nested.vmcb02.ptr);
>  
>  	svm_switch_vmcb(svm, &svm->nested.vmcb02);
> -	nested_vmcb02_prepare_control(svm);
> +	nested_vmcb02_prepare_control(svm, vmcb12->save.rip);
>  	nested_vmcb02_prepare_save(svm, vmcb12);
>  
>  	ret = nested_svm_load_cr3(&svm->vcpu, svm->nested.save.cr3,
> @@ -1418,6 +1433,7 @@ static void nested_copy_vmcb_cache_to_control(struct vmcb_control_area *dst,
>  	dst->nested_ctl           = from->nested_ctl;
>  	dst->event_inj            = from->event_inj;
>  	dst->event_inj_err        = from->event_inj_err;
> +	dst->next_rip             = from->next_rip;
>  	dst->nested_cr3           = from->nested_cr3;
>  	dst->virt_ext              = from->virt_ext;
>  	dst->pause_filter_count   = from->pause_filter_count;
> @@ -1602,7 +1618,7 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
>  	nested_copy_vmcb_control_to_cache(svm, ctl);
>  
>  	svm_switch_vmcb(svm, &svm->nested.vmcb02);
> -	nested_vmcb02_prepare_control(svm);
> +	nested_vmcb02_prepare_control(svm, save->rip);
>  
>  	/*
>  	 * While the nested guest CR3 is already checked and set by
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 32220a1b0ea2..7d97e4d18c8b 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -139,6 +139,7 @@ struct vmcb_ctrl_area_cached {
>  	u64 nested_ctl;
>  	u32 event_inj;
>  	u32 event_inj_err;
> +	u64 next_rip;
>  	u64 nested_cr3;
>  	u64 virt_ext;
>  	u32 clean;


