Return-Path: <kvm+bounces-54614-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 32B61B255FB
	for <lists+kvm@lfdr.de>; Wed, 13 Aug 2025 23:53:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3646F1C2355C
	for <lists+kvm@lfdr.de>; Wed, 13 Aug 2025 21:53:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 681232ED15A;
	Wed, 13 Aug 2025 21:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="K5ljCaeJ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D68893009ED;
	Wed, 13 Aug 2025 21:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755121952; cv=none; b=OZtYBhDwwFxU9EwUgTwY9FHG1yEKJwk1hIyY08T8Pz9GjdXbfGA9ZtkJrFl6hPDlOZ15VMkts9VMOU0HMEmJAcIeuDkPHDKLHGE/wKeIyWpe1xQ8o+Y3zGBFYvv0jYXF4i+uJH71gcdEwEDZTrN+0gkexmRjCl6B3559g890BZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755121952; c=relaxed/simple;
	bh=Xm/66Xo566UEproqXHXMFzKT0m04y54OApQWydn3QXM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AWnCqEgav8/2LS57rnHlRcNQfojb+IL2yJVMijAN8qfPyOSx5IOBw0A7T1lIDOc9q/EQFtU4TbsRSPrggNxYNzw2wKmncRD7NWKad/MhLIn8R9JKRYxPwhudtHUtQsDKAYLhyPUKlajZZUt3BELa/BoKcEnIhhac8r0xeOkcSmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=K5ljCaeJ; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57DLc8xi015928;
	Wed, 13 Aug 2025 21:52:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=hq504y
	mxo8mQOS0Yhu4JFc54oB1vYk9oDhbefKBmo/M=; b=K5ljCaeJ74YsauctaLHq/0
	DpngZM1e+uOiEHPJkTGh62UaOkJZ/B+H2pJSpaCuot/qjn7p+ZMISkJgj8b+3yUb
	F+qUoMlpcGHJSTauM48vhluubVUm77Xg9WivZNkR2IVrNyxvr13rVelq+nSmR9vE
	o0HSyhKb4cTWUtXzplU9yaCMUiJ8QzsshXjgpw1Sc0zySPubhRm2JO8dVK1vHEfc
	nfPPEl1q4od1sIe0Mbdbd6suEsjlZNniF3Dc18PK79cyLI6o+ixlj+ck177AgLdf
	nervxxtuQfM2HDTihukuwzeN9Ud1Pfm55ntDCvZytXAH3SrxT9K5NuS+ldH5qh5g
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48dvrp6rpr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Aug 2025 21:52:28 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 57DJjiM4028585;
	Wed, 13 Aug 2025 21:52:27 GMT
Received: from smtprelay03.wdc07v.mail.ibm.com ([172.16.1.70])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 48ej5n998d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Aug 2025 21:52:27 +0000
Received: from smtpav03.wdc07v.mail.ibm.com (smtpav03.wdc07v.mail.ibm.com [10.39.53.230])
	by smtprelay03.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 57DLqIui17302124
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Aug 2025 21:52:18 GMT
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 88F995805C;
	Wed, 13 Aug 2025 21:52:26 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DD36F58054;
	Wed, 13 Aug 2025 21:52:25 +0000 (GMT)
Received: from [9.61.254.249] (unknown [9.61.254.249])
	by smtpav03.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 13 Aug 2025 21:52:25 +0000 (GMT)
Message-ID: <7059025f-f337-493d-a50c-ccce8fb4beee@linux.ibm.com>
Date: Wed, 13 Aug 2025 14:52:24 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 5/6] vfio-pci/zdev: Perform platform specific function
 reset for zPCI
To: Alex Williamson <alex.williamson@redhat.com>
Cc: linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, schnelle@linux.ibm.com,
        mjrosato@linux.ibm.com
References: <20250813170821.1115-1-alifm@linux.ibm.com>
 <20250813170821.1115-6-alifm@linux.ibm.com>
 <20250813143034.36f8c3a4.alex.williamson@redhat.com>
Content-Language: en-US
From: Farhan Ali <alifm@linux.ibm.com>
In-Reply-To: <20250813143034.36f8c3a4.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODEyMDIxOSBTYWx0ZWRfX5snddpIhg4K2
 4vy5ksbKN+w/Q5nFJqjRGmC1VmEmhj0sVjlDmb71HN3ItGme93g7mbpmXzIIO3j9rqieAZ5fWOn
 Eucx8cFkVTc4xzoheyX0SxxZWKKOkEQ7HnKXPoO+7VhyKPEkE+TQzwjuYDzRrK6P0I7PCglQK45
 tDOjNq/6BVw3jtjXYYUkhrpIQ75Xr3+3U6oJXMBmpc8rpnKRVN9dSv0lVO9922LF88VUTS/jaOZ
 OYHXeBlYDXs8jf2ku/RQ5KUL9TKpTMt/xUmmPHOl9vQndrkYUB5ioSHr6BmxpJoxsJVcpoiq+Fk
 XtlIQVKlsV57WdTghSCd/W9Uuc4BcCZ7v+6+XfWQ6yi4DoSbJHVjw5KQ/F9sTDp6G+Tx4yu6AW5
 4HXyietX
X-Authority-Analysis: v=2.4 cv=GrpC+l1C c=1 sm=1 tr=0 ts=689d091c cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=2OwXVqhp2XgA:10 a=VnNF1IyMAAAA:8 a=Ke-CEX4gKZVx1ICNS1cA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: v7-alXoa75Z1adO1K5C17f-psVkcKpV1
X-Proofpoint-ORIG-GUID: v7-alXoa75Z1adO1K5C17f-psVkcKpV1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-13_01,2025-08-11_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 adultscore=0 spamscore=0 impostorscore=0 suspectscore=0
 phishscore=0 bulkscore=0 priorityscore=1501 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2508120219


On 8/13/2025 1:30 PM, Alex Williamson wrote:
> On Wed, 13 Aug 2025 10:08:19 -0700
> Farhan Ali <alifm@linux.ibm.com> wrote:
>
>> For zPCI devices we should drive a platform specific function reset
>> as part of VFIO_DEVICE_RESET. This reset is needed recover a zPCI device
>> in error state.
>>
>> Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
>> ---
>>   arch/s390/pci/pci.c              |  1 +
>>   drivers/vfio/pci/vfio_pci_core.c |  4 ++++
>>   drivers/vfio/pci/vfio_pci_priv.h |  5 ++++
>>   drivers/vfio/pci/vfio_pci_zdev.c | 39 ++++++++++++++++++++++++++++++++
>>   4 files changed, 49 insertions(+)
>>
>> diff --git a/arch/s390/pci/pci.c b/arch/s390/pci/pci.c
>> index f795e05b5001..860a64993b58 100644
>> --- a/arch/s390/pci/pci.c
>> +++ b/arch/s390/pci/pci.c
>> @@ -788,6 +788,7 @@ int zpci_hot_reset_device(struct zpci_dev *zdev)
>>   
>>   	return rc;
>>   }
>> +EXPORT_SYMBOL_GPL(zpci_hot_reset_device);
>>   
>>   /**
>>    * zpci_create_device() - Create a new zpci_dev and add it to the zbus
>> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
>> index 7dcf5439dedc..7220a22135a9 100644
>> --- a/drivers/vfio/pci/vfio_pci_core.c
>> +++ b/drivers/vfio/pci/vfio_pci_core.c
>> @@ -1227,6 +1227,10 @@ static int vfio_pci_ioctl_reset(struct vfio_pci_core_device *vdev,
>>   	 */
>>   	vfio_pci_set_power_state(vdev, PCI_D0);
>>   
>> +	ret = vfio_pci_zdev_reset(vdev);
>> +	if (ret && ret != -ENODEV)
>> +		return ret;
>> +
>>   	ret = pci_try_reset_function(vdev->pdev);
>>   	up_write(&vdev->memory_lock);
> You're going to be very unhappy if this lock isn't released.
>
Ah yes, thanks for catching that. Will fix this.

>
>>   
>> diff --git a/drivers/vfio/pci/vfio_pci_priv.h b/drivers/vfio/pci/vfio_pci_priv.h
>> index a9972eacb293..5288577b3170 100644
>> --- a/drivers/vfio/pci/vfio_pci_priv.h
>> +++ b/drivers/vfio/pci/vfio_pci_priv.h
>> @@ -86,6 +86,7 @@ int vfio_pci_info_zdev_add_caps(struct vfio_pci_core_device *vdev,
>>   				struct vfio_info_cap *caps);
>>   int vfio_pci_zdev_open_device(struct vfio_pci_core_device *vdev);
>>   void vfio_pci_zdev_close_device(struct vfio_pci_core_device *vdev);
>> +int vfio_pci_zdev_reset(struct vfio_pci_core_device *vdev);
>>   #else
>>   static inline int vfio_pci_info_zdev_add_caps(struct vfio_pci_core_device *vdev,
>>   					      struct vfio_info_cap *caps)
>> @@ -100,6 +101,10 @@ static inline int vfio_pci_zdev_open_device(struct vfio_pci_core_device *vdev)
>>   
>>   static inline void vfio_pci_zdev_close_device(struct vfio_pci_core_device *vdev)
>>   {}
>> +int vfio_pci_zdev_reset(struct vfio_pci_core_device *vdev)
>> +{
>> +	return -ENODEV;
>> +}
>>   #endif
>>   
>>   static inline bool vfio_pci_is_vga(struct pci_dev *pdev)
>> diff --git a/drivers/vfio/pci/vfio_pci_zdev.c b/drivers/vfio/pci/vfio_pci_zdev.c
>> index 818235b28caa..dd1919ccb3be 100644
>> --- a/drivers/vfio/pci/vfio_pci_zdev.c
>> +++ b/drivers/vfio/pci/vfio_pci_zdev.c
>> @@ -212,6 +212,45 @@ static int vfio_pci_zdev_setup_err_region(struct vfio_pci_core_device *vdev)
>>   	return ret;
>>   }
>>   
>> +int vfio_pci_zdev_reset(struct vfio_pci_core_device *vdev)
>> +{
>> +	struct zpci_dev *zdev = to_zpci(vdev->pdev);
>> +	int rc = -EIO;
>> +
>> +	if (!zdev)
>> +		return -ENODEV;
>> +
>> +	/*
>> +	 * If we can't get the zdev->state_lock the device state is
>> +	 * currently undergoing a transition and we bail out - just
>> +	 * the same as if the device's state is not configured at all.
>> +	 */
>> +	if (!mutex_trylock(&zdev->state_lock))
>> +		return rc;
>> +
>> +	/* We can reset only if the function is configured */
>> +	if (zdev->state != ZPCI_FN_STATE_CONFIGURED)
>> +		goto out;
>> +
>> +	rc = zpci_hot_reset_device(zdev);
>> +	if (rc != 0)
>> +		goto out;
>> +
>> +	if (!vdev->pci_saved_state) {
>> +		pci_err(vdev->pdev, "No saved available for the device");
>> +		rc = -EIO;
>> +		goto out;
>> +	}
>> +
>> +	pci_dev_lock(vdev->pdev);
>> +	pci_load_saved_state(vdev->pdev, vdev->pci_saved_state);
>> +	pci_restore_state(vdev->pdev);
>> +	pci_dev_unlock(vdev->pdev);
>> +out:
>> +	mutex_unlock(&zdev->state_lock);
>> +	return rc;
>> +}
> This looks like it should be a device or arch specific reset
> implemented in drivers/pci, not vfio.  Thanks,
>
> Alex

Are you suggesting to move this to an arch specific function? One thing 
we need to do after the zpci_hot_reset_device, is to correctly restore 
the config space of the device. And for vfio-pci bound devices we want 
to restore the state of the device to when it was initially opened.

Thanks
Farhan


>
>> +
>>   int vfio_pci_zdev_open_device(struct vfio_pci_core_device *vdev)
>>   {
>>   	struct zpci_dev *zdev = to_zpci(vdev->pdev);

