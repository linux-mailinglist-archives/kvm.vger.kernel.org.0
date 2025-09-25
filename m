Return-Path: <kvm+bounces-58785-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BF4C3BA09B8
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 18:29:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7E079562E34
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 16:29:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90248306B0C;
	Thu, 25 Sep 2025 16:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="CbGMM5Bu"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 539AF21E091;
	Thu, 25 Sep 2025 16:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758817767; cv=none; b=qKXJNMjJVLwkWXH/LgMa9RN5EE1OtJbytvgyMUYGE0TtVDJoi3OfSq0zOxM1nqD6v0PCYBypvU9JTCwPWryQ4A3kcydDFpa8fn9Bd+WikTLJh0gmCVKn42f0b3vSn5zZFoR3dY9au0QqVdc/32Hnr7TtQ/Couj+4ELOCEZWvx2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758817767; c=relaxed/simple;
	bh=JUkaMlRnrLdVlEQcDzazaCH86J3W+GxapAK8XNF3xAM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CSpLtUUy98EDBawhrO4j6Y00qqmrYwnEms77fwOKeHnqeyV2GdfT9ktgqjB8m1DCBN/AIjrrxWSGIynUxtErnys2X2TPqIP/SXIFOIdoi0KLHNFl1rbPqCJUDuNgLnavUc5WvMWpEY3ev/1Up/PNFQ2SBbWOCMl0Dx4Gd+jySSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=CbGMM5Bu; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58PDMIMu022074;
	Thu, 25 Sep 2025 16:29:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=F/EeUH
	OmIBEUQQ325bs5/e9x8/Cev2WLTj4miF9tEyg=; b=CbGMM5BumYDwhqOxP+e6ZV
	or11EmtNvoQqrqhaJEK/8NKXm6KeRi2F4L8Mu7GmA+MD9zVaOQtsE8j8x5Oz6pjX
	i1x2trldIbDOuOhOUnB4ihXdMVV2+u/kEwT2BzXwY+XyN+dReYHcqbEF5dRkttVn
	D1jyIWXkInIptYemtcLhlcdppYIDrioFjighpY2/4wMFn6YFOs59k8F65t1T0ux1
	8N1iv80a7NRob9+102V3RKsCioK72Rs9GDYAzvhpxL+lCWHDEsPCB7MYasfiCMoz
	Ye4MKjL5pcewqbqTNOKqU+zuHkck6l2fga/pDKwXwOqMAwQYkMt3bNsTYrdYjioQ
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 499ksc72tv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 25 Sep 2025 16:29:19 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58PG7Fiw008294;
	Thu, 25 Sep 2025 16:29:18 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([172.16.1.8])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 49a6yy71n1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 25 Sep 2025 16:29:18 +0000
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
	by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58PGTHeF33686064
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 25 Sep 2025 16:29:17 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 634B658059;
	Thu, 25 Sep 2025 16:29:17 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BF99758055;
	Thu, 25 Sep 2025 16:29:16 +0000 (GMT)
Received: from [9.61.240.76] (unknown [9.61.240.76])
	by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 25 Sep 2025 16:29:16 +0000 (GMT)
Message-ID: <e8def2b9-bb37-4595-9e2e-0d1947e8f197@linux.ibm.com>
Date: Thu, 25 Sep 2025 09:29:05 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 07/10] s390/pci: Store PCI error information for
 passthrough devices
To: Niklas Schnelle <schnelle@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Cc: alex.williamson@redhat.com, helgaas@kernel.org, clg@redhat.com,
        mjrosato@linux.ibm.com
References: <20250924171628.826-1-alifm@linux.ibm.com>
 <20250924171628.826-8-alifm@linux.ibm.com>
 <d22cb26b864362454ace07ed5fcb9758c40ee32e.camel@linux.ibm.com>
Content-Language: en-US
From: Farhan Ali <alifm@linux.ibm.com>
In-Reply-To: <d22cb26b864362454ace07ed5fcb9758c40ee32e.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Ri0q2tuMKLdxT4k6o-H2gx71sLmpXsiM
X-Proofpoint-GUID: Ri0q2tuMKLdxT4k6o-H2gx71sLmpXsiM
X-Authority-Analysis: v=2.4 cv=SdH3duRu c=1 sm=1 tr=0 ts=68d56de0 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=gxxouCQkyeS9uqHApw0A:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTIwMDAyMCBTYWx0ZWRfX0JDCNMHq+Xql
 yxmf6bkUHiSvJG3GoHsv86LspvTaFoObfxiULJSvskdUe0G/3Y89hi7wGlXm37Uw9gafbPsEQkX
 O6PEfVkAXRnMY3gLbCtyD0Bp5nkSs4FF2u+xzoI1WH3zodKq/bHE9GysQjA+nuVii3roNvxRU2O
 WyVg3B1gaqgOqNGKA1QbfxOR8IEG0t2HoTT/HrOTvds6AZIUesCfN/wSJnb9OVdPm6A9fzlmIni
 2S4hSwj5wttHc5tatjc5kCBVr4Nqt0Ef+/GyfZTxYiiMkbv9arN/EaeMQu0fzgy/cUcERcFtkSM
 NZapFR+/xrZW5GkQMderJ/4BGFMLk9fi3QsIxOvEEQhc58NStuIpXctVzBflpHMn/78/4sxGtOq
 k2ZgY+BU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-25_01,2025-09-25_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 phishscore=0 spamscore=0 bulkscore=0
 priorityscore=1501 clxscore=1015 adultscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509200020

>> +void zpci_cleanup_pending_errors(struct zpci_dev *zdev)
>> +{
>> +	struct pci_dev *pdev = NULL;
>> +
>> +	mutex_lock(&zdev->pending_errs_lock);
>> +	pdev = pci_get_slot(zdev->zbus->bus, zdev->devfn);
> I think you missed my comment on the previous version. This is missing
> the matching pci_dev_put() for the pci_get_slot().

Ah yes indeed i missed that comment, my apologies. Will fixup.


>
>> +	if (zdev->pending_errs.count)
>> +		pr_info("%s: Unhandled PCI error events count=%d",
>> +				pci_name(pdev), zdev->pending_errs.count);
>> +	memset(&zdev->pending_errs, 0, sizeof(struct zpci_ccdf_pending));
>> +	mutex_unlock(&zdev->pending_errs_lock);
>> +}
>> +EXPORT_SYMBOL_GPL(zpci_cleanup_pending_errors);
>> +
>>
> --- snip ---
>>   
>> @@ -322,12 +340,13 @@ static void __zpci_event_error(struct zpci_ccdf_err *ccdf)
>>   		break;
>>   	case 0x0040: /* Service Action or Error Recovery Failed */
>>   	case 0x003b:
>> -		zpci_event_io_failure(pdev, pci_channel_io_perm_failure);
>> +		zpci_event_io_failure(pdev, pci_channel_io_perm_failure, ccdf);
>>   		break;
>>   	default: /* PCI function left in the error state attempt to recover */
>> -		ers_res = zpci_event_attempt_error_recovery(pdev);
>> +		ers_res = zpci_event_attempt_error_recovery(pdev, ccdf);
>>   		if (ers_res != PCI_ERS_RESULT_RECOVERED)
>> -			zpci_event_io_failure(pdev, pci_channel_io_perm_failure);
>> +			zpci_event_io_failure(pdev, pci_channel_io_perm_failure,
>> +					ccdf);
> Nit: I'd just keep the above on one line. It's still below the 100
> columns limit and just cleaner on one line.

I think I did this for checkpatch warning, but can move it back and see 
if the warning happens.

Thanks
Farhan

>
>>   		break;
>>   	}
>>   	pci_dev_put(pdev);
>> diff --git a/drivers/vfio/pci/vfio_pci_zdev.c b/drivers/vfio/pci/vfio_pci_zdev.c
>> index a7bc23ce8483..2be37eab9279 100644
>> --- a/drivers/vfio/pci/vfio_pci_zdev.c
>> +++ b/drivers/vfio/pci/vfio_pci_zdev.c
>> @@ -168,6 +168,8 @@ void vfio_pci_zdev_close_device(struct vfio_pci_core_device *vdev)
>>   
>>   	zdev->mediated_recovery = false;
>>   
>> +	zpci_cleanup_pending_errors(zdev);
>> +
>>   	if (!vdev->vdev.kvm)
>>   		return;
>>   

