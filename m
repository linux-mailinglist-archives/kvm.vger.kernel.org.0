Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F0F4243A91
	for <lists+kvm@lfdr.de>; Thu, 13 Aug 2020 15:11:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbgHMNLe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Aug 2020 09:11:34 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:18832 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726142AbgHMNLd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 13 Aug 2020 09:11:33 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07DD56jv018438;
        Thu, 13 Aug 2020 09:11:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=izIHFKr2yFlo2rDmic4pT1FxYnmeQNbDbsOvAaaHhoI=;
 b=MxGP/aVOer7/6/wDKa1MfFbPXqPQcvv03BNbJTZtzTvCR1WYuclCPrvjVqTbosx+xvpx
 TWIe+/j2wJU3nRaMN6z3TcUGtrFEy6tYMG9uBd8uKbWodjAzcTdCnG20GJw1MYc5f2ut
 t5rkS7wesPU2MaIW9aR2NXObqSTUXuh0Ir0KpvfaxZ5HpHYH6io6jgegBmEb+LNhz1s+
 dVEsGNsAYzA9tOCbzAI7+sMkQ2fv3/Pl5+FmdyEzagw6bQg2tIwhv5RtyVBWpJQcv6Bt
 bFkCKxuA7U7YGdZ8jAe7bB6GA29gfWF6jp0np4P9t0OyC8BSMJQW1iHHxDz2HnUOOp5o GA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32w24gypwx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Aug 2020 09:11:29 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 07DD5I9u019385;
        Thu, 13 Aug 2020 09:11:29 -0400
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32w24gypw0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Aug 2020 09:11:29 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07DDBRJ0020659;
        Thu, 13 Aug 2020 13:11:28 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma02dal.us.ibm.com with ESMTP id 32skp9vpyb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Aug 2020 13:11:28 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07DDBNcZ52429298
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Aug 2020 13:11:23 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4636D28058;
        Thu, 13 Aug 2020 13:11:23 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 09B4D28059;
        Thu, 13 Aug 2020 13:11:21 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.163.7.238])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 13 Aug 2020 13:11:20 +0000 (GMT)
Subject: Re: [PATCH v2] PCI: Introduce flag for detached virtual functions
To:     Niklas Schnelle <schnelle@linux.ibm.com>,
        "Oliver O'Halloran" <oohall@gmail.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>, pmorel@linux.ibm.com,
        Michael Ellerman <mpe@ellerman.id.au>,
        linux-s390@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        Alexey Kardashevskiy <aik@ozlabs.ru>
References: <1597260071-2219-1-git-send-email-mjrosato@linux.ibm.com>
 <1597260071-2219-2-git-send-email-mjrosato@linux.ibm.com>
 <CAOSf1CFjaVoeTyk=cLmWhBB6YQrHQkcD8Aj=ZYrB4kYc-rqLiw@mail.gmail.com>
 <2a862199-16c8-2141-d27f-79761c1b1b25@linux.ibm.com>
 <CAOSf1CE6UyL9P31S=rAG=VZKs-JL4Kbq3VMZNhyojHbkPHSw0Q@mail.gmail.com>
 <dc79c8a9-1bbc-380f-741f-bca270a34483@linux.ibm.com>
 <17be8c41-8989-f1da-a843-30f0761f42de@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
Message-ID: <6ffa5f39-3607-88c7-81f9-dc97d12d09df@linux.ibm.com>
Date:   Thu, 13 Aug 2020 09:11:20 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <17be8c41-8989-f1da-a843-30f0761f42de@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-13_10:2020-08-13,2020-08-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 phishscore=0 lowpriorityscore=0 suspectscore=0 spamscore=0
 priorityscore=1501 impostorscore=0 malwarescore=0 clxscore=1011
 bulkscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008130098
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/13/20 8:34 AM, Niklas Schnelle wrote:
> 
> 
> On 8/13/20 12:40 PM, Niklas Schnelle wrote:
>>
>>
>> On 8/13/20 11:59 AM, Oliver O'Halloran wrote:
>>> On Thu, Aug 13, 2020 at 7:00 PM Niklas Schnelle <schnelle@linux.ibm.com> wrote:
>>>>
>>>>
>>>> On 8/13/20 3:55 AM, Oliver O'Halloran wrote:
>>>>> On Thu, Aug 13, 2020 at 5:21 AM Matthew Rosato <mjrosato@linux.ibm.com> wrote:
>>>>>> *snip*
>>>>>> diff --git a/arch/s390/pci/pci.c b/arch/s390/pci/pci.c
>>>>>> index 3902c9f..04ac76d 100644
>>>>>> --- a/arch/s390/pci/pci.c
>>>>>> +++ b/arch/s390/pci/pci.c
>>>>>> @@ -581,6 +581,14 @@ int pcibios_enable_device(struct pci_dev *pdev, int mask)
>>>>>>   {
>>>>>>          struct zpci_dev *zdev = to_zpci(pdev);
>>>>>>
>>>>>> +       /*
>>>>>> +        * If we have a VF on a non-multifunction bus, it must be a VF that is
>>>>>> +        * detached from its parent PF.  We rely on firmware emulation to
>>>>>> +        * provide underlying PF details.
>>>>>> +        */
>>>>>> +       if (zdev->vfn && !zdev->zbus->multifunction)
>>>>>> +               pdev->detached_vf = 1;
>>>>>
>>>>> The enable hook seems like it's a bit too late for this sort of
>>>>> screwing around with the pci_dev. Anything in the setup path that
>>>>> looks at ->detached_vf would see it cleared while anything that looks
>>>>> after the device is enabled will see it set. Can this go into
>>>>> pcibios_add_device() or a fixup instead?
>>>>>
>>>>
>>>> This particular check could go into pcibios_add_device() yes.
>>>> We're also currently working on a slight rework of how
>>>> we establish the VF to parent PF linking including the sysfs
>>>> part of that. The latter sadly can only go after the sysfs
>>>> for the virtfn has been created and that only happens
>>>> after all fixups. We would like to do both together because
>>>> the latter sets pdev->is_virtfn which I think is closely related.
>>>>
>>>> I was thinking of starting another discussion
>>>> about adding a hook that is executed just after the sysfs entries
>>>> for the PCI device are created but haven't yet.
>>>
>>> if all you need is sysfs then pcibios_bus_add_device() or a bus
>>> notifier should work
>>
>> So this might go a bit off track but the problem is that
>> on s390 a VF can be disabled and reenabled with disable_slot()/enable_slot().
>> In this case pcibios_bus_add_device() is not called again but
>> the PF/VF link needs to be reestablished.
> 
> Scratch that I must have made some stupid mistake last time I tried
> this, with your suggestion I tried again and it works perfectly
> moving the setup into pcibios_bus_add_device().
> Thank you, this is actually much nicer!
> 

OK, and I can likewise relocate the setting of detached_vf to 
pcibios_bus_add_device().

