Return-Path: <kvm+bounces-53341-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 913D4B1011E
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 08:52:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 97C511CC1D40
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 06:52:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 861D920C029;
	Thu, 24 Jul 2025 06:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="vy35sepI"
X-Original-To: kvm@vger.kernel.org
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3AE0273F9
	for <kvm@vger.kernel.org>; Thu, 24 Jul 2025 06:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753339942; cv=none; b=czmsusefrVJOnf6PqJ/K/DgZx34Y1rHAAcXOKEhDHzFfrYnPBKqnEcddvIo96F08MSa3J84jydytCddKPXI/HC3J+h8dYiXen0Ig9NyS7d8J3F6cjxhVpZT6fqdxGYZL646+acdNIayI0HOrDKftrgoYdwWOXdPS621YTdOU4ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753339942; c=relaxed/simple;
	bh=GJIY4do+3UjlHPPQ/cO8rPzsqeO1bw4XGTv50v5QE2c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JwFJSCRE6Qc2Q0EatL1E7pT00q6xtoOlAroTv7nj5mVrWH0p7Dz9AaKgRkUw4Vpmd0DBkkAWZoXzRC02ds4X3giTYboPGj7tZGTf850Wa1ykLXdQh0mIeN+ctNsev60pFruPRIy0Rwk5uAw/E4Q+KAwLYzhFy7E10dtFgekO/GA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=vy35sepI; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 23 Jul 2025 23:51:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1753339928;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rwMlEka4cJNY6w6I3TpYez2izlEFdQeUh6PWXpxUFGI=;
	b=vy35sepI5H0lMN6QsQEkxtboil6uVq6YnQn17xMIc8eo9SlFtOiCmmhUf2hsYJ9vCeVWaa
	7qRfgfdeD0P6J+2KUfWFaT8Wid5wV4/DmPorgt15Fr3xzKH8KjUcZ81D3PXdQDaI541r2u
	P0xxs9D9Skx6O6c5fUHtw0wnOwVP5Kc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH 0/5] KVM: arm64: Config driven dependencies for
 TCR2/SCTLR/MDCR
Message-ID: <aIHYAeMb11eh2wih@linux.dev>
References: <20250714115503.3334242-1-maz@kernel.org>
 <175268446558.2457435.12236491763380805714.b4-ty@linux.dev>
 <276a28fa-c0a2-4ab7-8391-2c20831469e1@suse.cz>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <276a28fa-c0a2-4ab7-8391-2c20831469e1@suse.cz>
X-Migadu-Flow: FLOW_OUT

On Wed, Jul 23, 2025 at 05:53:20PM +0200, Vlastimil Babka wrote:
> On 7/16/25 18:47, Oliver Upton wrote:
> > On Mon, 14 Jul 2025 12:54:58 +0100, Marc Zyngier wrote:
> >> Here's a very short (and hopefully not too controversial) series
> >> converting a few more registers to the config-driven sanitisation
> >> framework (this is mostly a leftover from the corresponding 6.16
> >> monster series).
> >> 
> >> Patches on top of -rc3.
> >> 
> >> [...]
> > 
> > Applied to next, thanks!
> 
> The following merge commit creates a ./diff file. Found out because I had
> some local leftover one which prevented git checkout of current next.
> 
> commit 811ec70dcf9cc411e4fdf36db608dc9bcffb7a06
> Merge: 5ba04149822c 3096d238ec49
> Author: Oliver Upton <oliver.upton@linux.dev>
> Date:   Tue Jul 15 20:40:59 2025 -0700
> 
>     Merge branch 'kvm-arm64/config-masks' into kvmarm/next
> 
>     Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> 

Thanks for reporting this, I've added a fix on top of next and will
correct the merge when I rebuild the merge history to send the pull
request.

Thanks,
Oliver

