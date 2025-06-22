Return-Path: <kvm+bounces-50258-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C84B6AE2FEF
	for <lists+kvm@lfdr.de>; Sun, 22 Jun 2025 14:38:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 83EC03B3F83
	for <lists+kvm@lfdr.de>; Sun, 22 Jun 2025 12:37:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB64D1DF75A;
	Sun, 22 Jun 2025 12:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="hryIEMqT"
X-Original-To: kvm@vger.kernel.org
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 030822EAE5
	for <kvm@vger.kernel.org>; Sun, 22 Jun 2025 12:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750595881; cv=none; b=g0EDr9ucPV5As2kV+6zWyfQzLk8+V8UYaskq9Oj7AfzO3ArEROhGisRiw91It6kR+gKsksMuEYmZMyPFJ3jCAMR1GN2QPgI2kGxBmKILLATKjDblenWJI6w6FTiN1TEGhOEH9S3G3rxD48cPT/yMXKcdZ6EQ/v7UQbBSDNB/uRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750595881; c=relaxed/simple;
	bh=r2TLNHjXaxZ9qUZ1DaLfD5bMfQRPRiHSifyWV5+2nV8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rPYpf8YwzrgtBXcGKdaR3ingq0D2JxPShZkrAVkUBReZxJEtZ9D6ar0JJz69ghaVGHIkw+UABssjz/8L6mQTSs/PkXqhw+ND49/oG0RVbcmLBplmfBiCOsJtd8lJYHShY7ZGfoknDJn24AssRShiWJzrUBr+cstvzHHRQMRZjm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=hryIEMqT; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Sun, 22 Jun 2025 05:37:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750595866;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=G39kGGdgOel5ks2KWoZBvfJhe96q0aex/pRGhaP2C9A=;
	b=hryIEMqT69op4L3cD0N+MNzE3Zcl3j93X5eviPv4N/kD4wosCzZHFO4+k+yidbkKl1X2Ml
	dRmyMpTYrBM4k1BgLFLAfx+/A/U2efpcJ4JpnChuBkpWs8OpuN7BkD8BSEfx2gMFLk8dCk
	npfA2UPVzonkTcQe9i5LKkkIrpK1Yzs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: Sascha Bischoff <Sascha.Bischoff@arm.com>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, nd <nd@arm.com>,
	Joey Gouly <Joey.Gouly@arm.com>,
	Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	"will@kernel.org" <will@kernel.org>,
	"tglx@linutronix.de" <tglx@linutronix.de>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Timothy Hayes <Timothy.Hayes@arm.com>
Subject: Re: [PATCH 4/5] KVM: arm64: gic-v5: Support GICv3 compat
Message-ID: <aFf5EYvF3NVr9MKm@linux.dev>
References: <20250620160741.3513940-1-sascha.bischoff@arm.com>
 <20250620160741.3513940-5-sascha.bischoff@arm.com>
 <aFXClKQRG3KNAD2y@linux.dev>
 <87a560ezpa.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a560ezpa.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Sun, Jun 22, 2025 at 01:19:13PM +0100, Marc Zyngier wrote:
> On Fri, 20 Jun 2025 21:20:36 +0100,
> Oliver Upton <oliver.upton@linux.dev> wrote:
> > 
> > Hi Sascha,
> > 
> > Thank you for posting this. Very excited to see the GICv5 enablement get
> > started.
> > 
> > On Fri, Jun 20, 2025 at 04:07:51PM +0000, Sascha Bischoff wrote:
> > > Add support for GICv3 compat mode (FEAT_GCIE_LEGACY) which allows a
> > > GICv5 host to run GICv3-based VMs. This change enables the
> > > VHE/nVHE/hVHE/protected modes, but does not support nested
> > > virtualization.
> > 
> > Can't we just load the shadow state into the compat VGICv3? I'm worried
> > this has sharp edges on the UAPI side as well as users wanting to
> > migrate VMs to new hardware.
> >
> > The guest hypervisor should only see GICv3-only or GICv5-only, we can
> > pretend FEAT_GCIE_LEGACY never existed :)
> 
> That's exactly what this does. And the only reason NV isn't supported
> yet is the current BET0 spec makes ICC_SRE_EL2 UNDEF at EL1 with NV,
> which breaks NV in a spectacular way.

Gee, I wonder how... :)

> This will be addressed in a future revision of the architecture, and
> no HW will actually be built with this defect. As such, there is no
> UAPI to break.

That's fine by me. TBH, when I left this comment I hadn't fully read the
patch yet and was more curious about the intent.

> > > +void __vgic_v3_compat_mode_disable(void)
> > > +{
> > > +	sysreg_clear_set_s(SYS_ICH_VCTLR_EL2, ICH_VCTLR_EL2_V3, 0);
> > > +	isb();
> > > +}
> > > +
> > 
> > It isn't clear to me what these ISBs are synchonizing against. AFAICT,
> > the whole compat thing is always visible and we can restore the rest of
> > the VGICv3 context before guaranteeing the enable bit has been observed.
> 
> No, some registers have a behaviour that is dependent on the status of
> the V3 bit (ICH_VMCR_EL2 being one), so that synchronisation is
> absolutely needed before accessing this register.

Yeah, I had followed up on this after reading the spec, modal registers
are great. Putting all the constituent registers together in the common
load/put helpers will clear that up.

> The disabling is probably the wrong way around though, and I'd expect
> the clearing of V3 to have an ISB *before* the write to the sysreg,
> 
> > Can we consolidate this into a single hyp call along with
> > __vgic_v3_*_vmcr_aprs()?
> 
> I agree that we should be able to move this to be driven by
> load/put entirely.
> 
> But we first need to fix the whole WFI sequencing first, because this
> is a bit of a train wreck at the moment (entering the WFI emulation
> results in *two* "put" sequences on the vgic, and exiting WFI results
> in two loads).

You're talking about the case where halt polling fails and we do a
put/load on the whole vCPU to schedule right? i.e. in addition to the
explicit put on the vgic for faithful emulation.

Thanks,
Oliver

