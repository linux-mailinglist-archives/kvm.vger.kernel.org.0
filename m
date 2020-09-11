Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABD042665B0
	for <lists+kvm@lfdr.de>; Fri, 11 Sep 2020 19:10:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726253AbgIKRKu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Sep 2020 13:10:50 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:21499 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726269AbgIKRJZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Sep 2020 13:09:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599844161;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IBAi79BCgUQb7x/kKKWXp+YbGm17WGXJqEsuMSZt9FU=;
        b=YBCLjIGoxtDXAb5rWkZkyZWw1ZCUmMjbJX7Lku6Dq8uM9Pt7+fOlQwFrifvfQOBcvez/Lv
        Z0r1ATeMe56Oduioe0Pyh4jiyd0hVTFR886HYGWCX7aKVQpeT/lheKHfhug3gjmTYs2vpd
        BNDjRaIyMkFlsIVE2D0lnrLn351lH/4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-359-iPkZEvIvNi2wiRD5ZAqcvA-1; Fri, 11 Sep 2020 13:09:17 -0400
X-MC-Unique: iPkZEvIvNi2wiRD5ZAqcvA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6466C10BBEDF;
        Fri, 11 Sep 2020 17:09:16 +0000 (UTC)
Received: from w520.home (ovpn-112-71.phx2.redhat.com [10.3.112.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E63045C1BD;
        Fri, 11 Sep 2020 17:09:15 +0000 (UTC)
Date:   Fri, 11 Sep 2020 11:09:15 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     cohuck@redhat.com, pmorel@linux.ibm.com, schnelle@linux.ibm.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfio iommu: Add dma limit capability
Message-ID: <20200911110915.13302afa@w520.home>
In-Reply-To: <1599842643-2553-2-git-send-email-mjrosato@linux.ibm.com>
References: <1599842643-2553-1-git-send-email-mjrosato@linux.ibm.com>
        <1599842643-2553-2-git-send-email-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 11 Sep 2020 12:44:03 -0400
Matthew Rosato <mjrosato@linux.ibm.com> wrote:

> Commit 492855939bdb ("vfio/type1: Limit DMA mappings per container")
> added the ability to limit the number of memory backed DMA mappings.
> However on s390x, when lazy mapping is in use, we use a very large
> number of concurrent mappings.  Let's provide the limitation to
> userspace via the IOMMU info chain so that userspace can take
> appropriate mitigation.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 17 +++++++++++++++++
>  include/uapi/linux/vfio.h       | 16 ++++++++++++++++
>  2 files changed, 33 insertions(+)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 5fbf0c1..573c2c9 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -2609,6 +2609,20 @@ static int vfio_iommu_migration_build_caps(struct vfio_iommu *iommu,
>  	return vfio_info_add_capability(caps, &cap_mig.header, sizeof(cap_mig));
>  }
>  
> +static int vfio_iommu_dma_limit_build_caps(struct vfio_iommu *iommu,
> +					   struct vfio_info_cap *caps)
> +{
> +	struct vfio_iommu_type1_info_dma_limit cap_dma_limit;
> +
> +	cap_dma_limit.header.id = VFIO_IOMMU_TYPE1_INFO_DMA_LIMIT;
> +	cap_dma_limit.header.version = 1;
> +
> +	cap_dma_limit.max = dma_entry_limit;


I think you want to report iommu->dma_avail, which might change the
naming and semantics of the capability a bit.  dma_entry_limit is a
writable module param, so the current value might not be relevant to
this container at the time that it's read.  When a container is opened
we set iommu->dma_avail to the current dma_entry_limit, therefore later
modifications of dma_entry_limit are only relevant to subsequent
containers.

It seems like there are additional benefits to reporting available dma
entries as well, for example on mapping failure userspace could
reevaluate, perhaps even validate usage counts between kernel and user.
Thanks,

Alex

> +
> +	return vfio_info_add_capability(caps, &cap_dma_limit.header,
> +					sizeof(cap_dma_limit));
> +}
> +
>  static int vfio_iommu_type1_get_info(struct vfio_iommu *iommu,
>  				     unsigned long arg)
>  {
> @@ -2642,6 +2656,9 @@ static int vfio_iommu_type1_get_info(struct vfio_iommu *iommu,
>  	ret = vfio_iommu_migration_build_caps(iommu, &caps);
>  
>  	if (!ret)
> +		ret = vfio_iommu_dma_limit_build_caps(iommu, &caps);
> +
> +	if (!ret)
>  		ret = vfio_iommu_iova_build_caps(iommu, &caps);
>  
>  	mutex_unlock(&iommu->lock);
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index 9204705..c91e471 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -1039,6 +1039,22 @@ struct vfio_iommu_type1_info_cap_migration {
>  	__u64	max_dirty_bitmap_size;		/* in bytes */
>  };
>  
> +/*
> + * The DMA limit capability allows to report the number of simultaneously
> + * outstanding DMA mappings are supported.
> + *
> + * The structures below define version 1 of this capability.
> + *
> + * max: specifies the maximum number of outstanding DMA mappings allowed.
> + */
> +#define VFIO_IOMMU_TYPE1_INFO_DMA_LIMIT 3
> +
> +struct vfio_iommu_type1_info_dma_limit {
> +	struct	vfio_info_cap_header header;
> +	__u32	max;
> +};
> +
> +
>  #define VFIO_IOMMU_GET_INFO _IO(VFIO_TYPE, VFIO_BASE + 12)
>  
>  /**

