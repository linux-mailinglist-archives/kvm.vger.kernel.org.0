Return-Path: <kvm+bounces-50301-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 27E7EAE3D4B
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 12:51:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AB8D116D0DA
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 10:49:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11CB1239E97;
	Mon, 23 Jun 2025 10:48:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PYEM387M"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F409136988;
	Mon, 23 Jun 2025 10:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750675733; cv=none; b=Cn9YU/BcSu0ikrEG2rS1ME8ydxP9Fs9PApaw30iA1Qy0NuSAAQ3AtOTds75YpIQZX9tG0PHFVs3fHenDt44TVhvbe5TNmne2M4N3GMPrGDy+d3y/tngAiERLme7NxJUAFVvC9FQbYiO8Q5Jdw3ytOhRI80DFkUVSYiu6w1fuQP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750675733; c=relaxed/simple;
	bh=GeiFc7fkYtw2PiNgSxLbHE9VEewIkyxJ97+h2sDlPWE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BBgUFfvV9JXGrRP2PjGYBBKIUDxMYFGOKB+TO2Xi5vZU4Ncn/kMZxCHIhaE5gbqW3UUFsltqBVDv2aCSJDibqeXxYUGh4QF3r3dLsFk0bSaqVnK8KRqdspZNyimQaQ8fpJpKxy3wyRRF1fXQkI9JRSltOJvwC9uBttU5EzfCEk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PYEM387M; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B19AC4CEF2;
	Mon, 23 Jun 2025 10:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750675732;
	bh=GeiFc7fkYtw2PiNgSxLbHE9VEewIkyxJ97+h2sDlPWE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PYEM387M2psgVE2tb0EwhsInLMPQjhG7/iZjloP4oYCadD9zFGQjfoCkngU2nBn4j
	 ZtjKAHh/K0U5HyjNhPn8LgGC3mrFLOf2cy1tzTfy9Wj/Ds31wly05dSbbxaYhKsItd
	 O13P4GBuwDHshV1nkSwnQCSPg2G0fN1yd7BJV7RgsMv7+kLRFbYizrWLeQlFINhEPm
	 JLTSPH/Cs3R43kdHUJHONuE2Zq3CXb/6bOmSa90m9TnPQ8/eRMWhsqOS9FgUsyDZSb
	 bFYKhdqVb3JincAkzMdkR0dqzVYxdhHOytVPtYRg/bOeZJYJo+P8XitEmpBg/re+L0
	 OvPgeesbzz7LQ==
Date: Mon, 23 Jun 2025 16:15:13 +0530
From: Naveen N Rao <naveen@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Paolo Bonzini <pbonzini@redhat.com>, Joerg Roedel <joro@8bytes.org>, 
	David Woodhouse <dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	iommu@lists.linux.dev, linux-kernel@vger.kernel.org, Sairaj Kodilkar <sarunkod@amd.com>, 
	Vasant Hegde <vasant.hegde@amd.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Joao Martins <joao.m.martins@oracle.com>, Francesco Lavra <francescolavra.fl@gmail.com>, 
	David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v3 17/62] KVM: SVM: Add enable_ipiv param, never set
 IsRunning if disabled
Message-ID: <basmpkilvhmg52pktjkpkqwmfcx2nnpbv75c6dxs73w7ehnwam@yyeft6vgabk7>
References: <20250611224604.313496-2-seanjc@google.com>
 <20250611224604.313496-19-seanjc@google.com>
 <2eqjnjnszlmhlnvw6kcve4exjnpy7skguypwtmxutb2gecs3an@gcou53thsqww>
 <aFVylP1XzMoqocOx@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aFVylP1XzMoqocOx@google.com>

On Fri, Jun 20, 2025 at 07:39:16AM -0700, Sean Christopherson wrote:
> On Thu, Jun 19, 2025, Naveen N Rao wrote:
> > On Wed, Jun 11, 2025 at 03:45:20PM -0700, Sean Christopherson wrote:
> > > From: Maxim Levitsky <mlevitsk@redhat.com>
> > > 
> > > Let userspace "disable" IPI virtualization for AVIC via the enable_ipiv
> > > module param, by never setting IsRunning.  SVM doesn't provide a way to
> > > disable IPI virtualization in hardware, but by ensuring CPUs never see
> > > IsRunning=1, every IPI in the guest (except for self-IPIs) will generate a
> > > VM-Exit.
> > 
> > I think this is good to have regardless of the erratum. Not sure about VMX,
> > but does it make sense to intercept writes to the self-ipi MSR as well?
> 
> That doesn't work for AVIC, i.e. if the guest is MMIO to access the virtual APIC.

Right, I was thinking about the Self-IPI MSR, but the ICR will also need 
to be intercepted.

> 
> Regardless, I don't see any reason to manually intercept self-IPIs when IPI
> virtualization is disabled.  AFAIK, there's no need to do so for correctness,
> and Intel's self-IPI virtualization isn't tied to IPI virtualization either.
> Self-IPI virtualization is enabled by virtual interrupt delivery, which in turn
> is enabled by KVM when enable_apicv is true:
> 
>   Self-IPI virtualization occurs only if the “virtual-interrupt delivery”
>   VM-execution control is 1.

Excellent, for this patch:
Reviewed-by: Naveen N Rao (AMD) <naveen@kernel.org>

Thanks,
Naveen

