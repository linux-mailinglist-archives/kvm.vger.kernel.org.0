Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9868930AD8F
	for <lists+kvm@lfdr.de>; Mon,  1 Feb 2021 18:17:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231838AbhBARQg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 12:16:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26569 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230368AbhBARQe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Feb 2021 12:16:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612199708;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zoEgsUnA+6E+zicwySkdMUh9CFwLmdn7EQyiABNkBZY=;
        b=Yl3LHwBv+x5U0mu4JFC7c7gzBLByA6qBM3mmuJe27eIbj+GhKE8bJxRcz6OyimYnzJSBQJ
        b6ePCr5GiXHw3imr++OQlBg5ElrU1TjEyUwRHHfVnNJiw4ADZMjZI3JPX925eKMLb317vl
        HOFOgYCafpeEHa/G6BPucMxC8UFxvWg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-345-ShZAkfjNPAeLanazqPeJtQ-1; Mon, 01 Feb 2021 12:15:06 -0500
X-MC-Unique: ShZAkfjNPAeLanazqPeJtQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A483AAFAA4;
        Mon,  1 Feb 2021 17:15:03 +0000 (UTC)
Received: from gondolin (ovpn-113-126.ams2.redhat.com [10.36.113.126])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D693E5D9DC;
        Mon,  1 Feb 2021 17:14:56 +0000 (UTC)
Date:   Mon, 1 Feb 2021 18:14:54 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Max Gurtovoy <mgurtovoy@nvidia.com>
Cc:     <jgg@nvidia.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <alex.williamson@redhat.com>,
        <liranl@nvidia.com>, <oren@nvidia.com>, <tzahio@nvidia.com>,
        <leonro@nvidia.com>, <yarong@nvidia.com>, <aviadye@nvidia.com>,
        <shahafs@nvidia.com>, <artemp@nvidia.com>, <kwankhede@nvidia.com>,
        <ACurrid@nvidia.com>, <gmataev@nvidia.com>, <cjia@nvidia.com>,
        <mjrosato@linux.ibm.com>, <yishaih@nvidia.com>, <aik@ozlabs.ru>
Subject: Re: [PATCH 8/9] vfio/pci: use x86 naming instead of igd
Message-ID: <20210201181454.22112b57.cohuck@redhat.com>
In-Reply-To: <20210201162828.5938-9-mgurtovoy@nvidia.com>
References: <20210201162828.5938-1-mgurtovoy@nvidia.com>
        <20210201162828.5938-9-mgurtovoy@nvidia.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 1 Feb 2021 16:28:27 +0000
Max Gurtovoy <mgurtovoy@nvidia.com> wrote:

> This patch doesn't change any logic but only align to the concept of
> vfio_pci_core extensions. Extensions that are related to a platform
> and not to a specific vendor of PCI devices should be part of the core
> driver. Extensions that are specific for PCI device vendor should go
> to a dedicated vendor vfio-pci driver.

My understanding is that igd means support for Intel graphics, i.e. a
strict subset of x86. If there are other future extensions that e.g.
only make sense for some devices found only on AMD systems, I don't
think they should all be included under the same x86 umbrella.

Similar reasoning for nvlink, that only seems to cover support for some
GPUs under Power, and is not a general platform-specific extension IIUC.

We can arguably do the zdev -> s390 rename (as zpci appears only on
s390, and all PCI devices will be zpci on that platform), although I'm
not sure about the benefit.

> 
> For now, x86 extensions will include only igd.
> 
> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
> ---
>  drivers/vfio/pci/Kconfig                            | 13 ++++++-------
>  drivers/vfio/pci/Makefile                           |  2 +-
>  drivers/vfio/pci/vfio_pci_core.c                    |  2 +-
>  drivers/vfio/pci/vfio_pci_private.h                 |  2 +-
>  drivers/vfio/pci/{vfio_pci_igd.c => vfio_pci_x86.c} |  0
>  5 files changed, 9 insertions(+), 10 deletions(-)
>  rename drivers/vfio/pci/{vfio_pci_igd.c => vfio_pci_x86.c} (100%)

(...)

> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index c559027def2d..e0e258c37fb5 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -328,7 +328,7 @@ static int vfio_pci_enable(struct vfio_pci_device *vdev)
>  
>  	if (vfio_pci_is_vga(pdev) &&
>  	    pdev->vendor == PCI_VENDOR_ID_INTEL &&
> -	    IS_ENABLED(CONFIG_VFIO_PCI_IGD)) {
> +	    IS_ENABLED(CONFIG_VFIO_PCI_X86)) {
>  		ret = vfio_pci_igd_init(vdev);

This one explicitly checks for Intel devices, so I'm not sure why you
want to generalize this to x86?

>  		if (ret && ret != -ENODEV) {
>  			pci_warn(pdev, "Failed to setup Intel IGD regions\n");

