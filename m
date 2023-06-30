Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D21A7444FA
	for <lists+kvm@lfdr.de>; Sat,  1 Jul 2023 00:56:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231324AbjF3W4T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jun 2023 18:56:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjF3W4R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jun 2023 18:56:17 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8D6F2D69
        for <kvm@vger.kernel.org>; Fri, 30 Jun 2023 15:56:16 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id 98e67ed59e1d1-260cb94f585so2090629a91.0
        for <kvm@vger.kernel.org>; Fri, 30 Jun 2023 15:56:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1688165776; x=1690757776;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Y+QnFBcSRBuOpb7/7NCuCNZ3hM36J3/pYWSX0Cwatlw=;
        b=S0waF408wufglvxMeJmrbw1kI/mjgD/oT5sEf/q15auZfk2dybtZV4SIAd53uc2cTx
         jO6Ed7ldXcWOFosmsIjCZ+0C0Ic76XRyuMC8wmnPjcTfNl2AEHXdVFslCM8N+43wP/Qy
         tVMAwGwYSnuK2V6QPEmgJZqhzDTucNSH8z5LbwRRikUjoiQQ/pZJx0Do/7xrXqBxALPa
         TAovJI94lsrzduMH/H8lnybCqIsA1bmP+XsEFssM7dMqWGJkN+xHMFv8ptCa1dJ8JuUr
         SakB0OMT6IwT+4QRca8Krzdf34Z5IDdUi3ZddEIrkd/LSd90ptqRefG5bYGWsm7mCSbf
         /+zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688165776; x=1690757776;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Y+QnFBcSRBuOpb7/7NCuCNZ3hM36J3/pYWSX0Cwatlw=;
        b=gk1UVRpJlCvTN1KTd/Zo5gUXGRdISRcFYdgcmDA37JgsIR/oN7FhusspkL8Ehh4UKB
         4Xo8j9US2UyFyWY4yWTdLnM7jFkvS3SrOtgvWxrT/DkgXqnAhYpKeNHwUVbdydHpsWPA
         gTHsOAXQGJoGHxaAc6nnNQ2ku2R1PRXiVkYI1QQRCHcPXbQZsThlSXckb2xP0vd2jX7i
         B3UWjbWVu2fnco7qIcpvEeFWvYE9GpkvCmaJv1+RZ1ZJ0XlvJEgPF2uMoAWC0WQgTMS2
         6f661eyJnTZSdYHjKjrWZeK79t/bnWURacZcaXsV6PRbratSguvMyHr1vM46rHghyp2g
         18EQ==
X-Gm-Message-State: AC+VfDynaQy+BUi2x75S05RTwOuBxNk/UczrICjxh7d2yjlHXSFxhdP9
        WFSmMxaBqDaPH1jug5lIP1OyBBS0x0M=
X-Google-Smtp-Source: ACHHUZ7iPNwIykcY15LNzA+wFLMyr203vVFrF8aE2GhoGO8tUKRF6R2KJm2aQ5+nXurVT5iyhkPHkiH6wak=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:164f:b0:263:1117:32da with SMTP id
 il15-20020a17090b164f00b00263111732damr4394158pjb.2.1688165776199; Fri, 30
 Jun 2023 15:56:16 -0700 (PDT)
Date:   Fri, 30 Jun 2023 15:56:14 -0700
In-Reply-To: <ZJ6rBwy9p5bbdWrs@chao-email>
Mime-Version: 1.0
References: <20230630072612.1106705-1-aiqi.i7@bytedance.com> <ZJ6rBwy9p5bbdWrs@chao-email>
Message-ID: <ZJ9djqQZWSEjJlfb@google.com>
Subject: Re: [PATCH] kvm/x86: clear hlt for intel cpu when resetting vcpu
From:   Sean Christopherson <seanjc@google.com>
To:     Chao Gao <chao.gao@intel.com>
Cc:     Qi Ai <aiqi.i7@bytedance.com>, pbonzini@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, kvm@vger.kernel.org,
        fengzhimin@bytedance.com, cenjiahui@bytedance.com,
        fangying.tommy@bytedance.com, dengqiao.joey@bytedance.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

mn Fri, Jun 30, 2023, Chao Gao wrote:
> On Fri, Jun 30, 2023 at 03:26:12PM +0800, Qi Ai wrote:
> >+				!is_protmode(vcpu))
> >+			kvm_x86_ops.clear_hlt(vcpu);
> 
> Use static_call_cond(kvm_x86_clear_hlt)(vcpu) instead.
> 
> It looks incorrect that we add this side-effect heuristically here. I

Yeah, adding heuristics to KVM_SET_REGS isn't happening.  KVM's existing hack
for "Older userspace" in __set_sregs_common() is bad enough:

	/* Older userspace won't unhalt the vcpu on reset. */
	if (kvm_vcpu_is_bsp(vcpu) && kvm_rip_read(vcpu) == 0xfff0 &&
	    sregs->cs.selector == 0xf000 && sregs->cs.base == 0xffff0000 &&
	    !is_protmode(vcpu))
		vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;

> am wondering if we can link vcpu->arch.mp_state to VMCS activity state,

Hrm, maybe.

> i.e., when mp_state is set to RUNNABLE in KVM_SET_MP_STATE ioctl, KVM
> sets VMCS activity state to active.

Not in the ioctl(), there needs to be a proper set of APIs, e.g. so that the
existing hack works, and so that KVM actually reports out to userspace that a
vCPU is HALTED if userspace gained control of the vCPU, e.g. after an IRQ exit,
while the vCPU was HALTED.  I.e. mp_state versus vmcs.ACTIVITY_STATE needs to be
bidirectional, not one-way.  E.g. if a vCPU is live migrated, I'm pretty sure
vmcs.ACTIVITY_STATE is lost, which is wrong.

The downside is that if KVM propagates vmcs.ACTIVITY_STATE to mp_state for the
halted case, then KVM will enter kvm_vcpu_halt() instead of entering the guest
in halted state, which is undesirable.   Hmm, that can be handled by treating
the vCPU as running, e.g. 

static inline bool kvm_vcpu_running(struct kvm_vcpu *vcpu)
{
	return (vcpu->arch.mp_state == KVM_MP_STATE_RUNNABLE ||
		(vcpu->arch.mp_state == KVM_MP_STATE_HALTED &&
		 kvm_hlt_in_guest(vcpu->kvm))) &&
	       !vcpu->arch.apf.halted);
}

but that would have cascading effect to a whole pile of things.  I don't *think*
they'd be used with kvm_hlt_in_guest(), but we've had weirder stuff.

I'm half tempted to solve this particular issue by stuffing vmcs.ACTIVITY_STATE on
shutdown, similar to what SVM does on shutdown interception.  KVM doesn't come
anywhere near faithfully emulating shutdown, so it's unlikely to break anything.
And then the mp_state vs. hlt_in_guest coulbe tackled separately.  Ugh, but that
wouldn't cover a synthesized KVM_REQ_TRIPLE_FAULT.

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 44fb619803b8..ee4bb37067d1 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5312,6 +5312,8 @@ static __always_inline int handle_external_interrupt(struct kvm_vcpu *vcpu)
 
 static int handle_triple_fault(struct kvm_vcpu *vcpu)
 {
+       vmcs_write32(GUEST_ACTIVITY_STATE, GUEST_ACTIVITY_ACTIVE);
+
        vcpu->run->exit_reason = KVM_EXIT_SHUTDOWN;
        vcpu->mmio_needed = 0;
        return 0;


I don't suppose QEMU can to blast INIT at all vCPUs for this case?
