Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97550579054
	for <lists+kvm@lfdr.de>; Tue, 19 Jul 2022 04:00:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236622AbiGSCAz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jul 2022 22:00:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230230AbiGSCAw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Jul 2022 22:00:52 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36CD113D05;
        Mon, 18 Jul 2022 19:00:51 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26J1xwwp015512;
        Tue, 19 Jul 2022 02:00:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=qpEwW35PJI4mp/KC0VBN8ItsXjG1vAWzBpYXMi7ucws=;
 b=hHbjuqWKJRps/2mxBE9SdrkLGf26P6wi2k0gwPXiuCbd7hdq2J7bGtCDm3oaEtVGGmSL
 Kplz7y49HA47zcgxDzRK9ydThLNaiRZ9Ny6wVT72GYDukV7I9oZw4jLYEENDTGkCPvaI
 L17I/ZGPmAEXEfO/LjvN7lJY+crjtvSIv0WTvLfQkG7e8fnyQ8BG1b0655fFHiYJI3Zn
 X+nutGE0etiPf04gXPw39k387mkmHUF1hPmPvQTct1ijtm4Ute7gsiBPjqnRRkYx74p2
 fqN2plvrHNUPq1ApQOO6vVFQ0vPxitW1ETbmNtdVrpj5c6qtHlYmKaSNS8wo3XebjQWL pA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hdken80c0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jul 2022 02:00:33 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26J20WM3017754;
        Tue, 19 Jul 2022 02:00:32 GMT
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hdken80bq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jul 2022 02:00:32 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26J1pgGa031022;
        Tue, 19 Jul 2022 02:00:31 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma02wdc.us.ibm.com with ESMTP id 3hbmy98fcb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jul 2022 02:00:31 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26J20VHO64291114
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Jul 2022 02:00:31 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2D66DAC059;
        Tue, 19 Jul 2022 02:00:31 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E409EAC05B;
        Tue, 19 Jul 2022 02:00:27 +0000 (GMT)
Received: from farman-thinkpad-t470p (unknown [9.211.146.30])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 19 Jul 2022 02:00:27 +0000 (GMT)
Message-ID: <c4c14deebf82cd2497fd9ebd0c3f321e9089b7ce.camel@linux.ibm.com>
Subject: Re: [PATCH 14/14] vfio/mdev: add mdev available instance checking
 to the core
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
Date:   Mon, 18 Jul 2022 22:00:26 -0400
In-Reply-To: <20220709045450.609884-15-hch@lst.de>
References: <20220709045450.609884-1-hch@lst.de>
         <20220709045450.609884-15-hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 1CJ0FJITu-DKRJGyd2s7PJXHN0ojXqYz
X-Proofpoint-ORIG-GUID: -bI4b7ZiznRMWpO1De9IMKqPGFaXccMU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-18_22,2022-07-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 lowpriorityscore=0 mlxlogscore=999 spamscore=0 priorityscore=1501
 malwarescore=0 suspectscore=0 adultscore=0 impostorscore=0 clxscore=1015
 phishscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207190004
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 2022-07-09 at 06:54 +0200, Christoph Hellwig wrote:
> From: Jason Gunthorpe <jgg@nvidia.com>
> 
> Many of the mdev drivers use a simple counter for keeping track of
> the
> available instances. Move this code to the core code and store the
> counter
> in the mdev_parent. Implement it using correct locking, fixing mdpy.
> 
> Drivers just provide the value in the mdev_driver at registration
> time
> and the core code takes care of maintaining it and exposing the value
> in
> sysfs.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> [hch: count instances per-parent instead of per-type, use an atomic_t
>  to avoid taking mdev_list_lock in the show method]
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Reviewed-by: Kirti Wankhede <kwankhede@nvidia.com>
> ---
>  drivers/s390/cio/vfio_ccw_drv.c       |  1 -
>  drivers/s390/cio/vfio_ccw_ops.c       | 14 +-------------
>  drivers/s390/cio/vfio_ccw_private.h   |  2 --
>  drivers/s390/crypto/vfio_ap_ops.c     | 21 +++------------------
>  drivers/s390/crypto/vfio_ap_private.h |  2 --
>  drivers/vfio/mdev/mdev_core.c         | 17 ++++++++++++++---
>  drivers/vfio/mdev/mdev_sysfs.c        |  5 ++++-
>  include/linux/mdev.h                  |  3 +++
>  samples/vfio-mdev/mdpy.c              | 23 ++++-------------------
>  9 files changed, 29 insertions(+), 59 deletions(-)

...snip...

> diff --git a/drivers/vfio/mdev/mdev_core.c
> b/drivers/vfio/mdev/mdev_core.c
> index 93f8caf2e5f77..2d0302995d7b7 100644
> --- a/drivers/vfio/mdev/mdev_core.c
> +++ b/drivers/vfio/mdev/mdev_core.c
> @@ -70,6 +70,7 @@ int mdev_register_parent(struct mdev_parent
> *parent, struct device *dev,
>  	parent->mdev_driver = mdev_driver;
>  	parent->types = types;
>  	parent->nr_types = nr_types;
> +	atomic_set(&parent->available_instances, mdev_driver-
> >max_instances);
>  
>  	if (!mdev_bus_compat_class) {
>  		mdev_bus_compat_class =
> class_compat_register("mdev_bus");
> @@ -115,14 +116,17 @@ EXPORT_SYMBOL(mdev_unregister_parent);
>  static void mdev_device_release(struct device *dev)
>  {
>  	struct mdev_device *mdev = to_mdev_device(dev);
> -
> -	/* Pairs with the get in mdev_device_create() */
> -	kobject_put(&mdev->type->kobj);
> +	struct mdev_parent *parent = mdev->type->parent;
>  
>  	mutex_lock(&mdev_list_lock);
>  	list_del(&mdev->next);
> +	if (!parent->mdev_driver->get_available)
> +		atomic_inc(&parent->available_instances);
>  	mutex_unlock(&mdev_list_lock);
>  
> +	/* Pairs with the get in mdev_device_create() */
> +	kobject_put(&mdev->type->kobj);
> +
>  	dev_dbg(&mdev->dev, "MDEV: destroying\n");
>  	kfree(mdev);
>  }
> @@ -144,6 +148,13 @@ int mdev_device_create(struct mdev_type *type,
> const guid_t *uuid)
>  		}
>  	}
>  
> +	if (!drv->get_available) {
> +		if (atomic_dec_and_test(&parent->available_instances))
> {

Ah, subtle change between v5 and v6 to use atomics. As vfio-ccw only
has 1 available instance per mdev, this breaks us. Did you mean
atomic_dec_if_positive() ?

> +			mutex_unlock(&mdev_list_lock);
> +			return -EUSERS;
> +		}
> +	}
> +
>  	mdev = kzalloc(sizeof(*mdev), GFP_KERNEL);
>  	if (!mdev) {
>  		mutex_unlock(&mdev_list_lock);
> 

