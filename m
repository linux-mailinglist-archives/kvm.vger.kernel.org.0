Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7514A26836A
	for <lists+kvm@lfdr.de>; Mon, 14 Sep 2020 06:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726010AbgINEUy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 00:20:54 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:27560 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725973AbgINEUy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 14 Sep 2020 00:20:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600057252;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ij0YTaF6RiYno0x8sF/D5e5z9gxhF6aamWYdiKjdyYE=;
        b=YF/bWI2bHnPwArvgwug19uz8Zmd1CC6uYr42rxk+s6oNaQvGzCXDMj9GnBVEIwWzaEjZYZ
        LvU9mZVxIbH4KupAi2rO+NHkT1t0il/vDqy5UhbO6lfjYAdn8uQBCmCwHKo0rWmmJtQjHb
        J0v6alqXCEd2OSCXXwHGOCxn3F1RloU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-352-mnW_Qw2FPCe6DtMHLxgtzg-1; Mon, 14 Sep 2020 00:20:50 -0400
X-MC-Unique: mnW_Qw2FPCe6DtMHLxgtzg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6A78F1074651;
        Mon, 14 Sep 2020 04:20:48 +0000 (UTC)
Received: from [10.72.13.25] (ovpn-13-25.pek2.redhat.com [10.72.13.25])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DAE371A837;
        Mon, 14 Sep 2020 04:20:11 +0000 (UTC)
Subject: Re: [PATCH v7 00/16] vfio: expose virtual Shared Virtual Addressing
 to VMs
To:     Liu Yi L <yi.l.liu@intel.com>, alex.williamson@redhat.com,
        eric.auger@redhat.com, baolu.lu@linux.intel.com, joro@8bytes.org
Cc:     kevin.tian@intel.com, jacob.jun.pan@linux.intel.com,
        ashok.raj@intel.com, jun.j.tian@intel.com, yi.y.sun@intel.com,
        jean-philippe@linaro.org, peterx@redhat.com, hao.wu@intel.com,
        stefanha@gmail.com, iommu@lists.linux-foundation.org,
        kvm@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
References: <1599734733-6431-1-git-send-email-yi.l.liu@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <411c81c0-f13c-37cc-6c26-cafb42b46b15@redhat.com>
Date:   Mon, 14 Sep 2020 12:20:10 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1599734733-6431-1-git-send-email-yi.l.liu@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2020/9/10 下午6:45, Liu Yi L wrote:
> Shared Virtual Addressing (SVA), a.k.a, Shared Virtual Memory (SVM) on
> Intel platforms allows address space sharing between device DMA and
> applications. SVA can reduce programming complexity and enhance security.
>
> This VFIO series is intended to expose SVA usage to VMs. i.e. Sharing
> guest application address space with passthru devices. This is called
> vSVA in this series. The whole vSVA enabling requires QEMU/VFIO/IOMMU
> changes. For IOMMU and QEMU changes, they are in separate series (listed
> in the "Related series").
>
> The high-level architecture for SVA virtualization is as below, the key
> design of vSVA support is to utilize the dual-stage IOMMU translation (
> also known as IOMMU nesting translation) capability in host IOMMU.
>
>
>      .-------------.  .---------------------------.
>      |   vIOMMU    |  | Guest process CR3, FL only|
>      |             |  '---------------------------'
>      .----------------/
>      | PASID Entry |--- PASID cache flush -
>      '-------------'                       |
>      |             |                       V
>      |             |                CR3 in GPA
>      '-------------'
> Guest
> ------| Shadow |--------------------------|--------
>        v        v                          v
> Host
>      .-------------.  .----------------------.
>      |   pIOMMU    |  | Bind FL for GVA-GPA  |
>      |             |  '----------------------'
>      .----------------/  |
>      | PASID Entry |     V (Nested xlate)
>      '----------------\.------------------------------.
>      |             ||SL for GPA-HPA, default domain|
>      |             |   '------------------------------'
>      '-------------'
> Where:
>   - FL = First level/stage one page tables
>   - SL = Second level/stage two page tables
>
> Patch Overview:
>   1. reports IOMMU nesting info to userspace ( patch 0001, 0002, 0003, 0015 , 0016)
>   2. vfio support for PASID allocation and free for VMs (patch 0004, 0005, 0007)
>   3. a fix to a revisit in intel iommu driver (patch 0006)
>   4. vfio support for binding guest page table to host (patch 0008, 0009, 0010)
>   5. vfio support for IOMMU cache invalidation from VMs (patch 0011)
>   6. vfio support for vSVA usage on IOMMU-backed mdevs (patch 0012)
>   7. expose PASID capability to VM (patch 0013)
>   8. add doc for VFIO dual stage control (patch 0014)


If it's possible, I would suggest a generic uAPI instead of a VFIO 
specific one.

Jason suggest something like /dev/sva. There will be a lot of other 
subsystems that could benefit from this (e.g vDPA).

Have you ever considered this approach?

Thanks

