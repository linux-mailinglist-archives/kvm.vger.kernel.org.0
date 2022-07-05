Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BD0256611A
	for <lists+kvm@lfdr.de>; Tue,  5 Jul 2022 04:17:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234412AbiGECNO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Jul 2022 22:13:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230364AbiGECNL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Jul 2022 22:13:11 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1D1311C27
        for <kvm@vger.kernel.org>; Mon,  4 Jul 2022 19:13:05 -0700 (PDT)
Received: from kwepemi500016.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4LcR3M5CXRzhYv7;
        Tue,  5 Jul 2022 10:10:39 +0800 (CST)
Received: from [10.40.193.166] (10.40.193.166) by
 kwepemi500016.china.huawei.com (7.221.188.220) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 5 Jul 2022 10:13:03 +0800
Subject: Re: [PATCH rc] vfio: Move IOMMU_CAP_CACHE_COHERENCY test to after we
 know we have a group
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>, <kvm@vger.kernel.org>
References: <0-v1-e8934b490f36+f4-vfio_cap_fix_jgg@nvidia.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Joerg Roedel <jroedel@suse.de>,
        Kevin Tian <kevin.tian@intel.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>
From:   "chenxiang (M)" <chenxiang66@hisilicon.com>
Message-ID: <cf74ad89-b33d-b459-be17-faab5b29fea6@hisilicon.com>
Date:   Tue, 5 Jul 2022 10:13:02 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <0-v1-e8934b490f36+f4-vfio_cap_fix_jgg@nvidia.com>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.40.193.166]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
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

ÔÚ 2022/7/5 9:10, Jason Gunthorpe Ð´µÀ:

> The test isn't going to work if a group doesn't exist. Normally this isn't
> a problem since VFIO isn't going to create a device if there is no group,
> but the special CONFIG_VFIO_NOIOMMU behavior allows bypassing this
> prevention. The new cap test effectively forces a group and breaks this
> config option.
>
> Move the cap test to vfio_group_find_or_alloc() which is the earliest time
> we know we have a group available and thus are not running in noiommu mode.
>
> Fixes: e8ae0e140c05 ("vfio: Require that devices support DMA cache coherence")
> Reported-by "chenxiang (M)" <chenxiang66@hisilicon.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

I have tested the patch separately in iommu mode and in noiommu mode, 
and it works well, so please feel free to add:
Tested-by: Xiang Chen <chenxiang66@hisilicon.com>

> ---
>   drivers/vfio/vfio.c | 17 ++++++++++-------
>   1 file changed, 10 insertions(+), 7 deletions(-)
>
> This should fixe the issue with dpdk on noiommu, but I've left PPC out.
>
> I think the right way to fix PPC is to provide the iommu_ops for the devices
> groups it is creating. They don't have to be fully functional - eg they don't
> have to to create domains, but if the ops exist they can correctly respond to
> iommu_capable() and we don't need special code here to work around PPC being
> weird.
>
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index e43b9496464bbf..cbb693359502d9 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -552,6 +552,16 @@ static struct vfio_group *vfio_group_find_or_alloc(struct device *dev)
>   	if (!iommu_group)
>   		return ERR_PTR(-EINVAL);
>   
> +	/*
> +	 * VFIO always sets IOMMU_CACHE because we offer no way for userspace to
> +	 * restore cache coherency. It has to be checked here because it is only
> +	 * valid for cases where we are using iommu groups.
> +	 */
> +	if (!iommu_capable(dev->bus, IOMMU_CAP_CACHE_COHERENCY)) {
> +		iommu_group_put(iommu_group);
> +		return ERR_PTR(-EINVAL);
> +	}
> +
>   	group = vfio_group_get_from_iommu(iommu_group);
>   	if (!group)
>   		group = vfio_create_group(iommu_group, VFIO_IOMMU);
> @@ -604,13 +614,6 @@ static int __vfio_register_dev(struct vfio_device *device,
>   
>   int vfio_register_group_dev(struct vfio_device *device)
>   {
> -	/*
> -	 * VFIO always sets IOMMU_CACHE because we offer no way for userspace to
> -	 * restore cache coherency.
> -	 */
> -	if (!iommu_capable(device->dev->bus, IOMMU_CAP_CACHE_COHERENCY))
> -		return -EINVAL;
> -
>   	return __vfio_register_dev(device,
>   		vfio_group_find_or_alloc(device->dev));
>   }
>
> base-commit: e2475f7b57209e3c67bf856e1ce07d60d410fb40

