Return-Path: <kvm+bounces-3642-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DE8380621D
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 23:52:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 70B201C2110B
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 22:52:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E21B405C5;
	Tue,  5 Dec 2023 22:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZG6ABtKt"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 279BB1B1
	for <kvm@vger.kernel.org>; Tue,  5 Dec 2023 14:52:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701816719;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bp190EtfGjWCeA3brdN4OZ/TodkB+7ZXGXpd4KD/R9A=;
	b=ZG6ABtKt8QNMdGVEjTic6laOVcdJgqGXkVmh0OQuagKlWciq46EWrX3uyWd/QIUU6Mw9Sf
	7CRPuquB8kE19yYVAF4+jlHXW2ZaFvat9HDlhZjWUmepJHh8yBbHQM7p+72eeXODBKoUDA
	nawi886hAra/6NPlYrsZ7P372akNGFw=
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com
 [209.85.161.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-212-l0Ghnvz4NI6_9lnWLPL4lw-1; Tue, 05 Dec 2023 17:51:57 -0500
X-MC-Unique: l0Ghnvz4NI6_9lnWLPL4lw-1
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-58d5657b6bbso334124eaf.1
        for <kvm@vger.kernel.org>; Tue, 05 Dec 2023 14:51:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701816716; x=1702421516;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bp190EtfGjWCeA3brdN4OZ/TodkB+7ZXGXpd4KD/R9A=;
        b=qttq3PYHellbKbIGFv7GP5OvNWGMo8mEW3ffzQR2J0cG8MM07FYEgr4wkr7dmYHYFF
         9wBpOoZ0GIOraUZvGQBdn6rTl1DfAHCVC9vIyO3nxBFDThy57g7nWhoI2U/gCrf3JF3q
         Vr6ZYU2RE57SNpKku1UihsioEEXssvfrC2Ds4Y6AW+o4YOX+q9OwhxPPgvR6cJJMuHE/
         bB4e7YnGBFapFWTMy84njdQDFOx/vE1BimXP9Wr0uJDDsDE1UuU9b0GXCP4XjrMTtHdz
         3pTPnnzRoq0lHgnVmKIqSsm/3MKn449q3uU2XpkNpf4VUreYWcPpnQlJk0XjtuJe9nqx
         t67g==
X-Gm-Message-State: AOJu0YyyUQGdv0FAkxj+x6cBXPKWqeu300DI4SuHSst8aYrTVuf5GN4h
	pBx0TtplB8LoZYmzKz11Z9JcI2J4USkMmZhJauAUKn5EmXc6osFArsgoNKmg+PsFtTtWHveooGd
	7uzM4IIMIsRiG
X-Received: by 2002:a05:6870:b14d:b0:1fb:788:e8a3 with SMTP id a13-20020a056870b14d00b001fb0788e8a3mr1044679oal.30.1701816716689;
        Tue, 05 Dec 2023 14:51:56 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHX+wy1tCPko5PNZEieZRXLMkP4wf5109/rs8kmfxtsW8LCRjq2ZZRbnCa0Y7fVkzda+iRfsA==
X-Received: by 2002:a05:6870:b14d:b0:1fb:788:e8a3 with SMTP id a13-20020a056870b14d00b001fb0788e8a3mr1044670oal.30.1701816716352;
        Tue, 05 Dec 2023 14:51:56 -0800 (PST)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id pb15-20020a0568701e8f00b001fb17559927sm2426720oab.48.2023.12.05.14.51.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Dec 2023 14:51:55 -0800 (PST)
Date: Tue, 5 Dec 2023 15:51:53 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Yishai Hadas <yishaih@nvidia.com>
Cc: <mst@redhat.com>, <jasowang@redhat.com>, <jgg@nvidia.com>,
 <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
 <parav@nvidia.com>, <feliu@nvidia.com>, <jiri@nvidia.com>,
 <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
 <si-wei.liu@oracle.com>, <leonro@nvidia.com>, <maorg@nvidia.com>
Subject: Re: [PATCH V5 vfio 8/9] vfio/pci: Expose
 vfio_pci_core_iowrite/read##size()
Message-ID: <20231205155153.2d5aceab.alex.williamson@redhat.com>
In-Reply-To: <20231205170623.197877-9-yishaih@nvidia.com>
References: <20231205170623.197877-1-yishaih@nvidia.com>
	<20231205170623.197877-9-yishaih@nvidia.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 5 Dec 2023 19:06:22 +0200
Yishai Hadas <yishaih@nvidia.com> wrote:

> Expose vfio_pci_core_iowrite/read##size() to let it be used by drivers.
> 
> This functionality is needed to enable direct access to some physical
> BAR of the device with the proper locks/checks in place.
> 
> The next patches from this series will use this functionality on a data
> path flow when a direct access to the BAR is needed.
> 
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> ---
>  drivers/vfio/pci/vfio_pci_rdwr.c | 46 +++++++++++++++++---------------
>  include/linux/vfio_pci_core.h    | 19 +++++++++++++
>  2 files changed, 43 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
> index a9887fd6de46..448ee90a3bb1 100644
> --- a/drivers/vfio/pci/vfio_pci_rdwr.c
> +++ b/drivers/vfio/pci/vfio_pci_rdwr.c
> @@ -38,7 +38,7 @@
>  #define vfio_iowrite8	iowrite8
>  
>  #define VFIO_IOWRITE(size) \
> -static int vfio_pci_iowrite##size(struct vfio_pci_core_device *vdev,		\
> +int vfio_pci_core_iowrite##size(struct vfio_pci_core_device *vdev,	\
>  			bool test_mem, u##size val, void __iomem *io)	\
>  {									\
>  	if (test_mem) {							\
> @@ -55,7 +55,8 @@ static int vfio_pci_iowrite##size(struct vfio_pci_core_device *vdev,		\
>  		up_read(&vdev->memory_lock);				\
>  									\
>  	return 0;							\
> -}
> +}									\
> +EXPORT_SYMBOL_GPL(vfio_pci_core_iowrite##size);
>  
>  VFIO_IOWRITE(8)
>  VFIO_IOWRITE(16)
> @@ -65,7 +66,7 @@ VFIO_IOWRITE(64)
>  #endif
>  
>  #define VFIO_IOREAD(size) \
> -static int vfio_pci_ioread##size(struct vfio_pci_core_device *vdev,		\
> +int vfio_pci_core_ioread##size(struct vfio_pci_core_device *vdev,	\
>  			bool test_mem, u##size *val, void __iomem *io)	\
>  {									\
>  	if (test_mem) {							\
> @@ -82,7 +83,8 @@ static int vfio_pci_ioread##size(struct vfio_pci_core_device *vdev,		\
>  		up_read(&vdev->memory_lock);				\
>  									\
>  	return 0;							\
> -}
> +}									\
> +EXPORT_SYMBOL_GPL(vfio_pci_core_ioread##size);
>  
>  VFIO_IOREAD(8)
>  VFIO_IOREAD(16)
> @@ -119,13 +121,13 @@ static ssize_t do_io_rw(struct vfio_pci_core_device *vdev, bool test_mem,
>  				if (copy_from_user(&val, buf, 4))
>  					return -EFAULT;
>  
> -				ret = vfio_pci_iowrite32(vdev, test_mem,
> -							 val, io + off);
> +				ret = vfio_pci_core_iowrite32(vdev, test_mem,
> +							      val, io + off);
>  				if (ret)
>  					return ret;
>  			} else {
> -				ret = vfio_pci_ioread32(vdev, test_mem,
> -							&val, io + off);
> +				ret = vfio_pci_core_ioread32(vdev, test_mem,
> +							     &val, io + off);
>  				if (ret)
>  					return ret;
>  
> @@ -141,13 +143,13 @@ static ssize_t do_io_rw(struct vfio_pci_core_device *vdev, bool test_mem,
>  				if (copy_from_user(&val, buf, 2))
>  					return -EFAULT;
>  
> -				ret = vfio_pci_iowrite16(vdev, test_mem,
> -							 val, io + off);
> +				ret = vfio_pci_core_iowrite16(vdev, test_mem,
> +							      val, io + off);
>  				if (ret)
>  					return ret;
>  			} else {
> -				ret = vfio_pci_ioread16(vdev, test_mem,
> -							&val, io + off);
> +				ret = vfio_pci_core_ioread16(vdev, test_mem,
> +							     &val, io + off);
>  				if (ret)
>  					return ret;
>  
> @@ -163,13 +165,13 @@ static ssize_t do_io_rw(struct vfio_pci_core_device *vdev, bool test_mem,
>  				if (copy_from_user(&val, buf, 1))
>  					return -EFAULT;
>  
> -				ret = vfio_pci_iowrite8(vdev, test_mem,
> -							val, io + off);
> +				ret = vfio_pci_core_iowrite8(vdev, test_mem,
> +							     val, io + off);
>  				if (ret)
>  					return ret;
>  			} else {
> -				ret = vfio_pci_ioread8(vdev, test_mem,
> -						       &val, io + off);
> +				ret = vfio_pci_core_ioread8(vdev, test_mem,
> +							    &val, io + off);
>  				if (ret)
>  					return ret;
>  
> @@ -364,16 +366,16 @@ static void vfio_pci_ioeventfd_do_write(struct vfio_pci_ioeventfd *ioeventfd,
>  {
>  	switch (ioeventfd->count) {
>  	case 1:
> -		vfio_pci_iowrite8(ioeventfd->vdev, test_mem,
> -				  ioeventfd->data, ioeventfd->addr);
> +		vfio_pci_core_iowrite8(ioeventfd->vdev, test_mem,
> +				       ioeventfd->data, ioeventfd->addr);
>  		break;
>  	case 2:
> -		vfio_pci_iowrite16(ioeventfd->vdev, test_mem,
> -				   ioeventfd->data, ioeventfd->addr);
> +		vfio_pci_core_iowrite16(ioeventfd->vdev, test_mem,
> +					ioeventfd->data, ioeventfd->addr);
>  		break;
>  	case 4:
> -		vfio_pci_iowrite32(ioeventfd->vdev, test_mem,
> -				   ioeventfd->data, ioeventfd->addr);
> +		vfio_pci_core_iowrite32(ioeventfd->vdev, test_mem,
> +					ioeventfd->data, ioeventfd->addr);
>  		break;
>  #ifdef iowrite64
>  	case 8:

There's a vfio_pci_iowrite64() call just below here that was missed.
Otherwise the vfio parts of the series looks ok to me.  We still need
to recruit another reviewer though.

My preferred merge approach would be that virtio maintainers take
patches 1-6 and provide a branch or tag I can merge to bring 7-9 in
through the vfio tree.  Thanks,

Alex

> diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
> index 67ac58e20e1d..85e84b92751b 100644
> --- a/include/linux/vfio_pci_core.h
> +++ b/include/linux/vfio_pci_core.h
> @@ -131,4 +131,23 @@ int vfio_pci_core_setup_barmap(struct vfio_pci_core_device *vdev, int bar);
>  pci_ers_result_t vfio_pci_core_aer_err_detected(struct pci_dev *pdev,
>  						pci_channel_state_t state);
>  
> +#define VFIO_IOWRITE_DECLATION(size) \
> +int vfio_pci_core_iowrite##size(struct vfio_pci_core_device *vdev,	\
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
> +int vfio_pci_core_ioread##size(struct vfio_pci_core_device *vdev,	\
> +			bool test_mem, u##size *val, void __iomem *io);
> +
> +VFIO_IOREAD_DECLATION(8)
> +VFIO_IOREAD_DECLATION(16)
> +VFIO_IOREAD_DECLATION(32)
> +
>  #endif /* VFIO_PCI_CORE_H */


