Return-Path: <kvm+bounces-15121-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B0F28AA1C1
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 20:06:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7C1D11C20FF1
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 18:05:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E719A179956;
	Thu, 18 Apr 2024 18:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bRQBvS3H"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86478175552;
	Thu, 18 Apr 2024 18:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713463552; cv=none; b=DD9KH3o9PRNUoa2zIFgtMOMqtPJvLFjJcYYSXVtu/eQfVZOwTBVuH1V+//UTMxaUpSkzzh8Zp+kpC5zTVfet3gkjHOIz0LrHAQnoEz4GyQPSky+Y3gzn0fDS0197TtLKFH9w/De8encs5DQ1a6tRtF6pTueNLGG4OIAIWr1YD6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713463552; c=relaxed/simple;
	bh=UHN9/iLhwy7XwyYNUPmUuZCVMwtBGVwjLhwBImjcW3k=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=j8d0HhNN5tRqIX029MAVgmSysahSOus3YDuzYPc7VYge/g6/bFNrCllKerKYGUi8oTOC1T2fANSrWwNaVdKDVICi8jmxusF1ykj51jqGF9mY2WJm1Lvmh3wktrpP60416mXhg7p0zsq0TTWUhipDvqc/qOitHaxbB1PouLvSSdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bRQBvS3H; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713463550; x=1744999550;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UHN9/iLhwy7XwyYNUPmUuZCVMwtBGVwjLhwBImjcW3k=;
  b=bRQBvS3Hs/ruNvL4j2NVTMAvu+YYzFOATLj4UHty4e3z+k8VPSqa3R6d
   MiFNuTfRTjQP/5KoO5bVP1qoSH4PLIYB6DzHAWQ/LbDUV7BeX/vlhDWzm
   LceELYuhBtuNREBgLAP54XOX7XjnPwbTu/V52L84yhqjOiqhffLlgjr9+
   N6G8NydpLoUnZ0uHMGPU+xCS9WGd2n9GJ9UQNSQ/7eTJqEEFawaQS054B
   AGhXUk5O76GIBvrca8+CIKiV/UyDHQnpWTy7cqnpL+f8BiMlCXmA3YDKL
   sgluorsVjOWt2qDcB5WfpGlFkSsn/77a896AsM03mmDPUtCdDQ7d4XPcR
   g==;
X-CSE-ConnectionGUID: dUv7SPFGRbaD4zk06Eth0g==
X-CSE-MsgGUID: zgEivhkdSXWaZlsJI9BJAQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11047"; a="11977317"
X-IronPort-AV: E=Sophos;i="6.07,212,1708416000"; 
   d="scan'208";a="11977317"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2024 11:05:49 -0700
X-CSE-ConnectionGUID: YaL3ncS1Su+LuCzG6gfi1A==
X-CSE-MsgGUID: Y6AeD5voQ5qMqlYMs/So9g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,212,1708416000"; 
   d="scan'208";a="53990641"
Received: from jacob-builder.jf.intel.com (HELO jacob-builder) ([10.54.39.125])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2024 11:05:50 -0700
Date: Thu, 18 Apr 2024 11:10:24 -0700
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Sean Christopherson <seanjc@google.com>, LKML
 <linux-kernel@vger.kernel.org>, X86 Kernel <x86@kernel.org>, Peter Zijlstra
 <peterz@infradead.org>, iommu@lists.linux.dev, Lu Baolu
 <baolu.lu@linux.intel.com>, kvm@vger.kernel.org, Dave Hansen
 <dave.hansen@intel.com>, Joerg Roedel <joro@8bytes.org>, "H. Peter Anvin"
 <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>, Ingo Molnar
 <mingo@redhat.com>, Paul Luse <paul.e.luse@intel.com>, Dan Williams
 <dan.j.williams@intel.com>, Jens Axboe <axboe@kernel.dk>, Raj Ashok
 <ashok.raj@intel.com>, Kevin Tian <kevin.tian@intel.com>, maz@kernel.org,
 Robin Murphy <robin.murphy@arm.com>, jim.harris@samsung.com,
 a.manzanares@samsung.com, Bjorn Helgaas <helgaas@kernel.org>,
 guang.zeng@intel.com, robert.hoo.linux@gmail.com, oliver.sang@intel.com,
 jacob.jun.pan@linux.intel.com
Subject: Re: [PATCH v2 03/13] x86/irq: Remove bitfields in posted interrupt
 descriptor
Message-ID: <20240418111024.615aa95e@jacob-builder>
In-Reply-To: <87wmouy3w3.ffs@tglx>
References: <20240405223110.1609888-1-jacob.jun.pan@linux.intel.com>
	<20240405223110.1609888-4-jacob.jun.pan@linux.intel.com>
	<Zh8aTitLwSYYlZW5@google.com>
	<20240417110131.4aaf1d66@jacob-builder>
	<87wmouy3w3.ffs@tglx>
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

On Thu, 18 Apr 2024 19:30:52 +0200, Thomas Gleixner <tglx@linutronix.de>
wrote:

> On Wed, Apr 17 2024 at 11:01, Jacob Pan wrote:
> > On Tue, 16 Apr 2024 17:39:42 -0700, Sean Christopherson
> > <seanjc@google.com> wrote:  
> >> > diff --git a/arch/x86/kvm/vmx/posted_intr.c
> >> > b/arch/x86/kvm/vmx/posted_intr.c index af662312fd07..592dbb765675
> >> > 100644 --- a/arch/x86/kvm/vmx/posted_intr.c
> >> > +++ b/arch/x86/kvm/vmx/posted_intr.c
> >> > @@ -107,7 +107,7 @@ void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int
> >> > cpu)
> >> >  		 * handle task migration (@cpu != vcpu->cpu).
> >> >  		 */
> >> >  		new.ndst = dest;
> >> > -		new.sn = 0;
> >> > +		new.notif_ctrl &= ~POSTED_INTR_SN;    
> >> 
> >> At the risk of creating confusing, would it make sense to add
> >> double-underscore, non-atomic versions of the set/clear helpers for ON
> >> and SN?
> >> 
> >> I can't tell if that's a net positive versus open coding clear() and
> >> set() here and below.  
> > IMHO, we can add non-atomic helpers when we have more than one user for
> > each operation.
> >
> > I do have a stupid bug here, it should be:
> > -               new.notif_ctrl &= ~POSTED_INTR_SN;
> > +               new.notif_ctrl &= ~BIT(POSTED_INTR_SN);  
> 
> That's a perfect reason to use a proper helper.
I just proved I was wrong:) will do.

Thanks,

Jacob

