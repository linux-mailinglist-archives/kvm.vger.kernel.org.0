Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA70152F4B4
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 22:59:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241610AbiETU72 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 16:59:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237815AbiETU70 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 16:59:26 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4C1019669A;
        Fri, 20 May 2022 13:59:24 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24KKImw6002349;
        Fri, 20 May 2022 20:59:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=808wDXQrHcXIjgNENByFmSVbbhNo/XMD0cLfCPIwwsI=;
 b=Hx9A+4magmEqSeNKfmeXtfSHHCj2oCEsAKGmrxgv7xwbp2oayxhgNo1kGeGyliqVUDWc
 L8BulKqiPc8kQoYvFNPFm0M1UBhFQGAhJ0lRkGsN9c5p+XeoJtGyXA7eQ+0rFqXoGxz8
 1oFLdHuSwFA08RXU7jnpXPB6U1dTjMLqI2YDiDYvTjrGT9Sd5M4O00zLq2DhjjQbSX53
 rgRNnEmMMAzDiPie/0gAXcoPxAw13h4X4PjxMe3I5+9Gyt14SL8ApuGfiP/9lA7/nqUs
 kT0NhBoRKYwT15Wv+ZQOWADcKSH3/ln1MUQy2I28tnnTxp3Jatv+V3SG8Ge8OlSwKeE3 1A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g6hws0jfj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 May 2022 20:59:10 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24KKvf5J015737;
        Fri, 20 May 2022 20:59:09 GMT
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g6hws0jf9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 May 2022 20:59:09 +0000
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24KKqqoj018012;
        Fri, 20 May 2022 20:59:08 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma04wdc.us.ibm.com with ESMTP id 3g4wp5t01q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 May 2022 20:59:08 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24KKx7ao24969636
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 May 2022 20:59:07 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 16F47B2066;
        Fri, 20 May 2022 20:59:07 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 462ABB205F;
        Fri, 20 May 2022 20:59:06 +0000 (GMT)
Received: from [9.160.37.241] (unknown [9.160.37.241])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri, 20 May 2022 20:59:06 +0000 (GMT)
Message-ID: <647c6f6e-33c8-62dd-8f22-c2abafcc5898@linux.ibm.com>
Date:   Fri, 20 May 2022 16:59:05 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v3 1/1] vfio: remove VFIO_GROUP_NOTIFY_SET_KVM
Content-Language: en-US
To:     Matthew Rosato <mjrosato@linux.ibm.com>, jgg@nvidia.com,
        alex.williamson@redhat.com
Cc:     cohuck@redhat.com, borntraeger@linux.ibm.com,
        jjherne@linux.ibm.com, pasic@linux.ibm.com,
        zhenyuw@linux.intel.com, zhi.a.wang@intel.com, hch@infradead.org,
        intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kevin Tian <kevin.tian@intel.com>,
        Christoph Hellwig <hch@lst.de>
References: <20220519183311.582380-1-mjrosato@linux.ibm.com>
 <20220519183311.582380-2-mjrosato@linux.ibm.com>
 <8b6db781-9d4e-4d64-04fa-94e45dbf8b22@linux.ibm.com>
 <b85ee6e2-9388-34b4-e1cd-e7e8578a4edf@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
In-Reply-To: <b85ee6e2-9388-34b4-e1cd-e7e8578a4edf@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: dpdhhNOQYdRvyPONzaCX7TmeSddYyPcx
X-Proofpoint-ORIG-GUID: CwrCj8rHlZcPYNPWkSYVBeYcca5j16Dv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-20_07,2022-05-20_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxscore=0
 malwarescore=0 spamscore=0 priorityscore=1501 bulkscore=0
 lowpriorityscore=0 impostorscore=0 clxscore=1015 phishscore=0
 suspectscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2202240000 definitions=main-2205200127
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/20/22 10:09 AM, Matthew Rosato wrote:
> On 5/20/22 9:56 AM, Tony Krowiak wrote:
>>
>>
>> On 5/19/22 2:33 PM, Matthew Rosato wrote:
>>> Rather than relying on a notifier for associating the KVM with
>>> the group, let's assume that the association has already been
>>> made prior to device_open.  The first time a device is opened
>>> associate the group KVM with the device.
>>>
>>> This fixes a user-triggerable oops in GVT.
>>>
>>> Reviewed-by: Tony Krowiak <akrowiak@linux.ibm.com>
>>> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
>>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>>> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
>>> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
>>> ---
>>>   drivers/gpu/drm/i915/gvt/gtt.c        |  4 +-
>>>   drivers/gpu/drm/i915/gvt/gvt.h        |  3 -
>>>   drivers/gpu/drm/i915/gvt/kvmgt.c      | 82 ++++++--------------------
>>>   drivers/s390/crypto/vfio_ap_ops.c     | 35 ++---------
>>>   drivers/s390/crypto/vfio_ap_private.h |  3 -
>>>   drivers/vfio/vfio.c                   | 83 
>>> ++++++++++-----------------
>>>   include/linux/vfio.h                  |  6 +-
>>>   7 files changed, 57 insertions(+), 159 deletions(-)
>>>
>>>
>>> diff --git a/drivers/s390/crypto/vfio_ap_ops.c 
>>> b/drivers/s390/crypto/vfio_ap_ops.c
>>> index e8914024f5b1..a7d2a95796d3 100644
>>> --- a/drivers/s390/crypto/vfio_ap_ops.c
>>> +++ b/drivers/s390/crypto/vfio_ap_ops.c
>>> @@ -1284,25 +1284,6 @@ static void vfio_ap_mdev_unset_kvm(struct 
>>> ap_matrix_mdev *matrix_mdev)
>>>       }
>>>   }
>>> -static int vfio_ap_mdev_group_notifier(struct notifier_block *nb,
>>> -                       unsigned long action, void *data)
>>> -{
>>> -    int notify_rc = NOTIFY_OK;
>>> -    struct ap_matrix_mdev *matrix_mdev;
>>> -
>>> -    if (action != VFIO_GROUP_NOTIFY_SET_KVM)
>>> -        return NOTIFY_OK;
>>> -
>>> -    matrix_mdev = container_of(nb, struct ap_matrix_mdev, 
>>> group_notifier);
>>> -
>>> -    if (!data)
>>> -        vfio_ap_mdev_unset_kvm(matrix_mdev);
>>> -    else if (vfio_ap_mdev_set_kvm(matrix_mdev, data))
>>> -        notify_rc = NOTIFY_DONE;
>>> -
>>> -    return notify_rc;
>>> -}
>>> -
>>>   static struct vfio_ap_queue *vfio_ap_find_queue(int apqn)
>>>   {
>>>       struct device *dev;
>>> @@ -1402,11 +1383,10 @@ static int vfio_ap_mdev_open_device(struct 
>>> vfio_device *vdev)
>>>       unsigned long events;
>>>       int ret;
>>> -    matrix_mdev->group_notifier.notifier_call = 
>>> vfio_ap_mdev_group_notifier;
>>> -    events = VFIO_GROUP_NOTIFY_SET_KVM;
>>> +    if (!vdev->kvm)
>>> +        return -EINVAL;
>>> -    ret = vfio_register_notifier(vdev, VFIO_GROUP_NOTIFY, &events,
>>> -                     &matrix_mdev->group_notifier);
>>> +    ret = vfio_ap_mdev_set_kvm(matrix_mdev, vdev->kvm);
>>>       if (ret)
>>>           return ret;
>>
>> I'm sorry I didn't see this with my last review, but maybe move the call
>> to vfio_ap_mdev_set_kvm(matrix_mdev, vdev->kvm) after the successful
>> registration of the IOMMU notifier? This way you won't be plugging AP 
>> queues
>> into the guest only to remove them if the registration fails.
>
> This is a pretty edge error case, and the 
> vfio_ap_mdev_unset_kvm(matrix_mdev) call at err_kvm should do the 
> proper cleanup, right?  I guess I'm wondering if it's really any 
> different than the prior code which would have registered the 
> VFIO_GROUP_NOTIFY_SET_KVM first, which would have immediately 
> triggered the notifier since the KVM was already registered to the 
> group, meaning it would haved called 
> vfio_ap_mdev_group_notifier->vfio_ap_mdev_set_kvm anyway (see 
> vfio_register_group_notifier, the "The attaching of kvm and vfio_group 
> might already happen..." comment)

You are correct, the VFIO_GROUP_NOTIFY_SET_KVM notifier will get 
triggered when it is registered; however, you may have pointed out a 
flaw in the previous version of the code. I'm guessing this notifier is 
not triggered when it is unregistered, so unless the guest is terminated 
due to a non-zero return code from the open_device callback, it will 
have access to the AP queues. In hindsight, we probably should have 
registered the IOMMU notifier first.

You make a valid point about this being an edge case and I don't think 
it's critical, so feel free to keep it as-is.

My r-b still stands.

>
>>
>>> @@ -1415,12 +1395,11 @@ static int vfio_ap_mdev_open_device(struct 
>>> vfio_device *vdev)
>>>       ret = vfio_register_notifier(vdev, VFIO_IOMMU_NOTIFY, &events,
>>>                        &matrix_mdev->iommu_notifier);
>>>       if (ret)
>>> -        goto out_unregister_group;
>>> +        goto err_kvm;
>>>       return 0;
>>> -out_unregister_group:
>>> -    vfio_unregister_notifier(vdev, VFIO_GROUP_NOTIFY,
>>> -                 &matrix_mdev->group_notifier);
>>> +err_kvm:
>>> +    vfio_ap_mdev_unset_kvm(matrix_mdev);
>>>       return ret;
>>>   }
>

