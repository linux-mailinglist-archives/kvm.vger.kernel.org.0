Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6888B770BF3
	for <lists+kvm@lfdr.de>; Sat,  5 Aug 2023 00:30:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229715AbjHDWa3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Aug 2023 18:30:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbjHDWa2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Aug 2023 18:30:28 -0400
Received: from mail-oi1-x249.google.com (mail-oi1-x249.google.com [IPv6:2607:f8b0:4864:20::249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE4D1E42
        for <kvm@vger.kernel.org>; Fri,  4 Aug 2023 15:30:26 -0700 (PDT)
Received: by mail-oi1-x249.google.com with SMTP id 5614622812f47-3a1c2d69709so3948343b6e.1
        for <kvm@vger.kernel.org>; Fri, 04 Aug 2023 15:30:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691188226; x=1691793026;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bFzzUD1s8YBHblwI04VOeCdWAbdee3I5YnQWnVOxvpo=;
        b=TFcn4WhuF59CuOFW+nA/rZmm0UJ9lmliU/kzI0ZppRYE7sDBYkerAuHzzRxdX3d7+X
         4kzLTKYNiq3+tnYZLXIkLwujJLcAX9xlXFF7P6HucTbVVv4htw7jc7Fx1odjOorNhcMK
         dodd2vDxN7Iv863IP8Ul0VCeKTSNeqWflaPt3PPJv7+5ayDRQWhkgJ+D3K75dcAoYxtZ
         WPhu6CqDtddYxxH4dTGFYTkyLBsWJw8IjQxufeXxzFdyCgNiKmvISMu1mHITGEKHgkkb
         HhwXF5timTSNjIo6jS4S4vsYjZPe1ZaATLPhRP8kRuAhbSLipOJg1Qe8hXm34hNZJUIk
         0cUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691188226; x=1691793026;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bFzzUD1s8YBHblwI04VOeCdWAbdee3I5YnQWnVOxvpo=;
        b=dR/PpIK/5Y07+FDs/JORgaBukEwDK0H8qaijuPm/2iVPNdOTO3JkL1B7YrzltmWA0U
         6Bp41A94GZBkyxpJKIrAE/sfquTjE9YG38gwT/HgXxhY6d/t8eM71NRL+z+yzDVRAazk
         DHQYLY89RpnK9Y7GsTDATkvAGVDvw9StF5Bk83HnqKDW2KSVGDyQmFu/SK8qWfovUjKt
         W+PgpQQrYLn2f/+cUdvgz5BAZuTg+GxnwKW/FlZYucGL3JUhBf1a5NU66isW5/2Zq7WE
         ePWX7AsPb68BBaXHUZYfDpqVPKBoHuvk1AChcTqvx1Hnbi7Z+VRuXpG3RvUX2jNS+t7j
         KILA==
X-Gm-Message-State: AOJu0YyMrsVmccYwMwSutPEd1WILxa0ugVbeAcMLKwoKueG7/Jp8WUYM
        hBvYdU484tFafwg5HtY1C6fSkkq0NMc=
X-Google-Smtp-Source: AGHT+IG/f7h4NBFD7Fzz9VqAMwBIHPfIp5Oxxm2+KkdFX36TNY82jUIYr8jbB4mGvNrT4WJJhTCK/9o3DZg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6808:198b:b0:3a7:75cd:df61 with SMTP id
 bj11-20020a056808198b00b003a775cddf61mr4531539oib.5.1691188226241; Fri, 04
 Aug 2023 15:30:26 -0700 (PDT)
Date:   Fri, 4 Aug 2023 15:30:24 -0700
In-Reply-To: <20230705080756.xv7fm3jxewipunvn@linux.intel.com>
Mime-Version: 1.0
References: <20230704075054.3344915-1-stevensd@google.com> <20230704075054.3344915-5-stevensd@google.com>
 <20230705080756.xv7fm3jxewipunvn@linux.intel.com>
Message-ID: <ZM18AAFj21Fo36hg@google.com>
Subject: Re: [PATCH v7 4/8] KVM: x86/mmu: Migrate to __kvm_follow_pfn
From:   Sean Christopherson <seanjc@google.com>
To:     Yu Zhang <yu.c.zhang@linux.intel.com>
Cc:     David Stevens <stevensd@chromium.org>,
        Marc Zyngier <maz@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Peter Xu <peterx@redhat.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 05, 2023, Yu Zhang wrote:
> On Tue, Jul 04, 2023 at 04:50:49PM +0900, David Stevens wrote:
> > From: David Stevens <stevensd@chromium.org>
> > 
> > Migrate from __gfn_to_pfn_memslot to __kvm_follow_pfn.

Please turn up your changelog verbosity from ~2 to ~8.  E.g. explain the transition
from async => FOLL_NOWAIT+KVM_PFN_ERR_NEEDS_IO, there's no reason to force readers
to suss that out on their own.

> > Signed-off-by: David Stevens <stevensd@chromium.org>
> > ---
> >  arch/x86/kvm/mmu/mmu.c | 35 +++++++++++++++++++++++++----------
> >  1 file changed, 25 insertions(+), 10 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index ec169f5c7dce..e44ab512c3a1 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -4296,7 +4296,12 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
> >  static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> >  {
> >  	struct kvm_memory_slot *slot = fault->slot;
> > -	bool async;
> > +	struct kvm_follow_pfn foll = {
> > +		.slot = slot,
> > +		.gfn = fault->gfn,
> > +		.flags = FOLL_GET | (fault->write ? FOLL_WRITE : 0),
> > +		.allow_write_mapping = true,
> > +	};
> >  
> >  	/*
> >  	 * Retry the page fault if the gfn hit a memslot that is being deleted
> > @@ -4325,12 +4330,14 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
> >  			return RET_PF_EMULATE;
> >  	}
> >  
> > -	async = false;
> > -	fault->pfn = __gfn_to_pfn_memslot(slot, fault->gfn, false, false, &async,
> > -					  fault->write, &fault->map_writable,
> > -					  &fault->hva);
> > -	if (!async)
> > -		return RET_PF_CONTINUE; /* *pfn has correct page already */
> > +	foll.flags |= FOLL_NOWAIT;
> > +	fault->pfn = __kvm_follow_pfn(&foll);
> > +
> > +	if (!is_error_noslot_pfn(fault->pfn))
> > +		goto success;
> > +
> > +	if (fault->pfn != KVM_PFN_ERR_NEEDS_IO)
> > +		return RET_PF_CONTINUE;
> 
> IIUC, FOLL_NOWAIT is set only when we wanna an async fault. So
> KVM_PFN_ERR_NEEDS_IO may not be necessary? 

But FOLL_NOWAIT is set above.  This logic is essentially saying "bail immediately
if __gfn_to_pfn_memslot() returned a fatal error".

A commented would definitely be helpful though.  How about?

	/*
	 * If __kvm_follow_pfn() failed because I/O is needed to fault in the
	 * page, then either set up an asynchronous #PF to do the I/O, or if
	 * doing an async #PF isn't possible, retry __kvm_follow_pfn() with
	  I/O allowed. All other failures are fatal, i.e. retrying won't help.
	 */
	if (fault->pfn != KVM_PFN_ERR_NEEDS_IO)
		return RET_PF_CONTINUE;
