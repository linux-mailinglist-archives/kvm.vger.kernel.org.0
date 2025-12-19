Return-Path: <kvm+bounces-66315-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 10668CCF28E
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 10:36:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 235F830343D8
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 09:36:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74B292DF3DA;
	Fri, 19 Dec 2025 09:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OUsnY3Sy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A41F22D7DDD;
	Fri, 19 Dec 2025 09:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766136965; cv=none; b=pBQ9TrQVY/qBSCrIbBqX6FUgs22Q28+dUQMndkbFwbcrILeao1ZVMW0wFlPzvCQyH0bPQcqYKKN8AzQ/40raT8o2EHfUHlJoA3Q8Cq+cSHrrBSFzydJTQ49C7IZ3u3sGfvP7hee4ieBtwBW1YQkVPPtUt88Y759J8w3jH6Rzays=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766136965; c=relaxed/simple;
	bh=NhGQzCcXUfeN4EQP9spJfAUa7YS36bJnOojzeGLNmzM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LqoPI3yqglunHlrsqs+7buZ14jJ9u+F1OWnUIbhkKAlzZi4ahshLBhVQkexVtcB8x/JxZSfAggaKOKJHh7AU5m9XOf4Oj9Bma3LJlDzdPKzdQw4igL9E7RbwqVv0+HUU+6+wCz/NT8Wmb4TnMAe3ikztR8kbL6ad13GjibqM4Vs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OUsnY3Sy; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766136962; x=1797672962;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=NhGQzCcXUfeN4EQP9spJfAUa7YS36bJnOojzeGLNmzM=;
  b=OUsnY3SyYGHM8ZWWqp4VERGhXIquR7k7vm7KAh8yUAGQ3k0m46FfHVKx
   EyY7v7hNPp/GCuwnnMIFUoUXOil8JTlzH7sQGFLKz0UUnrjTqxHMkHJXt
   9pQTmQF7ZZ/7LYikv0H8EGodQNEMhz6nO37C7CeBgGBKGf8v2VQ/KM+bM
   ufbFI6Mb1SLJUBDVwpFZEYKx/l4xhdXyyhEa8HQc2CCCbWICURLIFRLCF
   U6aGKswjqXjolkMrfKXUUzpiq0S/ZH7wkzmfNqS0/+weCWWE2PoizbU8E
   hOjk/AXvij27B6F0j0TG3MXs+vLV/qnPBKkM1Ynie90D+4RO9kco+FpAz
   A==;
X-CSE-ConnectionGUID: TUM7/MH9TgSRshPwoGl3EA==
X-CSE-MsgGUID: ADd8N1yXSFiNBB+2QnOQHA==
X-IronPort-AV: E=McAfee;i="6800,10657,11646"; a="55673459"
X-IronPort-AV: E=Sophos;i="6.21,159,1763452800"; 
   d="scan'208";a="55673459"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2025 01:36:02 -0800
X-CSE-ConnectionGUID: 6pJldH59TXex1X6SjLXxjw==
X-CSE-MsgGUID: TikCoaB7QJ6F5bz2U3YcBA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,159,1763452800"; 
   d="scan'208";a="199296786"
Received: from unknown (HELO [10.94.249.110]) ([10.94.249.110])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2025 01:35:59 -0800
Message-ID: <8e199209-6af1-4be2-9f10-5ade001bc3bf@linux.intel.com>
Date: Fri, 19 Dec 2025 10:35:56 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] vfio/xe: Add default handler for .get_region_info_caps
To: Michal Wajdeczko <michal.wajdeczko@intel.com>,
 intel-xe@lists.freedesktop.org
Cc: =?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, Jason Gunthorpe <jgg@nvidia.com>,
 Kevin Tian <kevin.tian@intel.com>, Alex Williamson <alex@shazbot.org>,
 =?UTF-8?Q?Micha=C5=82_Winiarski?= <michal.winiarski@intel.com>,
 dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
References: <20251218205106.4578-1-michal.wajdeczko@intel.com>
Content-Language: en-US
From: "Bernatowicz, Marcin" <marcin.bernatowicz@linux.intel.com>
In-Reply-To: <20251218205106.4578-1-michal.wajdeczko@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 12/18/2025 9:51 PM, Michal Wajdeczko wrote:
> New requirement for the vfio drivers was added by the commit
> f97859503859 ("vfio: Require drivers to implement get_region_info")
> followed by commit 1b0ecb5baf4a ("vfio/pci: Convert all PCI drivers
> to get_region_info_caps") that was missed by the new vfio/xe driver.
>
> Add handler for .get_region_info_caps to avoid -EINVAL errors.
>
> Fixes: 2e38c50ae492 ("vfio/xe: Add device specific vfio_pci driver variant for Intel graphics")
> Signed-off-by: Michal Wajdeczko <michal.wajdeczko@intel.com>
> ---
> Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
> Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
> Cc: Jason Gunthorpe <jgg@nvidia.com>
> Cc: Kevin Tian <kevin.tian@intel.com>
> Cc: Alex Williamson <alex@shazbot.org>
> Cc: Michał Winiarski <michal.winiarski@intel.com>
> Cc: Marcin Bernatowicz <marcin.bernatowicz@linux.intel.com>
> Cc: dri-devel@lists.freedesktop.org
> Cc: linux-kernel@vger.kernel.org
> Cc: kvm@vger.kernel.org
> ---
>   drivers/vfio/pci/xe/main.c | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/drivers/vfio/pci/xe/main.c b/drivers/vfio/pci/xe/main.c
> index 0156b53c678b..719ab4660085 100644
> --- a/drivers/vfio/pci/xe/main.c
> +++ b/drivers/vfio/pci/xe/main.c
> @@ -504,6 +504,7 @@ static const struct vfio_device_ops xe_vfio_pci_ops = {
>   	.open_device = xe_vfio_pci_open_device,
>   	.close_device = xe_vfio_pci_close_device,
>   	.ioctl = vfio_pci_core_ioctl,
> +	.get_region_info_caps = vfio_pci_ioctl_get_region_info,
>   	.device_feature = vfio_pci_core_ioctl_feature,
>   	.read = vfio_pci_core_read,
>   	.write = vfio_pci_core_write,
Reviewed-by: Marcin Bernatowicz <marcin.bernatowicz@linux.intel.com>
Tested-by: Marcin Bernatowicz <marcin.bernatowicz@linux.intel.com>

I tested it on v6.19-rc1 with QEMU 8.2.2
passing through an Intel Xe VF. The patch fixes the -EINVAL failure
on VFIO_DEVICE_GET_REGION_INFO.

