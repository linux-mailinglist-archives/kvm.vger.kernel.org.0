Return-Path: <kvm+bounces-14704-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0891C8A5E1A
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 01:16:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 80475B21ACE
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 23:16:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58B16158DCC;
	Mon, 15 Apr 2024 23:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="i2AKXiXY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42E60158D61;
	Mon, 15 Apr 2024 23:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713222976; cv=none; b=sxx1ZGEceozDM7QaOdegXJ1x/IXk1kLT0GtCOanUc3Y1qXaq9vV/3+VSGEMYqUtgO4E3GTOboIBMKJ+kVSaNX8etQL8FsuFjlIHHjPYjuMbF0c16liOmYnl0976/HdT/slFweOkmxZrLHohvw6Hmau+hc+x2ZSSWhHAEhcvmUsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713222976; c=relaxed/simple;
	bh=7B0+vlNEjkd3v4+xOWiFJOgf2HlzQA09AZVPsetgOhM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ezU6EMd3boOBtl5OGF1CxY9znKBhrT7JXHSq9EqfuXSimdAU4CcooXxnD1EtkD6Rp+HNRZ27g1w9dOzv9Q9Xj+DT3c2uHqpvl1lZIlMIiGlL31P4osOSUAxaTt0Ht3w2YaeFAF9T2/Rmk9N01/vPT3XFE2BKk6Uor802AkPb0c8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=i2AKXiXY; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713222976; x=1744758976;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7B0+vlNEjkd3v4+xOWiFJOgf2HlzQA09AZVPsetgOhM=;
  b=i2AKXiXYx9qF4XDQapP335mvoJx1a7SgU9uPs49KkIQ/QHlUzTo6P33W
   g/zmzRypm87QEB2ul2QfmkALBd+05RB+oUbwKa4J/XXkpTa6Tti8clcv2
   51PJZwZvOnUSjo+wQSZI5WbAzHbchfZSJnlxFWkKOYRc8P+IDodatx4F2
   Tcdwz60biPPkQO4w5eC0HyzC/hAVwezrkUTCdlRPOiNNB5wcBXrE+ob2E
   igQLAy4MfFS9DmNv662s5lzw1bALsy9Ak3CDdAo8dMBaUpat1ofKBu7SZ
   jkkJfXy7efasSWUKWlj/F2Z7H9k4e9F5J4l7a29HlYxiJ9WFY1eUU6m79
   A==;
X-CSE-ConnectionGUID: 2KY2Dg9fS3ywDfHAiCGXdQ==
X-CSE-MsgGUID: rsHupaCDQkKm/rUuhLsWjA==
X-IronPort-AV: E=McAfee;i="6600,9927,11045"; a="31114734"
X-IronPort-AV: E=Sophos;i="6.07,204,1708416000"; 
   d="scan'208";a="31114734"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2024 16:16:15 -0700
X-CSE-ConnectionGUID: NpTcH9BFTF29RrltnUwZBQ==
X-CSE-MsgGUID: tvdyeOlsQYe8ENzM5LFtLQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,204,1708416000"; 
   d="scan'208";a="21963487"
Received: from jacob-builder.jf.intel.com (HELO jacob-builder) ([10.54.39.125])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2024 16:16:14 -0700
Date: Mon, 15 Apr 2024 16:20:47 -0700
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
Subject: Re: [PATCH v2 11/13] iommu/vt-d: Make posted MSI an opt-in cmdline
 option
Message-ID: <20240415162047.34f19b0f@jacob-builder>
In-Reply-To: <BN9PR11MB527627DF2470FEC3144F59B08C042@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240405223110.1609888-1-jacob.jun.pan@linux.intel.com>
	<20240405223110.1609888-12-jacob.jun.pan@linux.intel.com>
	<BN9PR11MB527627DF2470FEC3144F59B08C042@BN9PR11MB5276.namprd11.prod.outlook.com>
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

On Fri, 12 Apr 2024 09:31:32 +0000, "Tian, Kevin" <kevin.tian@intel.com>
wrote:

> > From: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > Sent: Saturday, April 6, 2024 6:31 AM
> > 
> > +#ifdef CONFIG_X86_POSTED_MSI
> > +		else if (!strncmp(str, "posted_msi", 10)) {
> > +			if (disable_irq_post || disable_irq_remap)
> > +				pr_warn("Posted MSI not enabled due to
> > conflicting options!");
> > +			else
> > +				enable_posted_msi = 1;
> > +		}
> > +#endif  
> 
> the check of disable_irq_remap is unnecessary. It's unlikely to have
> a configuration with disable_irq_post=0 while disable_irq_remap=1
> given the latter has bigger scope.
> 
> but thinking more do we really need a check here? there is no order
> guarantee that "posted_msi" is parsed after the parameters deciding
> the value of two disable variables.
> 
> it probably makes more sense to just set enable_posted_msi here
> and then do all required checks when picking up the irqchip in
> intel_irq_remapping_alloc().

Makes sense, I have a helper function posted_msi_supported() called in
intel_irq_remapping_alloc() already.

My intention was to alert negligent users, but is is not really necessary
as you said.

Thanks,

Jacob

