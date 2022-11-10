Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C18D7623B5A
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 06:39:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231387AbiKJFjC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Nov 2022 00:39:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229803AbiKJFjB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Nov 2022 00:39:01 -0500
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C8C8643A
        for <kvm@vger.kernel.org>; Wed,  9 Nov 2022 21:38:54 -0800 (PST)
Date:   Thu, 10 Nov 2022 05:38:43 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1668058728;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Cz0g122FW3hWdq2eHIOMV7hQCiSlXiVP/4zHh+q+Qq0=;
        b=niJA84Quup1g33NjpucWgilFD6cKWSGkmmg79fRyKKMCCj38GzothGXiO0FqQ/Ep/Zn3e/
        TxfMu/QWFWEvxts+FQHY1uvhJTwmeoOAGVHEHR/Gf33KdN6MHH1K28hIs1iegy+qSvtXD3
        dcIAT1pfI0BM3eJ40oo50kQD+mcDB/Q=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Gavin Shan <gshan@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Reiji Watanabe <reijiw@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        David Matlack <dmatlack@google.com>,
        Quentin Perret <qperret@google.com>,
        Ben Gardon <bgardon@google.com>, Peter Xu <peterx@redhat.com>,
        Will Deacon <will@kernel.org>,
        Sean Christopherson <seanjc@google.com>, kvmarm@lists.linux.dev
Subject: Re: [PATCH v5 04/14] KVM: arm64: Don't pass kvm_pgtable through
 kvm_pgtable_walk_data
Message-ID: <Y2yOY0FKNmri8J4h@google.com>
References: <20221107215644.1895162-1-oliver.upton@linux.dev>
 <20221107215644.1895162-5-oliver.upton@linux.dev>
 <acce8160-a559-648f-ea9f-995843b9a3fb@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acce8160-a559-648f-ea9f-995843b9a3fb@redhat.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 10, 2022 at 01:30:08PM +0800, Gavin Shan wrote:
> Hi Oliver,
> 
> On 11/8/22 5:56 AM, Oliver Upton wrote:
> > In order to tear down page tables from outside the context of
> > kvm_pgtable (such as an RCU callback), stop passing a pointer through
> > kvm_pgtable_walk_data.
> > 
> > No functional change intended.
> > 
> > Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> > ---
> >   arch/arm64/kvm/hyp/pgtable.c | 18 +++++-------------
> >   1 file changed, 5 insertions(+), 13 deletions(-)
> > 
> 
> Reviewed-by: Gavin Shan <gshan@redhat.com>

Appreciated :)

> > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> > index db25e81a9890..93989b750a26 100644
> > --- a/arch/arm64/kvm/hyp/pgtable.c
> > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > @@ -50,7 +50,6 @@
> >   #define KVM_MAX_OWNER_ID		1
> >   struct kvm_pgtable_walk_data {
> > -	struct kvm_pgtable		*pgt;
> >   	struct kvm_pgtable_walker	*walker;
> >   	u64				addr;
> 
> Ok. Here is the answer why data->pgt->mm_ops isn't reachable in the walker
> and visitor, and @mm_ops needs to be passed down.

Yup, the reason for unhitching all of this from kvm_pgtable is explained
in the cover letter as well:

  Patches 1-4 clean up the context associated with a page table walk / PTE
  visit. This is helpful for:
   - Extending the context passed through for a visit
   - Building page table walkers that operate outside of a kvm_pgtable
     context (e.g. RCU callback)

--
Thanks,
Oliver
