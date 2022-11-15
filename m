Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8963C62A198
	for <lists+kvm@lfdr.de>; Tue, 15 Nov 2022 19:57:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231247AbiKOS5U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Nov 2022 13:57:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230082AbiKOS5S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Nov 2022 13:57:18 -0500
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9084286E7
        for <kvm@vger.kernel.org>; Tue, 15 Nov 2022 10:57:17 -0800 (PST)
Date:   Tue, 15 Nov 2022 18:57:11 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1668538636;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7QB1+Pi5ihYjPOVelH2p1IvQmXrfrqBb7hAw9xGI4+s=;
        b=I1myR4ndvHoG/R+3q3YyBBw752W7c7nAptLsdp9bzz2TaXNUvXLTmSBz8RDrT1fNs4fur4
        qJ1Kt7tkmB2cUMJHbqNEnTOaVo7XEcWlyf52cXvPNkodaQCImpKorJcU3DiDrwX2BxPaE7
        3jNh9frc0of7v9Wspln4+YPOazLXBV4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Reiji Watanabe <reijiw@google.com>,
        David Matlack <dmatlack@google.com>,
        Quentin Perret <qperret@google.com>,
        Ben Gardon <bgardon@google.com>, Gavin Shan <gshan@redhat.com>,
        Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>,
        kvmarm@lists.linux.dev
Subject: Re: [PATCH v5 08/14] KVM: arm64: Protect stage-2 traversal with RCU
Message-ID: <Y3PhBwQPD5QtyRbf@google.com>
References: <20221107215644.1895162-1-oliver.upton@linux.dev>
 <20221107215644.1895162-9-oliver.upton@linux.dev>
 <Y2whaWo3SIOOMKOE@google.com>
 <Y2w98zPmtefJlNfa@google.com>
 <Y3PeyV4KIjoBBYNV@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y3PeyV4KIjoBBYNV@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 15, 2022 at 10:47:37AM -0800, Ricardo Koller wrote:
> On Wed, Nov 09, 2022 at 11:55:31PM +0000, Oliver Upton wrote:
> > On Wed, Nov 09, 2022 at 09:53:45PM +0000, Sean Christopherson wrote:
> > > On Mon, Nov 07, 2022, Oliver Upton wrote:
> > > > Use RCU to safely walk the stage-2 page tables in parallel. Acquire and
> > > > release the RCU read lock when traversing the page tables. Defer the
> > > > freeing of table memory to an RCU callback. Indirect the calls into RCU
> > > > and provide stubs for hypervisor code, as RCU is not available in such a
> > > > context.
> > > > 
> > > > The RCU protection doesn't amount to much at the moment, as readers are
> > > > already protected by the read-write lock (all walkers that free table
> > > > memory take the write lock). Nonetheless, a subsequent change will
> > > > futher relax the locking requirements around the stage-2 MMU, thereby
> > > > depending on RCU.
> > > 
> > > Two somewhat off-topic questions (because I'm curious):
> > 
> > Worth asking!
> > 
> > >  1. Are there plans to enable "fast" page faults on ARM?  E.g. to fixup access
> > >     faults (handle_access_fault()) and/or write-protection faults without acquiring
> > >     mmu_lock?
> > 
> > I don't have any plans personally.
> > 
> > OTOH, adding support for read-side access faults is trivial, I just
> > didn't give it much thought as most large-scale implementations have
> > FEAT_HAFDBS (hardware access flag management).
> 
> WDYT of permission relaxation (write-protection faults) on the fast
> path?
> 
> The benefits won't be as good as in x86 due to the required TLBI, but
> may be worth it due to not dealing with the mmu lock and avoiding some
> of the context save/restore.  Note that unlike x86, in ARM the TLB entry
> related to a protection fault needs to be flushed.

Right, the only guarantee we have on arm64 is that the TLB will never
hold an entry that would produce an access fault.

I have no issues whatsoever with implementing a lock-free walker, we're
already most of the way there with the RCU implementation modulo some
rules for atomic PTE updates. I don't believe lock acquisition is a
bounding issue for us quite yet as break-before-make + lazy splitting
hurts.

--
Thanks,
Oliver
