Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18F2362F476
	for <lists+kvm@lfdr.de>; Fri, 18 Nov 2022 13:20:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241676AbiKRMUG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Nov 2022 07:20:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241577AbiKRMT6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Nov 2022 07:19:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 652E09735B;
        Fri, 18 Nov 2022 04:19:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BBEF862474;
        Fri, 18 Nov 2022 12:19:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5FD0C433C1;
        Fri, 18 Nov 2022 12:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668773996;
        bh=4JxZQz18/grkc1FqZWiq5Dfac3rhr+RHKptMtajtmCU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cmOF3PFW7xBBeFULSHg5Gp+fc3p4MViAOAqdlA/ug0xCIRdSMOJtUoHGsX+QL2mpS
         bTPOQLjhB86Sys7VFp08puWia/RHlVlLM0wT4B8Z3pbW6tO4Fz3TMvX+G/EVVFOktA
         /p8qOYNZGe9OhaGAFpw2qLDgDVZBnxxjh/VFwonn2jMINr6L4q9z2m4yxiurj1gV84
         TN/Sdu7nrtBuQ+iAYXICRRY29b+eTQAyfmYsaA6wKhDK3CVuaU+64QLN3FHpRquzez
         i4wfrwiA/0x+zSp0NHZWziFGoRsP74OpUmgM2rG6XleEn2/bX78qeeKP5JFaZrL5Yr
         f4BTl7ZBDC+BQ==
Date:   Fri, 18 Nov 2022 12:19:50 +0000
From:   Will Deacon <will@kernel.org>
To:     Oliver Upton <oliver.upton@linux.dev>
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
Message-ID: <20221118121949.GA3697@willie-the-truck>
References: <20221116165655.2649475-1-oliver.upton@linux.dev>
 <20221116165655.2649475-3-oliver.upton@linux.dev>
 <20221117174951.GA2916@willie-the-truck>
 <Y3Z8G3aCuRzzoq5e@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y3Z8G3aCuRzzoq5e@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 17, 2022 at 06:23:23PM +0000, Oliver Upton wrote:
> On Thu, Nov 17, 2022 at 05:49:52PM +0000, Will Deacon wrote:
> > On Wed, Nov 16, 2022 at 04:56:55PM +0000, Oliver Upton wrote:
> 
> [...]
> 
> > > -static inline void kvm_pgtable_walk_begin(void) {}
> > > -static inline void kvm_pgtable_walk_end(void) {}
> > > +static inline void kvm_pgtable_walk_begin(struct kvm_pgtable_walker *walker)
> > > +{
> > > +	/*
> > > +	 * Due to the lack of RCU (or a similar protection scheme), only
> > > +	 * non-shared table walkers are allowed in the hypervisor.
> > > +	 */
> > > +	WARN_ON(walker->flags & KVM_PGTABLE_WALK_SHARED);
> > > +}
> > 
> > I think it would be better to propagate the error to the caller rather
> > than WARN here.
> 
> I'd really like to warn somewhere though since we're rather fscked at
> this point. Keeping that WARN close to the exceptional condition would
> help w/ debugging.
> 
> Were you envisioning bubbling the error all the way back up (i.e. early
> return from kvm_pgtable_walk())?

Yes, that's what I had in mind. WARN is fatal at EL2, so I think it's
better to fail the pgtable operation rather than bring down the entire
machine by default. Now, it _might_ be fatal anyway (e.g. if we were
handling a host stage-2 fault w/ pKVM), but the caller is in a better
position to decide the severity.

> I had really only intended these to indirect lock acquisition/release,
> so the error handling on the caller side feels weird:
> 
>   static inline int kvm_pgtable_walk_begin(struct kvm_pgtable_walker *walker)
>   {
>   	if (WARN_ON(walker->flags & KVM_PGTABLE_WALK_SHARED))
> 		return -EPERM;
> 
> 	return 0;
>   }
> 
>   r = kvm_pgtable_walk_begin()
>   if (r)
>   	return r;
> 
>   r = _kvm_pgtable_walk();
>   kvm_pgtable_walk_end();

This doesn't look particularly weird to me (modulo dropping the WARN, or
moving it to _end()), but maybe I've lost my sense of taste.

> > Since you're rejigging things anyway, can you have this
> > function return int?
> 
> If having this is a strong motivator I can do a v4.

It's a really minor point, so I'll leave it up to you guys.

WIll
