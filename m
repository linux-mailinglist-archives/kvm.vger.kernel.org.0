Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37A5A4E448D
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 17:52:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238086AbiCVQxr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Mar 2022 12:53:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236623AbiCVQxp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Mar 2022 12:53:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 37CD585969
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 09:52:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647967936;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=db1IMNfZ680sFvNInZ9xMoSKQytu/M0sDENAFmyTnBo=;
        b=hH+4wVodxtoVU1CvgOKagThoAYNlc0KxhrTfEm3ldMzmcS2unXbA9XnH2sndRLCwErJug/
        PRBGl5BPN6Xr871wLCxTIN9j59edXPpyIF4sUBHn1fersiPAP9DcqUDnJyvRY2zvxq1G2U
        RmQahGADds4/LLY+rqyaKGy6MWcTg7E=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-443-PdXpRn9_PX6lYYxjLmGOQQ-1; Tue, 22 Mar 2022 12:52:11 -0400
X-MC-Unique: PdXpRn9_PX6lYYxjLmGOQQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4A2E985A5BE;
        Tue, 22 Mar 2022 16:52:10 +0000 (UTC)
Received: from starship (unknown [10.40.194.231])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ECF8740CF900;
        Tue, 22 Mar 2022 16:52:06 +0000 (UTC)
Message-ID: <5a63e5f2d88aa8a2caf84319c469b265ec430eb2.camel@redhat.com>
Subject: Re: [PATCH v3 4/7] KVM: x86: nSVM: support PAUSE filter threshold
 and count when cpu_pm=on
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>
Date:   Tue, 22 Mar 2022 18:52:05 +0200
In-Reply-To: <a235df4f-ba06-1b01-c588-06f12d8341b7@redhat.com>
References: <20220301143650.143749-1-mlevitsk@redhat.com>
         <20220301143650.143749-5-mlevitsk@redhat.com>
         <a235df4f-ba06-1b01-c588-06f12d8341b7@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-03-09 at 14:12 +0100, Paolo Bonzini wrote:
> On 3/1/22 15:36, Maxim Levitsky wrote:
> > Allow L1 to use these settings if L0 disables PAUSE interception
> > (AKA cpu_pm=on)
> > 
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > ---
> >   arch/x86/kvm/svm/nested.c |  6 ++++++
> >   arch/x86/kvm/svm/svm.c    | 17 +++++++++++++++++
> >   arch/x86/kvm/svm/svm.h    |  2 ++
> >   3 files changed, 25 insertions(+)
> > 
> > diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> > index 37510cb206190..4cb0bc49986d5 100644
> > --- a/arch/x86/kvm/svm/nested.c
> > +++ b/arch/x86/kvm/svm/nested.c
> > @@ -664,6 +664,12 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm)
> >   	if (!nested_vmcb_needs_vls_intercept(svm))
> >   		svm->vmcb->control.virt_ext |= VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK;
> >   
> > +	if (svm->pause_filter_enabled)
> > +		svm->vmcb->control.pause_filter_count = svm->nested.ctl.pause_filter_count;
> > +
> > +	if (svm->pause_threshold_enabled)
> > +		svm->vmcb->control.pause_filter_thresh = svm->nested.ctl.pause_filter_thresh;
> 
> I think this should be
> 
> 	if (kvm_pause_in_guest(vcpu->kvm)) {
> 		/* copy from VMCB12 if guest has CPUID, else set to 0 */
> 	} else {
> 		/* copy from VMCB01, unconditionally */
> 	}

> and likewise it should be copied back to VMCB01 unconditionally on 
> vmexit if !kvm_pause_in_guest(vcpu->kvm).


I did something different in the next version of the patches.
Please take a look.


> 
> >   	nested_svm_transition_tlb_flush(vcpu);
> >   
> >   	/* Enter Guest-Mode */
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index 6a571eed32ef4..52198e63c5fc4 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -4008,6 +4008,17 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
> >   
> >   	svm->v_vmload_vmsave_enabled = vls && guest_cpuid_has(vcpu, X86_FEATURE_V_VMSAVE_VMLOAD);
> >   
> > +	if (kvm_pause_in_guest(vcpu->kvm)) {
> > +		svm->pause_filter_enabled = pause_filter_count > 0 &&
> > +					    guest_cpuid_has(vcpu, X86_FEATURE_PAUSEFILTER);
> > +
> > +		svm->pause_threshold_enabled = pause_filter_thresh > 0 &&
> > +					    guest_cpuid_has(vcpu, X86_FEATURE_PFTHRESHOLD);
> 
> Why only if the module parameters are >0?  The module parameter is 
> unused if pause-in-guest is active.

Agree, will do.

> 
> > +	} else {
> > +		svm->pause_filter_enabled = false;
> > +		svm->pause_threshold_enabled = false;
> > +	}
> > +
> >   	svm_recalc_instruction_intercepts(vcpu, svm);
> >   
> >   	/* For sev guests, the memory encryption bit is not reserved in CR3.  */
> > @@ -4763,6 +4774,12 @@ static __init void svm_set_cpu_caps(void)
> >   		if (vls)
> >   			kvm_cpu_cap_set(X86_FEATURE_V_VMSAVE_VMLOAD);
> >   
> > +		if (pause_filter_count)
> > +			kvm_cpu_cap_set(X86_FEATURE_PAUSEFILTER);
> > +
> > +		if (pause_filter_thresh)
> > +			kvm_cpu_cap_set(X86_FEATURE_PFTHRESHOLD);
> 
> Likewise, this should be set using just boot_cpu_has, not the module 
> parameters.

Agree as well + the check above is wrong - it should have been inverted.

> 
> Paolo
> 
> >   		/* Nested VM can receive #VMEXIT instead of triggering #GP */
> >   		kvm_cpu_cap_set(X86_FEATURE_SVME_ADDR_CHK);
> >   	}
> > diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> > index a3c93f9c02847..6fa81eb3ffb78 100644
> > --- a/arch/x86/kvm/svm/svm.h
> > +++ b/arch/x86/kvm/svm/svm.h
> > @@ -234,6 +234,8 @@ struct vcpu_svm {
> >   	bool tsc_scaling_enabled          : 1;
> >   	bool lbrv_enabled                 : 1;
> >   	bool v_vmload_vmsave_enabled      : 1;
> > +	bool pause_filter_enabled         : 1;
> > +	bool pause_threshold_enabled      : 1;
> >   
> >   	u32 ldr_reg;
> >   	u32 dfr_reg;


Thanks for the review!

Best regards,
	Maxim Levitsky






