Return-Path: <kvm+bounces-27467-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 735B99864D1
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 18:29:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EABA01F2524F
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 16:29:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC1DB4962E;
	Wed, 25 Sep 2024 16:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=freebsd.org header.i=@freebsd.org header.b="ChT2OcBH"
X-Original-To: kvm@vger.kernel.org
Received: from mx2.freebsd.org (mx2.freebsd.org [96.47.72.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D39F367;
	Wed, 25 Sep 2024 16:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=96.47.72.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727281744; cv=pass; b=gacKsM9ZwkQHJ+oJrg2EwbUrQi0BBR0No0pGxl8i+H4OXmMo7Ly7znpP4K5/kh3YVbXjWbTJfXW9+Jy+KdHv2EnizfOoJUiUz3fmjky9H8swqFZgVI+peu2Y+7WI14Kngh1SMyrpuJR0n4XZkZ7U3NSvaBn0ylEHqXkc3KvkT/I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727281744; c=relaxed/simple;
	bh=Drg62vbidm313cp43ukPdG1u2UTDR9VUvpU0FvdN/7s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gNV45QOUKP4X+A0bacn3GVv1E18rFM+ZtcrGbcGcV1F9GcN/4a3KyqCWZCCKFlfjizV4x4Bnno9a3+j0PjykqpzA/AsUIJFNQY5pKX8yc42Nyo+L8pbnMk0m8jZIFKVdunrE/Lx+q/18TED195zXcovM+zgaDKuagsKM9GrxMyY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=freebsd.org; spf=pass smtp.mailfrom=freebsd.org; dkim=pass (2048-bit key) header.d=freebsd.org header.i=@freebsd.org header.b=ChT2OcBH; arc=pass smtp.client-ip=96.47.72.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=freebsd.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=freebsd.org
Received: from mx1.freebsd.org (mx1.freebsd.org [IPv6:2610:1c1:1:606c::19:1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits)
	 client-signature RSA-PSS (4096 bits))
	(Client CN "mx1.freebsd.org", Issuer "R10" (verified OK))
	by mx2.freebsd.org (Postfix) with ESMTPS id 4XDMcY25Z3z4Xjy;
	Wed, 25 Sep 2024 16:29:01 +0000 (UTC)
	(envelope-from ssouhlal@freebsd.org)
Received: from freefall.freebsd.org (freefall.freebsd.org [96.47.72.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
	 client-signature RSA-PSS (4096 bits) client-digest SHA256)
	(Client CN "freefall.freebsd.org", Issuer "R11" (verified OK))
	by mx1.freebsd.org (Postfix) with ESMTPS id 4XDMcX6Tx4z4VZx;
	Wed, 25 Sep 2024 16:29:00 +0000 (UTC)
	(envelope-from ssouhlal@freebsd.org)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=freebsd.org; s=dkim;
	t=1727281740;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QvovojzBC4sqSXOUEmyBpaOxWWALChCLJNU1wSv3wE4=;
	b=ChT2OcBH/OLGrN/hySzAcnNSTVjaimwU1m4zXRgiI0qtdqf8kEHYzI48mk1RtMNIuYDgh6
	JPShnfRLy5hlFQpBMEc/WkTXUVUxRMTVrOpiNpXPG7R351/2k6BLFUtXE7ZihgikSXG88E
	V00k3XqcrG04VG3itQ9/Z6rf2wwpFNB7637pro0f8MVsHwinqB01g4PnAe+1aRXyJIdRV9
	2hC9iLr4Wc1SAIMP7TG9yhOfOTrWiZpRLPSz8evCm+VH+3hQABHjH9fBowWNRqTh0p4z6H
	b9NpIYLM1kCCI29C9tGP0ckVW3mr5amsdospnFzjs+nQIrlHNYH60g2kfM+s3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=freebsd.org;
	s=dkim; t=1727281740;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QvovojzBC4sqSXOUEmyBpaOxWWALChCLJNU1wSv3wE4=;
	b=A277neFBlBIU+Zx5S1UOAZQ6dNd4CfWQip/JYgc+zFnlAycfgg4gfW99F9jMxRmOgA8Mj6
	uMEl8NDDDFEHhOVBEgk/n1bYnw3uWL9bKwjTJjdORR3kCTUO6LSf7U40iQ4QXOp82T/m0s
	pkXRmBEkM1UBX3q8bjcwnzRO0jybjTogJfSl3RZPhYvwmO+l4uNHn1BRS4X9PXNOD2mP4s
	13Rof+CyYN48WYARxMertpSMGFE1nd8OUgm4FSyMURfd1CY049RpFJj6kS2beGRi+nfgp1
	bChMNo8bDc4iTYqH/MgKSvDAhxsRjx/SILpSYDb2GoF5LklLUcMFZbcVs7osRQ==
ARC-Authentication-Results: i=1;
	mx1.freebsd.org;
	none
ARC-Seal: i=1; s=dkim; d=freebsd.org; t=1727281740; a=rsa-sha256; cv=none;
	b=tm3HfbMSD0p9XYaPvvtMZcfZNm4wXISgH7zunh3h7CsBcLszX0fCwf/icqrmN2v4sBqQRq
	QrOEjprdzzcaRiXPyJrbJhRhiy9vY1TT6abHxyqPdihX6vsDmCdKo6dKnYwo4c2xu69KvA
	scmqX8zDE+uqDDgLim1usGkiwTOwnj5Z54PNtvT3hY7PpwWGF+uZK0sOvUbr+49fsQcljJ
	r7YXwqMDT0m7pxCnCHjrOuWYyvOkGax9o0LLmdhj1SwMnb4HjHpvD0kKTswrO4aUtTZDHO
	DyRjTYEgpT5fq/UHIY5nQl+RWUSOnLDgfyq7f9MJyz/U8YuIcidppJMSlEZ0mg==
Received: by freefall.freebsd.org (Postfix, from userid 1026)
	id C07D6EC81; Wed, 25 Sep 2024 16:29:00 +0000 (UTC)
Date: Wed, 25 Sep 2024 16:29:00 +0000
From: Suleiman Souhlal <ssouhlal@freebsd.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Suleiman Souhlal <suleiman@google.com>, Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>, joelaf@google.com,
	vineethrp@google.com, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, Srikar Dronamraju <srikar@linux.ibm.com>,
	Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v2] sched: Don't try to catch up excess steal time.
Message-ID: <ZvQ6TKth0uySk3eJ@freefall.freebsd.org>
References: <20240911111522.1110074-1-suleiman@google.com>
 <f0535c47ea81a311efd5cade70543cdf7b25b15c.camel@infradead.org>
 <ZvQPTYo2oCN-4YTM@freefall.freebsd.org>
 <c393230b8c258ab182f85b74cbc9f866acc2a5a2.camel@infradead.org>
 <ZvQo9gJgTlZ3nB03@freefall.freebsd.org>
 <982d866bd387964b47148b0492fe9aada3b9ae32.camel@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <982d866bd387964b47148b0492fe9aada3b9ae32.camel@infradead.org>

On Wed, Sep 25, 2024 at 04:34:57PM +0100, David Woodhouse wrote:
> On Wed, 2024-09-25 at 15:15 +0000, Suleiman Souhlal wrote:
> > Yes, that's a good way to put it: The excess steal time isn't actually
> > being stolen from anyone.
> > And since it's not being stolen from anyone, isn't the right thing to do
> > to drop it?
> 
> It's being stolen from the system, isn't it? Just not any specific
> userspace process?

I guess it depends what you mean by "stolen". I would argue that it's not
stolen from anyone since the time isn't actually counted anywhere.

> 
> If we have separate "end of outgoing task" and "start of incoming task"
> timestamps, surely the time between those two must be accounted
> *somewhere*?

Not exactly. clock_task is essentially frozen until the next
update_rq_clock(), at which point we'll look at how much sched_clock_cpu
advanced and subtract how much steal time advanced. The two things
are done in separate spots (update_rq_clock() and update_rq_clock_task()),
indepedently (which is where the race is happening).
As far as I can tell, the time between the two isn't really accounted
anywhere.

The "end of outgoing task" and "start of incoming task" timestamps should
end up being the same.

> 
> > There might still be extra steal time that doesn't exceed the current
> > 'delta' from the race between reading the two values, that would still
> > be erroneously accounted to the outgoing task, which this patch doesn't
> > address, but we know that any steal > delta is from this race and should
> > be dropped.
> 
> Well that's what we want the atomic paired read for :)

Right, but I don't think it's that simple. We aren't only reading memory
but also a clock.
It might be possible to address this with a mechanism like rseq, but that
would be a much bigger patch set than the current one (and I don't think
anyone has ever attempted to do rseq for VMs yet).

(There is also another potential issue I spotted with steal time, that
has to do with reading another VCPU's steal time while it's not running,
but I'll start a separate discussion about that with a different patch set.)

Thanks for the discussion.
-- Suleiman

