Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D2EB53CBD5
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 16:55:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245243AbiFCOzi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jun 2022 10:55:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230468AbiFCOzg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jun 2022 10:55:36 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8B2D3A5C7;
        Fri,  3 Jun 2022 07:55:34 -0700 (PDT)
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 253EcxLG004047;
        Fri, 3 Jun 2022 14:55:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=kxMEvrmyuB2mCIECNuGYXLO1HRZlORzOer6e116ByhA=;
 b=hpxC4lcULcaH6n9z3AAksbyGix3ehC7ZgWwUW/lLzuEEnkXZAOWnMCmEkEWiPhwucBRj
 1iwMvo9VADkXLFQNa9QZDXM7py0zyzAH+rfTym3wNE96i+MRMFk3+Q8MOBnZIVRhpMA+
 zLU9IkchaDzxuSOClGLPNgfshcHD0RGvpVDY7Lbl+PHfw429+yjGDBuouVeg/omDpm9u
 gwcroZZtzUx+lHiA/WAEiggv2arTsIKbSlaDxnw+RcCkrwYX6dpmh4ubVPKlWC4PZcYK
 JtKMQ5CQT0Tb4aOaUG+AOyZw2H2zpo67kSbB3x0rZNSHQsLttqp79Mn7rgF8XpIDArFq XA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gfgg8crck-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Jun 2022 14:55:26 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 253EjTaR007074;
        Fri, 3 Jun 2022 14:55:26 GMT
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gfgg8crcb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Jun 2022 14:55:26 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 253Ep41Y003161;
        Fri, 3 Jun 2022 14:55:25 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma02dal.us.ibm.com with ESMTP id 3gd1adj8sd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Jun 2022 14:55:25 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 253EtOwk27066634
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 3 Jun 2022 14:55:24 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5508AAE063;
        Fri,  3 Jun 2022 14:55:24 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8D8BFAE064;
        Fri,  3 Jun 2022 14:55:23 +0000 (GMT)
Received: from [9.160.55.57] (unknown [9.160.55.57])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri,  3 Jun 2022 14:55:23 +0000 (GMT)
Message-ID: <da388736-9bca-bcb7-701b-c34748b0d7b6@linux.ibm.com>
Date:   Fri, 3 Jun 2022 10:55:23 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v1 13/18] vfio/mdev: Consolidate all the device_api sysfs
 into the core code
Content-Language: en-US
To:     Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Halil Pasic <pasic@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Kirti Wankhede <kwankhede@nvidia.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        intel-gvt-dev@lists.freedesktop.org
References: <20220602171948.2790690-1-farman@linux.ibm.com>
 <20220602171948.2790690-14-farman@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
In-Reply-To: <20220602171948.2790690-14-farman@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ueWDmYA9hEn-ZFWlR7YNsyzxxFevPOVs
X-Proofpoint-GUID: zKpxR9rExxX-Ls_oFRkq1s8E2SrCZtZd
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-03_05,2022-06-03_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 clxscore=1011 impostorscore=0 lowpriorityscore=0 malwarescore=0
 bulkscore=0 mlxlogscore=999 mlxscore=0 adultscore=0 phishscore=0
 suspectscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206030062
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reviewed-by: Tony Krowiak <akrowiak@linux.ibm.com>

On 6/2/22 1:19 PM, Eric Farman wrote:
> From: Jason Gunthorpe <jgg@nvidia.com>
>
> Every driver just emits a static string, simply feed it through the ops
> and provide a standard sysfs show function.
>
> Cc: Kirti Wankhede <kwankhede@nvidia.com>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Zhenyu Wang <zhenyuw@linux.intel.com>
> Cc: Zhi Wang <zhi.a.wang@intel.com>
> Cc: Tony Krowiak <akrowiak@linux.ibm.com>
> Cc: Jason Herne <jjherne@linux.ibm.com>
> Cc: intel-gvt-dev@lists.freedesktop.org
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Link: https://lore.kernel.org/r/6-v3-57c1502c62fd+2190-ccw_mdev_jgg@nvidia.com/
> [farman: added Cc: tags]
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
>   .../driver-api/vfio-mediated-device.rst       |  4 ++-
>   drivers/gpu/drm/i915/gvt/kvmgt.c              |  9 +------
>   drivers/s390/cio/vfio_ccw_ops.c               |  9 +------
>   drivers/s390/crypto/vfio_ap_ops.c             |  9 +------
>   drivers/vfio/mdev/mdev_core.c                 |  2 +-
>   drivers/vfio/mdev/mdev_sysfs.c                | 27 ++++++++++++++++---
>   include/linux/mdev.h                          |  7 ++---
>   samples/vfio-mdev/mbochs.c                    |  9 +------
>   samples/vfio-mdev/mdpy.c                      |  9 +------
>   samples/vfio-mdev/mtty.c                      | 10 +------
>   10 files changed, 36 insertions(+), 59 deletions(-)
>
> diff --git a/Documentation/driver-api/vfio-mediated-device.rst b/Documentation/driver-api/vfio-mediated-device.rst
> index 9f26079cacae..f410a1cd98bb 100644
> --- a/Documentation/driver-api/vfio-mediated-device.rst
> +++ b/Documentation/driver-api/vfio-mediated-device.rst
> @@ -137,6 +137,7 @@ The structures in the mdev_parent_ops structure are as follows:
>   * mdev_attr_groups: attributes of the mediated device
>   * supported_config: attributes to define supported configurations
>   * device_driver: device driver to bind for mediated device instances
> +* device_api: String to pass through the sysfs file below
>   
>   The mdev_parent_ops also still has various functions pointers.  Theses exist
>   for historical reasons only and shall not be used for new drivers.
> @@ -225,7 +226,8 @@ Directories and files under the sysfs for Each Physical Device
>   * device_api
>   
>     This attribute should show which device API is being created, for example,
> -  "vfio-pci" for a PCI device.
> +  "vfio-pci" for a PCI device. The core code maintins this sysfs using the
> +  device_api member of mdev_parent_ops.
>   
>   * available_instances
>   
> diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
> index 057ec4490104..752d7a1211e6 100644
> --- a/drivers/gpu/drm/i915/gvt/kvmgt.c
> +++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
> @@ -163,12 +163,6 @@ static ssize_t available_instances_show(struct mdev_type *mtype,
>   	return sprintf(buf, "%u\n", num);
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
> @@ -202,13 +196,11 @@ static ssize_t name_show(struct mdev_type *mtype,
>   }
>   
>   static MDEV_TYPE_ATTR_RO(available_instances);
> -static MDEV_TYPE_ATTR_RO(device_api);
>   static MDEV_TYPE_ATTR_RO(description);
>   static MDEV_TYPE_ATTR_RO(name);
>   
>   static struct attribute *gvt_type_attrs[] = {
>   	&mdev_type_attr_available_instances.attr,
> -	&mdev_type_attr_device_api.attr,
>   	&mdev_type_attr_description.attr,
>   	&mdev_type_attr_name.attr,
>   	NULL,
> @@ -1767,6 +1759,7 @@ static const struct attribute_group *intel_vgpu_groups[] = {
>   
>   static struct mdev_parent_ops intel_vgpu_ops = {
>   	.mdev_attr_groups       = intel_vgpu_groups,
> +	.device_api		= VFIO_DEVICE_API_PCI_STRING,
>   	.create			= intel_vgpu_create,
>   	.remove			= intel_vgpu_remove,
>   
> diff --git a/drivers/s390/cio/vfio_ccw_ops.c b/drivers/s390/cio/vfio_ccw_ops.c
> index 2afb8f13739f..6793c8b3c58b 100644
> --- a/drivers/s390/cio/vfio_ccw_ops.c
> +++ b/drivers/s390/cio/vfio_ccw_ops.c
> @@ -66,13 +66,6 @@ static ssize_t name_show(struct mdev_type *mtype,
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
> @@ -86,7 +79,6 @@ static MDEV_TYPE_ATTR_RO(available_instances);
>   
>   static struct attribute *mdev_types_attrs[] = {
>   	&mdev_type_attr_name.attr,
> -	&mdev_type_attr_device_api.attr,
>   	&mdev_type_attr_available_instances.attr,
>   	NULL,
>   };
> @@ -644,5 +636,6 @@ struct mdev_driver vfio_ccw_mdev_driver = {
>   const struct mdev_parent_ops vfio_ccw_mdev_ops = {
>   	.owner			= THIS_MODULE,
>   	.device_driver		= &vfio_ccw_mdev_driver,
> +	.device_api		= VFIO_DEVICE_API_CCW_STRING,
>   	.supported_type_groups  = mdev_type_groups,
>   };
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index 6e08d04b605d..838b1a3eac8a 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -530,17 +530,9 @@ static ssize_t available_instances_show(struct mdev_type *mtype,
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
>   
>   static struct attribute *vfio_ap_mdev_type_attrs[] = {
>   	&mdev_type_attr_name.attr,
> -	&mdev_type_attr_device_api.attr,
>   	&mdev_type_attr_available_instances.attr,
>   	NULL,
>   };
> @@ -1501,6 +1493,7 @@ static struct mdev_driver vfio_ap_matrix_driver = {
>   static const struct mdev_parent_ops vfio_ap_matrix_ops = {
>   	.owner			= THIS_MODULE,
>   	.device_driver		= &vfio_ap_matrix_driver,
> +	.device_api		= VFIO_DEVICE_API_AP_STRING,
>   	.supported_type_groups	= vfio_ap_mdev_type_groups,
>   };
>   
> diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
> index b314101237fe..c3018e8e6d32 100644
> --- a/drivers/vfio/mdev/mdev_core.c
> +++ b/drivers/vfio/mdev/mdev_core.c
> @@ -129,7 +129,7 @@ int mdev_register_device(struct device *dev, const struct mdev_parent_ops *ops)
>   	char *envp[] = { env_string, NULL };
>   
>   	/* check for mandatory ops */
> -	if (!ops || !ops->supported_type_groups)
> +	if (!ops || !ops->supported_type_groups || !ops->device_api)
>   		return -EINVAL;
>   	if (!ops->device_driver && (!ops->create || !ops->remove))
>   		return -EINVAL;
> diff --git a/drivers/vfio/mdev/mdev_sysfs.c b/drivers/vfio/mdev/mdev_sysfs.c
> index f5cf1931c54e..d4b99440d19e 100644
> --- a/drivers/vfio/mdev/mdev_sysfs.c
> +++ b/drivers/vfio/mdev/mdev_sysfs.c
> @@ -74,9 +74,30 @@ static ssize_t create_store(struct mdev_type *mtype,
>   
>   	return count;
>   }
> -
>   static MDEV_TYPE_ATTR_WO(create);
>   
> +static ssize_t device_api_show(struct mdev_type *mtype,
> +			       struct mdev_type_attribute *attr, char *buf)
> +{
> +	return sysfs_emit(buf, "%s\n", mtype->parent->ops->device_api);
> +}
> +static MDEV_TYPE_ATTR_RO(device_api);
> +
> +static struct attribute *mdev_types_std_attrs[] = {
> +	&mdev_type_attr_create.attr,
> +	&mdev_type_attr_device_api.attr,
> +	NULL,
> +};
> +
> +static struct attribute_group mdev_type_std_group = {
> +	.attrs = mdev_types_std_attrs,
> +};
> +
> +static const struct attribute_group *mdev_type_groups[] = {
> +	&mdev_type_std_group,
> +	NULL,
> +};
> +
>   static void mdev_type_release(struct kobject *kobj)
>   {
>   	struct mdev_type *type = to_mdev_type(kobj);
> @@ -123,7 +144,7 @@ static struct mdev_type *add_mdev_supported_type(struct mdev_parent *parent,
>   		return ERR_PTR(ret);
>   	}
>   
> -	ret = sysfs_create_file(&type->kobj, &mdev_type_attr_create.attr);
> +	ret = sysfs_create_groups(&type->kobj, mdev_type_groups);
>   	if (ret)
>   		goto attr_create_failed;
>   
> @@ -144,7 +165,7 @@ static struct mdev_type *add_mdev_supported_type(struct mdev_parent *parent,
>   attrs_failed:
>   	kobject_put(type->devices_kobj);
>   attr_devices_failed:
> -	sysfs_remove_file(&type->kobj, &mdev_type_attr_create.attr);
> +	sysfs_remove_groups(&type->kobj, mdev_type_groups);
>   attr_create_failed:
>   	kobject_del(&type->kobj);
>   	kobject_put(&type->kobj);
> diff --git a/include/linux/mdev.h b/include/linux/mdev.h
> index a5788f592817..14655215417b 100644
> --- a/include/linux/mdev.h
> +++ b/include/linux/mdev.h
> @@ -36,6 +36,7 @@ struct device *mtype_get_parent_dev(struct mdev_type *mtype);
>    *
>    * @owner:		The module owner.
>    * @device_driver:	Which device driver to probe() on newly created devices
> + * @device_api:		String to return for the device_api sysfs
>    * @dev_attr_groups:	Attributes of the parent device.
>    * @mdev_attr_groups:	Attributes of the mediated device.
>    * @supported_type_groups: Attributes to define supported types. It is mandatory
> @@ -80,6 +81,7 @@ struct device *mtype_get_parent_dev(struct mdev_type *mtype);
>   struct mdev_parent_ops {
>   	struct module   *owner;
>   	struct mdev_driver *device_driver;
> +	const char *device_api;
>   	const struct attribute_group **dev_attr_groups;
>   	const struct attribute_group **mdev_attr_groups;
>   	struct attribute_group **supported_type_groups;
> @@ -108,11 +110,6 @@ struct mdev_type_attribute {
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
> diff --git a/samples/vfio-mdev/mbochs.c b/samples/vfio-mdev/mbochs.c
> index e90c8552cc31..8d3ae97d9d6e 100644
> --- a/samples/vfio-mdev/mbochs.c
> +++ b/samples/vfio-mdev/mbochs.c
> @@ -1358,17 +1358,9 @@ static ssize_t available_instances_show(struct mdev_type *mtype,
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
>   static struct attribute *mdev_types_attrs[] = {
>   	&mdev_type_attr_name.attr,
>   	&mdev_type_attr_description.attr,
> -	&mdev_type_attr_device_api.attr,
>   	&mdev_type_attr_available_instances.attr,
>   	NULL,
>   };
> @@ -1417,6 +1409,7 @@ static struct mdev_driver mbochs_driver = {
>   static const struct mdev_parent_ops mdev_fops = {
>   	.owner			= THIS_MODULE,
>   	.device_driver		= &mbochs_driver,
> +	.device_api		= VFIO_DEVICE_API_PCI_STRING,
>   	.supported_type_groups	= mdev_type_groups,
>   };
>   
> diff --git a/samples/vfio-mdev/mdpy.c b/samples/vfio-mdev/mdpy.c
> index fe5d43e797b6..402a7ebe6563 100644
> --- a/samples/vfio-mdev/mdpy.c
> +++ b/samples/vfio-mdev/mdpy.c
> @@ -670,17 +670,9 @@ static ssize_t available_instances_show(struct mdev_type *mtype,
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
>   static struct attribute *mdev_types_attrs[] = {
>   	&mdev_type_attr_name.attr,
>   	&mdev_type_attr_description.attr,
> -	&mdev_type_attr_device_api.attr,
>   	&mdev_type_attr_available_instances.attr,
>   	NULL,
>   };
> @@ -728,6 +720,7 @@ static struct mdev_driver mdpy_driver = {
>   static const struct mdev_parent_ops mdev_fops = {
>   	.owner			= THIS_MODULE,
>   	.device_driver          = &mdpy_driver,
> +	.device_api		= VFIO_DEVICE_API_PCI_STRING,
>   	.supported_type_groups	= mdev_type_groups,
>   };
>   
> diff --git a/samples/vfio-mdev/mtty.c b/samples/vfio-mdev/mtty.c
> index a0e1a469bd47..5dc1b6a4c02c 100644
> --- a/samples/vfio-mdev/mtty.c
> +++ b/samples/vfio-mdev/mtty.c
> @@ -1281,17 +1281,8 @@ static ssize_t available_instances_show(struct mdev_type *mtype,
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
>   static struct attribute *mdev_types_attrs[] = {
>   	&mdev_type_attr_name.attr,
> -	&mdev_type_attr_device_api.attr,
>   	&mdev_type_attr_available_instances.attr,
>   	NULL,
>   };
> @@ -1333,6 +1324,7 @@ static struct mdev_driver mtty_driver = {
>   static const struct mdev_parent_ops mdev_fops = {
>   	.owner                  = THIS_MODULE,
>   	.device_driver		= &mtty_driver,
> +	.device_api		= VFIO_DEVICE_API_PCI_STRING,
>   	.dev_attr_groups        = mtty_dev_groups,
>   	.supported_type_groups  = mdev_type_groups,
>   };

