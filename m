Return-Path: <kvm+bounces-57612-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BA3C7B58492
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 20:28:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E98597B0217
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 18:26:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21C462E8DF1;
	Mon, 15 Sep 2025 18:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="kApsjmls"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABA16284679;
	Mon, 15 Sep 2025 18:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757960893; cv=none; b=NwTxWoetZTHI46hS+gWSSxpVOaVIYo+/Lquuifo68iZvJd/6SVEFVz27CoW64L/xFnSpgLxGLXvU/+npfm52fHgEjq0q/hZdt/jE003kCHiOT2DnfXcN15GsmLyIBmuQKUx5+d+JKsKi3aF5SbUDzyay7d7+6SxoOSpXZC8H2BM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757960893; c=relaxed/simple;
	bh=ABt6M1tDohzKjz7sdRyb04+ee8AHKlWw3ay3YR4MIOA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IqdV+J+SATdXtTQfpU5rNIwFbGNdSJxlE55e267syLoout9IdNb90LyV9zlga/eWpCC1kmLtVcqDEQVJc312HHGrgkt+KzjKQZC1Ni9r6lA7NT1goapmEqt8lxhABkUUN2V+Qbs/X5EDFQjmvOsbMGL8HB4CmjkmXHhdAogQdTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=kApsjmls; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58FDXh9a023043;
	Mon, 15 Sep 2025 18:28:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=wWcgHa
	z9WZlOhtQ4LnaWODco0CY+vd+MOPf1D+zntUA=; b=kApsjmlsDs2d49cZ/nWMT4
	uqpn1ybfUPb9Wn7O8BStAmXDyAzUGZlGvX9YgYEi2Ir2Zua5dNyZPf/Lxr8Ve8mi
	Qs0Ev3/EAjFzLEKN0c2tVyqarnf4+JVSbm8pdSH6z301YhnQ+KS18VA0c8cqGbgp
	VQ6NLeXsC1RfTr1ICpB71+W+JqQOPFPgT2qiEptycApN52fLwyEW+Po9hyQiN3wq
	8l6teWvUP9AQBI33R8BzZc/+m9iRHBOhyUS64uoxe+Kb9fWMUCDyL/QLQjfGFxOK
	9ggF+I62Pe6nTtMHSibOjFGvMUC1/VMD7+mWKSHM/fYhHlOVLNzxdp/soodemTNQ
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 496avnmf54-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 15 Sep 2025 18:28:00 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58FI1eav029472;
	Mon, 15 Sep 2025 18:27:58 GMT
Received: from smtprelay06.wdc07v.mail.ibm.com ([172.16.1.73])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 495kb0r14e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 15 Sep 2025 18:27:58 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
	by smtprelay06.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58FIRvPU48169284
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Sep 2025 18:27:57 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9553158058;
	Mon, 15 Sep 2025 18:27:57 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A59265805B;
	Mon, 15 Sep 2025 18:27:56 +0000 (GMT)
Received: from [9.61.244.242] (unknown [9.61.244.242])
	by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 15 Sep 2025 18:27:56 +0000 (GMT)
Message-ID: <fdad9c58-5a6f-460d-807b-fc5e6631b994@linux.ibm.com>
Date: Mon, 15 Sep 2025 11:27:53 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 08/10] vfio-pci/zdev: Add a device feature for error
 information
To: =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@kaod.org>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Cc: alex.williamson@redhat.com, helgaas@kernel.org, schnelle@linux.ibm.com,
        mjrosato@linux.ibm.com
References: <20250911183307.1910-1-alifm@linux.ibm.com>
 <20250911183307.1910-9-alifm@linux.ibm.com>
 <d55b6b2e-3217-41e1-a95a-744dbbdbe618@kaod.org>
Content-Language: en-US
From: Farhan Ali <alifm@linux.ibm.com>
In-Reply-To: <d55b6b2e-3217-41e1-a95a-744dbbdbe618@kaod.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: bJZDFJDB4jMiw85QHaHjZUw1mnMWmKBy
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE1MDAyOCBTYWx0ZWRfXyfV/7NYbPwFY
 VDzjKDB4RLxfkekcdVE9jZBeXhQw3GRm9+r/MYg67FPxAAQIN2UXyQzZFCUa5VU81Bu0AxXqowW
 25HcF29jiOrvHrWBBTa39khMsMPUXe4SlptruCR/HoL8fGDGOZL3kdNCRZrk2jygLmeYTAgUvrv
 f5f3by4/4dKuIYsBFB0ZWfjOhbri5qb47pCxt62EtHDnV4xrYl/5PJ62STqBPaP1v8jBwkcuF3J
 PERjLUlCDPqkh4APJN875PXfwoeh/Aw4easjU9MnW9QGm8V03C9MeGmzJsc0m1d51NxvqM4FHOc
 bIyOGKVLYJEBke1+T0sgaSyxVw77wlQdUpzbVCmlty/URmSDm1Mc52N2PZ7WGpdAfuvEGKHsjBq
 7WdjZt3w
X-Authority-Analysis: v=2.4 cv=HecUTjE8 c=1 sm=1 tr=0 ts=68c85ab0 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=jbbMZsOuVxTQt3OaBu8A:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: bJZDFJDB4jMiw85QHaHjZUw1mnMWmKBy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-15_07,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 adultscore=0 spamscore=0 priorityscore=1501 suspectscore=0
 malwarescore=0 bulkscore=0 impostorscore=0 clxscore=1011
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509150028


On 9/14/2025 11:26 PM, Cédric Le Goater wrote:
> On 9/11/25 20:33, Farhan Ali wrote:
>> For zPCI devices, we have platform specific error information. The 
>> platform
>> firmware provides this error information to the operating system in an
>> architecture specific mechanism. To enable recovery from userspace for
>> these devices, we want to expose this error information to userspace. 
>> Add a
>> new device feature to expose this information.
>>
>> Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
>> ---
>>   drivers/vfio/pci/vfio_pci_core.c |  2 ++
>>   drivers/vfio/pci/vfio_pci_priv.h |  8 ++++++++
>>   drivers/vfio/pci/vfio_pci_zdev.c | 34 ++++++++++++++++++++++++++++++++
>>   include/uapi/linux/vfio.h        | 14 +++++++++++++
>>   4 files changed, 58 insertions(+)
>>
>> diff --git a/drivers/vfio/pci/vfio_pci_core.c 
>> b/drivers/vfio/pci/vfio_pci_core.c
>> index 7dcf5439dedc..378adb3226db 100644
>> --- a/drivers/vfio/pci/vfio_pci_core.c
>> +++ b/drivers/vfio/pci/vfio_pci_core.c
>> @@ -1514,6 +1514,8 @@ int vfio_pci_core_ioctl_feature(struct 
>> vfio_device *device, u32 flags,
>>           return vfio_pci_core_pm_exit(device, flags, arg, argsz);
>>       case VFIO_DEVICE_FEATURE_PCI_VF_TOKEN:
>>           return vfio_pci_core_feature_token(device, flags, arg, argsz);
>> +    case VFIO_DEVICE_FEATURE_ZPCI_ERROR:
>> +        return vfio_pci_zdev_feature_err(device, flags, arg, argsz);
>>       default:
>>           return -ENOTTY;
>>       }
>> diff --git a/drivers/vfio/pci/vfio_pci_priv.h 
>> b/drivers/vfio/pci/vfio_pci_priv.h
>> index a9972eacb293..a4a7f97fdc2e 100644
>> --- a/drivers/vfio/pci/vfio_pci_priv.h
>> +++ b/drivers/vfio/pci/vfio_pci_priv.h
>> @@ -86,6 +86,8 @@ int vfio_pci_info_zdev_add_caps(struct 
>> vfio_pci_core_device *vdev,
>>                   struct vfio_info_cap *caps);
>>   int vfio_pci_zdev_open_device(struct vfio_pci_core_device *vdev);
>>   void vfio_pci_zdev_close_device(struct vfio_pci_core_device *vdev);
>> +int vfio_pci_zdev_feature_err(struct vfio_device *device, u32 flags,
>> +                  void __user *arg, size_t argsz);
>>   #else
>>   static inline int vfio_pci_info_zdev_add_caps(struct 
>> vfio_pci_core_device *vdev,
>>                             struct vfio_info_cap *caps)
>> @@ -100,6 +102,12 @@ static inline int 
>> vfio_pci_zdev_open_device(struct vfio_pci_core_device *vdev)
>>     static inline void vfio_pci_zdev_close_device(struct 
>> vfio_pci_core_device *vdev)
>>   {}
>> +
>> +static int vfio_pci_zdev_feature_err(struct vfio_device *device, u32 
>> flags,
>> +                     void __user *arg, size_t argsz);
>
> The extra ';' breaks builds on non-Z platforms.
>
> C.

Thanks for catching this, will fix.

Thanks
Farhan


>
>> +{
>> +    return -ENODEV;
>> +}
>>   #endif
>>     static inline bool vfio_pci_is_vga(struct pci_dev *pdev)
>> diff --git a/drivers/vfio/pci/vfio_pci_zdev.c 
>> b/drivers/vfio/pci/vfio_pci_zdev.c
>> index 2be37eab9279..261954039aa9 100644
>> --- a/drivers/vfio/pci/vfio_pci_zdev.c
>> +++ b/drivers/vfio/pci/vfio_pci_zdev.c
>> @@ -141,6 +141,40 @@ int vfio_pci_info_zdev_add_caps(struct 
>> vfio_pci_core_device *vdev,
>>       return ret;
>>   }
>>   +int vfio_pci_zdev_feature_err(struct vfio_device *device, u32 flags,
>> +                  void __user *arg, size_t argsz)
>> +{
>> +    struct vfio_device_feature_zpci_err err;
>> +    struct vfio_pci_core_device *vdev =
>> +        container_of(device, struct vfio_pci_core_device, vdev);
>> +    struct zpci_dev *zdev = to_zpci(vdev->pdev);
>> +    int ret;
>> +    int head = 0;
>> +
>> +    if (!zdev)
>> +        return -ENODEV;
>> +
>> +    ret = vfio_check_feature(flags, argsz, VFIO_DEVICE_FEATURE_GET,
>> +                 sizeof(err));
>> +    if (ret != 1)
>> +        return ret;
>> +
>> +    mutex_lock(&zdev->pending_errs_lock);
>> +    if (zdev->pending_errs.count) {
>> +        head = zdev->pending_errs.head % ZPCI_ERR_PENDING_MAX;
>> +        err.pec = zdev->pending_errs.err[head].pec;
>> +        zdev->pending_errs.head++;
>> +        zdev->pending_errs.count--;
>> +        err.pending_errors = zdev->pending_errs.count;
>> +    }
>> +    mutex_unlock(&zdev->pending_errs_lock);
>> +
>> +    if (copy_to_user(arg, &err, sizeof(err)))
>> +        return -EFAULT;
>> +
>> +    return 0;
>> +}
>> +
>>   int vfio_pci_zdev_open_device(struct vfio_pci_core_device *vdev)
>>   {
>>       struct zpci_dev *zdev = to_zpci(vdev->pdev);
>> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
>> index 75100bf009ba..a950c341602d 100644
>> --- a/include/uapi/linux/vfio.h
>> +++ b/include/uapi/linux/vfio.h
>> @@ -1478,6 +1478,20 @@ struct vfio_device_feature_bus_master {
>>   };
>>   #define VFIO_DEVICE_FEATURE_BUS_MASTER 10
>>   +/**
>> + * VFIO_DEVICE_FEATURE_ZPCI_ERROR feature provides PCI error 
>> information to
>> + * userspace for vfio-pci devices on s390x. On s390x PCI error 
>> recovery involves
>> + * platform firmware and notification to operating system is done by
>> + * architecture specific mechanism.  Exposing this information to 
>> userspace
>> + * allows userspace to take appropriate actions to handle an error 
>> on the
>> + * device.
>> + */
>> +struct vfio_device_feature_zpci_err {
>> +    __u16 pec;
>> +    int pending_errors;
>> +};
>> +#define VFIO_DEVICE_FEATURE_ZPCI_ERROR 11
>> +
>>   /* -------- API for Type1 VFIO IOMMU -------- */
>>     /**
>
>

