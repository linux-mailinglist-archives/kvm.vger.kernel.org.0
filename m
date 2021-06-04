Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F322739B11B
	for <lists+kvm@lfdr.de>; Fri,  4 Jun 2021 05:47:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbhFDDtX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Jun 2021 23:49:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25051 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229718AbhFDDtW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 3 Jun 2021 23:49:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622778456;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qYVKZDuvt5Qic5U7hRSglNEDW7YcTuvFUNtFxiNT7O8=;
        b=AZ/Y54HvkpKqAG3KwZEZoyWKVhYffiS+2s8wSYi48rDrWlS9ZH2W11E0vXkZfQ3XoNPesD
        3G5jXFszrhz5lwTHMcFxUGdOuzswtqtAH17BKm/NqK5fDDXmqaoq2gMgk/JR7G1bBJEgY2
        RMOKDCo5+iFnfCQLTTw8KAjOKqzOYAc=
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com
 [209.85.210.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-601-kAZxU714Nw-xA-j-0f1qKw-1; Thu, 03 Jun 2021 23:47:34 -0400
X-MC-Unique: kAZxU714Nw-xA-j-0f1qKw-1
Received: by mail-ot1-f69.google.com with SMTP id r16-20020a0568301350b0290363e6a9392fso4375297otq.13
        for <kvm@vger.kernel.org>; Thu, 03 Jun 2021 20:47:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qYVKZDuvt5Qic5U7hRSglNEDW7YcTuvFUNtFxiNT7O8=;
        b=Jj9KhJnPsnebihyQBLSaa2IbSPRtN2jVbMi0NROjSweyMZVKrfMmeg5o2lVI84X49G
         GP3mSO3n377yiz1pu9DDlhEVDuR3XTYlKLLmuJRE3IqWXTv3J8pa6zkYWLR0BZq/Xicu
         9Z8N26AAuY81/LKyZuVKuUoedTlEqJym69n65FTwuky1hs1u16vFn3OcElKS9rGnIwgh
         dWule1t4Kh4/hU/nTbWdQy6YCGRxgP/PDZqKWY7FBI1+OlgivaI5vXftnbN7GMPNeYoC
         ubDYgGNmcWUc9KcrkHUFb9WdcjXtK5Ow+OCItBDNJ1CL6OdOS7UkJTw2dHYscwKYJA10
         yg/w==
X-Gm-Message-State: AOAM531RJqB9qCScjgunrqYjQjyp3GEE5VFuZBM11vzG3TVOUrKV1R6f
        03/hPcUJ/fNaVx0glrxCQ9rSz7pXMnY/70MLS/bUFCBu2KLi1INGF4jimaOLm1ERtTtfkTKPLdn
        byWgJiZ4a8dKM
X-Received: by 2002:aca:42c6:: with SMTP id p189mr9377796oia.36.1622778454092;
        Thu, 03 Jun 2021 20:47:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzPpaWKooEIC1jgqP5XfvYz7fSFRzk4H+W3/+1Ves6P7f1pdUp+76S8SrIRLTsgQayfXww8vg==
X-Received: by 2002:aca:42c6:: with SMTP id p189mr9377780oia.36.1622778453943;
        Thu, 03 Jun 2021 20:47:33 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id n11sm214881oom.1.2021.06.03.20.47.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jun 2021 20:47:33 -0700 (PDT)
Date:   Thu, 3 Jun 2021 21:47:31 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Dave Jiang <dave.jiang@intel.com>
Cc:     kwankhede@nvidia.com, tglx@linutronix.de, vkoul@kernel.org,
        jgg@mellanox.com, megha.dey@intel.com, jacob.jun.pan@intel.com,
        ashok.raj@intel.com, yi.l.liu@intel.com, baolu.lu@intel.com,
        kevin.tian@intel.com, sanjay.k.kumar@intel.com,
        tony.luck@intel.com, dan.j.williams@intel.com,
        eric.auger@redhat.com, pbonzini@redhat.com,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v6 12/20] vfio: move VFIO PCI macros to common header
Message-ID: <20210603214731.1631a480.alex.williamson@redhat.com>
In-Reply-To: <162164281969.261970.17759783730654052269.stgit@djiang5-desk3.ch.intel.com>
References: <162164243591.261970.3439987543338120797.stgit@djiang5-desk3.ch.intel.com>
        <162164281969.261970.17759783730654052269.stgit@djiang5-desk3.ch.intel.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 21 May 2021 17:20:19 -0700
Dave Jiang <dave.jiang@intel.com> wrote:

> Move some VFIO_PCI macros to a common header as they will be shared between
> mdev and vfio_pci.

No, this is the current implementation of vfio-pci, it's specifically
not meant to be a standard.  Each vfio device driver is free to expose
regions on the device file descriptor as they wish.  If you want to use
a 40-bit implementation as well, great, but it should not be imposed as
a standard.  Thanks,

Alex

> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  drivers/vfio/pci/vfio_pci_private.h |    6 ------
>  include/linux/vfio.h                |    6 ++++++
>  2 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pci_private.h
> index a17943911fcb..e644f981509c 100644
> --- a/drivers/vfio/pci/vfio_pci_private.h
> +++ b/drivers/vfio/pci/vfio_pci_private.h
> @@ -18,12 +18,6 @@
>  #ifndef VFIO_PCI_PRIVATE_H
>  #define VFIO_PCI_PRIVATE_H
>  
> -#define VFIO_PCI_OFFSET_SHIFT   40
> -
> -#define VFIO_PCI_OFFSET_TO_INDEX(off)	(off >> VFIO_PCI_OFFSET_SHIFT)
> -#define VFIO_PCI_INDEX_TO_OFFSET(index)	((u64)(index) << VFIO_PCI_OFFSET_SHIFT)
> -#define VFIO_PCI_OFFSET_MASK	(((u64)(1) << VFIO_PCI_OFFSET_SHIFT) - 1)
> -
>  /* Special capability IDs predefined access */
>  #define PCI_CAP_ID_INVALID		0xFF	/* default raw access */
>  #define PCI_CAP_ID_INVALID_VIRT		0xFE	/* default virt access */
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index 3b372fa57ef4..ed5ca027eb49 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -15,6 +15,12 @@
>  #include <linux/poll.h>
>  #include <uapi/linux/vfio.h>
>  
> +#define VFIO_PCI_OFFSET_SHIFT   40
> +
> +#define VFIO_PCI_OFFSET_TO_INDEX(off)	((off) >> VFIO_PCI_OFFSET_SHIFT)
> +#define VFIO_PCI_INDEX_TO_OFFSET(index)	((u64)(index) << VFIO_PCI_OFFSET_SHIFT)
> +#define VFIO_PCI_OFFSET_MASK	(((u64)(1) << VFIO_PCI_OFFSET_SHIFT) - 1)
> +
>  struct vfio_device {
>  	struct device *dev;
>  	const struct vfio_device_ops *ops;
> 
> 

