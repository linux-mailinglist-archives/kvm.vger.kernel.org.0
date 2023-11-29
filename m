Return-Path: <kvm+bounces-2785-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 687D67FDE17
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 18:13:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D3C0EB211D5
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 17:13:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF6E446BBC;
	Wed, 29 Nov 2023 17:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="l0EVZnTS"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEB8CBC;
	Wed, 29 Nov 2023 09:13:08 -0800 (PST)
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3ATH70Ur005040;
	Wed, 29 Nov 2023 17:13:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=azPyXhZAO1/LTSGf53Txxbl0DE8jhzL3YiN2cyuqFac=;
 b=l0EVZnTSphWZ1qGZL+Sqz4tnQM9yZR09wdUK+E/dG2wKs9vTkJooo71/xSntJIGEswgw
 xkD04Q1WWcWns82lyQ6G0XHQVkmqf2QyVJ8mrk/nAUu1uufgXFrXpC3Evnz6LVHquNVt
 Ajlbd+JzBPw5rFF6L1ypJdHRG2vbeydfcI1O5ryMvfa47Vkl0fJIFNDYg9ZzK7XWqLiY
 zCd4jqnpRd4GZ9NO1dPSHQe2f0EMRIlRp1JDhLC4daFIew7PpMZpYpddahkvHgd+32H4
 zfawTDpKw666S9YilKWp9jqVI3j2NrSNiPKNqVCoRDrY5nLBwCXYwIkedVP188nL532p xg== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3up9ds07hj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 29 Nov 2023 17:13:04 +0000
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3ATH75Ha005199;
	Wed, 29 Nov 2023 17:12:50 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3up9ds06hv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 29 Nov 2023 17:12:50 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3ATGnLc7011187;
	Wed, 29 Nov 2023 17:12:38 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3ukwy2041w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 29 Nov 2023 17:12:38 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3ATHCZdT12845702
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Nov 2023 17:12:35 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1673020043;
	Wed, 29 Nov 2023 17:12:35 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8178420040;
	Wed, 29 Nov 2023 17:12:34 +0000 (GMT)
Received: from [9.179.21.219] (unknown [9.179.21.219])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 29 Nov 2023 17:12:34 +0000 (GMT)
Message-ID: <b43414ef-7aa4-9e5c-a706-41861f0d346c@linux.ibm.com>
Date: Wed, 29 Nov 2023 18:12:34 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH] s390/vfio-ap: handle response code 01 on queue reset
Content-Language: en-US
To: Tony Krowiak <akrowiak@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: jjherne@linux.ibm.com, pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com,
        david@redhat.com
References: <20231129143529.260264-1-akrowiak@linux.ibm.com>
From: Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20231129143529.260264-1-akrowiak@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: c0zicIJzmU0dgoEO2gJEoy8knN0XQPTy
X-Proofpoint-GUID: MlZMYa1VOAevDuZn0VXzPwp02-1s7FQk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-29_15,2023-11-29_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 mlxscore=0
 malwarescore=0 impostorscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 priorityscore=1501 lowpriorityscore=0 bulkscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311290131

Am 29.11.23 um 15:35 schrieb Tony Krowiak:
> In the current implementation, response code 01 (AP queue number not valid)
> is handled as a default case along with other response codes returned from
> a queue reset operation that are not handled specifically. Barring a bug,
> response code 01 will occur only when a queue has been externally removed
> from the host's AP configuration; nn this case, the queue must
> be reset by the machine in order to avoid leaking crypto data if/when the
> queue is returned to the host's configuration. The response code 01 case
> will be handled specifically by logging a WARN message followed by cleaning
> up the IRQ resources.
> 

To me it looks like this can be triggered by the LPAR admin, correct? So it
is not desireable but possible.
In that case I prefer to not use WARN, maybe use dev_warn or dev_err instead.
WARN can be a disruptive event if panic_on_warn is set.


> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> ---
>   drivers/s390/crypto/vfio_ap_ops.c | 31 +++++++++++++++++++++++++++++++
>   1 file changed, 31 insertions(+)
> 
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index 4db538a55192..91d6334574d8 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -1652,6 +1652,21 @@ static int apq_status_check(int apqn, struct ap_queue_status *status)
>   		 * a value indicating a reset needs to be performed again.
>   		 */
>   		return -EAGAIN;
> +	case AP_RESPONSE_Q_NOT_AVAIL:
> +		/*
> +		 * This response code indicates the queue is not available.
> +		 * Barring a bug, response code 01 will occur only when a queue
> +		 * has been externally removed from the host's AP configuration;
> +		 * in which case, the queue must be reset by the machine in
> +		 * order to avoid leaking crypto data if/when the queue is
> +		 * returned to the host's configuration. In this case, let's go
> +		 * ahead and log a warning message and return 0 so the AQIC
> +		 * resources get cleaned up by the caller.
> +		 */
> +		WARN(true,
> +		     "Unable to reset queue %02x.%04x: not in host AP configuration\n",
> +		     AP_QID_CARD(apqn), AP_QID_QUEUE(apqn));
> +			return 0;
>   	default:
>   		WARN(true,
>   		     "failed to verify reset of queue %02x.%04x: TAPQ rc=%u\n",
> @@ -1736,6 +1751,22 @@ static void vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q)
>   		q->reset_status.response_code = 0;
>   		vfio_ap_free_aqic_resources(q);
>   		break;
> +	case AP_RESPONSE_Q_NOT_AVAIL:
> +		/*
> +		 * This response code indicates the queue is not available.
> +		 * Barring a bug, response code 01 will occur only when a queue
> +		 * has been externally removed from the host's AP configuration;
> +		 * in which case, the queue must be reset by the machine in
> +		 * order to avoid leaking crypto data if/when the queue is
> +		 * returned to the host's configuration. In this case, let's go
> +		 * ahead and log a warning message then clean up the AQIC
> +		 * resources.
> +		 */
> +		WARN(true,
> +		     "Unable to reset queue %02x.%04x: not in host AP configuration\n",
> +		     AP_QID_CARD(q->apqn), AP_QID_QUEUE(q->apqn));
> +		vfio_ap_free_aqic_resources(q);
> +		break;
>   	default:
>   		WARN(true,
>   		     "PQAP/ZAPQ for %02x.%04x failed with invalid rc=%u\n",

