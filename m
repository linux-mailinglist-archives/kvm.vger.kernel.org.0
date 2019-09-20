Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD6E9B9495
	for <lists+kvm@lfdr.de>; Fri, 20 Sep 2019 17:54:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404645AbfITPx5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Sep 2019 11:53:57 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:42046 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2404191AbfITPx5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Sep 2019 11:53:57 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x8KFl6MC121393;
        Fri, 20 Sep 2019 11:53:50 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2v51ndgfre-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Sep 2019 11:53:49 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x8KFlIvr123010;
        Fri, 20 Sep 2019 11:53:49 -0400
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2v51ndgfqt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Sep 2019 11:53:49 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x8KFp6xY005075;
        Fri, 20 Sep 2019 15:53:48 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma01wdc.us.ibm.com with ESMTP id 2v3vbty3xc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Sep 2019 15:53:48 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x8KFrhuT54723052
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Sep 2019 15:53:44 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CEBB67805E;
        Fri, 20 Sep 2019 15:53:43 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1C9E37805C;
        Fri, 20 Sep 2019 15:53:42 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.85.141.73])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 20 Sep 2019 15:53:41 +0000 (GMT)
Subject: Re: [PATCH v4 4/4] vfio: pci: Using a device region to retrieve zPCI
 information
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     sebott@linux.ibm.com, gerald.schaefer@de.ibm.com,
        pasic@linux.ibm.com, borntraeger@de.ibm.com, walling@linux.ibm.com,
        linux-s390@vger.kernel.org, iommu@lists.linux-foundation.org,
        joro@8bytes.org, linux-kernel@vger.kernel.org,
        alex.williamson@redhat.com, kvm@vger.kernel.org,
        heiko.carstens@de.ibm.com, robin.murphy@arm.com, gor@linux.ibm.com,
        pmorel@linux.ibm.com
References: <1567815231-17940-1-git-send-email-mjrosato@linux.ibm.com>
 <1567815231-17940-5-git-send-email-mjrosato@linux.ibm.com>
 <20190919172505.2eb075f8.cohuck@redhat.com>
 <c5c5c46e-371b-5be0-064a-b89195cdc3f6@linux.ibm.com>
 <20190920162607.16198c92.cohuck@redhat.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
Openpgp: preference=signencrypt
Message-ID: <f25bfba5-96b0-3072-f082-9592a56edbe2@linux.ibm.com>
Date:   Fri, 20 Sep 2019 11:53:41 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190920162607.16198c92.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-09-20_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1909200144
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/20/19 10:26 AM, Cornelia Huck wrote:
> On Thu, 19 Sep 2019 16:57:10 -0400
> Matthew Rosato <mjrosato@linux.ibm.com> wrote:
> 
>> On 9/19/19 11:25 AM, Cornelia Huck wrote:
>>> On Fri,  6 Sep 2019 20:13:51 -0400
>>> Matthew Rosato <mjrosato@linux.ibm.com> wrote:
>>>   
>>>> From: Pierre Morel <pmorel@linux.ibm.com>
>>>>
>>>> We define a new configuration entry for VFIO/PCI, VFIO_PCI_ZDEV
>>>>
>>>> When the VFIO_PCI_ZDEV feature is configured we initialize
>>>> a new device region, VFIO_REGION_SUBTYPE_ZDEV_CLP, to hold
>>>> the information from the ZPCI device the use
>>>>
>>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>>> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
>>>> ---
>>>>  drivers/vfio/pci/Kconfig            |  7 +++
>>>>  drivers/vfio/pci/Makefile           |  1 +
>>>>  drivers/vfio/pci/vfio_pci.c         |  9 ++++
>>>>  drivers/vfio/pci/vfio_pci_private.h | 10 +++++
>>>>  drivers/vfio/pci/vfio_pci_zdev.c    | 85 +++++++++++++++++++++++++++++++++++++
>>>>  5 files changed, 112 insertions(+)
>>>>  create mode 100644 drivers/vfio/pci/vfio_pci_zdev.c
>>>>
>>>> diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
>>>> index ac3c1dd..d4562a8 100644
>>>> --- a/drivers/vfio/pci/Kconfig
>>>> +++ b/drivers/vfio/pci/Kconfig
>>>> @@ -45,3 +45,10 @@ config VFIO_PCI_NVLINK2
>>>>  	depends on VFIO_PCI && PPC_POWERNV
>>>>  	help
>>>>  	  VFIO PCI support for P9 Witherspoon machine with NVIDIA V100 GPUs
>>>> +
>>>> +config VFIO_PCI_ZDEV
>>>> +	bool "VFIO PCI Generic for ZPCI devices"
>>>> +	depends on VFIO_PCI && S390
>>>> +	default y
>>>> +	help
>>>> +	  VFIO PCI support for S390 Z-PCI devices  
>>>   
>>> >From that description, I'd have no idea whether I'd want that or not.  
>>> Is there any downside to enabling it?
>>>   
>>
>> :) Not really, you're just getting information from the hardware vs
>> using hard-coded defaults.  The only reason I could think of to turn it
>> off would be if you wanted/needed to restore this hard-coded behavior.
> 
> I'm not really sure whether that's worth adding a Kconfig switch for.
> Won't older versions simply ignore the new region anyway?
> 

Yes, you have a point here...  This switch showed up in v3 of this
series when Pierre changed to using a region to pass this info and I
haven't yet found a 'why' he decided to add the Kconfig switch.  If I
can't convince myself of a reason to keep it, I'll just remove it from
the next version.

> Also, I don't think we have any migration compatibility issues, as
> vfio-pci devices are not (yet) migrateable anyway.
> 
>>
>> bool "VFIO PCI support for generic ZPCI devices" ?
> 
> "Support zPCI-specific configuration for VFIO PCI" ?
> 
>>
>> "Support for sharing ZPCI hardware device information between the host
>> and guests." ?
> 
> "Enabling this options exposes a region containing hardware
> configuration for zPCI devices. This enables userspace (e.g. QEMU) to
> supply proper configuration values instead of hard-coded defaults for
> zPCI devices passed through via VFIO on s390.
> 
> Say Y here."
> 
> ?
>

Your descriptions are much better - thanks for the feedback!
