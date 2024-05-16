Return-Path: <kvm+bounces-17535-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BB1C8C786D
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 16:32:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C52B91F21880
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 14:32:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F72A14B96F;
	Thu, 16 May 2024 14:32:14 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE9A414B942;
	Thu, 16 May 2024 14:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715869933; cv=none; b=JbvSohfD0s1H2A5q8gZpJ3L2C6WF2AaQv5O4CtxxUEshLYx18Lv4JO1vbw4Bh2BUExckeZqO951bMHG8pGNwU/yUH1cNq8yyzfEv1g8h/xj0QcLRWllX8AL0kGlm0RIvSFdYkNWIGZA84MGKV95W7xtjScDhpRK2tL/auadfNQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715869933; c=relaxed/simple;
	bh=bAPoVDfL5WvnkkSsUVS3M8XyJ++r3/L577PAoucEi6g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fhWzOA9zdH/HQYEH23tjkOGNw8ha/X3HdaJ+5NDHTVSXMafT9uTeAguAYwBSZ8AMYXJ2C4odcT90/OMnunMb9EqnfKTqaBAZPzyT3VK4rqwLOB+CfGK/THEBzPSb9vV2akFOdIZGoJ5V53VScn5E7p+nba/wAhEtd8L58vdRc70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E2A8C113CC;
	Thu, 16 May 2024 14:32:10 +0000 (UTC)
Date: Thu, 16 May 2024 15:32:08 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: Re: [PATCH v2 02/14] arm64: Detect if in a realm and set RIPAS RAM
Message-ID: <ZkYY6GO-4FkuEBlU@arm.com>
References: <20240412084213.1733764-1-steven.price@arm.com>
 <20240412084213.1733764-3-steven.price@arm.com>
 <Zj5a9Kt6r7U9WN5E@arm.com>
 <a5dbe87b-dcb0-4467-9002-775fbdfb239d@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a5dbe87b-dcb0-4467-9002-775fbdfb239d@arm.com>

On Tue, May 14, 2024 at 11:18:13AM +0100, Suzuki K Poulose wrote:
> On 10/05/2024 18:35, Catalin Marinas wrote:
> > On Fri, Apr 12, 2024 at 09:42:01AM +0100, Steven Price wrote:
> > > +void arm64_setup_memory(void)
> > 
> > I would give this function a better name, something to resemble the RSI
> > setup. Similarly for others like set_memory_range_protected/shared().
> > Some of the functions have 'rsi' in the name like arm64_rsi_init() but
> > others don't and at a first look they'd seem like some generic memory
> > setup on arm64, not RSI-specific.
> 
> Ack. arm64_rsi_setup_memory() ? I agree, we should "rsi" fy the names.

This should work. We also have rsi_*() functions without any 'arm64' but
those are strictly about communicating with the RMM, so that's fine.

> > > @@ -293,6 +294,8 @@ void __init __no_sanitize_address setup_arch(char **cmdline_p)
> > >   	 * cpufeature code and early parameters.
> > >   	 */
> > >   	jump_label_init();
> > > +	/* Init RSI after jump_labels are active */
> > > +	arm64_rsi_init();
> > >   	parse_early_param();
> > 
> > Does it need to be this early? It's fine for now but I wonder whether we
> > may have some early parameter at some point that could influence what we
> > do in the arm64_rsi_init(). I'd move it after or maybe even as part of
> > the arm64_setup_memory(), though I haven't read the following patches if
> > they update this function.
> 
> We must do this before we setup the "earlycon", so that the console
> is accessed using shared alias and that happens via parse_early_param() :-(.

Ah, ok, makes sense.

-- 
Catalin

