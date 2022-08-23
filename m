Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CDF759E9EB
	for <lists+kvm@lfdr.de>; Tue, 23 Aug 2022 19:39:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230075AbiHWRgP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 13:36:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231346AbiHWRe4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 13:34:56 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8988180346;
        Tue, 23 Aug 2022 08:15:33 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27NFCiIQ004659;
        Tue, 23 Aug 2022 15:15:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=cC46tiX9BrbTmGrsc9kJBoqbsXbAoGGjhXK85Q9l+YY=;
 b=bEoZtsgyXJ0kBA3bp/E9BqfsTjKOqrOraaOprFz+5h48gJK5yRvxCbjh+S/JK0UVKvop
 1yVB6XFbymq9i0jXB0zg8ECtQLKSnxO8+z8a+eNvju/apiIwOCCwPp7iomp9HqVPZ/AP
 67Co2EEteb2ZM47OFHmcqyrc4e+02sEmMTmVb+4ZyKMmwt5gxY/FKk2DqPzALqqxzpwY
 CLffK+FdtWVk+EekO7+8ytWAQUg2mzW88fvnmg9riIitxaUqapsQm3T4VBCntc7e8A6k
 m4Tej+DSRv/TYDqVTTHi0Ajdpkd9IQnDJ5i23mmAw5+iUDOnzyLXAwwleQ5w6NMwDq0a Qw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j51b702b1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Aug 2022 15:15:18 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27NFEBcq011169;
        Tue, 23 Aug 2022 15:15:18 GMT
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j51b702a3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Aug 2022 15:15:17 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27NF99io016926;
        Tue, 23 Aug 2022 15:15:17 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma04dal.us.ibm.com with ESMTP id 3j2q8a0hy5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Aug 2022 15:15:16 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27NFFFc249021202
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Aug 2022 15:15:16 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CF9E92805E;
        Tue, 23 Aug 2022 15:15:15 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 25B872805A;
        Tue, 23 Aug 2022 15:15:15 +0000 (GMT)
Received: from [9.160.64.167] (unknown [9.160.64.167])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 23 Aug 2022 15:15:15 +0000 (GMT)
Message-ID: <02b06bc5-ce85-2266-c14a-dd1b83c16dd1@linux.ibm.com>
Date:   Tue, 23 Aug 2022 11:15:14 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 03/14] vfio/mdev: make mdev.h standalone includable
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, intel-gvt-dev@lists.freedesktop.org,
        Kevin Tian <kevin.tian@intel.com>
References: <20220822062208.152745-1-hch@lst.de>
 <20220822062208.152745-4-hch@lst.de>
From:   Anthony Krowiak <akrowiak@linux.ibm.com>
In-Reply-To: <20220822062208.152745-4-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ffx7kv0bjvvh-2SMGqR-NyZYaa6R0DYy
X-Proofpoint-GUID: 7wV0v7-ig_VwuOxY9S51FaOO8JFHbmvU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-23_05,2022-08-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 clxscore=1011
 impostorscore=0 malwarescore=0 priorityscore=1501 phishscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208230062
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reviewed-by: Tony Krowiak <akrowiak@linux.ibm.com>

On 8/22/22 2:21 AM, Christoph Hellwig wrote:
> Include <linux/device.h> and <linux/uuid.h> so that users of this headers
> don't need to do that and remove those includes that aren't needed
> any more.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Reviewed By: Kirti Wankhede <kwankhede@nvidia.com>
> ---
>   drivers/gpu/drm/i915/gvt/kvmgt.c      | 2 --
>   drivers/s390/cio/vfio_ccw_drv.c       | 1 -
>   drivers/s390/crypto/vfio_ap_private.h | 1 -
>   drivers/vfio/mdev/mdev_core.c         | 2 --
>   drivers/vfio/mdev/mdev_driver.c       | 1 -
>   drivers/vfio/mdev/mdev_sysfs.c        | 2 --
>   include/linux/mdev.h                  | 3 +++
>   samples/vfio-mdev/mbochs.c            | 1 -
>   samples/vfio-mdev/mdpy.c              | 1 -
>   samples/vfio-mdev/mtty.c              | 2 --
>   10 files changed, 3 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
> index 91ba675a2fb8c..92bb9e7548b12 100644
> --- a/drivers/gpu/drm/i915/gvt/kvmgt.c
> +++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
> @@ -34,7 +34,6 @@
>    */
>   
>   #include <linux/init.h>
> -#include <linux/device.h>
>   #include <linux/mm.h>
>   #include <linux/kthread.h>
>   #include <linux/sched/mm.h>
> @@ -43,7 +42,6 @@
>   #include <linux/rbtree.h>
>   #include <linux/spinlock.h>
>   #include <linux/eventfd.h>
> -#include <linux/uuid.h>
>   #include <linux/mdev.h>
>   #include <linux/debugfs.h>
>   
> diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
> index 86d9e428357b0..e9985c63dc6bf 100644
> --- a/drivers/s390/cio/vfio_ccw_drv.c
> +++ b/drivers/s390/cio/vfio_ccw_drv.c
> @@ -12,7 +12,6 @@
>   
>   #include <linux/module.h>
>   #include <linux/init.h>
> -#include <linux/device.h>
>   #include <linux/slab.h>
>   #include <linux/mdev.h>
>   
> diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
> index d782cf463eaba..163eeaaf24cee 100644
> --- a/drivers/s390/crypto/vfio_ap_private.h
> +++ b/drivers/s390/crypto/vfio_ap_private.h
> @@ -13,7 +13,6 @@
>   #define _VFIO_AP_PRIVATE_H_
>   
>   #include <linux/types.h>
> -#include <linux/device.h>
>   #include <linux/mdev.h>
>   #include <linux/delay.h>
>   #include <linux/mutex.h>
> diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
> index b8b9e7911e559..2c32923fbad27 100644
> --- a/drivers/vfio/mdev/mdev_core.c
> +++ b/drivers/vfio/mdev/mdev_core.c
> @@ -8,9 +8,7 @@
>    */
>   
>   #include <linux/module.h>
> -#include <linux/device.h>
>   #include <linux/slab.h>
> -#include <linux/uuid.h>
>   #include <linux/sysfs.h>
>   #include <linux/mdev.h>
>   
> diff --git a/drivers/vfio/mdev/mdev_driver.c b/drivers/vfio/mdev/mdev_driver.c
> index 9c2af59809e2e..7bd4bb9850e81 100644
> --- a/drivers/vfio/mdev/mdev_driver.c
> +++ b/drivers/vfio/mdev/mdev_driver.c
> @@ -7,7 +7,6 @@
>    *             Kirti Wankhede <kwankhede@nvidia.com>
>    */
>   
> -#include <linux/device.h>
>   #include <linux/iommu.h>
>   #include <linux/mdev.h>
>   
> diff --git a/drivers/vfio/mdev/mdev_sysfs.c b/drivers/vfio/mdev/mdev_sysfs.c
> index 0ccfeb3dda245..4bfbf49aaa66a 100644
> --- a/drivers/vfio/mdev/mdev_sysfs.c
> +++ b/drivers/vfio/mdev/mdev_sysfs.c
> @@ -9,9 +9,7 @@
>   
>   #include <linux/sysfs.h>
>   #include <linux/ctype.h>
> -#include <linux/device.h>
>   #include <linux/slab.h>
> -#include <linux/uuid.h>
>   #include <linux/mdev.h>
>   
>   #include "mdev_private.h"
> diff --git a/include/linux/mdev.h b/include/linux/mdev.h
> index 47ad3b104d9e7..a5d8ae6132a20 100644
> --- a/include/linux/mdev.h
> +++ b/include/linux/mdev.h
> @@ -10,6 +10,9 @@
>   #ifndef MDEV_H
>   #define MDEV_H
>   
> +#include <linux/device.h>
> +#include <linux/uuid.h>
> +
>   struct mdev_type;
>   
>   struct mdev_device {
> diff --git a/samples/vfio-mdev/mbochs.c b/samples/vfio-mdev/mbochs.c
> index 344c2901a82bf..d0d1bb7747240 100644
> --- a/samples/vfio-mdev/mbochs.c
> +++ b/samples/vfio-mdev/mbochs.c
> @@ -21,7 +21,6 @@
>    */
>   #include <linux/init.h>
>   #include <linux/module.h>
> -#include <linux/device.h>
>   #include <linux/kernel.h>
>   #include <linux/slab.h>
>   #include <linux/vmalloc.h>
> diff --git a/samples/vfio-mdev/mdpy.c b/samples/vfio-mdev/mdpy.c
> index e8c46eb2e2468..0c4ca1f4be7ed 100644
> --- a/samples/vfio-mdev/mdpy.c
> +++ b/samples/vfio-mdev/mdpy.c
> @@ -17,7 +17,6 @@
>    */
>   #include <linux/init.h>
>   #include <linux/module.h>
> -#include <linux/device.h>
>   #include <linux/kernel.h>
>   #include <linux/slab.h>
>   #include <linux/vmalloc.h>
> diff --git a/samples/vfio-mdev/mtty.c b/samples/vfio-mdev/mtty.c
> index f42a59ed2e3fe..4f5a6f2d3629d 100644
> --- a/samples/vfio-mdev/mtty.c
> +++ b/samples/vfio-mdev/mtty.c
> @@ -12,7 +12,6 @@
>   
>   #include <linux/init.h>
>   #include <linux/module.h>
> -#include <linux/device.h>
>   #include <linux/kernel.h>
>   #include <linux/fs.h>
>   #include <linux/poll.h>
> @@ -20,7 +19,6 @@
>   #include <linux/cdev.h>
>   #include <linux/sched.h>
>   #include <linux/wait.h>
> -#include <linux/uuid.h>
>   #include <linux/vfio.h>
>   #include <linux/iommu.h>
>   #include <linux/sysfs.h>
