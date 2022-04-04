Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BC7D4F1268
	for <lists+kvm@lfdr.de>; Mon,  4 Apr 2022 11:54:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355277AbiDDJ4c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Apr 2022 05:56:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355220AbiDDJ43 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Apr 2022 05:56:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D7ACC12AC4
        for <kvm@vger.kernel.org>; Mon,  4 Apr 2022 02:54:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649066073;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KMb1GD24tmBMQaTuA4xnLnYoCbKxRRTT3IiDRoq85ns=;
        b=CSxLlYHqETlz/n58J8MTOM02/2mpkBQ0YhmnrJxQ0EVbjl9a20QDq/j0/4himplgMWwrQE
        uX74nZSzBzp+G4ibHS0jKXbac0prSHATplrJ6u/mn1L+REYbrIjXwW5Ub02pb6hKN8FSfz
        D6cXucMZ6LE6fIC9WIYAPUHHgdOz6uY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-404-BEBSKqy4Pa-CIeNKhoZhBg-1; Mon, 04 Apr 2022 05:54:27 -0400
X-MC-Unique: BEBSKqy4Pa-CIeNKhoZhBg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BD0011C05EA6;
        Mon,  4 Apr 2022 09:54:26 +0000 (UTC)
Received: from starship (unknown [10.40.194.231])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B12051111C72;
        Mon,  4 Apr 2022 09:54:24 +0000 (UTC)
Message-ID: <2369d933f61073ca6788545f40b16b9c86d6d368.camel@redhat.com>
Subject: Re: [PATCH 1/8] KVM: nSVM: Sync next_rip field from vmcb12 to vmcb02
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>
Date:   Mon, 04 Apr 2022 12:54:23 +0300
In-Reply-To: <20220402010903.727604-2-seanjc@google.com>
References: <20220402010903.727604-1-seanjc@google.com>
         <20220402010903.727604-2-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 2022-04-02 at 01:08 +0000, Sean Christopherson wrote:
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
> Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
> Co-developed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/svm/nested.c | 22 +++++++++++++++++++---
>  arch/x86/kvm/svm/svm.h    |  1 +
>  2 files changed, 20 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 73b545278f5f..9a6dc2b38fcf 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -369,6 +369,7 @@ void __nested_copy_vmcb_control_to_cache(struct kvm_vcpu *vcpu,
>  	to->nested_ctl          = from->nested_ctl;
>  	to->event_inj           = from->event_inj;
>  	to->event_inj_err       = from->event_inj_err;
> +	to->next_rip            = from->next_rip;
>  	to->nested_cr3          = from->nested_cr3;
>  	to->virt_ext            = from->virt_ext;
>  	to->pause_filter_count  = from->pause_filter_count;
> @@ -606,7 +607,8 @@ static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12
>  	}
>  }
>  
> -static void nested_vmcb02_prepare_control(struct vcpu_svm *svm)
> +static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
> +					  unsigned long vmcb12_rip)
>  {
>  	u32 int_ctl_vmcb01_bits = V_INTR_MASKING_MASK;
>  	u32 int_ctl_vmcb12_bits = V_TPR_MASK | V_IRQ_INJECTION_BITS_MASK;
> @@ -660,6 +662,19 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm)
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
> @@ -743,7 +758,7 @@ int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa,
>  	nested_svm_copy_common_state(svm->vmcb01.ptr, svm->nested.vmcb02.ptr);
>  
>  	svm_switch_vmcb(svm, &svm->nested.vmcb02);
> -	nested_vmcb02_prepare_control(svm);
> +	nested_vmcb02_prepare_control(svm, vmcb12->save.rip);
>  	nested_vmcb02_prepare_save(svm, vmcb12);
>  
>  	ret = nested_svm_load_cr3(&svm->vcpu, svm->nested.save.cr3,
> @@ -1422,6 +1437,7 @@ static void nested_copy_vmcb_cache_to_control(struct vmcb_control_area *dst,
>  	dst->nested_ctl           = from->nested_ctl;
>  	dst->event_inj            = from->event_inj;
>  	dst->event_inj_err        = from->event_inj_err;
> +	dst->next_rip             = from->next_rip;
>  	dst->nested_cr3           = from->nested_cr3;
>  	dst->virt_ext              = from->virt_ext;
>  	dst->pause_filter_count   = from->pause_filter_count;
> @@ -1606,7 +1622,7 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
>  	nested_copy_vmcb_control_to_cache(svm, ctl);
>  
>  	svm_switch_vmcb(svm, &svm->nested.vmcb02);
> -	nested_vmcb02_prepare_control(svm);
> +	nested_vmcb02_prepare_control(svm, save->rip);
>  
>  	/*
>  	 * While the nested guest CR3 is already checked and set by
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index e246793cbeae..47e7427d0395 100644
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

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

