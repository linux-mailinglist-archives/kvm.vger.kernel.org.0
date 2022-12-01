Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF53263F75E
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 19:17:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbiLASRd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 13:17:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230419AbiLASRT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 13:17:19 -0500
X-Greylist: delayed 336 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 01 Dec 2022 10:17:17 PST
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [IPv6:2001:41d0:1004:224b::b8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1DCD1113
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 10:17:17 -0800 (PST)
Date:   Thu, 1 Dec 2022 18:11:33 +0000
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] KVM: arm64: Don't serialize if the access flag isn't
 set
Message-ID: <Y4juVQNx9I0rzYFH@google.com>
References: <20221129191946.1735662-1-oliver.upton@linux.dev>
 <20221129191946.1735662-3-oliver.upton@linux.dev>
 <Y4Zw/J3srTsZ57P7@google.com>
 <Y4Z2aWVEnluy+d3+@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4Z2aWVEnluy+d3+@google.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 29, 2022 at 09:15:21PM +0000, Oliver Upton wrote:
> Hi Ricardo,
> 
> Thanks for having a look.
> 
> On Tue, Nov 29, 2022 at 12:52:12PM -0800, Ricardo Koller wrote:
> > On Tue, Nov 29, 2022 at 07:19:44PM +0000, Oliver Upton wrote:
> 
> [...]
> 
> > > +	ret = stage2_update_leaf_attrs(pgt, addr, 1, KVM_PTE_LEAF_ATTR_LO_S2_AF, 0,
> > > +				       &pte, NULL, 0);
> > > +	if (!ret)
> > > +		dsb(ishst);
> > 
> > At the moment, the only reason for stage2_update_leaf_attrs() to not
> > update the PTE is if it's not valid:
> > 
> > 	if (!kvm_pte_valid(pte))
> > 			return 0;
> > 
> > I guess you could check that as well:
> > 
> > +	if (!ret || kvm_pte_valid(pte))
> > +		dsb(ishst);
> 
> Thanks for catching this.
> 
> Instead of pivoting on the returned PTE value, how about we return
> -EAGAIN from the early return in stage2_attr_walker()? It would better
> match the pattern used elsewhere in the pgtable code.

Bugh...

Returning EAGAIN has some unfortunate consequences that I've missed
until now...

The stage2 attr walker is used to handle faults as well as range-based
operations. In the former case, EAGAIN is sane as we retry execution but
the latter is not. I stupidly got hung up on write protection not
working as intended for some time.

I think that callers into the page table walker should indicate whether
or not the walk is to address a fault. If it is not,
__kvm_pgtable_visit() and __kvm_pgtable_walk() should chug along instead
of bailing for EAGAIN.

Let me mess around with this and figure out what is least ugly.

--
Thanks,
Oliver
