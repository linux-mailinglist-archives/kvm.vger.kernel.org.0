Return-Path: <kvm+bounces-8633-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 37FF9853AE3
	for <lists+kvm@lfdr.de>; Tue, 13 Feb 2024 20:26:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E4DE828D2D2
	for <lists+kvm@lfdr.de>; Tue, 13 Feb 2024 19:26:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36FA460878;
	Tue, 13 Feb 2024 19:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="e1z/5+iT"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDC05605C8;
	Tue, 13 Feb 2024 19:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707852376; cv=none; b=Bb4AMFNc5tzTW3q74rEBQPbrChm3b0xo4m/MLm+f15/r+p6hzGmcH8Ry9NBsowjb97QQvc3wC9mCGWNCGMQgaOEvfAr8byXe8+8Lp6KvVEQUNqaUKij7BEGIV1uhBAW0fvCNH8jhBvlsjJUA/YrtvjBGZIzjch4NYXPgv8dJSkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707852376; c=relaxed/simple;
	bh=BO77RV+GIQjk9Z58R/dxnr2s1En8OoXSBgchfvm6cJM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ioBZZSDFGjC1uBh6HF/CzRMxxhJjSIJPYLeM6nyueTkSGIzXT1+PmxqriLMiJ+FQ+u/6Mh7TRr5oQVUzhqQ4JaOmMuH6yp6A92qNup/dB7pCFdI5XLD127bkfjb8AHw/j5rb/W+OJ1Oe6+daqFq89//h3JzJwDe2ZcZqmLrh0A4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=e1z/5+iT; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707852376; x=1739388376;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BO77RV+GIQjk9Z58R/dxnr2s1En8OoXSBgchfvm6cJM=;
  b=e1z/5+iTWeS/YkGImRHey+UW9D9G7rOTtjWSlm2l56ffSx3W/ceT2H5t
   pB2LfLKWzXwN5RCqnsQaciyq6aEbOtgirorX5kqSSTnGwLsAHUVmRgn8h
   KlHmaOgwYwSqIjLHcP1va1hU6VLopS4LErQjZQpdR33EmiV4zKl1OQWep
   3JHPj38xWUd2dS0xV2r8GxSQkH7MAmeH4nZHg4hyT5SA+viDJF5SFVbA6
   sTO34EzfXR07k4xAiGOnFC/k/iFh0zG6XUUYu43UnweuGC2Qo8P3oDdha
   XNVPl0uluaPnNLc9pHZkjmCo9P2oPaVCdOnLypOcZ4KB6FPFfFXtebb6A
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10982"; a="12967593"
X-IronPort-AV: E=Sophos;i="6.06,158,1705392000"; 
   d="scan'208";a="12967593"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2024 11:26:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,158,1705392000"; 
   d="scan'208";a="7731030"
Received: from jacob-builder.jf.intel.com (HELO jacob-builder) ([10.24.100.114])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2024 11:26:14 -0800
Date: Tue, 13 Feb 2024 11:31:42 -0800
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, X86 Kernel <x86@kernel.org>,
 iommu@lists.linux.dev, Lu Baolu <baolu.lu@linux.intel.com>,
 kvm@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>, Joerg Roedel
 <joro@8bytes.org>, "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov
 <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>, Raj Ashok
 <ashok.raj@intel.com>, "Tian, Kevin" <kevin.tian@intel.com>,
 maz@kernel.org, peterz@infradead.org, seanjc@google.com, Robin Murphy
 <robin.murphy@arm.com>, jacob.jun.pan@linux.intel.com
Subject: Re: [PATCH RFC 12/13] iommu/vt-d: Add a helper to retrieve PID
 address
Message-ID: <20240213113142.6b7459e1@jacob-builder>
In-Reply-To: <87le7oixk4.ffs@tglx>
References: <20231112041643.2868316-1-jacob.jun.pan@linux.intel.com>
	<20231112041643.2868316-13-jacob.jun.pan@linux.intel.com>
	<874jgvuls0.ffs@tglx>
	<20240126153047.5e42e5d0@jacob-builder>
	<87le7oixk4.ffs@tglx>
Organization: OTC
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Hi Thomas,

On Tue, 13 Feb 2024 09:21:47 +0100, Thomas Gleixner <tglx@linutronix.de>
wrote:

> > Here the parent APIC chip does apic_set_affinity() which will set up
> > effective mask before posted MSI affinity change.
> >
> > Maybe I missed some cases?  
> 
> The function is only used in intel_ir_reconfigure_irte_posted() in the
> next patch, but it's generally available. So I asked that question
> because if it's called in some other context then it's going to be not
> guaranteed.
> 
> That also begs the question why this function exists in the first
> place. This really can be part of intel_ir_reconfigure_irte_posted(),
> which makes it clear what the context is, no?
Make sense, will fold it in next time.

Thanks,

Jacob

