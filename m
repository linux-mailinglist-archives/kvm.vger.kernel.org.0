Return-Path: <kvm+bounces-25959-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A006396DE77
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2024 17:37:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E4D13B211CE
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2024 15:37:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B14D419D895;
	Thu,  5 Sep 2024 15:37:49 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8781349630
	for <kvm@vger.kernel.org>; Thu,  5 Sep 2024 15:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725550669; cv=none; b=dF6Jqbs4u+OmSkXH9fGTjJ5xYL2akKetPoNLiG7cOWJNrytZoD2z46Oxzhx/9aJjVTyvwQ+wIeZHbXEQKwWG0rQyy5hKn6CXbSY6BbJyDITtagmf+/TbDAXrOaFMFNjsH//fhLrwcS4IIQv4f/7vVaIqXh9k9quLdEXmtAcvY8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725550669; c=relaxed/simple;
	bh=sdrEi2mbWLJaX/PRLp9kc2aep1cLeaLKEG5CEoDrwf4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u75I7HmvSVnsbfxmIuEMQVt/sy+QDQ4QW9zWlFeThDReg9eH8WUU7udREsq/xHjkaE1rgjD7kivHM7c2GNt3iWBWkx8V0FZmJXUvCZIIcBHrs5giYoeMYO7LZHa5v6hv8zDX5cFHiwFa0/FtOOwWKCBT9YA7WvnqnrmhY3R6hWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3E3F9FEC;
	Thu,  5 Sep 2024 08:38:08 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 028173F73B;
	Thu,  5 Sep 2024 08:37:39 -0700 (PDT)
Date: Thu, 5 Sep 2024 16:37:34 +0100
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v2 12/16] KVM: arm64: Implement AT S1PIE support
Message-ID: <20240905153734.GA4157679@e124191.cambridge.arm.com>
References: <20240903153834.1909472-1-maz@kernel.org>
 <20240903153834.1909472-13-maz@kernel.org>
 <20240905135820.GA4142389@e124191.cambridge.arm.com>
 <86ikvaup12.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86ikvaup12.wl-maz@kernel.org>

On Thu, Sep 05, 2024 at 03:57:13PM +0100, Marc Zyngier wrote:
> Hi Joey,
> 
> Thanks for having a look.
> 
> On Thu, 05 Sep 2024 14:58:20 +0100,
> Joey Gouly <joey.gouly@arm.com> wrote:
> > 
> > Hello Marc!
> > 
> > >  static void compute_s1_permissions(struct kvm_vcpu *vcpu, u32 op,
> > >  				   struct s1_walk_info *wi,
> > >  				   struct s1_walk_result *wr,
> > >  				   struct s1_perms *s1p)
> > >  {
> > > -	compute_s1_direct_permissions(vcpu, wi, wr, s1p);
> > > +	if (!s1pie_enabled(vcpu, wi->regime))
> > > +		compute_s1_direct_permissions(vcpu, wi, wr, s1p);
> > > +	else
> > > +		compute_s1_indirect_permissions(vcpu, wi, wr, s1p);
> > > +
> > >  	compute_s1_hierarchical_permissions(vcpu, wi, wr, s1p);
> > 
> > Is this (and the previous patch to split this up) right?
> > 
> > Looking at this from the ARM ARM (ARM DDI 0487K.a):
> > 
> > 	R JHSVW If Indirect permissions are used, then hierarchical
> > 	permissions are disabled and TCR_ELx.HPDn are RES 1.
> 
> Odd. I was convinced that it was when S1POE is enabled that HPs were
> disabled. But you are absolutely right, and it is once more proven
> that I can't read. Oh well.

For POE there is:

	RBVXDG Hierarchical Permissions are disabled and the TCR_ELx.{HPD0, HPD1} bits are RES1 for stage 1 of a translation
	regime using VMSAv8-64 if one or more of POE and E0POE (for EL1&0, EL2&0) is enabled for that translation
	regime.

> 
> Not to worry, I've since found other issues with this series. I have
> forgotten the patch dealing with the fast path on another branch, and
> since decided that TCR2_EL2 needed extra care to cope with individual
> features being disabled.
> 
> The rework is still useful, as I'm looking at POE as well, but I need
> to hoist the HP stuff up a notch.
> 
> I'll repost things once I've sorted these things up.

I think the rest of this patch looked fine though.

> 
> Thanks again,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.

