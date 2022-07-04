Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCC765656F1
	for <lists+kvm@lfdr.de>; Mon,  4 Jul 2022 15:22:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232665AbiGDNW4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Jul 2022 09:22:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232717AbiGDNVz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Jul 2022 09:21:55 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6E54C70
        for <kvm@vger.kernel.org>; Mon,  4 Jul 2022 06:21:53 -0700 (PDT)
Received: from kwepemi500016.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Lc5xz61v9zkWpk;
        Mon,  4 Jul 2022 21:19:51 +0800 (CST)
Received: from [10.40.193.166] (10.40.193.166) by
 kwepemi500016.china.huawei.com (7.221.188.220) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 4 Jul 2022 21:21:50 +0800
Subject: Re: [PATCH v3 4/4] vfio: Require that devices support DMA cache
 coherence
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        <iommu@lists.linux-foundation.org>, Joerg Roedel <joro@8bytes.org>,
        <kvm@vger.kernel.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>
References: <4-v3-2cf356649677+a32-intel_no_snoop_jgg@nvidia.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Christoph Hellwig <hch@lst.de>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Robin Murphy <robin.murphy@arm.com>
From:   "chenxiang (M)" <chenxiang66@hisilicon.com>
Message-ID: <40454b70-11e1-f9a1-6c26-27e7340f2109@hisilicon.com>
Date:   Mon, 4 Jul 2022 21:21:26 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <4-v3-2cf356649677+a32-intel_no_snoop_jgg@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.40.193.166]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemi500016.china.huawei.com (7.221.188.220)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

We encounter a issue with the patch: our platform is ARM64, and we run 
DPDK with smmu disable on VM (without iommu=smmuv3 etc),

so we use noiommu mode with enable_unsafe_noiommu_mode=1 to passthrough 
the device to VM with following steps (those steps are on VM) :

insmod vfio.ko enable_unsafe_noiommu_mode=1
insmod vfio_virqfd.ko
insmod vfio-pci-core.ko
insmdo vfio-pci.ko
insmod vfio_iommu_type1.ko

echo vfio-pci > /sys/bus/pci/devices/0000:00:02.0/driver_override
echo 0000:00:02.0 > /sys/bus/pci/drivers_probe ------------------ failed

I find that vfio-pci device is not probed because of the additional 
check. It works well without this patch.

Do we need to skip the check if enable_unsafe_noiommu_mode=1?

Best regards,

Xiang Chen


在 2022/4/11 23:16, Jason Gunthorpe 写道:
> IOMMU_CACHE means that normal DMAs do not require any additional coherency
> mechanism and is the basic uAPI that VFIO exposes to userspace. For
> instance VFIO applications like DPDK will not work if additional coherency
> operations are required.
>
> Therefore check IOMMU_CAP_CACHE_COHERENCY like vdpa & usnic do before
> allowing an IOMMU backed VFIO device to be created.
>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Acked-by: Alex Williamson <alex.williamson@redhat.com>
> Acked-by: Robin Murphy <robin.murphy@arm.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>   drivers/vfio/vfio.c | 7 +++++++
>   1 file changed, 7 insertions(+)
>
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index a4555014bd1e72..9edad767cfdad3 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -815,6 +815,13 @@ static int __vfio_register_dev(struct vfio_device *device,
>   
>   int vfio_register_group_dev(struct vfio_device *device)
>   {
> +	/*
> +	 * VFIO always sets IOMMU_CACHE because we offer no way for userspace to
> +	 * restore cache coherency.
> +	 */
> +	if (!iommu_capable(device->dev->bus, IOMMU_CAP_CACHE_COHERENCY))
> +		return -EINVAL;
> +
>   	return __vfio_register_dev(device,
>   		vfio_group_find_or_alloc(device->dev));
>   }

