Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2ED8014D42A
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2020 00:57:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727207AbgA2X46 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jan 2020 18:56:58 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:31606 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727093AbgA2X46 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jan 2020 18:56:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580342217;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YWdRpM1kcQ6PLj0ocD77Ak3FkfzKXOacBKoKAVuuAfg=;
        b=SVL7viY7t8k7Ce2NHtfhkCFziGpWWiniL1kNW4i0XOFUrxThq6fnlj/W2jvuAySGD3TDFo
        c5kpGjxx44zpeKRXvIZschbKER6td/JVFGLXGOSyE7Bl68GKEcCLF8Fkh91ovfaJOy8Jb2
        zLIxd24JI2iEfSVcTrISJIYnYKyinEE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-62-6U95WgCEN6uGY4yXsZpQvw-1; Wed, 29 Jan 2020 18:56:55 -0500
X-MC-Unique: 6U95WgCEN6uGY4yXsZpQvw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0AB738017CC;
        Wed, 29 Jan 2020 23:56:54 +0000 (UTC)
Received: from w520.home (ovpn-116-28.phx2.redhat.com [10.3.116.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4546184D8B;
        Wed, 29 Jan 2020 23:56:50 +0000 (UTC)
Date:   Wed, 29 Jan 2020 16:56:49 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     eric.auger@redhat.com, kevin.tian@intel.com,
        jacob.jun.pan@linux.intel.com, joro@8bytes.org,
        ashok.raj@intel.com, jun.j.tian@intel.com, yi.y.sun@intel.com,
        jean-philippe.brucker@arm.com, peterx@redhat.com,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC v3 4/8] vfio/type1: Add
 VFIO_NESTING_GET_IOMMU_UAPI_VERSION
Message-ID: <20200129165649.43008300@w520.home>
In-Reply-To: <1580299912-86084-5-git-send-email-yi.l.liu@intel.com>
References: <1580299912-86084-1-git-send-email-yi.l.liu@intel.com>
        <1580299912-86084-5-git-send-email-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 29 Jan 2020 04:11:48 -0800
"Liu, Yi L" <yi.l.liu@intel.com> wrote:

> From: Liu Yi L <yi.l.liu@intel.com>
> 
> In Linux Kernel, the IOMMU nesting translation (a.k.a. IOMMU dual stage
> translation capability) is abstracted in uapi/iommu.h, in which the uAPIs
> like bind_gpasid/iommu_cache_invalidate/fault_report/pgreq_resp are defined.
> 
> VFIO_TYPE1_NESTING_IOMMU stands for the vfio iommu type which is backed by
> IOMMU nesting translation capability. VFIO exposes the nesting capability
> to userspace and also exposes uAPIs (will be added in later patches) to user
> space for setting up nesting translation from userspace. Thus applications
> like QEMU could support vIOMMU for pass-through devices with IOMMU nesting
> translation capability.
> 
> As VFIO expose the nesting IOMMU programming to userspace, it also needs to
> provide an API for the uapi/iommu.h version check to ensure compatibility.
> This patch reports the iommu uapi version to userspace. Applications could
> use this API to do version check before further using the nesting uAPIs.
> 
> Cc: Kevin Tian <kevin.tian@intel.com>
> CC: Jacob Pan <jacob.jun.pan@linux.intel.com>
> Cc: Alex Williamson <alex.williamson@redhat.com>
> Cc: Eric Auger <eric.auger@redhat.com>
> Cc: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
> Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> ---
>  drivers/vfio/vfio.c       |  3 +++
>  include/uapi/linux/vfio.h | 10 ++++++++++
>  2 files changed, 13 insertions(+)
> 
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index 425d60a..9087ad4 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -1170,6 +1170,9 @@ static long vfio_fops_unl_ioctl(struct file *filep,
>  	case VFIO_GET_API_VERSION:
>  		ret = VFIO_API_VERSION;
>  		break;
> +	case VFIO_NESTING_GET_IOMMU_UAPI_VERSION:
> +		ret = iommu_get_uapi_version();
> +		break;

Shouldn't the type1 backend report this?  It doesn't make much sense
that the spapr backend reports a version for something it doesn't
support.  Better yet, provide this info gratuitously in the
VFIO_IOMMU_GET_INFO ioctl return like you do with nesting in the next
patch, then it can help the user figure out if this support is present.
Thanks,

Alex

>  	case VFIO_CHECK_EXTENSION:
>  		ret = vfio_ioctl_check_extension(container, arg);
>  		break;
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index d4bf415..62113be 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -857,6 +857,16 @@ struct vfio_iommu_type1_pasid_quota {
>   */
>  #define VFIO_IOMMU_SET_PASID_QUOTA	_IO(VFIO_TYPE, VFIO_BASE + 23)
>  
> +/**
> + * VFIO_NESTING_GET_IOMMU_UAPI_VERSION - _IO(VFIO_TYPE, VFIO_BASE + 24)
> + *
> + * Report the version of the IOMMU UAPI when dual stage IOMMU is supported.
> + * In VFIO, it is needed for VFIO_TYPE1_NESTING_IOMMU.
> + * Availability: Always.
> + * Return: IOMMU UAPI version
> + */
> +#define VFIO_NESTING_GET_IOMMU_UAPI_VERSION	_IO(VFIO_TYPE, VFIO_BASE + 24)
> +
>  /* -------- Additional API for SPAPR TCE (Server POWERPC) IOMMU -------- */
>  
>  /*

