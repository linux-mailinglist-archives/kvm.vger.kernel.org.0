Return-Path: <kvm+bounces-68005-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B08AD1D188
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 09:25:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 05B6E303A1AB
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 08:24:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80A5537E2EF;
	Wed, 14 Jan 2026 08:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eURadS3g"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58D4F35F8AF;
	Wed, 14 Jan 2026 08:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768379054; cv=none; b=PAtVbDIVZC1rZE/D72Dta8O+UkEeElD0jPNamLjj4zQ2yBiUcc8SIVgqSaPSOleEsMXXQ8iS+SDytKfjvBuDqc5/iwTfzNJGA/S7T+ELQsFlhEbmES8Jxz9Bet+S+ULHy3bD+tpT2Px9lfD5qVcjHXcgao+MgzbjDrkZpel5d98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768379054; c=relaxed/simple;
	bh=0YUlR/pGcmIKMTQRiymsEIfsph8rcI+uI5Cu81391C0=;
	h=From:Date:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=Mad8OjOLLJA93lhDlvHqZOXe1oiVD89cwrEuO3ocCLdrV5oePBLwCLfolMVkBGWMxBTkfdCBMB9/EZPzxkQCljCuJjaQCsyEz1YljlVu6ISx28Hf2ILS2dXbxomxQzhfYn3EDshxnMNHxrbTXzkg6iiURq4+w8Ys8IyUng6c7ZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eURadS3g; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768379051; x=1799915051;
  h=from:date:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=0YUlR/pGcmIKMTQRiymsEIfsph8rcI+uI5Cu81391C0=;
  b=eURadS3gaoKeOVSDFDH8pQBO/fSF33hnNMHxP84z6WHpIWTsO/FmV1UE
   6LMqm23/DCNkprXvu1l68JUn6TaQDmOSwU7LynR1nc7r3Fad14tWp8C8d
   Kooy85zv1qOHP1myf+LKQlT9JgGufatNAYEwVIQpUTIQLH8gVl7jgFVBQ
   m/3Ph0P8+2TKFqyZnXg4yanzA/D00QDA6xYm+ZhrIYxSW3ES0w7lAUoe0
   uDLqxVdjEJ7VirtE7/kvR92LufeLknuPYKBNxzRAGWr9VggiyhsSEmVIt
   gBeNNFlY+LtbMd44YTM2d40szGMOYURfQq+1WWOBDz9gHY1vMk8H6aVf4
   A==;
X-CSE-ConnectionGUID: 00NpfdobQZiDNjVFnF76pg==
X-CSE-MsgGUID: zW/56zJPRVG0UWKPWpYsIQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11670"; a="73309119"
X-IronPort-AV: E=Sophos;i="6.21,225,1763452800"; 
   d="scan'208";a="73309119"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2026 00:24:11 -0800
X-CSE-ConnectionGUID: 9iL+s5tHT3irMTIBecTLjA==
X-CSE-MsgGUID: wXNl4bYtRmC7cg9/6a0wRw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,225,1763452800"; 
   d="scan'208";a="235333837"
Received: from ijarvine-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.244.107])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2026 00:24:09 -0800
From: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Date: Wed, 14 Jan 2026 10:24:04 +0200 (EET)
To: "Anthony Pighin (Nokia)" <anthony.pighin@nokia.com>
cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
    "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, 
    Alex Williamson <alex@shazbot.org>, Nathan Chen <nathanc@nvidia.com>, 
    Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH] PCI: Lock upstream bridge for pci_try_reset_function()
In-Reply-To: <BN0PR08MB69514F34E3CA505AE910F2F8838EA@BN0PR08MB6951.namprd08.prod.outlook.com>
Message-ID: <260dbdbf-fde6-8445-2c9b-07758d78b3fc@linux.intel.com>
References: <BN0PR08MB69514F34E3CA505AE910F2F8838EA@BN0PR08MB6951.namprd08.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Tue, 13 Jan 2026, Anthony Pighin (Nokia) wrote:

> Address this issue:
> [  125.942583] pcieport 0000:00:00.0: unlocked secondary bus reset via:
>                pci_reset_bus_function+0x188/0x1b8

Timestamp is unnecessary for understanding this issue and can be removed.

> which flows from a VFIO_GROUP_GET_DEVICE_FD ioctl when a PCI device is
> being added to a VFIO group.
> 
> Commit 920f6468924f ("Warn on missing cfg_access_lock during secondary
> bus reset") added a warning if the PCI configuration space was not
> locked during a secondary bus reset request. That was in response to
> commit 7e89efc6e9e4 ("Lock upstream bridge for pci_reset_function()")
> such that remaining paths would be made more visible.

It would be more logical to start the entire changelog with something 
like:

The commit 7e89efc6e9e4 ("Lock upstream bridge for pci_reset_function()") 
added locking of the upstream bridge the the reset function. To catch 
paths that are not properly locked, the commit 920f6468924f ("Warn on 
missing cfg_access_lock during secondary bus reset") added a warning
if the PCI configuration space was not locked during a secondary bus reset 
request.

And only then explain how it triggers in this particular case + quote the 
warning.

> Address the pci_try_reset_function() path.

"Address" is very vague. Please state explicitly that you add missing 
bridge locking and add a Fixes tag.

> Signed-off-by: Anthony Pighin <anthony.pighin@nokia.com>
> ---
>  drivers/pci/pci.c | 17 ++++++++++++++++-
>  1 file changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index 13dbb405dc31..ff3f2df7e9c8 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -5196,19 +5196,34 @@ EXPORT_SYMBOL_GPL(pci_reset_function_locked);
>   */
>  int pci_try_reset_function(struct pci_dev *dev)
>  {
> +	struct pci_dev *bridge;
>  	int rc;
>  
>  	if (!pci_reset_supported(dev))
>  		return -ENOTTY;
>  
> -	if (!pci_dev_trylock(dev))
> +	/*
> +	 * If there's no upstream bridge, no locking is needed since there is
> +	 * no upstream bridge configuration to hold consistent.
> +	 */
> +	bridge = pci_upstream_bridge(dev);
> +	if (bridge && !pci_dev_trylock(bridge))
>  		return -EAGAIN;
>  
> +	if (!pci_dev_trylock(dev)) {
> +		rc = -EAGAIN;
> +		goto out_unlock_bridge;
> +	}
> +
>  	pci_dev_save_and_disable(dev);
>  	rc = __pci_reset_function_locked(dev);
>  	pci_dev_restore(dev);
>  	pci_dev_unlock(dev);
>  
> +out_unlock_bridge:
> +	if (bridge)
> +		pci_dev_unlock(bridge);
> +
>  	return rc;
>  }
>  EXPORT_SYMBOL_GPL(pci_try_reset_function);
> -- 
> 2.43.0
> 

-- 
 i.


