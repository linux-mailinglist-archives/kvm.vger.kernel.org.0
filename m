Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5E767262CF
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 16:30:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240770AbjFGOaW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 10:30:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241123AbjFGOaI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 10:30:08 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE15110DE
        for <kvm@vger.kernel.org>; Wed,  7 Jun 2023 07:30:06 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-51f7638a56fso6913493a12.3
        for <kvm@vger.kernel.org>; Wed, 07 Jun 2023 07:30:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686148206; x=1688740206;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DRgyzVKGCvMw/q3nuqjtgG4N4w0GjLMDNuDTOrtLH68=;
        b=ygSd1D2Ibu6sM5/ueCqe1pCA8x9jH581VPCXUXR/ZZ09ovFXLqEnse7t91U5ldpcK9
         0ytCW+q6gbxANgFnybq86Js100pXu5JD4G25NHAUBftINbwmIzlpQP0XtwaGpprVzcOE
         gfv83APbZzNmfthv2sK/Rk+sTrAK444m51elu6ElIsqRzkAFbVZj8fphj4QrWP8EZ1LI
         lxUm3HWLvWYNGqm03KoUqtJRKAww5CU0MGgnptQilDrwVnZOjctOVe7E3TyVevesqgyW
         3HllKGyug6OHxMvpX43dE2oLd1RIlHFI9Nr2p1qtvpbM3eqxNgev8ASkV/JXUvj5I/z2
         704g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686148206; x=1688740206;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DRgyzVKGCvMw/q3nuqjtgG4N4w0GjLMDNuDTOrtLH68=;
        b=hxQGhZ6JHoS6dp5B8f9rsSSvT7ec3gxsagHjQEr3irOPnV5noa62KUFNRTxp+Q3oEI
         WWoso6QrVBbVb87gzt4z5bZhjtC8Hm4Kbws72LYI7hUUXu8DrVMbBdJvBXxEZsERoXD8
         PMMUfIvueFJPHNsKJyK6AFF//I9SS1GE29LVkx5oOOwnvuxTro9sXQfWOCOi+PIbBMmp
         QROVqvJEDR9Srgd3YyrHZRBF7WFK7zBWGIliMNOE6kVYcawJhOmOyCM973bIRe3KILGu
         lcirOIE/vjcvRXTR7/ypoUN6s9ktIrKi+jXF3nyh9zCe6ILo2WQlP/ZoLn/eJGGqezDd
         agqA==
X-Gm-Message-State: AC+VfDwnmuFbHnx8hj1TGyGNbW0+d7dNhS3JgNXUe6Pf1yGGVMB1+4UK
        KWEtsDief8MkT0sOWVMSDBjQku7sj8M=
X-Google-Smtp-Source: ACHHUZ7I80I2uZ3YcoemVBwNBPFwMJ3g3JfQPiNCnJscn+mrts1zvp3uPbTwQvdKepWDPfI0pvu6hfokOOw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:5c11:0:b0:53f:2668:2bd3 with SMTP id
 q17-20020a635c11000000b0053f26682bd3mr1168127pgb.7.1686148206250; Wed, 07 Jun
 2023 07:30:06 -0700 (PDT)
Date:   Wed, 7 Jun 2023 07:30:04 -0700
In-Reply-To: <20230607073728.vggwcoylibj3cp6s@linux.intel.com>
Mime-Version: 1.0
References: <20230602011518.787006-1-seanjc@google.com> <20230602011518.787006-2-seanjc@google.com>
 <20230607073728.vggwcoylibj3cp6s@linux.intel.com>
Message-ID: <ZICUbIF2+Cvbb9GM@google.com>
Subject: Re: [PATCH 1/3] KVM: VMX: Retry APIC-access page reload if
 invalidation is in-progress
From:   Sean Christopherson <seanjc@google.com>
To:     yu.c.zhang@linux.intel.com
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
        Alistair Popple <apopple@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 07, 2023, yu.c.zhang@linux.intel.com wrote:
> On Thu, Jun 01, 2023 at 06:15:16PM -0700, Sean Christopherson wrote:
> > +	pfn = gfn_to_pfn_memslot(slot, gfn);
> > +	if (is_error_noslot_pfn(pfn))
> > +		return;
> > +
> > +	read_lock(&vcpu->kvm->mmu_lock);
> > +	if (mmu_invalidate_retry_hva(kvm, mmu_seq,
> > +				     gfn_to_hva_memslot(slot, gfn))) {
> > +		kvm_make_request(KVM_REQ_APIC_PAGE_RELOAD, vcpu);
> 
> Are the mmu_invalidate_retry_hva() and the following request meant to stall
> the vCPU if there's on going invalidation? 

Yep.

> If yes, may I ask how would the vCPU be stalled?
> 
> Below are my understandings and confusions about this process. I must have
> missed something, waiting to be educated... :) 
> 
> When the backing page of APIC access page is to be reclaimed:
> 1> kvm_mmu_notifier_invalidate_range_start() -> __kvm_handle_hva_range() will
> increase the kvm->mmu_invalidate_in_progress and account the start/end of this
> page in kvm_mmu_invalidate_begin().
> 2> And then kvm_unmap_gfn_range() will zap the TDP, and send the request,
> KVM_REQ_APIC_PAGE_RELOAD, to all vCPUs.
> 3> While a vCPU tries to reload the APIC access page before entering the guest,
> kvm->mmu_invalidate_in_progress will be checked in mmu_invalidate_retry_hva(),
> but it is possible(or is it?) that the kvm->mmu_invalidate_in_progess is still
> positive, so KVM_REQ_APIC_PAGE_RELOAD is set again. No reload, and no TLB flush.
> 4> So what if the vCPU resumes with KVM_REQ_APIC_PAGE_RELOAD & KVM_REQ_TLB_FLUSH
> flags being set, yet APIC access page is not reloaded and TLB is not flushed? Or,
> will this happen?

Pending requests block KVM from actually entering the guest.  If a request comes
in after vcpu_enter_guest()'s initial handling of requests, KVM will bail before
VM-Enter and go back through the entire "outer" run loop.

This isn't necessarily the most efficient way to handle the stall, e.g. KVM does
a fair bit of prep for VM-Enter before detecting the pending request.  The
alternative would be to have kvm_vcpu_reload_apic_access_page() return value
instructing vcpu_enter_guest() whether to bail immediately or continue on.  I
elected for the re-request approach because (a) it didn't require redefining the
kvm_x86_ops vendor hook, (b) this should be a rare situation and not performance
critical overall, and (c) there's no guarantee that bailing immediately would
actually yield better performance from the guest's perspective, e.g. if there are
other pending requests/work, then the KVM can handle those items while the vCPU
is stalled instead of waiting until the invalidation completes to proceed.

> One more dumb question - why does KVM not just pin the APIC access page?

Definitely not a dumb question, I asked myself the same thing multiple times when
looking at this :-)  Pinning the page would be easier, and KVM actually did that
in the original implementation.  The issue is in how KVM allocates the backing
page.  It's not a traditional kernel allocation, but is instead anonymous memory
allocated by way of vm_mmap(), i.e. for all intents and purposes it's a user
allocation.  That means the kernel expects it to be a regular movable page, e.g.
it's entirely possible the page (if it were pinned) could be the only page in a
2MiB chunk preventing the kernel from migrating/compacting and creating a hugepage.

In hindsight, I'm not entirely convinced that unpinning the page was the right
choice, as it resulted in a handful of nasty bugs.  But, now that we've fixed all
those bugs (knock wood), there's no good argument for undoing all of that work.
Because while the code is subtle and requires hooks in a few paths, it's not *that*
complex and for the most part doesn't require active maintenance.

static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
{
	if (kvm_request_pending(vcpu)) {  <= check if any request is pending

		if (kvm_check_request(KVM_REQ_APIC_PAGE_RELOAD, vcpu))
			kvm_vcpu_reload_apic_access_page(vcpu); <= re-requests APIC_PAGE_RELOAD

                ...
	}

	...

	preempt_disable();

	static_call(kvm_x86_prepare_switch_to_guest)(vcpu);

        <host => guest bookkeeping>

	if (kvm_vcpu_exit_request(vcpu)) {  <= detects the new pending request
		vcpu->mode = OUTSIDE_GUEST_MODE;
		smp_wmb();
		local_irq_enable();
		preempt_enable();
		kvm_vcpu_srcu_read_lock(vcpu);
		r = 1;
		goto cancel_injection;  <= bails from actually entering the guest
	}

	if (req_immediate_exit) {
		kvm_make_request(KVM_REQ_EVENT, vcpu);
		static_call(kvm_x86_request_immediate_exit)(vcpu);
	}

	for (;;) {
		<inner run / VM-Enter loop>
	}

	<VM-Exit path>

	r = static_call(kvm_x86_handle_exit)(vcpu, exit_fastpath);
	return r;

cancel_injection:
	if (req_immediate_exit)
		kvm_make_request(KVM_REQ_EVENT, vcpu);
	static_call(kvm_x86_cancel_injection)(vcpu);
	if (unlikely(vcpu->arch.apic_attention))
		kvm_lapic_sync_from_vapic(vcpu);
out:
	return r;
}
