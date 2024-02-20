Return-Path: <kvm+bounces-9188-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 12BB985BD1B
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 14:24:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C26C52879FA
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 13:24:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A0226A32B;
	Tue, 20 Feb 2024 13:23:57 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DAB76A320
	for <kvm@vger.kernel.org>; Tue, 20 Feb 2024 13:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708435436; cv=none; b=j3ii+dFOXGmzi3m/+K5coV8sg4fq8atOXlizypOMsj83nYaf2nbLUcR3W1c2/OigLxLlFWgNCA5S3a+mq1ReAfkOJU6e5x+geeIXAsZCbjZav63oEGuaobYgYK70SmBVVcdM1xYyCqXlWbga852ptl1wm6Edyr+J/8ieB1FX+So=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708435436; c=relaxed/simple;
	bh=DeeXSvIxgYiYaGQcMq9PvMO7guh9vNjSt50+vBd21A8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KEvuUv4UIBeP3We2EF5F1jRPRyuawoQEvU+hThBT4jmKj11Bp/KBJ2Kx8QQUGbigjq1FG71pYI2RCE8zk3ao5/m3yVi2M44X2hpTz3ueCyIziZ9G5IcyYCpswvLyiHnb1TAUrSfoAtmc0xWJZN2WENC0Jkvg7gFrz4mHOSlY19U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1D125FEC;
	Tue, 20 Feb 2024 05:24:33 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B89923F73F;
	Tue, 20 Feb 2024 05:23:52 -0800 (PST)
Date: Tue, 20 Feb 2024 13:23:50 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH 02/13] KVM: arm64: Clarify ESR_ELx_ERET_ISS_ERET*
Message-ID: <20240220132350.GB8575@e124191.cambridge.arm.com>
References: <20240219092014.783809-1-maz@kernel.org>
 <20240219092014.783809-3-maz@kernel.org>
 <20240220113127.GB16168@e124191.cambridge.arm.com>
 <861q9748ut.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <861q9748ut.wl-maz@kernel.org>

On Tue, Feb 20, 2024 at 12:29:30PM +0000, Marc Zyngier wrote:
> On Tue, 20 Feb 2024 11:31:27 +0000,
> Joey Gouly <joey.gouly@arm.com> wrote:
> > 
> > On Mon, Feb 19, 2024 at 09:20:03AM +0000, Marc Zyngier wrote:
> > > The ESR_ELx_ERET_ISS_ERET* macros are a bit confusing:
> > > 
> > > - ESR_ELx_ERET_ISS_ERET really indicates that we have trapped an
> > >   ERETA* instruction, as opposed to an ERET
> > > 
> > > - ESR_ELx_ERET_ISS_ERETA reallu indicates that we have trapped
> > >   an ERETAB instruction, as opposed to an ERETAA.
> > > 
> > > Repaint the two helpers such as:
> > > 
> > > - ESR_ELx_ERET_ISS_ERET becomes ESR_ELx_ERET_ISS_ERETA
> > > 
> > > - ESR_ELx_ERET_ISS_ERETA becomes ESR_ELx_ERET_ISS_ERETAB
> > > 
> > > At the same time, use BIT() instead of raw values.
> > > 
> > > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > 
> > I'm somewhat against this, as the original names are what the Arm
> > ARM specifies.
> 
> I don't disagree, but that doesn't make the ARM ARM right! ;-)
> 
> > 
> > > ---
> > >  arch/arm64/include/asm/esr.h | 4 ++--
> > >  arch/arm64/kvm/handle_exit.c | 2 +-
> > >  2 files changed, 3 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
> > > index 353fe08546cf..72c7810ccf2c 100644
> > > --- a/arch/arm64/include/asm/esr.h
> > > +++ b/arch/arm64/include/asm/esr.h
> > > @@ -290,8 +290,8 @@
> > >  		 ESR_ELx_SYS64_ISS_OP2_SHIFT))
> > >  
> > >  /* ISS field definitions for ERET/ERETAA/ERETAB trapping */
> > > -#define ESR_ELx_ERET_ISS_ERET		0x2
> > > -#define ESR_ELx_ERET_ISS_ERETA		0x1
> > > +#define ESR_ELx_ERET_ISS_ERETA		BIT(1)
> > > +#define ESR_ELx_ERET_ISS_ERETAB		BIT(0)
> > >  
> > >  /*
> > >   * ISS field definitions for floating-point exception traps
> > > diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> > > index 617ae6dea5d5..0646c623d1da 100644
> > > --- a/arch/arm64/kvm/handle_exit.c
> > > +++ b/arch/arm64/kvm/handle_exit.c
> > > @@ -219,7 +219,7 @@ static int kvm_handle_ptrauth(struct kvm_vcpu *vcpu)
> > >  
> > >  static int kvm_handle_eret(struct kvm_vcpu *vcpu)
> > >  {
> > > -	if (kvm_vcpu_get_esr(vcpu) & ESR_ELx_ERET_ISS_ERET)
> > > +	if (kvm_vcpu_get_esr(vcpu) & ESR_ELx_ERET_ISS_ERETA)
> > 
> > If this part is confusing due to the name, maybe introduce a function in esr.h
> > esr_is_pac_eret() (name pending bikeshedding)?
> 
> That's indeed a better option. Now for the bikeshed aspect:
> 
> - esr_iss_is_eretax(): check for ESR_ELx_ERET_ISS_ERET being set
> 
> - esr_iss_is_eretab(): check for ESR_ELx_ERET_ISS_ERETA being set
> 
> Thoughts?
> 

I was trying to avoid the ERETA* confusion by suggesting 'pac_eret', but if I
were to pick between your options I'd pick esr_iss_is_eretax().

Thanks,
Joey

