Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F1B91EE7B0
	for <lists+kvm@lfdr.de>; Thu,  4 Jun 2020 17:25:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729500AbgFDPZb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jun 2020 11:25:31 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:53735 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729035AbgFDPZb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 4 Jun 2020 11:25:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591284330;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+QNtRZdQksHtLTAxFoyE3GgtLlyfez9R35g/z9pvVhk=;
        b=eJ3nrJSxcZk3l0F4A/tQie7FfUQ+DPBoOj/tFpN3hMgZID26DoxYdu6JuGTybs5upM9oMS
        39AbM8VmSP1HfZda5wR8dO8mHQxrZ+0+6I6NDPRaqi8BUOQp7O1lfCF7ndKl2BPsZr66F3
        cGdsvFKv39D1NGp1pHFx7pSjISBF+Dk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-88-H6Yl6rxpPS2aoSTqNcEvog-1; Thu, 04 Jun 2020 11:25:25 -0400
X-MC-Unique: H6Yl6rxpPS2aoSTqNcEvog-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9275C805489;
        Thu,  4 Jun 2020 15:25:23 +0000 (UTC)
Received: from gondolin (ovpn-112-76.ams2.redhat.com [10.36.112.76])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 882D67A8D2;
        Thu,  4 Jun 2020 15:25:18 +0000 (UTC)
Date:   Thu, 4 Jun 2020 17:25:15 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        alex.williamson@redhat.com, zhenyuw@linux.intel.com,
        zhi.a.wang@intel.com, kevin.tian@intel.com, shaopeng.he@intel.com,
        yi.l.liu@intel.com, xin.zeng@intel.com, hang.yuan@intel.com
Subject: Re: [RFC PATCH v4 04/10] vfio/pci: let vfio_pci know number of
 vendor regions and vendor irqs
Message-ID: <20200604172515.614e9864.cohuck@redhat.com>
In-Reply-To: <20200518024944.14263-1-yan.y.zhao@intel.com>
References: <20200518024202.13996-1-yan.y.zhao@intel.com>
        <20200518024944.14263-1-yan.y.zhao@intel.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 17 May 2020 22:49:44 -0400
Yan Zhao <yan.y.zhao@intel.com> wrote:

> This allows a simpler VFIO_DEVICE_GET_INFO ioctl in vendor driver
> 
> Cc: Kevin Tian <kevin.tian@intel.com>
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> ---
>  drivers/vfio/pci/vfio_pci.c         | 23 +++++++++++++++++++++--
>  drivers/vfio/pci/vfio_pci_private.h |  2 ++
>  include/linux/vfio.h                |  3 +++
>  3 files changed, 26 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> index 290b7ab55ecf..30137c1c5308 100644
> --- a/drivers/vfio/pci/vfio_pci.c
> +++ b/drivers/vfio/pci/vfio_pci.c
> @@ -105,6 +105,24 @@ void *vfio_pci_vendor_data(void *device_data)
>  }
>  EXPORT_SYMBOL_GPL(vfio_pci_vendor_data);
>  
> +int vfio_pci_set_vendor_regions(void *device_data, int num_vendor_regions)
> +{
> +	struct vfio_pci_device *vdev = device_data;
> +
> +	vdev->num_vendor_regions = num_vendor_regions;

Do we need any kind of sanity check here, in case this is called with a
bogus value?

> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(vfio_pci_set_vendor_regions);
> +
> +
> +int vfio_pci_set_vendor_irqs(void *device_data, int num_vendor_irqs)
> +{
> +	struct vfio_pci_device *vdev = device_data;
> +
> +	vdev->num_vendor_irqs = num_vendor_irqs;

Here as well.

> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(vfio_pci_set_vendor_irqs);
>  /*
>   * Our VGA arbiter participation is limited since we don't know anything
>   * about the device itself.  However, if the device is the only VGA device

(...)

