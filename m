Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B9A91C6AC9
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 10:05:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728304AbgEFIFt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 04:05:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:53682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728290AbgEFIFt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 May 2020 04:05:49 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5300720661;
        Wed,  6 May 2020 08:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588752348;
        bh=UjdxhpVscqX8eojhwkhNUe0wu2YW5eO/ax3nOE6DNr4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JDNKhr1Phvo7xXG9he3Gj9+ZGn5UNmxa9ERq7/dVBcwVNBfSq167LLMSAdeHkw1ry
         fk1DZbDYo1iI8fp1i3YFFLq2nhDpp1jnlaWBQbBY4kgxdF86Q7ueav7wetKcNq42mX
         AhFiHphOXgYdAR631rYeDrU0Lf7iZVGru3LeekpQ=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jWF3q-009sbR-L1; Wed, 06 May 2020 09:05:46 +0100
Date:   Wed, 6 May 2020 09:05:44 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Andrew Scull <ascull@google.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
        Andre Przywara <andre.przywara@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        George Cherian <gcherian@marvell.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH 06/26] arm64: Add level-hinted TLB invalidation helper
Message-ID: <20200506090544.18620ed4@why>
In-Reply-To: <20200505171631.GC237572@google.com>
References: <20200422120050.3693593-1-maz@kernel.org>
        <20200422120050.3693593-7-maz@kernel.org>
        <20200505171631.GC237572@google.com>
Organization: Approximate
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: ascull@google.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, will@kernel.org, andre.przywara@arm.com, Dave.Martin@arm.com, gcherian@marvell.com, prime.zeng@hisilicon.com, catalin.marinas@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 5 May 2020 18:16:31 +0100
Andrew Scull <ascull@google.com> wrote:

Hi Andrew,

> > +#define __tlbi_level(op, addr, level)					\
> > +	do {								\
> > +		u64 arg = addr;						\
> > +									\
> > +		if (cpus_have_const_cap(ARM64_HAS_ARMv8_4_TTL) &&	\
> > +		    level) {						\
> > +			u64 ttl = level;				\
> > +									\
> > +			switch (PAGE_SIZE) {				\
> > +			case SZ_4K:					\
> > +				ttl |= 1 << 2;				\
> > +				break;					\
> > +			case SZ_16K:					\
> > +				ttl |= 2 << 2;				\
> > +				break;					\
> > +			case SZ_64K:					\
> > +				ttl |= 3 << 2;				\
> > +				break;					\
> > +			}						\
> > +									\
> > +			arg &= ~TLBI_TTL_MASK;				\
> > +			arg |= FIELD_PREP(TLBI_TTL_MASK, ttl);		\  
> 
> Despite the spec saying both tables apply to TLB maintenance
> instructions that do not apply to a range of addresses I think it only
> means the 4-bit version (bug report to Arm, or I'm on the wrong spec).

I'm not quite sure what you mean by the 4-bit version here. Do you mean
the instructions taking a VA or IPA as input address? In this case,
yes, this macro is solely for the use of the invalidation of a given
translation, identified by a VA/IPA and a level (which is an implicit
TLB size for a given translation granule).

And yes, it looks like there is a bad copy-paste bug in the ARM ARM
(Rev F.a).

> This is consistent with Table D5-53 and the macro takes a single address
> argument to make misuse with range based tlbi less likely.
> 
> It relies on the caller to get the level right and getting it wrong
> could be pretty bad as the spec says all bets are off in that case. Is
> it worth adding a check of the level against the address (seems a bit
> involved), or that it is just 2 bits or adding a short doc comment to
> explain it?

I'd like to avoid checking code at that level, to be honest. If you are
writing TLB invalidation code, you'd better know what you are doing.
Happy to document it a bit more thoroughly though, and set the
expectations that if you misuse the level, you're in for a treat.

> (Looks like we get some constants for the levels in a later patch that
> could be referenced with some form of time travel)

I'm happy to bring these definitions forward, maybe in a more generic
form (they are very S2-specific at the moment).

> 
> > +		}							\
> > +									\
> > +		__tlbi(op,  arg);					\  
> 
> cosmetic nit: double space in here

Well spotted.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
