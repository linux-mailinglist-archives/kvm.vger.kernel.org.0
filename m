Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B2456337E4
	for <lists+kvm@lfdr.de>; Tue, 22 Nov 2022 10:06:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233071AbiKVJGC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Nov 2022 04:06:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232986AbiKVJF7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Nov 2022 04:05:59 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B582183AD
        for <kvm@vger.kernel.org>; Tue, 22 Nov 2022 01:05:58 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AM7i6Eu006710;
        Tue, 22 Nov 2022 09:05:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=C4eL9rgGQ+4MaasqwLZJb78ImVu5/wpJSokw1aQUME8=;
 b=YWWmz0FZe5p+RYc9pwC1VOI12//pB4MUXPXevtEDgycdKqaW7QWTt6e7wc3SFbz5jpwr
 wC6RwHECjikwDIcbBBeNkZuoYMk1Zjr219M2x8chtanAKdq9mlp1OY9yX6klDYT7hd7/
 AGwz3lKTRmzvDiYW4lhhPzISNsTC1xy9Z2F9Q6/u12xDXz+m5zNA24FRXnSsDJCFgVri
 by2/FcDDAqGgXEnWMKHMwRZ9hvgkuRL3P24W1B/T5ImWZKKOo9e+stCAVPx77p5gFIBo
 JM1elow2heu0OheLXvIdYlnsigObMGJcjYHN/SzpKVGq6G54FjqPafSDqzKhmoCvTg9J uQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3m0qfgdn1p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Nov 2022 09:05:49 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2AM8wCAu002370;
        Tue, 22 Nov 2022 09:05:49 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3m0qfgdn0u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Nov 2022 09:05:49 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2AM8oKfZ005650;
        Tue, 22 Nov 2022 09:05:47 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06fra.de.ibm.com with ESMTP id 3kxpdj2v93-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Nov 2022 09:05:47 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2AM95iTS7995906
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Nov 2022 09:05:44 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 270B342047;
        Tue, 22 Nov 2022 09:05:44 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EC5CC42042;
        Tue, 22 Nov 2022 09:05:42 +0000 (GMT)
Received: from [9.171.75.192] (unknown [9.171.75.192])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 22 Nov 2022 09:05:42 +0000 (GMT)
Message-ID: <d82db5c8-171b-1570-e000-25e381843e8d@linux.ibm.com>
Date:   Tue, 22 Nov 2022 10:05:42 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v11 04/11] s390x/cpu topology: reporting the CPU topology
 to the guest
To:     =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>,
        qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, scgl@linux.ibm.com,
        frankja@linux.ibm.com, berrange@redhat.com
References: <20221103170150.20789-1-pmorel@linux.ibm.com>
 <20221103170150.20789-5-pmorel@linux.ibm.com>
 <1888d31f-227f-7edf-4cc8-dd88a9b19435@kaod.org>
 <34caa4c4-0b94-1729-fe88-77d9b4240f04@linux.ibm.com>
 <8b29a416-8190-243f-c414-e9e77efae918@kaod.org>
Content-Language: en-US
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <8b29a416-8190-243f-c414-e9e77efae918@kaod.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: pm98OJxTIi2f7qbfVo6ht-7_27HkeRd1
X-Proofpoint-GUID: 46DkD6enMDMmFhyI0XDmWWkfn9WGonGU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-22_04,2022-11-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 priorityscore=1501 lowpriorityscore=0 mlxlogscore=999 adultscore=0
 malwarescore=0 spamscore=0 clxscore=1015 impostorscore=0 suspectscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211220067
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11/21/22 15:13, Cédric Le Goater wrote:
>>>> +static char *s390_top_set_level2(S390Topology *topo, char *p)
>>>> +{
>>>> +    int i, origin;
>>>> +
>>>> +    for (i = 0; i < topo->nr_sockets; i++) {
>>>> +        if (!topo->socket[i].active_count) {
>>>> +            continue;
>>>> +        }
>>>> +        p = fill_container(p, 1, i);
>>>> +        for (origin = 0; origin < S390_TOPOLOGY_MAX_ORIGIN; 
>>>> origin++) {
>>>> +            uint64_t mask = 0L;
>>>> +
>>>> +            mask = topo->socket[i].mask[origin];
>>>> +            if (mask) {
>>>> +                p = fill_tle_cpu(p, mask, origin);
>>>> +            }
>>>> +        }
>>>> +    }
>>>> +    return p;
>>>> +}
>>>
>>> Why is it not possible to compute this topo information at "runtime",
>>> when stsi is called, without maintaining state in an extra S390Topology
>>> object ? Couldn't we loop on the CPU list to gather the topology bits
>>> for the same result ?
>>>
>>> It would greatly simplify the feature.
>>>
>>> C.
>>>
>>
>> The vCPU are not stored in order of creation in the CPU list and not 
>> in a topology order.
>> To be able to build the SYSIB we need an intermediate structure to 
>> reorder the CPUs per container.
>>
>> We can do this re-ordering during the STSI interception but the idea 
>> was to keep this instruction as fast as possible.> The second reason 
>> is to have a structure ready for the QEMU migration when we introduce 
>> vCPU migration from a socket to another socket, having then a 
>> different internal representation of the topology.
>>
>>
>> However, if as discussed yesterday we use a new cpu flag we would not 
>> need any special migration structure in the current series.
>>
>> So it only stays the first reason to do the re-ordering preparation 
>> during the plugging of a vCPU, to optimize the STSI instruction.
>>
>> If we think the optimization is not worth it or do not bring enough to 
>> be consider, we can do everything during the STSI interception.
> 
> Is it called on a hot code path ? AFAICT, it is only called once
> per cpu when started. insert_stsi_3_2_2 is also a guest exit andit 
> queries the machine definition in a very similar way.


It is not fully exact, stsi(15) is called at several moments, not only 
on CPU creation, but each time the core calls rebuild_sched_domains() 
that is for s390 on:
- change in the host topology
- changes in CPUSET: for allowed CPU or load balancing

Regards,
Pierre

> 
> Thanks,
> 
> C.
> 

-- 
Pierre Morel
IBM Lab Boeblingen
