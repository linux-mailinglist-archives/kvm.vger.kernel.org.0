Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA322569B76
	for <lists+kvm@lfdr.de>; Thu,  7 Jul 2022 09:22:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234500AbiGGHWl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jul 2022 03:22:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234091AbiGGHWj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jul 2022 03:22:39 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A6EA30F43;
        Thu,  7 Jul 2022 00:22:37 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2676DGVh020614;
        Thu, 7 Jul 2022 07:22:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=yg1aYH0HbxMgVuQHmFaMubRV+99KFiuI4Iep0iMvM0Y=;
 b=J8bOSFUh8iuQo3c+GOT50BObSmEiIsndHKQT6LFHzHCpM4gnZFJZuu+/C5Wz1u7gqO4K
 Y0+FHx9KHSgvT35CCImDiX7ofi8IymGDLprl/Yr0hcsnhJ8FE2gpBp4RScv8mM09TiEv
 Fqoq64HF/TGMiZopWImbYA0Vwc0jHnwd6b69/6IVyY4Y6SrK4PRAhTYB8BzrXibWhtSt
 UODHmacQBIyq4NAZN2QWkXGnP6xVLeO6nNc1yoyojzyfn/a/k80/PJ+2rgje0OaW34h9
 E6+vaPxrBFcDz3+PUTgRxZecljPtgJxKgQqwyyYWHhTdq9KQwfaeLA6YMzWIXfHZF8Bd mA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3h5q4gdq6b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Jul 2022 07:22:28 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2676sl59028099;
        Thu, 7 Jul 2022 07:22:27 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3h5q4gdq5k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Jul 2022 07:22:27 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2677KDW1024675;
        Thu, 7 Jul 2022 07:22:25 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma01fra.de.ibm.com with ESMTP id 3h4ukw1kum-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Jul 2022 07:22:25 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2677MMuA18219306
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 7 Jul 2022 07:22:22 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3E233A405B;
        Thu,  7 Jul 2022 07:22:22 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 17ED5A4054;
        Thu,  7 Jul 2022 07:22:22 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu,  7 Jul 2022 07:22:22 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 55398)
        id C435BE0231; Thu,  7 Jul 2022 09:22:21 +0200 (CEST)
Date:   Thu, 7 Jul 2022 09:22:21 +0200
From:   Vineeth Vijayan <vneethv@linux.ibm.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Jason Gunthorpe <jgg@nvidia.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, intel-gvt-dev@lists.freedesktop.org,
        Kevin Tian <kevin.tian@intel.com>
Subject: Re: [PATCH 04/15] vfio/mdev: embedd struct mdev_parent in the parent
 data structure
Message-ID: <YsaJrX4kpCCz5AZI@tuxmaker.boeblingen.de.ibm.com>
References: <20220706074219.3614-1-hch@lst.de>
 <20220706074219.3614-5-hch@lst.de>
 <27e9ef873a00dde07373155e76615437136106c4.camel@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <27e9ef873a00dde07373155e76615437136106c4.camel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 1dkTBgsqSWyiWGWuF56bW6Ktpq41Dk4g
X-Proofpoint-ORIG-GUID: 5RKsP4BdEBijsk5JDEAyU_qWB-UIAPs2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-07_04,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 priorityscore=1501 malwarescore=0 impostorscore=0 mlxscore=0
 spamscore=0 adultscore=0 phishscore=0 suspectscore=0 clxscore=1011
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207070027
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 06, 2022 at 11:08:28PM -0400, Eric Farman wrote:
> On Wed, 2022-07-06 at 09:42 +0200, Christoph Hellwig wrote:
> > Simplify mdev_{un}register_device by requiring the caller to pass in
> > a structure allocate as part of the parent device structure.  This
> > removes the need for a list of parents and the separate mdev_parent
> > refcount as we can simplify rely on the reference to the parent
> > device.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> > Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> > ---
> >  .../driver-api/vfio-mediated-device.rst       |  12 +-
> >  Documentation/s390/vfio-ap.rst                |   2 +-
> >  Documentation/s390/vfio-ccw.rst               |   2 +-
> >  drivers/gpu/drm/i915/gvt/gvt.h                |   2 +
> >  drivers/gpu/drm/i915/gvt/kvmgt.c              |   5 +-
> >  drivers/s390/cio/cio.h                        |   2 +
> >  drivers/s390/cio/vfio_ccw_ops.c               |   6 +-
> 
> (@Vineeth, @Peter FYI regarding struct subchannel)
> 
> I haven't had a chance to look at this series with enough focus, but
> the change to cio.h (here, and patch 5) caught my eye. I would've
> expected the "parent" to be struct vfio_ccw_private, instead of the
> subchannel.
> 
> Eric
Thank you Eric for pointing it out. You are right. I think the struct
subchannel is obviously the wrong place. 
Also, in this case, the mdev_parent should be in one of the vfio-ccw
io-subchannel structure, which as you mentioned should be in vfio-ccw*.

@Halil, Could you please have a look. I am not very familier with the
vfio yet.
> 
> >  drivers/s390/crypto/vfio_ap_ops.c             |   5 +-
> >  drivers/s390/crypto/vfio_ap_private.h         |   1 +
> >  drivers/vfio/mdev/mdev_core.c                 | 120 ++++----------
> > ----
> >  drivers/vfio/mdev/mdev_private.h              |  23 ----
> >  drivers/vfio/mdev/mdev_sysfs.c                |   4 +-
> >  include/linux/mdev.h                          |  15 ++-
> >  samples/vfio-mdev/mbochs.c                    |   5 +-
> >  samples/vfio-mdev/mdpy.c                      |   5 +-
> >  samples/vfio-mdev/mtty.c                      |   6 +-
> >  16 files changed, 69 insertions(+), 146 deletions(-)
> > 
> > diff --git a/Documentation/driver-api/vfio-mediated-device.rst
> > b/Documentation/driver-api/vfio-mediated-device.rst
> > index 1c57815619fdf..62a82afce161b 100644
> > --- a/Documentation/driver-api/vfio-mediated-device.rst
> > +++ b/Documentation/driver-api/vfio-mediated-device.rst
> > @@ -60,19 +60,19 @@ devices as examples, as these devices are the
> > first devices to use this module::
> >       |  MDEV CORE    |
> >       |   MODULE      |
> >       |   mdev.ko     |
> > -     | +-----------+ |  mdev_register_device() +--------------+
> > +     | +-----------+ |  mdev_register_parent() +--------------+
> >       | |           | +<------------------------+              |
> >       | |           | |                         |  nvidia.ko   |<->
> > physical
> >       | |           | +----------------------
> > -->+              |    device
> >       | |           | |        callbacks        +--------------+
> >       | | Physical  | |
> > -     | |  device   | |  mdev_register_device() +--------------+
> > +     | |  device   | |  mdev_register_parent() +--------------+
> >       | | interface | |<------------------------+              |
> >       | |           | |                         |  i915.ko     |<->
> > physical
> >       | |           | +----------------------
> > -->+              |    device
> >       | |           | |        callbacks        +--------------+
> >       | |           | |
> > -     | |           | |  mdev_register_device() +--------------+
> > +     | |           | |  mdev_register_parent() +--------------+
> >       | |           | +<------------------------+              |
> >       | |           | |                         | ccw_device.ko|<->
> > physical
> >       | |           | +----------------------
> > -->+              |    device
> > @@ -127,8 +127,8 @@ vfio_device_ops.
> >  When a driver wants to add the GUID creation sysfs to an existing
> > device it has
> >  probe'd to then it should call::
> >  
> > -    int mdev_register_device(struct device *dev,
> > -                             struct mdev_driver *mdev_driver);
> > +    int mdev_register_parent(struct mdev_parent *parent, struct
> > device *dev,
> > +			struct mdev_driver *mdev_driver);
> >  
> >  This will provide the 'mdev_supported_types/XX/create' files which
> > can then be
> >  used to trigger the creation of a mdev_device. The created
> > mdev_device will be
> > @@ -136,7 +136,7 @@ attached to the specified driver.
> >  
> >  When the driver needs to remove itself it calls::
> >  
> > -    void mdev_unregister_device(struct device *dev);
> > +    void mdev_unregister_parent(struct mdev_parent *parent);
> >  
> >  Which will unbind and destroy all the created mdevs and remove the
> > sysfs files.
> >  
> > diff --git a/Documentation/s390/vfio-ap.rst
> > b/Documentation/s390/vfio-ap.rst
> > index f57ae621f33e8..37e16158c7fbf 100644
> > --- a/Documentation/s390/vfio-ap.rst
> > +++ b/Documentation/s390/vfio-ap.rst
> > @@ -299,7 +299,7 @@ of the VFIO AP mediated matrix device driver::
> >     |  MDEV CORE  |
> >     |   MODULE    |
> >     |   mdev.ko   |
> > -   | +---------+ | mdev_register_device() +--------------+
> > +   | +---------+ | mdev_register_parent() +--------------+
> >     | |Physical | +<-----------------------+              |
> >     | | device  | |                        |  vfio_ap.ko  |<-> matrix
> >     | |interface| +----------------------->+              |    device
> > diff --git a/Documentation/s390/vfio-ccw.rst
> > b/Documentation/s390/vfio-ccw.rst
> > index 8aad08a8b8a50..ea928a3806f43 100644
> > --- a/Documentation/s390/vfio-ccw.rst
> > +++ b/Documentation/s390/vfio-ccw.rst
> > @@ -156,7 +156,7 @@ Below is a high Level block diagram::
> >   |  MDEV CORE  |
> >   |   MODULE    |
> >   |   mdev.ko   |
> > - | +---------+ | mdev_register_device() +--------------+
> > + | +---------+ | mdev_register_parent() +--------------+
> >   | |Physical | +<-----------------------+              |
> >   | | device  | |                        |  vfio_ccw.ko |<->
> > subchannel
> >   | |interface| +----------------------->+              |     device
> > diff --git a/drivers/gpu/drm/i915/gvt/gvt.h
> > b/drivers/gpu/drm/i915/gvt/gvt.h
> > index 392c2ad49d376..bbf0116671ecb 100644
> > --- a/drivers/gpu/drm/i915/gvt/gvt.h
> > +++ b/drivers/gpu/drm/i915/gvt/gvt.h
> > @@ -36,6 +36,7 @@
> >  #include <uapi/linux/pci_regs.h>
> >  #include <linux/kvm_host.h>
> >  #include <linux/vfio.h>
> > +#include <linux/mdev.h>
> >  
> >  #include "i915_drv.h"
> >  #include "intel_gvt.h"
> > @@ -338,6 +339,7 @@ struct intel_gvt {
> >  	struct intel_gvt_workload_scheduler scheduler;
> >  	struct notifier_block
> > shadow_ctx_notifier_block[I915_NUM_ENGINES];
> >  	DECLARE_HASHTABLE(cmd_table, GVT_CMD_HASH_BITS);
> > +	struct mdev_parent parent;
> >  	struct intel_vgpu_type *types;
> >  	unsigned int num_types;
> >  	struct intel_vgpu *idle_vgpu;
> > diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c
> > b/drivers/gpu/drm/i915/gvt/kvmgt.c
> > index 85e1393d8e55c..e9dba4c0fe6b5 100644
> > --- a/drivers/gpu/drm/i915/gvt/kvmgt.c
> > +++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
> > @@ -1958,7 +1958,7 @@ static void intel_gvt_clean_device(struct
> > drm_i915_private *i915)
> >  	if (drm_WARN_ON(&i915->drm, !gvt))
> >  		return;
> >  
> > -	mdev_unregister_device(i915->drm.dev);
> > +	mdev_unregister_parent(&gvt->parent);
> >  	intel_gvt_cleanup_vgpu_type_groups(gvt);
> >  	intel_gvt_destroy_idle_vgpu(gvt->idle_vgpu);
> >  	intel_gvt_clean_vgpu_types(gvt);
> > @@ -2063,7 +2063,8 @@ static int intel_gvt_init_device(struct
> > drm_i915_private *i915)
> >  	if (ret)
> >  		goto out_destroy_idle_vgpu;
> >  
> > -	ret = mdev_register_device(i915->drm.dev,
> > &intel_vgpu_mdev_driver);
> > +	ret = mdev_register_parent(&gvt->parent, i915->drm.dev,
> > +				   &intel_vgpu_mdev_driver);
> >  	if (ret)
> >  		goto out_cleanup_vgpu_type_groups;
> >  
> > diff --git a/drivers/s390/cio/cio.h b/drivers/s390/cio/cio.h
> > index fa8df50bb49e3..22be5ac7d23c1 100644
> > --- a/drivers/s390/cio/cio.h
> > +++ b/drivers/s390/cio/cio.h
> > @@ -5,6 +5,7 @@
> >  #include <linux/mutex.h>
> >  #include <linux/device.h>
> >  #include <linux/mod_devicetable.h>
> > +#include <linux/mdev.h>
> >  #include <asm/chpid.h>
> >  #include <asm/cio.h>
> >  #include <asm/fcx.h>
> > @@ -108,6 +109,7 @@ struct subchannel {
> >  	 * frees it.  Use driver_set_override() to set or clear it.
> >  	 */
> >  	const char *driver_override;
> > +	struct mdev_parent parent;
> >  } __attribute__ ((aligned(8)));
> >  
> >  DECLARE_PER_CPU_ALIGNED(struct irb, cio_irb);
> > diff --git a/drivers/s390/cio/vfio_ccw_ops.c
> > b/drivers/s390/cio/vfio_ccw_ops.c
> > index b49e2e9db2dc6..9192a21085ce4 100644
> > --- a/drivers/s390/cio/vfio_ccw_ops.c
> > +++ b/drivers/s390/cio/vfio_ccw_ops.c
> > @@ -11,7 +11,6 @@
> >   */
> >  
> >  #include <linux/vfio.h>
> > -#include <linux/mdev.h>
> >  #include <linux/nospec.h>
> >  #include <linux/slab.h>
> >  
> > @@ -660,10 +659,11 @@ struct mdev_driver vfio_ccw_mdev_driver = {
> >  
> >  int vfio_ccw_mdev_reg(struct subchannel *sch)
> >  {
> > -	return mdev_register_device(&sch->dev, &vfio_ccw_mdev_driver);
> > +	return mdev_register_parent(&sch->parent, &sch->dev,
> > +				    &vfio_ccw_mdev_driver);
> >  }
> >  
> >  void vfio_ccw_mdev_unreg(struct subchannel *sch)
> >  {
> > -	mdev_unregister_device(&sch->dev);
> > +	mdev_unregister_parent(&sch->parent);
> >  }
> > diff --git a/drivers/s390/crypto/vfio_ap_ops.c
> > b/drivers/s390/crypto/vfio_ap_ops.c
> > index a7d2a95796d36..834945150dc9f 100644
> > --- a/drivers/s390/crypto/vfio_ap_ops.c
> > +++ b/drivers/s390/crypto/vfio_ap_ops.c
> > @@ -1485,7 +1485,8 @@ int vfio_ap_mdev_register(void)
> >  	if (ret)
> >  		return ret;
> >  
> > -	ret = mdev_register_device(&matrix_dev->device,
> > &vfio_ap_matrix_driver);
> > +	ret = mdev_register_parent(&matrix_dev->parent, &matrix_dev-
> > >device,
> > +				   &vfio_ap_matrix_driver);
> >  	if (ret)
> >  		goto err_driver;
> >  	return 0;
> > @@ -1497,6 +1498,6 @@ int vfio_ap_mdev_register(void)
> >  
> >  void vfio_ap_mdev_unregister(void)
> >  {
> > -	mdev_unregister_device(&matrix_dev->device);
> > +	mdev_unregister_parent(&matrix_dev->parent);
> >  	mdev_unregister_driver(&vfio_ap_matrix_driver);
> >  }
> > diff --git a/drivers/s390/crypto/vfio_ap_private.h
> > b/drivers/s390/crypto/vfio_ap_private.h
> > index 6616aa83347ad..0191f6bc973a4 100644
> > --- a/drivers/s390/crypto/vfio_ap_private.h
> > +++ b/drivers/s390/crypto/vfio_ap_private.h
> > @@ -45,6 +45,7 @@ struct ap_matrix_dev {
> >  	struct list_head mdev_list;
> >  	struct mutex lock;
> >  	struct ap_driver  *vfio_ap_drv;
> > +	struct mdev_parent parent;
> >  };
> >  
> >  extern struct ap_matrix_dev *matrix_dev;
> > diff --git a/drivers/vfio/mdev/mdev_core.c
> > b/drivers/vfio/mdev/mdev_core.c
> > index 2c32923fbad27..fa05ac3396950 100644
> > --- a/drivers/vfio/mdev/mdev_core.c
> > +++ b/drivers/vfio/mdev/mdev_core.c
> > @@ -18,8 +18,6 @@
> >  #define DRIVER_AUTHOR		"NVIDIA Corporation"
> >  #define DRIVER_DESC		"Mediated device Core Driver"
> >  
> > -static LIST_HEAD(parent_list);
> > -static DEFINE_MUTEX(parent_list_lock);
> >  static struct class_compat *mdev_bus_compat_class;
> >  
> >  static LIST_HEAD(mdev_list);
> > @@ -61,28 +59,6 @@ struct device *mtype_get_parent_dev(struct
> > mdev_type *mtype)
> >  }
> >  EXPORT_SYMBOL(mtype_get_parent_dev);
> >  
> > -/* Should be called holding parent_list_lock */
> > -static struct mdev_parent *__find_parent_device(struct device *dev)
> > -{
> > -	struct mdev_parent *parent;
> > -
> > -	list_for_each_entry(parent, &parent_list, next) {
> > -		if (parent->dev == dev)
> > -			return parent;
> > -	}
> > -	return NULL;
> > -}
> > -
> > -void mdev_release_parent(struct kref *kref)
> > -{
> > -	struct mdev_parent *parent = container_of(kref, struct
> > mdev_parent,
> > -						  ref);
> > -	struct device *dev = parent->dev;
> > -
> > -	kfree(parent);
> > -	put_device(dev);
> > -}
> > -
> >  /* Caller must hold parent unreg_sem read or write lock */
> >  static void mdev_device_remove_common(struct mdev_device *mdev)
> >  {
> > @@ -105,125 +81,73 @@ static int mdev_device_remove_cb(struct device
> > *dev, void *data)
> >  }
> >  
> >  /*
> > - * mdev_register_device : Register a device
> > + * mdev_register_parent: Register a device as parent for mdevs
> > + * @parent: parent structure registered
> >   * @dev: device structure representing parent device.
> >   * @mdev_driver: Device driver to bind to the newly created mdev
> >   *
> > - * Add device to list of registered parent devices.
> > + * Registers the @parent stucture as a parent for mdev types and
> > thus mdev
> > + * devices.  The caller needs to hold a reference on @dev that must
> > not be
> > + * released until after the call to mdev_unregister_parent().
> > + *
> >   * Returns a negative value on error, otherwise 0.
> >   */
> > -int mdev_register_device(struct device *dev, struct mdev_driver
> > *mdev_driver)
> > +int mdev_register_parent(struct mdev_parent *parent, struct device
> > *dev,
> > +		struct mdev_driver *mdev_driver)
> >  {
> > -	int ret;
> > -	struct mdev_parent *parent;
> >  	char *env_string = "MDEV_STATE=registered";
> >  	char *envp[] = { env_string, NULL };
> > +	int ret;
> >  
> >  	/* check for mandatory ops */
> >  	if (!mdev_driver->supported_type_groups)
> >  		return -EINVAL;
> >  
> > -	dev = get_device(dev);
> > -	if (!dev)
> > -		return -EINVAL;
> > -
> > -	mutex_lock(&parent_list_lock);
> > -
> > -	/* Check for duplicate */
> > -	parent = __find_parent_device(dev);
> > -	if (parent) {
> > -		parent = NULL;
> > -		ret = -EEXIST;
> > -		goto add_dev_err;
> > -	}
> > -
> > -	parent = kzalloc(sizeof(*parent), GFP_KERNEL);
> > -	if (!parent) {
> > -		ret = -ENOMEM;
> > -		goto add_dev_err;
> > -	}
> > -
> > -	kref_init(&parent->ref);
> > +	memset(parent, 0, sizeof(*parent));
> >  	init_rwsem(&parent->unreg_sem);
> > -
> >  	parent->dev = dev;
> >  	parent->mdev_driver = mdev_driver;
> >  
> >  	if (!mdev_bus_compat_class) {
> >  		mdev_bus_compat_class =
> > class_compat_register("mdev_bus");
> > -		if (!mdev_bus_compat_class) {
> > -			ret = -ENOMEM;
> > -			goto add_dev_err;
> > -		}
> > +		if (!mdev_bus_compat_class)
> > +			return -ENOMEM;
> >  	}
> >  
> >  	ret = parent_create_sysfs_files(parent);
> >  	if (ret)
> > -		goto add_dev_err;
> > +		return ret;
> >  
> >  	ret = class_compat_create_link(mdev_bus_compat_class, dev,
> > NULL);
> >  	if (ret)
> >  		dev_warn(dev, "Failed to create compatibility class
> > link\n");
> >  
> > -	list_add(&parent->next, &parent_list);
> > -	mutex_unlock(&parent_list_lock);
> > -
> >  	dev_info(dev, "MDEV: Registered\n");
> >  	kobject_uevent_env(&dev->kobj, KOBJ_CHANGE, envp);
> > -
> >  	return 0;
> > -
> > -add_dev_err:
> > -	mutex_unlock(&parent_list_lock);
> > -	if (parent)
> > -		mdev_put_parent(parent);
> > -	else
> > -		put_device(dev);
> > -	return ret;
> >  }
> > -EXPORT_SYMBOL(mdev_register_device);
> > +EXPORT_SYMBOL(mdev_register_parent);
> >  
> >  /*
> > - * mdev_unregister_device : Unregister a parent device
> > - * @dev: device structure representing parent device.
> > - *
> > - * Remove device from list of registered parent devices. Give a
> > chance to free
> > - * existing mediated devices for given device.
> > + * mdev_unregister_parent : Unregister a parent device
> > + * @parent: parent structure to unregister
> >   */
> > -
> > -void mdev_unregister_device(struct device *dev)
> > +void mdev_unregister_parent(struct mdev_parent *parent)
> >  {
> > -	struct mdev_parent *parent;
> >  	char *env_string = "MDEV_STATE=unregistered";
> >  	char *envp[] = { env_string, NULL };
> >  
> > -	mutex_lock(&parent_list_lock);
> > -	parent = __find_parent_device(dev);
> > -
> > -	if (!parent) {
> > -		mutex_unlock(&parent_list_lock);
> > -		return;
> > -	}
> > -	dev_info(dev, "MDEV: Unregistering\n");
> > -
> > -	list_del(&parent->next);
> > -	mutex_unlock(&parent_list_lock);
> > +	dev_info(parent->dev, "MDEV: Unregistering\n");
> >  
> >  	down_write(&parent->unreg_sem);
> > -
> > -	class_compat_remove_link(mdev_bus_compat_class, dev, NULL);
> > -
> > -	device_for_each_child(dev, NULL, mdev_device_remove_cb);
> > -
> > +	class_compat_remove_link(mdev_bus_compat_class, parent->dev,
> > NULL);
> > +	device_for_each_child(parent->dev, NULL,
> > mdev_device_remove_cb);
> >  	parent_remove_sysfs_files(parent);
> >  	up_write(&parent->unreg_sem);
> >  
> > -	mdev_put_parent(parent);
> > -
> > -	/* We still have the caller's reference to use for the uevent
> > */
> > -	kobject_uevent_env(&dev->kobj, KOBJ_CHANGE, envp);
> > +	kobject_uevent_env(&parent->dev->kobj, KOBJ_CHANGE, envp);
> >  }
> > -EXPORT_SYMBOL(mdev_unregister_device);
> > +EXPORT_SYMBOL(mdev_unregister_parent);
> >  
> >  static void mdev_device_release(struct device *dev)
> >  {
> > diff --git a/drivers/vfio/mdev/mdev_private.h
> > b/drivers/vfio/mdev/mdev_private.h
> > index 7c9fc79f3d838..297f911fdc890 100644
> > --- a/drivers/vfio/mdev/mdev_private.h
> > +++ b/drivers/vfio/mdev/mdev_private.h
> > @@ -13,17 +13,6 @@
> >  int  mdev_bus_register(void);
> >  void mdev_bus_unregister(void);
> >  
> > -struct mdev_parent {
> > -	struct device *dev;
> > -	struct mdev_driver *mdev_driver;
> > -	struct kref ref;
> > -	struct list_head next;
> > -	struct kset *mdev_types_kset;
> > -	struct list_head type_list;
> > -	/* Synchronize device creation/removal with parent
> > unregistration */
> > -	struct rw_semaphore unreg_sem;
> > -};
> > -
> >  struct mdev_type {
> >  	struct kobject kobj;
> >  	struct kobject *devices_kobj;
> > @@ -48,16 +37,4 @@ void mdev_remove_sysfs_files(struct mdev_device
> > *mdev);
> >  int mdev_device_create(struct mdev_type *kobj, const guid_t *uuid);
> >  int  mdev_device_remove(struct mdev_device *dev);
> >  
> > -void mdev_release_parent(struct kref *kref);
> > -
> > -static inline void mdev_get_parent(struct mdev_parent *parent)
> > -{
> > -	kref_get(&parent->ref);
> > -}
> > -
> > -static inline void mdev_put_parent(struct mdev_parent *parent)
> > -{
> > -	kref_put(&parent->ref, mdev_release_parent);
> > -}
> > -
> >  #endif /* MDEV_PRIVATE_H */
> > diff --git a/drivers/vfio/mdev/mdev_sysfs.c
> > b/drivers/vfio/mdev/mdev_sysfs.c
> > index 4bfbf49aaa66a..b71ffc5594870 100644
> > --- a/drivers/vfio/mdev/mdev_sysfs.c
> > +++ b/drivers/vfio/mdev/mdev_sysfs.c
> > @@ -81,7 +81,7 @@ static void mdev_type_release(struct kobject *kobj)
> >  
> >  	pr_debug("Releasing group %s\n", kobj->name);
> >  	/* Pairs with the get in add_mdev_supported_type() */
> > -	mdev_put_parent(type->parent);
> > +	put_device(type->parent->dev);
> >  	kfree(type);
> >  }
> >  
> > @@ -110,7 +110,7 @@ static struct mdev_type
> > *add_mdev_supported_type(struct mdev_parent *parent,
> >  	type->kobj.kset = parent->mdev_types_kset;
> >  	type->parent = parent;
> >  	/* Pairs with the put in mdev_type_release() */
> > -	mdev_get_parent(parent);
> > +	get_device(parent->dev);
> >  	type->type_group_id = type_group_id;
> >  
> >  	ret = kobject_init_and_add(&type->kobj, &mdev_type_ktype, NULL,
> > diff --git a/include/linux/mdev.h b/include/linux/mdev.h
> > index 555c1d015b5f0..327ce3e5c6b5f 100644
> > --- a/include/linux/mdev.h
> > +++ b/include/linux/mdev.h
> > @@ -23,6 +23,16 @@ struct mdev_device {
> >  	bool active;
> >  };
> >  
> > +/* embedded into the struct device that the mdev devices hang off */
> > +struct mdev_parent {
> > +	struct device *dev;
> > +	struct mdev_driver *mdev_driver;
> > +	struct kset *mdev_types_kset;
> > +	struct list_head type_list;
> > +	/* Synchronize device creation/removal with parent
> > unregistration */
> > +	struct rw_semaphore unreg_sem;
> > +};
> > +
> >  static inline struct mdev_device *to_mdev_device(struct device *dev)
> >  {
> >  	return container_of(dev, struct mdev_device, dev);
> > @@ -75,8 +85,9 @@ static inline const guid_t *mdev_uuid(struct
> > mdev_device *mdev)
> >  
> >  extern struct bus_type mdev_bus_type;
> >  
> > -int mdev_register_device(struct device *dev, struct mdev_driver
> > *mdev_driver);
> > -void mdev_unregister_device(struct device *dev);
> > +int mdev_register_parent(struct mdev_parent *parent, struct device
> > *dev,
> > +		struct mdev_driver *mdev_driver);
> > +void mdev_unregister_parent(struct mdev_parent *parent);
> >  
> >  int mdev_register_driver(struct mdev_driver *drv);
> >  void mdev_unregister_driver(struct mdev_driver *drv);
> > diff --git a/samples/vfio-mdev/mbochs.c b/samples/vfio-mdev/mbochs.c
> > index d0d1bb7747240..30b3643b3b389 100644
> > --- a/samples/vfio-mdev/mbochs.c
> > +++ b/samples/vfio-mdev/mbochs.c
> > @@ -128,6 +128,7 @@ static dev_t		mbochs_devt;
> >  static struct class	*mbochs_class;
> >  static struct cdev	mbochs_cdev;
> >  static struct device	mbochs_dev;
> > +static struct mdev_parent mbochs_parent;
> >  static atomic_t mbochs_avail_mbytes;
> >  static const struct vfio_device_ops mbochs_dev_ops;
> >  
> > @@ -1456,7 +1457,7 @@ static int __init mbochs_dev_init(void)
> >  	if (ret)
> >  		goto err_class;
> >  
> > -	ret = mdev_register_device(&mbochs_dev, &mbochs_driver);
> > +	ret = mdev_register_parent(&mbochs_parent, &mbochs_dev,
> > &mbochs_driver);
> >  	if (ret)
> >  		goto err_device;
> >  
> > @@ -1477,7 +1478,7 @@ static int __init mbochs_dev_init(void)
> >  static void __exit mbochs_dev_exit(void)
> >  {
> >  	mbochs_dev.bus = NULL;
> > -	mdev_unregister_device(&mbochs_dev);
> > +	mdev_unregister_parent(&mbochs_parent);
> >  
> >  	device_unregister(&mbochs_dev);
> >  	mdev_unregister_driver(&mbochs_driver);
> > diff --git a/samples/vfio-mdev/mdpy.c b/samples/vfio-mdev/mdpy.c
> > index 0c4ca1f4be7ed..132bb055628a6 100644
> > --- a/samples/vfio-mdev/mdpy.c
> > +++ b/samples/vfio-mdev/mdpy.c
> > @@ -83,6 +83,7 @@ static dev_t		mdpy_devt;
> >  static struct class	*mdpy_class;
> >  static struct cdev	mdpy_cdev;
> >  static struct device	mdpy_dev;
> > +static struct mdev_parent mdpy_parent;
> >  static u32		mdpy_count;
> >  static const struct vfio_device_ops mdpy_dev_ops;
> >  
> > @@ -765,7 +766,7 @@ static int __init mdpy_dev_init(void)
> >  	if (ret)
> >  		goto err_class;
> >  
> > -	ret = mdev_register_device(&mdpy_dev, &mdpy_driver);
> > +	ret = mdev_register_parent(&mdpy_parent, &mdpy_dev,
> > &mdpy_driver);
> >  	if (ret)
> >  		goto err_device;
> >  
> > @@ -786,7 +787,7 @@ static int __init mdpy_dev_init(void)
> >  static void __exit mdpy_dev_exit(void)
> >  {
> >  	mdpy_dev.bus = NULL;
> > -	mdev_unregister_device(&mdpy_dev);
> > +	mdev_unregister_parent(&mdpy_parent);
> >  
> >  	device_unregister(&mdpy_dev);
> >  	mdev_unregister_driver(&mdpy_driver);
> > diff --git a/samples/vfio-mdev/mtty.c b/samples/vfio-mdev/mtty.c
> > index 4f5a6f2d3629d..8ba5f6084a093 100644
> > --- a/samples/vfio-mdev/mtty.c
> > +++ b/samples/vfio-mdev/mtty.c
> > @@ -72,6 +72,7 @@ static struct mtty_dev {
> >  	struct cdev	vd_cdev;
> >  	struct idr	vd_idr;
> >  	struct device	dev;
> > +	struct mdev_parent parent;
> >  } mtty_dev;
> >  
> >  struct mdev_region_info {
> > @@ -1350,7 +1351,8 @@ static int __init mtty_dev_init(void)
> >  	if (ret)
> >  		goto err_class;
> >  
> > -	ret = mdev_register_device(&mtty_dev.dev, &mtty_driver);
> > +	ret = mdev_register_parent(&mtty_dev.parent, &mtty_dev.dev,
> > +				   &mtty_driver);
> >  	if (ret)
> >  		goto err_device;
> >  	return 0;
> > @@ -1370,7 +1372,7 @@ static int __init mtty_dev_init(void)
> >  static void __exit mtty_dev_exit(void)
> >  {
> >  	mtty_dev.dev.bus = NULL;
> > -	mdev_unregister_device(&mtty_dev.dev);
> > +	mdev_unregister_parent(&mtty_dev.parent);
> >  
> >  	device_unregister(&mtty_dev.dev);
> >  	idr_destroy(&mtty_dev.vd_idr);
> 
