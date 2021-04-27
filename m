Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0992136C90D
	for <lists+kvm@lfdr.de>; Tue, 27 Apr 2021 18:06:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237161AbhD0QHg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Apr 2021 12:07:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:42656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233501AbhD0QHe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Apr 2021 12:07:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8ED1861004;
        Tue, 27 Apr 2021 16:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619539610;
        bh=OlGgPoXFiwlxIxkP58geOzu4Y+BRna2BMKK6Be9F+PU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ReqCNCiFnmkUA+jpoOFgSEWc0P9AxwTpEhiNPMdpZZYmzCxSHPvtLDqYiUwOBjS/U
         9bSfBvO/nRDfTPwPlP1wi3pVBpEWW7DVYL1twQbsf8qKNIXfKcenlB9I1XXzdScAje
         wx4J3BhLbGuv2PXl7LjM+/Oul0maskZUmiCQwviI=
Date:   Tue, 27 Apr 2021 18:06:47 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Firas Ashkar <firas.ashkar@savoirfairelinux.com>
Cc:     mst@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] uio: uio_pci_generic: add memory resource mappings
Message-ID: <YIg2lz3y5XkT0Pva@kroah.com>
References: <20210427150646.3074218-1-firas.ashkar@savoirfairelinux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210427150646.3074218-1-firas.ashkar@savoirfairelinux.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 27, 2021 at 11:06:46AM -0400, Firas Ashkar wrote:
> import memory resources from underlying pci device, thus allowing
> userspace applications to memory map those resources.
> 
> Signed-off-by: Firas Ashkar <firas.ashkar@savoirfairelinux.com>
> ---
> :100644 100644 c7d681fef198 efc43869131d M	drivers/uio/uio_pci_generic.c
>  drivers/uio/uio_pci_generic.c | 32 ++++++++++++++++++++++++++++++++
>  1 file changed, 32 insertions(+)
> 
> diff --git a/drivers/uio/uio_pci_generic.c b/drivers/uio/uio_pci_generic.c
> index c7d681fef198..efc43869131d 100644
> --- a/drivers/uio/uio_pci_generic.c
> +++ b/drivers/uio/uio_pci_generic.c
> @@ -72,7 +72,9 @@ static int probe(struct pci_dev *pdev,
>  			   const struct pci_device_id *id)
>  {
>  	struct uio_pci_generic_dev *gdev;
> +	struct uio_mem *uiomem;
>  	int err;
> +	int i;
>  
>  	err = pcim_enable_device(pdev);
>  	if (err) {
> @@ -101,6 +103,36 @@ static int probe(struct pci_dev *pdev,
>  			 "no support for interrupts?\n");
>  	}
>  
> +	uiomem = &gdev->info.mem[0];
> +	for (i = 0; i < MAX_UIO_MAPS; ++i) {
> +		struct resource *r = &pdev->resource[i];
> +
> +		if (r->flags != (IORESOURCE_SIZEALIGN | IORESOURCE_MEM))
> +			continue;
> +
> +		if (uiomem >= &gdev->info.mem[MAX_UIO_MAPS]) {
> +			dev_warn(
> +				&pdev->dev,
> +				"device has more than " __stringify(
> +					MAX_UIO_MAPS) " I/O memory resources.\n");
> +			break;
> +		}
> +
> +		uiomem->memtype = UIO_MEM_PHYS;
> +		uiomem->addr = r->start & PAGE_MASK;
> +		uiomem->offs = r->start & ~PAGE_MASK;
> +		uiomem->size =
> +			(uiomem->offs + resource_size(r) + PAGE_SIZE - 1) &
> +			PAGE_MASK;
> +		uiomem->name = r->name;
> +		++uiomem;
> +	}
> +
> +	while (uiomem < &gdev->info.mem[MAX_UIO_MAPS]) {
> +		uiomem->size = 0;
> +		++uiomem;
> +	}
> +
>  	return devm_uio_register_device(&pdev->dev, &gdev->info);
>  }
>  
> -- 
> 2.25.1
> 

Hi,

This is the friendly patch-bot of Greg Kroah-Hartman.  You have sent him
a patch that has triggered this response.  He used to manually respond
to these common problems, but in order to save his sanity (he kept
writing the same thing over and over, yet to different people), I was
created.  Hopefully you will not take offence and will fix the problem
in your patch and resubmit it so that it can be accepted into the Linux
kernel tree.

You are receiving this message because of the following common error(s)
as indicated below:

- You did not specify a description of why the patch is needed, or
  possibly, any description at all, in the email body.  Please read the
  section entitled "The canonical patch format" in the kernel file,
  Documentation/SubmittingPatches for what is needed in order to
  properly describe the change.

- This looks like a new version of a previously submitted patch, but you
  did not list below the --- line any changes from the previous version.
  Please read the section entitled "The canonical patch format" in the
  kernel file, Documentation/SubmittingPatches for what needs to be done
  here to properly describe this.

If you wish to discuss this problem further, or you have questions about
how to resolve this issue, please feel free to respond to this email and
Greg will reply once he has dug out from the pending patches received
from other developers.

thanks,

greg k-h's patch email bot
