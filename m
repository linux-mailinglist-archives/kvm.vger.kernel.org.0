Return-Path: <kvm+bounces-67191-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E839ACFB676
	for <lists+kvm@lfdr.de>; Wed, 07 Jan 2026 01:03:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 385973029BA4
	for <lists+kvm@lfdr.de>; Wed,  7 Jan 2026 00:02:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 206B39460;
	Wed,  7 Jan 2026 00:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="p2IOVNWS"
X-Original-To: kvm@vger.kernel.org
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58EFE10F1
	for <kvm@vger.kernel.org>; Wed,  7 Jan 2026 00:02:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767744173; cv=none; b=e32roDgKiWsyH+sMB96LOLoSmtqFLnx0WZwBBx2SnE8YUUf/Xop1OSVpoFtcGO0HrW+2mcgT8QJ2qXUvkPBaOwSxrnMTVsMwpK8O/1pLMRsG8vAiRVVQLC1H6IH9y9db0chikQOB4npOjszoBsSZqyjhOYakyHDd+9fdH5Hvhr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767744173; c=relaxed/simple;
	bh=AvkjJLCFyNvuci7RdTqo29qyP0mI1NW+1fvzeOsS2HQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V+keAeiqCIdtdw1FYZZC0jLw3R6R6y+hrxD24hM8nSUlNPZbiP47zqK/cRl++5VrVklXMwEG2A+yudV5JACqnSDXRzXuGV5KVbufGP5XrSVFdRasIi4guM0OCxq7IQzH+flVg0uSIOvMVZq7FHJOVGMPeuUI4dF8rRwfZwEnqu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=p2IOVNWS; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 7 Jan 2026 00:02:40 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767744164;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SadaGAHAoCzyMI4YdGhTUbV3QojP8p+WsJPjSSDErGY=;
	b=p2IOVNWSyLT+NmXowivbxknsmrOD2kRVfyhPY1RGYN4WmOe7XzLdfcYvCT6pKbmg//wX0Q
	vVe2MWUgW6px5Gbu5AHsOg4LbSP3EPbowmKjCN+Cc88BDcWNFe1bPp/T9nr6DoBJollkZc
	rQkfLZfv9gI8LAS1TCcrlZcS3oJqz7w=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Kevin Cheng <chengkev@google.com>, pbonzini@redhat.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] KVM: SVM: Raise #UD if VMMCALL instruction is not
 intercepted
Message-ID: <qsigylx7qbq6ymbouw5rfuseqwb6s6fczhbusxqe5e46bscxxz@2cmi2okx7cte>
References: <20260106041250.2125920-1-chengkev@google.com>
 <20260106041250.2125920-3-chengkev@google.com>
 <aV1UpwppcDbOim_K@google.com>
 <pbbfdqgd7vu6xknmrlg6ezrbhprnw42ngbkp7f55thxanqgnuf@7l4fkbrk7v76>
 <aV2dEWVolv2862-D@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aV2dEWVolv2862-D@google.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Jan 06, 2026 at 03:38:57PM -0800, Sean Christopherson wrote:
> On Tue, Jan 06, 2026, Yosry Ahmed wrote:
> > On Tue, Jan 06, 2026 at 10:29:59AM -0800, Sean Christopherson wrote:
> > > > +static int vmmcall_interception(struct kvm_vcpu *vcpu)
> > > > +{
> > > > +	/*
> > > > +	 * If VMMCALL from L2 is not intercepted by L1, the instruction raises a
> > > > +	 * #UD exception
> > > > +	 */
> > > 
> > > Mentioning L2 and L1 is confusing.  It reads like arbitrary KVM behavior.  And
> > > IMO the most notable thing is what's missing: an intercept check.  _That_ is
> > > worth commenting, e.g.
> > > 
> > > 	/*
> > > 	 * VMMCALL #UDs if it's not intercepted, and KVM reaches this point if
> > > 	 * and only if the VMCALL intercept is not set in vmcb12.
> > 
> > Nit: VMMCALL
> > 
> > > 	 */
> > > 
> > 
> > Would it be too paranoid to WARN if the L1 intercept is set here?
> 
> Yes.  At some point we have to rely on not being completely inept :-D, and more
> importantly this is something that should be trivial easy to validate via tests.
> 
> My hesitation for such a check is that adding a WARN here begs the question of
> what makes _this_ particular handler special, i.e. why doesn't every other handler
> also check that an exit shouldn't have been routed to L1?  At that point we'd be
> replicating much of the routing logic into every exit handler.

I briefly thought about this, and I thought since we're explicitly
calling out the dependency on L1 not intercepting this here, a WARN
would make sense. Anyway, your argument make sense. I was going to
suggested adding a WARN in svm_invoke_exit_handler() instead, something
like:

WARN_ON_ONCE(vmcb12_is_intercept(&svm->nested.ctl, exit_code));

But this doesn't work for all cases (e.g. SVM_EXIT_MSR, SVM_EXIT_IOIO,
etc). We can exclude these cases, but this point maintaining the WARN
becomes a burden in itself. I give up :)

> 
> And it _still_ wouldn't guarantee correctness, e.g. wouldn't detect the case where
> KVM incorrectly forwarded a VMMCALL to L1, i.e. we still need the aforementioned
> tests, and so I see the WARN as an overall net-negative.
> 
> > WARN_ON_ONCE(vmcb12_is_intercept(&svm->nested.ctl, INTERCEPT_VMMCALL));

