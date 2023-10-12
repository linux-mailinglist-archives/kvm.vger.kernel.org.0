Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97FB77C687D
	for <lists+kvm@lfdr.de>; Thu, 12 Oct 2023 10:54:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235478AbjJLIoz convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 12 Oct 2023 04:44:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235430AbjJLIoy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Oct 2023 04:44:54 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 859149D;
        Thu, 12 Oct 2023 01:44:50 -0700 (PDT)
Received: from lhrpeml100005.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4S5jnb2WXVz687rH;
        Thu, 12 Oct 2023 16:42:43 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 lhrpeml100005.china.huawei.com (7.191.160.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Thu, 12 Oct 2023 09:44:46 +0100
Received: from lhrpeml500005.china.huawei.com ([7.191.163.240]) by
 lhrpeml500005.china.huawei.com ([7.191.163.240]) with mapi id 15.01.2507.031;
 Thu, 12 Oct 2023 09:44:46 +0100
From:   Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To:     Brett Creeley <brett.creeley@amd.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "dan.carpenter@linaro.org" <dan.carpenter@linaro.org>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "shannon.nelson@amd.com" <shannon.nelson@amd.com>
Subject: RE: [PATCH v2 vfio 1/3] pds/vfio: Fix spinlock bad magic BUG
Thread-Topic: [PATCH v2 vfio 1/3] pds/vfio: Fix spinlock bad magic BUG
Thread-Index: AQHZ/JbkCnaV2OiQRk6iZK1jPCVjpLBF1igQ
Date:   Thu, 12 Oct 2023 08:44:46 +0000
Message-ID: <597df40289ac4ee59df04af0349874b7@huawei.com>
References: <20231011230115.35719-1-brett.creeley@amd.com>
 <20231011230115.35719-2-brett.creeley@amd.com>
In-Reply-To: <20231011230115.35719-2-brett.creeley@amd.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.227.178]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Brett Creeley [mailto:brett.creeley@amd.com]
> Sent: 12 October 2023 00:01
> To: jgg@ziepe.ca; yishaih@nvidia.com; Shameerali Kolothum Thodi
> <shameerali.kolothum.thodi@huawei.com>; kevin.tian@intel.com;
> alex.williamson@redhat.com; dan.carpenter@linaro.org
> Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> brett.creeley@amd.com; shannon.nelson@amd.com
> Subject: [PATCH v2 vfio 1/3] pds/vfio: Fix spinlock bad magic BUG
> 
> The following BUG was found when running on a kernel with
> CONFIG_DEBUG_SPINLOCK=y set:
> 
> BUG: spinlock bad magic on CPU#2, bash/2481
>  lock: 0xffff8d6052a88f50, .magic: 00000000, .owner:
> <none>/-1, .owner_cpu: 0
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x36/0x50
>  do_raw_spin_lock+0x79/0xc0
>  pds_vfio_reset+0x1d/0x60 [pds_vfio_pci]
>  pci_reset_function+0x4b/0x70
>  reset_store+0x5b/0xa0
>  kernfs_fop_write_iter+0x137/0x1d0
>  vfs_write+0x2de/0x410
>  ksys_write+0x5d/0xd0
>  do_syscall_64+0x3b/0x90
>  entry_SYSCALL_64_after_hwframe+0x6e/0xd8
> 
> As shown, the .magic: 00000000, does not match the expected value. This
> is because spin_lock_init() is never called for the reset_lock. Fix
> this by calling spin_lock_init(&pds_vfio->reset_lock) when initializing
> the device.
> 
> Signed-off-by: Brett Creeley <brett.creeley@amd.com>
> Reviewed-by: Shannon Nelson <shannon.nelson@amd.com>

Reviewed-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>

I think this needs to be fixed in HiSilicon driver as well. I will send out a 
patch.

Thanks,
Shameer

> ---
>  drivers/vfio/pci/pds/vfio_dev.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/vfio/pci/pds/vfio_dev.c b/drivers/vfio/pci/pds/vfio_dev.c
> index 649b18ee394b..c351f588fa13 100644
> --- a/drivers/vfio/pci/pds/vfio_dev.c
> +++ b/drivers/vfio/pci/pds/vfio_dev.c
> @@ -155,6 +155,8 @@ static int pds_vfio_init_device(struct vfio_device
> *vdev)
> 
>  	pds_vfio->vf_id = vf_id;
> 
> +	spin_lock_init(&pds_vfio->reset_lock);
> +
>  	vdev->migration_flags = VFIO_MIGRATION_STOP_COPY |
> VFIO_MIGRATION_P2P;
>  	vdev->mig_ops = &pds_vfio_lm_ops;
>  	vdev->log_ops = &pds_vfio_log_ops;
> --
> 2.17.1

