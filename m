Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B965166978
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2020 22:00:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729128AbgBTVAV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Feb 2020 16:00:21 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:54933 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729098AbgBTVAT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Feb 2020 16:00:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582232418;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m+oWt3SPhWAiuaw2Ro+zpYFjBbPlPq0cBH/yGGKJ2v4=;
        b=HuwYQAnrnWlkZ7/uupUvAFhvuvXwVdKwJTif1czDaSdsH2oiUx46JLHYATPsqVpUGIsKe2
        PLNtdC/ot/UQW332PjkC8IZJ7VIEwXFMv+kMfhMTE/qaAH+qdDD+7Oga9r0YLH+UukVJpj
        zpZM4gSU24Cs5uBKvqiQCYr6bNLU+8w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-488-Mw8hiM-SNR-m9qEdvYcFwA-1; Thu, 20 Feb 2020 16:00:14 -0500
X-MC-Unique: Mw8hiM-SNR-m9qEdvYcFwA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EC50110CE78A;
        Thu, 20 Feb 2020 21:00:12 +0000 (UTC)
Received: from w520.home (ovpn-116-28.phx2.redhat.com [10.3.116.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 403C760C87;
        Thu, 20 Feb 2020 21:00:12 +0000 (UTC)
Date:   Thu, 20 Feb 2020 14:00:11 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        cohuck@redhat.com, zhenyuw@linux.intel.com, zhi.a.wang@intel.com,
        kevin.tian@intel.com, shaopeng.he@intel.com, yi.l.liu@intel.com
Subject: Re: [RFC PATCH v3 1/9] vfio/pci: export vfio_pci_device public and
 add vfio_pci_device_private
Message-ID: <20200220140011.79621d7f@w520.home>
In-Reply-To: <20200211101038.20772-1-yan.y.zhao@intel.com>
References: <20200211095727.20426-1-yan.y.zhao@intel.com>
        <20200211101038.20772-1-yan.y.zhao@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 11 Feb 2020 05:10:38 -0500
Yan Zhao <yan.y.zhao@intel.com> wrote:

> (1) make vfio_pci_device public, so it is accessible from external code.
> (2) add a private struct vfio_pci_device_private, which is only accessible
> from internal code. It extends struct vfio_pci_device.
> 
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> ---
>  drivers/vfio/pci/vfio_pci.c         | 256 +++++++++++++++-------------
>  drivers/vfio/pci/vfio_pci_config.c  | 186 ++++++++++++--------
>  drivers/vfio/pci/vfio_pci_igd.c     |  19 ++-
>  drivers/vfio/pci/vfio_pci_intrs.c   | 186 +++++++++++---------
>  drivers/vfio/pci/vfio_pci_nvlink2.c |  22 +--
>  drivers/vfio/pci/vfio_pci_private.h |   7 +-
>  drivers/vfio/pci/vfio_pci_rdwr.c    |  40 +++--
>  include/linux/vfio.h                |   5 +
>  8 files changed, 408 insertions(+), 313 deletions(-)

[SNIP!]

> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index e42a711a2800..70a2b8fb6179 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -195,4 +195,9 @@ extern int vfio_virqfd_enable(void *opaque,
>  			      void *data, struct virqfd **pvirqfd, int fd);
>  extern void vfio_virqfd_disable(struct virqfd **pvirqfd);
>  
> +struct vfio_pci_device {
> +	struct pci_dev			*pdev;
> +	int				num_regions;
> +	int				irq_type;
> +};
>  #endif /* VFIO_H */

Hi Yan,

Sorry for the delay.  I'm still not very happy with this result, I was
hoping the changes could be done less intrusively.  Maybe here's
another suggestion, why can't the vendor driver use a struct
vfio_pci_device* as an opaque pointer?  If you only want these three
things initially, I think this whole massive patch can be reduced to:

struct pci_dev *vfio_pci_pdev(struct vfio_pci_device *vdev)
{
	return vdev->pdev;
}
EXPORT_SYMBOL_GPL(vfio_pci_dev);

int vfio_pci_num_regions(struct vfio_pci_device *vdev)
{
	return vdev->num_regions;
}
EXPORT_SYMBOL_GPL(vfio_pci_num_region);

int vfio_pci_irq_type(struct vfio_pci_device *vdev)
{
	return vdev->irq_type;
}
EXPORT_SYMBOL_GPL(vfio_pci_irq_type);

This is how vfio-pci works with vfio, we don't know a struct
vfio_device as anything other than an opaque pointer and we have access
function where we need to see some property of that object.

Patch 5/9 would become a vfio_pci_set_vendor_regions() interface.

Thanks,
Alex

