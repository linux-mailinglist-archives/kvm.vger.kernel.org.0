Return-Path: <kvm+bounces-39124-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C3794A4451C
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 16:57:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8B9747AB06C
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 15:56:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13090188A0E;
	Tue, 25 Feb 2025 15:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vMr7zURB"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 779E22AEE4;
	Tue, 25 Feb 2025 15:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740499023; cv=none; b=hEzS2biDU5l52I7ogatLfqd6P4g/OZK2YoP+P2vrXgr1E0tAUeXZNhY900LsPKTIjv/raG+TLGpSchLjEam4uoSMCHcR/jKH8vZiAl/Oad/pXFDDVtu0WWyGOAZM3VgnB2XCKXulhQO4mcB+KXOyBLpDmnxeDs/BvmFFg8AlUPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740499023; c=relaxed/simple;
	bh=yu6wXpbijbvoprV7cAUlfR90pWJ4tsCo/nY0611s5OQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NkwuYDbKTJUWgQ3WzdDL00YPS6L50K1Ph4XsPFzf71PCMM+7yPWMrvKjacIOw7GMY4G5L+Mx7RUB4sRdvaqK1Ni/lhNX3miFnyUaOeuhce2EFKQDz6mjEkpvplnyDpfVoUQJWDLF5pFLQ1UZ+2/cZ0gYW9rccJ84TJGcQnVy/m0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=vMr7zURB; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=VN/3A6vgb56W0tilRktJHT6BmmHqRIi/ngh2AhRM5Lw=; b=vMr7zURBonPoMkDkO+7eSER6rL
	pCwqXqAO33W7UHrux3BNm1V62PG09EmLrLvg2hR4LTU4Y2hgybNPu/M4WI6WCCarx4beg3iZSFMDo
	MC9/VGxIBE9AJzXY4jMkkgSWG2/bGuz4vYLs7DQIsok9BDqqIShw9RAl3GNmzG4klBIPETOYSdBJp
	EOhdxTzkOQd01nxYOVjO2dgpAdWX5Y2163Aj5RDnvluWQzdosVXsZaPEUOx8AaV1uoRUtDM7RCGj9
	C813cuTkW2o041P7/Vrm7f3KY/t2WvZ+Ts6ImZqBvtfK0EmTqKk81P+vZscn/cUT+EJDSzZrbl2LC
	NdLSSr2Q==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tmxIn-0000000BoqX-3LBB;
	Tue, 25 Feb 2025 15:56:58 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id A5FB9300472; Tue, 25 Feb 2025 16:56:56 +0100 (CET)
Date: Tue, 25 Feb 2025 16:56:56 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, rangemachine@gmail.com,
	whanos@sergal.fun, Ravi Bangoria <ravi.bangoria@amd.com>
Subject: Re: [PATCH 0/3] KVM: SVM: Zero DEBUGCTL before VMRUN if necessary
Message-ID: <20250225155656.GE34233@noisy.programming.kicks-ass.net>
References: <20250224181315.2376869-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250224181315.2376869-1-seanjc@google.com>

On Mon, Feb 24, 2025 at 10:13:12AM -0800, Sean Christopherson wrote:
> PeterZ,
> 
> Can you confirm that the last patch (snapshot and restore DEBUGCTL with
> IRQs disabled) is actually necessary?  I'm 99% certain it is, but I'm
> holding out hope that it somehow isn't, because I don't love the idea of
> adding a RDMSR to every VM-Entry.

I think you're right. I mean, I'd have to go double check and trace the
various call paths again, but I'd be very surprised if we can't change
DEBUGCTL from NMI context.

> Assuming DEBUGCTL can indeed get modified in IRQ context, it probably
> makes sense to add a per-CPU cache to eliminate the RDMSR.  Unfortunately,
> there are quite a few open-coded WRMSRs, so it's not a trivial change.

This, I'm surprised we've not yet done that.

> On to the main event...
> 
> Fix a long-lurking bug in SVM where KVM runs the guest with the host's
> DEBUGCTL if LBR virtualization is disabled.  AMD CPUs rather stupidly
> context switch DEBUGCTL if and only if LBR virtualization is enabled (not
> just supported, but fully enabled).
> 
> The bug has gone unnoticed because until recently, the only bits that
> KVM would leave set were things like BTF, which are guest visible but
> won't cause functional problems unless guest software is being especially
> particular about #DBs.
> 
> The bug was exposed by the addition of BusLockTrap ("Detect" in the kernel),
> as the resulting #DBs due to split-lock accesses in guest userspace (lol
> Steam) get reflected into the guest by KVM.

Hehe, yeah, games. Yeah we ran into that with bus-lock on intel too :-)

