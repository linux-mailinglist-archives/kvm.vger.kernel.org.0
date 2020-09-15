Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCFEB26ACEC
	for <lists+kvm@lfdr.de>; Tue, 15 Sep 2020 21:04:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727936AbgIOTEL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Sep 2020 15:04:11 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:30260 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727944AbgIOTD2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Sep 2020 15:03:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600196593;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ux70NJwYpQbrHOnF/i8ecMy4axzo/jDyAkGKN/ONFYY=;
        b=EqYyfbfQbXytt6qIunOZL+CdJtsbgfRmg5DHMU6hASKsmbxxEGOS2fE0toG2l04iQYnDJ2
        UnyS5TkhsMXh1TdUaMvYCPx1HN7tqb8wApvXe81QotrYN5u5AEPFtIfW9fz5zJlXr48pqU
        p6k0rW+16zsmJKlJ9dpyivfks++knNk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-441-OGH__QN-OVG655563cWZew-1; Tue, 15 Sep 2020 15:03:07 -0400
X-MC-Unique: OGH__QN-OVG655563cWZew-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CF2CB10BBEC3;
        Tue, 15 Sep 2020 19:03:06 +0000 (UTC)
Received: from x1.home (ovpn-112-71.phx2.redhat.com [10.3.112.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 248D66CE61;
        Tue, 15 Sep 2020 19:03:02 +0000 (UTC)
Date:   Tue, 15 Sep 2020 13:03:01 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     cohuck@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfio: add a singleton check for vfio_group_pin_pages
Message-ID: <20200915130301.15d95412@x1.home>
In-Reply-To: <20200915003042.14273-1-yan.y.zhao@intel.com>
References: <20200915003042.14273-1-yan.y.zhao@intel.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 15 Sep 2020 08:30:42 +0800
Yan Zhao <yan.y.zhao@intel.com> wrote:

> vfio_pin_pages() and vfio_group_pin_pages() are used purely to mark dirty
> pages to devices with IOMMU backend as they already have all VM pages
> pinned at VM startup.

This is wrong.  The entire initial basis of mdev devices is for
non-IOMMU backed devices which provide mediation outside of the scope
of the IOMMU.  That mediation includes interpreting device DMA
programming and making use of the vfio_pin_pages() interface to
translate and pin IOVA address to HPA.  Marking pages dirty is a
secondary feature.

> when there're multiple devices in the vfio group, the dirty pages
> marked through pin_pages interface by one device is not useful as the
> other devices may access and dirty any VM pages.

I don't know of any cases where there are multiple devices in a group
that would make use of this interface, however, all devices within a
group necessarily share an IOMMU context and any one device dirtying a
page will dirty that page for all devices, so I don't see that this is
a valid statement either.

> So added a check such that only singleton IOMMU groups can pin pages
> in vfio_group_pin_pages. for mdevs, there's always only one dev in a
> vfio group.
> This is a fix to the commit below that added a singleton IOMMU group
> check in vfio_pin_pages.

None of the justification above is accurate, please try again.  Thanks,

Alex

> Fixes: 95fc87b44104 (vfio: Selective dirty page tracking if IOMMU backed
> device pins pages)
> 
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> ---
>  drivers/vfio/vfio.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index 5e6e0511b5aa..2f0fa272ebf2 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -2053,6 +2053,9 @@ int vfio_group_pin_pages(struct vfio_group *group,
>  	if (!group || !user_iova_pfn || !phys_pfn || !npage)
>  		return -EINVAL;
>  
> +	if (group->dev_counter > 1)
> +		return  -EINVAL;
> +
>  	if (npage > VFIO_PIN_PAGES_MAX_ENTRIES)
>  		return -E2BIG;
>  

