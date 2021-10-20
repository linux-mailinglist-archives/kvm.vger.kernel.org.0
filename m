Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3FC44349EE
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 13:18:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230117AbhJTLUX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 07:20:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbhJTLUW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Oct 2021 07:20:22 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E499C06161C;
        Wed, 20 Oct 2021 04:18:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=5d1gma0Gx7HJL4VIDWgBwU9sSwfKwX+Z9mQqWXboDEQ=; b=Tv9p/fC2CfHxRw8iroLtAddPIH
        NxwEgUzvJFgWM2trn3IRyMBePYrWCy7s0aDYBw+QOksEMafu20TeSumTYe9qw/hXr4qRIOQGE1n2m
        lAWtMgB5tyRDA2EoxECV50iHjPbqV1jK/OjUzgpvTSSb/OyoRiKOMZKSkAHRhITV1WJOoO8HXiYsn
        bzbGHuDrdIC0I4sppdCBmQa1p4ObT9MEWy4oVHa7FgCJ63iPMamGB23W7JNB3RWI2JDR2KQVpFIyT
        h05ucVKJIDc4tu/O/eO+dq50mFgAg3IwbEZjrDnA+SgerQqyjvdEMv0L1Kj07a98fl32IydK4SeRK
        8wiTzS5A==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1md9bM-00AwAQ-TH; Wed, 20 Oct 2021 11:17:45 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 08AF1300221;
        Wed, 20 Oct 2021 13:17:44 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id EA332201BB3C5; Wed, 20 Oct 2021 13:17:43 +0200 (CEST)
Date:   Wed, 20 Oct 2021 13:17:43 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Davidlohr Bueso <dave@stgolabs.net>,
        Oleg Nesterov <oleg@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Wanpeng Li <wanpengli@tencent.com>
Subject: Re: [PATCH] rcuwait: do not enter RCU protection unless a wakeup is
 needed
Message-ID: <YW/61zpycsD8/z4g@hirez.programming.kicks-ass.net>
References: <20211020110638.797389-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211020110638.797389-1-pbonzini@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 20, 2021 at 07:06:38AM -0400, Paolo Bonzini wrote:
> In some cases, rcuwait_wake_up can be called even if the actual likelihood
> of a wakeup is very low.  If CONFIG_PREEMPT_RCU is active, the resulting
> rcu_read_lock/rcu_read_unlock pair can be relatively expensive, and in
> fact it is unnecessary when there is no w->task to keep alive: the
> memory barrier before the read is what matters in order to avoid missed
> wakeups.
> 
> Therefore, do an early check of w->task right after the barrier, and skip
> rcu_read_lock/rcu_read_unlock unless there is someone waiting for a wakeup.
> 
> Running kvm-unit-test/vmexit.flat with APICv disabled, most interrupt
> injection tests (tscdeadline*, self_ipi*, x2apic_self_ipi*) improve
> by around 600 cpu cycles.

*how* ?!?

AFAICT, rcu_read_lock() for PREEMPT_RCU is:

  WRITE_ONCE(current->rcu_read_lock_nesting, READ_ONCE(current->rcu_read_lock_nesting) + 1);
  barrier();

Paul?
