Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CB523F221C
	for <lists+kvm@lfdr.de>; Thu, 19 Aug 2021 23:12:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235659AbhHSVNU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Aug 2021 17:13:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58263 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235406AbhHSVNT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 19 Aug 2021 17:13:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629407562;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=E6gvO9OrXFcUe/cpRZ8MFuADLEe52cpmbYRUrdRkJ+A=;
        b=JQP4oyN/cRNavLeUgPWKTD3uj02ZMP33AqbOrFBqYgtJuAFBSs2P0RICGZ+dTlwFSDU2YC
        7wN/G19rnLV8j8y+gSIbf5vGd/ktpCQskA5+V7KugfYHi8CLfpLFe5Z+LVW6I5AfLet7KN
        kpbmZQ63L/9jM9wPrgmNO3I1LCyvScQ=
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com
 [209.85.167.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-243-2Clk6EnZMl-tkH50hd5-Ag-1; Thu, 19 Aug 2021 17:12:38 -0400
X-MC-Unique: 2Clk6EnZMl-tkH50hd5-Ag-1
Received: by mail-oi1-f199.google.com with SMTP id q7-20020a0568082007b0290267cebbbabeso2693074oiw.20
        for <kvm@vger.kernel.org>; Thu, 19 Aug 2021 14:12:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=E6gvO9OrXFcUe/cpRZ8MFuADLEe52cpmbYRUrdRkJ+A=;
        b=fSIHL225XlIK4PT6hAOuZWczzHZSWvlxYfmJwlPInjTQMSMf5fUrYqVu6l5Pc/C2I4
         +FdB+TDjP/Pr1Ep9hsH+AZhUSpeRm2AsLqe3FDRa5wdE+PNGPghjhBNMma2zFRbqpt8q
         rw6v9X/jFg0a5XTTG3dVzcbOhH02Nxw14ElKtsDgbcEgrWwqOaGip12HdrwRwDEID7ds
         PQ2qapli/mGEZI4g86SQJ6I87OI5GW3mGdCzvaL0C9lJsOvFTUogKQQz+Bz5Rgnpj5MK
         XrKkg9AlljRTwOm5/lqC4jXlbcK8LAZGvPEeTDfv9WkiKMK0F543umDMlHT4PI0xTcgP
         MHLw==
X-Gm-Message-State: AOAM533MCDLMnm452cSSzwYiHvsT13MG4ElPlWrOL8MEE8PikKtemLzc
        j7QRKwNAiTBIwlO4y+UxHEzuD+b77cp4MnJlRQunQO7qXtjegoLZtwcnAl0TxgMZpsKtQxRt5bb
        1lbNIpXB192h8
X-Received: by 2002:a9d:2623:: with SMTP id a32mr13182302otb.230.1629407557348;
        Thu, 19 Aug 2021 14:12:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzUeeSwDkzPyIuUpTTNozB4BrJ608hcWg5fGUZ6DQun89xaPNcF182TXCouJfusmvYM/5S3YA==
X-Received: by 2002:a9d:2623:: with SMTP id a32mr13182284otb.230.1629407557130;
        Thu, 19 Aug 2021 14:12:37 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id 32sm969567otr.2.2021.08.19.14.12.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Aug 2021 14:12:36 -0700 (PDT)
Date:   Thu, 19 Aug 2021 15:12:35 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     <bhelgaas@google.com>, <corbet@lwn.net>,
        <diana.craciun@oss.nxp.com>, <kwankhede@nvidia.com>,
        <eric.auger@redhat.com>, <masahiroy@kernel.org>,
        <michal.lkml@markovi.net>, <linux-pci@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <kvm@vger.kernel.org>,
        <linux-s390@vger.kernel.org>, <linux-kbuild@vger.kernel.org>,
        <mgurtovoy@nvidia.com>, <jgg@nvidia.com>, <maorg@nvidia.com>,
        <leonro@nvidia.com>
Subject: Re: [PATCH V2 06/12] vfio/pci: Split the pci_driver code out of
 vfio_pci_core.c
Message-ID: <20210819151235.6fe61269.alex.williamson@redhat.com>
In-Reply-To: <20210818151606.202815-7-yishaih@nvidia.com>
References: <20210818151606.202815-1-yishaih@nvidia.com>
        <20210818151606.202815-7-yishaih@nvidia.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 18 Aug 2021 18:16:00 +0300
Yishai Hadas <yishaih@nvidia.com> wrote:
> +
> +static int vfio_pci_sriov_configure(struct pci_dev *pdev, int nr_virtfn)
> +{
> +	might_sleep();

vfio_pci_core_sriov_configure() retained the might_sleep(), it
shouldn't be needed here.

> +
> +	if (!enable_sriov)
> +		return -ENOENT;
> +
> +	return vfio_pci_core_sriov_configure(pdev, nr_virtfn);
> +}
...
> @@ -509,7 +449,7 @@ static struct vfio_pci_core_device *get_pf_vdev(struct vfio_pci_core_device *vde
>  	if (!pf_dev)
>  		return NULL;
>  
> -	if (pci_dev_driver(physfn) != &vfio_pci_driver) {
> +	if (pci_dev_driver(physfn) != pci_dev_driver(vdev->pdev)) {

I think this means that the PF and VF must use the same vfio-pci
"variant" driver, it's too bad we're not enabling vfio-pci to own the
PF while vfio-vendor-foo-pci owns the VF since our SR-IOV security
model remains in the core.  We can work on that later though, no loss
of functionality here.

...
> @@ -1795,12 +1723,12 @@ static int vfio_pci_bus_notifier(struct notifier_block *nb,
>  		pci_info(vdev->pdev, "Captured SR-IOV VF %s driver_override\n",
>  			 pci_name(pdev));
>  		pdev->driver_override = kasprintf(GFP_KERNEL, "%s",
> -						  vfio_pci_ops.name);
> +						  vdev->vdev.ops->name);
>  	} else if (action == BUS_NOTIFY_BOUND_DRIVER &&
>  		   pdev->is_virtfn && physfn == vdev->pdev) {
>  		struct pci_driver *drv = pci_dev_driver(pdev);
>  
> -		if (drv && drv != &vfio_pci_driver)
> +		if (drv && drv != pci_dev_driver(vdev->pdev))
>  			pci_warn(vdev->pdev,
>  				 "VF %s bound to driver %s while PF bound to vfio-pci\n",

"vfio-pci" is hardcoded in this comment.  There are a few other user
visible instances of this in vfio-pci-core.c as well:

MODULE_PARM_DESC(disable_vga, "Disable VGA resource access through vfio-pci");

                ret = pci_request_selected_regions(pdev,
                                                   1 << index, "vfio-pci");

                        pci_info_ratelimited(vdev->pdev,
                                "VF token incorrectly provided, PF not bound to vfio-pci\n");

We should try to fix or reword as many of these as we reasonably can.
Thanks,

Alex

