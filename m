Return-Path: <kvm+bounces-8580-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D73A08526D2
	for <lists+kvm@lfdr.de>; Tue, 13 Feb 2024 02:44:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8B8AA1F2432F
	for <lists+kvm@lfdr.de>; Tue, 13 Feb 2024 01:44:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF63078B46;
	Tue, 13 Feb 2024 01:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="F22wHHPl"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9176379DB6;
	Tue, 13 Feb 2024 01:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.55.52.88
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707786275; cv=none; b=W8sum9mhpUEmAYhXZYH/6nK2ALGSFuDs/3Nzt1QlRp+Xq57YV6l6sg6i/26bgeNlfGmLAMv/lGMMpGn++cNPPRJvc/LDhAIAy2zRAcC6xpJMZ5Naz/JmA1FH8YjZzIVBWOafwD9LT8xEF5/S1f/KIEwHI5mXYvqMnBJLVqAvJ2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707786275; c=relaxed/simple;
	bh=rPkyRn3h/xI5tyHZCWp4P0ZLlst3DRj0eD9GNA7385w=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kxUB/ym7E6BhOITI9e9CD9EDZrH9e5JC0llLxEYtAZZ73/5iCiKRNSgq8d2FPEETEoOIuXqErhzvQCnCOiiYa74who+sa7kOS908w/IkXO5LkC6ljy3V4o3t5HvkT6JdNNSe8YYY+FkKnAfPIFqfbj4lJKg3RrhlrOAd9LqljtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=F22wHHPl; arc=none smtp.client-ip=192.55.52.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707786273; x=1739322273;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rPkyRn3h/xI5tyHZCWp4P0ZLlst3DRj0eD9GNA7385w=;
  b=F22wHHPlYgipUYHDbf6oRD3GhgQO7NR1D1AxvQa/7XlWIQ6RzOSN352u
   /Mhhm06dUwy91yOlf+LRWPFP1PkuG+SyL4OkN2jj1NRybx18Vk6xeNHjt
   cZYHCYqFqTQFvUpMIISHVqrFpHTlZzxQcO692a+Nt/kMNz9KkfKF+Zfkj
   FpBgTGJ9fQyT92Ci7wXFsILSBrcAjcyzvtyD4vzlyTHtyLbf/NCynNl8c
   K/BKW5lMjbefExriKGp8NVzYcZklE/ItB1VrQbERSI/1DYH1fM5IfUH3F
   MgC5+tevTh/bi94gRAubaZTshaMncVlSug3+WwPMjxFLCBniXS6f0Wsc/
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10982"; a="436927567"
X-IronPort-AV: E=Sophos;i="6.06,155,1705392000"; 
   d="scan'208";a="436927567"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2024 17:04:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10982"; a="911650880"
X-IronPort-AV: E=Sophos;i="6.06,155,1705392000"; 
   d="scan'208";a="911650880"
Received: from jacob-builder.jf.intel.com (HELO jacob-builder) ([10.24.100.114])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2024 17:04:32 -0800
Date: Mon, 12 Feb 2024 17:10:00 -0800
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: LKML <linux-kernel@vger.kernel.org>, X86 Kernel <x86@kernel.org>, Peter
 Zijlstra <peterz@infradead.org>, iommu@lists.linux.dev, Thomas Gleixner
 <tglx@linutronix.de>, Lu Baolu <baolu.lu@linux.intel.com>,
 kvm@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>, Joerg Roedel
 <joro@8bytes.org>, "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov
 <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>, Paul Luse
 <paul.e.luse@intel.com>, Dan Williams <dan.j.williams@intel.com>, Raj Ashok
 <ashok.raj@intel.com>, "Tian, Kevin" <kevin.tian@intel.com>,
 maz@kernel.org, seanjc@google.com, Robin Murphy <robin.murphy@arm.com>,
 jacob.jun.pan@linux.intel.com, "Lantz, Philip" <philip.lantz@intel.com>
Subject: Re: [PATCH 00/15] Coalesced Interrupt Delivery with posted MSI
Message-ID: <20240212171000.253813ee@jacob-builder>
In-Reply-To: <2aa290eb-ec4b-43b1-87db-4df8ccbeaa37@kernel.dk>
References: <20240126234237.547278-1-jacob.jun.pan@linux.intel.com>
	<051cf099-9ecf-4f5a-a3ac-ee2d63a62fa6@kernel.dk>
	<20240209094307.4e7eacd0@jacob-builder>
	<9285b29c-6556-46db-b0bb-7a85ad40d725@kernel.dk>
	<20240212102742.34e1e2c2@jacob-builder>
	<2aa290eb-ec4b-43b1-87db-4df8ccbeaa37@kernel.dk>
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

Hi Jens,

On Mon, 12 Feb 2024 11:36:42 -0700, Jens Axboe <axboe@kernel.dk> wrote:

> > For the record, here is my set up and performance data for 4 Samsung
> > disks. IOPS increased from 1.6M per disk to 2.1M. One difference I
> > noticed is that IRQ throughput is improved instead of reduction with
> > this patch on my setup. e.g. BEFORE: 185545/sec/vector 
> >      AFTER:  220128  
> 
> I'm surprised at the rates being that low, and if so, why the posted MSI
> makes a difference? Usually what I've seen for IRQ being slower than
> poll is if interrupt delivery is unreasonably slow on that architecture
> of machine. But ~200k/sec isn't that high at all.

Even at ~200k/sec, I am seeing around 75% ratio between posted interrupt
notification and MSIs. i.e. for every 4 MSIs, we save one CPU notification.
That might be where the savings come from.

I was expecting an even or reduction in CPU notifications but more MSI
throughput. Instead, Optane gets less MSIs/sec as your data shows.

Is it possible to get the interrupt coalescing ratio on your set up? ie.
PMN count in cat /proc/interrupts divided by total NVME MSIs.

Here is a summary of my testing on 4 Samsung Gen 5 drives:
test cases		IOPS*1000	ints/sec(MSI)*
=================================================
aio 			6348		182218
io_uring		6895		207932
aio w/ posted MSI	8295		185545
io_uring w/ post MSI	8811		220128
io_uring poll_queue	13000		0
================================================


Thanks,

Jacob

