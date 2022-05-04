Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB93B51A37E
	for <lists+kvm@lfdr.de>; Wed,  4 May 2022 17:15:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352083AbiEDPT2 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 4 May 2022 11:19:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352079AbiEDPTT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 11:19:19 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1220C31342
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 08:15:41 -0700 (PDT)
Received: from kwepemi500018.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4KtgPB0tdpzhYgp;
        Wed,  4 May 2022 23:15:10 +0800 (CST)
Received: from kwepemm600008.china.huawei.com (7.193.23.88) by
 kwepemi500018.china.huawei.com (7.221.188.213) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 4 May 2022 23:15:39 +0800
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 kwepemm600008.china.huawei.com (7.193.23.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 4 May 2022 23:15:37 +0800
Received: from lhreml710-chm.china.huawei.com ([169.254.81.184]) by
 lhreml710-chm.china.huawei.com ([169.254.81.184]) with mapi id
 15.01.2375.024; Wed, 4 May 2022 16:15:35 +0100
From:   Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        liulongfang <liulongfang@huawei.com>,
        Yishai Hadas <yishaih@nvidia.com>
CC:     Kevin Tian <kevin.tian@intel.com>
Subject: RE: [PATCH v2] vfio/pci: Remove vfio_device_get_from_dev()
Thread-Topic: [PATCH v2] vfio/pci: Remove vfio_device_get_from_dev()
Thread-Index: AQHYXn5Kk1+EMpPYVEmRhZ5O3cCSZa0OyfVQ
Date:   Wed, 4 May 2022 15:15:35 +0000
Message-ID: <ea998a76810f4f96943de33b01252ae9@huawei.com>
References: <0-v2-0f36bcf6ec1e+64d-vfio_get_from_dev_jgg@nvidia.com>
In-Reply-To: <0-v2-0f36bcf6ec1e+64d-vfio_get_from_dev_jgg@nvidia.com>
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Jason Gunthorpe [mailto:jgg@nvidia.com]
> Sent: 03 May 2022 00:42
> To: Alex Williamson <alex.williamson@redhat.com>; Cornelia Huck
> <cohuck@redhat.com>; kvm@vger.kernel.org; liulongfang
> <liulongfang@huawei.com>; Shameerali Kolothum Thodi
> <shameerali.kolothum.thodi@huawei.com>; Yishai Hadas
> <yishaih@nvidia.com>
> Cc: Kevin Tian <kevin.tian@intel.com>
> Subject: [PATCH v2] vfio/pci: Remove vfio_device_get_from_dev()
> 
> The last user of this function is in PCI callbacks that want to convert
> their struct pci_dev to a vfio_device. Instead of searching use the
> vfio_device available trivially through the drvdata.
> 
> When a callback in the device_driver is called, the caller must hold the
> device_lock() on dev. The purpose of the device_lock is to prevent
> remove() from being called (see __device_release_driver), and allow the
> driver to safely interact with its drvdata without races.
> 
> The PCI core correctly follows this and holds the device_lock() when
> calling error_detected (see report_error_detected) and
> sriov_configure (see sriov_numvfs_store).
> 
> Further, since the drvdata holds a positive refcount on the vfio_device
> any access of the drvdata, under the driver_lock, from a driver callback

device_lock() ? (v1 discussion says it's a typo).

> needs no further protection or refcounting.
> 
> Thus the remark in the vfio_device_get_from_dev() comment does not apply
> here, VFIO PCI drivers all call vfio_unregister_group_dev() from their
> remove callbacks under the driver lock and cannot race with the remaining
> callers.

May be we can also mention the removal of vfio_group_get_from_dev() as well
in the commit.

> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>

Thanks,
Shameer
