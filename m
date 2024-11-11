Return-Path: <kvm+bounces-31426-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1201D9C3AED
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 10:33:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CA223283293
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 09:33:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1749F14A624;
	Mon, 11 Nov 2024 09:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jTV4xA1T"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8F4C224D6;
	Mon, 11 Nov 2024 09:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731317620; cv=none; b=t0H+F/9oV9nSP4CRHz+KgHaeudjvkihcLJ0PLAiMQf1lcOt5i1Wjnx5QFN3WDCHSQTOWY/4zcN1cRZUmBfMbMPgolR1wBMGPg7c9BsXWd5O1bMHESVYcsAWjSFp6+N+aArCDu6ckaIVXMZUYZEfvKm7ZcNTLtmhgh841cxRCqc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731317620; c=relaxed/simple;
	bh=S5DtvwrGDQ+vwlJFpq82/vsqjIUp6kWdOPKhbwAhZNY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gRhVmivKFBuhzkLSA3hf1/gGfJPIgwIsHM5MPV9X6BM+iZf87ajifE/J4Pyo+MoIxoSUJlVNb64Tfzwx/xZvauiniGrbYVjQ96CxTjXYoG1scgkMbXSY0wTNVxZ6J76+wkpgNJ7bQR3SmsMWeJoY/70CVJiAVvZLMGXWtSFep1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jTV4xA1T; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731317619; x=1762853619;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=S5DtvwrGDQ+vwlJFpq82/vsqjIUp6kWdOPKhbwAhZNY=;
  b=jTV4xA1TiJwqiwKAuLdK2qqpF9GcV6GdsSfJlO+iqnR1OCANarPvjKJ8
   7KHXVMiGcUu55cmPUhzt6zFsMeZPZUKnxgvmZ6sR1OzPmxeJjHUZSVsWd
   JUDksUIMsLpgOB41R/MledQR8EqtwMCOqCmT7V/7ncJ/5pDpsdJibn9hh
   eiXPlfDH+zS6htd8il9GXjrL/6L8ecos/WLiZplOH4lG9765FZVkajMMa
   5IGP5fW4jGBgOYUrIRFFuR25pgeza1+DJJmE10dpqc4MmxfymTFmWvSg6
   OoPBSUSw7SXj1LemATut5HBa49nUTdmmLlR8B3ycNzA3Y8SRJaN7VT8EA
   A==;
X-CSE-ConnectionGUID: tzb8KaUdT362FPL44LpFew==
X-CSE-MsgGUID: HlXIn81MRtSEPIaAreJikA==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="41677967"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="41677967"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2024 01:33:39 -0800
X-CSE-ConnectionGUID: HoGMdXS/Ti+b8iMovMwi3Q==
X-CSE-MsgGUID: GgMl7szCRZSiJHpXxUGZhw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,144,1728975600"; 
   d="scan'208";a="86951178"
Received: from smile.fi.intel.com ([10.237.72.154])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2024 01:33:32 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.98)
	(envelope-from <andriy.shevchenko@linux.intel.com>)
	id 1tAQnZ-0000000DXlq-1Mq2;
	Mon, 11 Nov 2024 11:33:29 +0200
Date: Mon, 11 Nov 2024 11:33:28 +0200
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: maz@kernel.org, tglx@linutronix.de, bhelgaas@google.com,
	alex.williamson@redhat.com, jgg@nvidia.com, leonro@nvidia.com,
	shameerali.kolothum.thodi@huawei.com, robin.murphy@arm.com,
	dlemoal@kernel.org, kevin.tian@intel.com, smostafa@google.com,
	reinette.chatre@intel.com, eric.auger@redhat.com,
	ddutile@redhat.com, yebin10@huawei.com, brauner@kernel.org,
	apatel@ventanamicro.com, shivamurthy.shastri@linutronix.de,
	anna-maria@linutronix.de, nipun.gupta@amd.com,
	marek.vasut+renesas@mailbox.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-pci@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH RFCv1 5/7] PCI/MSI: Extract a common
 __pci_alloc_irq_vectors function
Message-ID: <ZzHPaPlrTYKt59fy@smile.fi.intel.com>
References: <cover.1731130093.git.nicolinc@nvidia.com>
 <0c09c2b1cef3eb085a2f4fd33105eb18aed2b611.1731130093.git.nicolinc@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0c09c2b1cef3eb085a2f4fd33105eb18aed2b611.1731130093.git.nicolinc@nvidia.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo

On Fri, Nov 08, 2024 at 09:48:50PM -0800, Nicolin Chen wrote:
> Extract a common function from the existing callers, to prepare for a new
> helper that provides an array of msi_iovas. Also, extract the msi_iova(s)
> from the array and pass in properly down to __pci_enable_msi/msix_range().

...

> +	return __pci_alloc_irq_vectors(dev, min_vecs, max_vecs,
> +				       flags, NULL, NULL);

Even if you so strict about 80 character limit, this whole line is only 83
characters, which is okay to have.

...

> +	return __pci_alloc_irq_vectors(dev, min_vecs, max_vecs,
> +				       flags, affd, NULL);

In the similar way, and other lines as well.

-- 
With Best Regards,
Andy Shevchenko



