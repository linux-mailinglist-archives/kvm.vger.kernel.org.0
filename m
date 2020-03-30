Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFF3A1977ED
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 11:36:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728502AbgC3Jgz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 05:36:55 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:36123 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726127AbgC3Jgz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Mar 2020 05:36:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585561013;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GsQts7KdvM7OmuNRLhUrsthOkUg/qgVxfy93Ru1gfZY=;
        b=evy2x4vEuSEzfOEfMOBk7XF0LlGg9RwTvNCG35I6npTYRAPhPaZ6QfS7xiTu8M55RWmvbq
        vBQEFdfY5KPNoZiKFA0tpVgcqz4OHMXaKLms+LMZBThs+zYCl3YbTWQzK4CvkFUP8SabPF
        boQ5wulj/gkF+fAld2GXv73tuee+HbY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-493-H-Aylf-TMzeyq1sp7BqO4w-1; Mon, 30 Mar 2020 05:36:52 -0400
X-MC-Unique: H-Aylf-TMzeyq1sp7BqO4w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4A0A6E6BAC;
        Mon, 30 Mar 2020 09:36:43 +0000 (UTC)
Received: from [10.36.112.58] (ovpn-112-58.ams2.redhat.com [10.36.112.58])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D17C9DA0FB;
        Mon, 30 Mar 2020 09:36:23 +0000 (UTC)
Subject: Re: [PATCH v2 03/22] vfio: check VFIO_TYPE1_NESTING_IOMMU support
To:     Liu Yi L <yi.l.liu@intel.com>, qemu-devel@nongnu.org,
        alex.williamson@redhat.com, peterx@redhat.com
Cc:     pbonzini@redhat.com, mst@redhat.com, david@gibson.dropbear.id.au,
        kevin.tian@intel.com, jun.j.tian@intel.com, yi.y.sun@intel.com,
        kvm@vger.kernel.org, hao.wu@intel.com, jean-philippe@linaro.org,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
References: <1585542301-84087-1-git-send-email-yi.l.liu@intel.com>
 <1585542301-84087-4-git-send-email-yi.l.liu@intel.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <2c65e531-1cc8-dc01-4b06-e7baff58addd@redhat.com>
Date:   Mon, 30 Mar 2020 11:36:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <1585542301-84087-4-git-send-email-yi.l.liu@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Yi,

On 3/30/20 6:24 AM, Liu Yi L wrote:
> VFIO needs to check VFIO_TYPE1_NESTING_IOMMU support with Kernel before
> further using it. e.g. requires to check IOMMU UAPI version.
> 
> Cc: Kevin Tian <kevin.tian@intel.com>
> Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
> Cc: Peter Xu <peterx@redhat.com>
> Cc: Eric Auger <eric.auger@redhat.com>
> Cc: Yi Sun <yi.y.sun@linux.intel.com>
> Cc: David Gibson <david@gibson.dropbear.id.au>
> Cc: Alex Williamson <alex.williamson@redhat.com>
> Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> Signed-off-by: Yi Sun <yi.y.sun@linux.intel.com>
> ---
>  hw/vfio/common.c | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/hw/vfio/common.c b/hw/vfio/common.c
> index 0b3593b..c276732 100644
> --- a/hw/vfio/common.c
> +++ b/hw/vfio/common.c
> @@ -1157,12 +1157,21 @@ static void vfio_put_address_space(VFIOAddressSpace *space)
>  static int vfio_get_iommu_type(VFIOContainer *container,
>                                 Error **errp)
>  {
> -    int iommu_types[] = { VFIO_TYPE1v2_IOMMU, VFIO_TYPE1_IOMMU,
> +    int iommu_types[] = { VFIO_TYPE1_NESTING_IOMMU,
> +                          VFIO_TYPE1v2_IOMMU, VFIO_TYPE1_IOMMU,
>                            VFIO_SPAPR_TCE_v2_IOMMU, VFIO_SPAPR_TCE_IOMMU };
> -    int i;
> +    int i, version;
>  
>      for (i = 0; i < ARRAY_SIZE(iommu_types); i++) {
>          if (ioctl(container->fd, VFIO_CHECK_EXTENSION, iommu_types[i])) {
> +            if (iommu_types[i] == VFIO_TYPE1_NESTING_IOMMU) {
> +                version = ioctl(container->fd, VFIO_CHECK_EXTENSION,
> +                                VFIO_NESTING_IOMMU_UAPI);
> +                if (version < IOMMU_UAPI_VERSION) {
> +                    info_report("IOMMU UAPI incompatible for nesting");
> +                    continue;
> +                }
> +            }
This means that by default VFIO_TYPE1_NESTING_IOMMU wwould be chosen. I
don't think this what we want. On ARM this would mean that for a
standard VFIO assignment without vIOMMU, SL will be used instead of FL.
This may not be harmless.

For instance, in "[RFC v6 09/24] vfio: Force nested if iommu requires
it", I use nested only if I detect we have a vSMMU. Otherwise I keep the
legacy VFIO_TYPE1v2_IOMMU.

Thanks

Eric
>              return iommu_types[i];
>          }
>      }
> @@ -1278,6 +1287,7 @@ static int vfio_connect_container(VFIOGroup *group, AddressSpace *as,
>      }
>  
>      switch (container->iommu_type) {
> +    case VFIO_TYPE1_NESTING_IOMMU:
>      case VFIO_TYPE1v2_IOMMU:
>      case VFIO_TYPE1_IOMMU:
>      {
> 

