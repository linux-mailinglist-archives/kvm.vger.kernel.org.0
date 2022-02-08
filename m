Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9CAD4AE3C7
	for <lists+kvm@lfdr.de>; Tue,  8 Feb 2022 23:24:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387384AbiBHWX2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Feb 2022 17:23:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386973AbiBHViJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Feb 2022 16:38:09 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FBE9C0612B8;
        Tue,  8 Feb 2022 13:38:07 -0800 (PST)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 218KLPU4008129;
        Tue, 8 Feb 2022 21:38:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=+vZEbJf2/F/HXJS/xb959JWBMnW+q6kEGUI0pVRvbIU=;
 b=EBPlj+Fi0Suqi9+RuiXia3bLWlMJlGNVTeMW/DMnmzR5X9r3IYTnuP+x6CXdQ9ssyt+W
 yf5Q4+zHV8G8zRPtGPTglyAfbu1pNNHmWH98aQzzbxUFSSjvrMGTa84afJ9oEOBdeKQ5
 ECWuBKtiHv421EO44qS9+40YPLNPCEgm4I4gl0Ke9oJbIjqp9G37cJVof9drXnwb/6xH
 VJt5NGh3wshXL6WlBo5PLjT/fRZocc0jxKdrRg/8KgVF761Y59QIFnUTPWABSZMESSdW
 YR2Imvnrve2L0VwOrAv6zvNtMNgkDhoQNSrt4AZS5koAFdRvhVSzbQxhy8xc1x8dmZdW aQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e3tst2bdk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Feb 2022 21:38:05 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 218KTMtH022850;
        Tue, 8 Feb 2022 21:38:04 GMT
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e3tst2bd9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Feb 2022 21:38:04 +0000
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 218LbhfF001267;
        Tue, 8 Feb 2022 21:38:03 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma03wdc.us.ibm.com with ESMTP id 3e1gvb4whj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Feb 2022 21:38:03 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 218Lc1dY26018302
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 8 Feb 2022 21:38:01 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BB373AE05C;
        Tue,  8 Feb 2022 21:38:01 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 93103AE063;
        Tue,  8 Feb 2022 21:37:56 +0000 (GMT)
Received: from [9.211.136.120] (unknown [9.211.136.120])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue,  8 Feb 2022 21:37:56 +0000 (GMT)
Message-ID: <920cf807-efcd-319b-560a-ed3a1c6fdc85@linux.ibm.com>
Date:   Tue, 8 Feb 2022 16:37:55 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v3 24/30] vfio-pci/zdev: wire up group notifier
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        linux-s390@vger.kernel.org, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        frankja@linux.ibm.com, david@redhat.com, imbrenda@linux.ibm.com,
        vneethv@linux.ibm.com, oberpar@linux.ibm.com, freude@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220204211536.321475-1-mjrosato@linux.ibm.com>
 <20220204211536.321475-25-mjrosato@linux.ibm.com>
 <20220208104319.4861fb22.alex.williamson@redhat.com>
 <20220208185141.GH4160@nvidia.com>
 <20220208122624.43ad52ef.alex.williamson@redhat.com>
 <438d8b1e-e149-35f1-a8c9-ed338eb97430@linux.ibm.com>
 <20220208204041.GK4160@nvidia.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <20220208204041.GK4160@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: gBoIvL9YXflJpi2SsFc-is9hNyMZmx3G
X-Proofpoint-GUID: LR1RpkiMXSJ2erWaWvdY7NsRIHuLJu0_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-08_06,2022-02-07_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 spamscore=0
 malwarescore=0 lowpriorityscore=0 priorityscore=1501 phishscore=0
 impostorscore=0 mlxlogscore=999 clxscore=1015 adultscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202080125
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/8/22 3:40 PM, Jason Gunthorpe wrote:
> On Tue, Feb 08, 2022 at 03:33:58PM -0500, Matthew Rosato wrote:
> 
>>> Is the purpose of IOAT to associate the device to a set of KVM page
>>> tables?  That seems like a container or future iommufd operation.  I
>>
>> Yes, here we are establishing a relationship with the DMA table in the guest
>> so that once mappings are established guest PCI operations (handled via
>> special instructions in s390) don't need to go through the host but can be
>> directly handled by firmware (so, effectively guest can keep running on its
>> vcpu vs breaking out).
> 
> Oh, well, certainly sounds like a NAK on that - anything to do with
> the DMA translation of a PCI device must go through the iommu layer,
> not here.
> 
> Lets not repeat the iommu subsytem bypass mess power made please.
> 
>> It's more that non-KVM userspace doesn't care about what these ioctls are
>> doing...  The enabling of 'interp, aif, ioat' is only pertinent when there
>> is a KVM userspace, specifically because the information being shared /
>> actions being performed as a result are only relevant to properly enabling
>> zPCI features when the zPCI device is being passed through to a VM
>> guest.
> 
> Then why are they KVM ioctls?

Well, the primary reason I ended up here was that I need to ensure the 
the operation is only performed when guest X owns host zPCI device Y. 
The vfio-pci device ioctl had the benefit of acting on device 
granularity + also already being aware of the host PCI (and thus zPCI) 
device association -- so I already know exactly what hostdev is being 
referenced for the operation.  All that was needed was the KVM notifier 
to ensure the vfio device was associated to a KVM guest.

I think moving over to a KVM ioctl is doable; I might still need to rely 
on VFIO_GROUP_NOTIFY_SET_KVM though, not sure yet.

Based on prior comments in this thread I'm assuming Alex shares that 
view too (don't use vfio device ioctl for something only being used for 
VM passthrough) so I'll start looking at using KVM ioctls instead.

