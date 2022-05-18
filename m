Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1AC352BF6F
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 18:13:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239432AbiERPeE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 11:34:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239438AbiERPeD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 11:34:03 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B93C174DD0;
        Wed, 18 May 2022 08:33:54 -0700 (PDT)
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24IFO4Kc007205;
        Wed, 18 May 2022 15:33:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=H6Vc3MVfyrLUyE4tx33xTvG94JG+q8zgiXWOBhDaWFQ=;
 b=pwQUWmd4ThOuY5539Mk5g04fHqX087GUVCiz/pRcD+nA4GNtRQZ3HWBXZbTSOrmxlB6U
 fWg3Gsb/vJdBiwo1fgSo291F2OTqC7IiRQKoR1NGxqgU2k3yZ6H5RfBpOO+f7ZcNwqNk
 Mba9KYjW5PRiRn8P/JvffHI2VXiD9hiZG11XGUycQGdsQou9FULaRaOeOn5A6qpeXe+R
 fnrmIMPmK8I6WUR2Yw//+cocKr4igf4aa2GNt2RpuFkyTOGdpzbHoLsN4eLGXmYHw/gK
 G2KhWjU/LpsFAI1uk0DQJo69jYsTCBf0u1BqKG3UlhSztDz0bln6h9D3ZaKdeHal9qbz cA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g53dm8762-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 May 2022 15:33:44 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24IFTiUU032585;
        Wed, 18 May 2022 15:33:43 GMT
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g53dm875r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 May 2022 15:33:43 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24IFJwgq026460;
        Wed, 18 May 2022 15:33:42 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma02dal.us.ibm.com with ESMTP id 3g242amrwh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 May 2022 15:33:42 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24IFXfMN19923388
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 May 2022 15:33:41 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AD72C12405C;
        Wed, 18 May 2022 15:33:41 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 68F1612405A;
        Wed, 18 May 2022 15:33:38 +0000 (GMT)
Received: from [9.211.37.97] (unknown [9.211.37.97])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 18 May 2022 15:33:38 +0000 (GMT)
Message-ID: <34c5fd53-c75c-cb96-c627-9d30b8c45c37@linux.ibm.com>
Date:   Wed, 18 May 2022 11:33:37 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH 1/1] vfio: remove VFIO_GROUP_NOTIFY_SET_KVM
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        borntraeger@linux.ibm.com, jjherne@linux.ibm.com,
        akrowiak@linux.ibm.com, pasic@linux.ibm.com,
        zhenyuw@linux.intel.com, zhi.a.wang@intel.com, hch@infradead.org,
        intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220517180851.166538-1-mjrosato@linux.ibm.com>
 <20220517180851.166538-2-mjrosato@linux.ibm.com>
 <2e51b388-48d0-4689-07f4-65f607dbce59@linux.ibm.com>
 <20220518151247.GI1343366@nvidia.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <20220518151247.GI1343366@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: x8aS-_aMEqYWg_MOFc4u10zptZE03O1w
X-Proofpoint-ORIG-GUID: UVwqhqkeeZKxIv-g8DOJjNo9QYNkHSaQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-18_05,2022-05-17_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 mlxlogscore=999 malwarescore=0 impostorscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 priorityscore=1501 mlxscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205180089
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/18/22 11:12 AM, Jason Gunthorpe wrote:
> On Wed, May 18, 2022 at 10:37:48AM -0400, Matthew Rosato wrote:
>> On 5/17/22 2:08 PM, Matthew Rosato wrote:
>>> Rather than relying on a notifier for associating the KVM with
>>> the group, let's assume that the association has already been
>>> made prior to device_open.  The first time a device is opened
>>> associate the group KVM with the device.
>>>
>>> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
>>> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
>>
>> ...
>>
>>> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
>>> index cfcff7764403..c5d421eda275 100644
>>> +++ b/drivers/vfio/vfio.c
>>> @@ -10,6 +10,7 @@
>>>     * Author: Tom Lyon, pugs@cisco.com
>>>     */
>>> +#include "linux/kvm_host.h"
>>>    #include <linux/cdev.h>
>>>    #include <linux/compat.h>
>>>    #include <linux/device.h>
>>> @@ -1083,6 +1084,13 @@ static struct file *vfio_device_open(struct vfio_device *device)
>>>    	mutex_lock(&device->dev_set->lock);
>>>    	device->open_count++;
>>> +	down_write(&device->group->group_rwsem);
>>> +	if (device->open_count == 1 && device->group->kvm) {
>>> +		device->kvm = device->group->kvm;
>>> +		kvm_get_kvm(device->kvm);
>>
>> Did some more compile testing, since vfio has no hard kvm dependency,
>> kvm_get_kvm and kvm_put_kvm are an issue if KVM is a module while vfio is
>> built-in...
> 
> Ugh, my other plan was to have the driver itself capture the kvm, ie
> we lock the group_rwsem to keep the group->kvm valid and then pass the
> kvm to open_device in some way, then the driver can kvm_get_kvm() it
> 

Hrm... If we did that we would have to re-evaluate some other usage of 
the rwsem e.g. if driver open_device calls vfio_register_iommu_notifier 
it will try to get the rwsem but it's already locked.

> Alternatively, I don't know why kvm_get_kvm() is an exported symbol
> when it is just calling refcount_inc() - inlining it would be an
> improvement I think.
> 

I think that would work for kvm_get_kvm, but kvm_put_kvm (which we also 
need) calls kvm_destroy_kvm after the refcount_dec and that can't be inlined
