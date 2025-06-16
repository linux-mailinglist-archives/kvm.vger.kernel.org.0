Return-Path: <kvm+bounces-49641-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2550CADBDAA
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 01:33:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CBCA4175AF5
	for <lists+kvm@lfdr.de>; Mon, 16 Jun 2025 23:33:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 758242264D0;
	Mon, 16 Jun 2025 23:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="El/fY8UI"
X-Original-To: kvm@vger.kernel.org
Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3F892BF01B
	for <kvm@vger.kernel.org>; Mon, 16 Jun 2025 23:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750116822; cv=none; b=TdF4lnEN1mYzSkFTn1b4PkzakcHj58HH6CpYbN76CQ95tFZVK6tS38oyp5wNch+WpFVkYQTb5n0K/LqnCUXDKLJ8ioF2cl5LjIHzT74GDYC/ZD8IU/Bp/5B+VUi1nxfG8dTIn2SDVs/dzCP7vGDCvdVbrP2Uy0iaT/Z7/Or/gWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750116822; c=relaxed/simple;
	bh=r9V7Lv9bIf/ES5N/fxOfdN1RijU6kclvrc1CLeiQvxM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sIhTFDmVQg7UAEnPMr/c+Go+ClSaj45s6pyRqZFFehoCs+epHxG9RZsi5WmYS4QKFwIrXbuJ0G/3vi8aq6ypx5wywzvo0xua+qCWxZomHwQWQrOmaxCHLcZ5yyzktN5C/cpG6MEH4lsKL9lmZrYlF8K2h549I2DAaqUGpmDbNEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=El/fY8UI; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=Content-Type:MIME-Version:Message-ID:Subject:From:Date:From
	:Subject; bh=FQ9AVie1G3opC6SktC6DwSQCFYiO015Exy38SxOe1kk=; b=El/fY8UIGmwy+hKD
	EFhjQDl6etqkbrwFleIO3W6yF4k4S3PZaDqzEGa53I6uVPjWSrA2OMlrnk29YkRiUrNi5Fv76onDf
	g3hkgz9OhChZS8KQ4s7LqiwkmLLP54gyWaymsal1W0yypK8KBWOZms7pY8LHapFvYT4fG+q2mRMwk
	odt08sf/0Ld6EXU3ftcHABuXhS51hlEDB+OjXpUtX+pdCiwKSXfK5IHBzyAhKj39W42jChEG/SpfA
	wlt2AFahovgmX0NYmA+3vlj9OUg5uEiK+Y9JsI0lqQNaQvQZc8/BfUkw9fE+hlboBNxrFIePOImfH
	pgA0S/LMuz7lF5pinw==;
Received: from dg by mx.treblig.org with local (Exim 4.96)
	(envelope-from <dg@treblig.org>)
	id 1uRJKO-009ze4-2z;
	Mon, 16 Jun 2025 23:33:24 +0000
Date: Mon, 16 Jun 2025 23:33:24 +0000
From: "Dr. David Alan Gilbert" <dave@treblig.org>
To: "Moger, Babu" <babu.moger@amd.com>
Cc: pbonzini@redhat.com, zhao1.liu@intel.com, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, davydov-max@yandex-team.ru
Subject: Re: [PATCH v7 4/6] target/i386: Add couple of feature bits in
 CPUID_Fn80000021_EAX
Message-ID: <aFCpxId3J3E1rNHL@gallifrey>
References: <cover.1746734284.git.babu.moger@amd.com>
 <a5f6283a59579b09ac345b3f21ecb3b3b2d92451.1746734284.git.babu.moger@amd.com>
 <aELfPr7snDmIirNk@gallifrey>
 <e7cdab23-de40-457d-aa69-f0e210206c16@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e7cdab23-de40-457d-aa69-f0e210206c16@amd.com>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/6.1.0-34-amd64 (x86_64)
X-Uptime: 23:28:48 up 50 days,  7:42,  1 user,  load average: 0.00, 0.00, 0.00
User-Agent: Mutt/2.2.12 (2023-09-09)

* Moger, Babu (babu.moger@amd.com) wrote:
> Hi Dave,
> 
> On 6/6/25 07:29, Dr. David Alan Gilbert wrote:
> > * Babu Moger (babu.moger@amd.com) wrote:
> >> Add CPUID bit indicates that a WRMSR to MSR_FS_BASE, MSR_GS_BASE, or
> >> MSR_KERNEL_GS_BASE is non-serializing amd PREFETCHI that the indicates
> >> support for IC prefetch.
> >>
> >> CPUID_Fn80000021_EAX
> >> Bit    Feature description
> >> 20     Indicates support for IC prefetch.
> >> 1      FsGsKernelGsBaseNonSerializing.
> > 
> > I'm curious about this:
> >   a) Is this new CPUs are non-serialising on that write?
> >   b) If so, what happens if you run existing kernels/firmware on them?
> >   c) Bonus migration question; what happens if you live migrate from a host
> >      that claims to be serialising to one that has the extra non-serialising
> >      flag but is disabled in the emulated CPU model.
> 
> Good question. After looking at the AMD64 Architecture Programmer’s Manual
> again, these writes have always been non-serializing. Behavior has not
> changed.

Ah OK, then nothing to worry about.

> We're just reporting it through CPUID now. This information
> likely isn’t being used anywhere.

Seems curious to add it then!

> Let me know if you have any questions.

No, thanks for the reply.

Dave

> -- 
> Thanks
> Babu Moger
-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    |       Running GNU/Linux       | Happy  \ 
\        dave @ treblig.org |                               | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/

