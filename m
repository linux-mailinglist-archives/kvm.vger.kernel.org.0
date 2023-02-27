Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40AA76A4819
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 18:34:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbjB0Rez (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 12:34:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229790AbjB0Res (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 12:34:48 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3D83BBA5
        for <kvm@vger.kernel.org>; Mon, 27 Feb 2023 09:34:41 -0800 (PST)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31RGpfMG026739;
        Mon, 27 Feb 2023 17:34:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Z4MQjNfpT/pG5Ir8oEEcSXH0GeCk+FTPmNQ9BuLSP1E=;
 b=QA7s6KMs2IiqAY/ZEjwI6+uD1aR2UqtfZdCP+jtVVzvGSM6m3FYc2SWKILSJoLXZYPrl
 psxe6wk0T5zbmiS7kuUW18igibKSHwRH5YOz8uXYjhcRTUsHtxQrq81ojXkNYSWT31f2
 qBHfI0+E3MTN3/5XBHUN5vk76J9IsKnTbsSbfDDT2AoebEAh4YY2TzE3lVkW76ZJfnkY
 CD3eSWctHdbDf8sZMWUdruj/MpbFhkEjsKKaMUh16WhFKjxblyusK/9KR/FeTt2rJtPh
 Fa8iAFJg76zvloqau5RynolujSHJJErSyqpWhZpctkJhImiVz1H4tZO6dujhhk27ySyr zQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p0u1rb2v1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Feb 2023 17:34:33 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31RH3SW0016597;
        Mon, 27 Feb 2023 17:34:32 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p0u1rb2u3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Feb 2023 17:34:32 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31QMtiMe018440;
        Mon, 27 Feb 2023 17:34:29 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3nybbdhm52-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Feb 2023 17:34:29 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31RHYQqc22151494
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Feb 2023 17:34:26 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2C6952004B;
        Mon, 27 Feb 2023 17:34:26 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C01DD20043;
        Mon, 27 Feb 2023 17:34:24 +0000 (GMT)
Received: from [9.171.54.232] (unknown [9.171.54.232])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Mon, 27 Feb 2023 17:34:24 +0000 (GMT)
Message-ID: <0a5c020e-4827-4e6c-ab2c-2e4c47285f33@linux.ibm.com>
Date:   Mon, 27 Feb 2023 18:34:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v16 11/11] docs/s390x/cpu topology: document s390x cpu
 topology
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        nsg@linux.ibm.com, frankja@linux.ibm.com, berrange@redhat.com,
        clg@kaod.org
References: <20230222142105.84700-1-pmorel@linux.ibm.com>
 <20230222142105.84700-12-pmorel@linux.ibm.com>
 <039b5a0f-4440-324c-d5a7-54e9e1c89ea8@redhat.com>
 <dcac1561-8c91-310c-7e9f-db9fff3b00a7@linux.ibm.com>
 <365c5bca-eda6-52dd-a90c-12de397bedf6@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <365c5bca-eda6-52dd-a90c-12de397bedf6@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: VXr9Ndm6xS3faKTZ9wzTzcU7MnYFcnlA
X-Proofpoint-ORIG-GUID: eEikCUMIKpcrtnoHcBQXvN-N1JeIEDLo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-27_13,2023-02-27_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 clxscore=1015 suspectscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0
 spamscore=0 impostorscore=0 priorityscore=1501 mlxscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302270137
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2/27/23 15:27, Thomas Huth wrote:
> On 27/02/2023 15.17, Pierre Morel wrote:
>>
>> On 2/27/23 14:58, Thomas Huth wrote:
>>> On 22/02/2023 15.21, Pierre Morel wrote:
>>>> Add some basic examples for the definition of cpu topology
>>>> in s390x.
>>>>
>>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>>> ---
>>>>   docs/system/s390x/cpu-topology.rst | 378 
>>>> +++++++++++++++++++++++++++++
>>>>   docs/system/target-s390x.rst       |   1 +
>>>>   2 files changed, 379 insertions(+)
>>>>   create mode 100644 docs/system/s390x/cpu-topology.rst
>>>>
>>>> diff --git a/docs/system/s390x/cpu-topology.rst 
>>>> b/docs/system/s390x/cpu-topology.rst
>>>> new file mode 100644
>>>> index 0000000000..d470e28b97
>>>> --- /dev/null
>>>> +++ b/docs/system/s390x/cpu-topology.rst
>>>> @@ -0,0 +1,378 @@
>>>> +CPU topology on s390x
>>>> +=====================
>>>> +
>>>> +Since QEMU 8.0, CPU topology on s390x provides up to 3 levels of
>>>> +topology containers: drawers, books, sockets, defining a tree shaped
>>>> +hierarchy.
>>>> +
>>>> +The socket container contains one or more CPU entries consisting
>>>> +of a bitmap of three dentical CPU attributes:
>>>
>>> What do you mean by "dentical" here?
>>
>> :D i.. dentical
>>
>> I change it to identical
>
> Ok, but even with "i" at the beginning, it does not make too much 
> sense here to me - I'd interpret "identical" as "same", but these 
> attributes have clearly different meanings, haven't they?
>
>  Thomas
>
>
Ah OK I understand what is unclear.

What I mean is that in each socket we have several CPU TLE entries each 
entry has different attributes values and contains CPU bit in the mask 
for CPU with identical attributes.

For example,

in the case of horizontal polarization, we have one CPU TLE entry for 
low entitlement, one CPU TLE for medium entitlement, one for high 
entitlement and one for high entitlement with dedicated CPU

in the case of horizontal polarization we have one CPU TLE for non 
dedicated CPU and one for dedicated CPU.

Only CPU TLE with at least one bit (CPU) set in the mask is written 
inside the SYSIB.

Regards,

Pierre




