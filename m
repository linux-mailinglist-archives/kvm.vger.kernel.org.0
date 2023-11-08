Return-Path: <kvm+bounces-1274-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 05D787E5F15
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 21:21:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B46D42815B2
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 20:21:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 016D937178;
	Wed,  8 Nov 2023 20:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="KGL1jXLw"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 181883716F
	for <kvm@vger.kernel.org>; Wed,  8 Nov 2023 20:21:25 +0000 (UTC)
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06F152134;
	Wed,  8 Nov 2023 12:21:24 -0800 (PST)
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A8KFWNO007888;
	Wed, 8 Nov 2023 20:21:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : from : to : cc : references : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=JWLjtEDsbu9pQezW8V3iE5wEiBaU0MWE30c+dgKsRU4=;
 b=KGL1jXLwtWr3iWohog/wEZhBrM8GoluuvcdEdNE4mnpEXmD7nmV73twEgBJ1ZSot/mOx
 StCFyLKycBzfbNm3PDVafkEGDJDy3MuU1/zCXrxktDeY5d5r98EF8GW5jhvQccBUYnV/
 yPk8YWCRDW6RiISX1vXifv1rDVj9FVnUkg43ZWQwb90w7fHmFn06KBHYmcSNqSWa9R9k
 ZDQDtfCJFAn74GPR/kdo7JGgHTrn9mEerrWeKR+7wUP09+oT3Zb6YUTEdCRP+GXJMmOd
 E94YFScCrTYv3i+gf4LV1WOiDGrn7JK7FgqfHXyyxwITpCjise+nJdR3bNXubrxdMK20 4w== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u8fyf2fru-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Nov 2023 20:21:23 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3A8KFwS8010853;
	Wed, 8 Nov 2023 20:21:23 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u8fyf2fra-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Nov 2023 20:21:23 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3A8J2k0q014372;
	Wed, 8 Nov 2023 20:21:22 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([172.16.1.72])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3u7w21ybqc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Nov 2023 20:21:22 +0000
Received: from smtpav03.wdc07v.mail.ibm.com (smtpav03.wdc07v.mail.ibm.com [10.39.53.230])
	by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3A8KLLur25362986
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 8 Nov 2023 20:21:22 GMT
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E3D185805F;
	Wed,  8 Nov 2023 20:21:21 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CE7AB58062;
	Wed,  8 Nov 2023 20:21:20 +0000 (GMT)
Received: from [9.61.74.193] (unknown [9.61.74.193])
	by smtpav03.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  8 Nov 2023 20:21:20 +0000 (GMT)
Message-ID: <17ef8d76-5dec-46a3-84e1-1b92fadd27b0@linux.ibm.com>
Date: Wed, 8 Nov 2023 15:21:20 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] s390/vfio-ap: fix sysfs status attribute for AP queue
 devices
Content-Language: en-US
From: Tony Krowiak <akrowiak@linux.ibm.com>
To: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc: jjherne@linux.ibm.com, pasic@linux.ibm.com, borntraeger@linux.ibm.com,
        frankja@linux.ibm.com, imbrenda@linux.ibm.com, david@redhat.com,
        Harald Freudenberger <freude@linux.ibm.com>
References: <20231108201135.351419-1-akrowiak@linux.ibm.com>
Organization: IBM
In-Reply-To: <20231108201135.351419-1-akrowiak@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Knz054HCiTxFwKUszYpj6N7jesrU_sJZ
X-Proofpoint-ORIG-GUID: aTanNe0nwYMzlVTApE8mmgOKt61P-bZ4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-08_09,2023-11-08_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 malwarescore=0 clxscore=1015 phishscore=0 mlxscore=0
 impostorscore=0 mlxlogscore=999 suspectscore=0 spamscore=0 bulkscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311080167

Christian,
Can this be pushed with the Acks by Halil and Harald?

On 11/8/23 15:11, Tony Krowiak wrote:
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
> Acked-by: Halil Pasic <pasic@linux.ibm.com>
> Acked-by: Harald Freudenberger <freude@linux.ibm.com>
> ---
>   drivers/s390/crypto/vfio_ap_ops.c | 16 +++++++++++++++-
>   1 file changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index 4db538a55192..6e0a79086656 100644
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
> @@ -1983,8 +1984,21 @@ static ssize_t status_show(struct device *dev,
>   	q = dev_get_drvdata(&apdev->device);
>   	matrix_mdev = vfio_ap_mdev_for_queue(q);
>   
> +	/* If the queue is assigned to the matrix mediated device, then
> +	 * determine whether it is passed through to a guest; otherwise,
> +	 * indicate that it is unassigned.
> +	 */
>   	if (matrix_mdev) {
> -		if (matrix_mdev->kvm)
> +		apid = AP_QID_CARD(q->apqn);
> +		apqi = AP_QID_QUEUE(q->apqn);
> +		/*
> +		 * If the queue is passed through to the guest, then indicate
> +		 * that it is in use; otherwise, indicate that it is
> +		 * merely assigned to a matrix mediated device.
> +		 */
> +		if (matrix_mdev->kvm &&
> +		    test_bit_inv(apid, matrix_mdev->shadow_apcb.apm) &&
> +		    test_bit_inv(apqi, matrix_mdev->shadow_apcb.aqm))
>   			nchars = scnprintf(buf, PAGE_SIZE, "%s\n",
>   					   AP_QUEUE_IN_USE);
>   		else

