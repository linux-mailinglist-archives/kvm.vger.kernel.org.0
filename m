Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58C52344DB0
	for <lists+kvm@lfdr.de>; Mon, 22 Mar 2021 18:47:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231751AbhCVRrC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Mar 2021 13:47:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31530 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231615AbhCVRqh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 22 Mar 2021 13:46:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616435194;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WJwiSS+T6VPqw/HeedjTiXeqD0yZ8fDdEubPYZui8ak=;
        b=U0FYD1heRbClyWdMFcItKPsf2VF6SbzJUqrpbclAXiu3W+K94Raht7XIGNigWdvCzPCh8w
        OYlfybUapTnVleoRB2/d3Z7VVztl1tqyAqlcMC9E89OMmhkWPYmdXn2RomdTAderGlVt5W
        uF/EuRJnank78vLaaWsqHpJ+zy/nmtA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-489-CsGnQE7FPTSOCUMojFYzmw-1; Mon, 22 Mar 2021 13:46:30 -0400
X-MC-Unique: CsGnQE7FPTSOCUMojFYzmw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6DA6B18C89D9;
        Mon, 22 Mar 2021 17:46:27 +0000 (UTC)
Received: from omen.home.shazbot.org (ovpn-112-120.phx2.redhat.com [10.3.112.120])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7AC7F60240;
        Mon, 22 Mar 2021 17:46:24 +0000 (UTC)
Date:   Mon, 22 Mar 2021 11:46:23 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        dri-devel@lists.freedesktop.org, Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-api@vger.kernel.org,
        Alexey Kardashevskiy <aik@ozlabs.ru>
Subject: Re: [PATCH 1/2] vfio/pci: remove vfio_pci_nvlink2
Message-ID: <20210322114623.2f929b07@omen.home.shazbot.org>
In-Reply-To: <20210322150155.797882-2-hch@lst.de>
References: <20210322150155.797882-1-hch@lst.de>
        <20210322150155.797882-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 22 Mar 2021 16:01:54 +0100
Christoph Hellwig <hch@lst.de> wrote:
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index 8ce36c1d53ca11..db7e782419d5d9 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -332,19 +332,6 @@ struct vfio_region_info_cap_type {
>  #define VFIO_REGION_SUBTYPE_INTEL_IGD_HOST_CFG	(2)
>  #define VFIO_REGION_SUBTYPE_INTEL_IGD_LPC_CFG	(3)
>  
> -/* 10de vendor PCI sub-types */
> -/*
> - * NVIDIA GPU NVlink2 RAM is coherent RAM mapped onto the host address space.
> - */
> -#define VFIO_REGION_SUBTYPE_NVIDIA_NVLINK2_RAM	(1)
> -
> -/* 1014 vendor PCI sub-types */
> -/*
> - * IBM NPU NVlink2 ATSD (Address Translation Shootdown) register of NPU
> - * to do TLB invalidation on a GPU.
> - */
> -#define VFIO_REGION_SUBTYPE_IBM_NVLINK2_ATSD	(1)
> -
>  /* sub-types for VFIO_REGION_TYPE_GFX */
>  #define VFIO_REGION_SUBTYPE_GFX_EDID            (1)
>  
> @@ -637,33 +624,6 @@ struct vfio_device_migration_info {
>   */
>  #define VFIO_REGION_INFO_CAP_MSIX_MAPPABLE	3
>  
> -/*
> - * Capability with compressed real address (aka SSA - small system address)
> - * where GPU RAM is mapped on a system bus. Used by a GPU for DMA routing
> - * and by the userspace to associate a NVLink bridge with a GPU.
> - */
> -#define VFIO_REGION_INFO_CAP_NVLINK2_SSATGT	4
> -
> -struct vfio_region_info_cap_nvlink2_ssatgt {
> -	struct vfio_info_cap_header header;
> -	__u64 tgt;
> -};
> -
> -/*
> - * Capability with an NVLink link speed. The value is read by
> - * the NVlink2 bridge driver from the bridge's "ibm,nvlink-speed"
> - * property in the device tree. The value is fixed in the hardware
> - * and failing to provide the correct value results in the link
> - * not working with no indication from the driver why.
> - */
> -#define VFIO_REGION_INFO_CAP_NVLINK2_LNKSPD	5
> -
> -struct vfio_region_info_cap_nvlink2_lnkspd {
> -	struct vfio_info_cap_header header;
> -	__u32 link_speed;
> -	__u32 __pad;
> -};
> -
>  /**
>   * VFIO_DEVICE_GET_IRQ_INFO - _IOWR(VFIO_TYPE, VFIO_BASE + 9,
>   *				    struct vfio_irq_info)

I'll leave any attempt to defend keeping this code to Alexey, but
minimally these region sub-types and capability IDs should probably be
reserved to avoid breaking whatever userspace might exist to consume
these.  Our ID space is sufficiently large that we don't need to
recycle them any time soon.  Thanks,

Alex

