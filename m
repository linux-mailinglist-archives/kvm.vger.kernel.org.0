Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6726166979
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2020 22:00:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729113AbgBTVAT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Feb 2020 16:00:19 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:38970 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728936AbgBTVAT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Feb 2020 16:00:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582232418;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yiunvjhi0mmwDra9J4GOFZcEpSpxQietN0rDNA6NOEg=;
        b=a1/tjNMJgG0q7wGFpXtPkJ5glMlwEeVvbjwfbF3tLnVRUykD8JzAh0hNq3EA7cQMtAb9uc
        pkc3r2RJIs6LQfSS5+mWCGOnVOhPy/9RhQRu0qXKR4DH58sYpImeE0pNjTjCfjVnCjH2Fo
        IIWWX7+6/h0LoyqQLpy5PkOUE/6viN0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-349-yP3m1cQ0ODKoJg2CFqu37Q-1; Thu, 20 Feb 2020 16:00:16 -0500
X-MC-Unique: yP3m1cQ0ODKoJg2CFqu37Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 713578017CC;
        Thu, 20 Feb 2020 21:00:14 +0000 (UTC)
Received: from w520.home (ovpn-116-28.phx2.redhat.com [10.3.116.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D5BC75C114;
        Thu, 20 Feb 2020 21:00:13 +0000 (UTC)
Date:   Thu, 20 Feb 2020 14:00:13 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        cohuck@redhat.com, zhenyuw@linux.intel.com, zhi.a.wang@intel.com,
        kevin.tian@intel.com, shaopeng.he@intel.com, yi.l.liu@intel.com
Subject: Re: [RFC PATCH v3 6/9] vfio/pci: export vfio_pci_setup_barmap
Message-ID: <20200220140013.66a6b52c@w520.home>
In-Reply-To: <20200211101419.21067-1-yan.y.zhao@intel.com>
References: <20200211095727.20426-1-yan.y.zhao@intel.com>
        <20200211101419.21067-1-yan.y.zhao@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 11 Feb 2020 05:14:19 -0500
Yan Zhao <yan.y.zhao@intel.com> wrote:

> This allows vendor driver to read/write to bars directly which is useful
> in security checking condition.
> 
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> ---
>  drivers/vfio/pci/vfio_pci_rdwr.c | 26 +++++++++++++-------------
>  include/linux/vfio.h             |  2 ++
>  2 files changed, 15 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
> index a0ef1de4f74a..3ba85fb2af5b 100644
> --- a/drivers/vfio/pci/vfio_pci_rdwr.c
> +++ b/drivers/vfio/pci/vfio_pci_rdwr.c
> @@ -129,7 +129,7 @@ static ssize_t do_io_rw(void __iomem *io, char __user *buf,
>  	return done;
>  }
>  
> -static int vfio_pci_setup_barmap(struct vfio_pci_device *vdev, int bar)
> +void __iomem *vfio_pci_setup_barmap(struct vfio_pci_device *vdev, int bar)
>  {
>  	struct pci_dev *pdev = vdev->pdev;
>  	struct vfio_pci_device_private *priv = VDEV_TO_PRIV(vdev);
> @@ -137,22 +137,23 @@ static int vfio_pci_setup_barmap(struct vfio_pci_device *vdev, int bar)
>  	void __iomem *io;
>  
>  	if (priv->barmap[bar])
> -		return 0;
> +		return priv->barmap[bar];
>  
>  	ret = pci_request_selected_regions(pdev, 1 << bar, "vfio");
>  	if (ret)
> -		return ret;
> +		return NULL;
>  
>  	io = pci_iomap(pdev, bar, 0);
>  	if (!io) {
>  		pci_release_selected_regions(pdev, 1 << bar);
> -		return -ENOMEM;
> +		return NULL;
>  	}
>  
>  	priv->barmap[bar] = io;
>  
> -	return 0;
> +	return io;
>  }
> +EXPORT_SYMBOL_GPL(vfio_pci_setup_barmap);

This should instead become a vfio_pci_get_barmap() function that tests
for an optionally calls vfio_pci_setup_barmap before returning the
pointer.  I'm now willing to lose the better error returns in the
original.  Thanks,

Alex

