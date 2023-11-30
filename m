Return-Path: <kvm+bounces-3010-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D302C7FFB13
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 20:20:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8A3D02818F1
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 19:20:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83F1522075;
	Thu, 30 Nov 2023 19:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MJglnYnL"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A413E10DE
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 11:20:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701372016;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gI+NHy4QsgVzIpGUJkuvfP+tzzElBrBrYlrvCXuyd6c=;
	b=MJglnYnLdxtsDoZnQGMtX4z3N/qk6ItBPslVPfv5EshFGYWDJX6krnApWMD0B+jEU8HTk8
	zdwDCcV92a7xbaDrUpisjq1gtSRWa/BffMoA+CwDqLk15SS8a/wi0tCJDIsmyT70MaZiPF
	1gDwRs6QFFqWLbOyUPmaQ+FYcKH8E1w=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-19-71lNlJKZN3GWWOc7XQv86Q-1; Thu, 30 Nov 2023 14:20:14 -0500
X-MC-Unique: 71lNlJKZN3GWWOc7XQv86Q-1
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-7b40d154baeso76663739f.0
        for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 11:20:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701372013; x=1701976813;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gI+NHy4QsgVzIpGUJkuvfP+tzzElBrBrYlrvCXuyd6c=;
        b=lrUhyvyrfGB+er2apha7wJg7TxYbNo1fJxDiIdsHDe5ftCnlbxUycMEzI9+HWCAHg5
         Aw6sRpe4gK77MwKVPruvdvSe+GOCeFAaAiO9qdvhmfp0kvHSI6hd9Uc5zbwr0ujXLxLK
         t1IBJ68mFOaubTCroHMSojLL30DBEUFp6bF/Q4qq6QBsKgq5VYbdj1Uq5QIO2Jgz0zSc
         u1VOT4tuyn5aPpbROrPpiIqaE4rU7hz0CReAtUj5EpaaGBCpkPGWCpsBmOvmnYkhFd6R
         8bH3iHqxes6JGerSPmykwAPpeEyec+B64SlJHZ3kVR32BnSmAMZ0bQrumSKMEnuIjZzA
         7yCg==
X-Gm-Message-State: AOJu0YzHqDZ8lKh35jRYarW6CMBgLdgWOuuf87UcqAuP5p3CV/a9MtKP
	+D6Swb9IJ0CAbki9jfOzUTH8d4T/nKpsdQRCvkdX1TOvOqvxuJ4BESAwOQl9C4kPaXQw+jtSR3S
	w5EA9XYrnVKB2kcrQqpFi
X-Received: by 2002:a5e:8613:0:b0:791:16ba:d764 with SMTP id z19-20020a5e8613000000b0079116bad764mr25053622ioj.16.1701372012878;
        Thu, 30 Nov 2023 11:20:12 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFWZAGlxOOtEZV4cyIfR8XEUIGJn/VBf5TbyQKFfZMrEfeBiouv9jSp1k1yGD0s6K3Fb1D2/A==
X-Received: by 2002:a5e:8613:0:b0:791:16ba:d764 with SMTP id z19-20020a5e8613000000b0079116bad764mr25053595ioj.16.1701372012621;
        Thu, 30 Nov 2023 11:20:12 -0800 (PST)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id cc14-20020a056602424e00b007b35739a580sm509939iob.27.2023.11.30.11.20.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Nov 2023 11:20:12 -0800 (PST)
Date: Thu, 30 Nov 2023 12:20:10 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Yishai Hadas <yishaih@nvidia.com>
Cc: <mst@redhat.com>, <jasowang@redhat.com>, <jgg@nvidia.com>,
 <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
 <parav@nvidia.com>, <feliu@nvidia.com>, <jiri@nvidia.com>,
 <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
 <si-wei.liu@oracle.com>, <leonro@nvidia.com>, <maorg@nvidia.com>
Subject: Re: [PATCH V4 vfio 8/9] vfio/pci: Expose
 vfio_pci_iowrite/read##size()
Message-ID: <20231130122010.3563bdee.alex.williamson@redhat.com>
In-Reply-To: <20231129143746.6153-9-yishaih@nvidia.com>
References: <20231129143746.6153-1-yishaih@nvidia.com>
	<20231129143746.6153-9-yishaih@nvidia.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 29 Nov 2023 16:37:45 +0200
Yishai Hadas <yishaih@nvidia.com> wrote:

> Expose vfio_pci_iowrite/read##size() to let it be used by drivers.
> 
> This functionality is needed to enable direct access to some physical
> BAR of the device with the proper locks/checks in place.
> 
> The next patches from this series will use this functionality on a data
> path flow when a direct access to the BAR is needed.
> 
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> ---
>  drivers/vfio/pci/vfio_pci_rdwr.c | 10 ++++++----
>  include/linux/vfio_pci_core.h    | 19 +++++++++++++++++++
>  2 files changed, 25 insertions(+), 4 deletions(-)

I don't follow the inconsistency between this and the previous patch.
Why did we move and rename the code to setup the barmap but we export
the ioread/write functions in place?  Thanks,

Alex


> diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
> index 6f08b3ecbb89..817ec9a89123 100644
> --- a/drivers/vfio/pci/vfio_pci_rdwr.c
> +++ b/drivers/vfio/pci/vfio_pci_rdwr.c
> @@ -38,7 +38,7 @@
>  #define vfio_iowrite8	iowrite8
>  
>  #define VFIO_IOWRITE(size) \
> -static int vfio_pci_iowrite##size(struct vfio_pci_core_device *vdev,		\
> +int vfio_pci_iowrite##size(struct vfio_pci_core_device *vdev,		\
>  			bool test_mem, u##size val, void __iomem *io)	\
>  {									\
>  	if (test_mem) {							\
> @@ -55,7 +55,8 @@ static int vfio_pci_iowrite##size(struct vfio_pci_core_device *vdev,		\
>  		up_read(&vdev->memory_lock);				\
>  									\
>  	return 0;							\
> -}
> +}									\
> +EXPORT_SYMBOL_GPL(vfio_pci_iowrite##size);
>  
>  VFIO_IOWRITE(8)
>  VFIO_IOWRITE(16)
> @@ -65,7 +66,7 @@ VFIO_IOWRITE(64)
>  #endif
>  
>  #define VFIO_IOREAD(size) \
> -static int vfio_pci_ioread##size(struct vfio_pci_core_device *vdev,		\
> +int vfio_pci_ioread##size(struct vfio_pci_core_device *vdev,		\
>  			bool test_mem, u##size *val, void __iomem *io)	\
>  {									\
>  	if (test_mem) {							\
> @@ -82,7 +83,8 @@ static int vfio_pci_ioread##size(struct vfio_pci_core_device *vdev,		\
>  		up_read(&vdev->memory_lock);				\
>  									\
>  	return 0;							\
> -}
> +}									\
> +EXPORT_SYMBOL_GPL(vfio_pci_ioread##size);
>  
>  VFIO_IOREAD(8)
>  VFIO_IOREAD(16)
> diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
> index 67ac58e20e1d..22c915317788 100644
> --- a/include/linux/vfio_pci_core.h
> +++ b/include/linux/vfio_pci_core.h
> @@ -131,4 +131,23 @@ int vfio_pci_core_setup_barmap(struct vfio_pci_core_device *vdev, int bar);
>  pci_ers_result_t vfio_pci_core_aer_err_detected(struct pci_dev *pdev,
>  						pci_channel_state_t state);
>  
> +#define VFIO_IOWRITE_DECLATION(size) \
> +int vfio_pci_iowrite##size(struct vfio_pci_core_device *vdev,		\
> +			bool test_mem, u##size val, void __iomem *io);
> +
> +VFIO_IOWRITE_DECLATION(8)
> +VFIO_IOWRITE_DECLATION(16)
> +VFIO_IOWRITE_DECLATION(32)
> +#ifdef iowrite64
> +VFIO_IOWRITE_DECLATION(64)
> +#endif
> +
> +#define VFIO_IOREAD_DECLATION(size) \
> +int vfio_pci_ioread##size(struct vfio_pci_core_device *vdev,		\
> +			bool test_mem, u##size *val, void __iomem *io);
> +
> +VFIO_IOREAD_DECLATION(8)
> +VFIO_IOREAD_DECLATION(16)
> +VFIO_IOREAD_DECLATION(32)
> +
>  #endif /* VFIO_PCI_CORE_H */


