Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B8535EE19C
	for <lists+kvm@lfdr.de>; Wed, 28 Sep 2022 18:18:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233945AbiI1QSV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Sep 2022 12:18:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233784AbiI1QRs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Sep 2022 12:17:48 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 857BDE5F84
        for <kvm@vger.kernel.org>; Wed, 28 Sep 2022 09:16:50 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28SEtDM1012616;
        Wed, 28 Sep 2022 16:16:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : from : to : cc : references : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=MXrT9nG9vXfi5eXSpWydH/izVFSpHHfIbj/yEiK6g9g=;
 b=VJ0teEutuW2wFXGJOdTH+gTwbayExDWY2RWkthh99iPsg+PkyrNgzAAJpaLopxlgPpJE
 ohbIaNMzdQuXu/Q9hdyxLo1ZATcaXP++uGdl9Ftip6NglbE+UojCKDPJYjgdYg+h31+r
 lnalTmUiIg7ud7khZrOwwjxz/oU7zAs6gTDSzDgaYO3omrhmchxlJF+c8XN4+8FT7UTD
 x+V5Hja5j4lMtw2fOeNzDtojzUqGNY93GXDw+UkFQEH5K1TRz1SvvH9keGUbXYRur6Ki
 syx5hEbxVRyGNS2dua+x8h2XiFXMOiJ8RRkFns4YX+ugZ0G2vsKB18TyxwGQrTh1oEJt TA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jvjd17ss2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Sep 2022 16:16:36 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 28SFbfKY022497;
        Wed, 28 Sep 2022 16:16:35 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jvjd17sr6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Sep 2022 16:16:35 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 28SG5xA2011277;
        Wed, 28 Sep 2022 16:16:33 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3jssh9dfju-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Sep 2022 16:16:32 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 28SGGTVO62980456
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Sep 2022 16:16:29 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A9C094C04A;
        Wed, 28 Sep 2022 16:16:29 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C01304C044;
        Wed, 28 Sep 2022 16:16:28 +0000 (GMT)
Received: from [9.171.31.212] (unknown [9.171.31.212])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 28 Sep 2022 16:16:28 +0000 (GMT)
Message-ID: <dff1744f-3242-af11-6b4b-02037a7e2af5@linux.ibm.com>
Date:   Wed, 28 Sep 2022 18:16:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH v9 01/10] s390x/cpus: Make absence of multithreading clear
Content-Language: en-US
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>,
        Nico Boehr <nrb@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, frankja@linux.ibm.com
References: <20220902075531.188916-1-pmorel@linux.ibm.com>
 <20220902075531.188916-2-pmorel@linux.ibm.com>
 <166237756810.5995.16085197397341513582@t14-nrb>
 <c394823e-edd5-a722-486f-438e5fba2c9d@linux.ibm.com>
 <0d3fd34e-d060-c72e-ee19-e9054e06832a@kaod.org>
 <724d962a-c11b-c18d-f67f-9010eb2f32e2@linux.ibm.com>
In-Reply-To: <724d962a-c11b-c18d-f67f-9010eb2f32e2@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 4-6tfmag6vU1u1tC2LWVt8rI_vChDBbW
X-Proofpoint-GUID: 6ZDUHxeiJVHl3RA2P8zO2jktsVZt6wFe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-28_06,2022-09-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 suspectscore=0 mlxscore=0 clxscore=1015 impostorscore=0 malwarescore=0
 spamscore=0 bulkscore=0 lowpriorityscore=0 priorityscore=1501
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209280096
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

More thinking about this I will drop this patch for backward 
compatibility and in topology masks treat CPUs as being cores*threads



On 9/28/22 15:21, Pierre Morel wrote:
> 
> 
> On 9/27/22 11:44, Cédric Le Goater wrote:
>> On 9/5/22 17:10, Pierre Morel wrote:
>>>
>>>
>>> On 9/5/22 13:32, Nico Boehr wrote:
>>>> Quoting Pierre Morel (2022-09-02 09:55:22)
>>>>> S390x do not support multithreading in the guest.
>>>>> Do not let admin falsely specify multithreading on QEMU
>>>>> smp commandline.
>>>>>
>>>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>>>> ---
>>>>>   hw/s390x/s390-virtio-ccw.c | 3 +++
>>>>>   1 file changed, 3 insertions(+)
>>>>>
>>>>> diff --git a/hw/s390x/s390-virtio-ccw.c b/hw/s390x/s390-virtio-ccw.c
>>>>> index 70229b102b..b5ca154e2f 100644
>>>>> --- a/hw/s390x/s390-virtio-ccw.c
>>>>> +++ b/hw/s390x/s390-virtio-ccw.c
>>>>> @@ -86,6 +86,9 @@ static void s390_init_cpus(MachineState *machine)
>>>>>       MachineClass *mc = MACHINE_GET_CLASS(machine);
>>>>>       int i;
>>>>> +    /* Explicitely do not support threads */
>>>>            ^
>>>>            Explicitly
>>>>
>>>>> +    assert(machine->smp.threads == 1);
>>>>
>>>> It might be nicer to give a better error message to the user.
>>>> What do you think about something like (broken whitespace ahead):
>>>>
>>>>      if (machine->smp.threads != 1) {if (machine->smp.threads != 1) {
>>>>          error_setg(&error_fatal, "More than one thread specified, 
>>>> but multithreading unsupported");
>>>>          return;
>>>>      }
>>>>
>>>
>>>
>>> OK, I think I wanted to do this and I changed my mind, obviously, I 
>>> do not recall why.
>>> I will do almost the same but after a look at error.h I will use 
>>> error_report()/exit() instead of error_setg()/return as in:
>>>
>>>
>>> +    /* Explicitly do not support threads */
>>> +    if (machine->smp.threads != 1) {
>>> +        error_report("More than one thread specified, but 
>>> multithreading unsupported");
>>> +        exit(1);
>>> +    }
>>
>>
>> or add an 'Error **errp' parameter to s390_init_cpus() and use 
>> error_setg()
>> as initially proposed. s390x_new_cpu() would benefit from it also.
>>
> OK, Thanks,
> 
> Pierre
> 

-- 
Pierre Morel
IBM Lab Boeblingen
