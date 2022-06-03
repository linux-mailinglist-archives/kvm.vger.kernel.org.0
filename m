Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7982753CBF2
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 17:03:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245306AbiFCPDN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jun 2022 11:03:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238431AbiFCPDL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jun 2022 11:03:11 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 375D564D0;
        Fri,  3 Jun 2022 08:03:09 -0700 (PDT)
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 253Ehxj4002882;
        Fri, 3 Jun 2022 15:03:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=ZtFUqvTqQrVNSBKmu+T4KuPTnazRttz1/sSoL6Ugfrk=;
 b=H4YwIoA+uqEaZ8DRhE4fO6TdFuzuMA9KCgp0q7HWOeECuX6igbOENFjElV16reAABxUY
 xwt13+btHrsSfoknchwe4EZfh+PSjxJ0MqXPa6SUWx4t/x3PnU/PfEiyxFEpS8ySpw2D
 Eh8d28/IQizt1fCe4UYT4SAXLQvjMjRUeba1YeYBzkD7sEJJkRVRowix8lboex7Pxy+D
 UGFCxH3ip/v0AdGPQybueqeiPhEzCWsfFHKuabmxDFtJ8iZ7cqw5CVp81pokmAyiPix6
 CLnl/6ICjKh72vT9f0q2jtOxrweiSHRgklR+nN6EUXXX7z20HXK75xsBJpAVflWIua3v Cg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gfgg8cwk7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Jun 2022 15:03:00 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 253El3Q6022201;
        Fri, 3 Jun 2022 15:03:00 GMT
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gfgg8cwjr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Jun 2022 15:02:59 +0000
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 253Eo5cb020328;
        Fri, 3 Jun 2022 15:02:58 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma03wdc.us.ibm.com with ESMTP id 3gbc9w202n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Jun 2022 15:02:58 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 253F2vTE29491526
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 3 Jun 2022 15:02:57 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C8E2DAE05F;
        Fri,  3 Jun 2022 15:02:57 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 18163AE06B;
        Fri,  3 Jun 2022 15:02:57 +0000 (GMT)
Received: from [9.160.55.57] (unknown [9.160.55.57])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri,  3 Jun 2022 15:02:57 +0000 (GMT)
Message-ID: <c85dc6c6-1f23-d850-3d9c-79874604b9a2@linux.ibm.com>
Date:   Fri, 3 Jun 2022 11:02:56 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v1 14/18] vfio/mdev: Add mdev available instance checking
 to the core
Content-Language: en-US
To:     Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Halil Pasic <pasic@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Kirti Wankhede <kwankhede@nvidia.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Jason Herne <jjherne@linux.ibm.com>,
        Christoph Hellwig <hch@lst.de>
References: <20220602171948.2790690-1-farman@linux.ibm.com>
 <20220602171948.2790690-15-farman@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
In-Reply-To: <20220602171948.2790690-15-farman@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: COFDk2vZODLipdNIjhYMc9V3LjcixVxK
X-Proofpoint-GUID: dcarqX4iSsncP8NC_txR8-1-d3yBQy7H
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-03_05,2022-06-03_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 clxscore=1015 impostorscore=0 lowpriorityscore=0 malwarescore=0
 bulkscore=0 mlxlogscore=999 mlxscore=0 adultscore=0 phishscore=0
 suspectscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206030067
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
> Many of the mdev drivers use a simple counter for keeping track of the
> available instances. Move this code to the core code and store the counter
> in the mdev_type. Implement it using correct locking, fixing mdpy.
>
> Drivers provide a get_available() callback to set the number of available
> instances for their mtypes which is fixed at registration time. The core
> provides a standard sysfs attribute to return the available_instances.
>
> Cc: Kirti Wankhede <kwankhede@nvidia.com>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Tony Krowiak <akrowiak@linux.ibm.com>
> Cc: Jason Herne <jjherne@linux.ibm.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Link: https://lore.kernel.org/r/7-v3-57c1502c62fd+2190-ccw_mdev_jgg@nvidia.com/
> [farman: added Cc: tags]
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
>   .../driver-api/vfio-mediated-device.rst       |  4 +-
>   drivers/s390/cio/vfio_ccw_drv.c               |  1 -
>   drivers/s390/cio/vfio_ccw_ops.c               | 26 ++++---------
>   drivers/s390/cio/vfio_ccw_private.h           |  2 -
>   drivers/s390/crypto/vfio_ap_ops.c             | 32 ++++------------
>   drivers/s390/crypto/vfio_ap_private.h         |  2 -
>   drivers/vfio/mdev/mdev_core.c                 | 11 +++++-
>   drivers/vfio/mdev/mdev_private.h              |  2 +
>   drivers/vfio/mdev/mdev_sysfs.c                | 37 +++++++++++++++++++
>   include/linux/mdev.h                          |  2 +
>   samples/vfio-mdev/mdpy.c                      | 22 +++--------
>   11 files changed, 76 insertions(+), 65 deletions(-)
>
> diff --git a/Documentation/driver-api/vfio-mediated-device.rst b/Documentation/driver-api/vfio-mediated-device.rst
> index f410a1cd98bb..a4f7f1362fa8 100644
> --- a/Documentation/driver-api/vfio-mediated-device.rst
> +++ b/Documentation/driver-api/vfio-mediated-device.rst
> @@ -106,6 +106,7 @@ structure to represent a mediated device's driver::
>   	     int  (*probe)  (struct mdev_device *dev);
>   	     void (*remove) (struct mdev_device *dev);
>   	     struct device_driver    driver;
> +	     unsigned int (*get_available)(struct mdev_type *mtype);
>        };
>   
>   A mediated bus driver for mdev should use this structure in the function calls
> @@ -232,7 +233,8 @@ Directories and files under the sysfs for Each Physical Device
>   * available_instances
>   
>     This attribute should show the number of devices of type <type-id> that can be
> -  created.
> +  created. Drivers can supply a get_available() function pointer to have the
> +  core code create and maintain this sysfs automatically.
>   
>   * [device]
>   
> diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
> index e4b285953a45..6dca35f3ceba 100644
> --- a/drivers/s390/cio/vfio_ccw_drv.c
> +++ b/drivers/s390/cio/vfio_ccw_drv.c
> @@ -147,7 +147,6 @@ static struct vfio_ccw_private *vfio_ccw_alloc_private(struct subchannel *sch)
>   	INIT_LIST_HEAD(&private->crw);
>   	INIT_WORK(&private->io_work, vfio_ccw_sch_io_todo);
>   	INIT_WORK(&private->crw_work, vfio_ccw_crw_todo);
> -	atomic_set(&private->avail, 1);
>   
>   	private->cp.guest_cp = kcalloc(CCWCHAIN_LEN_MAX, sizeof(struct ccw1),
>   				       GFP_KERNEL);
> diff --git a/drivers/s390/cio/vfio_ccw_ops.c b/drivers/s390/cio/vfio_ccw_ops.c
> index 6793c8b3c58b..60a4855e8ecb 100644
> --- a/drivers/s390/cio/vfio_ccw_ops.c
> +++ b/drivers/s390/cio/vfio_ccw_ops.c
> @@ -66,20 +66,9 @@ static ssize_t name_show(struct mdev_type *mtype,
>   }
>   static MDEV_TYPE_ATTR_RO(name);
>   
> -static ssize_t available_instances_show(struct mdev_type *mtype,
> -					struct mdev_type_attribute *attr,
> -					char *buf)
> -{
> -	struct vfio_ccw_private *private =
> -		dev_get_drvdata(mtype_get_parent_dev(mtype));
> -
> -	return sprintf(buf, "%d\n", atomic_read(&private->avail));
> -}
> -static MDEV_TYPE_ATTR_RO(available_instances);
>   
>   static struct attribute *mdev_types_attrs[] = {
>   	&mdev_type_attr_name.attr,
> -	&mdev_type_attr_available_instances.attr,
>   	NULL,
>   };
>   
> @@ -101,9 +90,6 @@ static int vfio_ccw_mdev_probe(struct mdev_device *mdev)
>   	if (private->state == VFIO_CCW_STATE_NOT_OPER)
>   		return -ENODEV;
>   
> -	if (atomic_dec_if_positive(&private->avail) < 0)
> -		return -EPERM;
> -
>   	memset(&private->vdev, 0, sizeof(private->vdev));
>   	vfio_init_group_dev(&private->vdev, &mdev->dev,
>   			    &vfio_ccw_dev_ops);
> @@ -115,13 +101,12 @@ static int vfio_ccw_mdev_probe(struct mdev_device *mdev)
>   
>   	ret = vfio_register_emulated_iommu_dev(&private->vdev);
>   	if (ret)
> -		goto err_atomic;
> +		goto err_init;
>   	dev_set_drvdata(&mdev->dev, private);
>   	return 0;
>   
> -err_atomic:
> +err_init:
>   	vfio_uninit_group_dev(&private->vdev);
> -	atomic_inc(&private->avail);
>   	return ret;
>   }
>   
> @@ -143,7 +128,6 @@ static void vfio_ccw_mdev_remove(struct mdev_device *mdev)
>   	vfio_ccw_fsm_event(private, VFIO_CCW_EVENT_CLOSE);
>   
>   	vfio_uninit_group_dev(&private->vdev);
> -	atomic_inc(&private->avail);
>   }
>   
>   static int vfio_ccw_mdev_open_device(struct vfio_device *vdev)
> @@ -614,6 +598,11 @@ static void vfio_ccw_mdev_request(struct vfio_device *vdev, unsigned int count)
>   	}
>   }
>   
> +static unsigned int vfio_ccw_get_available(struct mdev_type *mtype)
> +{
> +	return 1;
> +}
> +
>   static const struct vfio_device_ops vfio_ccw_dev_ops = {
>   	.open_device = vfio_ccw_mdev_open_device,
>   	.close_device = vfio_ccw_mdev_close_device,
> @@ -631,6 +620,7 @@ struct mdev_driver vfio_ccw_mdev_driver = {
>   	},
>   	.probe = vfio_ccw_mdev_probe,
>   	.remove = vfio_ccw_mdev_remove,
> +	.get_available = vfio_ccw_get_available,
>   };
>   
>   const struct mdev_parent_ops vfio_ccw_mdev_ops = {
> diff --git a/drivers/s390/cio/vfio_ccw_private.h b/drivers/s390/cio/vfio_ccw_private.h
> index 02a4a5edd00c..e568fd6bcf2a 100644
> --- a/drivers/s390/cio/vfio_ccw_private.h
> +++ b/drivers/s390/cio/vfio_ccw_private.h
> @@ -72,7 +72,6 @@ struct vfio_ccw_crw {
>    * @sch: pointer to the subchannel
>    * @state: internal state of the device
>    * @completion: synchronization helper of the I/O completion
> - * @avail: available for creating a mediated device
>    * @nb: notifier for vfio events
>    * @io_region: MMIO region to input/output I/O arguments/results
>    * @io_mutex: protect against concurrent update of I/O regions
> @@ -95,7 +94,6 @@ struct vfio_ccw_private {
>   	struct subchannel	*sch;
>   	int			state;
>   	struct completion	*completion;
> -	atomic_t		avail;
>   	struct notifier_block	nb;
>   	struct ccw_io_region	*io_region;
>   	struct mutex		io_mutex;
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index 838b1a3eac8a..4c62ba9c72d8 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -462,14 +462,9 @@ static int vfio_ap_mdev_probe(struct mdev_device *mdev)
>   	struct ap_matrix_mdev *matrix_mdev;
>   	int ret;
>   
> -	if ((atomic_dec_if_positive(&matrix_dev->available_instances) < 0))
> -		return -EPERM;
> -
>   	matrix_mdev = kzalloc(sizeof(*matrix_mdev), GFP_KERNEL);
> -	if (!matrix_mdev) {
> -		ret = -ENOMEM;
> -		goto err_dec_available;
> -	}
> +	if (!matrix_mdev)
> +		return -ENOMEM;
>   	vfio_init_group_dev(&matrix_mdev->vdev, &mdev->dev,
>   			    &vfio_ap_matrix_dev_ops);
>   
> @@ -492,8 +487,6 @@ static int vfio_ap_mdev_probe(struct mdev_device *mdev)
>   	mutex_unlock(&matrix_dev->lock);
>   	vfio_uninit_group_dev(&matrix_mdev->vdev);
>   	kfree(matrix_mdev);
> -err_dec_available:
> -	atomic_inc(&matrix_dev->available_instances);
>   	return ret;
>   }
>   
> @@ -509,7 +502,6 @@ static void vfio_ap_mdev_remove(struct mdev_device *mdev)
>   	mutex_unlock(&matrix_dev->lock);
>   	vfio_uninit_group_dev(&matrix_mdev->vdev);
>   	kfree(matrix_mdev);
> -	atomic_inc(&matrix_dev->available_instances);
>   }
>   
>   static ssize_t name_show(struct mdev_type *mtype,
> @@ -520,20 +512,8 @@ static ssize_t name_show(struct mdev_type *mtype,
>   
>   static MDEV_TYPE_ATTR_RO(name);
>   
> -static ssize_t available_instances_show(struct mdev_type *mtype,
> -					struct mdev_type_attribute *attr,
> -					char *buf)
> -{
> -	return sprintf(buf, "%d\n",
> -		       atomic_read(&matrix_dev->available_instances));
> -}
> -
> -static MDEV_TYPE_ATTR_RO(available_instances);
> -
> -
>   static struct attribute *vfio_ap_mdev_type_attrs[] = {
>   	&mdev_type_attr_name.attr,
> -	&mdev_type_attr_available_instances.attr,
>   	NULL,
>   };
>   
> @@ -1473,6 +1453,11 @@ static ssize_t vfio_ap_mdev_ioctl(struct vfio_device *vdev,
>   	return ret;
>   }
>   
> +static unsigned int vfio_ap_mdev_get_available(struct mdev_type *mtype)
> +{
> +	return MAX_ZDEV_ENTRIES_EXT;
> +}
> +
>   static const struct vfio_device_ops vfio_ap_matrix_dev_ops = {
>   	.open_device = vfio_ap_mdev_open_device,
>   	.close_device = vfio_ap_mdev_close_device,
> @@ -1488,6 +1473,7 @@ static struct mdev_driver vfio_ap_matrix_driver = {
>   	},
>   	.probe = vfio_ap_mdev_probe,
>   	.remove = vfio_ap_mdev_remove,
> +	.get_available = vfio_ap_mdev_get_available,
>   };
>   
>   static const struct mdev_parent_ops vfio_ap_matrix_ops = {
> @@ -1501,8 +1487,6 @@ int vfio_ap_mdev_register(void)
>   {
>   	int ret;
>   
> -	atomic_set(&matrix_dev->available_instances, MAX_ZDEV_ENTRIES_EXT);
> -
>   	ret = mdev_register_driver(&vfio_ap_matrix_driver);
>   	if (ret)
>   		return ret;
> diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
> index 648fcaf8104a..5c0cbf03074b 100644
> --- a/drivers/s390/crypto/vfio_ap_private.h
> +++ b/drivers/s390/crypto/vfio_ap_private.h
> @@ -29,7 +29,6 @@
>    * struct ap_matrix_dev - Contains the data for the matrix device.
>    *
>    * @device:	generic device structure associated with the AP matrix device
> - * @available_instances: number of mediated matrix devices that can be created
>    * @info:	the struct containing the output from the PQAP(QCI) instruction
>    * @mdev_list:	the list of mediated matrix devices created
>    * @lock:	mutex for locking the AP matrix device. This lock will be
> @@ -41,7 +40,6 @@
>    */
>   struct ap_matrix_dev {
>   	struct device device;
> -	atomic_t available_instances;
>   	struct ap_config_info info;
>   	struct list_head mdev_list;
>   	struct mutex lock;
> diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
> index c3018e8e6d32..bb27ca0db948 100644
> --- a/drivers/vfio/mdev/mdev_core.c
> +++ b/drivers/vfio/mdev/mdev_core.c
> @@ -25,7 +25,7 @@ static DEFINE_MUTEX(parent_list_lock);
>   static struct class_compat *mdev_bus_compat_class;
>   
>   static LIST_HEAD(mdev_list);
> -static DEFINE_MUTEX(mdev_list_lock);
> +DEFINE_MUTEX(mdev_list_lock);
>   
>   struct device *mdev_parent_dev(struct mdev_device *mdev)
>   {
> @@ -245,6 +245,7 @@ static void mdev_device_release(struct device *dev)
>   
>   	mutex_lock(&mdev_list_lock);
>   	list_del(&mdev->next);
> +	mdev->type->available++;
>   	mutex_unlock(&mdev_list_lock);
>   
>   	dev_dbg(&mdev->dev, "MDEV: destroying\n");
> @@ -268,6 +269,14 @@ int mdev_device_create(struct mdev_type *type, const guid_t *uuid)
>   		}
>   	}
>   
> +	if (drv && drv->get_available) {
> +		if (!type->available) {
> +			mutex_unlock(&mdev_list_lock);
> +			return -EUSERS;
> +		}
> +		type->available--;
> +	}
> +
>   	mdev = kzalloc(sizeof(*mdev), GFP_KERNEL);
>   	if (!mdev) {
>   		mutex_unlock(&mdev_list_lock);
> diff --git a/drivers/vfio/mdev/mdev_private.h b/drivers/vfio/mdev/mdev_private.h
> index afbad7b0a14a..83586b070233 100644
> --- a/drivers/vfio/mdev/mdev_private.h
> +++ b/drivers/vfio/mdev/mdev_private.h
> @@ -29,6 +29,7 @@ struct mdev_type {
>   	struct kobject *devices_kobj;
>   	struct mdev_parent *parent;
>   	struct list_head next;
> +	unsigned int available;
>   	unsigned int type_group_id;
>   };
>   
> @@ -38,6 +39,7 @@ struct mdev_type {
>   	container_of(_kobj, struct mdev_type, kobj)
>   
>   extern struct mdev_driver vfio_mdev_driver;
> +extern struct mutex mdev_list_lock;
>   
>   int  parent_create_sysfs_files(struct mdev_parent *parent);
>   void parent_remove_sysfs_files(struct mdev_parent *parent);
> diff --git a/drivers/vfio/mdev/mdev_sysfs.c b/drivers/vfio/mdev/mdev_sysfs.c
> index d4b99440d19e..b3129dfc27ef 100644
> --- a/drivers/vfio/mdev/mdev_sysfs.c
> +++ b/drivers/vfio/mdev/mdev_sysfs.c
> @@ -93,8 +93,41 @@ static struct attribute_group mdev_type_std_group = {
>   	.attrs = mdev_types_std_attrs,
>   };
>   
> +/* mdev_type attribute used by drivers that have an get_available() op */
> +static ssize_t available_instances_show(struct mdev_type *mtype,
> +					struct mdev_type_attribute *attr,
> +					char *buf)
> +{
> +	unsigned int available;
> +
> +	mutex_lock(&mdev_list_lock);
> +	available = mtype->available;
> +	mutex_unlock(&mdev_list_lock);
> +
> +	return sysfs_emit(buf, "%u\n", available);
> +}
> +static MDEV_TYPE_ATTR_RO(available_instances);
> +static umode_t available_instances_is_visible(struct kobject *kobj,
> +					      struct attribute *attr, int n)
> +{
> +	struct mdev_type *type = to_mdev_type(kobj);
> +
> +	if (!type->parent->ops->device_driver->get_available)
> +		return 0;
> +	return attr->mode;
> +}
> +static struct attribute *mdev_types_name_attrs[] = {
> +	&mdev_type_attr_available_instances.attr,
> +	NULL,
> +};
> +static struct attribute_group mdev_type_available_instances_group = {
> +	.attrs = mdev_types_name_attrs,
> +	.is_visible = available_instances_is_visible,
> +};
> +
>   static const struct attribute_group *mdev_type_groups[] = {
>   	&mdev_type_std_group,
> +	&mdev_type_available_instances_group,
>   	NULL,
>   };
>   
> @@ -136,6 +169,10 @@ static struct mdev_type *add_mdev_supported_type(struct mdev_parent *parent,
>   	mdev_get_parent(parent);
>   	type->type_group_id = type_group_id;
>   
> +	if (parent->ops->device_driver->get_available)
> +		type->available =
> +			parent->ops->device_driver->get_available(type);
> +
>   	ret = kobject_init_and_add(&type->kobj, &mdev_type_ktype, NULL,
>   				   "%s-%s", dev_driver_string(parent->dev),
>   				   group->name);
> diff --git a/include/linux/mdev.h b/include/linux/mdev.h
> index 14655215417b..0ce1bb3dabd0 100644
> --- a/include/linux/mdev.h
> +++ b/include/linux/mdev.h
> @@ -120,12 +120,14 @@ struct mdev_type_attribute {
>    * @probe: called when new device created
>    * @remove: called when device removed
>    * @driver: device driver structure
> + * @get_available: Return the max number of instances that can be created
>    *
>    **/
>   struct mdev_driver {
>   	int (*probe)(struct mdev_device *dev);
>   	void (*remove)(struct mdev_device *dev);
>   	struct device_driver driver;
> +	unsigned int (*get_available)(struct mdev_type *mtype);
>   };
>   
>   static inline void *mdev_get_drvdata(struct mdev_device *mdev)
> diff --git a/samples/vfio-mdev/mdpy.c b/samples/vfio-mdev/mdpy.c
> index 402a7ebe6563..d7da6ed35657 100644
> --- a/samples/vfio-mdev/mdpy.c
> +++ b/samples/vfio-mdev/mdpy.c
> @@ -84,7 +84,6 @@ static dev_t		mdpy_devt;
>   static struct class	*mdpy_class;
>   static struct cdev	mdpy_cdev;
>   static struct device	mdpy_dev;
> -static u32		mdpy_count;
>   static const struct vfio_device_ops mdpy_dev_ops;
>   
>   /* State of each mdev device */
> @@ -225,9 +224,6 @@ static int mdpy_probe(struct mdev_device *mdev)
>   	u32 fbsize;
>   	int ret;
>   
> -	if (mdpy_count >= max_devices)
> -		return -ENOMEM;
> -
>   	mdev_state = kzalloc(sizeof(struct mdev_state), GFP_KERNEL);
>   	if (mdev_state == NULL)
>   		return -ENOMEM;
> @@ -256,8 +252,6 @@ static int mdpy_probe(struct mdev_device *mdev)
>   	mdpy_create_config_space(mdev_state);
>   	mdpy_reset(mdev_state);
>   
> -	mdpy_count++;
> -
>   	ret = vfio_register_emulated_iommu_dev(&mdev_state->vdev);
>   	if (ret)
>   		goto err_mem;
> @@ -284,8 +278,6 @@ static void mdpy_remove(struct mdev_device *mdev)
>   	kfree(mdev_state->vconfig);
>   	vfio_uninit_group_dev(&mdev_state->vdev);
>   	kfree(mdev_state);
> -
> -	mdpy_count--;
>   }
>   
>   static ssize_t mdpy_read(struct vfio_device *vdev, char __user *buf,
> @@ -662,18 +654,10 @@ static ssize_t description_show(struct mdev_type *mtype,
>   }
>   static MDEV_TYPE_ATTR_RO(description);
>   
> -static ssize_t available_instances_show(struct mdev_type *mtype,
> -					struct mdev_type_attribute *attr,
> -					char *buf)
> -{
> -	return sprintf(buf, "%d\n", max_devices - mdpy_count);
> -}
> -static MDEV_TYPE_ATTR_RO(available_instances);
>   
>   static struct attribute *mdev_types_attrs[] = {
>   	&mdev_type_attr_name.attr,
>   	&mdev_type_attr_description.attr,
> -	&mdev_type_attr_available_instances.attr,
>   	NULL,
>   };
>   
> @@ -706,6 +690,11 @@ static const struct vfio_device_ops mdpy_dev_ops = {
>   	.mmap = mdpy_mmap,
>   };
>   
> +static unsigned int mdpy_get_available(struct mdev_type *mtype)
> +{
> +	return max_devices;
> +}
> +
>   static struct mdev_driver mdpy_driver = {
>   	.driver = {
>   		.name = "mdpy",
> @@ -715,6 +704,7 @@ static struct mdev_driver mdpy_driver = {
>   	},
>   	.probe = mdpy_probe,
>   	.remove	= mdpy_remove,
> +	.get_available = mdpy_get_available,
>   };
>   
>   static const struct mdev_parent_ops mdev_fops = {

