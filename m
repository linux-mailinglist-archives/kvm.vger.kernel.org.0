Return-Path: <kvm+bounces-42072-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E606A71FB1
	for <lists+kvm@lfdr.de>; Wed, 26 Mar 2025 20:54:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7A4A9189D324
	for <lists+kvm@lfdr.de>; Wed, 26 Mar 2025 19:52:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2AEB624C676;
	Wed, 26 Mar 2025 19:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="CYtCvibk"
X-Original-To: kvm@vger.kernel.org
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4675618E34A
	for <kvm@vger.kernel.org>; Wed, 26 Mar 2025 19:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743018751; cv=none; b=o3CyNsHRMmcrO9Sv91kXHwujUMpw0YXvIy4pQDAKcd4WS22y3P50R6YzMLQWwCINbtwO6tU7u0p7yVuGGt48OFhgTQneTEUsaWWWAEp/MmWVH4HQWO7JRQx9/2zEiHDmdIhn99ZL5Dmw4o9boBFAswpnIdUL0GPFbEIqYxadlZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743018751; c=relaxed/simple;
	bh=8j/pMZObftENplg4deoaM1S6jWxUldrn0AWjkmEiUcs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lTaXWlmyCmTmasDGPzwcJq7EbSQSRU2PThutfBTCLFKtYB49vx8o1KngGt6oG4fKWbOVYh8r10abhd3ermUhv854lcN/C26Fjas0K31Txtl0kLUcUHNOmYN5CirR/0cPFHUP2N9Tl7b2o2adfK1/+W/LVxhrjqBG5uPnPWh8x5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=CYtCvibk; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 26 Mar 2025 19:52:20 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1743018747;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zzUfRFRmyA5Roo3UjviLOYKBv7xMeHy4PTNRPVwZ90I=;
	b=CYtCvibkcPwHarZgZ5JQ81lUW0Ke/is/DxOPkUeE1GMRy7rkw2Q5eGydsPtSw1x1uIz/7B
	cFfiV1yR3LKkExx+jhN4J4rcwc3R1nTXe0xAKMyoH6UhZ2wNO8pyTGie+uoZdMXHMMONGX
	V7e9fm/G5SLrDPuEDgdm5JhcU2uRb+w=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>,
	David Kaplan <David.Kaplan@amd.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] Unify IBRS virtualization
Message-ID: <Z-Ra9FYKP_xX4UBm@google.com>
References: <20250221163352.3818347-1-yosry.ahmed@linux.dev>
 <Z9NMxr0Ri7VUlJzM@google.com>
 <Z-RaJVo1MKuI90G0@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z-RaJVo1MKuI90G0@google.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Mar 26, 2025 at 12:48:53PM -0700, Sean Christopherson wrote:
> On Thu, Mar 13, 2025, Yosry Ahmed wrote:
> > On Fri, Feb 21, 2025 at 04:33:49PM +0000, Yosry Ahmed wrote:
> > > To properly virtualize IBRS on Intel, an IBPB is executed on emulated
> > > VM-exits to provide separate predictor modes for L1 and L2.
> > > 
> > > Similar handling is theoretically needed for AMD, unless IbrsSameMode is
> > > enumerated by the CPU (which should be the case for most/all CPUs
> > > anyway). For correctness and clarity, this series generalizes the
> > > handling to apply for both Intel and AMD as needed.
> > > 
> > > I am not sure if this series would land through the kvm-x86 tree or the
> > > tip/x86 tree.
> > 
> > Sean, any thoughts about this (or general feedback about this series)?
> 
> No feedback, I just you and Jim to get mitigation stuff right far more than I
> trust myself :-)
> 
> I'm planning on grabbing this for 6.16.

Awesome, thanks!

