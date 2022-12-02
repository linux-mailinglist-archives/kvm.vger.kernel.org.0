Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D81864037C
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 10:39:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233039AbiLBJjK convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 2 Dec 2022 04:39:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232577AbiLBJjB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 04:39:01 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54E46B7DCB
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 01:38:58 -0800 (PST)
Received: from fraeml711-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4NNnql0wg2z6HJNr;
        Fri,  2 Dec 2022 17:35:47 +0800 (CST)
Received: from lhrpeml100004.china.huawei.com (7.191.162.219) by
 fraeml711-chm.china.huawei.com (10.206.15.60) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 2 Dec 2022 10:38:55 +0100
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 lhrpeml100004.china.huawei.com (7.191.162.219) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Fri, 2 Dec 2022 09:38:55 +0000
Received: from lhrpeml500005.china.huawei.com ([7.191.163.240]) by
 lhrpeml500005.china.huawei.com ([7.191.163.240]) with mapi id 15.01.2375.034;
 Fri, 2 Dec 2022 09:38:55 +0000
From:   Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To:     Yishai Hadas <yishaih@nvidia.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>,
        "joao.m.martins@oracle.com" <joao.m.martins@oracle.com>,
        "leonro@nvidia.com" <leonro@nvidia.com>,
        "shayd@nvidia.com" <shayd@nvidia.com>,
        "maorg@nvidia.com" <maorg@nvidia.com>,
        "avihaih@nvidia.com" <avihaih@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>
Subject: RE: [PATCH V2 vfio 02/14] vfio: Extend the device migration protocol
 with PRE_COPY
Thread-Topic: [PATCH V2 vfio 02/14] vfio: Extend the device migration protocol
 with PRE_COPY
Thread-Index: AQHZBZoJXXyoA82qikWEEG1TNybH/65aVWHg
Date:   Fri, 2 Dec 2022 09:38:55 +0000
Message-ID: <90968e5f85a64bc68bb3d140fd7a4045@huawei.com>
References: <20221201152931.47913-1-yishaih@nvidia.com>
 <20221201152931.47913-3-yishaih@nvidia.com>
In-Reply-To: <20221201152931.47913-3-yishaih@nvidia.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.126.168.102]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Yishai Hadas [mailto:yishaih@nvidia.com]
> Sent: 01 December 2022 15:29
> To: alex.williamson@redhat.com; jgg@nvidia.com
> Cc: kvm@vger.kernel.org; kevin.tian@intel.com; joao.m.martins@oracle.com;
> leonro@nvidia.com; shayd@nvidia.com; yishaih@nvidia.com;
> maorg@nvidia.com; avihaih@nvidia.com; cohuck@redhat.com
> Subject: [PATCH V2 vfio 02/14] vfio: Extend the device migration protocol
> with PRE_COPY

[...]
 
> +/**
> + * VFIO_MIG_GET_PRECOPY_INFO - _IO(VFIO_TYPE, VFIO_BASE + 21)
> + *
> + * This ioctl is used on the migration data FD in the precopy phase of the
> + * migration data transfer. It returns an estimate of the current data sizes
> + * remaining to be transferred. It allows the user to judge when it is
> + * appropriate to leave PRE_COPY for STOP_COPY.
> + *
> + * This ioctl is valid only in PRE_COPY states and kernel driver should
> + * return -EINVAL from any other migration state.
> + *
> + * The vfio_precopy_info data structure returned by this ioctl provides
> + * estimates of data available from the device during the PRE_COPY states.
> + * This estimate is split into two categories, initial_bytes and
> + * dirty_bytes.
> + *
> + * The initial_bytes field indicates the amount of initial precopy
> + * data available from the device. This field should have a non-zero initial
> + * value and decrease as migration data is read from the device.
> + * It is recommended to leave PRE_COPY for STOP_COPY only after this field
> + * reaches zero. Leaving PRE_COPY earlier might make things slower.
> + *
> + * The dirty_bytes field tracks device state changes relative to data
> + * previously retrieved.  This field starts at zero and may increase as
> + * the internal device state is modified or decrease as that modified
> + * state is read from the device.
> + *
> + * Userspace may use the combination of these fields to estimate the
> + * potential data size available during the PRE_COPY phases, as well as
> + * trends relative to the rate the device is dirtying its internal
> + * state, but these fields are not required to have any bearing relative
> + * to the data size available during the STOP_COPY phase.
> + *
> + * Drivers have a lot of flexibility in when and what they transfer during the
> + * PRE_COPY phase, and how they report this from
> VFIO_MIG_GET_PRECOPY_INFO.
> + *
> + * During pre-copy the migration data FD has a temporary "end of stream"
> that is
> + * reached when both initial_bytes and dirty_byte are zero. For instance,
> this
> + * may indicate that the device is idle and not currently dirtying any internal
> + * state. When read() is done on this temporary end of stream the kernel
> driver
> + * should return ENOMSG from read(). Userspace can wait for more data
> (which may
> + * never come) by using poll.
> + *
> + * Once in STOP_COPY the migration data FD has a permanent end of
> stream
> + * signaled in the usual way by read() always returning 0 and poll always
> + * returning readable. ENOMSG may not be returned in STOP_COPY.
> Support
> + * for this ioctl is optional.

Isn't mandatory if the driver claims support for VFIO_MIGRATION_PRE_COPY?

Other than that looks fine to me.

Reviewed-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>

