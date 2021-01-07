Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01A8D2ED658
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 19:05:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728979AbhAGSEo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 13:04:44 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:27870 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726294AbhAGSEo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 Jan 2021 13:04:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610042597;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5b36Xc2SKU0a+7LxVxNlJO6GM2c450VEJqcMA0uDyoM=;
        b=Peq5bb08kwogOrEDD+/jAyP404Nt3hV2DKUG2MUFGSan6KLbJ2ygb6OwsEbv/SULKxfrTS
        6gWIEGTPSX02Vek83R+S9hVQxTdk/Omuk5a/2zON+fBMf5Z3dxaccJR4b7VhHTQ4ac0vfm
        +d37vPGVrC6wiG2BCXsObpqnzEgtu5E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-304-h8HVBlOQOd2HGcGKWkdniw-1; Thu, 07 Jan 2021 13:03:15 -0500
X-MC-Unique: h8HVBlOQOd2HGcGKWkdniw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E2E51107ACF6;
        Thu,  7 Jan 2021 18:03:11 +0000 (UTC)
Received: from starship (unknown [10.35.206.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D3A245D9E3;
        Thu,  7 Jan 2021 18:03:07 +0000 (UTC)
Message-ID: <16461ed89f53110c44ca8e80afc505e50a0cafb5.camel@redhat.com>
Subject: Re: [PATCH v2 1/4] KVM: nSVM: cancel KVM_REQ_GET_NESTED_STATE_PAGES
 on nested vmexit
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>
Date:   Thu, 07 Jan 2021 20:03:06 +0200
In-Reply-To: <6d7bac03-2270-e908-2e66-1cc4f9425294@redhat.com>
References: <20210107093854.882483-1-mlevitsk@redhat.com>
         <20210107093854.882483-2-mlevitsk@redhat.com> <X/c+FzXGfk/3LUC2@google.com>
         <6d7bac03-2270-e908-2e66-1cc4f9425294@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2021-01-07 at 18:51 +0100, Paolo Bonzini wrote:
> On 07/01/21 18:00, Sean Christopherson wrote:
> > Ugh, I assume this is due to one of the "premature" nested_ops->check_events()
> > calls that are necessitated by the event mess?  I'm guessing kvm_vcpu_running()
> > is the culprit?
> > 
> > If my assumption is correct, this bug affects nVMX as well.
> 
> Yes, though it may be latent.  For SVM it was until we started 
> allocating svm->nested on demand.
> 
> > Rather than clear the request blindly on any nested VM-Exit, what
> > about something like the following?
> 
> I think your patch is overkill, KVM_REQ_GET_NESTED_STATE_PAGES is only 
> set from KVM_SET_NESTED_STATE so it cannot happen while the VM runs.

Note that I didn't include the same fix for VMX becasue it uses a separate vmcs
for guest which has its own msr bitmap so in theory this shouldn't be needed,
but it won't hurt.

I'll test indeed if canceling the KVM_REQ_GET_NESTED_STATE_PAGES on VMX
makes any difference on VMX in regard to nested migration crashes I am seeing.

Best regards,
	Maxim Levitsky

> 
> Something like this is small enough and works well.
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index a622e63739b4..cb4c6ee10029 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -595,6 +596,8 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
>   	svm->nested.vmcb12_gpa = 0;
>   	WARN_ON_ONCE(svm->nested.nested_run_pending);
> 
> +	kvm_clear_request(KVM_REQ_GET_NESTED_STATE_PAGES, &svm->vcpu);
> +
>   	/* in case we halted in L2 */
>   	svm->vcpu.arch.mp_state = KVM_MP_STATE_RUNNABLE;
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index e2f26564a12d..0fbb46990dfc 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -4442,6 +4442,8 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 
> vm_exit_reason,
>   	/* trying to cancel vmlaunch/vmresume is a bug */
>   	WARN_ON_ONCE(vmx->nested.nested_run_pending);
> 
> +	kvm_clear_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu);
> +
>   	/* Service the TLB flush request for L2 before switching to L1. */
>   	if (kvm_check_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu))
>   		kvm_vcpu_flush_tlb_current(vcpu);
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 3f7c1fc7a3ce..b7e784b5489c 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -8789,7 +8789,9 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
> 
>   	if (kvm_request_pending(vcpu)) {
>   		if (kvm_check_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu)) {
> -			if (unlikely(!kvm_x86_ops.nested_ops->get_nested_state_pages(vcpu))) {
> +			if (WARN_ON_ONCE(!is_guest_mode(&svm->vcpu)))
> +				;
> +			else if 
> (unlikely(!kvm_x86_ops.nested_ops->get_nested_state_pages(vcpu))) {
>   				r = 0;
>   				goto out;
>   			}
> 


