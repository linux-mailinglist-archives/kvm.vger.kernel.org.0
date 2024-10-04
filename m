Return-Path: <kvm+bounces-27983-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BFFB29908AE
	for <lists+kvm@lfdr.de>; Fri,  4 Oct 2024 18:08:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DFDD0B21041
	for <lists+kvm@lfdr.de>; Fri,  4 Oct 2024 16:00:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAE841C7292;
	Fri,  4 Oct 2024 15:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="VBEdW6Td"
X-Original-To: kvm@vger.kernel.org
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7372C1C7262
	for <kvm@vger.kernel.org>; Fri,  4 Oct 2024 15:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728057189; cv=none; b=XjNhfYo8Ni4Gh4wcKZ9qdBRwQhGeoLXEmM8NyCWMtSWff0/JvHEgaLcIKIQfdIt3ajyOCpIgI3UXTiKx+u3I4GtJyXLix5ms8gm+CAqEyec8NhvGv+3gMbS177p/i0dcMZTTUMmFKGmRLc/k9/qXxRQRxaF0zyU+HYHNPNGmYXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728057189; c=relaxed/simple;
	bh=dk8hBzieIPbzvrhpctgGmM0IsPgACCkbqqNlKJy6X7g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lV9FIjESGd1E8VyQYSQX+E3RrJgFu0tStGK2J4rBLmt7UwpetJk5+cdCCaygpMjCGrXyqJ9png/SnkPGThDiRAzdGzeZUg5jgiWKvkMSLz4walEGELvEYeKW7trZnhjx/AlcOMb/OZTkGGMwQfaPfB44QI0R/dLIUWFKLvNuZWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=VBEdW6Td; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 4 Oct 2024 08:52:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1728057185;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ivG9THqCQQnFANZXsktsXbgeggmF80l3fARD79rk4OU=;
	b=VBEdW6TdJq+I0Nni5DzNlmiLE4pE738CbB+0OTgiHbZpgUoJi/Je1pnPd+L3nCltngGK6V
	xKB4MNhUyy6gW7Y2Vp3j9rX5aK/0N45w1qn2+EmYweF+nBjIzxWopsR+3Lw9DCb0FB0nKd
	dzkQ+bGU/2kC6D0PzBHZVzRUWj1GLfY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Peter Maydell <peter.maydell@linaro.org>
Cc: Ahmad Fatoum <a.fatoum@pengutronix.de>, qemu-arm@nongnu.org,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	Pengutronix Kernel Team <kernel@pengutronix.de>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	Enrico Joerns <ejo@pengutronix.de>
Subject: Re: [BUG] ARM64 KVM: Data abort executing post-indexed LDR on MMIO
 address
Message-ID: <ZwAPWc-v9GhMbERF@linux.dev>
References: <89f184d6-5b61-4c77-9f3b-c0a8f6a75d60@pengutronix.de>
 <CAFEAcA_Yv2a=XCKw80y9iyBRoC27UL6Sfzgy4KwFDkC1gbzK7w@mail.gmail.com>
 <a4c06f55-28ec-4620-b594-b7ff0bb1e162@pengutronix.de>
 <CAFEAcA9F3AR-0OCKDy__eVBJRMi80G7bWNfANGZRR2W8iMhfJA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFEAcA9F3AR-0OCKDy__eVBJRMi80G7bWNfANGZRR2W8iMhfJA@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Oct 04, 2024 at 01:10:48PM +0100, Peter Maydell wrote:
> On Fri, 4 Oct 2024 at 12:51, Ahmad Fatoum <a.fatoum@pengutronix.de> wrote:
> > > Strictly speaking this is a missing feature in KVM (in an
> > > ideal world it would let you do MMIO with any instruction
> > > that you could use on real hardware).
> >
> > I assume that's because KVM doesn't want to handle interruptions
> > in the middle of such "composite" instructions?
> 
> It's because with the ISV=1 information in the ESR_EL2,
> KVM has everything it needs to emulate the load/store:
> it has the affected register number, the data width, etc. When
> ISV is 0, simulating the load/store would require KVM
> to load the actual instruction word, decode it to figure
> out what kind of load/store it was, and then emulate
> its behaviour. The instruction decode would be complicated
> and if done in the kernel would increase the attack surface
> exposed to the guest.

On top of that, the only way to 'safely' fetch the instruction would be
to pause all vCPUs in the VM to prevent the guest from remapping the
address space behind either KVM or the VMM's back.

> > static inline u32 __raw_readl(const volatile void __iomem *addr)
> > {
> >         return *(const volatile u32 __force *)addr;
> > }
> >
> > I wouldn't necessarily characterize this as strange, we just erroneously
> > assumed that with strongly ordered memory for MMIO regions and volatile
> > accesses we had our bases covered and indeed we did until the bases
> > shifted to include hardware-assisted virtualization. :-)

This has nothing to do with ordering and everything to do with the
instruction set && what your compiler decided to emit.

> I'm not a fan of doing MMIO access via 'volatile' in C code,
> personally -- I think the compiler has a tendency to do more
> clever recombination than you might actually want, because
> it doesn't know that the thing you're accessing isn't RAM-like.

+1

-- 
Thanks,
Oliver

