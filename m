Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E91B59EA5C
	for <lists+kvm@lfdr.de>; Tue, 23 Aug 2022 19:56:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231697AbiHWR4J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 13:56:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233022AbiHWRzZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 13:55:25 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C977A792E1;
        Tue, 23 Aug 2022 08:59:14 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27NFtBfu008119;
        Tue, 23 Aug 2022 15:59:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Non4A/MdBljnRPYprlCTZl2RaTycqk//JkJkvX63Trw=;
 b=VFKdOJsBzFdaB5B7mRqIOwo82CF7eQOljU1kIfKzEJgJCTPjUd1Ux1gAJKeBGtsy5sW5
 ypNhAWMwYJ4RFFLoDml6UQr+Z21WlyQoKCt8QW/nxbHIwCEvPu2/dZItFboyWUGDXtxB
 xR9G6MhWeMdumDhfhq73TpqhJUFGFHQQQsCjtJ6M89RfASG9fOM2xtY/Lq03UKixBggD
 SuGdvFDlQt8PUl3y194rGBacnSDjrork9GfaGr7QLAApS/pI7aImFR2KTUYGHzSLjhq8
 m3kzYK9ErBVok4wOFS7ELfvzC1PcX9odr7TVxeAIM3/lpl+qpcN4VZpi5Aec0+X3vwt7 wA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j51y284b8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Aug 2022 15:59:07 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27NFutBR012691;
        Tue, 23 Aug 2022 15:59:07 GMT
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j51y284ak-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Aug 2022 15:59:06 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27NFoBSZ011243;
        Tue, 23 Aug 2022 15:59:06 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma02wdc.us.ibm.com with ESMTP id 3j2q8a3ved-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Aug 2022 15:59:06 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27NFx54u7275192
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Aug 2022 15:59:05 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7DDD32805C;
        Tue, 23 Aug 2022 15:59:05 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B4BB728059;
        Tue, 23 Aug 2022 15:59:04 +0000 (GMT)
Received: from [9.160.64.167] (unknown [9.160.64.167])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 23 Aug 2022 15:59:04 +0000 (GMT)
Message-ID: <1d31e1bf-8353-a3a3-8547-43cc8bd779b1@linux.ibm.com>
Date:   Tue, 23 Aug 2022 11:59:04 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 10/14] vfio/mdev: consolidate all the device_api sysfs
 into the core code
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
 <20220822062208.152745-11-hch@lst.de>
From:   Anthony Krowiak <akrowiak@linux.ibm.com>
In-Reply-To: <20220822062208.152745-11-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: FPSjIzA_EcnIZgImxQZCe4SVnQ8qIjJ6
X-Proofpoint-GUID: SkrtISf_To5u6mrmQXKSQ-BKf89z6zzp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-23_07,2022-08-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 spamscore=0 clxscore=1015 priorityscore=1501 suspectscore=0 mlxscore=0
 mlxlogscore=999 phishscore=0 adultscore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208230063
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

On 8/22/22 2:22 AM, Christoph Hellwig wrote:
> From: Jason Gunthorpe <jgg@nvidia.com>
>
> Every driver just emits a static string, simply feed it through the ops
> and provide a standard sysfs show function.
>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Reviewed-by: Kirti Wankhede <kwankhede@nvidia.com>
> ---
>   .../driver-api/vfio-mediated-device.rst       |  2 +-
>   drivers/gpu/drm/i915/gvt/kvmgt.c              |  9 +----
>   drivers/s390/cio/vfio_ccw_ops.c               |  9 +----
>   drivers/s390/crypto/vfio_ap_ops.c             | 10 +-----
>   drivers/vfio/mdev/mdev_driver.c               |  4 ++-
>   drivers/vfio/mdev/mdev_sysfs.c                | 35 +++++++++++++------
>   include/linux/mdev.h                          |  7 ++--
>   samples/vfio-mdev/mbochs.c                    |  9 +----
>   samples/vfio-mdev/mdpy.c                      |  9 +----
>   samples/vfio-mdev/mtty.c                      | 10 +-----
>   10 files changed, 37 insertions(+), 67 deletions(-)
>
> diff --git a/Documentation/driver-api/vfio-mediated-device.rst b/Documentation/driver-api/vfio-mediated-device.rst
> index 7b660f3fa2c92..b0c29e37f61b4 100644
> --- a/Documentation/driver-api/vfio-mediated-device.rst
> +++ b/Documentation/driver-api/vfio-mediated-device.rst
> @@ -202,7 +202,7 @@ Directories and files under the sysfs for Each Physical Device
>   
>   * device_api
>   
> -  This attribute should show which device API is being created, for example,
> +  This attribute shows which device API is being created, for example,
>     "vfio-pci" for a PCI device.
>   
>   * available_instances
> diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
> index ef9d114349c3a..1ed99091165a4 100644
> --- a/drivers/gpu/drm/i915/gvt/kvmgt.c
> +++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
> @@ -123,12 +123,6 @@ static ssize_t available_instances_show(struct mdev_type *mtype,
>   	return sprintf(buf, "%u\n", type->avail_instance);
>   }
>   
> -static ssize_t device_api_show(struct mdev_type *mtype,
> -			       struct mdev_type_attribute *attr, char *buf)
> -{
> -	return sprintf(buf, "%s\n", VFIO_DEVICE_API_PCI_STRING);
> -}
> -
>   static ssize_t description_show(struct mdev_type *mtype,
>   				struct mdev_type_attribute *attr, char *buf)
>   {
> @@ -151,13 +145,11 @@ static ssize_t name_show(struct mdev_type *mtype,
>   }
>   
>   static MDEV_TYPE_ATTR_RO(available_instances);
> -static MDEV_TYPE_ATTR_RO(device_api);
>   static MDEV_TYPE_ATTR_RO(description);
>   static MDEV_TYPE_ATTR_RO(name);
>   
>   static const struct attribute *gvt_type_attrs[] = {
>   	&mdev_type_attr_available_instances.attr,
> -	&mdev_type_attr_device_api.attr,
>   	&mdev_type_attr_description.attr,
>   	&mdev_type_attr_name.attr,
>   	NULL,
> @@ -1531,6 +1523,7 @@ static void intel_vgpu_remove(struct mdev_device *mdev)
>   }
>   
>   static struct mdev_driver intel_vgpu_mdev_driver = {
> +	.device_api	= VFIO_DEVICE_API_PCI_STRING,
>   	.driver = {
>   		.name		= "intel_vgpu_mdev",
>   		.owner		= THIS_MODULE,
> diff --git a/drivers/s390/cio/vfio_ccw_ops.c b/drivers/s390/cio/vfio_ccw_ops.c
> index 0ec0e310c91ea..9ced2063720e6 100644
> --- a/drivers/s390/cio/vfio_ccw_ops.c
> +++ b/drivers/s390/cio/vfio_ccw_ops.c
> @@ -51,13 +51,6 @@ static ssize_t name_show(struct mdev_type *mtype,
>   }
>   static MDEV_TYPE_ATTR_RO(name);
>   
> -static ssize_t device_api_show(struct mdev_type *mtype,
> -			       struct mdev_type_attribute *attr, char *buf)
> -{
> -	return sprintf(buf, "%s\n", VFIO_DEVICE_API_CCW_STRING);
> -}
> -static MDEV_TYPE_ATTR_RO(device_api);
> -
>   static ssize_t available_instances_show(struct mdev_type *mtype,
>   					struct mdev_type_attribute *attr,
>   					char *buf)
> @@ -70,7 +63,6 @@ static MDEV_TYPE_ATTR_RO(available_instances);
>   
>   static const struct attribute *mdev_types_attrs[] = {
>   	&mdev_type_attr_name.attr,
> -	&mdev_type_attr_device_api.attr,
>   	&mdev_type_attr_available_instances.attr,
>   	NULL,
>   };
> @@ -590,6 +582,7 @@ static const struct vfio_device_ops vfio_ccw_dev_ops = {
>   };
>   
>   struct mdev_driver vfio_ccw_mdev_driver = {
> +	.device_api = VFIO_DEVICE_API_CCW_STRING,
>   	.driver = {
>   		.name = "vfio_ccw_mdev",
>   		.owner = THIS_MODULE,
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index e74f34589329d..728a0ada4928f 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -802,17 +802,8 @@ static ssize_t available_instances_show(struct mdev_type *mtype,
>   
>   static MDEV_TYPE_ATTR_RO(available_instances);
>   
> -static ssize_t device_api_show(struct mdev_type *mtype,
> -			       struct mdev_type_attribute *attr, char *buf)
> -{
> -	return sprintf(buf, "%s\n", VFIO_DEVICE_API_AP_STRING);
> -}
> -
> -static MDEV_TYPE_ATTR_RO(device_api);
> -
>   static const struct attribute *vfio_ap_mdev_type_attrs[] = {
>   	&mdev_type_attr_name.attr,
> -	&mdev_type_attr_device_api.attr,
>   	&mdev_type_attr_available_instances.attr,
>   	NULL,
>   };
> @@ -1791,6 +1782,7 @@ static const struct vfio_device_ops vfio_ap_matrix_dev_ops = {
>   };
>   
>   static struct mdev_driver vfio_ap_matrix_driver = {
> +	.device_api = VFIO_DEVICE_API_AP_STRING,
>   	.driver = {
>   		.name = "vfio_ap_mdev",
>   		.owner = THIS_MODULE,
> diff --git a/drivers/vfio/mdev/mdev_driver.c b/drivers/vfio/mdev/mdev_driver.c
> index 5b3c94f4fb13d..60e8b9f6474e8 100644
> --- a/drivers/vfio/mdev/mdev_driver.c
> +++ b/drivers/vfio/mdev/mdev_driver.c
> @@ -55,8 +55,10 @@ struct bus_type mdev_bus_type = {
>    **/
>   int mdev_register_driver(struct mdev_driver *drv)
>   {
> -	if (!drv->types_attrs)
> +	if (!drv->types_attrs || !drv->device_api)
>   		return -EINVAL;
> +
> +	/* initialize common driver fields */
>   	drv->driver.bus = &mdev_bus_type;
>   	return driver_register(&drv->driver);
>   }
> diff --git a/drivers/vfio/mdev/mdev_sysfs.c b/drivers/vfio/mdev/mdev_sysfs.c
> index 80b2d546a3d98..89637bc85462a 100644
> --- a/drivers/vfio/mdev/mdev_sysfs.c
> +++ b/drivers/vfio/mdev/mdev_sysfs.c
> @@ -72,9 +72,30 @@ static ssize_t create_store(struct mdev_type *mtype,
>   
>   	return count;
>   }
> -
>   static MDEV_TYPE_ATTR_WO(create);
>   
> +static ssize_t device_api_show(struct mdev_type *mtype,
> +			       struct mdev_type_attribute *attr, char *buf)
> +{
> +	return sysfs_emit(buf, "%s\n", mtype->parent->mdev_driver->device_api);
> +}
> +static MDEV_TYPE_ATTR_RO(device_api);
> +
> +static struct attribute *mdev_types_core_attrs[] = {
> +	&mdev_type_attr_create.attr,
> +	&mdev_type_attr_device_api.attr,
> +	NULL,
> +};
> +
> +static struct attribute_group mdev_type_core_group = {
> +	.attrs = mdev_types_core_attrs,
> +};
> +
> +static const struct attribute_group *mdev_type_groups[] = {
> +	&mdev_type_core_group,
> +	NULL,
> +};
> +
>   static void mdev_type_release(struct kobject *kobj)
>   {
>   	struct mdev_type *type = to_mdev_type(kobj);
> @@ -86,8 +107,9 @@ static void mdev_type_release(struct kobject *kobj)
>   }
>   
>   static struct kobj_type mdev_type_ktype = {
> -	.sysfs_ops = &mdev_type_sysfs_ops,
> -	.release = mdev_type_release,
> +	.sysfs_ops	= &mdev_type_sysfs_ops,
> +	.release	= mdev_type_release,
> +	.default_groups	= mdev_type_groups,
>   };
>   
>   static int mdev_type_add(struct mdev_parent *parent, struct mdev_type *type)
> @@ -107,10 +129,6 @@ static int mdev_type_add(struct mdev_parent *parent, struct mdev_type *type)
>   		return ret;
>   	}
>   
> -	ret = sysfs_create_file(&type->kobj, &mdev_type_attr_create.attr);
> -	if (ret)
> -		goto attr_create_failed;
> -
>   	type->devices_kobj = kobject_create_and_add("devices", &type->kobj);
>   	if (!type->devices_kobj) {
>   		ret = -ENOMEM;
> @@ -125,8 +143,6 @@ static int mdev_type_add(struct mdev_parent *parent, struct mdev_type *type)
>   attrs_failed:
>   	kobject_put(type->devices_kobj);
>   attr_devices_failed:
> -	sysfs_remove_file(&type->kobj, &mdev_type_attr_create.attr);
> -attr_create_failed:
>   	kobject_del(&type->kobj);
>   	kobject_put(&type->kobj);
>   	return ret;
> @@ -137,7 +153,6 @@ static void mdev_type_remove(struct mdev_type *type)
>   	sysfs_remove_files(&type->kobj, type->parent->mdev_driver->types_attrs);
>   
>   	kobject_put(type->devices_kobj);
> -	sysfs_remove_file(&type->kobj, &mdev_type_attr_create.attr);
>   	kobject_del(&type->kobj);
>   	kobject_put(&type->kobj);
>   }
> diff --git a/include/linux/mdev.h b/include/linux/mdev.h
> index e445f809ceca3..af1ff0165b8d3 100644
> --- a/include/linux/mdev.h
> +++ b/include/linux/mdev.h
> @@ -61,11 +61,6 @@ struct mdev_type_attribute {
>   			 size_t count);
>   };
>   
> -#define MDEV_TYPE_ATTR(_name, _mode, _show, _store)		\
> -struct mdev_type_attribute mdev_type_attr_##_name =		\
> -	__ATTR(_name, _mode, _show, _store)
> -#define MDEV_TYPE_ATTR_RW(_name) \
> -	struct mdev_type_attribute mdev_type_attr_##_name = __ATTR_RW(_name)
>   #define MDEV_TYPE_ATTR_RO(_name) \
>   	struct mdev_type_attribute mdev_type_attr_##_name = __ATTR_RO(_name)
>   #define MDEV_TYPE_ATTR_WO(_name) \
> @@ -73,12 +68,14 @@ struct mdev_type_attribute mdev_type_attr_##_name =		\
>   
>   /**
>    * struct mdev_driver - Mediated device driver
> + * @device_api: string to return for the device_api sysfs
>    * @probe: called when new device created
>    * @remove: called when device removed
>    * @types_attrs: attributes to the type kobjects.
>    * @driver: device driver structure
>    **/
>   struct mdev_driver {
> +	const char *device_api;
>   	int (*probe)(struct mdev_device *dev);
>   	void (*remove)(struct mdev_device *dev);
>   	const struct attribute * const *types_attrs;
> diff --git a/samples/vfio-mdev/mbochs.c b/samples/vfio-mdev/mbochs.c
> index 1069f561cb012..199846f01de92 100644
> --- a/samples/vfio-mdev/mbochs.c
> +++ b/samples/vfio-mdev/mbochs.c
> @@ -1367,17 +1367,9 @@ static ssize_t available_instances_show(struct mdev_type *mtype,
>   }
>   static MDEV_TYPE_ATTR_RO(available_instances);
>   
> -static ssize_t device_api_show(struct mdev_type *mtype,
> -			       struct mdev_type_attribute *attr, char *buf)
> -{
> -	return sprintf(buf, "%s\n", VFIO_DEVICE_API_PCI_STRING);
> -}
> -static MDEV_TYPE_ATTR_RO(device_api);
> -
>   static const struct attribute *mdev_types_attrs[] = {
>   	&mdev_type_attr_name.attr,
>   	&mdev_type_attr_description.attr,
> -	&mdev_type_attr_device_api.attr,
>   	&mdev_type_attr_available_instances.attr,
>   	NULL,
>   };
> @@ -1391,6 +1383,7 @@ static const struct vfio_device_ops mbochs_dev_ops = {
>   };
>   
>   static struct mdev_driver mbochs_driver = {
> +	.device_api = VFIO_DEVICE_API_PCI_STRING,
>   	.driver = {
>   		.name = "mbochs",
>   		.owner = THIS_MODULE,
> diff --git a/samples/vfio-mdev/mdpy.c b/samples/vfio-mdev/mdpy.c
> index 2052cc27b1c6d..b8d6eeff2033d 100644
> --- a/samples/vfio-mdev/mdpy.c
> +++ b/samples/vfio-mdev/mdpy.c
> @@ -678,17 +678,9 @@ static ssize_t available_instances_show(struct mdev_type *mtype,
>   }
>   static MDEV_TYPE_ATTR_RO(available_instances);
>   
> -static ssize_t device_api_show(struct mdev_type *mtype,
> -			       struct mdev_type_attribute *attr, char *buf)
> -{
> -	return sprintf(buf, "%s\n", VFIO_DEVICE_API_PCI_STRING);
> -}
> -static MDEV_TYPE_ATTR_RO(device_api);
> -
>   static const struct attribute *mdev_types_attrs[] = {
>   	&mdev_type_attr_name.attr,
>   	&mdev_type_attr_description.attr,
> -	&mdev_type_attr_device_api.attr,
>   	&mdev_type_attr_available_instances.attr,
>   	NULL,
>   };
> @@ -701,6 +693,7 @@ static const struct vfio_device_ops mdpy_dev_ops = {
>   };
>   
>   static struct mdev_driver mdpy_driver = {
> +	.device_api = VFIO_DEVICE_API_PCI_STRING,
>   	.driver = {
>   		.name = "mdpy",
>   		.owner = THIS_MODULE,
> diff --git a/samples/vfio-mdev/mtty.c b/samples/vfio-mdev/mtty.c
> index 029a19ef8ce7b..2a470424628af 100644
> --- a/samples/vfio-mdev/mtty.c
> +++ b/samples/vfio-mdev/mtty.c
> @@ -1268,17 +1268,8 @@ static ssize_t available_instances_show(struct mdev_type *mtype,
>   
>   static MDEV_TYPE_ATTR_RO(available_instances);
>   
> -static ssize_t device_api_show(struct mdev_type *mtype,
> -			       struct mdev_type_attribute *attr, char *buf)
> -{
> -	return sprintf(buf, "%s\n", VFIO_DEVICE_API_PCI_STRING);
> -}
> -
> -static MDEV_TYPE_ATTR_RO(device_api);
> -
>   static const struct attribute *mdev_types_attrs[] = {
>   	&mdev_type_attr_name.attr,
> -	&mdev_type_attr_device_api.attr,
>   	&mdev_type_attr_available_instances.attr,
>   	NULL,
>   };
> @@ -1291,6 +1282,7 @@ static const struct vfio_device_ops mtty_dev_ops = {
>   };
>   
>   static struct mdev_driver mtty_driver = {
> +	.device_api = VFIO_DEVICE_API_PCI_STRING,
>   	.driver = {
>   		.name = "mtty",
>   		.owner = THIS_MODULE,
