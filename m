Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C14563F477
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 16:47:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231975AbiLAPrC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 10:47:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231929AbiLAPrA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 10:47:00 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD648AE52
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 07:46:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669909559;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zXP0UHbjB4gS30fO8iLIvs/Qipsj+EODVXd3Gmy47d0=;
        b=Zw4a/pyUq8zeLD7dQsGB14/GaA/J4Z3uFGWdArRsYYPIJKXq7Hf64zNwkkY2nN7n43ukQC
        100QDe4lo2BgBO43scEVeJk7ywQU9pDQi+lGfgllUCeJCu4tZESQxBej9oAFjmAr9c4elS
        oruX40y+EMtDQRocmFm756etaRGf4wo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-161-BBEZ5xw_PuWZNkm-dt0ykQ-1; Thu, 01 Dec 2022 10:45:56 -0500
X-MC-Unique: BBEZ5xw_PuWZNkm-dt0ykQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 074E4101A52A;
        Thu,  1 Dec 2022 15:45:56 +0000 (UTC)
Received: from starship (unknown [10.35.206.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 85DCB40C8459;
        Thu,  1 Dec 2022 15:45:53 +0000 (UTC)
Message-ID: <00a73e8046d4ce1597b2bc0e331e6bf668d8c98d.camel@redhat.com>
Subject: Re: [PATCH] KVM: X86: set EXITING_GUEST_MODE as soon as vCPU exits
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Jon Kohler <jon@nutanix.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date:   Thu, 01 Dec 2022 17:45:52 +0200
In-Reply-To: <E3693FA8-7818-495B-9F40-42AEEE756142@nutanix.com>
References: <20221129182226.82087-1-jon@nutanix.com>
         <5162c4cbaaae8de01c77093ac005c2f5abc1d040.camel@redhat.com>
         <E3693FA8-7818-495B-9F40-42AEEE756142@nutanix.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-11-29 at 19:56 +0000, Jon Kohler wrote:
> > On Nov 29, 2022, at 2:47 PM, Maxim Levitsky <mlevitsk@redhat.com> wrote:
> > 
> > On Tue, 2022-11-29 at 13:22 -0500, Jon Kohler wrote:
> > > Set vcpu->mode to EXITING_GUEST_MODE as soon vCPU exits to reflect
> > > that we are indeed exiting guest mode, but not quite out of guest
> > > mode yet. Note: This is done lazily without an explicit memory
> > > barrier so that we do not regress the cost in the critical path
> > > of going from the exit to the exit handler.
> > > 
> > > Flip back to IN_GUEST_MODE for exits that use
> > > EXIT_FASTPATH_REENTER_GUEST, such that we are IN_GUEST_MODE upon
> > > reentry.
> > > 
> > > Changing vcpu->mode away from IN_GUEST_MODE as early as possible
> > > gives IPI senders as much runway as possible to avoid ringing
> > > doorbell or sending posted interrupt IPI in AMD and Intel,
> > > respectively. Since this is done without an explicit memory
> > > barrier, the worst case is that the IPI sender sees IN_GUEST_MODE
> > > still and sends a spurious event, which is the behavior prior
> > > to this patch.
> > 
> > Beware that we had a king sized bug in regard to AVIC inhibition races
> > vs guest entries, this this should be carefully checked for this.
> 
> Thanks, Maxim - any pointers on what we should be looking for here?

I need to swap the whole thing in to be able to comment on this one.
I'll do this next week.

Overall the problem is that the target vCPU can inhibit its AVIC at any moment,
which forces the senders to use normal KVM_REQ_EVENT + vcpu kick to deliver
it the interrupt. It is very racy.

The only other pointer I can recall now is the code at 'svm_complete_interrupt_delivery'

Best regards,
	Maxim Levitsky

> 
> > Also, do you have any perf numbers to see if that actually improves performance?
> > (I am just curious, I do think that this can improve performance).
> > 
> 
> Yes indeed! Sorry I should have put that right in the commit msg as a note,
> but using the kvm-unit-tests vmexit_ipi with -smp 20 on an Intel 8168 its
> roughly ~3% better (~3325-ish vs ~3400-ish), though the test is a bit noisy
> even with taskset to a single socket.
> 
> To help validate that we were even getting *any* benefit, in a local build
> I added a log statement (rough code below) to IPI delivery path, and did see 
> many, many IPIs getting suppressed that would have otherwise fired.
> 
> kvm_vcpu_trigger_posted_interrupt() {
> ...
>     if (vcpu->mode == EXITING_GUEST_MODE) {
>         pr_warn_ratelimited("exiting suppression worked");
>     }
> ...
> }
> 
> > Best regards,
> > 	Maxim Levitsky
> > 
> > 
> > > Signed-off-by: Jon Kohler <jon@nutanix.com>
> > > ---
> > > arch/x86/kvm/svm/svm.c |  7 +++++++
> > > arch/x86/kvm/vmx/vmx.c | 23 +++++++++++++++++++++++
> > > arch/x86/kvm/x86.c     |  8 ++++++++
> > > 3 files changed, 38 insertions(+)
> > > 
> > > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > > index ce362e88a567..5f0c118a3ffd 100644
> > > --- a/arch/x86/kvm/svm/svm.c
> > > +++ b/arch/x86/kvm/svm/svm.c
> > > @@ -3907,6 +3907,13 @@ static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu, bool spec_ctrl_in
> > > 	else
> > > 		__svm_vcpu_run(svm, spec_ctrl_intercepted);
> > > 
> > > +	/* Optimize IPI reduction by setting mode immediately after vmexit
> > > +	 * without a memmory barrier as this as not paired anywhere. vcpu->mode
> > > +	 * is will be set to OUTSIDE_GUEST_MODE in x86 common code with a memory
> > > +	 * barrier, after the host is done fully restoring various host states.
> > > +	 */
> > > +	vcpu->mode = EXITING_GUEST_MODE;
> > > +
> > > 	guest_state_exit_irqoff();
> > > }
> > > 
> > > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > > index 63247c57c72c..243dcb87c727 100644
> > > --- a/arch/x86/kvm/vmx/vmx.c
> > > +++ b/arch/x86/kvm/vmx/vmx.c
> > > @@ -5878,6 +5878,17 @@ static fastpath_t handle_fastpath_preemption_timer(struct kvm_vcpu *vcpu)
> > > 
> > > 	if (!vmx->req_immediate_exit &&
> > > 	    !unlikely(vmx->loaded_vmcs->hv_timer_soft_disabled)) {
> > > +		/* Reset IN_GUEST_MODE since we're going to reenter
> > > +		 * guest as part of this fast path. This is done as
> > > +		 * an optimization without a memory barrier since
> > > +		 * EXITING_GUEST_MODE is also set without a memory
> > > +		 * barrier. This also needs to be reset prior to
> > > +		 * calling apic_timer_expired() so that
> > > +		 * kvm_use_posted_timer_interrupt() returns the proper
> > > +		 * value.
> > > +		 */
> > > +		if (vcpu->mode == EXITING_GUEST_MODE)
> > > +			vcpu->mode = IN_GUEST_MODE;
> > > 		kvm_lapic_expired_hv_timer(vcpu);
> > > 		return EXIT_FASTPATH_REENTER_GUEST;
> > > 	}
> > > @@ -7031,6 +7042,18 @@ void noinstr vmx_update_host_rsp(struct vcpu_vmx *vmx, unsigned long host_rsp)
> > > void noinstr vmx_spec_ctrl_restore_host(struct vcpu_vmx *vmx,
> > > 					unsigned int flags)
> > > {
> > > +	struct kvm_vcpu *vcpu = &vmx->vcpu;
> > > +
> > > +	/* Optimize IPI reduction by setting mode immediately after vmexit
> > > +	 * without a memmory barrier as this as not paired anywhere. vcpu->mode
> > > +	 * is will be set to OUTSIDE_GUEST_MODE in x86 common code with a memory
> > > +	 * barrier, after the host is done fully restoring various host states.
> > > +	 * Since the rdmsr and wrmsr below are expensive, this must be done
> > > +	 * first, so that the IPI suppression window covers the time dealing
> > > +	 * with fixing up SPEC_CTRL.
> > > +	 */
> > > +	vcpu->mode = EXITING_GUEST_MODE;
> > > +
> > > 	u64 hostval = this_cpu_read(x86_spec_ctrl_current);
> > > 
> > > 	if (!cpu_feature_enabled(X86_FEATURE_MSR_SPEC_CTRL))
> > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > index 2835bd796639..0e0d228f3fa5 100644
> > > --- a/arch/x86/kvm/x86.c
> > > +++ b/arch/x86/kvm/x86.c
> > > @@ -2160,6 +2160,14 @@ fastpath_t handle_fastpath_set_msr_irqoff(struct kvm_vcpu *vcpu)
> > > 		data = kvm_read_edx_eax(vcpu);
> > > 		if (!handle_fastpath_set_tscdeadline(vcpu, data)) {
> > > 			kvm_skip_emulated_instruction(vcpu);
> > > +			/* Reset IN_GUEST_MODE since we're going to reenter
> > > +			 * guest as part of this fast path. This is done as
> > > +			 * an optimization without a memory barrier since
> > > +			 * EXITING_GUEST_MODE is also set without a memory
> > > +			 * barrier.
> > > +			 */
> > > +			if (vcpu->mode == EXITING_GUEST_MODE)
> > > +				vcpu->mode = IN_GUEST_MODE;
> > > 			ret = EXIT_FASTPATH_REENTER_GUEST;
> > > 		}
> > > 		break;


