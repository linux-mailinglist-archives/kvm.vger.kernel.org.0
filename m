Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C65463D032D
	for <lists+kvm@lfdr.de>; Tue, 20 Jul 2021 22:46:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235367AbhGTUDR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Jul 2021 16:03:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42284 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237603AbhGTTv6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 20 Jul 2021 15:51:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626813153;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jyIXqBx5VnbN6f+SGKNmgxj2zuj1jSInCu86uEKhaLM=;
        b=JZ0NyB7jxaQbEXWIOQTEtn3ULiKPjJpHbu4vml99Ju7GPvzp89SRwpnn9PY/FPRVINJAio
        HGDsS++zistLp8sQD2dIC1MZSokG7CFq0IouxtE77+eBMnTOfDDcUgh4ORBlQ275QLMdlP
        JM/trPquu2BR9dUvcHIc76WGjNHpjgM=
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com
 [209.85.210.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-207-F6yeaVPJNn6pmcpHuZP34Q-1; Tue, 20 Jul 2021 16:32:31 -0400
X-MC-Unique: F6yeaVPJNn6pmcpHuZP34Q-1
Received: by mail-ot1-f72.google.com with SMTP id s11-20020a056830124bb02904d1d78ee61cso35366otp.3
        for <kvm@vger.kernel.org>; Tue, 20 Jul 2021 13:32:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jyIXqBx5VnbN6f+SGKNmgxj2zuj1jSInCu86uEKhaLM=;
        b=YgnXCvHcs1Ao5h9AnRuq9WPBAIJIcPUZzKpiXi/Zy6oknl08UPwz8poNBjECLlpEry
         x5LXwFVbfilRPE6g58758d7mVKI9xzGZaDJYna3t9ONpgwYLEWzEGsVHk+GTpVGlgmBQ
         I21E8zS7uaiaMOMXYhWGXNSryhh2IpCRwmSB1bOa+Y2mSDR1wnsfx3PMjZ2z1FWDgmbq
         bnARnFtz3DZDZXQ+YqWcT17XeAjFSIhANEtO1MeRuP9aGzE2eOSl/lHXNtdMQEqDLgsN
         xuUxcIq24GTaWC9nvRRwHWRWayKRrC7mnQ3LlecCaR9evsYB+gOKnp9vI7r7+LpMzH5R
         Sezw==
X-Gm-Message-State: AOAM530BTGn+YrBe+q6kwwBjXGZ0dNvmM13kYDbHy/vLGNQU3u+X9Aar
        ilGiSEmaiU/4lSwa5EK+j+eu09Tto1DA9FAtMA0aJODF7qf0Q68H6/YbMuIQs/UyNJVPsilnJeb
        hJH8+IRXAOscC
X-Received: by 2002:a05:6808:5d4:: with SMTP id d20mr187965oij.43.1626813151009;
        Tue, 20 Jul 2021 13:32:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzHEphdvA2U4/0BlxKutMeM8y5uwtmQ+JL6MXc9MTIOJdyRrIf32XjOMKcrBpCMp/fNWlnUUg==
X-Received: by 2002:a05:6808:5d4:: with SMTP id d20mr187957oij.43.1626813150901;
        Tue, 20 Jul 2021 13:32:30 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id z14sm3179522otm.66.2021.07.20.13.32.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jul 2021 13:32:30 -0700 (PDT)
Date:   Tue, 20 Jul 2021 14:32:29 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH] vfio_pci_core: Make vfio_pci_regops->rw() return
 ssize_t
Message-ID: <20210720143229.75a21984.alex.williamson@redhat.com>
In-Reply-To: <0-v1-cfc4743f1f6e+fefd-vfio_rw_jgg@nvidia.com>
References: <0-v1-cfc4743f1f6e+fefd-vfio_rw_jgg@nvidia.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 20 Jul 2021 14:39:12 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> From: Yishai Hadas <yishaih@nvidia.com>
> 
> The only implementation of this in IGD returns a -ERRNO which is
> implicitly cast through a size_t and then casted again and returned as a
> ssize_t in vfio_pci_rw().
> 
> Fix the vfio_pci_regops->rw() return type to be ssize_t so all is
> consistent.
> 
> Fixes: 28541d41c9e0 ("vfio/pci: Add infrastructure for additional device specific regions")
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> ---
>  drivers/vfio/pci/vfio_pci_igd.c | 10 +++++-----
>  include/linux/vfio_pci_core.h   |  2 +-
>  2 files changed, 6 insertions(+), 6 deletions(-)


This is against vfio_pci_core code that we don't have upstream yet.
Thanks,

Alex

 
> diff --git a/drivers/vfio/pci/vfio_pci_igd.c b/drivers/vfio/pci/vfio_pci_igd.c
> index f04774cd3a7ff0..8d07f0fc365c21 100644
> --- a/drivers/vfio/pci/vfio_pci_igd.c
> +++ b/drivers/vfio/pci/vfio_pci_igd.c
> @@ -25,8 +25,8 @@
>  #define OPREGION_RVDS		0x3c2
>  #define OPREGION_VERSION	0x16
>  
> -static size_t vfio_pci_igd_rw(struct vfio_pci_core_device *vdev, char __user *buf,
> -			      size_t count, loff_t *ppos, bool iswrite)
> +static ssize_t vfio_pci_igd_rw(struct vfio_pci_core_device *vdev, char __user *buf,
> +			       size_t count, loff_t *ppos, bool iswrite)
>  {
>  	unsigned int i = VFIO_PCI_OFFSET_TO_INDEX(*ppos) - VFIO_PCI_NUM_REGIONS;
>  	void *base = vdev->region[i].data;
> @@ -160,9 +160,9 @@ static int vfio_pci_igd_opregion_init(struct vfio_pci_core_device *vdev)
>  	return ret;
>  }
>  
> -static size_t vfio_pci_igd_cfg_rw(struct vfio_pci_core_device *vdev,
> -				  char __user *buf, size_t count, loff_t *ppos,
> -				  bool iswrite)
> +static ssize_t vfio_pci_igd_cfg_rw(struct vfio_pci_core_device *vdev,
> +				   char __user *buf, size_t count, loff_t *ppos,
> +				   bool iswrite)
>  {
>  	unsigned int i = VFIO_PCI_OFFSET_TO_INDEX(*ppos) - VFIO_PCI_NUM_REGIONS;
>  	struct pci_dev *pdev = vdev->region[i].data;
> diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
> index 0a51836e002e1e..fb5add3bded0ac 100644
> --- a/include/linux/vfio_pci_core.h
> +++ b/include/linux/vfio_pci_core.h
> @@ -57,7 +57,7 @@ struct vfio_pci_core_device;
>  struct vfio_pci_region;
>  
>  struct vfio_pci_regops {
> -	size_t	(*rw)(struct vfio_pci_core_device *vdev, char __user *buf,
> +	ssize_t	(*rw)(struct vfio_pci_core_device *vdev, char __user *buf,
>  		      size_t count, loff_t *ppos, bool iswrite);
>  	void	(*release)(struct vfio_pci_core_device *vdev,
>  			   struct vfio_pci_region *region);

