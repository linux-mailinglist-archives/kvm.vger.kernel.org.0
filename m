Return-Path: <kvm+bounces-40763-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7901BA5BDF4
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 11:34:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CC82D3AC9F6
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 10:34:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8024238D3B;
	Tue, 11 Mar 2025 10:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="trMzo645"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EB182206BD;
	Tue, 11 Mar 2025 10:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741689267; cv=none; b=hu0NfGNYa1hvSGD+QJSdr4FxLpg9jrkOAiw9zlQYS+DIKxXFIERR3Z9Jcn1IDk1vPh4PKQtTD6n39FCGgKlHXwokFUltpayA7jj6TXr3lbK+FqSR3VDsTPfehb3JAKW1vbpm9adog5o7T+9XoFXQuOdrolca4ygV7M1l8brE8II=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741689267; c=relaxed/simple;
	bh=S6wR8udc4flcNC99ou/zTegE4/iCZsKNPsN00sFe5JY=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=i18lwUaUiWtLU1jMK+twTcMXFmKUou0pnTE/yl9lbfIfzB6p43aqaZLWB/mAtSZ2CK/MiOTM5e4ZY/3bnVkcFLjca1SvV2yN7+6n5UhSYft6R7jQqOSwXIpBL5Ylv4W5J7o/Fu7X0URi1m0tkHRJga8ehLD0JnERHP8fWFReCLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=trMzo645; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52B9PUlB026764;
	Tue, 11 Mar 2025 10:34:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=EXkS22
	ubkiuuVZA6TyT0Ek4W0I7j3tntZa9y+PgAqPY=; b=trMzo645qIlqFJAT49IzMv
	2vDkujAdoEQVpBBLzVQzF0tPMmnVljAtYe3VUGtzrzh7vETw2NnCja7Or7mToRJV
	znmFcOsdnnnasBQaOXbWhGcx2Cne/YR2iJFxFnQg8179zc6Bo1atS4XR6QkpPgLt
	xTZDQJh4KG07VqOgBRXcr+Oin1L5O+iUnS4iwsoLm5HozVQHk7Tcjj9wx6Cfwg04
	kfKuIjW2Y5l1ZAKmMdLHFR4sHcY2LMfBuN6RD/TIb7pVeBtBBB0CwmsUlYzhFasl
	HBYBrMkVJ/QbwkPMl0w1iBQP6RF8lczqfUq1Ee/EB/cJ2Q8PWfn7OlbnWbhIJJlg
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 45a7a1b7kd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 11 Mar 2025 10:34:23 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 52B8gOBK007011;
	Tue, 11 Mar 2025 10:34:22 GMT
Received: from smtprelay05.dal12v.mail.ibm.com ([172.16.1.7])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 45907t3v70-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 11 Mar 2025 10:34:22 +0000
Received: from smtpav01.dal12v.mail.ibm.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
	by smtprelay05.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 52BAYMbr24117960
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Mar 2025 10:34:22 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1582258064;
	Tue, 11 Mar 2025 10:34:22 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 313C85806B;
	Tue, 11 Mar 2025 10:34:21 +0000 (GMT)
Received: from [9.61.127.211] (unknown [9.61.127.211])
	by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 11 Mar 2025 10:34:21 +0000 (GMT)
Message-ID: <ff033f2a-b82c-4c7b-a45d-71c674892b2d@linux.ibm.com>
Date: Tue, 11 Mar 2025 06:34:20 -0400
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] s390/vfio-ap: lock mdev object when handling mdev remove
 request
From: Anthony Krowiak <akrowiak@linux.ibm.com>
To: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc: jjherne@linux.ibm.com, pasic@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, borntraeger@linux.ibm.com,
        alex.williamson@redhat.com, clg@redhat.com, mjrosato@linux.ibm.com,
        stable@vger.kernel.org
References: <20250221153238.3242737-1-akrowiak@linux.ibm.com>
Content-Language: en-US
In-Reply-To: <20250221153238.3242737-1-akrowiak@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: RoiwAMSpPJPPSrY5iB4UQV1ltiLJsWnr
X-Proofpoint-GUID: RoiwAMSpPJPPSrY5iB4UQV1ltiLJsWnr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-11_01,2025-03-11_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 lowpriorityscore=0 mlxlogscore=999 malwarescore=0
 clxscore=1015 mlxscore=0 impostorscore=0 bulkscore=0 spamscore=0
 suspectscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2502100000 definitions=main-2503110070

PING!


On 2/21/25 10:32 AM, Anthony Krowiak wrote:
> The vfio_ap_mdev_request function in drivers/s390/crypto/vfio_ap_ops.c
> accesses fields of an ap_matrix_mdev object without ensuring that the
> object is accessed by only one thread at a time. This patch adds the lock
> necessary to secure access to the ap_matrix_mdev object.
>
> Fixes: 2e3d8d71e285 ("s390/vfio-ap: wire in the vfio_device_ops request callback")
> Signed-off-by: Anthony Krowiak <akrowiak@linux.ibm.com>
> Cc: <stable@vger.kernel.org>
> ---
>   drivers/s390/crypto/vfio_ap_ops.c | 3 +++
>   1 file changed, 3 insertions(+)
>
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index a52c2690933f..a2784d3357d9 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -2045,6 +2045,7 @@ static void vfio_ap_mdev_request(struct vfio_device *vdev, unsigned int count)
>   	struct ap_matrix_mdev *matrix_mdev;
>   
>   	matrix_mdev = container_of(vdev, struct ap_matrix_mdev, vdev);
> +	mutex_lock(&matrix_dev->mdevs_lock);
>   
>   	if (matrix_mdev->req_trigger) {
>   		if (!(count % 10))
> @@ -2057,6 +2058,8 @@ static void vfio_ap_mdev_request(struct vfio_device *vdev, unsigned int count)
>   		dev_notice(dev,
>   			   "No device request registered, blocked until released by user\n");
>   	}
> +
> +	mutex_unlock(&matrix_dev->mdevs_lock);
>   }
>   
>   static int vfio_ap_mdev_get_device_info(unsigned long arg)


