Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFD0937799F
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 03:11:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230121AbhEJBLZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 9 May 2021 21:11:25 -0400
Received: from mga01.intel.com ([192.55.52.88]:48552 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229941AbhEJBLU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 9 May 2021 21:11:20 -0400
IronPort-SDR: 0RTbbDN2Ewlak3U54tFPsihd2eQs/sFxGZXJnsEwKhu5j33WkwB7UbMRq1WNyMdSrVk3gQNzzg
 brgziDFySVYg==
X-IronPort-AV: E=McAfee;i="6200,9189,9979"; a="220024067"
X-IronPort-AV: E=Sophos;i="5.82,286,1613462400"; 
   d="scan'208";a="220024067"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2021 18:10:17 -0700
IronPort-SDR: rTsmeD20ARgDXEz0Kl1zLM25fvP+Bhd6ba7hrWM/JOfQtfDVxpQW2ZmUz9WMnpMJP9b2w8wFIq
 nZsivOM2nWXg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,286,1613462400"; 
   d="scan'208";a="460994377"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.38])
  by FMSMGA003.fm.intel.com with ESMTP; 09 May 2021 18:10:15 -0700
Date:   Mon, 10 May 2021 09:10:14 +0800
From:   Yuan Yao <yuan.yao@linux.intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     tkffaul@outlook.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfio/pci: Sanity check IGD OpRegion Size
Message-ID: <20210510011014.q6xfcmqopbqgepbq@yy-desk-7060>
References: <162041357421.21800.16214130780777455390.stgit@omen>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162041357421.21800.16214130780777455390.stgit@omen>
User-Agent: NeoMutt/20171215
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 07, 2021 at 12:53:17PM -0600, Alex Williamson wrote:
> The size field of the IGD OpRegion table is supposed to indicate table
> size in KB, but we've seen at least one report of a BIOS that appears
> to incorrectly report size in bytes.  The default size is 8 (*1024 =
> 8KB), but an incorrect implementation may report 8192 (*1024 = 8MB)
> and can cause a variety of mapping errors.
> 
> It's believed that 8MB would be an implausible, if not absurd, actual
> size, so we can probably be pretty safe in assuming this is a BIOS bug
> where the intended size is likely 8KB.
> 
> Reported-by: Travis Faulhaber <tkffaul@outlook.com>
> Tested-by: Travis Faulhaber <tkffaul@outlook.com>
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
>  drivers/vfio/pci/vfio_pci_igd.c |   11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_igd.c b/drivers/vfio/pci/vfio_pci_igd.c
> index 228df565e9bc..c89a4797cd18 100644
> --- a/drivers/vfio/pci/vfio_pci_igd.c
> +++ b/drivers/vfio/pci/vfio_pci_igd.c
> @@ -86,7 +86,16 @@ static int vfio_pci_igd_opregion_init(struct vfio_pci_device *vdev)
>  		return -EINVAL;
>  	}
>  
> -	size *= 1024; /* In KB */
> +	/*
> +	 * The OpRegion size field is specified as size in KB, but there have been
> +	 * user reports where this field appears to report size in bytes.  If we
> +	 * read 8192, assume this is the case.
> +	 */
> +	if (size == OPREGION_SIZE)

Is "size >= OPREGION_SIZE" or "size >= smaller but still implausible value
(like 4096)" better for covering more bad BIOS implementation cases ?

> +		pci_warn(vdev->pdev,
> +			 "BIOS Bug, IGD OpRegion reports invalid size, assuming default 8KB\n");
> +	else
> +		size *= 1024; /* In KB */
>  
>  	/*
>  	 * Support opregion v2.1+
> 
> 
