Return-Path: <kvm+bounces-14303-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C1A878A1DEB
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 20:21:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7723C1F25A55
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 18:21:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB91C7EF06;
	Thu, 11 Apr 2024 17:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nYYjl2Bd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA3A67BAF8;
	Thu, 11 Apr 2024 17:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712856859; cv=none; b=O4RBrxkvsT6xSjfQUjyB0SIJzV6XkwlhkYiO8EqwsSpmHgSm1tQ+Yyd1p3EZdhdqnLun0PU9wcd6vPJBCS+VidMTHr3M0IF1CvdFNaLcE3QvWdI6VUF8Mv5ikhNhYRV7Du1hSn4Da3dZEHApB2aB80kuHJVTg7Ys0yRaMerKRTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712856859; c=relaxed/simple;
	bh=BXJ4rYsFbdYq9tuBBdm+ZHYZ7dtQaqzMQCkTTRJEguM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nVBE21As3dBckQM7HblcyuF//r2SbGeuGJ5rqn6QIY83oocrwogzE5hrdbjUhIn0IClcHWhE6KLQx1dJfp8zlAYLNsxB+DZtynGaKqlz3VrhntCCZoZW99JKpBmE15MOLgMbS/JOPJ+4DkktGQEwTR8yXnX97y7O3lqgOcfWEnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nYYjl2Bd; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712856858; x=1744392858;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BXJ4rYsFbdYq9tuBBdm+ZHYZ7dtQaqzMQCkTTRJEguM=;
  b=nYYjl2BdvuWHTjgH62UrtFEwqOC4rrOHudWzWkXhG5qTQGnMbJptUEK9
   4QQza+YCHxk+q4AHVI+h1gZF9DB3sKKJXCZk6vSw593PCrU9C+aYjVxJ7
   mdVkvBAqvjF8YRwjuwSHkr3/v5R7nOI63ZzDhQag5u2URdM1oT/u08TYN
   pHvIsxZ7ZQxCjLwm/vSAAPCNjLhmgZLp/ckx57blIrQmRUobq/w5jWUwe
   Z2DPWQ+22eElkav8bDs9hKy7YCcKg4osYo8cXUWuDLx6DQfLUAlj/BMVj
   enLrc+Jle1Xgt/uKUWXYu1OVeT7QJIjsoSurHNDEs8nE6Sqb6DwM0OqC/
   A==;
X-CSE-ConnectionGUID: NTWoEdsfTZq/jU2ijd5QpQ==
X-CSE-MsgGUID: F3JHQ9KjQC+a7ynt+XCMgw==
X-IronPort-AV: E=McAfee;i="6600,9927,11041"; a="19437589"
X-IronPort-AV: E=Sophos;i="6.07,193,1708416000"; 
   d="scan'208";a="19437589"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2024 10:34:17 -0700
X-CSE-ConnectionGUID: 18gQPbGiQouq/wmAbL8AxQ==
X-CSE-MsgGUID: m8ZxjFTcTxWns/sMaxePEA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,193,1708416000"; 
   d="scan'208";a="25759756"
Received: from jacob-builder.jf.intel.com (HELO jacob-builder) ([10.54.39.125])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2024 10:34:17 -0700
Date: Thu, 11 Apr 2024 10:38:47 -0700
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, X86 Kernel <x86@kernel.org>, Peter
 Zijlstra <peterz@infradead.org>, "iommu@lists.linux.dev"
 <iommu@lists.linux.dev>, Thomas Gleixner <tglx@linutronix.de>, Lu Baolu
 <baolu.lu@linux.intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "Hansen, Dave" <dave.hansen@intel.com>, Joerg Roedel <joro@8bytes.org>, "H.
 Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>, Ingo Molnar
 <mingo@redhat.com>, "Luse, Paul E" <paul.e.luse@intel.com>, "Williams, Dan
 J" <dan.j.williams@intel.com>, Jens Axboe <axboe@kernel.dk>, "Raj, Ashok"
 <ashok.raj@intel.com>, "maz@kernel.org" <maz@kernel.org>,
 "seanjc@google.com" <seanjc@google.com>, Robin Murphy
 <robin.murphy@arm.com>, "jim.harris@samsung.com" <jim.harris@samsung.com>,
 "a.manzanares@samsung.com" <a.manzanares@samsung.com>, Bjorn Helgaas
 <helgaas@kernel.org>, "Zeng, Guang" <guang.zeng@intel.com>,
 "robert.hoo.linux@gmail.com" <robert.hoo.linux@gmail.com>,
 jacob.jun.pan@linux.intel.com
Subject: Re: [PATCH v2 08/13] x86/irq: Install posted MSI notification
 handler
Message-ID: <20240411103847.57f47a48@jacob-builder>
In-Reply-To: <BN9PR11MB5276C4932F6CFD217CC50AD78C052@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240405223110.1609888-1-jacob.jun.pan@linux.intel.com>
	<20240405223110.1609888-9-jacob.jun.pan@linux.intel.com>
	<BN9PR11MB5276C4932F6CFD217CC50AD78C052@BN9PR11MB5276.namprd11.prod.outlook.com>
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

Hi Kevin,

On Thu, 11 Apr 2024 07:52:28 +0000, "Tian, Kevin" <kevin.tian@intel.com>
wrote:

> > From: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > Sent: Saturday, April 6, 2024 6:31 AM
> > 
> > +
> > +/*
> > + * De-multiplexing posted interrupts is on the performance path, the
> > code
> > + * below is written to optimize the cache performance based on the
> > following
> > + * considerations:
> > + * 1.Posted interrupt descriptor (PID) fits in a cache line that is
> > frequently
> > + *   accessed by both CPU and IOMMU.
> > + * 2.During posted MSI processing, the CPU needs to do 64-bit read and
> > xchg
> > + *   for checking and clearing posted interrupt request (PIR), a 256
> > bit field
> > + *   within the PID.
> > + * 3.On the other side, the IOMMU does atomic swaps of the entire PID
> > cache
> > + *   line when posting interrupts and setting control bits.
> > + * 4.The CPU can access the cache line a magnitude faster than the
> > IOMMU.
> > + * 5.Each time the IOMMU does interrupt posting to the PIR will evict
> > the PID
> > + *   cache line. The cache line states after each operation are as
> > follows:
> > + *   CPU		IOMMU			PID Cache line
> > state
> > + *   ---------------------------------------------------------------
> > + *...read64					exclusive
> > + *...lock xchg64				modified
> > + *...			post/atomic swap	invalid
> > + *...-------------------------------------------------------------
> > + *  
> 
> According to VT-d spec: 5.2.3 Interrupt-Posting Hardware Operation:
> 
> "
> - Read contents of the Posted Interrupt Descriptor, claiming exclusive
>   ownership of its hosting cache-line.
>   ...
> - Modify the following descriptor field values atomically:
>   ...
> - Promote the cache-line to be globally observable, so that the
> modifications are visible to other caching agents. Hardware may
> write-back the cache-line anytime after this step.
> "
> 
> sounds that the PID cache line is not evicted after IOMMU posting?
IOMMU follows the same MESI protocol defined in SDM. VT-d spec. also says
"This atomic read-modify-write operation will always snoop processor caches"

So if the PID cache line is in modified state (caused by writing ON bit,
clear PIR, etc.), IOMMU request ownership will evict the cache.


Thanks,

Jacob

