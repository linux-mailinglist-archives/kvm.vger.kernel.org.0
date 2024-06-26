Return-Path: <kvm+bounces-20579-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 470AF919B71
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2024 01:55:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A624B283CE7
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 23:55:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0F721946AD;
	Wed, 26 Jun 2024 23:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="BI8cmKs7"
X-Original-To: kvm@vger.kernel.org
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 309AA194159
	for <kvm@vger.kernel.org>; Wed, 26 Jun 2024 23:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719446139; cv=none; b=OPPSmhDQkevYCD88cy6tV0widd1owkw6mR4paHPhuZNhW84HWRCt8qy+QxB+zcbogPxRaBcBLEdXzJUgxe7BB28nBS6nx9N0N0nsuVlbyr0aq3Zd24lW2pnBhkYsbQpGopIxDAJsIYLaxeC15yNYoiglRHWvf29L0Y1RrkLMV88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719446139; c=relaxed/simple;
	bh=DChNOV7eKFR74vjJV7cooi/IxTjttEFhGUmfC06vs50=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gmQqOJnz8HSapwrqnLPpdB02gt2zwWFEkDa8FJbKrOXpJDaXC+EHSAiaS6Qz7cf/pMzHWf2u01ofYqXNK1fpDJj13u8FxeyVU71kIP/PwbYGDEvx4X9fJWlv5Kc6s+iYae4zQQ3k2i+Fife/BDBxb4m7EridVJqlaIK67V5KpGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=BI8cmKs7; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: maz@kernel.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1719446133;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TGfl0vQIVVIIo5O6ugRFyaaCUBEAQaTPfBkSo6iTFPo=;
	b=BI8cmKs7KEPRTFEE1djUAEi6xujzVRypiyOGttiIlzUZYx4l5JImLDXcfFyqj+96hKuTxZ
	V/empXYqbyyTbXQk3YNlI2zzn2nUyAp0OkHB7PystjPgi8dK/I18Bo41wW/aPdRK0YS5LP
	GrGxJw6IBZ2qJyaNqGrQvVvOPPAokG4=
X-Envelope-To: joey.gouly@arm.com
X-Envelope-To: kvmarm@lists.linux.dev
X-Envelope-To: linux-arm-kernel@lists.infradead.org
X-Envelope-To: kvm@vger.kernel.org
X-Envelope-To: james.morse@arm.com
X-Envelope-To: suzuki.poulose@arm.com
X-Envelope-To: yuzenghui@huawei.com
Date: Wed, 26 Jun 2024 23:55:28 +0000
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 1/5] KVM: arm64: Correctly honor the presence of FEAT_TCRX
Message-ID: <ZnyqcMPGyZs07N6B@linux.dev>
References: <20240625130042.259175-1-maz@kernel.org>
 <20240625130042.259175-2-maz@kernel.org>
 <20240625143734.GA1517668@e124191.cambridge.arm.com>
 <86r0ckj30i.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86r0ckj30i.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Tue, Jun 25, 2024 at 07:22:53PM +0100, Marc Zyngier wrote:
> On Tue, 25 Jun 2024 15:37:34 +0100,
> Joey Gouly <joey.gouly@arm.com> wrote:
> > 
> > On Tue, Jun 25, 2024 at 02:00:37PM +0100, Marc Zyngier wrote:
> > > We currently blindly enable TCR2_EL1 use in a guest, irrespective
> > > of the feature set. This is obviously wrong, and we should actually
> > > honor the guest configuration and handle the possible trap resulting
> > > from the guest being buggy.
> > > 
> > > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > > ---
> > >  arch/arm64/include/asm/kvm_arm.h | 2 +-
> > >  arch/arm64/kvm/sys_regs.c        | 9 +++++++++
> > >  2 files changed, 10 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
> > > index b2adc2c6c82a5..e6682a3ace5af 100644
> > > --- a/arch/arm64/include/asm/kvm_arm.h
> > > +++ b/arch/arm64/include/asm/kvm_arm.h
> > > @@ -102,7 +102,7 @@
> > >  #define HCR_HOST_NVHE_PROTECTED_FLAGS (HCR_HOST_NVHE_FLAGS | HCR_TSC)
> > >  #define HCR_HOST_VHE_FLAGS (HCR_RW | HCR_TGE | HCR_E2H)
> > >  
> > > -#define HCRX_GUEST_FLAGS (HCRX_EL2_SMPME | HCRX_EL2_TCR2En)
> > > +#define HCRX_GUEST_FLAGS (HCRX_EL2_SMPME)
> > >  #define HCRX_HOST_FLAGS (HCRX_EL2_MSCEn | HCRX_EL2_TCR2En | HCRX_EL2_EnFPM)
> > >  
> > >  /* TCR_EL2 Registers bits */
> > > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > > index 22b45a15d0688..71996d36f3751 100644
> > > --- a/arch/arm64/kvm/sys_regs.c
> > > +++ b/arch/arm64/kvm/sys_regs.c
> > > @@ -383,6 +383,12 @@ static bool access_vm_reg(struct kvm_vcpu *vcpu,
> > >  	bool was_enabled = vcpu_has_cache_enabled(vcpu);
> > >  	u64 val, mask, shift;
> > >  
> > > +	if (reg_to_encoding(r) == SYS_TCR2_EL1 &&
> > > +	    !kvm_has_feat(vcpu->kvm, ID_AA64MMFR3_EL1, TCRX, IMP)) {
> > > +		kvm_inject_undefined(vcpu);
> > > +		return false;
> > > +	}
> > > +
> > 
> > If we need to start doing this with more vm(sa) registers, it might make sense
> > to think of a way to do this without putting a big if/else in here.  For now
> > this is seems fine.
> 
> One possible solution would be to mimic the FGU behaviour and have a
> shadow version of HCRX_EL2 that only indicates the trap routing code
> that something trapped through that bit needs to UNDEF.

Seems reasonable, but that'll be the problem for the _next_ person to
add an affected register ;-)

-- 
Thanks,
Oliver

