Return-Path: <kvm+bounces-17552-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 00D2C8C7C8E
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 20:39:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 28BAF1C20A9D
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 18:39:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E90D4156F24;
	Thu, 16 May 2024 18:39:04 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5877C4688
	for <kvm@vger.kernel.org>; Thu, 16 May 2024 18:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.107.74.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715884744; cv=none; b=ow7cy/OGDB+UljrnBZuH/FAzEU70xDiPvQDJFoP+NxFZ8LXkp2wtxo2BbZJ41URfAHJIAg3Fx+Hj7KsJTYyzVufpnlCqrUyXY8ipneq8qXr99qKWZj0u/xHLgR2kIbIbFqfdLwtXnYiFstbM0UEiKlgNP3lyU10wMabEIJU6o0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715884744; c=relaxed/simple;
	bh=39NomLhI4XA4T/emOFtqZ68whXhoO6wTnpToxTxppkM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GRGfrIFhbiib8EVdUC/AGghlcnpf0H4iDQaSAZpo6lUjjMNSh5ofngfW+pPCUM+fbpjQpm/YDoS4LiSk4TOwlD1fd7CY88TSN8i6Sqn9MdxAnngxc0WkdSWlf4Vs6/E3MZGqvRTbSOq72k3GgNTqE25l+LUtOSowNj9BclxUqXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kaod.org; spf=pass smtp.mailfrom=ozlabs.org; arc=none smtp.client-ip=150.107.74.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kaod.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ozlabs.org
Received: from mail.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
	by gandalf.ozlabs.org (Postfix) with ESMTP id 4VgJlQ1Z6Nz4wc5;
	Fri, 17 May 2024 04:38:58 +1000 (AEST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4VgJlK0Fn9z4wby;
	Fri, 17 May 2024 04:38:52 +1000 (AEST)
Message-ID: <f6d9c3e2-bed0-47d7-bc60-8e0fd3e7d08b@kaod.org>
Date: Thu, 16 May 2024 20:38:48 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] vfio/pci: Restore zero affected bus reset devices warning
To: Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org, Yi Liu <yi.l.liu@intel.com>
References: <20240516174831.2257970-1-alex.williamson@redhat.com>
Content-Language: en-US, fr
From: =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@kaod.org>
In-Reply-To: <20240516174831.2257970-1-alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 5/16/24 19:48, Alex Williamson wrote:
> Yi notes relative to commit f6944d4a0b87 ("vfio/pci: Collect hot-reset
> devices to local buffer") that we previously tested the resulting
> device count with a WARN_ON, which was removed when we switched to
> the in-loop user copy in commit b56b7aabcf3c ("vfio/pci: Copy hot-reset
> device info to userspace in the devices loop").  Finding no devices in
> the bus/slot would be an unexpected condition, so let's restore the
> warning and trigger a -ERANGE error here as success with no devices
> would be an unexpected result to userspace as well.
> 
> Suggested-by: Yi Liu <yi.l.liu@intel.com>
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>


Reviewed-by: Cédric Le Goater <clg@redhat.com>

Thanks,

C.


> ---
>   drivers/vfio/pci/vfio_pci_core.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index d8c95cc16be8..80cae87fff36 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -1281,6 +1281,9 @@ static int vfio_pci_ioctl_get_pci_hot_reset_info(
>   	if (ret)
>   		return ret;
>   
> +	if (WARN_ON(!count)) /* Should always be at least one */
> +		return -ERANGE;
> +
>   	if (count > (hdr.argsz - sizeof(hdr)) / sizeof(*devices)) {
>   		hdr.count = count;
>   		ret = -ENOSPC;


