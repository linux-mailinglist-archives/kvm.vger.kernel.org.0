Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D08842B9BD1
	for <lists+kvm@lfdr.de>; Thu, 19 Nov 2020 21:05:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727189AbgKSUEP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Nov 2020 15:04:15 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:57016 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726567AbgKSUEP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 19 Nov 2020 15:04:15 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AJK3cYv043013;
        Thu, 19 Nov 2020 15:04:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=figsb8yB5xo4yw3ajG1C3J4Mia80Yro+B5IPff6sMbA=;
 b=AsawqiMQkocMylH/6hD94QC+B68eER5PMt5zEj5+qidyX07/7Yw5algnd/9A5/5e1B2m
 71Jsho1wmlZRfGxGE3LW2CcReHPWPaA2qXqt+c8LRTFZ5E5tTYXACS6HbkPRrTMpfgho
 ZHA4XBfyfTuNyLx60ErgUHQcKZP+XFySx+gM1a4eIiolhqFjaLHUnpHy2wsM8vq3O80n
 VBXmMh4NbF/BnaJ3we1Oya9FMl5NwoXcGRMJQXYOmph+kU39Eawrm3AhQ+JMoaMHLdfx
 rSLvvAC46HmrYwHDU4rHJ3QekDb+hy8/bNbKFp+te7dQU/IAutDe0u0kkdOPZW3dY2oP yg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34w4xqy91p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Nov 2020 15:04:14 -0500
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0AJK3r0w045861;
        Thu, 19 Nov 2020 15:04:13 -0500
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34w4xqy90h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Nov 2020 15:04:13 -0500
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AJJuqLu001460;
        Thu, 19 Nov 2020 20:04:12 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma02dal.us.ibm.com with ESMTP id 34vgjmwt0r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Nov 2020 20:04:12 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AJK4BwX10093224
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Nov 2020 20:04:11 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2036DB205F;
        Thu, 19 Nov 2020 20:04:11 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BE281B2064;
        Thu, 19 Nov 2020 20:04:09 +0000 (GMT)
Received: from [9.163.28.108] (unknown [9.163.28.108])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 19 Nov 2020 20:04:09 +0000 (GMT)
Subject: Re: [RFC PATCH 1/2] vfio-mdev: Wire in a request handler for mdev
 parent
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
Cc:     Kirti Wankhede <kwankhede@nvidia.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
References: <20201117032139.50988-1-farman@linux.ibm.com>
 <20201117032139.50988-2-farman@linux.ibm.com>
 <20201119123026.1353cb3c.cohuck@redhat.com>
 <20201119092754.240847b8@w520.home>
From:   Eric Farman <farman@linux.ibm.com>
Message-ID: <27946d84-ae22-6882-67a5-edb5bd782bfa@linux.ibm.com>
Date:   Thu, 19 Nov 2020 15:04:08 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201119092754.240847b8@w520.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-19_10:2020-11-19,2020-11-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=999 spamscore=0 impostorscore=0 mlxscore=0 adultscore=0
 phishscore=0 clxscore=1015 lowpriorityscore=0 malwarescore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011190134
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11/19/20 11:27 AM, Alex Williamson wrote:
> On Thu, 19 Nov 2020 12:30:26 +0100
> Cornelia Huck <cohuck@redhat.com> wrote:
> 
>> On Tue, 17 Nov 2020 04:21:38 +0100
>> Eric Farman <farman@linux.ibm.com> wrote:
>>
>>> While performing some destructive tests with vfio-ccw, where the
>>> paths to a device are forcible removed and thus the device itself
>>> is unreachable, it is rather easy to end up in an endless loop in
>>> vfio_del_group_dev() due to the lack of a request callback for the
>>> associated device.
>>>
>>> In this example, one MDEV (77c) is used by a guest, while another
>>> (77b) is not. The symptom is that the iommu is detached from the
>>> mdev for 77b, but not 77c, until that guest is shutdown:
>>>
>>>      [  238.794867] vfio_ccw 0.0.077b: MDEV: Unregistering
>>>      [  238.794996] vfio_mdev 11f2d2bc-4083-431d-a023-eff72715c4f0: Removing from iommu group 2
>>>      [  238.795001] vfio_mdev 11f2d2bc-4083-431d-a023-eff72715c4f0: MDEV: detaching iommu
>>>      [  238.795036] vfio_ccw 0.0.077c: MDEV: Unregistering
>>>      ...silence...
>>>
>>> Let's wire in the request call back to the mdev device, so that a hot
>>> unplug can be (gracefully?) handled by the parent device at the time
>>> the device is being removed.
>>
>> I think it makes a lot of sense to give the vendor driver a way to
>> handle requests.
>>
>>>
>>> Signed-off-by: Eric Farman <farman@linux.ibm.com>
>>> ---
>>>   drivers/vfio/mdev/vfio_mdev.c | 11 +++++++++++
>>>   include/linux/mdev.h          |  4 ++++
>>>   2 files changed, 15 insertions(+)
>>>
>>> diff --git a/drivers/vfio/mdev/vfio_mdev.c b/drivers/vfio/mdev/vfio_mdev.c
>>> index 30964a4e0a28..2dd243f73945 100644
>>> --- a/drivers/vfio/mdev/vfio_mdev.c
>>> +++ b/drivers/vfio/mdev/vfio_mdev.c
>>> @@ -98,6 +98,16 @@ static int vfio_mdev_mmap(void *device_data, struct vm_area_struct *vma)
>>>   	return parent->ops->mmap(mdev, vma);
>>>   }
>>>   
>>> +static void vfio_mdev_request(void *device_data, unsigned int count)
>>> +{
>>> +	struct mdev_device *mdev = device_data;
>>> +	struct mdev_parent *parent = mdev->parent;
>>> +
>>> +	if (unlikely(!parent->ops->request))
>>
>> Hm. Do you think that all drivers should implement a ->request()
>> callback?
> 
> It's considered optional for bus drivers in vfio-core, obviously
> mdev-core could enforce presence of this callback, but then we'd break
> existing out of tree drivers.  We don't make guarantees to out of tree
> drivers, but it feels a little petty.  We could instead encourage such
> support by printing a warning for drivers that register without a
> request callback.

Coincidentally, I'd considered adding a dev_warn_once() message in
drivers/vfio/vfio.c:vfio_del_group_dev() when vfio_device->ops->request
is NULL, and thus we're looping endlessly (and silently). But adding 
this patch and not patch 2 made things silent again, so I left it out. 
Putting a warning when the driver registers seems cool.

> 
> Minor nit, I tend to prefer:
> 
> 	if (callback for thing)
> 		call thing
> 
> Rather than
> 
> 	if (!callback for thing)
> 		return;
> 	call thing

I like it too.  I'll set it up that way in v2.

> 
> Thanks,
> Alex
> 
>>
>>> +		return;
>>> +	parent->ops->request(mdev, count);
>>> +}
>>> +
>>>   static const struct vfio_device_ops vfio_mdev_dev_ops = {
>>>   	.name		= "vfio-mdev",
>>>   	.open		= vfio_mdev_open,
> 
