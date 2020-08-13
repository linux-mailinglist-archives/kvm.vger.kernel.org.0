Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C76E2439D8
	for <lists+kvm@lfdr.de>; Thu, 13 Aug 2020 14:34:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726419AbgHMMe3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Aug 2020 08:34:29 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:18560 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726100AbgHMMeZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 13 Aug 2020 08:34:25 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07DCWu5j083663;
        Thu, 13 Aug 2020 08:34:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : from : to : cc
 : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=+O4EkHoBTvbZ+GO2QHDX1q51uq8lakUAqvSItKU1TuU=;
 b=Ombdm1BrFU8/Lhbxdo2H88IY1DjQ6ALaX5O1exQ9LIdu+jy0arZgB3xUTDpHCB4+I8d8
 zciFUerf3HLGgnWsnczkpJ4ZwoB8jYRvwXTWIKyne+kbT5fuuOuetANJLLkpR7seP7yB
 ckffGN+Nbv0LyWRmFRI4i0Ufsl6htk7uSuvhOcwFUYK8RTUkGCpcOgBL6nErBK5v3nrB
 yIm8j8yMGnPwQnHrNNtdrBVIZxL8q4HxbcoikgHscoRpzzCeMrDh01+ZBXT8wuyBbD17
 BkdPNfCn8x3I34XnmHTZi7r1ynbyKhn7gnIIxuuhPoV02m3qnTTWaPuhPAOnL83RVXuu sA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32vqcpq4jg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Aug 2020 08:34:20 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 07DCXAaZ084909;
        Thu, 13 Aug 2020 08:34:19 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32vqcpq4h5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Aug 2020 08:34:19 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07DCLTax018223;
        Thu, 13 Aug 2020 12:34:16 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 32skahdhyv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Aug 2020 12:34:16 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07DCYDMd26018300
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Aug 2020 12:34:13 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AE8354C052;
        Thu, 13 Aug 2020 12:34:13 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EC1324C04A;
        Thu, 13 Aug 2020 12:34:12 +0000 (GMT)
Received: from oc5500677777.ibm.com (unknown [9.145.93.1])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 13 Aug 2020 12:34:12 +0000 (GMT)
Subject: Re: [PATCH v2] PCI: Introduce flag for detached virtual functions
From:   Niklas Schnelle <schnelle@linux.ibm.com>
To:     "Oliver O'Halloran" <oohall@gmail.com>
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
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
Message-ID: <17be8c41-8989-f1da-a843-30f0761f42de@linux.ibm.com>
Date:   Thu, 13 Aug 2020 14:34:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <dc79c8a9-1bbc-380f-741f-bca270a34483@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-13_10:2020-08-13,2020-08-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 spamscore=0 impostorscore=0 mlxscore=0 phishscore=0 suspectscore=0
 lowpriorityscore=0 mlxlogscore=999 clxscore=1015 priorityscore=1501
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008130094
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/13/20 12:40 PM, Niklas Schnelle wrote:
> 
> 
> On 8/13/20 11:59 AM, Oliver O'Halloran wrote:
>> On Thu, Aug 13, 2020 at 7:00 PM Niklas Schnelle <schnelle@linux.ibm.com> wrote:
>>>
>>>
>>> On 8/13/20 3:55 AM, Oliver O'Halloran wrote:
>>>> On Thu, Aug 13, 2020 at 5:21 AM Matthew Rosato <mjrosato@linux.ibm.com> wrote:
>>>>> *snip*
>>>>> diff --git a/arch/s390/pci/pci.c b/arch/s390/pci/pci.c
>>>>> index 3902c9f..04ac76d 100644
>>>>> --- a/arch/s390/pci/pci.c
>>>>> +++ b/arch/s390/pci/pci.c
>>>>> @@ -581,6 +581,14 @@ int pcibios_enable_device(struct pci_dev *pdev, int mask)
>>>>>  {
>>>>>         struct zpci_dev *zdev = to_zpci(pdev);
>>>>>
>>>>> +       /*
>>>>> +        * If we have a VF on a non-multifunction bus, it must be a VF that is
>>>>> +        * detached from its parent PF.  We rely on firmware emulation to
>>>>> +        * provide underlying PF details.
>>>>> +        */
>>>>> +       if (zdev->vfn && !zdev->zbus->multifunction)
>>>>> +               pdev->detached_vf = 1;
>>>>
>>>> The enable hook seems like it's a bit too late for this sort of
>>>> screwing around with the pci_dev. Anything in the setup path that
>>>> looks at ->detached_vf would see it cleared while anything that looks
>>>> after the device is enabled will see it set. Can this go into
>>>> pcibios_add_device() or a fixup instead?
>>>>
>>>
>>> This particular check could go into pcibios_add_device() yes.
>>> We're also currently working on a slight rework of how
>>> we establish the VF to parent PF linking including the sysfs
>>> part of that. The latter sadly can only go after the sysfs
>>> for the virtfn has been created and that only happens
>>> after all fixups. We would like to do both together because
>>> the latter sets pdev->is_virtfn which I think is closely related.
>>>
>>> I was thinking of starting another discussion
>>> about adding a hook that is executed just after the sysfs entries
>>> for the PCI device are created but haven't yet.
>>
>> if all you need is sysfs then pcibios_bus_add_device() or a bus
>> notifier should work
> 
> So this might go a bit off track but the problem is that
> on s390 a VF can be disabled and reenabled with disable_slot()/enable_slot().
> In this case pcibios_bus_add_device() is not called again but
> the PF/VF link needs to be reestablished.

Scratch that I must have made some stupid mistake last time I tried
this, with your suggestion I tried again and it works perfectly
moving the setup into pcibios_bus_add_device().
Thank you, this is actually much nicer!

> 
> ... snip ...
> 
