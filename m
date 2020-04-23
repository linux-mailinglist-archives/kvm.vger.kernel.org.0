Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FD511B57F4
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 11:19:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726587AbgDWJTk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 05:19:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725854AbgDWJTk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Apr 2020 05:19:40 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0074CC03C1AF;
        Thu, 23 Apr 2020 02:19:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=IF166yOm7z3m4Fk7SSrrLKAwHCMS4Qf9u239M1AvMd0=; b=NEv7cR+rgqIf2XOBxiAU9RR9Vs
        ihCjSWBaJbsum5B6R4ENT5uYOyV4ul60eCJwViQD3oNK2ivAZU/N3oEgK/n9xN8K9f9CW43fHfkgt
        hgxpQoU30ckQi9kJaAbADimpDHIBwLydqXpm8O3ccaLXNZiGOkA4tZsBPW4MyC+00xsks27Szn1AK
        pHzaKGgvAQDmJ4WQisG8qDpEdmU00Otf7jMekdWZwrjboExbQQh5ZyYCtxI5ZmGv+2cREn059gQhK
        amR13oJQKxMRq6inLqNxgqb/K5+1yN631HrSBA9pSYmVXLrrUdQTJHxpq1WaGbtJx5db0XSohzk/Q
        9aPAUTZQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jRY0n-0003XN-Qx; Thu, 23 Apr 2020 09:19:13 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 8CA4330257C;
        Thu, 23 Apr 2020 11:19:11 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 469F520C02CD2; Thu, 23 Apr 2020 11:19:11 +0200 (CEST)
Date:   Thu, 23 Apr 2020 11:19:11 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, Davidlohr Bueso <dave@stgolabs.net>,
        tglx@linutronix.de, kvm@vger.kernel.org,
        Davidlohr Bueso <dbueso@suse.de>,
        torvalds@linux-foundation.org, bigeasy@linutronix.de,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org,
        linux-mips@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
        joel@joelfernandes.org, will@kernel.org,
        kvmarm@lists.cs.columbia.edu
Subject: Re: [PATCH 4/5] kvm: Replace vcpu->swait with rcuwait
Message-ID: <20200423091911.GP20730@hirez.programming.kicks-ass.net>
References: <20200422040739.18601-1-dave@stgolabs.net>
 <20200422040739.18601-5-dave@stgolabs.net>
 <20200423094140.69909bbb@why>
 <f07f6f55-9339-04b0-3877-d3240abd6d9c@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f07f6f55-9339-04b0-3877-d3240abd6d9c@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 23, 2020 at 10:57:57AM +0200, Paolo Bonzini wrote:
> On 23/04/20 10:41, Marc Zyngier wrote:
> >>  
> >> -	if (swait_active(kvm_arch_vcpu_wq(vcpu)))
> >> +	if (rcu_dereference(kvm_arch_vpu_get_wait(vcpu)) != NULL)
> > This doesn't compile (wrong function name, and rcu_dereference takes a
> > variable). But whatever it would do if we fixed it looks dodgy. it isn't
> > the rcuwait structure that you want to dereference, but rcuwait->task
> > (we are checking whether we are called because we are blocking or being
> > preempted).
> > 
> 
> Yes, I agree.  Replacing swait with rcuwait is all good, but please make
> the API look the same first.  Just like you added prepare_to_rcuwait and
> finish_rcuwait, let's add rcuwait_active as well.
> 
> Actually let's do it like this:
> 
> 1) Davidlohr, please post only patches 1-3 to "equalize" the swait and
> rcuwait APIs.
> 
> 2) Peter, please prepare a topic branch for those, or provide Acked-by

I don't think I have anything that conflicts with this, so sure, take
the whole thing through KVM.

For 1-3 (and I'll send a small niggle for 3 right after this):

Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>

I'll keep 5 as it is unrelated.
