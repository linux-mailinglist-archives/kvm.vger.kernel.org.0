Return-Path: <kvm+bounces-57611-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D56ABB5848B
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 20:27:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8B1914C5009
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 18:27:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C57932E7F31;
	Mon, 15 Sep 2025 18:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="FzUQg9xQ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B0A62E7BDB;
	Mon, 15 Sep 2025 18:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757960841; cv=none; b=nTmVGPQF4SeeojQL05/mY6/QFb+WhkxH0XirY86zXjBwUT6m3foW/C4ZSUV/cIig9nmQ17HHzGyPVbE9ppd/gVFcTnPbmXEuGBTQ+02nG97hsSIeaT7JfBxS0aCepDEf/5sEM1UIL+Lu9KW7v9aBNHEgol7WzX4Rv36jx9Mbl5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757960841; c=relaxed/simple;
	bh=0JH4r/5xqMYN2XuIWxNS2Ren3KRP166NvzxoZ2dUGPA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FLVsDpqXixo0qR9mGb+anlGOvYzsIjU1ravSU3Rmseh+okUnqGca02QwBNZdcnV2KYoBYhTMSDhguna3DkeuOaN3yBx7PYYb6ySIWCu39TIsBodhPbp4OvHi9gLajgU+G8oO32GIvtJVGJVd82ZVV+PEkjelevkyDhkbWVOdtP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=FzUQg9xQ; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58FDv4oQ024250;
	Mon, 15 Sep 2025 18:27:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=GShTAO
	nLc6O6oMX8e5Bx4qhybeu2IfXYCl2jy6D2oHg=; b=FzUQg9xQ5bVSgCp3JyjsBy
	w/Pebhf9kzO5F6St4IZm1hpLnaJ2Jz9diVLR0F50WxQusvU0iepIJs+FwtetbL3K
	pUv21Z6s5CkYwg7NszCkPXtcxvlJR/YACHqqtYZlYG8D37SBHpFYcxYq3q6giRhv
	PWNGdSbGcchEL5fMyHM0UB/n77SMtfkraxvXwEulsWBrduXZ7OBlTnGuLsGWE9f1
	DVp87ZjKkXy289BmEmb3TzAtFhPFfa4Mph4GXk18Bq9ozkqVInix7Mmh7Nxfden5
	DYJSh4ZsGR21H0UijJF2BP7Rk+9vGs/I5QpDOvykgSML3rVtCzwT60HiAXpiD8dQ
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 496avnmf26-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 15 Sep 2025 18:27:13 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58FFks1x018629;
	Mon, 15 Sep 2025 18:27:12 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([172.16.1.8])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 495n5m7mwu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 15 Sep 2025 18:27:12 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
	by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58FIRBCP31064816
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Sep 2025 18:27:11 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 19CCF58058;
	Mon, 15 Sep 2025 18:27:11 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4639F58059;
	Mon, 15 Sep 2025 18:27:10 +0000 (GMT)
Received: from [9.61.244.242] (unknown [9.61.244.242])
	by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 15 Sep 2025 18:27:10 +0000 (GMT)
Message-ID: <9fe8f746-37f5-4743-8144-ec9679b6e5c6@linux.ibm.com>
Date: Mon, 15 Sep 2025 11:27:06 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 08/10] vfio-pci/zdev: Add a device feature for error
 information
To: Alex Williamson <alex.williamson@redhat.com>
Cc: linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        helgaas@kernel.org, schnelle@linux.ibm.com, mjrosato@linux.ibm.com
References: <20250911183307.1910-1-alifm@linux.ibm.com>
 <20250911183307.1910-9-alifm@linux.ibm.com>
 <20250913100457.1af13cd7.alex.williamson@redhat.com>
Content-Language: en-US
From: Farhan Ali <alifm@linux.ibm.com>
In-Reply-To: <20250913100457.1af13cd7.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 8yGVObKgPMNYfxaRd7FmcdMrJLfeXp-P
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE1MDAyOCBTYWx0ZWRfX3lVChOY9eeI6
 Ejhkx+c40HhtffymlQEX6FUtC1GzgHMiQl0Sogr03ij7twx09pVQoyp2huWNbCxq5HatBssmZ8x
 iblg5PFBQUV4VMvaKdR1AWzSiNkf08TWIH7fYZboLXPh/KCXAK/uDPmyA1MBufWD7j8KeGJXcdj
 1zkA5snRy37G5LcFKRk2XVCnNFHSHyPUMvtI+4btvRAwS8Qfqfy20mvLwe4iVLEeGjzIdVBuO02
 0dB/vDrZagMvj0mb8L3le6qbNOQYEagM4n6CnQSaIKOQHVUI2VL+HZiPLtMPJst79jPbCOlcyg5
 TQrqd2C6CLpJDMhNflQWPO/CL1EdMa5GIspSdWbwQ7qmzHH/ENcmbQf8SxDvKCNuYnLV2l9zc83
 qUz5KCOX
X-Authority-Analysis: v=2.4 cv=HecUTjE8 c=1 sm=1 tr=0 ts=68c85a81 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=jbbMZsOuVxTQt3OaBu8A:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: 8yGVObKgPMNYfxaRd7FmcdMrJLfeXp-P
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-15_07,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 adultscore=0 spamscore=0 priorityscore=1501 suspectscore=0
 malwarescore=0 bulkscore=0 impostorscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509150028


On 9/13/2025 2:04 AM, Alex Williamson wrote:
> On Thu, 11 Sep 2025 11:33:05 -0700
> Farhan Ali <alifm@linux.ibm.com> wrote:
>
>> For zPCI devices, we have platform specific error information. The platform
>> firmware provides this error information to the operating system in an
>> architecture specific mechanism. To enable recovery from userspace for
>> these devices, we want to expose this error information to userspace. Add a
>> new device feature to expose this information.
>>
>> Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
>> ---
>>   drivers/vfio/pci/vfio_pci_core.c |  2 ++
>>   drivers/vfio/pci/vfio_pci_priv.h |  8 ++++++++
>>   drivers/vfio/pci/vfio_pci_zdev.c | 34 ++++++++++++++++++++++++++++++++
>>   include/uapi/linux/vfio.h        | 14 +++++++++++++
>>   4 files changed, 58 insertions(+)
>>
>> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
>> index 7dcf5439dedc..378adb3226db 100644
>> --- a/drivers/vfio/pci/vfio_pci_core.c
>> +++ b/drivers/vfio/pci/vfio_pci_core.c
>> @@ -1514,6 +1514,8 @@ int vfio_pci_core_ioctl_feature(struct vfio_device *device, u32 flags,
>>   		return vfio_pci_core_pm_exit(device, flags, arg, argsz);
>>   	case VFIO_DEVICE_FEATURE_PCI_VF_TOKEN:
>>   		return vfio_pci_core_feature_token(device, flags, arg, argsz);
>> +	case VFIO_DEVICE_FEATURE_ZPCI_ERROR:
>> +		return vfio_pci_zdev_feature_err(device, flags, arg, argsz);
>>   	default:
>>   		return -ENOTTY;
>>   	}
>> diff --git a/drivers/vfio/pci/vfio_pci_priv.h b/drivers/vfio/pci/vfio_pci_priv.h
>> index a9972eacb293..a4a7f97fdc2e 100644
>> --- a/drivers/vfio/pci/vfio_pci_priv.h
>> +++ b/drivers/vfio/pci/vfio_pci_priv.h
>> @@ -86,6 +86,8 @@ int vfio_pci_info_zdev_add_caps(struct vfio_pci_core_device *vdev,
>>   				struct vfio_info_cap *caps);
>>   int vfio_pci_zdev_open_device(struct vfio_pci_core_device *vdev);
>>   void vfio_pci_zdev_close_device(struct vfio_pci_core_device *vdev);
>> +int vfio_pci_zdev_feature_err(struct vfio_device *device, u32 flags,
>> +			      void __user *arg, size_t argsz);
>>   #else
>>   static inline int vfio_pci_info_zdev_add_caps(struct vfio_pci_core_device *vdev,
>>   					      struct vfio_info_cap *caps)
>> @@ -100,6 +102,12 @@ static inline int vfio_pci_zdev_open_device(struct vfio_pci_core_device *vdev)
>>   
>>   static inline void vfio_pci_zdev_close_device(struct vfio_pci_core_device *vdev)
>>   {}
>> +
>> +static int vfio_pci_zdev_feature_err(struct vfio_device *device, u32 flags,
>> +				     void __user *arg, size_t argsz);
>> +{
>> +	return -ENODEV;
>> +}
>>   #endif
>>   
>>   static inline bool vfio_pci_is_vga(struct pci_dev *pdev)
>> diff --git a/drivers/vfio/pci/vfio_pci_zdev.c b/drivers/vfio/pci/vfio_pci_zdev.c
>> index 2be37eab9279..261954039aa9 100644
>> --- a/drivers/vfio/pci/vfio_pci_zdev.c
>> +++ b/drivers/vfio/pci/vfio_pci_zdev.c
>> @@ -141,6 +141,40 @@ int vfio_pci_info_zdev_add_caps(struct vfio_pci_core_device *vdev,
>>   	return ret;
>>   }
>>   
>> +int vfio_pci_zdev_feature_err(struct vfio_device *device, u32 flags,
>> +			      void __user *arg, size_t argsz)
>> +{
>> +	struct vfio_device_feature_zpci_err err;
>> +	struct vfio_pci_core_device *vdev =
>> +		container_of(device, struct vfio_pci_core_device, vdev);
>> +	struct zpci_dev *zdev = to_zpci(vdev->pdev);
>> +	int ret;
>> +	int head = 0;
>> +
>> +	if (!zdev)
>> +		return -ENODEV;
>> +
>> +	ret = vfio_check_feature(flags, argsz, VFIO_DEVICE_FEATURE_GET,
>> +				 sizeof(err));
>> +	if (ret != 1)
>> +		return ret;
>> +
>> +	mutex_lock(&zdev->pending_errs_lock);
>> +	if (zdev->pending_errs.count) {
>> +		head = zdev->pending_errs.head % ZPCI_ERR_PENDING_MAX;
>> +		err.pec = zdev->pending_errs.err[head].pec;
>> +		zdev->pending_errs.head++;
>> +		zdev->pending_errs.count--;
>> +		err.pending_errors = zdev->pending_errs.count;
>> +	}
>> +	mutex_unlock(&zdev->pending_errs_lock);
>> +
>> +	if (copy_to_user(arg, &err, sizeof(err)))
>> +		return -EFAULT;
>> +
>> +	return 0;
>> +}
>> +
>>   int vfio_pci_zdev_open_device(struct vfio_pci_core_device *vdev)
>>   {
>>   	struct zpci_dev *zdev = to_zpci(vdev->pdev);
>> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
>> index 75100bf009ba..a950c341602d 100644
>> --- a/include/uapi/linux/vfio.h
>> +++ b/include/uapi/linux/vfio.h
>> @@ -1478,6 +1478,20 @@ struct vfio_device_feature_bus_master {
>>   };
>>   #define VFIO_DEVICE_FEATURE_BUS_MASTER 10
>>   
>> +/**
>> + * VFIO_DEVICE_FEATURE_ZPCI_ERROR feature provides PCI error information to
>> + * userspace for vfio-pci devices on s390x. On s390x PCI error recovery involves
>> + * platform firmware and notification to operating system is done by
>> + * architecture specific mechanism.  Exposing this information to userspace
>> + * allows userspace to take appropriate actions to handle an error on the
>> + * device.
>> + */
>> +struct vfio_device_feature_zpci_err {
>> +	__u16 pec;
>> +	int pending_errors;
>> +};
> This should have some explicit alignment.  Thanks,
>
> Alex
>
Sure, would something like this be sufficient?

struct vfio_device_feature_zpci_err {
	__u16 pec;
	__u8 pending_errors;
	__u8 __pad;
};

Based on some discussion with Niklas (patch 7) we can reduce the 
pending_errors to u8.

Thanks
Farhan

>
>> +#define VFIO_DEVICE_FEATURE_ZPCI_ERROR 11
>> +
>>   /* -------- API for Type1 VFIO IOMMU -------- */
>>   
>>   /**

