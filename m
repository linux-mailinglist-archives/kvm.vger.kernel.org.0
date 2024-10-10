Return-Path: <kvm+bounces-28451-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 15DD1998A72
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 16:54:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C33522863C0
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 14:54:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB75E1CF2B0;
	Thu, 10 Oct 2024 14:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kvohx1nJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D5581CF287;
	Thu, 10 Oct 2024 14:40:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728571239; cv=none; b=Vbp0qnjgKlvCO7qUp7IxPTtuvE4RHoWZ1zh8sjN4xwuKWv2X7Xpgi5m7SDBMWTKWAc4TtHaaYlOjiZyhNFG7hkWbK7gvSNp9hNW9UgFgCxbPUR22hZDcWvEux5ESQht8HqJvYSOKABJJLG0J0yue2F6ecsjfpoTO0RS6ulMU8DE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728571239; c=relaxed/simple;
	bh=Uq5PgKpLE7uhqRzqfCFPjNL9bUnSLqy/ztfVl9urxFg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iyU4HRBaWtJ9ckQ23mk/9EDVGaDE4bHcWirzDm2/UhQ2K4tBqA8oYaZk/VhWkQVxTvBDx1VN5TYOlNW1yMqhIzNw7aDRFS1blRomGK8KGuaqu5pyL+tZOLZGXinnsuqOp2+4ioL6GKYJ1yv5QrTWEXb8bkpxMkSWJVvBpJjO5Gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kvohx1nJ; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728571237; x=1760107237;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Uq5PgKpLE7uhqRzqfCFPjNL9bUnSLqy/ztfVl9urxFg=;
  b=kvohx1nJBQjJkXtR7BonDqKnk2WLQ8kzvl1kAiX/UbNcW0uulzNFvqsK
   fcJUtpkJVb+cxXxaYzsfB5rFDUax0YJV5eBOVnTzm9HtfzrXXk1Q4am7B
   qjoDK/SzW0sPcvdy/83mUEheSoga3MIc00TpXib+QjtGcVAHgnH2F3+Ii
   sWX6enJJDC8lKbTxCBZN+m4XBFOvu1Thj++uQUV+5FhkfZOKORS2L2gie
   BF5q0yMCaZIOW4v+vpukcZiDtJKJbCK00ZLCVex4JqYcVsS0pecsvsv3P
   A6G0s7+19c57NeGaTpwTVwvmeiE6ytyptxZE/Ep+P3NNWV63h2cMOLdfh
   g==;
X-CSE-ConnectionGUID: G2PFZdprT3uxuFLWZ1xo+w==
X-CSE-MsgGUID: TvdzS29ERRWcOc+n0N2hTw==
X-IronPort-AV: E=McAfee;i="6700,10204,11220"; a="28065604"
X-IronPort-AV: E=Sophos;i="6.11,193,1725346800"; 
   d="scan'208";a="28065604"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2024 07:40:36 -0700
X-CSE-ConnectionGUID: 24TFoChFQf2xX8y5S/3N6A==
X-CSE-MsgGUID: bcd6cbeoShWJdS+S7bWq0g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,193,1725346800"; 
   d="scan'208";a="81191373"
Received: from smile.fi.intel.com ([10.237.72.154])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2024 07:40:22 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.98)
	(envelope-from <andriy.shevchenko@linux.intel.com>)
	id 1syuKv-00000001Z6U-0EM4;
	Thu, 10 Oct 2024 17:40:17 +0300
Date: Thu, 10 Oct 2024 17:40:16 +0300
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Philipp Stanner <pstanner@redhat.com>
Cc: Damien Le Moal <dlemoal@kernel.org>, Niklas Cassel <cassel@kernel.org>,
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
Subject: Re: [RFC PATCH 01/13] PCI: Prepare removing devres from pci_intx()
Message-ID: <ZwfnULv2myACxnVb@smile.fi.intel.com>
References: <20241009083519.10088-1-pstanner@redhat.com>
 <20241009083519.10088-2-pstanner@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241009083519.10088-2-pstanner@redhat.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo

On Wed, Oct 09, 2024 at 10:35:07AM +0200, Philipp Stanner wrote:
> pci_intx() is a hybrid function which sometimes performs devres
> operations, depending on whether pcim_enable_device() has been used to
> enable the pci_dev. This sometimes-managed nature of the function is
> problematic. Notably, it causes the function to allocate under some
> circumstances which makes it unusable from interrupt context.
> 
> To, ultimately, remove the hybrid nature from pci_intx(), it is first
> necessary to provide an always-managed and a never-managed version
> of that function. Then, all callers of pci_intx() can be ported to the
> version they need, depending whether they use pci_enable_device() or
> pcim_enable_device().
> 
> An always-managed function exists, namely pcim_intx(), for which
> __pcim_intx(), a never-managed version of pci_intx() had been
> implemented.

> Make __pcim_intx() a public function under the name
> pci_intx_unmanaged(). Make pcim_intx() a public function.

To avoid an additional churn we can make just completely new APIs, namely:
pcim_int_x()
pci_int_x()

You won't need all dirty dances with double underscored function naming and
renaming.


...

> +	pci_read_config_word(pdev, PCI_COMMAND, &pci_command);
> +
> +	if (enable)
> +		new = pci_command & ~PCI_COMMAND_INTX_DISABLE;
> +	else
> +		new = pci_command | PCI_COMMAND_INTX_DISABLE;
> +
> +	if (new != pci_command)

I would use positive conditionals as easy to read (yes, a couple of lines
longer, but also a win is the indentation and avoiding an additional churn in
the future in case we need to add something in this branch.

> +		pci_write_config_word(pdev, PCI_COMMAND, new);

...

Otherwise I'm for the idea in general.

-- 
With Best Regards,
Andy Shevchenko



