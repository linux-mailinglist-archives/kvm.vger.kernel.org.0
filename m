Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22C9930A6BB
	for <lists+kvm@lfdr.de>; Mon,  1 Feb 2021 12:43:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229502AbhBALnn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 06:43:43 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37488 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229481AbhBALnm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Feb 2021 06:43:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612179735;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bajKGz05uWXz+8X8x9OUV6BiE9ISgVd3jUlsfuSAB6Y=;
        b=eknoSvL9Un1ayApfO6cT3i7eTpPivm+pY5WyomNerPakM6z21tnsG7RCS++Ph7EJ/2swGO
        0foZOngRud8B2k1JPByX3cnjbyP8D1GF2PsI4lXditfU0apMdpM1mnWtn7jfTs+bCQ12AR
        bdG6+834u/UhQEcAfR+K6L4lg4OGdYQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-393-UOk2btG-NJm9zdR5N3ZWmw-1; Mon, 01 Feb 2021 06:42:14 -0500
X-MC-Unique: UOk2btG-NJm9zdR5N3ZWmw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D7AF1801817;
        Mon,  1 Feb 2021 11:42:12 +0000 (UTC)
Received: from gondolin (ovpn-113-126.ams2.redhat.com [10.36.113.126])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DA3AA60CDE;
        Mon,  1 Feb 2021 11:42:08 +0000 (UTC)
Date:   Mon, 1 Feb 2021 12:42:06 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Steve Sistare <steven.sistare@oracle.com>
Cc:     kvm@vger.kernel.org, Alex Williamson <alex.williamson@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>
Subject: Re: [PATCH V3 1/9] vfio: option to unmap all
Message-ID: <20210201124206.49d3c71b.cohuck@redhat.com>
In-Reply-To: <1611939252-7240-2-git-send-email-steven.sistare@oracle.com>
References: <1611939252-7240-1-git-send-email-steven.sistare@oracle.com>
        <1611939252-7240-2-git-send-email-steven.sistare@oracle.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 29 Jan 2021 08:54:04 -0800
Steve Sistare <steven.sistare@oracle.com> wrote:

> For the UNMAP_DMA ioctl, delete all mappings if VFIO_DMA_UNMAP_FLAG_ALL
> is set.  Define the corresponding VFIO_UNMAP_ALL extension.
> 
> Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
> ---
>  include/uapi/linux/vfio.h | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index 9204705..55578b6 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -46,6 +46,9 @@
>   */
>  #define VFIO_NOIOMMU_IOMMU		8
>  
> +/* Supports VFIO_DMA_UNMAP_FLAG_ALL */
> +#define VFIO_UNMAP_ALL			9
> +
>  /*
>   * The IOCTL interface is designed for extensibility by embedding the
>   * structure length (argsz) and flags into structures passed between
> @@ -1074,6 +1077,7 @@ struct vfio_bitmap {
>   * field.  No guarantee is made to the user that arbitrary unmaps of iova
>   * or size different from those used in the original mapping call will
>   * succeed.
> + *
>   * VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP should be set to get the dirty bitmap
>   * before unmapping IO virtual addresses. When this flag is set, the user must
>   * provide a struct vfio_bitmap in data[]. User must provide zero-allocated
> @@ -1083,11 +1087,15 @@ struct vfio_bitmap {
>   * indicates that the page at that offset from iova is dirty. A Bitmap of the
>   * pages in the range of unmapped size is returned in the user-provided
>   * vfio_bitmap.data.
> + *
> + * If flags & VFIO_DMA_UNMAP_FLAG_ALL, unmap all addresses.  iova and size
> + * must be 0.  This may not be combined with the get-dirty-bitmap flag.

wording nit: s/may not/cannot/

Or maybe

"VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP and VFIO_DMA_UNMAP_FLAG_ALL are
mutually exclusive."

?

>   */
>  struct vfio_iommu_type1_dma_unmap {
>  	__u32	argsz;
>  	__u32	flags;
>  #define VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP (1 << 0)
> +#define VFIO_DMA_UNMAP_FLAG_ALL		     (1 << 1)
>  	__u64	iova;				/* IO virtual address */
>  	__u64	size;				/* Size of mapping (bytes) */
>  	__u8    data[];

