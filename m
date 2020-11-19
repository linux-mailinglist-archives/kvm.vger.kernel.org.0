Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D4732B94C1
	for <lists+kvm@lfdr.de>; Thu, 19 Nov 2020 15:41:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728037AbgKSOgt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Nov 2020 09:36:49 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:32424 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727903AbgKSOgs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 19 Nov 2020 09:36:48 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AJEXnWw052244;
        Thu, 19 Nov 2020 09:36:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=sAPi4w17vCUU3dGDsOzqlN83QDgMoYmLBT+UM9PNKrk=;
 b=tmbk8+f2DBUS3ZW0IGueWvyN+EXfWV81fiwtUowenWjRlV9iyHjzzW0rgEswWcYzVhzZ
 s+SqS4vSClX1zx6tECajpXJCxXkptqZ1o46WEDTjfBBkDxZ5iCmeRSOj1bTbeUlbQFAB
 JnXP8eE528pTkkMEgUA9z7K+ZK7At9MQnWEuO4+tdnH9Bwn3uyKURM2Mdwg1bn5y94Ob
 B+LtRA9fioH4+TGIvoGHYs82oSw6aoTNCM8yJe5v64Jb8H0EFwwu7QQh1Z2o+WIlJou3
 y0mibchlWbVtCZPVffSxcAFZSMa4mxfrTKSk1tkxBf4nDW0HKWlP8nq586/SON5uKNEF Yg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34wtk2g3jj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Nov 2020 09:36:47 -0500
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0AJEYKwW056346;
        Thu, 19 Nov 2020 09:36:47 -0500
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34wtk2g3j9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Nov 2020 09:36:47 -0500
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AJEQvhU009432;
        Thu, 19 Nov 2020 14:36:46 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma01dal.us.ibm.com with ESMTP id 34uttrw83y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Nov 2020 14:36:46 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AJEajDa4981266
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Nov 2020 14:36:45 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 58D10B2064;
        Thu, 19 Nov 2020 14:36:45 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 678ABB205F;
        Thu, 19 Nov 2020 14:36:44 +0000 (GMT)
Received: from [9.163.28.108] (unknown [9.163.28.108])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 19 Nov 2020 14:36:44 +0000 (GMT)
Subject: Re: [RFC PATCH 1/2] vfio-mdev: Wire in a request handler for mdev
 parent
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Kirti Wankhede <kwankhede@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
References: <20201117032139.50988-1-farman@linux.ibm.com>
 <20201117032139.50988-2-farman@linux.ibm.com>
 <20201119123026.1353cb3c.cohuck@redhat.com>
From:   Eric Farman <farman@linux.ibm.com>
Message-ID: <6eb37afb-a1b4-a6e5-3b5c-e7e93489faa4@linux.ibm.com>
Date:   Thu, 19 Nov 2020 09:36:43 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201119123026.1353cb3c.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-19_09:2020-11-19,2020-11-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 spamscore=0
 mlxscore=0 lowpriorityscore=0 phishscore=0 clxscore=1015 bulkscore=0
 mlxlogscore=999 malwarescore=0 adultscore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011190110
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11/19/20 6:30 AM, Cornelia Huck wrote:
> On Tue, 17 Nov 2020 04:21:38 +0100
> Eric Farman <farman@linux.ibm.com> wrote:
> 
>> While performing some destructive tests with vfio-ccw, where the
>> paths to a device are forcible removed and thus the device itself
>> is unreachable, it is rather easy to end up in an endless loop in
>> vfio_del_group_dev() due to the lack of a request callback for the
>> associated device.
>>
>> In this example, one MDEV (77c) is used by a guest, while another
>> (77b) is not. The symptom is that the iommu is detached from the
>> mdev for 77b, but not 77c, until that guest is shutdown:
>>
>>      [  238.794867] vfio_ccw 0.0.077b: MDEV: Unregistering
>>      [  238.794996] vfio_mdev 11f2d2bc-4083-431d-a023-eff72715c4f0: Removing from iommu group 2
>>      [  238.795001] vfio_mdev 11f2d2bc-4083-431d-a023-eff72715c4f0: MDEV: detaching iommu
>>      [  238.795036] vfio_ccw 0.0.077c: MDEV: Unregistering
>>      ...silence...
>>
>> Let's wire in the request call back to the mdev device, so that a hot
>> unplug can be (gracefully?) handled by the parent device at the time
>> the device is being removed.
> 
> I think it makes a lot of sense to give the vendor driver a way to
> handle requests.
> 
>>
>> Signed-off-by: Eric Farman <farman@linux.ibm.com>
>> ---
>>   drivers/vfio/mdev/vfio_mdev.c | 11 +++++++++++
>>   include/linux/mdev.h          |  4 ++++
>>   2 files changed, 15 insertions(+)
>>
>> diff --git a/drivers/vfio/mdev/vfio_mdev.c b/drivers/vfio/mdev/vfio_mdev.c
>> index 30964a4e0a28..2dd243f73945 100644
>> --- a/drivers/vfio/mdev/vfio_mdev.c
>> +++ b/drivers/vfio/mdev/vfio_mdev.c
>> @@ -98,6 +98,16 @@ static int vfio_mdev_mmap(void *device_data, struct vm_area_struct *vma)
>>   	return parent->ops->mmap(mdev, vma);
>>   }
>>   
>> +static void vfio_mdev_request(void *device_data, unsigned int count)
>> +{
>> +	struct mdev_device *mdev = device_data;
>> +	struct mdev_parent *parent = mdev->parent;
>> +
>> +	if (unlikely(!parent->ops->request))
> 
> Hm. Do you think that all drivers should implement a ->request()
> callback?

Hrm... Good question. Don't know the profile of other drivers; so maybe 
the unlikely() is unecessary. But probably need to check that parent is 
not NULL also, in case things are really in the weeds.

> 
>> +		return;
>> +	parent->ops->request(mdev, count);
>> +}
>> +
>>   static const struct vfio_device_ops vfio_mdev_dev_ops = {
>>   	.name		= "vfio-mdev",
>>   	.open		= vfio_mdev_open,
> 
