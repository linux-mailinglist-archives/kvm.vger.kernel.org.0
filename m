Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AE745ECF69
	for <lists+kvm@lfdr.de>; Tue, 27 Sep 2022 23:43:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231428AbiI0VnR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Sep 2022 17:43:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230305AbiI0VnO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Sep 2022 17:43:14 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DB8310AB3F
        for <kvm@vger.kernel.org>; Tue, 27 Sep 2022 14:43:13 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id 3so10574759pga.1
        for <kvm@vger.kernel.org>; Tue, 27 Sep 2022 14:43:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=rC06GjmhrHvd34k/0fcmKBaDkDTHh4ureNi4LBJEBWU=;
        b=WJhQQJpmL0a0hLZl8y6AKS1ZFYQs5KJ0zYGkWRDN3LLQpoVImIy9r4P9zKtJU6piOi
         SAKDqgtYF6oO5IoaKassayWfDdjFr3ImaNpToUkGVTrtGS5oPJoYM0DlgmIPaiRTkjU1
         Ti5dony0C3FLKxernqzVgkbExA0C43iakJDXJBZgeEMQdLbMwI1JmgOifBGgUfFZWmjU
         sUOOrJzM0NzUkmXUvO4XfGCAxXHqH56FVSBh/8zmZ9Foy0cluZwYnYZBekF6H0MrCe5J
         bnSoQEMsZuGZfeHgEuZlee+D4GIsCP9haLLgRMb+qK5i6QiOsroHpyMO2Wo4SI1G/JfS
         yxhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=rC06GjmhrHvd34k/0fcmKBaDkDTHh4ureNi4LBJEBWU=;
        b=AhnkfxbQnz4QdNY23I180lFn/IoUiSQekAfKBVw5sblSLpuC09B6zG/F5dc0/tgq2T
         ifG9awo9gQnQPNeHB7NwCLU+5Og9lhIfhzHqF9oJxnIkJ25rFJrS1RYI7BwBFzg4b8S0
         rIuqjuk8KUgdq8vxrkG+owzTA6AFhmPTALXtgVn5d8YbNgZLb84hfzOkejdu9GmXwhcW
         u3gQXdSIMjfXRuKRw5FDBsw4hEafHRWjiscKKnAHln6YncpgGechP2DFciKVhgMq5Mba
         77PljWi8mFXyaTYU1qQjysLC9Da2p7MCpFn0UCudFu4vuHqFnxEGLnj3HqqioyoU4HNV
         oMyw==
X-Gm-Message-State: ACrzQf3lJAmC8FFO21sUR5dJM8GDPXoLuKwII2/1VIGSEl3EbvnRy2mb
        aUS05xxB/8qFpJm8BHBz5Dbj5A==
X-Google-Smtp-Source: AMsMyM5i1NQBXCucCmm5sYdgQMTiBhQuU2rZxyb3DdFYjUldg2vdCgzP7RYut2dT0vrxL1hPFiQWZg==
X-Received: by 2002:a65:6e8c:0:b0:435:144e:445e with SMTP id bm12-20020a656e8c000000b00435144e445emr26953745pgb.96.1664314992602;
        Tue, 27 Sep 2022 14:43:12 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id 5-20020a170902c20500b00176d347e9a7sm2036036pll.233.2022.09.27.14.43.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 14:43:11 -0700 (PDT)
Date:   Tue, 27 Sep 2022 21:43:08 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Chao Gao <chao.gao@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, jon@nutanix.com,
        kevin.tian@intel.com, Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC v2] KVM: x86/vmx: Suppress posted interrupt notification
 when CPU is in host
Message-ID: <YzNubGQf0yvODjZC@google.com>
References: <20220923085806.384344-1-chao.gao@intel.com>
 <YzHRKO1v5N/BIQl6@google.com>
 <YzKZExaU2k7qfcS9@gao-cwp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YzKZExaU2k7qfcS9@gao-cwp>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 27, 2022, Chao Gao wrote:
> On Mon, Sep 26, 2022 at 04:19:52PM +0000, Sean Christopherson wrote:
> >On Fri, Sep 23, 2022, Chao Gao wrote:
> >> it is pointless to update PID.NV to wakeup vector since notification is
> >> anyway suppressed. And since PID.SN should be already set for running
> >> vCPUs, so, don't set it again for preempted vCPUs.
> >
> >I'm pretty sure this is wrong.  If the vCPU is preempted between prepare_to_rcuwait()
> >and schedule(), then skipping pi_enable_wakeup_handler() will hang the guest if
> >the wakeup event is a posted IRQ and the event arrives while the vCPU is preempted.
> 
> Thanks for pointing out this subtle case.
> 
> My understanding is finally there will be a call of vmx_vcpu_pi_put()
> with preempted=false (I assume that preempted vCPUs will be scheduled
> at some later point). In that case, pi_enable_wakeup_handler() can wake
> up the vCPU by sending a self-ipi. Plus this patch checks PIR instead of
> ON bit, I don't get why the guest will hang.

Ah, I forgot about the addition of the pi_is_pir_empty() check.  I think I was
hoping/assuming that check would go away when I wrote the above.

> >> When IPI virtualization is enabled, this patch increases "perf bench" [*]
> >> by 6.56%, and PIN count in 1 second drops from tens of thousands to
> >> hundreds. But cpuid loop test shows this patch causes 1.58% overhead in
> >> VM-exit round-trip latency.
> >
> >The overhead is more than likely due to pi_is_pir_empty() in the VM-Entry path,
> >i.e. should in theory go away if PID.SN is clear/set at IN_GUEST_MODE and
> >OUTSIDE_GUEST_MODE
> 
> I will collect perf data after implementing what you suggested.
> 
> >
> >> Also honour PID.SN bit in vmx_deliver_posted_interrupt().
> >
> >Why?
> 
> VT-d hardware doesn't set ON bit if SN bit is set.
> 
> Enforce the same rule in KVM can skip unnecessary work, like the
> following pi_test_and_set_on() and kvm_vcpu_trigger_posted_interrupt().

But in all likelihood it's a net negative.  IMO, ideally posted interrupts would
set ON=1 even if SN=1 (or have another "PI pending" bit if necessary).

In the optimal case, where the vCPU is IN_GUEST_MODE, it's completely unnecessary.
If IN_GUEST_MODE isn't set, then setting ON=1 is likely a net positive, because
it will allow KVM to avoid checking all of PIR when clearing SN, i.e. KVM can
optimize those paths to:

	if (!pi_test_on(&vmx->pi_desc) && !pi_is_pir_empty(&vmx->pi_desc))
		pi_set_on(&vmx->pi_desc);
	    
> >> When IPI virtualization is enabled, this patch increases "perf bench" [*]
> >> by 6.56%, and PIN count in 1 second drops from tens of thousands to
> >> hundreds. But cpuid loop test shows this patch causes 1.58% overhead in
> >> VM-exit round-trip latency.
> >> 
> >> [*] test cmd: perf bench sched pipe -T. Note that we change the source
> >> code to pin two threads to two different vCPUs so that it can reproduce
> >> stable results.
> >> 
> >> Signed-off-by: Chao Gao <chao.gao@intel.com>
> >> ---
> >> RFC: I am not sure whether the benefits outweighs the extra VM-exit cost.
> >> 
> >> Changes in v2 (addressed comments from Kevin):
> >> - measure/estimate the impact to non-IPC-intensive cases
> >> - don't tie PID.SN to vcpu->mode. Instead, clear PID.SN
> >>   right before VM-entry and set it after VM-exit.
> >
> >Ah, sorry, missed v1.  Rather than key off of IN_GUEST_MODE in the sync path, add
> >an explicit kvm_x86_ops hook to perform the transition.  I.e. make it explict.
> 
> It is ok to add a separate hook. But the question is how to coordinate clearing
> SN with ->sync_pir_to_irr(). Clearing SN bit may put PIR in a state where ON/SN
> are cleared but some outstanding IRQs left there. Current ->sync_pir_to_irr()
> doesn't sync those IRQs to IRR in this case.
>
> Here are two options to fix the problem:
> 
> 1) clear SN with the new hook, then set ON bit if there is any outstanding IRQ.
> No change to ->sync_pir_to_irr() is needed.
> 
> 2) clear SN with the new hook, add a force mode to ->sync_pir_to_irr() where
> PIR is synced to IRR regardless of ON/SN bits, inovke ->sync_pir_to_irr()
> on VM-entry path with force_mode=true.
>
> Both may lead to an extra check of PIR.

  3) Unconditionally set ON when clearing SN in the VM-Enter path.

#3 it's a little gross, but it would avoid the "extra" pi_is_pir_empty().

I don't like #2 because it bleeds the logic into common x86, whereas #1 and #3
keep everything in the PI code.

My vote would be #1, and only do #3 if the overhead of #1 is really truly necessary
for performance reasons.  #1 effectively optimizes for not having a pending posted
IRQ, while #3 optimizes for having a pending posted IRQ _without ON=1.  And #1 can
be optimized to scrub the PIR if and only if ON=0.

More importantly, if we go with #1, then we can use the same hook for the
->vcpu_blocking() hook.  More below.

> >> @@ -101,11 +95,16 @@ void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu)
> >>  		new.control = old.control;
> >>  
> >>  		/*
> >> -		 * Clear SN (as above) and refresh the destination APIC ID to
> >> -		 * handle task migration (@cpu != vcpu->cpu).
> >> +		 * Set SN and refresh the destination APIC ID to handle
> >> +		 * task migration (@cpu != vcpu->cpu).
> >> +		 *
> >> +		 * SN is cleared when a vCPU goes to blocked state so that
> >> +		 * the blocked vCPU can be waken up on receiving a
> >> +		 * notification. For a running/runnable vCPU, such
> >> +		 * notifications are useless. Set SN bit to suppress them.
> >>  		 */
> >>  		new.ndst = dest;
> >> -		new.sn = 0;
> >> +		new.sn = 1;
> >
> >To handle the preempted case, I believe the correct behavior is to leave SN
> >as-is, although that would require setting SN=1 during vCPU creation.  Arguably
> >KVM should do that anyways when APICv is enabled.
> >
> >Hmm, or alternatively this should do the same?
> >
> >		new.sn = !kvm_vcpu_is_blocking();
> 
> I don't get this. Probably I am misunderstanding something about vCPU preemption.

Ignore the this, I was deep down a path of stuff that I'm pretty sure ends up being
irrelevant.

> >> @@ -172,8 +160,10 @@ static void pi_enable_wakeup_handler(struct kvm_vcpu *vcpu)
> >>  	 * enabled until it is safe to call try_to_wake_up() on the task being
> >>  	 * scheduled out).
> >>  	 */
> >> -	if (pi_test_on(&new))
> >> +	if (!pi_is_pir_empty(pi_desc)) {
> >> +		pi_set_on(pi_desc);
> >
> >As much as I wish we could get rid of kvm_arch_vcpu_blocking(), I actually think
> >this would be a good application of that hook.  If PID.SN is cleared during
> >kvm_arch_vcpu_blocking() and set during kvm_arch_vcpu_unblocking(), then I believe
> >there's no need to manually check the PIR here, as any IRQ that isn't detected by
> >kvm_vcpu_check_block() is guaranteed to set PID.ON=1.
> 
> Using kvm_arch_vcpu_blocking() has the same problem as using a new hook
> for the VM-entry path: we need a force mode for ->sync_pir_to_irr() or
> set ON bit if there is any outstanding IRQ right after clearing SN
>
> The former may help performance a little but since the call of
> ->sync_pir_to_irr() in kvm_vcpu_check_block() is so far away from the
> place where SN is cleared, I think this would be a source of bugs.
> 
> The latter has no benefit compared to what this patch does here.

The benefits I see are:

  1. The code is very explicit.  When clearing SN, check PIR and set ON=1 to
     ensure IRQs aren't ignored.

  2. pi_enable_wakeup_handler() is only responsible for changing the vector,
     i.e. there's no clearing of SN "hidden" in the CMPXCHG loop.

  3. Same for vmx_vcpu_pi_load(), it's only responsible for updating the pCPU
     and the vector, it doesn't touch SN.

  4. The logic is common to all paths that clear SN, i.e. the same helper can
     be used for both VM-Enter and vCPU blocking.

E.g. the VMX hook for both VM-Enter and vCPU blocking could be:

  static void vmx_no_idea_what_to_call_this(struct kvm_vcpu *vcpu)
  {
	pi_clear_sn(&vmx->pi_desc);

	/*
	 * Clear SN before reading the bitmap.  The VT-d firmware writes the
	 * bitmap and reads SN atomically (5.2.3 in the spec), so it doesn't
	 * really have a memory barrier that pairs with this, but we cannot do
	 * that and we need one.
	 */
	smp_mb__after_atomic();

	/* blah blah blah */
	if (!pi_test_on(&vmx->pi_desc) && !pi_is_pir_empty(&vmx->pi_desc))
		pi_set_on(&vmx->pi_desc);
  }

One related thought thing I want to capture:

The proposed approach is having vmx_sync_pir_to_irr() check PIR if ON=1 || SN=1
is effectively _required_ to avoid breaking halt-polling.  I was thinking we could
keep that path optimized to check only ON=1, but with that approach, KVM won't detect
the pending IRQ until it actually starts to block the vCPU, i.e. until it clears SN
and manually checks the PIR.  Clearing SN in kvm_arch_vcpu_pending() would be better
than waiting until the vCPU is "put", but even that is too late from a halt-polling
perspective.

A comment in vmx_sync_pir_to_irr() is likely needed to capture that.
