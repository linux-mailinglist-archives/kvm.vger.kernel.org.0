Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B425657A6F
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2019 06:07:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727002AbfF0EHn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jun 2019 00:07:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18794 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725385AbfF0EHn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jun 2019 00:07:43 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3B8162F8BE2;
        Thu, 27 Jun 2019 04:07:43 +0000 (UTC)
Received: from x1.home (ovpn-117-35.phx2.redhat.com [10.3.117.35])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ED4311001281;
        Thu, 27 Jun 2019 04:07:39 +0000 (UTC)
Date:   Wed, 26 Jun 2019 22:07:39 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Tina Zhang <tina.zhang@intel.com>
Cc:     intel-gvt-dev@lists.freedesktop.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kraxel@redhat.com,
        zhenyuw@linux.intel.com, zhiyuan.lv@intel.com,
        zhi.a.wang@intel.com, kevin.tian@intel.com, hang.yuan@intel.com
Subject: Re: [RFC PATCH v3 1/4] vfio: Define device specific irq type
 capability
Message-ID: <20190626220739.578c518b@x1.home>
In-Reply-To: <20190627033802.1663-2-tina.zhang@intel.com>
References: <20190627033802.1663-1-tina.zhang@intel.com>
        <20190627033802.1663-2-tina.zhang@intel.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Thu, 27 Jun 2019 04:07:43 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 27 Jun 2019 11:37:59 +0800
Tina Zhang <tina.zhang@intel.com> wrote:

> Cap the number of irqs with fixed indexes and use capability chains
> to chain device specific irqs.
> 
> Signed-off-by: Tina Zhang <tina.zhang@intel.com>
> ---
>  include/uapi/linux/vfio.h | 19 ++++++++++++++++++-
>  1 file changed, 18 insertions(+), 1 deletion(-)
> 
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index 02bb7ad6e986..600784acc4ac 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -444,11 +444,27 @@ struct vfio_irq_info {
>  #define VFIO_IRQ_INFO_MASKABLE		(1 << 1)
>  #define VFIO_IRQ_INFO_AUTOMASKED	(1 << 2)
>  #define VFIO_IRQ_INFO_NORESIZE		(1 << 3)
> +#define VFIO_IRQ_INFO_FLAG_CAPS		(1 << 4) /* Info supports caps */
>  	__u32	index;		/* IRQ index */
> +	__u32	cap_offset;	/* Offset within info struct of first cap */
>  	__u32	count;		/* Number of IRQs within this index */
>  };


This cannot be inserted into the middle of the structure, it breaks
compatibility with all existing userspace binaries.  I must be added to
the end of the structure.

>  #define VFIO_DEVICE_GET_IRQ_INFO	_IO(VFIO_TYPE, VFIO_BASE + 9)
>  
> +/*
> + * The irq type capability allows irqs unique to a specific device or
> + * class of devices to be exposed.
> + *
> + * The structures below define version 1 of this capability.
> + */
> +#define VFIO_IRQ_INFO_CAP_TYPE      3
> +
> +struct vfio_irq_info_cap_type {
> +	struct vfio_info_cap_header header;
> +	__u32 type;     /* global per bus driver */
> +	__u32 subtype;  /* type specific */
> +};
> +
>  /**
>   * VFIO_DEVICE_SET_IRQS - _IOW(VFIO_TYPE, VFIO_BASE + 10, struct vfio_irq_set)
>   *
> @@ -550,7 +566,8 @@ enum {
>  	VFIO_PCI_MSIX_IRQ_INDEX,
>  	VFIO_PCI_ERR_IRQ_INDEX,
>  	VFIO_PCI_REQ_IRQ_INDEX,
> -	VFIO_PCI_NUM_IRQS
> +	VFIO_PCI_NUM_IRQS = 5	/* Fixed user ABI, IRQ indexes >=5 use   */
> +				/* device specific cap to define content */
>  };
>  
>  /*

