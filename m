Return-Path: <kvm+bounces-28652-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CE36D99ADF7
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 23:14:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6C8952846AA
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 21:14:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E13E1D1506;
	Fri, 11 Oct 2024 21:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IpL5Ypov"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BCE31D12FE
	for <kvm@vger.kernel.org>; Fri, 11 Oct 2024 21:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728681259; cv=none; b=TcU35kXuZl5HSGW19+HPBImWD/r5mmUL3kSiyuKV+DbNrja9GKby3P2LEFrY+RfjcdQ4QBkCeUocU4Fc21NWVRgioKVYXjdmuOyCzHuMr16LpysCHnstjYv+ASRc8lgoDcqKti/6W1Me8i8ibwhDrBUYRkPKZimpwxc87WEv4X0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728681259; c=relaxed/simple;
	bh=ExMoUpCDJ/R6BehmPeDOlR4R77PKPTu6pDUU6pP5rKs=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jSiGex6KtNp03NLDQxdfyzjS9RL9vSm7bN4jkpMzC6f0uWPoR6v3prJ0Vwhm4wubjTOaWevQeNogqxkP7+eiU2l5d+BmCTMNERSxwiamJkQ5atxkfLbXCEKF29Z2U8vY0qerdUAXTLJ3Q+nVgRW+WzYMFHgzRrm7mpRb9QLxe+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IpL5Ypov; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728681256;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QMUBbZRfSoQvEodUgNa2TXbxyHgaQJ7LEL/v8sBXYi4=;
	b=IpL5YpovtaBUoTJ+o0XFeGsOMOFE/4lQfESZ4jQtjMKp4see1GARVrNjoZzB14Xl29FADx
	MZj1rnSNiwsJpZc81V7ZMi6S4WUnYVBCDrPQMZXffLTGNR5cISqLJ6ql2XVGzKnQl+EnvY
	5Ja2gWM6u4buDz23BIEqN+h4v7ADm9I=
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com
 [209.85.167.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-635-56VTZWqTNtuaoTL4qdAZWA-1; Fri, 11 Oct 2024 17:14:15 -0400
X-MC-Unique: 56VTZWqTNtuaoTL4qdAZWA-1
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-3e3e680b886so213731b6e.1
        for <kvm@vger.kernel.org>; Fri, 11 Oct 2024 14:14:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728681254; x=1729286054;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QMUBbZRfSoQvEodUgNa2TXbxyHgaQJ7LEL/v8sBXYi4=;
        b=IBIWrKE4VouTRvyN4SrJB4Ghkslk5xbJ2hqKxAWymh4rb+RGBchvCNlKEsPiGHkZq4
         /wJMZN5lg/d//nX3XJ3l8KPcLg2Uux4mFO6nzFG0yiNUoBQLr1rvu9qaXMLhWRr7YPVP
         t2x/xPaXioohJnrTM8CkfSGaXU4d7PYBt9oMlmIQGxmANwYJ1LkFX59P1wQaoyNHkDDV
         0EhGfYkoj3s+yLS0PrKQUCMqZEvMn+ABCMCI+jLhH+1aOb3uryMW7893aV1IZ9FcduXv
         mBlnRb9YSjBDdXgibW0awa18r8CAo1cAkP3PRXRr1+rFwnYDFWSvTTeXHNNkUhZWeu6t
         9Nog==
X-Gm-Message-State: AOJu0Yyem7Iu8Rl/8alNmUYCR5XlcOrdcLLZK9T7f70yR5gvuzlOT/Ll
	f6jPaVkX20ukIiKUlMPEJFMcVSFGW66/K12OHLM7kdBpwzvpOTZbrTBiDSTWG9rH1hmb18BOI4R
	FmEilicjrrEFCu/xsXmAI/VrugPzzoOqtDN95+BdRNE3DmPttFw==
X-Received: by 2002:a05:6808:2223:b0:3e0:38ab:718e with SMTP id 5614622812f47-3e5c9131c45mr920650b6e.10.1728681254519;
        Fri, 11 Oct 2024 14:14:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IExBvBAUNHD/iMT7K/PYik7aFQyB3k755ifaewktdrtEizCuwl6K0a6zwI2kI4XKE/nPufnIg==
X-Received: by 2002:a05:6808:2223:b0:3e0:38ab:718e with SMTP id 5614622812f47-3e5c9131c45mr920634b6e.10.1728681254206;
        Fri, 11 Oct 2024 14:14:14 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-3e50a29d05csm809691b6e.6.2024.10.11.14.14.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Oct 2024 14:14:13 -0700 (PDT)
Date: Fri, 11 Oct 2024 15:14:10 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Zhi Wang <zhiw@nvidia.com>
Cc: <kvm@vger.kernel.org>, <linux-cxl@vger.kernel.org>,
 <kevin.tian@intel.com>, <jgg@nvidia.com>, <alison.schofield@intel.com>,
 <dan.j.williams@intel.com>, <dave.jiang@intel.com>, <dave@stgolabs.net>,
 <jonathan.cameron@huawei.com>, <ira.weiny@intel.com>,
 <vishal.l.verma@intel.com>, <alucerop@amd.com>, <acurrid@nvidia.com>,
 <cjia@nvidia.com>, <smitra@nvidia.com>, <ankita@nvidia.com>,
 <aniketa@nvidia.com>, <kwankhede@nvidia.com>, <targupta@nvidia.com>,
 <zhiwang@kernel.org>
Subject: Re: [RFC 11/13] vfio/cxl: introduce VFIO CXL device cap
Message-ID: <20241011151410.04ac0bc9.alex.williamson@redhat.com>
In-Reply-To: <20240920223446.1908673-12-zhiw@nvidia.com>
References: <20240920223446.1908673-1-zhiw@nvidia.com>
	<20240920223446.1908673-12-zhiw@nvidia.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 20 Sep 2024 15:34:44 -0700
Zhi Wang <zhiw@nvidia.com> wrote:

> The userspace needs CXL device information, e.g. HDM decoder registers
> offset to know when the VM updates the HDM decoder and re-build the
> mapping between GPA in the virtual HDM decoder base registers and the
> HPA of the CXL region created by the vfio-cxl-core when initialize the
> CXL device.
> 
> To acheive this, a new VFIO CXL device cap is required to convey those
> information to the usersapce.
> 
> Introduce a new VFIO CXL device cap to expose necessary information to
> the userspace. Initialize the cap with the information filled when the
> CXL device is being initialized. vfio-pci-core fills the CXL cap into
> the caps returned to userapce when CXL is enabled.
> 
> Signed-off-by: Zhi Wang <zhiw@nvidia.com>
> ---
>  drivers/vfio/pci/vfio_cxl_core.c | 15 +++++++++++++++
>  drivers/vfio/pci/vfio_pci_core.c | 19 ++++++++++++++++++-
>  include/linux/vfio_pci_core.h    |  1 +
>  include/uapi/linux/vfio.h        | 10 ++++++++++
>  4 files changed, 44 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/pci/vfio_cxl_core.c b/drivers/vfio/pci/vfio_cxl_core.c
> index d8b51f8792a2..cebc444b54b7 100644
> --- a/drivers/vfio/pci/vfio_cxl_core.c
> +++ b/drivers/vfio/pci/vfio_cxl_core.c
> @@ -367,6 +367,19 @@ static int setup_virt_comp_regs(struct vfio_pci_core_device *core_dev)
>  	return 0;
>  }
>  
> +static void init_vfio_cxl_cap(struct vfio_pci_core_device *core_dev)
> +{
> +	struct vfio_cxl *cxl = &core_dev->cxl;
> +
> +	cxl->cap.header.id = VFIO_DEVICE_INFO_CAP_CXL;
> +	cxl->cap.header.version = 1;
> +	cxl->cap.hdm_count = cxl->hdm_count;
> +	cxl->cap.hdm_reg_offset = cxl->hdm_reg_offset;
> +	cxl->cap.hdm_reg_size = cxl->hdm_reg_size;
> +	cxl->cap.hdm_reg_bar_index = cxl->comp_reg_bar;
> +	cxl->cap.dpa_size = cxl->dpa_size;
> +}
> +
>  int vfio_cxl_core_enable(struct vfio_pci_core_device *core_dev)
>  {
>  	struct vfio_cxl *cxl = &core_dev->cxl;
> @@ -401,6 +414,8 @@ int vfio_cxl_core_enable(struct vfio_pci_core_device *core_dev)
>  	if (ret)
>  		goto err_enable_cxl_device;
>  
> +	init_vfio_cxl_cap(core_dev);
> +
>  	flags = VFIO_REGION_INFO_FLAG_READ |
>  		VFIO_REGION_INFO_FLAG_WRITE |
>  		VFIO_REGION_INFO_FLAG_MMAP;
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index e0f23b538858..47e65e28a42b 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -963,6 +963,15 @@ static int vfio_pci_info_atomic_cap(struct vfio_pci_core_device *vdev,
>  	return vfio_info_add_capability(caps, &cap.header, sizeof(cap));
>  }
>  
> +static int vfio_pci_info_cxl_cap(struct vfio_pci_core_device *vdev,
> +				 struct vfio_info_cap *caps)
> +{
> +	struct vfio_cxl *cxl = &vdev->cxl;
> +
> +	return vfio_info_add_capability(caps, &cxl->cap.header,
> +					sizeof(cxl->cap));
> +}
> +
>  static int vfio_pci_ioctl_get_info(struct vfio_pci_core_device *vdev,
>  				   struct vfio_device_info __user *arg)
>  {
> @@ -984,9 +993,17 @@ static int vfio_pci_ioctl_get_info(struct vfio_pci_core_device *vdev,
>  	if (vdev->reset_works)
>  		info.flags |= VFIO_DEVICE_FLAGS_RESET;
>  
> -	if (vdev->has_cxl)
> +	if (vdev->has_cxl) {
>  		info.flags |= VFIO_DEVICE_FLAGS_CXL;
>  
> +		ret = vfio_pci_info_cxl_cap(vdev, &caps);
> +		if (ret) {
> +			pci_warn(vdev->pdev,
> +				 "Failed to setup CXL capabilities\n");
> +			return ret;
> +		}
> +	}
> +
>  	info.num_regions = VFIO_PCI_NUM_REGIONS + vdev->num_regions;
>  	info.num_irqs = VFIO_PCI_NUM_IRQS;
>  
> diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
> index e5646aad3eb3..d79f7a91d977 100644
> --- a/include/linux/vfio_pci_core.h
> +++ b/include/linux/vfio_pci_core.h
> @@ -80,6 +80,7 @@ struct vfio_cxl {
>  	struct resource ram_res;
>  
>  	struct vfio_cxl_region region;
> +	struct vfio_device_info_cap_cxl cap;

We should create this dynamically on request, the device info ioctl is
not a fast path.  Thanks,

Alex

>  };
>  
>  struct vfio_pci_core_device {
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index 0895183feaac..9a5972961280 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -257,6 +257,16 @@ struct vfio_device_info_cap_pci_atomic_comp {
>  	__u32 reserved;
>  };
>  
> +#define VFIO_DEVICE_INFO_CAP_CXL		6
> +struct vfio_device_info_cap_cxl {
> +	struct vfio_info_cap_header header;
> +	__u8 hdm_count;
> +	__u8 hdm_reg_bar_index;
> +	__u64 hdm_reg_size;
> +	__u64 hdm_reg_offset;
> +	__u64 dpa_size;
> +};
> +
>  /**
>   * VFIO_DEVICE_GET_REGION_INFO - _IOWR(VFIO_TYPE, VFIO_BASE + 8,
>   *				       struct vfio_region_info)


