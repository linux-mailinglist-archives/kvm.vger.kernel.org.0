Return-Path: <kvm+bounces-58176-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 22273B8AE9B
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 20:28:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id A15C94E1395
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 18:28:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F43D262FD7;
	Fri, 19 Sep 2025 18:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ubsOj1Pe"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D14334BA40;
	Fri, 19 Sep 2025 18:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758306526; cv=none; b=TT/pxA0d9f+RPcLruP6L2i9/F/xowXqLVqf51lc/CWL10+uhZRnjxb2T0GyNZOTDpAOPuybYfCY7VCAOgkhRC/tHGf9pOuoiUNqB3/FlbsUgPiU3CEOcUwDnvk0jTKT3vVcb2RIurq0t8ZeTU3WV2FanVEZ7n1Fm6mbPYk0tU6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758306526; c=relaxed/simple;
	bh=DO1caKjdwWiEytFz3wuG+prVCNu0No7MAnjxeIVogno=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Sd7qPmFb4NYKacX0rbGSNvDGL0qJiMCTQw3g9U+qQhoTq2E1zkfkyxOqg135YlKdM8BGiZWSakhaQIm8uCF4V3rghgYR/PRtpvLkPNW3P8J3SQewVeU3W2pMTKCx8fxFIZjIUr4v5yOl8q+n8pcwNoEGYXTrpW93GzV5UAsVcUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ubsOj1Pe; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CE72C4CEF0;
	Fri, 19 Sep 2025 18:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758306525;
	bh=DO1caKjdwWiEytFz3wuG+prVCNu0No7MAnjxeIVogno=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ubsOj1Pew7RSEEcA1nUpPVmW0jxl+vy4mtZxsiV75MAi3on2SrPyjZAb33JEWjBx8
	 iWjwT+Vpjuq78+tXQ1+HuJNwJBPMf5hppoZkDWyqiM6+HPbytWGoyY0WGFg3ejCCIe
	 33CItSTrDJ5XVvzHu5txVMIJbxkcml3Tmo4wAMJmtZco7isyzRADCP3LeZhsKatquX
	 /jPChCRyzTnejy4QuTf6ksRmXXuPddGAhOwq7p4CahVsBLyoyLBzEwKN/Tbnap61Vg
	 XotOvzEUHZEz8dqz/b0d8nrsPZferdo3+NuNfhgU1ddeJhPqlOfn2QFY0BvSQ05Omq
	 2JiJLGx/lfc9Q==
Date: Fri, 19 Sep 2025 23:57:07 +0530
From: Naveen N Rao <naveen@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 5/6] KVM: SVM: Move global "avic" variable to avic.c
Message-ID: <vt5cuym6jynubpyvv2t7b6ygvg4hj5plufet6vsdnr7rc7zu7d@nv5aggxvomzm>
References: <20250919002136.1349663-1-seanjc@google.com>
 <20250919002136.1349663-6-seanjc@google.com>
 <73txiv6ycd3umvlptnqnepsc6hozuo4rfmyqj4rhtv7ahkm43k@37jbftataicw>
 <aM1sTc36cXIKxCDb@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aM1sTc36cXIKxCDb@google.com>

On Fri, Sep 19, 2025 at 07:44:29AM -0700, Sean Christopherson wrote:
> On Fri, Sep 19, 2025, Naveen N Rao wrote:
> > On Thu, Sep 18, 2025 at 05:21:35PM -0700, Sean Christopherson wrote:
> > > @@ -1141,15 +1149,9 @@ void avic_vcpu_unblocking(struct kvm_vcpu *vcpu)
> > >  	avic_vcpu_load(vcpu, vcpu->cpu);
> > >  }
> > >  
> > > -/*
> > > - * Note:
> > > - * - The module param avic enable both xAPIC and x2APIC mode.
> > > - * - Hypervisor can support both xAVIC and x2AVIC in the same guest.
> > > - * - The mode can be switched at run-time.
> > > - */
> > > -bool __init avic_hardware_setup(struct kvm_x86_ops *svm_ops)
> > > +static bool __init avic_want_avic_enable(void)
> > 
> > Maybe avic_can_enable()?
> 
> That was actualy one of my first names, but I didn't want to use "can" because
> (to me at least) that doesn't capture that the helper is incorporating input from
> the user, i.e. that it's also checking what the user "wants".

Makes sense.

> 
> I agree the name isn't great.  Does avic_want_avic_enabled() read any better?

Yes, though I think avic_want_enabled() suffices. But, I'm ok if you 
want it to be explicit.


- Naveen


