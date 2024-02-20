Return-Path: <kvm+bounces-9203-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A96985BFB2
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 16:19:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9E3941C21474
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 15:19:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77CFF7602D;
	Tue, 20 Feb 2024 15:19:01 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF3C374E3A
	for <kvm@vger.kernel.org>; Tue, 20 Feb 2024 15:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708442341; cv=none; b=r86dG/8K1hHAMyp5p3Y+EYX6WLZBQBSJkX1JgPlTb4aCvr9hT2lHMcyy02iWtMcIi3FOry1vIU6XiPLQvoIS3/K404LJbvOt9sNpT15oK54WMvvWx98cXatRXDCXDbkflm1sK57uPCEqWg4C1FQiupZey5CubDzIRGyMvKDrsOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708442341; c=relaxed/simple;
	bh=8M1w/VdbQnHgutFm242Apw7ANRyCWUvBTMdLcLoDsjs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PFXzteDi3odlIsQBp8fSgLtHCB1DCSEHhN1FoJThTX0xGviTfTcnn2+dJlvf3/ZyJE8Xrkg5XjjEgydc8z0ZOUgR/V/L9jfXG2I8Mgc6VIQ8yTiUXGmm2aO4sEkli2UkOYjMbNRRVNEu4ENbRtQ8XzXI2pq9sdSmu9mrM8EoUIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3728EFEC;
	Tue, 20 Feb 2024 07:19:38 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D9B093F73F;
	Tue, 20 Feb 2024 07:18:57 -0800 (PST)
Date: Tue, 20 Feb 2024 15:18:51 +0000
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
Message-ID: <20240220151851.GA57578@e124191.cambridge.arm.com>
References: <20240219092014.783809-1-maz@kernel.org>
 <20240219092014.783809-3-maz@kernel.org>
 <20240220113127.GB16168@e124191.cambridge.arm.com>
 <861q9748ut.wl-maz@kernel.org>
 <20240220132350.GB8575@e124191.cambridge.arm.com>
 <86zfvv2qys.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86zfvv2qys.wl-maz@kernel.org>

On Tue, Feb 20, 2024 at 01:41:15PM +0000, Marc Zyngier wrote:
> On Tue, 20 Feb 2024 13:23:50 +0000,
> Joey Gouly <joey.gouly@arm.com> wrote:
> > 
> > On Tue, Feb 20, 2024 at 12:29:30PM +0000, Marc Zyngier wrote:
> > > On Tue, 20 Feb 2024 11:31:27 +0000,
> > > Joey Gouly <joey.gouly@arm.com> wrote:
> > > > 
> > > > If this part is confusing due to the name, maybe introduce a function in esr.h
> > > > esr_is_pac_eret() (name pending bikeshedding)?
> > > 
> > > That's indeed a better option. Now for the bikeshed aspect:
> > > 
> > > - esr_iss_is_eretax(): check for ESR_ELx_ERET_ISS_ERET being set
> > > 
> > > - esr_iss_is_eretab(): check for ESR_ELx_ERET_ISS_ERETA being set
> > > 
> > > Thoughts?
> > > 
> > 
> > I was trying to avoid the ERETA* confusion by suggesting 'pac_eret', but if I
> > were to pick between your options I'd pick esr_iss_is_eretax().
> 
> It's not an either/or situation. We actually need both:
> 
> - esr_iss_is_eretax() being true tells you that you need to
>   authenticate the ERET
> 
> - esr_iss_is_eretab() tells you that you need to use the A or B key

Oh right, yes that makes sense (please add a brief comment like ^ above the
functions)

Thanks,
Joey

