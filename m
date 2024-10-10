Return-Path: <kvm+bounces-28453-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 40969998AB3
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 16:59:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AF0B81F25F02
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 14:59:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6D441F4FD7;
	Thu, 10 Oct 2024 14:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HzrPiJMu"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62C691CB301;
	Thu, 10 Oct 2024 14:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728571848; cv=none; b=gzO501AaXSdndmUJFu9Ms0GOBVnde49TPdQ1GNnrCj/ix2q4ccC2CgcBMCBsx25UgfH7BPQaI/Apk1txLazliAF4CtlMfvfn3WSz80dzwAj8zfMTsWD6M61COWHRLzyjPG+773tbjvULGZv6VWx5cZAN4VJBnhwOcqA2dILxoks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728571848; c=relaxed/simple;
	bh=sibCqydeqQiNQIf/lBDGFiiLV6uF5mNsecPlSRVwL9Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B3/scKROThIj3haRrGDKbpf/DI6sLwIJXqFP4NEEuUqrEil3zLx+S6JIGezTJ7XtW/cMHpy8pKkCedx+vLZvrLhO2cdzQAYdQTjcLrt9GiSrkItJRJUd5XZ5Q3x7mCVqhREOiRSF1XgLgfOvKeBIQjXGPkM7REGy1+K9rTvbOnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HzrPiJMu; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728571848; x=1760107848;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=sibCqydeqQiNQIf/lBDGFiiLV6uF5mNsecPlSRVwL9Y=;
  b=HzrPiJMuD2f3mp/TH4iEQ0T1f3sseukJKhhNrIKpJV8F/ZhP+DkZw8+a
   3uiMySVHDpJx0VmG8HQbfdLeIdZZx2wtZfGfewytc0KIlIVEWcGIEAG28
   UeEl329Pd64uocuSzvQXExl+5i/Un0s3kie7q/rSpCN36QYAZEAJf+7ET
   YVbisKNnTImnkcHA3Ck/cxK9BUROl7lZMaJrQgTGgmoA4u9l7mg/J0yVR
   LraoxaWTVFlrBJE+m8mNfdUPKZDbz9Tv7J8pbVvdGJI19qPMdQrrrh+NG
   tA5fSgsCvD/2tbH3KVcuI5qgsyU/PUJxE32O19OVgRtIAqf69aAilT6BF
   A==;
X-CSE-ConnectionGUID: NmRIE5LLTFq5Iz2muUcGXA==
X-CSE-MsgGUID: f6YHws0fQ1GM8x850rpSwQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11220"; a="27880006"
X-IronPort-AV: E=Sophos;i="6.11,193,1725346800"; 
   d="scan'208";a="27880006"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2024 07:50:46 -0700
X-CSE-ConnectionGUID: 7wY/4jxvQLCPgvYMG4Ai+Q==
X-CSE-MsgGUID: 2AQrvW1rQX2PPbhnm34TWQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,193,1725346800"; 
   d="scan'208";a="114082669"
Received: from smile.fi.intel.com ([10.237.72.154])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2024 07:50:31 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.98)
	(envelope-from <andriy.shevchenko@linux.intel.com>)
	id 1syuUj-00000001ZJ4-117L;
	Thu, 10 Oct 2024 17:50:25 +0300
Date: Thu, 10 Oct 2024 17:50:25 +0300
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Philipp Stanner <pstanner@redhat.com>
Cc: Heiner Kallweit <hkallweit1@gmail.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Sergey Shtylyov <s.shtylyov@omp.ru>,
	Basavaraj Natikar <basavaraj.natikar@amd.com>,
	Jiri Kosina <jikos@kernel.org>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Alex Dubov <oakad@yahoo.com>,
	Sudarsana Kalluru <skalluru@marvell.com>,
	Manish Chopra <manishc@marvell.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Rasesh Mody <rmody@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
	Igor Mitsyanko <imitsyanko@quantenna.com>,
	Sergey Matyukevich <geomatsi@gmail.com>,
	Kalle Valo <kvalo@kernel.org>, Sanjay R Mehta <sanju.mehta@amd.com>,
	Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
	Jon Mason <jdmason@kudzu.us>, Dave Jiang <dave.jiang@intel.com>,
	Allen Hubbe <allenbh@gmail.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Juergen Gross <jgross@suse.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Chen Ni <nichen@iscas.ac.cn>, Ricky Wu <ricky_wu@realtek.com>,
	Al Viro <viro@zeniv.linux.org.uk>, Breno Leitao <leitao@debian.org>,
	Kevin Tian <kevin.tian@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Mostafa Saleh <smostafa@google.com>, Hannes Reinecke <hare@suse.de>,
	John Garry <john.g.garry@oracle.com>,
	Soumya Negi <soumya.negi97@gmail.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Yi Liu <yi.l.liu@intel.com>,
	"Dr. David Alan Gilbert" <linux@treblig.org>,
	Christian Brauner <brauner@kernel.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Eric Auger <eric.auger@redhat.com>, Ye Bin <yebin10@huawei.com>,
	Marek =?iso-8859-1?Q?Marczykowski-G=F3recki?= <marmarek@invisiblethingslab.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Rui Salvaterra <rsalvaterra@gmail.com>,
	Marc Zyngier <maz@kernel.org>, linux-ide@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	ntb@lists.linux.dev, linux-pci@vger.kernel.org,
	linux-staging@lists.linux.dev, kvm@vger.kernel.org,
	xen-devel@lists.xenproject.org, linux-sound@vger.kernel.org
Subject: Re: [RFC PATCH 00/13] Remove implicit devres from pci_intx()
Message-ID: <ZwfpsSxnwm7K4eMF@smile.fi.intel.com>
References: <20241009083519.10088-1-pstanner@redhat.com>
 <8643a212-884c-48de-a2d0-0f068fc49ca2@gmail.com>
 <6468cf3e4a06c008644c98a7a79f81a1c04752b8.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6468cf3e4a06c008644c98a7a79f81a1c04752b8.camel@redhat.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo

On Thu, Oct 10, 2024 at 10:09:12AM +0200, Philipp Stanner wrote:
> On Wed, 2024-10-09 at 20:32 +0200, Heiner Kallweit wrote:
> > On 09.10.2024 10:35, Philipp Stanner wrote:

...

> > > To do so, a pci_intx() version that is always-managed, and one that
> > > is
> > > never-managed are provided. Then, all pci_intx() users are ported
> > > to the
> > > version they need. Afterwards, pci_intx() can be cleaned up and the
> > > users of the never-managed version be ported back to pci_intx().
> > > 
> > > This way we'd get this PCI API consistent again.
> > > 
> > AFAICS pci_intx() is used only by drivers which haven't been
> > converted
> > to the pci_alloc_irq_vectors() API yet. Wouldn't it be better to do
> > this
> > instead of trying to improve pci_intx()?

My first impression was the same...

> This would be the créme-de-la-créme-solution, yes.
> 
> But such a portation would require more detailed knowledge of the old
> drivers.
> 
> In this discussion, Alex points out that at least in some drivers, you
> can't replace pci_intx() without further ado:
> https://lore.kernel.org/all/20240904151020.486f599e.alex.williamson@redhat.com/
> 
> What we could do is mark pci_intx() and pcim_intx() as deprecated and
> point everyone to pci_alloc_irq_vectors(). Then someone can look into
> porting the old drivers at some point in the future.

...but here I got the point by Philipp.

-- 
With Best Regards,
Andy Shevchenko



