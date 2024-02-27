Return-Path: <kvm+bounces-10140-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 37DD086A0AA
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 21:11:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 67C8D1C24565
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 20:11:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92EA214A4F9;
	Tue, 27 Feb 2024 20:11:28 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1525B1D6A8;
	Tue, 27 Feb 2024 20:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709064688; cv=none; b=R2sZTofyoV9KuIu1jQt9nSvoKE8H3QxQMxzpfrv4phwBjzIEDnCC/IIugvaw6vJ3fqZSM4R2N7Bwc/Jr11IumeCq+ZYKfVdBK2LKK5oiI/m/MiPk294VpITQZFMN/025krYRtZaXQCjj4eTXklGmGaAZT52kdUuX3r1d1xwTD/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709064688; c=relaxed/simple;
	bh=asmb5gigKVGR1GsnUvrFAnwASHCIwvnjV+4uj7J8U7Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XO8SIT+jM3Haz2QOXeRwseh0r/fCICPNbwl5XASE02/bDpbS3BlswItdCYKLbsXtu8qr8Ta67jNb0t/pFaTukK8v6P0Rqu+VbqhDKCgdYivveQm+hXGb9rJ2FdMxgDVbog/9hXKVa8xL751pPZiJyl04KTEi1HUR1BlmBKgvOo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B399DC433F1;
	Tue, 27 Feb 2024 20:11:24 +0000 (UTC)
Date: Tue, 27 Feb 2024 20:11:22 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, maz@kernel.org, will@kernel.org,
	suzuki.poulose@arm.com, james.morse@arm.com, corbet@lwn.net,
	boris.ostrovsky@oracle.com, darren@os.amperecomputing.com,
	d.scott.phillips@amperecomputing.com
Subject: Re: [PATCH] arm64: errata: Minimize tlb flush due to vttbr writes on
 AmpereOne
Message-ID: <Zd5B6huxqEcYIW6b@arm.com>
References: <20240207090458.463021-1-gankulkarni@os.amperecomputing.com>
 <ZcNRV-lMiNgE0_jv@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZcNRV-lMiNgE0_jv@linux.dev>

(catching up on emails)

On Wed, Feb 07, 2024 at 09:45:59AM +0000, Oliver Upton wrote:
> On Wed, Feb 07, 2024 at 01:04:58AM -0800, Ganapatrao Kulkarni wrote:
> > AmpereOne implementation is doing tlb flush when ever there is
> > a write to vttbr_el2. As per KVM implementation, vttbr_el2 is updated
> > with VM's S2-MMU while return to VM. This is not necessary when there
> > is no VM context switch and a just return to same Guest.
> > 
> > Adding a check to avoid the vttbr_el2 write if the same value
> > already exist to prevent needless tlb flush.
> 
> Sorry, zero interest in taking what is really a uarch optimization.
> The errata framework exists to allow the kernel achieve *correctness*
> on a variety of hardware and is not a collection of party tricks for
> optimizing any given implementation.

Definitely, we should not abuse the errata framework for uarch
optimisations.

> Think of the precedent this would establish. What would stop
> implementers from, say, changing out our memcpy implementation into a
> a hundred different uarch-specific routines. That isn't maintainable,
> nor is it even testable as most folks don't have access to your
> hardware.

I agree. FTR, I'm fine with uarch optimisations if (a) they don't
run-time patch the kernel binary, (b) don't affect the existing hardware
and (c) show significant gains on the targeted uarch in some meaningful
benchmarks (definitely not microbenchmark hammering a certain kernel
path).

We did have uarch optimisations in the past that broke rule (a). We
tried to make them somewhat more justifiable by creating optimisation
classes (well, I think it was only ARM64_HAS_NO_HW_PREFETCH). But such
changes don't scale well for maintainers, so I'd rather not go back
there.

So, if one wants an optimisation, it better benefits the other
implementations or at least it doesn't make them worse. Now, we do have
hardware from mobiles to large enterprise systems, so at some point we
may have to make a call on different kernel behaviours, possibly even at
run-time. We already do this at build-time, e.g. CONFIG_NUMA where it
doesn't make much sense in a mobile (yet). But they should not be seen
as uarch specific tweaks, more like higher-level classes of
optimisations.

-- 
Catalin

