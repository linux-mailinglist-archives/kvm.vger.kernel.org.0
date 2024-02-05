Return-Path: <kvm+bounces-8053-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B6D1E84A96C
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 23:38:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DB7AA1C26A89
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 22:38:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12C444F8BC;
	Mon,  5 Feb 2024 22:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="II1FSL1u"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B041E4F5F7
	for <kvm@vger.kernel.org>; Mon,  5 Feb 2024 22:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707172592; cv=none; b=YCgajJfmFHhlSjCak4WMcDaeTGgyvirXYdywvnHF1/WhBQVopbUAynEbeQgB0YaHWvHanI97D+9USCFQTOH2M//UP+m029V9d6E2GJw3vagKh/jFiBPb7IoMzluQC5C22qHBGlLGX3D7kvYdRXVTZzX+j+6CvEgcGCkoKR91/4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707172592; c=relaxed/simple;
	bh=EqQ9MenzjCrFTlHTtt0bcFYKQybhQjUuz9ueBRPlcMU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EcB9vmnFnhIlRqXzPe4WjojU9vR5U8HwrRS+d/7LuCFNxm3ti5nG3/SnwS1LHRmDl39+nkRk0+Vtdii4xph7RMI5w6lcKuTWCRkyl4PZw5j2uPLkj1EXs/RRObsIRCeY6kuY3AiThlqT+CkkmsoA8uGf9pAk4aPBZkD26qtIKXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=II1FSL1u; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707172586;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=l5+sRNSSKmOzqMPOlpF55UvsCPipUMWShM7Hzevo2EA=;
	b=II1FSL1usRNiF8Y5ILpwZTqKdtgPprEV1M9OpZhK1ZVnhrZh4YeXiEJ6j3AMm/UipH0p2m
	f9PV1NvGzHtppcVYAecrT6ID0U4eFuwyfEdfyUZbh39e3RlonTsRDpOqBF7Rnie55PHiKK
	Jq2Jah8Mg4T2rrQIdWSvlVaq8awnC/s=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-44-o0w6GakSMWmgziyQ_mJSpA-1; Mon, 05 Feb 2024 17:36:24 -0500
X-MC-Unique: o0w6GakSMWmgziyQ_mJSpA-1
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-7bec4b24a34so471300939f.3
        for <kvm@vger.kernel.org>; Mon, 05 Feb 2024 14:36:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707172582; x=1707777382;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l5+sRNSSKmOzqMPOlpF55UvsCPipUMWShM7Hzevo2EA=;
        b=iy9C2EQAEecJu3oZGG89dwiUB3PWI4KTf62KTkokqrQzj4u9nCVsqLO7+Vxdfmme+x
         VIOeli7gYfP3N/R9zgAG28N3Rpyarl7R9epj7KGIR2nLGV5Zhm0BiOu9o8gMXeOHWzfQ
         Y3LSVk8dyr5sov2XUuWHOnL6t6SmmsAfDMVw5MbjR08xAavzbVwnisTrp6KE6fwYoQ00
         73d8ZbP0UUMz/pIQR4z6De8qUBQQKQPjVsZzmDcxXbYvGq/s9xKxpAnIAyuZf7gFBuhR
         BdbNKF/UFzT1eHwnVN0C/Chd9k+BotZGQSn6xwC6JbrrJJE6LUQA7YWSMSLp1N+Z1c87
         AwZw==
X-Gm-Message-State: AOJu0YwZfYCq0GlAWvx5+1R2lzXVhyGBh/nvzm8S09J2bx6UHUqqtKCg
	AbJtFv0ClxZ97BbnVc7O4u47Q0xwtRDj4+aP+8Fc4rtNxCnEebVUkz4zoRalrC2p6TNY4vW5U9Q
	DewI1bXeg1P21PaFkfwlIzaoowTeLcmEpOzidcdmjBOJ3Ev+0Jw==
X-Received: by 2002:a5d:9ed5:0:b0:7c3:eda5:f418 with SMTP id a21-20020a5d9ed5000000b007c3eda5f418mr344368ioe.14.1707172582316;
        Mon, 05 Feb 2024 14:36:22 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE5U6k02BKkprA4o5OQRn+FJZMOQRMF0m1ybF8f+k4uAvd6hCGcrIjSdFZFC9usmZJWumiCCw==
X-Received: by 2002:a5d:9ed5:0:b0:7c3:eda5:f418 with SMTP id a21-20020a5d9ed5000000b007c3eda5f418mr344350ioe.14.1707172581994;
        Mon, 05 Feb 2024 14:36:21 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCXGvJ2rExnLiSMqoPJCwTunOmYd+ODfGHJNEKxV2xhiAP3Rj0ZWrTgIC0Vxq+hjhi6+dqSlFllpvMlFAehMa+dHTANDCY7RR7b6pz19AXvxwJKuBxWGM2A9eOW1GL8EhGqKk8MO5dCXmVdWB4gQsUKk57V3aYCg6PPfCdEEPbQy689ftwI8CuhvcwAuFRxg5ccnLfjvYzd3vmVBDRKs1I+txlkQtU6SnNQpEFX/mAjuoywyChrwRzx7ew7biFU1I0cN4OScrqJhoIl7V1GritLLoAQQAmEofTQbvjWXeeYinnIAawGLgZ6LMlE4hJB5deztemhV8A==
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 25-20020a0566380a5900b00471374f17a3sm190892jap.136.2024.02.05.14.36.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Feb 2024 14:36:20 -0800 (PST)
Date: Mon, 5 Feb 2024 15:35:42 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: jgg@nvidia.com, yishaih@nvidia.com,
 shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
 kvm@vger.kernel.org, dave.jiang@intel.com, ashok.raj@intel.com,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH 15/17] vfio/pci: Let enable and disable of interrupt
 types use same signature
Message-ID: <20240205153542.0883e2ff.alex.williamson@redhat.com>
In-Reply-To: <bf87e46c249941ebbfacb20ee9ff92e8efd2a595.1706849424.git.reinette.chatre@intel.com>
References: <cover.1706849424.git.reinette.chatre@intel.com>
	<bf87e46c249941ebbfacb20ee9ff92e8efd2a595.1706849424.git.reinette.chatre@intel.com>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.38; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu,  1 Feb 2024 20:57:09 -0800
Reinette Chatre <reinette.chatre@intel.com> wrote:

> vfio_pci_set_intx_trigger() and vfio_pci_set_msi_trigger() have
> flows that can be shared.
> 
> For INTx, MSI, and MSI-X interrupt management to share the
> same enable/disable flow the interrupt specific enable and
> disable functions should have the same signatures.
> 
> Let vfio_intx_enable() and vfio_msi_enable() use the same
> parameters by passing "start" and "count" to these functions
> instead of letting the (what will eventually be) common code
> interpret these values.
> 
> Providing "start" and "count" to vfio_intx_enable()
> enables the INTx specific check of these parameters to move into
> the INTx specific vfio_intx_enable(). Similarly, providing "start"
> and "count" to vfio_msi_enable() enables the MSI/MSI-X specific
> code to initialize number of vectors needed.
> 
> The shared MSI/MSI-X code needs the interrupt index. Provide
> the interrupt index (clearly marked as unused) to the INTx code
> to use the same signatures.
> 
> With interrupt type specific code using the same parameters it
> is possible to have common code that calls the enable/disable
> code for different interrupt types.
> 
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> ---
>  drivers/vfio/pci/vfio_pci_intrs.c | 27 ++++++++++++++++++---------
>  1 file changed, 18 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
> index 37065623d286..9217fea3f636 100644
> --- a/drivers/vfio/pci/vfio_pci_intrs.c
> +++ b/drivers/vfio/pci/vfio_pci_intrs.c
> @@ -257,13 +257,18 @@ static irqreturn_t vfio_intx_handler(int irq, void *dev_id)
>  	return ret;
>  }
>  
> -static int vfio_intx_enable(struct vfio_pci_core_device *vdev)
> +static int vfio_intx_enable(struct vfio_pci_core_device *vdev,
> +			    unsigned int start, unsigned int count,
> +			    unsigned int __always_unused index)
>  {
>  	struct vfio_pci_irq_ctx *ctx;
>  
>  	if (!is_irq_none(vdev))
>  		return -EINVAL;
>  
> +	if (start != 0 || count != 1)
> +		return -EINVAL;
> +
>  	if (!vdev->pdev->irq)
>  		return -ENODEV;
>  
> @@ -332,7 +337,8 @@ static char *vfio_intx_device_name(struct vfio_pci_core_device *vdev,
>  	return kasprintf(GFP_KERNEL_ACCOUNT, "vfio-intx(%s)", pci_name(pdev));
>  }
>  
> -static void vfio_intx_disable(struct vfio_pci_core_device *vdev)
> +static void vfio_intx_disable(struct vfio_pci_core_device *vdev,
> +			      unsigned int __always_unused index)
>  {
>  	struct vfio_pci_irq_ctx *ctx;
>  
> @@ -358,17 +364,20 @@ static irqreturn_t vfio_msihandler(int irq, void *arg)
>  	return IRQ_HANDLED;
>  }
>  
> -static int vfio_msi_enable(struct vfio_pci_core_device *vdev, int nvec,
> +static int vfio_msi_enable(struct vfio_pci_core_device *vdev,
> +			   unsigned int start, unsigned int count,
>  			   unsigned int index)
>  {
>  	struct pci_dev *pdev = vdev->pdev;
>  	unsigned int flag;
> -	int ret;
> +	int ret, nvec;
>  	u16 cmd;
>  
>  	if (!is_irq_none(vdev))
>  		return -EINVAL;
>  
> +	nvec = start + count;
> +
>  	flag = (index == VFIO_PCI_MSIX_IRQ_INDEX) ? PCI_IRQ_MSIX : PCI_IRQ_MSI;
>  
>  	/* return the number of supported vectors if we can't get all: */
> @@ -701,11 +710,11 @@ static int vfio_pci_set_intx_trigger(struct vfio_pci_core_device *vdev,
>  	unsigned int i;
>  
>  	if (is_intx(vdev) && !count && (flags & VFIO_IRQ_SET_DATA_NONE)) {
> -		vfio_intx_disable(vdev);
> +		vfio_intx_disable(vdev, index);
>  		return 0;
>  	}
>  
> -	if (!(is_intx(vdev) || is_irq_none(vdev)) || start != 0 || count != 1)
> +	if (!(is_intx(vdev) || is_irq_none(vdev)))
>  		return -EINVAL;
>  
>  	if (flags & VFIO_IRQ_SET_DATA_EVENTFD) {
> @@ -715,13 +724,13 @@ static int vfio_pci_set_intx_trigger(struct vfio_pci_core_device *vdev,
>  		if (is_intx(vdev))
>  			return vfio_irq_set_block(vdev, start, count, fds, index);
>  
> -		ret = vfio_intx_enable(vdev);
> +		ret = vfio_intx_enable(vdev, start, count, index);

Please trace what happens when a user calls SET_IRQS to setup a trigger
eventfd with start = 0, count = 1, followed by any other combination of
start and count values once is_intx() is true.  vfio_intx_enable()
cannot be the only place we bounds check the user, all of the INTx
callbacks should be an error or nop if vector != 0.  Thanks,

Alex

>  		if (ret)
>  			return ret;
>  
>  		ret = vfio_irq_set_block(vdev, start, count, fds, index);
>  		if (ret)
> -			vfio_intx_disable(vdev);
> +			vfio_intx_disable(vdev, index);
>  
>  		return ret;
>  	}
> @@ -771,7 +780,7 @@ static int vfio_pci_set_msi_trigger(struct vfio_pci_core_device *vdev,
>  			return vfio_irq_set_block(vdev, start, count,
>  						  fds, index);
>  
> -		ret = vfio_msi_enable(vdev, start + count, index);
> +		ret = vfio_msi_enable(vdev, start, count, index);
>  		if (ret)
>  			return ret;
>  


