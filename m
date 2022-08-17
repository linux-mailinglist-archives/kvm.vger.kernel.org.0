Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3019B597459
	for <lists+kvm@lfdr.de>; Wed, 17 Aug 2022 18:41:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240342AbiHQQlJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Aug 2022 12:41:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240189AbiHQQlI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Aug 2022 12:41:08 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78ED082F8E
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 09:41:06 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id jm11so10224130plb.13
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 09:41:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=+ikgV9j3l03eb081Wbda2p4MulJ7Ue+5+L1IC0y+zRw=;
        b=Xm3zYn0XXhcqlUm6XwtiUXKvfhHNTJlwJ5rOGOdeIAENS+HTDHR8MoC+gv0BJ6FfGD
         jW7eeUJEVwESibuvPt/A4l7PtNTXBTNMXGGO44s25K9ny7C8mmfzN9gPZN9CMoF95Lee
         3by231uAWxez9zWEhzG+ANfWtvjh6CGyhTTZ3GZk7/jqwz4GsVpY6GSqdZAWLGaQozGv
         M4RpuwhTP4UwCdNo+eMqiXcVD0ixxSJTKdcVqzX6rLjWQ5JV8+nlZ9fB8CMZZZ+TqazC
         DUeJQabE9GlXzf+rwmAt43fAXtP5vatJCMn8wgXYiKZER8aE4lYobMMod8nyWa3oOnFY
         qTcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=+ikgV9j3l03eb081Wbda2p4MulJ7Ue+5+L1IC0y+zRw=;
        b=wvfVyQZ9qBtvR5UOkfEr05fqpVdOOaIYTFvOe0faCenKxBpTC0Bf8nG7AvCAsazOVy
         eKrwI3fx6/g/AcJMxDLb8HJY//juKqBpXvbbTcqmQlhiOnax5tlQ3vZTg+5qPvbiyS/f
         8AU7fqo6f47SCUfwn889LS+/SlD4lDSOcTAwdYSSGFoNJMOhjxcakSOF8jUx0ETIxq7c
         hfQM3ijYpgjBU0v6NJf2gA8an0vyRKp5+VFmalce3kMWQoc/Ufboc+XcfPZ3vLTxqFOK
         NCDmM/qUXn5AFJ3dQTtXBMbIPscVfP/+kNztBxNWjIciGrlUoz6RHDEDZdJLrPxQtpt8
         k2gA==
X-Gm-Message-State: ACgBeo1C3we+Key1UHLQdRR+GcK4bHyh8Zzqj/E+fXGFgrc2fsx1Gg7B
        fEYMG0KGAruOK7nhzDnhS7kMpw==
X-Google-Smtp-Source: AA6agR5bKAhFJJYgDr81IUOVX+n51nW4MVPub70A4/x+j2SHk2CJkiB9rNZ00QaD5XiSVlzNhahDxw==
X-Received: by 2002:a17:90b:4c8d:b0:1f5:29ef:4a36 with SMTP id my13-20020a17090b4c8d00b001f529ef4a36mr4688702pjb.127.1660754466127;
        Wed, 17 Aug 2022 09:41:06 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id f8-20020a170902684800b001728ac8af94sm111593pln.248.2022.08.17.09.41.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 09:41:05 -0700 (PDT)
Date:   Wed, 17 Aug 2022 16:41:01 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        mlevitsk@redhat.com, vkuznets@redhat.com
Subject: Re: [PATCH v2 2/9] KVM: x86: remove return value of kvm_vcpu_block
Message-ID: <Yv0aHXcmuivyJDXw@google.com>
References: <20220811210605.402337-1-pbonzini@redhat.com>
 <20220811210605.402337-3-pbonzini@redhat.com>
 <Yvwpb6ofD1S+Rqk1@google.com>
 <78616cf8-2693-72cc-c2cc-5a849116ffc7@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <78616cf8-2693-72cc-c2cc-5a849116ffc7@redhat.com>
X-Spam-Status: No, score=-14.4 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 17, 2022, Paolo Bonzini wrote:
> On 8/17/22 01:34, Sean Christopherson wrote:
> > Isn't freeing up the return from kvm_vcpu_check_block() unnecessary?  Can't we
> > just do:
> > 
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 9f11b505cbee..ccb9f8bdeb18 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -10633,7 +10633,7 @@ static inline int vcpu_block(struct kvm_vcpu *vcpu)
> >                  if (hv_timer)
> >                          kvm_lapic_switch_to_hv_timer(vcpu);
> > 
> > -               if (!kvm_check_request(KVM_REQ_UNHALT, vcpu))
> > +               if (!kvm_arch_vcpu_runnable(vcpu))
> >                          return 1;
> >          }
> > 
> > 
> > which IMO is more intuitive and doesn't require reworking halt-polling (again).
> 
> This was my first idea indeed.  However I didn't like calling
> kvm_arch_vcpu_runnable() again and "did it schedule()" seemed to be a less
> interesting result from kvm_vcpu_block() (and in fact kvm_vcpu_halt() does
> not bother passing it up the return chain).

The flip side of calling kvm_arch_vcpu_runnable() again is that KVM will immediately
wake the vCPU if it becomes runnable after kvm_vcpu_check_block().  The edge cases
where the vCPU becomes runnable late are unlikely to truly matter in practice, but
on the other hand manually re-checking kvm_arch_vcpu_runnable() means KVM gets both
cases "right" (waited=true iff vCPU actually waited, vCPU awakened ASAP), whereas
squishing the information into the return of kvm_vcpu_check_block() means KVM gets
both cases "wrong" (waited=true even if schedule() was never called, vCPU left in
a non-running state even though it's runnable).

My only hesitation with calling kvm_arch_vcpu_runnable() again is that it could be
problematic if KVM somehow managed to consume the event that caused kvm_vcpu_has_events()
to return true, but I don't see how that could happen without it being a KVM bug.

Ah, and if we do go with the explicit check, it should come with a comment to call
out that KVM needs to return up the stack, e.g.

		/*
		 * If KVM stopped blocking the vCPU but the vCPU is still not
		 * runnable, then there is a pending host event of some kind,
		 * e.g. a pending signal.  Return up the stack to service the
		 * pending event without changing the vCPU's activity state.
		 */
		if (!kvm_arch_vcpu_runnable(vcpu))
			return 1;

so that we don't end combining the checks into:

	while (!kvm_arch_vcpu_runnable(vcpu)) {
		/*
		 * Switch to the software timer before halt-polling/blocking as
		 * the guest's timer may be a break event for the vCPU, and the
		 * hypervisor timer runs only when the CPU is in guest mode.
		 * Switch before halt-polling so that KVM recognizes an expired
		 * timer before blocking.
		 */
		hv_timer = kvm_lapic_hv_timer_in_use(vcpu);
		if (hv_timer)
			kvm_lapic_switch_to_sw_timer(vcpu);

		kvm_vcpu_srcu_read_unlock(vcpu);
		if (vcpu->arch.mp_state == KVM_MP_STATE_HALTED)
			kvm_vcpu_halt(vcpu);
		else
			kvm_vcpu_block(vcpu);
		kvm_vcpu_srcu_read_lock(vcpu);

		if (hv_timer)
			kvm_lapic_switch_to_hv_timer(vcpu);
	}

which looks sane, but would mean KVM never bounces out to handle whatever event
needs handling.

Side topic, usage of kvm_apic_accept_events() appears to be broken (though nothing
can trigger the bug).  If kvm_apic_accept_events() were to return an -errno, then
kvm_arch_vcpu_ioctl_run() would return '0' to userspace without updating
vcpu->run->exit_reason.  I think an easy fix is to drop the return value entirely
and then WARN if kvm_check_nested_events() returns something other than -EBUSY.

	if (is_guest_mode(vcpu)) {
		r = kvm_check_nested_events(vcpu);
		if (r < 0) {
			WARN_ON_ONCE(r != -EBUSY);
			return;
		}


