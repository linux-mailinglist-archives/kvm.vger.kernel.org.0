Return-Path: <kvm+bounces-785-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DE02B7E295B
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 17:04:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3B5B8B21037
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 16:04:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CF9D28E3D;
	Mon,  6 Nov 2023 16:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="BDy1w+uF"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A2AF250FE
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 16:04:05 +0000 (UTC)
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F7A613E;
	Mon,  6 Nov 2023 08:04:03 -0800 (PST)
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A6FeF2u017483;
	Mon, 6 Nov 2023 16:04:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : from : to : cc : references : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=MGbbZNP/mdzm3S/5Ztp69aF9Y4qswVAtQclS9ietJKA=;
 b=BDy1w+uFOknc7t5DYyGqJGcHUTt6dv3FKCK/HR3bGpWQrSCuZ8jKax3vcPrMruTzgHmy
 acAzgCUG97l4NIjYh9M1Bh+oErIOOL+sA96962qwVqEfEaK9vHFqZ5AfwQxn33dQXl/w
 0WkKJLEa0XwSPG9Io+U0x6hN5B+c+9zil1adB8w5dnDTdnu6TBd1ca/2rQuEdP5VaqLT
 M8rgKTqAEeY/5GapWj9HtEvI6fsfThbauiDb7ttsb/j5xKoFmL8eulBokAaqEHIa3sz/
 wu5hvlpjRYWrgdkjTxzztOt8RJA776v0cqy6L53LinzHQWIzkPwTO//en9Etyag87oXe dA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u7302rvg6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Nov 2023 16:04:00 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3A6FeiEY020142;
	Mon, 6 Nov 2023 16:03:53 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u7302rvax-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Nov 2023 16:03:53 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3A6FZvQk012848;
	Mon, 6 Nov 2023 16:03:41 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([172.16.1.9])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3u609sjpge-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Nov 2023 16:03:41 +0000
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
	by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3A6G3e2615008032
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 6 Nov 2023 16:03:41 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D48A158063;
	Mon,  6 Nov 2023 16:03:40 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CB9EC58053;
	Mon,  6 Nov 2023 16:03:39 +0000 (GMT)
Received: from [9.61.121.140] (unknown [9.61.121.140])
	by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  6 Nov 2023 16:03:39 +0000 (GMT)
Message-ID: <cff6c61d-71a9-4dcc-a12a-5160b67d9ae4@linux.ibm.com>
Date: Mon, 6 Nov 2023 11:03:39 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] s390/vfio-ap: fix sysfs status attribute for AP queue
 devices
Content-Language: en-US
From: Tony Krowiak <akrowiak@linux.ibm.com>
To: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc: jjherne@linux.ibm.com, pasic@linux.ibm.com, borntraeger@linux.ibm.com,
        frankja@linux.ibm.com, imbrenda@linux.ibm.com, david@redhat.com,
        stable@vger.kernel.org
References: <20231020204838.409521-1-akrowiak@linux.ibm.com>
Organization: IBM
In-Reply-To: <20231020204838.409521-1-akrowiak@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: dsx9XxmwV9OrZfFiJB7AK9_H2MfZQJl8
X-Proofpoint-GUID: v-z6IauqZ0fi2RxW9WwV0zFaK3ZLHkdN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-06_12,2023-11-02_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 spamscore=0 impostorscore=0 suspectscore=0 mlxscore=0 bulkscore=0
 lowpriorityscore=0 adultscore=0 clxscore=1015 mlxlogscore=999 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310240000 definitions=main-2311060129

PING
This patch is pretty straight forward, does anyone see a reason why this 
shouldn't be integrated?

On 10/20/23 16:48, Tony Krowiak wrote:
> The 'status' attribute for AP queue devices bound to the vfio_ap device
> driver displays incorrect status when the mediated device is attached to a
> guest, but the queue device is not passed through. In the current
> implementation, the status displayed is 'in_use' which is not correct; it
> should be 'assigned'. This can happen if one of the queue devices
> associated with a given adapter is not bound to the vfio_ap device driver.
> For example:
> 
> Queues listed in /sys/bus/ap/drivers/vfio_ap:
> 14.0005
> 14.0006
> 14.000d
> 16.0006
> 16.000d
> 
> Queues listed in /sys/devices/vfio_ap/matrix/$UUID/matrix
> 14.0005
> 14.0006
> 14.000d
> 16.0005
> 16.0006
> 16.000d
> 
> Queues listed in /sys/devices/vfio_ap/matrix/$UUID/guest_matrix
> 14.0005
> 14.0006
> 14.000d
> 
> The reason no queues for adapter 0x16 are listed in the guest_matrix is
> because queue 16.0005 is not bound to the vfio_ap device driver, so no
> queue associated with the adapter is passed through to the guest;
> therefore, each queue device for adapter 0x16 should display 'assigned'
> instead of 'in_use', because those queues are not in use by a guest, but
> only assigned to the mediated device.
> 
> Let's check the AP configuration for the guest to determine whether a
> queue device is passed through before displaying a status of 'in_use'.
> 
> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> Fixes: f139862b92cf ("s390/vfio-ap: add status attribute to AP queue device's sysfs dir")
> Cc: stable@vger.kernel.org
> ---
>   drivers/s390/crypto/vfio_ap_ops.c | 7 ++++++-
>   1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index 4db538a55192..871c14a6921f 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -1976,6 +1976,7 @@ static ssize_t status_show(struct device *dev,
>   {
>   	ssize_t nchars = 0;
>   	struct vfio_ap_queue *q;
> +	unsigned long apid, apqi;
>   	struct ap_matrix_mdev *matrix_mdev;
>   	struct ap_device *apdev = to_ap_dev(dev);
>   
> @@ -1984,7 +1985,11 @@ static ssize_t status_show(struct device *dev,
>   	matrix_mdev = vfio_ap_mdev_for_queue(q);
>   
>   	if (matrix_mdev) {
> -		if (matrix_mdev->kvm)
> +		apid = AP_QID_CARD(q->apqn);
> +		apqi = AP_QID_QUEUE(q->apqn);
> +		if (matrix_mdev->kvm &&
> +		    test_bit_inv(apid, matrix_mdev->shadow_apcb.apm) &&
> +		    test_bit_inv(apqi, matrix_mdev->shadow_apcb.aqm))
>   			nchars = scnprintf(buf, PAGE_SIZE, "%s\n",
>   					   AP_QUEUE_IN_USE);
>   		else

