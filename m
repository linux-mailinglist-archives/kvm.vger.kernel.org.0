Return-Path: <kvm+bounces-45094-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 18BC7AA5F8D
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 15:53:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E3C8F7AA927
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 13:51:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0ECFF1D54C0;
	Thu,  1 May 2025 13:52:57 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 215031A08B8
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 13:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746107576; cv=none; b=ed4/Q8wQtGEJdxxsQjwTok9PHivH2pw9QB+Pe4ktFNMGoUcGf/j4XijmKZngOV94pe84VwSoNXq2jxUD7yUZIyUeHONngVE83P063g4IHONalVsPatlSj/q1ztVA1t8eNH3rOglpqQjNCJR/uTz2lPLLVr4M6KiQaL+ydIDp1mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746107576; c=relaxed/simple;
	bh=6yDp8glkjJeZQXTs9XrMQjX3ielx2fKfRZU/2JdmlCY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GxzJvKwJxAd5aK9qjg2Pw9Oh60oVmjeh/URuU2UlV7mM0QSsck6nbkWIMlYi7rEW4Jp/4B4mywEHq+AhArDhbgY80pEGavv/BQKIhNcmazU8yWzYNyhO8A9bFCSXWRpNcuS+3eRpbVfnelAeI7IHV/0rimtC8ltk/A1fD2rkb38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E6025168F;
	Thu,  1 May 2025 06:52:46 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 88A463F673;
	Thu,  1 May 2025 06:52:52 -0700 (PDT)
Date: Thu, 1 May 2025 14:52:47 +0100
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>, Fuad Tabba <tabba@google.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v3 08/42] arm64: sysreg: Add registers trapped by
 HFG{R,W}TR2_EL2
Message-ID: <20250501135247.GA2195277@e124191.cambridge.arm.com>
References: <20250426122836.3341523-1-maz@kernel.org>
 <20250426122836.3341523-9-maz@kernel.org>
 <20250501101136.GE1859293@e124191.cambridge.arm.com>
 <86wmb0h2ap.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86wmb0h2ap.wl-maz@kernel.org>

On Thu, May 01, 2025 at 02:46:06PM +0100, Marc Zyngier wrote:
> On Thu, 01 May 2025 11:11:36 +0100,
> Joey Gouly <joey.gouly@arm.com> wrote:
> > 
> > On Sat, Apr 26, 2025 at 01:28:02PM +0100, Marc Zyngier wrote:
> > > Bulk addition of all the system registers trapped by HFG{R,W}TR2_EL2.
> > > 
> > > The descriptions are extracted from the BSD-licenced JSON file part
> > > of the 2025-03 drop from ARM.
> > > 
> > > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > > ---
> > >  arch/arm64/tools/sysreg | 395 ++++++++++++++++++++++++++++++++++++++++
> > >  1 file changed, 395 insertions(+)
> > > 
> > > diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
> > > index 6433a3ebcef49..7969e632492bb 100644
> > > --- a/arch/arm64/tools/sysreg
> > > +++ b/arch/arm64/tools/sysreg
> > > @@ -2068,6 +2068,26 @@ Field	1	A
> > >  Field	0	M
> > >  EndSysreg
> > >  
> > > +Sysreg	SCTLR_EL12      3	5	1	0	0
> > > +Mapping	SCTLR_EL1
> > > +EndSysreg
> > > +
> > > +Sysreg	SCTLRALIAS_EL1  3	0	1	4	6
> > > +Mapping	SCTLR_EL1
> > > +EndSysreg
> > > +
> > > +Sysreg	ACTLR_EL1	3	0	1	0	1
> > > +Field   63:0    IMPDEF
> > > +EndSysreg
> > > +
> > > +Sysreg	ACTLR_EL12      3	5	1	0	1
> > > +Mapping	ACTLR_EL1
> > > +EndSysreg
> > > +
> > > +Sysreg	ACTLRALIAS_EL1  3	0	1	4	5
> > > +Mapping	ACTLR_EL1
> > > +EndSysreg
> > > +
> > 
> > Do you want to update CPACR_EL1 while you're at it, so that it matches
> > CPACRMASK_EL1?
> 
> Do you mean adding the TAM and TCPAC bits added by FEAT_NV2p1? Sure,
> no problem. I'll probably add that as a separate patch though, as I
> want this one to only be concerned with the FEAT_FGT2-controlled
> accessors.

Yep, sounds good.

> 
> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.

