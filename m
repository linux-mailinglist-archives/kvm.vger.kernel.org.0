Return-Path: <kvm+bounces-1208-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EB7627E596A
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 15:44:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1A83A1C20B25
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 14:44:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 757147494;
	Wed,  8 Nov 2023 14:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="TT14SmgM"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D260DA4C
	for <kvm@vger.kernel.org>; Wed,  8 Nov 2023 14:44:31 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F604172E;
	Wed,  8 Nov 2023 06:44:31 -0800 (PST)
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A8EBQtj011401;
	Wed, 8 Nov 2023 14:44:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=8R4XpmhGAJxp8KL+Oel/9pqBG0NMrAtzm0/+s84mSl8=;
 b=TT14SmgMSJORVaZrL7929yH/c+0DrYNI2urPpZ8NiAzZYUdTiOONmHhY+XT2MVu4vnp8
 /+LyebBL9FISliCtOIrs4JO7S3uGp2Sk6vO62d+8Wu0f4H61MgcZLnsZQSYnjCdgBPka
 Qsu7Lv0HIIF3bIXftoti19f0sjLSn6MXCHhU+WigQ6PuH0CIJUIj1eowE8Vx0KvTHXXu
 g5HnQSzvc5+J9WrUTLhzxpZEqdqOomqaZNLh/qWKqzzmUOcOE2ruZeIWxlm+iwkU+ofr
 k/64T30BxABAxCahl9rrs8cwzzjafwTzcADSfaXSjpQIbYQPnBjdjtNHrAju3FJvwp+E eg== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u8bewj45x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Nov 2023 14:44:30 +0000
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3A8EfDEl032403;
	Wed, 8 Nov 2023 14:44:29 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u8bewj45k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Nov 2023 14:44:29 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3A8EEAOw004183;
	Wed, 8 Nov 2023 14:44:28 GMT
Received: from smtprelay06.wdc07v.mail.ibm.com ([172.16.1.73])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3u7w20wcpn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Nov 2023 14:44:28 +0000
Received: from smtpav03.wdc07v.mail.ibm.com (smtpav03.wdc07v.mail.ibm.com [10.39.53.230])
	by smtprelay06.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3A8EiR7Y26542616
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 8 Nov 2023 14:44:27 GMT
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 90CBF58064;
	Wed,  8 Nov 2023 14:44:27 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 788C95805D;
	Wed,  8 Nov 2023 14:44:26 +0000 (GMT)
Received: from [9.61.74.193] (unknown [9.61.74.193])
	by smtpav03.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  8 Nov 2023 14:44:26 +0000 (GMT)
Message-ID: <b9e7cdb5-30a2-4bba-9642-a2d3d05a9253@linux.ibm.com>
Date: Wed, 8 Nov 2023 09:44:25 -0500
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
To: freude@linux.ibm.com
Cc: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, jjherne@linux.ibm.com, pasic@linux.ibm.com,
        borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, david@redhat.com, stable@vger.kernel.org
References: <20231020204838.409521-1-akrowiak@linux.ibm.com>
 <cff6c61d-71a9-4dcc-a12a-5160b67d9ae4@linux.ibm.com>
 <12aef605a2add44afca75cc647674cdb@linux.ibm.com>
From: Tony Krowiak <akrowiak@linux.ibm.com>
Organization: IBM
In-Reply-To: <12aef605a2add44afca75cc647674cdb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: kbMuvIapmouIMViq467u_ZlZH7RhLhAz
X-Proofpoint-ORIG-GUID: Zj3n8L8LjmpDaZa7RpNZMeU-VcaJrHrK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-08_03,2023-11-08_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 bulkscore=0 suspectscore=0 adultscore=0 phishscore=0
 impostorscore=0 spamscore=0 mlxscore=0 lowpriorityscore=0 clxscore=1015
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311080121



On 11/7/23 03:07, Harald Freudenberger wrote:
> On 2023-11-06 17:03, Tony Krowiak wrote:
>> PING
>> This patch is pretty straight forward, does anyone see a reason why
>> this shouldn't be integrated?
>>
>> On 10/20/23 16:48, Tony Krowiak wrote:
>>> The 'status' attribute for AP queue devices bound to the vfio_ap device
>>> driver displays incorrect status when the mediated device is attached 
>>> to a
>>> guest, but the queue device is not passed through. In the current
>>> implementation, the status displayed is 'in_use' which is not 
>>> correct; it
>>> should be 'assigned'. This can happen if one of the queue devices
>>> associated with a given adapter is not bound to the vfio_ap device 
>>> driver.
>>> For example:
>>>
>>> Queues listed in /sys/bus/ap/drivers/vfio_ap:
>>> 14.0005
>>> 14.0006
>>> 14.000d
>>> 16.0006
>>> 16.000d
>>>
>>> Queues listed in /sys/devices/vfio_ap/matrix/$UUID/matrix
>>> 14.0005
>>> 14.0006
>>> 14.000d
>>> 16.0005
>>> 16.0006
>>> 16.000d
>>>
>>> Queues listed in /sys/devices/vfio_ap/matrix/$UUID/guest_matrix
>>> 14.0005
>>> 14.0006
>>> 14.000d
>>>
>>> The reason no queues for adapter 0x16 are listed in the guest_matrix is
>>> because queue 16.0005 is not bound to the vfio_ap device driver, so no
>>> queue associated with the adapter is passed through to the guest;
>>> therefore, each queue device for adapter 0x16 should display 'assigned'
>>> instead of 'in_use', because those queues are not in use by a guest, but
>>> only assigned to the mediated device.
>>>
>>> Let's check the AP configuration for the guest to determine whether a
>>> queue device is passed through before displaying a status of 'in_use'.
>>>
>>> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
>>> Fixes: f139862b92cf ("s390/vfio-ap: add status attribute to AP queue 
>>> device's sysfs dir")
>>> Cc: stable@vger.kernel.org
>>> ---
>>>   drivers/s390/crypto/vfio_ap_ops.c | 7 ++++++-
>>>   1 file changed, 6 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/s390/crypto/vfio_ap_ops.c 
>>> b/drivers/s390/crypto/vfio_ap_ops.c
>>> index 4db538a55192..871c14a6921f 100644
>>> --- a/drivers/s390/crypto/vfio_ap_ops.c
>>> +++ b/drivers/s390/crypto/vfio_ap_ops.c
>>> @@ -1976,6 +1976,7 @@ static ssize_t status_show(struct device *dev,
>>>   {
>>>       ssize_t nchars = 0;
>>>       struct vfio_ap_queue *q;
>>> +    unsigned long apid, apqi;
>>>       struct ap_matrix_mdev *matrix_mdev;
>>>       struct ap_device *apdev = to_ap_dev(dev);
>>>   @@ -1984,7 +1985,11 @@ static ssize_t status_show(struct device *dev,
>>>       matrix_mdev = vfio_ap_mdev_for_queue(q);
>>>         if (matrix_mdev) {
>>> -        if (matrix_mdev->kvm)
>>> +        apid = AP_QID_CARD(q->apqn);
>>> +        apqi = AP_QID_QUEUE(q->apqn);
>>> +        if (matrix_mdev->kvm &&
>>> +            test_bit_inv(apid, matrix_mdev->shadow_apcb.apm) &&
>>> +            test_bit_inv(apqi, matrix_mdev->shadow_apcb.aqm))
>>>               nchars = scnprintf(buf, PAGE_SIZE, "%s\n",
>>>                          AP_QUEUE_IN_USE);
>>>           else
> 
> I can give you an
> Acked-by: Harald Freudenberger <freude@linux.ibm.com>
> for this. Your explanation sounds sane to me and fixes a wrong
> display. However, I am not familiar with the code so, I can't tell
> if that's correct.
> Just a remark: How can it happen that one queue is not bound to the vfio 
> dd?
> Didn't we actively remove the unbind possibility from the sysfs for devices
> assigned to the vfio dd?

A device bound to the vfio_ap device driver can be manually unbound; 
however, it can not be unbound by the AP bus via a change to the 
apmask/aqmask attributes if it is assigned to a mediated device.

At one point I wanted to remove the unbind sysfs attribute, but as I 
recall I was talked out of it.


