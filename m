Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A0FC671FAE
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 15:35:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbjAROfG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 09:35:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230292AbjAROem (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 09:34:42 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 513AF1206E
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 06:23:45 -0800 (PST)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30IDa7oI014063;
        Wed, 18 Jan 2023 14:23:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=6GJQ2A6inUJb3jVI1iUgFoUZ7sWyNtzkTMaU8Z4sfF8=;
 b=LK5u3uTXYJOuYLNokAt3eRJjTmkYm0kGEZEKqHF+PmXNVIhIVNdGutKS7U4ipg0RyvE9
 bRfig77xB76Vmfne25XiwK/VwBJmdwNOAzvI74GpVho/C9RdOJN9n6UEu5Yp/BQ5N3qK
 I66EqPyvM3/puvr0a0vYsk1F/jJSvrkWEq3DFdrfB36GaKkSnjxUh68E41G0HywBRM0N
 iwAntcNqoiiq9LkIsYa5fuDWItJMW5k259OU/EKbXdLpUNYbq5R+Fyv3Q9zXBn228awz
 ToDSk2dX8PI6PLfJnqBFqPk0vlZzE68OgfDbwmh51g/NIPLWEsoYuRJR214E5pO0r6M/ og== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n6fp6mm2b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Jan 2023 14:23:31 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30IBNhoE026749;
        Wed, 18 Jan 2023 14:23:31 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n6fp6mm1b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Jan 2023 14:23:31 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30IATgWk014427;
        Wed, 18 Jan 2023 14:23:28 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma05fra.de.ibm.com (PPS) with ESMTPS id 3n3m16bxe9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Jan 2023 14:23:28 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30IENOQS38273314
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Jan 2023 14:23:24 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8F20820040;
        Wed, 18 Jan 2023 14:23:24 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A69E820049;
        Wed, 18 Jan 2023 14:23:23 +0000 (GMT)
Received: from [9.171.39.117] (unknown [9.171.39.117])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 18 Jan 2023 14:23:23 +0000 (GMT)
Message-ID: <b8d577c5-04eb-f696-6b23-8d941ace5657@linux.ibm.com>
Date:   Wed, 18 Jan 2023 15:23:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v14 08/11] qapi/s390/cpu topology: change-topology monitor
 command
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        scgl@linux.ibm.com, frankja@linux.ibm.com, berrange@redhat.com,
        clg@kaod.org
References: <20230105145313.168489-1-pmorel@linux.ibm.com>
 <20230105145313.168489-9-pmorel@linux.ibm.com>
 <999a31e0-56f4-6d14-f264-320f51f259af@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <999a31e0-56f4-6d14-f264-320f51f259af@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 4zOlDYHGg03NMbm7-F86sn00d_hRIAL-
X-Proofpoint-ORIG-GUID: VFpRroAezalVyBKsM287wqltocRW1wvO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-18_05,2023-01-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 impostorscore=0 adultscore=0 suspectscore=0 lowpriorityscore=0
 phishscore=0 priorityscore=1501 clxscore=1015 mlxscore=0 malwarescore=0
 bulkscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301180121
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/11/23 11:09, Thomas Huth wrote:
> On 05/01/2023 15.53, Pierre Morel wrote:
>> The modification of the CPU attributes are done through a monitor
>> commands.
> 
> s/commands/command/

thx

> 
>> It allows to move the core inside the topology tree to optimise
>> the cache usage in the case the host's hypervizor previously
> 
> s/hypervizor/hypervisor/

yes, thx

> 
>> moved the CPU.
>>
>> The same command allows to modifiy the CPU attributes modifiers
> 
> s/modifiy/modify/

thx

> 
>> like polarization entitlement and the dedicated attribute to notify
>> the guest if the host admin modified scheduling or dedication of a vCPU.
>>
>> With this knowledge the guest has the possibility to optimize the
>> usage of the vCPUs.
> 
> Hmm, who is supposed to call this QMP command in the future? Will there 
> be a new daemon monitoring the CPU changes in the host? Or will there be 
> a libvirt addition for this? ... Seems like I still miss the big picture 
> here...
> 
>   Thomas
> 

The first idea is to provide a daemon that could get the information on 
real CPU from the host sysfs and to specify the vCPU topology according 
to the real CPU.

There could be a libvirt command for this too.

The big picture is to provide the guest OS with the real topology so 
that the guest OS can make decisions on the scheduling.

I think that a daemon is perfect I can not imagine anything else than 
the alternative:

1) Do not specify anything and let things go more or less random as 
today by setting the cores in socket,book,drawer in an incremental way.

2) specifying the exact topology

So I do not see the point to let the user or even libvirt specify a 
random topology if it is specified it must be exact.

Regards,
Pierre



-- 
Pierre Morel
IBM Lab Boeblingen
