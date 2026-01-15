Return-Path: <kvm+bounces-68262-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 41D79D29099
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 23:33:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9BC50309BC20
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 22:32:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA93032C949;
	Thu, 15 Jan 2026 22:32:46 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97C112E090B
	for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 22:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768516366; cv=none; b=dJ8uizY+n7fb2i8dzkhtjIwPJ/4oRaXXPZQoBmTI7Zh/4MV+tXDXQRx0iuD/y1G7beKKSV3/P62NE3OQ5mPqJD25psiItHDLa5gNxu7VnPTuDuzKdK6Tz2j2HIBKyxPhcDSaxRdJTWtehLm+hOa71Rxa5xmCh2ibN6loXGu9MM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768516366; c=relaxed/simple;
	bh=p4Ebc87ASzcaCgPWg+YOqfXTIPlgejw1M4LpLbgL/So=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IXxlfNXoup8TNEtoVb2AmNfsxAsMVPgPpTwPU/N9VuApmCbv/GNvAyQ6djRL5hZOTpf+U76JQopl/6oU+lzLTaqP64BB34nWfpSAeKbhyLAgu3GT6eYV+tfEZ5xXNm7878RMMlvClia/Uj+Xn7/kZbPxfmH2SLAZ+6zVLCYlTTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 445611515;
	Thu, 15 Jan 2026 14:32:37 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C0C423F632;
	Thu, 15 Jan 2026 14:32:42 -0800 (PST)
Date: Thu, 15 Jan 2026 22:32:37 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: Andrew Jones <andrew.jones@linux.dev>
Cc: kvm@vger.kernel.org, alexandru.elisei@arm.com, eric.auger@redhat.com,
	maz@kernel.org, kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [kvm-unit-tests PATCH v5 00/11] arm64: EL2 support
Message-ID: <20260115223237.GA1087383@e124191.cambridge.arm.com>
References: <20260114115703.926685-1-joey.gouly@arm.com>
 <csscff65cagzfgyvsseufdqupde64z5x73llmzgzci7u43pzbs@fv7pfn4jxrdv>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <csscff65cagzfgyvsseufdqupde64z5x73llmzgzci7u43pzbs@fv7pfn4jxrdv>

On Thu, Jan 15, 2026 at 11:40:12AM -0600, Andrew Jones wrote:
> On Wed, Jan 14, 2026 at 11:56:52AM +0000, Joey Gouly wrote:
> > Hi all,
> > 
> > This series is for adding support to running the kvm-unit-tests at EL2.
> > 
> > Changes since v4[1]:
> > 	- changed env var to support EL2=1,y,Y
> > 	- replaced ifdef in selftest with test_exception_prep()
> > 
> > Thanks,
> > Joey
> > 
> > [1] https://lore.kernel.org/kvmarm/20251204142338.132483-1-joey.gouly@arm.com/
> >
> 
> Hi Joey,
> 
> So this series doesn't appear to regress current tests, but it also
> doesn't seem to completely work. I noticed these issues when running
> with EL2=1 (there could be more):
> 
>  - timer test times out
>  - all debug-bp fail
>  - all watchpoint received tests fail for debug-wp
>  - micro-bench hits the assert in gicv3_lpi_alloc_tables()
>    lib/arm/gic-v3.c:183: assert failed: gicv3_data.redist_base[cpu]: Redistributor for cpu0 not initialized. Did cpu0 enable the GIC?

Timer and micro-bench are unexpected, maybe regressed, I will investigate.

debug/watchpoint I knew about, would be good if we could skip those, and
someone more knowledgeable about debug could figure out the issue there?

Thanks,
Joey

> 
> Thanks,
> drew

