Return-Path: <kvm+bounces-31425-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DF0879C3AE1
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 10:30:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9DDF01F2268E
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 09:30:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C2B61527A7;
	Mon, 11 Nov 2024 09:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NgdHjbij"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB80B224D6;
	Mon, 11 Nov 2024 09:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731317424; cv=none; b=SBD/dzCiQIMQv0LFqmoig1W3xdkUqXGwgZAbQhuEIMS+++Hl0gNDozFMs/rUpiAlX962BUy5BN+FagL8BqbY2v2hVIlLXnXjC88MwfZL3fFFKXv5HorVuIzpHs3nDLaQYQj5wwryc83ebjOHNV39SpCUy02H1r7lUC9HzCBRzIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731317424; c=relaxed/simple;
	bh=BUnaed9fBm7H7/JjfD4vCaL7tVZY6KSJ+UsnJ84Dnps=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=llT6ul3wwamKyeb22bTf7V2sOaLofGSysJ6xcK8VksGQcMlNLe2dVrGL5YX78twfjy936ryxHy5e0fEj994QHnSNhzPwwnct1+UkaHREFoOcXd0VfyW/ITPeARMiybQLNgHvTf8BwGp6mfvqZuG08F0Y+CQkBjWfSypj3YHaCA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NgdHjbij; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731317422; x=1762853422;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=BUnaed9fBm7H7/JjfD4vCaL7tVZY6KSJ+UsnJ84Dnps=;
  b=NgdHjbijAiwkUz1k+RGEs7KeUXXg2yr8WAjEzkhJFdydC0eu/UTBFFlk
   9KasfM48r2gVw48kSl/Xaa39cJGse17mBXxpTufKUlmxt0B4yaduDC9/H
   /WHfHU1xUoZbxzU5jCd+vGs+J9IjcryRpOx+oF9lKdD9h9uZrNRFoeHy8
   0YBQgng3uSUsbRcyXcKy+NVJLS+FMRKVJp2bh7rrXdSaaS4ZR1oYq3hb0
   ACLpSBHUSZY/R5i39juXBC1YQS4uVqWNVliSYzC7r3t4Z3kDNcyp3WFN0
   mv+Yz1PddSDHtKoP+R92t/ATdKIGCjT58zSR6NRS9Z53GxjGZzEscjCPs
   w==;
X-CSE-ConnectionGUID: Kn33U6MHSheOGSFNvsZxSQ==
X-CSE-MsgGUID: KA7PNz9xQvGC4Tql1bJgbw==
X-IronPort-AV: E=McAfee;i="6700,10204,11252"; a="30998438"
X-IronPort-AV: E=Sophos;i="6.12,144,1728975600"; 
   d="scan'208";a="30998438"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2024 01:30:21 -0800
X-CSE-ConnectionGUID: 8X7KpXjaRMWd5iBaSklJwQ==
X-CSE-MsgGUID: t+bmDv6FTumsoJ+kjdXA+Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="91748569"
Received: from smile.fi.intel.com ([10.237.72.154])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2024 01:30:16 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.98)
	(envelope-from <andriy.shevchenko@linux.intel.com>)
	id 1tAQkO-0000000DXig-2diE;
	Mon, 11 Nov 2024 11:30:12 +0200
Date: Mon, 11 Nov 2024 11:30:12 +0200
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
Subject: Re: [PATCH RFCv1 4/7] PCI/MSI: Allow __pci_enable_msi_range to pass
 in iova
Message-ID: <ZzHOpJ8tNs5CD9m1@smile.fi.intel.com>
References: <cover.1731130093.git.nicolinc@nvidia.com>
 <7406707cbcf225fe8f6ec3ce497bdcfc51f27afb.1731130093.git.nicolinc@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7406707cbcf225fe8f6ec3ce497bdcfc51f27afb.1731130093.git.nicolinc@nvidia.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo

On Fri, Nov 08, 2024 at 09:48:49PM -0800, Nicolin Chen wrote:
> The previous patch passes in the msi_iova to msi_capability_init, so this

msi_capability_init()

> allows its caller to do the same.

-- 
With Best Regards,
Andy Shevchenko



