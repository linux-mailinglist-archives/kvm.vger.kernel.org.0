Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F24B68D7E3
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 14:04:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232109AbjBGNEC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Feb 2023 08:04:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232096AbjBGND4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Feb 2023 08:03:56 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE4B139B8F
        for <kvm@vger.kernel.org>; Tue,  7 Feb 2023 05:03:54 -0800 (PST)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 317CiYKL008510;
        Tue, 7 Feb 2023 13:03:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=FD3ng3/DUeIa1ytGfU6rPkqMWcO54YEJNz9R2qDNsgw=;
 b=QsuqE1E66SRKtaz73JrEyra5nqS08p1WLLEA1qprntH2nnyLSlwNIuapGz98XFYJa6Ho
 02EShjQtANpg6E0rzKuhB1oHCFlduX4ufHeoMIvG4Sze00lFfc6yhcRJQKmy4jnhedzY
 xw5g3Kjzn4RxPpcvq3iqXMJrGM80tQ6lNvE6HN1BCkDUqhpqUJH3hsF2uvBwihw24R38
 dTedYj26oXBUcZvtG08BiNHuomqnM5CJx/aSZAxauMOceDj5ymNvkEIeCR+7b0n5cOaI
 TJvg1CedJVdMZHD1ayha6qK2ZGOE/lc7t11NLIP8q3nofxFiB8dXpf/QBADHXwVCKS7q gQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nkpwp0fpd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Feb 2023 13:03:42 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 317ClbDm023248;
        Tue, 7 Feb 2023 13:03:41 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nkpwp0fms-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Feb 2023 13:03:41 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 316JlUI0007292;
        Tue, 7 Feb 2023 13:03:38 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma06fra.de.ibm.com (PPS) with ESMTPS id 3nhemfjjyj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Feb 2023 13:03:38 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 317D3ZWx36897264
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 Feb 2023 13:03:35 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 321F920043;
        Tue,  7 Feb 2023 13:03:35 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D638C20040;
        Tue,  7 Feb 2023 13:03:34 +0000 (GMT)
Received: from [9.152.224.241] (unknown [9.152.224.241])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  7 Feb 2023 13:03:34 +0000 (GMT)
Message-ID: <1c0c2806-41cf-3e29-d4d2-02d08015fe32@linux.ibm.com>
Date:   Tue, 7 Feb 2023 14:03:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v15 06/11] s390x/cpu topology: interception of PTF
 instruction
Content-Language: en-US
To:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com,
        berrange@redhat.com, clg@kaod.org
References: <20230201132051.126868-1-pmorel@linux.ibm.com>
 <20230201132051.126868-7-pmorel@linux.ibm.com>
 <5c15ccde659a9849ab3529e08f5e1278508406c8.camel@linux.ibm.com>
 <f5c6b04a-0faa-ba36-9019-468662b9fbb2@linux.ibm.com>
 <b3c206df9dc08c094c0c717b0cb6457d29ed9925.camel@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <b3c206df9dc08c094c0c717b0cb6457d29ed9925.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: igNpiRYW8hzTug1W6pdWQtEzUOvoQeve
X-Proofpoint-GUID: vsMnOJys4OaCRZ7ZR7TgogNEbXPXpv0N
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-07_04,2023-02-06_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 priorityscore=1501 phishscore=0 impostorscore=0 malwarescore=0
 clxscore=1015 bulkscore=0 mlxscore=0 mlxlogscore=999 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302070111
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/7/23 12:27, Nina Schoetterl-Glausch wrote:
> On Tue, 2023-02-07 at 10:59 +0100, Pierre Morel wrote:
>>
>> On 2/6/23 19:34, Nina Schoetterl-Glausch wrote:
>>> On Wed, 2023-02-01 at 14:20 +0100, Pierre Morel wrote:

...

>>> [...]
>>>>    
>>>>    /**
>>>> @@ -137,6 +225,21 @@ static void s390_topology_cpu_default(S390CPU *cpu, Error **errp)
>>>>                              (smp->books * smp->sockets * smp->cores)) %
>>>>                             smp->drawers;
>>>>        }
>>>
>>> Why are the changes below in this patch?
>>
>> Because before thos patch we have only horizontal polarization.
> 
> Not really since you only enable topology in the next patch.
>>
>>>
>>>> +
>>>> +    /*
>>>> +     * Machine polarity is set inside the global s390_topology structure.
>>>> +     * In the case the polarity is set as horizontal set the entitlement
>>
>> Sorry here an error in the comment should be :
>> "In the case the polarity is NOT set as horizontal..."
>>
>>>> +     * to POLARITY_VERTICAL_MEDIUM which is the better equivalent when
>>>> +     * machine polarity is set to vertical or POLARITY_VERTICAL_HIGH if
>>>> +     * the vCPU is dedicated.
>>>> +     */
>>>> +    if (s390_topology.polarity && !env->entitlement) {
>>>
>>> It'd be more readable if you compared against enum values by name.
>>
>> Right, I will change this to
>>
>>       if (s390_topology.polarity != S390_POLARITY_HORIZONTAL &&
>>           env->entitlement == S390_ENTITLEMENT_UNSET) {
>>
>>>
>>> I don't see why you check s390_topology.polarity. If it is horizontal
>>> then the value of the entitlement doesn't matter at all, so you can set it
>>> to whatever.
>>
>> Right, that is why it is done only for vertical polarization (sorry for
>> the wrong comment)
> 
> I'm saying you don't need to check it at all. You adjust the values for
> vertical polarization, but you could just always do that since the values
> don't matter at all if the polarization is horizontal.

OK right

>>
>>> All you want to do is enforce dedicated -> VERTICAL_HIGH, right?
>>> So why don't you just add
>>>
>>> +    if (cpu->env.dedicated && cpu->env.entitlement != POLARITY_VERTICAL_HIGH) {
>>> +        error_setg(errp, "A dedicated cpu implies high entitlement");
>>> +        return;
>>> +    } >
>>> to s390_topology_check?
>>
>> Here it is to set the default in the case the values are not provided.
> 
> If no values are provided, they default to dedication=false and entitlement=medium,
> as defined by patch 1, which are fine and don't need to be adjusted.

Right, I think I added this when working on modifying the attributes in 
QAPI and rebased it in the wrong patch.
Here it has no sense.

> 
>>
>> But where you are right is that I should add a verification to the check
>> function.
>>
>>>
>>>> +        if (env->dedicated) {
>>>> +            env->entitlement = POLARITY_VERTICAL_HIGH;
>>>> +        } else {
>>>> +            env->entitlement = POLARITY_VERTICAL_MEDIUM;
>>>> +        }
>>>
>>> If it is horizontal, then setting the entitlement is pointless as it will be
>>> reset to medium on PTF.
>>
>> That is why the polarity is tested (sorry for the bad comment)
> 
> I said this because I'm fine with setting it pointlessly.
> 
>>> So the current polarization is vertical and a cpu is being hotplugged,
>>> but setting the entitlement of the cpu being added is also pointless, because
>>> it's determined by the dedication. That seems weird.
>>
>> No it is not determined by the dedication, if there is no dedication the
>> 3 vertical values are possible.
> 
> You set it to either high or medium based on the dedication. And for horizontal
> polarization it obviously doesn't matter.

on PTF yes but not on hotplug, on hotplug all 3 values are possible.

> 
> As far as I understand you don't need this because the default values are fine.
> You should add the check that if a dedicated cpu is hotplugged, then the entitlement
> must be high, to patch 2 and that's it, no additional changes necessary.

Yes, right.

Regards,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
