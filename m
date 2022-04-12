Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECFDA4FE3E1
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 16:32:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356534AbiDLOez (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 10:34:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231604AbiDLOex (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 10:34:53 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFF2E5EDDE;
        Tue, 12 Apr 2022 07:32:34 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23CD7eWM029884;
        Tue, 12 Apr 2022 14:32:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=HXBMRHEi2/708n5x9K+5FRvYId0NbVxKCUq5l1FNyng=;
 b=SNBk/OyhGmCWc+/YCk3nr5VKFMJAAkcewE6C+iN4vgDXDZib9lFXYFg/w5jakNruklFr
 S/sX3bShAPWrd1hNAbr0Ph2MdVIaRJtbOkXiN5N3/PTMLA36QkSKeht9FtkHdoQVzC2e
 z05Hp8CBKWBaHumBZKug/nRdjSlX/hrzL5JZK21O83NZz6LH4lzWSjIWno3d9T64S5f+
 RK7N0GK3ft0nQlq+Xun7MqjkLhUJmXE4vaKzU+Ql3xIg0Hu3cMn919VcMFwUgVG/3phQ
 B8dAwAfzzcJDu+E6CTvWY7MPFRCj5IhqQCi3l2IuHKqXDlvHLl6asEA7qsHWAoPDuPM2 4w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fd8b5mv7p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Apr 2022 14:32:34 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23CDVFoq023898;
        Tue, 12 Apr 2022 14:32:33 GMT
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fd8b5mv79-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Apr 2022 14:32:33 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23CEDvoU017750;
        Tue, 12 Apr 2022 14:32:32 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma02dal.us.ibm.com with ESMTP id 3fb1s9pqqr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Apr 2022 14:32:32 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23CEWVvS25952684
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Apr 2022 14:32:31 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C0DDAB205F;
        Tue, 12 Apr 2022 14:32:31 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 58B3AB2065;
        Tue, 12 Apr 2022 14:32:26 +0000 (GMT)
Received: from [9.211.106.50] (unknown [9.211.106.50])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 12 Apr 2022 14:32:26 +0000 (GMT)
Message-ID: <cf92d65e-f069-cd4b-d229-9fea794eea5d@linux.ibm.com>
Date:   Tue, 12 Apr 2022 10:32:25 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v5 16/21] KVM: vfio: add s390x hook to register KVM guest
 designation
Content-Language: en-US
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     alex.williamson@redhat.com, linux-s390@vger.kernel.org,
        cohuck@redhat.com, schnelle@linux.ibm.com, farman@linux.ibm.com,
        pmorel@linux.ibm.com, borntraeger@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        agordeev@linux.ibm.com, svens@linux.ibm.com, frankja@linux.ibm.com,
        david@redhat.com, imbrenda@linux.ibm.com, vneethv@linux.ibm.com,
        oberpar@linux.ibm.com, freude@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, pbonzini@redhat.com, corbet@lwn.net,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
References: <20220404174349.58530-1-mjrosato@linux.ibm.com>
 <20220404174349.58530-17-mjrosato@linux.ibm.com>
 <20220408124536.GX64706@ziepe.ca>
 <3639d5fb-ff71-d42e-ef09-0b297f7e1a45@linux.ibm.com>
 <20220412135517.GE64706@ziepe.ca>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <20220412135517.GE64706@ziepe.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ZGwu49q27VBGXYCaTEyco3gw89qlNgyL
X-Proofpoint-GUID: M4clunag9ROxfedXJmYuNZItOYxpujxh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-12_05,2022-04-12_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 bulkscore=0 spamscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 priorityscore=1501 lowpriorityscore=0 clxscore=1015 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204120070
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/12/22 9:55 AM, Jason Gunthorpe wrote:
> On Tue, Apr 12, 2022 at 09:39:44AM -0400, Matthew Rosato wrote:
>> On 4/8/22 8:45 AM, Jason Gunthorpe wrote:
>>> On Mon, Apr 04, 2022 at 01:43:44PM -0400, Matthew Rosato wrote:
>>>> At the time a KVM is associated with a vfio group, s390x zPCI devices
>>>> must register a special guest indication (GISA designation) to allow
>>>> for the use of interpretive execution facilities.  This indication is
>>>> used to ensure that only the specified KVM can interact with the device.
>>>> Similarly, the indication must be removed once the KVM is no longer
>>>> associated with the device.
>>>>
>>>> This patch adds an s390-specific hook to invoke a KVM registration routine
>>>> for each device associated with the iommu group; in reality, it will be a
>>>> NOP for all but zPCI devices on s390x.
>>>>
>>>> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
>>>>    virt/kvm/vfio.c | 35 ++++++++++++++++++++++++++++++++++-
>>>>    1 file changed, 34 insertions(+), 1 deletion(-)
>>>
>>> I wonder if this should be done in the vfio_pci side from the existing
>>> kvm notifier
>>>
>>
>> So you mean rather than hooking into virt as I do here, drive something out
>> of drivers/vfio/vfio.c:vfio_group_set_kvm?  Note, the kvm notifier is
>> handled in vfio, not vfio_pci, so if you want to handle it in vfio_pci I
>> think we'd need to add a new routine to vfio_device_ops and only define it
>> vfio_pci for s390
> 
> I've been thinking about doing that anyhow, exactly for reasons like
> this..
> 
>> static const struct vfio_device_ops vfio_pci_ops = {
>> 	.name		= "vfio-pci",
>> [...]
>> #ifdef CONFIG_S390
>> 	.set_kvm = vfio_pci_zdev_set_kvm,
>> #endif
>> };
>>
>> and something like...
>>
>> void vfio_group_set_kvm(struct vfio_group *group, struct kvm *kvm)
>> {
>> 	struct vfio_device *vdev;
>> 	group->kvm = kvm;
>>
>> 	mutex_lock(&group->device_lock);
>> 	list_for_each_entry(vdev, &group->device_list, group_next) {
>> 		if (vdev->ops->set_kvm)
>> 			it->ops->set_kvm(vdev, kvm);
>> 	}
>> 	mutex_unlock(&group->device_lock);
> 
> Almost, the device should be open before calling the callback
> 
> And you have to inject a callback during open if the device is opened
> after the kvm was set.
> 
> But I don't think you need to do this, you can just register a
> notifier in zpci when it hooks open_device like everything else,
> right?

Yes, that would also work -- I was registering a notifier for a few 
prior versions of this series (granted, not from open_device) but got 
the impression I should avoid registering a notifier from within 
vfio_pci_zdev.

I will go ahead and add register/unregister notifiers hooked from 
vfio_pci_core_finish_enable/vfio_pci_core_close_device for zpci (e.g. 
vfio_pci_zdev_{open,close}) and use the notifier events to drive the 
routines from patch 15.
