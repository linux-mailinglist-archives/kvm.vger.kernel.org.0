Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5F606105C6
	for <lists+kvm@lfdr.de>; Fri, 28 Oct 2022 00:31:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235514AbiJ0WbY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 18:31:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235455AbiJ0WbW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 18:31:22 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 787F157DE2
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 15:31:20 -0700 (PDT)
Date:   Thu, 27 Oct 2022 22:31:15 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1666909879;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GW5NB8+RTKGpYs1izwEP9mB0IXmkchEi4A58SakMWcs=;
        b=SAz+URbCjnmNMltTgdDWAqtUOSNXXWz0wbOUwMMuaQN4L38TjZjE0neZdisQyK57xfF25S
        Wc9HAGblbg7HKZiAP06j3kdCX8Z5pdQz5BAxfmPsIpVK6QJBDPU6VSL1hUt3Ra48mpCJbV
        8a96aNnjz+U/wf6s+DmSBbhMLYzWvck=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Will Deacon <will@kernel.org>, kvmarm@lists.linux.dev,
        Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 07/15] KVM: arm64: Use an opaque type for pteps
Message-ID: <Y1sGs6TFh6P20ymH@google.com>
References: <20221007232818.459650-1-oliver.upton@linux.dev>
 <20221007232818.459650-8-oliver.upton@linux.dev>
 <Y1CFl8sLllXm4seK@google.com>
 <Y1EHnFN2Goj2eLkE@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y1EHnFN2Goj2eLkE@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 20, 2022 at 11:32:28AM +0300, Oliver Upton wrote:
> On Wed, Oct 19, 2022 at 11:17:43PM +0000, Sean Christopherson wrote:
> > On Fri, Oct 07, 2022, Oliver Upton wrote:

[...]

> > > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> > > index 02c33fccb178..6b6e1ed7ee2f 100644
> > > --- a/arch/arm64/kvm/hyp/pgtable.c
> > > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > > @@ -175,13 +175,14 @@ static int kvm_pgtable_visitor_cb(struct kvm_pgtable_walk_data *data,
> > >  }
> > >  
> > >  static int __kvm_pgtable_walk(struct kvm_pgtable_walk_data *data,
> > > -			      struct kvm_pgtable_mm_ops *mm_ops, kvm_pte_t *pgtable, u32 level);
> > > +			      struct kvm_pgtable_mm_ops *mm_ops, kvm_pteref_t pgtable, u32 level);
> > >  
> > >  static inline int __kvm_pgtable_visit(struct kvm_pgtable_walk_data *data,
> > >  				      struct kvm_pgtable_mm_ops *mm_ops,
> > > -				      kvm_pte_t *ptep, u32 level)
> > > +				      kvm_pteref_t pteref, u32 level)
> > >  {
> > >  	enum kvm_pgtable_walk_flags flags = data->walker->flags;
> > > +	kvm_pte_t *ptep = kvm_dereference_pteref(pteref, false);
> > >  	struct kvm_pgtable_visit_ctx ctx = {
> > >  		.ptep	= ptep,
> > >  		.old	= READ_ONCE(*ptep),
> > 
> > This is where you want the protection to kick in, e.g. 
> > 
> >   typedef kvm_pte_t __rcu *kvm_ptep_t;
> > 
> >   static inline kvm_pte_t kvm_read_pte(kvm_ptep_t ptep)
> >   {
> > 	return READ_ONCE(*rcu_dereference(ptep));
> >   }
> > 
> > 		.old	= kvm_read_pte(ptep),
> > 
> > In other words, the pointer itself isn't that's protected, it's PTE that the
> > pointer points at that's protected.
> 
> Right, but practically speaking it is the boundary at which we assert
> that protection.
> 
> Anyhow, I'll look at abstracting the actual memory accesses in the
> visitors without too much mess.

Took this in a slightly different direction after playing with it for a
while. Abstracting all PTE accesses adds a lot of churn to the series.
Adding in an assertion before invoking a visitor callback (i.e. when the
raw pointer is about to be used) provides a similar degree of assurance
that we are indeed RCU-safe.

--
Thanks,
Oliver
