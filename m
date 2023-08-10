Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F9A07772ED
	for <lists+kvm@lfdr.de>; Thu, 10 Aug 2023 10:32:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234199AbjHJIcU convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 10 Aug 2023 04:32:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234196AbjHJIcU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Aug 2023 04:32:20 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B38B5E56;
        Thu, 10 Aug 2023 01:32:18 -0700 (PDT)
Received: from lhrpeml100006.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4RM0S93F6Pz6J7Xv;
        Thu, 10 Aug 2023 16:28:25 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 lhrpeml100006.china.huawei.com (7.191.160.224) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 10 Aug 2023 09:32:16 +0100
Received: from lhrpeml500005.china.huawei.com ([7.191.163.240]) by
 lhrpeml500005.china.huawei.com ([7.191.163.240]) with mapi id 15.01.2507.027;
 Thu, 10 Aug 2023 09:32:16 +0100
From:   Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To:     Brett Creeley <brett.creeley@amd.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>
CC:     "horms@kernel.org" <horms@kernel.org>,
        "shannon.nelson@amd.com" <shannon.nelson@amd.com>
Subject: RE: [PATCH v14 vfio 0/8] pds-vfio-pci driver
Thread-Topic: [PATCH v14 vfio 0/8] pds-vfio-pci driver
Thread-Index: AQHZyXHv3bTrp0qnokyw6FJ+IoQZlq/jNQAg
Date:   Thu, 10 Aug 2023 08:32:15 +0000
Message-ID: <1d01d5f4063444ecbf7a258289d0e1d6@huawei.com>
References: <20230807205755.29579-1-brett.creeley@amd.com>
In-Reply-To: <20230807205755.29579-1-brett.creeley@amd.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.227.178]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Brett Creeley [mailto:brett.creeley@amd.com]
> Sent: 07 August 2023 21:58
> To: kvm@vger.kernel.org; netdev@vger.kernel.org;
> alex.williamson@redhat.com; jgg@nvidia.com; yishaih@nvidia.com;
> Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>;
> kevin.tian@intel.com
> Cc: horms@kernel.org; brett.creeley@amd.com; shannon.nelson@amd.com
> Subject: [PATCH v14 vfio 0/8] pds-vfio-pci driver
> 
> This is a patchset for a new vendor specific VFIO driver
> (pds-vfio-pci) for use with the AMD/Pensando Distributed Services
> Card (DSC). This driver makes use of the pds_core driver.
> 
> This driver will use the pds_core device's adminq as the VFIO
> control path to the DSC. In order to make adminq calls, the VFIO
> instance makes use of functions exported by the pds_core driver.
> 
> In order to receive events from pds_core, the pds-vfio-pci driver
> registers to a private notifier. This is needed for various events
> that come from the device.
> 
> An ASCII diagram of a VFIO instance looks something like this and can
> be used with the VFIO subsystem to provide the VF device VFIO and live
> migration support.
> 
>                                .------.  .-----------------------.
>                                | QEMU |--|  VM  .-------------.  |
>                                '......'  |      |   Eth VF    |  |
>                                   |      |      .-------------.  |
>                                   |      |      |  SR-IOV VF  |
> |
>                                   |      |      '-------------'  |
>                                   |      '------------||---------'
>                                .--------------.       ||
>                                |/dev/<vfio_fd>|       ||
>                                '--------------'       ||
> Host Userspace                         |              ||
> ===================================================   ||
> Host Kernel                            |              ||
>                                   .--------.          ||
>                                   |vfio-pci|          ||
>                                   '--------'          ||
>        .------------------.           ||              ||
>        |   | exported API |<----+     ||              ||
>        |   '--------------|     |     ||              ||
>        |                  |    .--------------.       ||
>        |     pds_core     |--->| pds-vfio-pci |       ||
>        '------------------' |  '--------------'       ||
>                ||           |         ||              ||
>              09:00.0     notifier    09:00.1          ||
> == PCI ===============================================||=====
>                ||                     ||              ||
>           .----------.          .----------.          ||
>     ,-----|    PF    |----------|    VF    |-------------------,
>     |     '----------'         |'----------'         VF        |
>     |                     DSC  |                 data/control  |
>     |                          |                     path      |
>     -----------------------------------------------------------
> 
> The pds-vfio-pci driver is targeted to reside in drivers/vfio/pci/pds.
> It makes use of and introduces new files in the common include/linux/pds
> include directory.

Looks fine to me. 

For series,

Reviewed-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>

Thanks,
Shameer
