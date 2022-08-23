Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F3FD59EC28
	for <lists+kvm@lfdr.de>; Tue, 23 Aug 2022 21:22:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231230AbiHWTWw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 15:22:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233218AbiHWTWb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 15:22:31 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C9789E692;
        Tue, 23 Aug 2022 11:03:29 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27NHhY9w007681;
        Tue, 23 Aug 2022 18:02:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=AgNvVG0edT28hv7MtckHKr3I12mN1X1DVyBIWBmN+64=;
 b=P2bOHPMLBZ0qinqhiYDgQ3XA1V90Bye5C39eepSCqIkVuS9K3ImN2geB9SPq93vLOeWu
 R8iSFpN009pIcb6gujsqXEKv3SAvrFsETzEg0G0ORP0N8OQyjoeyvliXHLflF3MHZC2l
 w1Q9I4qo/qt5bPEY6Dtfgb36EZBtgOUkmhKDvlmvbqklElZUDvy0RNyWV9rLy9Tl1Cvs
 PgCuqlSYcTNmH9Th2w4bNVlfjjAxnt9MCSvnCM4XguLmyQ19eqT16bsJyrpGW2QHOuIk
 /dgptvCUd7cZP6allweIZeDb2Rwi+8lrR46IKqoxGJ6azroQS0b2/H+Q7HVDxTibovHR Rg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3j53hugj86-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Aug 2022 18:02:11 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27NHkJtr017952;
        Tue, 23 Aug 2022 18:02:11 GMT
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3j53hugj7n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Aug 2022 18:02:11 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27NHoVPl017411;
        Tue, 23 Aug 2022 18:02:10 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma01dal.us.ibm.com with ESMTP id 3j2q8a1kjd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Aug 2022 18:02:10 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27NI29IH18154254
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Aug 2022 18:02:09 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0AA4C124053;
        Tue, 23 Aug 2022 18:02:09 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4B266124052;
        Tue, 23 Aug 2022 18:02:08 +0000 (GMT)
Received: from li-479af74c-31f9-11b2-a85c-e4ddee11713b.ibm.com (unknown [9.160.161.42])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 23 Aug 2022 18:02:08 +0000 (GMT)
Message-ID: <1e9beb36fca72f1dccc217321b2bbbf31c1c1723.camel@linux.ibm.com>
Subject: Re: [PATCH 03/14] vfio/mdev: make mdev.h standalone includable
From:   Eric Farman <farman@linux.ibm.com>
To:     Christoph Hellwig <hch@lst.de>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, intel-gvt-dev@lists.freedesktop.org,
        Kevin Tian <kevin.tian@intel.com>
Date:   Tue, 23 Aug 2022 14:02:07 -0400
In-Reply-To: <20220822062208.152745-4-hch@lst.de>
References: <20220822062208.152745-1-hch@lst.de>
         <20220822062208.152745-4-hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-1.fc36) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: vqWB3DDdlpD1oFBTsjI6HEJ1hsxEDs7d
X-Proofpoint-ORIG-GUID: J_XRo1RCwCmak8PMqElH5G5o9gaVUQkV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-23_07,2022-08-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxlogscore=999
 priorityscore=1501 malwarescore=0 impostorscore=0 lowpriorityscore=0
 bulkscore=0 adultscore=0 phishscore=0 mlxscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208230069
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2022-08-22 at 08:21 +0200, Christoph Hellwig wrote:
> Include <linux/device.h> and <linux/uuid.h> so that users of this
> headers
> don't need to do that and remove those includes that aren't needed
> any more.
>=20
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Reviewed By: Kirti Wankhede <kwankhede@nvidia.com>

Reviewed-by: Eric Farman <farman@linux.ibm.com>

> ---
> =C2=A0drivers/gpu/drm/i915/gvt/kvmgt.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 2 =
--
> =C2=A0drivers/s390/cio/vfio_ccw_drv.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 | 1 -
> =C2=A0drivers/s390/crypto/vfio_ap_private.h | 1 -
> =C2=A0drivers/vfio/mdev/mdev_core.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 | 2 --
> =C2=A0drivers/vfio/mdev/mdev_driver.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 | 1 -
> =C2=A0drivers/vfio/mdev/mdev_sysfs.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 | 2 --
> =C2=A0include/linux/mdev.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 3 +++
> =C2=A0samples/vfio-mdev/mbochs.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 1 -
> =C2=A0samples/vfio-mdev/mdpy.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 1 -
> =C2=A0samples/vfio-mdev/mtty.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 2 --
> =C2=A010 files changed, 3 insertions(+), 13 deletions(-)
>=20
> diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c
> b/drivers/gpu/drm/i915/gvt/kvmgt.c
> index 91ba675a2fb8c..92bb9e7548b12 100644
> --- a/drivers/gpu/drm/i915/gvt/kvmgt.c
> +++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
> @@ -34,7 +34,6 @@
> =C2=A0 */
> =C2=A0
> =C2=A0#include <linux/init.h>
> -#include <linux/device.h>
> =C2=A0#include <linux/mm.h>
> =C2=A0#include <linux/kthread.h>
> =C2=A0#include <linux/sched/mm.h>
> @@ -43,7 +42,6 @@
> =C2=A0#include <linux/rbtree.h>
> =C2=A0#include <linux/spinlock.h>
> =C2=A0#include <linux/eventfd.h>
> -#include <linux/uuid.h>
> =C2=A0#include <linux/mdev.h>
> =C2=A0#include <linux/debugfs.h>
> =C2=A0
> diff --git a/drivers/s390/cio/vfio_ccw_drv.c
> b/drivers/s390/cio/vfio_ccw_drv.c
> index 86d9e428357b0..e9985c63dc6bf 100644
> --- a/drivers/s390/cio/vfio_ccw_drv.c
> +++ b/drivers/s390/cio/vfio_ccw_drv.c
> @@ -12,7 +12,6 @@
> =C2=A0
> =C2=A0#include <linux/module.h>
> =C2=A0#include <linux/init.h>
> -#include <linux/device.h>
> =C2=A0#include <linux/slab.h>
> =C2=A0#include <linux/mdev.h>
> =C2=A0
> diff --git a/drivers/s390/crypto/vfio_ap_private.h
> b/drivers/s390/crypto/vfio_ap_private.h
> index d782cf463eaba..163eeaaf24cee 100644
> --- a/drivers/s390/crypto/vfio_ap_private.h
> +++ b/drivers/s390/crypto/vfio_ap_private.h
> @@ -13,7 +13,6 @@
> =C2=A0#define _VFIO_AP_PRIVATE_H_
> =C2=A0
> =C2=A0#include <linux/types.h>
> -#include <linux/device.h>
> =C2=A0#include <linux/mdev.h>
> =C2=A0#include <linux/delay.h>
> =C2=A0#include <linux/mutex.h>
> diff --git a/drivers/vfio/mdev/mdev_core.c
> b/drivers/vfio/mdev/mdev_core.c
> index b8b9e7911e559..2c32923fbad27 100644
> --- a/drivers/vfio/mdev/mdev_core.c
> +++ b/drivers/vfio/mdev/mdev_core.c
> @@ -8,9 +8,7 @@
> =C2=A0 */
> =C2=A0
> =C2=A0#include <linux/module.h>
> -#include <linux/device.h>
> =C2=A0#include <linux/slab.h>
> -#include <linux/uuid.h>
> =C2=A0#include <linux/sysfs.h>
> =C2=A0#include <linux/mdev.h>
> =C2=A0
> diff --git a/drivers/vfio/mdev/mdev_driver.c
> b/drivers/vfio/mdev/mdev_driver.c
> index 9c2af59809e2e..7bd4bb9850e81 100644
> --- a/drivers/vfio/mdev/mdev_driver.c
> +++ b/drivers/vfio/mdev/mdev_driver.c
> @@ -7,7 +7,6 @@
> =C2=A0 *=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 Kirti Wankhede <kwankhede@nvidia.com>
> =C2=A0 */
> =C2=A0
> -#include <linux/device.h>
> =C2=A0#include <linux/iommu.h>
> =C2=A0#include <linux/mdev.h>
> =C2=A0
> diff --git a/drivers/vfio/mdev/mdev_sysfs.c
> b/drivers/vfio/mdev/mdev_sysfs.c
> index 0ccfeb3dda245..4bfbf49aaa66a 100644
> --- a/drivers/vfio/mdev/mdev_sysfs.c
> +++ b/drivers/vfio/mdev/mdev_sysfs.c
> @@ -9,9 +9,7 @@
> =C2=A0
> =C2=A0#include <linux/sysfs.h>
> =C2=A0#include <linux/ctype.h>
> -#include <linux/device.h>
> =C2=A0#include <linux/slab.h>
> -#include <linux/uuid.h>
> =C2=A0#include <linux/mdev.h>
> =C2=A0
> =C2=A0#include "mdev_private.h"
> diff --git a/include/linux/mdev.h b/include/linux/mdev.h
> index 47ad3b104d9e7..a5d8ae6132a20 100644
> --- a/include/linux/mdev.h
> +++ b/include/linux/mdev.h
> @@ -10,6 +10,9 @@
> =C2=A0#ifndef MDEV_H
> =C2=A0#define MDEV_H
> =C2=A0
> +#include <linux/device.h>
> +#include <linux/uuid.h>
> +
> =C2=A0struct mdev_type;
> =C2=A0
> =C2=A0struct mdev_device {
> diff --git a/samples/vfio-mdev/mbochs.c b/samples/vfio-mdev/mbochs.c
> index 344c2901a82bf..d0d1bb7747240 100644
> --- a/samples/vfio-mdev/mbochs.c
> +++ b/samples/vfio-mdev/mbochs.c
> @@ -21,7 +21,6 @@
> =C2=A0 */
> =C2=A0#include <linux/init.h>
> =C2=A0#include <linux/module.h>
> -#include <linux/device.h>
> =C2=A0#include <linux/kernel.h>
> =C2=A0#include <linux/slab.h>
> =C2=A0#include <linux/vmalloc.h>
> diff --git a/samples/vfio-mdev/mdpy.c b/samples/vfio-mdev/mdpy.c
> index e8c46eb2e2468..0c4ca1f4be7ed 100644
> --- a/samples/vfio-mdev/mdpy.c
> +++ b/samples/vfio-mdev/mdpy.c
> @@ -17,7 +17,6 @@
> =C2=A0 */
> =C2=A0#include <linux/init.h>
> =C2=A0#include <linux/module.h>
> -#include <linux/device.h>
> =C2=A0#include <linux/kernel.h>
> =C2=A0#include <linux/slab.h>
> =C2=A0#include <linux/vmalloc.h>
> diff --git a/samples/vfio-mdev/mtty.c b/samples/vfio-mdev/mtty.c
> index f42a59ed2e3fe..4f5a6f2d3629d 100644
> --- a/samples/vfio-mdev/mtty.c
> +++ b/samples/vfio-mdev/mtty.c
> @@ -12,7 +12,6 @@
> =C2=A0
> =C2=A0#include <linux/init.h>
> =C2=A0#include <linux/module.h>
> -#include <linux/device.h>
> =C2=A0#include <linux/kernel.h>
> =C2=A0#include <linux/fs.h>
> =C2=A0#include <linux/poll.h>
> @@ -20,7 +19,6 @@
> =C2=A0#include <linux/cdev.h>
> =C2=A0#include <linux/sched.h>
> =C2=A0#include <linux/wait.h>
> -#include <linux/uuid.h>
> =C2=A0#include <linux/vfio.h>
> =C2=A0#include <linux/iommu.h>
> =C2=A0#include <linux/sysfs.h>

