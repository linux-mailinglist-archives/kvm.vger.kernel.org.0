Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D719F2CCCF3
	for <lists+kvm@lfdr.de>; Thu,  3 Dec 2020 04:05:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727697AbgLCDEh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Dec 2020 22:04:37 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:43324 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726977AbgLCDEh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 2 Dec 2020 22:04:37 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B332vhq032666;
        Wed, 2 Dec 2020 22:03:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=wFHLqLOz/dEosuKfUSnxuOQoZ30RXFoV+tYFwRLbGrc=;
 b=k/exz9gOnoEVWkqmG0xixN/T0DxbS8DJEjZzJtV0l63WAOcC/je8EZJO+kSHTMgm8Q4p
 6p4zzdKE7lvvfF1uln7dCVA0v4LZZiZJtIRKEZnwDUmo9U5PnWlKS8/trtsmyQIWgG+c
 e6JqJibuctz9bLtR9/KgxCBu36IzY2WglLu2xTRHufNmtBWmysa/HKEPlXliwk7by4e9
 /lvYC4DP+2stgb/YUz0deQFYXNKTw8oIlhIiIV6XnypV147SjZ0Ghy5nNKhNWTqFFH9g
 p87EREugNMVuHECQE3HsQYQl6RcOxO5KaOC9jmYCO/D8ka3GdMoX3aV9D1fReDxzRv2S DA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 355jjjbqah-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Dec 2020 22:03:56 -0500
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0B33338U032895;
        Wed, 2 Dec 2020 22:03:56 -0500
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 355jjjbq9s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Dec 2020 22:03:55 -0500
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B332wF6008826;
        Thu, 3 Dec 2020 03:03:54 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma01wdc.us.ibm.com with ESMTP id 355vrfvp8a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Dec 2020 03:03:54 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B332cv216319078
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 3 Dec 2020 03:02:38 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BFF6DB205F;
        Thu,  3 Dec 2020 03:02:38 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A5B94B2064;
        Thu,  3 Dec 2020 03:02:37 +0000 (GMT)
Received: from [9.211.50.183] (unknown [9.211.50.183])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu,  3 Dec 2020 03:02:37 +0000 (GMT)
Subject: Re: [PATCH v2 1/2] vfio-mdev: Wire in a request handler for mdev
 parent
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
References: <20201120180740.87837-1-farman@linux.ibm.com>
 <20201120180740.87837-2-farman@linux.ibm.com>
 <20201202132838.6a872c17@w520.home>
From:   Eric Farman <farman@linux.ibm.com>
Message-ID: <eacaffbf-81eb-4d3d-a8eb-e8da8100c313@linux.ibm.com>
Date:   Wed, 2 Dec 2020 22:02:36 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201202132838.6a872c17@w520.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-03_01:2020-11-30,2020-12-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 lowpriorityscore=0 bulkscore=0 adultscore=0 mlxlogscore=999
 priorityscore=1501 spamscore=0 phishscore=0 clxscore=1015 impostorscore=0
 mlxscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012030017
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 12/2/20 3:28 PM, Alex Williamson wrote:
> On Fri, 20 Nov 2020 19:07:39 +0100
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
>> Let's wire in the request call back to the mdev device, so that a
>> device being physically removed from the host can be (gracefully?)
>> handled by the parent device at the time the device is removed.
>>
>> Add a message when registering the device if a driver doesn't
>> provide this callback, so a clue is given that this same loop
>> may be encountered in a similar situation.
>>
>> Signed-off-by: Eric Farman <farman@linux.ibm.com>
>> ---
>>   drivers/vfio/mdev/mdev_core.c |  4 ++++
>>   drivers/vfio/mdev/vfio_mdev.c | 10 ++++++++++
>>   include/linux/mdev.h          |  4 ++++
>>   3 files changed, 18 insertions(+)
>>
>> diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
>> index b558d4cfd082..6de97d25a3f8 100644
>> --- a/drivers/vfio/mdev/mdev_core.c
>> +++ b/drivers/vfio/mdev/mdev_core.c
>> @@ -154,6 +154,10 @@ int mdev_register_device(struct device *dev, const struct mdev_parent_ops *ops)
>>   	if (!dev)
>>   		return -EINVAL;
>>   
>> +	/* Not mandatory, but its absence could be a problem */
>> +	if (!ops->request)
>> +		dev_info(dev, "Driver cannot be asked to release device\n");
>> +
>>   	mutex_lock(&parent_list_lock);
>>   
>>   	/* Check for duplicate */
>> diff --git a/drivers/vfio/mdev/vfio_mdev.c b/drivers/vfio/mdev/vfio_mdev.c
>> index 30964a4e0a28..06d8fc4a6d72 100644
>> --- a/drivers/vfio/mdev/vfio_mdev.c
>> +++ b/drivers/vfio/mdev/vfio_mdev.c
>> @@ -98,6 +98,15 @@ static int vfio_mdev_mmap(void *device_data, struct vm_area_struct *vma)
>>   	return parent->ops->mmap(mdev, vma);
>>   }
>>   
>> +static void vfio_mdev_request(void *device_data, unsigned int count)
>> +{
>> +	struct mdev_device *mdev = device_data;
>> +	struct mdev_parent *parent = mdev->parent;
>> +
>> +	if (parent->ops->request)
>> +		parent->ops->request(mdev, count);
> 
> What do you think about duplicating the count==0 notice in the else
> case here?  ie.
> 
> 	else if (count == 0)
> 		dev_notice(mdev_dev(mdev), "No mdev vendor driver	request callback support, blocked until released by user\n");
> 

I'm fine with that. If there are no objections, I should be able to spin 
a v3 with such a change tomorrow.

Thank you!

Eric

> This at least puts something in the log a bit closer to the timeframe
> of a possible issue versus the registration nag.  vfio-core could do
> this too, but vfio-mdev registers a request callback on behalf of all
> mdev devices, so vfio-core would no longer have visibility for this
> case.
> 
> Otherwise this series looks fine to me and I can take it through the
> vfio tree.  Thanks,
> 
> Alex
> 
>> +}
>> +
>>   static const struct vfio_device_ops vfio_mdev_dev_ops = {
>>   	.name		= "vfio-mdev",
>>   	.open		= vfio_mdev_open,
>> @@ -106,6 +115,7 @@ static const struct vfio_device_ops vfio_mdev_dev_ops = {
>>   	.read		= vfio_mdev_read,
>>   	.write		= vfio_mdev_write,
>>   	.mmap		= vfio_mdev_mmap,
>> +	.request	= vfio_mdev_request,
>>   };
>>   
>>   static int vfio_mdev_probe(struct device *dev)
>> diff --git a/include/linux/mdev.h b/include/linux/mdev.h
>> index 0ce30ca78db0..9004375c462e 100644
>> --- a/include/linux/mdev.h
>> +++ b/include/linux/mdev.h
>> @@ -72,6 +72,9 @@ struct device *mdev_get_iommu_device(struct device *dev);
>>    * @mmap:		mmap callback
>>    *			@mdev: mediated device structure
>>    *			@vma: vma structure
>> + * @request:		request callback to release device
>> + *			@mdev: mediated device structure
>> + *			@count: request sequence number
>>    * Parent device that support mediated device should be registered with mdev
>>    * module with mdev_parent_ops structure.
>>    **/
>> @@ -92,6 +95,7 @@ struct mdev_parent_ops {
>>   	long	(*ioctl)(struct mdev_device *mdev, unsigned int cmd,
>>   			 unsigned long arg);
>>   	int	(*mmap)(struct mdev_device *mdev, struct vm_area_struct *vma);
>> +	void	(*request)(struct mdev_device *mdev, unsigned int count);
>>   };
>>   
>>   /* interface for exporting mdev supported type attributes */
> 
