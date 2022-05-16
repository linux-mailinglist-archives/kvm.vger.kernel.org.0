Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7874A528D1C
	for <lists+kvm@lfdr.de>; Mon, 16 May 2022 20:31:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344879AbiEPSbj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 14:31:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344924AbiEPSbN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 14:31:13 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A5743E5CC;
        Mon, 16 May 2022 11:30:56 -0700 (PDT)
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24GHX032001172;
        Mon, 16 May 2022 18:30:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=NU7xIOSPC0Y44CEFU/QJwSPahboNVQlOckv1Zd/PAnI=;
 b=a1Xa0eaQlgPcwA7onHWlcW9Nx4eVXvcO6agPKJixudAtvDPeqoXpq+F+Qo8yc0Ayc92o
 avDrS6PnwJAuQQ6iWFryPTd6C0SlZIGrEWUAWggoUzRzfkY0sko1jXlPN+aIQuYQ9Fom
 O2Z4Puq519XuwVe9DEhZnYHOxBGlQfdihbWo46tRbiSbFAswrSrYSliSh5XXSb+v7k/8
 wXAz2IvK/1XEVcpQJ1RTPeycpN2Swo8po2uGN1rrukvlMxRD0bbikH+Wls29FdT2Wme4
 6fug3u+I9Ollr+Y1Se9lgs1MvCqbK/6Ac8MUaMGKKuXlAXXSOzZfyxfuscwNUluhhS88 Lg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g3u40s2kk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 18:30:53 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24GISlB9006197;
        Mon, 16 May 2022 18:30:52 GMT
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g3u40s2ka-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 18:30:52 +0000
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24GIMgTw013835;
        Mon, 16 May 2022 18:30:51 GMT
Received: from b03cxnp07027.gho.boulder.ibm.com (b03cxnp07027.gho.boulder.ibm.com [9.17.130.14])
        by ppma03wdc.us.ibm.com with ESMTP id 3g2429g1a7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 18:30:51 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp07027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24GIUoiK23265618
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 May 2022 18:30:50 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B925CBE04F;
        Mon, 16 May 2022 18:30:50 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5E982BE058;
        Mon, 16 May 2022 18:30:48 +0000 (GMT)
Received: from [9.211.37.97] (unknown [9.211.37.97])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 16 May 2022 18:30:48 +0000 (GMT)
Message-ID: <7a31ec36-ceaf-dcef-8bd0-2b4732050aed@linux.ibm.com>
Date:   Mon, 16 May 2022 14:30:46 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v7 17/22] vfio-pci/zdev: add open/close device hooks
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>, alex.williamson@redhat.com
Cc:     linux-s390@vger.kernel.org, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        svens@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, vneethv@linux.ibm.com,
        oberpar@linux.ibm.com, freude@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, pbonzini@redhat.com, corbet@lwn.net,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
References: <20220513191509.272897-1-mjrosato@linux.ibm.com>
 <20220513191509.272897-18-mjrosato@linux.ibm.com>
 <20220516172734.GE1343366@nvidia.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <20220516172734.GE1343366@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: QJ3mSR_ZqBKMkYpk0zFfj6GqvLy2hGwF
X-Proofpoint-ORIG-GUID: 0PfwCy3HfsOL6d04QXP-y2qXyrWTxYgI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-16_15,2022-05-16_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 adultscore=0
 mlxscore=0 malwarescore=0 lowpriorityscore=0 impostorscore=0 phishscore=0
 spamscore=0 mlxlogscore=999 suspectscore=0 priorityscore=1501
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205160097
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/16/22 1:27 PM, Jason Gunthorpe wrote:
> On Fri, May 13, 2022 at 03:15:04PM -0400, Matthew Rosato wrote:
>> @@ -136,3 +137,56 @@ int vfio_pci_info_zdev_add_caps(struct vfio_pci_core_device *vdev,
>>   
>>   	return ret;
>>   }
>> +
>> +static int vfio_pci_zdev_group_notifier(struct notifier_block *nb,
>> +					unsigned long action, void *data)
>> +{
>> +	struct zpci_dev *zdev = container_of(nb, struct zpci_dev, nb);
>> +
>> +	if (action == VFIO_GROUP_NOTIFY_SET_KVM) {
>> +		if (!zdev)
>> +			return NOTIFY_DONE;
>> +
>> +		if (data) {
>> +			if (kvm_s390_pci_register_kvm(zdev, (struct kvm *)data))
>> +				return NOTIFY_BAD;
> 
> The error codes are all ignored for this notifier chains, so this
> seems like a problem.
> 
>> +		} else {
>> +			if (kvm_s390_pci_unregister_kvm(zdev))
>> +				return NOTIFY_BAD;
> 
> unregister really shouldn't fail.
> 
> 
>> +		}
>> +
>> +	}
>> +
>> +	return NOTIFY_OK;
>> +}
>> +
>> +void vfio_pci_zdev_open(struct vfio_pci_core_device *vdev)
>> +{
>> +	unsigned long events = VFIO_GROUP_NOTIFY_SET_KVM;
>> +	struct zpci_dev *zdev = to_zpci(vdev->pdev);
>> +
>> +	if (!zdev)
>> +		return;
>> +
>> +	zdev->nb.notifier_call = vfio_pci_zdev_group_notifier;
>> +
>> +	vfio_register_notifier(vdev->vdev.dev, VFIO_GROUP_NOTIFY,
>> +			       &events, &zdev->nb);
> 
> Normally you'd want to do what is kvm_s390_pci_register_kvm() here,
> where a failure can be propogated but then you have a race condition
> with the kvm.
> 
> Blech, maybe it is time to just fix this race condition permanently,
> what do you think? (I didn't even compile it)

Conceptually I think this would work for QEMU anyway (it always sets the 
kvm before we open the device).  I tried to test the idea quickly but 
couldn't get the following to apply on vfio-next or your 
vfio_group_locking -- but I understand what you're trying to do so I'll 
re-work and try it out.

@Alex can you think of any usecase/reason why we would need to be able 
to set the KVM sometime after the device was opened?  Doing something 
like below would break that, as this introduces the assumption that the 
group is associated with the KVM before the device is opened (and if 
it's not, the device open fails).


> 
> diff --git a/drivers/gpu/drm/i915/gvt/gvt.h b/drivers/gpu/drm/i915/gvt/gvt.h
> index 2af4c83e733c6c..633acfcf76bf23 100644
> --- a/drivers/gpu/drm/i915/gvt/gvt.h
> +++ b/drivers/gpu/drm/i915/gvt/gvt.h
> @@ -227,8 +227,6 @@ struct intel_vgpu {
>   	struct mutex cache_lock;
>   
>   	struct notifier_block iommu_notifier;
> -	struct notifier_block group_notifier;
> -	struct kvm *kvm;
>   	struct work_struct release_work;
>   	atomic_t released;
>   
> diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
> index 7655ffa97d5116..655d47c65470d5 100644
> --- a/drivers/gpu/drm/i915/gvt/kvmgt.c
> +++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
> @@ -761,23 +761,6 @@ static int intel_vgpu_iommu_notifier(struct notifier_block *nb,
>   	return NOTIFY_OK;
>   }
>   
> -static int intel_vgpu_group_notifier(struct notifier_block *nb,
> -				     unsigned long action, void *data)
> -{
> -	struct intel_vgpu *vgpu =
> -		container_of(nb, struct intel_vgpu, group_notifier);
> -
> -	/* the only action we care about */
> -	if (action == VFIO_GROUP_NOTIFY_SET_KVM) {
> -		vgpu->kvm = data;
> -
> -		if (!data)
> -			schedule_work(&vgpu->release_work);
> -	}
> -
> -	return NOTIFY_OK;
> -}
> -
>   static bool __kvmgt_vgpu_exist(struct intel_vgpu *vgpu)
>   {
>   	struct intel_vgpu *itr;
> @@ -789,7 +772,7 @@ static bool __kvmgt_vgpu_exist(struct intel_vgpu *vgpu)
>   		if (!itr->attached)
>   			continue;
>   
> -		if (vgpu->kvm == itr->kvm) {
> +		if (vgpu->vfio_device.kvm == itr->vfio_device.kvm) {
>   			ret = true;
>   			goto out;
>   		}
> @@ -806,7 +789,6 @@ static int intel_vgpu_open_device(struct vfio_device *vfio_dev)
>   	int ret;
>   
>   	vgpu->iommu_notifier.notifier_call = intel_vgpu_iommu_notifier;
> -	vgpu->group_notifier.notifier_call = intel_vgpu_group_notifier;
>   
>   	events = VFIO_IOMMU_NOTIFY_DMA_UNMAP;
>   	ret = vfio_register_notifier(vfio_dev, VFIO_IOMMU_NOTIFY, &events,
> @@ -817,38 +799,30 @@ static int intel_vgpu_open_device(struct vfio_device *vfio_dev)
>   		goto out;
>   	}
>   
> -	events = VFIO_GROUP_NOTIFY_SET_KVM;
> -	ret = vfio_register_notifier(vfio_dev, VFIO_GROUP_NOTIFY, &events,
> -				     &vgpu->group_notifier);
> -	if (ret != 0) {
> -		gvt_vgpu_err("vfio_register_notifier for group failed: %d\n",
> -			ret);
> -		goto undo_iommu;
> -	}
> -
>   	ret = -EEXIST;
>   	if (vgpu->attached)
> -		goto undo_register;
> +		goto undo_iommu;
>   
>   	ret = -ESRCH;
> -	if (!vgpu->kvm || vgpu->kvm->mm != current->mm) {
> +	if (!vgpu->vfio_device.kvm ||
> +	    vgpu->vfio_device.kvm->mm != current->mm) {
>   		gvt_vgpu_err("KVM is required to use Intel vGPU\n");
> -		goto undo_register;
> +		goto undo_iommu;
>   	}
>   
>   	ret = -EEXIST;
>   	if (__kvmgt_vgpu_exist(vgpu))
> -		goto undo_register;
> +		goto undo_iommu;
>   
>   	vgpu->attached = true;
> -	kvm_get_kvm(vgpu->kvm);
>   
>   	kvmgt_protect_table_init(vgpu);
>   	gvt_cache_init(vgpu);
>   
>   	vgpu->track_node.track_write = kvmgt_page_track_write;
>   	vgpu->track_node.track_flush_slot = kvmgt_page_track_flush_slot;
> -	kvm_page_track_register_notifier(vgpu->kvm, &vgpu->track_node);
> +	kvm_page_track_register_notifier(vgpu->vfio_device.kvm,
> +					 &vgpu->track_node);
>   
>   	debugfs_create_ulong(KVMGT_DEBUGFS_FILENAME, 0444, vgpu->debugfs,
>   			     &vgpu->nr_cache_entries);
> @@ -858,10 +832,6 @@ static int intel_vgpu_open_device(struct vfio_device *vfio_dev)
>   	atomic_set(&vgpu->released, 0);
>   	return 0;
>   
> -undo_register:
> -	vfio_unregister_notifier(vfio_dev, VFIO_GROUP_NOTIFY,
> -				 &vgpu->group_notifier);
> -
>   undo_iommu:
>   	vfio_unregister_notifier(vfio_dev, VFIO_IOMMU_NOTIFY,
>   				 &vgpu->iommu_notifier);
> @@ -898,21 +868,15 @@ static void __intel_vgpu_release(struct intel_vgpu *vgpu)
>   	drm_WARN(&i915->drm, ret,
>   		 "vfio_unregister_notifier for iommu failed: %d\n", ret);
>   
> -	ret = vfio_unregister_notifier(&vgpu->vfio_device, VFIO_GROUP_NOTIFY,
> -				       &vgpu->group_notifier);
> -	drm_WARN(&i915->drm, ret,
> -		 "vfio_unregister_notifier for group failed: %d\n", ret);
> -
>   	debugfs_remove(debugfs_lookup(KVMGT_DEBUGFS_FILENAME, vgpu->debugfs));
>   
> -	kvm_page_track_unregister_notifier(vgpu->kvm, &vgpu->track_node);
> -	kvm_put_kvm(vgpu->kvm);
> +	kvm_page_track_unregister_notifier(vgpu->vfio_device.kvm,
> +					   &vgpu->track_node);
>   	kvmgt_protect_table_destroy(vgpu);
>   	gvt_cache_destroy(vgpu);
>   
>   	intel_vgpu_release_msi_eventfd_ctx(vgpu);
>   
> -	vgpu->kvm = NULL;
>   	vgpu->attached = false;
>   }
>   
> @@ -1649,6 +1613,7 @@ static const struct attribute_group *intel_vgpu_groups[] = {
>   };
>   
>   static const struct vfio_device_ops intel_vgpu_dev_ops = {
> +	.flags		= VFIO_DEVICE_NEEDS_KVM,
>   	.open_device	= intel_vgpu_open_device,
>   	.close_device	= intel_vgpu_close_device,
>   	.read		= intel_vgpu_read,
> @@ -1713,7 +1678,7 @@ static struct mdev_driver intel_vgpu_mdev_driver = {
>   
>   int intel_gvt_page_track_add(struct intel_vgpu *info, u64 gfn)
>   {
> -	struct kvm *kvm = info->kvm;
> +	struct kvm *kvm = info->vfio_device.kvm;
>   	struct kvm_memory_slot *slot;
>   	int idx;
>   
> @@ -1743,7 +1708,7 @@ int intel_gvt_page_track_add(struct intel_vgpu *info, u64 gfn)
>   
>   int intel_gvt_page_track_remove(struct intel_vgpu *info, u64 gfn)
>   {
> -	struct kvm *kvm = info->kvm;
> +	struct kvm *kvm = info->vfio_device.kvm;
>   	struct kvm_memory_slot *slot;
>   	int idx;
>   
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index e8914024f5b1af..f378f809d8a00d 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -1284,25 +1284,6 @@ static void vfio_ap_mdev_unset_kvm(struct ap_matrix_mdev *matrix_mdev)
>   	}
>   }
>   
> -static int vfio_ap_mdev_group_notifier(struct notifier_block *nb,
> -				       unsigned long action, void *data)
> -{
> -	int notify_rc = NOTIFY_OK;
> -	struct ap_matrix_mdev *matrix_mdev;
> -
> -	if (action != VFIO_GROUP_NOTIFY_SET_KVM)
> -		return NOTIFY_OK;
> -
> -	matrix_mdev = container_of(nb, struct ap_matrix_mdev, group_notifier);
> -
> -	if (!data)
> -		vfio_ap_mdev_unset_kvm(matrix_mdev);
> -	else if (vfio_ap_mdev_set_kvm(matrix_mdev, data))
> -		notify_rc = NOTIFY_DONE;
> -
> -	return notify_rc;
> -}
> -
>   static struct vfio_ap_queue *vfio_ap_find_queue(int apqn)
>   {
>   	struct device *dev;
> @@ -1402,11 +1383,7 @@ static int vfio_ap_mdev_open_device(struct vfio_device *vdev)
>   	unsigned long events;
>   	int ret;
>   
> -	matrix_mdev->group_notifier.notifier_call = vfio_ap_mdev_group_notifier;
> -	events = VFIO_GROUP_NOTIFY_SET_KVM;
> -
> -	ret = vfio_register_notifier(vdev, VFIO_GROUP_NOTIFY, &events,
> -				     &matrix_mdev->group_notifier);
> +	ret = vfio_ap_mdev_set_kvm(matrix_mdev, vdev->vdev.kvm);
>   	if (ret)
>   		return ret;
>   
> @@ -1415,12 +1392,11 @@ static int vfio_ap_mdev_open_device(struct vfio_device *vdev)
>   	ret = vfio_register_notifier(vdev, VFIO_IOMMU_NOTIFY, &events,
>   				     &matrix_mdev->iommu_notifier);
>   	if (ret)
> -		goto out_unregister_group;
> +		goto err_kvm;
>   	return 0;
>   
> -out_unregister_group:
> -	vfio_unregister_notifier(vdev, VFIO_GROUP_NOTIFY,
> -				 &matrix_mdev->group_notifier);
> +err_kvm:
> +	vfio_ap_mdev_unset_kvm(matrix_mdev);
>   	return ret;
>   }
>   
> @@ -1431,8 +1407,6 @@ static void vfio_ap_mdev_close_device(struct vfio_device *vdev)
>   
>   	vfio_unregister_notifier(vdev, VFIO_IOMMU_NOTIFY,
>   				 &matrix_mdev->iommu_notifier);
> -	vfio_unregister_notifier(vdev, VFIO_GROUP_NOTIFY,
> -				 &matrix_mdev->group_notifier);
>   	vfio_ap_mdev_unset_kvm(matrix_mdev);
>   }
>   
> @@ -1481,6 +1455,7 @@ static ssize_t vfio_ap_mdev_ioctl(struct vfio_device *vdev,
>   }
>   
>   static const struct vfio_device_ops vfio_ap_matrix_dev_ops = {
> +	.flags = VFIO_DEVICE_NEEDS_KVM,
>   	.open_device = vfio_ap_mdev_open_device,
>   	.close_device = vfio_ap_mdev_close_device,
>   	.ioctl = vfio_ap_mdev_ioctl,
> diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
> index 648fcaf8104abb..a26efd804d0df3 100644
> --- a/drivers/s390/crypto/vfio_ap_private.h
> +++ b/drivers/s390/crypto/vfio_ap_private.h
> @@ -81,8 +81,6 @@ struct ap_matrix {
>    * @node:	allows the ap_matrix_mdev struct to be added to a list
>    * @matrix:	the adapters, usage domains and control domains assigned to the
>    *		mediated matrix device.
> - * @group_notifier: notifier block used for specifying callback function for
> - *		    handling the VFIO_GROUP_NOTIFY_SET_KVM event
>    * @iommu_notifier: notifier block used for specifying callback function for
>    *		    handling the VFIO_IOMMU_NOTIFY_DMA_UNMAP even
>    * @kvm:	the struct holding guest's state
> @@ -94,7 +92,6 @@ struct ap_matrix_mdev {
>   	struct vfio_device vdev;
>   	struct list_head node;
>   	struct ap_matrix matrix;
> -	struct notifier_block group_notifier;
>   	struct notifier_block iommu_notifier;
>   	struct kvm *kvm;
>   	crypto_hook pqap_hook;
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index cfd797629a21ab..1c20bb5484afde 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -10,6 +10,7 @@
>    * Author: Tom Lyon, pugs@cisco.com
>    */
>   
> +#include "linux/kvm_host.h"
>   #include <linux/cdev.h>
>   #include <linux/compat.h>
>   #include <linux/device.h>
> @@ -1097,13 +1098,25 @@ static struct file *vfio_device_open(struct vfio_device *device)
>   
>   	down_write(&device->group->group_rwsem);
>   	ret = vfio_device_assign_container(device);
> -	up_write(&device->group->group_rwsem);
> -	if (ret)
> +	if (ret) {
> +		up_write(&device->group->group_rwsem);
>   		return ERR_PTR(ret);
> +	}
> +
> +	if (device->ops->flags & VFIO_DEVICE_NEEDS_KVM)
> +	{
> +		if (!device->group->kvm) {
> +			up_write(&device->group->group_rwsem);
> +			goto err_unassign_container;
> +		}
> +		device->kvm = device->group->kvm;
> +		kvm_get_kvm(device->kvm);
> +	}
> +	up_write(&device->group->group_rwsem);
>   
>   	if (!try_module_get(device->dev->driver->owner)) {
>   		ret = -ENODEV;
> -		goto err_unassign_container;
> +		goto err_put_kvm;
>   	}
>   
>   	mutex_lock(&device->dev_set->lock);
> @@ -1147,6 +1160,11 @@ static struct file *vfio_device_open(struct vfio_device *device)
>   	device->open_count--;
>   	mutex_unlock(&device->dev_set->lock);
>   	module_put(device->dev->driver->owner);
> +err_put_kvm:
> +	if (device->kvm) {
> +		kvm_put_kvm(device->kvm);
> +		device->kvm = NULL;
> +	}
>   err_unassign_container:
>   	vfio_device_unassign_container(device);
>   	return ERR_PTR(ret);
> @@ -1344,6 +1362,10 @@ static int vfio_device_fops_release(struct inode *inode, struct file *filep)
>   
>   	module_put(device->dev->driver->owner);
>   
> +	if (device->kvm) {
> +		kvm_put_kvm(device->kvm);
> +		device->kvm = NULL;
> +	}
>   	vfio_device_unassign_container(device);
>   
>   	vfio_device_put(device);
> @@ -1748,8 +1770,8 @@ EXPORT_SYMBOL_GPL(vfio_file_enforced_coherent);
>    * @file: VFIO group file
>    * @kvm: KVM to link
>    *
> - * The kvm pointer will be forwarded to all the vfio_device's attached to the
> - * VFIO file via the VFIO_GROUP_NOTIFY_SET_KVM notifier.
> + * When a VFIO device is first opened the KVM will be available in
> + * device->kvm if VFIO_DEVICE_NEEDS_KVM is set.
>    */
>   void vfio_file_set_kvm(struct file *file, struct kvm *kvm)
>   {
> @@ -1760,8 +1782,6 @@ void vfio_file_set_kvm(struct file *file, struct kvm *kvm)
>   
>   	down_write(&group->group_rwsem);
>   	group->kvm = kvm;
> -	blocking_notifier_call_chain(&group->notifier,
> -				     VFIO_GROUP_NOTIFY_SET_KVM, kvm);
>   	up_write(&group->group_rwsem);
>   }
>   EXPORT_SYMBOL_GPL(vfio_file_set_kvm);
> @@ -2061,42 +2081,6 @@ static int vfio_unregister_iommu_notifier(struct vfio_group *group,
>   	return ret;
>   }
>   
> -static int vfio_register_group_notifier(struct vfio_group *group,
> -					unsigned long *events,
> -					struct notifier_block *nb)
> -{
> -	int ret;
> -	bool set_kvm = false;
> -
> -	if (*events & VFIO_GROUP_NOTIFY_SET_KVM)
> -		set_kvm = true;
> -
> -	/* clear known events */
> -	*events &= ~VFIO_GROUP_NOTIFY_SET_KVM;
> -
> -	/* refuse to continue if still events remaining */
> -	if (*events)
> -		return -EINVAL;
> -
> -	ret = blocking_notifier_chain_register(&group->notifier, nb);
> -	if (ret)
> -		return ret;
> -
> -	/*
> -	 * The attaching of kvm and vfio_group might already happen, so
> -	 * here we replay once upon registration.
> -	 */
> -	if (set_kvm) {
> -		down_read(&group->group_rwsem);
> -		if (group->kvm)
> -			blocking_notifier_call_chain(&group->notifier,
> -						     VFIO_GROUP_NOTIFY_SET_KVM,
> -						     group->kvm);
> -		up_read(&group->group_rwsem);
> -	}
> -	return 0;
> -}
> -
>   int vfio_register_notifier(struct vfio_device *device,
>   			   enum vfio_notify_type type, unsigned long *events,
>   			   struct notifier_block *nb)
> @@ -2112,9 +2096,6 @@ int vfio_register_notifier(struct vfio_device *device,
>   	case VFIO_IOMMU_NOTIFY:
>   		ret = vfio_register_iommu_notifier(group, events, nb);
>   		break;
> -	case VFIO_GROUP_NOTIFY:
> -		ret = vfio_register_group_notifier(group, events, nb);
> -		break;
>   	default:
>   		ret = -EINVAL;
>   	}
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index 45b287826ce686..aaf120b9c080b7 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -36,6 +36,7 @@ struct vfio_device {
>   	struct vfio_device_set *dev_set;
>   	struct list_head dev_set_list;
>   	unsigned int migration_flags;
> +	struct kvm *kvm;
>   
>   	/* Members below here are private, not for driver use */
>   	refcount_t refcount;
> @@ -44,6 +45,10 @@ struct vfio_device {
>   	struct list_head group_next;
>   };
>   
> +enum {
> +	VFIO_DEVICE_NEEDS_KVM = 1,
> +};
> +
>   /**
>    * struct vfio_device_ops - VFIO bus driver device callbacks
>    *
> @@ -72,6 +77,7 @@ struct vfio_device {
>    */
>   struct vfio_device_ops {
>   	char	*name;
> +	unsigned int flags;
>   	int	(*open_device)(struct vfio_device *vdev);
>   	void	(*close_device)(struct vfio_device *vdev);
>   	ssize_t	(*read)(struct vfio_device *vdev, char __user *buf,
> @@ -155,15 +161,11 @@ extern int vfio_dma_rw(struct vfio_device *device, dma_addr_t user_iova,
>   /* each type has independent events */
>   enum vfio_notify_type {
>   	VFIO_IOMMU_NOTIFY = 0,
> -	VFIO_GROUP_NOTIFY = 1,
>   };
>   
>   /* events for VFIO_IOMMU_NOTIFY */
>   #define VFIO_IOMMU_NOTIFY_DMA_UNMAP	BIT(0)
>   
> -/* events for VFIO_GROUP_NOTIFY */
> -#define VFIO_GROUP_NOTIFY_SET_KVM	BIT(0)
> -
>   extern int vfio_register_notifier(struct vfio_device *device,
>   				  enum vfio_notify_type type,
>   				  unsigned long *required_events,

