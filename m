Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95D0861EFA0
	for <lists+kvm@lfdr.de>; Mon,  7 Nov 2022 10:53:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231601AbiKGJxU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Nov 2022 04:53:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230408AbiKGJxT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Nov 2022 04:53:19 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DF97140E0
        for <kvm@vger.kernel.org>; Mon,  7 Nov 2022 01:53:18 -0800 (PST)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A784cEW008507;
        Mon, 7 Nov 2022 09:52:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=14txLhW4w9k21V55YRJmQefhy8Bmmsighk/p4xndYDQ=;
 b=qswhW3D/PPChGAfAS8SAj/Q8FedJhXsCSbOw6GUV/BcTWsmEp/7+2GwJuwZgnM1MJFgn
 9fHzGdW+47Lg8AY6WzCW7OLeaHk+58hBxqsa975DjSPz+U2E5byx8CBwGk4gpujJ9KYo
 6wagPxVDnEvojs5fXhlpGvnKLuq6k5D5Od4EDED1Dn96LeUq9VMi4YVDlbnVfN/zLC1q
 CvHpd5FgAoxNyys27hCLZdPXFNS8+Tcm6nvakKkrEyhWemLsNDZbXds7yHHB3j6uyybX
 j50LWhEpJn8NDQNlMltD713N8iK1/KT7/t/1Yfd7oZp+FHxftiqO6Wu0W+Ixe9X8spAb qA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kpx6c2uw1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Nov 2022 09:52:42 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2A788Ghb002941;
        Mon, 7 Nov 2022 09:52:42 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kpx6c2uux-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Nov 2022 09:52:41 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2A79pLue032208;
        Mon, 7 Nov 2022 09:52:39 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma02fra.de.ibm.com with ESMTP id 3kngpghpt0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Nov 2022 09:52:39 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2A79kt1S50135352
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 7 Nov 2022 09:46:55 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CDC914C04A;
        Mon,  7 Nov 2022 09:52:35 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D3E924C040;
        Mon,  7 Nov 2022 09:52:34 +0000 (GMT)
Received: from [9.171.53.254] (unknown [9.171.53.254])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  7 Nov 2022 09:52:34 +0000 (GMT)
Message-ID: <ee0c10e7-f27d-cd3a-5a77-9b29d61e1b14@linux.ibm.com>
Date:   Mon, 7 Nov 2022 10:52:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH v11 01/11] s390x: Register TYPE_S390_CCW_MACHINE
 properties as class properties
To:     Thomas Huth <thuth@redhat.com>,
        =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>,
        qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        scgl@linux.ibm.com, frankja@linux.ibm.com, berrange@redhat.com
References: <20221103170150.20789-1-pmorel@linux.ibm.com>
 <20221103170150.20789-2-pmorel@linux.ibm.com>
 <3f913a58-e7d0-539e-3bc0-6cbd5608db8e@redhat.com>
 <7d809617-67e0-d233-97b2-8534e2a4610f@linux.ibm.com>
 <6415cf08-e6a1-c72a-1c56-907d3a446a8c@kaod.org>
 <7a3c34dc-2c16-6fdd-e8bc-7a1c623823ae@redhat.com>
 <7177da22-ca19-6510-9bf3-4120140f5431@linux.ibm.com>
 <5fd39710-902e-bc26-65ec-12cabe24178d@redhat.com>
Content-Language: en-US
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <5fd39710-902e-bc26-65ec-12cabe24178d@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: nbg6LsIyCqc2MWSmWzdtFk_y_gqnONJx
X-Proofpoint-ORIG-GUID: vBh4ybqLFjT6lotASWhiEyyc_dPqIJzy
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_02,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 lowpriorityscore=0 spamscore=0 impostorscore=0
 mlxlogscore=999 bulkscore=0 clxscore=1015 suspectscore=0 malwarescore=0
 mlxscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211070080
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11/6/22 12:37, Thomas Huth wrote:
> On 04/11/2022 15.57, Pierre Morel wrote:
>>
>>
>> On 11/4/22 15:29, Thomas Huth wrote:
>>> On 04/11/2022 11.53, Cédric Le Goater wrote:
>>>> On 11/4/22 11:16, Pierre Morel wrote:
>>>>>
>>>>>
>>>>> On 11/4/22 07:32, Thomas Huth wrote:
>>>>>> On 03/11/2022 18.01, Pierre Morel wrote:
>>>>>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>>>>>> ---
>>>>>>>   hw/s390x/s390-virtio-ccw.c | 127 
>>>>>>> +++++++++++++++++++++----------------
>>>>>>>   1 file changed, 72 insertions(+), 55 deletions(-)
>>>>>>
>>>>>> -EMISSINGPATCHDESCRIPTION
>>>>>>
>>>>>> ... please add some words *why* this is a good idea / necessary.
>>>>>
>>>>> I saw that the i386 patch had no description for the same patch so...
>>>>>
>>>>> To be honest I do not know why it is necessary.
>>>>> The only reason I see is to be in sync with the PC implementation.
>>>>>
>>>>> So what about:
>>>>> "
>>>>> Register TYPE_S390_CCW_MACHINE properties as class properties
>>>>> to be conform with the X architectures
>>>>> "
>>>>> ?
>>>>>
>>>>> @Cédric , any official recommendation for doing that?
>>>>
>>>> There was a bunch of commits related to QOM in this series :
>>>>
>>>>    91def7b83 arm/virt: Register most properties as class properties
>>>>    f5730c69f0 i386: Register feature bit properties as class properties
>>>>
>>>> which moved property definitions at the class level.
>>>>
>>>> Then,
>>>>
>>>>    commit d8fb7d0969 ("vl: switch -M parsing to keyval")
>>>>
>>>> changed machine_help_func() to use a machine class and not machine
>>>> instance anymore.
>>>>
>>>> I would use the same kind of commit log and add a Fixes tag to get it
>>>> merged in 7.2
>>>
>>> Ah, so this fixes the problem that running QEMU with " -M 
>>> s390-ccw-virtio,help" does not show the s390x-specific properties 
>>> anymore? ... that's certainly somethings that should be mentioned in 
>>> the commit message! What about something like this:
>>>
>>> "Currently, when running 'qemu-system-s390x -M -M 
>>> s390-ccw-virtio,help' the s390x-specific properties are not listed 
>>> anymore. This happens because since commit d8fb7d0969 ("vl: switch -M 
>>> parsing to keyval") the properties have to be defined at the class 
>>> level and not at the instance level anymore. Fix it on s390x now, 
>>> too, by moving the registration of the properties to the class level"
>>>
>>> Fixes: d8fb7d0969 ("vl: switch -M parsing to keyval")
>>>
>>> ?
>>>
>>>   Thomas
>>>
>>
>> That seems really good :)
> 
> All right, I've queued this patch (with the updated commit description) 
> and the next one on my s390x-branch for QEMU 7.2:
> 
>   https://gitlab.com/thuth/qemu/-/commits/s390x-next/
> 
>   Thomas
> 
> 

Thank you!

Regards,
Pierre


-- 
Pierre Morel
IBM Lab Boeblingen
