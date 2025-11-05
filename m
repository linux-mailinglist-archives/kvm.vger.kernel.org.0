Return-Path: <kvm+bounces-62130-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id AC8E0C380E6
	for <lists+kvm@lfdr.de>; Wed, 05 Nov 2025 22:37:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 1C3DF4EFCD4
	for <lists+kvm@lfdr.de>; Wed,  5 Nov 2025 21:36:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 401962D780A;
	Wed,  5 Nov 2025 21:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="BYEpea8t"
X-Original-To: kvm@vger.kernel.org
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AE9D2D7D2E
	for <kvm@vger.kernel.org>; Wed,  5 Nov 2025 21:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762378558; cv=none; b=Vg+TwZYscxfN6HO2Tm+clPXL87Wj80cz3KfHZQzM+j5DwQOQTz9RzCqL4rGH9psz2WebEnWgX5vA5AYWwD/jRzwdXX/v/DHclAJ9lUXRy6t/WxAfnJw5WwBaS7MlHmmq6vPu0/oYzS/zrHgjEmMEDFjK2/CySaM72fnFevo8RLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762378558; c=relaxed/simple;
	bh=MzRZz+66SyVzDLezHrbDKlE6u52q1wUmoUZfAwtBh98=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gf6eH1q+3ccKdBdFZy8cLfwCuzSkSCXhDAEGq7L28wrhn4aYySzTFfpjMsZQDeUstjIHSjBaZWhaMVHh0KeFvd4QF6TzSMX919zhPjHfsoTqWdJ7tsV4657ZA77vzj8sXG+PBQmGL8KyFvSsMhlvJzUCZyGmW+B1wPLHUgTQoRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=BYEpea8t; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 5 Nov 2025 21:35:38 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762378544;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dzJKN4L1Av54sD+cUR2dVkWf3Dxaaun45EKshnukXw0=;
	b=BYEpea8tDcZ3RvI+GV2cMoL/cOwleCQVaCzgKneuYmp2tdy8+zIba2avshbi5pj7bj4J3B
	ahdAccGcKCv9NLLAeWvETpViuncLEHIzhLJSSnS9DtyqhrCbzQo4B7Rk40qGvn0wU7daJj
	KIe+Gp33UFVNsVgcec99mMvNGrQhwFk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel
Subject: Re: [PATCH 3/3] KVM: nSVM: Avoid incorrect injection of
 SVM_EXIT_CR0_SEL_WRITE
Message-ID: <ygndurqaaapgrr2omlkdqa24sn6dubndp5cmsgasnobdwhcdql@gfysa3jtfjha>
References: <20251024192918.3191141-1-yosry.ahmed@linux.dev>
 <20251024192918.3191141-4-yosry.ahmed@linux.dev>
 <aQuqC6Nh4--OV0Je@google.com>
 <ek624i3z4e4nwlk36h7frogzgiml47xdzzilu5zuhiyb5gk5eb@tr2a6ptojzyo>
 <aQu1keKld2CT0OY5@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aQu1keKld2CT0OY5@google.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Nov 05, 2025 at 12:37:37PM -0800, Sean Christopherson wrote:
> On Wed, Nov 05, 2025, Yosry Ahmed wrote:
> > On Wed, Nov 05, 2025 at 11:48:27AM -0800, Sean Christopherson wrote:
> > > On Fri, Oct 24, 2025, Yosry Ahmed wrote:
> > Looks good with a minor nit:
> > 
> > > 
> > > 		/*
> > > 		 * Adjust the exit code accordingly if a CR other than CR0 is
> > > 		 * being written, and skip straight to the common handling as
> > > 		 * only CR0 has an additional selective intercept.
> > > 		 */
> > > 		if (info->intercept == x86_intercept_cr_write && info->modrm_reg) {
> > > 			icpt_info.exit_code += info->modrm_reg;
> > > 			break;
> > > 		}
> > > 
> > > 		/*
> > > 		 * Convert the exit_code to SVM_EXIT_CR0_SEL_WRITE if L1 set
> > > 		 * INTERCEPT_SELECTIVE_CR0 but not INTERCEPT_CR0_WRITE, as the
> > > 		 * unconditional intercept has higher priority.
> > > 		 */
> > 
> > We only convert the exict_code to SVM_EXIT_CR0_SEL_WRITE if other
> > conditions are true below. So maybe "Check if the exit_code needs to be
> > converted to.."?
> 
> Ouch, good point.  I keep forgetting that the common code below this needs to
> check the exit_code against the intercept enables.  How about this?

Looks good.

> 
> 		/*
> 		 * Convert the exit_code to SVM_EXIT_CR0_SEL_WRITE if a
> 		 * selective CR0 intercept is triggered (the common logic will
> 		 * treat the selective intercept as being enabled).  Note, the
> 		 * unconditional intercept has higher priority, i.e. this is
> 		 * only relevant if *only* the selective intercept is enabled.
> 		 */
> 
> > 
> > > 		if (vmcb12_is_intercept(&svm->nested.ctl, INTERCEPT_CR0_WRITE) ||
> > > 		    !(vmcb12_is_intercept(&svm->nested.ctl, INTERCEPT_SELECTIVE_CR0)))
> > > 			break;
> > > 
> > > 
> > > > -		    info->intercept == x86_intercept_clts)
> > > > +		    vmcb12_is_intercept(&svm->nested.ctl,
> > > > +					INTERCEPT_CR0_WRITE) ||
> > > > +		    !(vmcb12_is_intercept(&svm->nested.ctl,
> > > > +					  INTERCEPT_SELECTIVE_CR0)))
> > > 
> > > Let these poke out.
> > 
> > Sure. Do you prefer a new version with this + your fixup above, or will
> > you fix them up while applying?
> 
> If you're happy with it, I'll just fixup when applying.

More than happy :)

