Return-Path: <kvm+bounces-51031-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AF822AEC198
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 22:56:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 07F9E3AE0BF
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 20:55:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D022E2ED857;
	Fri, 27 Jun 2025 20:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ryxq9xyO"
X-Original-To: kvm@vger.kernel.org
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E8A72ECE84
	for <kvm@vger.kernel.org>; Fri, 27 Jun 2025 20:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751057750; cv=none; b=bc9PZnRTBnfOaBG4u8K5iPHc+xecHvdf8be2BXCRLgFl8N7YexyZZy82xpms5KRJCRDm/9Xy6vU/8CVsv07Ir0NU88p4tB0j0w8oVKPUxr/Oc65wrt90lRdBWEMn6nZib3Z0rCQdE1JiI+ZkRSSh3ywL4y7/EcgwJDznPeWpGak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751057750; c=relaxed/simple;
	bh=38GaMaW/B7zHBvh1tFU9ANgBBdPtUjqbBkbeYoWb7Go=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jhNpQIkYwUPIeZKi4IS3QZ8NBSSwUQx/INbFnCEiM2O0bon9jwtUVjGzHTAEgU1IxPO/1CJdHEt8bCnfhg4FiBTnDdsU2Sz8p4dkjoV8kbv+fxLhIScjIqhTSJghAes7HXvoQfpkCNJ2Bdkbuzwu7Dk/EMN8psYJ6KvJld5bwlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ryxq9xyO; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 27 Jun 2025 13:55:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1751057734;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1AMsankqQ7fXut//cwhaRHpcwwLLJJgqr0ZblnCJIz0=;
	b=ryxq9xyOHz5HcEmHKXHWirB5Xpi7L1zTlBdjMXx/7++C8tCcdl/h+rYXtM3iVSXvEC7B7P
	11j/UAoaFs0ZNl9IKeMbblgKhnCbvPA0ZkwN1k+IBnrMoa6O9wiT7rXXgf42CoURxWxwZk
	pXvRVVgsa3Hiney2sAnFfkyylePCAqU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Colton Lewis <coltonlewis@google.com>
Cc: Ben Horgan <ben.horgan@arm.com>, kvm@vger.kernel.org,
	pbonzini@redhat.com, corbet@lwn.net, linux@armlinux.org.uk,
	catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	mizhang@google.com, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, mark.rutland@arm.com, shuah@kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v3 02/22] arm64: Generate sign macro for sysreg Enums
Message-ID: <aF8FPTupC_VnAldN@linux.dev>
References: <603eb4c7-5570-438c-b747-cdcc67b09ea6@arm.com>
 <gsntecv49aml.fsf@coltonlewis-kvm.c.googlers.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <gsntecv49aml.fsf@coltonlewis-kvm.c.googlers.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Jun 27, 2025 at 08:45:38PM +0000, Colton Lewis wrote:
> Hi Ben. Thanks for the review.
> 
> Ben Horgan <ben.horgan@arm.com> writes:
> 
> > Hi Colton,
> 
> > On 6/26/25 21:04, Colton Lewis wrote:
> > > There's no reason Enums shouldn't be equivalent to UnsignedEnums and
> > > explicitly specify they are unsigned. This will avoid the annoyance I
> > > had with HPMN0.
> > An Enum can be annotated with the field's sign by updating it to
> > UnsignedEnum or SignedEnum. This is explained in [1].
> 
> > With this change ID_AA64PFR1_EL1.MTE_frac would be marked as unsigned
> > when it should really be considered signed.
> 
> > Enum	43:40	MTE_frac
> > 	0b0000	ASYNC
> > 	0b1111	NI
> > EndEnum
> 
> Thanks for the explanation. I made this a separate commit because I
> considered people might object and HPMN0 is already an UnsignedEnum in
> my previous commit.
> 
> Do you think it would be a good idea to make plain Enums signed by
> default or should I just remove this commit from the series?

It is presumptive to associate a sign with an enumeration. Generally
speaking, the only fields that can do signed / unsigned comparisons are
the Feature ID register fields.

So please drop this and only keep the change for HPMN0.

Thanks,
Oliver

> > > Signed-off-by: Colton Lewis <coltonlewis@google.com>
> > > ---
> > >    arch/arm64/tools/gen-sysreg.awk | 1 +
> > >    1 file changed, 1 insertion(+)
> 
> > > diff --git a/arch/arm64/tools/gen-sysreg.awk
> > > b/arch/arm64/tools/gen-sysreg.awk
> > > index f2a1732cb1f6..fa21a632d9b7 100755
> > > --- a/arch/arm64/tools/gen-sysreg.awk
> > > +++ b/arch/arm64/tools/gen-sysreg.awk
> > > @@ -308,6 +308,7 @@ $1 == "Enum" && (block_current() == "Sysreg" ||
> > > block_current() == "SysregFields
> > >    	parse_bitdef(reg, field, $2)
> 
> > >    	define_field(reg, field, msb, lsb)
> > > +	define_field_sign(reg, field, "false")
> 
> > >    	next
> > >    }
> 
> > Thanks,
> 
> > Ben
> 
> > [1]
> > https://lore.kernel.org/all/20221207-arm64-sysreg-helpers-v4-1-25b6b3fb9d18@kernel.org/

