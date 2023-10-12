Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 006437C68BA
	for <lists+kvm@lfdr.de>; Thu, 12 Oct 2023 11:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235340AbjJLJAR convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 12 Oct 2023 05:00:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234141AbjJLJAQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Oct 2023 05:00:16 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05D5A90;
        Thu, 12 Oct 2023 02:00:12 -0700 (PDT)
Received: from lhrpeml100003.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4S5k6857x9z6HJLt;
        Thu, 12 Oct 2023 16:57:04 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 lhrpeml100003.china.huawei.com (7.191.160.210) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Thu, 12 Oct 2023 10:00:09 +0100
Received: from lhrpeml500005.china.huawei.com ([7.191.163.240]) by
 lhrpeml500005.china.huawei.com ([7.191.163.240]) with mapi id 15.01.2507.031;
 Thu, 12 Oct 2023 10:00:09 +0100
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
Subject: RE: [PATCH v2 vfio 2/3] pds/vfio: Fix mutex lock->magic != lock
 warning
Thread-Topic: [PATCH v2 vfio 2/3] pds/vfio: Fix mutex lock->magic != lock
 warning
Thread-Index: AQHZ/JbkzhM2+SFoM0OMypRByjrUkrBF2rrw
Date:   Thu, 12 Oct 2023 09:00:09 +0000
Message-ID: <591f90f071454dcd82d8de1178241e3c@huawei.com>
References: <20231011230115.35719-1-brett.creeley@amd.com>
 <20231011230115.35719-3-brett.creeley@amd.com>
In-Reply-To: <20231011230115.35719-3-brett.creeley@amd.com>
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
> Subject: [PATCH v2 vfio 2/3] pds/vfio: Fix mutex lock->magic != lock warning
> 
> The following BUG was found when running on a kernel with
> CONFIG_DEBUG_MUTEXES=y set:
> 
> DEBUG_LOCKS_WARN_ON(lock->magic != lock)
> RIP: 0010:mutex_trylock+0x10d/0x120
> Call Trace:
>  <TASK>
>  ? __warn+0x85/0x140
>  ? mutex_trylock+0x10d/0x120
>  ? report_bug+0xfc/0x1e0
>  ? handle_bug+0x3f/0x70
>  ? exc_invalid_op+0x17/0x70
>  ? asm_exc_invalid_op+0x1a/0x20
>  ? mutex_trylock+0x10d/0x120
>  ? mutex_trylock+0x10d/0x120
>  pds_vfio_reset+0x3a/0x60 [pds_vfio_pci]
>  pci_reset_function+0x4b/0x70
>  reset_store+0x5b/0xa0
>  kernfs_fop_write_iter+0x137/0x1d0
>  vfs_write+0x2de/0x410
>  ksys_write+0x5d/0xd0
>  do_syscall_64+0x3b/0x90
>  entry_SYSCALL_64_after_hwframe+0x6e/0xd8
> 
> As shown, lock->magic != lock. This is because
> mutex_init(&pds_vfio->state_mutex) is called in the VFIO open path. So,
> if a reset is initiated before the VFIO device is opened the mutex will
> have never been initialized. Fix this by calling
> mutex_init(&pds_vfio->state_mutex) in the VFIO init path.
> 
> Also, don't destroy the mutex on close because the device may
> be re-opened, which would cause mutex to be uninitialized. Fix this by
> implementing a driver specific vfio_device_ops.release callback that
> destroys the mutex before calling vfio_pci_core_release_dev().
> 
> Signed-off-by: Brett Creeley <brett.creeley@amd.com>
> Reviewed-by: Shannon Nelson <shannon.nelson@amd.com>

Reviewed-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>

Looks like mutex destruction logic needs to be added to HiSilicon driver as well.
From a quick look mlx5 also doesn't destroy the state_mutex.

Thanks,
Shameer
 
> ---
>  drivers/vfio/pci/pds/vfio_dev.c | 15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/vfio/pci/pds/vfio_dev.c b/drivers/vfio/pci/pds/vfio_dev.c
> index c351f588fa13..306b1c25f016 100644
> --- a/drivers/vfio/pci/pds/vfio_dev.c
> +++ b/drivers/vfio/pci/pds/vfio_dev.c
> @@ -155,6 +155,7 @@ static int pds_vfio_init_device(struct vfio_device
> *vdev)
> 
>  	pds_vfio->vf_id = vf_id;
> 
> +	mutex_init(&pds_vfio->state_mutex);
>  	spin_lock_init(&pds_vfio->reset_lock);
> 
>  	vdev->migration_flags = VFIO_MIGRATION_STOP_COPY |
> VFIO_MIGRATION_P2P;
> @@ -170,6 +171,16 @@ static int pds_vfio_init_device(struct vfio_device
> *vdev)
>  	return 0;
>  }
> 
> +static void pds_vfio_release_device(struct vfio_device *vdev)
> +{
> +	struct pds_vfio_pci_device *pds_vfio =
> +		container_of(vdev, struct pds_vfio_pci_device,
> +			     vfio_coredev.vdev);
> +
> +	mutex_destroy(&pds_vfio->state_mutex);
> +	vfio_pci_core_release_dev(vdev);
> +}
> +
>  static int pds_vfio_open_device(struct vfio_device *vdev)
>  {
>  	struct pds_vfio_pci_device *pds_vfio =
> @@ -181,7 +192,6 @@ static int pds_vfio_open_device(struct vfio_device
> *vdev)
>  	if (err)
>  		return err;
> 
> -	mutex_init(&pds_vfio->state_mutex);
>  	pds_vfio->state = VFIO_DEVICE_STATE_RUNNING;
>  	pds_vfio->deferred_reset_state = VFIO_DEVICE_STATE_RUNNING;
> 
> @@ -201,14 +211,13 @@ static void pds_vfio_close_device(struct
> vfio_device *vdev)
>  	pds_vfio_put_save_file(pds_vfio);
>  	pds_vfio_dirty_disable(pds_vfio, true);
>  	mutex_unlock(&pds_vfio->state_mutex);
> -	mutex_destroy(&pds_vfio->state_mutex);
>  	vfio_pci_core_close_device(vdev);
>  }
> 
>  static const struct vfio_device_ops pds_vfio_ops = {
>  	.name = "pds-vfio",
>  	.init = pds_vfio_init_device,
> -	.release = vfio_pci_core_release_dev,
> +	.release = pds_vfio_release_device,
>  	.open_device = pds_vfio_open_device,
>  	.close_device = pds_vfio_close_device,
>  	.ioctl = vfio_pci_core_ioctl,
> --
> 2.17.1

