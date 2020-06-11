Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CC2B1F6DFD
	for <lists+kvm@lfdr.de>; Thu, 11 Jun 2020 21:30:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbgFKTal (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jun 2020 15:30:41 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:29852 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725869AbgFKTal (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 11 Jun 2020 15:30:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591903839;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xDFPgR1jsIqQEJ39RAb5AMUxAVBLVh8eDmFbfuZWBzQ=;
        b=frPbEsADwr4lWWi341I9bVmt50cYnei+k2f5ek50lXwY15HDO63chWGek+oQDaRPJbBuvI
        QGncyeOOG9xOwAPO2ZXcFDzgz9Dk2pvZmVOxyz716zp6NLSPIwEmxPHAApcj4j9B5FvEHB
        xU+RIdofUREkvIDwFgW0roA8b7I0I6c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-50-WayPYoGWNL2nL7edCea_Fw-1; Thu, 11 Jun 2020 15:30:26 -0400
X-MC-Unique: WayPYoGWNL2nL7edCea_Fw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BB11C19200C0;
        Thu, 11 Jun 2020 19:30:24 +0000 (UTC)
Received: from x1.home (ovpn-112-195.phx2.redhat.com [10.3.112.195])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7B79E5D9DC;
        Thu, 11 Jun 2020 19:30:15 +0000 (UTC)
Date:   Thu, 11 Jun 2020 13:30:15 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Liu Yi L <yi.l.liu@intel.com>
Cc:     eric.auger@redhat.com, baolu.lu@linux.intel.com, joro@8bytes.org,
        kevin.tian@intel.com, jacob.jun.pan@linux.intel.com,
        ashok.raj@intel.com, jun.j.tian@intel.com, yi.y.sun@intel.com,
        jean-philippe@linaro.org, peterx@redhat.com, hao.wu@intel.com,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 02/15] iommu: Report domain nesting info
Message-ID: <20200611133015.1418097f@x1.home>
In-Reply-To: <1591877734-66527-3-git-send-email-yi.l.liu@intel.com>
References: <1591877734-66527-1-git-send-email-yi.l.liu@intel.com>
        <1591877734-66527-3-git-send-email-yi.l.liu@intel.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 11 Jun 2020 05:15:21 -0700
Liu Yi L <yi.l.liu@intel.com> wrote:

> IOMMUs that support nesting translation needs report the capability info
> to userspace, e.g. the format of first level/stage paging structures.
> 
> Cc: Kevin Tian <kevin.tian@intel.com>
> CC: Jacob Pan <jacob.jun.pan@linux.intel.com>
> Cc: Alex Williamson <alex.williamson@redhat.com>
> Cc: Eric Auger <eric.auger@redhat.com>
> Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Lu Baolu <baolu.lu@linux.intel.com>
> Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> ---
> @Jean, Eric: as nesting was introduced for ARM, but looks like no actual
> user of it. right? So I'm wondering if we can reuse DOMAIN_ATTR_NESTING
> to retrieve nesting info? how about your opinions?
> 
>  include/linux/iommu.h      |  1 +
>  include/uapi/linux/iommu.h | 34 ++++++++++++++++++++++++++++++++++
>  2 files changed, 35 insertions(+)
> 
> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> index 78a26ae..f6e4b49 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -126,6 +126,7 @@ enum iommu_attr {
>  	DOMAIN_ATTR_FSL_PAMUV1,
>  	DOMAIN_ATTR_NESTING,	/* two stages of translation */
>  	DOMAIN_ATTR_DMA_USE_FLUSH_QUEUE,
> +	DOMAIN_ATTR_NESTING_INFO,
>  	DOMAIN_ATTR_MAX,
>  };
>  
> diff --git a/include/uapi/linux/iommu.h b/include/uapi/linux/iommu.h
> index 303f148..02eac73 100644
> --- a/include/uapi/linux/iommu.h
> +++ b/include/uapi/linux/iommu.h
> @@ -332,4 +332,38 @@ struct iommu_gpasid_bind_data {
>  	};
>  };
>  
> +struct iommu_nesting_info {
> +	__u32	size;
> +	__u32	format;
> +	__u32	features;
> +#define IOMMU_NESTING_FEAT_SYSWIDE_PASID	(1 << 0)
> +#define IOMMU_NESTING_FEAT_BIND_PGTBL		(1 << 1)
> +#define IOMMU_NESTING_FEAT_CACHE_INVLD		(1 << 2)
> +	__u32	flags;
> +	__u8	data[];
> +};
> +
> +/*
> + * @flags:	VT-d specific flags. Currently reserved for future
> + *		extension.
> + * @addr_width:	The output addr width of first level/stage translation
> + * @pasid_bits:	Maximum supported PASID bits, 0 represents no PASID
> + *		support.
> + * @cap_reg:	Describe basic capabilities as defined in VT-d capability
> + *		register.
> + * @cap_mask:	Mark valid capability bits in @cap_reg.
> + * @ecap_reg:	Describe the extended capabilities as defined in VT-d
> + *		extended capability register.
> + * @ecap_mask:	Mark the valid capability bits in @ecap_reg.

Please explain this a little further, why do we need to tell userspace
about cap/ecap register bits that aren't valid through this interface?
Thanks,

Alex


> + */
> +struct iommu_nesting_info_vtd {
> +	__u32	flags;
> +	__u16	addr_width;
> +	__u16	pasid_bits;
> +	__u64	cap_reg;
> +	__u64	cap_mask;
> +	__u64	ecap_reg;
> +	__u64	ecap_mask;
> +};
> +
>  #endif /* _UAPI_IOMMU_H */

