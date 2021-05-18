Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90103387DFA
	for <lists+kvm@lfdr.de>; Tue, 18 May 2021 18:56:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350935AbhERQ5W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 May 2021 12:57:22 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:44676 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1350921AbhERQ5V (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 May 2021 12:57:21 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14IGYIlL148595;
        Tue, 18 May 2021 12:56:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=ZGikWVfUtpfOAAvPiUkgUShkYVgHpqL4NX8lGw8AWXY=;
 b=OnWXVWvZ18PeIzclYiC/AbiDCUIvE0u5oFtNMJor1z/DS47e41mpiCApCEtK0x0etuAl
 x45IgH9Ac6Y44me0DZt5NUUZgfJQxSizajmlhcAV1/yoQOkuP90HsFzo7YS5hEOi0Q5F
 O/am/fjf8D7chHeWzFMCraLtPlb64ahrkjlcX6i3Vu9gScASq2LDDHnSLgKKLDKywmyZ
 Tv55xaDoik3D9NbaTClCMHajzItldNd5FDDS5AF5pETNFLnlhPYHdlmQ+hZxAowOUykE
 dAFuzTb6aoMw6TBG/Vh725l6wqBdqLCN6ohLEcqkKrMGSm5dTdSxUpRYuQi31hsNyuin 4Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38mgjjsk0d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 May 2021 12:56:02 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14IGYK9b148778;
        Tue, 18 May 2021 12:56:02 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38mgjjsjys-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 May 2021 12:56:02 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14IGrTYm006341;
        Tue, 18 May 2021 16:56:00 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 38j5jgsm1b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 May 2021 16:56:00 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14IGtvOE57934224
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 May 2021 16:55:57 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3AB5142045;
        Tue, 18 May 2021 16:55:57 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BDE934203F;
        Tue, 18 May 2021 16:55:56 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.73.129])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 18 May 2021 16:55:56 +0000 (GMT)
Subject: Re: [PATCH v1 00/11] KVM: s390: pv: implement lazy destroy
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        frankja@linux.ibm.com, thuth@redhat.com, pasic@linux.ibm.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210517200758.22593-1-imbrenda@linux.ibm.com>
 <20210518170537.58b32ffe.cohuck@redhat.com> <20210518173624.13d043e3@ibm-vm>
 <20210518180411.4abf837d.cohuck@redhat.com> <20210518181922.52d04c61@ibm-vm>
 <a38192d5-0868-8e07-0a34-c1615e1997fc@redhat.com>
 <20210518183131.1e0cf801@ibm-vm>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <e66400c5-a1b6-c5fe-d715-c08b166a7b54@de.ibm.com>
Date:   Tue, 18 May 2021 18:55:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210518183131.1e0cf801@ibm-vm>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: oChby2Y3pxZXMkMI0VF1MdVhXBawnRBp
X-Proofpoint-ORIG-GUID: eBOfXgdcVIvCt0P55KCsQDdUk892_jJM
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-18_08:2021-05-18,2021-05-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 adultscore=0 impostorscore=0 malwarescore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 clxscore=1015 mlxscore=0 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105180113
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 18.05.21 18:31, Claudio Imbrenda wrote:
> On Tue, 18 May 2021 18:22:42 +0200
> David Hildenbrand <david@redhat.com> wrote:
> 
>> On 18.05.21 18:19, Claudio Imbrenda wrote:
>>> On Tue, 18 May 2021 18:04:11 +0200
>>> Cornelia Huck <cohuck@redhat.com> wrote:
>>>    
>>>> On Tue, 18 May 2021 17:36:24 +0200
>>>> Claudio Imbrenda <imbrenda@linux.ibm.com> wrote:
>>>>   
>>>>> On Tue, 18 May 2021 17:05:37 +0200
>>>>> Cornelia Huck <cohuck@redhat.com> wrote:
>>>>>       
>>>>>> On Mon, 17 May 2021 22:07:47 +0200
>>>>>> Claudio Imbrenda <imbrenda@linux.ibm.com> wrote:
>>>>   
>>>>>>> This means that the same address space can have memory
>>>>>>> belonging to more than one protected guest, although only one
>>>>>>> will be running, the others will in fact not even have any
>>>>>>> CPUs.
>>>>>>
>>>>>> Are those set-aside-but-not-yet-cleaned-up pages still possibly
>>>>>> accessible in any way? I would assume that they only belong to
>>>>>> the
>>>>>
>>>>> in case of reboot: yes, they are still in the address space of the
>>>>> guest, and can be swapped if needed
>>>>>       
>>>>>> 'zombie' guests, and any new or rebooted guest is a new entity
>>>>>> that needs to get new pages?
>>>>>
>>>>> the rebooted guest (normal or secure) will re-use the same pages
>>>>> of the old guest (before or after cleanup, which is the reason of
>>>>> patches 3 and 4)
>>>>
>>>> Took a look at those patches, makes sense.
>>>>   
>>>>>
>>>>> the KVM guest is not affected in case of reboot, so the userspace
>>>>> address space is not touched.
>>>>
>>>> 'guest' is a bit ambiguous here -- do you mean the vm here, and the
>>>> actual guest above?
>>>>   
>>>
>>> yes this is tricky, because there is the guest OS, which terminates
>>> or reboots, then there is the "secure configuration" entity,
>>> handled by the Ultravisor, and then the KVM VM
>>>
>>> when a secure guest reboots, the "secure configuration" is
>>> dismantled (in this case, in a deferred way), and the KVM VM (and
>>> its memory) is not directly affected
>>>
>>> what happened before was that the secure configuration was
>>> dismantled synchronously, and then re-created.
>>>
>>> now instead, a new secure configuration is created using the same
>>> KVM VM (and thus the same mm), before the old secure configuration
>>> has been completely dismantled. hence the same KVM VM can have
>>> multiple secure configurations associated, sharing the same address
>>> space.
>>>
>>> of course, only the newest one is actually running, the other ones
>>> are "zombies", without CPUs.
>>>    
>>
>> Can a guest trigger a DoS?
> 
> I don't see how
> 
> a guest can fill its memory and then reboot, and then fill its memory
> again and then reboot... but that will take time, filling the memory
> will itself clean up leftover pages from previous boots.

In essence this guest will then synchronously wait for the page to be
exported and reimported, correct?
> 
> "normal" reboot loops will be fast, because there won't be much memory
> to process
> 
> I have actually tested mixed reboot/shutdown loops, and the system
> behaved as you would expect when under load.

I guess the memory will continue to be accounted to the memcg? Correct?
