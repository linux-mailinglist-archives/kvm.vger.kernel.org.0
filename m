Return-Path: <kvm+bounces-31427-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3844F9C3AF2
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 10:35:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7162B1C21C43
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 09:35:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD113155325;
	Mon, 11 Nov 2024 09:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="m+fwPH4T"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 916FC224D6;
	Mon, 11 Nov 2024 09:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731317698; cv=none; b=b96kaD9UcO/uw6EXbyih12Pfc3Cqh+WjPzWX+U7iL2ze4UYD97550t2iVTNOYXtA+MhDmQY9u/aUYeoCvAbxXXGfMiTflutbCm60CxNNix3vhr7lZF5b/D2tRDtVfYWZGTB1x+AuSaQPD85E4oxWceZgUdzRRGiyn24E77LpE20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731317698; c=relaxed/simple;
	bh=rUnm2FdY/OLS/8AxyOpljESVF9x1DK5QupuPhKyvdjk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uZgNRw2jx9C/a4WhoW4u/pklsgVhphmdyR93fTAWF419++EReTggRbUxGiVQSE3yEjkngghw/SVQW9N72bD7soQfwEFQUFjku9pAg7h98Ch/qriB9qP0IHLdKAetvCL7p7IXeAP3anYKn4M+TFy63DqTZalKJUAWwoh0DfmX74s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=m+fwPH4T; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731317697; x=1762853697;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=rUnm2FdY/OLS/8AxyOpljESVF9x1DK5QupuPhKyvdjk=;
  b=m+fwPH4TtoVUxxLecERh5a3+lavWr8J6f4SwPCFz3ufZYHmi87LYyX6+
   TWYYmuGMVtILWMu/w5TI+DHATDC3WImmSceSgMUkTwpb4v4Jt7jycBlom
   qHQ3z0fo0ZLgaGcvUxFBlhJo+LC9OplJHrhZOefk15fBZSNDl7xmHfSUT
   ye+xuGTHl2UpVJ+5V1GZkrgyE9Dpkx3caJSUdOrxpt4CrbYrDk3jn5WFn
   gMsKVLDxC22Z1+ncdiam64QtLus4EXdgs7r+oWCGjcmyoyS4kQrIF2Chz
   ytdSflHQc8EDBlG5jilxM7xToGKvliPqn/K1ZuksLfa4y6ULrrJG+hwSO
   Q==;
X-CSE-ConnectionGUID: C/WlcEosTS+lYFDl41Rl0A==
X-CSE-MsgGUID: dI6FGNMfT2208XaE/GCfOA==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="41678016"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="41678016"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2024 01:34:57 -0800
X-CSE-ConnectionGUID: 4iLhGHbyQTaH/HX0q8sZdQ==
X-CSE-MsgGUID: g/25x4VyTj+JOidQGT/xJg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,144,1728975600"; 
   d="scan'208";a="86951247"
Received: from smile.fi.intel.com ([10.237.72.154])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2024 01:34:51 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.98)
	(envelope-from <andriy.shevchenko@linux.intel.com>)
	id 1tAQop-0000000DXmm-2DTa;
	Mon, 11 Nov 2024 11:34:47 +0200
Date: Mon, 11 Nov 2024 11:34:47 +0200
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
Subject: Re: [PATCH RFCv1 6/7] PCI/MSI: Add pci_alloc_irq_vectors_iovas helper
Message-ID: <ZzHPtwPdCehYyXWE@smile.fi.intel.com>
References: <cover.1731130093.git.nicolinc@nvidia.com>
 <e9399426b08b16efbdf7224c0122f5bf80f6d0ea.1731130093.git.nicolinc@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e9399426b08b16efbdf7224c0122f5bf80f6d0ea.1731130093.git.nicolinc@nvidia.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo

On Fri, Nov 08, 2024 at 09:48:51PM -0800, Nicolin Chen wrote:
> Now, the common __pci_alloc_irq_vectors() accepts an array of msi_iovas,
> which is a list of preset IOVAs for MSI doorbell addresses.
> 
> Add a helper that would pass in a list. A following patch will call this
> to forward msi_iovas from user space.

...

> +/**
> + * pci_alloc_irq_vectors_iovas() - Allocate multiple device interrupt
> + *                                 vectors with preset msi_iovas
> + * @dev:       the PCI device to operate on
> + * @min_vecs:  minimum required number of vectors (must be >= 1)
> + * @max_vecs:  maximum desired number of vectors
> + * @flags:     allocation flags, as in pci_alloc_irq_vectors()
> + * @msi_iovas: list of IOVAs for MSI between [min_vecs, max_vecs]
> + *
> + * Same as pci_alloc_irq_vectors(), but with the extra @msi_iovas parameter.
> + * Check that function docs, and &struct irq_affinity, for more details.
> + */

Always validate your kernel-doc descriptions

	scripts/kernel-doc -Wall -none -v ...

will give you a warning here.

-- 
With Best Regards,
Andy Shevchenko



