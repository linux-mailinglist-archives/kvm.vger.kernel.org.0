Return-Path: <kvm+bounces-31771-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C221E9C773A
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 16:32:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 598D1B23CC5
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 15:25:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 772531632FE;
	Wed, 13 Nov 2024 15:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jEpL3axQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB2F913B29B;
	Wed, 13 Nov 2024 15:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731511475; cv=none; b=UxDgmxzn8mYByoUX0EX0IWb6/SBoKSpxbvA4do0GiWmw5e5gmlUYjlsS5fj6AdJlu2xQMcEXcuqW3Sf6XIXGbx9TkHewpLuKrcpXk+nVmbxqSVHlIhc3D/B6A30tDKFYZEbUV98Zm/UQkFV6d4IE0+vCVT1HcD7JLdCxy+7kRbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731511475; c=relaxed/simple;
	bh=/Qs+Z4ETO6HBDD0/r4vq50xWIIZZXaOFQHJesHfkTbA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VvKg0AVMOaRLlep0RkdBiY0X4Q6nH3jsF7yXOs960sZI2JzosBYHmLqsHZvHvR+UXxYLuUy+0stepgPrh/9RYxke833rjN9JqM/K8ODeSykfNmro5WvRndl46LgonJFTxdjSTlww0D7tbRnbYL909kzmLZMhV95NdRJX81lFIq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jEpL3axQ; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731511474; x=1763047474;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=/Qs+Z4ETO6HBDD0/r4vq50xWIIZZXaOFQHJesHfkTbA=;
  b=jEpL3axQI5kZQvhWzQW1WgefqUXhGYEPMJsFyBsVRq8L/IJvsGg1iz6Y
   wQ/G7eyoNLWHaUiZ5DjzPmVkGItHyIEMyFw0fbpmY0P70iZbtj2gEwVOE
   56qnSDVS3DT8Dv5v44zSLn/aKTMUDFp439beeHamqBguNpZVolUEmPi3H
   TCq2GsCIrsO/LxsXJzhzX/vRhmw6hW5weE3a1/QSc5cTVdVyDsSFunPCy
   OHq+bbOUMDd6pdCoSPtZGD0QG1KqJntWOcyGIZ+GxQhN83Po/VPtDpz0R
   PHOXz1N+GmYHe69Dt9+vgc/2IaiKX8luo5nkRLDt8GtnZ0Ly66Zp1f3sO
   w==;
X-CSE-ConnectionGUID: hufD5M6HQ5ahAp19Uixp0A==
X-CSE-MsgGUID: N/JRjFZKROO6Qy00GI0UCQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11254"; a="42038092"
X-IronPort-AV: E=Sophos;i="6.12,151,1728975600"; 
   d="scan'208";a="42038092"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2024 07:24:33 -0800
X-CSE-ConnectionGUID: Eu78RBWmRsK0vvilN+bwhQ==
X-CSE-MsgGUID: u7LspSQgTTqwqS7xt+wrPQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,151,1728975600"; 
   d="scan'208";a="111214069"
Received: from spandruv-desk1.amr.corp.intel.com (HELO [10.125.111.237]) ([10.125.111.237])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2024 07:24:28 -0800
Message-ID: <decf5296-1c9b-49ab-8556-55a199e214ed@intel.com>
Date: Wed, 13 Nov 2024 08:24:27 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 04/11] net/ntb: Use never-managed version of pci_intx()
To: Philipp Stanner <pstanner@redhat.com>, Damien Le Moal
 <dlemoal@kernel.org>, Niklas Cassel <cassel@kernel.org>,
 Basavaraj Natikar <basavaraj.natikar@amd.com>, Jiri Kosina
 <jikos@kernel.org>, Benjamin Tissoires <bentiss@kernel.org>,
 Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alex Dubov
 <oakad@yahoo.com>, Sudarsana Kalluru <skalluru@marvell.com>,
 Manish Chopra <manishc@marvell.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Rasesh Mody <rmody@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
 Igor Mitsyanko <imitsyanko@quantenna.com>,
 Sergey Matyukevich <geomatsi@gmail.com>, Kalle Valo <kvalo@kernel.org>,
 Sanjay R Mehta <sanju.mehta@amd.com>,
 Shyam Sundar S K <Shyam-sundar.S-k@amd.com>, Jon Mason <jdmason@kudzu.us>,
 Allen Hubbe <allenbh@gmail.com>, Bjorn Helgaas <bhelgaas@google.com>,
 Alex Williamson <alex.williamson@redhat.com>, Juergen Gross
 <jgross@suse.com>, Stefano Stabellini <sstabellini@kernel.org>,
 Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
 Mario Limonciello <mario.limonciello@amd.com>, Chen Ni <nichen@iscas.ac.cn>,
 Ricky Wu <ricky_wu@realtek.com>, Al Viro <viro@zeniv.linux.org.uk>,
 Breno Leitao <leitao@debian.org>, Kevin Tian <kevin.tian@intel.com>,
 Thomas Gleixner <tglx@linutronix.de>, Mostafa Saleh <smostafa@google.com>,
 Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Yi Liu <yi.l.liu@intel.com>,
 Kunwu Chan <chentao@kylinos.cn>, Ankit Agrawal <ankita@nvidia.com>,
 Christian Brauner <brauner@kernel.org>,
 Reinette Chatre <reinette.chatre@intel.com>,
 Eric Auger <eric.auger@redhat.com>, Ye Bin <yebin10@huawei.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-input@vger.kernel.org, netdev@vger.kernel.org,
 linux-wireless@vger.kernel.org, ntb@lists.linux.dev,
 linux-pci@vger.kernel.org, kvm@vger.kernel.org,
 xen-devel@lists.xenproject.org
References: <20241113124158.22863-2-pstanner@redhat.com>
 <20241113124158.22863-6-pstanner@redhat.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20241113124158.22863-6-pstanner@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 11/13/24 5:41 AM, Philipp Stanner wrote:
> pci_intx() is a hybrid function which can sometimes be managed through
> devres. To remove this hybrid nature from pci_intx(), it is necessary to
> port users to either an always-managed or a never-managed version.
> 
> hw/amd and how/intel enable their PCI-Device with pci_enable_device().
> Thus, they need the never-managed version.
> 
> Replace pci_intx() with pci_intx_unmanaged().
> 
> Signed-off-by: Philipp Stanner <pstanner@redhat.com>
> Acked-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com> #for ntb_hw_amd.c

Acked-by: Dave Jiang <dave.jiang@intel.com> # for ntb_hw_gen1.c
> ---
>  drivers/ntb/hw/amd/ntb_hw_amd.c    | 4 ++--
>  drivers/ntb/hw/intel/ntb_hw_gen1.c | 2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/ntb/hw/amd/ntb_hw_amd.c b/drivers/ntb/hw/amd/ntb_hw_amd.c
> index d687e8c2cc78..b146f170e839 100644
> --- a/drivers/ntb/hw/amd/ntb_hw_amd.c
> +++ b/drivers/ntb/hw/amd/ntb_hw_amd.c
> @@ -791,7 +791,7 @@ static int ndev_init_isr(struct amd_ntb_dev *ndev,
>  err_msi_enable:
>  
>  	/* Try to set up intx irq */
> -	pci_intx(pdev, 1);
> +	pci_intx_unmanaged(pdev, 1);
>  
>  	rc = request_irq(pdev->irq, ndev_irq_isr, IRQF_SHARED,
>  			 "ndev_irq_isr", ndev);
> @@ -831,7 +831,7 @@ static void ndev_deinit_isr(struct amd_ntb_dev *ndev)
>  		if (pci_dev_msi_enabled(pdev))
>  			pci_disable_msi(pdev);
>  		else
> -			pci_intx(pdev, 0);
> +			pci_intx_unmanaged(pdev, 0);
>  	}
>  }
>  
> diff --git a/drivers/ntb/hw/intel/ntb_hw_gen1.c b/drivers/ntb/hw/intel/ntb_hw_gen1.c
> index 079b8cd79785..9ad9d7fe227e 100644
> --- a/drivers/ntb/hw/intel/ntb_hw_gen1.c
> +++ b/drivers/ntb/hw/intel/ntb_hw_gen1.c
> @@ -445,7 +445,7 @@ int ndev_init_isr(struct intel_ntb_dev *ndev,
>  
>  	/* Try to set up intx irq */
>  
> -	pci_intx(pdev, 1);
> +	pci_intx_unmanaged(pdev, 1);
>  
>  	rc = request_irq(pdev->irq, ndev_irq_isr, IRQF_SHARED,
>  			 "ndev_irq_isr", ndev);


