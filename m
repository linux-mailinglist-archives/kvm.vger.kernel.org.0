Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0B11606B62
	for <lists+kvm@lfdr.de>; Fri, 21 Oct 2022 00:42:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbiJTWmv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 18:42:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbiJTWmt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 18:42:49 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35416222F32
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 15:42:48 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id l6so871387pgu.7
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 15:42:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FDFfzkE5dBJ5m6UqarnXclPiOYRM3ZnuG29aeElkJZ8=;
        b=UFyoF3/kPlkt8lmbdzCeNxrtN54Gvnzwlm6/jKsU5K/Mx+Zi+HwDfQ7UxBuccJHjwT
         FF/O/U0LJ81NbHXU1XqFIpc5LF3JCSeveqIRBGPN03THEGBU4v57rGEqKUjuVjhcB1i/
         p0uQl3N+4jVpvxyO3cDiPD12xRWdu5W4a5xnP0NwL7l2oJaStOFKIxqjNsbuxfb4EaN1
         y2EOtpNLG1rHsf1+Fd85K3EDV2HwKToEaOhhJAy/ivRAnwpSGtWhvw7BEQmNr0xUuPFT
         JCUJ8U+wO6kVeTWgjt+2elG8nTCDckhpxTG5vHstj5zWaeyb7w5k3EEwqOijwfqC5N2a
         bSzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FDFfzkE5dBJ5m6UqarnXclPiOYRM3ZnuG29aeElkJZ8=;
        b=kxvB7Iv+wLXaSk1+MbEC7GpTgHX6nC5IMbKLCKHhKr4DjI6OszQMnGQoFmDLlBW50o
         wlIUa5+oj6gYZOkrEkd1GJnRV7OU9PtDv5BjGL+WL3JX4bQvv+pZRZvwL+7Srph9XbB+
         FI65BxE2RTR737bTCFsD9JitIsLx8lrczwgPcR2Z8ab6arGBol/JtnsyYsferBYApC+C
         z5SxlJDGL9mXh3E0/XeYMJl6IjZuaOyY8jof7+jKUWhRuz3ysNQ+gx1u4v4w6UVjen56
         9OXRUrHQuTILDqY1x3RnJ+yX1fvn9r6+ynsdXB7pfOpRq4UxQoSaVwYVdhiCvC9RQ8av
         ko7Q==
X-Gm-Message-State: ACrzQf1imUoBa9Lr4V8Y8ztkaCfcc04nSyg9OaDf+HBmnrIz9ZDjRs7G
        BfovPsv+wphaHwGvZ0/RVjfLbgOC8wiFUQ==
X-Google-Smtp-Source: AMsMyM4JQIqv54X7L2VMODIVQcxLu8cn0BAcxLq2cfv7QyfUO4ao734HP8s0sZIrch8ZWhhpsUlCGA==
X-Received: by 2002:a63:854a:0:b0:46e:af42:ed12 with SMTP id u71-20020a63854a000000b0046eaf42ed12mr2502242pgd.510.1666305767257;
        Thu, 20 Oct 2022 15:42:47 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id m9-20020a63ed49000000b0043c7996f7f0sm12182415pgk.58.2022.10.20.15.42.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Oct 2022 15:42:46 -0700 (PDT)
Date:   Thu, 20 Oct 2022 22:42:43 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Gavin Shan <gshan@redhat.com>
Cc:     kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, peterx@redhat.com, maz@kernel.org,
        will@kernel.org, catalin.marinas@arm.com, bgardon@google.com,
        shuah@kernel.org, andrew.jones@linux.dev, dmatlack@google.com,
        pbonzini@redhat.com, zhenyzha@redhat.com, james.morse@arm.com,
        suzuki.poulose@arm.com, alexandru.elisei@arm.com,
        oliver.upton@linux.dev, shan.gavin@gmail.com
Subject: Re: [PATCH v6 1/8] KVM: x86: Introduce KVM_REQ_RING_SOFT_FULL
Message-ID: <Y1HO46UCyhc9M6nM@google.com>
References: <20221011061447.131531-1-gshan@redhat.com>
 <20221011061447.131531-2-gshan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221011061447.131531-2-gshan@redhat.com>
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

On Tue, Oct 11, 2022, Gavin Shan wrote:
> This adds KVM_REQ_RING_SOFT_FULL, which is raised when the dirty

"This" is basically "This patch", which is generally frowned upon.  Just state
what changes are being made.

> ring of the specific VCPU becomes softly full in kvm_dirty_ring_push().
> The VCPU is enforced to exit when the request is raised and its
> dirty ring is softly full on its entrance.
> 
> The event is checked and handled in the newly introduced helper
> kvm_dirty_ring_check_request(). With this, kvm_dirty_ring_soft_full()
> becomes a private function.

None of this captures why the request is being added.  I'm guessing Marc's
motivation is to avoid having to check ring on every entry, though there might
also be a correctness issue too?

It'd also be helpful to explain that KVM re-queues the request to maintain KVM's
existing uABI, which enforces the soft_limit even if no entries have been added
to the ring since the last KVM_EXIT_DIRTY_RING_FULL exit.

And maybe call out the alternative(s) that was discussed in v2[*]?

[*] https://lore.kernel.org/all/87illlkqfu.wl-maz@kernel.org

> Suggested-by: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Gavin Shan <gshan@redhat.com>
> Reviewed-by: Peter Xu <peterx@redhat.com>
> ---
>  arch/x86/kvm/x86.c             | 15 ++++++---------
>  include/linux/kvm_dirty_ring.h |  8 ++------
>  include/linux/kvm_host.h       |  1 +
>  virt/kvm/dirty_ring.c          | 19 ++++++++++++++++++-
>  4 files changed, 27 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index b0c47b41c264..0dd0d32073e7 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10260,16 +10260,13 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  
>  	bool req_immediate_exit = false;
>  
> -	/* Forbid vmenter if vcpu dirty ring is soft-full */
> -	if (unlikely(vcpu->kvm->dirty_ring_size &&
> -		     kvm_dirty_ring_soft_full(&vcpu->dirty_ring))) {
> -		vcpu->run->exit_reason = KVM_EXIT_DIRTY_RING_FULL;
> -		trace_kvm_dirty_ring_exit(vcpu);
> -		r = 0;
> -		goto out;
> -	}
> -
>  	if (kvm_request_pending(vcpu)) {
> +		/* Forbid vmenter if vcpu dirty ring is soft-full */

Eh, I'd drop the comment, pretty obvious what the code is doing

> +		if (kvm_dirty_ring_check_request(vcpu)) {

I think it makes to move this check below at KVM_REQ_VM_DEAD.  I doubt it will
ever matter in practice, but conceptually VM_DEAD is a higher priority event.

I'm pretty sure the check can be moved to the very end of the request checks,
e.g. to avoid an aborted VM-Enter attempt if one of the other request triggers
KVM_REQ_RING_SOFT_FULL.

Heh, this might actually be a bug fix of sorts.  If anything pushes to the ring
after the check at the start of vcpu_enter_guest(), then without the request, KVM
would enter the guest while at or above the soft limit, e.g. record_steal_time()
can dirty a page, and the big pile of stuff that's behind KVM_REQ_EVENT can
certainly dirty pages.

> +			r = 0;
> +			goto out;
> +		}
> +
>  		if (kvm_check_request(KVM_REQ_VM_DEAD, vcpu)) {
>  			r = -EIO;
>  			goto out;

> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -157,6 +157,7 @@ static inline bool is_error_page(struct page *page)
>  #define KVM_REQ_VM_DEAD           (1 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
>  #define KVM_REQ_UNBLOCK           2
>  #define KVM_REQ_UNHALT            3

UNHALT is gone, the new request can use '3'.

> +#define KVM_REQ_RING_SOFT_FULL    4

Any objection to calling this KVM_REQ_DIRTY_RING_SOFT_FULL?  None of the users
are in danger of having too long lines, and at first glance it's not clear that
this is specifically for the dirty ring.

It'd also give us an excuse to replace spaces with tabs in the above alignment :-)

#define KVM_REQ_TLB_FLUSH		(0 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
#define KVM_REQ_VM_DEAD			(1 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
#define KVM_REQ_UNBLOCK			2
#define KVM_REQ_DIRTY_RING_SOFT_FULL	3
#define KVM_REQUEST_ARCH_BASE		8

> @@ -149,6 +149,7 @@ int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring)
>  
>  void kvm_dirty_ring_push(struct kvm_dirty_ring *ring, u32 slot, u64 offset)
>  {
> +	struct kvm_vcpu *vcpu = container_of(ring, struct kvm_vcpu, dirty_ring);
>  	struct kvm_dirty_gfn *entry;
>  
>  	/* It should never get full */
> @@ -166,6 +167,22 @@ void kvm_dirty_ring_push(struct kvm_dirty_ring *ring, u32 slot, u64 offset)
>  	kvm_dirty_gfn_set_dirtied(entry);
>  	ring->dirty_index++;
>  	trace_kvm_dirty_ring_push(ring, slot, offset);
> +
> +	if (kvm_dirty_ring_soft_full(ring))
> +		kvm_make_request(KVM_REQ_RING_SOFT_FULL, vcpu);

Would it make sense to clear the request in kvm_dirty_ring_reset()?  I don't care
about the overhead of having to re-check the request, the goal would be to help
document what causes the request to go away.

E.g. modify kvm_dirty_ring_reset() to take @vcpu and then do:

	if (!kvm_dirty_ring_soft_full(ring))
		kvm_clear_request(KVM_REQ_RING_SOFT_FULL, vcpu);

> +}
> +
> +bool kvm_dirty_ring_check_request(struct kvm_vcpu *vcpu)
> +{
> +	if (kvm_check_request(KVM_REQ_RING_SOFT_FULL, vcpu) &&
> +		kvm_dirty_ring_soft_full(&vcpu->dirty_ring)) {

Align please,

	if (kvm_check_request(KVM_REQ_RING_SOFT_FULL, vcpu) &&
	    kvm_dirty_ring_soft_full(&vcpu->dirty_ring)) {

> +		kvm_make_request(KVM_REQ_RING_SOFT_FULL, vcpu);

A comment would be helpful to explain (a) why KVM needs to re-check on the next
KVM_RUN and (b) why this won't indefinitely prevent KVM from entering the guest.
For pretty every other request I can think of, re-queueing a request like this
will effectively hang the vCPU, i.e. this looks wrong at first glance.

> +		vcpu->run->exit_reason = KVM_EXIT_DIRTY_RING_FULL;
> +		trace_kvm_dirty_ring_exit(vcpu);
> +		return true;
> +	}
> +
> +	return false;
>  }
>  
>  struct page *kvm_dirty_ring_get_page(struct kvm_dirty_ring *ring, u32 offset)
> -- 
> 2.23.0
> 
