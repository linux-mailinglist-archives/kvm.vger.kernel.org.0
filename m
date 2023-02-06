Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CE8868C018
	for <lists+kvm@lfdr.de>; Mon,  6 Feb 2023 15:30:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229528AbjBFOav (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Feb 2023 09:30:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231358AbjBFOas (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Feb 2023 09:30:48 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E125F1D900;
        Mon,  6 Feb 2023 06:30:39 -0800 (PST)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 316Dqegl027235;
        Mon, 6 Feb 2023 14:30:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Xmlhwlv8rTLONN0h2XOQ+YzPsB8oOSdEijMjpmTq+IU=;
 b=b/uAGfP226KnCYpZPQJjuRgy8l5SKoWy0DqYVC6UWJuxGIgpC2kBcFk5J3ehD8ewcN9I
 cAaKSSgFUB0l5hTuwGkDU6kSpwcCsHueMTQY+yA+76seDX0Yfna7wJC0jIl6Ry1af5gf
 yABh5dO+hyFz7pUR6x0S7Sgqb8Fg11kOW9W4DLhWtEGlm6xLXRAKu5z4jiy1TNY4qeHe
 M9XdQVSEcdbANQKSfh+QflocP8A/b5ljxUAN0GnEhVSygt4uH1YUIsK3ajtpgNT/s6ze
 UAw01HptdDPMYdUm9zuggEKQ2nMuU8b/hso4aZ9zD0MowarkEug0vD8GkrdA++XXexpK Qw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nk2tbhcsp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Feb 2023 14:30:24 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 316EPxC2007225;
        Mon, 6 Feb 2023 14:30:23 GMT
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nk2tbhcrm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Feb 2023 14:30:23 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 316C5AQJ027767;
        Mon, 6 Feb 2023 14:30:22 GMT
Received: from smtprelay01.wdc07v.mail.ibm.com ([9.208.129.119])
        by ppma02wdc.us.ibm.com (PPS) with ESMTPS id 3nhf07k4hr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Feb 2023 14:30:22 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
        by smtprelay01.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 316EUK6631654544
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 6 Feb 2023 14:30:20 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8A7BB58059;
        Mon,  6 Feb 2023 14:30:20 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 261CC5805D;
        Mon,  6 Feb 2023 14:30:18 +0000 (GMT)
Received: from [9.65.214.209] (unknown [9.65.214.209])
        by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Mon,  6 Feb 2023 14:30:18 +0000 (GMT)
Message-ID: <c5e32a7c-707c-d646-db1e-c1f0124c05a3@linux.ibm.com>
Date:   Mon, 6 Feb 2023 09:30:17 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH v4 1/2] vfio: fix deadlock between group lock and kvm lock
Content-Language: en-US
To:     Matthew Rosato <mjrosato@linux.ibm.com>,
        alex.williamson@redhat.com, pbonzini@redhat.com,
        yi.l.liu@intel.com, jgg@nvidia.com
Cc:     cohuck@redhat.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, david@redhat.com, jjherne@linux.ibm.com,
        pasic@linux.ibm.com, zhenyuw@linux.intel.com, zhi.a.wang@intel.com,
        seanjc@google.com, kevin.tian@intel.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
References: <20230203215027.151988-1-mjrosato@linux.ibm.com>
 <20230203215027.151988-2-mjrosato@linux.ibm.com>
From:   Anthony Krowiak <akrowiak@linux.ibm.com>
In-Reply-To: <20230203215027.151988-2-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ovFxLcZ9j84kNjr3bREE05JEc3DIUxfB
X-Proofpoint-GUID: iFuVjfRUGoERPpPhtA3RZ3j8FOmGGoHu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-06_07,2023-02-06_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 impostorscore=0
 mlxlogscore=999 lowpriorityscore=0 adultscore=0 malwarescore=0
 suspectscore=0 mlxscore=0 priorityscore=1501 clxscore=1015 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302060121
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Tested-by: Tony Krowiak <akrowiak@linux.ibm.com>

On 2/3/23 4:50 PM, Matthew Rosato wrote:
> After 51cdc8bc120e, we have another deadlock scenario between the
> kvm->lock and the vfio group_lock with two different codepaths acquiring
> the locks in different order.  Specifically in vfio_open_device, vfio
> holds the vfio group_lock when issuing device->ops->open_device but some
> drivers (like vfio-ap) need to acquire kvm->lock during their open_device
> routine;  Meanwhile, kvm_vfio_release will acquire the kvm->lock first
> before calling vfio_file_set_kvm which will acquire the vfio group_lock.
>
> To resolve this, let's remove the need for the vfio group_lock from the
> kvm_vfio_release codepath.  This is done by introducing a new spinlock to
> protect modifications to the vfio group kvm pointer, and acquiring a kvm
> ref from within vfio while holding this spinlock, with the reference held
> until the last close for the device in question.
>
> Fixes: 51cdc8bc120e ("kvm/vfio: Fix potential deadlock on vfio group_lock")
> Reported-by: Anthony Krowiak <akrowiak@linux.ibm.com>
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>   drivers/vfio/group.c     | 44 +++++++++++++++++++++++-----
>   drivers/vfio/vfio.h      | 15 ++++++++++
>   drivers/vfio/vfio_main.c | 63 +++++++++++++++++++++++++++++++++++-----
>   include/linux/vfio.h     |  2 +-
>   4 files changed, 109 insertions(+), 15 deletions(-)
>
> diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
> index bb24b2f0271e..98621ac082f0 100644
> --- a/drivers/vfio/group.c
> +++ b/drivers/vfio/group.c
> @@ -154,6 +154,18 @@ static int vfio_group_ioctl_set_container(struct vfio_group *group,
>   	return ret;
>   }
>   
> +static void vfio_device_group_get_kvm_safe(struct vfio_device *device)
> +{
> +	spin_lock(&device->group->kvm_ref_lock);
> +	if (!device->group->kvm)
> +		goto unlock;
> +
> +	_vfio_device_get_kvm_safe(device, device->group->kvm);
> +
> +unlock:
> +	spin_unlock(&device->group->kvm_ref_lock);
> +}
> +
>   static int vfio_device_group_open(struct vfio_device *device)
>   {
>   	int ret;
> @@ -164,13 +176,23 @@ static int vfio_device_group_open(struct vfio_device *device)
>   		goto out_unlock;
>   	}
>   
> +	mutex_lock(&device->dev_set->lock);
> +
>   	/*
> -	 * Here we pass the KVM pointer with the group under the lock.  If the
> -	 * device driver will use it, it must obtain a reference and release it
> -	 * during close_device.
> +	 * Before the first device open, get the KVM pointer currently
> +	 * associated with the group (if there is one) and obtain a reference
> +	 * now that will be held until the open_count reaches 0 again.  Save
> +	 * the pointer in the device for use by drivers.
>   	 */
> -	ret = vfio_device_open(device, device->group->iommufd,
> -			       device->group->kvm);
> +	if (device->open_count == 0)
> +		vfio_device_group_get_kvm_safe(device);
> +
> +	ret = vfio_device_open(device, device->group->iommufd, device->kvm);
> +
> +	if (device->open_count == 0)
> +		vfio_device_put_kvm(device);
> +
> +	mutex_unlock(&device->dev_set->lock);
>   
>   out_unlock:
>   	mutex_unlock(&device->group->group_lock);
> @@ -180,7 +202,14 @@ static int vfio_device_group_open(struct vfio_device *device)
>   void vfio_device_group_close(struct vfio_device *device)
>   {
>   	mutex_lock(&device->group->group_lock);
> +	mutex_lock(&device->dev_set->lock);
> +
>   	vfio_device_close(device, device->group->iommufd);
> +
> +	if (device->open_count == 0)
> +		vfio_device_put_kvm(device);
> +
> +	mutex_unlock(&device->dev_set->lock);
>   	mutex_unlock(&device->group->group_lock);
>   }
>   
> @@ -450,6 +479,7 @@ static struct vfio_group *vfio_group_alloc(struct iommu_group *iommu_group,
>   
>   	refcount_set(&group->drivers, 1);
>   	mutex_init(&group->group_lock);
> +	spin_lock_init(&group->kvm_ref_lock);
>   	INIT_LIST_HEAD(&group->device_list);
>   	mutex_init(&group->device_lock);
>   	group->iommu_group = iommu_group;
> @@ -803,9 +833,9 @@ void vfio_file_set_kvm(struct file *file, struct kvm *kvm)
>   	if (!vfio_file_is_group(file))
>   		return;
>   
> -	mutex_lock(&group->group_lock);
> +	spin_lock(&group->kvm_ref_lock);
>   	group->kvm = kvm;
> -	mutex_unlock(&group->group_lock);
> +	spin_unlock(&group->kvm_ref_lock);
>   }
>   EXPORT_SYMBOL_GPL(vfio_file_set_kvm);
>   
> diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
> index f8219a438bfb..24d6cd285945 100644
> --- a/drivers/vfio/vfio.h
> +++ b/drivers/vfio/vfio.h
> @@ -74,6 +74,7 @@ struct vfio_group {
>   	struct file			*opened_file;
>   	struct blocking_notifier_head	notifier;
>   	struct iommufd_ctx		*iommufd;
> +	spinlock_t			kvm_ref_lock;
>   };
>   
>   int vfio_device_set_group(struct vfio_device *device,
> @@ -251,4 +252,18 @@ extern bool vfio_noiommu __read_mostly;
>   enum { vfio_noiommu = false };
>   #endif
>   
> +#ifdef CONFIG_HAVE_KVM
> +void _vfio_device_get_kvm_safe(struct vfio_device *device, struct kvm *kvm);
> +void vfio_device_put_kvm(struct vfio_device *device);
> +#else
> +static inline void _vfio_device_get_kvm_safe(struct vfio_device *device,
> +					     struct kvm *kvm)
> +{
> +}
> +
> +static inline void vfio_device_put_kvm(struct vfio_device *device)
> +{
> +}
> +#endif
> +
>   #endif
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index 5177bb061b17..28c47cd6a6b5 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -16,6 +16,9 @@
>   #include <linux/fs.h>
>   #include <linux/idr.h>
>   #include <linux/iommu.h>
> +#ifdef CONFIG_HAVE_KVM
> +#include <linux/kvm_host.h>
> +#endif
>   #include <linux/list.h>
>   #include <linux/miscdevice.h>
>   #include <linux/module.h>
> @@ -338,6 +341,55 @@ void vfio_unregister_group_dev(struct vfio_device *device)
>   }
>   EXPORT_SYMBOL_GPL(vfio_unregister_group_dev);
>   
> +#ifdef CONFIG_HAVE_KVM
> +void _vfio_device_get_kvm_safe(struct vfio_device *device, struct kvm *kvm)
> +{
> +	void (*pfn)(struct kvm *kvm);
> +	bool (*fn)(struct kvm *kvm);
> +	bool ret;
> +
> +	lockdep_assert_held(&device->dev_set->lock);
> +
> +	pfn = symbol_get(kvm_put_kvm);
> +	if (WARN_ON(!pfn))
> +		return;
> +
> +	fn = symbol_get(kvm_get_kvm_safe);
> +	if (WARN_ON(!fn)) {
> +		symbol_put(kvm_put_kvm);
> +		return;
> +	}
> +
> +	ret = fn(kvm);
> +	symbol_put(kvm_get_kvm_safe);
> +	if (!ret) {
> +		symbol_put(kvm_put_kvm);
> +		return;
> +	}
> +
> +	device->put_kvm = pfn;
> +	device->kvm = kvm;
> +}
> +
> +void vfio_device_put_kvm(struct vfio_device *device)
> +{
> +	lockdep_assert_held(&device->dev_set->lock);
> +
> +	if (!device->kvm)
> +		return;
> +
> +	if (WARN_ON(!device->put_kvm))
> +		goto clear;
> +
> +	device->put_kvm(device->kvm);
> +	device->put_kvm = NULL;
> +	symbol_put(kvm_put_kvm);
> +
> +clear:
> +	device->kvm = NULL;
> +}
> +#endif
> +
>   /* true if the vfio_device has open_device() called but not close_device() */
>   static bool vfio_assert_device_open(struct vfio_device *device)
>   {
> @@ -361,7 +413,6 @@ static int vfio_device_first_open(struct vfio_device *device,
>   	if (ret)
>   		goto err_module_put;
>   
> -	device->kvm = kvm;
>   	if (device->ops->open_device) {
>   		ret = device->ops->open_device(device);
>   		if (ret)
> @@ -370,7 +421,6 @@ static int vfio_device_first_open(struct vfio_device *device,
>   	return 0;
>   
>   err_unuse_iommu:
> -	device->kvm = NULL;
>   	if (iommufd)
>   		vfio_iommufd_unbind(device);
>   	else
> @@ -387,7 +437,6 @@ static void vfio_device_last_close(struct vfio_device *device,
>   
>   	if (device->ops->close_device)
>   		device->ops->close_device(device);
> -	device->kvm = NULL;
>   	if (iommufd)
>   		vfio_iommufd_unbind(device);
>   	else
> @@ -400,14 +449,14 @@ int vfio_device_open(struct vfio_device *device,
>   {
>   	int ret = 0;
>   
> -	mutex_lock(&device->dev_set->lock);
> +	lockdep_assert_held(&device->dev_set->lock);
> +
>   	device->open_count++;
>   	if (device->open_count == 1) {
>   		ret = vfio_device_first_open(device, iommufd, kvm);
>   		if (ret)
>   			device->open_count--;
>   	}
> -	mutex_unlock(&device->dev_set->lock);
>   
>   	return ret;
>   }
> @@ -415,12 +464,12 @@ int vfio_device_open(struct vfio_device *device,
>   void vfio_device_close(struct vfio_device *device,
>   		       struct iommufd_ctx *iommufd)
>   {
> -	mutex_lock(&device->dev_set->lock);
> +	lockdep_assert_held(&device->dev_set->lock);
> +
>   	vfio_assert_device_open(device);
>   	if (device->open_count == 1)
>   		vfio_device_last_close(device, iommufd);
>   	device->open_count--;
> -	mutex_unlock(&device->dev_set->lock);
>   }
>   
>   /*
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index 35be78e9ae57..87ff862ff555 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -46,7 +46,6 @@ struct vfio_device {
>   	struct vfio_device_set *dev_set;
>   	struct list_head dev_set_list;
>   	unsigned int migration_flags;
> -	/* Driver must reference the kvm during open_device or never touch it */
>   	struct kvm *kvm;
>   
>   	/* Members below here are private, not for driver use */
> @@ -58,6 +57,7 @@ struct vfio_device {
>   	struct list_head group_next;
>   	struct list_head iommu_entry;
>   	struct iommufd_access *iommufd_access;
> +	void (*put_kvm)(struct kvm *kvm);
>   #if IS_ENABLED(CONFIG_IOMMUFD)
>   	struct iommufd_device *iommufd_device;
>   	struct iommufd_ctx *iommufd_ictx;
