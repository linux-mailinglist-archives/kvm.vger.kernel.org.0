Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 179893EA7DC
	for <lists+kvm@lfdr.de>; Thu, 12 Aug 2021 17:42:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238275AbhHLPmo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Aug 2021 11:42:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:44072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234287AbhHLPmn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Aug 2021 11:42:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9BCBF60D07;
        Thu, 12 Aug 2021 15:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628782937;
        bh=qBpC7WYzogfOhZyzsyuRKruDRx/wBsEIhRmz7HaVzcw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=GyMu3gPEScbOHbOgAZ7UW9DjIVAVG0Uq1k1Rctc15KKJTWQwSKQRwHq5L2pXFYZqN
         SI6UZhJCdU8LyjCTXS9mdRkKVoQu4Xr2bXhiFg9awZECtcPTzwJ+DKOovX34aSCOTh
         eZf6SKEMYQV92pxd6Bx6UHECqlxHd8eAdjcY3vody3xVxC1DeFahEo6Ym5z8qT97mw
         ylRk38w0xRzFTW6SGQSC5YoTu+41hYx0MjaR+lLdRpeJnMwrf2OrpPA10T6aHMuqag
         NieaHhQ1IswcDzopjtLId4K78EkkFN/cKfqEs74dJ+XofOrl1GObAplSw4sQnRyQh0
         ywda2dMQ4FERw==
Date:   Thu, 12 Aug 2021 10:42:16 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     bhelgaas@google.com, corbet@lwn.net, alex.williamson@redhat.com,
        diana.craciun@oss.nxp.com, kwankhede@nvidia.com,
        eric.auger@redhat.com, masahiroy@kernel.org,
        michal.lkml@markovi.net, linux-pci@vger.kernel.org,
        linux-doc@vger.kernel.org, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kbuild@vger.kernel.org,
        mgurtovoy@nvidia.com, jgg@nvidia.com, maorg@nvidia.com,
        leonro@nvidia.com
Subject: Re: [PATCH 09/12] PCI: Add a PCI_ID_F_VFIO_DRIVER_OVERRIDE flag to
 struct pci_device_id
Message-ID: <20210812154216.GA2473009@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210721161609.68223-10-yishaih@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 21, 2021 at 07:16:06PM +0300, Yishai Hadas wrote:
> From: Max Gurtovoy <mgurtovoy@nvidia.com>
> 
> The new flag field is be used to allow PCI drivers to signal the core code
> during driver matching and when generating the modules.alias information.
> ...

> @@ -152,10 +152,27 @@ static const struct pci_device_id *pci_match_device(struct pci_driver *drv,
>  	}
>  	spin_unlock(&drv->dynids.lock);
>  
> -	if (!found_id)
> -		found_id = pci_match_id(drv->id_table, dev);
> +	if (found_id)
> +		return found_id;
> +
> +	ids = drv->id_table;
> +	while ((found_id = pci_match_id(ids, dev))) {
> +		/*
> +		 * The match table is split based on driver_override. Check the
> +		 * flags as well so that any matching PCI_ID_F_DRIVER_OVERRIDE
> +		 * entry is returned.
> +		 */
> +		if ((found_id->flags & PCI_ID_F_VFIO_DRIVER_OVERRIDE) &&
> +		    !dev->driver_override)
> +			ids = found_id + 1;
> +		else
> +			break;
> +	}
>  
> -	/* driver_override will always match, send a dummy id */
> +	/*
> +	 * if no static match, driver_override will always match, send a dummy
> +	 * id.
> +	 */
>  	if (!found_id && dev->driver_override)
>  		found_id = &pci_device_id_any;

Possibly more readable:

  while ((found_id = pci_match_id(ids, dev))) {

    /*
     * PCI_ID_F_VFIO_DRIVER_OVERRIDE entries only match when
     * driver_override matches this driver.
     */
    if (found_id->flags & PCI_ID_F_VFIO_DRIVER_OVERRIDE) {
      if (dev->driver_override)
	return found_id;
      else
	ids = found_id + 1;
    } else {
      return found_id;
    }
  }

  /* Driver_override will always match; send a dummy ID */
  if (dev->driver_override)
    return &pci_device_id_any;

  return NULL;
