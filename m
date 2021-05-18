Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9AC0387DCD
	for <lists+kvm@lfdr.de>; Tue, 18 May 2021 18:36:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350879AbhERQh0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 May 2021 12:37:26 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:12552 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1350859AbhERQhQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 May 2021 12:37:16 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14IGYIce148595;
        Tue, 18 May 2021 12:35:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=GdRBRmnqVr6QPOCuFGmuEfiUDUiuIams0JIQv92tmcQ=;
 b=Au5W1E682KHSav0TUUcO2TOdJInDnvJcJiJwvB3aYx+Kh3jaV3oZzn+OjbprY3c1D7wJ
 lngRVR0dz/W6z8SLTDqoht84GcUSSFux6qNB6m4PLunT2lTuG3R/2Ii7C2OQAW4nSn5d
 4evDBFhPfBGF/he1Qefg+5a/VI2raIlynoyWrr74KowZaRrLqNE/qF5L7wA3Vc99UFuh
 lKSW+9CzEcVlvBXP0TctDKktHpT+g9RMRdiWqcM3kqjb4xkWbTgVGtzyKURddc/7Dcn9
 2wykKjERNbc2f9f2sRf09q4P0a5QRpPnTEaJQmqXehTBPvuZC39HNvZ79UJ0eBAcCuwe zg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38mgjjs39q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 May 2021 12:35:57 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14IGYJUw148660;
        Tue, 18 May 2021 12:35:57 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38mgjjs38u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 May 2021 12:35:57 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14IGXovv023892;
        Tue, 18 May 2021 16:35:54 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma05fra.de.ibm.com with ESMTP id 38m19sr8sp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 May 2021 16:35:54 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14IGZp1o19333484
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 May 2021 16:35:51 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7878142041;
        Tue, 18 May 2021 16:35:51 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 016A942042;
        Tue, 18 May 2021 16:35:51 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.73.129])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 18 May 2021 16:35:50 +0000 (GMT)
Subject: Re: [PATCH v1 00/11] KVM: s390: pv: implement lazy destroy
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        frankja@linux.ibm.com, thuth@redhat.com, pasic@linux.ibm.com,
        david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210517200758.22593-1-imbrenda@linux.ibm.com>
 <20210518170537.58b32ffe.cohuck@redhat.com> <20210518173624.13d043e3@ibm-vm>
 <225fe3ec-f2e9-6c76-97e1-b252fe3326b3@de.ibm.com>
 <20210518181305.2a9d19f3@ibm-vm>
 <896be0fd-5d5d-5998-8cb0-4ac8637412ac@de.ibm.com>
 <20210518183442.6e078ea1@ibm-vm>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <cb21db5f-f303-5b4b-6fab-5b28728e8ef2@de.ibm.com>
Date:   Tue, 18 May 2021 18:35:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210518183442.6e078ea1@ibm-vm>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: YCjkDYYQGDvN0yvMLgwhoav07XzDKegc
X-Proofpoint-ORIG-GUID: 2KJSULVZ3uDD2dKo0PivT5bqdVYfqaOB
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



On 18.05.21 18:34, Claudio Imbrenda wrote:
> On Tue, 18 May 2021 18:20:22 +0200
> Christian Borntraeger <borntraeger@de.ibm.com> wrote:
> 
>> On 18.05.21 18:13, Claudio Imbrenda wrote:
>>> On Tue, 18 May 2021 17:45:18 +0200
>>> Christian Borntraeger <borntraeger@de.ibm.com> wrote:
>>>    
>>>> On 18.05.21 17:36, Claudio Imbrenda wrote:
>>>>> On Tue, 18 May 2021 17:05:37 +0200
>>>>> Cornelia Huck <cohuck@redhat.com> wrote:
>>>>>       
>>>>>> On Mon, 17 May 2021 22:07:47 +0200
>>>>>> Claudio Imbrenda <imbrenda@linux.ibm.com> wrote:
>>>>>>      
>>>>>>> Previously, when a protected VM was rebooted or when it was shut
>>>>>>> down, its memory was made unprotected, and then the protected VM
>>>>>>> itself was destroyed. Looping over the whole address space can
>>>>>>> take some time, considering the overhead of the various
>>>>>>> Ultravisor Calls (UVCs).  This means that a reboot or a shutdown
>>>>>>> would take a potentially long amount of time, depending on the
>>>>>>> amount of used memory.
>>>>>>>
>>>>>>> This patchseries implements a deferred destroy mechanism for
>>>>>>> protected guests. When a protected guest is destroyed, its
>>>>>>> memory is cleared in background, allowing the guest to restart
>>>>>>> or terminate significantly faster than before.
>>>>>>>
>>>>>>> There are 2 possibilities when a protected VM is torn down:
>>>>>>> * it still has an address space associated (reboot case)
>>>>>>> * it does not have an address space anymore (shutdown case)
>>>>>>>
>>>>>>> For the reboot case, the reference count of the mm is increased,
>>>>>>> and then a background thread is started to clean up. Once the
>>>>>>> thread went through the whole address space, the protected VM is
>>>>>>> actually destroyed.
>>>>>>>
>>>>>>> For the shutdown case, a list of pages to be destroyed is formed
>>>>>>> when the mm is torn down. Instead of just unmapping the pages
>>>>>>> when the address space is being torn down, they are also set
>>>>>>> aside. Later when KVM cleans up the VM, a thread is started to
>>>>>>> clean up the pages from the list.
>>>>>>
>>>>>> Just to make sure, 'clean up' includes doing uv calls?
>>>>>
>>>>> yes
>>>>>       
>>>>>>>
>>>>>>> This means that the same address space can have memory belonging
>>>>>>> to more than one protected guest, although only one will be
>>>>>>> running, the others will in fact not even have any CPUs.
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
>>>>>
>>>>> the KVM guest is not affected in case of reboot, so the userspace
>>>>> address space is not touched.
>>>>>       
>>>>>> Can too many not-yet-cleaned-up pages lead to a (temporary)
>>>>>> memory exhaustion?
>>>>>
>>>>> in case of reboot, not much; the pages were in use are still in
>>>>> use after the reboot, and they can be swapped.
>>>>>
>>>>> in case of a shutdown, yes, because the pages are really taken
>>>>> aside and cleared/destroyed in background. they cannot be
>>>>> swapped. they are freed immediately as they are processed, to try
>>>>> to mitigate memory exhaustion scenarios.
>>>>>
>>>>> in the end, this patchseries is a tradeoff between speed and
>>>>> memory consumption. the memory needs to be cleared up at some
>>>>> point, and that requires time.
>>>>>
>>>>> in cases where this might be an issue, I introduced a new KVM flag
>>>>> to disable lazy destroy (patch 10)
>>>>
>>>> Maybe we could piggy-back on the OOM-kill notifier and then fall
>>>> back to synchronous freeing for some pages?
>>>
>>> I'm not sure I follow
>>>
>>> once the pages have been set aside, it's too late
>>>
>>> while the pages are being set aside, every now and then some memory
>>> needs to be allocated. the allocation is atomic, not allowed to use
>>> emergency reserves, and can fail without warning. if the allocation
>>> fails, we clean up one page and continue, without setting aside
>>> anything (patch 9)
>>>
>>> so if the system is low on memory, the lazy destroy should not make
>>> the situation too much worse.
>>>
>>> the only issue here is starting a normal process in the host (maybe
>>> a non secure guest) that uses a lot of memory very quickly, right
>>> after a large secure guest has terminated.
>>
>> I think page cache page allocations do not need to be atomic.
>> In that case the kernel might stil l decide to trigger the oom
>> killer. We can let it notify ourselves free 256 pages synchronously
>> and avoid the oom kill. Have a look at the virtio-balloon
>> virtio_balloon_oom_notify
> 
> the issue is that once the pages have been set aside, it's too late.
> the OOM notifier would only be useful if we get notified of the OOM
> situation _while_ setting aside the pages.
> 
> unless you mean that the notifier should simply wait until the thread
> has done (some of) its work?

Exactly. Let the notifier wait until you have freed 256pages and return
256 to the oom notifier.
