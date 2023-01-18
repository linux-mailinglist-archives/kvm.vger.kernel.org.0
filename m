Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A9F6672216
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 16:51:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231374AbjARPu5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 10:50:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230325AbjARPuH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 10:50:07 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07FF738662
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 07:48:30 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30IDrM1l026878;
        Wed, 18 Jan 2023 15:48:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=NchMlj1ckhjhtBOdPVQMHQV/zKaR+7ry2beCggPwhc4=;
 b=Ig2+KiHm3TWZM6/y/OmT1Sh1cCVAO7lT2gfBFcjysCZsla7bosi++nxHEwuoEzNe38bW
 NHaEfVHK5uuPRF4OxRGjYs+XuPoVfQn4Jd++JSi3PFLko7fsfDl1S/yb6unp4G5tPx61
 3nO/SYvKG6gknL5yBaOlCAdYuyf95IRDTkJ41SJlvihyyvxYS6T459iqsVU5t2HS/nu7
 ypZTfzgHYZU+hYksJMLPctisQCWiMqyE83N4ryzPFIRi1bHSnIjdDgvKUKX+4090RnsX
 U6eM8TF5xXz6tDWwDyE8pFCjzDN7TZrcPTk6uNHelDFLQIVNpsnv7+ROkoAgRCGtsgjv xg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3n6j232ysv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Jan 2023 15:48:16 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30IErQNp009455;
        Wed, 18 Jan 2023 15:48:16 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3n6j232ysc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Jan 2023 15:48:16 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30I66Ldc006701;
        Wed, 18 Jan 2023 15:48:14 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3n3m16m0r1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Jan 2023 15:48:14 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30IFmAtR45351420
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Jan 2023 15:48:10 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4DD1620040;
        Wed, 18 Jan 2023 15:48:10 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D855920043;
        Wed, 18 Jan 2023 15:48:08 +0000 (GMT)
Received: from [9.179.13.15] (unknown [9.179.13.15])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 18 Jan 2023 15:48:08 +0000 (GMT)
Message-ID: <32cf9903-e1e6-ca38-a8f1-1e904d975cbe@linux.ibm.com>
Date:   Wed, 18 Jan 2023 16:48:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v14 08/11] qapi/s390/cpu topology: change-topology monitor
 command
Content-Language: en-US
To:     Kevin Wolf <kwolf@redhat.com>, Thomas Huth <thuth@redhat.com>
Cc:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>, qemu-s390x@nongnu.org,
        qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        frankja@linux.ibm.com, berrange@redhat.com, clg@kaod.org,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>, hreitz@redhat.com
References: <20230105145313.168489-1-pmorel@linux.ibm.com>
 <20230105145313.168489-9-pmorel@linux.ibm.com>
 <72baa5b42abe557cdf123889b33b845b405cc86c.camel@linux.ibm.com>
 <cd9e0c88-c2a8-1eca-d146-3fd6639af3e7@redhat.com>
 <5654d88fb7d000369c6cfdbe0213ca9d2bfe013b.camel@linux.ibm.com>
 <91566c93-a422-7969-1f7e-80c6f3d214f1@redhat.com>
 <Y8gNo74mLXwAxVqy@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <Y8gNo74mLXwAxVqy@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: vuyK-oLaDJG_pDNHBmyj1CPIpMnstyPd
X-Proofpoint-ORIG-GUID: OUesE0Iz423i756j9XK8ohWjy-_KVig_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-18_05,2023-01-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 phishscore=0
 clxscore=1015 priorityscore=1501 malwarescore=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 suspectscore=0 impostorscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301180130
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/18/23 16:17, Kevin Wolf wrote:
> Am 18.01.2023 um 11:53 hat Thomas Huth geschrieben:
>> On 17/01/2023 14.31, Nina Schoetterl-Glausch wrote:
>>> On Tue, 2023-01-17 at 08:30 +0100, Thomas Huth wrote:
>>>> On 16/01/2023 22.09, Nina Schoetterl-Glausch wrote:
>>>>> On Thu, 2023-01-05 at 15:53 +0100, Pierre Morel wrote:
>>>>>> The modification of the CPU attributes are done through a monitor
>>>>>> commands.
>>>>>>
>>>>>> It allows to move the core inside the topology tree to optimise
>>>>>> the cache usage in the case the host's hypervizor previously
>>>>>> moved the CPU.
>>>>>>
>>>>>> The same command allows to modifiy the CPU attributes modifiers
>>>>>> like polarization entitlement and the dedicated attribute to notify
>>>>>> the guest if the host admin modified scheduling or dedication of a vCPU.
>>>>>>
>>>>>> With this knowledge the guest has the possibility to optimize the
>>>>>> usage of the vCPUs.
>>>>>>
>>>>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>>>>> ---
>> ...
>>>>>> +    s390_topology.sockets[s390_socket_nb(id)]--;
>>>>>
>>>>> I suppose this function cannot run concurrently, so the same CPU doesn't get removed twice.
>>>>
>>>> QEMU has the so-called BQL - the Big Qemu Lock. Instructions handlers are
>>>> normally called with the lock taken, see qemu_mutex_lock_iothread() in
>>>> target/s390x/kvm/kvm.c.
>>>
>>> That is good to know, but is that the relevant lock here?
>>> We don't want to concurrent qmp commands. I looked at the code and it's pretty complicated.
>>
>> Not sure, but I believe that QMP commands are executed from the main
>> iothread, so I think this should be safe? ... CC:-ing some more people who
>> might know the correct answer.
> 
> In general yes, QMP commands are processed one after another in the main
> thread while holding the BQL. And I think this is the relevant case for
> you.
> 
> The exception is out-of-band commands, which I think run in the monitor
> thread while some other (normal) command could be processed. OOB
> commands are quite limited in what they are allowed to do, though, and
> there aren't many of them. They are mainly meant to fix situations where
> something (including other QMP commands) got stuck.
> 
> Kevin
> 

Thanks Kevin,

regards,
Pierre
-- 
Pierre Morel
IBM Lab Boeblingen
