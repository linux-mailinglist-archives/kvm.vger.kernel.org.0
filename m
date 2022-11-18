Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF75F62FB50
	for <lists+kvm@lfdr.de>; Fri, 18 Nov 2022 18:13:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242491AbiKRRNF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Nov 2022 12:13:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242486AbiKRRM4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Nov 2022 12:12:56 -0500
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01BD68CF10;
        Fri, 18 Nov 2022 09:12:54 -0800 (PST)
Date:   Fri, 18 Nov 2022 17:12:49 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1668791573;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SZClopAzQZuqTFUhQclgWoQ7jvZ2RLe6Z0cHJygex2I=;
        b=pg/shj4QLtOPw9mnu1T7TalbMSXwxOcCnj7v/lwgEdv806cCTaPHYBQp6Opzx3ysZ426ld
        DVpCO70x+BsZLC91lzrJs3+nwF6okrCjLrt/kHK5dZrd1YXpLoqguwoaUTXwDJxJRY2BTa
        8h35XCtgTiFFx+RnZHLmSg2kD79h+lM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Will Deacon <will@kernel.org>
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] KVM: arm64: Don't acquire RCU read lock for
 exclusive table walks
Message-ID: <Y3e9EXICIfgw4nSz@google.com>
References: <20221116165655.2649475-1-oliver.upton@linux.dev>
 <20221116165655.2649475-3-oliver.upton@linux.dev>
 <20221117174951.GA2916@willie-the-truck>
 <Y3Z8G3aCuRzzoq5e@google.com>
 <20221118121949.GA3697@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221118121949.GA3697@willie-the-truck>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 18, 2022 at 12:19:50PM +0000, Will Deacon wrote:
> On Thu, Nov 17, 2022 at 06:23:23PM +0000, Oliver Upton wrote:
> > On Thu, Nov 17, 2022 at 05:49:52PM +0000, Will Deacon wrote:
> > > On Wed, Nov 16, 2022 at 04:56:55PM +0000, Oliver Upton wrote:
> > 
> > [...]
> > 
> > > > -static inline void kvm_pgtable_walk_begin(void) {}
> > > > -static inline void kvm_pgtable_walk_end(void) {}
> > > > +static inline void kvm_pgtable_walk_begin(struct kvm_pgtable_walker *walker)
> > > > +{
> > > > +	/*
> > > > +	 * Due to the lack of RCU (or a similar protection scheme), only
> > > > +	 * non-shared table walkers are allowed in the hypervisor.
> > > > +	 */
> > > > +	WARN_ON(walker->flags & KVM_PGTABLE_WALK_SHARED);
> > > > +}
> > > 
> > > I think it would be better to propagate the error to the caller rather
> > > than WARN here.
> > 
> > I'd really like to warn somewhere though since we're rather fscked at
> > this point. Keeping that WARN close to the exceptional condition would
> > help w/ debugging.
> > 
> > Were you envisioning bubbling the error all the way back up (i.e. early
> > return from kvm_pgtable_walk())?
> 
> Yes, that's what I had in mind. WARN is fatal at EL2, so I think it's
> better to fail the pgtable operation rather than bring down the entire
> machine by default.

Duh, I forgot WARNs really do go boom at EL2. Yeah, in that case it'd be
best to let the caller clean up the mess.

> > If having this is a strong motivator I can do a v4.
> 
> It's a really minor point, so I'll leave it up to you guys.

Sold (sorry I wasn't following before). v4 on the way.

--
Thanks,
Oliver
