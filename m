Return-Path: <kvm+bounces-14563-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BD05C8A3523
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 19:50:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5E0201F23F4E
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 17:50:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB58514E2EF;
	Fri, 12 Apr 2024 17:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nBeigbiD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7321214D29E;
	Fri, 12 Apr 2024 17:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712944210; cv=none; b=fvUz2gvMSM+qw7rJZE/dnYspzSJ5UHXd/76bp32LyWqTAiF+93ZmTMX9Bge9luU1fzj7PjX0AxLzbtUVe6spkVaok6f/NvJJsNeAMHXa3tl5qa1cpdPDjNYX8oDaVK3wryWq4mnKt/GenDGlpLpJRkx1lMgPESaUsAJIY3i6dOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712944210; c=relaxed/simple;
	bh=sQu31TKj1DykuJKDUxWpDtj7xAwMdG8O2RnnSSWBS5g=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WxnLU+SSaPEMGxobH276nROtM2BCnZomARt346F+eAI0aAXSwa5j7NdBdbifNfQgzan//JV8x+W3V93dgsPHnxKd41h/CPqX9aSNoHVgD1+835sXoJEGO+6VsV4ValXt7nSdcLwQculrop6rJR5t1B0Yy5QQ/pxhBl2/H97Ww/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nBeigbiD; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712944210; x=1744480210;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sQu31TKj1DykuJKDUxWpDtj7xAwMdG8O2RnnSSWBS5g=;
  b=nBeigbiDKJYV6/1ZTKVab89uK9xzVrUosCK2BCdjLXKHHyPPsM43nDvQ
   DnQmzPmWTgEcH+A4Xfws82dPLYI2nApNvgNoxmAeYppQKuE+8ll9sQ0Hu
   HCnlQs8cnwPX+067YrJfPiumPwwG0WtJCoy9ofHq2KUlU8OFLvG/9IKf5
   kWKUK+WNl6PiI+1hSA7J3EdTAw3x10kRcIyNMfs5EePjJKzV+di4oa2MN
   +RM17pK2jCbyxiXxX25jWoYgcB35O1gcIYGGEJ1ytKya2R9rwOfBeXrL1
   Oy6TY7CeWEd3cPRXPFGS8jKVoQmzBplzhwctRVHOj8y89KZLJmmHRmTW8
   A==;
X-CSE-ConnectionGUID: 522dSkskSMC1nJVgEHFDmA==
X-CSE-MsgGUID: tjd5DmhRRU+SJueWOuP4Sg==
X-IronPort-AV: E=McAfee;i="6600,9927,11042"; a="8586232"
X-IronPort-AV: E=Sophos;i="6.07,196,1708416000"; 
   d="scan'208";a="8586232"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2024 10:50:09 -0700
X-CSE-ConnectionGUID: xrZhma/XTdiCshLxpuCXCA==
X-CSE-MsgGUID: A55UTogyQJ+4WxvqXu3GaA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,196,1708416000"; 
   d="scan'208";a="21380981"
Received: from jacob-builder.jf.intel.com (HELO jacob-builder) ([10.54.39.125])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2024 10:50:08 -0700
Date: Fri, 12 Apr 2024 10:54:39 -0700
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
Subject: Re: [PATCH v2 06/13] x86/irq: Set up per host CPU posted interrupt
 descriptors
Message-ID: <20240412105439.37aa12cc@jacob-builder>
In-Reply-To: <BN9PR11MB527696368E4022DBAC9DD7768C042@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240405223110.1609888-1-jacob.jun.pan@linux.intel.com>
	<20240405223110.1609888-7-jacob.jun.pan@linux.intel.com>
	<BN9PR11MB527696368E4022DBAC9DD7768C042@BN9PR11MB5276.namprd11.prod.outlook.com>
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

On Fri, 12 Apr 2024 09:16:25 +0000, "Tian, Kevin" <kevin.tian@intel.com>
wrote:

> > From: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > Sent: Saturday, April 6, 2024 6:31 AM
> > 
> > +#ifdef CONFIG_X86_POSTED_MSI
> > +
> > +/* Posted Interrupt Descriptors for coalesced MSIs to be posted */
> > +DEFINE_PER_CPU_ALIGNED(struct pi_desc, posted_interrupt_desc);  
> 
> 'posted_msi_desc' to be more accurate?
makes sense, will do.

Thanks,

Jacob

