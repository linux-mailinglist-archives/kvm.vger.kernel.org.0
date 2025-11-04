Return-Path: <kvm+bounces-61957-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A2DAFC30565
	for <lists+kvm@lfdr.de>; Tue, 04 Nov 2025 10:48:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3A30E3B3977
	for <lists+kvm@lfdr.de>; Tue,  4 Nov 2025 09:41:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2E88306B0D;
	Tue,  4 Nov 2025 09:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="q4ejJ01C"
X-Original-To: kvm@vger.kernel.org
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ABF5200BA1
	for <kvm@vger.kernel.org>; Tue,  4 Nov 2025 09:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762249263; cv=none; b=ojjd1dOQx7X1sf0/nRZ60D/+ik7vBfe+hXk+ThSTLZhxRcx7q6gMFxRk/H50n2awHMQlX1Vf+G2REdvhuRGY1Hvh+kKaJVLuV2a2xDtC/pDpyQEFJYNsSIS/I6Wwq7UTgq3wqLR51KiRq5O1eavwzDQJCHjkJqvHoOFp9LW2fy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762249263; c=relaxed/simple;
	bh=qSCCfVq6lm9SqP8dFusqXopIHvIovaoe6ctAB1IHbyA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hl1pAnzqGo/6EF5KqPAGgmoe7pV0cg/BAItihhkXsn5zxVX0cOJP0fmP1Vpa5Lb1558thhW0MbM6ikQqDsrdZR4eIk8+8s2rDUL0zWVSJaHMwHGrgKfHRSmaYXU0bJ1CKQoNrC22NFEgwl8aCBUV7T3ht5LKZ+WiPqOXXXuerWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=q4ejJ01C; arc=none smtp.client-ip=115.124.30.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1762249252; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=rBdmFbAtZ4x0EBEmNprMJUgxsa3W4T6k8icJajXOb60=;
	b=q4ejJ01CUli15G5UoQTCmsRZwlge6SQGgkdSkZjbZoNM4I9udI0zMx0LwPZdek3ulel3iBp+jMP0JD0kNXXOBW9Qx8uhycNtzp/KAYmnCTN1L3wgUDkFg9n2aF0+Nv8b/T5FvWCgsZIjisewKXQeb4QwQt2bWBIAduRW4TeBI4g=
Received: from localhost(mailfrom:yaoyuan@linux.alibaba.com fp:SMTPD_---0WrgkE3J_1762249251 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 04 Nov 2025 17:40:52 +0800
Date: Tue, 4 Nov 2025 17:40:51 +0800
From: Yao Yuan <yaoyuan@linux.alibaba.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Zenghui Yu <yuzenghui@huawei.com>, Christoffer Dall <christoffer.dall@arm.com>, 
	Volodymyr Babchuk <Volodymyr_Babchuk@epam.com>
Subject: Re: [PATCH 05/33] KVM: arm64: GICv3: Detect and work around the lack
 of ICV_DIR_EL1 trapping
Message-ID: <fprfzs2qtlhxv7no4zmpjfrgs76shbcm7gs4lh5o55n6qxozso@4uoe6tuadnx3>
References: <20251103165517.2960148-1-maz@kernel.org>
 <20251103165517.2960148-6-maz@kernel.org>
 <eossoxorxj5knjyx2xglsrzhrbi6rry3rcr2xryfmft3q7up4b@tr5yrg6lljzq>
 <86ikfquq28.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86ikfquq28.wl-maz@kernel.org>

On Tue, Nov 04, 2025 at 09:04:15AM +0800, Marc Zyngier wrote:
> On Tue, 04 Nov 2025 08:50:26 +0000,
> Yao Yuan <yaoyuan@linux.alibaba.com> wrote:
> >
> > On Mon, Nov 03, 2025 at 04:54:49PM +0800, Marc Zyngier wrote:
> > > A long time ago, an unsuspecting architect forgot to add a trap
> > > bit for ICV_DIR_EL1 in ICH_HCR_EL2. Which was unfortunate, but
> > > what's a bit of spec between friends? Thankfully, this was fixed
> > > in a later revision, and ARM "deprecates" the lack of trapping
> > > ability.
> > >
> > > Unfortuantely, a few (billion) CPUs went out with that defect,
> > > anything ARMv8.0 from ARM, give or take. And on these CPUs,
> > > you can't trap DIR on its own, full stop.
> > >
> > > As the next best thing, we can trap everything in the common group,
> > > which is a tad expensive, but hey ho, that's what you get. You can
> > > otherwise recycle the HW in the neaby bin.
> > >
> > > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > > ---
> > >  arch/arm64/include/asm/virt.h  |  7 ++++++-
> > >  arch/arm64/kernel/cpufeature.c | 34 ++++++++++++++++++++++++++++++++++
> > >  arch/arm64/kernel/hyp-stub.S   |  5 +++++
> > >  arch/arm64/kvm/vgic/vgic-v3.c  |  3 +++
> > >  arch/arm64/tools/cpucaps       |  1 +
> > >  5 files changed, 49 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/arch/arm64/include/asm/virt.h b/arch/arm64/include/asm/virt.h
> > > index aa280f356b96a..8eb63d3294974 100644
> > > --- a/arch/arm64/include/asm/virt.h
> > > +++ b/arch/arm64/include/asm/virt.h
> > > @@ -40,8 +40,13 @@
> > >   */
> > >  #define HVC_FINALISE_EL2	3
> > >
> > > +/*
> > > + * HVC_GET_ICH_VTR_EL2 - Retrieve the ICH_VTR_EL2 value
> > > + */
> > > +#define HVC_GET_ICH_VTR_EL2	4
> > > +
> > >  /* Max number of HYP stub hypercalls */
> > > -#define HVC_STUB_HCALL_NR 4
> > > +#define HVC_STUB_HCALL_NR 5
> > >
> > >  /* Error returned when an invalid stub number is passed into x0 */
> > >  #define HVC_STUB_ERR	0xbadca11
> > > diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> > > index 5ed401ff79e3e..44103ad98805d 100644
> > > --- a/arch/arm64/kernel/cpufeature.c
> > > +++ b/arch/arm64/kernel/cpufeature.c
> > > @@ -2303,6 +2303,31 @@ static bool has_gic_prio_relaxed_sync(const struct arm64_cpu_capabilities *entry
> > >  }
> > >  #endif
> > >
> > > +static bool can_trap_icv_dir_el1(const struct arm64_cpu_capabilities *entry,
> > > +				 int scope)
> > > +{
> > > +	struct arm_smccc_res res = {};
> > > +
> > > +	BUILD_BUG_ON(ARM64_HAS_ICH_HCR_EL2_TDS <= ARM64_HAS_GICV3_CPUIF);
> > > +	BUILD_BUG_ON(ARM64_HAS_ICH_HCR_EL2_TDS <= ARM64_HAS_GICV5_LEGACY);
> > > +	if (!cpus_have_cap(ARM64_HAS_GICV3_CPUIF) ||
> > > +	    !cpus_have_cap(ARM64_HAS_GICV3_CPUIF))
> >
> > Duplicated checking ?
>
> Yup, cut'n'paste, and lack of GICv5 testing... This should really look

Thanks for the quick reply!

Oh, not awared that checking GICv5 is necessary here.
I looked v3/v4 spec before but stop before v5. Ok it's time to
have a look on v5.

> like the hack below, since GICv5 legacy feature is guaranteed to have
> TDIR:
>
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index 44103ad98805d..3f2d4b033966d 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -2310,13 +2310,15 @@ static bool can_trap_icv_dir_el1(const struct arm64_cpu_capabilities *entry,
>
>  	BUILD_BUG_ON(ARM64_HAS_ICH_HCR_EL2_TDS <= ARM64_HAS_GICV3_CPUIF);
>  	BUILD_BUG_ON(ARM64_HAS_ICH_HCR_EL2_TDS <= ARM64_HAS_GICV5_LEGACY);
> -	if (!cpus_have_cap(ARM64_HAS_GICV3_CPUIF) ||
> -	    !cpus_have_cap(ARM64_HAS_GICV3_CPUIF))
> +	if (!cpus_have_cap(ARM64_HAS_GICV3_CPUIF))
>  		return false;
>
>  	if (!is_hyp_mode_available())
>  		return false;
>
> +	if (cpus_have_cap(ARM64_HAS_GICV5_LEGACY))
> +		return true;
> +
>  	if (is_kernel_in_hyp_mode())
>  		res.a1 = read_sysreg_s(SYS_ICH_VTR_EL2);
>  	else
>
>
> Thanks for the heads-up!
>
> 	M.
>
> --
> Without deviation from the norm, progress is not possible.

